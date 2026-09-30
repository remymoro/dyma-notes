L’écosystème MCP contient de nombreux serveurs. Il ne faut cependant pas chercher à tous les installer ni choisir uniquement les plus populaires. Un serveur MCP est utile lorsqu’il supprime une friction réelle : copier une issue dans Claude Code, ouvrir manuellement une documentation, parcourir des erreurs de production ou manipuler une application dans un navigateur.

Dépôts de code et suivi du travail
Les serveurs MCP liés au développement permettent de connecter Claude Code à un dépôt distant, à ses issues, à ses pull requests ou à un outil de gestion de projet.
- GitHub MCP : Consulter les dépôts, commits, issues, pull requests et workflows.
- Linear MCP : Rechercher, créer et mettre à jour des issues, projets et commentaires.
Le serveur officiel GitHub permet de sélectionner des groupes d’outils précis (repos, issues, etc.) et propose un mode lecture seule pour éviter de modifier le dépôt.

Navigateurs et vérification d’interfaces
Les MCP de navigateur (ex: Playwright MCP) permettent à Claude d’ouvrir une application, d’inspecter son contenu et d’interagir avec son interface. Playwright MCP expose des outils d’automatisation du navigateur, adapté aux apps web, aux tests exploratoires et au diagnostic (il complète les tests unitaires).

Documentation et connaissances d’équipe
Certains serveurs donnent accès à la documentation (ex: Notion MCP). Un serveur Notion peut rechercher du contenu, lire, modifier des pages. Accès très large, doit correspondre à un besoin.

Supervision et diagnostic de production
Les serveurs d’observabilité (ex: Sentry) donnent accès aux erreurs, traces, événements d'une app déployée. Sentry aide Claude à rechercher des erreurs. 

Bases de données et services backend
Permet d'interroger des données réelles (ex: Supabase, Postgres). L'accès doit commencer en lecture seule sur un environnement de développement non sensible.

Design et interfaces
Les MCP de design (ex: Figma) transmettent des informations structurées provenant d'une maquette (composants, espacements) pour les comparer avec l'interface développée.

Services métier et paiements
Connectent à des services métier (Stripe, CRM). Conséquences financières ou opérationnelles importantes, nécessitent beaucoup de restrictions.

Cloud et infrastructure
Interroger ou administrer des ressources cloud (AWS, Azure, Cloudflare). Ne deviennent utiles que si le projet utilise réellement la plateforme.

Choisir un MCP avec des critères simples
Avant d’ajouter un serveur, posez les questions suivantes :
- Besoin réel : Quelle opération répétitive ce MCP supprime-t-il ?
- Valeur ajoutée : Cette capacité existe-t-elle déjà dans Claude Code ?
- Source : Le serveur est-il officiel, maintenu ?
- Données accessibles : À quels documents/comptes aura-t-il accès ?
- Lecture ou écriture : Peut-il modifier les données ?
- Authentification : Utilise-t-il OAuth, clé restreinte ?
- Nombre d’outils : Peut-on ne charger que les capacités nécessaires ?
- Conséquences : Une mauvaise action serait-elle réversible ?

Éviter les MCP inutiles
Mauvaise logique : "Un serveur existe, je l'installe."
Meilleure logique : "Je copie régulièrement des issues. GitHub MCP supprime cette étape. Je commence en lecture seule."
Il faut toujours :
-> serveur de confiance
-> accès minimal
-> lecture seule si possible
-> validation sur une tâche bornée

Les MCP retenus pour le convertisseur
Seulement trois intégrations seront conservées pour le projet du cours :
1. Documentation Claude Code (rechercher infos commandes/config)
2. Playwright MCP (ouvrir convertisseur, vérifier le navigateur)
3. GitHub MCP (consulter le dépôt, historique, issues)
