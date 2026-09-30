Pourquoi utiliser plusieurs agents ?
Un agent unique peut tout faire. Le travail multi-agent n'est pas une obligation. Il est utile si la demande se divise en missions indépendantes.
Avantages : Vitesse (travaux en parallèle), Contexte (ciblé, pas de pollution), Spécialisation (outil/modèle adapté), Indépendance (contexte frais pour vérifier).

> Plusieurs agents ne rendent pas automatiquement une tâche plus rapide. Le parallélisme produit un gain uniquement si les missions peuvent avancer sans attendre leurs résultats respectifs.
Si les tâches sont strictement séquentielles, lancer trois agents ajoute du temps de démarrage et de synthèse sans gain.

Décomposer le travail
Une grande tâche n'est pas toujours parallélisable. Une unité de travail doit posséder :
- entrée identifiable
- objectif borné
- périmètre clair
- sortie exploitable
- preuve de fin
- le moins de dépendances possible.

Trois organisations de coordination
Claude Code propose trois organisations principales :
1. sous-agents dans une conversation ;
2. sessions en arrière-plan dans agent view ;
3. équipe d'agents coordonnée par un chef.

(Worktrees et `/batch` complètent ces organisations).

1. Sous-agents coordonnés par la conversation principale
La conversation principale décompose, lance les sous-agents (A, B, C) et reçoit un rapport synthétique de fin.
> Un sous-agent normal commence avec une nouvelle fenêtre de contexte. Il ne voit pas automatiquement l'historique, les fichiers lus ou les skills. La conversation principale lui transmet une mission synthétique.
Le sous-agent peut envoyer un message direct avec `SendMessage`.
C'est utile quand seule la conclusion de la mission secondaire est utile à la conversation principale.

2. Sessions en arrière-plan (agent view)
Lancées via `claude agents`, `claude --bg "..."` ou `/bg ...`.
La coordination reste humaine : vous lancez, consultez l'état, répondez aux questions.
> Avant sa première modification dans un dépôt Git, la session s'isole automatiquement dans un worktree sous `.claude/worktrees/` (sauf si l'isolation vaut `none`).
Une session isolée peut créer un commit, pousser sa branche, et ouvrir une PR en brouillon sans demander autorisation.

3. Équipe d'agents (expérimental)
Nécessite la variable `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`.
Une équipe contient un chef d'équipe, des coéquipiers, une liste de tâches partagée et une messagerie.
> Une équipe n'isole pas automatiquement ses coéquipiers dans des worktrees. Le prompt doit attribuer des fichiers distincts pour éviter l'écrasement ou l'invalidation croisée.

Distinguer isolation contexte / fichiers
Deux agents dans des contextes isolés mais partageant le même dossier Git peuvent écraser les modifications de l'autre ou faire échouer les tests. Solutions : attribuer des fichiers distincts, worktrees, ordonner, ou intégrateur unique.

Les profils intégrés
- `Explore` : Explore le code. Hérite de Claude, `Write`/`Edit` refusés. Plafond Opus.
- `Plan` : Planification. `Write`/`Edit` refusés.
- `general-purpose` : Analyse complexe et code.
> `Explore` et `Plan` ne chargent pas `CLAUDE.md`, n'ont pas `git status`, sont one-shot, et ne retournent pas d'identifiant de reprise. S'il faut une règle projet, répétez-la dans le prompt de délégation.

Comment invoquer un profil ?
- Nom dans le prompt : Claude décide.
- Mention `@` : Garantit l'exécution (`@Explore`).
- `--agent` : Remplace le prompt système par défaut et devient l'agent principal. (`--agents` pour un JSON de profils temporaires).
*Les sous-agents ont un pool d'outils restreint (pas de Write, etc. selon le mode), sauf avec un Fork qui hérite du pool de la conv parente.*

Autres limites
- Consommation (jetons multipliés).
- Perte d'information lors de la synthèse (demandez des preuves structurées : fichiers, emplacements, codes de sortie).
- Conflits.
- Surcharge de coordination.

Quand conserver une SEULE conversation ?
Correction petite, étapes séquentielles, même contexte, même fichier, ou latence prioritaire.
> Pour une question courte sur l'information déjà dans le contexte, utilisez `/btw` (by the way) plutôt qu'un sous-agent.

Résumé des mécanismes :
- Recherche ciblée / seule la conclusion compte -> Sous-agent.
- Exige l'historique -> Fork (`/subtask`).
- Plusieurs missions à superviser humainement -> `/bg` et `agent view`.
- Auto-coordination -> Équipe d'agents.
- Tâche fortement séquentielle -> Conversation principale.
