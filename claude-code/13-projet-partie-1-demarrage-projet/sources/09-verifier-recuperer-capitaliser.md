Claude Code 13. Projet partie 1 : démarrage d'un pro… 9. Vérifier, récupérer et capitaliser

Les trois premières phases de la tranche verticale ont été implémentées dans le commit précédent. Le core contient maintenant le parseur Markdown minimal, les règles MEM001, MEM002 et MEM003, ainsi que leur registre. Le CLI lit un fichier, appelle le moteur, produit les formats text et json, applique --fail-on et retourne les codes de sortie 0, 1 ou 2.

La phase 4 ne doit pas ajouter une nouvelle fonctionnalité. Elle doit verrouiller le comportement déjà construit avec des fixtures permanentes, des snapshots, un test de dogfooding et un smoke test E2E exécutant le binaire réel.

Cette phase transforme un comportement fonctionnel en contrat de non-régression. Elle doit prouver les gates 3 et 4 du design doc sans modifier le moteur ni la logique du CLI.

Reprendre connaissance de l’implémentation existante
Demander des spécifications avant un plan d’implémentation
La session commence par une demande courte. Claude Code doit lire le dernier commit, comprendre l’implémentation des phases 1 à 3, puis proposer les spécifications de la phase 4.

Les phases un, deux et trois ont été implémentées dans le commit précédent.
Prends connaissance de ce commit et propose-moi des specs pour la phase quatre.
Si tu as des recommandations, pose-moi des questions.

Claude Code consulte le dernier commit et les fichiers principaux du core et du CLI. Cette lecture lui permet de construire la phase 4 à partir des contrats réels, et non à partir d’une version théorique du plan.

Points d’appui dans l’existant
L’exploration confirme plusieurs propriétés qui structurent la future validation.

Élément existant | Conséquence pour la phase 4
---|---
runScan(file, options) retourne { output, exitCode } sans écrire directement dans le terminal. | Les sorties et codes de retour peuvent être testés directement, sans lancer un processus pour chaque cas.
Les rendus texte et JSON produisent des chaînes déterministes terminées par \n. | Les sorties peuvent être verrouillées avec des snapshots.
Le registre exécute les règles dans l’ordre MEM001, MEM002, MEM003. | L’ordre des findings dans les snapshots et dans le test du binaire doit rester stable.
parseMarkdown normalise les fins de ligne et ne compte pas une ligne vide fantôme après la dernière fin de ligne. | Une fixture doit contenir au moins 201 lignes de texte effectives pour déclencher MEM001.
MEM002 ignore une section vide lorsqu’elle sert de conteneur à une sous-section plus profonde. | La section vide des fixtures fautives ne doit pas être suivie par une sous-section.
MEM003 reconnaît les familles command, architecture, verification et verify dans les titres normalisés. | Les titres de la fixture fautive doivent éviter ces fragments, y compris dans des mots plus longs.

La phase 4 peut donc rester entièrement centrée sur les preuves. Aucun changement du core, de scan.ts, de render.ts, de program.ts ou de index.ts n’est nécessaire.

Trancher les choix de validation
Répondre aux questions de cadrage
Avant de rédiger les spécifications, Claude Code pose quatre questions. Elles déterminent la couverture exacte de la phase.

Question | Décision retenue | Raison
---|---|---
Faut-il ajouter une troisième fixture contenant uniquement des avertissements pour tester --fail-on ? | Oui, trois fixtures. | Une fixture contenant une erreur ne permet pas de prouver que le seuil warn change réellement le code de sortie.
Où placer les fixtures ? | packages/cli/fixtures/. | Elles valident le comportement public du CLI, ses formats et ses codes de sortie.
Comment matérialiser le dogfooding ? | Avec un test Vitest permanent. | Toute dérive future du fichier CLAUDE.md doit casser automatiquement la gate.
Faut-il tester le binaire réel en plus des tests de runScan ? | Oui, avec un smoke test E2E. | Les tests directs ne couvrent ni le fichier compilé, ni le point d’entrée, ni la propagation réelle des codes de sortie.

Ces décisions permettent de distinguer trois niveaux de validation :
runScan directement
↓
comportement fonctionnel, sorties et seuils

dogfooding avec runScan
↓
conformité permanente du propre CLAUDE.md du projet

binaire compilé avec execFile
↓
point d'entrée réel, stdout, stderr et codes 0, 1, 2

Définir le périmètre de la phase 4
Verrouiller les gates 3 et 4
La phase 4 doit produire quatre preuves principales :
Verrouiller les sorties text et json avec des snapshots.
Prouver le comportement de --fail-on dans les deux sens.
Rendre le dogfooding permanent.
Exécuter le binaire compilé dans un smoke test E2E.

Elle ne doit ajouter que :
des fixtures ;
des tests ;
des snapshots ;
un fichier .gitattributes ;
un ajustement du script test ;
une mise à jour de la commande documentée dans CLAUDE.md.

Ce qui reste inchangé
packages/core/**
packages/cli/src/scan.ts
packages/cli/src/render.ts
packages/cli/src/program.ts
packages/cli/src/index.ts

Une modification de ces fichiers indiquerait soit une régression découverte par les tests, soit une dérive de périmètre. La phase n’a pas pour objectif de refactoriser une logique qui fonctionne déjà.

Créer trois fixtures permanentes
Organisation des fixtures
Les fixtures sont placées dans packages/cli/fixtures/. Chaque dossier contient un seul fichier CLAUDE.md.

packages/cli/fixtures/
├── sain/
│ └── CLAUDE.md
├── fautif/
│ └── CLAUDE.md
└── avertissements/
└── CLAUDE.md

Les trois fichiers représentent trois situations produit distinctes :

Fixture | Contenu | Findings attendus
---|---|---
sain | Au plus 200 lignes, avec des sections documentées consacrées à l’architecture, aux commandes et à la vérification. | Aucun finding.
fautif | Au moins 201 lignes, une section vide non conteneur et aucune section appartenant aux trois familles exigées. | MEM001, MEM002, puis MEM003.
avertissements | Au moins 201 lignes, une section vide et une structure contenant les sections minimales attendues. | MEM001 et MEM002 uniquement.

Fixture saine
La fixture saine reste courte, environ une trentaine de lignes. Elle contient notamment les titres suivants :
## Architecture
## Commandes
## Vérification

Toutes les sections sont documentées. Le fichier contient également un bloc de code comprenant une ligne qui ressemble à un titre Markdown :
```bash
# commentaire
pnpm run test
```
Cette ligne exerce la gestion des fences sur la chaîne complète. Elle ne doit créer ni section ni finding.

Le comportement attendu est strict :
output text : chaîne vide
findings JSON : liste vide
exitCode : 0

Fixture fautive
La fixture fautive doit déclencher les trois règles dans l’ordre du registre.
Elle contient au moins 201 lignes de texte effectives. Son remplissage peut utiliser des paragraphes numérotés. Le corps du texte n’influence pas MEM003, qui inspecte uniquement les titres.

Les titres doivent rester volontairement neutres :
## Bloc-notes
## Contexte
## Historique
## Divers

Aucun titre ne doit contenir les fragments :
command
architecture
verification
verify

Un titre comme Recommandations est donc interdit dans cette fixture, car il contient le fragment command et pourrait satisfaire accidentellement une partie de MEM003.

La dernière section est vide et ne sert pas de conteneur :
## Notes

Les findings attendus sont :
Ordre | Règle | Sévérité | Position
---|---|---|---
1 | MEM001 | warn | Ligne 201.
2 | MEM002 | warn | Ligne du titre Notes.
3 | MEM003 | error | Sans ligne, car le finding concerne la structure globale.

Fixture contenant seulement des avertissements
La fixture avertissements est indispensable pour tester le seuil --fail-on.
Elle reprend les deux problèmes non bloquants de la fixture fautive :
plus de 200 lignes ;
une section vide non conteneur.

Elle contient cependant les sections structurelles attendues, notamment une section Architecture documentée. Elle ne déclenche donc pas MEM003.

Findings :
MEM001
MEM002
Avec --fail-on error :
exitCode 0
Avec --fail-on warn :
exitCode 1

Cette fixture constitue la preuve directe que le seuil modifie la décision d’échec sans modifier les findings affichés.

Stabiliser les fins de ligne des fixtures
Ajouter .gitattributes
Les fixtures doivent produire le même nombre de lignes et les mêmes snapshots sous Windows, Linux et macOS.
Le parseur normalise déjà CRLF et LF. Les rendus utilisent déjà \n. Un fichier .gitattributes est toutefois ajouté à la racine pour figer les fixtures octet par octet.

packages/cli/fixtures/** text eol=lf

Cette règle constitue une protection supplémentaire. Elle limite les variations des fichiers de référence entre les environnements et les outils Git.

Construire la matrice de tests fonctionnels
Tester directement runScan
La matrice principale est placée dans :
packages/cli/src/fixtures.test.ts

Les tests appellent directement runScan(). Aucun processus enfant n’est lancé pour cette matrice.
const result = await runScan(
"packages/cli/fixtures/fautif/CLAUDE.md",
{
format: "text",
failOn: "error"
}
);

Les chemins sont passés au format relatif POSIX, par exemple :
packages/cli/fixtures/sain/CLAUDE.md
packages/cli/fixtures/fautif/CLAUDE.md
packages/cli/fixtures/avertissements/CLAUDE.md

runScan réutilise ce chemin dans la sortie. L’utilisation de chemins relatifs rend donc les snapshots portables.

Le test documente l’hypothèse suivante : le répertoire courant de Vitest est la racine du dépôt, où se trouve vitest.config.ts.

Matrice des neuf cas
Fixture | Format | fail-on | Assertion
---|---|---|---
sain | text | error | output === "" par assertion directe et code 0.
sain | json | error | snapshot contenant une liste vide et code 0.
sain | text | warn | Code 0.
fautif | text | error | snapshot et code 1.
fautif | json | error | snapshot et code 1.
fautif | text | warn | Code 1, car la présence de MEM003 suffit déjà à faire échouer le scan.
avertissements | text | error | snapshot montrant les avertissements et code 0.
avertissements | text | warn | Code 1. Ce cas prouve que le seuil agit.
avertissements | json | error | snapshot et code 0.

Utiliser des snapshots externes
Les snapshots sont enregistrés dans un fichier dédié et commité :
packages/cli/src/__snapshots__/fixtures.test.ts.snap

Ils ne sont pas placés en ligne dans le fichier de test.

Ces sorties de référence doivent verrouiller :
le format texte ;
le format JSON ;
les chemins affichés ;
l'ordre MEM001, MEM002, MEM003 ;
les lignes ;
les sévérités ;
les messages.

Un changement de snapshot doit être relu comme une modification du contrat produit, pas accepté automatiquement.

Rendre le dogfooding permanent
Scanner le vrai fichier CLAUDE.md
Le test de dogfooding est placé dans :
packages/cli/src/dogfooding.test.ts

Il doit scanner le fichier CLAUDE.md réel du dépôt. Son chemin est résolu depuis le fichier de test et ne dépend pas du répertoire courant.

const claudeMd = fileURLToPath(
new URL("../../../CLAUDE.md", import.meta.url)
);
const result = await runScan(claudeMd, {
format: "text",
failOn: "error"
});

Le test ne doit pas seulement vérifier que le fichier ne dépasse pas le seuil d’échec. Il doit confirmer l’absence totale de finding.

expect(result.exitCode).toBe(0);
expect(result.output).toBe("");

Cette distinction est importante : un fichier contenant uniquement des avertissements pourrait retourner 0 avec failOn: "error". L’assertion sur la sortie vide garantit que le propre fichier du projet reste entièrement conforme.

Ne pas utiliser de snapshot pour un chemin absolu
Le test de dogfooding n’utilise pas de snapshot. La sortie pourrait contenir un chemin absolu propre à la machine, donc non portable.

Le contrat est exprimé par des assertions directes :
exitCode === 0
output === ""

Le fichier actuel contient environ quarante lignes et des sections documentées consacrées notamment à l’architecture et aux commandes. Toute dérive future doit faire échouer ce test.

Ajouter un smoke test du binaire compilé
Pourquoi les tests de runScan ne suffisent pas
La matrice de fixtures valide la logique de scan, mais elle ne lance pas le fichier compilé dist/index.js.
Elle ne couvre donc pas directement :
le point d'entrée réel ;
le package compilé ;
le parsing des arguments par commander ;
la sortie réelle vers stdout ;
la sortie réelle vers stderr ;
la propagation du code de sortie au processus.

Un smoke test E2E complémentaire est ajouté dans :
packages/cli/src/e2e.test.ts

Lancer le binaire avec le runtime courant
Le test résout le chemin du fichier compilé depuis son propre emplacement.

const cli = fileURLToPath(
new URL("../dist/index.js", import.meta.url)
);

Le processus est lancé avec process.execPath. Cette approche utilise le même runtime Node.js que le processus de test et reste portable sous Windows.

execFile(process.execPath, [
cli,
"scan",
fixture
]);

Normaliser le résultat d’execFile
execFile rejette la promesse lorsqu’un processus se termine avec un code non nul. Or les codes 1 et 2 sont des résultats attendus dans deux des trois cas.
Le test utilise donc un helper local qui retourne toujours une structure exploitable :

async function runCli(
args: readonly string[]
): Promise<{
stdout: string;
stderr: string;
code: number;
}> {
// Exécute le binaire avec execFile.
// En cas de code non nul, récupère stdout, stderr et le code
// depuis l'erreur au lieu de laisser le test échouer immédiatement.
}

Un délai de test plus élevé, par exemple quinze secondes, peut être utilisé. Le démarrage d’un processus Node.js enfant peut être plus lent sous Windows.

Tester les trois codes de sortie
Le smoke test couvre un cas par code de sortie.

Cas | Commande | Assertion
---|---|---
Code 0 | scan sur la fixture saine. | stdout vide et code 0.
Code 1 | scan sur la fixture fautive avec --format json. | JSON.parse(stdout) réussit et les identifiants sont MEM001, MEM002, MEM003.
Code 2 | scan avec --format yaml. | stderr contient un message indiquant que le format est invalide.

expect(
JSON.parse(result.stdout).findings.map(
(finding: { ruleId: string }) => finding.ruleId
)
).toEqual([
"MEM001",
"MEM002",
"MEM003"
]);

Les chemins des fixtures transmis au binaire sont résolus en chemins absolus depuis le fichier de test. Le processus enfant ne dépend donc d’aucune hypothèse sur son répertoire courant.

Garantir que le binaire existe avant les tests
Modifier le script racine
Le smoke test E2E exécute packages/cli/dist/index.js. Le build doit donc être terminé avant le lancement de Vitest.

Le script test de la racine est rendu explicite :

{
"scripts": {
"test": "pnpm run build && vitest run"
}
}

Le test ne repose pas sur un hook implicite. Le script porte directement son prérequis : construire les packages, puis lancer les tests.

Aligner CLAUDE.md
La commande documentée dans CLAUDE.md doit refléter ce nouveau comportement.
pnpm run test # construit les packages puis lance vitest sur le monorepo

Cette modification évite qu’un agent futur interprète le script comme une simple exécution de Vitest.

Produire le plan d’implémentation
Conserver le plan hors du dépôt
Une fois les spécifications validées, Claude Code lance son agent de planification. Le plan est enregistré dans le dossier utilisateur de Claude Code, sous ~/.claude/plans/.

Ce fichier n’est pas ajouté au dépôt. Il sert à guider la future implémentation de la phase 4.

Rappeler le contexte du plan
Le plan commence par résumer l’état du projet :
Dernière phase de la tranche verticale.
Phases 1 à 3 déjà implémentées.
Parseur, règles MEM001 à MEM003 et CLI scan complets.
Aucune modification de logique attendue.
La phase ajoute uniquement fixtures, tests, snapshots et ajustement du script test.

Il rappelle également les contrats sur lesquels la phase s’appuie :
runScan retourne output et exitCode.
Les rendus sont déterministes.
L'ordre des findings suit le registre.
Le parser normalise les fins de ligne.
MEM002 connaît l'exception des sections conteneurs.
MEM003 compare des titres normalisés.

Fichiers prévus par le plan
Nouveaux fichiers
packages/cli/fixtures/sain/CLAUDE.md
packages/cli/fixtures/fautif/CLAUDE.md
packages/cli/fixtures/avertissements/CLAUDE.md
.gitattributes
packages/cli/src/fixtures.test.ts
packages/cli/src/__snapshots__/fixtures.test.ts.snap
packages/cli/src/dogfooding.test.ts
packages/cli/src/e2e.test.ts

Fichiers modifiés
Fichier | Modification
---|---
package.json | Le script test devient pnpm run build && vitest run.
CLAUDE.md | Le commentaire de la commande pnpm run test indique que le build précède les tests.

Fichiers explicitement non modifiés
packages/core/**
packages/cli/src/scan.ts
packages/cli/src/render.ts
packages/cli/src/program.ts
packages/cli/src/index.ts

La phase 4 ne doit donc modifier ni les règles, ni le parseur, ni le rendu, ni l’implémentation de la commande.

Ordre d’exécution prévu
Étapes du plan
1. Créer les trois fixtures et .gitattributes.
2. Créer fixtures.test.ts et générer les snapshots.
3. Relire le fichier .snap comme un livrable produit.
4. Créer dogfooding.test.ts.
5. Créer e2e.test.ts.
6. Modifier le script test racine.
7. Mettre à jour la commande dans CLAUDE.md.
8. Exécuter toutes les validations.

La première génération des snapshots ne ferme pas automatiquement la gate. Le fichier produit doit être inspecté pour confirmer que les sorties deviennent bien le contrat souhaité.

Vérifications prévues
Valider les snapshots
pnpm run test
pnpm run test

Deux exécutions consécutives doivent produire les mêmes snapshots. La seconde exécution ne doit modifier aucun fichier de référence.
La matrice doit notamment prouver :
avertissements + fail-on error -> code 0
avertissements + fail-on warn -> code 1

Valider le dogfooding et le binaire
La chaîne complète est ensuite validée avec :
pnpm run test
pnpm run typecheck
pnpm run lint

Le dogfooding doit rester vert. Le smoke test E2E doit exécuter le binaire compilé et observer les codes 0, 1 et 2.

Vérifier manuellement la forme du produit
pnpm run claudoscope scan CLAUDE.md
Cette commande ne remplace pas les tests. Elle permet de contrôler manuellement la forme du comportement utilisateur après l’exécution de la phase.

Connaître le piège du test isolé
Le test E2E dépend du contenu de dist. Exécuter directement vitest run sans build préalable peut donc faire échouer uniquement ce test.
Ce comportement est attendu. La commande de référence du projet devient :
pnpm run test
Elle construit le projet avant d’exécuter les tests.

Critères d’acceptation de la phase
Gate 3 : sorties et seuils verrouillés
pnpm run test passe.
Les snapshots text et JSON sont commités.
Deux exécutions consécutives produisent les mêmes snapshots.
Les findings apparaissent dans l'ordre MEM001, MEM002, MEM003.
La fixture avertissements retourne 0 avec fail-on error.
La fixture avertissements retourne 1 avec fail-on warn.

Gate 4 : dogfooding et binaire réel
Le test permanent de dogfooding passe.
Le vrai CLAUDE.md produit zéro finding.
Le binaire compilé est exécuté par le smoke test.
Le cas sain retourne 0.
Le cas fautif retourne 1.
Le format invalide retourne 2.
Le typecheck et le lint restent verts.
Aucun fichier du core n'est modifié.
