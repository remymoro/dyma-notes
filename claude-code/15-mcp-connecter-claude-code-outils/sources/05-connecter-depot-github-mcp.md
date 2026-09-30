Nous allons connecter Claude Code au dépôt GitHub du convertisseur. L'objectif est de consulter le code distant, l'historique des commits et les issues sans devoir copier manuellement ces informations. Nous utiliserons le serveur officiel GitHub MCP en mode distant, restreint en lecture seule.

Comprendre ce que GitHub MCP apporte
Claude Code utilise déjà Git en local (`git diff`, `git status`). GitHub MCP apporte les informations hébergées par GitHub : consulter les issues, lire les infos du dépôt distant, analyser les pull requests.

Commencer en lecture seule
Le serveur GitHub expose des outils pour créer/modifier des issues et PRs. Ces capacités ne sont pas nécessaires. On applique le principe du moindre privilège :
- Toolsets autorisés : repos, issues.
- Mode : lecture seule.
L'en-tête `X-MCP-Toolsets` sélectionne les groupes d'outils. L'en-tête `X-MCP-Readonly` retire les outils d'écriture.

Créer un token GitHub limité
Utiliser un token d'accès personnel (PAT) à permissions fines :
- Accès aux dépôts : Uniquement le dépôt concerné
- Permissions : Contents (Lecture seule), Issues (Lecture seule)
Copiez le token, il ne doit jamais être versionné.

Placer le token dans l'environnement
Ne pas l'écrire dans la config MCP. Utiliser une variable d'environnement :
`export GITHUB_PAT="votre_token"`

Créer la configuration GitHub MCP
Créer un fichier `.mcp.json` à la racine :
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PAT}",
        "X-MCP-Toolsets": "repos,issues",
        "X-MCP-Readonly": "true"
      }
    }
  }
}
```
Claude remplace `${GITHUB_PAT}` par l'environnement.

Vérifier que le token n'est pas versionné
`cat .mcp.json` doit afficher `Bearer ${GITHUB_PAT}`. Le fichier `.mcp.json` peut être partagé avec le projet, le secret reste dans l'environnement.

Approuver le serveur du projet
Démarrer `claude`. Comme le serveur provient de `.mcp.json`, Claude demande une approbation (évite qu'un dépôt cloné transmette des données en douce). Ouvrir `/mcp`, sélectionner github et approuver.

Vérifier la connexion
- `claude mcp list` -> `github : ✓ Connected`
- `claude mcp get github`

Analyser le dépôt et comparer avec le local
Claude peut lire les infos du dépôt distant via GitHub MCP, et la branche locale via Git. MCP ne remplace pas Git, il le complète.

Préparer une issue sans la créer
Demander à Claude de préparer le contenu de l'issue, mais préciser "Ne crée pas l'issue". Claude consulte le dépôt pour éviter les doublons.
Vérifier la restriction : demander à Claude pourquoi il ne peut pas créer l'issue. Il doit identifier que l'outil d'écriture n'est pas exposé. C'est plus sûr qu'un simple prompt "ne crée rien".

Limiter davantage les outils
On peut utiliser `X-MCP-Tools: get_file_contents,issue_read` pour lister précisément les outils, mais cela demande de connaître les noms exacts. Les `Toolsets` sont plus lisibles.

Diagnostiquer les problèmes courants
- Var env absente : `test -n "$GITHUB_PAT"...`
- Erreur d'auth : token incorrect, expiré, révoqué, ou défini après avoir lancé Claude.
- Dépôt inaccessible : le token n'a pas accès au dépôt.
- Issues non dispos : manque "Issues -> lecture" dans le token, ou "issues" dans X-MCP-Toolsets. (Le token détermine ce que GitHub autorise. Le toolset détermine ce que le serveur expose).
- Serveur reste en attente : Ouvrez `/mcp` et approuvez le serveur défini dans `.mcp.json`.
