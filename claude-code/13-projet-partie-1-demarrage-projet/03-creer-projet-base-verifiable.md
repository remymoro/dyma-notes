---
title: "Créer le projet depuis zéro et obtenir une base vérifiable"
description: "Comment générer un plan de socle technique (Walking Skeleton) strict à l'aide du Design Doc."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - architecture
  - monorepo
  - pnpm
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 03-creer-projet-base-verifiable
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-03
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quel est l'objectif de cette étape ?** | Préparer un **plan exact** du socle technique (fichiers à créer, commandes de validation), SANS encore générer le code. C'est l'étape qui sépare l'architecture de l'exécution. |
| **Pourquoi s'assurer que le dossier ne contient *que* `design-doc.md` ?** | Le `design-doc.md` doit rester l'unique source de vérité de l'agent. Aucun fichier `package.json` ou structure pré-existante ne doit l'influencer. |
| **Comment forcer l'agent à ne produire qu'un plan ?** | Via un prompt très strict : "Pour le moment, réponds avec : les fichiers à créer, leur rôle, et les commandes de validation." et l'interdiction de coder ("ne pas créer les fichiers, installer les dépendances..."). |
| **Comment relier les packages dans le monorepo ?** | En utilisant `pnpm workspaces`. Le package `claudoscope` (CLI) dépend de `@claudoscope/core` via la syntaxe de dépendance `"workspace:*"`. |
| **Que teste le "test minimal de santé" du *core* ?** | Il prouve simplement que le moteur (qui expose la fonction `analyze`) peut être appelé avec un tableau vide et renvoyer un tableau vide, sans aucune logique d'audit ou de règles implémentée. |
| **Que teste le "test minimal de santé" du *CLI* ?** | Il vérifie que la commande `scan` peut être appelée et qu'elle retourne un code `0` ou affiche un message "stub" sans faire appel au système de fichiers ou exécuter de véritables diagnostics. |

## Synthèse
Une fois le `design-doc.md` rédigé, la tentation est grande de laisser l'agent coder l'application d'un coup. C'est une erreur. Cette leçon explique comment contraindre Claude Code à produire un **plan d'exécution strict** d'un *Walking Skeleton* (un socle technique vide mais vérifiable) avant la moindre écriture de fichier. L'agent doit planifier un *monorepo pnpm* structuré autour de deux frontières d'architecture fermes : un package "core" absolument pur (aucune I/O, pas d'accès au système de fichiers) et un package "CLI" gérant les entrées/sorties. Ce plan n'inclut aucune logique métier : son seul but est de définir l'architecture des fichiers (ex: `tsconfig.base.json` à la racine, mode `composite` pour le core), les dépendances (`workspace:*`), les scripts de compilation et de test, et ce qui est explicitement *exclu* de ce premier jet. La "Gate" de sortie de cette session n'est pas du code, mais un document de planification détaillé et validé par l'humain.

## Glossaire
- **Walking Skeleton** : Squelette d'application qui traverse toutes les couches techniques (compilation, lint, tests) sans aucune logique métier.
- **Monorepo** : Dépôt unique contenant plusieurs sous-projets (ici géré par `pnpm workspaces`).
- **`workspace:*`** : Protocole pnpm permettant à un package du monorepo d'importer directement le code local d'un autre package sans passer par un registre npm.
- **`corepack`** : Outil natif Node.js permettant d'activer et de gérer la version de `pnpm` utilisée dans le projet sans l'installer globalement.
- **Mode `composite` (TypeScript)** : Option de configuration (`tsconfig.json`) indispensable dans un monorepo pour permettre à TypeScript de référencer d'autres sous-projets compilés indépendamment.

## Questions d'auto-évaluation
1. Au début de cette session de planification, quels fichiers sont présents dans le dossier du projet ?
2. Quelle commande utiliser pour activer `pnpm` si Node.js est installé mais que la commande n'est pas reconnue ?
3. Le package `core` de Claudoscope peut-il utiliser le module `fs` de Node.js pour lire le fichier `CLAUDE.md` ? Pourquoi ?
4. Quel est le résultat attendu du moteur `analyze` du package `core` dans cette phase de "squelette" ?

# Créer le projet depuis zéro et obtenir une base vérifiable

**Durée : 20 minutes**

## Objectif de la leçon
Passer du *Design Doc* au **Plan de Socle Technique** : demander à l'agent de lister tous les fichiers nécessaires, leurs rôles et les commandes de validation d'un squelette vide, sans lui laisser l'autorisation d'écrire ces fichiers.

---

# 1. État zéro et préparation de l'environnement

**La règle d'or** : Votre dossier de travail ne doit contenir qu'un seul et unique fichier : `design-doc.md`.

Aucun `package.json`, aucun `node_modules`, aucune structure préétablie. Le Design Doc est la source de vérité.

Si vous utilisez `pnpm` (comme recommandé dans le design doc de Claudoscope) et que la commande n'est pas reconnue, utilisez **Corepack** (intégré à Node.js) :
```bash
corepack enable
pnpm -v
```

---

# 2. Forcer l'agent à planifier (Le Prompt)

Comme toujours, la clé réside dans les contraintes posées dans le prompt :
```text
Nous sommes dans un dépôt vide.
Je vais te renseigner le fichier @design-doc.md.
Dans cette session, tu dois me préparer le socle technique.
(...)
Pour le moment, réponds avec :
- les fichiers à créer
- le rôle de chaque fichier
- les commandes de validation.
```
L'agent doit comprendre que sa **Gate de sortie** est la présentation d'un plan complet, et non la production du code métier. Il ne doit **rien coder, rien installer**.

---

# 3. Ce que le plan doit contenir (Le Squelette / Walking Skeleton)

L'agent doit vous présenter une architecture respectant vos décisions. Pour le projet Claudoscope, c'est un **monorepo pnpm** séparé en deux :

### 1. La Racine (L'outillage commun)
- `package.json` privé gérant les dépendances de développement (`typescript`, `vitest`, `eslint`).
- `pnpm-workspace.yaml` (pour déclarer le dossier `packages/*`).
- Configurations communes : `tsconfig.base.json`, `eslint.config.js`.

### 2. Le Package Core (`@claudoscope/core`)
- **Responsabilité** : Recevoir le texte en mémoire, appliquer les règles, renvoyer les diagnostics.
- **Interdictions** : AUCUNE LECTURE FICHIER (`fs`), pas de réseau, pas de `console.log`.
- **Test de santé** : Une fonction `analyze([], [])` qui renvoie `[]`.

### 3. Le Package CLI (`claudoscope`)
- **Responsabilité** : Exposer la commande, lire les fichiers, appeler le `core`.
- **Connexion** : Il dépend du core via `"@claudoscope/core": "workspace:*"`.
- **Test de santé** : Un exécutable factice (`index.js`) qui fait un simple `console.log("stub")` et retourne le code `0`.

---

# 4. Le Hors-périmètre : ce qui ne doit PAS être dans le plan

Un bon plan définit aussi ce qui ne sera **pas fait**. Le socle technique ne doit contenir :
- Aucune règle métier (pas de vérification de longueur de fichier).
- Aucun appel réel à `fs.readFile`.
- Aucun Snapshot métier généré.
- Aucune configuration GitHub Actions.

---

# 5. Les commandes de validation du plan

Le plan produit par l'agent doit se terminer par les commandes qui prouveront (plus tard, quand le code sera écrit) que le squelette fonctionne parfaitement de bout-en-bout :

```bash
pnpm install
pnpm run lint
pnpm run typecheck
pnpm run test
pnpm run build
node packages/cli/dist/index.js scan
```
Tant que l'agent ne propose pas une chaîne de commandes claires et déterministes qui passent toutes "au vert" sur un socle vide, le plan n'est pas validé.

---

# Cartes mentales

```text
              L'ANATOMIE DU WALKING SKELETON
                           │
             ┌─────────────┴─────────────┐
             ↓                           ↓
      RACINE (MONOREPO)             LES PACKAGES
  - pnpm-workspace.yaml          ┌────────┴────────┐
  - package.json racine          ↓                 ↓
  - tsconfig.base.json         CORE               CLI
  - eslint.config.js       (Moteur pur)      (Entrées/Sorties)
                           - Sans "fs"       - Lit les fichiers
                           - Sans I/O        - Dépend de "workspace:*"
                           - Test "vide"     - Commande stub
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les 3 étapes de la session de planification :
1. Partir d'un dossier vide avec le seul `design-doc.md`.
2. Donner le Design Doc à l'agent avec un prompt interdisant l'écriture de code.
3. Valider le plan (Architecture, Séparation des responsabilités, Hors-périmètre, et chaîne de validation CI/tests).
```

> **La phrase centrale de la leçon :**
> Le but du socle technique (Walking Skeleton) n'est pas de résoudre le problème métier, mais de prouver que l'on peut exécuter, compiler et tester de bout-en-bout une architecture vide, sans aucune erreur.
