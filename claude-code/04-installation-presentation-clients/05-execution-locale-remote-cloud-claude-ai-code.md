---
title: "Exécution locale, remote et cloud et présentation de claude.ai/code"
description: "Comparer les modes d’exécution local, Remote Control et Cloud, et maîtriser claude.ai/code et la téléportation de session."
date: 2026-08-15
draft: true
tags:
  - claude-code
  - cloud
  - remote
categories:
  - "Chapitre 4"
cours: Claude Code
chapitre: 04-installation-presentation-clients
leçon: 05-execution-locale-remote-cloud-claude-ai-code
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Où s'exécute le code ? | **Local** (sur votre PC), **Remote Control** (PC piloté via web), **Cloud** (VM Sandbox Anthropic). |
| Qu'est-ce que le Remote Control ? | Expose une session locale active vers l'interface `claude.ai/code` via `claude remote-control`. |
| Comment fonctionne le mode Cloud ? | Connexion GitHub requise. L'agent travaille dans une VM cloud isolée et crée des Pull Requests. |
| À quoi sert --teleport ? | Rapatrie une session Cloud en cours vers son terminal local via `claude --teleport <session-id>`. |
| Différence sur les configurations ? | En local : lit `~/.claude/settings.json`. En Cloud : exige de committer `.claude/settings.json` dans le dépôt Git. |

## Synthèse
Les trois modes d'exécution de Claude Code (Local, Remote Control, Cloud) déterminent où le code est modifié et exécuté. Le mode local et le Remote Control opèrent sur votre machine physique (accès aux fichiers et serveurs MCP locaux). Le mode Cloud s'exécute de façon autonome dans des Sandbox isolées liées à GitHub, et sa session peut être rapatriée localement via `--teleport`.

## Glossaire
- **--remote** : Option CLI pour exécuter une tâche dans une machine virtuelle cloud sécurisée.
- **--teleport** : Commande pour rapatrier une branche Git et l'historique d'une session cloud vers son terminal local.
- **claude.ai/code** : Interface web centralisée d'Anthropic pour piloter des sessions distantes ou Cloud.
- **Remote Control (rc)** : Pilotage à distance (depuis un navigateur ou mobile) d'une session de code restée sur son PC local.

## Questions d'auto-évaluation
1. Pourquoi la mise en veille de votre ordinateur portable interrompt-elle une session en mode Remote Control mais pas une session lancée avec `claude --remote` ?
2. Pourquoi les serveurs MCP déclarés uniquement dans `~/.mcp.json` sur votre PC local ne sont-ils pas accessibles en mode Cloud ?
3. Quelle commande CLI permet de rapatrier sur son poste local le code produit par un agent exécuté dans le cloud ?
4. Quel est l'intérêt du mode `--permission-mode plan` pour analyser une tâche avant de lui laisser modifier des fichiers ?

# Exécution locale, remote et cloud et présentation de claude.ai/code

**Durée : 15 minutes**

## Objectif de la leçon
Distinguer les 3 topologies d'exécution (Local, Remote Control, Cloud) et utiliser `claude.ai/code` pour rapatrier des sessions via la téléportation.

---

# 1. Les 3 Topologies d'Exécution

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                     TOPOLOGIES D'EXÉCUTION CLAUDE CODE                  │
│                                                                         │
│  1. LOCAL          ──> Exécution directe sur votre PC (Localhost, Docker) │
│  2. REMOTE CONTROL ──> Exécution sur votre PC, mais PILOTÉE via le web  │
│  3. CLOUD          ──> Exécution sur Sandbox VM Anthropic (GitHub PR)   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. La Téléportation de Session (`--teleport`)

```text
  [Session Cloud activée sur claude.ai/code] ──> Travail de l'agent dans la Sandbox VM
                                                            │
  [Terminal Local] <── `claude --teleport <session-id>` ────┘
  (Rapatrie la branche Git et l'historique d'échange sur votre PC)
```

---

# Résumé & Schéma global

```text
                    TOPOLOGIE & ENVIRONNEMENTS
                                │
      ┌─────────────────────────┼─────────────────────────┐
      ▼                         ▼                         ▼
   Local                    Remote Control              Cloud
(Sur votre PC)          (PC piloté via le Web)      (VM Sandbox / PR)
```

# Tableau comparatif des modes

| Mode | Lieu d'exécution | Dépendance machine physique | Configuration |
|---|---|---|---|
| **Local** | Votre PC | Oui (Machine doit rester allumée) | `~/.claude/settings.json` |
| **Remote Control** | Votre PC | Oui (S'arrête si le PC s'éteint) | `~/.claude/settings.json` |
| **Cloud** | Sandbox VM Anthropic | Non (S'exécute à 100% dans le cloud) | `.claude/settings.json` dans Git |

# Les 5 points les plus importants

1. **Remote Control ≠ Cloud** : Remote Control pilote votre PC local depuis le web.
2. **L'extinction ou la mise en veille du PC** arrête les sessions Remote Control mais pas le Cloud.
3. **Le mode Cloud requiert une intégration GitHub** et un dépôt distant accessible.
4. **La téléportation (`claude --teleport`)** ramène une session Cloud sur votre terminal local.
5. **Les serveurs MCP pour le mode Cloud** doivent être committés dans le dépôt Git du projet.

---

# Carte mentale

```text
Topologies d'Exécution
│
├── Local & Remote Control
│   ├── Exécution sur le PC physique
│   └── Remote Control = Interface Web pour PC Local
│
├── Mode Cloud (--remote)
│   ├── Isolation complète dans une VM Sandbox
│   └── Création directe de Pull Requests GitHub
│
└── Rapatriement & Synchronisation
    └── claude --teleport <session-id>
```

---

# Mini fiche de révision

```text
Local          → Exécution directe sur les fichiers et outils de votre PC
Remote Control → Pilotage web d'une session locale active (PC allumé requis)
Cloud          → Exécution 100% isolée dans une Sandbox Anthropic (GitHub)
--teleport     → Rapatrier une session Cloud sur son terminal local
```

> **Phrase à retenir** : Utilisez le mode Local pour travailler avec vos outils physiques, le mode Cloud pour déléguer sans risque d'effet de bord, et la téléportation pour basculer de l'un à l'autre.
