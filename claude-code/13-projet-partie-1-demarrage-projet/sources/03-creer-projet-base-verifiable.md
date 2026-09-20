Claude Code 13. Projet partie 1 : démarage d'u… 3. Créer le projet depuis zéro et obtenir une base vérifiable …

Le cadrage de Claudoscope est maintenant terminé. Le dossier du projet existe et contient uniquement le fichier design-doc.md produit pendant la session précédente.

Ce document fixe les principales décisions : un CLI local, un moteur déterministe, une stack TypeScript et Node.js, deux packages séparant le moteur pur des entrées-sorties, ainsi qu’une première tranche limitée à l’analyse de CLAUDE.md.

Cette session ne doit toujours pas implémenter les règles du produit. Son objectif est de préparer le plan exact du socle technique : les fichiers à créer, leur responsabilité, les commandes qui permettront de les valider et les éléments qui doivent rester hors périmètre.

La gate de cette leçon n’est pas un dépôt compilé. C’est un plan de socle suffisamment précis pour pouvoir être exécuté sans nouvelle décision d’architecture.

Vérifier l’état de départ
Contrôler le contenu du dossier
Ouvrez un terminal à la racine de claudoscope, puis affichez son contenu.
Le dossier ne doit contenir que le document de conception :
ls
design-doc.md

Il n’existe pas encore de package.json, de pnpm-workspace.yaml, de dossier packages/, de configuration TypeScript ou de code source.
Cette absence est volontaire. Le design doc constitue l’unique source de vérité avant la création du socle.

Vérifier Node.js et le gestionnaire de packages
Contrôlez ensuite les versions disponibles de Node.js et de npm.
node -v
npm -v

L’environnement utilisé pendant cette session retourne :
v22.14.0
11.4.1

Le projet doit cependant utiliser pnpm. Essayez de lancer la commande :
pnpm

Dans l’environnement initial, PowerShell indique que la commande n’est pas reconnue.
pnpm : le terme 'pnpm' n'est pas reconnu comme nom de commande, fonction, fichier de script ou programme exécutable.

Activez alors Corepack :
corepack enable

Puis vérifiez que pnpm est maintenant accessible :
pnpm -v

Cette étape prépare l’environnement. Elle ne crée encore aucun fichier dans le projet.

Fournir le design doc comme source de vérité
Référencer directement le fichier
Ouvrez Claude Code sur le dossier local claudoscope. Le document peut être fourni directement dans la demande avec la référence @design-doc.md.

Cette référence évite de recopier manuellement l’ensemble du document dans la conversation. Claude Code doit lire les décisions déjà validées et construire son plan à partir de celles-ci.

La demande précise également d’ignorer CLAUDE.md. Le socle doit être dérivé du design doc, sans utiliser d’autres instructions projet pendant cette session.

Le prompt utilisé
Nous sommes dans un dépôt vide appelé claudoscope.
Je vais te renseigner le fichier @design-doc.md.
Ignore CLAUDE.md.
Dans ce fichier, tu as tous les prérequis pour la mise en place du socle du projet.
Dans cette session, tu dois me préparer le socle technique.
Le plan doit contenir :
- un workspace pnpm ;
- un package packages/core ;
- un package packages/cli ;
- les scripts lint, typecheck, test et build ;
- un point d'entrée CLI de squelette ;
- un test minimal de santé ;
- une structure qui ne contient pour l'instant aucune logique d'audit.
Pour le moment, réponds avec :
- les fichiers à créer ;
- le rôle de chaque fichier ;
- les commandes de validation.

La dernière phrase borne explicitement l’action. Claude Code doit produire un plan, pas modifier le dossier.
Il ne doit donc pas :
créer les fichiers ;
installer les dépendances ;
lancer les validations ;
implémenter les règles ;
analyser CLAUDE.md ;
créer les fixtures ;
préparer la publication.

Faire dériver le socle du design doc
Rappeler le contexte du produit
La réponse commence par reformuler les contraintes qui influencent directement le socle.

Claudoscope est un linter déterministe pour les fichiers de configuration de Claude Code. La première version doit analyser CLAUDE.md selon un modèle proche d’ESLint : des règles codées produisent des diagnostics et un code de sortie.
Le dossier est encore vide, à l’exception de design-doc.md. La session doit uniquement préparer :
un monorepo pnpm ;
deux packages ;
les outils de lint, de typage, de test et de build ;
un CLI de squelette ;
un test de santé.

Elle ne doit introduire aucune logique d’audit :
aucune règle ;
aucune découverte de fichiers ;
aucun rapport réel ;
aucun calcul de code de sortie par sévérité.

Respecter les deux frontières d’architecture
Le design doc impose deux composants dès le premier socle.

Composant | Responsabilité | Interdictions
---|---|---
@claudoscope/core | Recevoir des contenus en mémoire, exécuter les futures règles et retourner des Finding[]. | Aucun accès à fs, au réseau ou à process.
claudoscope | Constituer la surface CLI publiable et consommer le core. | Aucune logique propre aux futures règles d’audit.

Le pipeline générique est anticipé par les types et par un moteur minimal :
découverte
↓
analyse
↓
règles
↓
rapport

Le moteur du socle doit pouvoir recevoir une liste vide de règles et retourner une liste vide de diagnostics. Cela valide le contrat sans implémenter une seule règle métier.

Fixer les décisions de stack
La stack retenue

Décision | Application dans le socle
---|---
TypeScript strict | Tous les packages utilisent une configuration commune avec strict: true.
Node.js 20 ou supérieur | Le manifeste racine déclare cette contrainte dans engines.
ESM | Les packages déclarent "type": "module".
pnpm workspaces | Les deux packages vivent sous packages/*.
commander | La surface CLI expose la future commande scan.
Vitest | Deux tests de santé valident le core et le CLI.
ESLint | Une configuration plate couvre tout le monorepo.
tsc | La compilation n’utilise ni tsup ni autre bundler.

Relier les deux packages
@claudoscope/core ne possède aucune dépendance d’exécution. Le package claudoscope dépend du core avec le protocole du workspace :
{
"dependencies": {
"@claudoscope/core": "workspace:*"
}
}

Le CLI peut ainsi consommer le package local pendant le développement, sans publier préalablement @claudoscope/core.

Planifier les fichiers de la racine
L’outillage commun du workspace

Fichier | Rôle
---|---
package.json | Manifeste racine privé. Il déclare pnpm comme gestionnaire, exige Node.js 20 ou supérieur, centralise les dépendances de développement et expose les scripts build, typecheck, test et lint.
pnpm-workspace.yaml | Déclare le workspace avec le motif packages/*.
tsconfig.base.json | Centralise la configuration TypeScript : mode strict, modules NodeNext, résolution NodeNext, cible ES2022 et absence d’émission par défaut.
eslint.config.js | Configure ESLint au format plat pour TypeScript, ignore les dossiers dist et prépare le contrôle de la frontière sans entrées-sorties du core.
vitest.config.ts | Configure une seule exécution Vitest sur les fichiers correspondant à packages/**/*.test.ts, dans l’environnement Node.js.
.gitignore | Ignore node_modules, les sorties dist et les caches de compilation.
.npmrc | Contient les réglages minimaux de pnpm, notamment engine-strict=true.
README.md | Fournit un pointeur court vers design-doc.md et présente les commandes de développement.

Le manifeste racine
Le futur package.json racine doit rester privé. Il n’est pas destiné à être publié sur npm.
Il centralise les dépendances communes :
typescript
vitest
eslint
typescript-eslint
@types/node

Les scripts racine orchestrent les deux packages. Ils doivent permettre d’exécuter les validations depuis un seul point d’entrée.

Planifier @claudoscope/core
Le package pur
Le dossier packages/core contient le contrat et le moteur générique du produit. Il n’effectue aucune entrée-sortie.

Fichier | Rôle
---|---
packages/core/package.json | Déclare le package @claudoscope/core, le mode ESM, les exports JavaScript et TypeScript, ainsi que les scripts build et typecheck. Il ne contient aucune dépendance d’exécution.
packages/core/tsconfig.json | Étend la configuration commune, utilise src comme rootDir, émet dans dist et produit les déclarations de types.
packages/core/src/types.ts | Définit les types de contrat sans ajouter de règle métier.
packages/core/src/engine.ts | Expose un moteur pur qui reçoit des fichiers en mémoire et une liste de règles, puis retourne les diagnostics produits.
packages/core/src/index.ts | Constitue la surface publique du package et réexporte les types et le moteur.
packages/core/src/engine.test.ts | Vérifie qu’une analyse exécutée avec une liste vide de règles retourne une liste vide.

Les types de contrat
Le fichier src/types.ts prépare les concepts que les prochaines tranches utiliseront.

Type | Rôle
---|---
Severity | Union "error" \| "warn" \| "info".
SourceFile | Contient un chemin et le texte déjà chargé en mémoire.
Finding | Contient l’identifiant de la règle, la sévérité, le message et une ligne optionnelle.
Rule | Définit un identifiant stable, une sévérité, une description et une fonction check.
RuleContext | Fournit à une règle le contexte nécessaire à son exécution.

Ces types ne constituent pas encore une logique d’audit. Ils fixent seulement le contrat que les futures règles devront respecter.

Le moteur vide
Le moteur expose une fonction de cette forme :
analyze(files: SourceFile[], rules: Rule[]): Finding[]

Il parcourt les contenus et exécute les règles fournies. Avec une liste de règles vide, il retourne immédiatement une liste vide.
analyze(
[
{
path: "CLAUDE.md",
content: "# Projet"
}
],
[]
);
// Résultat attendu : []

Ce comportement suffit pour le test de santé du core. Il prouve que le contrat peut être appelé sans introduire les futures règles de longueur, de section, de contenu dérivable ou de secret.

Préparer correctement la référence de projet
Le CLI doit référencer le projet core. Le fichier packages/core/tsconfig.json doit donc activer le mode composite :
{
"extends": "../../tsconfig.base.json",
"compilerOptions": {
"composite": true,
"declaration": true,
"rootDir": "src",
"outDir": "dist"
},
"include": ["src/**/*.ts"]
}

Cette option permet à TypeScript de traiter le core comme un projet référencé avec ses propres sorties.

Planifier le package claudoscope
Le squelette du CLI

Fichier | Rôle
---|---
packages/cli/package.json | Déclare le package publiable claudoscope, le mode ESM, le champ bin pointant vers dist/index.js, ainsi que les dépendances @claudoscope/core et commander.
packages/cli/tsconfig.json | Étend la configuration commune, utilise src comme rootDir, émet dans dist et référence le projet core.
packages/cli/src/program.ts | Construit le programme commander et l’exporte pour permettre son test sans exécuter le processus complet.
packages/cli/src/index.ts | Constitue le point d’entrée exécutable, importe le programme et lui transmet process.argv.
packages/cli/src/program.test.ts | Instancie le programme et vérifie qu’il expose la commande scan sans effet de bord.

Préparer la commande sans l’implémenter
Le fichier src/program.ts doit exposer une commande de squelette :
claudoscope scan [chemin]

Les options déjà retenues dans le design doc peuvent être déclarées :
--format
--fail-on

Elles ne doivent cependant produire aucun comportement réel dans ce socle. La commande affiche seulement un message temporaire et se termine avec le code 0.
Elle ne doit encore effectuer :
aucune recherche de CLAUDE.md ;
aucune lecture avec fs ;
aucun appel à une règle ;
aucun rendu de diagnostics ;
aucun calcul de sévérité ;
aucun code de sortie fonctionnel.

Le point d’entrée exécutable
Le fichier src/index.ts commence par un shebang compatible avec un exécutable Node.js :
#!/usr/bin/env node

Il importe le programme, le lance avec process.argv et transforme une erreur d’exécution en code de sortie 2.
Cette gestion prépare le futur contrat du CLI, mais elle ne remplace pas encore les codes de sortie fonctionnels du scan.

Maintenir un hors-périmètre explicite
Ce que le socle ne doit pas contenir
Le plan identifie explicitement les tranches repoussées.

Élément exclu | Raison
---|---
Règles de la première version | La longueur totale, les sections démesurées, le contenu dérivable et les secrets seront ajoutés dans une tranche ultérieure.
Découverte de CLAUDE.md | Le CLI ne lit pas encore le système de fichiers.
Rapport texte ou JSON | La commande n’affiche qu’un message temporaire.
Code de sortie selon la sévérité | Le socle termine toujours avec 0, sauf erreur d’exécution.
Fixtures sain et fautif | Les règles et leurs sorties n’existent pas encore.
Snapshots | Aucune sortie métier n’est encore assez stable pour être enregistrée.
Action GitHub | La distribution par CI est repoussée.
Publication npm | Le package n’a pas encore prouvé sa valeur fonctionnelle.

Le socle anticipe la forme du produit sans implémenter sa valeur métier.

Définir les commandes de validation
Les commandes racine
Le plan se termine par les commandes qui devront être lancées après la création des fichiers.
Elles sont exécutées depuis la racine et dans cet ordre :
pnpm install # Résout le workspace et lie @claudoscope/core au CLI
pnpm run lint # Exécute ESLint sur le monorepo, sans erreur attendue
pnpm run typecheck # Vérifie les deux packages sans émettre de fichiers
pnpm run test # Exécute les deux tests de santé
pnpm run build # Compile les packages et produit leurs dossiers dist

Ces commandes ne sont pas encore exécutées dans cette session. Elles constituent les futures preuves de fermeture du socle.

La vérification manuelle du CLI
Après la compilation, deux commandes permettront de contrôler le squelette :
node packages/cli/dist/index.js scan
node packages/cli/dist/index.js --help

La première doit afficher le message temporaire et terminer avec le code 0.
La seconde doit afficher l’aide générée par commander et présenter la commande scan.

Définir les critères de réussite
La future gate du socle
Le plan fixe quatre critères observables.

Critère | Preuve attendue
---|---
Chaîne de validation | Les scripts lint, typecheck, test et build passent sans erreur.
Tests de santé | Le test du core et le test du CLI sont verts.
Pureté du core | @claudoscope/core ne contient aucun import de fs, de process ou d’un client réseau.
Squelette du CLI | Le programme démarre, expose scan, termine avec 0 et n’exécute aucune logique d’audit.

Ces critères décrivent la prochaine gate d’exécution. Ils permettent de juger le futur socle sans devoir redéfinir ce que signifie « terminé » après sa création.

Gate de sortie de la session
Valider le plan, pas encore le code
La session se termine lorsque Claude Code a produit un plan qui contient :
les fichiers de la racine ;
les fichiers de @claudoscope/core ;
les fichiers du package claudoscope ;
le rôle précis de chaque fichier ;
les dépendances entre les packages ;
les commandes de validation ;
la vérification manuelle du CLI ;
les critères de réussite ;
les éléments explicitement exclus.

Le contenu du dossier ne doit pas encore avoir changé. Il contient toujours uniquement :
design-doc.md

Le résultat de cette leçon est donc un plan de socle relu, borné et directement exécutable, pas encore le socle lui-même.
