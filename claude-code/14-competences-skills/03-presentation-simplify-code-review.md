---
title: "Présentation de /simplify et /code-review"
description: "Savoir utiliser et différencier les skills natives /code-review, /simplify et /batch pour relire et améliorer du code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - review
  - refactoring
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 03-presentation-simplify-code-review
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence fondamentale entre `/code-review` et `/simplify` ?** | `/code-review` cherche des **bugs** (corrections, régressions, cas limites) sur du code en cours de développement. `/simplify` intervient sur du code **déjà fonctionnel** pour améliorer sa **structure** (lisibilité, efficacité, abstraction). |
| **Que se passe-t-il si je tape `/code-review` sans arguments ?** | L'agent analyse le `diff` courant (les fichiers modifiés et non commités, ou par rapport à la branche distante) et produit **uniquement un rapport**. Il ne modifie pas le code par défaut. Pour appliquer les corrections, il faut ajouter `--fix`. |
| **Comment utiliser `/code-review` sur une pull request distante ?** | Il suffit de lui passer l'ID de la PR : `/code-review medium 123`. On peut même publier les résultats directement sur GitHub sous forme de commentaires avec `/code-review medium --comment 123`. |
| **Qu'est-ce que le mode `ultra` de `/code-review` ?** | C'est une analyse distante (cloud) multi-agents. Plusieurs agents spécialisés explorent la PR en parallèle et vérifient les bugs avant de les reporter. Idéal pour de grosses PR risquées, mais consomme beaucoup de crédits et nécessite une authentification Claude.ai. |
| **Comment fonctionne `/batch` ?** | `/batch` orchestre un changement massif sur un dépôt Git (ex: migration d'API). L'agent découpe le travail en unités (5 à 30), et lance des **sous-agents en parallèle**, chacun travaillant dans un `worktree` isolé pour créer sa propre PR. C'est très coûteux et inadapté pour les petites corrections. |
| **Pourquoi ne faut-il pas utiliser `/simplify` quand les tests échouent ?** | Parce que `/simplify` (contrairement à `/code-review`) suppose que la logique métier est **correcte**. Si le code est buggé, `/simplify` risque de refactoriser un bug et de le rendre plus difficile à trouver. Son but est le nettoyage (DRY, abstractions inutiles), pas le débogage. |

## Synthèse
La leçon détaille trois `skills` natives de Claude Code dédiées à l'amélioration du code : `/code-review`, `/simplify` et `/batch`. Elles interviennent à des étapes différentes du cycle de développement. 
1. **Pendant le développement** : On utilise `/code-review` pour auditer le `diff` et chercher des bugs ou des failles. Par défaut, il lit et fait un rapport. On peut préciser la profondeur (`low`, `medium`, `high`, `ultra`) et demander l'application des corrections avec `--fix`.
2. **Une fois le code fonctionnel** (tests au vert) : On lance `/simplify`. Ce skill analyse 4 axes (Réutilisation, Simplification, Efficacité, Abstraction) et nettoie la dette technique introduite lors du développement. Contrairement au review, il applique ses changements automatiquement.
3. **Pour des migrations massives** : On utilise `/batch`. Ce skill agit comme un orchestrateur. Il découpe une demande vaste en sous-tâches et lance des sous-agents en parallèle dans des environnements Git isolés (`worktrees`). Chaque agent résout sa tâche et ouvre sa propre PR. Attention au coût élevé de ce mode en termes de contexte et de crédits.

## Glossaire
- **`/code-review`** : Skill natif qui cherche des bugs dans un diff et génère un rapport. Accepte différents niveaux d'effort (low -> ultra).
- **`/code-review ultra`** : Exécution dans le cloud (Claude.ai) multi-agents, où le dépôt/PR est cloné à distance pour une analyse très approfondie.
- **`/simplify`** : Skill natif de refactoring. Ne s'utilise que sur du code dont les tests sont verts. Applique directement ses recommandations.
- **`/batch`** : Skill d'orchestration massive. Découpe une instruction en sous-unités traitées en parallèle par des sous-agents.
- **Worktree (Git)** : Fonctionnalité Git permettant d'avoir plusieurs copies de travail d'un même dépôt reliées au même `.git`, utilisé par `/batch` pour isoler le travail des sous-agents.

## Questions d'auto-évaluation
1. Si je veux corriger directement un bug dans mon fichier, dois-je taper `/code-review` ou `/code-review --fix` ?
2. Quelle skill est la plus appropriée pour remplacer l'utilisation d'une librairie obsolète sur 50 composants différents ?
3. Pourquoi est-il déconseillé d'exécuter `/simplify` avant d'avoir lancé `npm test` ?
4. Que fait la commande `/code-review medium --comment 45` ?

# Présentation de /simplify et /code-review

**Durée : 20 minutes**

## Objectif de la leçon
Maîtriser les trois `skills` d'amélioration continue fournies nativement par Claude Code et comprendre dans quel ordre les exécuter.

---

# 1. `/code-review` : Chercher les bugs

Cette skill analyse le `diff` en cours (ou une PR) pour y débusquer des régressions et des bugs.

**Syntaxe :**
`/code-review [niveau] [--fix] [--comment] [cible]`

- **Le niveau (`low`, `medium`, `high`, `xhigh`, `max`, `ultra`)** : Contrôle la profondeur. `low` remonte peu de bugs mais très probables. `high` élargit l'analyse. `ultra` l'envoie sur le cloud (multi-agents).
- **L'action (`--fix`)** : Par défaut, la skill est **en lecture seule** (elle fait un rapport). Avec `--fix`, elle modifie les fichiers.
- **L'intégration (`--comment`)** : Sur une cible de type PR (ex: `/code-review high --comment 123`), l'agent ira publier ses remarques directement sur GitHub !

---

# 2. `/simplify` : Nettoyer le code

Une fois que `/code-review` n'a plus rien trouvé et que **les tests passent**, le code est fonctionnel. Mais il n'est peut-être pas "beau". C'est là qu'intervient `/simplify`.

**Ses 4 axes d'analyse :**
1. **Réutilisation** : Y a-t-il une fonction dans le projet qui faisait déjà le job ?
2. **Simplification** : Cette condition `if/else` est-elle inutilement complexe ?
3. **Efficacité** : Fait-on deux boucles là où une seule suffirait ?
4. **Abstraction** : Cette abstraction (ex: un Design Pattern complexe) est-elle justifiée ou est-ce de l'over-engineering ?

> [!WARNING]
> Contrairement à `/code-review`, `/simplify` **applique directement** ses changements au code. Ne l'utilisez **jamais** si le code est cassé, car l'agent supposerait que la logique en cours (bien que buggée) est ce que vous souhaitez accomplir.

---

# 3. `/batch` : L'artillerie lourde

Quand vous avez une tâche massive et fastidieuse (ex: "Migrer ces 80 composants vers notre nouveau Design System"), n'utilisez pas l'agent standard. Utilisez `/batch`.

**Le workflow `/batch` :**
1. Vous lui donnez l'ordre global.
2. Il explore le dépôt et crée un **plan de bataille** (5 à 30 unités indépendantes).
3. Vous validez.
4. Il crée des **sous-agents** qui tournent en tâche de fond (visibles via `/tasks`).
5. Chaque sous-agent clone le code dans un **worktree Git isolé**.
6. Chaque sous-agent résout sa tâche, lance les tests, et ouvre une **Pull Request** indépendante.

> [!CAUTION]
> `/batch` a un coût de contexte monumental, car chaque sous-agent consomme ses propres tokens. À n'utiliser que si les tâches sont *vraiment* indépendantes et fastidieuses.

---

# Cartes mentales

```text
               WORKFLOW DE DÉVELOPPEMENT OPTIMAL AVEC CLAUDE CODE
                                      │
            ┌─────────────────────────┼─────────────────────────┐
            ↓                         ↓                         ↓
    1. IMPLÉMENTATION         2. RECHERCHE DE BUGS         3. REFACTORING
(Vous ou l'agent codez)    (Le code est écrit, on teste)  (Les tests sont au vert)
            │                         │                         │
            ↓                         ↓                         ↓
      `npm test`              `/code-review --fix`          `/simplify`
 (Échoue si bugs evidents)  (Corrige les edge-cases)    (Nettoie la dette tech)
            │                         │                         │
            └──────────<──────────────┴───────────<─────────────┘
                                      │
                         SI TÂCHE MASSIVE (>20 fichiers)
                              Utiliser `/batch`
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Quand utiliser quoi ?
- Pour trouver des bugs avant de commiter : `/code-review high`
- Pour trouver des bugs et les corriger : `/code-review high --fix`
- Pour critiquer une Pull Request d'un collègue sur GitHub : `/code-review medium --comment [ID_PR]`
- Pour nettoyer son code brouillon qui marche enfin : `/simplify`
- Pour refactoriser une architecture sur 50 fichiers : `/batch [instruction]`
```

> **La phrase centrale de la leçon :**
> `/code-review` s'assure que votre code fait ce qu'il est censé faire (sans rien casser), tandis que `/simplify` s'assure que votre code le fait de la manière la plus lisible et idiomatique possible.
