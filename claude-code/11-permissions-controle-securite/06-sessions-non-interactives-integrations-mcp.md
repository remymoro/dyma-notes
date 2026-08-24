---
title: "Cadrer les sessions non interactives et les intégrations MCP"
description: "Sécuriser les sessions automatisées et les intégrations fondées sur MCP."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - mcp
  - securite
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 06-sessions-non-interactives-integrations-mcp
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la règle d'or du mode non-interactif ?** | "Ce qui n'est pas supervisé doit être borné". L'agent doit échouer proprement au lieu d'attendre une validation indéfiniment. |
| **Que fait `allowedTools` ?** | Il *pré-approuve* des outils, mais **il ne retire pas** les autres de la surface. Pour restreindre, il faut utiliser `disallowedTools` ou le mode `dontAsk`. |
| **Pourquoi préférer le mode `dontAsk` en CI ?** | Parce qu'il convertit automatiquement toute demande de permission non pré-approuvée en **refus**. C'est le mode le plus déterministe pour l'automatisation. |
| **L'option `tools` filtre-t-elle les outils MCP ?** | **Non**. `tools` ne gère que les outils natifs de Claude Code. Les serveurs MCP sont une surface d'attaque distincte qui doit être bloquée séparément (ex: `disallowedTools: ["mcp__*"]`). |
| **Pourquoi bloquer `bypassPermissions` en script ?** | Parce que ce mode annule l'intérêt de `allowedTools`. Si un outil n'est pas dans `allowedTools`, le mode `bypassPermissions` va quand même l'autoriser à s'exécuter. |
| **Quelles bornes ajouter à un agent non-interactif ?** | Toujours définir une limite de tours (`maxTurns`), un budget (`maxBudgetUsd`), et exiger une sortie structurée (JSON). |
| **Comment gérer les permissions MCP en équipe ?** | Utilisez `strictMcpConfig` ou `managed-mcp.json` et basez-vous sur des identifiants robustes (`serverUrl`, `serverCommand`), pas sur un `serverName` (qui est modifiable par l'utilisateur). |

## Synthèse
Une session non-interactive (comme `claude -p` ou via le SDK Agent) ne bénéficie pas de la vigilance d'un humain pour rattraper les dérives. Elle doit donc être strictement "bornée". Pour y parvenir, il ne suffit pas de faire une liste d'outils autorisés (`allowedTools`), il faut aussi s'assurer que les autres outils seront bloqués, par exemple en utilisant le mode de permission `dontAsk` (qui refuse tout imprévu) ou en déclarant des `disallowedTools` explicites. De plus, il est crucial de ne pas oublier que l'option `tools` ne filtre pas les outils MCP : ces derniers nécessitent leur propre gouvernance via des configurations strictes (`strictMcpConfig`, `allowManagedMcpServersOnly`) et des conditions d'arrêt physiques comme `maxTurns` ou `maxBudgetUsd`.

## Glossaire
- **Mode Headless (`claude -p`)** : Exécute une commande de bout en bout et imprime la réponse sans ouvrir de terminal. Utile pour les scripts.
- **`allowedTools`** : Pré-approuve les outils listés. *Ne bloque pas les autres.*
- **`disallowedTools`** : Bloque explicitement des outils (ex: `Bash`, `mcp__*`). L'emporte sur tous les modes.
- **Mode `dontAsk`** : En non-interactif, transforme toute demande de validation en refus immédiat.
- **`maxTurns` / `maxBudgetUsd`** : Limites "coupe-circuit" essentielles pour empêcher une tâche automatisée de tourner à l'infini ou de vider le compte.
- **`strictMcpConfig`** : Force Claude Code à ignorer les serveurs MCP personnels de l'utilisateur pour garantir une exécution reproductible.

## Questions d'auto-évaluation
1. Dans un script CI, si je déclare `allowedTools: ["Read"]` et `permissionMode: "bypassPermissions"`, l'agent peut-il utiliser l'outil `Bash` ?
2. Je veux bloquer tous les serveurs MCP dans ma tâche. Puis-je le faire via l'option `tools` de l'Agent SDK ?
3. Le mode `auto` est-il recommandé pour un script qui doit toujours produire le même résultat ou échouer ?
4. Où dois-je placer le fichier de configuration MCP de mon projet : `.claude/.mcp.json` ou `.mcp.json` (à la racine) ?

# Cadrer les sessions non interactives et les intégrations MCP

**Durée : 20 minutes**

## Objectif de la leçon
Savoir sécuriser une exécution de Claude Code sans humain dans la boucle (scripts, CI, automatisation). Comprendre que `allowedTools` ne suffit pas, et apprendre à borner la surface MCP et les ressources de l'agent.

---

# 1. Le principe du non-interactif : Ce qui n'est pas supervisé doit être borné

Dans un terminal classique, si Claude s'égare, vous l'arrêtez. En mode **headless** (`claude -p` ou SDK), l'agent tourne seul. Il doit échouer proprement plutôt que d'attendre indéfiniment un "Yes/No" ou d'halluciner des solutions compliquées.

> [!WARNING]
> **Le grand piège de `allowedTools`**
> `allowedTools` **pré-approuve**, mais ne **restreint pas**.
> Si vous dites "tu as le droit d'utiliser Read", cela ne veut pas dire "tu n'as PAS le droit d'utiliser Bash". Si l'agent veut utiliser Bash, cela déclenchera le comportement de votre `permissionMode`.

Pour verrouiller une exécution, il faut utiliser `allowedTools` **AVEC** le mode `dontAsk` (qui refuse automatiquement ce qui n'est pas pré-approuvé) OU ajouter des `disallowedTools` explicites.

---

# 2. Borner les ressources physiques (Les garde-fous)

Une automatisation ne doit jamais pouvoir tourner à l'infini. Dans le SDK, imposez toujours :
- **`maxTurns`** : Le nombre d'allers-retours max (ex: 3 à 5 suffisent pour une analyse).
- **`maxBudgetUsd`** : Le plafond financier (ex: 1$). Stoppe l'agent si le contexte dérive et coûte trop cher.
- **Un format structuré** : Demandez du JSON (ou JSON streamé) pour le parser facilement dans votre pipeline CI.

---

# 3. La double surface : Outils natifs vs Serveurs MCP

C'est l'erreur la plus fréquente : on restreint les outils natifs via l'option `tools` du SDK, mais on oublie les serveurs MCP !

**Les serveurs MCP forment une surface d'attaque distincte.**
Un serveur MCP qui lit Jira ou modifie GitHub est un outil comme un autre, et peut causer d'énormes dégâts.

### Comment sécuriser MCP en non-interactif ?
1. **Désactiver MCP si inutile :** Ajoutez `disallowedTools: ["mcp__*"]`.
2. **Refuser les configs locales :** Ne laissez pas l'automatisation utiliser le `mcp.json` personnel du développeur. Utilisez `mcpConfig` de manière explicite ou activez `strictMcpConfig`.
3. **Privilégier la lecture seule :** Autorisez `mcp__github__get_issue`, mais mettez `mcp__github__create_*` dans `disallowedTools`.
4. **Utiliser des identifiants robustes :** Ne faites pas confiance au nom (un serveur malveillant peut s'appeler "github"). Identifiez le serveur par sa `serverUrl` ou sa `serverCommand`.

*(Rappel : la configuration MCP du projet se met dans `.mcp.json` à la racine, pas dans le dossier `.claude` !)*

---

# Cartes mentales

```text
               SÉCURISER UNE SESSION NON-INTERACTIVE
                                 │
           ┌─────────────────────┼─────────────────────┐
           ↓                     ↓                     ↓
     SURFACE NATIVE       SURFACE EXTERNE        LIMITES PHYSIQUES
           │                     │                     │
   Ne suffit PAS de     Ne jamais hériter de   Indispensables pour
  mettre allowedTools      configs persos !    éviter les boucles
           │                     │                     │
    Ajouter dontAsk       Bloquer avec mcp__*       maxTurns
          OU              OU strictMcpConfig      maxBudgetUsd
    disallowedTools      OU managed-mcp.json      (Et demander JSON)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice de choix du mode
- Je veux que ça échoue si imprévu → dontAsk
- Je veux un humain si imprévu     → default (ou acceptEdits)
- Je veux que l'IA gère l'imprévu  → auto
- Je veux tout casser sans filet   → bypassPermissions (interdit en CI !)

■ Anatomie d'une tâche de CI parfaite
1. permissionMode: dontAsk
2. allowedTools: ["Read", "Glob"]
3. disallowedTools: ["Bash", "Write", "mcp__*"]
4. maxTurns: 3
5. maxBudgetUsd: 1.00
```

> **La phrase centrale de la leçon :**
> Dans une intégration sérieuse, on ne remplace pas une politique par un contournement (`bypassPermissions`) : on limite les outils, les tours, le budget, et on sépare la gestion des outils natifs de celle des serveurs MCP.
