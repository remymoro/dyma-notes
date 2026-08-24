---
title: "Liste des configurations — partie 1"
description: "Découvrir une première partie des réglages disponibles dans Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - configuration
  - commandes
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 02-liste-configurations-partie-1
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Nature d'une configuration ?** | Modifie le cadre de la session (affichage, contexte, modèle, permissions, orchestration), contrairement à un prompt qui agit sur une tâche précise. |
| **Comment modifier les paramètres ?** | La commande `/config` (ou son alias `/settings`) est le point d'entrée interactif principal. Évite d'éditer manuellement les JSON sans connaître les clés. |
| **Hiérarchie des paramètres ?** | De la priorité la plus forte à la plus faible : 1. Managed settings, 2. CLI, 3. `settings.local.json`, 4. `settings.json` (projet), 5. `~/.claude/settings.json` (utilisateur). |
| **autoCompactEnabled ?** | Compresse l'historique quand la limite approche pour continuer la session sans saturer le contexte. Protège la continuité mais transforme l'information. |
| **fileCheckpointingEnabled ?** | Crée des snapshots automatiques des fichiers avant modification, ce qui permet l'utilisation de la commande `/rewind` pour annuler. |
| **Toujours persistant ?** | Non. Par exemple, l'effort `ultracode` ou la bascule de modèle "flagged" sont des réglages de session ou d'interface, pas des clés stables à écrire dans `settings.json`. |
| **permissions.defaultMode ?** | Définit l'autonomie initiale (`default`, `plan`, `auto`, `acceptEdits`, `dontAsk`, `bypassPermissions`). Structurant pour la sécurité du projet. |

## Synthèse
La configuration de Claude Code définit le cadre d'exécution des sessions en modifiant l'interface, l'autonomie, l'orchestration ou le contexte. Les réglages s'appliquent selon une hiérarchie stricte (organisation > CLI > local > projet > global) et se gèrent principalement via la commande interactive `/config`. Une bonne configuration doit être réfléchie pour équilibrer confort, sécurité et observabilité selon les besoins spécifiques de chaque projet.

## Glossaire
- **`/config`** : Commande interactive principale pour explorer, activer ou désactiver les réglages persistants ou de session.
- **Auto-compact (`autoCompactEnabled`)** : Mécanisme qui résume et compresse l'historique pour éviter la saturation du contexte lors de longues sessions.
- **Rewind code (`fileCheckpointingEnabled`)** : Option permettant de sauvegarder l'état d'un fichier avant modification pour pouvoir revenir en arrière.
- **Dynamic Workflows** : Fonctionnalité d'orchestration permettant l'usage de sous-agents pour les tâches vastes et complexes.

## Questions d'auto-évaluation
1. Quelle est la principale différence entre un prompt et une configuration ?
2. Quel fichier a la priorité : `.claude/settings.local.json` ou `~/.claude/settings.json` ?
3. À quoi sert le réglage `fileCheckpointingEnabled` et quelle commande lui est associée ?
4. Le paramètre `/effort ultracode` peut-il être sauvegardé comme clé ordinaire dans le `settings.json` ?

# Liste des configurations — partie 1

**Durée : 17 minutes**

## Objectif de la leçon
Comprendre l'impact réel de chaque réglage (affichage, contexte, permissions, orchestration) au-delà de la simple interface. Savoir comment modifier la configuration efficacement via `/config` et maîtriser la hiérarchie des fichiers pour adapter le niveau d'autonomie et de sécurité de Claude Code à son dépôt.

---

# 1. Hiérarchie et Gestion des Configurations

```text
 Hiérarchie des réglages
 ┌────────────────────────────────────────────────────────┐
 │ 1. Managed settings (Politique d'Organisation)         │ Plus fort
 │ 2. Arguments CLI (--pr, etc.)                          │
 │ 3. .claude/settings.local.json                         │
 │ 4. .claude/settings.json (Projet)                      │
 │ 5. ~/.claude/settings.json (Global / Utilisateur)      │ Plus faible
 └────────────────────────────────────────────────────────┘
```
**Important** : C'est pour cette raison qu'un réglage dans votre fichier utilisateur peut sembler ignoré : une couche supérieure l'écrase. Le réflexe doit être de consulter `/config`.

---

# 2. Typologie des réglages principaux

* **Contexte & Historique** : `autoCompactEnabled` (compression du contexte), `awaySummaryEnabled` (récap d'absence), `fileCheckpointingEnabled` (instantanés pour rewind).
* **Raisonnement** : `alwaysThinkingEnabled` (activer le mode thinking), `showThinkingSummaries` (affichage visuel du thinking).
* **Interface & Bruit** : `spinnerTipsEnabled` (astuces), `verbose` (logs détaillés), `prefersReducedMotion` (animations réduites).
* **Orchestration** : `disableWorkflows` (bloque les agents dynamiques), `workflowKeywordTriggerEnabled` (active via le mot-clé *ultracode*).
* **Permissions & Environnement** : `permissions.defaultMode` (niveau d'autonomie par défaut), `worktree.baseRef` (base de travail *fresh* vs *head*).

---

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `/config` | Ouvre l'interface de configuration interactive de Claude Code. |
| `/config clé=valeur` | Forme directe pour modifier un paramètre sans passer par le menu. |
| `/settings` | Alias de `/config`. |
| `/recap` | Force l'affichage d'un résumé manuel de la session. |

# Les 5 points les plus importants

1. Une configuration modifie le cadre général d'exécution de l'agent, tandis qu'un prompt est spécifique à une tâche.
2. Tous les réglages affichés dans `/config` ne sont pas forcément persistants dans le fichier `settings.json` (ex: `ultracode`).
3. L'Auto-compact (`autoCompactEnabled`) est vital pour les sessions longues mais altère l'information brute passée à Claude.
4. L'observabilité (mode `verbose`) est utile pour le diagnostic, mais ajoute du bruit visuel par rapport à une sortie concise en production.
5. Le mode de permission (`permissions.defaultMode`) définit l'autonomie initiale et constitue le réglage de sécurité le plus structurant.

---

# Carte mentale

```text
Configuration de Claude Code
├── Gestion & Principes
│   ├── Outil : /config ou /settings
│   └── Règle : Les couches hautes (Orga, CLI) écrasent les couches basses (Global, Projet)
├── Contexte & Mémoire
│   ├── autoCompactEnabled (Compression historique)
│   ├── awaySummaryEnabled (Récapitulatif)
│   └── fileCheckpointingEnabled (snapshots pour /rewind)
├── Modèle & Interface
│   ├── alwaysThinkingEnabled & showThinkingSummaries
│   └── spinnerTipsEnabled, verbose, terminalProgressBarEnabled
├── Workflows
│   ├── disableWorkflows (On/Off global)
│   └── workflowKeywordTriggerEnabled (Déclencheur via "ultracode")
└── Environnement & Sécurité
    ├── permissions.defaultMode (default, plan, auto, acceptEdits...)
    └── worktree.baseRef (fresh = origin, head = local)
```

---

# Mini fiche de révision

```text
Config = Modifier l'environnement (pas la tâche).
Toujours vérifier via `/config`.
Catégories d'impact : Interface (bruit), Contexte (mémoire), Autonomie (sécurité), Orchestration (sous-agents).
Hiérarchie (fort -> faible) : Orga > CLI > Local > Projet > Utilisateur.
```

> **Phrase à retenir** : Une bonne configuration ne consiste pas à tout activer, mais à rendre le comportement de Claude Code prévisible, lisible et adapté au risque du projet.
