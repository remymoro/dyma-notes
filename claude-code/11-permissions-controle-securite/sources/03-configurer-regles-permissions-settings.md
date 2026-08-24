Cette partie est opérationnelle. Le modèle de contrôle et les modes d’autonomie sont en place. Il ne s’agit plus d’expliquer pourquoi une action est autorisée, demandée ou refusée, mais d’écrire des règles concrètes, de les placer au bon endroit et de diagnostiquer pourquoi elles s’appliquent ou non.
Une règle de permission est utile seulement si elle est précise, placée dans la bonne portée et vérifiable. Une règle trop large supprime trop de contrôle. Une règle trop étroite crée des demandes répétitives. Une règle placée dans le mauvais fichier ne s’applique pas aux bonnes personnes. Le travail consiste donc à transformer des décisions de sécurité en configuration lisible.

La commande centrale est /permissions. Elle affiche et gère les règles d’autorisation, de demande et de refus, ainsi que le fichier settings.json dont elles proviennent.

Le rôle de /permissions
Observer la politique active
Avant d’écrire une règle, il faut inspecter la politique active. /permissions permet de voir quelles règles sont déjà chargées et d’où elles viennent. C’est important parce qu’une même session peut combiner des paramètres utilisateur, des paramètres de projet, des paramètres locaux, des paramètres gérés et des décisions prises pendant la session.

Cette commande sert à répondre à des questions pratiques : pourquoi une commande est-elle demandée, pourquoi une lecture est-elle bloquée, pourquoi une règle projet ne semble-t-elle pas s’appliquer, et quelle portée fournit la règle active.

Modifier sans éditer le JSON à la main
/permissions est aussi utile pour ajouter ou retirer une règle en session interactive. C’est le bon point d’entrée quand vous découvrez un projet et que vous observez les mêmes validations revenir : commande de test, lint, typecheck, lecture d’issue, commande de diagnostic ou outil externe récurrent.
La méthode correcte est progressive. Commencez avec une posture prudente, observez les actions réellement utiles, puis stabilisez les règles dans le fichier approprié. Ne commencez pas par autoriser largement le shell ou tous les outils externes.

Où placer les règles
Portée utilisateur
~/.claude/settings.json contient les préférences personnelles qui doivent vous suivre dans tous les projets. On y place des règles liées à votre environnement personnel : protéger votre répertoire ~/.ssh, protéger ~/.aws, autoriser des commandes Git de lecture que vous utilisez partout, ou définir des préférences globales.
Cette portée ne doit pas contenir une règle qui appartient à un dépôt précis. Si toute l’équipe doit l’utiliser, elle appartient au projet.

Portée projet
.claude/settings.json contient les règles partagées par l’équipe dans le dépôt. C’est le bon endroit pour les commandes de validation du projet, les chemins documentaires éditables, les dossiers sensibles du dépôt et les usages acceptés d’outils externes.
Cette configuration facilite les vérifications et les modifications peu risquées, mais garde une validation humaine sur les commits et les zones de configuration. Les secrets et les actions de publication restent bloqués.

Portée locale projet
.claude/settings.local.json contient les exceptions propres à une machine ou à un développeur dans un dépôt précis. Ce fichier ne doit pas être versionné, et Claude Code l’ajoute automatiquement au .gitignore à sa création. Il sert aux chemins locaux, aux runners personnels, aux fixtures privées et aux essais de configuration.
Une règle locale ne doit pas devenir une convention implicite d’équipe. Si elle est nécessaire à tous, elle doit être déplacée dans .claude/settings.json.

Comment les portées se combinent
Les règles des différentes portées ne s’écrasent pas : les tableaux allow, ask et deny de toutes les portées applicables sont concaténés et dédupliqués.
Les paramètres gérés restent prioritaires et ne peuvent être levés par aucune autre portée. Un refus présent dans n’importe quelle portée bloque l’action, même si une autre portée l’autorise.

Structure d’un bloc permissions
Forme minimale
Les règles se placent sous permissions.allow, permissions.ask et permissions.deny.

Nom d’outil et spécificateur
Une règle prend la forme Tool ou Tool(specifier). Le nom seul cible l’outil entier. La forme avec parenthèses cible un usage particulier : commande Bash, chemin de fichier, domaine web, outil MCP, sous-agent ou paramètre d’appel. Utilisez les noms canoniques des outils, car un libellé affiché dans l’interface peut différer du nom réel attendu par les règles (par exemple, le libellé Stop Task correspond au nom canonique TaskStop).
Si une règle ne fonctionne pas, vérifiez d’abord le nom canonique de l’outil. Une règle écrite avec un libellé d’interface peut ne correspondre à rien et déclenche un avertissement au démarrage pour les règles de refus et de demande.

Écrire des règles Bash
Autoriser des commandes exactes
Une commande exacte est la forme la plus sûre. Elle convient aux commandes stables et fréquentes, par exemple le lint ou le typecheck.
Cette forme est préférable quand la commande ne doit pas recevoir d’arguments arbitraires.

Autoriser une famille bornée
Les règles Bash prennent en charge *, qui peut apparaître au début, au milieu ou à la fin et couvrir plusieurs arguments. L’espace avant * est significatif : Bash(ls *) correspond à ls -la, mais pas à lsof, tandis que Bash(ls*) correspond aux deux. Le suffixe :* est une écriture équivalente à un * final, donc Bash(ls:*) couvre les mêmes commandes que Bash(ls *).
Une wildcard doit être traitée comme une règle de sécurité. Bash(npm run test *) est plus précis que Bash(npm *). Bash(gh issue view *) est plus précis que Bash(gh *).

Commandes composées
Claude Code analyse les séparateurs shell dans les commandes composées (&&, ||, ;, | et autres). Une règle qui autorise une commande ne donne pas automatiquement le droit d’exécuter une autre sous-commande ajoutée après un opérateur shell. Chaque sous-commande doit être couverte séparément.

Refuser les commandes destructrices
Les commandes destructrices, les publications et les opérations d’infrastructure doivent être refusées ou demandées explicitement. La règle doit viser l’effet dangereux, pas seulement une formulation particulière.

Écrire des règles Read et Edit
Les ancres de chemin
Les règles Read et Edit suivent la spécification gitignore et distinguent quatre ancres : //path pour un chemin absolu depuis la racine du système de fichiers, ~/path pour un chemin depuis le répertoire utilisateur, /path pour un chemin relatif à la racine du projet, et path ou ./path pour un chemin relatif au répertoire courant.
La confusion la plus fréquente est de croire que /Users/alice/file désigne un chemin absolu. Dans les règles de fichiers, cette forme est relative à la racine du projet. Pour un chemin absolu, il faut utiliser //Users/alice/file.

Autoriser un périmètre documentaire
Cette règle autorise les modifications dans le dossier docs à la racine du projet. Elle ne signifie pas que tout le système de fichiers est éditable.

Bloquer les secrets
Protéger la lecture est nécessaire. Une fuite de secret ne suppose pas une modification de fichier : il suffit qu’un contenu sensible entre dans le contexte de la session.

Cas Windows
Sur Windows, les chemins sont normalisés en forme POSIX avant la correspondance. Par exemple, C:\Users\alice devient /c/Users/alice. Pour viser les fichiers .env sur le lecteur C, utilisez une forme comme Read(//c/**/.env). Pour viser tous les lecteurs, utilisez Read(//**/.env).

Limite des règles de fichiers
Les règles Read et Edit contrôlent les outils intégrés de fichiers et certaines commandes de fichiers reconnues dans Bash, comme cat, head, tail ou sed. Elles ne bloquent pas les sous-processus arbitraires capables de lire ou écrire des fichiers indirectement, par exemple un script Python ou Node qui ouvre lui-même un fichier. Pour imposer cette limite au niveau du système d’exploitation, il faut activer le sandbox.

Écrire des règles WebFetch
Autoriser des domaines précis
Les règles WebFetch utilisent la forme domain: et correspondent au nom d’hôte de l’URL demandée. La correspondance est insensible à la casse et prend en charge le caractère *.
WebFetch(domain:*.example.com) correspond aux sous-domaines à n’importe quelle profondeur, mais pas au domaine racine lui-même. Si vous voulez autoriser les deux, écrivez deux règles.

Ne pas oublier Bash
Contrôler WebFetch ne contrôle pas toute la connectivité réseau. Si Bash est autorisé, l’agent peut encore tenter d’utiliser des outils comme curl ou wget. Restreignez donc les outils réseau via Bash si vous voulez que l’accès web passe par WebFetch et ses règles de domaine.

Écrire des règles MCP
Nommer un serveur ou un outil
Les outils MCP utilisent des noms qualifiés. Une règle peut viser un serveur entier, tous les outils d’un serveur, ou un outil précis : mcp__puppeteer, mcp__puppeteer__* et mcp__puppeteer__puppeteer_navigate.
Cette forme permet d’autoriser les lectures utiles d’un service tout en demandant validation ou en bloquant les actions d’écriture.

Globs sur les outils MCP
Les règles de refus et de demande acceptent des globs dans la position du nom d’outil. mcp__* correspond à tous les outils MCP. Les règles d’autorisation sont plus restrictives : un glob d’autorisation n’est accepté qu’après un préfixe de serveur précis, par exemple mcp__github__get_*. Un glob d’autorisation trop large comme mcp__* est ignoré avec un avertissement.

Écrire des règles Agent
Contrôler les sous-agents utilisables
Les règles Agent(AgentName) permettent de contrôler quels sous-agents Claude peut utiliser, par exemple Agent(Explore), Agent(Plan) et Agent(my-custom-agent).
Autoriser un sous-agent n’est pas anodin. Un sous-agent peut lire beaucoup de fichiers, produire un rapport, lancer des tâches ou consommer un contexte séparé. Agent(...) se configure comme une surface d’outil, au même titre que les autres.

Contrôler certains paramètres d’appel
Les règles de demande et de refus peuvent viser certains paramètres de premier niveau, par exemple Agent(model:opus), Agent(isolation:worktree) ou Bash(run_in_background:true). Cette forme sert à exiger une validation ou à bloquer certains comportements spécifiques.
Cette syntaxe ne remplace pas les spécificateurs canoniques. Pour une commande Bash, utilisez Bash(rm *), pas une règle sur un champ interne comme command. Pour une URL, utilisez WebFetch(domain:host), pas un filtre sur le champ url. Ces champs canonicalisés ne sont pas filtrables par paramètre, et une règle qui essaie de le faire est ignorée avec un avertissement au démarrage.

Construire une allowlist projet réaliste
Point de départ recommandé
Une allowlist de projet doit commencer par les actions qui améliorent la vérification : tests, lint, typecheck, lecture d’issues, inspection de statut. Elle ne doit pas commencer par l’autorisation large du shell.
Cette politique a une structure claire : faciliter les vérifications, contrôler les zones sensibles, bloquer les secrets et empêcher les actions de publication ou d’infrastructure.

Rendre la règle auditée par l’équipe
Une règle projet partagée doit être lisible par un nouvel arrivant. Si la règle est large, elle doit être justifiée par un usage stable. Si elle est sensible, elle doit plutôt demander confirmation ou être refusée.

Diagnostiquer une règle qui ne fonctionne pas
Commandes utiles
/permissions montre les règles actives et leur fichier d’origine. /doctor diagnostique les problèmes d’installation et de configuration, et signale les entrées de paramètres invalides. /mcp permet de vérifier les serveurs et outils MCP réellement connectés avant d’écrire une règle qui les cible.

Causes fréquentes
Symptôme | Cause probable | Correction
---|---|---
La règle ne s’applique pas | Nom d’outil non canonique | Vérifier le nom réel dans la référence des outils ou dans /mcp.
Une action autorisée reste bloquée | Règle de refus plus large dans une autre portée | Inspecter les règles dans /permissions.
Une règle de chemin ne cible pas le bon fichier | Confusion entre /, //, ~/ et ./ | Revoir l’ancrage du chemin.
Un domaine web reste accessible autrement | Bash permet encore curl ou wget | Bloquer les commandes réseau shell ou utiliser le sandbox réseau.
Une règle MCP ne marche pas | Nom de serveur ou outil mal qualifié | Vérifier le nom complet avec /mcp.

Ce que ces règles ne gouvernent pas
Ces règles applicatives gouvernent une surface d’outils. Elles ne fixent pas la posture d’autonomie de la session, qui relève des modes. Elles n’encadrent pas le flux de planification. Et elles n’imposent pas de limites au niveau du système d’exploitation : l’isolation par sandbox, les conteneurs, les devcontainers et les données fictives forment une couche distincte, tout comme les drapeaux non interactifs, les hooks et les politiques gérées.

Erreurs fréquentes
Autoriser trop large
Bash(npm *), Bash(gh *) ou mcp__* en autorisation sont rarement de bons points de départ. Autorisez d’abord les commandes réellement sûres.

Placer une règle au mauvais niveau
Une règle d’équipe ne doit pas vivre dans settings.local.json. Une exception personnelle ne doit pas être versionnée dans .claude/settings.json.

Confondre chemin projet et chemin absolu
/src/** désigne un chemin relatif à la racine du projet. //src/** désignerait un chemin absolu depuis la racine du système de fichiers.

Oublier que le shell peut contourner une règle web
Limiter WebFetch ne suffit pas si Bash peut lancer des outils réseau. Les deux surfaces doivent être gouvernées ensemble.

Supposer qu’une règle Read bloque tout processus
Les règles de fichiers contrôlent les outils intégrés et certaines commandes reconnues. Les scripts arbitraires nécessitent une couche de sandbox pour être limités au niveau système.
