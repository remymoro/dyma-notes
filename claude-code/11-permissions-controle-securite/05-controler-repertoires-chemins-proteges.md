---
title: "Contrôler les répertoires et les chemins protégés"
description: "Comprendre comment gérer la surface de travail, l'accès multi-dossiers et les fichiers sensibles."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - securite
  - repertoires
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 05-controler-repertoires-chemins-proteges
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre `/cd` et `/add-dir` ?** | `/cd` relocalise complètement la session (et charge le `.claude/` cible). `/add-dir` donne simplement accès aux fichiers d'un autre dossier sans importer sa politique de configuration. |
| **Comment rendre l'ajout de dossier permanent pour l'équipe ?** | En utilisant `permissions.additionalDirectories` dans le fichier `.claude/settings.json`. |
| **Qu'est-ce qu'un chemin protégé ?** | C'est un dossier (ex: `.git`, `.vscode`, `.claude`) ou un fichier (ex: `.envrc`, `.gitconfig`) dont l'écriture modifie le comportement structurel du dépôt. |
| **Peut-on bypasser la protection d'un chemin protégé avec une règle `allow` ?** | Non. L'écriture dans un chemin protégé demandera toujours validation (sauf en mode `bypassPermissions` ou si approuvée par classificateur en `auto`). Une règle `Edit(.claude/**)` dans `allow` ne suffit pas. |
| **Pourquoi bloquer en lecture un fichier `.env` est crucial ?** | Parce qu'une fuite n'implique pas de le modifier. Le simple fait que l'agent le lise l'injecte dans le contexte, qui est envoyé à l'API. |
| **Que gère la règle `Cd` ?** | Elle gère uniquement les destinations où l'utilisateur (humain) a le droit de faire la commande `/cd` dans la CLI. |

## Synthèse
La gestion de l'espace de travail dans Claude Code repose sur un principe de proportionnalité : ne donnez à l'agent que les accès strictement nécessaires à sa tâche. Dans un monorepo, naviguez (avec `/cd`) vers le bon package, puis ajoutez si besoin un répertoire supplémentaire via `/add-dir` (ou `additionalDirectories` pour la persistance). Attention, l'accès aux fichiers d'un dossier additionnel n'importe pas sa configuration (pas de `CLAUDE.md` chargé). De plus, Claude Code intègre une sécurité structurelle : les "chemins protégés" (`.git`, `.claude`, `.vscode`, `.npmrc`...) ne sont jamais modifiables automatiquement. Enfin, avant d'ajouter l'accès à un dossier externe, assurez-vous de configurer des règles `Read` (`deny`) robustes pour empêcher l'agent d'y lire des secrets ou des clés d'environnement (`.env`).

## Glossaire
- **`/cd`** : Relocalise la racine du projet (change le contexte et les settings).
- **`/add-dir`** : Élargit la surface de lecture/écriture des fichiers pour une session, sans changer la racine.
- **`additionalDirectories`** : Option de `settings.json` pour configurer des `/add-dir` persistants.
- **Chemins protégés** : Liste codée en dur de fichiers et dossiers structurels (`.git`, `.vscode`, configs shell) qui ne peuvent jamais être édités sans validation explicite (hors mode bypass).
- **Règle `Cd(path)`** : Liste blanche ou noire limitant vers où l'humain peut utiliser la commande `/cd`.

## Questions d'auto-évaluation
1. Si vous utilisez `additionalDirectories` pour pointer vers `../shared`, le `CLAUDE.md` situé dans `shared` sera-t-il pris en compte pour la session ?
2. Une règle `allow` peut-elle pré-approuver l'écriture dans le fichier `.gitconfig` ?
3. Est-il recommandé de lancer Claude Code à la racine d'un énorme monorepo pour simplifier l'accès ?
4. La commande `cd` (via Bash) exécutée par l'agent déplace-t-elle la session ?

# Contrôler les répertoires et les chemins protégés

**Durée : 15 minutes**

## Objectif de la leçon
Comprendre comment manipuler finement l'espace de travail (monorepo, dossiers frères) sans créer de failles béantes, et assimiler le concept des chemins protégés natifs (ceux qui refusent de s'auto-approuver).

---

# 1. Naviguer vs Ajouter (Les nuances de l'espace de travail)

- **La commande `/cd`** déplace le "cerveau" de la session. La session charge le `CLAUDE.md` et les `settings.json` du nouveau dossier.
- **La commande `/add-dir`** ajoute un simple "bras". La session garde son cerveau actuel, mais gagne la capacité de lire et écrire des fichiers ailleurs.

Pour rendre un `/add-dir` permanent, on utilise le tableau `permissions.additionalDirectories` dans les settings.

> [!WARNING]
> **Le piège du Monorepo**
> Ne démarrez pas à la racine d'un monorepo par facilité. Placez-vous dans le bon package avec `/cd`, puis donnez l'accès uniquement aux dépendances strictes via `additionalDirectories`.

---

# 2. Les chemins protégés : La sécurité native

Même si vous êtes en mode `acceptEdits`, Claude Code ne modifiera **jamais** automatiquement certains fichiers critiques.

- **Répertoires protégés :** `.git`, `.vscode`, `.claude` (sauf `.claude/worktrees`), `.husky`, `.idea`...
- **Fichiers protégés :** `.gitconfig`, `.envrc`, `.npmrc`, `.devcontainer.json`, etc.

**Une règle `allow` ne préapprouve pas ces chemins.**
Mettre `"Edit(.claude/**)"` dans `allow` ne sert à rien : la protection native s'évalue avant. Si vous voulez modifiez ces fichiers, ce sera validé à la main (avec la petite case "Yes, and allow Claude to edit its own settings for this session").

---

# 3. La protection des secrets à la lecture

La fuite d'un secret n'est pas un problème d'écriture, c'est un problème de **lecture**. Si l'agent lit un `.env`, le jeton est chargé dans le contexte de la session, qui est envoyé sur le réseau à l'API.

C'est pourquoi il est crucial, surtout quand on ajoute des répertoires externes (`../shared`), de vérifier et bloquer les `Read` sur les fichiers `.env` et les clés `~/.ssh`.

---

# Cartes mentales

```text
                 MÉCANIQUES DE L'ESPACE
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
         /cd           /add-dir        Règles Cd
           │               │               │
     Change le        Ajoute un       Restreint où
      cerveau           bras           l'humain
   (settings, md)  (lecture/édition)    peut aller


                 CHEMINS PROTÉGÉS NATIVEMENT
                           │
         Éditions toujours en validation manuelle !
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
       Système          Éditeurs       Configuration
    (.git, .husky) (.vscode, .idea) (.claude, .npmrc)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice d'actions
- Lancer Claude Code                 → Dossier de lancement (Racine)
- Changer définitivement de contexte → /cd (ou règle Cd)
- Ajouter l'accès à un autre package → /add-dir (ou additionalDirectories)
- Protéger les secrets d'un dossier  → Règles deny sur Read(.env)
```

> **La phrase centrale de la leçon :**
> Ajouter un répertoire est une extension de confiance, pas seulement une commodité de navigation : cela élargit la surface d'attaque, d'où l'importance des chemins protégés natifs.
