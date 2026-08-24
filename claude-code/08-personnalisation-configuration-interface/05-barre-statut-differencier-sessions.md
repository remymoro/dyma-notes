---
title: "Construire une barre de statut utile et différencier les sessions"
description: "Personnaliser la barre de statut et la couleur des sessions Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - barre-de-statut
  - sessions
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 05-barre-statut-differencier-sessions
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Rôle de la barre de statut ?** | Maintient des repères objectifs et visibles (modèle, dossier, branche, contexte, coût, nom de session) pour éviter de travailler dans le mauvais contexte (surtout en multi-onglets). |
| **Comment la configurer ?** | Via `/statusline` avec une demande en langage naturel, ou en écrivant un script shell local (souvent dans `~/.claude/`) qui extrait les données avec `jq`. |
| **Fonctionnement interne ?** | Claude Code envoie l'état de la session en JSON via `stdin`. Le script lit, extrait, et imprime du texte sur `stdout` (qui devient la barre de statut). |
| **Danger des scripts lents ?** | Le script s'exécute localement à chaque tour. Il doit être instantané. Les appels réseau ou commandes lourdes (comme `npm test`) vont geler/ralentir l'interface. |
| **`/color` : usage et limite ?** | Applique une couleur à l'invite de la session courante pour la différencier visuellement. C'est purement visuel (vert = lecture, rouge = danger) et ne modifie pas réellement les permissions. |
| **Rafraîchissement (`refreshInterval`) ?** | Paramètre du `settings.json` qui relance le script toutes les N secondes. Utile pour une horloge, mais à utiliser avec parcimonie pour ne pas épuiser les ressources ou ralentir le terminal. |

## Synthèse
La combinaison de `/statusline` et de `/color` permet de sécuriser le travail parallèle sur plusieurs branches, worktrees ou tâches. La ligne de statut affiche l'état réel et objectif de la session (dossier, modèle, usage du contexte) tandis que la couleur permet de signaler visuellement l'intention (lecture seule, correction rapide, refonte risquée). Le script gérant la barre de statut s'exécutant localement, il doit impérativement utiliser des outils rapides (comme `jq`) et proscrire toute commande bloquante.

## Glossaire
- **`/statusline`** : Commande pour configurer la ligne d'état (soit par prompt génératif, soit en liant un script shell).
- **`/color`** : Commande assignant une couleur à l'invite de la session courante pour faciliter le repérage multi-onglets.
- **`refreshInterval`** : Paramètre optionnel du `settings.json` forçant la réexécution du script de statut toutes les N secondes.

## Questions d'auto-évaluation
1. Assigner la couleur rouge (`/color red`) sécurise-t-elle la session en interdisant à Claude de modifier des fichiers ?
2. D'où provient le JSON lu par le script de barre de statut ?
3. Pourquoi est-il fortement déconseillé d'exécuter un test métier (ex: `npm test`) directement dans le script de la barre de statut ?
4. Un pourcentage de contexte utilisé de 95% signifie-t-il que la qualité des réponses de Claude sera mauvaise ?

# Construire une barre de statut utile et différencier les sessions

**Durée : 12 minutes**

## Objectif de la leçon
Apprendre à configurer des repères visuels fiables (barre de statut pour l'état objectif et couleurs pour l'intention) afin d'opérer en toute sécurité sur plusieurs sessions parallèles sans risquer de se tromper de dépôt, de branche ou de tâche.

---

# 1. Flux de la barre de statut

```text
  Mécanique d'un script de statut local
  [ Claude Code ]
       │
       │ Envoie un flux JSON décrivant la session (via stdin)
       ▼
  [ Script Shell ] ──> Utilise 'jq' pour extraire: modèle, contexte, coût...
       │           ──> Exécute des commandes locales légères (git status)
       │ Retourne une chaîne de texte simple (via stdout)
       ▼
  [ Affichage UI ]
```

---

# 2. Convention de Couleurs de Session

```text
  Exemple de convention multi-onglets (purement visuelle)
  /color green   -> Lecture seule (exploration sécurisée)
  /color cyan    -> Bugfix limité (correction sur un ou deux fichiers)
  /color yellow  -> Planification / Architecture
  /color purple  -> Refactorisation globale
  /color red     -> Zone sensible / Manipulation critique (Prod, DB, Auth)
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `/statusline` | Configure (par prompt) ou supprime (`clear`) la ligne de statut. |
| `/color` | Modifie la couleur de l'invite de la session courante. |
| `claude --name <nom>` | Lance une session avec un nom explicite (lisible par le script de statut). |

# Les 5 points les plus importants

1. La **barre de statut** affiche l'état objectif (branche, dossier) ; la **couleur** indique l'intention (lecture, risque).
2. Le script de statut est alimenté par un flux JSON envoyé via `stdin` et nécessite l'utilitaire `jq` pour son traitement.
3. Le script de statut s'exécutant très fréquemment, il faut **bannir** toute commande lente, lourde ou réseau.
4. La commande `/color` ne bride aucune capacité de l'agent, elle s'adresse uniquement à votre attention pour éviter les erreurs de contexte.
5. Une barre de statut surchargée d'informations ou dépassant la largeur du terminal devient contre-productive (vous finirez par l'ignorer).

---

# Carte mentale

```text
Repérage et Contexte Multi-sessions
│
├── Barre de statut (/statusline)
│   │
│   ├── Objectif
│   │   └── Réduire les erreurs de contexte
│   │       ├── mauvais dossier
│   │       ├── mauvaise branche
│   │       └── mauvais worktree
│   │
│   ├── Infos principales
│   │   ├── modèle
│   │   ├── dossier
│   │   ├── branche Git
│   │   ├── worktree
│   │   └── contexte utilisé
│   │
│   ├── Infos optionnelles
│   │   ├── coût estimé
│   │   ├── durée
│   │   ├── nom de session
│   │   ├── style de sortie
│   │   └── mode Vim
│   │
│   └── Mécanisme interne
│       └── Claude Code
│           ↓
│         JSON
│           ↓ stdin
│         script local
│           ↓
│          jq
│           ↓
│         printf
│           ↓ stdout
│       barre de statut
│
├── Scripts de statut
│   │
│   ├── Doivent rester rapides
│   │   └── éviter :
│   │       ├── tests
│   │       ├── builds
│   │       ├── appels réseau/API
│   │       └── commandes bloquantes
│   │
│   ├── jq
│   │   └── extrait les champs du JSON
│   │
│   ├── Script personnel
│   │   ├── ~/.claude/statusline-....sh
│   │   └── ~/.claude/settings.json
│   │
│   └── Script d'équipe
│       ├── .claude/statusline.sh
│       └── .claude/settings.json
│
├── Couleurs de session (/color)
│   │
│   ├── Objectif
│   │   └── afficher l'INTENTION de la session
│   │
│   ├── Convention possible
│   │   ├── vert   → lecture seule
│   │   ├── cyan   → correction limitée
│   │   ├── jaune  → exploration / planification
│   │   ├── violet → refactorisation
│   │   └── rouge  → zone sensible
│   │
│   ├── Limite
│   │   └── repère uniquement visuel
│   │       ├── ne change pas les permissions
│   │       ├── ne change pas la branche
│   │       └── ne garantit pas la sécurité
│   │
│   └── Complément
│       ├── /statusline → ÉTAT RÉEL
│       ├── /color      → INTENTION
│       └── nom session → IDENTITÉ
│
└── Validation
    ├── barre de statut ≠ validation
    ├── couleur ≠ sécurité
    │
    └── vraie vérification
        ├── diff
        ├── tests
        └── preuves finales
```

---

# Mini fiche de révision

```text
Symptôme : Travailler dans le mauvais onglet.
Solution 1 : /statusline (affiche dossier, branche, contexte, modèle).
Solution 2 : /color (affiche l'intention : vert=sûr, rouge=danger).
Mécanisme : Le script reçoit du JSON via stdin -> jq -> print sur stdout.
Règle d'or absolue : Le script de statut doit s'exécuter instantanément.
```

> **Phrase à retenir** : La couleur annonce l'intention de la session, la barre de statut confirme son contexte objectif.

---

# Annexes Visuelles

![Tableau de configuration de la barre de statut](../assets/status-table.png)
![Aperçu de la barre de statut](../assets/status-preview.png)
