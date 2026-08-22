---
title: "Les bonnes pratiques d'utilisation des LLM"
description: "Maîtriser la structuration des prompts, la densité informationnelle et le chaînage de requêtes."
date: 2026-08-15
draft: true
tags:
  - llm
  - prompts
  - bonnes-pratiques
categories:
  - "Chapitre 3"
cours: Claude Code
chapitre: 03-fonctionnalites-limites-bonnes-pratiques
leçon: 03-bonnes-pratiques-utilisation-llm
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce que la densité informationnelle ? | Rapport entre informations opérationnelles (contraintes, règles) et volume total du prompt. |
| Qu'est-ce qu'un contexte pur ? | Un contexte filtré sans bavardage, doublons ni données obsolètes. |
| Pourquoi limiter à une tâche unique ? | Réduit l'omission de consignes et les réponses vagues. Chaîner les requêtes complexes. |
| Quel est le modèle de prompt universel ? | **Contexte Pur** + **Tâche Unique** + **Contraintes Explicites** + **Format Attendu**. |
| Pourquoi utiliser des exemples (Few-Shot) ? | L'IA imite la structure des exemples fournis beaucoup mieux qu'une consigne abstraite. |

## Synthèse
Pour maximiser la précision d'un LLM, les prompts doivent être denses (chaque mot compte) et purs (libres de tout bruit). La méthode recommandée repose sur le découpage en tâches uniques, l'utilisation du modèle universel (Contexte + Tâche + Contraintes + Format) et l'illustration par des exemples concrets (Few-Shot).

## Glossaire
- **Chaînage de prompts** : Découpage d'un processus complexe en une suite d'instructions étape par étape.
- **Densité informationnelle** : Qualité d'un prompt contenant un maximum de consignes claires par token.
- **Few-Shot Prompting** : Technique consistant à insérer un ou deux exemples de sorties modèles dans le prompt.
- **Prompt Universel** : Structure standard d'instruction (Contexte, Tâche, Contraintes, Format).

## Questions d'auto-évaluation
1. Pourquoi un prompt très long n'est-il pas forcément un bon prompt ?
2. Quels sont les 4 composants essentiels de la structure universelle d'un prompt efficace ?
3. Pourquoi le chaînage de prompts produit-il de meilleurs résultats qu'une demande unique multi-tâches ?
4. En quoi le *Few-Shot Prompting* améliore-t-il la conformité des formats de sortie (comme du JSON ou un tableau) ?

# Les bonnes pratiques d'utilisation des LLM

**Durée : 18 minutes**

## Objectif de la leçon
Apprendre à concevoir des prompts denses et structurés pour obtenir des réponses précises, reproductibles et adaptées à l'environnement professionnel.

---

# 1. La Structure Universelle du Prompt Efficace

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    LE MODÈLE UNIVERSEL DE PROMPT                        │
│                                                                         │
│  1. CONTEXTE PUR   : Données fiables, fichiers, extrait précis          │
│  2. TÂCHE UNIQUE   : Verbe d'action clair (Rédige, Extrais, Refactore)  │
│  3. CONTRAINTES    : Limites, règles de code, éléments à exclure        │
│  4. FORMAT        : Exemple visuel, tableau, JSON, liste                │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Chaînage de Prompts vs Prompt Unique Complexe

```text
Prompt unique surchargé  ──> [Analyse + Architecture + Code + Tests] ──> Risque d'oubli & erreurs

Chaînage séquentiel      ──> 1. [Analyse] ──> 2. [Architecture] ──> 3. [Code] ──> 4. [Tests]
                             (Précision maximale à chaque étape)
```

---

# Résumé & Schéma global

```text
                  OPTIMISATION DE L'INGÉNIERIE DE PROMPTS
                                     │
       ┌─────────────────────────────┼─────────────────────────────┐
       ▼                             ▼                             ▼
Contexte Pur & Dense            Tâche Unique & Chaînage      Exemples (Few-Shot)
(Zéro bruit / Zéro bavardage)   (Étape par étape)            (Modèle de sortie)
```

# Tableau des bonnes pratiques

| Pratique | Mauvaise approche | Bonne approche |
|---|---|---|
| **Contexte** | Déposer 100 pages de doc brute sans tri. | Extraire les 3 pages pertinentes pour la tâche. |
| **Périmètre** | "Fais l'application complète." | "Écris la fonction d'authentification JWT." |
| **Format** | "Formatte bien la réponse." | Insérer un exemple Markdown ou JSON exact. |
| **Vérification** | "Es-tu sûr de toi ?" | "Isole tes certitudes et tes points à vérifier." |

# Les 5 points les plus importants

1. **La densité informationnelle prime sur la longueur** : éliminez le bavardage superflu.
2. **Fournissez un contexte pur** exempt de contradictions ou de vieilles versions.
3. **Limitez chaque prompt à une tâche unique** et enchaînez les étapes.
4. **Appliquez la formule à 4 blocs** : Contexte + Tâche + Contraintes + Format.
5. **Utilisez le Few-Shot Prompting** (exemples concrets) pour verrouiller le format.

---

# Carte mentale

```text
Bonnes Pratiques de Prompting
│
├── Contexte & Contenu
│   ├── Densité informationnelle
│   └── Contexte pur (RAG / Sélection)
│
├── Structuration
│   ├── Modèle à 4 blocs (Contexte/Tâche/Contrainte/Format)
│   └── Tâche unique & Chaînage
│
└── Contrôle de la Sortie
    ├── Few-Shot (Exemples)
    └── Isolation des hypothèses
```

---

# Mini fiche de révision

```text
Contexte pur       → Données fiables sans bruit
Tâche unique       → 1 seule action principale par prompt
4 Blocs            → Contexte + Tâche + Contraintes + Format
Few-Shot           → Donner un exemple pour verrouiller la structure
```

> **Phrase à retenir** : La qualité de la réponse d'une IA ne dépend pas de la longueur de la question, mais de la pureté du contexte et de la clarté du format exigé.
