---
title: "Tour d’horizon des produits Anthropic"
description: "Présentation des 5 produits principaux d'Anthropic, de l'écosystème d'intégrations et de la pyramide d'architecture."
date: 2026-08-14
draft: true
tags:
  - anthropic
  - produits
categories:
  - "Chapitre 1"
cours: Claude Code
chapitre: 01-introduction-anthropic-claude-code
leçon: 03-tour-horizon-produits-anthropic
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Différence produit / intégration / compétence / connecteur ? | **Produit** : Surface de travail (Claude, Claude Code).<br>**Intégration** : Interface tierce d'utilisation (Slack, Chrome).<br>**Compétence (Skill)** : Méthode spécialisée.<br>**Connecteur** : Lien aux données/services (MCP). |
| Quels sont les 5 produits principaux d'Anthropic ? | 1. Claude (Généraliste)<br>2. Claude Code (Développement CLI)<br>3. Claude Cowork (Agentique long)<br>4. Claude Design (Création visuelle)<br>5. Claude Security (Cybersécurité). |
| Qu'est-ce qu'un Plugin ? | Un package installable regroupant compétences, connecteurs et workflows pour un métier donné. |
| À quoi sert Claude Platform ? | Plateforme développeur (API, SDKs) pour intégrer les modèles dans des applications sur mesure. |
| Que signifient GA, Public beta et Research preview ? | **GA** : Généralement disponible/stable.<br>**Public beta** : Accessible mais sujet aux évolutions.<br>**Research preview** : Expérimental et restreint. |
| Pourquoi cette distinction compte ? | Assurer la gouvernance des données et limiter les risques de sécurité selon les permissions accordées aux connecteurs. |

## Synthèse
L'écosystème d'Anthropic est structuré en plusieurs strates : les modèles (Opus, Sonnet, Haiku) alimentent cinq produits principaux (Claude, Code, Cowork, Design, Security). Ces produits s'intègrent dans des environnements tiers (IDE, Slack, Chrome) et s'étendent grâce au répertoire de compétences (Skills), de connecteurs (MCP) et de plugins métiers.

## Glossaire
- **MCP (Model Context Protocol)** : Protocole ouvert développé par Anthropic permettant de connecter les modèles aux outils et bases de données locales/cloud.
- **Skill (Compétence)** : Instruction technique ou méthode réutilisable enseignée à l'agent.
- **Plugin** : Bundle complet combinant plusieurs Skills et Connecteurs métiers prêts à l'emploi.
- **GA (General Availability)** : Statut de maturité d'un logiciel indiquant sa stabilité pour une utilisation en production.

## Questions d'auto-évaluation
1. Si un ingénieur souhaite automatiser des refactorisations sur un projet local sans interface graphique, quel produit Anthropic est adapté ?
2. Quelle est la différence essentielle entre un *Connecteur* et un *Skill* ?
3. Pourquoi l'activation d'un plugin nécessite-t-elle une évaluation de gouvernance préalable en entreprise ?
4. Quels sont les 3 modèles fondamentaux qui motorisent les produits Anthropic ?

# Tour d’horizon des produits Anthropic

**Durée : 20 minutes**

## Objectif de la leçon
Identifier les 5 produits majeurs d'Anthropic, comprendre l'écosystème d'extensions (Skills, Connecteurs, Plugins) et savoir choisir l'outil adapté au besoin.

---

# 1. Les 5 Produits Principaux

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                     LES 5 PRODUITS ANTHROPIC                            │
│                                                                         │
│  1. CLAUDE        : Chat généraliste, rédaction, analyse doc            │
│  2. CLAUDE CODE   : Agent CLI autonome pour développeurs                │
│  3. CLAUDE COWORK : Exécution agentique longue sur workflows complexes  │
│  4. CLAUDE DESIGN : Prototypage visuel et UI/UX                         │
│  5. CLAUDE SECU   : Audit de sécurité et détection de failles         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Le Répertoire d'Extensions (Skills, Connecteurs, Plugins)

L'écosystème repose sur des briques modulaires installables :

* **Skills (Compétences)** : Instructions méthodologiques (ex: structure de fiche, conventions de code).
* **Connecteurs (MCP)** : Passerelles vers des outils externes (ex: GitHub, PostgreSQL, Google Drive).
* **Plugins** : Bundles métiers regroupant Skills + Connecteurs + Workflows.

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                        ANATOMIE D'UN PLUGIN                             │
│                                                                         │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │  PLUGIN MÉTIER                                                  │   │
│   │  ├── SKILL : Règles de refactorisation                          │   │
│   │  ├── CONNECTEUR : Accès API GitHub                              │   │
│   │  └── WORKFLOW : Boucle de validation automatisée                │   │
│   └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 3. La Pyramide d'Architecture à 6 Niveaux

```text
               ┌────────────────────────────────────────┐
               │ 6. Solutions Verticales (Finance/Legal)│
               ├────────────────────────────────────────┤
               │ 5. Claude Platform (API / SDK)         │
               ├────────────────────────────────────────┤
               │ 4. Le Répertoire (Skills/Connecteurs)   │
               ├────────────────────────────────────────┤
               │ 3. Les Intégrations (Chrome, Slack...)  │
               ├────────────────────────────────────────┤
               │ 2. Les 5 Produits (Claude, Code...)    │
               ├────────────────────────────────────────┤
               │ 1. Les Modèles (Opus, Sonnet, Haiku)   │
               └────────────────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                     GAMME PRODUITS ANTHROPIC
                                │
      ┌─────────────────────────┼─────────────────────────┐
      ▼                         ▼                         ▼
  Modèles                  Produits                   Extensions
(Opus/Sonnet/Haiku)   (Claude, Code, Cowork...)   (Skills, MCP, Plugins)
```

# Tableau des produits

| Produit | Usage Principal | Cible |
|---|---|---|
| **Claude** | Discussion, rédaction, synthèse | Tout public / Enterprise |
| **Claude Code** | Agent CLI, modification de code | Développeurs |
| **Claude Cowork** | Tâches agentiques multi-étapes | Équipes opérationnelles |
| **Claude Design** | Prototypage visuel | Designers / Product Managers |
| **Claude Security** | Audit de code & vulnérabilités | Équipes Cybersécurité |

# Les 5 points les plus importants

1. **Anthropic ne se résume pas à un chatbot web** : la gamme compte 5 produits distincts.
2. **Claude Code est dédié aux développeurs** via une interface terminal interactive.
3. **Le protocole MCP** est le standard de connexion aux données et outils tiers.
4. **Un Plugin réunit Skills, Connecteurs et Workflows** dans une solution clé en main.
5. **La gouvernance exige de contrôler** les permissions accordées aux connecteurs.

---

# Carte mentale

```text
Produits Anthropic
│
├── Modèles de base
│   ├── Opus (Raisonnement lourd)
│   ├── Sonnet (Équilibre / Code)
│   └── Haiku (Vitesse / Coût)
│
├── Produits
│   ├── Claude / Claude Code
│   └── Cowork / Design / Security
│
└── Extensibilité
    ├── Skills (Méthodes)
    ├── Connecteurs (MCP)
    └── Plugins (Bundles)
```

---

# Mini fiche de révision

```text
Claude Code      → Agent CLI Dev
MCP              → Standard de connexion données
Skill vs Plugin  → Skill = Méthode | Plugin = Pack complet
Opus/Sonnet/Haiku → Les 3 moteurs IA
```

> **Phrase à retenir** : Les modèles fournissent l'intelligence, les produits la surface de travail, et les extensions MCP l'accès au monde réel.
