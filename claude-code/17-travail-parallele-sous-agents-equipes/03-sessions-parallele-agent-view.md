---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 03-sessions-parallele-agent-view
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre `claude agents`, `/agents` et `/tasks` ?** | - `claude agents` affiche TOUTES les sessions locales en arrière-plan.<br>- `/agents` liste les sous-agents d'une session et la bibliothèque des profils.<br>- `/tasks` n'affiche que les travaux/processus shell lancés en arrière-plan (via `Ctrl+B`) rattachés à la session courante. |
| **Que se passe-t-il si on ferme le terminal où tourne `agent view` ?** | Rien de grave. Le processus superviseur tourne en arrière-plan localement. Les sessions continueront (mais s'arrêteront si l'ordinateur se met en veille ou s'éteint). |
| **Comment relancer des sessions de fond après une mise en veille ?** | La commande shell `claude respawn --all` permet de réveiller et relancer les sessions stoppées. |
| **Peut-on interagir avec une session en arrière-plan sans "l'ouvrir" ?** | Oui, en la sélectionnant dans `agent view` et en appuyant sur `Espace`. Cela ouvre un **panneau d'aperçu** depuis lequel on peut directement répondre si la session est en statut `Needs input`. |
| **Pourquoi faut-il être vigilant avant de faire `Ctrl+X` ou `claude rm` sur une session d'arrière-plan ?** | La session s'étant automatiquement isolée dans un *worktree*, sa suppression effacera **immédiatement** le *worktree* et tout le code non commité qui s'y trouve. |

## Synthèse
L'outil `agent view` (`claude agents`) permet de transformer Claude Code en un véritable centre de commandement asynchrone. Plutôt que de bloquer votre terminal pendant une longue analyse, vous pouvez détacher vos sessions (`/bg`, `Ctrl+B` ou `claude --bg`). Ces sessions de fond sont gérées par un processus superviseur local. La grande force de ce système est sa sécurité : dès qu'une session asynchrone s'apprête à modifier un fichier, elle s'auto-isole dans un *worktree* Git pour ne pas interférer avec l'arbre principal (sauf désactivation explicite dans `settings.json`). L'interface `agent view` permet d'observer l'état de l'avancement (`Working`, `Needs input`, `Completed`), de répondre rapidement depuis un panneau d'aperçu (Touche `Espace`), de s'attacher à une conversation (Touche `Entrée`) et de la détacher pour la remettre en fond (Touche `←` ou `/exit`).

## Glossaire
- **Superviseur (Daemon)** : Processus qui tourne en toile de fond sur la machine, maintenant les sessions asynchrones de Claude actives même lorsque l'interface visuelle est fermée.
- **`Needs input`** : État d'une session en arrière-plan indiquant qu'elle est en pause, attendant une permission (ex: lancer une commande) ou une réponse de l'utilisateur.
- **`claude rm <id>` / `Ctrl+X`** : Commande pour supprimer définitivement une session d'arrière-plan, ce qui détruit le *worktree* associé et le travail non sauvegardé.
- **`Ctrl+B`** : Raccourci clavier permettant d'envoyer un script shell bloquant (ex: `! sleep 20 && npm test`) en tâche de fond pour libérer la ligne de commande de la session courante.

## Questions d'auto-évaluation
1. Quelles sont les 3 commandes possibles pour envoyer une tâche en arrière-plan ?
2. Comment afficher uniquement le résultat des tâches bash envoyées en fond au sein de votre conversation actuelle ?
3. Que devez-vous absolument vérifier avant d'appuyer deux fois sur `Ctrl+X` pour fermer une session dans `agent view` ?
4. Si vous vous êtes attaché à une session de fond (via la flèche `→`), comment revenir à la liste sans arrêter le travail en cours ?

# Sessions en parallèle et agent view (/bg et /tasks)

**Durée : 13 minutes**

## Objectif de la leçon
Apprendre à piloter de multiples itérations de travail simultanées en utilisant les sessions d'arrière-plan, l'interface `agent view` et les tâches asynchrones (`/tasks`). Maîtriser le passage de l'avant-plan vers l'arrière-plan tout en garantissant la sécurité des modifications.

---

# 1. Le Superviseur et `agent view`

Une session classique bloque votre terminal. Une session en arrière-plan devient un **processus indépendant** (supervisé localement). 
*Si vous fermez la fenêtre, la session continue. Si vous éteignez l'ordinateur, elle s'arrête.*

Pour ouvrir le centre de commande de ces sessions, tapez :
```bash
claude agents
```
*(Cela ouvre l'interface TUI : "Agent view").*

### Les états principaux des sessions :
- **Working** : Claude réfléchit ou exécute un outil.
- **Needs input** : Il attend une réponse ou une validation de votre part.
- **Idle** : En attente d'une nouvelle consigne.
- **Completed** / **Failed** : Mission terminée.

---

# 2. Navigation et Interaction rapide

L'interface `agent view` possède des raccourcis vitaux pour l'efficacité :

| Raccourci | Action (Interface `agent view`) |
|---|---|
| **`Espace`** | Ouvre un panneau d'aperçu rapide sur le côté. (Permet de répondre directement à un `Needs input` sans ouvrir la conversation). |
| **`Entrée`** ou **`→`** | **S'attacher** à la session. (La session occupe tout l'écran). |
| **`←`** ou **`/exit`** | **Détacher** la session. (Vous retournez à la liste, l'agent continue en fond). |
| **`/stop`** | Arrête l'agent (depuis l'intérieur d'une conversation). |
| **`Ctrl+X`** (x2) | Supprime définitivement la session de la liste. |

---

# 3. Mettre en arrière-plan : Les méthodes

Comment créer une session de fond ?

**1. Lancement depuis le shell :**
```bash
claude --bg "Exécute les tests et résume les erreurs"
```

**2. Lancement depuis une conversation classique :**
```bash
/bg écris la documentation de ce fichier
# ou
/background écris la documentation
```
*(Le terminal vous rend la main, la conversation part rejoindre `agent view`).*

**3. Lancer depuis la zone de texte de `agent view` :**
Tapez votre prompt directement dans la barre du bas de l'interface `claude agents`.

---

# 4. Le piège de la suppression (`Ctrl+X`)

**Sécurité intégrée** : Une session en arrière-plan qui effectue une modification de fichier va **automatiquement** s'isoler dans un nouveau *worktree* (sauf indication contraire dans `settings.json`).

> **ATTENTION :** 
> Si vous supprimez la session (`Ctrl+X` ou `claude rm <id>`), vous supprimez son *worktree* et **toutes les modifications non commitées** qu'il contient.

Avant de supprimer une session terminée, vérifiez ce qu'elle a produit en vous déplaçant dans son dossier, et faites un commit si le code vous convient !

---

# 5. La nuance fondamentale : `/agents` vs `/tasks` vs `claude agents`

Ne confondez pas ces trois interfaces :

1. **`claude agents` (Agent View)** : La vue globale du système. Montre TOUTES les sessions asynchrones de la machine.
2. **`/agents`** : Commande interne à une session. Affiche la bibliothèque de profils et les *sous-agents* rattachés à cette session.
3. **`/tasks`** : Commande interne. Elle affiche uniquement les **processus shell en arrière-plan** lancés depuis *cette conversation spécifique*.
   *Exemple d'usage : vous tapez `! npm test`, c'est très long, vous faites `Ctrl+B` (Background). La tâche shell passe en fond. Vous pouvez voir son statut avec `/tasks`.*

---

# Les 5 points les plus importants

1. L'interface `agent view` est un gestionnaire asynchrone (`claude agents`), à ne pas confondre avec la liste des processus shell d'une conversation (`/tasks`).
2. Les sessions en arrière-plan s'isolent d'elles-mêmes dans un *worktree* avant toute écriture pour ne pas polluer l'arbre local.
3. Le panneau d'aperçu (Touche `Espace`) est le meilleur moyen de valider des permissions (`Needs input`) à la chaîne sans entrer dans chaque conversation.
4. La flèche gauche (`←`) ou `/exit` détache la session mais la laisse tourner, tandis que `/stop` ou `Ctrl+X` l'interrompt pour de bon.
5. `claude respawn --all` est indispensable pour relancer toutes vos tâches de fond après que la machine ait été mise en veille.

---

# Carte mentale

```text
Sessions d'arrière-plan
├── 1. Interfaces
│   ├── claude agents (Vue Globale TUI)
│   ├── /agents (Profils et sous-agents internes)
│   └── /tasks (Processus shell / Ctrl+B)
├── 2. Pilotage (Raccourcis)
│   ├── Espace : Aperçu (réponse rapide)
│   ├── → ou Entrée : S'attacher
│   └── ← ou /exit : Se détacher (continue en fond)
├── 3. Envoi en fond
│   ├── /bg (depuis une conv)
│   └── claude --bg (depuis bash)
└── 4. Sécurité et Arrêt
    ├── Isolation auto en Worktree (à la 1ère écriture)
    └── Danger : claude rm supprime le code non commité !
```

---

# Mini fiche de révision

```text
/bg = envoie la conv en tâche de fond. claude agents = ouvre le dashboard.
Ctrl+B = envoie la commande bash actuelle en tâche de fond (visible avec /tasks).
Touche Espace = Aperçu + réponse rapide. Flèche gauche = Retour au dashboard.
Sessions de fond s'isolent en Worktree auto : attention lors de la suppression (Ctrl+X) = perte du code non commité !
Relancer après veille : claude respawn --all.
```

> **Phrase à retenir** : `/bg` gère des conversations asynchrones isolées, tandis que `Ctrl+B` puis `/tasks` gère des exécutions de commandes asynchrones à l'intérieur d'une conversation précise.
