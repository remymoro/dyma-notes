Claude Code 13. Projet partie 1 : démarage d'u… 5. Cadrer la mémoire projet avec CLAUDE.md et .claude/rul…

Le socle technique de Claudoscope est maintenant en place. Le monorepo contient ses deux packages, ses configurations communes, ses contrats de types, son moteur minimal, son squelette de CLI et ses tests de santé.

La stratégie de publication a également été corrigée : claudoscope et @claudoscope/core sont destinés à être publiés comme deux packages distincts.

Avant d’ajouter des instructions persistantes dans CLAUDE.md, il faut demander à Claude Code de comprendre le projet réel. La mémoire ne doit pas être écrite à partir d’un plan abstrait ou d’une ancienne version du design doc. Elle doit être extraite du code, des configurations et des décisions effectivement présentes.

Cette session suit donc trois étapes : comprendre le socle, réaligner les documents, puis extraire une mémoire courte et ciblée.

Parcourir l’intégralité du socle
Compléter la lecture du design doc
Le fichier design-doc.md explique les objectifs et les choix structurants du projet. Il ne suffit cependant pas pour savoir ce qui existe réellement dans le dépôt.

Il faut demander à Claude Code de confronter le document au socle complet : configurations du monorepo, manifestes des packages, sources et tests.

Lis le fichier @design-doc.md, puis parcours l'intégralité du socle technique du dépôt.
Ne modifie encore aucun fichier.
Présente-moi le projet en distinguant :
- le problème auquel il répond ;
- les décisions structurantes ;
- l'architecture ;
- le contenu actuel de packages/core ;
- le contenu actuel de packages/cli ;
- les tests et l'outillage ;
- l'état des gates du design doc ;
- la prochaine étape naturelle.

Claude Code recherche les fichiers du projet et en lit 18. Cette exploration couvre le design doc, la configuration du monorepo, les deux packages, leurs fichiers source et leurs tests.
Il peut alors produire une présentation fondée sur le dépôt réel, et non sur des suppositions.

Présenter le problème et la réponse produit
Le problème traité
Le comportement d’un agent Claude Code dans un dépôt est notamment piloté par plusieurs fichiers de configuration :
CLAUDE.md
.claude/rules/
.claude/settings.json
.mcp.json

Ces fichiers peuvent progressivement dériver : instructions trop longues, permissions trop larges, informations sensibles en clair ou contenu devenu inutile.
Claudoscope doit analyser ces fichiers selon un fonctionnement comparable à celui d’ESLint :
Des règles codées.
Un rapport structuré.
Un code de sortie.
La même entrée produit toujours la même sortie.

Le produit n’utilise ni LLM, ni réseau, ni clé d’API pour produire ses diagnostics.

Les décisions structurantes

Décision | Conséquence
---|---
Moteur déterministe pur | Le jugement par LLM et l’approche hybride sont écartés afin de conserver des résultats reproductibles et des snapshots stables.
CLI comme première surface | Une seule commande, claudoscope scan [chemin], doit pouvoir être utilisée localement puis comme gate de CI.
Première version limitée à CLAUDE.md | Le pipeline est générique, mais les autres formats restent hors de la première tranche.
Lecture seule stricte | Pas d’auto-fix, aucune écriture dans le dépôt analysé et aucune configuration utilisateur dans la première version.
Publication libre visée | Le projet utilise une licence MIT, avec une première utilisation interne avant diffusion publique.

Comprendre les deux packages
Une frontière centrale
Le monorepo contient deux packages. Leur séparation constitue le principal contrat d’architecture.

packages/core
↓
moteur pur et contrats

packages/cli
↓
surface extérieure et entrées-sorties

La dépendance ne doit circuler que dans un sens :
surface -> moteur

Le moteur ne doit jamais connaître la surface qui l’utilise. Une future Action de CI, un plugin Claude Code ou un serveur LSP devra pouvoir consommer le même core.

Le contenu actuel de packages/core
Le package @claudoscope/core contient déjà les contrats et le moteur générique.

Fichier | Responsabilité
---|---
packages/core/src/types.ts | Définit les types SourceFile, Finding, Severity, Rule et le contexte transmis aux règles.
packages/core/src/engine.ts | Contient la fonction analyze(files, rules), qui applique chaque règle à chaque fichier dans un ordre fixe.
packages/core/src/index.ts | Expose l’unique point d’entrée public du package.
packages/core/src/engine.test.ts | Vérifie qu’une analyse sans règle retourne une liste vide et conserve un comportement déterministe.

Les types correspondent déjà au modèle de règle défini dans le design doc :

type Severity = "error" | "warn" | "info";
type SourceFile = {
path: string;
content: string;
};
type Finding = {
ruleId: string;
severity: Severity;
message: string;
line?: number;
};
type Rule = {
id: string;
severity: Severity;
docs: string;
check(ctx: RuleContext): Finding[];
};

Le moteur utilise une double boucle, fichiers puis règles, pour agréger les diagnostics dans un ordre fixe.
analyze(files, rules);

Aucune règle métier n’est encore fournie. Avec une liste de règles vide, le moteur retourne une liste vide.

Le contenu actuel de packages/cli
Le package claudoscope contient la surface terminal du produit.

Fichier | Responsabilité
---|---
packages/cli/src/program.ts | Construit le programme commander et déclare la commande scan.
packages/cli/src/index.ts | Constitue le point d’entrée exécutable et traduit une erreur d’exécution en code de sortie 2.
packages/cli/src/program.test.ts | Vérifie que la commande scan existe.

La commande déclare déjà ses principales options :
claudoscope scan [chemin]
--format text|json
--fail-on error|warn

Le chemin utilise le répertoire courant par défaut.

L’action de la commande reste cependant un squelette. Elle affiche un message temporaire et ne réalise encore :
aucune découverte de CLAUDE.md ;
aucune lecture de fichier ;
aucun appel au moteur ;
aucun rendu de diagnostics ;
aucun calcul de code de sortie fonctionnel.

Comprendre les tests et l’outillage
Les tests existants
Le socle contient deux tests de santé :

Test | Preuve fournie
---|---
engine.test.ts | Le moteur peut être appelé sans règle, retourne une liste vide et conserve son déterminisme.
program.test.ts | Le programme CLI expose la commande scan.

Il n’existe encore ni fixture de dépôt, ni snapshot, ni test d’intégration traversant la frontière entre le CLI et le core.

L’outillage commun
La configuration du monorepo confirme les choix suivants :
TypeScript strict
noUncheckedIndexedAccess
verbatimModuleSyntax
module et moduleResolution NodeNext
ESM dans les deux packages
Node.js 20 ou supérieur
pnpm workspaces
compilation avec tsc
Vitest à la racine
ESLint sur le monorepo

Les scripts racine orchestrent les deux packages :
pnpm run build
pnpm run typecheck
pnpm run test
pnpm run lint

Évaluer l’avancement des gates
Comparer le code aux cinq gates du design doc

Gate | État observé
---|---
Core minimal, une règle testée en mémoire | Le moteur existe, mais aucune règle n’est encore implémentée.
CLI branché sur les fixtures et les codes de sortie | Le squelette existe, mais il n’est pas encore branché au core.
Jeu de règles initial et snapshots | Non commencé.
Dogfooding sur le propre dépôt | Non commencé.
Publication npm | Hors de la première version fonctionnelle.

Identifier la prochaine tranche
La prochaine étape naturelle est la première tranche verticale :

Implémenter une première règle dans le core.
↓
Brancher le CLI sur le moteur.
↓
Découvrir ./CLAUDE.md puis .claude/CLAUDE.md.
↓
Produire une sortie texte ou JSON.
↓
Retourner les codes de sortie attendus.
↓
Ajouter les fixtures saine et fautive.

Le projet est encore jeune, mais ses fondations sont en place : contrat de types, frontière core / CLI, outillage et stratégie de publication.

Réaligner les documents avant de créer la mémoire
Identifier les décisions devenues obsolètes
La lecture complète met en évidence deux changements qui ne sont pas encore reflétés partout dans les documents.

Premièrement, le design doc et le README.md indiquent encore que seul le package claudoscope doit être publié. La stratégie retenue est maintenant de publier également @claudoscope/core.

Deuxièmement, le jeu de règles initial doit être remplacé par trois règles nommées :

Règle | Signal
---|---
MEM001 | Le fichier CLAUDE.md est trop long.
MEM002 | Une section est vide.
MEM003 | La structure minimale attendue est absente, notamment une section consacrée aux commandes, à l’architecture ou à la vérification.

Le comportement exact, les seuils et les sévérités seront précisés pendant la spécification de l’implémentation.

Demander deux modifications ciblées
Mets à jour uniquement design-doc.md et README.md.
Modifications à appliquer :
1. Publication
Les deux packages seront publiés :
- claudoscope ;
- @claudoscope/core.
@claudoscope/core est une dépendance du CLI actuel et des futures surfaces.
2. Jeu de règles de la première version
Remplace l'ancienne liste par :
- MEM001 : fichier trop long ;
- MEM002 : section vide ;
- MEM003 : structure minimale absente.
Précise que leur comportement exact sera spécifié pendant l'implémentation.
Ne modifie aucun fichier source.
Ne crée aucune règle.
Ne commence pas la tranche verticale.

Modifications obtenues
Claude Code modifie exactement deux fichiers.

Fichier | Modification
---|---
design-doc.md | La publication du seul CLI est remplacée par la publication des deux packages.
design-doc.md | L’ancien catalogue de règles est remplacé par MEM001, MEM002 et MEM003.
design-doc.md | Un caractère isolé présent dans la section des objectifs est supprimé.
README.md | La présentation est alignée sur la publication des deux packages.

Le code ne nécessite aucune correction supplémentaire pour cette décision : packages/core/package.json contient déjà sa licence MIT, son accès public et la liste des fichiers publiés.

Extraire une mémoire courte du projet
Ne pas recopier le design doc
Le design doc contient la trajectoire du produit, les alternatives écartées, les gates et les futures fonctionnalités. Ces informations n’ont pas toutes besoin d’être injectées dans chaque session.

La mémoire principale doit conserver uniquement les informations nécessaires au travail quotidien :
La nature du projet.
La frontière entre le core et le CLI.
Le sens des dépendances.
Les commandes usuelles.
La stack du monorepo.

Les instructions propres au core peuvent être isolées dans une règle limitée à packages/core/**.

Demander la création des deux fichiers

À partir du socle et du design doc maintenant alignés, crée la mémoire du projet.
Crée uniquement :
- CLAUDE.md ;
- .claude/rules/claudoscope-core.md.
CLAUDE.md doit rester court et contenir uniquement :
- la présentation du projet ;
- la frontière packages/core / packages/cli ;
- le sens des dépendances ;
- les commandes du monorepo ;
- la stack.
La règle claudoscope-core.md doit :
- être limitée à packages/core/** avec paths ;
- rappeler l'absence totale d'I/O ;
- interdire le réseau et les clés d'API ;
- imposer le déterminisme ;
- rappeler le contrat minimal d'une règle et de ses tests.
Ne modifie aucun autre fichier.
Ne crée aucune logique produit.
Ne configure pas encore les permissions.

Créer le fichier CLAUDE.md
Le contexte commun à toutes les sessions
Le fichier principal reste volontairement court. Il ne contient ni l’historique du cadrage, ni le détail des gates, ni le catalogue des futures règles.

## Projet
claudoscope est un linter déterministe (modèle ESLint) pour les fichiers de configuration Claude Code
## Architecture
- **Le moteur (`packages/core`, `@claudoscope/core`)** - applique les règles à des
contenus en mémoire et produit des findings. Entièrement pur, donc déterministe et
testable sans mise en scène.
- **La surface (`packages/cli`, `claudoscope`)** - tout le rapport au monde extérieur :
découvrir et lire les fichiers, invoquer le moteur, présenter les résultats, traduire
leur gravité en code de sortie.
Cette frontière est le contrat central du projet : la dépendance ne va que dans un sens
(surface -> moteur). Toute surface future (Action CI, plugin Claude Code, LSP) consommera
le même moteur, sans que celui-ci n'ait jamais à connaître ses surfaces.
## Commandes
```bash
pnpm install # installe et lie les packages du workspace
pnpm run build # tsc -> packages/*/dist (nécessaire avant d'exécuter la CLI)
pnpm run typecheck # tsc --noEmit sur chaque package
pnpm run test # vitest run sur tout le monorepo
pnpm run lint # eslint sur le monorepo
pnpm run claudoscope # exécute la CLI buildée (node packages/cli/dist/index.js)
```
## Stack
- Monorepo pnpm
- Node >= 20, ESM partout
- TypeScript strict
- Vitest (tests, fixtures, snapshots)
- eslint + typescript-eslint
- Workspaces pnpm

Ce que le fichier ne contient pas
Plusieurs informations restent volontairement dans design-doc.md plutôt que dans la mémoire principale :
Les alternatives architecturales écartées.
Le détail des cinq gates.
Le catalogue MEM001 / MEM002 / MEM003.
Les seuils des futures règles.
Les fixtures à construire.
Le plan de publication.
Les futures surfaces.
L'historique des arbitrages.

Cette séparation évite de charger chaque session avec des informations qui ne sont pas nécessaires à toutes les tâches.

Créer une règle limitée au core
Utiliser le frontmatter paths
Les instructions particulières au moteur sont placées dans :
.claude/rules/claudoscope-core.md

Le frontmatter limite cette règle aux fichiers de packages/core.
---
paths:
- "packages/core/**"
---
- Le core ne fait aucune I/O : fonctions pures `contenus -> findings`.
- Aucune requête réseau, aucune clé API, jamais.
- Déterminisme : même entrée -> même sortie, garanti par snapshots ; l'ordre d'agrégation
des findings (fichiers × règles) est fixe.
- Toute règle a un id stable (ex. `claude-md/length`), une sévérité, une doc d'une ligne,
et des tests fixture sain + fautif avant merge.

Pourquoi isoler ces instructions
La pureté du moteur constitue une information globale et apparaît donc brièvement dans CLAUDE.md.
Les détails d’implémentation des règles ne sont utiles que lorsque le travail concerne packages/core :
Absence d'I/O.
Ordre d'agrégation fixe.
Identifiant stable.
Sévérité.
Documentation d'une ligne.
Fixture saine.
Fixture fautive.

Les placer dans une règle ciblée garde la mémoire principale concise tout en fournissant les contraintes au moment où elles deviennent pertinentes.

Distinguer mémoire et contrôle
Des instructions persistantes, pas une barrière technique
CLAUDE.md et .claude/rules/claudoscope-core.md donnent à Claude Code le contexte et les conventions du projet.

Ils ne remplacent pas les contrôles déterministes qui devront protéger les invariants :
Tests unitaires.
Tests d'intégration.
ESLint.
TypeScript.
Snapshots.
Permissions.
Hooks éventuels.
Revue du diff.

La règle « le core ne fait aucune I/O » est maintenant visible par l’agent. Elle devra aussi être détectable par les tests ou l’analyse statique si elle devient un invariant critique.

Résultat de la session
Documents alignés
design-doc.md
publication des deux packages
jeu de règles MEM001 / MEM002 / MEM003
README.md
publication des deux packages

Mémoire ajoutée
CLAUDE.md
présentation
architecture
commandes
stack
.claude/rules/claudoscope-core.md
règle limitée à packages/core/**
pureté
déterminisme
contrat des règles
exigences de test

Éléments encore absents
Aucune règle MEM implémentée.
Aucune fixture saine ou fautive.
Aucun snapshot.
Aucune découverte de CLAUDE.md.
Aucun branchement réel du CLI vers le core.
Aucune permission projet.
Aucun hook.
Aucune logique produit supplémentaire.
