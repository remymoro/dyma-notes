# Étendre les capacités de Claude Code

Étendre Claude Code ne signifie pas seulement lui ajouter des commandes ou des intégrations. Cela consiste à modifier la manière dont il connaît un projet, dont il accède aux systèmes externes, dont il automatise certains événements, dont il délègue le travail et dont il réutilise des procédures spécialisées.

Claude Code dispose déjà d’outils intégrés pour lire, rechercher, modifier, exécuter des commandes et accéder au web. La couche d’extension intervient lorsque ces outils génériques ne suffisent plus : lorsque le projet possède des conventions stables, lorsqu’une procédure revient souvent, lorsqu’un service externe doit être interrogé, lorsqu’une tâche secondaire doit être isolée, ou lorsqu’une règle doit s’appliquer de manière déterministe.

Une extension n’est donc pas un ajout décoratif. C’est une modification de la surface opérationnelle de Claude Code. Elle change ce que le système voit, ce qu’il peut appeler, ce qu’il peut automatiser, ce qu’il peut déléguer ou ce qu’il peut distribuer à d’autres projets.

La question centrale n’est pas : « comment ajouter le plus de fonctionnalités possible ? » La question correcte est : à quel endroit de la boucle faut-il intervenir ? Certaines extensions agissent sur le contexte, d’autres sur les outils, d’autres sur le cycle de vie, d’autres sur l’isolation du travail, d’autres encore sur la distribution et la réutilisation en équipe.

## L’extension comme couche au-dessus des outils intégrés

### Les outils intégrés couvrent le socle

Les outils intégrés de Claude Code couvrent les opérations fondamentales : lire un fichier, chercher dans un dépôt, éditer, écrire, exécuter une commande, interroger une URL, rechercher sur le web, inspecter le code avec un serveur de langage, ou déléguer à un agent. Ce socle permet déjà de traiter une grande partie des tâches de développement.

La couche d’extension ne remplace pas ce socle. Elle l’oriente, le spécialise ou l’augmente. Un `CLAUDE.md` peut indiquer comment utiliser les outils dans ce projet. Une skill peut encapsuler une procédure réutilisable. Un serveur MCP peut ajouter de nouveaux outils. Un hook peut imposer une vérification après usage d’un outil. Un subagent peut utiliser les outils dans un contexte isolé. Un plugin peut empaqueter tout cela pour plusieurs projets.

L’extension est donc une couche de spécialisation, pas une seconde architecture parallèle. Elle se connecte à la boucle existante et modifie certains de ses points d’entrée : contexte, outils, événements, délégation ou packaging.

### Le bon mécanisme dépend du point d’injection

Chaque mécanisme d’extension répond à une question différente. Si Claude doit toujours connaître une convention, on utilise un fichier d’instructions persistant. S’il doit parfois charger une procédure longue, on utilise une skill. S’il doit accéder à un système externe, on utilise MCP. S’il faut exécuter quelque chose à chaque événement, on utilise un hook. S’il faut préserver le contexte principal, on utilise un subagent. S’il faut partager une configuration complète, on utilise un plugin.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

- **Convention permanente** → `CLAUDE.md` ou `.claude/rules/`
- **Procédure réutilisable** → `Skill`
- **Système externe** → `MCP`
- **Navigation sémantique code** → `Code intelligence`
- **Travail isolé** → `Subagent`
- **Travail multi-session** → `Agent team`
- **Automatisation déterministe** → `Hook`
- **Distribution réutilisable** → `Plugin` ou `marketplace`

</div>

Cette distinction est le fondement de toute configuration sérieuse. Une extension mal placée ajoute du bruit, augmente le coût de contexte et rend le comportement plus difficile à contrôler.

![Quand les fonctionnalités entrent dans le contexte](./assets/etendre-capacites-1.png)

## CLAUDE.md et les règles : étendre la connaissance persistante

### Le contexte toujours actif

`CLAUDE.md` sert à donner à Claude Code un contexte persistant : conventions du projet, commandes de test, décisions d’architecture, règles de style, structure du dépôt, contraintes permanentes et informations que Claude ne peut pas déduire facilement par exploration.

Ce mécanisme intervient au niveau du contexte. Il ne donne pas de nouvel outil. Il ne déclenche pas une action. Il modifie ce que Claude sait au moment où il raisonne sur la tâche. C’est donc le bon endroit pour les règles qui doivent être visibles dans presque toutes les sessions.

`CLAUDE.md` doit rester court, stable et discriminant. Une instruction persistante consomme du contexte à chaque session. Si elle répète une évidence, si elle décrit une procédure occasionnelle ou si elle contient une documentation longue, elle diminue la qualité du signal au lieu de l’améliorer.

### Quand utiliser .claude/rules/

Les règles dans `.claude/rules/` permettent de modulariser les instructions et de les limiter à certains chemins. Elles sont utiles dans les grands dépôts, les monorepos ou les projets où les conventions diffèrent fortement selon les répertoires.

La différence est importante. `CLAUDE.md` convient aux conventions globales. Les règles conviennent aux instructions spécifiques à un langage, un répertoire, un package ou une zone fonctionnelle. Elles réduisent le bruit parce qu’elles peuvent se charger seulement lorsque Claude travaille avec les fichiers concernés.

La bonne pratique est de placer les invariants généraux dans `CLAUDE.md`, et les contraintes locales dans `.claude/rules/`. Le but n’est pas d’écrire plus d’instructions, mais de les charger au bon moment.

### Ce que CLAUDE.md ne garantit pas

Un fichier d’instructions guide le modèle ; il ne constitue pas une politique d’exécution déterministe. Une consigne comme « ne jamais modifier .env » est utile, mais elle reste une instruction lue par le modèle. Si cette règle doit être absolument garantie, il faut la transformer en hook, en permission, en règle de contrôle ou en vérification externe.

Le contexte persistant n’est pas une barrière de sécurité. Il influence le raisonnement. Il ne remplace pas les mécanismes de contrôle.

## Les skills : étendre les procédures et l’expertise

### Une skill comme capacité réutilisable

Une skill est une capacité réutilisable écrite sous forme de fichier markdown. Elle peut contenir des instructions, une procédure, une checklist, une expertise de domaine, des fichiers de support ou un flux de travail invocable par commande.

La skill convient lorsque l’utilisateur répète le même prompt, colle régulièrement le même playbook ou maintient dans `CLAUDE.md` une section qui est devenue trop procédurale. Contrairement à `CLAUDE.md`, le corps complet d’une skill ne doit pas nécessairement être chargé dans chaque session. Son coût de contexte peut donc rester faible jusqu’à son utilisation.

La skill est l’extension du savoir-faire, pas seulement du savoir. Elle ne dit pas seulement à Claude ce qu’il doit savoir ; elle lui donne une manière de travailler sur une famille de tâches.

### Skill de référence et skill d’action

Une skill peut être une ressource de référence : guide d’API, convention de documentation, modèle de réponse, architecture d’un service, règles d’un domaine métier. Elle peut aussi être une skill d’action : procédure de déploiement, revue de sécurité, génération de changelog, audit de migration, vérification de release.

Cette distinction change son écriture. Une skill de référence doit être structurée pour être consultée. Une skill d’action doit définir une séquence opératoire, des préconditions, des vérifications et un résultat attendu.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Skill de référence :**
- explique une convention ;
- fournit un vocabulaire ;
- donne des modèles ;
- aide Claude à raisonner correctement.

**Skill d'action :**
- démarre un flux de travail ;
- impose une procédure ;
- utilise des outils ;
- produit un livrable vérifiable.

</div>

### Pourquoi ne pas tout mettre dans des skills

Les skills ne remplacent pas tout le reste. Elles restent interprétées par Claude. Elles sont appropriées lorsque la tâche exige du raisonnement, de l’adaptation ou une procédure semi-flexible. Elles ne sont pas appropriées pour une règle qui doit s’exécuter exactement de la même manière à chaque événement.

Pour une action déterministe, le hook est plus adapté. Pour un accès à un service externe, MCP est plus adapté. Pour une tâche bruyante qui lit beaucoup de fichiers, le subagent est plus adapté. Pour une distribution en équipe, le plugin est plus adapté.

## MCP : étendre la surface d’outils et de données

### Connecter Claude Code au monde externe

MCP, ou Model Context Protocol, sert à connecter Claude Code à des outils, bases de données, APIs et services externes. Il intervient au niveau de la surface d’action. Là où une skill ajoute des connaissances ou des procédures, MCP ajoute des capacités d’interaction avec un système externe.

Un serveur MCP peut exposer des outils appelables, des ressources lisibles ou des prompts. Il peut connecter Claude à un outil de suivi de tickets, une base PostgreSQL, un service de monitoring, un dépôt GitHub, un outil de design, une plateforme de communication ou un système interne.

MCP doit être utilisé lorsque le problème vient de l’accès aux données ou aux actions externes. Si l’utilisateur copie sans cesse des informations depuis un tableau de bord, un outil métier ou une base de données vers le chat, le bon niveau d’extension est probablement un serveur MCP.

### MCP et skill ne jouent pas le même rôle

La confusion la plus fréquente consiste à opposer MCP et skill. En réalité, ils se complètent. MCP donne accès à un système ; une skill peut expliquer comment utiliser ce système correctement.

Un serveur MCP peut fournir un outil de requête sur une base. Une skill peut documenter le modèle de données, les tables à éviter, les requêtes usuelles, les règles d’anonymisation et le format attendu des résultats. Le premier donne la capacité d’agir ; la seconde donne la compétence pour agir correctement.

### La surface MCP doit être gouvernée

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

- **MCP** fournit la connexion.
- **La skill** fournit la méthode.
- **Le hook** peut contrôler certains événements.
- **Le plugin** peut empaqueter l'ensemble.

</div>

Ajouter un serveur MCP augmente les capacités de Claude Code, mais augmente aussi la surface de risque. Un outil externe peut exposer des données sensibles, déclencher des actions réelles ou introduire des comportements non prévus. Il faut donc traiter les serveurs MCP comme des dépendances d’exécution, pas comme de simples aides documentaires.

Un serveur MCP doit être installé à la bonne portée, audité, documenté, limité par des permissions adaptées et retiré lorsqu’il n’est plus nécessaire. Dans un environnement professionnel, il faut aussi clarifier qui maintient le serveur, quelles données il expose, quelles actions il autorise et comment ses erreurs sont observées.

## La code intelligence : étendre la compréhension structurelle du dépôt

### Au-delà de Grep

La code intelligence connecte Claude Code à un serveur de langage. Elle permet une navigation au niveau des symboles : définitions, références, types, diagnostics, implémentations et relations de code. Elle complète les recherches textuelles classiques.

`Grep` voit du texte. La code intelligence voit une structure interprétée par un serveur de langage. Dans les langages typés ou les grands dépôts, cette différence est décisive. Suivre une définition ou une référence par le serveur de langage évite souvent de lire trop de fichiers ou de se tromper sur une homonymie.

La code intelligence est une extension de précision. Elle réduit le bruit exploratoire et améliore la qualité des observations après modification, notamment lorsque des diagnostics sont remontés automatiquement.

### Quand l’ajouter

Il faut l’ajouter lorsque Claude lit trop largement pour comprendre où un symbole est défini, lorsque les erreurs de type sont fréquentes, lorsque la navigation par texte devient insuffisante, ou lorsque le dépôt est assez grand pour rendre les recherches naïves coûteuses.

Comme elle dépend de plugins et de binaires de serveurs de langage, elle doit être considérée comme une capacité d’environnement. Elle n’est fiable que si le serveur de langage est installé, configuré et cohérent avec le projet.

## Les subagents : étendre par isolation du travail

### Un contexte séparé pour les tâches bruyantes

Un subagent permet de déléguer une tâche à un agent spécialisé qui dispose de son propre contexte. Il peut lire de nombreux fichiers, effectuer une recherche large, analyser un sous-système, vérifier une hypothèse ou produire une revue ciblée sans saturer la conversation principale.

Le subagent retourne un résultat synthétique. La conversation principale ne reçoit pas nécessairement tout le détail intermédiaire. Cette architecture est essentielle lorsque le travail secondaire serait utile, mais trop volumineux pour rester dans le contexte principal.

Le subagent n’étend pas seulement les capacités ; il protège l’attention du contexte principal. Il permet d’exécuter une exploration ou une vérification tout en gardant la session parent lisible.

### Spécialiser les agents

Un subagent peut avoir ses propres instructions, ses propres outils autorisés, son propre modèle, ses propres permissions et éventuellement ses propres skills préchargées. Cette spécialisation permet de définir des travailleurs récurrents : relecteur de sécurité, analyste de tests, explorateur de code, validateur de requêtes, examinateur de documentation.

Le point important est l’isolation. Un subagent n’est pas seulement un prompt plus long. C’est une unité de travail avec une frontière de contexte. Cette frontière permet de contrôler ce qui revient à la conversation principale.

### Quand ne pas utiliser un subagent

Un subagent est moins adapté lorsque le travail exige de conserver chaque détail dans la conversation principale, lorsque la tâche est très courte, ou lorsque la coordination continue avec l’utilisateur est plus importante que l’isolation. Dans ces cas, la conversation principale reste préférable.

Le subagent doit être réservé aux travaux où le bénéfice de l’isolation dépasse le coût de coordination.

## Les agent teams : étendre par coordination multi-session

### Du travail isolé au travail collaboratif

Les agent teams permettent de coordonner plusieurs sessions Claude Code indépendantes. Contrairement aux subagents, qui rapportent principalement à l’agent principal dans une même session, les coéquipiers d’une équipe peuvent travailler comme sessions séparées, se coordonner autour de tâches partagées et communiquer entre eux.

Cette extension est adaptée aux tâches où plusieurs hypothèses, domaines ou responsabilités doivent être traités en parallèle : revue de code multi-angle, recherche concurrente, analyse sécurité-performance-tests, ou développement d’une fonctionnalité découpée en responsabilités distinctes.

Une équipe d’agents est une extension de coordination, pas seulement de parallélisme. Elle a du sens lorsque les agents doivent produire des résultats distincts, se confronter ou collaborer, et pas seulement exécuter une recherche isolée.

### Une extension avancée

Les équipes d’agents doivent être traitées comme un mécanisme avancé. Elles consomment davantage de ressources, exigent une définition claire des responsabilités et peuvent produire des conflits si plusieurs coéquipiers modifient les mêmes zones. Il faut donc les réserver aux tâches complexes, et non aux corrections locales.

Pour une simple recherche bruyante, un subagent suffit. Pour une analyse parallèle avec hypothèses concurrentes et coordination explicite, une agent team devient pertinente.

## Les hooks : étendre par automatisation déterministe

### Le hook comme événement contrôlé

Un hook est une action déclenchée à un événement du cycle de vie de Claude Code. Il peut exécuter une commande shell, appeler une requête HTTP, lancer une invite, générer un subagent ou bloquer une opération selon la configuration.

Le hook intervient là où une instruction au modèle serait trop faible. Si une action doit se produire à chaque fois, il ne faut pas demander à Claude de s’en souvenir. Il faut l’attacher à un événement.

Le hook est l’outil des règles déterministes. Il convient au formatage automatique, au linting après modification, au blocage de fichiers protégés, à l’audit, à la notification, au contrôle de permissions ou à la réinjection de contexte après certains événements.

### Hook ou skill

La différence entre hook et skill est conceptuelle. Une skill est lue et interprétée par Claude. Un hook se déclenche sur un événement. Une skill convient lorsque la tâche demande du jugement. Un hook convient lorsque le comportement doit être systématique.

### Le hook peut aussi produire du contexte

Un hook peut rester extérieur à la conversation et ne rien ajouter au contexte. Mais il peut aussi retourner une sortie qui sera réinjectée dans la session. Cette capacité doit être utilisée avec retenue. Un hook qui retourne trop de texte peut polluer la conversation principale.

La bonne pratique est de réserver la sortie de hook aux informations réellement utiles pour la décision suivante : résultat de linter, diagnostic court, blocage justifié, lien vers un rapport, ou message d’erreur structuré.

## Les plugins : étendre par packaging et distribution

### Un plugin comme unité installable

Un plugin regroupe des extensions dans une unité installable. Il peut contenir des skills, des agents, des hooks, des serveurs MCP, des serveurs LSP, des paramètres par défaut ou d’autres composants distribuables.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

- Si Claude doit raisonner → **Skill**
- Si l'action doit se produire à chaque fois → **Hook**
- Si la règle doit bloquer une action → **Hook ou perm**
- Si la règle doit guider une décision → **Skill ou CLAUDE.md**

</div>

Le plugin devient pertinent lorsque la configuration dépasse le cadre personnel ou expérimental. Si une équipe veut partager les mêmes workflows, agents, hooks, intégrations et conventions sur plusieurs projets, le plugin est le bon mécanisme.

Le plugin n’est pas seulement une commodité. C’est un mécanisme d’industrialisation. Il permet de versionner, distribuer, activer, désactiver et mettre à jour des capacités de manière plus propre qu’une collection de fichiers copiés à la main.

### Configuration autonome ou plugin

La configuration autonome dans `.claude/` convient à l’expérimentation rapide, aux personnalisations locales et aux besoins propres à un seul projet. Le plugin convient lorsque la même capacité doit être réutilisée, partagée, maintenue et installée dans plusieurs environnements.

### Marketplaces et confiance

Les marketplaces facilitent la découverte et l’installation de plugins. Mais l’installation d’un plugin doit être traitée comme l’ajout d’une dépendance active. Un plugin peut apporter des hooks, des agents, des serveurs MCP, des intégrations externes ou des capacités qui affectent l’environnement de travail.

Il ne faut pas installer un plugin non fiable dans un dépôt sensible. Avant installation, il faut examiner ce que le plugin ajoute, quelle portée il demande, quelles dépendances il installe, quelles actions il peut déclencher et qui le maintient.

## La superposition des extensions

### Des règles différentes selon le mécanisme

Les extensions peuvent exister à plusieurs niveaux : utilisateur, projet, local, géré par organisation ou fourni par plugin. Mais elles ne se superposent pas toutes de la même manière.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**.claude/ local :**
- expérimentation ;
- configuration personnelle ;
- usage spécifique à un projet ;
- noms courts et rapides.

**Plugin :**
- partage en équipe ;
- réutilisation multi-projets ;
- versionnement ;
- distribution ;
- espace de noms pour éviter les conflits.

</div>

Les fichiers `CLAUDE.md` sont additifs : plusieurs fichiers peuvent contribuer simultanément au contexte. Les skills et subagents se remplacent par nom selon une priorité de portée. Les serveurs MCP peuvent également se remplacer par nom selon leur portée. Les hooks, eux, fusionnent : plusieurs hooks peuvent se déclencher sur le même événement.

Comprendre la superposition est indispensable pour déboguer une configuration. Une extension peut ne pas agir parce qu’elle est masquée, remplacée, désactivée, non chargée, ou parce qu’un hook concurrent ajoute un comportement inattendu.

### Les conflits ne se règlent pas tous dans le prompt

Lorsqu’une configuration devient complexe, il ne faut pas essayer de corriger tous les conflits par des consignes dans le chat. Il faut inspecter les niveaux de configuration, vérifier les noms, les portées, les hooks actifs, les plugins installés, les serveurs MCP connectés et les règles chargées.

Un prompt peut demander une tâche. Il ne doit pas servir de mécanisme permanent pour compenser une configuration mal structurée.

## Les coûts de contexte

### Chaque extension a un coût différent

Étendre Claude Code augmente souvent la puissance du système, mais peut aussi augmenter le coût de contexte. Ce coût n’est pas uniforme.

`CLAUDE.md` charge son contenu complet au début de session. Les skills chargent généralement leurs descriptions au démarrage et leur contenu complet seulement à l’utilisation. Les serveurs MCP peuvent charger les noms d’outils au démarrage et différer les schémas complets. La code intelligence peut réduire le contexte nécessaire en remplaçant des lectures larges par une navigation symbolique. Les subagents utilisent un contexte isolé. Les hooks ont un coût nul par défaut, sauf lorsqu’ils retournent du contexte.

Une extension doit donc être évaluée par son utilité et par son coût cognitif. Une configuration très riche peut rendre Claude moins efficace si elle ajoute trop de descriptions, de règles ou de sorties automatiques.

### L’extension minimale efficace

La bonne stratégie n’est pas de configurer tout dès le départ. Il faut construire la configuration progressivement, à partir de signaux répétés.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

- Claude répète une erreur de convention → **ajouter à CLAUDE.md**
- Une règle dépend d'un répertoire → **créer une règle locale**
- Une procédure revient souvent → **créer une skill**
- Un service externe est consulté sans cesse → **configurer un serveur MCP**
- Une recherche pollue le contexte principal → **créer un subagent**
- Un événement doit toujours déclencher une action → **écrire un hook**
- La configuration sert à plusieurs dépôts → **empaqueter dans un plugin**

</div>

Cette progression évite les architectures surconfigurées. Une extension doit répondre à un frottement observé, pas à une possibilité abstraite.
