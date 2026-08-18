---
title: "Les différentes façons d’utiliser Claude"
description: "Découvrir les 6 surfaces d'utilisation de Claude : autocomplétion, chat, édition inline, CLI local, IDE agentique et agents Cloud."
date: 2026-08-15
draft: true
tags:
  - claude
  - clients
  - IDE
  - CLI
categories:
  - "Chapitre 4"
cours: Claude Code
chapitre: 04-installation-presentation-clients
leçon: 01-differentes-facons-utiliser-claude
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Autocomplétion (Ghost text) | Saisie prédictive locale accélérant la frappe sans vision globale. |
| Chat dans l'éditeur | Échange interactif sur du code sélectionné pour explication ou refactoring. |
| Édition assistée (Inline) | Génération de diffs visuels (avant/après) applicables en un clic dans le fichier. |
| Agent de code local (CLI) | Programme autonome (Claude Code) poursuivant un objectif global via le terminal. |
| IDE agentique | Éditeur centré agent (Cursor, Antigravity) intégrant IA, terminal et fichiers. |
| Agent Cloud | Exécution conteneurisée isolée créant directement des Pull Requests. |

## Synthèse
L'intégration de Claude dans le workflow développeur offre plusieurs niveaux d'autonomie : de la simple suggestion de frappe (autocomplétion) au pilotage de tâches complexes multi-fichiers (agents locaux CLI ou cloud). Le choix de l'interface dépend de l'objectif, du niveau de contrôle humain requis et du besoin d'isolation de l'environnement d'exécution.

## Glossaire
- **Autocomplétion (Ghost Text)** : Saisie prédictive affichant des suggestions de lignes en grisé.
- **Diff Inline** : Visualisation intégrée comparant les modifications proposées ligne à ligne (vert/rouge).
- **IDE Agentique** : Environnement de développement conçu nativement autour du travail d'agents IA.
- **Sandbox Cloud** : Environnement virtuel isolé protégeant la machine locale des effets de bord.

## Questions d'auto-évaluation
1. Quelle est la différence de posture entre utiliser le chat d'un IDE et confier une tâche à un agent CLI comme Claude Code ?
2. Pourquoi le diff inline est-il le mode privilégié pour les refactorisations ciblées sous contrôle humain ?
3. Quel avantage majeur l'exécution d'un agent en Sandbox Cloud apporte-t-elle sur le plan de la sécurité système ?
4. Dans quel cas l'autocomplétion simple reste-t-elle l'outil le plus rapide et le moins intrusif ?

# Les différentes façons d’utiliser Claude

## Objectif de la leçon
Cartographier les 6 niveaux d'intégration de l'IA dans le développement et choisir l'interface optimale (Chat, Inline, CLI, Cloud).

---

# 1. Échelle de Maturation & Autonomie des Outils IA

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      L'ÉCHELLE DU DÉVELOPPEMENT ASSISTÉ                 │
│                                                                         │
│  [1. Autocomplétion]  ──> Suggestion ligne à ligne en grisé            │
│  [2. Chat IDE]        ──> Question / réponse sur code sélectionné       │
│  [3. Inline Diff]     ──> Modification ciblée sous contrôle visuel      │
│  [4. Agent CLI Local] ──> Boucle autonome multi-fichiers + terminal     │
│  [5. IDE Agentique]   ──> Interface pensée "Agent-First"                │
│  [6. Agent Cloud]     ──> Exécution isolée en Sandbox VM (Pull Request) │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Assistant vs Agent

```text
ASSISTANT (Chat / Inline)  ──> Répond à des questions précises, propose du code.
                                 L'humain doit copier, coller et tester.

AGENT (CLI / Cloud)        ──> Reçoit un objectif global (ex: "Fix la faille").
                                 Il lit, édite, lance les tests et s'auto-corrige.
```

---

# Résumé & Schéma global

```text
                   SURFACES D'UTILISATION DE CLAUDE
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼                          ▼                          ▼
 Outils Locaux (IDE)        Agent CLI (Claude Code)    Environnements Cloud
(Ghost text, Chat, Diff)   (Terminal & Outils locaux) (Sandbox & GitHub PR)
```

# Tableau récapitulatif des surfaces

| Interface | Degré d'autonomie | Cas d'usage idéal |
|---|---|---|
| **Autocomplétion** | Très faible | Frappe rapide, structures répétitives. |
| **Chat / Inline** | Faible à moyen | Explication de bug, refactoring court. |
| **Claude Code CLI** | Élevé | Refactoring lourd, création de features, tests. |
| **Agent Cloud** | Maximum | Tâches de fond isolées sans polluer la machine locale. |

# Les 5 points les plus importants

1. **L'autocomplétion accélère la frappe** mais ne vérifie pas la logique du projet.
2. **L'édition Inline offre un contrôle visuel direct** (diff) sur chaque modification.
3. **Claude Code CLI s'exécute directement dans le terminal** pour lire, éditer et tester.
4. **L'agent poursuit un objectif global** de manière autonome en s'auto-corrigeant.
5. **Les agents Cloud isolent l'exécution** dans un bac à sable conteneurisé.

---

# Carte mentale

```text
Façons d'utiliser Claude
│
├── Assistances Ponctuelles
│   ├── Autocomplétion (Ghost text)
│   ├── Chat dans l'IDE
│   └── Édition assistée (Diff inline)
│
├── Agents Autonomes
│   ├── Agent Local CLI (Claude Code)
│   ├── IDE Agentique (Cursor / Antigravity)
│   └── Agent Cloud (Sandbox / GitHub)
│
└── Criteres de Choix
    ├── Niveau de contrôle humain
    └── Besoin d'isolation système
```

---

# Mini fiche de révision

```text
Ghost Text  → Autocomplétion de frappe en grisé
Inline Diff → Affichage visuel avant/après modification
Claude Code → Agent CLI autonome agissant sur le projet et terminal
Agent Cloud → Exécution distante en Sandbox sécurisée
```

> **Phrase à retenir** : Passez du statut d'utilisateur de Chatbot à celui de pilote d'agent en confiant des objectifs globaux à Claude Code dans votre terminal.
