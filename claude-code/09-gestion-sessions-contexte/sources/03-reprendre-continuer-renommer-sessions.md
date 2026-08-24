# Reprendre, continuer et renommer les sessions

Dans Claude Code, une session est une conversation enregistrée localement et liée à un répertoire de projet. Elle ne correspond pas seulement à l’écran actuellement ouvert dans le terminal. Elle désigne une trajectoire de travail persistée : messages utilisateur, réponses de Claude, appels d’outils, résultats d’outils, événements de compaction, métadonnées et informations nécessaires à la reprise.

Reprendre une session ne signifie donc pas recommencer la tâche. Cela signifie rouvrir une conversation déjà enregistrée, avec le même identifiant de session, puis ajouter de nouveaux messages à cette conversation existante. La session continue d’accumuler de l’historique, au lieu de créer une trajectoire indépendante.

Cette distinction est importante dans un chapitre consacré au contexte. Une session peut survivre à la fermeture du terminal, à un redémarrage ou à un `/clear`. En revanche, la fenêtre de contexte active reste limitée. La reprise donne accès à l’historique de session, mais elle ne garantit pas que chaque détail ancien soit encore visible sous forme brute par le modèle. La session durable et le contexte vivant ne sont pas la même chose.

## La session comme unité de travail persistante

### Une conversation liée au projet
Une session est attachée à un répertoire de projet. Lorsque vous travaillez dans un dépôt, Claude Code écrit progressivement la transcription de la conversation dans le stockage local associé à ce projet. C’est ce lien entre session et répertoire qui permet ensuite de retrouver les conversations pertinentes depuis le même projet ou depuis les worktrees du même référentiel.

Cette organisation évite de traiter toutes les conversations comme une seule masse globale. Une tâche dans un dépôt d’authentification, une tâche dans un dépôt frontend et une tâche dans un dépôt d’infrastructure ne doivent pas se mélanger. Le sélecteur de sessions commence donc par le périmètre local du projet, puis peut être élargi si nécessaire.

La session n’est pas seulement une mémoire textuelle. Elle est une trace d’exécution. Elle peut contenir des lectures de fichiers, des sorties de commandes, des refus de permissions, des compactages, des résultats de sous-agents et des métadonnées utiles pour reconstruire la conversation.

### Une transcription locale
Les transcriptions de session sont stockées localement sous `~/.claude/projects/`, dans des fichiers `JSONL`. Chaque ligne correspond à un objet de transcription : message, appel d’outil, résultat d’outil ou entrée de métadonnées.

```bash
~/.claude/projects/
# Contient les transcriptions locales des sessions par projet
~/.claude/projects/nom-du-projet/session-id.jsonl
# Contient la transcription d’une session précise.
```
Le nom du sous-dossier sous `projects/` n’est pas exactement le nom du projet : il est dérivé du chemin absolu du répertoire, les caractères non alphanumériques étant remplacés, et un nom trop long étant tronqué puis complété par une empreinte. C’est pourquoi un même projet ouvert depuis deux chemins différents peut produire deux dossiers de sessions distincts.

Cette forme de stockage a une conséquence pratique : une session peut être reprise parce que Claude Code peut relire la transcription et reconstruire l’état conversationnel. Le papier d’architecture décrit cette persistance comme un modèle essentiellement append-only : les événements sont ajoutés au fil de l’eau, ce qui favorise la reprise, l’audit et la reconstruction.

Vous pouvez aussi exporter une copie lisible de la conversation courante avec `/export`. Sans argument, la commande copie la transcription dans le presse-papiers ou propose de l’enregistrer dans un fichier ; avec un nom de fichier, elle écrit directement dedans. C’est utile pour archiver une décision ou partager un échange hors du stockage interne.

### Ce qui est enregistré et ce qui ne l’est pas
La conversation, les messages, les utilisations d’outils et les résultats sont enregistrés. Les grandes sorties d’outils peuvent être externalisées dans des fichiers séparés. Les transcriptions de sous-agents peuvent être conservées dans des fichiers séparés associés à la session parente. Les checkpoints de fichiers relèvent d’un stockage distinct, qui sera traité dans la leçon sur le rembobinage.

En revanche, les permissions accordées uniquement pour la session ne doivent pas être comprises comme une confiance permanente. Lors d’une reprise, la conversation est reconstruite, mais le contexte de permissions est recalculé à partir de la configuration actuelle, des paramètres et du répertoire. Les autorisations temporaires approuvées dans une session précédente ne sont pas automatiquement restaurées.

La reprise conserve la continuité du travail ; elle ne transporte pas toute la confiance ancienne. C’est un choix de sécurité. Une autorisation accordée hier dans une branche ou un état de projet précis ne doit pas nécessairement rester valide après un changement de branche, de dépendances, de fichiers ou d’objectif.

## Continuer la session la plus récente

### La logique de continuation
Continuer signifie reprendre automatiquement la session la plus récente dans le répertoire courant. C’est l’option la plus rapide lorsque vous savez que la dernière conversation du projet est bien celle que vous voulez rouvrir.
```bash
claude -c
# Continue la session la plus récente du répertoire courant
```
Ce comportement est volontairement direct. Il ne demande pas à l’utilisateur de choisir dans une liste. Il prend la dernière session trouvée dans le périmètre du projet courant. S’il n’y a aucune session à continuer dans ce périmètre, Claude Code ne peut pas inventer une continuité : il indique qu’aucune conversation n’a été trouvée.

Continuer est adapté à la reprise immédiate, pas à la recherche historique. Si plusieurs conversations existent, ou si vous ne savez plus laquelle correspond à la tâche, il faut utiliser `/resume` ou la reprise par nom.

### Continuer en mode non interactif
La continuation peut aussi être utilisée avec le mode non interactif. Cela permet de reprendre une session existante, d’envoyer une instruction courte, puis de laisser Claude Code travailler sans ouvrir une conversation interactive complète.
```bash
claude -c -p "Reprends la dernière session et indique où nous en sommes"
# Continue la session la plus récente avec une instruction non interactive
```
Ce type d’usage est utile pour automatiser un contrôle, générer un état d’avancement, ou demander une vérification rapide à partir d’un contexte déjà construit. Il faut cependant rester prudent : une session longue peut contenir du contexte obsolète. Si la tâche a changé, continuer automatiquement peut réintroduire de mauvaises hypothèses.

Un point de vigilance propre à l’automatisation : en mode non interactif, `--continue` peut, dans certains cas, créer une nouvelle session au lieu de reprendre la plus récente. Pour un script où la continuité doit être garantie, préférez `--resume` avec un identifiant ou un nom de session explicite.

## Reprendre une session précise

### /resume dans une session active
`/resume` permet de basculer vers une autre conversation depuis une session active. Sans argument, la commande ouvre le sélecteur de sessions.
```bash
/resume
# Ouvre le sélecteur de sessions.
/continue
# Alias interactif de /resume.
```
Le fait que `/continue` soit un alias de `/resume` dans l’interface interactive ne doit pas être confondu avec la continuation automatique depuis le terminal. Dans le terminal, continuer signifie reprendre la session la plus récente. Dans une session active, `/continue` renvoie à la logique de reprise interactive.

Dans le doute, `/resume` est la commande la plus explicite. Elle dit clairement que l’on veut reprendre ou choisir une session existante.

### Reprendre par nom
Une session nommée peut être reprise directement par son nom. C’est la raison principale pour laquelle il faut nommer les sessions importantes.
```bash
/resume auth-refactor
# Reprend la session nommée auth-refactor depuis une session interactive
claude -r "auth-refactor"
# Reprend la session nommée auth-refactor depuis le terminal
claude -r "auth-refactor" "Continue la correction et commit"
# Reprend la session puis envoie une instruction initiale
```
La résolution du nom dépend du périmètre de recherche. Dans le contexte du référentiel courant, Claude Code cherche les sessions du projet et de ses worktrees. Si la correspondance est exacte, la session peut être reprise directement. Si le nom est ambigu, le comportement diffère selon l’entrée utilisée : la reprise depuis le terminal peut ouvrir le sélecteur préfiltré, tandis que `/resume nom` dans une session active peut signaler l’ambiguïté et demander d’utiliser le sélecteur sans argument.

### Reprendre par identifiant
Une session peut également être reprise par identifiant. C’est particulièrement utile pour les sessions créées en mode non interactif ou par le SDK, qui ne sont pas toujours affichées dans le sélecteur interactif.
```bash
claude -r "session-id"
# Reprend une session par son identifiant depuis le répertoire courant
```
La recherche par identifiant est plus stricte que la recherche par nom. Elle est limitée au répertoire de projet courant et à ses worktrees. Si la session a été créée ailleurs, il faut se placer dans le bon répertoire ou connaître le chemin de projet correspondant.

Le nom sert à retrouver humainement une tâche ; l’identifiant sert à retrouver techniquement une transcription précise.

### Reprendre la session liée à une pull request
Une session peut aussi être rouverte à partir de la pull request qu’elle a servi à créer. Lorsque vous ouvrez une PR depuis une session, Claude Code associe la conversation à cette PR.
```bash
claude --from-pr 128
# Reprend la session liée à la pull request numéro 128.
```
C’est pratique quand des commentaires de revue arrivent : vous retrouvez la session qui a produit la PR, avec son contexte d’origine, sans avoir à la chercher dans le sélecteur.

## Utiliser le sélecteur de sessions

### Ouvrir le sélecteur
Le sélecteur s’ouvre avec `/resume` depuis une session active, ou avec la reprise sans nom depuis le terminal.
```bash
/resume
# Ouvre le sélecteur depuis la session courante.
claude -r
# Ouvre le sélecteur depuis le terminal.
```
Chaque ligne affiche le nom de la session lorsqu’il existe. Sinon, Claude Code affiche un résumé de la conversation ou la première invite. Le sélecteur affiche aussi des informations opérationnelles comme l’activité récente, le nombre de messages et la branche Git.

### Raccourcis essentiels
```text
↑ / ↓
# Naviguer entre les sessions.
→ / ←
# Déplier ou replier un groupe de sessions.
Entrée
# Reprendre la session sélectionnée.
Espace
# Prévisualiser le contenu de la session.
Ctrl+R
# Renommer la session sélectionnée.
/
# Rechercher une session.
Ctrl+W
# Élargir aux worktrees du référentiel courant.
Ctrl+A
# Élargir à tous les projets de la machine.
Ctrl+B
# Filtrer sur la branche Git courante.
Esc
# Quitter le sélecteur ou la recherche.
```
Ces raccourcis sont importants parce qu’ils transforment `/resume` en outil de navigation, et pas seulement en commande de reprise. Dans un projet actif, plusieurs sessions peuvent exister en parallèle : une correction de bug, une revue de diff, une exploration d’architecture, une migration, une branche de test. Sans noms explicites et sans usage correct du sélecteur, ces conversations deviennent difficiles à distinguer.

### Étendre le périmètre de recherche
Par défaut, le sélecteur privilégie les sessions interactives du worktree courant. Il peut aussi afficher les sessions des autres worktrees du même référentiel ou de tous les projets de la machine. Cette logique évite de surcharger la vue par défaut, tout en permettant de retrouver une session quand elle n’est pas dans le périmètre immédiat.

Le périmètre de recherche doit être contrôlé. Reprendre une session du mauvais projet peut réintroduire un contexte totalement inadapté. Il faut donc vérifier le nom, la branche, le chemin et le contenu prévisualisé avant de basculer vers une session ancienne.

## Renommer les sessions

### Renommer pendant la session
`/rename` modifie le nom de la session courante. Le nom apparaît ensuite dans la barre d’invite et dans le sélecteur de sessions.
```bash
/rename auth-refactor
# Renomme la session courante.
/rename
# Génère un nom automatiquement à partir de l’historique
```
Un nom descriptif doit indiquer la tâche, pas l’humeur du moment. `auth-refactor`, `billing-test-fix`, `stripe-migration` ou `review-pr-128` sont utiles. `test`, `bug`, `à voir` ou `session-2` sont trop faibles.

Nommer une session est une opération de gestion du contexte futur. Le nom n’aide pas seulement maintenant. Il aide surtout lorsque vous devrez reprendre la bonne conversation plusieurs heures ou plusieurs jours plus tard.

### Nommer au démarrage
Une session peut aussi recevoir un nom dès son lancement. C’est utile lorsque l’objectif de travail est déjà clair avant d’entrer dans Claude Code.
```bash
claude -n "auth-refactor"
# Démarre une session nommée auth-refactor.
```
Nommer au démarrage est particulièrement adapté aux tâches longues : migration, refactorisation, revue de sécurité, correction de CI, exploration de sous-système, préparation de release. Dans ces cas, la session doit être considérée comme un espace de travail durable.

### Renommer depuis le sélecteur
Le sélecteur permet aussi de renommer une session sans l’ouvrir. Il suffit de la mettre en surbrillance et d’utiliser `Ctrl+R`.
```text
Ctrl+R
# Renomme la session sélectionnée dans le sélecteur.
```
Cette possibilité est utile pour nettoyer un historique de sessions après coup. Une conversation démarrée sans nom peut devenir importante. Il faut alors la renommer avant de la perdre dans une liste de résumés automatiques.

## Ce que la reprise restaure réellement

### La conversation continue sous le même identifiant
Lorsque vous reprenez une session, Claude Code rouvre la même conversation sous le même identifiant de session. Les nouveaux messages sont ajoutés à la transcription existante. Ce n’est pas une copie, ni une branche, ni une nouvelle conversation.

Reprendre modifie la session originale. Si vous voulez tester une approche différente sans toucher à la trajectoire d’origine, il faut utiliser une branche de session. Cette mécanique appartient à la leçon suivante, mais la distinction doit être claire dès maintenant : reprendre continue ; brancher copie puis sépare.

### La trace revient, mais pas toute la confiance
La reprise reconstruit l’historique conversationnel à partir de la transcription. Elle ne restaure pas automatiquement les permissions temporaires accordées dans la session précédente. Les règles de sécurité, les paramètres et le contexte de permission sont recalculés dans l’environnement actuel.

Cela peut produire une friction : Claude peut redemander une permission que vous aviez déjà accordée. Cette friction est voulue. Une session reprise peut se trouver dans un état de projet différent, avec une branche différente, des fichiers modifiés ou un objectif élargi. La confiance doit donc être établie dans le contexte courant.

### Le contexte actif reste borné
La session peut contenir beaucoup plus d’information que ce que le modèle voit à un instant donné. Lorsque l’historique devient long, Claude Code peut compacter, résumer ou projeter certaines parties. La reprise permet de retrouver la trajectoire, mais elle ne transforme pas la fenêtre de contexte en stockage infini.

La session est durable ; le contexte est sélectif. C’est la distinction la plus importante de cette leçon.

### Ce qui peut accompagner une reprise
**Objectifs actifs** : Si une session utilisait un objectif actif, celui-ci peut être restauré lors de la reprise si l’objectif n’avait pas encore été atteint ou effacé. La condition reste conservée, mais les compteurs de tours, les minuteurs et certaines bases de calcul sont réinitialisés à la reprise. Ce comportement est logique : l’objectif décrit ce qui doit rester vrai, mais l’exécution reprend dans un nouveau moment de travail.

**Tâches planifiées** : Lorsque des tâches planifiées existent dans la session, certaines tâches non expirées peuvent revenir avec la reprise.

**Sous-agents et arrière-plan** : Les sessions en arrière-plan et les sous-agents peuvent avoir leurs propres traces. Lorsqu’une session est reprise, ces traces peuvent rester utiles pour l’audit ou la continuation, mais elles ne sont pas automatiquement injectées en entier dans la conversation principale.

## Les pièges de la reprise

### Reprendre la mauvaise session
Le premier piège est de reprendre une session au nom trop vague. Si plusieurs conversations s’appellent `bug`, `test` ou `migration`, la reprise devient ambiguë. Il faut alors ouvrir le sélecteur, prévisualiser le contenu et renommer les sessions importantes.

### Continuer alors que la tâche a changé
Le deuxième piège est d’utiliser `claude -c` par réflexe, alors que l’objectif a changé. Continuer reprend la session la plus récente. Si cette session portait sur une autre tâche, vous allez importer du contexte obsolète dans une nouvelle demande.

Si la tâche change, il faut repartir proprement. Selon le cas, on utilise une nouvelle session, `/clear`, ou une branche de session. Continuer est utile pour poursuivre un même travail, pas pour commencer une tâche sans rapport.

### Ouvrir la même session dans deux terminaux
Si vous reprenez la même session dans deux terminaux sans créer de branche, les messages des deux terminaux s’ajoutent à la même transcription. Les trajectoires peuvent alors s’entrelacer. C’est rarement souhaitable pour une tâche de développement sérieuse.

### Supposer que la reprise restaure tout
La reprise ne restaure pas tout comme un instantané système complet. Elle restaure une conversation enregistrée, dans un environnement actuel. Si le dépôt a changé, si la branche a changé, si les fichiers ont été modifiés manuellement, si la configuration a évolué ou si les permissions ont été révoquées, la session reprise doit composer avec ce nouvel état.

Il faut donc demander à Claude de vérifier l’état courant après une reprise longue.
```text
Reprends cette session.
Avant toute modification, vérifie :
- la branche actuelle ;
- les fichiers modifiés ;
- le dernier objectif de la session ;
- les vérifications déjà exécutées ;
- ce qui reste incertain.
```

## Nommer les sessions comme des branches de travail

### Un nom par flux de travail
Une bonne pratique consiste à traiter les sessions comme des branches de travail conversationnelles. Chaque flux de travail important doit avoir son nom : une correction, une migration, une revue, une exploration, une préparation de release, une enquête sur une erreur.
```bash
/rename auth-refresh-token
# Session centrée sur le renouvellement de session.
/rename billing-vat-tests
# Session centrée sur les tests de TVA.
/rename pr-128-review
# Session centrée sur la revue d’une demande de tirage.
```
Le nom doit être court, stable et spécifique. Il ne doit pas décrire toutes les étapes. Il doit permettre de retrouver rapidement la bonne conversation dans le sélecteur.

### Renommer avant d’effacer
Lorsqu’une tâche est terminée ou que le contexte devient trop chargé, il peut être pertinent d’utiliser `/clear` pour repartir avec un contexte vide. Avant cela, il faut nommer la session si elle contient une trace utile.
```bash
/rename auth-refresh-token
# Donner un nom retrouvable à la session actuelle.
/clear
# Repartir sur un contexte vide pour une autre tâche.
/resume auth-refresh-token
# Revenir plus tard à la conversation nommée.
```
Effacer le contexte courant n’est pas supprimer la session. La conversation précédente reste enregistrée et peut être retrouvée avec `/resume`, à condition que la persistance de session n’ait pas été désactivée et que les fichiers locaux n’aient pas expiré.

## Persistance, rétention et limites pratiques

### Durée de conservation
Les fichiers locaux de session sont nettoyés automatiquement après une période de rétention. La valeur par défaut documentée est de trente jours, configurable avec `cleanupPeriodDays`.

Cette rétention signifie qu’une session n’est pas une archive permanente par défaut. Pour conserver une information durable, il ne faut pas compter uniquement sur l’historique conversationnel. Les décisions importantes doivent être déplacées dans le code, la documentation, un `CLAUDE.md`, une note de projet, un ticket ou un commit.

### Déplacer le stockage Claude
Le stockage local de Claude Code peut être déplacé en définissant `CLAUDE_CONFIG_DIR`. Cela change l’emplacement des fichiers normalement placés sous `~/.claude`.
```bash
CLAUDE_CONFIG_DIR=/chemin/vers/config-claude claude
# Lance Claude Code avec un répertoire de configuration personnalisé
```
Ce réglage doit être utilisé avec prudence.

### Persistance désactivée
Il existe des modes où la persistance de session peut être désactivée. Par exemple, l’option `--no-session-persistence` en mode non interactif évite d’écrire la transcription sur disque. Dans ce cas, les sessions ne sont pas enregistrées et ne peuvent pas être reprises comme des conversations ordinaires.
Pas de transcription, pas de reprise.

## Workflow recommandé pour une tâche reprise

### Avant d’arrêter
```bash
/rename nom-de-tache
# Donner un nom clair à la session.
/context
# Vérifier ce qui consomme le contexte.
```
Demande à Claude :
```text
Prépare un point de reprise court :
- objectif initial ;
- fichiers importants ;
- changements appliqués ;
- vérifications exécutées ;
- prochaine action recommandée.
```
Cette préparation réduit le risque de reprise confuse.

### Au moment de reprendre
```bash
claude -r "nom-de-tache"
# Reprendre la session nommée.
```
Demande à Claude :
```text
Avant toute action, rappelle :
- où nous en étions ;
- ce qui est vérifié ;
- ce qui ne l’est pas ;
- les fichiers modifiés ;
- la prochaine étape minimale.
```
La première demande après reprise doit être orientée vers la vérification de l’état, pas vers une modification immédiate. Une reprise sérieuse commence par un recalage.

### Après reprise
```bash
/diff
# Vérifier les modifications présentes.
/context
# Vérifier l’état du contexte.
```
Demande à Claude :
```text
Ne modifie rien tant que tu n’as pas confirmé que la branche actuelle, le diff et l’objectif correspondent encore à la session d'origine.
```
Ce protocole est particulièrement important après une pause longue. Le dépôt peut avoir changé, la branche peut avoir avancé, ou une modification manuelle peut avoir été faite hors de Claude Code.
