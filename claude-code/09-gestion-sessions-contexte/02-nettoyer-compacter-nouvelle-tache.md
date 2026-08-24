---
title: "Nettoyer, compacter ou repartir sur une nouvelle tâche"
description: "Gérer le contexte courant et repartir proprement selon les besoins de la tâche."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - contexte
  - sessions
categories:
  - "Chapitre 9"
cours: Claude Code
chapitre: 09-gestion-sessions-contexte
leçon: 02-nettoyer-compacter-nouvelle-tache
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pollution du contexte ?** | (*Context rot*) L'accumulation d'anciennes pistes abandonnées, d'erreurs ou de changements de sujet dans l'historique. Cause des hallucinations ou des "oublis". |
| **`/clear` (ou `/new`) ?** | Efface l'historique et démarre un nouveau contexte. À utiliser quand **la tâche change** (ex: on passe du debug à la doc) ou après **2 échecs répétés** de l'agent. |
| **`/compact` ?** | Résume l'historique pour regagner du budget, **sans changer de tâche**. Une compaction perd des détails : donnez des consignes (`/compact Garde X et Y`). |
| **`## Compaction` dans `CLAUDE.md` ?** | On peut définir dans ce fichier les règles globales de ce qu'il faut toujours préserver (ex: fichiers modifiés) et toujours supprimer (ex: pistes réfutées) lors d'une compaction. |
| **`/btw` ?** | (*By the way*) Permet de poser une question hors-historique (elle ne sera pas sauvegardée dans le contexte). Très utile pour demander une info rapide sans polluer. |
| **`/recap` ?** | Affiche le "résumé court" de la direction actuelle de la session. Si ce résumé n'a plus de sens avec ce que vous faites, c'est qu'il faut nettoyer. |

## Synthèse
La gestion de la fenêtre de contexte repose sur deux actions clés pour éviter la "pollution" (*context rot*) : le nettoyage total (`/clear`) et la compaction (`/compact`). Chaque nouvelle tâche (ou après deux échecs successifs) justifie un `/clear` suivi d'un nouveau brief précis incluant les leçons apprises. Si la tâche est continue mais longue (seuil d'alerte vers 40-60%), `/compact` permet de résumer l'historique pour regagner du budget. Une compaction n'est jamais neutre : guidez-la en précisant ce qui doit être conservé ou ignoré, par exemple via une section `## Compaction` dans `CLAUDE.md`. Enfin, la commande `/btw` permet d'obtenir des informations rapides sans encombrer la session.

## Glossaire
- **Context rot (Pollution)** : Détérioration des réponses due à un contexte encombré par des erreurs répétées ou des changements de sujet.
- **`/clear` (ou `/new`, `/reset`)** : Purge la session actuelle et démarre un nouveau contexte vierge.
- **`/compact`** : Transforme les anciens échanges en un résumé structuré pour regagner de l'espace.
- **`/btw`** : Commande pour poser une question "hors contexte" (ne s'ajoute pas à l'historique principal).
- **`/recap`** : Génère un mini-résumé (une ligne) de la direction de la session.

## Questions d'auto-évaluation
1. Après deux tentatives infructueuses de Claude pour corriger un bug, devez-vous demander une troisième correction dans le même prompt ?
2. Quelle est la différence majeure entre `/clear` et `/compact` ?
3. Est-il judicieux d'utiliser `/btw` pour dire à Claude d'ignorer un fichier pour le reste de la tâche ?
4. Comment s'assurer que Claude ne supprime pas la liste des fichiers lus lors d'une compaction automatique ou manuelle ?

# Nettoyer, compacter ou repartir sur une nouvelle tâche

**Durée : 14 minutes**

## Objectif de la leçon
Savoir repérer la pollution du contexte et utiliser les bonnes commandes de nettoyage (`/clear`, `/compact`, `/btw`) pour garantir que Claude Code dispose toujours des informations les plus claires et pertinentes possibles pour la tâche en cours.

---

# 1. Plan de Décision (Nettoyage vs Compaction)

```text
  [ Évaluation de la Session ] -> observer via /context et /recap
             │
      La tâche a-t-elle changé ?
      (ou Claude a-t-il échoué 2 fois ?)
        /           \
     OUI             NON
      │               │
  [ /clear ]      Le contexte est-il > 60% ?
      │               │
  (Nouveau Brief)    OUI
                      │
                  [ /compact avec consigne ]
```

---

# Tableau des commandes à retenir

| Commande | Rôle |
|---|---|
| `/clear` | Efface le contexte (nouvelle tâche = nouvelle session). |
| `/compact` | Résume le contexte (même tâche mais budget trop lourd). |
| `/btw` | Question rapide (hors historique, pour ne pas polluer). |
| `/recap` | Vérification de l'objectif courant (1 ligne). |
| `/context` | Analyse détaillée de l'usage du budget de contexte. |

# Les 5 points les plus importants

1. **Une tâche = une session** : Utilisez `/clear` pour isoler vos tâches (Debug ≠ Documentation).
2. Après **2 échecs** consécutifs sur un même problème, purgez avec `/clear` et rédigez un nouveau brief incluant ce que vous avez appris ("voici ce qu'il ne faut pas refaire").
3. Une **compaction** n'est pas neutre (perte de détails). Accompagnez toujours `/compact` d'une consigne ("Garde X, ignore Y").
4. N'utilisez **jamais** `/btw` pour donner des instructions ou modifier des contraintes, car elles n'entreront pas dans la mémoire de la session.
5. Vous pouvez inclure une section `## Compaction` dans votre fichier `CLAUDE.md` pour forcer la conservation d'éléments critiques lors des compactages.

---

# Carte mentale

```text
GESTION DU CONTEXTE DANS CLAUDE CODE
│
├── 1. Pollution du contexte — context rot
│   │
│   ├── Causes
│   │   ├── anciennes informations
│   │   ├── informations contradictoires
│   │   ├── pistes abandonnées
│   │   ├── tâches différentes mélangées
│   │   └── sorties / discussions devenues inutiles
│   │
│   ├── Conséquences
│   │   ├── retour vers une mauvaise piste
│   │   ├── oubli d'une contrainte récente
│   │   ├── mélange de plusieurs objectifs
│   │   └── modification hors périmètre
│   │
│   └── Principe central
│       └── pertinence du contexte > pourcentage utilisé
│
├── 2. Observer la session
│   │
│   ├── /context
│   │   ├── montre l'utilisation de la fenêtre de contexte
│   │   └── diagnostic détaillé
│   │
│   ├── statusline
│   │   └── signal permanent du niveau de contexte
│   │
│   └── /recap
│       ├── résumé d'une ligne de la session
│       └── vérifie si la session suit encore le bon objectif
│
├── 3. Décider
│   │
│   └── Question principale :
│       "L'historique aide-t-il encore la tâche actuelle ?"
│
│       ├── OUI
│       │   ├── contexte encore léger
│       │   │   └── continuer
│       │   │
│       │   └── contexte devenu lourd
│       │       └── /compact
│       │
│       └── NON
│           └── /clear + nouveau brief
│
├── 4. /compact — Continuer la même tâche
│   │
│   ├── Rôle
│   │   └── résumer l'historique pour libérer du contexte
│   │
│   ├── Important
│   │   └── synthèse avec perte
│   │
│   ├── À préserver
│   │   ├── objectif actuel
│   │   ├── fichiers concernés
│   │   ├── fichiers modifiés
│   │   ├── contraintes
│   │   ├── décisions prises
│   │   ├── tests exécutés
│   │   ├── résultats des tests
│   │   ├── erreurs restantes
│   │   ├── points non vérifiés
│   │   └── prochaine action
│   │
│   └── À réduire / ignorer
│       ├── pistes abandonnées
│       ├── hypothèses réfutées
│       ├── anciennes commandes inutiles
│       ├── longs logs déjà résumés
│       ├── discussions latérales
│       └── explications devenues inutiles
│
├── 5. /clear — Repartir proprement
│   │
│   ├── Rôle
│   │   └── nouvelle conversation avec contexte vide
│   │
│   ├── Alias
│   │   ├── /reset
│   │   └── /new
│   │
│   ├── Ancienne session
│   │   └── reste accessible avec /resume
│   │
│   └── Utiliser quand
│       ├── nouvelle tâche réelle
│       ├── debug → documentation
│       ├── exploration → implémentation
│       ├── trop de sujets mélangés
│       ├── plusieurs mauvaises pistes
│       ├── deux corrections déjà effectuées
│       └── besoin d'un brief entièrement contrôlé
│
├── 6. Échecs répétés
│   │
│   ├── 1re erreur
│   │   └── corriger clairement
│   │
│   ├── 2e erreur
│   │   └── corriger une dernière fois
│   │
│   └── Nouvelle tentative nécessaire
│       ├── /clear
│       └── nouveau brief intégrant les erreurs à ne pas refaire
│
├── 7. /btw — Question latérale
│   │
│   ├── Rôle
│   │   └── question rapide hors historique principal
│   │
│   ├── Bons usages
│   │   ├── quelle commande de test ?
│   │   ├── quel fichier contient cette logique ?
│   │   └── ce fichier a-t-il déjà été lu ?
│   │
│   └── Mauvais usages
│       ├── changer le périmètre
│       ├── ajouter une contrainte
│       ├── autoriser une nouvelle modification
│       └── changer l'objectif
│
├── 8. Auto-compaction
│   │
│   ├── peut arriver près des limites du contexte
│   │
│   └── ne pas attendre si la session se dégrade déjà
│
├── 9. Après /compact
│   │
│   ├── rechargé automatiquement
│   │   ├── CLAUDE.md
│   │   ├── mémoire automatique
│   │   └── noms des outils MCP
│   │
│   └── exception
│       ├── descriptions générales des skills
│       │   └── pas toutes réinjectées
│       └── skills réellement invoquées
│           └── restent disponibles
│
├── 10. CLAUDE.md et compaction
│   │
│   ├── permet de définir des règles courtes de préservation
│   ├── utile pour les longues sessions récurrentes
│   └── ne remplace pas /clear si la session est déjà très mauvaise
│
├── 11. Repères de contexte
│   │
│   ├── contexte bas
│   │   └── préférable pour les tâches sensibles
│   │
│   ├── ~40 %
│   │   └── surveiller davantage
│   │
│   ├── ~60 %
│   │   └── envisager /compact ou /clear
│   │
│   └── attention
│       └── heuristiques, pas règles officielles
│
└── 12. Workflow final
    │
    ├── OBSERVER
    │   ├── /context
    │   └── /recap
    │
    ├── DÉCIDER
    │   └── l'historique aide-t-il encore ?
    │
    └── AGIR
        ├── même tâche + contexte utile
        │   └── continuer
        │
        ├── même tâche + contexte lourd
        │   └── /compact
        │
        ├── nouvelle tâche / contexte pollué
        │   └── /clear + brief
        │
        └── question ponctuelle
            └── /btw
```

---

# Mini fiche de révision

```text
/context → combien de contexte ?
/recap   → quelle direction ?
/compact → même tâche, j'allège
/clear   → nouvelle tâche ou contexte mauvais
/btw     → petite question hors historique
```

> **Règle d'or à retenir :**
> OBSERVER → PERTINENCE DU CONTEXTE → MÊME TÂCHE ? → continuer / compact / clear


