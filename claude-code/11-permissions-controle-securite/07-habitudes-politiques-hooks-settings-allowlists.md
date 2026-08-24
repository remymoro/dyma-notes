---
title: "Transformer les habitudes en politiques avec hooks, settings et allowlists"
description: "Formaliser les pratiques de sécurité à l’aide de hooks, de réglages et de listes d’autorisation."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - hooks
  - securite
  - configuration
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 07-habitudes-politiques-hooks-settings-allowlists
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi ne pas tout mettre dans `CLAUDE.md` ?** | Le fichier `CLAUDE.md` *guide* l'agent, mais ne *force pas* l'exécution. Ce n'est pas une barrière de sécurité. Les interdictions et règles dures doivent aller dans les permissions. |
| **À quoi sert `/fewer-permission-prompts` ?** | C'est un outil d'audit (une skill) qui analyse les sessions passées pour repérer les commandes `Bash`/`MCP` répétitives et proposer une *allowlist* de projet candidate. Cette liste doit toujours être relue humainement. |
| **Quand utiliser une règle de permission vs. un hook ?** | - **Permission** (`allow/deny`) : Pour un blocage dur, déterministe ou une auto-autorisation simple.<br>- **Hook** (`PreToolUse`, `PostToolUse`) : Quand la politique demande du *code* (ex: exécuter un formatteur après modification, journaliser une commande). |
| **Pourquoi un Hook ne doit pas être le seul "garde-fou" ?** | Les hooks peuvent échouer, être mal ciblés (matchers trop larges), et ne parshent pas toujours parfaitement les commandes `Bash`. Les refus absolus doivent toujours utiliser le système `deny`. |
| **Quelle est la différence entre un Hook et une Skill ?** | - **Hook** : Action *automatique* déclenchée sur un événement précis.<br>- **Skill** : Procédure *intellectuelle* (ex: guide de migration) que Claude décide d'invoquer. Ne mettez pas d'analyse ou de jugement humain dans un hook. |
| **Que sont les "paramètres gérés" ?** | C'est le niveau d'organisation (ex: entreprise). Ils ont la priorité absolue sur les configs utilisateur et projet. Utilisés pour bloquer par la force les hooks locaux (`allowManagedHooksOnly`) ou imposer des serveurs MCP. |

## Synthèse
L'utilisation avancée de Claude Code implique de passer du "répétitif" à la "politique codée". Plutôt que de répéter "n'utilise pas cette commande" ou "formate toujours le fichier", ces habitudes doivent être déléguées à l'outil approprié. Le fichier `CLAUDE.md` sert à guider les procédures, mais les barrières d'exécution doivent résider dans le système de permission (`allow`/`deny`). Pour des actions déclenchées sur événement (comme formater après une écriture), les **Hooks** sont l'outil idéal. Cependant, un hook ne remplace jamais un refus dur : ils doivent travailler de concert (le `deny` bloque, le hook journalise). Pour s'aider à identifier les règles candidates, la commande `/fewer-permission-prompts` est excellente. Enfin, à l'échelle d'une organisation, les "paramètres gérés" permettent d'imposer des règles et des hooks de haut niveau que les développeurs locaux ne peuvent pas contourner.

## Glossaire
- **Politique (`settings.json`)** : Déclaration formelle (permission, hook, config) de ce qui est autorisé ou non.
- **`/fewer-permission-prompts`** : Outil d'audit pour générer une proposition d'allowlist basée sur l'historique des sessions.
- **Hooks** : Scripts déclenchés à des étapes clés du cycle de vie (ex: `PreToolUse`, `PostToolUse`, `PermissionRequest`).
- **Paramètres gérés** : Configurations injectées au niveau de l'organisation (via MDM ou registres système) qui ont priorité sur toute configuration de dépôt ou d'utilisateur.
- **Skill** : Procédure ou workflow intellectuel (ex: "comment faire une release") mis à disposition du modèle pour guider son travail.

## Questions d'auto-évaluation
1. L'agent écrit du code sans respecter les conventions de nommage. Dois-je créer une règle `deny`, un hook, ou l'ajouter au `CLAUDE.md` ?
2. Je veux que chaque appel à `Bash(git push)` soit bloqué et loggé dans un fichier texte. Comment configurer cela ?
3. Pourquoi la commande `/fewer-permission-prompts` ne doit-elle pas être vue comme un "bouton magique pour tout autoriser" ?
4. Si je définis un Hook local dans `.claude/settings.local.json`, mais que l'organisation a activé `allowManagedHooksOnly: true`, que se passe-t-il ?

# Transformer les habitudes en politiques avec hooks, settings et allowlists

**Durée : 20 minutes**

## Objectif de la leçon
Comprendre comment faire évoluer sa configuration : passer des consignes orales dans le prompt à des barrières de sécurité dures (`allow`/`deny`), et maîtriser l'utilisation des **Hooks** pour les actions événementielles, tout en sachant quand utiliser les "paramètres gérés" pour l'entreprise.

---

# 1. Où ranger son intelligence ? (Le choix de la couche)

Cesser de répéter la même chose à chaque prompt est le premier pas vers une utilisation avancée. Mais il faut choisir la bonne boîte :

| Mon besoin | Où le ranger ? | Pourquoi ? |
|---|---|---|
| M'indiquer comment builder, ou l'architecture du projet | **`CLAUDE.md`** ou **Skill** | C'est du "guidage". Ça n'empêche aucune commande de s'exécuter. |
| M'empêcher d'exécuter `git push` ou de lire `.env` | **`permissions.deny`** | C'est un refus dur et déterministe. Ne dépend pas de la bonne volonté de l'IA. |
| Approuver automatiquement mes tests récurrents | **`permissions.allow`** | Supprime la "fatigue de validation" sur des tâches sûres. |
| Exécuter le linter *après* chaque modification de fichier | **Hook (`PostToolUse`)** | C'est une action automatique liée à un événement. |
| Imposer une règle de sécurité à tous les développeurs | **Paramètres gérés** | C'est une politique d'entreprise, prioritaire sur le reste. |

---

# 2. Construire une allowlist saine

Une bonne allowlist ne contient pas de jokers dangereux comme `Bash(npm *)`.
Pour vous aider à démarrer, Claude Code inclut un outil de diagnostic :

> [!TIP]
> **`/fewer-permission-prompts`**
> Tapez cette commande dans le terminal. Claude va analyser vos 50 dernières sessions, repérer les validations que vous faites manuellement en permanence, et vous proposer un bloc `allow` à ajouter à votre `settings.json`.

**Attention : Ce n'est pas un bouton d'approbation aveugle.** Vous DEVEZ relire ce qu'il propose. Une commande fréquente n'est pas toujours une commande sûre.

---

# 3. Les Hooks : l'automatisation événementielle

Les hooks sont des scripts que Claude Code exécute à votre place lors d'événements précis (ex: `PreToolUse`, `PostToolUse`, `PermissionRequest`).

### Ce qu'un hook DOIT faire
- Formater un fichier après son édition (`PostToolUse`).
- Journaliser une commande (écrire dans un log) avant qu'elle ne s'exécute (`PreToolUse`).
- Réécrire une entrée (ex: modifier dynamiquement les arguments d'un outil).

### Ce qu'un hook NE DOIT PAS faire (Garde-fou)
Ne vous reposez jamais sur un hook *seul* pour bloquer une commande critique.
Les hooks peuvent avoir des matchers flous (un hook `Bash` a du mal à parser finement les arguments bash complexes).
**La bonne pratique (Séparation saine) :**
- Utilisez **`deny`** dans les permissions pour bloquer la commande (le refus dur).
- Utilisez un **Hook** pour journaliser ou auditer le fait que la commande a été tentée.

---

# 4. Politiques d'organisation : Les paramètres gérés

Dans un cadre d'entreprise, laisser la configuration dans des `.claude/settings.json` modifiables par les développeurs locaux n'est parfois pas suffisant.

L'entreprise peut déployer (via MDM, registre Windows, ou `/etc/claude-code/`) des **paramètres gérés**.
- Ces paramètres écrasent les configurations du projet ou de l'utilisateur.
- **`allowManagedPermissionRulesOnly: true`** : Ignore tous les `allow` locaux et n'utilise que ceux validés par la sécurité IT.
- **`allowManagedHooksOnly: true`** : Empêche un développeur de créer un hook local malveillant ou bogué, en bloquant tous les hooks non fournis par l'organisation.

---

# Cartes mentales

```text
               TRANSFORMER UNE HABITUDE EN POLITIQUE
                                 │
           ┌─────────────────────┼─────────────────────┐
           ↓                     ↓                     ↓
     CONNAISSANCE           AUTORISATION         AUTOMATISATION
   "Voici comment..."   "Bloque ça / Fais ça"    "À chaque fois..."
           │                     │                     │
       CLAUDE.md         permissions.allow            Hook
          ou             permissions.deny       (PostToolUse, ...)
        Skills                   │                     │
                        (Paramètres gérés si niveau entreprise)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Workflow de conversion
1. Observer   : Lancer /fewer-permission-prompts ou /insights.
2. Classer    : Est-ce un blocage (deny), un automatisme (hook), ou une procédure (skill) ?
3. Écrire     : Créer la règle dans le bon JSON (.claude/settings.json).
4. Tester     : Lancer Claude Code, vérifier avec /permissions et /hooks.
5. Versionner : Commiter le JSON avec le reste de l'équipe.
```

> **La phrase centrale de la leçon :**
> Si vous tapez la même chose dans un prompt pour la troisième fois, c'est que la règle doit quitter `CLAUDE.md` et devenir une politique exécutable (Permission ou Hook).
