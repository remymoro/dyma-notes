---
title: "Configurer le terminal, le thème, les notifications et les retours à la ligne"
description: "Adapter l’apparence et le comportement du terminal utilisé avec Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - terminal
  - theme
  - notifications
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 04-terminal-theme-notifications-retours-ligne
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| ... | ... |

## Synthèse
| Indices / questions clés | Notes détaillées |
|---|---|
| **Retour à la ligne multiligne ?** | L'appui sur `Entrée` soumet le prompt. `Shift+Enter` dépend du terminal. `Ctrl+J` ou l'échappement `\` + `Entrée` sont des méthodes de repli garanties. |
| **Le rôle de `/terminal-setup` ?** | Tente de corriger les réglages du terminal (souvent intégrés aux IDE) pour qu'il transmette bien les raccourcis à Claude (ne configure *pas* le comportement interne du CLI). |
| **macOS et "Option" ?** | Dans Apple Terminal ou les IDE, il faut configurer "Use Option as Meta Key" pour transmettre les raccourcis correctement. |
| **`/theme` vs `/color` ?** | `/theme` = Confort visuel global (dark, auto, ansi). `/color` = Distinction visuelle entre plusieurs sessions de travail simultanées. |
| **Notifications locales ?** | Gérées via `preferredNotifChannel` (iterm2, kitty, terminal_bell). Signale simplement que la tâche est finie et requiert votre attention (ne garantit pas le succès de la tâche). |
| **`tmux` et signaux bloqués ?** | `tmux` bloque les notifications et touches complexes par défaut. Il faut activer `allow-passthrough` et `extended-keys` dans `~/.tmux.conf`. |
| **Gestion multi-sessions ?** | Renommer systématiquement les onglets par *tâche* (ex: `convertisseur-fix`) et vérifier `git status` évite les erreurs de contexte. |

## Synthèse
La configuration du terminal est la première étape pour optimiser l'environnement Claude Code. Le CLI dépend intimement de l'émulateur (IDE, tmux, OS) pour la transmission des frappes (`Shift+Enter`, `Option`), le rendu visuel (`/theme`) et la remontée des notifications (`preferredNotifChannel`). En cas de raccourci inopérant, la friction provient rarement de l'agent mais souvent du terminal hôte, ce qui peut se corriger via `/terminal-setup`, des combinaisons robustes (`Ctrl+J`) ou la configuration tmux (`allow-passthrough`).

## Glossaire
- **`/terminal-setup`** : Utilitaire permettant d'aider le terminal (surtout dans les IDE) à transmettre correctement les séquences de touches à Claude Code.
- **`Ctrl+J`** : Raccourci universel (robuste) pour insérer un saut de ligne dans le prompt interactif sans l'envoyer.
- **`allow-passthrough`** : Réglage indispensable de `tmux` pour permettre le passage des séquences d'échappement (notifications, barres de progression) vers le terminal hôte.

## Questions d'auto-évaluation
1. Si `Shift+Enter` envoie directement le message, quelle commande peut tenter de réparer ce comportement ?
2. Quelle méthode de saut de ligne fonctionnera dans 100% des terminaux sans aucune configuration ?
3. Quelle est la différence d'usage entre `/theme` et `/color` ?
4. Pourquoi est-il déconseillé d'ouvrir plusieurs sessions parallèles sans renommer les onglets du terminal ?

# Configurer le terminal, le thème, les notifications et les retours à la ligne

**Durée : 9 minutes**

## Objectif de la leçon
Supprimer les frictions liées à l'environnement d'exécution (terminaux intégrés, multiplexeurs, configurations macOS) pour fluidifier la saisie de prompts multilignes, garantir des notifications fiables, et rendre l'interface de travail confortable au quotidien.

---

# 1. Interaction Terminal et Claude Code

```text
  Couches de contrôle et sources de friction
  [ Terminal Hôte (OS, IDE, tmux) ]
   │ - Clavier / Séquences (Shift+Enter, touche Option)
   │ - Rendu ANSI / Palette de base
   │ - Cloche & Notifications de bureau
   ▼
  [ Claude Code CLI ]
     - Apparence (/theme)
     - Actions internes (/keybindings)
```
*Note : Si une touche semble inopérante, réparez le lien de transmission (Terminal), pas l'outil récepteur (Claude).*

---

# 2. Saisie Multiligne et Raccourcis

```text
  Stratégies de saut de ligne dans le prompt interactif
  - Rapide / Fragile : Shift+Enter (souvent intercepté par l'IDE)
  - Robuste          : Ctrl+J (Méthode de repli idéale)
  - Universelle      : \ + Entrée (Peu lisible mais infaillible)
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `/theme` | Modifie l'apparence générale de Claude (auto, dark, light, ansi, etc.). |
| `/terminal-setup` | Tente de configurer l'émulateur hôte pour qu'il transmette correctement les touches. |
| `Ctrl+J` | Insère un saut de ligne dans le prompt sans envoyer le message. |
| `\` + `Entrée` | Méthode d'échappement garantissant un saut de ligne robuste. |

# Les 5 points les plus importants

1. Claude gère son affichage et ses raccourcis internes, mais le **terminal garde le contrôle** sur la transmission matérielle des touches et l'affichage des notifications.
2. `Ctrl+J` est la méthode de repli absolue et robuste pour le prompt multiligne.
3. `/terminal-setup` ne définit pas les actions de Claude, il répare la configuration de l'émulateur (particulièrement utile dans les IDE).
4. Sous macOS, il faut souvent forcer l'utilisation de la touche Option comme touche "Meta" via les réglages du profil terminal.
5. `tmux` bloque les notifications et les touches complexes par défaut ; il nécessite d'activer `allow-passthrough` et `extended-keys`.

---

# Carte mentale

```text
TERMINAL + CLAUDE CODE
│
├── Saisie
│   ├── Entrée → envoyer
│   ├── Ctrl+J → nouvelle ligne
│   └── Shift+Enter → dépend du terminal
│
├── Raccourcis
│   ├── /terminal-setup → transmission
│   └── Option → Meta sur macOS
│
├── Apparence
│   ├── /theme → apparence générale
│   ├── auto → clair/sombre automatique
│   ├── dark/light
│   ├── ANSI → palette terminal
│   └── /color → identifier une session
│
├── Notifications
│   └── preferredNotifChannel
│       → attirer l'attention
│       → pas valider le travail
│
├── tmux
│   ├── allow-passthrough
│   └── extended-keys
│
└── Multi-sessions
    ├── un onglet par tâche
    ├── nom explicite
    └── git status avant modification
```

---

# Mini fiche de révision

```text
Friction clavier = problème de terminal (IDE, OS, tmux).
Solution raccourcis = /terminal-setup ou Option -> Meta.
Multiligne robuste = Ctrl+J.
Esthétique = /theme (visuel global) =/= /color (par session).
Multi-sessions = Renommer les onglets par tâche pour éviter le mauvais contexte.
```

> **Phrase à retenir** : Les frustrations de saisie dans Claude Code proviennent rarement du CLI lui-même, mais presque toujours du terminal hôte qui intercepte ou bloque les signaux.

---

# Mini fiche de révision

```text
Aide-mémoire express, aligné sur →
```

> **Phrase à retenir** : la règle d'or de la leçon.
