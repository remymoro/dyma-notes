Nous allons maintenant connecter Claude Code à un navigateur réel. L’objectif est de vérifier le comportement du convertisseur comme le ferait un utilisateur : ouvrir la page, saisir une température, cliquer sur le bouton et observer le résultat.
Playwright MCP est un serveur local de type stdio. Claude Code lance le programme sur la machine, puis utilise les outils qu’il expose pour piloter le navigateur.

Comprendre ce que Playwright MCP apporte
Les tests unitaires vérifient les fonctions JS (`npm test`). Ils ne vérifient pas l'UI.
- `npm test` : Vérifier que 0 °C produit 32 °F dans le code.
- Playwright MCP : Vérifier que le bouton déclenche la conversion, le comportement d’une saisie vide, rechercher une erreur dans la console.
Playwright MCP utilise principalement une représentation structurée de l’interface fondée sur l’arbre d’accessibilité (pas juste des pixels).

Vérifier les prérequis
Nécessite Node.js 18+ (`node --version`) et un navigateur installé. Vérifier que le projet fonctionne avec `npm test`.

Installer Playwright MCP
`claude mcp add playwright \ -- npx -y @playwright/mcp@latest --isolated`
- `--` : Sépare les options de Claude Code de la commande du serveur.
- `npx -y` : Télécharge et exécute sans confirmation.
- `--isolated` : Utilise un profil temporaire qui n’est pas conservé (reproductible).

Vérifier la connexion
- `claude mcp list` -> `playwright : ✓ Connected`
- `claude mcp get playwright` ou `/mcp` dans une session.

Lancer le convertisseur
Terminal 1 : `npm run dev` (http://localhost:5173)
Terminal 2 : `claude`. Demander d'utiliser Playwright pour ouvrir l'URL, indiquer le titre, les champs, boutons...

Tester les scénarios du convertisseur
Demander à Claude de vérifier plusieurs scénarios (saisir 20, vider champ, saisir abc...) et présenter un tableau de résultats.
Claude sélectionne automatiquement les outils Playwright.
- `browser_navigate` : Ouvrir l'adresse.
- `browser_snapshot` : Lire la structure accessible de la page.
- `browser_type` : Saisir une valeur.
- `browser_click` : Cliquer sur un bouton.
- `browser_console_messages` : Consulter les logs console.
- `browser_close` : Fermer navigateur.
- `browser_take_screenshot` : Conserver une preuve visuelle (la capture complète ne remplace pas la structure pour le ciblage).

Corriger puis rejouer les scénarios
Observation des échecs (Playwright) -> Modifier fichiers (Outils intégrés) -> Vérifier (npm test) -> Rejouer (Playwright).
- Playwright MCP = capacité technique.
- `/verify` = workflow de vérification (organisation).

Diagnostiquer les problèmes courants
- Le serveur ne démarre pas : exécuter `npx -y @playwright/mcp@latest --isolated` directement dans le terminal pour voir les erreurs de dépendance.
- Application non accessible : vérifier `npm run dev` manuellement.
- Navigateur conserve ancien état : vérifier la présence de `--isolated`.
- Claude utilise un mauvais élément : lui demander de relire la structure de la page (nouveau snapshot) avant d'interagir.
