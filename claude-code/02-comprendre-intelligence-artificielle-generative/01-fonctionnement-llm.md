---
title: "Fonctionnement d’un LLM"
description: "Comprendre le fonctionnement interne des grands modèles de langage : tokenization, embeddings, attention et génération."
date: 2026-08-14
draft: true
tags:
  - intelligence-artificielle
  - llm
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 01-fonctionnement-llm
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce qu'un LLM et comment fonctionne-t-il ? | *Large Language Model* : modèle statistique entraîné à prédire la suite d'un texte token par token à partir d'un contexte. |
| Qu'est-ce qu'un Token et la Tokenization ? | **Token** : Unité minimale de texte (~4 caractères).<br>**Tokenization** : Découpage du texte brut en identifiants numériques. |
| Quelle différence entre Identifiant et Embedding ? | **Identifiant** : Numéro unique servant de référence à un token.<br>**Embedding** : Vecteur numérique capturant le sens sémantique et les relations. |
| À quoi sert l'auto-attention (Self-attention) ? | Permet à chaque token de peser l'importance des autres tokens du contexte pour lever les ambiguïtés sémantiques. |
| Comment marche l'attention (Query, Key, Value) ? | **Query (Q)** : Ce que le mot cherche.<br>**Key (K)** : L'étiquette de chaque mot du contexte.<br>**Value (V)** : L'information transmise si Q et K correspondent. |
| Pourquoi un LLM n'est pas une base de données ? | Un LLM compresse des relations statistiques. Sans données exactes injectées dans son contexte, il risque d'halluciner. |

## Synthèse
Un LLM ne pense pas de manière consciente : c'est un prédicteur statistique de tokens. Il découpe le texte d'entrée en tokens, les convertit en vecteurs d'embeddings enrichis d'un encodage positionnel, calcule les relations de sens via le mécanisme d'attention du Transformer, puis génère le mot suivant le plus probable via Softmax et Sampling.

## Glossaire
- **Embedding** : Vectorisation mathématique représentant la signification d'un token dans un espace multidimensionnel.
- **Logits** : Scores numériques bruts générés par le modèle pour chaque token du vocabulaire avant conversion probabiliste.
- **Positional Encoding** : Technique injectant l'information de position et d'ordre des mots dans les vecteurs d'embeddings.
- **Softmax** : Fonction mathématique convertissant les logits bruts en une distribution de probabilités dont la somme vaut 100%.

## Questions d'auto-évaluation
1. Pourquoi le mot *"internationalisation"* est-il découpé en plusieurs tokens distincts par le tokenizer ?
2. Quelle est la différence fondamentale entre l'identifiant d'un token et son vecteur d'embedding ?
3. Quel rôle la température joue-t-elle dans le choix final du token lors du sampling ?
4. Pourquoi les hallucinations se produisent-elles et comment les éviter ?

# Fonctionnement d’un LLM

**Durée : 21 minutes**

## Objectif de la leçon
Comprendre le cycle de traitement de l'information au sein d'un modèle Transformer, de la saisie utilisateur jusqu'à la génération du token final.

---

# 1. Le Pipeline de Traitement des LLMs

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      PIPELINE DE GÉNÉRATION LLM                         │
│                                                                         │
│  [Prompt Brut] ──> [Tokenization] ──> [Embeddings + Position]           │
│                                                     │                   │
│  [Token Sortie] <── [Softmax / Temp] <── [Attention (Q, K, V)] ◄──────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Mécanisme d'Attention (Query, Key, Value)

L'auto-attention permet de relier les mots entre eux selon le contexte :

```text
  Query (Ce qu'on cherche)   ──────┐
                                   ├──> Score d'Attention ──> Value Retenue
  Key (Ce qui est présent)   ──────┘
```

---

# Résumé & Schéma global

```text
                    MÉCANIQUE DU TRANSFORMER
                               │
      ┌────────────────────────┼────────────────────────┐
      ▼                        ▼                        ▼
  Input Tokenized         Self-Attention            Probabilités
(Mots → Identifiants)   (Contexte & Sens)       (Logits → Softmax)
```

# Tableau des étapes

| Étape | Action |
|---|---|
| **1. Tokenization** | Découpage du texte en morceaux minimaux (tokens). |
| **2. Embedding** | Conversion des tokens en vecteurs numériques sémantiques. |
| **3. Attention** | Pondération de l'importance de chaque mot du contexte (Q, K, V). |
| **4. Sampling** | Sélection du token de sortie selon la température et les probabilités. |

# Les 5 points les plus importants

1. **Un LLM prédit des tokens**, pas des mots ou des concepts abstraits conscients.
2. **La tokenization découpe les mots** en sous-unités d'environ 4 caractères.
3. **Les embeddings traduisent les mots en géométrie** dans un espace vectoriel.
4. **Le mécanisme d'attention** détermine l'importance relative de chaque mot du contexte.
5. **Un LLM n'est pas une base de données** : il compresse des probabilités et peut halluciner.

---

# Carte mentale

```text
Fonctionnement d'un LLM
│
├── Entrées & Représentation
│   ├── Tokenization (ID)
│   └── Embeddings & Position
│
├── Cœur du Transformer
│   ├── Auto-attention
│   └── Système Query / Key / Value
│
└── Génération
    ├── Logits & Softmax
    └── Température & Sampling
```

---

# Mini fiche de révision

```text
Token              → ~4 caractères / morceau de mot
Embedding          → Vecteur numérique sémantique
Self-Attention     → Lien de sens entre les mots du contexte
Softmax / Sampling → Conversion des scores en token final
```

> **Phrase à retenir** : Un LLM est un prédicteur statistique de tokens extrêmement sophistiqué, pas une base de données de vérités factuelles.
