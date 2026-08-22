---
title: "Les phases d’entraînement d’un LLM"
description: "Découvrir les grandes étapes de fabrication d'un LLM : préparation des données, Pretraining, SFT, Alignement et Inférence."
date: 2026-08-14
draft: true
tags:
  - intelligence-artificielle
  - llm
  - entrainement
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 02-phases-entrainement-llm
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Comment un LLM apprend-il ? | Ajustement de milliards de **poids (weights)** pour minimiser l'erreur de prédiction sur de grands corpus. |
| Quelles sont les 3 étapes du dataset ? | 1. **Nettoyage** (bruit).<br>2. **Déduplication** (retirer les doublons).<br>3. **Filtrage** (qualité). |
| Qu'est-ce que le Pretraining ? | Apprentissage brut massif consistant à **prédire le token suivant** sur tout le web. |
| Qu'est-ce que le SFT ? | *Supervised Fine-Tuning* : Enseignement de la structure "Instruction / Réponse" au modèle. |
| Qu'est-ce que l'Alignement (RLHF/DPO) ? | Ajustement selon les préférences humaines pour rendre le modèle utile, inoffensif et précis. |
| Quelle différence entre Entraînement et Inférence ? | **Entraînement** : Les poids changent.<br>**Inférence** : Les poids sont figés (lecture seule). |

## Synthèse
L'entraînement d'un LLM s'effectue en plusieurs phases : la préparation des données (nettoyage/déduplication), le Pretraining (prédiction de mots), le SFT (obéissance aux instructions) et l'Alignement (RLHF/DPO pour les préférences humaines). En phase d'Inférence, les poids du modèle restent figés.

## Glossaire
- **Backpropagation** : Calcul rétrograde de l'erreur permettant d'identifier les poids à ajuster dans le réseau de neurones.
- **Gradient Descent** : Algorithme d'optimisation ajustant progressivement les paramètres pour réduire la fonction de perte (Loss).
- **Inférence** : Phase d'utilisation opérationnelle où le modèle génère des réponses à poids constants.
- **SFT (Supervised Fine-Tuning)** : Étape d'entraînement supervisé apprenant au modèle à se comporter en assistant.

## Questions d'auto-évaluation
1. Comment un modèle réagit-il à une consigne s'il n'a subi que la phase de Pretraining sans SFT ?
2. Pourquoi la déduplication des données est-elle cruciale avant de lancer le Pretraining ?
3. Quelle est la différence majeure entre la phase d'Entraînement et la phase d'Inférence ?
4. Quel est le rôle de l'algorithme de Descente de Gradient ?

# Les phases d’entraînement d’un LLM

**Durée : 19 minutes**

## Objectif de la leçon
Comprendre le cycle complet de création d'un modèle de langage, du corpus de données brutes jusqu'à son déploiement en inférence.

---

# 1. Le Pipeline d'Entraînement

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    LES 4 PHASES DE FABRICATION D'UN LLM                 │
│                                                                         │
│  1. DONNÉES      : Nettoyage ──> Déduplication ──> Filtrage            │
│  2. PRETRAINING  : Complétion brute du mot suivant (Loss / Gradients)   │
│  3. SFT          : Apprentissage du format "Question / Réponse"         │
│  4. ALIGNEMENT   : Ajustement selon les préférences humaines (RLHF/DPO) │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Entraînement vs Inférence

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                        ENTRAÎNEMENT vs INFÉRENCE                        │
│                                                                         │
│   ENTRAÎNEMENT : Poids (Weights) DYNAMIQUES ──> Mise à jour permanente  │
│   INFÉRENCE    : Poids (Weights) FIGÉS     ──> Lecture seule (Prompt)   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                       CYCLE DE VIE D'UN LLM
                                 │
     ┌───────────────────────────┼───────────────────────────┐
     ▼                           ▼                           ▼
  Pretraining                   SFT                      Alignement
(Compulsion web)        (Suivi d'instruction)       (RLHF / Sécurité)
```

# Tableau récapitulatif des phases

| Phase | Entrée | Objectif |
|---|---|---|
| **Pretraining** | Textes bruts du web | Prédire le token suivant. |
| **SFT** | Paires (Instruction, Réponse) | Transformer le modèle en assistant. |
| **Alignement** | Préférences (A est meilleur que B) | Garantir la sécurité et l'utilité. |
| **Inférence** | Prompts utilisateurs | Générer du texte à poids fixes. |

# Les 5 points les plus importants

1. **Le Pretraining est la phase la plus coûteuse**, créant la base de connaissances du modèle.
2. **Le SFT (Supervised Fine-Tuning)** apprend au modèle à répondre aux instructions.
3. **L'alignement (RLHF/DPO)** affine le comportement selon les valeurs et attentes humaines.
4. **La rétropropagation (Backpropagation)** permet de corriger les erreurs de prédiction.
5. **En inférence (utilisation quotidienne)**, les poids du modèle ne changent jamais.

---

# Carte mentale

```text
Phases d'entraînement d'un LLM
│
├── 1. Préparation des données
│   ├── Nettoyage & Filtrage
│   └── Déduplication
│
├── 2. Pretraining (Base)
│   ├── Loss function & Gradients
│   └── Prédiction du token suivant
│
├── 3. Post-Training (Comportement)
│   ├── SFT (Instructions)
│   └── Alignement (RLHF / DPO)
│
└── 4. Inférence (Production)
    └── Modèle figé en lecture seule
```

---

# Mini fiche de révision

```text
Pretraining  → Apprentissage brut du langage
SFT          → Format Assistant (Instruction/Réponse)
RLHF / DPO   → Alignement éthique & préférences
Inférence    → Utilisation à poids fixes
```

> **Phrase à retenir** : Le pretraining donne l'intelligence au modèle, le post-training lui apprend la politesse et l'obéissance.
