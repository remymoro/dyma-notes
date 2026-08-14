---
title: "Fonctionnement d’un LLM"
description: "Comprendre les principes de fonctionnement d’un grand modèle de langage."
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
etape_revision: 1
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce qu'un LLM et comment fonctionne-t-il ? | *Large Language Model* : modèle statistique entraîné à traiter et générer du langage. Il reçoit un contexte, le convertit en nombres, calcule des relations, puis prédit la suite token par token. |
| Qu'est-ce qu'un Token et la Tokenization ? | **Token** : Unité de base de texte (mot, partie de mot, ponctuation).<br>**Tokenization** : Découpage du texte en tokens représentés par des **identifiants** (numéros uniques). |
| Quelle différence entre Identifiant et Embedding ? | **Identifiant** : Nombre servant à *reconnaître* le token (ex: 9021).<br>**Embedding** : Liste de nombres (vecteur) beaucoup plus riche servant à *manipuler mathématiquement* le sens et comparer sa proximité avec d'autres mots. |
| À quoi sert l'auto-attention (Self-attention) ? | Permet à chaque token de "regarder" les autres tokens du même contexte pour adapter sa représentation interne selon les mots qui l'entourent (ex: distinguer *"avocat"* fruit vs juridique). |
| Comment marche l'attention avec Query, Key, Value ? | **Query (Q)** : Ce que le modèle cherche à comprendre.<br>**Key (K)** : Les étiquettes d'informations du contexte.<br>**Value (V)** : Le contenu informatif récupéré si Query correspond à Key. |
| Pourquoi un LLM n'est pas une base de données ? | Une base de données stocke des données exactes sous forme de tables. Un LLM **compresse des régularités statistiques** ; il n'a pas de copie conforme et peut donc générer des réponses plausibles mais fausses (**hallucinations**). |

## Synthèse
Un LLM ne pense pas de manière consciente : c'est un prédicteur statistique de tokens. Il transforme le texte d'entrée en tokens puis en vecteurs (embeddings), y ajoute la position, calcule les relations de sens via le mécanisme d'attention du Transformer, et génère le mot suivant le plus probable couche après couche. Pour garantir l'exactitude des informations, il faut lui fournir les données brutes directement dans son contexte.

## Glossaire
- **Embedding** : Traduction mathématique d'un token sous forme de liste de nombres (vecteur).
- **Logits** : Scores bruts calculés par le modèle pour chaque token avant conversion en probabilités.
- **Positional encoding** : Encodage de position ajouté aux embeddings pour que le modèle comprenne l'ordre des mots.
- **Sampling & Temperature** : Méthode et paramètre de sélection du token suivant influençant le degré de variabilité (créativité/stabilité) de la réponse.
- **Softmax** : Fonction mathématique convertissant les logits en distribution de probabilités (somme égale à 100%).
- **Token** : Morceau de texte minimal manipulé par le modèle (environ 4 caractères en moyenne).

## Questions d'auto-évaluation
1. Pourquoi un mot rare ou long comme *"internationalisation"* est-il découpé en plusieurs tokens ?
2. Quelle est la différence entre l'attention et l'auto-attention (self-attention) ?
3. Quel est l'impact d'une température très élevée (ex: 1.5) sur la génération d'une réponse ?

# Fonctionnement d’un LLM

**Durée : 21 minutes**

## Notes

Voici le schéma récapitulatif de l'architecture Transformer et de son flux de traitement :

![Architecture Transformer](assets/transformer-architecture.jpg)

## Points clés

- Un LLM découpe le texte en **tokens** puis les convertit en **embeddings** (vecteurs numériques).
- L'ordre des mots est conservé grâce au **Positional Encoding**.
- Le **Transformer** utilise l'**attention** (et le système Query/Key/Value) pour calculer l'importance relative de chaque mot du contexte.
- La génération se fait pas à pas en convertissant les **logits** en probabilités (**softmax**) puis en effectuant un **sampling** influencé par la **temperature**.
- Le LLM n'étant ni une base de données ni un moteur de recherche, il compresse des régularités et peut halluciner. Il faut lui fournir les données dont on souhaite être sûr.
