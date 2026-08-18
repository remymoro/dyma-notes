---
title: "La spécificité Anthropic : la Constitution IA"
description: "Découvrir l'approche constitutionnelle développée par Anthropic (Constitutional AI, RLAIF et la hiérarchie à 4 niveaux)."
date: 2026-08-14
draft: true
tags:
  - anthropic
  - intelligence-artificielle
  - constitution-ia
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 05-constitution-ia-anthropic
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce que Constitutional AI ? | Méthode d'alignement entraînant le modèle à évaluer et corriger ses propres réponses via des principes écrits. |
| Quelles sont les limites du RLHF classique ? | Exposition des annotateurs humains, **sycophantie** (flatterie), valeurs cachées et limites d'échelle. |
| Comment s'articulent les deux phases ? | 1. **Critique et Révision** (SFT constitutionnel).<br>2. **Apprentissage par Renforcement** (RLAIF). |
| Quelle est la hiérarchie à 4 niveaux ? | **1. Sûreté** (Absolue) ──> **2. Éthique** ──> **3. Conformité** ──> **4. Utilité** (Subordonnée). |
| Hard constraints vs règles ajustables ? | **Hard constraints** : Limites absolues (cyberarmes, CSAM).<br>**Règles ajustables** : Ton, style, format. |

## Synthèse
Constitutional AI est la méthode d'alignement propriétaire d'Anthropic. Elle remplace la modération humaine directe par un apprentissage par renforcement basé sur l'IA (RLAIF) guidé par une constitution écrite. La version 2026 établit une hiérarchie stricte à 4 niveaux (Sûreté > Éthique > Conformité > Utilité), éliminant la sycophantie et rendant les refus prévisibles et transparents.

## Glossaire
- **Constitutional AI** : Méthode d'alignement guidée par des principes explicites d'auto-correction.
- **RLAIF (Reinforcement Learning from AI Feedback)** : Apprentissage par renforcement utilisant un modèle d'IA pour attribuer les récompenses d'alignement.
- **Sycophantie** : Tendance négative d'un modèle d'IA à être trop d'accord avec l'utilisateur, même s'il a tort.
- **Hard constraints** : Interdictions absolues non contournables inscrites dans le noyau de sécurité du modèle.

## Questions d'auto-évaluation
1. Pourquoi l'utilisation de principes constitutionnels explicites rend-elle Claude plus prévisible pour les entreprises ?
2. Quel niveau de la hiérarchie constitutionnelle prime en cas de conflit entre la demande de l'utilisateur et la sécurité ?
3. Comment la méthode RLAIF évite-t-elle l'épuisement des annotateurs humains du RLHF traditionnel ?

# La spécificité Anthropic : la Constitution IA

## Objectif de la leçon
Découvrir les principes majeurs de la Constitutional AI d'Anthropic et comprendre la hiérarchie à 4 niveaux qui régit les décisions et refus de Claude.

---

# 1. Le Pipeline Constitutional AI (RLAIF)

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    PIPELINE CONSTITUTIONAL AI                           │
│                                                                         │
│  [Prompt Sensible] ──> [Réponse brute] ──> [Critique vs Constitution]   │
│                                                     │                   │
│  [Modèle Aligné (RLAIF)] <── [Réponse révisée] ◄────┘                   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. La Hiérarchie Constitutionnelle à 4 Niveaux

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      HIÉRARCHIE DE DÉCISION (2026)                      │
│                                                                         │
│  NIVEAU 1 : SÛRETÉ    ──> Protection absolue (Cyberarmes, CSAM)        │
│  NIVEAU 2 : ÉTHIQUE   ──> Honnêteté & Non-manipulation                   │
│  NIVEAU 3 : CONFORMITÉ──> Consignes de l'opérateur (API / Enterprise)   │
│  NIVEAU 4 : UTILITÉ   ──> Aide à l'utilisateur (Subordonnée aux 1-3)  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                  ALIGNEMENT PAR CONSTITUTION (RLAIF)
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼                          ▼                          ▼
Principes Écrits           Auto-Correction            Hiérarchie 4 Niveaux
(Constitution claire)      (Critique avant réponse)   (Sûreté > Utilité)
```

# Tableau récapitulatif

| Niveau | Domaine | Priorité |
|---|---|---|
| **Niveau 1** | Sûreté globale (Armes, Cyberattaques) | Priorité Absolue |
| **Niveau 2** | Éthique & Vérité (Anti-sycophantie) | Forte |
| **Niveau 3** | Conformité métier (Règles entreprise) | Moyenne |
| **Niveau 4** | Utilité directe (Aide utilisateur) | Subordonnée |

# Les 5 points les plus importants

1. **Constitutional AI utilise le RLAIF** pour évaluer les réponses sans dépendre du RLHF humain continu.
2. **Le modèle s'auto-critique** et se réécrit par rapport à des principes constitutionnels explicites.
3. **La hiérarchie à 4 niveaux** place la Sûreté et l'Éthique au-dessus de l'Utilité utilisateur.
4. **La sycophantie est activement combattue** pour éviter que l'IA ne valide des erreurs par flatterie.
5. **Les hard constraints sont absolues** et garantissent la sécurité en environnement Enterprise.

---

# Carte mentale

```text
Constitution IA Anthropic
│
├── Méthodologie
│   ├── RLAIF (AI Feedback)
│   └── Auto-critique & Révision
│
├── Hiérarchie des Devoirs
│   ├── 1. Sûreté (Absolue)
│   ├── 2. Éthique & Vérité
│   ├── 3. Conformité Métier
│   └── 4. Utilité Utilisateur
│
└── Bénéfices Enterprise
    ├── Transparence des refus
    └── Prévention de la sycophantie
```

---

# Mini fiche de révision

```text
Constitutional AI → Alignement guidé par principes écrits
RLAIF             → Apprentissage par renforcement basé sur l'IA
Hiérarchie 1 à 4  → Sûreté > Éthique > Conformité > Utilité
Anti-sycophantie  → Ne pas dire oui à l'utilisateur s'il se trompe
```

> **Phrase à retenir** : Claude ne cherche pas à plaire à tout prix à l'utilisateur : sa constitution place la sécurité et l'honnêteté scientifique avant l'obéissance aveugle.
