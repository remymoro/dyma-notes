---
title: "Les LRM et l'effort"
description: "Comprendre les modèles de raisonnement (LRM), le test-time compute et le contrôle de l'effort de calcul."
date: 2026-08-14
draft: true
tags:
  - intelligence-artificielle
  - llm
  - lrm
  - raisonnement
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 03-lrm-et-effort
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce qu'un LRM ? | *Large Reasoning Model* : LLM optimisé pour exécuter des étapes de délibération logique (*thinking tokens*). |
| Qu'est-ce que le test-time compute ? | Calcul alloué **pendant l'inférence** pour permettre au modèle de réfléchir avant de répondre. |
| Comment contrôler le raisonnement ? | **Thinking budget** (tokens max de réflexion) et **Reasoning effort** (Low, Medium, High). |
| Que fait le modèle pendant sa réflexion ? | Découpage du problème, vérification des contraintes, **backtracking** et auto-correction. |
| Quelle différence entre ORM et PRM ? | **ORM** : Récompense uniquement le résultat final.<br>**PRM** : Récompense la qualité de chaque étape logique intermédiaire. |
| Qu'est-ce que la distillation ? | Transfert des traces de raisonnement d'un modèle expert (Teacher) vers un petit modèle (Student). |

## Synthèse
Les modèles de raisonnement (LRM) s'appuient sur le *test-time compute* pour générer des tokens de réflexion internes avant de répondre. Entraînés par apprentissage par renforcement avec des modèles de récompense de processus (PRM), ils décomposent les problèmes complexes, appliquent du *backtracking* en cas d'erreur et s'auto-corrigeants.

## Glossaire
- **Backtracking** : Capacité du modèle à abandonner une piste logique infructueuse et revenir à une étape antérieure.
- **LRM (Large Reasoning Model)** : Modèle de langage spécialisé dans la délibération et le raisonnement pas-à-pas.
- **PRM (Process Reward Model)** : Système d'évaluation récompensant chaque étape intermédiaire valide d'un raisonnement.
- **Test-time compute** : Temps et puissance de calcul consacrés à la réflexion au moment d'exécuter la requête.

## Questions d'auto-évaluation
1. Pourquoi un LRM est-il plus adapté qu'un LLM classique pour résoudre des bugs complexes sur une base de code ?
2. Quelle est la différence majeure entre un Process Reward Model (PRM) et un Outcome Reward Model (ORM) ?
3. Quel risque existe-t-il lorsqu'on utilise un modèle dont les capacités de raisonnement ont été distillées ?
4. Quel paramètre permet de brider la consommation de tokens lors des étapes de réflexion d'un LRM ?

# Les LRM et l'effort

## Objectif de la leçon
Comprendre le fonctionnement des modèles de raisonnement (LRM), le concept de test-time compute et le contrôle de l'effort de réflexion.

---

# 1. LLM Classique vs LRM

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      MODÈLE CLASSIQUE vs RAISONNEMENT                   │
│                                                                         │
│  [LLM Classique] : Prompt ──> Réponse immédiate (Instinctif)            │
│                                                                         │
│  [LRM]           : Prompt ──> [Thinking Tokens] ──> Réponse finale      │
│                                (Découpage,                              │
│                                 Backtracking,                           │
│                                 Vérification)                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Le Contrôle de l'Effort (Budget & Reasoning Effort)

On ajuste le temps de réflexion selon la complexité du problème :

* **Reasoning Effort** : `Low` (réponses rapides), `Medium` (équilibré), `High` (analyse approfondie).
* **Thinking Budget** : Plafond maximal de tokens accordés au travail interne de délibération.

---

# Résumé & Schéma global

```text
                     MÉCANIQUE DU RAISONNEMENT (LRM)
                                   │
       ┌───────────────────────────┼───────────────────────────┐
       ▼                           ▼                           ▼
Test-time compute            Process Rewards (PRM)       Thinking Budget
(Temps de réflexion)         (Évaluation par étape)      (Contrôle du coût)
```

# Tableau récapitulatif

| Concept | Rôle |
|---|---|
| **Thinking Tokens** | Tokens internes invisibles servant de brouillon logique. |
| **PRM** | Récompense chaque étape de calcul valide pendant l'entraînement. |
| **Backtracking** | Capacité à revenir en arrière en cas de fausse piste. |
| **Distillation** | Compression de compétences de raisonnement dans de petits modèles. |

# Les 5 points les plus importants

1. **Les LRM utilisent le test-time compute** pour réfléchir pendant l'inférence.
2. **Les thinking tokens sont un brouillon interne** servant à la résolution complexe.
3. **Le backtracking permet au modèle de corriger** ses propres erreurs logiques.
4. **Les PRM récompensent la méthode**, contrairement aux ORM qui ne regardent que le résultat.
5. **Le budget de réflexion (thinking budget)** contrôle l'équilibre entre coût et précision.

---

# Carte mentale

```text
Les LRM & L'Effort
│
├── Mécanique interne
│   ├── Test-time compute
│   └── Thinking tokens (brouillon)
│
├── Entraînement
│   ├── PRM (Récompense par étape)
│   └── Backtracking & Auto-correction
│
└── Contrôle & Optimisation
    ├── Thinking budget
    └── Distillation (Teacher → Student)
```

---

# Mini fiche de révision

```text
LRM               → Réfléchit avant de répondre (Thinking tokens)
PRM               → Évalue chaque étape du raisonnement
Backtracking      → Fait machine arrière si blocage
Reasoning effort  → Reglage de l'intensité de réflexion
```

> **Phrase à retenir** : Les LRM transforment le temps de calcul en intelligence en permettant au modèle d'utiliser un brouillon logique avant de donner sa réponse finale.
