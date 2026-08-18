---
title: "L’économie des tokens et la facturation"
description: "Comprendre la structure des coûts des LLM : input vs output tokens, prompt caching et batch processing."
date: 2026-08-14
draft: true
tags:
  - intelligence-artificielle
  - tokens
  - facturation
  - api
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 06-economie-tokens-facturation
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Comment est mesurée la consommation API ? | En **tokens** (jetons) par million. Tarifs distincts pour l'entrée (Input) et la sortie (Output). |
| Pourquoi les Output Tokens sont-ils plus chers ? | Coûtent **3x à 5x plus cher** car la génération auto-régressive exige un calcul pas-à-pas à l'inférence. |
| Qu'incluent les Input Tokens ? | System prompt, historique complet du chat, fichiers attachés et retours d'outils. |
| Quels sont les coûts cachés des agents ? | Boucle fermée de réflexion et d'outils générant de multiples sous-requêtes automatiques. |
| Qu'est-ce que le Prompt Caching ? | Stockage temporaire en mémoire des prompts stables réduisant le coût d'entrée jusqu'à **-90%**. |
| Qu'est-ce que le Batch Processing ? | Envoi de tâches de masse non urgentes (exécutées sous 24h) avec une remise de **-50%**. |

## Synthèse
L'économie des LLM repose sur la facturation au million de tokens. Les tokens de sortie (Output) sont nettement plus chers que ceux d'entrée (Input) car ils requièrent un calcul de génération pas-à-pas. Pour maîtriser le budget des projets agentiques, il est crucial d'utiliser le *Prompt Caching* (-90% sur l'entrée répétée) et le *Batch Processing* (-50% sur les tâches de fond).

## Glossaire
- **Batch Processing** : Exécution de traitements de masse asynchrones sous 24 heures bénéficiant d'une réduction de 50%.
- **Input Tokens** : Tokens transmis au modèle (prompts, historique, contexte, fichiers).
- **Output Tokens** : Tokens générés et écrits par le modèle en réponse.
- **Prompt Caching** : Mise en cache serveur d'un segment de prompt stable évitant sa re-facturation lors des requêtes suivantes.

## Questions d'auto-évaluation
1. Pourquoi un agent en boucle autonome peut-il consommer beaucoup plus de tokens que prévu par l'utilisateur ?
2. Quelle économie exacte le Prompt Caching apporte-t-il sur les tokens d'entrée mis en cache ?
3. Quelle est la différence de facturation entre les tokens d'entrée et les tokens de sortie ?
4. Dans quel cas d'usage professionnel le Batch Processing est-il particulièrement recommandé ?

# L’économie des tokens et la facturation

## Objectif de la leçon
Comprendre la tarification de l'API Claude, identifier les leviers d'optimisation financière (Caching & Batching) et anticiper les coûts des agents.

---

# 1. Structure de Coût d'un Appel API

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      STRUCTURE DE TARIFICATION API                      │
│                                                                         │
│  [Input Tokens (Lecture)]   ──> Tarif de base (ex: 3$ / 1M tokens)    │
│  [Output Tokens (Génération)]──> Tarif 3x-5x plus cher (ex: 15$ / 1M)  │
│  [Prompt Caching (Cache Hit)]──> Réduction jusqu'à -90%                 │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Les Leviers d'Optimisation du Budget

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      OPTIMISATION FINANCIÈRE                            │
│                                                                         │
│  PROMPT CACHING   : Idéal pour les gros fichiers/doc stables (-90%)     │
│  BATCH PROCESSING : Idéal pour les analyses de masse à H+24 (-50%)      │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                    ÉCONOMIE DES TOKENS & BUDGET
                                │
      ┌─────────────────────────┼─────────────────────────┐
      ▼                         ▼                         ▼
  Composition              Asymétrie                 Optimisation
(Input vs Output)     (Output 3x-5x plus cher)     (Caching & Batching)
```

# Tableau récapitulatif des remises

| Mécanisme | Domaine d'application | Réduction |
|---|---|---|
| **Prompt Caching** | Contexte système & docs stables réutilisés | Jusqu'à -90% sur l'entrée |
| **Batch Processing** | Traitement par lots sous 24h | -50% sur l'ensemble |
| **Sélection Modèle** | Passer de Sonnet à Haiku pour les sous-tâches | Jusqu'à -80% du coût global |

# Les 5 points les plus importants

1. **Les tokens de sortie coûtent 3 à 5 fois plus cher** que les tokens d'entrée.
2. **Tout l'historique est facturé** à chaque nouveau message d'une session.
3. **Les agents autonomes génèrent des boucles** qui multiplient la consommation de tokens.
4. **Le Prompt Caching réduit jusqu'à 90%** le coût de relecture des gros documents.
5. **Le Batch Processing divise par 2 le coût** des tâches qui ne nécessitent pas de réponse immédiate.

---

# Carte mentale

```text
Économie des Tokens
│
├── Facturation de base
│   ├── Input tokens (Lecture contexte)
│   └── Output tokens (Génération 3x-5x plus chère)
│
├── Consommation Agentique
│   ├── Envoi récurrent de l'historique
│   └── Boucles d'outils automatiques
│
└── Outils d'optimisation
    ├── Prompt Caching (-90% sur l'entrée)
    └── Batch Processing (-50% sous 24h)
```

---

# Mini fiche de révision

```text
Input Tokens    → Tokens lus en entrée (Moins cher)
Output Tokens   → Tokens générés en sortie (3x à 5x plus cher)
Prompt Caching  → Économise jusqu'à 90% sur les contextes récurrents
Batching        → Économise 50% sur les tâches traitées sous 24h
```

> **Phrase à retenir** : Pour maîtriser les coûts en environnement de production, optimisez l'entrée grâce au Prompt Caching et réservez les tokens de sortie aux seules réponses nécessaires.
