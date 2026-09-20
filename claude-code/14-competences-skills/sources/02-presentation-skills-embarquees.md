Claude Code 14. Les compétences (skills) 2. Présentation des skills embarqués - (/run, /run-skill-generator, /verify, /claude-api, /doctor...)

Présentation des skills embarquées
Claude Code fournit plusieurs skills prêtes à l’emploi. Elles couvrent des workflows courants comme le lancement d’une application, la vérification d’un changement, la revue de code, le diagnostic de l’environnement ou l’exécution de modifications à grande échelle.

Une skill embarquée n’est pas une simple commande dont le comportement est entièrement programmé dans le CLI. Elle fournit à Claude des instructions spécialisées, puis Claude utilise ses outils pour réaliser le workflow demandé.

Les skills embarquées s’utilisent comme les skills personnalisées, avec une commande commençant par /. Certaines peuvent également être déclenchées automatiquement par Claude lorsque leur description correspond à la tâche en cours.

Le projet utilisé
Le projet est notre convertisseur de température écrit en JavaScript. Il permet notamment de convertir des degrés Celsius en degrés Fahrenheit et contient des tests unitaires pour les fonctions de conversion et d’arrondi.

Deux commandes principales sont disponibles :
npm test
npm run dev

La première lance les tests. La seconde démarre l’application sur le port 5173.
http://localhost:5173

Le lancement est suffisamment simple pour être déduit à partir du fichier README.md et du fichier package.json.

Afficher les skills disponibles
La commande /skills affiche toutes les skills accessibles dans l’environnement courant :
/skills

La liste peut contenir :
les skills embarquées avec Claude Code ;
les skills personnelles placées dans ~/.claude/skills/ ;
les skills du projet placées dans .claude/skills/ ;
les skills fournies par des plugins.

Il est possible de filtrer la liste en saisissant quelques lettres. La disponibilité exacte dépend de la version de Claude Code, de la plateforme, du plan et de l’environnement utilisé. La liste affichée par /skills reste donc la source de vérité pour la session courante.

Lancer et vérifier l’application

/run
/run lance l’application et permet à Claude d’interagir avec le produit réel. L’objectif n’est pas seulement d’exécuter les tests, mais d’observer directement le comportement de l’application.

Sur le convertisseur, Claude peut identifier la commande suivante dans le projet :
npm run dev

Il peut ensuite ouvrir l’application et tester le formulaire. /run peut déduire la procédure de lancement depuis des fichiers comme README.md, package.json ou Makefile.

/verify
/verify construit et lance l’application, puis confirme qu’un changement fonctionne réellement. Cette skill ne doit pas se limiter aux tests unitaires, au typage ou au lint.

/verify Vérifie les comportements suivants :
- 20 doit produire 68 °F ;
- une saisie vide doit afficher un message d'erreur ;
- une saisie non numérique doit afficher un message d'erreur ;
- aucun résultat contenant NaN ne doit être affiché.

Dans ce projet, les tests couvrent les fonctions de conversion, mais pas le comportement du formulaire dans le navigateur.
Le champ accepte actuellement n’importe quelle valeur et le code utilise directement Number(). Une saisie invalide peut donc produire un résultat contenant NaN. /verify permet de détecter ce problème en utilisant l’application comme un utilisateur.

/run-skill-generator
/run-skill-generator est utile lorsque Claude ne peut pas déduire facilement comment lancer le projet.
Cette skill examine la procédure nécessaire pour installer, construire et lancer l’application depuis un environnement propre. Elle enregistre ensuite cette procédure dans une skill propre au projet.
Elle devient utile lorsque l’application nécessite plusieurs services, une base de données, des variables d’environnement, une compilation particulière ou plusieurs commandes de démarrage. Elle n’est pas nécessaire pour le convertisseur, car npm run dev suffit.

Diagnostiquer Claude Code

/doctor
/doctor vérifie l’installation et la configuration de Claude Code.
Cette skill peut notamment détecter :
plusieurs installations concurrentes ;
un problème dans le PATH ;
un fichier de configuration invalide ;
des skills, plugins ou serveurs MCP inutilisés ;
des hooks trop lents ;
une version plus récente de Claude Code.

/doctor concerne l’environnement de développement. Elle ne sert pas à diagnostiquer directement un bug dans le convertisseur.

/debug
/debug active les journaux de diagnostic de la session et aide à comprendre un problème lié au fonctionnement de Claude Code.
/debug Les commandes exécutées dans cette session échouent de manière inattendue.

La skill lit le journal de débogage de la session et recherche la cause du problème. Elle est utile pour diagnostiquer une erreur d’outil, de configuration ou d’exécution interne.
Pour un bug fonctionnel dans le convertisseur, il faut plutôt demander directement une analyse du code, puis utiliser /run et /verify.

/fewer-permission-prompts
/fewer-permission-prompts analyse les transcriptions précédentes pour identifier les commandes Bash et les appels MCP en lecture seule qui sont régulièrement autorisés.

La skill peut ensuite proposer une liste de permissions dans le fichier suivant :
.claude/settings.json

Cette proposition doit être relue avant d’être acceptée. Il faut éviter les règles trop larges et conserver une confirmation manuelle pour les actions sensibles ou irréversibles.
Sur le convertisseur, cette skill n’est pas prioritaire. Elle devient plus intéressante après de nombreuses sessions, lorsque les mêmes demandes de permissions reviennent régulièrement.

Automatiser une vérification répétée

/loop
/loop exécute un même prompt de manière répétée tant que la session reste ouverte.
/loop 5m Vérifie si le déploiement est terminé.

Cette skill peut servir à surveiller :
une intégration continue ;
un déploiement ;
un fichier de journal ;
une condition externe ;
une opération longue.

Elle n’a pas d’utilité immédiate sur le convertisseur, car son lancement et ses tests sont rapides. Elle ne doit pas non plus remplacer une suite de tests ou une gate de validation.

Travailler avec l’API Claude

/claude-api
/claude-api charge des informations de référence sur l’API Claude et les SDK Anthropic.
Elle couvre notamment :
l’envoi de messages ;
le streaming ;
l’utilisation d’outils ;
les traitements par lots ;
les sorties structurées ;
les principales erreurs d’intégration.

Elle peut également être activée automatiquement lorsqu’un projet importe un SDK comme anthropic ou @anthropic-ai/sdk.
Cette skill ne concerne pas le convertisseur, qui ne contient aucun appel à l’API Claude.

Créer des graphiques et des tableaux de bord

/dataviz
/dataviz fournit des recommandations pour concevoir des graphiques, des visualisations de données et des tableaux de bord.
/dataviz Crée un graphique montrant l'évolution des conversions réalisées chaque jour.

Claude choisit une représentation adaptée aux données et applique des règles concernant la lisibilité, les contrastes, l’accessibilité et l’utilisation des couleurs.
Le convertisseur actuel ne conserve aucune donnée et n’affiche aucun graphique. Cette skill deviendrait pertinente si le projet ajoutait un historique des conversions ou des statistiques d’utilisation. Sa disponibilité dépend notamment de la version de Claude Code.

Synchroniser un design system React

/design-sync
/design-sync analyse le design system React d’un dépôt et le synchronise avec les outils de conception Claude compatibles.
/design-sync Mon design system

Cette skill est destinée aux projets React qui possèdent une bibliothèque de composants suffisamment structurée. Elle peut vérifier les composants disponibles avant de les rendre accessibles aux workflows de conception.
Elle ne s’applique pas au convertisseur, qui utilise une page HTML et du JavaScript sans framework ni bibliothèque de composants. Sa disponibilité dépend également du fournisseur et de l’environnement utilisés.

Choisir la bonne skill

Besoin | Skill | Application au convertisseur
---|---|---
Vérifier l’installation de Claude Code | /doctor | Utile uniquement en cas de problème d’environnement.
Diagnostiquer une erreur interne à la session | /debug | Utile si les outils ou commandes de Claude échouent.
Lancer l’application | /run | Très utile pour démarrer le serveur local.
Tester le comportement réel | /verify | Très utile pour tester les saisies valides et invalides.
Enregistrer une procédure de lancement complexe | /run-skill-generator | Inutile ici, car npm run dev suffit.
Rechercher des bugs dans le diff | /code-review | Utile après la correction du formulaire.
Nettoyer un changement fonctionnel | /simplify | Utile après les tests et la vérification.
Réaliser une migration massive | /batch | Disproportionné pour un projet aussi petit.
Surveiller une condition répétitivement | /loop | Peu utile sur ce projet.
Réduire les demandes de permissions | /fewer-permission-prompts | À envisager après plusieurs sessions.
Développer avec l’API Claude | /claude-api | Hors sujet pour ce projet.
Créer des visualisations de données | /dataviz | Utile seulement après l’ajout de statistiques.
Synchroniser un design system React | /design-sync | Hors sujet pour cette application HTML.

Appliquer les principales skills au projet
On peut commencer par le lancement de l’application :
/run

Claude peut ensuite observer le problème avec les valeurs invalides :
/verify Vérifie le comportement du formulaire avec :
- la valeur 20 ;
- un champ vide ;
- la valeur abc.
Indique précisément le résultat observé pour chaque cas.

Une fois le problème confirmé, il est possible de demander sa correction :
Corrige la gestion des saisies invalides dans le convertisseur.
Contraintes :
- conserve le comportement des conversions valides ;
- affiche un message clair pour une saisie vide ;
- affiche un message clair pour une saisie non numérique ;
- ajoute les tests utiles ;
- limite les modifications au périmètre nécessaire.

Les tests sont ensuite exécutés :
npm test

Le comportement réel est vérifié une nouvelle fois :
/verify Vérifie que les trois scénarios précédents fonctionnent maintenant correctement.

Le diff peut enfin être relu et nettoyé (nous verrons ces skills dans la prochaine leçon) :
/code-review
/simplify

Le projet ne permet pas d’utiliser de manière pertinente toutes les skills embarquées. Il fournit néanmoins un support suffisant pour comprendre leur rôle et pour pratiquer les plus importantes dans un workflow de développement : /run, /verify, /code-review et /simplify.
