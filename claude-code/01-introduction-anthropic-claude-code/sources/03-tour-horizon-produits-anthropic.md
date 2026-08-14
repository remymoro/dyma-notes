# Tour d'horizon des produits Anthropic

*Claude : fondations → 1. Introduction à Anthropic et Claude → 3. Tour d'horizon des produits Anthropic*

## Cartographier les produits actuels d'Anthropic

Avant de plonger dans le détail des produits Anthropic, il faut comprendre une distinction simple : tout ce que propose Anthropic n'est pas un produit.

On peut facilement se perdre, parce que les noms se ressemblent. Claude, Claude Code, Claude Cowork, Claude Design, Claude Security, Claude for Chrome, Claude for Microsoft 365, Claude for Slack, Claude in Xcode, Skills, Connectors, Plugins, Opus, Sonnet, Haiku, API et MCP ne sont pas des objets de même nature.

Certains sont des produits. D'autres sont des intégrations d'interface. D'autres sont des modèles. D'autres encore sont des modules que l'on installe depuis un répertoire, comme les Compétences, les Connecteurs et les Plugins.

Cette leçon sert donc de carte. L'objectif est de comprendre les grandes familles de l'écosystème Anthropic, avant d'étudier chaque outil en détail dans les leçons suivantes.

## Quatre repères pour situer l'écosystème

L'écosystème Anthropic peut être lu avec quatre repères simples.

- Un cœur unique : Claude, l'intelligence artificielle développée par Anthropic.
- Cinq produits principaux : Claude, Claude Code, Claude Cowork, Claude Design et Claude Security.
- Un répertoire en trois familles : Compétences, Connecteurs et Plugins.
- Plusieurs familles de modèles : Opus, Sonnet et Haiku, avec certains modèles en aperçu limité selon les surfaces et les accès.

Le point important est le suivant : un produit, une intégration, une compétence, un connecteur, un plugin et un modèle ne répondent pas à la même question.

- Un produit répond à la question : où est-ce que je travaille ?
- Une intégration d'interface répond à la question : dans quelle interface externe est-ce que j'utilise Claude ?
- Une compétence répond à la question : quelle méthode de travail spécialisée est-ce que j'active ?
- Un connecteur répond à la question : à quelles données, applications ou services Claude peut-il se connecter ?
- Un plugin répond à la question : quel pack de travail est-ce que j'installe pour un métier, une équipe ou un workflow ?
- Un modèle répond à la question : quel moteur d'intelligence artificielle fait le travail ?

## La distinction fondamentale

Pour comprendre l'écosystème Anthropic, il faut distinguer sept catégories : les produits, les intégrations d'interface, les compétences, les connecteurs, les plugins, les modèles et la plateforme développeur.

### Un produit

Un produit est une surface principale dans laquelle l'utilisateur travaille. Autrement dit, un produit répond à la question : où est-ce que je travaille ?

Par exemple, Claude est le produit de conversation généraliste. Claude Code est le produit pour les développeurs. Claude Cowork est le produit pour déléguer des tâches longues. Claude Design est le produit orienté création visuelle. Claude Security est le produit destiné aux équipes de cybersécurité.

Un produit peut avoir son propre usage, son public cible, son interface, son cycle de vie et ses contraintes d'utilisation.

### Une intégration d'interface

Une intégration d'interface amène Claude dans un environnement tiers. Un environnement tiers est un outil qui n'appartient pas directement à l'interface principale de Claude, mais dans lequel l'utilisateur travaille déjà.

Par exemple, Claude for Microsoft 365 amène Claude dans Excel, PowerPoint, Word et Outlook. Claude for Chrome amène Claude dans le navigateur. Claude in Xcode amène Claude dans l'environnement de développement Apple.

Claude for Slack existe aussi, mais il doit être présenté avec plus de nuance. Slack peut être une interface pour parler à Claude, une source de contexte via un connecteur, un point d'entrée vers Claude Code, ou une brique utilisée par un plugin.

Une intégration d'interface concerne donc l'endroit où l'utilisateur interagit avec Claude.

### Un connecteur

Un connecteur est différent d'une intégration d'interface. Un connecteur ne désigne pas seulement l'endroit où l'utilisateur travaille. Il désigne la connexion entre Claude et une application, un service, un espace documentaire ou une base de données.

Par exemple, un connecteur vers Google Drive peut permettre à Claude de rechercher des fichiers. Un connecteur vers Gmail peut aider à rechercher des emails, résumer des fils de discussion ou préparer des brouillons. Un connecteur vers Google Calendar peut aider à comprendre un agenda.

La différence est donc simple :
- Une intégration répond à la question : dans quelle interface est-ce que j'utilise Claude ?
- Un connecteur répond à la question : à quelles données ou applications Claude est-il relié ?

### Une compétence ou Skill

Une Skill est une compétence préparée à l'avance pour aider Claude à mieux accomplir une tâche. En français, on peut traduire Skill par compétence.

Une Skill peut contenir des instructions, des exemples, des ressources, des procédures, des modèles de sortie et parfois des scripts.

> Un script est un petit programme qui automatise une action. Par exemple, un script peut nettoyer un tableau, convertir un fichier ou générer un document dans un format précis.

L'intérêt d'une Skill est la réutilisation. Au lieu de réexpliquer les mêmes consignes à chaque conversation, on prépare une compétence qui peut être réutilisée.

### Un plugin

Un Plugin est un pack installable qui étend ce que Claude peut faire dans un contexte donné.

Un Plugin peut regrouper plusieurs éléments : des Skills, des Connectors, des commandes, des sous-agents et des instructions spécialisées.

Dans le répertoire, on trouve par exemple des plugins orientés Productivity, Design, Marketing, Engineering, Data, Finance, Product management, Operations, Sales ou Legal.

Un Plugin est donc plus large qu'une simple compétence. Il sert souvent à équiper Claude pour un métier, une équipe ou un type de workflow.

> Un workflow est une suite d'étapes organisées pour accomplir une tâche. Par exemple : analyser une demande, chercher des informations, produire un brouillon, vérifier les points sensibles, puis livrer une version finale.

### Un modèle

Un modèle est le moteur d'intelligence artificielle qui produit les réponses.

Les principales familles de modèles publiques sont Opus, Sonnet et Haiku.

- Opus désigne la famille orientée vers la puissance maximale.
- Sonnet désigne la famille orientée vers l'équilibre entre intelligence, vitesse et coût.
- Haiku désigne la famille orientée vers la rapidité et l'efficacité économique.

Un modèle n'est pas un produit. Le même modèle peut alimenter plusieurs produits ou surfaces, par exemple Claude, Claude Code, Claude Cowork ou l'API.

### Une plateforme développeur

Une plateforme développeur est un environnement technique destiné aux développeurs et aux entreprises qui veulent intégrer Claude dans leurs propres outils.

Dans l'écosystème Anthropic, cette plateforme s'appelle Claude Platform.

Elle comprend notamment l'API, la Console, les SDK, les outils de gestion des fichiers, les traitements en lots, les outils d'agent et les capacités d'intégration.

> API signifie Application Programming Interface. En français, on peut traduire cela par interface de programmation. Une API permet à un logiciel d'utiliser les capacités d'un autre logiciel.
>
> SDK signifie Software Development Kit. En français, on peut traduire cela par kit de développement logiciel. C'est un ensemble d'outils qui aide les développeurs à utiliser une technologie.

## Les cinq produits principaux

*[Schéma : grille des 5 produits — Claude (produit généraliste : discuter, rédiger, analyser, synthétiser), Claude Code (développement logiciel : coder, corriger, tester, refactorer), Claude Cowork (travail agentique : déléguer une tâche longue ou complexe), Claude Design (création visuelle : maquettes, prototypes, présentations visuelles), Claude Security (cybersécurité : scanner du code, détecter des failles)]*

Les produits principaux sont les surfaces où l'utilisateur travaille directement.

Les cinq produits principaux à connaître sont Claude, Claude Code, Claude Cowork, Claude Design et Claude Security.

### Claude

Claude est le produit généraliste.

C'est l'assistant que l'on utilise sur le web, sur ordinateur ou sur mobile pour discuter, rédiger, analyser, synthétiser, raisonner, coder, travailler avec des fichiers ou organiser une réflexion.

C'est la surface la plus simple pour un débutant. On peut l'utiliser pour écrire un email, résumer un document, préparer une structure, reformuler un texte, analyser une note, expliquer une notion ou travailler sur un fichier.

Dans cette formation, Claude est le point d'entrée naturel. C'est là que l'on apprend les bases : formuler une demande, donner du contexte, vérifier une réponse, travailler avec des fichiers et comprendre les limites du modèle.

### Claude Code

Claude Code est le produit destiné au développement logiciel. Il permet de travailler directement dans une base de code.

> Une base de code est l'ensemble des fichiers qui composent une application ou un projet informatique.

Claude Code peut lire des fichiers, proposer des modifications, corriger des bugs, lancer des commandes, exécuter des tests et contribuer à des workflows de développement.

> Un bug est une erreur dans un logiciel. Un test est une vérification automatique ou manuelle qui permet de contrôler qu'un logiciel fonctionne comme prévu.

Claude Code peut être utilisé dans plusieurs environnements, notamment le terminal, les IDE, l'application desktop, le web, Xcode et certains workflows connectés.

> IDE signifie Integrated Development Environment. En français, on peut traduire cela par environnement de développement intégré. C'est un logiciel utilisé par les développeurs pour écrire, lire, tester et organiser du code. VS Code, JetBrains et Xcode sont des exemples d'environnements de développement.

Pour un débutant, il faut retenir que Claude Code n'est pas seulement un outil qui complète une ligne de code. C'est un système agentique capable de comprendre un projet plus large et d'agir sur plusieurs fichiers.

### Claude Cowork

Claude Cowork est le produit agentique destiné au travail de connaissance.

> Un produit agentique est un produit où l'intelligence artificielle ne se contente pas de répondre à une question. Elle peut poursuivre un objectif, consulter des fichiers, utiliser des outils, organiser plusieurs étapes et produire un livrable. Un livrable est un résultat concret que l'on peut utiliser : une note, un tableau, une synthèse, une structure, une présentation, un document ou un fichier.

Claude Cowork s'adresse surtout aux personnes qui travaillent avec des documents, des tableaux, des fichiers locaux, des notes, des contrats, des rapports ou des supports de présentation.

Exemples d'usage : trier un dossier de fichiers, synthétiser plusieurs documents, préparer une note de synthèse, extraire des informations d'un ensemble de fichiers, construire une présentation ou produire un rapport.

La différence avec Claude est importante. Dans Claude, l'utilisateur reste souvent dans une conversation. Dans Claude Cowork, l'utilisateur délègue davantage une tâche complète.

### Claude Design

Claude Design est le produit orienté création visuelle. Il sert à créer des livrables visuels comme des designs, des prototypes, des présentations, des pages synthétiques et des supports visuels.

> Un design est une proposition visuelle. Il peut s'agir de l'apparence d'une page, d'une interface, d'une présentation ou d'un support de communication. Un prototype est une première version d'un produit, d'un écran ou d'un support. Il permet de tester une idée avant de la finaliser.

Claude Design est utile lorsque le résultat attendu n'est pas seulement un texte, mais une forme visuelle : maquette, support de présentation, page de synthèse, visuel de communication ou exploration d'interface.

Pour un débutant, la différence avec Claude est simple. Claude sert surtout à discuter, analyser et rédiger. Claude Design sert davantage à transformer une idée en livrable visuel.

### Claude Security

Claude Security est le produit destiné aux équipes de cybersécurité. Il sert à scanner une base de code, détecter des vulnérabilités, valider les résultats et proposer des correctifs.

> Une vulnérabilité est une faiblesse dans un logiciel. Elle peut permettre une fuite de données, une prise de contrôle, un contournement d'authentification, une injection de code ou une interruption de service. Un correctif est une modification destinée à résoudre un problème dans un logiciel.

Claude Security s'adresse surtout aux organisations qui ont beaucoup de code à sécuriser. Ce n'est pas le premier produit à utiliser pour un débutant qui veut simplement parler à Claude ou rédiger un document.

## Les intégrations d'interface

Les intégrations d'interface amènent Claude dans des environnements tiers. Elles sont importantes parce qu'un utilisateur ne travaille pas seulement dans une interface de chat. Il travaille aussi dans un navigateur, une suite bureautique, un environnement de développement ou une messagerie d'équipe.

### Claude for Chrome

Claude for Chrome, aussi appelé Claude in Chrome, est une extension navigateur.

> Une extension navigateur est un petit module que l'on ajoute à un navigateur, ici Chrome, pour lui donner de nouvelles capacités.

Claude for Chrome permet à Claude de travailler dans le contexte d'un onglet web. Il peut lire une page, comprendre ce qui s'affiche, cliquer, naviguer et aider sur des tâches liées au navigateur.

Cette intégration doit être utilisée avec prudence. Lorsqu'une intelligence artificielle peut interagir avec un site web, il faut superviser ses actions, surtout si le site contient des données personnelles, des informations professionnelles, des paiements, des formulaires ou des actions irréversibles.

> Une action irréversible est une action que l'on ne peut pas facilement annuler, par exemple envoyer un formulaire, supprimer un fichier ou valider une commande.

### Claude for Microsoft 365

*[Capture d'écran : panneau "Faites plus avec Claude, partout où vous travaillez" — installation Claude dans Excel, PowerPoint, Word (Nouveau), avec exemple d'analyse de portefeuille dans Excel via recherche de contexte multi-sources]*

Claude for Microsoft 365 permet d'utiliser Claude dans Excel, PowerPoint, Word et Outlook.

- Excel sert principalement à travailler avec des tableaux et des données.
- PowerPoint sert à créer des présentations.
- Word sert à rédiger et structurer des documents.
- Outlook sert à gérer des emails et des calendriers.

L'intérêt est simple : au lieu de copier-coller entre Claude et les fichiers bureautiques, l'assistant travaille directement dans les applications où se trouve le travail.

Par exemple, un utilisateur peut analyser une pièce jointe dans Word, construire une analyse dans Excel, transformer le résultat en présentation dans PowerPoint et préparer une réponse dans Outlook.

### Claude for Slack

Claude for Slack permet d'utiliser Claude dans Slack.

> Slack est un outil de messagerie professionnelle utilisé par des équipes pour communiquer dans des canaux, des conversations directes et des fils de discussion.

Il ne faut toutefois pas le présenter comme une simple intégration isolée. Slack est plutôt un cas hybride dans l'écosystème Anthropic. Il existe plusieurs usages distincts autour de Slack :

- Claude for Slack permet de parler à Claude dans Slack.
- Un connecteur Slack peut permettre à Claude d'utiliser du contexte provenant de Slack.
- Claude Code peut s'intégrer à certains workflows liés à Slack.
- Un plugin peut aussi utiliser Slack comme source de contexte ou comme environnement de travail.

Ces usages sont proches, mais ils ne donnent pas le même accès aux données et ne répondent pas au même besoin.

### Claude in Xcode

Claude in Xcode est une intégration destinée aux développeurs qui travaillent dans l'écosystème Apple.

> Xcode est l'environnement de développement d'Apple, notamment utilisé pour créer des applications iOS, macOS, watchOS et tvOS.

Claude in Xcode ne doit pas être confondu avec Claude Code dans son ensemble. Claude Code est le produit agentique de développement. Xcode est l'un des environnements dans lesquels ce travail peut s'intégrer.

## Le répertoire : Compétences, Connecteurs et Plugins

*[Schéma : 3 blocs — Skill/Compétence (« Quelle méthode de travail ? », ex : créer une présentation type), Connector/Connecteur (« À quels outils accéder ? », ex : lire Google Drive ou Gmail), Plugin/Pack métier (« Quel workflow installer ? », ex : pack Finance complet pour métier)]*

Le répertoire est une partie importante de l'écosystème. Il regroupe des briques que l'on peut ajouter à certaines surfaces pour étendre ce que Claude sait faire ou ce à quoi il peut accéder.

Dans le répertoire, il faut distinguer trois familles : Compétences, Connecteurs et Plugins.

### Compétences

*[Capture d'écran : répertoire "Anthropic & Partenaires" listant les plugins/skills par catégorie — Productivity (1.8M), Design (1.8M), Marketing (1.6M), Engineering (1.6M), Data (1.6M), Finance (1.5M), Product management (1.5M), Operations (1.4M), Sales (1.4M), Legal (1.4M)]*

Les Compétences correspondent aux Skills. Une Skill donne à Claude une méthode de travail plus spécialisée.

Exemples : produire une présentation, traiter un tableur, générer un rapport, appliquer une grille d'analyse, respecter une charte de style ou suivre une procédure interne.

Une Skill peut être fournie par Anthropic, créée par une organisation ou installée dans certains environnements techniques.

Pour un débutant, il faut retenir ceci : une Skill ne donne pas forcément accès à un nouvel outil externe. Elle donne surtout une meilleure manière de faire une tâche.

### Connecteurs

*[Capture d'écran : panneau "Répertoire" avec onglets Compétences/Connecteurs/Plugins — liste de connecteurs disponibles : Ironclad Contracts, NetDocuments, Google Drive (le plus populaire), Gmail (#2), Canva (#4), Figma (#5), Microsoft 365 (#8), Google Calendar (#3), Atlassian Rovo (#7), Notion (#6)]*

Les Connecteurs permettent à Claude de travailler avec des applications, fichiers, bases de données ou services externes. Ils sont souvent liés à MCP.

> MCP signifie Model Context Protocol. En français, on peut traduire cela par protocole de contexte pour modèle. Un protocole est un ensemble de règles qui permet à plusieurs systèmes de communiquer correctement. Le rôle de MCP est de fournir un cadre standardisé pour connecter un modèle à des outils, données et services.

Exemples de connecteurs visibles dans le répertoire : Google Drive, Gmail, Google Calendar, Microsoft 365, Notion, Canva, Figma, Ironclad Contracts, NetDocuments et Atlassian Rovo.

Le bon réflexe est de toujours regarder les permissions avant d'activer un connecteur. Un connecteur peut donner accès à des informations personnelles, contractuelles, commerciales ou confidentielles.

### Plugins

Les Plugins sont des modules installables plus larges. Un Plugin peut regrouper plusieurs Skills, plusieurs Connectors, des commandes et des sous-agents.

> Un sous-agent est un agent spécialisé chargé d'une partie du travail. Par exemple, un agent principal peut déléguer une analyse de données à un sous-agent orienté Data, puis utiliser son résultat pour produire une synthèse finale.

Les Plugins sont souvent organisés par fonction métier. Exemples : Productivity, Design, Marketing, Engineering, Data, Finance, Product management, Operations, Sales et Legal.

Pour un débutant, il faut retenir ceci : un Plugin est un pack de travail. Il ne sert pas seulement à faire une action isolée. Il prépare Claude à travailler dans un domaine, un métier ou un workflow.

### Différence entre Skill, Connector et Plugin

| Objet | Question principale | Exemple simple |
|---|---|---|
| Skill | Quelle méthode de travail Claude doit-il appliquer ? | Créer une présentation selon une structure précise. |
| Connector | À quel outil ou à quelles données Claude peut-il accéder ? | Lire des fichiers dans Google Drive ou des messages dans Gmail. |
| Plugin | Quel pack métier ou workflow complet est installé ? | Installer un pack Finance pour aider sur des rapprochements, des états financiers et des analyses d'écarts. |

Une Skill structure une compétence. Un Connector relie Claude à un système externe. Un Plugin combine souvent plusieurs briques pour un usage plus large.

## Les surfaces développeur

Les surfaces développeur ne s'adressent pas d'abord aux utilisateurs non techniques. Elles servent à intégrer Claude dans des produits, applications, agents ou systèmes internes.

### Claude Platform

Claude Platform est la plateforme technique pour les développeurs. Elle permet d'intégrer Claude dans des produits, des outils internes, des agents ou des systèmes automatisés.

Elle inclut notamment l'API, la Console, les SDK, les fichiers, les traitements en lots, les outils, l'exécution de code et les agents.

> Console désigne ici l'interface de gestion technique utilisée pour configurer, tester ou administrer l'usage de l'API. Un traitement en lots signifie que l'on envoie beaucoup de requêtes à traiter ensemble, plutôt que de les traiter une par une en temps réel.

### Claude Platform on AWS

Claude Platform on AWS est une manière d'utiliser Claude Platform dans l'écosystème AWS.

> AWS signifie Amazon Web Services. C'est la plateforme cloud d'Amazon. Le cloud désigne des serveurs, bases de données, outils de calcul et services informatiques accessibles à distance.

Claude Platform on AWS permet aux entreprises qui utilisent déjà AWS d'accéder à certaines capacités de Claude Platform avec des mécanismes familiers : authentification, permissions, facturation et audit.

> IAM signifie Identity and Access Management. C'est le système qui permet de gérer les identités et les permissions dans AWS. CloudTrail est un service AWS qui enregistre les actions réalisées dans un compte. Il sert à l'audit, à la sécurité et à la traçabilité.

### Claude Managed Agents

Claude Managed Agents est une brique de Claude Platform pour créer, exécuter et superviser des agents.

> Un agent est un système qui peut poursuivre un objectif en plusieurs étapes. Il peut utiliser des outils, consulter des données, prendre des décisions intermédiaires et produire un résultat. Un agent managé est un agent dont une partie de l'infrastructure est prise en charge par la plateforme.

Cette approche évite à l'entreprise de tout construire elle-même. Claude Managed Agents n'est pas une interface de chat pour débutants. C'est une brique destinée aux développeurs et aux organisations qui veulent créer des agents dans leurs propres systèmes.

### Le connecteur MCP côté API

MCP existe aussi côté développeur. Dans ce contexte, le connecteur MCP permet à l'API de se connecter à des serveurs MCP distants.

> Un serveur MCP est un service qui expose des outils ou des ressources à un modèle selon le protocole MCP.

Pour un débutant, il faut retenir ceci : les connecteurs visibles dans l'interface et les connecteurs utilisés par les développeurs reposent sur la même idée générale. Ils servent à relier le modèle à des sources ou outils externes.

## Les solutions verticales

Les solutions verticales sont des offres orientées vers un métier, un secteur ou un type d'organisation.

Une solution verticale n'est pas toujours un produit autonome. Elle combine souvent plusieurs briques : produits, modèles, connecteurs, plugins, compétences, API, agents et règles de sécurité.

### Exemples de solutions verticales

- Legal pour les usages juridiques.
- Security pour les usages de cybersécurité.
- Financial services pour les services financiers.
- Government pour les administrations et organisations publiques.
- Healthcare pour la santé.
- Life sciences pour les sciences de la vie.
- Education pour l'éducation.
- Customer support pour le support client.
- Nonprofits pour les organisations à but non lucratif.
- Small business pour les petites entreprises.

Ces solutions ne doivent pas être confondues avec les cinq produits principaux. Par exemple, une solution juridique peut combiner Claude Cowork, des connecteurs vers des outils documentaires, des plugins juridiques et des compétences adaptées aux professionnels du droit.

### Pourquoi les solutions verticales existent

Un cabinet juridique, une banque, une équipe de support client et une équipe de recherche scientifique n'utilisent pas l'intelligence artificielle de la même manière.

- Les documents ne sont pas les mêmes.
- Les risques ne sont pas les mêmes.
- Les règles de validation ne sont pas les mêmes.
- Les formats de livrables ne sont pas les mêmes.

Les solutions verticales servent à adapter l'écosystème Anthropic à ces contextes professionnels spécifiques.

## Les statuts à connaître

Toutes les surfaces de l'écosystème Anthropic ne sont pas au même niveau de maturité. Il faut savoir distinguer GA, Public beta et Research preview.

### GA

GA signifie Generally Available. En français, on peut traduire cela par disponibilité générale.

Une capacité en GA est considérée comme disponible pour les utilisateurs concernés et suffisamment stable pour des usages courants. Cela ne veut pas dire qu'elle ne changera jamais. Cela veut dire qu'elle n'est plus présentée comme une simple expérimentation.

### Public beta

Public beta signifie beta publique. Une beta publique est accessible publiquement, mais elle est encore en évolution.

Elle peut être utile, mais il faut s'attendre à des changements de comportement, de limites, d'interface ou de disponibilité. Pour un usage critique, il faut être prudent avec une beta publique.

### Research preview

Research preview signifie aperçu de recherche. C'est un statut plus expérimental qu'une beta publique.

Une capacité en Research preview peut être limitée à certains utilisateurs, certaines régions ou certaines activations. Elle peut aussi changer rapidement.

Pour un débutant, le réflexe est simple : si une capacité est en Research preview, il faut la tester, la superviser et éviter de dépendre d'elle pour un processus critique sans contrôle humain.

## La carte mentale complète

*[Schéma : pyramide à 6 niveaux — 1. Le cœur (Claude, alimenté par Opus/Sonnet/Haiku), 2. Les produits principaux (Claude, Claude Code, Claude Cowork, Claude Design, Claude Security), 3. Les intégrations d'interface (Chrome, Microsoft 365, Xcode, Slack — cas hybride), 4. Le répertoire (Compétences, Connecteurs, Plugins), 5. La plateforme développeur (Claude Platform, Claude Platform on AWS), 6. Les solutions verticales (Legal, Security, Finance, Healthcare, Education, etc.)]*

L'écosystème Anthropic peut être lu en six niveaux.

### Niveau 1 : le cœur

Au centre, il y a Claude, l'intelligence artificielle développée par Anthropic. Claude est alimenté par des modèles : Opus, Sonnet, Haiku et, selon les accès, certains modèles en aperçu.

### Niveau 2 : les produits principaux

Les produits principaux sont les surfaces où l'utilisateur travaille directement.

- Claude sert au travail généraliste.
- Claude Code sert au développement logiciel.
- Claude Cowork sert au travail agentique des personnes qui manipulent des documents, des fichiers et des livrables.
- Claude Design sert à produire des livrables visuels.
- Claude Security sert à la cybersécurité et à la détection de vulnérabilités.

### Niveau 3 : les intégrations d'interface

Les intégrations d'interface amènent Claude dans des outils tiers.

- Claude for Chrome amène Claude dans le navigateur.
- Claude for Microsoft 365 amène Claude dans Excel, PowerPoint, Word et Outlook.
- Claude in Xcode amène Claude dans un environnement de développement Apple.
- Claude for Slack amène Claude dans Slack, mais Slack doit aussi être compris comme une source de contexte et comme un point d'entrée possible vers d'autres usages.

### Niveau 4 : le répertoire

Le répertoire regroupe les briques que l'on peut ajouter ou activer.

- Les Compétences donnent des méthodes de travail spécialisées.
- Les Connecteurs relient Claude à des services et données externes.
- Les Plugins regroupent des capacités par métier, fonction ou workflow.

### Niveau 5 : la plateforme développeur

Claude Platform permet d'intégrer Claude dans des produits, outils internes, workflows ou agents programmatiques.

Elle comprend l'API, la Console, les SDK, les fichiers, les traitements en lots, les outils, l'exécution de code et les agents.

Claude Platform on AWS permet d'utiliser cette plateforme dans l'écosystème AWS.

### Niveau 6 : les solutions verticales

Les solutions verticales adaptent l'écosystème à un secteur ou un métier. Exemples : Legal, Security, Financial services, Government, Healthcare, Life sciences, Education, Customer support, Nonprofits et Small business.

Elles combinent souvent plusieurs briques existantes plutôt que de créer un produit entièrement séparé.

## Quel outil utiliser selon le besoin ?

Cette cartographie devient utile lorsqu'il faut choisir le bon outil.

**Pour discuter, rédiger ou analyser** — Pour discuter, analyser un fichier, rédiger un email, synthétiser un texte ou réfléchir à une stratégie, il faut utiliser Claude.

**Pour développer du logiciel** — Pour corriger du code, comprendre une base de code, écrire des tests, refactorer ou préparer une pull request, il faut utiliser Claude Code.

> Une pull request est une proposition de modification dans un dépôt de code. Elle permet à une équipe de relire, discuter et valider un changement avant de l'intégrer au projet principal.

**Pour déléguer une tâche longue** — Pour déléguer une tâche longue sur plusieurs fichiers, produire un livrable, organiser un dossier ou synthétiser un corpus documentaire, il faut utiliser Claude Cowork.

> Un corpus documentaire est un ensemble de documents que l'on analyse ensemble.

**Pour produire un livrable visuel** — Pour créer un livrable visuel, une maquette, une présentation, une page de synthèse ou un prototype, il faut utiliser Claude Design.

**Pour sécuriser du code** — Pour détecter et corriger des vulnérabilités dans une base de code d'entreprise, il faut utiliser Claude Security.

**Pour travailler dans un outil tiers** — Pour travailler dans un navigateur, il faut utiliser Claude for Chrome. Pour rester dans Excel, PowerPoint, Word ou Outlook, il faut utiliser Claude for Microsoft 365. Pour travailler dans Xcode, il faut regarder Claude in Xcode ou les surfaces liées à Claude Code. Pour travailler avec Slack, il faut distinguer le besoin : parler à Claude dans Slack, utiliser Slack comme source de contexte, ou connecter Slack à un workflow plus large.

**Pour ajouter des capacités** — Pour spécialiser Claude sur une procédure répétable, il faut utiliser les Skills. Pour connecter Claude à des outils ou données externes, il faut utiliser les Connectors. Pour installer un pack métier ou un workflow complet, il faut utiliser les Plugins. Pour construire un produit ou un agent avec Claude, il faut utiliser Claude Platform. Pour déployer dans l'écosystème AWS, il faut utiliser Claude Platform on AWS.

## Pourquoi cette distinction compte

Cette distinction n'est pas seulement une question de vocabulaire. Elle a des conséquences pratiques pour choisir le bon outil, organiser les permissions, former une équipe et gouverner les usages.

### Elle évite de choisir le mauvais outil

- Un utilisateur qui veut écrire un email n'a pas besoin de Claude Code.
- Un développeur qui veut corriger une base de code entière ne doit pas se limiter à Claude.
- Une personne qui veut produire une maquette visuelle ou une présentation structurée peut avoir intérêt à utiliser Claude Design.
- Une équipe qui travaille dans Excel, PowerPoint, Word et Outlook peut avoir intérêt à utiliser Claude for Microsoft 365.
- Une équipe sécurité qui doit scanner du code à grande échelle doit regarder Claude Security, pas seulement Claude Code.

### Elle clarifie la gouvernance

> La gouvernance désigne l'ensemble des règles permettant de contrôler l'usage d'un outil dans une organisation. Cela inclut les accès, les données, les permissions, les audits, la sécurité, la conformité, les coûts et les responsabilités.

Dans une entreprise, utiliser Claude, Claude Code, Claude Cowork, Claude Design, Claude for Microsoft 365, un Connector, un Plugin ou l'API ne pose pas les mêmes questions.

Exemples : qui peut installer une Skill ? Qui peut connecter un outil externe ? Qui peut installer un Plugin ? Qui peut faire agir Claude dans un navigateur ? Qui peut utiliser un connecteur en lecture et écriture ? Qui valide une action avant envoi ? Qui peut voir les journaux d'activité ?

### Elle clarifie les risques

Chaque catégorie a ses risques propres.

- Un produit agentique comme Claude Cowork demande une supervision des tâches longues.
- Une intégration comme Claude for Chrome demande une vigilance sur les actions web.
- Un Connector demande une attention particulière aux permissions et aux données accessibles.
- Un Plugin demande de vérifier ce qu'il installe, ce qu'il connecte et ce qu'il peut faire.
- Une API demande une gouvernance technique : clés d'accès, journaux, quotas, coûts, sécurité et supervision.

## Points à retenir

- Anthropic ne propose pas un seul outil, mais un écosystème de produits, intégrations, compétences, connecteurs, plugins, modèles, plateformes et solutions verticales.
- Les cinq produits principaux sont Claude, Claude Code, Claude Cowork, Claude Design et Claude Security.
- Les intégrations d'interface amènent Claude dans des environnements tiers, comme Chrome, Microsoft 365, Slack ou Xcode.
- Slack doit être compris comme un cas hybride : interface de conversation, source de contexte, connecteur possible, plugin possible et point d'entrée vers d'autres usages.
- Le répertoire regroupe trois familles importantes : Compétences, Connecteurs et Plugins.
- Une Skill est une compétence réutilisable qui aide Claude à mieux accomplir une tâche.
- Un Connector relie Claude à une application, un service, une base de données ou un espace documentaire.
- Un Plugin est un pack installable qui peut regrouper des Skills, des Connectors, des commandes et des sous-agents pour un workflow ou un métier.
- Les modèles, comme Opus, Sonnet et Haiku, ne sont pas des produits. Ce sont les moteurs qui alimentent les produits.
- Claude Platform est la surface développeur. Elle sert à intégrer Claude dans des produits, workflows ou agents programmatiques.
- Claude Platform on AWS permet d'utiliser Claude Platform dans l'écosystème AWS.
- Les solutions verticales ne sont pas toujours des produits séparés. Elles combinent plusieurs briques existantes pour répondre à un secteur ou un métier.
- Le bon réflexe consiste à poser six questions : où est-ce que je travaille, dans quelle interface externe, avec quel moteur, avec quelles compétences, avec quelles connexions, et avec quelles permissions ?
