---
title: "Composition et gestion du contexte"
description: "Comprendre la composition, la gestion et l'optimisation de la fenêtre de contexte d'un LLM."
date: 2026-08-14
draft: true
tags:
  - intelligence-artificielle
  - contexte
  - llm
categories:
  - "Chapitre 2"
cours: Claude Code
chapitre: 02-comprendre-intelligence-artificielle-generative
leçon: 04-composition-gestion-contexte
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce que la fenêtre de contexte ? | Limite maximale de tokens (entrée et sortie) traitée lors d'un appel. Mémoire RAM temporaire. |
| Qu'inclut la fenêtre de contexte ? | Prompts, historique complet, fichiers attachés, retours d'outils et marge de réponse. |
| Qu'est-ce que le taux utile ? | Ratio de remplissage prenant en compte les données injectées plus la marge de sortie prévue. |
| Quels sont les risques de saturation (>85%) ? | Lenteur, hausse des coûts, erreurs et **dilution de l'attention** (perte d'informations clés). |
| Comment compresser le contexte ? | Résumés d'historique, extraction de contraintes, RAG et suppression de données inutiles. |
| Pourquoi une grande fenêtre ne suffit pas ? | Une grande capacité n'empêche pas le bruit et ne garantit pas la qualité de récupération sémantique. |

## Synthèse
La fenêtre de contexte agit comme la mémoire de travail (RAM) d'un LLM. Pour éviter sa saturation (qui provoque la dilution de l'attention, de la latence et un surcoût), il est essentiel de contrôler son taux utile et d'appliquer des stratégies de compression (RAG, compaction, résumés).

## Glossaire
- **Compaction** : Stratégie visant à résumer l'historique d'une session pour libérer des tokens dans le contexte.
- **Fenêtre de contexte** : Capacité maximale en tokens qu'un modèle peut lire et écrire en une seule fois.
- **RAG (Retrieval-Augmented Generation)** : Technique d'injection dynamique des seuls passages de documents pertinents.
- **Taux utile** : Indicateur mesurant le remplissage réel du contexte en incluant la réponse estimée.

## Questions d'auto-évaluation
1. Pourquoi chaque nouveau message dans une conversation réinjecte-t-il la totalité de l'historique précédent ?
2. Quel phénomène physique se produit lorsque le taux utile du contexte dépasse 85% ?
3. Pourquoi conseille-t-on de toujours placer les consignes de travail à la toute fin d'un prompt contenant de grands fichiers ?
4. Quelle est la différence entre la capacité brute de la fenêtre et la précision de récupération (retrieval) ?

# Composition et gestion du contexte

**Durée : 13 minutes**

## Objectif de la leçon
Comprendre la composition de la fenêtre de contexte, mesurer son taux de remplissage utile et maîtriser les techniques d'optimisation.

---

# 1. Anatomie de la Fenêtre de Contexte

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    COMPOSITION DU CONTEXTE (RAM)                        │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │ 1. SYSTEM PROMPT  : Consignes & rôles de base                     │  │
│  │ 2. HISTORIQUE     : Échanges passés de la session                 │  │
│  │ 3. DOCUMENTS      : Code source, fichiers joints, retours MCP     │  │
│  │ 4. PROMPT ACTUEL  : Question / instruction finale                 │  │
│  │ 5. MARGE SORTIE   : Espace réservé à la réponse (ex: 4000 tokens) │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Les Niveaux de Remplissage (Taux Utile)

```text
[ < 40%  ] ──> Zone de Confort (Attention maximale, réponse rapide)
[ 40-70% ] ──> Densité Neutre (Surveiller l'accumulation de code)
[ 70-85% ] ──> Zone Dense (Risque de baisse de précision et hausse de coût)
[  > 85% ] ──> Saturation (Dilution d'attention, risque de rejet)
```

---

# Résumé & Schéma global

```text
                     GESTION DU CONTEXTE LLM
                                │
      ┌─────────────────────────┼─────────────────────────┐
      ▼                         ▼                         ▼
   Mesure                    Bruit                     Solutions
(Taux Utile < 85%)     (Dilution d'attention)   (Compaction, RAG, /compact)
```

# Tableau des stratégies de compression

| Technique | Description |
|---|---|
| **Compaction** | Résumer l'historique conversationnel en conservant les faits essentiels. |
| **RAG** | Ne charger dans le contexte que les fragments de fichiers nécessaires. |
| **Positionnement** | Placer la consigne critique tout à la fin du prompt pour maximiser l'attention. |

# Les 5 points les plus importants

1. **La fenêtre de contexte est une mémoire RAM temporaire**, pas un stockage permanent.
2. **Tout l'historique est réenvoyé à chaque prompt**, consommant progressivement le quota.
3. **Le taux utile inclut la marge réservée à la réponse** ($\text{Entrée} + \text{Sortie} \le \text{Limite}$).
4. **La saturation (>85%) dilue l'attention** du modèle et augmente la latence.
5. **Placer les consignes à la fin du prompt** garantit un meilleur suivi des instructions.

---

# Carte mentale

```text
Composition & Contexte
│
├── Composition
│   ├── System prompt & Historique
│   ├── Fichiers & Retours d'outils
│   └── Marge de sortie réservée
│
├── Risques de saturation
│   ├── Lenteur & Coût
│   └── Dilution de l'attention
│
└── Stratégies d'optimisation
    ├── Compaction / Résumé
    ├── RAG (Injection ciblée)
    └── Positionnement à la fin
```

---

# Mini fiche de révision

```text
Fenêtre de contexte → Mémoire RAM temporaire en tokens
Taux utile          → (Entrée + Marge Sortie) / Capacité totale
Dilution            → Perte de précision si contexte trop encombré
Compaction          → Résumé d'historique pour libérer du contexte
```

> **Phrase à retenir** : Plus la fenêtre de contexte est encombrée de bruit, moins l'attention du modèle est précise sur vos consignes essentielles.
