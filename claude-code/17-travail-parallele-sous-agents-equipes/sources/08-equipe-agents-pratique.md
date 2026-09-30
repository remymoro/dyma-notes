Préparer la démonstration
La démonstration utilise trois membres (teammates) :
- `francais` : contrôle vocabulaire (lecture seule).
- `temperature` : contrôle formules (lecture seule).
- `strategiste-tests` : conçoit/ajoute les tests. **Seul autorisé à écrire un fichier** (`test/limites-temperature.test.js`).
*Cette répartition stricte évite les conflits d'écriture.*
Les profils `gardien-francais.md` et `gardien-temperature.md` doivent être présents.

Activer et demander l'équipe
On active via `export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` et on lance `claude`.
On préautorise `Bash(npm test)` dans `/permissions`.

> Prompt initial :
> "Crée explicitement une équipe d'agents (pas de simples sous-agents). Lance trois teammates :
> 1. `francais` (profil gardien-francais)
> 2. `temperature` (profil gardien-temperature)
> 3. `strategiste-tests` (profil general-purpose).
> Règles : crée task list partagée, communiquent directement, seul strategiste-tests modifie (uniquement `test/limites-temperature.test.js`), aucun commit, attends tous les teammates."

Construire la task list
Demandez au team lead de créer l'arbre de dépendances :
- Tâche 1 (`francais`) : auditer.
- Tâche 2 (`temperature`) : auditer.
- Tâche 3 (`strategiste-tests`) : inventorier les manquements (sans modifier).
- Tâche 4 : confronter les rapports. *(Dépend de 1, 2, 3)*.
- Tâche 5 (`strategiste-tests`) : créer fichier et tester. *(Dépend de 4)*.
- Tâche 6 (`temperature`) : relire. *(Dépend de 5)*.

Affichez la task list avec `Ctrl+T`. Les 3 premières sont actives, les autres bloquées.

Interagir avec l'équipe (in-process)
- **Observer** : `↑`/`↓` puis `Entrée` pour ouvrir le transcript d'un membre.
- **Parler directement** : Dans le terminal d'un membre, on peut ajouter une contrainte ("Vérifie les valeurs décimales"). Le message ne passe pas par le team lead.
- **Faire communiquer** : Via le lead, on peut orchestrer les échanges : *"Demande à temperature d'envoyer ses cas limites à strategiste. Demande à strategiste de contester les suggestions non prouvées."* (La livraison est automatique dans les *mailboxes*).

Autoriser l'écriture (Tâche 5)
Avant la tâche 5, rappelez formellement le périmètre au team lead, car les teammates partagent le **même dossier physique** et cela doit rester explicite :
> "Pour la tâche d'implémentation : seul strategiste-tests écrit dans `test/limites-temperature.test.js`. Il ne modifie aucun autre fichier. Exécute `npm test`."

Faire relire (Tâche 6)
La fin de la tâche 5 débloque la tâche 6 (revue par `temperature`). S'il trouve un problème, il doit envoyer son retour à `strategiste-tests`, qui reste **l'unique propriétaire du fichier**.

Synthétiser et arrêter
Demandez au team lead de conclure :
> "Attends que tous les teammates aient terminé. Produis une synthèse : défauts, tests ajoutés, suggestions rejetées... Ne modifie plus aucun fichier."

Demandez au chef d'arrêter les membres par leur nom :
> "Demande à francais, temperature et strategiste-tests de s'arrêter proprement."

Vérification finale
`git status --short` et `npm test`. Le seul changement fonctionnel attendu est le nouveau fichier de tests. La configuration de l'équipe (task list locale) est nettoyée à la fermeture, mais peut rester pour une reprise.
