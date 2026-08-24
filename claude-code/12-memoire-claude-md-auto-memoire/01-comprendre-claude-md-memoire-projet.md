---
title: "Comprendre CLAUDE.md : la mémoire de projet et les instructions persistantes"
description: "Comprendre comment CLAUDE.md conserve les instructions propres à un projet."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - claude-md
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 01-comprendre-claude-md-memoire-projet
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre `CLAUDE.md` et les permissions ?** | `CLAUDE.md` est du *contexte* injecté dans le prompt système. Il influence le modèle, mais ne crée **aucune barrière d'exécution**. (Mettre "ne lis jamais .env" n'empêche pas techniquement la lecture). |
| **Qu'est-ce qui différencie la mémoire explicite de l'automatique ?** | La mémoire **explicite** (`CLAUDE.md`) est écrite par l'équipe, versionnée et durable. La mémoire **automatique** est écrite par Claude (à partir de ses erreurs), locale à votre machine et demande une supervision. |
| **Combien de tokens consomme le fichier `CLAUDE.md` ?** | Il consomme directement des tokens dans la fenêtre de contexte de *chaque session*. Il doit donc rester **court** (cible < 200 lignes) pour ne pas polluer l'attention du modèle et augmenter le coût. |
| **Que faut-il mettre en priorité dans le `CLAUDE.md` ?** | Des informations **non évidentes** : la vraie commande de test, les patterns de migration (quel code copier, quel code ignorer), les gotchas d'environnement et l'architecture du projet. |
| **Que faut-il NE PAS mettre dans `CLAUDE.md` ?** | Des tutos complets, une doc API, des procédures multi-étapes complexes (réservez ça aux Skills) ou des interdictions de sécurité strictes (réservez ça aux permissions/hooks). |

## Synthèse
Le fichier `CLAUDE.md` constitue la mémoire de projet : il permet de transmettre à l'agent les commandes spécifiques, les conventions d'équipe et les pièges connus de la base de code pour éviter de les répéter à chaque session. Attention cependant : `CLAUDE.md` n'est *que* du contexte injecté en début de prompt, il ne remplace en aucun cas les règles de permission (allow/deny) pour la sécurité. L'erreur la plus fréquente consiste à le transformer en longue encyclopédie ; un `CLAUDE.md` doit rester **court, spécifique et actuel**, idéalement sous les 200 lignes. Les informations plus longues ou très ciblées doivent être externalisées vers des *skills* ou des règles locales, tandis que la mémoire automatique de Claude (visible via `/memory`) viendra compléter ce fichier avec des apprentissages locaux.

## Glossaire
- **`CLAUDE.md`** : Mémoire explicite de l'équipe. Fichier Markdown versionné à la racine (ou dans `.claude/`) lu au démarrage de la session.
- **`CLAUDE.local.md`** : Mémoire locale et personnelle. Non versionnée (dans `.gitignore`), utile pour ses propres commandes.
- **Mémoire automatique** : Fonctionnalité où Claude note ses propres apprentissages (erreurs, chemins fréquents) dans des fichiers locaux.
- **`/memory`** : Commande pour vérifier l'état de la mémoire, lister les fichiers `CLAUDE.md` chargés et activer/désactiver la mémoire automatique.
- **Adhérence des instructions** : La propension du modèle à respecter une règle. Une règle "diluée" dans 1000 lignes de texte a une très faible adhérence.

## Questions d'auto-évaluation
1. L'équipe a un vieux fichier `README.md` avec l'historique du projet depuis 2018. Faut-il le copier dans `CLAUDE.md` pour aider l'agent ?
2. J'ai écrit `N'utilise jamais la commande 'rm -rf'` dans mon `CLAUDE.md`. L'agent est-il techniquement bloqué s'il essaie ?
3. Le projet utilise une ancienne librairie HTTP dans 80% du code, mais on migre vers une nouvelle. Comment éviter que Claude ne copie l'ancien code par mimétisme ?
4. Où va l'instruction "Avant de faire un commit, lance le linter" : dans `CLAUDE.md` ou dans un `Hook` ?

# Comprendre `CLAUDE.md` : la mémoire de projet

**Durée : 15 minutes**

## Objectif de la leçon
Comprendre le rôle de `CLAUDE.md` comme contexte injecté, identifier ce qui doit y figurer (et surtout ce qui ne doit *pas* y figurer) pour maintenir une haute qualité de réponse sans exploser le coût en tokens.

---

# 1. `CLAUDE.md` n'est PAS une règle, c'est du contexte

C'est la leçon la plus importante : **`CLAUDE.md` ne contrôle rien techniquement.**
Le contenu du fichier est ajouté au prompt système au démarrage de votre session. 

- S'il dit `"Utilise pnpm"`, Claude saura qu'il doit utiliser pnpm.
- S'il dit `"Ne lis pas les fichiers .env"`, Claude va essayer de s'y conformer. **MAIS** il a toujours techniquement le droit d'utiliser l'outil `Read(./.env)`.

Pour de la sécurité ou du blocage déterministe, utilisez les permissions ou les Hooks.

---

# 2. Mémoire explicite vs Mémoire automatique

Il y a deux façons pour Claude de se souvenir de choses entre les sessions :

1. **Mémoire explicite (`CLAUDE.md`)** : C'est vous, l'humain, qui l'écrivez. C'est la vérité de l'équipe, elle est versionnée sur Git et révisée en PR.
2. **Mémoire automatique** : C'est Claude qui l'écrit. Quand il galère sur un bug, ou trouve la bonne commande de build, il prend des notes pour "la prochaine fois". C'est stocké en local sur votre machine.

> [!TIP]
> **Diagnostiquer avec `/memory`**
> La commande `/memory` vous permet de voir quels fichiers `CLAUDE.md` sont chargés, si la mémoire automatique est active, et d'ouvrir ces fichiers de notes pour faire le ménage.

---

# 3. Qu'est-ce qu'un "bon" CLAUDE.md ?

Un fichier `CLAUDE.md` est chargé dans la fenêtre de contexte à **chaque session**. S'il fait 1000 lignes, vous payez ces 1000 lignes à chaque requête, et Claude risque d'oublier la règle ligne 452 (dilution des instructions).

**La règle d'or : Court (< 200 lignes), Spécifique, Actuel.**

| À mettre (Informations non évidentes) | À bannir (Bruit documentaire) |
|---|---|
| La commande exacte : `pnpm test:unit` | "Fais attention aux tests" (trop vague) |
| Le pattern de migration en cours (Quel code copier, quel code fuir) | L'historique des choix architecturaux depuis 3 ans |
| Les "gotchas" spécifiques de l'environnement (ex: "redis se lance via docker-compose up") | La copie d'une doc API complète trouvable sur le web |

---

# 4. Le cas des migrations partielles

Quand vous migrez un projet (ex: de React vers Vue, ou d'une lib A vers B), la base de code contient **deux patterns concurrents**.

C'est très dangereux pour Claude : il lit un fichier au hasard, voit l'ancien pattern (car majoritaire), et le reproduit pour son nouveau code !

**Solution dans `CLAUDE.md` :**
```text
Le projet est en migration progressive.
Ancien pattern (A NE PLUS UTILISER) :
Client API classique dans src/api/
Nouveau pattern (À UTILISER OBLIGATOIREMENT) :
Fetch wrapper dans src/lib/http-client.ts.
```

---

# Cartes mentales

```text
               LA MÉMOIRE DANS CLAUDE CODE
                           │
           ┌───────────────┼───────────────┐
           ↓                               ↓
   MÉMOIRE EXPLICITE               MÉMOIRE AUTOMATIQUE
       (Humaine)                       (Agentique)
           │                               │
       CLAUDE.md                      Notes locales
    Versionné, partagé              Brouillon de l'IA
           │                               │
   Contient : commandes,         Contient : apprentissages,
   gotchas, conventions           débogages douloureux
           │                               │
           └───────────────┬───────────────┘
                           ↓
                   FENÊTRE DE CONTEXTE
           (Doit rester court et spécifique !)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Cycle de vie d'une instruction
1. Je répète la consigne au chat     → Perte de temps
2. Claude l'apprend (mémoire auto)   → Aide locale
3. C'est utile pour tous             → Ajout au CLAUDE.md
4. C'est trop long / une procédure   → Transformation en Skill
5. C'est une question de sécurité    → Déplacement dans permissions.deny
```

> **La phrase centrale de la leçon :**
> `CLAUDE.md` est le cerveau culturel du projet, pas son pare-feu. Gardez-le court pour maximiser l'adhérence de l'agent, et explicitez toujours quel pattern suivre dans une base de code hétérogène.
