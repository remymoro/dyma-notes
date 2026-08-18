---
title: "Les gammes de modèles et leurs performances"
description: "Découvrir les gammes de modèles (Haiku, Sonnet, Opus), leurs compromis Vitesse/Coût/Qualité et l'architecture MoE."
date: 2026-08-15
draft: true
tags:
  - llm
  - modeles
  - performance
categories:
  - "Chapitre 3"
cours: Claude Code
chapitre: 03-fonctionnalites-limites-bonnes-pratiques
leçon: 01-gammes-modeles-performance
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Que sont les paramètres (weights) ? | Valeurs numériques ajustées en apprentissage. Connaissances **distribuées** mathématiquement. |
| Quel est le compromis Taille/Vitesse/Coût ? | **Légers** (Haiku) : Vitesse & faible coût.<br>**Équilibrés** (Sonnet) : Polyvalence dev.<br>**Puissants** (Opus) : Raisonnement lourd. |
| Qu'est-ce qu'une architecture MoE ? | *Mixture of Experts* : Activation dynamique d'un sous-ensemble d'experts par token pour optimiser le calcul. |
| Quel est le rôle des modèles d'embedding ? | Modèles non conversationnels convertissant du texte en vecteurs pour les moteurs RAG. |
| Comment choisir son modèle ? | Sélectionner selon le risque et la complexité : Haiku (tâches simples/massives), Sonnet (code/agent), Opus (refactoring lourd). |

## Synthèse
Le choix d'un modèle d'IA repose sur un arbitrage strict entre la qualité requise, la latence acceptable et le coût par million de tokens. La gamme Anthropic s'échelonne de Haiku (rapide et économique) à Opus (raisonnement complexe), en passant par Sonnet (l'étalon-or pour le développement et Claude Code).

## Glossaire
- **Dense** : Architecture où 100% des paramètres sont sollicités à chaque token généré.
- **MoE (Mixture of Experts)** : Architecture n'activant qu'une fraction des paramètres (experts) par token.
- **Paramètre (Weight)** : Coefficient numérique ajusté en entraînement stockant les connaissances du modèle.
- **RAG (Retrieval-Augmented Generation)** : Système associant un modèle d'embedding et un LLM pour la recherche documentaire.

## Questions d'auto-évaluation
1. Pourquoi un modèle avec moins de paramètres mais un entraînement plus propre peut-il surpasser un modèle plus volumineux ?
2. Quel est l'avantage principal de l'architecture MoE pour les fournisseurs d'API ?
3. Pourquoi Claude Sonnet est-il le modèle recommandé par défaut pour Claude Code ?
4. Quelle est la fonction propre d'un modèle d'embedding par rapport à un LLM conversationnel ?

# Les gammes de modèles et leurs performances

## Objectif de la leçon
Comprendre l'arbitrage Qualité-Vitesse-Coût et savoir sélectionner le modèle adapté au cas d'usage technique.

---

# 1. Le Compromis Vitesse / Coût / Qualité

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      TRIANGLE D'ARBITRAGE DES MODÈLES                   │
│                                                                         │
│  [Haiku]  ──> Ultra-Rapide & Économique (Extraction, tri, classification)│
│  [Sonnet] ──> Modèle Étalon-Or (Développement, agents, refactoring)    │
│  [Opus]   ──> Raisonnement Supérieur (Problèmes mathématiques/architecture)│
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Arbre de Décision pour la Sélection

```text
               Tâche à accomplir
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
Tâche simple & répétitive?     Besoin de code / logique?
   │                              │
   ├──> OUI : Haiku               ├──> OUI : Sonnet / LRM
   └──> NON : Voir complexe       └──> NON : Opus (Analyse doc)
```

---

# Résumé & Schéma global

```text
                       GAMME DE MODÈLES ANTHROPIC
                                   │
       ┌───────────────────────────┼───────────────────────────┐
       ▼                           ▼                           ▼
   Claude Haiku              Claude Sonnet               Claude Opus
(Rapidité / Coût)         (Code / Équilibre)          (Complexité max)
```

# Tableau récapitulatif de la gamme

| Modèle | Spécialité | Cas d'usage idéal |
|---|---|---|
| **Claude Haiku** | Vitesse extrême, faible coût | Tri de logs, extraction de données, requêtes légères. |
| **Claude Sonnet** | Équilibre parfait, agentique | Programmation, édition de fichiers, Claude Code CLI. |
| **Claude Opus** | Raisonnement lourd, nuances | Architecture logicielle, réécriture complexe, audits. |

# Les 5 points les plus importants

1. **Les connaissances sont distribuées dans les poids**, pas stockées sous forme de tables.
2. **Claude Sonnet est le modèle de référence** pour l'agentique et le code.
3. **Claude Haiku permet d'automatiser** des tâches massives à très faible coût.
4. **L'architecture MoE n'active que les experts nécessaires**, réduisant la latence.
5. **Le choix du modèle doit être guidé** par l'arbitrage Vitesse / Coût / Précision.

---

# Carte mentale

```text
Gammes de Modèles & Performance
│
├── Gamme Anthropic
│   ├── Haiku (Rapide / Économique)
│   ├── Sonnet (Équilibré / Code CLI)
│   └── Opus (Raisonnement lourd)
│
├── Architectures
│   ├── Modèles Denses (100% calcul)
│   └── MoE (Activation dynamique par token)
│
└── Critères de Sélection
    ├── Complexité de la tâche
    ├── Exigence de latence
    └── Budget tokens
```

---

# Mini fiche de révision

```text
Haiku  → Vitesse & Économie (Tâches simples)
Sonnet → Standard de développement (Claude Code)
Opus   → Raisonnement & Architecture complexe
MoE    → Activation sélective des paramètres par token
```

> **Phrase à retenir** : Ne payez pas pour de l'intelligence inutile : utilisez Haiku pour le tri et Sonnet/Opus pour le code critique.
