Claude Code sait déjà lire les fichiers du projet, modifier le code et exécuter des commandes dans le terminal. En revanche, il ne connaît pas automatiquement le contenu d’une issue GitHub, les erreurs enregistrées dans Sentry ou l’état d’une application dans un navigateur.
Le Model Context Protocol, ou MCP, est un standard ouvert qui permet de connecter une application d’intelligence artificielle à des outils et à des sources de données externes. Dans Claude Code, un serveur MCP peut donner accès à une API, une base de données, un navigateur, un dépôt distant ou un service métier.

Le problème résolu par MCP
Sans MCP, les informations externes doivent souvent être copiées manuellement dans la conversation.
Avec un serveur MCP connecté à GitHub, Claude peut consulter directement l’issue depuis Claude Code.
MCP devient pertinent lorsqu’une tâche oblige régulièrement à récupérer des informations depuis un autre outil ou à y effectuer une action. Claude Code peut alors travailler à partir des données réelles plutôt que d’une copie fournie manuellement.

Comprendre l’architecture MCP
Une intégration MCP repose sur trois éléments principaux :
- Client MCP : Utiliser les capacités proposées par les serveurs (ex: Claude Code).
- Serveur MCP : Exposer des capacités dans un format standardisé (ex: Playwright MCP ou GitHub MCP).
- Service ou système externe : Fournir les données ou exécuter réellement les actions (ex: Un navigateur, GitHub ou une base PostgreSQL).

Claude Code n’accède pas directement à l’ensemble du service. Le serveur MCP choisit précisément les capacités qu’il expose. Un serveur GitHub peut, par exemple, proposer un outil pour lire une issue et un autre pour créer une issue, sans donner un accès général et illimité au compte GitHub. Les serveurs MCP sont des programmes qui exposent des capacités à travers des interfaces standardisées. Un même client peut ainsi utiliser plusieurs serveurs sans nécessiter une intégration entièrement différente pour chaque service.

Les trois capacités principales
Un serveur MCP peut exposer trois types de capacités : des tools, des resources et des prompts.
- Tool : Exécuter une opération (ex: Ouvrir une page, lire une issue). Déclenché par Claude selon la demande.
- Resource : Fournir une donnée en lecture comme contexte (ex: doc, contenu d'issue). Déclenché par l'application ou l'utilisateur.
- Prompt : Fournir un modèle de demande réutilisable. Déclenché par l'utilisateur explicitement.

Les tools :
Un tool est une fonction que Claude peut appeler. Chaque outil possède un nom, une description, des paramètres et un résultat structuré. Claude peut les sélectionner lorsqu’ils sont pertinents. Leur exécution peut nécessiter une autorisation.

Les resources :
Représente une information que Claude peut utiliser comme contexte. Identifiée par une URI. Dans Claude Code, elles peuvent apparaître dans l'autocomplétion ouverte avec @. Elles servent principalement à lire des données.

Les prompts :
Modèles de prompts exposés sous forme de commandes slash (/mcp__nom-du-serveur__nom-du-prompt).

Ce qui nécessite MCP dans le convertisseur
Tout ne doit pas devenir une intégration MCP. 
- Lire / Modifier / npm test : Outils et terminal intégrés
- Analyser dette technique : Skill projet
- Manipuler navigateur : Playwright MCP
- Consulter GitHub distant : GitHub MCP

Distinguer outils, skills et MCP
- Outil intégré : Opération locale (Lire fichier)
- Skill : Workflow (Suivre une procédure)
- MCP : Système/outil externe (GitHub, navigateur)
La skill définit la procédure. Le serveur MCP fournit les moyens techniques de l'exécuter.

Vérifier les serveurs MCP déjà configurés
- Dans le terminal : `claude mcp list`
- Dans Claude Code : `/mcp`
Si aucun n'apparaît, aucune intégration n'est configurée.

Les permissions restent nécessaires
Connecter un serveur ne signifie pas accès total sans contrôle. MCP peut modifier un service externe. Claude Code peut demander confirmation. Toujours connecter des serveurs de confiance avec un périmètre d'accès limité.
