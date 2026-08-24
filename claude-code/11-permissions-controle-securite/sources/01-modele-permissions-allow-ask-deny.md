Dans Claude Code, les permissions définissent la frontière entre ce que le modèle peut proposer et ce que le système peut réellement exécuter. Elles ne sont pas une préférence d’affichage, ni une simple confirmation de confort. Elles constituent une couche de contrôle entre la sortie du modèle et l’environnement de développement.

Le modèle ne touche pas directement au système. Il peut demander à lire un fichier, modifier du code, lancer une commande ou utiliser un outil externe. Mais cette demande passe par Claude Code, qui vérifie les règles de permission avant de laisser l’outil agir. Les règles de permission sont appliquées par Claude Code, pas par le modèle. Les instructions dans le prompt ou dans CLAUDE.md influencent ce que Claude essaie de faire, mais elles ne changent pas ce que le système autorise.

Le modèle de base repose sur trois décisions : allow, ask et deny. Ces trois décisions servent à classer les actions selon leur niveau de confiance : ce qui peut être préautorisé, ce qui doit être validé, et ce qui doit être bloqué.

Pourquoi les permissions existent
Une demande d’outil n’est pas encore une action
Dans la boucle agentique, le modèle peut produire une demande d’outil. Cette demande est une intention structurée. Elle indique ce que le modèle veut faire, mais elle ne produit pas encore d’effet sur le disque, le shell, le réseau ou les services externes.

Claude propose une action.
Claude Code vérifie les permissions.
La décision est allow, ask ou deny.
L’outil s’exécute seulement si la décision le perme
Le résultat revient ensuite dans la boucle.

Cette séparation est fondamentale. Elle permet à Claude de raisonner librement sur la tâche, tout en empêchant qu’une mauvaise hypothèse, une instruction injectée ou une erreur de contexte devienne automatiquement une action réelle.

Le système contrôle l’exécution
L’architecture de Claude Code sépare le raisonnement du modèle et l’exécution par le harness. Le modèle produit des demandes d’outils, puis le harness les interprète, vérifie les permissions, exécute les outils autorisés et collecte les résultats. Le modèle ne lit donc pas directement le système de fichiers, ne lance pas directement le shell et ne contourne pas lui-même les contrôles.
Les permissions sont donc une frontière d’exécution. Elles ne servent pas seulement à demander confirmation. Elles définissent quelles trajectoires agentiques sont possibles dans l’environnement courant.

Les trois décisions fondamentales
allow
allow signifie que l’action correspondante peut s’exécuter sans interruption supplémentaire. C’est une préautorisation. Elle convient aux actions fréquentes, sûres et bien comprises.
Une action allow doit être prévisible. Elle doit correspondre à une opération que l’on accepte de laisser à Claude Code dans le cadre normal du projet : lire certains fichiers, lancer un test ciblé, exécuter un lint connu, consulter une issue ou effectuer une commande de diagnostic sans effet destructeur.
allow n’est pas une confiance générale. C’est une autorisation précise accordée à une famille d’actions que l’on juge sûre.

ask
ask signifie que Claude Code doit demander une validation humaine avant d’exécuter l’action. C’est le bon choix pour les actions légitimes, mais contextuelles.
Une action peut être acceptable dans certains cas et inacceptable dans d’autres. Par exemple, modifier un fichier de configuration, créer un commit, lancer une commande qui écrit sur le disque ou interagir avec un service externe peut être correct, mais seulement après lecture humaine de la demande.
ask conserve l’autorité humaine sur les actions ambiguës. Le modèle peut proposer ; l’utilisateur décide si le moment, le périmètre et les paramètres sont acceptables.

deny
deny signifie que l’action doit être bloquée. C’est la décision à utiliser pour les secrets, les commandes destructrices, les accès hors périmètre, les actions réseau non souhaitées, les modifications d’infrastructure ou les opérations qui ne doivent pas dépendre de l’attention de l’utilisateur.
Une action deny ne doit pas être transformée en question de confiance ponctuelle. Elle doit être refusée par principe dans l’environnement concerné.
deny est la décision de protection forte. Elle sert à retirer certaines actions de la trajectoire possible de l’agent.

La priorité du refus
L’ordre d’évaluation
Les règles sont évaluées dans un ordre fixe : d’abord les règles de refus, ensuite les règles de demande, puis les règles d’autorisation. La première règle correspondante l’emporte, même si une règle située plus bas est plus spécifique. La spécificité d’une règle ne change pas cet ordre.

Ordre de décision :
deny
ask
allow

Cette priorité est volontaire. Elle évite qu’une autorisation locale contourne accidentellement un refus plus général. Une politique de sécurité doit pouvoir dire : cette famille d’actions ne passe pas, même si une autre règle semble l’autoriser.

Un refus large ne se contourne pas avec une autorisation étroite
Si une action correspond à une règle deny, elle est refusée. Il ne faut pas concevoir les permissions comme une liste d’exceptions où une autorisation plus précise annule un refus plus large. Un refus large comme Bash(aws *) bloque tous les appels correspondants, y compris ceux qui correspondent aussi à une autorisation plus étroite comme Bash(aws s3 ls) : une règle de refus ne peut pas porter d’exceptions d’autorisation.

Exemple conceptuel :
une règle refuse une famille d’actions.
une autre règle autorise une action dans cette fami
résultat : l’action reste refusée.

Cette logique impose de calibrer les refus avec soin. Un refus trop large peut bloquer des actions utiles. Un refus trop étroit peut laisser passer des actions dangereuses. L’écriture propre de ces motifs relève de la configuration des règles.

Les permissions et la surface d’outils
Retirer une capacité ou contrôler un usage
Une règle peut viser un outil entier ou un usage particulier d’un outil. Viser un outil entier revient à retirer une capacité complète. Viser un usage particulier permet de garder l’outil disponible tout en contrôlant certains cas.
Cette distinction est importante. Interdire entièrement Bash n’a pas le même effet que bloquer seulement certaines commandes. Interdire entièrement WebFetch n’a pas le même effet que restreindre certains domaines. Interdire entièrement un serveur MCP n’a pas le même effet que contrôler un outil précis de ce serveur.

Les permissions modifient la surface d’action de l’agent. Elles ne se contentent pas de valider après coup. Un refus qui nomme seulement l’outil, comme Bash , retire cet outil du contexte du modèle : il n’est même plus proposé comme trajectoire. Un refus qui cible un motif, comme Bash(rm *) , laisse l’outil disponible et bloque les appels correspondants au moment où ils sont tentés.

Les permissions s’appliquent aux outils
Le modèle de permission se comprend à partir des outils : lecture, modification, exécution, accès web, outils MCP , sous-agents, skills et autres capacités exposées. Les mêmes noms d’outils se retrouvent dans les règles de permission, les paramètres, les skills, les sous-agents, les hooks et certaines options d’exécution. Ces noms servent notamment dans permissions.allow, permissions.deny, /permissions, les options des sessions non interactives comme --allowedTools et --disallowedTools, les skills, les sous-agents et les hooks.
L’écriture concrète de ces règles relève de la configuration détaillée. Le point essentiel ici : les permissions contrôlent une surface d’outils, pas une intention abstraite.

Permissions et instructions
CLAUDE.md conseille
CLAUDE.md est utile pour transmettre des conventions, des commandes recommandées, des préférences de style, des contraintes de projet et des procédures d’équipe. Il influence ce que Claude essaie de faire.
Mais CLAUDE.md reste du contexte. Il ne transforme pas une interdiction en barrière déterministe. Si une action doit être impossible, elle doit être bloquée par une permission, un hook, un sandbox ou une politique gérée.

Les permissions contrôlent
Une phrase comme « ne lis jamais les fichiers d’environnement » peut être utile comme rappel. Mais si cette règle doit vraiment s’appliquer, elle doit être traduite dans la couche de contrôle.

Instruction consultative :
ne lis pas les fichiers sensibles.
Contrôle imposé :
une règle de permission refuse ces lectures.

Le principe est simple. Les instructions décrivent comment travailler ; les permissions décident ce qui peut réellement s’exécuter.

Permissions et fatigue de validation
Tout demander n’est pas toujours plus sûr
Une approche naïve consisterait à demander confirmation pour chaque action. En pratique, trop de demandes de permission produisent une fatigue de validation : l’utilisateur finit par accepter automatiquement. Quand presque chaque demande est approuvée par réflexe, la confirmation manuelle perd sa valeur de protection. C’est ce qui justifie des garde-fous plus structurés : la priorité au refus, le classificateur du mode auto et le sandboxing.
La sécurité ne peut donc pas dépendre uniquement de l’attention humaine à chaque invite. Il faut une politique qui réduit les confirmations inutiles tout en conservant les blocages nécessaires.

Le bon objectif
Une bonne politique de permissions ne consiste pas à bloquer l’agent. Elle consiste à organiser le travail :
Type d’action | Décision naturelle | Raison
---|---|---
Action sûre, fréquente, vérifiable | allow | Réduire les interruptions inutiles.
Action utile mais contextuelle | ask | Conserver la décision humaine au bon moment.
Action dangereuse ou hors périmètre | deny | Bloquer sans dépendre de l’attention humaine.

Le but n’est pas de supprimer les permissions. Le but est de placer la friction au bon endroit.

Les permissions dans la boucle agentique
Le refus devient une observation
Quand une action est refusée, la boucle ne s’arrête pas nécessairement. Le refus peut revenir dans la conversation comme une observation. Claude peut alors proposer une trajectoire compatible avec les règles actives.

Claude demande une action.
La règle de permission refuse l’action.
Le refus revient comme information.
Claude cherche une autre approche compatible.

Cette propriété est importante. Les permissions ne servent pas seulement à arrêter. Elles orientent aussi la trajectoire de l’agent vers des actions acceptables.

Un refus bien formulé aide la reprise
Un refus utile indique pourquoi l’action ne passe pas : chemin sensible, commande destructrice, accès externe non autorisé, modification hors périmètre ou action non préapprouvée. Cette information permet à l’agent de réviser sa stratégie.

Action refusée :
lecture d’un fichier de secrets.
Réorientation attendue :
ne pas tenter de contourner.
demander une donnée fictive.
travailler avec un exemple minimal.
continuer sans exposer le secret.

Une permission bien conçue ne bloque pas seulement une action dangereuse ; elle rend la trajectoire suivante plus sûre.

Relation avec les autres couches de contrôle
Les modes de permission
Les modes de permission définissent la posture générale de la session : plus contrôlée, plus autonome, orientée planification ou verrouillée pour les exécutions non interactives. Les modes disponibles sont default, acceptEdits, plan, auto, dontAsk et bypassPermissions. Le mode auto préautorise les appels d’outils avec des vérifications de sécurité en arrière-plan qui contrôlent que les actions correspondent à la demande ; il s’agit actuellement d’un aperçu de recherche. Les règles granulaires se superposent à ce mode général.
Les modes règlent l’autonomie générale de la session, tandis que allow, ask et deny règlent les frontières concrètes, outil par outil.

Les hooks
Les hooks peuvent intercepter certains événements du cycle de vie, notamment avant l’utilisation d’un outil. Un hook PreToolUse peut autoriser, refuser ou demander confirmation, mais une décision allow donnée par un hook ne contourne pas les règles de refus : une règle deny ou ask est évaluée quel que soit le résultat du hook. Un hook qui se termine avec le code de sortie 2 arrête l’appel avant même l’évaluation des règles de permission.
Les hooks permettent donc de transformer des règles d’équipe en contrôles programmables, mais ils restent soumis à la logique de sécurité générale.

Le sandbox
Le sandbox n’a pas le même rôle qu’une permission. Une permission décide si l’action peut être tentée. Le sandbox limite ce qu’une commande peut atteindre lorsqu’elle s’exécute, au niveau du système, et il s’applique aux commandes Bash et à leurs processus enfants. Permissions et sandbox sont des couches complémentaires : les permissions contrôlent l’autorisation, le sandbox contrôle l’isolation d’exécution.
Autorisation et isolation ne sont pas interchangeables. Une action peut être autorisée mais sandboxée. Une action peut aussi être refusée avant même d’atteindre le sandbox.

La commande /permissions
Observer avant de configurer
/permissions ouvre l’interface de gestion des permissions. Elle liste toutes les règles actives et le fichier settings.json dont chaque règle provient, et permet de les gérer.
Avant d’écrire une politique complète, /permissions sert à identifier où se trouve la couche de contrôle et à comprendre pourquoi une action est autorisée, demandée ou refusée.

Ce que l’on doit chercher dans /permissions
À vérifier :
quelles actions sont préautorisées.
quelles actions demandent validation.
quelles actions sont refusées.
de quelle portée viennent les règles.
si une action répétitive devrait devenir une règle.
si une action sensible devrait être refusée.

La configuration détaillée des fichiers settings, des wildcards, des chemins et des outils MCP relève de l’écriture des règles. /permissions sert d’abord à rendre visible la politique active.

Les autres couches de la surface de permissions
Les modes
La posture d’autonomie de la session se règle par les modes default, plan, acceptEdits, auto, dontAsk et bypassPermissions, qui déterminent le comportement global tant qu’aucune règle granulaire ne s’applique.

La syntaxe complète des règles
L’écriture concrète des règles couvre les motifs Bash, les chemins Read et Edit au format gitignore, les domaines WebFetch, les règles MCP, les règles Agent pour les sous-agents et la répartition entre les différents fichiers settings.

Le sandbox et les environnements isolés
L’isolation d’exécution s’appuie sur la commande /sandbox, et au-delà sur Docker, les devcontainers et les données fictives, pour contenir les effets d’une commande exécutée.
Le modèle de décision allow / ask / deny est la base conceptuelle. La posture d’autonomie par les modes et l’écriture concrète des règles s’appuient dessus.

Erreurs fréquentes
Confondre une instruction avec une permission
Écrire « ne fais pas cela » dans le prompt peut orienter le modèle. Cela ne bloque pas mécaniquement l’action. Pour bloquer, il faut une règle de permission, un hook, un sandbox ou une politique gérée.

Utiliser allow comme confiance globale
allow doit viser des actions sûres et précises. Il ne doit pas servir à rendre toute la session silencieuse.

Utiliser ask pour tout
Demander validation pour chaque action peut sembler prudent, mais crée de la fatigue. Les actions sûres et répétitives doivent être préautorisées. Les actions dangereuses doivent être refusées. Les actions ambiguës doivent rester en validation.

Penser qu’un refus arrête forcément la tâche
Un refus peut être une observation utile. L’agent peut proposer une autre méthode compatible avec les règles.

Croire que les permissions remplacent le sandbox
Les permissions contrôlent l’autorisation d’utiliser les outils. Le sandbox contrôle les effets possibles d’une commande exécutée. Les deux couches répondent à des risques différents.
