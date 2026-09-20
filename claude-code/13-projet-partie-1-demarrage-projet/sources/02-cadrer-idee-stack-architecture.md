Claude Code 13. Projet partie 1 : démarage d'u… 2. Cadrer l’idée, la stack et l’architecture avec Claude Code …

Le point de départ n’est pas un dépôt existant. Nous partons de zéro, dans un dossier vide. Il n’y a pas encore de workspace, de package, de fichier CLAUDE.md, de commande, de test ou de structure technique.

Il existe seulement une intention produit : construire Claudoscope, un outil capable d’analyser les fichiers qui encadrent le fonctionnement de Claude Code dans un projet et de signaler les configurations fragiles.

La mauvaise réaction serait de demander immédiatement à Claude Code de créer le projet. Une intention encore floue lui laisserait le choix du produit, de la surface, de la stack, de l’architecture, des règles et du niveau de qualité attendu.

Le premier livrable n’est donc pas du code. C’est un design doc.

Dans cette session, Claude Code n’est pas utilisé comme implémenteur. Il intervient comme partenaire d’architecture et de critique. Il doit poser les questions manquantes, challenger les hypothèses, comparer les options et produire une décision suffisamment précise pour permettre ensuite la création du dépôt sans improvisation.

Imposer un livrable unique
Ne pas mélanger cadrage et implémentation
La session doit rester entièrement consacrée au cadrage. Claude Code ne doit créer ni scaffold, ni fichier de configuration, ni package, ni commande d’initialisation.

Cette contrainte évite que les premières propositions techniques deviennent implicitement des décisions. Tant que le cadrage n’est pas relu, aucune structure ne doit être matérialisée sur le disque.

Le livrable unique est un fichier design-doc.md. Il doit contenir exactement huit sections :

Section | Rôle
---|---
Contexte | Décrire le problème, le produit envisagé et les décisions issues de l’interview.
Objectifs et non-objectifs | Définir ce que la première version doit accomplir et ce qui en est volontairement exclu.
Design | Fixer la surface produit, la stack, les frontières d’architecture et la première tranche verticale.
Alternatives écartées | Conserver les options comparées et le compromis qui justifie chaque rejet.
Invariants d’architecture | Formuler les règles courtes qui seront ensuite ajoutées au futur CLAUDE.md.
Gates de validation | Associer chaque phase à une preuve observable.
Questions ouvertes | Conserver explicitement les décisions qui n’ont pas encore été tranchées.
Verdict final | Indiquer si le cadrage permet ou non de créer le dépôt.

Rendre les inconnues visibles
Un agent produit facilement une réponse plausible lorsqu’une information manque. Dans une session d’architecture, ce comportement est dangereux : une supposition peut devenir une contrainte structurelle sans avoir été décidée.

Le prompt impose donc un marqueur explicite pour les inconnues :
[OUVERT: question]

Tout élément qui n’a pas été fourni et qui ne peut pas être vérifié doit rester ouvert. Claude Code ne doit pas inventer une réponse pour rendre le document artificiellement complet.

Lancer la session de cadrage
Le prompt utilisé
La session commence avec une seule consigne structurée. Elle fixe le rôle de Claude Code, le livrable, le déroulé et les garde-fous.

Nous partons de zéro, dans un dossier vide. Le dépôt du projet n'existe pas encore.
Idée produit :
créer Claudoscope, un linter déterministe qui analyse les fichiers de configuration Claude
Ton rôle dans cette session : partenaire d'architecture et de critique.
Tu ne codes pas. Tu ne proposes ni scaffold, ni commande d'initialisation,
ni implémentation. Le livrable unique de la session est un design doc.
## Livrable
Un fichier design-doc.md avec exactement ces sections :
1. Contexte
2. Objectifs / Non-objectifs
3. Design (surface produit, stack, architecture en frontières, première tranche verticale)
4. Alternatives écartées (avec le trade-off qui a motivé chaque rejet)
5. Invariants d'architecture (courts, destinés au futur CLAUDE.md)
6. Gates de validation (une preuve observable par phase)
7. Questions ouvertes
8. Verdict final : "Prêt pour création du dépôt : oui / non"
Chaque décision est justifiée en une phrase. Le document reste concis :
il doit permettre de créer le dépôt sans hésitation, pas documenter le futur produit.
## Déroulé imposé
1. Commence par m'interviewer : questions par lots de 5 maximum, classées par
thème (produit, utilisateurs, surface, contraintes, sécurité, tests, distribution),
en commençant par celles dont la réponse change le plus le design.
Deux tours de questions maximum. Ne réponds pas aux questions à ma place.
2. Après mes réponses, propose la surface produit et la stack : compare les
options pertinentes sur des critères explicites, puis rends une recommandation
claire que je validerai ou corrigerai.
3. Rédige ensuite le design doc complet dans la conversation pour relecture.
4. N'écris le fichier qu'après mon "go", et n'écris que ce fichier.
## Garde-fous
- Tout ce que je ne t'ai pas dit et que tu ne peux pas vérifier est marqué
"[OUVERT: question]" dans le document. N'invente jamais une réponse plausible.
- Challenge mes hypothèses : si une de mes réponses te semble élargir le
périmètre ou fragiliser la première livraison, dis-le et propose plus strict.
- Une recommandation sans critères explicites ne vaut rien : donne toujours
les critères avant le choix.

Pourquoi le prompt est volontairement contraignant
Chaque partie ferme une classe d’erreurs particulière.

Contrainte | Erreur évitée
---|---
Ne pas coder | Transformer une hypothèse non validée en structure technique.
Un seul livrable | Disperser la session entre architecture, configuration et implémentation.
Huit sections imposées | Oublier les non-objectifs, les alternatives ou les preuves de validation.
Deux tours de questions maximum | Transformer le cadrage en interview interminable.
Questions qui changent le plus le design en premier | Consommer le contexte sur des détails avant de trancher les choix structurants.
Validation avant écriture | Créer un fichier alors que son contenu n’a pas encore été relu.
Marqueur [OUVERT: question] | Masquer une inconnue derrière une réponse plausible.
Critères avant recommandation | Présenter une préférence technique comme une décision rationnelle.

Faire conduire l’interview par Claude Code
Premier tour : les choix qui structurent le produit
Claude Code commence par les questions dont les réponses modifient le plus fortement l’architecture.

Question | Réponse | Conséquence
---|---|---
Quelle est la nature du moteur d’analyse : règles déterministes, jugement par LLM ou hybride ? | Règles déterministes. | Le produit doit fournir la même sortie pour la même entrée, sans modèle ni clé d’API.
Quelle surface produit pour la première livraison ? | CLI local. | La première version doit s’exécuter dans un terminal et retourner un code de sortie.
Quel est l’utilisateur cible de la première version ? | Usage interne d’abord, public visé ensuite. | La première preuve peut être validée en interne avant de travailler la publication.
Existe-t-il une contrainte ou une préférence de stack ? | TypeScript et Node.js. | Les alternatives restent comparées, mais l’écosystème cible devient un critère prioritaire.

Ces réponses suffisent déjà à écarter plusieurs familles d’architecture : service distant, base de données, interface web principale, moteur probabiliste ou dépendance obligatoire à un fournisseur de modèles.

Second tour : fermer le périmètre de la première version
Le second lot porte sur le périmètre, le contrat de sortie et les preuves attendues.

Question | Réponse | Conséquence
---|---|---
Quel périmètre de fichiers pour la première version ? | CLAUDE.md. | Les fichiers .claude/rules/, .claude/settings.json et .mcp.json sont repoussés.
Quel comportement de sortie pour le CLI ? | Rapport et code de sortie selon la sévérité. | La commande doit produire une sortie lisible et pouvoir être utilisée comme gate de CI.
L’auto-correction avec --fix fait-elle partie du produit ? | Pas dans la première version, mais elle pourra être envisagée ensuite. | Le produit initial reste strictement en lecture seule.
Quel niveau d’exigence pour les tests et la validation ? | Fixtures de dépôts et snapshots. | Les sorties texte et JSON doivent être comparables et reproductibles.

Les deux tours ont permis de trancher les questions qui auraient le plus fortement modifié la conception. Il n’est pas nécessaire de continuer à interroger l’utilisateur sur les détails que l’architecture pourra rendre réversibles.

Valider la surface produit et la stack
Ne pas passer directement des réponses au document
Le prompt impose une gate intermédiaire. Avant de rédiger le design doc, Claude Code doit synthétiser la surface et la stack recommandées, puis demander une validation explicite.

La proposition issue de l’interview est la suivante :

Surface produit :
CLI local, utilisable ensuite comme gate de CI.
Moteur :
règles déterministes codées.
Stack :
TypeScript strict, Node.js, ESM et pnpm.
Périmètre initial :
analyse de CLAUDE.md uniquement.
Sortie :
rapport texte ou JSON et code de sortie selon la sévérité.
Validation :
fixtures de dépôts, tests Vitest et snapshots.
Auto-correction :
hors première version.

Claude Code demande alors si cette surface et cette stack sont validées ou si un point doit être corrigé avant la rédaction.

Trois réponses sont possibles :
Réponse | Effet
---|---
Validé tel quel | Le document est rédigé sur cette base.
Validé sauf corrections | Les corrections précisées sont intégrées avant la rédaction.
Autre | Une réponse libre permet de modifier la proposition.

La proposition est validée telle quelle. Cette validation ferme la phase de recommandation. Claude Code peut maintenant rédiger le document complet, mais il ne doit toujours pas créer le fichier.

Rédiger le design doc dans la conversation
Relire avant d’écrire
Le design doc apparaît d’abord dans la conversation. Cette étape distingue deux actions qui sont souvent confondues :
Action | Statut
---|---
Rédiger une proposition | Réversible, relisible et corrigeable sans modifier le dossier.
Écrire design-doc.md | Matérialiser la décision validée sur le disque.

La relecture doit vérifier que toutes les réponses de l’interview apparaissent correctement et qu’aucune nouvelle décision n’a été inventée.

Le contexte du produit
Le document commence par les fichiers qui encadrent un agent Claude Code dans un dépôt :
CLAUDE.md
.claude/rules/
.claude/settings.json
.mcp.json

Ces fichiers peuvent devenir trop longs, trop permissifs ou difficiles à maintenir. Claudoscope doit les analyser selon un modèle proche d’ESLint : un catalogue de règles codées produit des diagnostics et un code de sortie.
La première version reste cependant limitée à CLAUDE.md. Les autres formats sont cités pour expliquer la trajectoire du produit, mais ils ne doivent pas être implémentés dans la première tranche.

Les objectifs
Les objectifs reprennent directement les réponses de l’interview.

Objectif | Conséquence technique
---|---
Analyse déterministe et reproductible | Même entrée, même sortie, sans réseau ni clé d’API.
CLI utilisable localement et en CI | Rapport exploitable et code de sortie configurable selon la sévérité.
Première version limitée à CLAUDE.md | Le pipeline reste générique, mais un seul format est pris en charge.
Usage interne avant publication | La valeur des règles doit être prouvée avant de construire les surfaces de distribution.
Publication libre envisagée | Une licence MIT est retenue comme cible, sans faire de la publication une gate de la première version.

Les non-objectifs
Les non-objectifs empêchent la première livraison de s’élargir pendant l’implémentation.

Pas de moteur LLM ni de moteur hybride.
Pas d'auto-fix.
Pas de configuration utilisateur des règles.
Pas d'analyse de .claude/settings.json.
Pas d'analyse de .mcp.json.
Pas d'analyse de .claude/rules/.
Pas de GitHub Action comme première surface.
Pas de plugin Claude Code comme première surface.

L’absence de fichier de configuration signifie que toutes les règles de la première version sont actives avec leur sévérité par défaut. Cette décision réduit la surface du produit tant que le catalogue n’est pas stabilisé.

Définir le contrat du CLI
La commande principale
La surface produit contient une seule commande :
claudoscope scan [chemin]

Le chemin est optionnel. En son absence, le répertoire courant est analysé.
Le CLI recherche le fichier principal dans cet ordre :
./CLAUDE.md
.claude/CLAUDE.md

Le premier fichier trouvé est transmis au moteur d’analyse.

Les formats de sortie
La sortie texte doit rester lisible par une personne. Chaque diagnostic contient les informations nécessaires pour retrouver le problème :
fichier
ligne
identifiant de règle
sévérité
message

Une sortie JSON permet l’intégration avec d’autres outils.
claudoscope scan --format json

L’option --fail-on détermine le niveau minimal qui provoque un échec.
claudoscope scan --fail-on error
claudoscope scan --fail-on warn
La valeur par défaut est error.

Les codes de sortie
Code | Signification
---|---
0 | Aucun diagnostic ne dépasse le seuil configuré.
1 | Au moins un diagnostic atteint ou dépasse le seuil.
2 | Une erreur d’exécution empêche l’analyse.

Le produit reste entièrement en lecture seule. La commande n’écrit et ne modifie aucun fichier du dépôt analysé.

Choisir une stack minimale
Les choix retenus

Outil | Rôle
---|---
TypeScript strict | Typer les règles, les contextes d’analyse et les diagnostics.
Node.js 20 ou supérieur | Fournir le runtime du CLI.
ESM | Utiliser le système de modules moderne de Node.js.
commander | Définir la commande et ses options sans construire manuellement le parseur d’arguments.
Vitest | Exécuter les tests et produire les snapshots.
pnpm workspaces | Gérer les deux packages dans le même dépôt.
tsc | Compiler les packages sans ajouter de bundler dans la première version.

Un parseur Markdown n’est pas encore nécessaire
Les règles de la première tranche ne nécessitent pas d’arbre syntaxique complet. Le fichier peut être analysé comme du texte brut, ligne par ligne, avec une reconnaissance minimale des titres commençant par #.
Cette approche suffit pour mesurer la longueur, identifier les sections, rechercher du contenu dérivable et détecter certaines formes de secrets en clair.
Une dépendance comme remark ou mdast pourra être ajoutée lorsqu’une règle exigera réellement une analyse syntaxique plus riche.

Définir l’architecture en frontières
Deux packages
Le projet est un monorepo géré par pnpm workspaces. Il contient deux packages dont les responsabilités sont strictement séparées.

Package | Responsabilité | Interdictions
---|---|---
@claudoscope/core | Recevoir des contenus en mémoire, exécuter les règles et retourner des diagnostics typés. | Aucune lecture de fichiers, aucun réseau, aucun accès à process et aucun affichage terminal.
claudoscope | Découvrir les fichiers, les lire, appeler le core, formater la sortie et retourner le code de sortie. | Aucune logique métier propre aux règles.

Le core reçoit un contenu déjà chargé en mémoire :
{
path: "CLAUDE.md",
content: "..."
}

Il retourne une liste typée de diagnostics :
Finding[]

Le modèle d’une règle contient au minimum :
{
id: "identifiant stable",
severity: "warn",
docs: "Description courte de la règle",
check(ctx) {
return [];
}
}

Une frontière préparée pour les surfaces futures
Toute surface future doit consommer @claudoscope/core :
Action de CI
plugin Claude Code
extension d'éditeur
serveur LSP
autre CLI

Le core ne doit jamais dépendre de l’une de ces surfaces.
Les deux packages vivent dans le workspace, mais seul le package claudoscope est destiné à une publication directe.

Définir la première tranche verticale
Un flux complet
La première tranche doit faire fonctionner le chemin principal de bout en bout :

Commande claudoscope scan
↓
Découverte de CLAUDE.md
↓
Lecture par le CLI
↓
Analyse par @claudoscope/core
↓
Exécution des règles
↓
Rapport texte ou JSON
↓
Code de sortie

Cette tranche ne se limite pas à construire le moteur ou le parseur de commande. Elle doit relier les entrées, l’analyse, les sorties et la validation.

Le premier jeu de règles
Règle | Signal recherché
---|---
Longueur totale excessive | Le fichier contient un volume trop important d’instructions persistantes.
Section démesurée | Une section concentre une quantité anormale de contenu.
Contenu dérivable du code | Le fichier recopie une information qui peut être retrouvée dans le dépôt, comme une arborescence complète.
Secret en clair | Le contenu présente un motif susceptible de contenir une information sensible.

Les seuils sont des constantes dans le code de la première version. Ils pourront être ajustés après les premiers retours, sans introduire immédiatement un système complet de configuration.

Deux fixtures de dépôt
La validation repose sur deux petits dépôts de test :

Fixture | Contenu attendu
---|---
fixtures/sain | Un fichier CLAUDE.md qui ne déclenche aucun diagnostic bloquant.
fixtures/fautif | Un fichier qui déclenche les diagnostics attendus.

Les sorties texte et JSON sont enregistrées sous forme de snapshots. Les codes de sortie sont également vérifiés.

Conserver les alternatives écartées
Comparer les options avant de les rejeter
Une alternative n’est pas écartée parce qu’elle est mauvaise en elle-même. Elle est écartée parce que son compromis correspond moins bien aux contraintes de la première livraison.

Alternative | Avantage | Raison du rejet
---|---|---
Moteur LLM ou hybride | Analyse sémantique plus riche. | Perte de déterminisme, coût par exécution, clé d’API obligatoire et sorties difficiles à stabiliser par snapshot.
Go ou Rust | Production d’un binaire autonome avec un démarrage rapide. | La cible dispose déjà de Node.js et la vitesse de développement serait plus faible pour l’équipe.
oclif | Framework complet pour construire des CLI complexes. | Surdimensionnement pour une première version contenant une seule commande.
remark, mdast et remark-lint | Arbre syntaxique robuste et écosystème de règles existant. | Les règles initiales fonctionnent sur des lignes et des titres, tandis que la cible du produit doit ensuite devenir multi-format.
tsup | Bundling et configuration de publication simplifiés. | tsc suffit pour un package Node.js pur et évite une dépendance supplémentaire.
Action GitHub ou plugin Claude Code comme première surface | Distribution visible et intégration directe à un workflow. | Couplage à un écosystème avant d’avoir prouvé la valeur du catalogue de règles.
Un seul package avec frontière interne | Outillage initial plus léger. | La frontière entre moteur pur et entrées-sorties ne serait pas opposable, alors que plusieurs surfaces sont envisagées.

Formuler les invariants d’architecture
Des règles courtes destinées au futur CLAUDE.md
Les invariants sont formulés de manière concise afin de pouvoir être repris ensuite dans la mémoire du projet.

@claudoscope/core ne fait aucune I/O : fonctions pures, contenus vers findings.
L'outil ne modifie jamais les fichiers analysés.
Aucune requête réseau et aucune clé d'API.
Le même input produit toujours le même output.
Chaque règle possède un identifiant stable, une sévérité, une documentation courte et des
Chaque règle est testée sur une fixture saine et une fixture fautive avant fusion.
Les surfaces dépendent du core ; le core ne dépend d'aucune surface.

Ces invariants ne décrivent pas une implémentation particulière. Ils définissent ce qui doit rester vrai pendant toute l’évolution du projet.

Définir les gates de validation
Une preuve observable par phase
Le document ne se contente pas d’annoncer que le projet devra être testé. Il associe chaque phase à une preuve concrète.

Gate | Preuve de fermeture
---|---
Core minimal | Un test Vitest vert exécute une règle sur un contenu en mémoire et obtient le diagnostic attendu.
CLI branché | claudoscope scan fixtures/fautif affiche un diagnostic et retourne 1, tandis que fixtures/sain retourne 0.
Jeu de règles initial | Les snapshots texte et JSON restent stables sur les deux fixtures et --fail-on est vérifié.
Dogfooding | L’outil analyse son propre dépôt sans planter et le fichier CLAUDE.md du projet passe le scan.
Publication, hors première version | npx claudoscope fonctionne depuis un dépôt tiers vierge.

La dernière gate est volontairement indiquée comme hors première version. Elle conserve la cible de distribution sans l’introduire dans la première tranche verticale.

Fermer les questions ouvertes
Ne pas conserver de faux consensus
La section des questions ouvertes doit contenir tout choix encore non tranché. Si une inconnue importante subsiste, le verdict final ne doit pas automatiquement être positif.
Dans cette session, toutes les questions structurantes ont été résolues :
périmètre de la première version
commande principale
moteur d'analyse
configuration
licence visée
emplacement du CLAUDE.md principal
formats de sortie
codes de sortie
stack
architecture

La section indique donc qu’aucune question ouverte ne bloque la création du dépôt.

Donner le go avant l’écriture
La dernière gate de cadrage
Le document complet est relu dans la conversation. Tant qu’il n’est pas validé, aucun fichier ne doit apparaître dans le dossier.
Une fois le contenu accepté, la consigne finale reste volontairement courte :

Go. Écris maintenant uniquement le fichier design-doc.md avec le contenu validé.
Ne crée aucun autre fichier.

Claude Code doit alors effectuer une seule modification : créer design-doc.md.
Il ne doit pas anticiper la suite en ajoutant un package.json, un README.md, un tsconfig.json ou une arborescence de packages.

Résultat final
# claudoscope - Design Doc
## 1. Contexte
Le comportement d'un agent Claude Code dans un dépôt est encadré par des fichiers de conf
Ces fichiers dérivent facilement : trop longs, permissions trop larges, configurations fra
Claudoscope est un linter déterministe pour ces fichiers, sur le modèle d'ESLint : des règ
Décisions issues de l'interview : moteur déterministe pur, surface CLI d'abord, usage inte
## 2. Objectifs / Non-objectifs
### Objectifs
- Linter déterministe et reproductible : même entrée, même sortie, sans réseau ni clé d'AP
- CLI utilisable localement et comme gate de CI dès la première version, avec un code de s
- Première version limitée aux règles `CLAUDE.md`, avec un pipeline générique `découverte
- Publication open source visée sous licence MIT, après une première utilisation interne.
### Non-objectifs de la première version
- Pas de jugement par LLM ni de moteur hybride.
- Pas d'auto-fix : l'outil reste en lecture seule.
- Pas de fichier de configuration utilisateur : toutes les règles sont actives avec leur s
- Pas d'analyse de `.claude/settings.json`, `.mcp.json` ou `.claude/rules/`.
- Pas de GitHub Action ni de plugin Claude Code comme première surface.
## 3. Design
### Surface produit
Une commande :
`claudoscope scan [chemin]`
Le chemin utilise le répertoire courant par défaut.
Le fichier `CLAUDE.md` principal est recherché dans cet ordre :
1. `./CLAUDE.md`
2. `.claude/CLAUDE.md`
La sortie terminal contient le fichier, la ligne, la règle, la sévérité et le message.
Options initiales :
- `--format json`
- `--fail-on error|warn`, avec `error` par défaut
Codes de sortie :
- `0` : aucun finding au-delà du seuil
- `1` : au moins un finding atteint le seuil
- `2` : erreur d'exécution
L'outil n'écrit jamais dans le dépôt analysé.
### Stack
- TypeScript strict
- Node.js 20 ou supérieur
- ESM
- `commander` pour le CLI
- `Vitest` pour les tests, les fixtures de mini-dépôts et les snapshots
- `pnpm workspaces`
- compilation avec `tsc` uniquement
Le Markdown est analysé comme du texte brut, à partir des lignes et des titres `#`, sans d
### Architecture en frontières
Monorepo `pnpm workspaces` avec deux packages.
#### `@claudoscope/core`
Package pur, sans I/O : aucun accès à `fs`, au réseau ou à `process`.
Il reçoit des contenus en mémoire sous la forme `{ path, content }`, exécute les règles et
Modèle de règle :
`{ id stable, severity, docs une ligne, check(ctx) -> Finding[] }`
#### `claudoscope`
Le CLI assure :
- la découverte des fichiers ;
- la lecture avec `fs` ;
- l'invocation du core ;
- le rendu texte ou JSON ;
- les codes de sortie.
La frontière constitue le contrat : toute surface future, comme une Action CI, un plugin C
Les deux packages vivent dans le workspace. Seul `claudoscope` est destiné à une publicat
### Première tranche verticale
`claudoscope scan` est exécuté sur un dépôt contenant un fichier `CLAUDE.md`.
Le jeu de règles initial contient :
- longueur totale excessive ;
- section démesurée ;
- contenu dérivable du code, comme une arborescence recopiée ;
- secret en clair.
Les seuils sont des constantes du code, ajustables par itération.
La tranche comprend deux fixtures, un dépôt sain et un dépôt fautif, des snapshots texte e
## 4. Alternatives écartées
- **Moteur LLM ou hybride** : puissance sémantique contre perte du déterminisme, coût par
- **Go ou Rust avec un binaire unique** : démarrage instantané contre utilité limitée pour
- **oclif** : richesse du framework contre surdimensionnement pour une commande unique.
- **remark, mdast et l'écosystème remark-lint** : AST robuste et règles existantes contre
- **tsup** : bundling clé en main contre une dépendance supplémentaire alors que `tsc` suf
- **Action GitHub ou plugin Claude Code comme première surface** : distribution séduisante
- **Mono-package avec frontière interne** : outillage plus léger contre frontière non oppo
## 5. Invariants d'architecture
- `@claudoscope/core` ne fait aucune I/O : fonctions pures, contenus vers findings.
- L'outil ne modifie jamais les fichiers analysés.
- Aucune requête réseau et aucune clé d'API.
- Déterminisme : même entrée, même sortie, garanti par snapshots.
- Chaque règle possède un identifiant stable, une sévérité, une documentation d'une ligne
- Les surfaces dépendent du core ; le core ne dépend d'aucune surface.
## 6. Gates de validation
1. **Core minimal** : un test Vitest vert exécute une règle sur un contenu en mémoire et p
2. **CLI branché** : `claudoscope scan fixtures/fautif` affiche le finding et retourne `1
3. **Jeu de règles initial** : les snapshots texte et JSON restent stables sur les deux f
4. **Dogfooding** : l'outil analyse son propre dépôt sans planter et le fichier `CLAUDE.md
5. **Publication, hors première version** : `npx claudoscope` fonctionne depuis un dépôt t
## 7. Questions ouvertes
Aucune à ce stade. Toutes les questions soulevées pendant la session ont été tranchées : p
## 8. Verdict final
**Prêt pour création du dépôt : oui.**
