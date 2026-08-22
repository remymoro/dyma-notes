---
title: "Ce que Claude Code peut voir"
description: "Comprendre quels fichiers, dossiers et éléments de l’environnement Claude Code peut utiliser pendant une session."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - contexte
  - workspace
  - fichiers
categories:
  - "Chapitre 5"
cours: Claude Code
chapitre: 05-fonctionnement-agents-code-claude-code
leçon: 05-ce-que-claude-code-peut-voir
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                                            | Notes détaillées                                                                                                                                                  |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| À partir de quoi Claude Code travaille-t-il ?                                       | À partir du projet, du dossier ou des fichiers rendus accessibles dans la session.                                                                                |
| Le projet entier est-il chargé automatiquement dans le contexte ?                   | Non. Claude construit progressivement sa compréhension à partir des fichiers consultés, des recherches, des commandes et des éléments fournis pendant la session. |
| Pourquoi le dossier de lancement est-il important ?                                 | Il constitue le point de départ principal de la session et influence la zone du projet que Claude peut explorer.                                                  |
| Que se passe-t-il si Claude Code est lancé à la racine du dépôt ?                   | Claude peut raisonner et explorer à l’échelle du projet entier.                                                                                                   |
| Pourquoi lancer Claude Code dans un sous-dossier ?                                  | Pour limiter le périmètre et concentrer le travail sur un package, un service ou un module particulier.                                                           |
| Qu’est-ce que le workspace local ?                                                  | Le dossier principal depuis lequel Claude Code est lancé et dans lequel il travaille pendant la session.                                                          |
| Le workspace Claude Code de la Console Anthropic correspond-il au dossier de code ? | Non. Il sert surtout à organiser l’usage et le suivi au niveau de l’organisation.                                                                                 |
| À quoi sert `/add-dir` ?                                                            | À ajouter un dossier supplémentaire à la session sans remplacer le dossier principal.                                                                             |
| À quoi sert `--add-dir` ?                                                           | À ajouter un dossier supplémentaire dès le lancement de Claude Code.                                                                                              |
| À quoi sert `/cd` ?                                                                 | À changer le dossier principal de travail de la session.                                                                                                          |
| Quelle différence entre `/add-dir` et `/cd` ?                                       | `/add-dir` élargit la session à un dossier supplémentaire, alors que `/cd` déplace le dossier principal de travail.                                               |
| Un fichier présent dans le projet a-t-il forcément été vu par Claude ?              | Non. Il peut exister sur disque sans avoir encore été ouvert, recherché ou intégré au contexte actif.                                                             |
| Comment donner un périmètre précis ?                                                | En indiquant directement les fichiers, dossiers, tests, logs ou erreurs pertinents.                                                                               |
| Pourquoi référencer précisément les fichiers ?                                      | Pour limiter l’exploration inutile et réduire le risque de raisonnement à partir d’un contexte incomplet.                                                         |
| Quelles autres sources Claude Code peut-il utiliser ?                               | Git, commandes exécutées, `CLAUDE.md`, mémoire locale, outils web, MCP, worktrees et intégrations externes.                                                       |

## Synthèse

Claude Code ne charge pas automatiquement tout le projet dans son contexte. Il travaille depuis un espace de travail donné et construit progressivement sa compréhension à partir des fichiers, dossiers et informations réellement consultés pendant la tâche.

## Glossaire

* espace de travail : zone principale du système de fichiers depuis laquelle Claude Code travaille.
* workspace local : dossier depuis lequel Claude Code est lancé.
* contexte : ensemble des informations réellement disponibles pour le raisonnement du modèle à un instant donné.
* périmètre : partie du projet concernée par une tâche.
* racine du dépôt : dossier principal contenant l’ensemble du dépôt.
* monorepo : dépôt contenant plusieurs applications, packages ou services.
* `/add-dir` : commande permettant d’ajouter un dossier supplémentaire à une session.
* `--add-dir` : option permettant d’ajouter un dossier supplémentaire au lancement.
* `/cd` : commande permettant de changer le dossier principal de la session.
* `CLAUDE.md` : fichier contenant des instructions persistantes pour Claude Code.
* worktree : espace Git séparé permettant de travailler sur une autre branche ou tâche en parallèle.
* MCP : protocole permettant à Claude Code d’accéder à des outils ou ressources externes.

## Questions d'auto-évaluation

1. Pourquoi le dossier depuis lequel Claude Code est lancé est-il important ?
2. Claude Code charge-t-il automatiquement tous les fichiers du projet dans son contexte ?
3. Quelle différence existe-t-il entre un fichier présent sur le disque et un fichier actif dans le contexte ?
4. Pourquoi peut-il être utile de lancer Claude Code dans un sous-dossier d’un monorepo ?
5. Quelle différence existe-t-il entre le workspace de la Console Anthropic et le workspace local ?
6. À quoi sert `/add-dir` ?
7. À quoi sert l’option `--add-dir` ?
8. Quelle différence existe-t-il entre `/add-dir` et `/cd` ?
9. Pourquoi ajouter un dossier supplémentaire à une session ?
10. Comment un fichier devient-il réellement utile au raisonnement de Claude ?
11. Pourquoi faut-il donner un périmètre clair à une tâche ?
12. Quel avantage apporte une référence directe comme `@src/auth/session.ts` ?
13. Pourquoi un dossier trop large peut-il augmenter le bruit d’exploration ?
14. Quelles autres sources d’information Claude Code peut-il utiliser en plus des fichiers ?
15. Quelle question est plus précise que simplement demander « À quoi Claude a accès ? »

# Ce que Claude Code peut voir

**Durée : 15 minutes**

## Notes

Claude Code ne travaille pas dans un espace abstrait.

Il travaille à partir d’un **projet**, d’un **dossier** et des différentes informations mises à sa disposition pendant la session.

Lorsqu’on lance Claude Code dans un dossier, celui-ci devient son espace de travail principal.

Par exemple :

```bash
cd /chemin/vers/mon-projet
claude
```

On peut représenter le point de départ ainsi :

```text
Système de fichiers
        │
        ↓
/mon-projet/
        │
        ↓
    claude
        │
        ↓
Session Claude Code
```

Le dossier de lancement influence donc directement le périmètre de travail.

Si Claude Code est lancé à la racine du dépôt :

```text
mon-projet/
├── frontend/
├── backend/
├── tests/
├── docs/
└── infrastructure/
```

Claude peut explorer le projet à cette échelle.

Dans un projet plus important, il peut être intéressant de démarrer dans une zone plus précise.

Par exemple :

```bash
cd mon-projet/backend
claude
```

Le point de départ devient alors plus ciblé.

On peut résumer cette idée ainsi :

```text
Dossier large
    ↓
exploration potentiellement large

Dossier ciblé
    ↓
travail davantage concentré
```

Dans un petit projet, démarrer à la racine est souvent logique.

Dans un monorepo ou une base de code importante, il peut être préférable de démarrer directement dans :

* un package ;
* un service ;
* une application ;
* un module ;
* une zone fonctionnelle.

Le mot **workspace** peut cependant avoir plusieurs significations.

Il existe notamment un workspace Claude Code au niveau de la Console Anthropic.

Celui-ci sert principalement à organiser l’utilisation de Claude Code et le suivi dans une organisation.

Ce workspace n’est pas directement le dossier contenant le code.

Pour le travail quotidien, le workspace important est surtout le **dossier local depuis lequel Claude Code est lancé**.

```text
Workspace organisationnel
→ organisation / usage / suivi

Workspace local
→ dossier de travail du projet
```

Claude Code peut également travailler avec plusieurs dossiers.

Si une session est déjà ouverte, on peut ajouter un dossier supplémentaire :

```bash
/add-dir ../bibliotheque-partagee
```

On peut également le faire au lancement :

```bash
claude --add-dir ../bibliotheque-partagee
```

Cela peut être utile lorsqu’un projet utilise plusieurs emplacements.

Par exemple :

```text
mon-projet/
    │
    │
    └── session principale
             │
             ├── fichiers du projet
             │
             └── ../bibliotheque-partagee
```

Un dossier supplémentaire peut contenir :

* une bibliothèque commune ;
* de la documentation locale ;
* un autre dépôt ;
* une configuration partagée ;
* des ressources utilisées par le projet.

`/add-dir` permet donc **d’élargir l’espace de travail disponible**.

Il ne remplace pas nécessairement le dossier principal.

Pour changer le dossier principal, on utilise plutôt :

```bash
/cd ../autre-projet
```

La différence peut être représentée ainsi :

```text
/add-dir
    ↓
ajoute un espace supplémentaire

/cd
    ↓
change le point de travail principal
```

Par exemple :

```text
Avant

projet-a/
   ↑
dossier principal
```

Avec :

```bash
/add-dir ../shared
```

on obtient conceptuellement :

```text
projet-a/
   ↑
principal

shared/
   ↑
supplémentaire
```

Alors qu’avec :

```bash
/cd ../projet-b
```

le point principal devient :

```text
projet-b/
   ↑
nouveau dossier principal
```

Une autre idée importante est que **le projet entier n’est pas injecté automatiquement dans le contexte du modèle**.

Il faut distinguer :

```text
Fichiers accessibles
        ≠
Fichiers actuellement dans le contexte
```

Un projet peut contenir des centaines ou des milliers de fichiers.

Claude n’a pas besoin de recevoir leur contenu complet immédiatement.

Il construit progressivement sa compréhension.

Par exemple :

```text
Projet
 │
 ├── fichier A
 ├── fichier B
 ├── fichier C
 ├── fichier D
 └── fichier E

Claude commence la tâche
        ↓
lit fichier B
        ↓
cherche une fonction
        ↓
ouvre fichier D
        ↓
analyse un test
```

Dans cet exemple, les fichiers `A`, `C` et `E` existent toujours dans le projet.

Mais ils ne sont pas nécessairement devenus utiles au raisonnement.

Un fichier devient plus directement exploitable lorsqu’il est :

* mentionné ;
* recherché ;
* ouvert ;
* lu ;
* résumé ;
* retourné par un outil ;
* intégré à la conversation.

On peut donc distinguer deux niveaux :

```text
Environnement accessible
        ↓
ensemble potentiel

Contexte actif
        ↓
informations réellement utilisées
```

Cette distinction est importante pour comprendre Claude Code.

Dire :

> Claude a accès au projet.

ne signifie pas :

> Claude possède immédiatement tout le projet dans sa fenêtre de contexte.

Claude peut **explorer** l’environnement au fur et à mesure que la tâche l’exige.

Pour améliorer la qualité du travail, il est donc utile de lui donner un **périmètre clair**.

Par exemple :

```text
Analyse @src/auth/session.ts.

Objectif :
expliquer comment ce fichier gère
le renouvellement de session.
```

Cette demande donne directement :

```text
Périmètre
→ @src/auth/session.ts

Objectif
→ comprendre le renouvellement de session
```

Claude sait ainsi où commencer son exploration.

Autre exemple :

```text
Analyse @src/billing/
et @tests/billing.test.ts.

Objectif :
comprendre pourquoi
les remises cumulées échouent.
```

Le périmètre devient :

```text
src/billing/
        +
tests/billing.test.ts
        ↓
zone initiale d'analyse
```

Ce type de cadrage évite une exploration inutile de l’ensemble du dépôt.

Le périmètre peut être donné à partir de plusieurs types d’artefacts :

* fichier ;
* dossier ;
* test ;
* log ;
* erreur ;
* sortie de commande ;
* configuration ;
* documentation.

Par exemple :

```text
Analyse :

@src/auth/
@tests/auth.spec.ts
@error.log
```

Claude dispose alors immédiatement de plusieurs points d’entrée pertinents.

Le principe général est donc :

```text
Demande vague
      ↓
Claude doit chercher largement
      ↓
davantage d'hypothèses

Demande cadrée
      ↓
Claude sait où regarder
      ↓
exploration plus ciblée
```

Le dossier principal n’est cependant qu’une partie de ce que Claude Code peut utiliser.

Au cours d’une session, d’autres sources peuvent participer à son travail.

Par exemple :

```text
Claude Code
│
├── fichiers du projet
├── dossiers ajoutés
├── état Git
├── sorties de commandes
├── CLAUDE.md
├── mémoire du projet
├── outils web
├── serveurs MCP
├── worktrees
└── intégrations externes
```

L’état Git peut fournir des informations sur :

* les fichiers modifiés ;
* la branche ;
* les différences ;
* l’historique du dépôt.

Les commandes peuvent produire :

* des résultats de tests ;
* des erreurs ;
* des builds ;
* des diagnostics ;
* des informations sur l’environnement.

`CLAUDE.md` peut apporter des instructions persistantes liées au projet.

Les outils web peuvent fournir des informations externes.

Les serveurs MCP peuvent donner accès à d’autres données ou systèmes.

Les worktrees peuvent fournir des espaces de travail séparés pour certaines tâches.

Claude Code construit donc son travail à partir d’un **ensemble de sources**, mais toutes ne sont pas automatiquement présentes dans son contexte au même moment.

La question importante n’est donc pas seulement :

```text
À quoi Claude peut-il accéder ?
```

mais plutôt :

```text
Qu'est-ce qui a réellement été rendu
visible et pertinent pour cette tâche ?
```

Cette distinction permet de mieux comprendre pourquoi le cadrage, le dossier de lancement et les fichiers fournis ont autant d’importance dans une session Claude Code.

## Points clés

* Claude Code travaille à partir d’un environnement réel de fichiers et de dossiers.
* Le dossier depuis lequel `claude` est lancé constitue le point de départ principal de la session.
* Lancer Claude Code à la racine permet une exploration plus large du dépôt.
* Lancer Claude Code dans un sous-dossier permet de réduire le périmètre.
* Dans un monorepo, un point de départ ciblé peut réduire le bruit.
* Le workspace organisationnel de la Console Anthropic n’est pas le dossier de code local.
* `/add-dir` ajoute un dossier supplémentaire à la session.
* `--add-dir` permet d’ajouter ce dossier dès le lancement.
* `/cd` permet de changer le dossier principal de travail.
* Ajouter un dossier et changer de dossier principal sont deux opérations différentes.
* Tous les fichiers accessibles ne sont pas automatiquement chargés dans le contexte.
* Un fichier peut exister dans le projet sans avoir encore été consulté par Claude.
* Claude construit progressivement sa compréhension du projet.
* Mentionner directement des fichiers ou dossiers aide à cadrer la tâche.
* Les logs, tests et erreurs peuvent également servir de points d’entrée.
* Un périmètre clair réduit l’exploration inutile.
* L’état Git peut participer au contexte de travail.
* Les sorties de commandes fournissent de nouvelles informations à Claude.
* `CLAUDE.md` peut ajouter du contexte persistant.
* Les outils web et MCP peuvent étendre les informations accessibles.
* Les worktrees permettent de travailler dans des espaces séparés.
* Il faut distinguer ce qui est techniquement accessible de ce qui est réellement présent dans le contexte actif.
