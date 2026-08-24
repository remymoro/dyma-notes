---
title: "Brancher une session pour tester une variante"
description: "Créer une branche de session afin d’explorer une variante sans perdre le travail courant."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - sessions
  - branche
categories:
  - "Chapitre 9"
cours: Claude Code
chapitre: 09-gestion-sessions-contexte
leçon: 04-brancher-session-tester-variante
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Qu'est-ce que `/branch` ?** | C'est une bifurcation *conversationnelle*. Elle copie l'historique jusqu'au point courant et crée une nouvelle trajectoire (identifiant propre). La session d'origine n'est pas modifiée par les messages ultérieurs. |
| **Le danger principal ?** | La branche isole la conversation, mais elle **ne protège pas les fichiers**. Si Claude modifie le code dans la branche, le disque (le worktree courant) est modifié ! |
| **Quand brancher ?** | Avant une modification risquée (refactorisation) ou pour comparer deux stratégies (ex: réparer localement vs refactoriser complètement), sans polluer la tâche principale. |
| **Différence avec `/clear` ou `/compact` ?** | `/clear` vide la mémoire, `/compact` résume l'historique sans changer de trajectoire. `/branch` garde l'historique complet jusqu'à la bifurcation mais sur une piste isolée. |
| **`/branch` vs `/fork` ?** | `/branch` bifurque la session interactive (vous suivez le chemin). `/fork` lance un sous-agent en tâche de fond (il travaille pendant que vous restez sur la session principale). |

## Synthèse
La commande `/branch` permet d'explorer des variantes (comme une refactorisation risquée ou une hypothèse de debug) sans polluer l'historique de la session principale. Elle clone la trajectoire conversationnelle, permettant de revenir facilement à l'original (via `/resume`) si l'idée n'aboutit pas. Cependant, il y a un piège majeur : `/branch` ne protège **pas** les fichiers sur le disque ! Les modifications effectuées par Claude dans la branche sont appliquées directement sur votre répertoire de travail. C'est pourquoi un branchement doit toujours s'accompagner d'une vérification stricte du `/diff` avant, pendant et après l'essai, afin de documenter ou d'annuler les changements (via git) si besoin.

## Glossaire
- **Branche de session** : Bifurcation de la trajectoire conversationnelle (le contexte est dupliqué, mais avec un nouvel ID).
- **`/branch <nom>`** : Commande interne pour créer une branche et basculer dessus.
- **`--fork-session`** : Argument en ligne de commande (CLI) pour lancer une branche dès le lancement du terminal (`claude -r <nom> --fork-session`).
- **`/fork`** : Commande pour déléguer une tâche secondaire à un sous-agent (sans brancher votre interface interactive).

## Questions d'auto-évaluation
1. Si je crée une `/branch`, que je demande à Claude de supprimer un fichier, puis que je retourne à la session d'origine avec `/resume`, le fichier réapparaîtra-t-il ?
2. Quelle commande Git permet d'éviter la collision des fichiers lors de l'exploration de variantes en parallèle ?
3. Pourquoi est-il fortement recommandé de renommer la session d'origine *avant* de lancer `/branch` ?
4. Quelle est la différence d'usage principale entre `/branch` et `/fork` ?

# Brancher une session pour tester une variante

**Durée : 7 minutes**

## Objectif de la leçon
Comprendre comment utiliser `/branch` pour tester des hypothèses isolées conversationnellement, tout en maîtrisant parfaitement le risque lié à l'absence d'isolation des fichiers réels sur le disque.

---

# 1. Le Piège de l'Isolation vs Disque

```text
  [ SESSION ORIGINALE ]
           │
           ├────────────┐
           │            │  /branch test-refactor
           │            ▼
           │      [ BRANCHE ] -> Claude modifie "api.js"
           │            │
           ▼            ▼
  [ RETOUR ORIGINAL ] (Le fichier "api.js" EST TOUJOURS MODIFIÉ !)

=> L'historique des prompts bifurque, mais le système de fichiers est PARTAGÉ.
```

---

# 5 points de comparaison essentiels

**1. Moment du branchement**
`/branch` est idéal après l'analyse, lorsqu'un point de décision apparaît, et avant les modifications expérimentales. Le piège est de brancher trop tôt, avant d’avoir construit le diagnostic.

**2. `/branch` vs Worktree Git**
`/branch` isole la conversation.
Worktree Git isole les fichiers.
Si deux variantes modifient les mêmes fichiers indépendamment, `/branch` seul ne suffit pas.

**3. `/branch` vs `--fork-session`**
Déjà dans Claude Code → `/branch`
Depuis le terminal → `--fork-session` (Exemple : `claude --resume "auth-refactor" --fork-session`)

**4. `/clear` vs `/branch`**
`/clear` → nouvelle tâche (contexte vide).
`/branch` → même tâche (contexte conservé, autre trajectoire).

**5. `/compact` vs `/branch`**
`/compact` → réduit le contexte (même trajectoire).
`/branch` → crée une autre trajectoire (historique conservé jusqu'au branchement).

---

# Fiche de synthèse (Notions clés)

| Catégorie | Notion | Rôle |
|---|---|---|
| Session | `/branch` | Créer une nouvelle trajectoire à partir de la conversation actuelle |
| Contexte | Branche de session | Conserver l’historique jusqu’au point de bifurcation |
| Nouvelle tâche | `/clear` | Repartir avec un contexte vide |
| Contexte | `/compact` | Réduire l’historique en restant dans la même trajectoire |
| Fichiers | Worktree Git | Isoler physiquement les variantes de code |
| Contrôle | `/diff` | Observer les modifications de fichiers |
| Permissions | Approbations temporaires | Ne suivent pas automatiquement dans une branche |
| Permissions | Règles persistantes | Continuent de s’appliquer |
| Navigation | `/resume` | Reprendre une session existante |
| Organisation | `/rename` | Donner un nom identifiable à une session |
| Terminal | `--fork-session` | Créer une session dérivée lors d’un `--resume` ou `--continue` |
| Sous-agent | `/fork <directive>` | Déléguer une tâche sans quitter la session principale |
| Méthode | Point de branchement | Définir précisément ce qui va être testé |
| Méthode | Bilan de branche | Comparer et décider de conserver ou abandonner la variante |

---

# Cartes mentales

## 1. Brancher une session

```text
                 BRANCHER UNE SESSION
                         │
                         ▼
                      /branch
                         │
             copie de la conversation
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
        session originale      nouvelle branche
          conservée                 │
                                    ▼
                             tester une variante


Attention :
conversation isolée ≠ fichiers isolés

           /branch                    Worktree Git
              │                            │
              ▼                            ▼
       conversation                  fichiers séparés
```

## 2. Autres commandes

```text
AUTRES COMMANDES
│
├── /clear
│   └── nouvelle tâche / contexte vide
│
├── /compact
│   └── réduire le contexte
│
├── /resume
│   └── reprendre une session
│
├── --fork-session
│   └── brancher depuis le terminal
│
└── /fork
    └── déléguer à un sous-agent
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
1. ANALYSER
      ↓
2. IDENTIFIER LE POINT DE DÉCISION
      ↓
3. /rename
      ↓
4. /diff + /context
      ↓
5. /branch nom-explicite
      ↓
6. TESTER UNE SEULE STRATÉGIE
      ↓
7. TESTS CIBLÉS
      ↓
8. /diff
      ↓
9. BILAN
      ↓
10. /resume
```

> **La phrase centrale de toute la leçon :**
> `/branch` isole la conversation, pas les fichiers.
