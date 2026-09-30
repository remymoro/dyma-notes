Comprendre une session en arrière-plan
Une session interactive occupe normalement le terminal. Une session en arrière-plan devient un processus indépendant. Vous pouvez fermer la vue, utiliser le terminal pour une autre tâche ou vous attacher à une session.
> Le superviseur s'exécute localement. Les sessions continuent si vous fermez le terminal ou `agent view`. Elles s'arrêtent si la machine est éteinte ou en veille.

Distinguer les trois niveaux de suivi
| Commande | Contenu affiché |
|---|---|
| `claude agents` | Toutes les sessions locales en arrière-plan de la machine. |
| `/agents` | Les sous-agents de la session et la bibliothèque des profils. |
| `/tasks` | Les travaux en arrière-plan rattachés à la session courante. |

Ouvrir agent view
`claude agents`
La vue contient une liste de sessions regroupées par état :
- `Working` : utilise outils ou génère réponse.
- `Needs input` : décision humaine attendue.
- `Idle` : disponible pour instruction.
- `Completed` / `Failed` : terminée.
- `Stopped` : arrêt manuel.
*(Ready for review : regroupe les sessions avec PR ouverte).*

Lancer plusieurs sessions
Depuis `agent view`, lancez des missions indépendantes (lecture seule, ou modification).
> Avant sa première modification, Claude Code déplace automatiquement la session dans un `worktree` sous `.claude/worktrees/`. Les sessions de lecture seule restent dans le dossier principal.
*Protection désactivable dans `.claude/settings.json` : `"worktree": { "bgIsolation": "none" }`.*

Lire et interagir avec l'aperçu
Sélectionnez avec ↑/↓, appuyez sur `Espace`. Affiche la question (si `Needs input`), le résultat, ou le statut. Vous pouvez répondre directement sans ouvrir la conversation.

S'attacher ou se détacher
- `Entrée` ou `→` : S'attacher à la session (la conv complète remplace agent view).
- `←` ou `/exit` : Revenir à agent view (détache sans arrêter).
- `/stop` : Arrêter réellement la session.

Placer une conversation en arrière-plan
- Depuis la conversation : `/bg <mission>` ou `/background`. Rejoint `agent view`.
- Depuis le shell : `claude --bg "<mission>"`. Retourne un ID.

Utiliser les commandes du shell
`claude attach <id>`, `claude logs <id>`, `claude stop <id>`, `claude rm <id>`.
> Après une mise en veille, redémarrez toutes les sessions arrêtées avec : `claude respawn --all`

Utiliser /tasks
Depuis une session, lancez un shell (ex: `! sleep 20 && npm test`) puis `Ctrl+B` pour la placer en arrière-plan.
`/tasks` affiche ce travail rattaché à la conversation. Les autres sessions de `agent view` n'apparaissent pas ici.

Connaître les raccourcis
`Espace` (aperçu), `Entrée/→` (attacher), `←` (détacher), `Ctrl+R` (renommer), `Ctrl+T` (épingler), `Ctrl+S` (grouper), `Ctrl+X` (arrêter/supprimer).

Conserver le travail avant une suppression
> Supprimer une session créée dans un worktree (via `Ctrl+X` ou `claude rm`) supprime également ce worktree et ses changements non committés.
Vérifiez l'état (`git -C .claude/worktrees/<nom> status --short`) avant de supprimer. Conservez les modifs avec un commit.
*Rappel : Une session isolée peut créer un commit/PR elle-même, spécifiez "ne pousse rien" pour l'empêcher.*
