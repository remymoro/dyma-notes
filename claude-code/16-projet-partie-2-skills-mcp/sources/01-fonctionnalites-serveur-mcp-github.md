Objectifs du chapitre
Quatre briques dans cet ordre :
- Serveur MCP GitHub : La session lit les tickets et ouvre les pull requests sans quitter le terminal. (Preuve : /mcp affiche le serveur connecté)
- Le ticket porteur de specs : L'unité de travail devient un objet partagé, pas un simple message de chat. (Preuve : Le ticket existe avec les critères d'acceptation).
- Une skill projet : La recette d'ajout d'une règle est écrite une fois et réutilisée. (Preuve : La skill apparaît dans /skills).
- Deux nouvelles règles et une feature : Le produit gagne en couverture et sait analyser un dépôt distant.

Le parcours cible
Ticket (avec specs) -> lecture du ticket via MCP -> implémentation guidée par la skill -> validation locale -> pull request.

Brancher le serveur MCP GitHub
1. Créer un token dédié
Il faut un jeton à portée fine (Fine-grained token), limité au seul dépôt du projet (ex: claudoscope).
Settings -> Developer settings -> PAT -> Fine-grained tokens
Expiration courte (ex: 30 jours).
Permissions :
- Metadata : Read-only (obligatoire)
- Contents : Read (Lire les fichiers)
- Issues : Read and write (Créer ticket et relire specs)
- Pull requests : Read and write (Ouvrir la PR à la fin)

2. Déclarer le serveur dans le dépôt
La déclaration appartient au projet (versionnée dans `.mcp.json`). Elle ne contient aucun secret mais référence la variable `${GITHUB_PAT}` dans le header `Authorization`. L'expansion `${VAR}` est prise en charge. La forme `${VAR:-defaut}` permet un repli. Mieux vaut une configuration rejetée qu'un échec silencieux.

3. Isoler le secret
Le secret vit dans une configuration locale non versionnée, ex: `.claude/settings.local.json`.
```json
{
  "env": {
    "GITHUB_PAT": "jeton_en_clair"
  }
}
```
Ce fichier contient le jeton en clair (pas d'expansion ici). Il doit être ignoré par Git avant le 1er commit, et ne jamais être montré à l'écran. 
Une variante plus sûre est d'exporter `GITHUB_PAT` depuis le shell.

4. Vérifier la connexion
Le `.mcp.json` sur le disque ne prouve rien. La preuve est dans la session via `/mcp`. 
Vérification sans effet de bord : "Ne modifie rien. Vérifie que le serveur GitHub est connecté. Indique le compte associé..."

5. Cadrer les outils du serveur
Un serveur MCP ajoute une surface d'action. Les outils de lecture peuvent être préautorisés, l'écriture doit demander confirmation.
Dans `.claude/settings.json`, configurer les permissions :
```json
{
  "permissions": {
    "ask": [
      "mcp__github"
    ]
  }
}
```
Attention : Les règles visent le nom complet de l'outil, et les jokers (*) ne sont pas pris en charge pour les entrées MCP (selon le cours, bien que vu différemment ailleurs). Mieux vaut un cadrage large `ask` au début, pour éviter une création de ticket/branche non voulue.
