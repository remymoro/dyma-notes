---
title: "Installation et présentation de l’extension VS Code"
description: "Installer et maîtriser l'extension Claude Code dans VS Code : @-mentions, raccourcis Alt+K, diffs interactifs et checkpoints."
date: 2026-08-15
draft: true
tags:
  - claude-code
  - vscode
  - installation
categories:
  - "Chapitre 4"
cours: Claude Code
chapitre: 04-installation-presentation-clients
leçon: 04-installation-presentation-extension-vscode
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Quels sont les prérequis ? | VS Code **1.98.0+** minimum et un compte éligible (Pro/Team/Enterprise/Console). |
| Comment cibler du contexte ? | Utiliser les **@-mentions** (ex: `@src/app.ts#5-20`) ou le raccourci `Alt+K` / `Option+K`. |
| Qu'est-ce qu'un Checkpoint ? | Point de restauration temporaire permettant d'annuler les modifications faites par l'agent sans toucher à Git. |
| Comment ajuster une modification ? | Édition directe au sein du panneau de diff interactif avant de cliquer sur valider. |
| Où sont partagés les paramètres ? | Dans `~/.claude/settings.json`, fichier commun qui unifie l'extension VS Code et le CLI autonome. |

## Synthèse
L'extension VS Code pour Claude Code offre un environnement de travail graphique directement intégré à l'éditeur. Elle optimise l'utilisation du contexte grâce aux @-mentions ciblées et aux raccourcis de sélection (`Alt+K`). Ses fonctionnalités de diff interactif et de checkpoints sécurisent la modification de code sans polluer l'historique Git.

## Glossaire
- **Alt+K / Option+K** : Raccourci pour injecter le bloc de code sélectionné en tant que contexte dans le prompt.
- **Checkpoint** : Point de restauration local généré à chaque passe d'édition pour pouvoir faire machine arrière.
- **@-mention** : Syntaxe de ciblage rapide (`@fichier.ts#L-L`) envoyant au modèle un extrait de fichier précis.
- **Diff Interactif** : Panneau de relecture permettant d'éditer ou de valider les propositions de l'agent.

## Questions d'auto-évaluation
1. Quel est l'intérêt d'utiliser une @-mention ciblée comme `@app.ts#10-30` plutôt que d'envoyer tout le fichier ?
2. Comment les checkpoints de l'extension VS Code diffèrent-ils des commits Git traditionnels ?
3. Le fichier de configuration `~/.claude/settings.json` est-il partagé entre l'extension VS Code et le CLI autonome ?
4. Quel raccourci permet de placer du code sélectionné dans le panneau Claude Code sans copier-coller ?

# Installation et présentation de l’extension VS Code

**Durée : 7 minutes**

## Objectif de la leçon
Installer l'extension Claude Code pour VS Code, maîtriser le ciblage de contexte par @-mentions et gérer les modifications par diffs interactifs.

---

# 1. Sélection Contextuelle Précise (@-mentions & Alt+K)

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    OPTIMISATION DU CONTEXTE DANS VS CODE                │
│                                                                         │
│  [Sélection + Alt+K] ──> Injecte immédiatement le bloc dans le prompt   │
│  [@-mention]         ──> `@src/server.ts#15-40` (Lit seulement l'extrait)│
│                                                                         │
│  └─► Réduit le volume de tokens et prévient la dilution d'attention.   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Workflow de Modification & Checkpoints

```text
  Prompt Utilisateur ──> [Génération du Code] ──> [Diff Interactif]
                                                       │
  [Annulation Checkpoint] <── [Rejet] <── [Édition & Validation] ──> [Appliqué]
```

---

# Résumé & Schéma global

```text
                     EXTENSION CLAUDE CODE POUR VS CODE
                                     │
       ┌─────────────────────────────┼─────────────────────────────┐
       ▼                             ▼                             ▼
 Sélection Précise             Diffs Interactifs              Checkpoints
(Alt+K & @-mentions)         (Édition avant validation)   (Annulation immédiate)
```

# Tableau récapitulatif des raccourcis

| Raccourci / Syntaxe | Action |
|---|---|
| **`Alt+K` / `Option+K`** | Envoie le code sélectionné dans le panneau Claude Code. |
| **`@chemin/fichier.ts`** | Attache la totalité d'un fichier au contexte. |
| **`@fichier.ts#10-50`** | Attache uniquement les lignes 10 à 50 au contexte. |

# Les 5 points les plus importants

1. **L'extension VS Code exige la version 1.98.0+** et embarque sa propre exécution CLI.
2. **Le raccourci `Alt+K` (ou `Option+K`)** envoie la sélection courante en référence au prompt.
3. **Les @-mentions avec plages de lignes** économisent les tokens et augmentent la précision.
4. **Le diff interactif permet de retoucher le code** proposé avant de le valider définitivement.
5. **Les checkpoints permettent de faire machine arrière** sur les modifications sans impacter Git.

---

# Carte mentale

```text
Extension VS Code Claude Code
│
├── Ciblage de Contexte
│   ├── Alt+K / Option+K (Sélection rapide)
│   └── @-mentions avec lignes (@fichier.ts#10-30)
│
├── Relecture & Validation
│   ├── Diffs interactifs éditables
│   └── Checkpoints d'annulation
│
└── Configuration
    └── Partagée via ~/.claude/settings.json
```

---

# Mini fiche de révision

```text
Alt+K            → Injecter le code sélectionné dans le chat
@fichier.ts#5-20 → Cibler les lignes 5 à 20 pour économiser les tokens
Checkpoint       → Annuler l'édition de l'agent sans impacter Git
settings.json    → Configuration partagée entre CLI et VS Code
```

> **Phrase à retenir** : Utilisez les @-mentions ciblées avec plages de lignes pour garder votre contexte pur et maîtriser la facturation des tokens.
