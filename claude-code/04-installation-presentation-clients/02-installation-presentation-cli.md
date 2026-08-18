---
title: "Installation et présentation du CLI"
description: "Installer, configurer et prendre en main l'interface en ligne de commande (CLI) de Claude Code."
date: 2026-08-15
draft: true
tags:
  - claude-code
  - cli
  - installation
categories:
  - "Chapitre 4"
cours: Claude Code
chapitre: 04-installation-presentation-clients
leçon: 02-installation-presentation-cli
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Comment installer nativement Claude Code ? | - **macOS/Linux/WSL** : `curl -fsSL https://claude.ai/install.sh \| bash`<br>- **Windows PS** : `irm https://claude.ai/install.ps1 \| iex` |
| Quelles sont les autres méthodes d'installation ? | **npm** (`npm install -g @anthropic-ai/claude-code`), **Homebrew** (`brew install --cask claude-code`) ou **WinGet**. |
| Différence Commandes Shell vs Commandes Slash ? | **Shell** : Lancées dans le terminal (ex: `claude doctor`).<br>**Slash** : Lancées en session interactive (ex: `/clear`, `/login`). |
| Quelles sont les commandes Shell clés ? | `claude` (session), `claude -p` (prompt passif ponctuel), `claude -c` (continuer la session), `claude doctor` (diagnostic). |
| Comment maintenir le CLI à jour ? | `claude update` en terminal ou `/upgrade` en session interactive. |

## Synthèse
L'installation de Claude Code s'effectue idéalement via l'installateur natif (curl/irm) pour bénéficier des mises à jour automatiques. Une fois authentifié via le navigateur, l'outil s'utilise soit par des commandes Shell (ex: `claude doctor`, `claude -p`), soit par des commandes slash interactives en session (ex: `/clear`, `/login`).

## Glossaire
- **CLI (Command Line Interface)** : Interface textuelle en ligne de commande pour piloter l'agent.
- **Claude Doctor** : Commande de diagnostic testant la santé de l'installation, le réseau et les clés API.
- **Installation Native** : Déploiement d'un binaire autonome sans dépendance Node.js ni gestionnaire externe.
- **Prompt Passif (`claude -p`)** : Exécution d'une requête unique en ligne de commande se terminant immédiatement.

## Questions d'auto-évaluation
1. Pourquoi est-il déconseillé d'utiliser `sudo npm install -g` lors de l'installation de Claude Code ?
2. Quelle est la différence d'usage entre `claude "tâche"` et `claude -p "tâche"` ?
3. Quelle commande permet de réinitialiser le contexte sans quitter l'interface interactive ?
4. Quel outil système devez-vous exécuter en cas de blocage d'authentification ou de réseau ?

# Installation et présentation du CLI

## Objectif de la leçon
Installer correctement Claude Code sur son système d'exploitation et maîtriser les deux modes de commandes (Shell et Slash).

---

# 1. Les Méthodes d'Installation

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    MÉTHODES D'INSTALLATION DE CLAUDE CODE               │
│                                                                         │
│  [NATIVE (RECOMMANDÉE)] ──> curl -fsSL https://claude.ai/install.sh | bash│
│                             (Mises à jour automatiques transparentes)   │
│                                                                         │
│  [GESTIONNAIRES]       ──> npm install -g @anthropic-ai/claude-code     │
│                             brew install --cask claude-code             │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Distinction : Commandes Shell vs Commandes Slash

```text
TERMINAL SYSTÈME (Bash / Zsh)             SESSION INTERACTIVE CLAUDE CODE
┌──────────────────────────────┐          ┌──────────────────────────────┐
│  $ claude                    │          │  > /clear                    │
│  $ claude -p "Explique..."   │ ───────► │  > /login                    │
│  $ claude doctor             │          │  > /release-notes            │
└──────────────────────────────┘          └──────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                       UTILISATION DE CLAUDE CODE CLI
                                     │
       ┌─────────────────────────────┼─────────────────────────────┐
       ▼                             ▼                             ▼
   Installation                 Commandes Shell            Commandes Slash
(Natifs curl / npm)          (claude -p, doctor, -c)      (/clear, /help, /exit)
```

# Tableau des commandes essentielles

| Commande | Environnement | Rôle |
|---|---|---|
| `claude` | Terminal Shell | Ouvre une session interactive vierge. |
| `claude -p "question"` | Terminal Shell | Mode passif : répond et quitte immédiatement. |
| `claude doctor` | Terminal Shell | Lance un diagnostic de santé (réseau, authentification). |
| `/clear` | Session Slash | Efface le contexte actuel de la session. |
| `/exit` | Session Slash | Quitte la session (équivalent Ctrl+D). |

# Les 5 points les plus importants

1. **L'installation native (curl/irm)** garantit les mises à jour automatiques transparentes.
2. **Ne lancez jamais `sudo npm install`** pour éviter d'endommager les permissions du système.
3. **`claude doctor` est l'outil n°1 de diagnostic** en cas de problème de réseau ou d'API.
4. **`claude -p` permet d'exécuter des requêtes ponctuelles** directement depuis des scripts Bash.
5. **Les commandes préfixées par `/`** (comme `/clear`) s'utilisent uniquement en session interactive.

---

# Carte mentale

```text
Installation & CLI Claude Code
│
├── Installation
│   ├── Native (curl / irm) - Recommandée
│   └── Gestionnaires (npm / Homebrew / WinGet)
│
├── Mode Shell (Terminal)
│   ├── claude (Session standard)
│   ├── claude -p (Prompt rapide)
│   └── claude doctor (Diagnostic)
│
└── Mode Slash (En session)
    ├── /clear (Réinitialiser contexte)
    ├── /login (Gestion comptes)
    └── /exit (Quitter)
```

---

# Mini fiche de révision

```text
Install Native   → curl -fsSL https://claude.ai/install.sh | bash
claude -p        → Question rapide sans ouvrir de session complète
claude doctor    → Diagnostic de santé et de connexion
/clear           → Réinitialiser la mémoire de la session en cours
```

> **Phrase à retenir** : Privilégiez l'installation native pour bénéficier des mises à jour automatiques et utilisez `claude doctor` au moindre souci de connexion.
