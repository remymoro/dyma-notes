---
title: "Portée de la configuration"
description: "Comprendre les différents niveaux auxquels la configuration de Claude Code peut s’appliquer."
date: 2026-08-22
draft: true
tags:
  - claude-code
  - configuration
  - permissions
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 01-portee-configuration
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| La question à se poser avant tout réglage ? | **Qui** doit être affecté, et avec **quel niveau d'autorité ?** L'emplacement compte plus que la clé JSON. |
| Configuration ≠ prompt ? | Le **prompt** est une instruction ponctuelle. La **configuration** définit l'environnement dans lequel Claude travaille (interface, modèle, permissions, hooks, plugins, sandbox). |
| Les 5 portées ? | **User** (`~/.claude/settings.json`), **Project** (`.claude/settings.json`), **Local** (`.claude/settings.local.json`), **Managed** (`managed-settings.json`), **CLI** (`--settings`). |
| Ordre de priorité ? | **Managed > CLI > Local > Project > User.** Le managed est en tête : c'est une politique, pas une préférence, et elle n'est pas contournable par les couches inférieures. |
| Lequel se versionne ? | `.claude/settings.json` **oui** (config d'équipe). `.claude/settings.local.json` **non**, il doit être ignoré par Git. |
| `settings.json` vs `.claude.json` ? | `~/.claude/settings.json` = paramètres configurables. `~/.claude.json` = **état interne** (OAuth, confiance des projets, caches). On ne configure pas dans le second. |
| Comment fusionnent les couches ? | Les **scalaires** (`theme`, `verbose`, `model`) sont **remplacés** par la couche la plus prioritaire. Certaines **listes**, dont les permissions, sont **concaténées et dédupliquées**. |
| Règle des permissions ? | **`deny` l'emporte toujours sur `allow`.** Un `allow` ne sert jamais à percer un `deny`. |
| Où sont attachés les paramètres projet ? | Au **répertoire de lancement** de Claude Code — logique différente de `CLAUDE.md`, qui se charge par ancêtres et sous-répertoires. |
| `CLAUDE.md` vs `settings.json` ? | `CLAUDE.md` dit **comment** Claude doit travailler (instructions). `settings.json` dit **dans quelles règles** il travaille (contrôle). |

## Synthèse
Configurer Claude Code, ce n'est pas choisir une option, c'est choisir à quel étage la poser. Cinq portées se superposent, du réglage personnel valable partout jusqu'à la politique d'organisation non contournable, et elles se résolvent selon un ordre de priorité fixe où le managed écrase tout et l'utilisateur cède devant tout le monde. Le réflexe à acquérir est donc de traduire un besoin en question d'autorité — qui est concerné, et est-ce que ça doit pouvoir être contourné — car un même réglage placé un étage trop bas devient une préférence qu'un collègue écrase, et placé un étage trop haut devient une contrainte que personne ne peut lever.

## Glossaire
- **Portée (scope)** : niveau auquel un réglage s'applique — moi, l'équipe, le projet, l'organisation ou une exécution unique.
- **Managed settings** : politique d'organisation, déposée hors du dépôt par l'administrateur, conçue pour ne pas être contournable par les couches inférieures.
- **`managed-settings.d/`** : répertoire permettant d'éclater la politique en plusieurs fichiers, triés alphabétiquement puis fusionnés (`10-security.json`, `20-sandbox.json`…).
- **`.claude.json`** : état interne de Claude Code (OAuth, confiance des projets, outils approuvés, caches) — à ne pas confondre avec les fichiers de configuration.
- **`$schema`** : clé pointant vers le schéma JSON public, qui active autocomplétion et validation dans l'éditeur.
- **`CLAUDE_CONFIG_DIR`** : variable d'environnement déplaçant le répertoire habituellement situé dans `~/.claude` (tests, conteneurs, profils séparés).

## Questions d'auto-évaluation
1. Votre `~/.claude/settings.json` fixe `verbose: false`, le `.claude/settings.json` du dépôt fixe `verbose: true`, et votre `.claude/settings.local.json` fixe `verbose: false`. Quelle valeur s'applique, et pourquoi cet ordre plutôt que l'inverse ?
2. Pourquoi ajouter `Read(./secrets/exemple.txt)` dans `allow` ne vous donnera-t-il pas accès au fichier si `Read(./secrets/**)` figure dans `deny` d'une couche supérieure ?
3. Vous voulez qu'un plugin expérimental soit désactivé chez vous seulement, sans gêner l'équipe. Dans quel fichier écrivez-vous le réglage, et que doit-il arriver à ce fichier vis-à-vis de Git ?
4. Vous lancez Claude Code depuis `monorepo/frontend/` alors que le `.claude/settings.json` est à la racine du monorepo. Le fichier est-il pris en compte ? En quoi cela diffère-t-il du chargement de `CLAUDE.md` ?
5. Une règle doit s'appliquer à toute l'entreprise sans qu'un développeur puisse la lever. Quelle portée choisissez-vous, et pourquoi les quatre autres sont-elles inadaptées ?

# Portée de la configuration

**Durée : 13 minutes**

## Objectif de la leçon
Cesser de se demander *quelle clé JSON écrire* pour se demander *où l'écrire*. La leçon installe les cinq portées de configuration, leur ordre de priorité et les règles de fusion — de quoi éviter les deux erreurs classiques : poser une règle de sécurité à un endroit contournable, ou imposer à toute une équipe une préférence purement personnelle.

---

# 1. Configuration ≠ prompt

Un **prompt** est une instruction ponctuelle adressée à Claude. La **configuration** définit l'environnement dans lequel Claude Code travaille : interface, modèle, permissions, hooks, plugins, variables d'environnement, sandbox, outils, mémoire, comportement de session.

```text
CONFIGURATION
     ↓  définit les règles de l'environnement
CLAUDE CODE
     ↓  reçoit le prompt utilisateur
TRAVAIL DE CLAUDE
```

La distinction se prolonge dans une confusion fréquente :

```text
CLAUDE.md        → instructions : COMMENT Claude doit travailler
settings.json    → configuration : DANS QUELLES RÈGLES il travaille
~/.claude.json   → état interne : OAuth, confiance des projets, caches
```

---

# 2. Les cinq portées

| Portée | Emplacement | Concerne |
|---|---|---|
| **Managed** | `managed-settings.json` | Toute l'organisation |
| **CLI** | `--settings` | Une seule exécution |
| **Local** | `.claude/settings.local.json` | Moi, dans ce projet |
| **Project** | `.claude/settings.json` | Toute l'équipe |
| **User** | `~/.claude/settings.json` | Moi, dans tous mes projets |

Le raisonnement se fait toujours du besoin vers l'emplacement, jamais l'inverse :

```text
Moi partout                      →  ~/.claude/settings.json
Toute l'équipe sur ce projet     →  .claude/settings.json        (versionné)
Moi seul sur ce projet           →  .claude/settings.local.json  (git-ignoré)
Toute l'organisation             →  managed-settings.json
Une seule exécution              →  claude --settings '{...}'
```

Emplacements des paramètres gérés : `/etc/claude-code/managed-settings.json` (Linux/WSL), `/Library/Application Support/ClaudeCode/` (macOS), `C:\Program Files\ClaudeCode\` (Windows, plus les politiques de registre). Sous WSL, les politiques Windows ne sont pas héritées automatiquement : il faut `"wslInheritsWindowsSettings": true`.

---

# 3. L'ordre de priorité

C'est le point central de la leçon.

```text
    PLUS PRIORITAIRE
          │
    1. MANAGED     ← politique d'organisation, non contournable
          ↓
    2. CLI         ← ponctuel, --settings
          ↓
    3. LOCAL       ← moi sur ce projet
          ↓
    4. PROJECT     ← l'équipe sur ce projet
          ↓
    5. USER        ← mes préférences globales
          │
    MOINS PRIORITAIRE
```

Le sens de l'échelle est logique : **plus le réglage engage de monde et d'autorité, plus il est haut.** Une préférence personnelle globale (User) est ce qui cède le plus facilement, parce que c'est le contexte le moins spécifique.

---

# 4. Fusion, remplacement et la règle `deny`

Deux comportements distincts selon le type de valeur :

```text
SCALAIRES  (theme, verbose, model, viewMode)
   → REMPLACÉS par la couche la plus prioritaire

LISTES     (notamment les permissions)
   → CONCATÉNÉES et dédupliquées entre les couches
     User : règle A  +  Project : règle B  =  A + B
```

Et par-dessus, une règle qui ne se négocie pas :

```text
DENY > ALLOW
```

Un refus l'emporte sur une autorisation, quelle que soit la couche d'où il vient. Ajouter une exception dans `allow` ne perce jamais un `deny` — c'est ce qui rend les politiques gérées réellement contraignantes.

Enfin, les fichiers user, project et local sont **stricts** : une erreur de validation peut faire rejeter tout le fichier. Les paramètres gérés sont plus **tolérants** et ignorent une entrée invalide en conservant les politiques valides restantes. D'où l'intérêt de `$schema` :

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
```

---

# Résumé & Schéma global

```text
                        UN BESOIN
                            │
              « qui, et avec quelle autorité ? »
                            │
   ┌──────────┬─────────────┼─────────────┬──────────┐
   ▼          ▼             ▼             ▼          ▼
 MANAGED     CLI          LOCAL        PROJECT     USER
 l'orga    1 exécution   moi ici      l'équipe    moi partout
   │          │             │             │          │
   └──────────┴──────► résolution ◄───────┴──────────┘
                     Managed > CLI > Local > Project > User
                     scalaires remplacés · listes fusionnées
                             DENY > ALLOW
```

# Tableau des commandes à retenir

| Commande / fichier | Rôle |
|---|---|
| `~/.claude/settings.json` | Mes préférences, dans tous mes projets |
| `.claude/settings.json` | Configuration d'équipe, versionnée avec le dépôt |
| `.claude/settings.local.json` | Mes réglages sur ce projet, git-ignoré |
| `managed-settings.json` | Politique d'organisation, non contournable |
| `claude --settings '{"verbose":true}'` | Réglage temporaire, une seule exécution |
| `/config` | Afficher ou modifier certaines options |
| `/status` | Voir les sources de configuration actives |
| `/permissions` | Inspecter les permissions **et leur origine** |
| `/mcp` | Inspecter les serveurs MCP |
| `claude doctor` | Diagnostiquer les problèmes de configuration |
| `CLAUDE_CONFIG_DIR=/chemin claude` | Déplacer le répertoire `~/.claude` |

# Les 5 points les plus importants

1. **La bonne question n'est pas « quelle clé ? » mais « qui doit être affecté, et avec quelle autorité ? »** — l'emplacement porte plus de sens que la valeur.
2. **`Managed > CLI > Local > Project > User`** : à mémoriser tel quel, c'est ce qui explique tout comportement inattendu.
3. **`deny` bat toujours `allow`** — un `allow` ne sert jamais à contourner un refus posé plus haut.
4. **Scalaires remplacés, listes fusionnées** : `theme` est écrasé, les permissions s'additionnent. Ne pas attendre le même comportement des deux.
5. **`.claude/settings.json` se versionne, `.claude/settings.local.json` non** — et les paramètres projet sont attachés au **répertoire de lancement**, contrairement à `CLAUDE.md`.

---

# Carte mentale

```text
Portée de la configuration
│
├── Nature
│   ├── Prompt        → instruction ponctuelle
│   ├── CLAUDE.md     → comment Claude travaille
│   ├── settings.json → dans quelles règles il travaille
│   └── .claude.json  → état interne (≠ configuration)
│
├── Les 5 portées
│   ├── User      ~/.claude/settings.json          moi partout
│   ├── Project   .claude/settings.json            l'équipe · versionné
│   ├── Local     .claude/settings.local.json      moi ici · git-ignoré
│   ├── Managed   managed-settings.json(.d/)       l'orga · non contournable
│   └── CLI       --settings                       une exécution
│
├── Résolution
│   ├── Managed > CLI > Local > Project > User
│   ├── Scalaires → remplacés
│   ├── Listes    → concaténées + dédupliquées
│   └── DENY > ALLOW
│
└── Diagnostic
    ├── /status · /permissions · /config · /mcp
    ├── claude doctor
    └── $schema → validation dans l'éditeur
```

---

# Mini fiche de révision

```text
Moi partout            → ~/.claude/settings.json
L'équipe, ce projet    → .claude/settings.json          (versionné)
Moi seul, ce projet    → .claude/settings.local.json    (git-ignoré)
L'organisation         → managed-settings.json          (non contournable)
Une seule exécution    → claude --settings '{...}'

Priorité               → Managed > CLI > Local > Project > User
Scalaires              → remplacés par la couche du dessus
Listes / permissions   → concaténées et dédupliquées
Permissions            → DENY > ALLOW
Projet                 → attaché au répertoire de LANCEMENT
```

> **Phrase à retenir** : on ne choisit pas un réglage, on choisit son étage — demandez-vous qui doit être affecté et avec quelle autorité, puis souvenez-vous que Managed écrase tout et qu'un `deny` ne se contourne jamais.
