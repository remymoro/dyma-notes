Claude Code 13. Projet partie 1 : démarrage d'un pro… 7. Planifier par phases avec des gates vérifiables

Le dépôt Claudoscope possède maintenant son socle technique, sa mémoire projet et sa politique de permissions. Les frontières d’architecture sont explicites et les commandes de validation sont disponibles.

La prochaine étape n’est pas encore l’implémentation. La première tranche verticale traverse plusieurs responsabilités : parsing du fichier CLAUDE.md, exécution des règles, lecture du fichier par le CLI, rendu des diagnostics, codes de sortie, fixtures, snapshots et dogfooding.

Avant de modifier le code, il faut donc produire deux niveaux de planification :

Niveau | Livrable | Objectif
---|---|---
Plan de la tranche | tranche-verticale.md | Définir les phases, leur ordre et leurs jalons.
Plan de la première phase | Plan d’implémentation du parsing Markdown | Trancher les comportements précis du parseur avant d’écrire le code.

Le premier plan organise le flux complet. Le second transforme la première phase en contrat d’implémentation testable.

Créer le plan de la tranche verticale
Commencer par un plan macroscopique
Le premier plan doit rester descriptif. Il ne doit pas encore contenir les signatures exactes des fonctions, le détail des algorithmes ou le code des règles.

Son rôle est de fixer :
l'ordre des phases ;
le périmètre de chaque phase ;
les livrables attendus ;
les validations associées ;
les limites de la première tranche ;
la condition de passage à la phase suivante.

La demande adressée à Claude Code peut être formulée ainsi :
Nous allons maintenant planifier la première tranche verticale de Claudoscope.
Appuie-toi sur :
- design-doc.md ;
- le socle actuel ;
- CLAUDE.md ;
- .claude/rules/ ;
- les permissions du projet.
Ne commence aucune implémentation.
Prépare un plan qui décrit :
- l'ordre des phases ;
- le périmètre de chaque phase ;
- les livrables ;
- les jalons de validation ;
- les éléments explicitement exclus.
Le plan devra ensuite être enregistré dans un fichier tranche-verticale.md
à la racine du dépôt.

Conserver les décisions déjà prises
Le plan reprend les décisions structurantes issues du cadrage et des arbitrages précédents.

Décision | Application dans la tranche
---|---
Commencer par le core | Le parsing et les règles sont construits avant le branchement complet du CLI.
Construire ensuite le CLI de bout en bout | La lecture du fichier, le rendu et les codes de sortie utilisent un moteur déjà testé.
Terminer par les fixtures et le dogfooding | La tranche est validée sur des dépôts de test puis sur le propre fichier CLAUDE.md du projet.
Parsing Markdown minimal | Un module interne au core, sans remark, mdast ou autre dépendance de parsing.
Trois règles initiales | MEM001, MEM002 et MEM003.
Entrée du CLI | Un chemin de fichier, sans découverte de répertoire dans cette tranche.
Sorties | Formats text et json, option --fail-on et codes de sortie 0, 1 ou 2.

Découper la tranche en quatre phases
Phase 1 : parsing Markdown minimal
La première phase ajoute au core un module capable de transformer le contenu brut d’un fichier CLAUDE.md en lignes et en sections.

Entrée :
contenu Markdown en mémoire.
Sortie :
lignes normalisées ;
prologue ;
sections ;
niveau de chaque en-tête ;
titre ;
numéro de ligne.

Contraintes :
module pur ;
aucune I/O ;
aucune dépendance de parsing ;
aucune règle métier ;
module interne au core.

Le parseur doit fournir aux règles les informations structurelles dont elles ont besoin, sans décider lui-même si une section est vide ou si la structure du document est correcte.

Phase 2 : règles MEM001 à MEM003
La deuxième phase consomme le parseur pour implémenter le premier registre de règles.

Règle | Comportement retenu pour la tranche | Sévérité
---|---|---
MEM001 | Signaler un fichier de plus de 200 lignes. | warn
MEM002 | Signaler une section vide. | warn
MEM003 | Signaler l’absence de la structure minimale attendue. | error

La structure minimale de MEM003 exige au moins une section relative aux commandes, une section d’architecture et une section de vérification.

Les comparaisons exactes, les variantes de titres acceptées et les cas limites doivent être explicités dans les spécifications de cette phase.

Phase 3 : CLI de bout en bout
La troisième phase relie la surface terminal au moteur.

Entrée :
chemin d'un fichier passé à claudoscope scan.
Traitement :
lecture du fichier ;
construction d'un SourceFile ;
appel de analyze() ;
exécution du registre de règles ;
rendu text ou json ;
calcul du code de sortie.

Le CLI ne recherche pas encore automatiquement un fichier dans un répertoire. Il reçoit directement un chemin de fichier.
Le contrat retenu est le suivant :

Situation | Comportement
---|---
Fichier sain | Rapport sans erreur bloquante et code de sortie 0.
Finding atteignant le seuil --fail-on | Rapport affiché et code de sortie 1.
Erreur d’exécution | Message d’erreur et code de sortie 2.
Fichier absent | Message indicatif et code de sortie 0 pour cette tranche.

Phase 4 : fixtures, snapshots et dogfooding
La dernière phase ferme la tranche par des preuves complètes.

Deux fixtures :
- dépôt sain ;
- dépôt fautif.
Validations :
- snapshots de la sortie text ;
- snapshots de la sortie json ;
- vérification de --fail-on ;
- vérification des codes de sortie ;
- exécution sur le CLAUDE.md du projet.

La tranche atteint alors les gates fonctionnelles du design doc : moteur testé, CLI branché, registre de règles validé et utilisation de l’outil sur son propre dépôt.

Écrire tranche-verticale.md
Un document de pilotage, pas une spécification de code
Après relecture du plan macroscopique, Claude Code crée le fichier suivant à la racine :
tranche-verticale.md
Il se trouve au même niveau que design-doc.md.

Le document commence par un préambule qui rappelle :
la cible fonctionnelle ;
les gates du design doc ;
le dogfooding attendu ;
la pureté du core ;
le déterminisme ;
l'absence de dépendance de parsing.

Chaque phase contient ensuite les mêmes rubriques :

Rubrique | Contenu
---|---
Objectif | Le résultat que la phase doit produire.
Périmètre | Ce qui appartient à la phase et ce qui en est exclu.
Livrables | Modules, tests, fixtures ou comportements attendus.
Jalon de fin | La preuve observable permettant de fermer la phase.

Le niveau de détail reste descriptif. Le document ne fixe pas encore les signatures exactes, l’implémentation des fonctions ou le contenu complet des tests. Ces décisions sont prises au début de chaque phase.

Préparer la phase de parsing
Ne pas implémenter avant d’avoir tranché les ambiguïtés
Le fichier tranche-verticale.md indique que la première phase doit parser un document Markdown en lignes et en sections.
Cette formulation reste insuffisante pour écrire un parseur déterministe.

Plusieurs comportements doivent encore être décidés :
Qu'est-ce qu'un en-tête reconnu ?
Comment traiter CRLF et LF ?
Comment traiter un BOM ?
Les titres Setext sont-ils acceptés ?
Comment reconnaître les blocs de code ?
Que faire d'un bloc de code non fermé ?
Où se termine une section ?
Que devient le contenu avant le premier titre ?
Le parseur est-il public ou interne ?
Quels cas limites doivent être testés ?

Une implémentation commencée avant ces décisions encoderait implicitement des choix produit dans une expression régulière ou dans une boucle. Ces choix seraient ensuite difficiles à distinguer de simples détails techniques.

Utiliser un agent d’exploration en fork
Claude Code délègue l’analyse de la phase à un agent d’exploration en fork. Cet agent parcourt le socle, le design doc, tranche-verticale.md et les types existants, puis revient avec les décisions encore ouvertes.

Nous allons maintenant détailler uniquement la phase 1 de tranche-verticale.md.
Avant de produire le plan d'implémentation, utilise un agent d'exploration pour :
- relire le core actuel ;
- identifier les contrats déjà existants ;
- rechercher les ambiguïtés du parsing Markdown minimal ;
- lister les cas limites ;
- proposer une recommandation pour chaque choix.
Ne modifie aucun fichier.
Ne commence aucune implémentation.
Distingue les faits du dépôt, les décisions déjà prises et les choix encore ouverts.

Identifier les choix cachés du parseur
Contrat d’entrée et normalisation
L’entrée du parseur est le contenu brut d’un SourceFile, sous forme de chaîne de caractères. Le parseur ne lit jamais le disque.

La première question concerne les fins de ligne. Sous Windows, le texte utilise souvent CRLF, tandis que Linux et macOS utilisent généralement LF. Les deux formes doivent produire la même structure.
Un éventuel BOM au début du fichier ne doit pas empêcher la reconnaissance du premier titre.

Définition d’un en-tête
Plusieurs syntaxes Markdown peuvent représenter un titre. Le parseur doit choisir celles qu’il prenne en charge.

Question | Choix recommandé
---|---
Titres ATX ou titres Setext ? | Uniquement les titres ATX, avec un à six caractères #.
Le caractère # doit-il être suivi d’un espace ? | Oui, d’une espace, d’une tabulation ou de la fin de ligne.
Une indentation est-elle acceptée ? | Jusqu’à trois espaces avant le premier #.
Les caractères # de fermeture sont-ils conservés ? | Non, ils sont retirés du titre.
Le titre est-il normalisé ? | Il est seulement nettoyé aux extrémités. La casse et les accents sont conservés.

La comparaison des titres exigés par MEM003 n’appartient pas au parseur. Elle sera effectuée dans la règle.

Exclusion des blocs de code
Un caractère # placé dans un bloc de code ne doit jamais créer une section.
Le parseur doit donc reconnaître les fences utilisant :
```
~~~

Longueur minimale :
3 caractères identiques.
Indentation maximale :
3 espaces.
Info string :
ignorée.

La fermeture doit utiliser le même caractère que l’ouverture, avec une longueur au moins égale.
Si une fence n’est jamais fermée, tout le reste du fichier reste considéré comme du code. Les titres suivants ne sont donc pas reconnus.
Le code indenté par quatre espaces, sans fence, reste hors du périmètre de cette première version.

Modèle des sections
Le parseur retourne une liste plate de sections, dans l’ordre du document. Il ne construit pas d’arbre de titres imbriqués.

Une section commence à son en-tête et se termine au prochain en-tête reconnu, quel que soit son niveau.

## Installation
texte
### Windows
texte

Résultat :
- section "Installation" ;
- section "Windows".

Cette décision est importante pour MEM002. Une section suivie immédiatement par un autre en-tête est considérée comme vide, même si le second en-tête est d’un niveau inférieur.
Le contenu situé avant le premier en-tête est conservé dans un prologue. Il ne constitue pas une section implicite.

Visibilité du module
Le parseur est un détail interne du core. Seules les règles de la première version doivent le consommer.
Il ne doit donc pas être réexporté depuis packages/core/src/index.ts. L’exposer immédiatement créerait un engagement d’API publique prématuré.

Pureté et déterminisme
La fonction doit rester pure :
même contenu
↓
même structure retournée

Interdictions :
aucune I/O ;
aucun réseau ;
aucun état global ;
aucun cache mutable ;
aucune dépendance de parsing.

Les structures exposées utilisent des propriétés en lecture seule afin de limiter les mutations accidentelles.

Produire le plan d’implémentation de la phase 1
Trancher les décisions de spécification
Les questions remontées par l’agent d’exploration sont intégrées au plan. Les choix retenus sont les suivants.

Zone | Décision
---|---
Fins de ligne | Découpage sur \r?\n, afin que CRLF et LF produisent la même structure.
BOM | Retiré avant le traitement de la première ligne.
Fin de ligne finale | Aucune fin de ligne finale n’est exigée.
Titres | Titres ATX uniquement, niveaux 1 à 6.
Espace après # | Une espace, une tabulation ou la fin de ligne est obligatoire.
Indentation | Jusqu’à trois espaces avant le titre.
Titres Setext | Exclus.
Fences | Backticks ou tildes, au moins trois caractères.
Fence non fermée | Le reste du fichier reste du code.
Sections | Liste plate, fin au prochain titre quel que soit son niveau.
Prologue | Conservé séparément, sans fausse section.
Visibilité | Module interne au core.

Créer uniquement deux fichiers
Le plan de la phase prévoit deux nouveaux fichiers.
packages/core/src/markdown.ts
packages/core/src/markdown.test.ts

Les fichiers existants restent inchangés :
packages/core/src/index.ts
packages/core/src/types.ts
packages/core/src/engine.ts
packages/cli/**

Cette limite protège le périmètre. La phase ne doit ni implémenter les règles, ni modifier l’API publique du core, ni toucher au CLI.

Définir le contrat de markdown.ts
La structure d’une section

/** Une section délimitée par un en-tête ATX, hors blocs de code. */
export interface Section {
readonly level: number;
readonly title: string;
readonly headingLine: number;
readonly lines: readonly string[];
}

Propriété | Signification
---|---
level | Niveau du titre, de 1 à 6.
title | Titre nettoyé, sans les caractères de fermeture.
headingLine | Numéro de ligne indexé à partir de 1, cohérent avec Finding.line.
lines | Contenu compris entre cet en-tête et le suivant, sans inclure l’en-tête.

La vue structurée du document

/** Vue structurée d'un contenu Markdown, produite sans dépendance. */
export interface ParsedMarkdown {
readonly lines: readonly string[];
readonly prologue: readonly string[];
readonly sections: readonly Section[];
}

export function parseMarkdown(content: string): ParsedMarkdown;

Propriété | Utilisation future
---|---
lines | Permet notamment à MEM001 de compter le nombre total de lignes.
prologue | Conserve le contenu précédant le premier titre.
sections | Fournit à MEM002 et MEM003 les titres et contenus dans l’ordre du document.

Le parseur ne décide pas qu’une section est vide. Il expose les lignes brutes de chaque section. La définition de la vacuité appartient à MEM002.
Il ne normalise pas non plus les titres pour MEM003. La comparaison insensible à la casse, aux accents ou aux variantes lexicales appartient à la règle.

Une seule passe sur les lignes
L’implémentation prévue parcourt le document une seule fois.
Elle conserve notamment un état indiquant si la ligne courante se trouve dans une fence :

État de fence :
- caractère d'ouverture : ` ou ~ ;
- longueur de la fence d'ouverture ;
- ouverte ou fermée.

Sur chaque ligne :
si une fence s'ouvre :
entrer dans le bloc de code ;
si une fence compatible se ferme :
sortir du bloc de code ;
si la ligne est dans une fence :
ne pas rechercher de titre ;
sinon, si la ligne contient un titre ATX valide :
fermer la section précédente ;
ouvrir une nouvelle section ;
sinon :
ajouter la ligne au prologue ou à la section courante.

Définir les tests avant l’implémentation
Un test pour chaque décision
Le fichier packages/core/src/markdown.test.ts utilise Vitest et reste placé à côté du module testé.
Les descriptions et commentaires restent en français, conformément aux conventions du projet.
Le plan identifie onze groupes de cas.

Cas | Comportement attendu
---|---
Document nominal | Plusieurs sections de niveaux différents, avec niveaux, titres, lignes et prologue corrects.
CRLF et LF | Structures strictement identiques.
Fichier vide | Aucune section et un prologue cohérent. La représentation exacte de lines est fixée et documentée par le test.
Aucun titre | Tout le contenu appartient au prologue.
Titre dans une fence | Aucune section créée, pour les fences avec backticks, tildes et info string.
Fence non fermée | Les caractères # suivants restent du code.
Titre en dernière ligne | Une section à contenu vide est créée.
Document contenant uniquement des titres | Autant de sections vides que de titres reconnus.
Variantes de titre | #Titre n’est pas reconnu, # seul crée un titre vide, les caractères de fermeture sont retirés et une indentation de trois espaces est acceptée.
BOM | Le premier titre reste reconnu.
Titres dupliqués | Deux sections distinctes sont conservées dans l’ordre.

Ne pas ajouter de snapshots à cette phase
Les snapshots ne sont pas nécessaires pour le parseur. Les tests peuvent comparer directement les structures retournées.
Les snapshots seront introduits plus tard pour les sorties texte et JSON du CLI, lorsque ces formats existeront.

Valider le plan de la phase
Ordre d’exécution prévu
1. Créer packages/core/src/markdown.ts.
2. Ajouter les types Section et ParsedMarkdown.
3. Implémenter parseMarkdown().
4. Créer packages/core/src/markdown.test.ts.
5. Ajouter les onze groupes de cas.
6. Lancer les validations du monorepo.

Commandes de validation
pnpm run typecheck
pnpm run test
pnpm run lint
pnpm run build

Les preuves attendues sont les suivantes :
Validation | Résultat attendu
---|---
pnpm run test | Les nouveaux tests du parseur passent et les trois tests existants restent verts.
pnpm run typecheck | Le code respecte le mode strict, notamment noUncheckedIndexedAccess.
pnpm run lint | Aucune erreur de style ou de qualité statique.
pnpm run build | Le dossier dist est produit.
Inspection de l’API | Le parseur n’apparaît pas dans dist/index.d.ts, puisque src/index.ts reste inchangé.

Résultat de la session
Document créé
tranche-verticale.md
Ce fichier contient les quatre phases de la première tranche, leurs périmètres, leurs livrables et leurs jalons.

Plan de phase prêt
Phase 1 :
parsing Markdown minimal dans packages/core.
Fichiers prévus :
packages/core/src/markdown.ts
packages/core/src/markdown.test.ts
Périmètre :
normalisation des lignes ;
titres ATX ;
exclusion des fences ;
prologue ;
sections plates ;
tests unitaires.
Hors périmètre :
règles MEM ;
exports publics ;
CLI ;
fixtures de dépôts ;
snapshots de sortie ;
dogfooding.

Aucune implémentation encore produite
Le plan contient des signatures et un contrat suffisamment précis pour guider l’implémentation, mais les fichiers markdown.ts et markdown.test.ts ne sont pas encore créés.

La prochaine action pourra donc implémenter uniquement la phase 1, puis s’arrêter dès que ses validations seront vertes.
