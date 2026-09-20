Claude Code 13. Projet partie 1 : démarrage d'un pro… 8. Implémenter sous contrôle et fermer chaque gate

La première phase de la tranche verticale a fixé le parsing Markdown minimal. Le core peut maintenant transformer le contenu brut d’un fichier CLAUDE.md en lignes et en sections, sans lecture du disque, sans dépendance de parsing et sans exposer ce module dans l’API publique.

Les deux phases suivantes transforment cette structure en comportement produit :

Phase | Objectif
---|---
Phase 2 | Implémenter MEM001, MEM002 et MEM003, construire le registre de règles et valider le moteur sur un contenu en mémoire.
Phase 3 | Brancher le CLI sur @claudoscope/core, lire un fichier passé en argument, produire les sorties text et json, puis appliquer les codes de sortie.

La phase 4, consacrée aux fixtures de dépôts, aux snapshots et au dogfooding complet par le CLI, reste volontairement séparée.

Le but de cette session est d’implémenter les phases 2 et 3 sans anticiper la validation finale de la tranche.

Reprendre le contrat produit par la phase 1
Le parseur est une dépendance, pas une responsabilité de la phase 2
Le plan d’implémentation de la phase 2 s’appuie sur la spécification enregistrée dans :
specs/phase-2-regles.md

Cette spécification suppose que le module de parsing existe déjà dans packages/core/src/markdown.ts.

/** Une section délimitée par un en-tête ATX. */
export interface Section {
/** Niveau de l'en-tête, correspondant au nombre de caractères #. */
readonly level: number;
/** Titre nettoyé, sans les caractères # ni les espaces de bord. */
readonly title: string;
/** Ligne de l'en-tête, indexée à partir de 1. */
readonly line: number;
/** Lignes de contenu jusqu'au prochain en-tête ou à la fin. */
readonly contentLines: readonly string[];
}
/** Structure minimale extraite d'un contenu Markdown. */
export interface ParsedMarkdown {
/** Toutes les lignes, sans ligne fantôme après une fin de ligne finale. */
readonly lines: readonly string[];
/** Sections conservées dans l'ordre du document. */
readonly sections: readonly Section[];
}
export function parseMarkdown(content: string): ParsedMarkdown;

Trois propriétés de ce contrat sont indispensables aux règles :
Les fins de ligne CRLF et LF produisent le même nombre de lignes.
Un contenu vide produit lines: [].
Les sections sont retournées dans l'ordre du document.

MEM001 utilise lines pour mesurer le fichier. MEM002 utilise l’ordre et le niveau des sections pour distinguer une section vide d’un titre conteneur. MEM003 utilise les titres pour rechercher la structure minimale.

Vérifier le prérequis avant de continuer
La phase 2 ne doit pas réinventer le parseur. Avant de commencer, vérifiez que la phase 1 est présente et que ses tests passent.
pnpm run test
pnpm run typecheck

Si markdown.ts ou ses tests sont absents, il faut fermer la phase 1 avant de poursuivre. Les règles ne doivent pas embarquer leur propre parsing.

Produire le plan d’implémentation de la phase 2
Demander un plan fondé sur la spécification

Prépare le plan d'implémentation de la phase 2 à partir de :
- specs/phase-2-regles.md ;
- tranche-verticale.md ;
- packages/core/src/types.ts ;
- packages/core/src/engine.ts ;
- packages/core/src/markdown.ts ;
- CLAUDE.md ;
- .claude/rules/claudoscope-core.md.
Ne modifie encore aucun fichier.
Le plan doit couvrir :
- MEM001 ;
- MEM002 ;
- MEM003 ;
- le registre de règles ;
- les exports publics nécessaires ;
- les tests unitaires ;
- le test d'intégration du registre ;
- le contrôle du vrai CLAUDE.md depuis les tests.
Respecte les contrats existants.
N'ajoute aucune dépendance.
Ne touche pas à packages/cli.

Le plan doit rester entièrement contenu dans packages/core. Aucun changement du CLI n’est nécessaire pour cette phase.

Fichiers prévus
Chaque règle est un objet conforme au type Rule existant.

packages/core/src/
├── markdown.ts
├── types.ts
├── index.ts
└── rules/
├── mem001.ts
├── mem001.test.ts
├── mem002.ts
├── mem002.test.ts
├── mem003.ts
├── mem003.test.ts
├── index.ts
└── rules.test.ts

Le contrat actuel de types.ts suffit. La phase n’ajoute ni nouvelle abstraction ni nouvelle dépendance.

Mettre à jour l’exemple du contrat Rule
Aligner la JSDoc sur les identifiants retenus
Le type Rule contient encore un exemple d’identifiant comme claude-md/length. Le catalogue utilise finalement des identifiants courts et stables : MEM001, MEM002 et MEM003.

La première modification de la phase consiste donc à corriger uniquement cet exemple dans packages/core/src/types.ts.
Le type lui-même ne change pas. Seule la convention d’identification est alignée sur la spécification.

export interface Rule {
/** Identifiant stable de la règle, par exemple MEM001. */
readonly id: string;
readonly severity: Severity;
readonly docs: string;
readonly check: (ctx: RuleContext) => readonly Finding[];
}

export const mem001: Rule = {
id: "MEM001",
severity: "warn",
docs: "Signale un fichier CLAUDE.md trop long.",
check(ctx) {
return [];
}
};

Implémenter MEM001 : fichier trop long
Fixer le seuil dans une constante exportée
MEM001 signale les fichiers de plus de 200 lignes. Le seuil est exprimé dans une constante unique afin d’éviter sa duplication entre l’implémentation et les tests.
export const MAX_LINES = 200;

La règle utilise la représentation normalisée produite par parseMarkdown.
const count = parseMarkdown(ctx.content).lines.length;

Un finding est produit uniquement lorsque le nombre de lignes dépasse strictement le seuil.
199 lignes -> aucun finding
200 lignes -> aucun finding
201 lignes -> un finding
215 lignes -> un finding

Contrat du finding
Champ | Valeur
---|---
ruleId | MEM001
severity | warn
line | MAX_LINES + 1, soit la première ligne située au-delà du seuil.
message | Indique le nombre de lignes observé et le maximum recommandé.

Pour un fichier de 215 lignes, le message peut prendre cette forme :
Le fichier contient 215 lignes, pour un maximum recommandé de 200.

Tests de MEM001
Les tests doivent couvrir le comportement nominal et la frontière exacte.

Fichier vide :
aucun finding.
Fichier de moins de 200 lignes :
aucun finding.
Fichier de 200 lignes :
aucun finding.
Fichier de 201 lignes :
un finding MEM001.
Fichier nettement trop long :
ruleId, severity, line et message vérifiés.

La normalisation des fins de ligne est déjà testée par le parseur. La règle consomme son contrat sans le reproduire.

Implémenter MEM002 : section vide
Définir une section vide
Une section est vide lorsque toutes ses lignes de contenu sont blanches après application de trim().

const isBlank = section.contentLines.every(
(line) => line.trim().length === 0
);

Cette définition ne suffit toutefois pas. Un titre peut servir de conteneur à des sous-sections.

## Installation
### Windows
Contenu Windows

La section Installation ne contient aucune ligne de texte avant le titre Windows. Elle ne doit pourtant pas être signalée comme vide, car elle introduit une sous-section.

Reconnaître un titre conteneur
Une section vide est ignorée lorsque la section suivante existe et possède un niveau plus profond.

const next = sections[index + 1];
const isContainer =
next !== undefined && next.level > section.level;

La règle produit donc un finding lorsque :
toutes les lignes de contenu sont blanches
ET
la section suivante n'est pas une sous-section directe ou indirecte.

Contrat du finding
MEM002 produit un finding par section vide.

Champ | Valeur
---|---
ruleId | MEM002
severity | warn
line | Ligne de l’en-tête de la section.
message | Indique le titre de la section vide.

La section « Architecture » est vide.

Tests de MEM002
Section contenant du texte :
aucun finding.
Section vide entre deux sections de même niveau :
un finding.
Titre conteneur suivi d'un titre plus profond :
aucun finding pour le conteneur.
Dernière section vide :
un finding.
Document contenant seulement un préambule :
aucun finding.
Fichier vide :
aucun finding.
Document sans en-tête :
aucun finding.
Plusieurs sections vides :
un finding par section, dans l'ordre du document.

Le parseur expose les lignes. La règle décide ce que signifie « vide ». Cette séparation évite d’introduire une décision métier dans markdown.ts.

Implémenter MEM003 : structure minimale absente
Définir les trois familles attendues
Un fichier CLAUDE.md minimal doit contenir au moins une section relevant de chacune des familles suivantes :
commandes ;
architecture ;
vérification.

La comparaison doit tolérer la casse, les accents et les variantes françaises ou anglaises courantes.

Normaliser les titres
function normalizeTitle(title: string): string {
return title
.toLowerCase()
.normalize("NFD")
.replace(/[\u0300-\u036f]/g, "");
}

Après normalisation, les familles sont identifiées avec les fragments suivants :

Famille | Fragments reconnus | Exemples
---|---|---
Commandes | command | Commandes, Commands, COMMANDES.
Architecture | architecture | Architecture, Architecture du projet.
Vérification | verification ou verify | Vérification, Verification, Verify.

Le document est conforme uniquement lorsqu’au moins un titre de chacune des trois familles est présent.

Ne pas mélanger existence et contenu
MEM003 vérifie la présence de la structure. Elle ne vérifie pas que les sections contiennent du texte.

## Commandes
## Architecture
## Vérification

Ce document ne déclenche pas MEM003, car les trois sections existent. Les sections vides sont signalées séparément par MEM002.

Contrat du finding
Si une ou plusieurs familles sont absentes, MEM003 produit un finding unique.

Champ | Valeur
---|---
ruleId | MEM003
severity | error
line | Absente, car le finding concerne la structure globale du document.
message | Nomme les familles de sections attendues.

Le fichier doit contenir des sections consacrées aux commandes,
à l'architecture et à la vérification.

Tests de MEM003

Titres Commandes, Architecture et Vérification :
aucun finding.
Variantes anglaises Commands et Verify :
aucun finding.
Titres en majuscules :
aucun finding.
Titre avec accent :
aucun finding après normalisation.
Fichier vide :
un finding MEM003.
Une famille absente :
un finding MEM003.
Plusieurs familles absentes :
un seul finding MEM003.
Sections attendues présentes mais vides :
aucun MEM003, mais MEM002 peut se déclencher.

Construire le registre de règles
Conserver un ordre fixe
Le registre est placé dans packages/core/src/rules/index.ts.

import type { Rule } from "../types.js";
import { mem001 } from "./mem001.js";
import { mem002 } from "./mem002.js";
import { mem003 } from "./mem003.js";
export const rules: readonly Rule[] = [
mem001,
mem002,
mem003
];

L’ordre est volontairement stable. Le moteur parcourt les fichiers puis les règles dans leur ordre de déclaration. La sortie doit donc rester reproductible :
MEM001
MEM002
MEM003

Le registre est ensuite réexporté depuis packages/core/src/index.ts, car le CLI devra le consommer pendant la phase 3.
export { rules } from "./rules/index.js";

Le parseur reste interne. Seuls le moteur, les types et le registre nécessaires aux surfaces sont exposés.

Tester l’intégration du registre
Exécuter le moteur sur un contenu en mémoire
Le fichier packages/core/src/rules/rules.test.ts vérifie que le registre complet fonctionne avec analyze().

const file: SourceFile = {
path: "CLAUDE.md",
content: contenuFautif
};
const findings = analyze([file], rules);

Le test doit vérifier :
les règles sont exécutées ;
les findings sont structurés ;
l'ordre MEM001, MEM002, MEM003 est stable ;
aucune lecture du disque n'est effectuée par le moteur ;
un contenu sain retourne une liste vide.

Ajouter un premier dogfooding au niveau du core
Le test peut également charger le vrai fichier CLAUDE.md du dépôt, puis transmettre son contenu au moteur.
La lecture du disque est effectuée dans le test, pas dans le code du core. L’invariant d’architecture reste donc respecté.

const content = readFileSync(
new URL("../../../../CLAUDE.md", import.meta.url),
"utf8"
);
const findings = analyze(
[
{
path: "CLAUDE.md",
content
}
],
rules
);
expect(findings).toEqual([]);

Si le fichier du projet déclenche un finding, il faut corriger CLAUDE.md, pas affaiblir la règle pour rendre le test vert.
Ce test constitue un premier dogfooding du moteur. Le dogfooding complet par la commande réelle restera dans la phase 4.

Exécuter et fermer la phase 2
Autoriser l’implémentation

Implémente maintenant la phase 2 conformément à :
- specs/phase-2-regles.md ;
- au plan d'implémentation validé ;
- au contrat existant de markdown.ts ;
- aux invariants de CLAUDE.md ;
- à .claude/rules/claudoscope-core.md.
Contraintes :
- travaille uniquement dans packages/core ;
- n'ajoute aucune dépendance ;
- ne modifie pas packages/cli ;
- ne duplique pas le parsing dans les règles ;
- conserve l'ordre MEM001, MEM002, MEM003 ;
- ajoute les tests prévus ;
- arrête-toi après la validation de la phase 2.

Commandes de validation
pnpm run test
pnpm run typecheck
pnpm run lint
pnpm run build

La gate est fermée lorsque :
MEM001 est testée aux limites 200 et 201.
MEM002 distingue une section vide d'un titre conteneur.
MEM003 exige les trois familles de sections.
Le registre expose les trois règles dans un ordre fixe.
analyze() exécute le registre sur un contenu en mémoire.
Le vrai CLAUDE.md produit zéro finding.
packages/cli reste inchangé.
Toutes les validations passent.

Préparer la phase 3 : CLI de bout en bout
Repartir du contrat fonctionnel
La phase 3 connecte le squelette existant du CLI au moteur et au registre de règles.
Le CLI ne doit pas interpréter le Markdown ni reproduire les règles. Il assure uniquement les entrées-sorties et la traduction du résultat en comportement terminal.

Chemin du fichier
↓
lecture du contenu
↓
construction d'un SourceFile
↓
analyze([sourceFile], rules)
↓
findings
↓
rendu text ou json
↓
code de sortie

Conserver le périmètre de la phase
Inclus :
- lecture d'un fichier passé en argument ;
- construction d'un SourceFile ;
- appel de analyze() avec le registre ;
- rendu text ;
- rendu json ;
- option --fail-on ;
- codes de sortie 0, 1 et 2 ;
- tests du comportement du CLI.

Exclus :
- découverte automatique d'un fichier dans un répertoire ;
- parcours récursif ;
- analyse de .claude/settings.json ;
- analyse de .mcp.json ;
- analyse de .claude/rules/ ;
- fixtures finales et snapshots ;
- SARIF ;
- auto-fix ;
- publication.

Produire le plan de la phase 3
Faire analyser le squelette existant

Prépare le plan d'implémentation de la phase 3 de tranche-verticale.md.
Analyse :
- packages/cli/src/program.ts ;
- packages/cli/src/index.ts ;
- packages/cli/src/program.test.ts ;
- les exports de @claudoscope/core ;
- le registre de règles ;
- les scripts du workspace.
Ne modifie encore aucun fichier.
Le plan doit préciser :
- comment lire le fichier passé à scan ;
- comment construire SourceFile ;
- comment appeler analyze() avec rules ;
- le format text ;
- le format json ;
- le comportement de --fail-on ;
- les codes de sortie 0, 1 et 2 ;
- les cas de fichier absent ;
- les tests à ajouter ;
- les fichiers qui resteront inchangés.
Aucune logique MEM ne doit être ajoutée au CLI.

Responsabilités du CLI

Responsabilité | Implémentation attendue
---|---
Recevoir l’entrée | Lire le chemin fourni à claudoscope scan.
Lire le disque | Charger le contenu du fichier en UTF-8.
Adapter l’entrée | Construire un objet SourceFile avec path et content.
Appeler le moteur | Exécuter analyze([sourceFile], rules).
Rendre les résultats | Produire une sortie text ou json.
Traduire le seuil | Retourner 1 lorsqu’un finding atteint le niveau configuré par --fail-on.
Gérer les erreurs techniques | Retourner 2 lorsqu’une erreur d’exécution empêche le scan.

Brancher le CLI sur le core
Utiliser uniquement les exports publics
Le CLI consomme le moteur et le registre depuis @claudoscope/core.

import {
analyze,
rules,
type Finding,
type SourceFile
} from "@claudoscope/core";

Il ne doit jamais importer directement :
@claudoscope/core/src/markdown
@claudoscope/core/src/rules/mem001
@claudoscope/core/src/rules/mem002
@claudoscope/core/src/rules/mem003

La surface publique du package constitue la frontière. Les détails internes restent cachés.

Construire l’entrée du moteur
const sourceFile: SourceFile = {
path: filePath,
content
};
const findings = analyze([sourceFile], rules);

Le CLI ne calcule aucune sévérité métier et ne crée aucun finding à la place des règles.

Produire une sortie texte déterministe
Afficher les findings dans leur ordre d’origine
Le moteur garantit l’ordre des fichiers et des règles. Le rendu texte doit conserver cet ordre sans effectuer de tri implicite supplémentaire.

Chaque finding peut être présenté avec :
chemin ;
ligne lorsqu'elle existe ;
sévérité ;
identifiant de règle ;
message.

Exemple de sortie :
CLAUDE.md:201 warn MEM001 Le fichier contient 215 lignes, pour un maximum recommandé de 200.
CLAUDE.md:12 warn MEM002 La section « Architecture » est vide.
CLAUDE.md error MEM003 Le fichier doit contenir les sections minimales attendues.

Le format exact doit être stable. Les snapshots complets seront ajoutés dans la phase 4.

Traiter l’absence de finding
Un fichier conforme doit produire une sortie courte et explicite.
Aucun problème détecté.

Le CLI ne doit pas afficher un faux finding ou une structure vide difficile à interpréter.

Produire une sortie JSON
Conserver les données structurées du moteur
L’option --format json doit produire une sortie parsable et déterministe.
claudoscope scan CLAUDE.md --format json

La sortie peut contenir le fichier analysé et la liste ordonnée des findings.
{
"file": "CLAUDE.md",
"findings": [
{
"ruleId": "MEM002",
"severity": "warn",
"message": "La section « Architecture » est vide.",
"line": 12
}
]
}

Le JSON doit être envoyé seul sur la sortie standard. Aucun message humain supplémentaire ne doit rendre le document invalide.

Appliquer --fail-on
Définir les niveaux
L’option accepte deux valeurs :
--fail-on error
--fail-on warn
Le seuil par défaut est error.

Seuil | Findings provoquant le code 1
---|---
error | Uniquement les findings de sévérité error.
warn | Les findings de sévérité warn ou error.

La commande ne modifie pas les findings. Elle détermine seulement si leur gravité doit faire échouer l’exécution.

Appliquer les codes de sortie
Contrat de la phase 3

Code | Situation
---|---
0 | Aucun finding n’atteint le seuil configuré.
1 | Au moins un finding atteint ou dépasse le seuil de --fail-on.
2 | Une erreur technique empêche l’exécution du scan.

Traiter le fichier absent
Pour cette première tranche, l’absence du fichier attendu produit un message indicatif et un code de sortie 0.
Aucun fichier à analyser.

Cette décision permet d’utiliser le linter comme gate facultative dans un dépôt qui ne possède pas encore de fichier CLAUDE.md.
Les autres erreurs de lecture ou d’exécution restent des erreurs techniques et produisent le code 2.

Tester la phase 3
Préserver les tests du programme
Le test existant qui vérifie la présence de la commande scan doit rester vert.

Les nouveaux tests doivent couvrir le comportement de l’action sans reproduire les tests unitaires des règles.

Fichier sain :
aucun finding bloquant, code 0.
Fichier avec MEM003 :
sortie contenant le finding, code 1 avec --fail-on error.
Fichier contenant seulement des warnings :
code 0 avec --fail-on error ;
code 1 avec --fail-on warn.
Format text :
sortie lisible et stable.
Format json :
JSON parsable contenant les findings attendus.
Fichier absent :
message indicatif et code 0.
Erreur technique :
message d'erreur et code 2.

Les fixtures finales et les snapshots ne sont pas encore ajoutés. Les tests de cette phase peuvent utiliser des fichiers temporaires ou des contenus minimaux créés pour le test.

Exécuter la phase 3
Autoriser les modifications du CLI

Implémente maintenant la phase 3 conformément à :
- tranche-verticale.md ;
- la spécification de la phase 3 ;
- au plan d'implémentation validé ;
- aux exports publics de @claudoscope/core ;
- aux permissions et invariants du projet.
Contraintes :
- le CLI lit le fichier et appelle le core ;
- aucune logique MEM ne doit apparaître dans packages/cli ;
- conserve les ordres produits par le moteur ;
- implémente les formats text et json ;
- implémente --fail-on error|warn ;
- applique les codes de sortie 0, 1 et 2 ;
- ne parcours pas de répertoire ;
- n'ajoute aucune fixture finale ni snapshot ;
- n'anticipe pas la phase 4 ;
- arrête-toi après la validation de la phase 3.

Commandes de validation
pnpm run test
pnpm run typecheck
pnpm run lint
pnpm run build

Après le build, vérifiez manuellement le comportement du CLI.
node packages/cli/dist/index.js scan CLAUDE.md
node packages/cli/dist/index.js scan CLAUDE.md --format json
node packages/cli/dist/index.js scan CLAUDE.md --fail-on warn

Le vrai fichier CLAUDE.md doit rester conforme. S’il déclenche une règle valide, corrigez le document plutôt que d’affaiblir le catalogue.

Relire le diff des deux phases
Vérifier la frontière d’architecture
git status --short
git diff --stat
git diff

Le diff doit respecter cette répartition :

Zone | Responsabilités ajoutées
---|---
packages/core | Règles MEM, registre, exports et tests du moteur.
packages/cli | Lecture du fichier, appel du moteur, rendu et codes de sortie.

Les signaux suivants indiquent une dérive :
parseMarkdown() dupliqué dans le CLI ;
seuil MAX_LINES copié dans le CLI ;
détection de section vide dans le CLI ;
comparaison des titres de MEM003 dans le CLI ;
lecture du disque dans le core ;
tri différent des findings dans chaque format ;
nouvelle dépendance de parsing ;
fixtures finales ou snapshots ajoutés avant la phase 4.

Demander une revue ciblée
Analyse le diff des phases 2 et 3.
Vérifie :
- MEM001 respecte le seuil strict de 200 lignes ;
- MEM002 distingue une section vide d'un titre conteneur ;
- MEM003 exige les trois familles de sections ;
- le registre conserve l'ordre MEM001, MEM002, MEM003 ;
- le core reste pur ;
- le CLI consomme uniquement l'API publique du core ;
- aucune logique MEM n'existe dans le CLI ;
- les sorties text et json conservent l'ordre des findings ;
- --fail-on applique correctement les niveaux error et warn ;
- les codes 0, 1 et 2 sont couverts ;
- les fixtures finales et snapshots restent absents.
Conclue :
phases 2 et 3 prêtes à être fermées : oui ou non.
Ne modifie rien.

Résultat de la session
Phase 2 terminée
Règles ajoutées :
- MEM001, fichier de plus de 200 lignes, warn ;
- MEM002, section vide, warn ;
- MEM003, structure minimale absente, error.
Intégration :
- registre ordonné ;
- export public du registre ;
- tests unitaires par règle ;
- test du registre avec analyze() ;
- premier dogfooding du core sur CLAUDE.md.

Phase 3 terminée
Commande :
claudoscope scan [chemin]
Traitement :
- lecture du fichier ;
- construction de SourceFile ;
- appel de analyze() avec rules ;
- rendu text ou json ;
- application de --fail-on ;
- codes de sortie 0, 1 ou 2.

Éléments encore reportés
Fixtures permanentes sain et fautif.
Snapshots des sorties text et json.
Dogfooding complet par le CLI.
Découverte automatique de CLAUDE.md dans un répertoire.
Scan de plusieurs fichiers.
Analyse de settings.json, .mcp.json et .claude/rules/.
SARIF.
Auto-fix.
Publication.
