---
title: "Créer des profils d’agents"
description: "Définir des agents spécialisés à l’aide de profils adaptés à leurs missions."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - agents
  - profils
categories:
  - "Chapitre 17"
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 05-creer-profils-agents
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi faut-il être très exhaustif en déléguant une tâche à un sous-agent personnalisé ?** | Contrairement à la session parente, le sous-agent démarre avec un **contexte frais**. Il n'a pas accès à l'historique complet ni aux fichiers déjà lus. Le message de délégation (l'objectif) doit donc inclure tout le contexte (fichiers, valeurs par défaut, format de sortie, etc.). |
| **Un sous-agent peut-il créer lui-même d'autres sous-agents ?** | **Non**. L'outil `Agent` est désactivé pour les sous-agents. C'est toujours la conversation principale qui gère la chaîne de délégation. |
| **Comment définir la `description` d'un profil pour qu'il soit utilisé à bon escient par Claude ?** | La description doit contenir le **déclencheur** (quand l'utiliser) et pas seulement la compétence (qui il est). Exemple : *"Utiliser avant la validation des changements d'authentification"* plutôt que *"Expert en sécurité"*. |
| **Quels sont les différents niveaux de portée (et de priorité) d'un profil ?** | L'organisation (1, plus haute), la session courante via `--agents` (2), le projet dans `.claude/agents/` (3), l'utilisateur global dans `~/.claude/agents/` (4), et les plugins (5). En cas de conflit de nom, la plus petite portée prime. |
| **Quelle particularité ont les profils intégrés `Explore` et `Plan` par rapport aux profils personnalisés ?** | Les profils personnalisés chargent normalement les fichiers `CLAUDE.md` et le statut Git, alors qu'Explore et Plan (les profils natifs) constituent une **exception** et ne les chargent pas. |

## Synthèse
Créer un profil de sous-agent personnalisé, c'est comme rédiger une fiche de poste. L'objectif (la mission ponctuelle transmise par l'agent parent) et le profil (le comportement global) doivent être strictement séparés. Le profil se matérialise par un fichier Markdown doté d'un *frontmatter YAML* contenant des paramètres essentiels : le modèle LLM souhaité (qui hérite du parent par défaut), la restriction fine des outils (`tools` et `disallowedTools`), les permissions, et les capacités d'isolation (ex: `background: true` et `isolation: worktree`). Le corps du Markdown fait office de prompt système pour "typer" l'agent.
Il est critique de comprendre qu'un sous-agent qui tourne en arrière-plan ne peut pas solliciter l'utilisateur pour clarifier un point (pas de `AskUserQuestion`). La mission qui lui est confiée doit donc être auto-suffisante, explicite sur les limites à ne pas franchir, et claire sur le format de réponse attendu.

## Glossaire
- **Profil d'agent** : Fichier Markdown (.md) définissant une "personnalité" et un ensemble de règles réutilisables (outils, permissions, modèle LLM) pour instancier un sous-agent spécialisé.
- **Frontmatter YAML** : En-tête de configuration situé au début du fichier `.md` du profil, délimité par `---`.
- **`disallowedTools`** : Champ du frontmatter servant à désactiver explicitement des outils (ex: `Write`, `Edit`, `Bash`) pour brider un sous-agent.
- **`/agents`** : Commande ouvrant l'interface graphique (TUI) interne à Claude Code pour consulter, créer ou éditer les profils existants.

## Questions d'auto-évaluation
1. Si un profil omet le champ `model` dans sa configuration, quel modèle LLM utilisera-t-il ?
2. Quelle propriété YAML faut-il ajouter pour forcer un sous-agent à travailler dans sa propre branche Git isolée ?
3. Est-il recommandé de mentionner un ticket JIRA ou un nom de fichier très spécifique dans le corps d'un profil ?
4. Si le parent tourne avec des permissions en mode `acceptEdits`, un sous-agent configuré avec `permissionMode: plan` pourra-t-il bypasser la permission humaine ?

# Créer des profils d’agents

**Durée : 16 minutes**

## Objectif de la leçon
Comprendre la syntaxe et la mécanique de création d'un profil de sous-agent personnalisé. Paramétrer finement ses droits, ses outils et son modèle pour concevoir de parfaits travailleurs spécialisés capables d'exécuter des missions répétitives (comme la revue de sécurité) sans polluer le contexte principal.

---

# 1. Le mécanisme de délégation

L'exécution d'un sous-agent est la fusion de deux éléments :
1. **L'Objectif (Mission)** : Fourni dynamiquement par la conversation principale (ex: *"Vérifie les logs d'erreurs dans app.js"*).
2. **Le Profil (Configuration)** : Réutilisable, défini en Markdown, il fixe le comportement global.

### Ce que le sous-agent hérite (ou non)
Un sous-agent démarre avec un **contexte frais**.
- **Il reçoit :** Le prompt de son profil, la mission, le dossier courant, et les instructions du projet (les profils persos chargent le `CLAUDE.md`, contrairement à `Explore` et `Plan`).
- **Il ne reçoit pas :** L'historique complet, les fichiers déjà explorés par le parent, les résultats des anciens outils.

> **Conséquence :** 
> Votre parent doit lui donner une mission exhaustive. De plus, s'il tourne en arrière-plan, il ne pourra pas utiliser l'outil `AskUserQuestion` ! Il bloquerait indéfiniment sans réponse. Donnez-lui toujours un comportement de repli en cas d'ambiguïté.

---

# 2. Structure d'un profil personnalisé

Un profil est composé d'un en-tête `YAML` (les options système) et d'un corps `Markdown` (le prompt). 

Voici l'anatomie d'un profil d'implémenteur isolé :
```yaml
---
name: isolated-implementer
description: "Implémente une fonctionnalité. À utiliser pour le code lourd."
model: inherit
effort: medium
tools: Read, Grep, Glob, Bash, Edit, Write
permissionMode: acceptEdits
isolation: worktree
background: true
maxTurns: 15
color: blue
---

# Instructions système du sous-agent (Prompt)
Tu es un implémenteur autonome. 
Respecte les fichiers attribués par la mission. N'ajoute pas de dépendance.
Ne pousse rien, ne fusionne rien.
Retourne obligatoirement :
- les fichiers modifiés
- les codes de sortie des tests
```

### Zoom sur les champs YAML :
- **`model`** : Sans modèle spécifié, il utilise `inherit` (reprend celui du parent). On peut y mettre `haiku` pour des relectures simples (économique) ou `opus` pour l'architecture.
- **`tools` et `disallowedTools`** : On peut restreindre les outils. *Rappel : Ne mettez jamais l'outil `Agent` dans les outils d'un sous-agent.*
- **`description`** : C'est le **déclencheur sémantique**. Il doit dire "Quand m'utiliser" (ex: "Relire l'authentification") plutôt que "Qui je suis" (ex: "Expert sécurité").
- **`isolation` et `background`** : Règle le comportement asynchrone sécurisé (`worktree`).

*(Note : le `permissionMode` du parent prévaut s'il est plus permissif que le sous-agent).*

---

# 3. Portée (Où enregistrer vos profils ?)

Les profils sont résolus avec un ordre de priorité très strict (le 1 gagne en cas de conflit de nom) :

| Priorité | Emplacement / Portée |
|---|---|
| **1** | Organisation (Paramètres gérés) |
| **2** | Session courante (Flag `--agents '{ "mon-agent": { ... } }'`) |
| **3** | Projet local (`.claude/agents/`) |
| **4** | Utilisateur global (`~/.claude/agents/`) |
| **5** | Dossier `agents/` d'un Plugin externe |

---

# 4. Gérer les profils avec `/agents`

Au lieu de créer les fichiers Markdown à la main dans le dossier `.claude/agents/`, Claude Code embarque une interface graphique interne :

**Tapez `/agents` dans votre terminal.**
L'onglet **Library** s'ouvre, vous permettant de :
- Consulter les profils existants.
- Créer ou modifier un profil via des menus interactifs.
- Générer une configuration complète (modèle, prompt) **en discutant avec Claude**.

Les profils créés ici sont enregistrés dans votre projet et disponibles immédiatement sans redémarrage.

---

# Les 5 points les plus importants

1. Le rôle d'un profil n'est pas de définir une mission (objectif ponctuel) mais une spécialité (méthode de travail réutilisable).
2. Un sous-agent ne voit pas l'historique complet de la session de son parent. Le prompt de délégation doit être exhaustif.
3. Un sous-agent qui tourne en arrière-plan ne peut pas bloquer en appelant l'outil `AskUserQuestion`. Donnez-lui des instructions claires de repli.
4. La description (`description` YAML) doit absolument inclure un déclencheur actionnable pour que Claude sache *quand* déléguer.
5. Les profils peuvent être générés dynamiquement et très facilement sans toucher aux fichiers locaux en utilisant l'interface interactive `/agents`.

---

# Carte mentale

```text
Profil de Sous-agent
├── Frontmatter YAML
│   ├── name, description (Déclencheur !)
│   ├── model (haiku, inherit...)
│   ├── tools / disallowedTools
│   └── background / isolation (worktree)
├── Corps Markdown
│   └── Prompt système (rôle durable)
├── Comportement
│   ├── Contexte "Frais" (Pas d'historique parent)
│   └── Pas d'outil AskUserQuestion (en bg)
└── Gestion
    ├── via fichiers (.claude/agents/)
    └── via UI (/agents -> Library)
```

---

# Mini fiche de révision

```text
Profil personnalisé = YAML (config) + Markdown (prompt système).
Délégation : Mission (ponctuelle, via parent) + Profil (réutilisable, via fichier).
Héritage : Sous-agent part de zéro, pas d'historique. Charge le CLAUDE.md local.
Outils : restreints via `disallowedTools`. Pas de sous-sous-agents (outil Agent interdit).
Priorité de lecture : Session (--agents) > Projet (.claude/agents/) > Utilisateur (~/.claude/agents/).
Interface de création : Commande `/agents`.
```

> **Phrase à retenir** : Rédigez le champ `description` d'un agent comme une documentation technique : indiquez à Claude le problème à résoudre, pas seulement le titre du poste.

---

# 1. Première section thématique

```text
Schéma ASCII : mécanisme, comparaison ou architecture
```

---

# Résumé & Schéma global

```text
Vue synthétique des flux
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| ... | ... |

# Les 5 points les plus importants

1. ...
2. ...
3. ...
4. ...
5. ...

---

# Carte mentale

```text
Racine
├── Branche 1
└── Branche 2
```

---

# Mini fiche de révision

```text
Aide-mémoire express, aligné sur →
```

> **Phrase à retenir** : la règle d'or de la leçon.
