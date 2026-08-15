---
title: "Les différentes façons d’utiliser Claude"
description: "Découvrir les différentes interfaces et méthodes disponibles pour utiliser Claude."
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
| Autocomplétion (Ghost text) | Rôle d'accélérateur de frappe locale. Propose la suite textuelle grisée d'une ligne ou d'une fonction, sans vision d'architecture ni validation par tests. |
| Chat dans l'éditeur | Permet de poser des questions interactives sur du code sélectionné ou de demander des explications, créant un contexte propice à la première forme de raisonnement. |
| Édition assistée (Inline) | Modification de blocs de code ciblés avec affichage d'un diff visuel de comparaison (avant/après) directement intégré dans le fichier pour relecture humaine. |
| Agent de code local (CLI) | Programme autonome en terminal (ex: Claude Code) recevant un objectif global, capable d'explorer, de modifier des fichiers et de lancer des commandes de tests. |
| IDE agentique | Environnement pensé autour de l'IA (ex: Cursor, Google Antigravity) où l'agent gère les tâches, le terminal et un navigateur intégré de manière intégrée. |
| Agent Cloud | Agent de code s'exécutant dans un bac à sable conteneurisé distant. Protège la machine physique locale de tout effet de bord destructeur ou malveillant. |
| Surfaces de Claude Code | S'utilise en terminal (CLI), via des extensions d'IDE (VS Code, JetBrains), sur l'application de bureau, le web, en contrôle à distance ou en CI/CD. |

## Synthèse
L'intégration des LLM dans le développement progresse d'une assistance de frappe locale (autocomplétion) vers une délégation d'objectifs (agents). L'assistant (chat/édition) résout des requêtes unitaires sous contrôle humain direct, tandis que l'agent (local ou cloud) pilote une boucle autonome associant modification de fichiers et exécution de commandes de test. Le choix de la surface (CLI, IDE, Cloud) dépend de la complexité de la tâche, du besoin d'isolation et du niveau de contrôle souhaité.

## Glossaire
- **Autocomplétion (Ghost text)** : Texte proposé en grisé suggérant la suite statistique directe d'une instruction en cours de saisie.
- **Bac à sable (Sandbox)** : Environnement virtuel isolé (ex: conteneur cloud) protégeant la machine locale des effets secondaires des commandes exécutées par l'agent.
- **Claude Code** : Outil d'Anthropic en ligne de commande locale agissant comme un agent de développement interactif doté d'outils de lecture/écriture et de terminal.
- **Diff** : Représentation visuelle des différences (ajouts en vert, retraits en rouge) entre deux versions d'un même fichier de code.
- **IDE Agentique** : Éditeur de code (comme Cursor) structuré nativement autour des interactions agentiques, plutôt que de simples extensions.

## Questions d'auto-évaluation
1. Quelle est la différence fondamentale entre un *assistant* de code classique et un *agent* de code ?
2. Quels risques liés à la sécurité informatique courre-t-on en utilisant un agent local en CLI par rapport à un agent cloud isolé ?
3. Dans quels types de tâches l'autocomplétion (ghost text) reste-t-elle l'outil le plus productif et le moins intrusif pour un développeur ?

# Les différentes façons d’utiliser Claude

**Durée : 14 minutes**

## Notes

### Progression de l'autonomie et de la complexité
```mermaid
graph TD
    A[1. Autocomplétion<br/>Local / Ghost text] --> B[2. Chat dans l'éditeur<br/>Explications / Refactoring local]
    B --> C[3. Édition assistée<br/>Modifications en diff inline]
    C --> D[4. Agent Local (CLI)<br/>Boucle autonome avec terminal]
    D --> E[5. IDE Agentique<br/>Agent-first / Tâches multiples]
    E --> F[6. Agent Cloud<br/>Isolation en Sandbox / PR automatique]

    style A fill:#f9f9f9,stroke:#ddd
    style B fill:#e3f2fd,stroke:#2196f3
    style C fill:#e1f5fe,stroke:#03a9f4
    style D fill:#e8f5e9,stroke:#4caf50,stroke-width:2px
    style E fill:#fff3e0,stroke:#ff9800,stroke-width:2px
    style F fill:#ffebee,stroke:#f44336,stroke-width:2px
```

## Points clés

- **L'autocomplétion** accélère la frappe mais ne valide ni la logique sémantique, ni la réussite des tests.
- **Le chat et l'édition assistée** maintiennent l'humain dans le contrôle direct de chaque ligne de modification (diff visuel).
- **L'agent de code** (CLI ou IDE) poursuit un **objectif global** en modifiant plusieurs fichiers et en vérifiant son travail par commandes système.
- **Claude Code** s'utilise principalement en ligne de commande (CLI) pour exécuter des builds, des linters et des commits de manière fluide.
- **Les agents Cloud** offrent une **isolation totale** et évitent les effets de bord destructeurs locaux, mais exigent des environnements configurés et reproductibles.
- **IDE Agentiques** (Cursor, Antigravity) placent l'IA au cœur du workflow (gestion intégrée des fichiers, terminal et visualisations).
