---
title: "Situer les skills dans l’écosystème Claude Code"
description: "Comprendre le rôle des skills par rapport à CLAUDE.md, aux règles, aux hooks, aux permissions et aux outils MCP."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - architecture
  - contexte
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 01-situer-skills-ecosysteme
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Qu'est-ce qu'une Skill ?** | Ce n'est pas juste un prompt. C'est un dossier complet (contenant souvent un `SKILL.md` et des sous-dossiers `references/`, `scripts/`, `examples/`) qui encapsule un **workflow réutilisable**. Son but est d'être chargé uniquement lorsque la situation le justifie, pour économiser du contexte. |
| **Pourquoi ne pas tout mettre dans `CLAUDE.md` ?** | `CLAUDE.md` est la mémoire permanente du projet. S'il contient des workflows de 20 étapes (comme une release) qui ne servent qu'une fois par mois, il gaspille des tokens de contexte à chaque requête quotidienne de l'utilisateur. |
| **Comment Claude Code sait-il quand invoquer une Skill ?** | Grâce à la **description** de la skill. Le nom et la description de la skill sont toujours connus de l'agent. Si la description correspond à l'intention de l'utilisateur (ex: "Aide à faire de la dette technique"), Claude chargera alors le contenu complet du `SKILL.md`. |
| **Quelle est la différence entre une Skill et des Permissions/Hooks ?** | Une skill **guide** (elle dit "comment travailler"). Elle ne remplace pas une permission (qui **bloque**) ou un hook (qui s'exécute de façon **déterministe** à un moment précis). |
| **Où doit-on placer une skill propre à une équipe entière (multirepos) ?** | Dans un **Plugin** (distribué). S'il s'agit d'une skill utile seulement pour soi, c'est dans `~/.claude/skills/`. Pour un projet spécifique, c'est dans `.claude/skills/` à la racine du dépôt. |

## Synthèse
Le chapitre 14 introduit les `skills` (compétences) dans Claude Code. L'erreur la plus fréquente des débutants est de surcharger le fichier `CLAUDE.md` avec des tutoriels et des workflows conditionnels (ex: comment faire une release, comment auditer la dette). Cela coûte extrêmement cher en contexte (tokens). La solution est d'utiliser des "skills". Une skill est un dossier (ex: `.claude/skills/techdebt/`) contenant un `SKILL.md` et des ressources liées. Claude Code ne charge le contenu complet de ce dossier que si sa **description** correspond au besoin immédiat de l'utilisateur.
Il est essentiel de choisir le bon outil pour le bon besoin :
- **Invariant permanent** -> `CLAUDE.md`
- **Règle ciblée sur un dossier** -> `.claude/rules/`
- **Workflow occasionnel** -> `Skill`
- **Automatisation systématique** -> `Hook`
- **Blocage de sécurité** -> `Permissions`
- **Accès API Externe / BDD** -> `MCP`

## Glossaire
- **Skill** : Dossier structuré contenant des instructions et des ressources décrivant un workflow ponctuel réutilisable (ex: `/release`, `/techdebt`).
- **Coût de contexte** : Plus on donne d'instructions permanentes à un LLM, plus on réduit sa fenêtre d'attention et plus les requêtes coûtent cher. Les skills réduisent ce coût en chargeant les instructions à la demande (Lazy Loading).
- **Description (d'une skill)** : Élément vital. C'est un "déclencheur" qui permet à l'agent de savoir quand il est opportun d'ouvrir la skill pour en lire le contenu détaillé.

## Questions d'auto-évaluation
1. Si je veux interdire à Claude Code de lire un fichier `.env`, dois-je créer une skill ou utiliser un autre mécanisme ?
2. Vrai ou Faux : Le contenu complet d'une skill est envoyé au modèle à chaque message de la conversation.
3. Quelle est la différence de structure entre un simple prompt sauvegardé et une "Skill" dans l'écosystème Claude Code ?
4. Dans un monorepo (comme `claudoscope`), où dois-je placer une skill qui ne sert qu'au package `packages/api` ?

# Situer les skills dans l’écosystème Claude Code

**Durée : 20 minutes**

## Objectif de la leçon
Comprendre le rôle spécifique des *Skills* parmi tous les mécanismes de pilotage de Claude Code (`CLAUDE.md`, Règles, Hooks, Permissions, MCP, Agents) et savoir quand les utiliser.

---

# 1. Le problème du contexte (Pourquoi les Skills existent)

### Le piège du `CLAUDE.md` obèse
Au début d'un projet, on a tendance à tout mettre dans `CLAUDE.md`. 
Le problème : `CLAUDE.md` est la mémoire **toujours active**. Chaque instruction qu'il contient consomme des tokens à *chaque* requête, même si l'utilisateur demande juste de corriger une faute d'orthographe.

- **Ce qui DOIT rester dans `CLAUDE.md` (Invariants)** : Architecture en couches, commandes de validation, séparation des préoccupations.
- **Ce qui DOIT SORTIR de `CLAUDE.md` (Workflows)** : Procédure de release, check-list de code review, audit de dette technique.

> Les workflows récurrents (mais pas permanents) deviennent des **Skills**.

---

# 2. Anatomie et fonctionnement d'une Skill

Une skill n'est pas juste un texte. C'est un **dossier de capacité** structuré :

```text
.claude/skills/techdebt/
├── SKILL.md            (Point d'entrée, instructions d'usage)
├── references/         (Checklists longues)
├── examples/           (Modèles de rapports attendus)
└── scripts/            (Scripts utilitaires locaux)
```

### Le Lazy Loading (Chargement à la demande)
Claude Code ne connaît par défaut que le **nom** et la **description** de la skill. 
Si la description correspond à votre demande (ex: `"Analyse les changements récents pour repérer la dette"`), Claude Code "invoquera" la skill, ce qui chargera le contenu complet de `SKILL.md` dans son contexte *uniquement pour la durée de cette tâche*.

---

# 3. La matrice de décision (Quel outil choisir ?)

Claude Code est un écosystème riche. Ne créez pas une skill pour tout résoudre. Posez-vous la bonne question :

| Question | Si oui ➔ | Mécanisme |
|---|---|---|
| L'info est-elle utile dans **presque toutes** les sessions ? | ➔ | `CLAUDE.md` |
| La consigne s'applique-t-elle à **un dossier précis** (`paths`) ? | ➔ | `.claude/rules/` |
| Est-ce un **workflow de plusieurs étapes** utilisé ponctuellement ? | ➔ | **Skill** (ex: `/release`) |
| L'action doit-elle s'exécuter **automatiquement** (ex: linter après modif) ? | ➔ | `Hook` |
| L'action doit-elle être **bloquée** ou strictement approuvée ? | ➔ | `Permissions` |
| Faut-il interroger une **base de données ou API externe** ? | ➔ | Serveur `MCP` |
| Faut-il analyser un projet entier **sans polluer la session courante** ? | ➔ | `Sous-agent` |
| Faut-il **distribuer** cet ensemble d'outils à toute l'entreprise ? | ➔ | `Plugin` |

---

# 4. Portée et Emplacement (Où vivent les skills ?)

Vous pouvez définir des skills à différents niveaux selon le public cible :

- **Portée Personnelle** (`~/.claude/skills/`) : Vous suit partout, utile pour vos propres habitudes.
- **Portée Projet** (`.claude/skills/`) : Versionnée avec le code, partagée avec l'équipe du dépôt.
- **Portée Package** (`packages/api/.claude/skills/`) : Dans un monorepo, une skill peut être ciblée sur un package spécifique pour ne pas polluer les autres.
- **Portée Entreprise / Plugin** : Permet de packager des skills, des hooks et des MCP pour toute une organisation.

> [!WARNING]
> **Une skill n'est pas un système de sécurité.**
> Une skill peut écrire : `"Ne pousse pas vers le remote pendant une release"`. 
> Mais si c'est critique, vous DEVEZ ajouter la règle `deny` sur `git push` dans les **permissions**. La skill guide l'intention, la permission impose la frontière.
