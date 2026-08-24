Dans Claude Code, l’isolation sert à limiter ce que l’agent peut atteindre lorsqu’une commande s’exécute. Le contrôle d’autorisation (règles, modes, planification) décide si une action peut être tentée. L’isolation traite une autre question : si une action est autorisée, dans quel environnement doit-elle produire ses effets ?

L’isolation ne remplace pas les permissions. Les permissions décident si une action peut être tentée. Le sandbox, un conteneur ou une machine virtuelle limitent ce que l’action peut toucher une fois lancée. Ce sont deux couches distinctes : les règles de permission s’appliquent à tous les outils, tandis que le sandbox Bash impose une limite système aux commandes Bash et à leurs processus enfants.

Cette défense fonctionne en couches : un appel d’outil passe par le système de permissions, peut être intercepté par des hooks, peut être évalué par un classificateur en mode auto, puis une commande shell approuvée peut encore être exécutée dans un sandbox système. L’intérêt est que plusieurs mécanismes indépendants puissent bloquer ou contenir une action si une autre couche laisse passer trop large.

Le rôle de l’isolation
Autoriser n’est pas isoler
Une commande peut être autorisée par les permissions et rester dangereuse si elle s’exécute sans limite. Par exemple, une commande de test peut lancer un script, un script peut lire des fichiers, une dépendance peut écrire dans un cache, ou un outil CLI peut tenter une connexion réseau. Le nom de la commande ne décrit pas toujours tout ce que ses processus enfants feront.

Le sandbox répond à cette limite. Il applique des règles au niveau du système d’exploitation. Si une commande autorisée tente d’écrire hors des chemins permis ou de joindre un domaine réseau non autorisé, la limite système la bloque. Cette limite tient indépendamment de ce que le modèle a choisi d’exécuter, même si une commande autorisée fait plus que son nom ne le suggère.

Ce que l’isolation protège
L’isolation protège principalement trois surfaces : le système de fichiers, le réseau et les identifiants accessibles au processus. Selon l’approche choisie, elle peut seulement couvrir les commandes Bash, ou couvrir tout le processus Claude Code, y compris les outils de fichiers, les hooks et les serveurs MCP.

Le choix du niveau d’isolation dépend du modèle de menace. Si vous faites une correction locale dans un dépôt de confiance, le sandbox Bash peut suffire. Si vous exécutez une tâche sans surveillance, manipulez du code non fiable ou activez un mode très autonome, il faut une limite plus forte : runtime sandbox, devcontainer, conteneur Docker dédié ou machine virtuelle.

/sandbox
Ce que fait la commande
/sandbox ouvre le panneau de configuration du sandbox Bash. Ce panneau contient notamment un onglet de mode, un onglet de dépendances et un onglet de configuration résolue. Le sandbox Bash est intégré à Claude Code et fournit une isolation du système de fichiers et du réseau pour les commandes Bash et leurs processus enfants.

Sur macOS, le sandbox utilise le framework système Seatbelt. Sur Linux et WSL2, il repose sur bubblewrap pour l’isolation du système de fichiers et sur socat pour relayer le trafic réseau à travers le proxy du sandbox. Windows natif n’est pas supporté pour ce sandbox : sur Windows, il faut utiliser WSL2, un conteneur ou une machine virtuelle.

Les deux modes du sandbox Bash
Le panneau /sandbox expose deux comportements principaux. En mode auto-allow, les commandes Bash qui s’exécutent à l’intérieur du sandbox sont approuvées automatiquement, parce que leur accès est contenu par la limite système ; une commande qui ne peut pas être sandboxée (outil exclu ou hôte non autorisé) repasse par le flux de permission habituel, et vos règles ask ou deny explicites continuent de s’appliquer. En mode permissions régulières, le sandbox est actif mais vous validez encore chaque commande, avec moins d’invites que sans sandbox puisque les opérations refusées échouent directement au lieu de demander. Dans les deux cas, les restrictions de fichiers et de réseau du sandbox sont identiques.

Le mode auto-allow du sandbox n’est pas le mode auto. Le mode auto utilise un classificateur pour examiner les actions. Le mode auto-allow du sandbox approuve certaines commandes Bash parce qu’elles sont contenues par la limite du sandbox, et fonctionne indépendamment du mode de permission. Les deux mécanismes peuvent se combiner, mais ils ne contrôlent pas la même chose.

Comportement par défaut
Par défaut, les commandes sandboxées peuvent écrire dans le répertoire de travail courant et dans le répertoire temporaire de la session. Le répertoire temporaire de la session est exposé via $TMPDIR pour les commandes sandboxées. La première fois qu’une commande a besoin d’un nouveau domaine réseau, Claude Code demande une approbation, puis autorise cet hôte pour la session.

Le comportement de lecture par défaut est plus permissif que ce que beaucoup d’utilisateurs imaginent : le sandbox Bash peut lire l’ensemble de l’ordinateur sauf les répertoires explicitement refusés, ce qui peut inclure des fichiers d’identifiants comme ~/.aws/credentials ou ~/.ssh si vous ne les bloquez pas. Il faut donc configurer les identifiants et les lectures sensibles explicitement.

Configurer le sandbox Bash
Activer le sandbox
Pour activer le sandbox dans un projet, utilisez /sandbox. Le choix effectué dans le panneau écrit dans les paramètres locaux du projet. Pour l’activer globalement, définissez sandbox.enabled dans les paramètres utilisateur. Pour l’imposer à l’échelle d’une organisation, utilisez les paramètres gérés ; pour les clés booléennes comme enabled et failIfUnavailable, la valeur gérée s’impose et toute valeur définie localement par un développeur est ignorée.

Échouer si le sandbox est indisponible
Par défaut, si le sandbox ne peut pas démarrer parce qu’une dépendance manque ou parce que la plateforme ne le supporte pas, Claude Code affiche un avertissement et exécute les commandes sans sandbox. Pour un environnement géré où le sandbox est une porte de sécurité, définissez failIfUnavailable à true : une dépendance manquante empêche alors Claude Code de démarrer au lieu de basculer en exécution non sandboxée.

Interdire les reprises hors sandbox
Lorsqu’une commande échoue à cause des restrictions du sandbox, Claude Code peut proposer une reprise hors sandbox. Pour empêcher cette trappe d’échappement, définissez allowUnsandboxedCommands à false : le paramètre interne qui désactive le sandbox pour une commande est alors ignoré, et les commandes doivent s’exécuter sandboxées ou figurer dans excludedCommands.
Cette configuration est adaptée aux environnements contrôlés. Elle évite qu’une commande qui ne passe pas dans la limite système soit simplement relancée sans isolation.

Système de fichiers
Autoriser l’écriture ciblée
Si une commande sandboxée doit écrire dans un chemin hors du répertoire de travail ou hors du répertoire temporaire de session, utilisez sandbox.filesystem.allowWrite. Cette approche est préférable à l’exclusion entière de l’outil du sandbox, parce que la limite système continue de s’appliquer aux processus enfants.
Dans les paramètres du sandbox, les préfixes de chemin suivent les conventions standards : /tmp/build est un chemin absolu, ~/cache est relatif au répertoire personnel, et ./output est relatif à la racine du projet dans les paramètres projet. Cette syntaxe diffère des règles Read et Edit, qui utilisent une autre logique d’ancrage.

Refuser la lecture du répertoire personnel
Pour empêcher les commandes Bash sandboxées de lire largement le répertoire personnel, utilisez denyRead, puis réautorisez le projet avec allowRead.
Ce bloc doit être placé dans les paramètres projet si vous voulez que . désigne la racine du projet. Dans les paramètres utilisateur, . se résoudrait différemment.

Protéger les identifiants
Les commandes Bash sandboxées héritent par défaut de l’environnement du processus parent, y compris des identifiants qui y sont définis, et le sandbox peut lire les fichiers d’identifiants non bloqués. Deux leviers existent. Le bloc sandbox.credentials déclare des fichiers d’identifiants refusés en lecture et des variables d’environnement supprimées avant chaque exécution sandboxée. La variable CLAUDE_CODE_SUBPROCESS_ENV_SCRUB permet, elle, de retirer les identifiants Anthropic et fournisseur cloud de tous les sous-processus.

Les données sensibles doivent être absentes ou explicitement bloquées. L’isolation ne doit pas être conçue en supposant que les secrets peuvent rester accessibles sans risque. La couche Bash (via denyRead ou credentials) et la couche outils (via les règles Read) se configurent séparément ; pour fermer un chemin des deux côtés, il faut une règle dans chacune.

Réseau
Autoriser les domaines nécessaires
Le sandbox réseau contrôle les domaines que les commandes Bash peuvent atteindre, via un proxy exécuté hors du sandbox. Aucun domaine n’est préautorisé par défaut ; la première tentative d’accès à un nouveau domaine déclenche une demande. Pour éviter cette invite, préautorisez les domaines nécessaires avec allowedDomains. Les domaines explicitement refusés se configurent avec deniedDomains.

Les règles réseau du sandbox sont séparées des règles WebFetch. Un domaine que vous voulez rendre accessible à un processus sandboxé doit donc aussi avoir une règle réseau explicite côté sandbox.

Éviter les autorisations réseau trop larges
Un sandbox efficace exige à la fois une isolation du système de fichiers et du réseau. Sans isolation réseau, un agent compromis pourrait exfiltrer des fichiers sensibles comme des clés SSH ; sans isolation du système de fichiers, un agent compromis pourrait altérer des ressources système pour regagner un accès réseau.
Ne corrigez pas un problème de dépendance en ouvrant tout le réseau. Préautorisez seulement les domaines nécessaires au projet : registre de paquets, API de dépôt, documentation interne ou fournisseur explicitement requis. Quand vous élargissez les valeurs par défaut, vérifiez qu’un chemin allowWrite, un allowedDomains trop large ou une exception excludedCommands n’annule pas une restriction de l’autre côté.

Ce que le sandbox Bash ne couvre pas
Couverture limitée à Bash
L’outil Bash sandboxé couvre les commandes Bash et leurs processus enfants. Il ne met pas automatiquement derrière une limite système les outils de fichiers intégrés, WebFetch, les serveurs MCP ou les hooks. Pour contenir aussi ces éléments, il faut exécuter l’ensemble du processus Claude Code dans un runtime sandbox, un devcontainer ou un conteneur personnalisé.
Cette limite est centrale. Si votre risque vient uniquement des commandes shell, /sandbox peut suffire. Si votre risque vient d’un serveur MCP, d’un hook ou d’un outil externe lancé par la session, vous devez isoler tout le processus.

Les processus externes restent réels
Une commande qui exécute un script de projet peut encore lancer du code arbitraire à l’intérieur de la limite sandbox. Le sandbox limite l’accès, mais il n’explique pas le comportement du script et ne garantit pas que le résultat est correct. Il faut donc garder les tests, le diff, Git et la revue humaine comme couches de vérification.

Runtime sandbox
Isoler tout le processus Claude Code
Le runtime sandbox enveloppe l’ensemble du processus Claude Code avec les mêmes primitives d’isolation que le sandbox Bash : Seatbelt sur macOS, bubblewrap sur Linux et WSL2. Contrairement au sandbox Bash intégré, il contraint toute la session : outils de fichiers, hooks, serveurs MCP et autres processus liés.
Cette option est pertinente si vous voulez isoler davantage sans Docker. Elle impose cependant une configuration plus complète, notamment les chemins d’écriture nécessaires à Claude Code, les chemins de configuration et les domaines réseau indispensables.

Quand le choisir
Choisissez le runtime sandbox lorsque vous voulez isoler les outils intégrés, les hooks et les serveurs MCP en plus de Bash, mais que vous ne voulez pas ou ne pouvez pas utiliser Docker. Pour une organisation, il faut vérifier la maturité du runtime, le format de configuration et la compatibilité de la plateforme avant d’en faire une base durable.

Devcontainers
Isoler l’environnement de développement
Un devcontainer exécute Claude Code dans un conteneur Docker géré par VS Code ou un éditeur compatible, avec le projet monté à l’intérieur. Le terminal, les serveurs de langage, les outils de compilation et Claude Code s’exécutent dans le conteneur plutôt que sur l’hôte. Vous définissez le vôtre avec un répertoire .devcontainer/ dans le dépôt.
Le dépôt claude-code publie un exemple de devcontainer avec un pare-feu iptables en refus par défaut comme point de départ. Copiez-le dans votre dépôt et ajustez la liste d’autorisation du pare-feu, l’image de base et la version épinglée de Claude Code. Comme le pare-feu bloque la sortie non approuvée, une configuration de ce type permet d’exécuter Claude Code avec --dangerously-skip-permissions pour du travail sans surveillance.
Cette approche est utile pour standardiser l’environnement d’équipe : même version d’outils, mêmes dépendances, mêmes politiques réseau, mêmes paramètres gérés et même configuration de projet.

Ce qu’un devcontainer ne protège pas automatiquement
Un devcontainer n’est pas une protection absolue. Si des identifiants Claude, des secrets cloud ou des clés SSH sont montés dans le conteneur, un projet malveillant qui peut les lire peut encore les exfiltrer si le réseau le permet. Ne montez pas les secrets de l’hôte comme ~/.ssh ou des fichiers d’identifiants cloud, et préférez des jetons limités au dépôt ou à courte durée de vie.
Un devcontainer isole l’environnement d’exécution, pas les données que vous choisissez d’y mettre.

Appliquer une politique d’équipe
Un devcontainer est aussi un bon endroit pour livrer une politique d’organisation. Claude Code lit /etc/claude-code/managed-settings.json sur Linux et applique ces paramètres avec la priorité la plus forte. Ce mécanisme permet d’imposer des règles de sandbox, de permissions, de télémétrie, de version ou de serveurs MCP dans une image commune.

Docker, conteneurs personnalisés et machines virtuelles
Conteneur personnalisé
Vous pouvez exécuter Claude Code dans n’importe quelle image Docker ou OCI avec vos propres politiques réseau, volumes montés et profils seccomp. C’est le chemin le plus courant pour les organisations qui ont déjà une infrastructure de conteneurs ou des exécuteurs CI, et plusieurs services gérés de sandbox ou d’exécution distante peuvent héberger le conteneur.
La même vérification s’applique qu’à tout conteneur : ce qui est monté en écriture, les identifiants et jetons accessibles à l’intérieur, et la politique de sortie réseau. Vous pouvez superposer le sandbox Bash intégré dans le conteneur pour des restrictions par commande. Les conteneurs non privilégiés nécessitent le réglage de sandbox imbriqué décrit dans le dépannage du sandbox.

Machine virtuelle
Une machine virtuelle dédiée fournit la séparation la plus forte, avec son propre noyau et, dans les déploiements cloud ou microVM, son propre matériel virtualisé. Les options incluent des instances cloud, des hyperviseurs locaux et des microVM comme Firecracker. Utilisez cette approche pour évaluer du code non fiable, respecter une politique nécessitant une séparation au niveau du noyau, ou travailler dans un contexte où les approches sur l’hôte ou les conteneurs ne suffisent pas.
Plus le code est non fiable, plus l’isolation doit se rapprocher d’une machine jetable. Une VM ou un environnement cloud isolé est préférable lorsque le dépôt lui-même fait partie de la menace.

Claude Code sur le web
Claude Code sur le web s’exécute dans un sandbox cloud hébergé par Anthropic, clone le référentiel depuis GitHub et peut être utilisé depuis un appareil sans environnement local. C’est une option utile pour une isolation complète sans provisionner soi-même l’infrastructure, sous réserve de disponibilité du plan et de connexion GitHub.
Cette option ne remplace pas automatiquement l’environnement local si la tâche dépend de services internes, de fichiers non poussés, de dépendances privées locales ou de secrets de développement.

Données fictives et secrets absents
Principe de minimisation
L’isolation technique doit être accompagnée d’une minimisation des données. Ne donnez pas à un agent plus de données que nécessaire. Pour les tests, utilisez des données fictives. Pour les intégrations, utilisez des comptes de développement. Pour les jetons, utilisez des jetons courts, limités et révocables. Pour les dépôts non fiables, partez d’un environnement sans secrets.

Pourquoi les données fictives comptent
Un sandbox limite les effets possibles, mais il ne change pas ce qui est envoyé au modèle ni ce qui est accessible dans l’environnement. Les invites et les fichiers que Claude lit sont transmis à l’API Anthropic ou au fournisseur configuré, avec ou sans sandbox.
La meilleure donnée sensible est celle qui n’est jamais présente. Si une tâche peut être faite avec un exemple minimal, une fixture ou un secret factice, il faut préférer cette version.

Choisir la bonne approche
Comparer les niveaux d’isolation

Approche | Ce qui est principalement isolé | Usage pertinent
---|---|---
/sandbox | Commandes Bash et processus enfants | Réduire les invites sur une machine de confiance.
Runtime sandbox | Tout le processus Claude Code | Isoler Bash, outils de fichiers, hooks et MCP sans Docker.
Devcontainer | Environnement de développement complet | Standardiser l’environnement d’équipe et contenir les outils.
Conteneur personnalisé | Environnement complet contrôlé par l’organisation | CI, runners internes, politiques réseau et images reproductibles.
Machine virtuelle | Système d’exploitation complet | Code non fiable, conformité forte, séparation au niveau du noyau.
Claude Code sur le web | Environnement cloud hébergé | Travail isolé sans configuration locale, si le dépôt GitHub suffit.

Règle de choix
Pour le travail quotidien sur un dépôt de confiance, commencez par /sandbox et des règles de permissions ciblées. Pour une tâche autonome ou très permissive, utilisez au minimum un devcontainer, un conteneur, une VM ou le runtime sandbox, afin que les outils de fichiers, les serveurs MCP et les hooks soient aussi dans la limite. Pour un dépôt non fiable, utilisez une VM dédiée ou un environnement cloud isolé. L’idée centrale est de faire correspondre l’approche au modèle de menace : sandbox Bash pour réduire les invites, conteneur ou VM pour l’exécution sans surveillance, runtime sandbox pour isoler aussi les hooks et MCP, VM ou cloud pour les référentiels non fiables.

Protocoles recommandés
Travail local avec sandbox Bash
Avant de continuer :
active le sandbox ;
garde les écritures dans le répertoire du projet ;
demande avant tout accès réseau nouveau ;
ne lis pas les fichiers d’identifiants ;
exécute uniquement les tests ciblés.

Devcontainer d’équipe
Dans le devcontainer :
installer Claude Code ;
utiliser des dépendances reproductibles ;
bloquer la sortie réseau non nécessaire ;
ne pas monter les secrets de l’hôte ;
utiliser des jetons limités ;
placer la politique commune dans les paramètres gérés

Dépôt non fiable
Pour un dépôt non fiable :
utiliser une VM ou un environnement cloud isolé ;
ne monter aucun secret ;
désactiver les identifiants personnels ;
restreindre le réseau ;
travailler sur une copie jetable ;
vérifier le diff avant toute récupération vers l’hôte

Erreurs fréquentes
Penser que /sandbox protège toute la session
/sandbox protège les commandes Bash et leurs processus enfants. Il ne protège pas automatiquement les outils de fichiers intégrés, les hooks et les serveurs MCP. Pour contenir tout le processus, il faut utiliser le runtime sandbox, un devcontainer, un conteneur ou une VM.

Activer un mode très permissif sans isolation forte
Un mode très autonome sans limite d’environnement est dangereux. Si vous retirez l’examen par action, l’isolation devient la principale barrière restante. Elle doit alors contenir tout ce qui peut produire des effets : fichiers, réseau, hooks, MCP et processus enfants.

Monter les secrets dans un conteneur
Un conteneur qui contient vos clés SSH, vos identifiants cloud ou des jetons larges n’est pas un environnement proprement isolé. Il contient simplement les secrets à un autre endroit.

Ouvrir trop largement le réseau
Autoriser toute la sortie réseau annule une partie majeure de l’isolation. Autorisez seulement les domaines nécessaires et refusez les destinations qui ne doivent jamais recevoir de données.

Exclure trop de commandes du sandbox
Chaque commande ajoutée aux exclusions sort de la limite système. Une exclusion doit être rare, justifiée et plus étroite que possible. Si beaucoup de commandes doivent être exclues, l’approche d’isolation n’est probablement pas adaptée.

Croire que l’isolation remplace Git
L’isolation réduit l’impact des actions. Elle ne fournit pas un historique durable, une revue de diff ou un mécanisme de collaboration. Git reste nécessaire pour inspecter, comparer, annuler et partager les changements.

Table de décision

Situation | Approche recommandée | Raison
---|---|---
Tests locaux dans un dépôt de confiance | /sandbox | Les commandes Bash sont contenues, sans conteneur complet.
Hooks ou MCP à isoler | Runtime sandbox ou conteneur | Le sandbox Bash ne couvre pas ces processus.
Équipe avec environnement standardisé | Devcontainer | Mêmes outils, mêmes dépendances, même politique.
CI ou exécution automatisée | Conteneur personnalisé | L’image, le réseau et les volumes sont contrôlés.
Code non fiable | VM dédiée ou cloud isolé | La séparation doit être plus forte que le simple sandbox Bash.
Données sensibles réelles | Données fictives ou environnement sans secrets | Ne pas exposer ce qui n’est pas nécessaire.
