Claude Code 13. Projet partie 1 : démarage d'u… 6. Cadrer les permissions et la surface d’action - (socle)

Le projet Claudoscope possède maintenant un design doc, un socle technique, un fichier CLAUDE.md et une règle ciblée dans .claude/rules/. Ces fichiers donnent à Claude Code le contexte nécessaire pour comprendre le produit, ses commandes et ses frontières d’architecture.

Ces instructions ne définissent toutefois pas les actions que l’agent peut exécuter sans confirmation. Une consigne dans CLAUDE.md oriente le comportement du modèle, mais elle ne bloque pas une commande, une lecture de fichier ou une opération Git.

Cette session doit donc créer une politique de permissions adaptée au projet. L’objectif est de permettre à Claude Code d’exécuter les commandes habituelles sans demander une confirmation systématique, tout en conservant un contrôle strict sur les dépendances, le réseau, les secrets et les opérations Git risquées.

La politique doit fonctionner aussi bien avec le mode de permissions par défaut qu’avec le mode auto.

Commencer par faire explorer le projet
Fournir le contexte de la session
La demande commence par rappeler l’état du projet et le livrable attendu.

Nous sommes au début de la mise en place d'un projet.
Nous avons déjà :
- réalisé un design doc ;
- mis en place le socle technique et son architecture ;
- positionné les informations destinées aux agents de code dans CLAUDE.md ;
- ajouté des instructions ciblées dans .claude/rules/.
Fais d'abord un tour d'horizon du projet.
Le but de cette session sera ensuite de mettre en place des permissions adaptées
à un travail sécurisé, tout en permettant d'exécuter les commandes nécessaires
sans demander une confirmation systématique lorsque nous utiliserons le mode
par défaut ou le mode auto.

Cette demande ne fournit pas directement une liste de permissions. Claude Code doit d’abord comprendre les outils, les scripts et le workflow réel du dépôt.

Une autorisation utile dans un projet peut être inutile ou dangereuse dans un autre. Il faut donc partir des commandes effectivement présentes dans package.json, de la stack et des opérations nécessaires aux prochaines tranches.

Déléguer l’exploration à un agent
Claude Code commence par lancer un agent d’exploration chargé de parcourir Claudoscope.

Je vais d'abord faire le tour du projet avec un agent d'exploration,
puis nous planifierons la configuration des permissions.

L’agent peut consulter notamment :
design-doc.md
CLAUDE.md
.claude/rules/
package.json
pnpm-workspace.yaml
packages/core/
packages/cli/
configurations TypeScript, Vitest et ESLint

Cette exploration permet d’identifier les commandes qui doivent être fluides :
installation du workspace ;
scripts pnpm ;
typecheck ;
tests ;
build ;
lint ;
exécution du CLI ;
inspection Git en lecture seule.

Trancher les choix de politique
Répondre aux questions structurantes
Après l’exploration, Claude Code ne crée pas immédiatement le fichier. Il demande de trancher trois choix qui modifient directement la politique.

Question | Décision retenue | Conséquence
---|---|---
Où placer les permissions ? | Dans le projet, avec un fichier commité. | La politique est enregistrée dans .claude/settings.json et partagée avec les autres contributeurs.
Jusqu’où autoriser Git sans confirmation ? | Lecture seule. | Les commandes d’inspection sont autorisées, tandis que les opérations qui modifient ou publient l’état restent contrôlées.
Comment traiter la gestion des dépendances ? | Sur demande. | L’installation normale du workspace est permise, mais les ajouts, suppressions, mises à jour et publications exigent une confirmation.

Utiliser une configuration de projet partagée
Les paramètres communs à l’équipe sont placés dans .claude/settings.json. Le fichier .claude/settings.local.json reste réservé aux préférences ou adaptations propres à une machine et n’est pas destiné à être partagé.

claudoscope/
.claude/
settings.json
rules/
claudoscope-core.md
CLAUDE.md

Le choix d’un fichier commité permet à tous les contributeurs de partir de la même politique de travail.

Combiner permissions et sandbox
Deux couches différentes
Le fichier active la sandbox et ajoute des permissions explicites.

{
"$schema": "https://json.schemastore.org/claude-code-settings.json",
"sandbox": {
"enabled": true
},
"permissions": {
"allow": [],
"ask": [],
"deny": []
}
}

Ces deux couches ne jouent pas le même rôle :

Couche | Rôle
---|---
Permissions | Décider si un outil ou une commande peut être utilisé, doit demander une confirmation ou doit être bloqué.
Sandbox | Limiter au niveau du système les ressources accessibles par les commandes shell qui s’exécutent dans la sandbox.

Les permissions sont évaluées avant l’exécution. La sandbox limite ensuite ce que le processus peut effectivement atteindre.

Tenir compte de l’environnement Windows
Le projet utilise des règles pour Bash et pour PowerShell. Cette symétrie permet de couvrir un environnement Windows utilisant soit Git Bash, soit l’outil PowerShell.

L’option sandbox.enabled demande l’activation de la sandbox lorsqu’elle est disponible. Sur Windows natif, cette isolation n’est pas prise en charge de la même manière que sous Linux, macOS ou WSL 2. Dans ce cas, les règles de permissions restent la principale couche de contrôle.

Comprendre allow, ask et deny
L’ordre d’évaluation
Les trois groupes ne possèdent pas la même priorité. Les règles sont évaluées dans cet ordre :
deny
↓
ask
↓
allow

Une règle deny correspondante bloque donc la commande, même si une règle ask ou allow correspond également.
De la même manière, une règle ask prend le dessus sur une autorisation. Les règles PowerShell utilisent la même syntaxe que les règles Bash.

Cette priorité permet notamment de demander une confirmation pour un git push normal, tout en interdisant complètement un git push --force.

Rôle de chaque groupe

Groupe | Usage dans le projet
---|---
allow | Commandes répétitives, attendues et nécessaires au développement ou à l’inspection du dépôt.
ask | Actions utiles, mais susceptibles de modifier les dépendances ou de produire un effet externe.
deny | Actions destructrices, accès aux secrets et commandes de transfert réseau hors workflow.

Autoriser les commandes de travail courantes
Commandes pnpm
Le groupe allow commence par les commandes nécessaires au socle et à ses validations.

"allow": [
"Bash(pnpm install)",
"Bash(pnpm run *)",
"Bash(pnpm test)",
"Bash(pnpm test *)",
"Bash(pnpm build)",
"Bash(pnpm typecheck)",
"Bash(pnpm lint)",
"Bash(pnpm -r build)",
"Bash(pnpm -r typecheck)",
"Bash(pnpm exec vitest *)",
"Bash(pnpm exec tsc *)",
"Bash(pnpm exec eslint *)",
"Bash(pnpm ls *)",
"Bash(pnpm why *)",
"Bash(pnpm --version)"
]

Ces autorisations couvrent plusieurs usages :

Commande | Rôle
---|---
pnpm install | Installer le workspace à partir des manifestes et du fichier de verrouillage existants.
pnpm run * | Exécuter les scripts déclarés par le projet.
pnpm test et pnpm exec vitest * | Lancer les tests complets ou ciblés.
pnpm typecheck et pnpm exec tsc * | Vérifier les types.
pnpm lint et pnpm exec eslint * | Exécuter les contrôles statiques.
pnpm ls * et pnpm why * | Inspecter les dépendances sans les modifier.

La règle pnpm run * est plus large que l’autorisation de scripts nommés individuellement. Elle fluidifie tous scripts du dépôt, mais elle suppose que les scripts présents dans les manifestes sont eux-mêmes relus et dignes de confiance.

En mode auto, les règles shell précises peuvent être appliquées avant le classifieur. Pour imposer l’évaluation de toutes les commandes shell par le classifieur, il est possible d’activer autoMode.classifyAllShell, au prix d’une validation plus lente.

Runtime et exécution du CLI
La politique autorise également la vérification de la version de Node.js et l’exécution du CLI construit.

"Bash(node --version)",
"Bash(node packages/cli/dist/index.js *)"

La seconde règle permet d’exécuter la future commande scan, son aide et ses options sans ajouter une permission à chaque variation d’arguments.

Inspection Git en lecture seule
La décision prise pendant l’interview est d’autoriser uniquement la lecture de l’état du dépôt.

"Bash(git status)",
"Bash(git status *)",
"Bash(git diff)",
"Bash(git diff *)",
"Bash(git log)",
"Bash(git log *)",
"Bash(git show *)",
"Bash(git branch)",
"Bash(git branch --list *)",
"Bash(git blame *)",
"Bash(git remote -v)",
"Bash(git rev-parse *)",
"Bash(git ls-files)",
"Bash(git ls-files *)",
"Bash(git stash list)"

Ces commandes permettent à Claude Code de comprendre le travail en cours, d’inspecter les changements, de lire l’historique et d’identifier la structure du dépôt.
Elles ne modifient pas la branche, l’index, les commits ou le remote.

Couvrir PowerShell
Les mêmes familles de commandes sont ajoutées pour l’outil PowerShell.

"PowerShell(pnpm install)",
"PowerShell(pnpm run *)",
"PowerShell(pnpm test)",
"PowerShell(pnpm test *)",
"PowerShell(pnpm build)",
"PowerShell(pnpm typecheck)",
"PowerShell(pnpm lint)",
"PowerShell(pnpm -r build)",
"PowerShell(pnpm -r typecheck)",
"PowerShell(pnpm exec vitest *)",
"PowerShell(pnpm exec tsc *)",
"PowerShell(pnpm exec eslint *)",
"PowerShell(pnpm ls *)",
"PowerShell(pnpm why *)",
"PowerShell(pnpm --version)",
"PowerShell(node --version)",
"PowerShell(node packages/cli/dist/index.js *)",
"PowerShell(git status)",
"PowerShell(git status *)",
"PowerShell(git diff)",
"PowerShell(git diff *)",
"PowerShell(git log)",
"PowerShell(git log *)",
"PowerShell(git show *)",
"PowerShell(git branch)",
"PowerShell(git branch --list *)",
"PowerShell(git blame *)",
"PowerShell(git remote -v)",
"PowerShell(git rev-parse *)",
"PowerShell(git ls-files)",
"PowerShell(git ls-files *)",
"PowerShell(git stash list)"

Cette duplication est volontaire. Une autorisation Bash ne s’applique pas automatiquement à l’outil PowerShell.

Demander confirmation pour les actions significatives
Gestion des dépendances
Les commandes qui modifient les manifestes, le fichier de verrouillage ou le contenu exécuté par le projet sont placées dans ask.

"ask": [
"Bash(pnpm add *)",
"Bash(pnpm remove *)",
"Bash(pnpm update *)",
"Bash(pnpm dlx *)",
"Bash(pnpm publish *)",
"PowerShell(pnpm add *)",
"PowerShell(pnpm remove *)",
"PowerShell(pnpm update *)",
"PowerShell(pnpm dlx *)",
"PowerShell(pnpm publish *)"
]

Commande | Pourquoi demander
---|---
pnpm add | Ajoute une dépendance et modifie les fichiers du projet.
pnpm remove | Retire une dépendance et peut casser le build.
pnpm update | Modifie les versions résolues et peut introduire des régressions.
pnpm dlx | Télécharge et exécute temporairement un package.
pnpm publish | Produit un effet externe sur le registre.

La gestion des dépendances reste donc possible, mais elle exige une validation humaine.

Publication Git
Un git push normal n’est pas totalement interdit. Il est placé dans ask.

"Bash(git push *)",
"PowerShell(git push *)"

Cette règle permet de publier une branche après confirmation, sans accorder une autorisation permanente au projet.

Les autres écritures Git qui ne correspondent à aucune règle allow suivent le comportement du mode actif. Elles ne sont donc pas implicitement autorisées par la liste de lecture seule.

Bloquer les actions dangereuses ou hors périmètre
Commandes de transfert réseau
La politique refuse les principales commandes permettant de télécharger ou d’envoyer directement des données depuis un shell.

"deny": [
"Bash(curl)",
"Bash(curl *)",
"Bash(curl.exe *)",
"Bash(wget)",
"Bash(wget *)",
"Bash(wget.exe *)",
"Bash(Invoke-WebRequest *)",
"Bash(Invoke-RestMethod *)",
"Bash(iwr *)",
"Bash(irm *)",
"Bash(Start-BitsTransfer *)",
"PowerShell(curl)",
"PowerShell(curl *)",
"PowerShell(curl.exe *)",
"PowerShell(wget)",
"PowerShell(wget *)",
"PowerShell(wget.exe *)",
"PowerShell(Invoke-WebRequest *)",
"PowerShell(Invoke-RestMethod *)",
"PowerShell(iwr *)",
"PowerShell(irm *)",
"PowerShell(Start-BitsTransfer *)"
]

Le refus couvre les noms complets, les alias courants et les variantes exécutables. Il empêche qu’une commande de transfert soit simplement reformulée entre Bash et PowerShell.

Suppressions par le shell
La configuration refuse également la commande rm dans les deux outils.

"Bash(rm *)",
"PowerShell(rm *)"

Les modifications normales de fichiers peuvent toujours passer par les outils d’édition de Claude Code, qui restent soumis au mode de permissions actif. La suppression shell générique n’est pas nécessaire au workflow courant.

Lecture des fichiers d’environnement
Les fichiers .env sont exclus des lectures autorisées.

"Read(.env)",
"Read(.env.*)",
"Read(**/.env)",
"Read(**/.env.*)"

Ces motifs couvrent le fichier racine, ses variantes comme .env.local et les fichiers similaires présents dans les sous-dossiers.

Opérations Git destructrices
Les variantes forcées du push et la réinitialisation destructive sont interdites.

"Bash(git push --force *)",
"Bash(git push -f *)",
"Bash(git reset --hard *)",
"PowerShell(git push --force *)",
"PowerShell(git push -f *)",
"PowerShell(git reset --hard *)"

Un git push ordinaire correspond à la règle ask. Un git push --force correspond aussi à cette règle générale, mais la règle deny est évaluée en premier et bloque donc l’action.

Structure finale du fichier
Vue synthétique
Le fichier créé suit cette organisation :

{
"$schema": "https://json.schemastore.org/claude-code-settings.json",
"sandbox": {
"enabled": true
},
"permissions": {
"allow": [
"commandes pnpm de validation",
"exécution du CLI",
"commandes Git en lecture seule",
"variantes Bash et PowerShell"
],
"ask": [
"mutations de dépendances",
"exécution ponctuelle de packages",
"publication npm",
"git push ordinaire"
],
"deny": [
"commandes de transfert réseau",
"rm depuis le shell",
"lecture des fichiers .env",
"push forcé",
"git reset --hard"
]
}
}

Une politique adaptée, pas une garantie absolue
Cette configuration réduit les interruptions pour les commandes habituelles et bloque plusieurs actions manifestement hors périmètre.

Elle ne garantit pas qu’une commande autorisée est toujours inoffensive. Par exemple, un script appelé avec pnpm run * peut exécuter le contenu déclaré dans un package.json. La politique repose donc toujours sur plusieurs couches :
permissions explicites ;
sandbox lorsqu'elle est disponible ;
revue des scripts du projet ;
contrôles Git ;
tests ;
inspection du diff ;
validation humaine des actions significatives.

Le mode bypassPermissions n’est pas utilisé. Il supprimerait précisément la couche de validation que cette gate cherche à construire.
