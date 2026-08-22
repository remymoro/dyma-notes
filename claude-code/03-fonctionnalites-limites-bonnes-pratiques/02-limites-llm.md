---
title: "Les limites des LLM"
description: "Comprendre les limites intrinsèques des LLM : hallucinations, knowledge cutoff, sycophantie et sécurité des données."
date: 2026-08-15
draft: true
tags:
  - llm
  - limites
  - hallucinations
  - securite
categories:
  - "Chapitre 3"
cours: Claude Code
chapitre: 03-fonctionnalites-limites-bonnes-pratiques
leçon: 02-limites-llm
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Quelle est la limite fondamentale ? | Prédit la **plausibilité** textuelle, pas la **vérité**. La forme parfaite masque parfois des faits faux. |
| Qu'est-ce qu'une hallucination ? | Génération assurée d'informations fausses, inventées ou obsolètes. |
| Qu'est-ce que le Knowledge Cutoff ? | Date limite d'entraînement au-delà de laquelle le modèle ignore les événements récents. |
| Qu'est-ce que la sycophantie ? | Tendances du modèle à confirmer les erreurs de l'utilisateur pour paraître serviable. |
| Limites de calcul et logique ? | Faiblesses sur l'arithmétique exacte complexe et le raisonnement géométrique/spatial. |
| Sécurité & Confidentialité | Interdiction d'injecter des données sensibles (secrets d'entreprise, RGPD) sans garanties API. |

## Synthèse
Les LLM sont des générateurs de textes plausibles et non des moteurs de vérités absolues. Leurs limites principales incluent les hallucinations (inventions plausibles), la date de fin d'apprentissage (*knowledge cutoff*), des faiblesses logiques et la sycophantie (flatterie de l'utilisateur). Une validation humaine reste systématiquement nécessaire.

## Glossaire
- **Hallucination** : Information fausse ou inventée générée avec assurance par l'IA.
- **Knowledge Cutoff** : Date de gel des données d'entraînement du modèle.
- **Sycophantie** : Propension de l'IA à approuver les choix de l'utilisateur même lorsqu'ils sont erronés.
- **Validation humaine** : Contrôle systématique des sorties du modèle par un expert métier.

## Questions d'auto-évaluation
1. Pourquoi un ton assuré et un style d'écriture parfait ne garantissent-ils pas l'exactitude d'un code généré par l'IA ?
2. Comment l'instruction *"Sois critique et signale toutes mes erreurs"* permet-elle de contrecarrer la sycophantie ?
3. Quel mécanisme technique permet de pallier la limite du Knowledge Cutoff ?
4. Quels risques juridiques existent lors de l'injection de données clients brutes dans un prompt ?

# Les limites des LLM

**Durée : 18 minutes**

## Objectif de la leçon
Identifier les pièges et limites des modèles de langage (hallucinations, sycophantie, limites logiques) pour sécuriser leur usage professionnel.

---

# 1. Plausibilité vs Vérité

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    PLAUSIBILITÉ vs VÉRITÉ EN IA                         │
│                                                                         │
│  FORME : Grammaire parfaite, ton confiant, structure claire (Plausible) │
│  FOND  : Faits inventés, fonctions fictives, calculs faux (Hallucination)│
│                                                                         │
│  └─► Règle : Toujours exécuter les tests et vérifier les références.   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. La Sycophantie et comment l'éviter

```text
Prompt Biaisé   ──> "Mon architecture PHP est excellente, n'est-ce pas ?"
IA Sycophante   ──> "Oui, absolument ! Votre architecture est parfaite..." (FAUX)

Prompt Correct  ──> "Joue le rôle d'un auditeur technique sévère. Trouve les failles de cette architecture."
IA Objective    ──> "Voici 3 problèmes majeurs de performance et de sécurité..." (UTILE)
```

---

# Résumé & Schéma global

```text
                        LIMITES & VIGILANCE LLM
                                   │
       ┌───────────────────────────┼───────────────────────────┐
       ▼                           ▼                           ▼
 Hallucinations             Knowledge Cutoff               Sycophantie
(Calculs / Faits)           (Besoins de RAG/Web)         (Besoin d'esprit critique)
```

# Tableau récapitulatif des limites

| Limite | Manifestation | Solution / Bonne pratique |
|---|---|---|
| **Hallucination** | Invocations de librairies/APIs fictives. | Exécuter le code et vérifier la documentation. |
| **Knowledge Cutoff** | Ignorance de la dernière version d'un framework. | Injecter la documentation récente dans le contexte. |
| **Sycophantie** | Approbation d'idées fausses de l'utilisateur. | Ordonner à l'agent de jouer un rôle d'auditeur critique. |
| **Confidentialité** | Fuites potentielles de secrets. | Utiliser des clés d'API avec *Zero Data Retention*. |

# Les 5 points les plus importants

1. **La forme ne garantit pas le fond** : un ton très sûr peut masquer une hallucination totale.
2. **Le Knowledge Cutoff impose d'injecter** la documentation récente des librairies.
3. **La sycophantie doit être contrée** en demandant explicitement à l'IA d'être critique.
4. **Les LLM ne sont pas des calculatrices** : déléguez les calculs à des scripts Python exécutés par l'agent.
5. **La validation finale appartient toujours au développeur**, jamais au modèle.

---

# Carte mentale

```text
Limites des LLM
│
├── Biais de Génération
│   ├── Hallucinations (Faits & Code fictif)
│   └── Sycophantie (Complaisance)
│
├── Limites de Connaissances
│   ├── Knowledge Cutoff
│   └── Absence de données privées
│
└── Vigilance & Sécurité
    ├── Confidentialité & RGPD
    └── Validation humaine systématique
```

---

# Mini fiche de révision

```text
Hallucination    → Information fausse générée avec assurance
Knowledge Cutoff → Date limite des connaissances d'entraînement
Sycophantie      → IA qui donne raison à l'utilisateur à tort
Règle d'or       → Toujours tester le code et relire les réponses
```

> **Phrase à retenir** : Un LLM ne connaît pas la vérité, il connaît la probabilité : la validation d'un résultat reste la responsabilité exclusive de l'humain.
