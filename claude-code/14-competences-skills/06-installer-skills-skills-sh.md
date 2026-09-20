---
title: "Installer des skills et présentation de skills.sh"
description: "Découvrir l'annuaire skills.sh géré par Vercel, installer, tester et mettre à jour des skills externes pour enrichir les agents."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - vercel
  - package-manager
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 06-installer-skills-skills-sh
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-04
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Qu'est-ce que `skills.sh` ?** | C'est un annuaire public open source de skills pour agents IA, géré par Vercel. Il référence des skills compatibles avec Claude Code, Codex, Cursor, etc. C'est le standard "Agent Skills". |
| **Comment lister les skills d'un dépôt Github distant sans les installer ?** | En utilisant `npx skills add [URL_DEPOT] --list` |
| **Comment installer une skill depuis un dépôt distant (ex: Github) ?** | En utilisant la commande `npx skills add [URL_DEPOT] --skill [NOM_SKILL] --agent claude-code`. Par défaut, la skill est installée localement dans `.claude/skills/`. |
| **Puis-je installer une skill globalement pour tous mes projets ?** | Oui, en ajoutant l'option `--global` (ou `-g`). La skill sera alors placée dans `~/.claude/skills/`. |
| **Peut-on "essayer" une skill sans l'installer définitivement ?** | Oui ! La commande `npx skills use [URL_DEPOT] --skill [NOM_SKILL] --agent claude-code` télécharge la skill dans un dossier temporaire et lance l'agent avec. Pratique pour évaluer la qualité avant de polluer le projet. |
| **Quelles sont les précautions de sécurité avant d'installer une skill tierce ?** | Une skill tierce, c'est du code tiers exécuté sur votre machine. Il faut toujours : vérifier le propriétaire, lire le `SKILL.md`, examiner les scripts fournis, et faire un `git status` / `git diff` après l'installation. |
| **Quelle est la différence entre `skills.sh` et les plugins propres à Claude Code ?** | `skills.sh` est un catalogue universel multi-agents. Les plugins natifs de Claude Code (installables via `/plugin marketplace add`) sont spécifiques à Anthropic et peuvent embarquer non seulement des skills, mais aussi des sous-agents, des hooks ou des serveurs MCP. |

## Synthèse
Outre la création manuelle, on peut importer des skills communautaires depuis l'annuaire `skills.sh` géré par Vercel. Basé sur le format standard "Agent Skills", cet annuaire permet de partager des workflows pour Claude Code, Cursor, Copilot, etc.
L'outil en ligne de commande associé s'invoque via `npx skills`. On peut rechercher des skills (`npx skills find testing`), les lister (`--list`), les ajouter au projet local ou globalement (`add ... --agent claude-code`), ou même les tester à la volée dans un dossier temporaire (`use`).
Les bonnes pratiques exigent de traiter ces skills tierces avec la plus grande prudence : il faut inspecter le dépôt source, lire le `SKILL.md`, auditer les scripts locaux fournis, et vérifier les effets de bord via Git après l'installation. Enfin, pour désactiver la collecte de métriques par `skills.sh` lors de l'installation, on peut utiliser la variable d'environnement `DISABLE_TELEMETRY=1`.

## Glossaire
- **`skills.sh`** : Annuaire open-source (soutenu par Vercel) hébergeant des skills au format standardisé pour divers agents IA.
- **`npx skills add`** : Commande CLI permettant d'installer une skill depuis un dépôt distant.
- **`npx skills use`** : Commande CLI permettant d'utiliser une skill de manière éphémère sans l'installer.
- **`DISABLE_TELEMETRY=1`** : Variable d'environnement pour bloquer l'envoi de statistiques d'installation (anonymes) vers `skills.sh`.

## Questions d'auto-évaluation
1. Si je veux tester la skill `webapp-testing` du dépôt `anthropics/skills` sans polluer le dossier de mon projet, quelle commande utiliser ?
2. Pourquoi une skill téléchargée depuis `skills.sh` fonctionne-t-elle souvent à la fois sur Cursor et sur Claude Code ?
3. Je viens d'installer une skill et j'aimerais mettre à jour toutes les skills de mon projet. Quelle est la commande appropriée ?
4. Vrai ou Faux : Les audits de sécurité fournis par `skills.sh` garantissent l'absence absolue de code malveillant.

# Installer des skills et présentation de skills.sh

**Durée : 20 minutes**

## Objectif de la leçon
Découvrir l'annuaire `skills.sh`, apprendre à rechercher, auditer, installer et mettre à jour des skills développées par la communauté (Anthropic, Vercel, Microsoft...).

---

# 1. L'écosystème `skills.sh`

`skills.sh` n'appartient pas à Anthropic, c'est un registre open-source piloté par Vercel. Il propose un standard de "Skills d'Agent" portable.
Ainsi, une skill (qui est fondamentalement un dossier avec un `SKILL.md` et des scripts) peut être installée sur **Claude Code, Cursor, Windsurf, ou GitHub Copilot**.

C'est pourquoi on utilise `npx skills` et on précise l'agent cible via `--agent claude-code`.

---

# 2. Explorer et rechercher

### Depuis le terminal
Vous pouvez chercher directement depuis le CLI :
```bash
npx skills find testing
npx skills find "web application testing"
```

### La "Skill" qui trouve des skills
Étonnamment, il existe une skill pour... chercher des skills !
```bash
npx skills add https://github.com/vercel-labs/skills \
  --skill find-skills \
  --agent claude-code
```
Une fois installée, vous pourrez demander à Claude de vous trouver un outil et il interrogera l'annuaire de lui-même.

### Lister ce que contient un dépôt
Avant d'installer, vous pouvez voir quelles skills contient un dépôt Github particulier :
```bash
npx skills add https://github.com/anthropics/skills --list
```

---

# 3. Installer et Auditer

Une skill est du **code tiers**. Elle vient potentiellement avec des scripts bash ou python que Claude peut lancer. **La méfiance est de rigueur.**

### L'installation (mode projet par défaut)
```bash
npx skills add https://github.com/anthropics/skills \
  --skill webapp-testing \
  --agent claude-code
```
- Sans l'option `--global` (ou `-g`), la skill atterrit dans `.claude/skills/webapp-testing/`. C'est l'approche recommandée pour la confiner au dépôt.

### Auditer le changement
Dès que l'installation est finie, votre premier réflexe doit être :
```bash
git status --short
git diff -- .claude
```
Lisez le code qui vient d'être téléchargé (le `SKILL.md` et les scripts dans `scripts/`). Vérifiez les `allowed-tools` et ce que fait la skill.

> [!TIP]
> **Désactiver la télémétrie**
> L'outil `npx skills` collecte des statistiques anonymes d'installation. Pour l'empêcher :
> `DISABLE_TELEMETRY=1 npx skills add ...`

---

# 4. Essayer sans s'engager (`use`)

Vous voulez évaluer une skill mais vous ne voulez pas salir votre dépôt Git ? Utilisez `use` au lieu de `add`.

```bash
npx skills use https://github.com/anthropics/skills \
  --skill webapp-testing \
  --agent claude-code
```
Le CLI télécharge la skill dans un dossier temporaire du système et lance immédiatement l'agent avec cette skill dans son contexte. Dès que vous fermez la session, la skill disparaît.

---

# 5. Gestion du cycle de vie

Les dépôts évoluent, les skills aussi. 

- **Mettre à jour une skill précise :**
  ```bash
  npx skills update webapp-testing
  ```
- **Mettre à jour TOUTES les skills du projet :**
  ```bash
  npx skills update --project
  ```
- **Supprimer une skill :**
  ```bash
  npx skills remove webapp-testing
  ```

> [!WARNING]
> Une mise à jour est équivalente à l'installation d'une nouvelle dépendance. Le créateur peut avoir ajouté un script malveillant. Faites toujours un `git diff` après un `update`.

---

# 6. `skills.sh` vs Plugins natifs Anthropic

Ne confondez pas `skills.sh` et le système de marketplace natif de Claude Code :
- **`skills.sh`** : Orienté "workflows multi-agents" (seulement des dossiers `SKILL.md` et des scripts bash/python).
- **Plugins Claude Code (`/plugin marketplace add`)** : Spécifiques à Anthropic. Ils peuvent installer des skills, mais aussi configurer des **Serveurs MCP**, injecter des **Hooks** ou déployer des **Sous-agents**. C'est un écosystème beaucoup plus profond.
