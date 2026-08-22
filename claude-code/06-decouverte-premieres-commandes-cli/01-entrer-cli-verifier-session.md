---
title: "Entrer dans le CLI et vérifier que la session est saine"
description: "Prendre en main le CLI et contrôler l'état de la session avec les commandes essentielles."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - commandes
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-decouverte-premieres-commandes-cli
leçon: 01-entrer-cli-verifier-session
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-22
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Pourquoi vérifier le mini-projet AVANT d'ouvrir Claude Code ? | Pour disposer d'une base de référence saine et prouvée. Si un problème apparaît après coup, on sait qu'il vient soit de la session CLI (`/doctor`), soit d'une action de Claude (`git diff`) — jamais d'un projet déjà cassé au départ. |
| Différence entre une commande slash et une demande en langage naturel ? | Une commande slash (`/login`, `/status`...) pilote la **session ou le compte** et ne touche jamais aux fichiers du dépôt. Le langage naturel passe par le raisonnement du modèle et peut amener Claude à lire, exécuter ou modifier le **projet**, selon les permissions. |
| Pourquoi la première vraie demande à Claude est-elle en lecture seule ? | Ce n'est pas tant pour "éviter de casser du code" (le projet est minuscule) que pour **valider le contexte avant de faire confiance à Claude** : bon dossier, bonne compréhension du projet, bonne commande de vérification identifiée. |
| Que faire si une session se comporte bizarrement dès le début ? | Lancer `/doctor` avant de retravailler le prompt. Le prompt agit sur le raisonnement de Claude, pas sur la couche technique (auth, connectivité, installation). Un environnement défaillant ne se corrige pas avec un meilleur prompt. |
| Que fait `/login` ? | Se connecter au compte utilisé par Claude Code. Ne modifie jamais le projet. |
| Que fait `/status` ? | Vérifier l'état de la session : version, compte, modèle, connectivité. Réflexe de début de session. |
| Que fait `/doctor` ? | Diagnostiquer l'installation, les paramètres, la connectivité, et proposer des corrections pour les problèmes réparables. |
| Que fait `/help` ? | Afficher l'aide et les commandes disponibles **dans la session réelle** — la liste évolue avec les versions. |
| Que fait `/powerup` ? | Lancer un parcours interactif de découverte des capacités de Claude Code (mode, rewind, MCP, skills, hooks, sous-agents...). Ne modifie rien. |
| Pourquoi lancer `claude` depuis la racine du dépôt ? | Si le CLI est lancé depuis le mauvais dossier, Claude ne voit pas le bon contexte et peut analyser un autre répertoire. |
| Pourquoi initialiser un dépôt Git avant Claude Code ? | Pas obligatoire, mais permet de voir précisément ce que Claude modifie (diff) et de revenir en arrière si nécessaire. |

## Synthèse
Avant de laisser Claude Code toucher à un projet, il faut d'abord prouver que ce projet fonctionne seul (tests + build) et que la session CLI est saine (`/status`, `/doctor`). Les commandes slash pilotent le compte et la session sans jamais toucher aux fichiers, contrairement au langage naturel qui peut déclencher de vraies actions sur le code. La toute première demande réelle à Claude reste donc volontairement en lecture seule : elle sert à vérifier que l'agent comprend bien le bon projet avant de lui faire confiance pour une tâche de modification.

## Glossaire
- **CLI** : interface en ligne de commande à travers laquelle on interagit avec Claude Code.
- **Commande slash** : commande de session commençant par `/`, gérée directement par le CLI (pas par le raisonnement du modèle), et qui ne touche jamais au projet.
- **Session** : instance active de travail avec Claude Code, caractérisée par un compte, un modèle, une version et un état de connectivité.
- **`/login`** : commande permettant de se connecter au compte utilisé par Claude Code.
- **`/status`** : commande affichant l'état de la session (version, compte, modèle, connectivité).
- **`/doctor`** : commande de diagnostic de l'installation, des paramètres et de la connectivité.
- **`/help`** : commande affichant l'aide et les commandes disponibles dans la session en cours.
- **`/powerup`** : parcours interactif de découverte des capacités de Claude Code.
- **`/logout`** : commande de déconnexion du compte actuellement utilisé.
- **`claude update`** : commande (hors session interactive) permettant de mettre à jour le CLI Claude Code.
- **Prompt en lecture seule** : demande explicitement limitée à la lecture, sans autorisation de modification, utilisée pour valider le contexte avant une tâche réelle.
- **Fil rouge du chapitre** : le mini-projet `convertisseur-temperature`, volontairement simple, qui sert de support à toutes les leçons du chapitre 6.

## Questions d'auto-évaluation
1. Pourquoi faut-il vérifier `npm test` et `npm run dev` avant d'ouvrir Claude Code ?
2. Quelle est la différence de nature entre une commande slash et une demande en langage naturel ?
3. Pourquoi `/login` ne modifie-t-il jamais le projet ?
4. Que vérifie concrètement `/status` ?
5. Dans quel cas `/doctor` doit-il être lancé en priorité ?
6. Pourquoi `/help` ne doit-il pas être appris comme une liste figée ?
7. À quoi sert `/powerup`, et à quoi ne sert-il pas ?
8. Pourquoi le projet du chapitre est-il volontairement très simple (3 fonctions) ?
9. Que se passe-t-il si Claude Code est lancé depuis le mauvais dossier ?
10. Pourquoi initialiser un dépôt Git avant la première session Claude ?
11. Pourquoi la première vraie demande à Claude est-elle formulée en lecture seule ?
12. Que doit contenir le résumé final attendu de Claude après cette première demande ?
13. Pourquoi ne faut-il pas réécrire le prompt en premier réflexe si la session se comporte mal ?
14. Quelle est la preuve minimale utilisée dans ce chapitre pour vérifier que le code fonctionne ?
15. Pourquoi comparer un problème CLI à un problème projet est-il utile pour déboguer une session ?

# Entrer dans le CLI et vérifier que la session est saine

**Durée : 22 minutes**

**Commandes :** `/login`, `/status`, `/doctor`, `/help`, `/powerup`, `/logout` et `claude update`

## Objectif de la leçon

Avant de laisser Claude Code toucher à un projet, cette leçon installe un réflexe en deux temps : **prouver que le projet fonctionne seul**, puis **prouver que la session CLI est saine** — avant seulement d'envoyer une première demande, volontairement en lecture seule. Le fil rouge du chapitre, `convertisseur-temperature`, est délibérément minuscule pour que chaque action de Claude reste observable.

---

# 1. Pourquoi vérifier avant de faire confiance

Le risque n'est pas seulement que Claude « casse » quelque chose. Le vrai risque est de **perdre la capacité à diagnostiquer** ce qui s'est passé.

```text
Projet vérifié AVANT  +  problème observé APRÈS
        │
        ▼
la cause ne peut venir que de :
  - la session CLI          → /doctor
  - une action de Claude     → git diff


Projet NON vérifié AVANT + problème observé APRÈS
        │
        ▼
impossible de savoir si le projet était déjà cassé,
ou si Claude l'a cassé
```

C'est pour cette raison que la leçon impose un ordre strict : le projet doit passer ses propres tests **sans l'aide de l'agent**, avant même d'ouvrir `claude`.

---

# 2. Construire le fil rouge : convertisseur-temperature

Le projet est volontairement pauvre en dépendances : pas de framework, pas de bundler. Juste assez de structure pour être « un vrai petit projet JS » exploitable par Claude Code.

```text
convertisseur-temperature/
├── package.json
├── README.md
├── .gitignore
├── index.html
├── server.js
├── src/
│   ├── conversion.js      → logique métier (3 fonctions)
│   └── main.js             → interface (DOM)
└── test/
    └── conversion.test.js  → preuve minimale (node --test)
```

Trois fonctions seulement dans `conversion.js` : convertir Celsius → Fahrenheit, Fahrenheit → Celsius, et arrondir. Peu de fichiers, peu de risques d'ambiguïté, beaucoup de lisibilité pour observer ce que Claude fait plus tard dans le chapitre.

---

# 3. Vérifier le projet seul, avant Claude Code

```text
Mini-projet créé
      │
      ▼
npm test            → ✅ les 3 tests passent
      │
      ▼
npm run dev          → ✅ page accessible sur :5173
      │
      ▼
git init + commit    → ✅ état de référence versionné
      │
      ▼
claude                (lancé depuis la RACINE du dépôt)
```

Cette étape n'est pas une formalité. Elle évite exactement le piège identifié plus haut : **confondre un problème de projet avec un problème de CLI**. Une fois `npm test` vert et la page fonctionnelle, toute anomalie ultérieure ne pourra venir que de la session ou de Claude — jamais du point de départ.

Git n'est pas obligatoire pour ouvrir Claude Code, mais c'est le réflexe recommandé : il rend le diff de Claude observable et le retour en arrière possible.

---

# 4. Les commandes de session : piloter le compte, pas le projet

Une fois `claude` lancé depuis la racine du dépôt, les commandes en `/` ne sont **pas** des commandes du terminal classique — elles pilotent la session elle-même.

```text
Commande slash (/login, /status, /doctor, /help, /powerup)
        │
        ▼
   pilote la SESSION ou le COMPTE
        │
        ▼
   ne touche JAMAIS aux fichiers du dépôt


Langage naturel ("lis le README", "corrige ce bug"...)
        │
        ▼
   passe par le raisonnement du modèle
        │
        ▼
   peut lire / exécuter / modifier le PROJET
   (selon les permissions accordées)
```

### `/login` — s'authentifier

Vérifie que le compte est bien connecté. Utile surtout sur une machine neuve, une session fraîche ou un poste partagé. Ne modifie jamais le projet.

### `/status` — l'état de la session

Donne un aperçu de la version, du compte, du modèle et de la connectivité. À utiliser en réflexe de début de session — en formation notamment, pour éviter de comparer deux sessions dans des états différents sans le savoir.

### `/doctor` — diagnostiquer l'environnement

Repère les problèmes d'installation, d'authentification, de connectivité ou de paramètres, et peut proposer des corrections. **Premier réflexe** en cas de comportement étrange — avant de retoucher le prompt, puisque le prompt n'agit que sur le raisonnement, jamais sur la couche technique sous-jacente.

### `/help` — l'aide à jour

La liste des commandes disponibles évolue avec les versions. `/help` reste la seule source fiable **dans la session réelle**, plutôt qu'une liste mémorisée une fois pour toutes.

### `/powerup` — la visite guidée

Parcours interactif présentant les capacités à venir (codebase, modes, rewind, mémoire, MCP, skills, hooks, sous-agents, remote, modèles, effort). Ne modifie rien — sert seulement à construire une carte mentale du reste du cours.

---

# 5. La première vraie demande : lecture seule

Une fois la session validée, la première demande envoyée à Claude reste volontairement en lecture seule :

```text
Prompt de découverte (lecture seule)
      │
      ▼
Claude lit uniquement :
  package.json · README.md · arborescence · src/ · test/
      │
      ▼
Résumé attendu :
  1. rôle du projet
  2. commandes disponibles
  3. fichiers importants
  4. vérification à relancer avant toute modification
      │
      ▼
Résumé juste  → contexte validé → on peut passer à l'écriture
Résumé faux   → mauvais dossier / mauvaise compréhension → on corrige AVANT tout risque
```

Ce n'est pas d'abord une précaution contre la casse — le projet est trop simple pour vraiment risquer grand-chose. C'est un **test de confiance** : est-ce que Claude voit le bon dépôt, comprend sa structure, et sait déjà quelle commande il devra relancer après une future modification (`npm test`) ? Cette demande installe le réflexe central du chapitre : **comprendre d'abord, modifier ensuite**.

---

# 6. Ancrage sur ta stack (web front/back JS-TS)

Le `convertisseur-temperature` est structurellement identique à un petit projet front/back JS-TS réel : un `package.json`, un dossier `src/`, un dossier `test/`, un script de dev. Le réflexe de cette leçon se transpose donc directement :

- avant d'ouvrir Claude Code sur un de tes projets, vérifie que `npm test` (ou l'équivalent) passe **sans lui** ;
- lance `/status` et `/doctor` en début de session, surtout après un changement de machine, de compte ou de version du CLI ;
- pour une première exploration d'un repo existant ou peu familier, démarre par un prompt en lecture seule listant les fichiers clés et la commande de vérification — exactement le même prompt que celui de cette leçon, adapté à ton projet ;
- garde le réflexe Git : un `commit` de référence avant chaque session permet de lire le diff produit par Claude, quelle que soit la taille réelle du projet.

---

# Résumé & Schéma global

```text
Préparer            Vérifier seul         Ouvrir Claude          Contrôler          Première demande
le mini-projet   →   (npm test / dev)  →   depuis la racine   →   la session     →   (lecture seule)
                                             du dépôt              /login /status
                                                                    /doctor /help
                                                                    /powerup
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `npm test` | Vérifier la logique du projet — preuve minimale avant toute session Claude |
| `npm run dev` | Lancer le serveur de développement local (`http://localhost:5173`) |
| `git init` / `add` / `commit` | Créer un état de référence versionné avant d'ouvrir Claude Code |
| `claude` | Lancer le CLI — toujours depuis la racine du dépôt |
| `/login` | Se connecter au compte utilisé par Claude Code |
| `/logout` | Se déconnecter du compte actuellement utilisé |
| `/status` | Vérifier l'état de la session : version, compte, modèle, connectivité |
| `/doctor` | Diagnostiquer l'installation, les paramètres, les problèmes réparables |
| `/help` | Afficher l'aide et les commandes disponibles dans la session réelle |
| `/powerup` | Lancer le parcours interactif de découverte des capacités |
| `claude update` | Mettre à jour le CLI Claude Code |

# Les 5 points les plus importants

## 1. Vérifier le projet seul, avant Claude
`npm test` et `npm run dev` doivent réussir sans l'aide de l'agent — sinon impossible de savoir plus tard si un problème vient du projet ou de Claude.

## 2. Slash = session/compte, langage naturel = projet/fichiers
Les commandes en `/` ne touchent jamais au dépôt. Seul le langage naturel peut déclencher une lecture, une exécution ou une modification réelle du code.

## 3. `/doctor` avant de retoucher le prompt
Un environnement défaillant ne se corrige pas avec un meilleur prompt. Le réflexe en cas de comportement étrange est toujours le diagnostic, pas la reformulation.

## 4. La première demande reste en lecture seule
Elle sert à valider que Claude est dans le bon dossier et comprend correctement le projet — un test de confiance avant d'autoriser la moindre modification.

## 5. Lancer `claude` depuis la racine du dépôt
Le dossier de lancement détermine le contexte que Claude peut voir. Se tromper de dossier revient à faire travailler Claude sur le mauvais projet.

---

# Carte mentale

```text
Entrer dans le CLI et préparer une session saine
│
├── Avant Claude Code
│   ├── Créer le mini-projet (convertisseur-temperature)
│   ├── npm test        → preuve minimale
│   ├── npm run dev      → vérification manuelle
│   └── git init/commit  → état de référence
│
├── Ouvrir la session
│   └── claude (depuis la racine du dépôt)
│
├── Commandes de session (compte / session, jamais le projet)
│   ├── /login    → authentification
│   ├── /status   → état de la session
│   ├── /doctor   → diagnostic environnement
│   ├── /help     → aide à jour
│   ├── /powerup  → visite guidée
│   └── /logout, claude update
│
└── Première vraie demande
    ├── Lecture seule
    ├── Valide le bon dossier / la bonne compréhension
    └── Réflexe central : comprendre d'abord, modifier ensuite
```

---

# Mini fiche de révision

```text
AVANT Claude Code     → npm test + npm run dev + git commit
LANCER Claude Code    → depuis la racine du dépôt
/login                → compte (jamais le projet)
/status               → état de la session (réflexe de début)
/doctor               → diagnostic (réflexe si comportement bizarre)
/help                 → aide à jour dans la session réelle
/powerup              → visite guidée (rien à modifier)
1ère demande          → lecture seule = test de confiance
```

## Phrase à retenir

> Avant de demander à Claude d'agir, il faut vérifier que la session est saine et que le projet est déjà prouvé sain — comprendre d'abord, modifier ensuite.
