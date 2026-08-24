---
title: "Adapter les raccourcis clavier"
description: "Configurer les raccourcis clavier et découvrir les réglages associés dans Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - raccourcis-clavier
  - configuration
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 06-adapter-raccourcis-clavier
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Rôle de `/keybindings` ?** | Ouvre ou crée le fichier JSON local (`~/.claude/keybindings.json`) pour lier des touches aux actions internes de Claude Code (Chat, Confirmation, Scroll). |
| **Pourquoi des Contextes ?** | Un raccourci a des rôles différents selon sa zone (ex: `Chat`, `Scroll`, `Confirmation`). Évitez la configuration `Global` pour ne pas causer d'effets de bord imprévus. |
| **Distinguer avec `/terminal-setup` ?** | `/terminal-setup` assure que l'IDE/OS *envoie* correctement la touche. `/keybindings` décide de ce que l'application *déclenche* avec cette touche. |
| **Les accords (chords) ?** | Combiner des touches (ex: `ctrl+k ctrl+e`) permet d'affecter des actions rares (ouvrir éditeur externe) sans cannibaliser les raccourcis simples. |
| **Comment "délier" un raccourci ?** | Affecter l'action `null` à une combinaison de touches dans le JSON (ex: `"ctrl+s": null`). |
| **Touches intouchables ?** | Ne jamais remapper les actions vitales : `Ctrl+C` (interrupt), `Ctrl+D` (exit), `Entrée`. Éviter aussi les préfixes tmux/screen (`Ctrl+B`, `Ctrl+A`). |
| **Vérification (Diagnostic) ?** | Après chaque modification du fichier, lancer `/doctor` pour détecter les JSON invalides, les raccourcis réservés ou les conflits. |

## Synthèse
La commande `/keybindings` permet d'ajuster l'ergonomie de l'interface Claude Code en liant des actions internes (comme l'ouverture d'un éditeur externe pour les longs prompts) à des combinaisons de touches spécifiques via un fichier JSON strictement personnel. Plutôt que de redéfinir brutalement des touches de manière globale, il est recommandé de cibler des **contextes** précis (`Chat`, `Scroll`), d'utiliser des accords (`ctrl+k ctrl+e`) pour les actions rares, et de s'abstenir de remapper les touches vitales (`Ctrl+C`, `Ctrl+D`). L'intégrité de ces personnalisations se vérifie toujours via `/doctor`.

## Glossaire
- **`/keybindings`** : Commande qui ouvre/crée le fichier de raccourcis clavier personnels.
- **Accords de touches** : Séquence composée de plusieurs touches successives (ex: `ctrl+k ctrl+e`) pour déclencher une action, limitant ainsi les appuis accidentels.
- **Contextes** : Périmètres d'interface (ex: `Chat`, `Task`, `Scroll`) permettant d'assigner différents comportements à une même touche.

## Questions d'auto-évaluation
1. Si le raccourci `Ctrl+E` est déjà utilisé par votre IDE (qui l'intercepte), devez-vous modifier le `keybindings.json` ou la configuration de l'IDE ?
2. Comment désactiver une combinaison de touche qui vous gêne dans le contexte du chat ?
3. Le fichier `keybindings.json` doit-il être partagé avec le reste de l'équipe via Git ?
4. Quelle commande permet d'identifier immédiatement un conflit ou une erreur de syntaxe dans vos raccourcis ?

# Adapter les raccourcis clavier

**Durée : 15 minutes**

## Objectif de la leçon
Apprendre à personnaliser l'ergonomie de Claude Code sans risquer de briser la navigation de base, en évitant les conflits avec le système hôte (IDE, tmux) et en s'assurant que ces préférences restent strictement personnelles.

---

# 1. Terminal vs Application : Qui fait quoi ?

```text
  Flux de transmission et résolution des problèmes
  [ Clavier Physique ]
           │
  [ Terminal Hôte (OS / IDE / tmux) ] -> Émet le signal.
           │        (Touche bloquée/interceptée ? -> vérifier IDE, tmux ou /terminal-setup)
           ▼
  [ Claude Code CLI ] -> Reçoit et interprète l'action via ~/.claude/keybindings.json
                    (Mauvaise action déclenchée ? -> configurer /keybindings)
```
*Règle d'or : Si la touche n'arrive pas, c'est le terminal. Si elle arrive mais fait la mauvaise chose, c'est Claude.*

---

# 2. Structure d'un raccourci (JSON)

```text
  {
    "bindings": [
      {
        "context": "Chat",                <-- 1. Le périmètre
        "bindings": {
          "ctrl+k ctrl+e": "chat:externalEditor", <-- 2. Accord déclenchant l'action
          "ctrl+s": null                          <-- 3. Touche déliée (désactivée)
        }
      }
    ]
  }
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `/keybindings` | Ouvre/crée le fichier de raccourcis personnels (`~/.claude/keybindings.json`). |
| `/doctor` | Diagnostique la configuration, détecte JSON invalide et conflits. |
| `Ctrl+R` | (Action par défaut) Recherche dans l'historique des requêtes. |
| `Ctrl+O` | (Action par défaut) Bascule l'affichage détaillé de la transcription. |

# Les 5 points les plus importants

1. Le fichier `~/.claude/keybindings.json` est **strictement personnel** et ne doit jamais être versionné dans le dépôt du projet.
2. Ciblez toujours un **Contexte** précis (`Chat`, `Confirmation`, `Scroll`) au lieu d'utiliser une règle `Global` génératrice de bugs inattendus.
3. Préférez les **accords de touches** (ex: `ctrl+k` puis `ctrl+e`) pour les actions peu fréquentes afin de préserver les raccourcis simples.
4. N'essayez jamais de remapper les touches de contrôle vitales : `Ctrl+C` (Interruption) et `Ctrl+D` (Sortie), ni les préfixes multiplexeurs (`Ctrl+B`, `Ctrl+A`).
5. Terminez **toujours** vos modifications en exécutant la commande `/doctor` pour valider l'intégrité de vos changements.

---

# Schéma récapitulatif

```text
                           RACCOURCIS CLAUDE CODE
                           │
          ┌────────────────┼────────────────┐
          │                │                │
      TRANSMISSION     CONFIGURATION     DIAGNOSTIC
          │                │                │
 /terminal-setup      /keybindings        /doctor
          │                │
          │        ~/.claude/keybindings.json
          │                │
          │             context
          │                │
          │      ┌─────────┼──────────┐
          │      │         │          │
          │     Chat     Scroll   Confirmation
          │                           Task...
          │
          └─ Une touche doit d'abord
             arriver correctement à Claude Code
```

---

# Carte mentale

```text
ADAPTER LES RACCOURCIS CLAUDE CODE
│
├── Transmission
│   └── /terminal-setup
│       → la touche arrive-t-elle correctement ?
│
├── Personnalisation
│   ├── /keybindings
│   └── ~/.claude/keybindings.json
│       │
│       ├── context
│       │   ├── Chat
│       │   ├── Confirmation
│       │   ├── Scroll
│       │   └── Task
│       │
│       ├── touche → action
│       ├── null → délier
│       └── accords → Ctrl+K puis Ctrl+E
│
├── Diagnostic
│   └── /doctor
│       → JSON
│       → conflits
│       → doublons
│       → raccourcis réservés
│
├── Environnement
│   ├── terminal
│   ├── IDE
│   ├── tmux
│   └── screen
│
├── Navigation
│   ├── Ctrl+R → historique
│   └── Ctrl+O → transcription
│
└── Mode d'édition
    ├── /config
    └── /vim → ancienne commande à connaître
```

---

# Mini fiche de révision

```text
Fichier de config : ~/.claude/keybindings.json (Local).
Règle : 1. Cibler le Contexte -> 2. Assigner les Touches -> 3. Lier l'Action.
Pour désactiver : Mettre l'action à "null".
Pour les actions rares : Utiliser des accords (ex: ctrl+k ctrl+e).
Validation : Lancer /doctor après chaque édition.
```

> **Phrase à retenir** : Les raccourcis dépendent trop du système et de l'IDE pour être partagés ; ils doivent rester personnels, prudents et validés par `/doctor`.
