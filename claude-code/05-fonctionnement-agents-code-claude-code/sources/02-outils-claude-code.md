# Comprendre les outils dans claude code

![Les outils de Claude Code](./assets/outils-claude-1.png)

Les outils constituent la surface d’action de Claude Code. Ils permettent au système de dépasser la production textuelle pour interagir avec un environnement de développement : lire un fichier, rechercher dans une base de code, modifier une ressource, exécuter une commande, inspecter un diagnostic, récupérer une page web, interroger un serveur MCP, déclencher une skill ou déléguer une opération à un agent spécialisé.

Un outil n’est pas une capacité vague du modèle. C’est une interface formelle, nommée, contrôlée et paramétrée. Le modèle peut demander son utilisation, mais l’exécution appartient au harness de Claude Code. Cette distinction est fondamentale : le modèle ne touche pas directement au disque, au shell, au réseau ou aux services externes. Il produit une demande d’outil ; le système vérifie cette demande, l’exécute si elle est autorisée, puis renvoie le résultat dans la session.

Les outils doivent donc être compris comme des contrats d’exécution. Chaque outil possède un nom, une fonction, des paramètres attendus, un régime de permission, des limites de sortie et un type de résultat. La qualité du système dépend autant de cette surface d’outils que du modèle lui-même, car ce sont les outils qui transforment une intention en opération vérifiable.

## Les outils comme interface entre le modèle et l’environnement

### Une demande d’outil n’est pas encore une action

Lorsqu’un modèle décide qu’une opération est nécessaire, il ne l’exécute pas directement. Il émet une demande structurée d’utilisation d’outil. Cette demande indique l’outil visé et les paramètres nécessaires à son exécution. Le harness interprète ensuite cette demande, vérifie que l’outil est disponible, applique les règles de permission et déclenche l’exécution seulement si les conditions sont satisfaites.

La demande d’outil est donc une intention opératoire, pas un effet système. Cette séparation empêche de confondre ce que le modèle propose avec ce que la machine exécute réellement. Elle permet aussi d’appliquer des contrôles différents selon la nature de l’outil : lire un fichier, écrire un fichier, lancer une commande, accéder au web ou appeler un service externe n’ont pas le même niveau de risque.

### Le résultat d’outil devient une donnée de travail

Un outil renvoie un résultat. Ce résultat peut être le contenu d’un fichier, une liste de chemins, une sortie de commande, une erreur de compilation, un diagnostic de serveur de langage, une sortie de test, une page web transformée, un message de permission, un identifiant de tâche ou un résumé produit par un agent secondaire.

Ce retour n’est pas un simple affichage. Il devient une donnée exploitable dans la suite de la session. La valeur d’un outil ne réside donc pas seulement dans l’action exécutée, mais dans le fait que son résultat modifie l’état informationnel de Claude Code. Un résultat vide, une erreur, un refus ou une sortie tronquée peuvent être aussi informatifs qu’un succès.

## La surface intégrée des outils

### Une nomenclature opérationnelle

La référence officielle des outils liste les outils disponibles par nom : `Read`, `Edit`, `Write`, `Bash`, `PowerShell`, `Glob`, `Grep`, `LSP`, `WebFetch`, `WebSearch`, `Agent`, `Skill`, `Workflow`, `Monitor`, `NotebookEdit`, les outils MCP, les outils de tâches, les outils de planification, les outils de worktree et plusieurs outils d’orchestration.

Ces noms ne servent pas seulement à documenter les capacités de Claude Code. Ils sont aussi utilisés dans les règles de permission, les paramètres, les options du Agent SDK, les définitions de subagents, les skills et les hooks. Le nom de l’outil devient donc une unité de configuration.

### Une surface variable selon la session

L’ensemble exact des outils accessibles n’est pas universel. Il dépend de la plateforme, du fournisseur, du mode d’exécution, des variables d’environnement, des paramètres, des plugins, des serveurs MCP connectés et des restrictions configurées. Une session locale, une session distante, une session sur Windows, une session avec PowerShell, une session avec outils MCP ou une session avec recherche d’outils différée peuvent exposer des surfaces différentes.

La liste théorique des outils n’est donc pas identique au pool effectif d’une session. Pour connaître la surface réellement disponible, il faut interroger la session en cours ou inspecter les configurations concernées, notamment les serveurs MCP lorsque des outils externes sont ajoutés.

## Les outils de lecture et d’exploration

### Read

`Read` lit le contenu d’un fichier et retourne ce contenu avec des numéros de ligne. Cet outil est central, car beaucoup d’opérations de modification exigent que le fichier ait été lu dans la conversation courante avant d’être édité ou remplacé. `Read` ne sert donc pas seulement à inspecter : il établit aussi une base de validité pour certaines écritures ultérieures.

L’outil gère plusieurs types de fichiers. Pour les fichiers texte, il retourne le contenu paginé si nécessaire. Pour les images, il retourne un contenu visuel exploitable par le modèle plutôt que des octets bruts. Pour les fichiers `.pdf`, il peut lire les documents courts en entier et les documents plus longs par plages de pages. Pour les notebooks `.ipynb`, il retourne les cellules, leurs sorties, le code, le markdown et les visualisations.

`Read` lit des fichiers, pas des répertoires. Pour lister un répertoire, Claude Code utilise une commande shell, par exemple via `Bash`.

### Glob et Grep

`Glob` sert à trouver des fichiers par motif de nom. Il travaille sur les chemins et permet de localiser rapidement les fichiers dont le nom ou l’emplacement correspond à une structure donnée. Ses résultats sont limités et triés, ce qui force parfois à affiner le motif lorsque la recherche est trop large.

`Grep` sert à rechercher dans le contenu des fichiers. Là où `Glob` identifie des chemins, `Grep` identifie des correspondances textuelles. Il s’appuie sur la syntaxe regex de ripgrep et peut retourner soit uniquement les fichiers qui correspondent, soit les lignes concernées, soit des comptes de correspondances.

La différence entre `Glob` et `Grep` est structurelle. Le premier explore l’espace des fichiers ; le second explore l’espace du contenu. Les confondre conduit à des recherches moins précises : chercher un fichier par nom n’est pas chercher une fonction, un symbole, une chaîne ou une erreur dans le code.

### LSP

`LSP` ajoute une intelligence de code fondée sur les serveurs de langage. Il permet d’accéder aux définitions, de trouver les références, d’obtenir des informations de type, de lister des symboles, de chercher un symbole dans l’espace de travail, de trouver des implémentations et de suivre certaines relations d’appel.

Son rôle est différent de celui de `Grep`. `Grep` voit du texte ; `LSP` voit une structure de code interprétée par un serveur de langage. Lorsqu’il est disponible, il peut aussi signaler automatiquement des erreurs de type et des avertissements après modification, ce qui donne à Claude Code un retour plus sémantique qu’une simple recherche textuelle.

`LSP` dépend d’un plugin d’intelligence du code et d’un serveur de langage configuré. Il ne faut donc pas le considérer comme une capacité toujours active dans toutes les sessions.

### ListMcpResourcesTool et ReadMcpResourceTool

Les outils `ListMcpResourcesTool` et `ReadMcpResourceTool` donnent accès aux ressources exposées par les serveurs MCP connectés. Ils ne doivent pas être confondus avec les outils MCP eux-mêmes. Un serveur MCP peut exposer des outils appelables, mais il peut aussi exposer des ressources lisibles.

Cette distinction est importante : une ressource MCP est une donnée consultable ; un outil MCP est une capacité d’action ou d’interrogation ajoutée au pool d’outils. Les deux passent par l’infrastructure MCP, mais ils n’ont pas le même statut opérationnel.

## Les outils de modification

### Edit

`Edit` effectue une modification ciblée dans un fichier. Son fonctionnement repose sur un remplacement exact : l’outil reçoit une chaîne ancienne et une chaîne nouvelle, puis remplace la première par la seconde. Il ne s’agit pas d’une recherche floue, ni d’un remplacement par intention, ni d’une transformation regex.

Trois conditions structurent son comportement. Le fichier doit avoir été lu dans la conversation courante et ne pas avoir changé depuis cette lecture. La chaîne à remplacer doit apparaître exactement telle qu’elle est fournie. Elle doit aussi être suffisamment unique pour éviter une modification ambiguë, sauf si le remplacement de toutes les occurrences est explicitement demandé.

`Edit` est donc un outil précis, mais exigeant. Une différence d’espace, d’indentation ou de contexte peut suffire à empêcher la modification. Cette exigence réduit le risque de modifications implicites dans une zone non visée, mais elle impose une lecture préalable correcte et une sélection de contexte suffisamment discriminante.

### Write

`Write` crée un nouveau fichier ou remplace entièrement un fichier existant. Il n’ajoute pas, ne fusionne pas et ne modifie pas partiellement. Pour un fichier déjà existant, Claude Code doit avoir lu le fichier dans la conversation courante avant de pouvoir le remplacer. Pour une modification partielle, l’outil approprié est `Edit`, non `Write`.

La différence entre `Edit` et `Write` correspond donc à la granularité de l’opération. `Edit` agit sur une portion ciblée. `Write` agit sur le contenu complet. Cette distinction est importante dans une base de code, car remplacer un fichier entier n’a pas le même niveau de risque qu’appliquer une modification locale.

### NotebookEdit

`NotebookEdit` modifie un notebook Jupyter cellule par cellule. Il cible les cellules par leur `cell_id` et peut remplacer, insérer ou supprimer une cellule. Il ne fonctionne pas comme `Edit` sur un fichier texte plat : le notebook est une structure composée de cellules, de métadonnées et de sorties.

Modifier un notebook exige donc une granularité différente. Une cellule peut être remplacée sans réécrire l’ensemble du notebook, une cellule peut être insérée après une cible, et une cellule peut être supprimée. Les règles de permission utilisent cependant le même format de chemin que les outils de modification de fichier.

## Les outils d’exécution

### Bash

`Bash` exécute des commandes shell dans l’environnement de l’utilisateur. Il permet de lancer des tests, des builds, des scripts, des commandes git, des gestionnaires de paquets, des serveurs de développement ou des utilitaires système.

Chaque commande s’exécute dans un processus séparé. Le répertoire de travail peut persister après un `cd` dans la session principale tant qu’il reste dans les répertoires autorisés, mais les variables d’environnement définies par `export` dans une commande ne persistent pas dans la commande suivante. Les alias, fonctions et options issus des fichiers de démarrage du shell peuvent être capturés au démarrage de la session et appliqués aux commandes.

`Bash` possède aussi des limites pratiques. Le délai d’expiration par défaut est borné, avec une possibilité d’extension contrôlée. La sortie de commande est également limitée : lorsqu’elle dépasse la limite, Claude Code conserve la sortie complète dans un fichier de session et fournit au modèle un aperçu accompagné du chemin du fichier. L’outil peut alors lire ou rechercher dans ce fichier si le détail complet est nécessaire.

`Bash` est l’un des outils les plus puissants et les plus sensibles. Il donne accès à une couche d’action générale. C’est précisément pourquoi il est soumis à des permissions, à des règles de correspondance de commande et, selon la configuration, à du sandboxing.

### PowerShell

`PowerShell` fournit une exécution native des commandes PowerShell, principalement pour les environnements Windows, mais aussi de manière optionnelle sur Linux, macOS et WSL lorsque pwsh est disponible. Lorsque l’outil est activé, Claude Code peut traiter PowerShell comme shell principal, tout en conservant `Bash` pour les scripts POSIX lorsque l’environnement le permet.

Son intérêt est d’éviter de forcer des commandes Windows à passer par une couche POSIX inadaptée. Les conventions de commande, les scripts `.ps1`, les modules et les comportements système ne sont pas identiques entre `Bash` et `PowerShell`. L’outil distingue donc explicitement les environnements d’exécution au lieu de masquer leurs différences.

### Monitor

`Monitor` exécute une surveillance en arrière-plan et renvoie les lignes de sortie à Claude Code à mesure qu’elles arrivent. Il peut suivre un journal, observer le statut d’une tâche longue, surveiller un répertoire ou suivre la sortie d’un script de longue durée.

La différence avec `Bash` est temporelle. `Bash` lance une commande et renvoie son résultat. `Monitor` maintient une surveillance active pendant que la session continue. Il rend possible une réaction à des événements qui apparaissent après le lancement initial de la commande.

`Monitor` reprend les règles de permission de `Bash`. Les motifs d’autorisation et de refus définis pour les commandes s’appliquent donc également à la surveillance.

## Les outils web

### WebFetch

`WebFetch` récupère le contenu d’une URL et applique une invite d’extraction au contenu récupéré. Lorsque le serveur retourne du HTML, la page est convertie en Markdown avant traitement. Pour la plupart des récupérations, Claude reçoit le résultat de cette extraction, pas nécessairement la page brute.

`WebFetch` est donc volontairement transformateur. Il ne faut pas le comprendre comme un simple `curl` intégré. L’invite d’extraction influence fortement ce qui revient dans la session. Si le résultat indique qu’une page ne mentionne pas un élément, cela peut signifier que la page ne le contient pas, mais aussi que la demande d’extraction n’a pas ciblé cet élément.

L’outil applique aussi des comportements spécifiques : mise à niveau automatique de certaines URL vers HTTPS, troncature des grandes pages, mise en cache temporaire des réponses et gestion explicite des redirections vers d’autres hôtes. Les permissions peuvent être accordées ou refusées par domaine, ce qui permet de contrôler finement les accès web.

### WebSearch

`WebSearch` effectue des recherches web et retourne des titres et des URL. Il ne récupère pas le contenu complet des pages trouvées. Pour lire une page issue d’une recherche, Claude Code doit ensuite utiliser `WebFetch`.

Cette séparation est importante. `WebSearch` découvre des candidats ; `WebFetch` extrait le contenu d’une cible. L’outil de recherche peut limiter les résultats à certains domaines ou en exclure d’autres, mais son backend n’est pas configurable. Pour utiliser un autre fournisseur de recherche, il faut passer par un serveur MCP exposant un outil de recherche distinct.

## Les outils d’organisation du travail

### TaskCreate, TaskGet, TaskList, TaskUpdate et TaskStop

Les outils de tâches servent à organiser le travail dans la session. `TaskCreate` crée une tâche, `TaskGet` récupère ses détails, `TaskList` liste les tâches, `TaskUpdate` modifie leur statut ou leurs dépendances, et `TaskStop` arrête une tâche d’arrière-plan.

Ces outils ne modifient pas directement le code. Ils structurent l’activité de la session. Leur rôle est de donner une forme explicite aux opérations en cours, aux dépendances, aux états d’avancement et aux travaux d’arrière-plan.

### CronCreate, CronList, CronDelete et ScheduleWakeup

Les outils de planification permettent de gérer des invites récurrentes, des tâches ponctuelles ou des réveils de boucle. `CronCreate` crée une planification, `CronList` liste les tâches planifiées, `CronDelete` les annule, et `ScheduleWakeup` règle le moment d’une prochaine itération dans certains modes de boucle auto-rythmée.

Ces outils déplacent l’action dans le temps. Ils ne produisent pas seulement un effet immédiat ; ils permettent d’organiser une reprise, une surveillance ou une répétition dans le cadre d’une session ou d’un service distant selon les cas.

### RemoteTrigger et PushNotification

`RemoteTrigger` concerne la création, la mise à jour, l’exécution et la liste de routines distantes. `PushNotification` permet d’envoyer une notification de bureau ou une notification mobile lorsque certaines conditions sont réunies.

Ces outils sont moins liés au code lui-même qu’à la coordination entre une tâche longue, une session distante, une routine et l’utilisateur. Ils rendent l’agent plus opérable dans des contextes où l’utilisateur ne reste pas nécessairement devant le terminal.

## Les outils d’orchestration

### Agent

`Agent` crée un subagent avec sa propre fenêtre de contexte. Le subagent travaille sur une tâche et retourne un seul résultat textuel à la conversation parent. La conversation parent ne voit pas nécessairement tous les appels d’outils intermédiaires du subagent ; elle reçoit le résultat final.

`Agent` est un outil d’isolation du travail. Il ne sert pas seulement à exécuter une commande ou à lire un fichier. Il crée un espace de travail agentique distinct, avec ses propres contraintes, ses propres outils autorisés et sa propre trajectoire interne. Le parent obtient une synthèse exploitable sans importer toute l’activité intermédiaire dans son propre contexte.

### Skill

`Skill` exécute une skill dans la conversation principale. Une skill peut injecter des instructions spécialisées, imposer une procédure, déclarer des outils autorisés, indiquer des arguments attendus ou adapter l’environnement d’exécution. Du point de vue des outils, `Skill` agit comme un méta-outil : il charge une capacité structurée qui peut elle-même orienter l’usage d’autres outils.

Cette architecture distingue la capacité d’action brute et la compétence opératoire. Un outil exécute une opération ; une skill peut configurer la manière dont certaines opérations doivent être pensées, contraintes et enchaînées.

### Workflow et SendMessage

`Workflow` exécute un flux de travail dynamique capable d’orchestrer plusieurs subagents en arrière-plan et de retourner un résultat consolidé. `SendMessage` envoie un message à un coéquipier dans une équipe d’agents ou reprend un subagent par son identifiant lorsque cette fonctionnalité est disponible.

Ces outils appartiennent à une couche d’orchestration plus avancée. Leur objet n’est pas seulement d’agir sur un fichier ou une commande, mais de coordonner plusieurs entités de travail, plusieurs états ou plusieurs trajectoires d’exécution.

### EnterPlanMode, ExitPlanMode, EnterWorktree et ExitWorktree

`EnterPlanMode` et `ExitPlanMode` encadrent le passage par un mode de planification. `EnterWorktree` et `ExitWorktree` encadrent l’entrée et la sortie d’un git worktree isolé. Ces outils ne sont pas des outils de lecture ou de modification directe ; ils modifient le cadre dans lequel les opérations suivantes pourront être menées.

Leur fonction est environnementale. Ils changent le régime de travail, l’espace de fichiers ou le statut de la session, plutôt que de produire immédiatement une modification de code.

## L’assemblage du pool d’outils

### La surface d’outils est construite, pas simplement listée

La surface d’outils disponible au modèle n’est pas une liste brute chargée sans contrôle. Elle est assemblée par le système. L’implémentation analysée dans le papier distingue plusieurs étapes : énumération des outils de base, filtrage selon le mode, vérification de disponibilité, préfiltrage par règles de refus, intégration des outils MCP, puis déduplication des noms.

Cette construction du pool d’outils est une décision architecturale importante. Elle signifie que le modèle ne choisit pas parmi tous les outils imaginables, mais parmi une surface explicitement exposée par le harness. Les outils interdits peuvent être retirés avant même que le modèle ne puisse tenter de les appeler.

### Les outils intégrés et les outils MCP

Les outils intégrés fournissent les capacités fondamentales : lecture, recherche, édition, shell, web, intelligence de code, orchestration et organisation de session. Les outils MCP ajoutent des capacités externes : bases de données, services internes, APIs, moteurs de recherche alternatifs, systèmes de ticketing ou outils métiers.

Lorsqu’un outil MCP est ajouté, il ne contourne pas le système. Il entre dans le pool d’outils, subit les règles de filtrage applicables et peut entrer en concurrence de nom avec un outil intégré. Dans l’architecture décrite par le papier, les outils intégrés prennent la priorité en cas de déduplication par nom.

### ToolSearch et les outils différés

`ToolSearch` sert à rechercher et charger des outils différés lorsque la recherche d’outils est activée. L’intérêt est de limiter le coût de contexte des schémas d’outils. Certains outils peuvent être connus par leur nom ou leur description minimale, tandis que leur schéma complet n’est chargé qu’au moment où il devient nécessaire.

Un outil consomme aussi du contexte. Sa définition, son nom, ses paramètres et son schéma occupent une partie de ce que le modèle reçoit. Différer les schémas d’outils permet de conserver une surface d’action large sans saturer immédiatement la fenêtre de contexte.

### WaitForMcpServers

`WaitForMcpServers` attend qu’un ou plusieurs serveurs MCP finissent de se connecter. Il intervient lorsque la session a besoin d’un outil exposé par un serveur encore en cours d’initialisation. Lorsque `ToolSearch` gère cette attente, `WaitForMcpServers` peut ne pas apparaître dans la même forme.

Cette distinction illustre un point général : certains outils ne sont pas orientés vers le projet lui-même, mais vers la disponibilité de la surface d’outils. Ils existent pour stabiliser l’infrastructure d’action avant que l’action métier puisse être appelée.

## Les permissions appliquées aux outils

### Les noms d’outils comme règles de contrôle

Les outils sont contrôlés par des règles qui utilisent leurs noms. Les mêmes noms peuvent apparaître dans les règles `allow` et `deny`, dans les options CLI, dans les options du Agent SDK, dans le frontmatter d’un subagent, dans le frontmatter d’une skill ou dans la condition d’un hook.

Le format général est de type `ToolName(specifier)`. Le spécificateur dépend de l’outil. `Bash` et `Monitor` utilisent des motifs de commande. `Read`, `Grep`, `Glob` et `LSP` utilisent des motifs de chemin. `Edit`, `Write` et `NotebookEdit` utilisent aussi des motifs de chemin. `Skill` utilise des noms de skills, `Agent` des types de subagents, et `WebFetch` des domaines.

La permission n’est donc pas seulement globale. Elle peut être attachée à une commande, à un chemin, à un domaine, à une skill ou à un type d’agent. Cette granularité permet de restreindre non seulement les outils disponibles, mais aussi les zones ou formes d’usage autorisées pour chaque outil.

### Outils sans permission et outils sensibles

Tous les outils n’exigent pas le même niveau de validation. Certains outils, principalement orientés lecture, organisation ou orchestration interne, peuvent ne pas demander de permission dans la configuration standard. D’autres outils, parce qu’ils modifient l’environnement, exécutent du code, accèdent au web ou déclenchent des opérations plus sensibles, exigent une permission.

Cette distinction ne signifie pas qu’un outil sans permission est sans conséquence. Elle signifie que son régime de risque est traité différemment. Lire un fichier, rechercher un motif, créer une tâche interne, lancer un subagent ou exécuter une commande shell ne présentent pas les mêmes effets possibles. La surface d’outils est donc aussi une surface de risque.

### Hooks et cycle de vie des outils

Les hooks ne sont pas eux-mêmes des outils ordinaires, mais ils interviennent dans le cycle de vie des outils. Ils peuvent agir avant une utilisation d’outil, après une utilisation, lors d’un échec, lors d’une demande de permission ou lors d’un refus. Ils permettent de bloquer, modifier, annoter ou enrichir certaines opérations.

Les hooks rendent la politique d’outil programmable. Ils permettent d’ajouter des contrôles transversaux sans modifier l’outil lui-même. Cela donne une architecture dans laquelle l’action reste localisée dans l’outil, tandis que certaines règles d’organisation, d’audit ou de sécurité peuvent être attachées au cycle d’exécution.

## Les limites des résultats d’outils

### Un résultat d’outil peut être incomplet

Un résultat d’outil n’est pas toujours une représentation exhaustive de l’environnement. `Read` peut retourner une vue partielle lorsqu’un fichier est trop volumineux. `Bash` peut fournir un aperçu et stocker la sortie complète dans un fichier de session. `WebFetch` peut transformer, tronquer et résumer une page. `Glob` peut atteindre une limite de résultats. `Grep` peut retourner seulement des chemins, des lignes ou des comptes selon son mode.

Il faut donc interpréter les sorties d’outils comme des vues opérationnelles, non comme une vérité totale. Une vue partielle peut suffire à décider de la suite, mais elle peut aussi nécessiter une lecture complémentaire, une recherche plus précise ou un appel d’outil différent.

### Les outils structurent l’attention du modèle

Chaque outil impose une forme particulière à l’information retournée. `Read` donne des lignes. `Grep` donne des correspondances. `LSP` donne une relation de code. `Bash` donne une sortie de processus. `WebSearch` donne des candidats. `WebFetch` donne une extraction. `Agent` donne un résultat synthétique. Cette forme oriente directement la manière dont le modèle peut raisonner ensuite.

La conception des outils est donc une conception de l’accès cognitif. Un même environnement peut devenir plus ou moins exploitable selon la manière dont les outils le découpent, le filtrent, le limitent et le présentent.
