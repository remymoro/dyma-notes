Nous allons maintenant connecter un premier serveur MCP à Claude Code. L’objectif est de comprendre le cycle complet : ajouter un serveur, vérifier sa connexion, utiliser ses outils, diagnostiquer un problème puis le supprimer si nécessaire.
Pour cette première installation, nous utiliserons le serveur officiel de documentation Claude Code. Il est hébergé à distance, ne nécessite pas d’authentification et permet d’effectuer des recherches dans la documentation à jour.

Comprendre les deux principaux types de serveurs
- Serveur HTTP : Claude Code se connecte à une URL distante (ex: Documentation Claude Code, Notion ou Sentry). Transport recommandé pour les services distants.
- Serveur stdio : Claude Code démarre un programme local et communique avec son entrée et sa sortie standard (ex: Playwright MCP lancé avec npx). Convient aux outils locaux.
L'ancien transport SSE est déprécié.

Vérifier les serveurs existants
Dans le terminal (hors session) : `claude mcp list`
Si aucun serveur n'est installé, la liste sera vide.

Ajouter le serveur de documentation
`claude mcp add \ --transport http \ claude-code-docs \ https://code.claude.com/docs/mcp`
- `--transport http` : accessible à distance.
- `claude-code-docs` : nom local utilisé pour identifier le serveur.
Sans option, `claude mcp add` utilise la portée `local` (active uniquement dans le projet courant, non ajoutée au dépôt Git). 

Vérifier la connexion
Le message "Added" ne signifie pas connecté. Il faut utiliser : `claude mcp list`
Statuts :
- `✓ Connected` : Prêt à être utilisé.
- `! Needs authentication` : Nécessite une authentification.
- `✗ Failed to connect` / `✗ Connection error` : Erreur de connexion.
- `⏸ Pending approval` : Attend une approbation.

Afficher les détails du serveur
`claude mcp get claude-code-docs`
Vérifie le transport, l'URL, la portée, le statut, les erreurs. Utile si le serveur apparaît mais ne fonctionne pas.

Utiliser le serveur dans Claude Code
Démarrer session `claude`. Demander : "Utilise le serveur claude-code-docs pour rechercher...". Nommer le serveur n'est pas obligatoire mais garantit que la recherche passe par le serveur.

Autoriser le premier appel
Claude Code peut demander une autorisation. L'appel apparaît ensuite avec le nom claude-code-docs.

Inspecter le serveur depuis la session
Ouvrez le panneau : `/mcp`
Permet de repérer un serveur en erreur, relancer connexions, authentification OAuth, approuver un serveur, vérifier outils.
(La commande terminal `claude mcp list` gère les config, le panneau `/mcp` gère la session active).

Vérifier qu'aucun fichier du projet n'a changé
`git status --short` : Aucun fichier MCP car portée locale (contrairement à `.mcp.json` qui est partagé).

Supprimer le serveur
`claude mcp remove claude-code-docs`

Les erreurs à éviter
- Considérer "Added" comme une connexion. -> utiliser `claude mcp list`
- Installer pour tous les projets immédiatement. -> commencer par portée `local`
- Autoriser tous les outils dès le 1er appel. -> observer les outils nécessaires.
- Accumuler les serveurs inutilisés. -> supprimer les intégrations inutiles.

Cycle de gestion : Ajouter -> vérifier -> utiliser -> conserver ou supprimer.
