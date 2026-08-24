Une session non interactive de Claude Code n’a pas le même profil de risque qu’une session terminal classique. Dans une session interactive, l’utilisateur peut lire une demande de permission, interrompre, répondre, corriger la trajectoire et inspecter le diff en direct. Dans une exécution non interactive, l’agent doit fonctionner avec des bornes définies à l’avance : outils disponibles, permissions, limites de tours, budget, sources MCP, format de sortie et comportement en cas de demande de permission.
Le principe central est simple : ce qui n’est pas supervisé doit être borné. Une exécution non interactive ne doit pas dépendre d’un utilisateur qui lira une invite au bon moment. Elle doit être configurée pour réussir dans un périmètre connu, ou échouer proprement si elle sort de ce périmètre.
Claude Code est une boucle partagée entre plusieurs surfaces : terminal interactif, mode headless, Agent SDK et intégrations. La logique centrale reste la même, mais les surfaces non interactives exigent davantage de configuration préalable, parce que l’interaction humaine n’est plus le mécanisme de rattrapage principal.

Ce que signifie non interactif
Le mode impression avec claude -p
Le mode impression exécute une demande sans ouvrir une session interactive complète : claude -p imprime la réponse au lieu d’ouvrir l’interface terminal. Ce mode est utile pour les scripts, les vérifications automatisées, les intégrations CI, les tâches ponctuelles et les appels depuis d’autres programmes.

claude -p "Analyse les erreurs TypeScript et pro"

Ce mode ne doit pas être traité comme un terminal interactif miniature. Il faut lui fournir une tâche courte, un périmètre clair, des outils autorisés et des limites d’exécution. Si la demande est trop ouverte, l’agent peut multiplier les tours, les lectures et les appels d’outils avant d’échouer ou de produire une réponse peu exploitable.

Le Agent SDK
Le Agent SDK permet d’appeler la boucle agentique depuis du code. L’agent peut appeler des outils, recevoir leurs résultats et répéter jusqu’à ce que la tâche soit terminée ou qu’une limite soit atteinte. Il expose des options comme allowedTools, disallowedTools, permissionMode, maxTurns et maxBudgetUsd.

{
  "allowedTools": ["Read", "Glob", "Grep"],
  "disallowedTools": ["Bash", "Edit", "Write"],
  "permissionMode": "dontAsk",
  "maxTurns": 3
}

Cette configuration décrit un agent de lecture. Il peut inspecter le projet, mais il ne peut pas modifier le dépôt ni lancer le shell. Le mode dontAsk est important : si un outil non préapprouvé est demandé, l’appel est refusé au lieu de suspendre l’exécution dans l’attente d’un humain.

Définir la surface d’outils
allowedTools préapprouve, mais ne restreint pas
allowedTools ajoute des règles d’autorisation. Il préapprouve les outils listés, mais il ne retire pas les autres outils de la surface disponible. Un outil non listé dans allowedTools reste disponible pour Claude ; il n’est simplement couvert par aucune règle d’autorisation et retombe sur le mode de permission actif.

{
  "allowedTools": ["Read", "Glob", "Grep"],
  "permissionMode": "default"
}

Cette configuration ne signifie pas que Claude ne peut voir que Read, Glob et Grep. Elle signifie seulement que ces outils sont approuvés automatiquement. Les autres outils peuvent encore être demandés, puis traités par le mode de permission.
Pour verrouiller une exécution, allowedTools seul ne suffit pas. Il faut l’associer à dontAsk, à disallowedTools, ou à une restriction explicite de la surface d’outils.

disallowedTools bloque réellement
disallowedTools ajoute des refus. Comme pour les règles de refus en général, la forme employée change l’effet : un refus nu sur Bash retire l’outil du contexte de Claude avant toute évaluation, tandis qu’un refus ciblé comme Bash(rm *) laisse Bash disponible et bloque seulement les commandes correspondant au motif. Les refus l’emportent, y compris sur bypassPermissions.

{
  "allowedTools": ["Read", "Glob", "Grep"],
  "disallowedTools": ["Bash", "Edit", "Write", "mcp__*"],
  "permissionMode": "dontAsk"
}

Ce type de configuration est adapté à une analyse non interactive en lecture seule. Les outils de lecture sont préapprouvés. Les outils de modification, le shell et les outils MCP sont exclus. Tout ce qui n’est pas déjà couvert est refusé plutôt que demandé.

tools définit la surface intégrée
L’option tools est distincte de allowedTools : elle définit l’ensemble des outils intégrés que Claude peut utiliser, ou reprend le préréglage claude_code. Restreindre cette surface intégrée ne neutralise pas pour autant les serveurs MCP : les outils MCP forment une surface distincte, contrôlée par des refus comme mcp__* ou par une configuration MCP stricte.

Surface integree souhaitee :
Read, Glob, Grep
Surface MCP souhaitee :
aucun serveur charge
Comportement attendu :
analyse de fichiers seulement, sans shell, sans MCP

La distinction est importante. Une session non interactive doit cadrer les deux surfaces : outils natifs et outils externes.

Choisir le mode de permission en non interactif
dontAsk pour verrouiller
Pour les scripts, la CI et les agents sans humain disponible, dontAsk est souvent le mode le plus prévisible. Il convertit toute demande de permission en refus : seuls les outils déjà préapprouvés par allowedTools, par une règle allow des paramètres ou par un hook s’exécutent ; tout le reste est refusé sans appeler de callback ni attendre une décision humaine.

{
  "allowedTools": ["Read", "Glob", "Grep"],
  "permissionMode": "dontAsk"
}

Ce mode exige une préparation. Si l’outil nécessaire n’est pas préapprouvé, l’action sera refusée. C’est précisément ce que l’on veut dans un environnement non supervisé : une exécution bornée qui échoue proprement plutôt qu’une exécution qui attend indéfiniment.

auto pour réduire les interruptions dans un cadre connu
Le mode auto réduit les interruptions en laissant un classificateur de sécurité évaluer les appels d’outils non couverts par les règles, et approuver ou refuser selon le cas. Il est accepté comme valeur de mode de permission dans la CLI comme dans le SDK.

Mode souhaite :
auto
Usage adapte :
tache claire, depot connu, environnement surveille

auto n’est pas un mode de verrouillage. Il convient aux tâches bien cadrées où l’on veut réduire la fatigue de permission. Pour une CI stricte ou un script qui doit être déterministe, dontAsk avec une liste d’outils explicite reste plus prévisible.

bypassPermissions n’est pas une solution de cadrage
Le mode bypassPermissions contourne les invites et doit être réservé à des environnements isolés comme des conteneurs ou de la CI dont les effets sont contenus. Il ne doit pas servir à simplifier une intégration non interactive mal cadrée. À noter : allowedTools ne contraint pas ce mode. Une liste allowedTools seule, combinée à bypassPermissions, laisse passer tous les autres outils, car ils retombent sur le mode qui les approuve. Seuls des refus explicites, des règles ask ou des hooks bloquent encore.
Dans une intégration sérieuse, on ne remplace pas une politique par un contournement. On limite les outils, on limite les tours, on limite le budget, on limite les serveurs MCP et on isole l’environnement si nécessaire.

Router les permissions en non interactif
permissionPromptTool
permissionPromptTool permet de désigner un outil MCP chargé de gérer les invites de permission en mode non interactif. Cela sert lorsque les demandes ne doivent pas bloquer dans le terminal, mais doivent être transmises à un mécanisme externe : service d’approbation, outil interne, orchestrateur CI ou passerelle de politique.

Session non interactive :
la demande de permission est envoyee a un outil
L'outil decide :
autoriser, refuser, ou retourner une raison explicite

Ce mécanisme doit être réservé aux intégrations où l’outil d’approbation est lui-même fiable. Il ne faut pas router les permissions vers un serveur MCP générique ou non audité. L’outil d’approbation devient une partie de la frontière de sécurité.

Callback canUseTool dans le SDK
Dans le SDK, si les hooks, les règles de refus, le mode de permission et les règles d’autorisation ne résolvent pas l’appel d’outil, le callback canUseTool est appelé pour décider. En mode dontAsk, cette étape est ignorée et l’outil est refusé.

Dans une application interactive construite avec le SDK, canUseTool peut afficher une validation utilisateur. Dans une automatisation, il doit produire une décision déterministe ou déléguer à un service de politique. Il ne doit pas créer une attente bloquante sans interface de réponse.

Borner les tours, le budget et la sortie
Limiter les tours
maxTurns limite les allers-retours d’utilisation d’outils. Lorsque la limite est atteinte, l’exécution se termine sur un résultat dont le sous-type signale l’arrêt. Cette limite est essentielle pour les exécutions non interactives, car elle empêche une tâche ouverte de se prolonger indéfiniment.

{
  "maxTurns": 4,
  "permissionMode": "dontAsk",
  "allowedTools": ["Read", "Glob", "Grep"]
}

Une tâche non interactive doit avoir un horizon. Pour une analyse courte, trois à cinq tours peuvent suffire. Pour une tâche plus longue, il faut découper en phases plutôt que laisser une seule exécution résoudre tout le problème.

Limiter le budget
maxBudgetUsd fixe une limite de coût en dollars avant arrêt. Le message de résultat porte d’ailleurs le coût cumulé (total_cost_usd), le nombre de tours et l’usage, ce qui permet d’alimenter des budgets et des tableaux de bord. Cette borne évite qu’une automatisation coûteuse continue après une dérive de contexte, un serveur MCP trop verbeux ou une série de tentatives infructueuses.

{
  "maxBudgetUsd": 2,
  "maxTurns": 3,
  "allowedTools": ["Read", "Glob", "Grep"]
}

Le budget n’est pas une garantie de qualité. C’est une condition d’arrêt économique. Il doit être combiné avec un prompt précis, un périmètre réduit et une sortie exploitable.

Choisir un format de sortie exploitable
Le mode impression accepte un format de sortie, notamment texte, JSON ou JSON en flux (stream-json). Le JSON est préférable lorsque la sortie doit être parsée par un autre programme ; le flux JSON est utile pour suivre les événements tour par tour.

Sortie attendue :
format structure avec statut, fichiers inspectes

Un script ne doit pas dépendre d’une prose longue et variable. Demandez une sortie structurée, courte et stable.

Cadrer les intégrations MCP
Ce que MCP ajoute
MCP connecte Claude Code à des outils externes, bases de données, API, services de suivi, outils de monitoring ou navigateurs. Un serveur MCP permet à Claude de lire et d’agir sur ces systèmes au lieu de travailler à partir de données copiées dans le chat. Il faut connecter seulement des serveurs de confiance, car les serveurs qui récupèrent du contenu externe peuvent exposer l’agent à des risques d’injection de prompt.
En non interactif, un serveur MCP est une surface d’action à part entière. Il peut lire une issue, interroger une base, déclencher une opération externe ou retourner un contenu hostile. Il doit donc être choisi et borné comme un outil d’exécution, pas comme une simple source documentaire.

Vérifier les serveurs actifs
/mcp affiche les serveurs connectés, leurs outils et l’état d’authentification dans une session interactive. Pour le diagnostic, retenez aussi que les serveurs de projet doivent se trouver dans .mcp.json à la racine du dépôt, pas dans .claude, et que settings.json ne lit pas de clé mcpServers pour les serveurs de projet.

Avant d’automatiser une session, vérifiez la surface MCP depuis une session interactive. Un serveur absent, mal placé ou rejeté par l’approbation de projet peut expliquer pourquoi une automatisation échoue.

Rendre les serveurs explicites avec mcpConfig
L’option mcpConfig charge les serveurs MCP à partir de fichiers ou de chaînes JSON. Pour une exécution non interactive, cette forme est préférable à une dépendance implicite aux serveurs configurés dans l’environnement de l’utilisateur.

Configuration attendue :
un fichier MCP explicite ;
des serveurs nommes ;
aucun serveur implicite ;
une tache qui mentionne exactement quels systemes utiliser.

Cette discipline améliore la reproductibilité. Le même script ne doit pas produire une surface d’action différente selon la machine de l’utilisateur.

Verrouiller avec strictMcpConfig
strictMcpConfig force Claude Code à utiliser uniquement les serveurs fournis par mcpConfig, en ignorant les autres configurations MCP. Sans configuration MCP fournie, cette restriction garantit qu’aucun serveur MCP ne se charge.

Politique de session :
charger uniquement les serveurs MCP explicitement définis ;
ignorer les serveurs utilisateur, projet ou plugins ;
refuser les outils MCP non attendus.

C’est une règle importante pour les scripts. Une intégration non interactive doit savoir quels serveurs externes sont présents. Elle ne doit pas hériter silencieusement d’un serveur personnel, d’un plugin ou d’une configuration locale.

Limiter les outils MCP
Refuser toute la surface MCP
Si une tâche n’a pas besoin d’outil externe, refusez les outils MCP. Dans les règles de refus, mcp__* correspond à tous les outils MCP.

{
  "disallowedTools": ["mcp__*"],
  "allowedTools": ["Read", "Glob", "Grep"],
  "permissionMode": "dontAsk"
}

Cette configuration convient aux analyses de code purement locales. Elle évite qu’un serveur externe fournisse du contenu non nécessaire ou ajoute une surface d’action imprévue.

Autoriser un serveur précis
Les règles d’autorisation pour les outils MCP n’acceptent un motif qu’après un préfixe littéral de serveur, comme mcp__puppeteer__* ou mcp__github__get_*. Une règle d’autorisation trop large comme mcp__* est ignorée avec un avertissement au démarrage. Les refus, eux, acceptent mcp__*.

{
  "allowedTools": [
    "mcp__github__get_issue",
    "mcp__github__get_pull_request"
  ],
  "disallowedTools": [
    "mcp__github__create_*",
    "mcp__github__delete_*"
  ],
  "permissionMode": "dontAsk"
}

Cette politique permet une intégration en lecture contrôlée avec GitHub, sans autoriser les actions de création ou de suppression.

Préférer les outils en lecture seule
Les outils en lecture seule, comme Read, Glob, Grep et les outils MCP marqués comme lecture seule, peuvent s’exécuter de manière concurrente. Les outils qui modifient l’état, comme Edit, Write et Bash, s’exécutent séquentiellement pour éviter les conflits.
Pour une tâche non interactive, les intégrations MCP en lecture seule sont plus faciles à borner. Une intégration qui peut écrire, supprimer, commenter, créer une PR, modifier une base ou déclencher un workflow externe doit avoir une politique plus stricte.

Gouverner les serveurs MCP à l’échelle d’une équipe
Serveurs de projet et serveurs utilisateur
Les serveurs MCP ont plusieurs portées. Un serveur ajouté localement au projet ne s’applique pas à tous les projets ; un serveur utilisateur suit l’utilisateur entre projets ; un fichier .mcp.json à la racine du dépôt partage une configuration de projet versionnée.
Dans une équipe, il faut éviter les intégrations implicites. Si un serveur est nécessaire à tout le monde, placez sa configuration dans le dépôt ou dans une politique gérée. Si un serveur est personnel, ne construisez pas un workflow d’équipe qui en dépend.

Contrôle géré
Pour les organisations, un fichier managed-mcp.json peut imposer un ensemble fixe de serveurs, et les clés allowedMcpServers, deniedMcpServers et allowManagedMcpServersOnly filtrent les serveurs avant chargement. La liste de refus l’emporte sur la liste d’autorisation. Pour réduire la surface au strict minimum, une liste d’autorisation vide combinée à allowManagedMcpServersOnly empêche tout serveur non géré de se charger.

{
  "allowManagedMcpServersOnly": true,
  "allowedMcpServers": []
}

Ce bloc représente le cas extrême : seuls les serveurs gérés peuvent se charger, et la liste vide n’en autorise aucun de plus. Dans une organisation, cette décision peut être pertinente pour les environnements sensibles, les pipelines ou les postes où l’on ne veut aucune intégration externe.
Quand allowManagedMcpServersOnly est actif, les listes d’autorisation utilisateur, projet et locale sont ignorées ; la liste de refus, elle, fusionne depuis toutes les portées, pour qu’un utilisateur puisse toujours bloquer un serveur pour lui-même.

Utiliser des identifiants robustes
Chaque entrée de allowedMcpServers ou deniedMcpServers identifie un serveur par exactement une clé : serverName, serverCommand ou serverUrl. Un serverName est une étiquette assignée par l’utilisateur et ne constitue pas un contrôle de sécurité : n’importe quel serveur peut être nommé github. Pour appliquer réellement quels serveurs se chargent, visez serverUrl pour les serveurs distants et serverCommand pour les serveurs locaux stdio.

{
  "allowedMcpServers": [
    { "serverUrl": "https://*.internal.example.com" },
    { "serverCommand": ["npx", "-y", "approved-package"] }
  ],
  "deniedMcpServers": [
    { "serverUrl": "https://*.untrusted.example.com" }
  ]
}

Une politique MCP sérieuse doit viser ce qui s’exécute vraiment, pas seulement le nom affiché.

Protocole pour une session non interactive sûre
Analyse en lecture seule

{
  "permissionMode": "dontAsk",
  "allowedTools": ["Read", "Glob", "Grep"],
  "disallowedTools": ["Bash", "Edit", "Write", "mcp__*"],
  "maxTurns": 3,
  "maxBudgetUsd": 1
}

Tache :
inspecter uniquement les fichiers lies a l'erreur
Sortie attendue :
fichiers lus ;
cause probable ;
incertitudes ;
prochaine verification manuelle.
Interdiction :
ne rien modifier ;
ne lancer aucune commande ;
ne pas utiliser MCP.

Analyse avec un serveur MCP de tickets

{
  "permissionMode": "dontAsk",
  "allowedTools": [
    "Read",
    "Glob",
    "Grep",
    "mcp__github__get_issue",
    "mcp__github__get_pull_request"
  ],
  "disallowedTools": [
    "Bash(git push *)",
    "mcp__github__create_*",
    "mcp__github__delete_*"
  ],
  "maxTurns": 5
}

Tache :
lire l'issue indiquee ;
identifier les fichiers locaux concernes ;
proposer un plan ;
ne creer aucun commentaire ;
ne modifier aucun fichier ;
ne creer aucune PR.

Correction locale bornée

{
  "permissionMode": "acceptEdits",
  "allowedTools": [
    "Read",
    "Glob",
    "Grep",
    "Edit",
    "Bash(npm run test *)",
    "Bash(npm run typecheck)"
  ],
  "disallowedTools": [
    "Bash(git push *)",
    "Bash(curl *)",
    "Bash(wget *)",
    "mcp__*"
  ],
  "maxTurns": 6
}

Tache :
corriger le bug localement ;
garder le diff minimal ;
lancer seulement le test cible ;
arreter si la correction exige un changement d'architecture ;
resumer le diff et les verifications.

Erreurs fréquentes
Penser que allowedTools limite la surface
allowedTools préapprouve. Il ne retire pas les outils non listés. Pour verrouiller, utilisez dontAsk, disallowedTools, tools pour les outils intégrés, et une stratégie explicite pour MCP.

Oublier que tools ne filtre pas MCP
L’option tools vise les outils intégrés. Les outils MCP doivent être contrôlés séparément, par refus mcp__*, par strictMcpConfig, par managed-mcp.json ou par les listes gérées de serveurs.

Utiliser bypassPermissions avec allowedTools en pensant limiter l’agent
allowedTools ne contraint pas bypassPermissions. Si vous définissez seulement allowedTools avec bypassPermissions, les autres outils sont encore approuvés par le mode. Pour bloquer, utilisez des refus explicites.

Laisser les serveurs MCP implicites se charger
Une automatisation doit savoir quels serveurs externes sont actifs. Utilisez une configuration MCP explicite et une restriction stricte lorsque la reproductibilité ou la sécurité compte.

Placer .mcp.json dans le mauvais dossier
La configuration MCP de projet doit être à la racine du dépôt sous .mcp.json, pas dans .claude. Et settings.json ne lit pas de clé mcpServers pour définir les serveurs de projet.

Faire dépendre un script d’une configuration utilisateur
Un script ne doit pas supposer que l’utilisateur possède le bon serveur, le bon plugin ou les bonnes permissions. Les dépendances doivent être explicites, versionnées ou gérées.

Table de décision

Situation | Configuration recommandée | Raison
---|---|---
Analyse locale sans modification | dontAsk, Read, Glob, Grep, refus de Bash et MCP | La tâche doit rester en lecture seule.
Script qui doit échouer plutôt que demander | dontAsk avec outils préapprouvés | Aucune validation humaine n’est disponible.
Tâche connue avec moins d’interruptions | auto avec bornes et refus explicites | Le classificateur réduit la friction, mais les refus gardent les limites.
Intégration avec tickets ou PR | Outils MCP de lecture ciblés | Lire les informations externes sans autoriser les actions d’écriture.
CI ou automatisation sensible | Configuration MCP stricte, tours et budget bornés | La surface doit être reproductible et limitée.
Environnement d’équipe | Serveurs MCP gérés ou listes blanches robustes | Éviter que chaque utilisateur apporte une surface externe différente.
