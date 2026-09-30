Comprendre le besoin de coordination
Les sous-agents retournent le résultat à la conversation principale. Mais si plusieurs agents doivent se coordonner, se contester ou se répartir des tâches, une **équipe d'agents** (Agent Teams) est plus adaptée.
La session principale devient le `team lead` (chef d'équipe). Elle lance les `teammates` (membres), organise les tâches, suit et synthétise. Chaque `teammate` a sa propre fenêtre de contexte.
> Utilisateur -> Team lead -> (Teammate A <--> Teammate B) + Task list + Mailbox.

Connaître le statut expérimental
Les équipes sont désactivées par défaut.
Activer via `settings.json` : `"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"` ou `export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

Comparer Équipe et Sous-agents
- Équipe : Liste de tâches partagée, messages directs entre membres, interaction directe possible avec l'utilisateur, coût plus élevé.
- Cas adaptés : revue parallèle sous plusieurs angles, investigation multi-hypothèses.
- Non adaptés : petite correction, étapes strictement séquentielles, *modifications du même fichier*.

Comprendre l'architecture et le contexte
- `Task list` (pending, in progress, completed) et `Mailbox`. L'équipe se forme au lancement du 1er teammate.
- Un teammate charge le contexte normal (`CLAUDE.md`, `skills` du projet, `MCP` configurés) mais **ne reçoit pas** l'historique complet du team lead. Le message de lancement doit être précis (limites, etc).

La liste de tâches et la communication
- Tâches dépendantes : bloquées jusqu'à complétion des autres.
- Les membres reçoivent un nom prévisible au lancement (ex: `conversion`, `tests`).
- Messages arrivent automatiquement, le chef n'a pas besoin de les "poller".

Choisir un mode d'affichage
- Mode par défaut : `in-process` (tous les membres dans le même terminal).
- Mode `split panes` : exige tmux ou iTerm2.
- Raccourcis (`in-process`) : `↑`/`↓` pour sélectionner, `Entrée` pour parler, `Ctrl+T` pour afficher la task list, `x` pour arrêter.

Choisir les modèles
Le team lead peut lancer un teammate avec un profil existant (ex: `avec le profil test-reviewer`). Le teammate n'utilise pas forcément le modèle actuel du chef, mais il hérite de son `effort`. Les `skills` et `mcpServers` d'un profil ne sont pas repris par l'équipe (le teammate prend ceux du projet global).

Exiger l'approbation d'un plan et Permissions
Pour une mission risquée, exigez un mode `plan`. **Le team lead approuve ou refuse le plan de manière autonome !**
Les membres ont les permissions du team lead. Un teammate ne peut pas vous forcer la main, la demande apparaît chez le chef. Pré-autorisez les commandes avant !

Éviter les conflits de fichiers
> Les équipes ne créent pas de `worktrees`. Deux membres qui modifient le même fichier vont s'écraser.
Attribuez des fichiers distincts : (Teammate A -> src/conversion.js, Teammate B -> src/batch.js).

Dimensionner et limites
- 3 à 5 membres maximum.
- 1 seule équipe par session.
- Reprise incertaine, coût élevé en jetons.
- Le chef peut conclure trop tôt. Précisez : *"Attends que tous les teammates aient terminé avant de synthétiser."*
- Pour arrêter, demandez au chef d'envoyer une requête d'arrêt : *"Demande au teammate tests de s'arrêter proprement."* Il peut refuser s'il est en train de sauvegarder un travail vital.
