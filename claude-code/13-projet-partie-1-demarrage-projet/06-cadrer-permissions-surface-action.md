---
title: "Cadrer les permissions et la surface d'action"
description: "Comment configurer les permissions (.claude/settings.json) pour sécuriser le projet tout en fluidifiant le workflow de Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - permissions
  - securite
  - settings
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 06-cadrer-permissions-surface-action
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi le fichier `CLAUDE.md` ne suffit-il pas à sécuriser le projet ?** | Une consigne dans `CLAUDE.md` (ex: "Ne lis pas les fichiers .env") donne le contexte au LLM, mais ne constitue pas une barrière technique. L'agent pourrait s'en affranchir. Pour un blocage réel, il faut une politique de permissions. |
| **Pourquoi demander à l'agent d'explorer le projet avant de configurer les permissions ?** | Une permission utile pour un projet Node (`pnpm build`) ne l'est pas pour un projet Python. L'agent doit faire l'inventaire des scripts et du socle existant pour proposer un fichier `.claude/settings.json` taillé sur mesure. |
| **Quel est l'ordre d'évaluation des permissions par Claude Code ?** | **1. Deny ➔ 2. Ask ➔ 3. Allow.**<br>Si une règle `deny` matche, l'action est bloquée immédiatement, même si une règle `ask` ou `allow` plus large correspond. (Ex: `git push --force` en deny bloque, même si `git push *` est en ask). |
| **Pourquoi cibler les environnements Bash ET PowerShell ?** | Pour garantir que les règles (ex: interdiction d'utiliser `curl`) s'appliquent de manière symétrique aux contributeurs sous Linux/macOS (Bash) et à ceux sous Windows (PowerShell, Git Bash). |
| **Pourquoi mettre `pnpm add` ou `pnpm dlx` dans le groupe `ask` ?** | Ce sont des mutations de dépendances ou des exécutions de paquets distants. Elles modifient le code ou introduisent de l'exécution arbitraire externe. Il faut toujours exiger la validation humaine avant de les lancer. |
| **Qu'est-ce qui va dans la section `deny` ?** | Tout ce qui est destructeur ou indiscret : les requêtes réseau (`curl`, `wget`), les suppressions sauvages par shell (`rm *`), la lecture des fichiers de secrets (`Read(**/.env)`), et les forçages Git (`git push --force`). |

## Synthèse
Le socle technique est prêt, mais il faut maintenant configurer "les rails" sur lesquels l'agent va évoluer. L'objectif est d'accélérer le travail de Claude Code en lui permettant d'exécuter seul les commandes répétitives (lint, test, build), tout en posant des barrières strictes sur les actions sensibles. Ce fichier central, `.claude/settings.json`, contient trois niveaux de permissions évaluées dans un ordre strict : `deny` (bloque quoi qu'il arrive), `ask` (demande une confirmation humaine), et `allow` (autorise l'exécution silencieuse). Pour bien calibrer ces listes, on ne donne pas d'instructions génériques à l'agent : on lui demande de déployer un sous-agent explorateur qui va analyser le `package.json` et le `design-doc.md` pour en déduire les commandes *réellement* utilisées par le projet. Les commandes de lecture (Git status, pnpm run lint) vont dans `allow`, les modifications de dépendances (`pnpm add`) vont dans `ask`, et les opérations dangereuses (`git reset --hard`, `curl`, lecture des `.env`) vont dans `deny`.

## Glossaire
- **`.claude/settings.json`** : Fichier de configuration du projet commité (partagé par l'équipe) permettant d'activer la sandbox et de définir les listes `allow`, `ask`, et `deny`.
- **`sandbox`** : Isolation système limitant les ressources accessibles par les scripts exécutés. Diffère des "permissions" qui décident *si* la commande a le droit d'être lancée ou non.
- **Règle Bash vs PowerShell** : Claude différencie les commandes selon le shell utilisé. Une règle `Bash(rm *)` n'empêchera pas `PowerShell(rm *)`. Il faut définir les deux.
- **Ordre d'évaluation (`Deny` > `Ask` > `Allow`)** : La règle la plus stricte l'emporte toujours.

## Questions d'auto-évaluation
1. L'agent propose de placer les permissions dans `.claude/settings.local.json`. Pourquoi devez-vous refuser ?
2. Quelle est la différence fondamentale de sécurité entre interdire la lecture des `.env` dans le `CLAUDE.md` ou dans la section `deny` de `settings.json` ?
3. Si j'autorise `"Bash(git push *)"` dans `ask`, mais que j'ajoute `"Bash(git push --force *)"` dans `deny`, que se passe-t-il quand l'agent tente un `git push --force` ?
4. Dans quel groupe doit-on placer la commande `pnpm test` ? Dans quel groupe doit-on placer `pnpm update` ?

# Cadrer les permissions et la surface d'action

**Durée : 20 minutes**

## Objectif de la leçon
Apprendre à générer la politique de permissions (`.claude/settings.json`) pour Claude Code, en autorisant les commandes de routine et en bloquant de façon déterministe les actions dangereuses.

---

# 1. Préparation : L'Exploration (Pas de liste magique)

Il n'y a pas de fichier de permission "universel". Avant de créer le `settings.json`, demandez à Claude Code d'explorer le dépôt (les manifestes, le design doc).

**Le Prompt de départ :**
```text
Nous avons mis en place le socle technique.
Fais d'abord un tour d'horizon du projet avec un agent d'exploration.
Le but sera ensuite de configurer les permissions pour permettre un travail fluide (mode auto) tout en bloquant les risques.
```
*L'agent va lister les commandes clés : `pnpm install`, `pnpm run build`, `vitest`, etc.*

---

# 2. Séparer Sandbox et Permissions

Le fichier généré `.claude/settings.json` doit activer la sandbox :
```json
"sandbox": {
  "enabled": true
}
```
> [!NOTE]
> La **Sandbox** limite techniquement ce qu'un script (déjà autorisé à s'exécuter) peut faire sur votre OS. 
> Les **Permissions** déterminent si l'agent a le droit de lancer cette commande en premier lieu.
> *Sur Windows natif, la sandbox n'est pas complètement prise en charge, d'où l'importance vitale des permissions.*

---

# 3. L'Ordre d'Évaluation (Deny > Ask > Allow)

C'est la règle d'or de la sécurité Claude Code. Les listes sont évaluées dans un ordre strict. Le `deny` gagne toujours.

### Le groupe `allow` (Travail courant)
Commandes répétitives, sans effets destructeurs ou avec impact limité au build local.
- Lancer les tests, le lint, le build (`pnpm run *`, `pnpm test`).
- Inspection Git pure (`git status`, `git diff`, `git log`).

### Le groupe `ask` (Surveillance)
L'agent doit demander votre aval avant de modifier l'état extérieur ou la stack.
- Gestion des packages (`pnpm add`, `pnpm remove`, `pnpm update`).
- Exécution distante ponctuelle (`pnpm dlx`).
- Push Git classique (`git push *`).

### Le groupe `deny` (Interdiction absolue)
L'agent est formellement bloqué par le système, même sans vous demander.
- Opérations destructrices : `git reset --hard`, `git push --force`.
- Transfert de réseau hors workflow : `curl`, `wget` (pour éviter des téléchargements/exfiltrations).
- Suppression sauvage : `rm *`.
- **Lecture des secrets** : `Read(.env)` et `Read(**/.env)`.

---

# 4. Le piège des environnements (Bash vs PowerShell)

Une faille classique consiste à écrire ses règles uniquement pour `Bash()`.
```json
"deny": [
  "Bash(curl *)"
]
```
Si un contributeur Windows ouvre le projet et que Claude Code utilise PowerShell, la règle n'est pas appliquée. **Il faut toujours doubler les règles** :
```json
"deny": [
  "Bash(curl *)",
  "PowerShell(curl *)",
  "PowerShell(Invoke-WebRequest *)"
]
```

---

# Cartes mentales

```text
               LA PYRAMIDE DES PERMISSIONS CLAUDE CODE
               (Évaluation de haut en bas)
                               │
               ┌───────────────┴───────────────┐
               ↓                               ↓
       1. DENY (Le Mur de briques)         Ex: "Bash(git push --force)"
          (Action bloquée direct)              "Read(.env)"
               │                               "PowerShell(curl)"
               ↓
       2. ASK (Le Péage humain)            Ex: "Bash(pnpm add *)"
          (Demande l'autorisation)             "Bash(git push *)"
               │
               ↓
       3. ALLOW (Le Tapis Roulant)         Ex: "Bash(pnpm test)"
          (Exécution silencieuse)              "Bash(git diff)"
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les étapes pour cadrer les permissions :
1. Envoyer un agent explorer le `package.json` pour comprendre les vrais besoins.
2. Écrire le `.claude/settings.json` (et non `.local.json` qui n'est pas partagé).
3. Activer la sandbox.
4. Remplir le `allow` pour fluidifier le lint/test.
5. Protéger les dépendances dans le `ask`.
6. Verrouiller les requêtes réseau, les `.env` et les push forcés dans le `deny` pour Bash ET PowerShell.
```

> **La phrase centrale de la leçon :**
> Définir des permissions ne consiste pas à tout bloquer, mais à séparer intelligemment ce qui nécessite une intuition humaine (modifier les dépendances, pousser sur le repo) de ce qui est purement mécanique (linter, tester, compiler), tout en posant un veto absolu (`deny`) sur les comportements destructeurs.
