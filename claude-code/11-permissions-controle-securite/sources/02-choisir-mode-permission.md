Un mode de permission définit la posture générale d’autonomie d’une session Claude Code. Le modèle de contrôle distingue trois décisions par action : autoriser, demander ou refuser. Le mode agit à un autre niveau : il fixe le niveau de supervision appliqué à la session dans son ensemble.

Le mode ne remplace pas les règles granulaires. Il définit le comportement de base lorsque Claude veut agir : demander, planifier, modifier plus librement, déléguer certains jugements à un classificateur, refuser ce qui n’est pas préapprouvé, ou contourner presque toutes les invites dans un environnement isolé. Les règles précises, les motifs d’outils et les fichiers settings relèvent de la configuration des règles.

Les modes disponibles sont default, acceptEdits, plan, auto, dontAsk et bypassPermissions. Cette famille forme un spectre gradué de confiance : on part d’une posture supervisée, puis on augmente l’autonomie quand le contexte, le projet et les garde-fous le justifient.

Le rôle d’un mode de permission
Une posture globale, pas une règle locale
Le mode répond à une question pratique : dans cette session, est-ce que Claude Code doit s’arrêter souvent pour demander l’avis de l’utilisateur, ou peut-il avancer plus librement dans un cadre défini ?
Cette décision n’a pas le même niveau que les règles allow, ask et deny. Une règle vise une action concrète. Un mode définit la posture de session : prudente, exploratoire, itérative, automatisée, verrouillée ou dangereusement permissive.

Changer de mode pendant la session
Dans la CLI, Maj + Tab fait défiler les modes visibles. Le cycle standard passe par default, acceptEdits et plan. Les modes optionnels ne sont pas tous présents : auto apparaît quand le compte remplit les conditions requises, avec une invite d’acceptation la première fois ; bypassPermissions n’apparaît qu’après un lancement explicite (par exemple --permission-mode bypassPermissions ou --dangerously-skip-permissions) ; dontAsk ne figure jamais dans le cycle et se règle uniquement au lancement avec --permission-mode dontAsk.

Le mode actif apparaît dans la barre d’état. Dans VS Code, l’application Desktop et claude.ai, le même choix est exposé par un sélecteur de mode plutôt que par le raccourci clavier.

default
Posture de supervision standard
default est le mode de départ prudent. Il convient lorsque vous voulez voir précisément ce que Claude demande avant de lui laisser produire des effets significatifs. Il est adapté aux projets inconnus, aux dépôts sensibles, aux premières sessions sur une base de code et aux tâches où l’on veut construire progressivement une politique d’autorisations.

Ce mode est particulièrement utile au début d’un projet, parce qu’il rend visibles les actions proposées. Vous observez les commandes que Claude veut lancer, les modifications qu’il demande, et les zones du dépôt qu’il considère pertinentes. Cette observation sert ensuite à construire une configuration plus stable.

Mode conseillé : default
Situation : dépôt inconnu, règles encore non établies, besoin d'observation

Quand le conserver
Conservez default si la tâche touche des fichiers sensibles, si le projet n’a pas encore de commandes de validation claires, si la session accumule des incertitudes, ou si l’utilisateur doit examiner les demandes d’action une par une.

default n’est pas un mode lent par nature. Il devient lent seulement si le projet n’a aucune politique de permissions. Avec des règles bien placées, les actions sûres peuvent être fluides tout en gardant une validation humaine sur les actions ambiguës.

acceptEdits
Posture d’itération locale
acceptEdits réduit la friction quand la tâche consiste principalement à modifier des fichiers dans le périmètre de travail. Ce mode accepte automatiquement les modifications de fichiers et certaines commandes courantes du système de fichiers (comme mkdir, touch, mv et cp) dans le répertoire de travail, tout en continuant à demander pour les autres commandes terminal.

Ce mode est utile après une phase de compréhension. Quand vous savez quels fichiers sont concernés, que le diff sera vérifié, et que les tests sont disponibles, acceptEdits permet à Claude d’avancer sans interruption à chaque édition.

Mode conseillé : acceptEdits
Situation : correction locale, diff limité, tests ciblés dispo

Le bon usage
Utilisez acceptEdits pour l’implémentation, pas pour l’exploration initiale d’un dépôt inconnu. Le mode suppose que vous acceptez de relire les modifications après coup, avec l’éditeur ou git diff.
Le contrôle se déplace. Au lieu d’approuver chaque édition avant exécution, vous contrôlez le résultat : diff, tests, typecheck et revue humaine. Ce mode devient robuste uniquement si cette vérification existe réellement.

plan
Posture d’analyse avant action
plan sert à séparer la compréhension de l’exécution. Dans ce mode, Claude recherche, lit et explore avec des commandes en lecture seule, puis rédige un plan sans modifier les fichiers source. Il prépare une approche et la présente à approuver avant de toucher au code.

Ce mode est adapté lorsque l’erreur de stratégie coûterait plus cher que le temps de planification : refactor, migration, architecture, incident ambigu, dette technique, changement transversal ou code sensible.

Mode conseillé : plan
Situation : comprendre avant d’agir, comparer des options, évi

Ce qu’il faut attendre du mode plan
Le résultat attendu n’est pas une réponse décorative. C’est une stratégie exploitable : fichiers concernés, hypothèse principale, risques, ordre d’action, vérifications prévues et points qui nécessitent une validation humaine.

Le mode plan doit rester une frontière réelle. Si la tâche exige une réflexion avant toute modification, commencez par plan, puis changez seulement de posture lorsque la stratégie est suffisamment claire. Le mode plan s’active avec Maj + Tab ou en préfixant une invite par /plan.

auto
Posture d’autonomie contrôlée
auto réduit les invites de permission en déléguant une partie des décisions à un classificateur de sécurité distinct. Les modifications et commandes considérées sûres s’exécutent sans interruption, tandis que les actions qui dépassent la demande, visent une infrastructure non reconnue ou semblent dictées par du contenu hostile sont bloquées. Ce mode est actuellement un aperçu de recherche.

Ce mode doit être compris comme un compromis. Il n’est ni aussi manuel que default, ni aussi permissif que bypassPermissions. Il vise à réduire la fatigue de validation tout en conservant une évaluation de sécurité en arrière-plan.

Mode conseillé : auto
Situation : tâche bien cadrée, interruptions trop fréquentes,

Pourquoi auto peut être plus raisonnable que l’acceptation mécanique
Sur une session longue, un utilisateur peut finir par accepter trop vite les demandes de permission. Cette fatigue d’approbation justifie des mécanismes comme les classificateurs, les refus prioritaires et le sandboxing. Dans ce contexte, auto peut être préférable à une supervision humaine purement formelle : il remplace une série d’acceptations machinales par une évaluation automatisée de certains risques.

auto ne garantit pas la sécurité. Il réduit les interruptions et ajoute un contrôle automatisé, mais les interdictions absolues doivent rester dans des règles déterministes, des hooks, un sandbox ou une politique gérée.

Quand éviter auto
Évitez auto lorsque la tâche touche des secrets, une infrastructure mal identifiée, des actions de production, des commandes destructrices, des modifications de politique de sécurité, ou du contenu externe potentiellement hostile. Le mode auto peut être désactivé par politique : les administrateurs empêchent son usage en réglant permissions.disableAutoMode.

dontAsk
Posture verrouillée
dontAsk est un mode où la session ne demande pas de validation interactive. Une demande qui appellerait normalement une confirmation n’est pas transformée en invite : elle est refusée si elle n’est pas déjà préautorisée par /permissions ou les règles permissions.allow.

Ce mode n’est pas conçu pour rendre le travail interactif plus confortable. Il est conçu pour les contextes où l’absence d’interaction est une contrainte : script, CI, automatisation contrôlée, tâche bornée par une liste d’outils connue.

Mode conseillé : dontAsk
Situation : exécution verrouillée, aucune interaction humaine

Ce que ce mode exige
dontAsk exige une politique explicite. Si les actions utiles ne sont pas déjà autorisées par la configuration, elles seront refusées. Cela rend le mode prévisible, mais peu adapté aux sessions exploratoires.
dontAsk doit être préparé. Il n’est efficace que lorsque les outils nécessaires sont connus à l’avance et préautorisés.

bypassPermissions
Posture de contournement
bypassPermissions contourne la plupart des invites de permission. Ce mode ignore les demandes ordinaires, y compris pour des écritures dans des zones normalement protégées ; seuls quelques garde-fous critiques restent en place, comme l’invite maintenue sur des suppressions visant la racine ou le répertoire personnel, et le respect des règles ask et deny explicites. Il n’offre aucune protection contre l’injection de prompt et doit rester réservé aux environnements isolés comme des conteneurs ou des machines virtuelles.

Ce mode n’est pas une bonne solution à la fatigue de permission. Si le problème est que les mêmes actions sûres demandent trop souvent confirmation, il faut configurer des règles propres ou utiliser un mode moins risqué, pas supprimer globalement les garde-fous.

Quand ne pas l’utiliser
Ne l’utilisez pas dans votre dépôt principal avec des secrets, des accès cloud, des clés de production, une configuration Git importante, des outils de déploiement ou un accès réseau non contrôlé. Les administrateurs peuvent d’ailleurs interdire ce mode en réglant permissions.disableBypassPermissionsMode.

bypassPermissions doit rester exceptionnel. Les couches d’isolation comme /sandbox, Docker, les devcontainers et les données fictives encadrent ce type d’usage.

Mode conseillé : bypassPermissions
Situation : environnement jetable, données fictives, absence

Comparer les modes
Gradient d’autonomie
Mode | Posture | Usage principal
---|---|---
default | Supervision standard | Découverte, dépôt sensible, contrôle humain fréquent.
plan | Analyse avant modification | Stratégie, architecture, refactor, migration, tâche ambiguë.
acceptEdits | Itération locale | Modification de fichiers avec relecture du diff et tests.
auto | Autonomie contrôlée | Tâche cadrée, moins d’interruptions, vérification disponible.
dontAsk | Exécution verrouillée | Scripts et automatisations où aucune invite humaine n’est possible.
bypassPermissions | Contournement | Environnement jetable uniquement.

Critères de choix
Le bon mode dépend de cinq critères : risque, familiarité avec le dépôt, clarté de la tâche, capacité de vérification et niveau d’isolation.

Question | Conséquence
---|---
Le dépôt est-il connu ? | Si non, préférer default ou plan.
La tâche exige-t-elle une stratégie ? | Si oui, préférer plan.
Le diff sera-t-il facile à relire ? | Si oui, acceptEdits peut être approprié.
Les interruptions nuisent-elles à une tâche claire ? | Si oui, auto peut être pertinent.
La session est-elle automatisée sans humain disponible ? | Si oui, envisager dontAsk avec une politique préparée.
L’environnement est-il jetable et isolé ? | Sinon, éviter bypassPermissions.

Progression recommandée
Commencer supervisé
Dans un nouveau projet, commencez par default ou plan. Observez les actions demandées, identifiez les commandes sûres, puis seulement ensuite augmentez l’autonomie.

Départ : default ou plan
Après observation : règles sûres et mode adapté
Implémentation locale : acceptEdits
Tâche longue cadrée : auto

Augmenter l’autonomie seulement avec vérification
Plus le mode autorise Claude à avancer sans interruption, plus la vérification doit être nette : diff lisible, tests ciblés, typecheck, build local, revue humaine ou environnement isolé.

L’autonomie n’est acceptable que si le résultat reste contrôlable. Un mode plus permissif dans une session sans tests, sans diff relu et sans périmètre clair augmente le risque plus qu’il n’augmente la productivité.

Erreurs fréquentes
Confondre acceptEdits et contrôle total
acceptEdits accélère les modifications de fichiers. Il ne signifie pas que toutes les actions shell, réseau ou infrastructure deviennent sûres. Il doit être associé à une relecture du diff et à une vérification.

Utiliser plan comme simple formalité
Si vous activez plan, exigez un vrai plan : périmètre, hypothèses, risques et vérifications. Sinon, le mode devient un détour sans valeur.

Activer auto pour une tâche mal cadrée
auto réduit les interruptions, mais il ne clarifie pas une tâche confuse. Si l’objectif est flou, commencez par plan ou reformulez la demande.

Utiliser dontAsk sans politique préparée
Ce mode est prévisible uniquement si les actions nécessaires sont déjà couvertes par la configuration. Sans préparation, il risque de refuser les actions utiles.

Utiliser bypassPermissions dans un environnement réel
Le contournement des permissions doit rester limité aux environnements jetables. Pour un dépôt réel, privilégiez les règles, acceptEdits, auto ou une isolation contrôlée.
