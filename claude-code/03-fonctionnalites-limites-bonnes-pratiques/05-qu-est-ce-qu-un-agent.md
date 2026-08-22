---
title: "Qu'est-ce qu'un agent ?"
description: "Comprendre le concept de système agentique : boucle d'exécution autonomie, gestion des permissions et contrôle humain."
date: 2026-08-15
draft: true
tags:
  - llm
  - agents
  - autonomie
  - securite
categories:
  - "Chapitre 3"
cours: Claude Code
chapitre: 03-fonctionnalites-limites-bonnes-pratiques
leçon: 05-qu-est-ce-qu-un-agent
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Quelle est la différence LLM vs Agent ? | Le LLM est un **moteur de décision**. L'**agent** orchestre une suite d'actions autonomes en boucle pour atteindre un objectif. |
| Comment fonctionne la boucle agentique ? | **Comprendre ──> Planifier ──> Agir (Outils) ──> Observer ──> Corriger / Valider**. |
| Comment gérer les permissions ? | Gradation des risques : Lecture (libre) ──> Écriture (contrôlée) ──> Publication/Suppression (Human-in-the-loop). |
| Qu'est-ce que le mode Human-in-the-loop ? | Validation humaine explicite obligatoire avant l'exécution d'actions irréversibles ou sensibles. |
| Différence entre Agent et RPA ? | **RPA** : Règles fixes déterministes.<br>**Agent** : Raisonnement souple en langage naturel sous incertitude. |

## Synthèse
Un agent s'appuie sur le LLM comme cerveau décisionnel pour résoudre des objectifs complexes en boucle fermée (observation, décision, action). Contrairement aux scripts RPA rigides, l'agent s'adapte au contexte mais nécessite des critères d'arrêt stricts et une validation humaine (*human-in-the-loop*) sur les actions sensibles.

## Glossaire
- **Boucle Agentique** : Processus itératif (Plan ──> Action ──> Observation ──> Décision) visant à atteindre un but fixé.
- **Critère d'Arrêt** : Garde-fou technique interrompant la boucle de l'agent si l'objectif n'est pas atteint après un quota.
- **Human-in-the-loop** : Intégration d'un point de validation humaine avant la finalisation d'une action critique.
- **RPA** : Automatisation robotisée déterministe basée sur des règles *Si/Alors* strictes.

## Questions d'auto-évaluation
1. Pourquoi un agent a-t-il besoin de lire les retours d'outils (`Tool Response`) pour ajuster sa planification ?
2. Quelle est la différence de fonctionnement entre une automatisation RPA classique et un agent basé sur un LLM ?
3. Pourquoi le mode *Human-in-the-loop* est-il indispensable lors de la gestion de modifications en production ?
4. Quels risques financiers une boucle agentique mal encadrée présente-t-elle ?

# Qu'est-ce qu'un agent ?

**Durée : 12 minutes**

## Objectif de la leçon
Découvrir l'architecture d'un agent autonome, comprendre la boucle d'exécution et savoir intégrer les mécanismes de sécurité et de contrôle humain.

---

# 1. Anatomie de la Boucle Agentique

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                        LA BOUCLE AGENTIQUE                              │
│                                                                         │
│  [1. Objectif] ──> [2. Planification] ──> [3. Action (Tool Call)]      │
│         ▲                                          │                    │
│         │                                          ▼                    │
│  [6. Validation] <── [5. Décision] <── [4. Observation (Tool Result)]  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Gradation des Permissions & Contrôle Humain

```text
Lecture Seule      ──> Auto-approuvé (Faible risque : lire fichiers, status)
Écriture Locale    ──> Soumis à approbation (Risque moyen : modifier code)
Action Destructive ──> Validation Humaine Obliatoire (Risque élevé : push, delete, deploy)
```

---

# Résumé & Schéma global

```text
                      SYSTÈME AGENTIQUE COMPLET
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼                          ▼                          ▼
Cerveau (LLM)               Mains (Outils)            Garde-fous (Humain)
(Planification/Décision)   (Commandes CLI/APIs)       (Permissions & Quotas)
```

# Tableau comparatif : Agent vs RPA

| Critère | Automatisation RPA | Agent LLM |
|---|---|---|
| **Règles** | Strictes & Déterministes (*If/Else*) | Souples & Adaptatives (Langage naturel) |
| **Gestion des erreurs** | Plante sur un imprévu | Tente une stratégie alternative |
| **Cas d'usage idéal** | Processus fixes identiques | Problèmes complexes et ouverts |

# Les 5 points les plus importants

1. **L'agent n'est pas qu'un LLM** : c'est un système unissant modèle, outils et boucle d'action.
2. **La boucle agentique est itérative** : elle s'auto-corrige en fonction des retours d'outils.
3. **Le principe du Human-in-the-loop** exige une confirmation humaine sur les actions critiques.
4. **Des critères d'arrêt sont obligatoires** pour prémunir contre les boucles infinies de tokens.
5. **Le RPA reste préférable pour les processus déterministes** fixes à faible coût.

---

# Carte mentale

```text
Qu'est-ce qu'un agent ?
│
├── Briques Fondamentales
│   ├── Moteur (LLM & Planification)
│   ├── Bras (Outils & Function Calling)
│   └── Mémoire (Contexte & État)
│
├── La Boucle Agentique
│   ├── Plan ──> Action ──> Observation
│   └── Décision de poursuite ou d'arrêt
│
└── Sécurité & Gouvernance
    ├── Human-in-the-loop
    └── Critères d'arrêt & Budget
```

---

# Mini fiche de révision

```text
Boucle Agentique → Planification ──> Action ──> Observation ──> Correction
Human-in-the-loop→ Validation humaine obligatoire sur actions critiques
Critère d'arrêt  → Limite maximale de boucles/tokens
Agent vs RPA     → Agent = Adaptabilité linguistique | RPA = Rigueur déterministe
```

> **Phrase à retenir** : Un agent associe l'intelligence d'un LLM à la capacité d'action des outils, encadré par la vigilance constante de l'humain dans la boucle.
