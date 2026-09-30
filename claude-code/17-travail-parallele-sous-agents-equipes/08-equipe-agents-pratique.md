---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 08-equipe-agents-pratique
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi faut-il imposer explicitement un "propriétaire" de fichier dans une équipe d'agents ?** | Parce que les *teammates* travaillent dans le même dossier local (pas d'isolation via *worktree*). Si on ne désigne pas un propriétaire exclusif (ex: *"seul `strategiste-tests` peut écrire dans ce fichier"*), les agents risquent de s'écraser mutuellement leurs modifications. |
| **Comment définir les dépendances entre les tâches de l'équipe ?** | Il faut demander au `Team lead` de construire une *Task list* avec des dépendances logiques (ex: "Tâche 4 dépend de 1, 2 et 3"). Une tâche restera à l'état `pending` (bloquée) tant que les tâches dont elle dépend n'auront pas atteint l'état `completed`. |
| **Comment forcer des échanges directs entre deux *teammates* sans intervention du *Team lead* ?** | On demande au `Team lead` de transmettre un ordre de communication, par exemple : *"Demande à `temperature` d'envoyer ses cas limites à `strategiste-tests`"*. Le message sera alors livré automatiquement dans la `Mailbox` du destinataire. |
| **Pourquoi faut-il demander explicitement au *Team lead* de patienter avant de conclure ?** | Le chef d'équipe, voyant les premières analyses arriver, peut être tenté de produire sa synthèse finale et de clôturer la session alors qu'une tâche est encore `in progress`. Il faut toujours lui préciser : *"Attends que tous les teammates aient terminé avant la synthèse"*. |
| **Comment clôturer proprement la session d'une équipe ?** | On ne tue pas les processus violemment. On demande au `Team lead` : *"Demande à [noms des teammates] de s'arrêter proprement."* Cela leur permet de finir leur écriture en cours avant de se terminer. |

## Synthèse
Cette leçon met en pratique l'orchestration complexe d'une "Agent Team". La clé du succès repose sur une ségrégation extrêmement stricte des responsabilités. Le `Team lead` (agent principal) reçoit un prompt massif définissant les rôles de trois *teammates* (ex: deux auditeurs en lecture seule, et un seul implémenteur avec le droit d'écrire sur un fichier précis). 
L'orchestration passe par la création d'une *Task list* (visible via `Ctrl+T`) qui gère les dépendances séquentielles (audit -> choix -> implémentation -> relecture croisée). L'humain agit comme un chef de projet : il navigue entre les terminaux des agents (`in-process`), injecte des consignes spécifiques directement à un agent si besoin, déclenche des discussions inter-agents (via la *mailbox*), et rappelle constamment les règles de non-collision de fichiers. Enfin, l'humain supervise la conclusion en forçant le `Team lead` à attendre que toute l'équipe ait terminé avant de produire la synthèse finale et de dissoudre l'escouade.

## Glossaire
- **Propriétaire de fichier** : Concept logique (imposé via le prompt) garantissant qu'un seul *teammate* est autorisé à modifier un fichier donné, évitant ainsi les conflits Git.
- **`pending` / `in progress` / `completed`** : Les trois états fondamentaux d'une tâche dans la *Task list* partagée de l'équipe.
- **Arrêt propre** : Requête envoyée aux *teammates* via le *Team lead* pour leur demander de s'arrêter sans corrompre le travail en cours.

## Questions d'auto-évaluation
1. Si l'Agent A audite le vocabulaire et l'Agent B audite les formules, pourquoi aucun des deux ne doit avoir le droit d'ajouter les tests manquants qu'ils découvrent ?
2. Que se passe-t-il si vous oubliez d'activer la variable d'environnement `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` avant de lancer la session ?
3. Comment faire pour qu'un agent relise le travail d'un autre agent sans modifier lui-même le code ?
4. Dans quel fichier/interface l'utilisateur peut-il valider `npm test` pour qu'un agent l'exécute en arrière-plan ?

# Équipe d'agents en pratique

**Durée : 7 minutes**

## Objectif de la leçon
Orchestrer de A à Z une équipe de trois agents autonomes pour accomplir un processus métier complet (Audit parallèle > Confrontation > Implémentation > Relecture croisée), en maîtrisant les dépendances de tâches, la communication inter-agents, et la protection absolue contre les conflits de fichiers.

---

# 1. Le Casting et les Règles d'or

Une équipe réussie repose sur la séparation des pouvoirs. Pour éviter que deux agents ne modifient le même code, on désigne un unique "écrivain".

- **`francais`** : Profil `gardien-francais`. Contrôle le vocabulaire. **Lecture seule.**
- **`temperature`** : Profil `gardien-temperature`. Contrôle les formules. **Lecture seule.**
- **`strategiste-tests`** : Profil standard. Compile les rapports, conçoit et implémente les tests manquants. **C'est le seul autorisé à modifier le projet.**

> **Prérequis de démarrage :**
> - Exporter `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
> - Pré-autoriser `Bash(npm test)` dans `/permissions`.

---

# 2. Le Prompt d'initialisation du Chef

Vous (l'humain) parlez au `Team lead`. Votre prompt doit tout structurer.

> *"Crée explicitement une équipe d'agents. Lance trois teammates : `francais`, `temperature`, et `strategiste-tests`.
> Règles : Crée une task list partagée. Ils doivent communiquer directement. Seul `strategiste-tests` peut créer le fichier `test/limites.test.js`. Aucun autre fichier ne doit être modifié. Aucun commit. Attends tous les teammates avant la synthèse."*

---

# 3. Construire l'arbre des Tâches (Task List)

Plutôt que de laisser l'équipe improviser, dictez l'ordre d'exécution au `Team lead`. Une tâche ne commencera que si ses "dépendances" sont terminées.

**L'arbre idéal :**
- **Tâche 1** (francais) : Auditer.
- **Tâche 2** (temperature) : Auditer.
- **Tâche 3** (strategiste) : Inventorier (sans modifier).
- **Tâche 4** (strategiste) : Confronter les rapports. *(Dépend de 1, 2, 3)*.
- **Tâche 5** (strategiste) : Créer le fichier de test. *(Dépend de 4)*.
- **Tâche 6** (temperature) : Relire le fichier créé par le strategiste. *(Dépend de 5)*.

> *Tapez `Ctrl+T` pour afficher le panneau des tâches. Les tâches 4, 5, 6 afficheront `pending` (bloquées) le temps que les audits se terminent.*

---

# 4. Le management "Micromanagement" (Optionnel)

L'interface `in-process` permet de manager l'équipe en temps réel :

- **Parler directement à un membre** : Utilisez les flèches `↑` et `↓`, tapez `Entrée` sur le terminal d'un membre (ex: `temperature`), et envoyez-lui une consigne de dernière minute : *"Vérifie les valeurs décimales"*. Ce message court-circuite le `Team lead`.
- **Forcer une discussion** : Demandez au `Team lead` d'ordonner un échange : *"Demande à temperature d'envoyer ses cas limites à strategiste"*. Le message sera livré dans la `Mailbox` de l'agent concerné.

---

# 5. Protéger l'étape d'écriture (Tâche 5)

RAPPEL CRITIQUE : L'équipe travaille sans *worktree* isolés. Avant que la tâche 5 d'implémentation ne démarre, il est recommandé de rafraîchir la mémoire du `Team lead` :

> *"Pour la tâche d'implémentation, seul strategiste-tests écrit. Il crée uniquement test/limites.test.js. Il ne modifie aucun autre fichier. Il exécute npm test."*

### La boucle de relecture croisée (Tâche 6)
Quand le fichier est créé, `temperature` prend le relais pour le relire (Tâche 6).
S'il détecte une erreur (ex: un test est redondant), **il ne doit pas corriger lui-même**. Il doit renvoyer son retour à `strategiste-tests`, car c'est lui le **propriétaire exclusif** du fichier !

---

# 6. Synthèse et Clôture propre

Le travail est terminé ? Il faut rapatrier l'intelligence vers le `Team lead`.

1. **La Synthèse** : *"Attends que tous les teammates aient terminé. Produis une synthèse : défauts scientifiques, incohérences confirmées, tests ajoutés... Ne modifie plus rien."*
2. **L'Arrêt de l'équipe** : On ne ferme pas le terminal brutalement. On dit au chef : *"Demande à francais, temperature et strategiste-tests de s'arrêter proprement."*

En quittant la session, vous n'aurez qu'un seul nouveau fichier non commité (le fichier de test), un dépôt propre, et un résumé brillant fourni par le `Team lead`. Les fichiers temporaires de configuration d'équipe seront nettoyés automatiquement.

---

# Les 5 points les plus importants

1. Pour réussir une équipe d'agents, il faut un "écrivain unique" (Propriétaire de fichier) et des lecteurs/auditeurs. Cela élimine les conflits Git.
2. Une *Task list* structurée avec des dépendances explicites garantit que l'implémentation ne commencera pas avant la fin des audits.
3. L'humain peut interagir directement avec un membre de l'équipe en ouvrant son terminal (`in-process`), court-circuitant ainsi la hiérarchie.
4. Les *teammates* peuvent communiquer entre eux (via les *mailboxes*), souvent sur ordre du *Team lead*. En cas de désaccord lors d'une relecture, l'auditeur critique et le propriétaire modifie.
5. Il faut toujours imposer au *Team lead* d'attendre la fin de l'équipe avant de résumer, et clôturer la session en demandant l'arrêt "propre" des agents.

---

# Carte mentale

```text
Orchestration d'Équipe
├── 1. Initialisation
│   ├── Activer Teams + Pré-autoriser Bash
│   └── Prompt : Casting, Rôles, 1 seul écrivain
├── 2. Structure (Task List)
│   ├── Audits (En parallèle)
│   ├── Confrontation (Dépendance)
│   └── Implémentation puis Relecture (Séquentiel)
├── 3. Supervision Humaine
│   ├── Ctrl+T (Monitoring)
│   ├── Messages directs (Corrections de cap)
│   └── Forçage de communication (Mailbox)
└── 4. Clôture
    ├── Exiger l'attente de la fin des tâches
    ├── Demander la synthèse au Lead
    └── Ordonner l'arrêt propre
```

---

# Mini fiche de révision

```text
Équipe d'agents = Risque de conflits locaux.
Solution = Un seul Agent autorisé à écrire, les autres sont des "Gardiens" en lecture seule.
Task List = Gère l'ordre d'exécution grâce aux "dépendances" (Tâche Y attend Tâche X).
Communication = Les agents peuvent s'envoyer des résultats validés via leur "Mailbox" interne.
Arrêt = Toujours demander au chef d'arrêter poliment les agents pour ne pas corrompre le code.
```

> **Phrase à retenir** : Le succès d'une équipe d'agents ne dépend pas de leur IA individuelle, mais de la clarté architecturale de la *Task list* et des territoires (fichiers) que vous leur avez assignés au départ.
