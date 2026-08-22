---
title: "Installation et présentation de l’application Desktop"
description: "Installer et découvrir l'application de bureau Claude : onglets Chat, Cowork, Code, diffs visuels et gestion multi-sessions."
date: 2026-08-15
draft: true
tags:
  - claude
  - desktop
  - installation
categories:
  - "Chapitre 4"
cours: Claude Code
chapitre: 04-installation-presentation-clients
leçon: 03-installation-presentation-desktop
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-16
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Quels sont les 3 onglets principaux ? | **Chat** (conversation), **Cowork** (tâches asynchrones cloud), **Code** (interface graphique Claude Code). |
| Quels OS sont pris en charge ? | **macOS** et **Windows**. **Non disponible sur Linux** (CLI obligatoire sur Linux). |
| Quels sont les 3 modes de session ? | **Locale** (dépôt PC + Git), **Distante** (Cloud Anthropic), **SSH** (serveur/VM). |
| Intérêt des diffs graphiques ? | Validation visuelle ligne à ligne en couleur (vert/rouge) avant d'appliquer les modifications. |
| Pourquoi utiliser plusieurs sessions ? | Isolation des contextes (1 session = 1 ticket) pour éviter la saturation de la fenêtre d'attention. |

## Synthèse
L'application Desktop Claude unifie la discussion classique (Chat), le travail asynchrone (Cowork) et l'agentique (Code). Disponible sous Windows et macOS (mais pas sous Linux), elle offre un confort visuel précieux pour relire les diffs de code, isoler des sessions par onglets et se connecter à des machines distantes via SSH.

## Glossaire
- **Claude Cowork** : Module d'exécution d'agents asynchrones dans le cloud pour traiter des tâches de fond.
- **Diff Graphique** : Comparateur visuel affichant clairement les suppressions et ajouts de code dans l'UI Desktop.
- **Session Locale** : Exécution de l'agent directement sur le système de fichiers et le dépôt Git de votre machine.
- **Session SSH** : Exécution distante contrôlée graphiquement depuis l'application Desktop vers un serveur distant.

## Questions d'auto-évaluation
1. Si vous travaillez sur une distribution Linux (ex: Ubuntu), quelle interface devez-vous utiliser pour faire tourner Claude Code ?
2. Quel est l'avantage de la vue en diffs graphiques de l'application Desktop par rapport aux logs textuels du CLI ?
3. Pourquoi recommande-t-on d'ouvrir un onglet séparé par ticket de développement dans l'application Desktop ?
4. L'application Desktop et le CLI partagent-ils les mêmes configurations et serveurs MCP ?

# Installation et présentation de l’application Desktop

**Durée : 9 minutes**

## Objectif de la leçon
Installer l'application Claude Desktop, prendre en main les 3 onglets (Chat, Cowork, Code) et valider graphiquement les modifications de code.

---

# 1. Structure de l'Application Desktop

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                       INTERFACE CLAUDE DESKTOP                          │
│                                                                         │
│  [ONGLET CHAT]   ──> Conversation classique, analyse documentaire        │
│  [ONGLET COWORK] ──> Exécution d'agents asynchrones en arrière-plan     │
│  [ONGLET CODE]   ──> Claude Code visuel, diffs graphiques, terminal     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Modes de Connexion dans l'Onglet Code

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                        MODES DE SESSION CODE                            │
│                                                                         │
│  1. SESSION LOCALE ──> Manipule directement le dossier Git de votre PC  │
│  2. SESSION CLOUD  ──> Machine virtuelle isolée hébergée par Anthropic  │
│  3. SESSION SSH    ──> Connexion distante à un serveur / VM dédié       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# Résumé & Schéma global

```text
                     CLAUDE DESKTOP APPLICATION
                                 │
     ┌───────────────────────────┼───────────────────────────┐
     ▼                           ▼                           ▼
  Chat & Docs                Cowork Cloud                 Claude Code
(Usage classique)         (Agents asynchrones)       (Diffs visuels / SSH)
```

# Tableau récapitulatif par système

| OS | Application Desktop | Version CLI |
|---|---|---|
| **macOS (Intel/Apple Silicon)** | ✅ Disponible | ✅ Disponible |
| **Windows (x64/ARM64)** | ✅ Disponible | ✅ Disponible |
| **Linux (Ubuntu, Debian, Fedora)** | ❌ Indisponible | ✅ Disponible (CLI natif) |

# Les 5 points les plus importants

1. **Claude Desktop n'est pas disponible sur Linux** : utilisez la version CLI natif.
2. **L'onglet Code apporte le confort graphique** de la relecture de diffs ligne par ligne.
3. **Le mode Cowork exécute des agents asynchrones** dans le cloud sans bloquer votre écran.
4. **La gestion multi-onglets isole le contexte** et évite la pollution de mémoire entre tickets.
5. **Le CLI et le Desktop partagent les mêmes réglages**, les mêmes skills et les mêmes MCP.

---

# Carte mentale

```text
Claude Desktop
│
├── Onglets Principaux
│   ├── Chat (Discussions & Docs)
│   ├── Cowork (Tâches Cloud)
│   └── Code (Interface Agentique)
│
├── Modes de Session Code
│   ├── Session Locale (Git PC)
│   ├── Session Distante (Cloud Sandbox)
│   └── SSH (Serveurs distants)
│
└── Avantages Ergonomiques
    ├── Diffs visuels en couleur
    └── Isolation par onglets
```

---

# Mini fiche de révision

```text
Desktop OS    → Windows et macOS uniquement (Linux = CLI)
Onglet Code   → Claude Code visuel avec révision des diffs
Multi-onglets → 1 onglet par ticket pour garder un contexte pur
Partage config→ Mêmes MCP et skills que le CLI local
```

> **Phrase à retenir** : Utilisez l'application Desktop pour le confort visuel de la relecture des diffs de code, et gardez le CLI pour la vitesse en terminal.
