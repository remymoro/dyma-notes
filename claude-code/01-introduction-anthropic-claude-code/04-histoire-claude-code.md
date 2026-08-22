---
title: "Histoire de Claude Code"
description: "Découverte de l’origine, des figures clés et de l’évolution chronologique de Claude Code."
date: 2026-08-14
draft: true
tags:
  - anthropic
  - claude-code
  - histoire
categories:
  - "Chapitre 1"
cours: Claude Code
chapitre: 01-introduction-anthropic-claude-code
leçon: 04-histoire-claude-code
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Comment fonctionnait l'aide au dev avant Claude Code ? | Reposait sur 3 piliers passifs : les **IDE** (refactoring local), les **moteurs de recherche** (doc) et les **assistants de complétion** (snippets hors contexte). Les chatbots n'agissaient pas directement. |
| Qu'est-ce qui définit la rupture historique de Claude Code ? | Le passage du chat passif à **l'action agentique** dans le terminal : exploration, modification, tests et commits autonomes. |
| Qui sont les figures clés du projet ? | **Boris Cherny** (ingénierie et origine technique), **Cat Wu** (pilotage produit), **Sid Bidasaria** (founding engineer/tech lead) et **Cal Rueb** (démonstrations/bonnes pratiques). |
| Quelles sont les dates clés d'évolution ? | **24 fév 2025** : Limited Research Preview (avec Claude 3.7 Sonnet).<br>**22 mai 2025** : Passage en GA (avec Claude 4), intégration IDE/SDK/CI-CD.<br>**Automne 2025** : Apparition des Plugins, Skills et du Mode Sandbox. |
| Qu'est-ce que l'incident du source map de 2026 ? | Publication accidentelle d'un fichier source map du paquet `@anthropic-ai/claude-code` exposant le code TypeScript du client. Sensibilisation aux risques de la supply chain IA. |

## Synthèse
Claude Code est né d'une expérimentation technique visant à intégrer Claude directement dans le terminal pour passer du simple chat à l'action autonome sur le code. Son histoire (de la preview en février 2025 à sa généralisation) est celle d'une transition rapide vers un écosystème multi-surfaces (IDE, SDK, CI/CD) et multi-agents (Agent Teams), validé par des cas d'usage réels chez Stripe et Ramp.

## Glossaire
- **Action agentique** : Capacité d'une IA à planifier des étapes, utiliser des outils locaux (compilateur, git, testeur) et corriger ses propres erreurs.
- **Limited Research Preview** : Phase de test publique restreinte permettant de récolter des retours d'usage en amont de la version finale.
- **Source Map** : Fichier faisant le lien entre le code JavaScript minifié/compilé et le code source TypeScript original.
- **Sandbox** : Environnement d'exécution isolé empêchant l'agent d'exécuter des actions système destructrices sur la machine hôte.

## Questions d'auto-évaluation
1. Pourquoi la philosophie de Claude Code est-elle qualifiée d'héritière directe de la philosophie Unix ?
2. Quelle est la différence fondamentale entre un assistant de complétion (type Copilot classique) et un agent CLI comme Claude Code ?
3. Quels mécanismes ont été introduits à l'automne 2025 pour sécuriser l'exécution des commandes système par l'agent ?
4. Quel enseignement l'incident du source map de 2026 a-t-il apporté à la communauté des développeurs ?

# Histoire de Claude Code

**Durée : 14 minutes**

## Objectif de la leçon
Tracer la genèse de Claude Code, comprendre la rupture avec les assistants passifs et connaître les jalons historiques clés de son développement.

---

# 1. La rupture avec l'aide au développement classique

Avant Claude Code, le développement assisté par IA souffrait de fragmentation :

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    OUTILS CLASSIQUES (PASSIFS)                          │
│                                                                         │
│  [IDE] -------------> Refactoring local manuel                          │
│  [Recherche Web] ---> Copie de documentation                            │
│  [Complétion IA] ---> Suggestion ligne par ligne hors contexte          │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE (AGENT CLI ACTIF)                        │
│                                                                         │
│  Lecture du projet ──> Planification ──> Édition ──> Tests ──> Commit   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Chronologie du Développement (2025 - 2026)

```text
24 Fév 2025     22 Mai 2025         Automne 2025        2026
    │                │                   │               │
    ▼                ▼                   ▼               ▼
Research Preview   General Avail.      Plugins & Skills   Agent Teams
(Claude 3.7)       (Claude 4, SDK)     (Mode Sandbox)    (Mémoire auto)
```

---

# 3. Les Cas d'Usage Industriels

* **Stripe** : Migrations massives de code et mise à jour de dépendances complexes à grande échelle.
* **Ramp** : Analyse automatique d'incidents et débogage autonome à partir de logs.

---

# Résumé & Schéma global

```text
                      ÉVOLUTION DE CLAUDE CODE
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼                          ▼                          ▼
Origine & Penseurs        Passage en GA (2025)       Sécurité & Écosystème
(Cherny, Wu, Bidasaria)   (Terminal, IDE, SDKs)      (Plugins, Sandbox, Teams)
```

# Tableau récapitulatif des jalons

| Date | Événement | Impact |
|---|---|---|
| **Février 2025** | Limited Research Preview | Lancement initial avec Claude 3.7 Sonnet. |
| **Mai 2025** | Generally Available (GA) | Intégration Claude 4, IDEs et SDKs Python/TS. |
| **Automne 2025** | Plugins & Sandbox | Structuration de l'écosystème d'extensions. |
| **2026** | Agent Teams & Source Map | Travail multi-agents et vigilance supply chain. |

# Les 5 points les plus importants

1. **Claude Code est né du besoin de franchir le pas** entre la discussion textuelle et l'action sur le code.
2. **Boris Cherny et Cat Wu** ont été les moteurs de la conception technique et produit de l'outil.
3. **Le passage en GA en mai 2025** a étendu l'agent aux IDEs, CI/CD et SDKs.
4. **L'arrivée du mode Sandbox** a apporté l'isolation nécessaire pour sécuriser les exécutions CLI.
5. **L'adoption par des géants comme Stripe et Ramp** a prouvé l'efficacité de l'agent sur des dépôts réels.

---

# Carte mentale

```text
Histoire de Claude Code
│
├── Rupture Technologique
│   ├── Fin de la complétion passive
│   └── Agent autonome dans le terminal
│
├── Chronologie
│   ├── Fév 2025 : Research Preview
│   ├── Mai 2025 : GA & IDEs
│   └── Automne 2025 : Plugins & Sandbox
│
└── Impact & Industrie
    ├── Cas Stripe & Ramp
    └── Enseignements de sécurité (Source map)
```

---

# Mini fiche de révision

```text
Boris Cherny & Cat Wu → Penseurs de Claude Code
Février 2025         → Research Preview
Mai 2025             → GA (Claude 4)
Action agentique     → Lire, écrire, tester, committer
```

> **Phrase à retenir** : Claude Code a transformé l'IA de développement : d'un conseiller passif qui suggère du code, elle est devenue un co-équipier actif qui exécute et teste dans le terminal.
