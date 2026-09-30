---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 01-introduction-travail-parallele
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Lancer plusieurs agents sur une tâche la rend-elle toujours plus rapide ?** | **Non**. Si la tâche est *strictement séquentielle*, le multi-agent n'ajoute que du temps de démarrage (création de contexte) et de la latence pour la synthèse. |
| **Quelle différence majeure entre un *Sous-Agent* et une session *Arrière-plan* (`/bg`) ?** | Le sous-agent est lancé et coordonné par la conversation *principale*, qui gère son rapport. La session `/bg` est supervisée *humainement* via `agent view` (vous l'avez lancée, vous la consultez). |
| **Comment un sous-agent connaît-il le contexte ou les *skills* de la conversation principale ?** | Il ne les connaît pas ! Un sous-agent démarre avec un contexte "frais" (vide). C'est la conversation principale qui doit lui fournir une mission ultra-synthétique et explicite. |
| **L'équipe d'agents (`AGENT_TEAMS: "1"`) isole-t-elle automatiquement les fichiers ?** | **Non**. Les coéquipiers ont des contextes IA séparés, mais travaillent dans le *même dossier Git*. Il faut impérativement leur partitionner les fichiers dans le prompt, sinon ils écrasent mutuellement leur code. |
| **Que font les profils d'agents `Explore` et `Plan` ?** | Ils sont dédiés à la recherche/compréhension sans pouvoir de modification (`Write`/`Edit` refusés). **Attention** : Ils sont *one-shot*, n'ont pas d'historique de reprise, ne voient pas le `git status` et ignorent le fichier `CLAUDE.md`. |
| **Quand faut-il utiliser la commande `/btw` (By the way) ?** | Pour poser une question courte nécessitant l'historique déjà présent dans votre contexte actuel, évitant ainsi le coût et la latence de lancer un sous-agent. |

## Synthèse
Le travail parallèle n'est utile que si la tâche peut être découpée en unités indépendantes. Pour exploiter cette indépendance, Claude Code propose plusieurs paradigmes de coordination. 
- Les **sous-agents** permettent de déléguer une analyse ciblée et d'en obtenir uniquement la conclusion, allégeant la conversation principale. 
- Les **sessions en arrière-plan** (`/bg`) permettent à l'humain de superviser de multiples itérations de fond, qui s'isolent d'elles-mêmes dans des *worktrees* avant toute écriture. 
- Enfin, les **équipes d'agents** (expérimentales) s'auto-coordonnent mais exigent une stricte séparation des fichiers pour éviter les conflits, car leurs cerveaux sont isolés mais pas leur clavier. 
Dans tous les cas, déléguer consomme beaucoup de jetons et engendre une perte d'information (le rapport final omet les détails). Le *prompt* de délégation doit donc exiger des "preuves structurées" (fichiers touchés, codes de sortie).

## Glossaire
- **Sous-agent (Sub-agent)** : Agent éphémère invoqué par la conversation principale pour une tâche ciblée. Naît avec un contexte vierge.
- **`/bg` (Background session)** : Session Claude asynchrone supervisée par l'humain via l'interface `agent view`. 
- **Profil d'agent** : Archétype d'IA définissant un rôle, un modèle et un jeu d'outils restreint (ex: `Explore`, `Plan`, `general-purpose`). S'invoque via `@nom` ou `--agent`.
- **`/btw` (By the way)** : Raccourci pour poser une question décorrélée de l'objectif principal de la session, mais utilisant le contexte actuel, sans créer de sous-agent.
- **Fork (`/subtask`)** : Sous-agent spécial qui, contrairement au sous-agent normal, hérite de tout l'historique et du *pool* d'outils exact de la conversation parente.

## Questions d'auto-évaluation
1. Quelles sont les conditions requises pour qu'une tâche soit réellement parallélisable ?
2. Un sous-agent `Explore` peut-il modifier le code ou lire vos directives dans le `CLAUDE.md` ?
3. Que se passe-t-il automatiquement avant qu'une session en arrière-plan (`/bg`) n'écrive son premier fichier ou commit ?
4. Pourquoi est-il critique de demander au sous-agent un rapport structuré avec les "codes de sortie" et les "fichiers modifiés" ?

# Introduction au travail en parallèle

**Durée : 12 minutes**

## Objectif de la leçon
Comprendre quand et comment diviser le travail en sous-agents ou sessions d'arrière-plan. Apprendre à utiliser les différents profils d'agents (`Explore`, `Plan`) et distinguer l'isolation cognitive (contexte IA) de l'isolation physique (dossier Git).

---

# 1. Le mythe de la vitesse

Ajouter des agents ne rend **pas** magiquement une tâche plus rapide.
Si la tâche est séquentielle (ex: `1. Créer API -> 2. Faire interface -> 3. Tester`), le multi-agent n'ajoute que de la latence de démarrage et de transfert d'informations.

**Pour être confiée à un sous-agent, une tâche doit avoir :**
- Une entrée claire.
- Un périmètre borné.
- Le moins de dépendances possibles.

---

# 2. Les 3 modèles de coordination

| Modèle | Coordination | Isolation fichiers |
|---|---|---|
| **1. Sous-agents** | La conversation principale gère tout et reçoit un résumé. | **Non** (sauf isolation via worktree). |
| **2. Sessions `/bg`** | L'humain gère via `agent view`. | **Oui** (Worktree auto avant le 1er commit). |
| **3. Équipe d'agents** | Un agent "Chef" gère une liste de tâches partagée. | **Non** (Il faut partitionner les fichiers). |

> **Règle d'or :** Distinguez l'isolation du *contexte* de l'isolation des *fichiers*. Deux coéquipiers d'une "Agent Team" ont des cerveaux isolés mais écrivent dans le même dossier `src/` ! S'ils touchent au même fichier, il y aura conflit (tests imprévisibles, écrasements).

---

# 3. Profils d'agents et Invocation

Claude propose des profils spécialisés. Invoquez-les avec `@profil`.

```text
 ┌─────────────┬─────────────────────────────────┬─────────────────────┐
 │ Profil      │ Limites                         │ Cas d'usage         │
 ├─────────────┼─────────────────────────────────┼─────────────────────┤
 │ Explore     │ Pas de Write/Edit. One-shot.    │ Comprendre le code  │
 │             │ Ignore CLAUDE.md & git status.  │                     │
 │ Plan        │ Pas de Write/Edit. One-shot.    │ Planifier           │
 │ general-    │ Analyse complexe, peut coder.   │ Tâches multi-étapes │
 │ purpose     │ Reste sur plusieurs tours.      │ (le travailleur)    │
 └─────────────┴─────────────────────────────────┴─────────────────────┘
```

**Comment invoquer ?**
- `@Explore analyse le dossier` : Garantit le lancement de ce profil précis.
- `claude --agent Explore` : Remplace l'agent principal pour toute la session CLI.

---

# 4. Le danger : La perte d'information

Un sous-agent retourne **toujours** un rapport synthétique à l'agent parent. S'il a vu une erreur, testé 5 hypothèses, puis réussi à la 6e, il ne renverra souvent qu'un lapidaire : *"C'est bon, j'ai corrigé le module"*.

**La parade du prompt de délégation :**
Exigez des preuves structurées dans votre demande !
> "Retourne les conclusions et leurs preuves :
> - fichiers consultés ;
> - commandes exécutées et codes de sortie ;
> - limites de l'implémentation."

---

# 5. Quel mécanisme choisir ? (Le Cheat-Sheet)

| Le Besoin | Le Mécanisme adapté |
|---|---|
| Question rapide nécessitant tout mon historique | **`/btw`** (By the way) |
| Mission longue nécessitant mon historique actuel | **Fork** (`/subtask`) |
| Recherche ciblée dont seul le résumé compte | **Sous-agent** |
| Plusieurs missions asynchrones à superviser moi-même | **`/bg`** et **`agent view`** |
| Remplacement d'une tâche massive de Search & Replace | **`/batch`** |
| Tâche petite ou très séquentielle | **Session classique** (Un seul agent) |

# Les 5 points les plus importants

1. Ne parallélisez que si les tâches n'ont pas de dépendances strictes entre elles.
2. Un sous-agent n'a pas accès au contexte de la session parente (historique, fichiers ouverts).
3. Les profils `Explore` et `Plan` sont "bâillonnés" : ils ne peuvent pas écrire de code, ne lisent pas `CLAUDE.md` et ne sont valables que pour un *one-shot*.
4. Une session d'arrière-plan (`/bg`) s'auto-protège en s'isolant dans un worktree avant toute écriture git destructive.
5. Une "Agent Team" (expérimental) n'isole pas les fichiers. C'est à vous (via le prompt) d'interdire formellement aux coéquipiers de toucher aux mêmes fichiers.

---

# Carte mentale

```text
Le travail Parallèle
├── 1. Les Sous-agents (Conversation parente)
│   ├── Contexte neuf et indépendant
│   ├── Danger : Perte d'info à la synthèse
│   └── Parade : Exiger des "preuves structurées"
├── 2. Profils spécialisés (@Explore, @Plan)
│   ├── Lecture seule
│   └── Ignorent CLAUDE.md et git status
├── 3. Arrière-plan (/bg et agent view)
│   ├── Supervisé par l'humain
│   └── S'isole en worktree avant écriture
└── 4. Équipes (Agent Teams)
    ├── Chef et Coéquipiers s'auto-gèrent
    └── Risque fatal : écrasement de fichiers (pas de worktree auto)
```

---

# Mini fiche de révision

```text
Parallélisme = utile seulement si tâches indépendantes.
Sous-agent = cerveau neuf. Fork (/subtask) = cerveau dupliqué (hérite de l'historique).
@Explore / @Plan = Lecture seule + ignorent le CLAUDE.md.
/bg = Asynchrone humain + Worktree auto.
Équipe d'agents = Indépendance du contexte MAIS fichiers partagés = Risque de conflits (partitionner !).
Toujours exiger du sous-agent un rapport contenant : fichiers touchés, commandes et codes de sortie.
```

> **Phrase à retenir** : Les sous-agents isolent les raisonnements, mais les *worktrees* isolent les fichiers. Sans worktree, plusieurs "cerveaux" tapent sur le même clavier.
