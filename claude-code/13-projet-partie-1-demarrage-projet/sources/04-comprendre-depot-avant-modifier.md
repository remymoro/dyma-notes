Claude Code 13. Projet partie 1 : démarage d'u… 4. Comprendre le dépôt avant de modifier

Le socle technique de Claudoscope vient d’être créé. Le monorepo contient le package pur @claudoscope/core, le package publiable claudoscope, les configurations communes, les tests de santé et les scripts de validation.
Le travail est enregistré dans le commit b93cf13. Avant d’ajouter la première règle d’audit, il faut comparer ce socle au fichier design-doc.md qui a piloté sa création.

Cette revue ne cherche pas à perfectionner tout le monorepo. Elle doit répondre à trois questions précises :
Le socle respecte-t-il les décisions du design doc ?
Un écart risque-t-il de bloquer la première tranche verticale ?
Quels correctifs sont réellement nécessaires avant de continuer ?

L’objectif n’est pas d’appliquer automatiquement toutes les suggestions de Claude Code. L’agent produit un rapport priorisé. Le développeur arbitre ensuite chaque point et n’autorise que les modifications utiles à la gate actuelle.

Comparer le socle au design doc
Lancer une revue d’adéquation
La demande doit comparer les fichiers réellement créés aux décisions du design doc. Elle ne doit pas commencer par modifier le projet.

Compare le socle technique actuel de Claudoscope au fichier @design-doc.md.
Le socle vient d'être créé dans le commit b93cf13.
Objectif :
- vérifier que le socle respecte les décisions du design doc ;
- identifier les écarts ;
- identifier les risques pour la première tranche verticale ;
- proposer uniquement les correctifs nécessaires.
Ne modifie encore aucun fichier.
Classe les correctifs par priorité :
- blocage ou contradiction structurelle ;
- correction importante mais non bloquante ;
- amélioration reportable ;
- optimisation facultative.
Pour chaque point :
- indique les fichiers concernés ;
- explique le risque concret ;
- propose les options possibles ;
- distingue clairement la décision d'architecture du correctif mécanique.

La revue conclut que le socle est globalement très fidèle au design doc. Les invariants principaux sont respectés par construction :

Le produit principal reste un CLI.
Le core est séparé des entrées-sorties.
Le core ne contient ni fs, ni réseau, ni process.
Le monorepo utilise pnpm.
Le code est en TypeScript strict.
Le build utilise tsc.
Aucune règle d'audit n'est encore implémentée.

Le rapport ne détecte donc pas une architecture à recommencer. Il met en évidence une contradiction de publication et plusieurs améliorations secondaires.

Prioriser les correctifs
Un rapport orienté vers l’action
Les constats sont classés de P1 à P4.

Priorité | Constat | Nature
---|---|---
P1 | La stratégie de publication du core contredit celle du CLI. | Contradiction structurelle à trancher.
P2 | Les packages ne contiennent pas encore toutes les métadonnées de publication. | Correction cohérente avec l’intention de publication.
P3 | La frontière d’exécution entre le core et le CLI n’est pas encore exercée. | Risque à traiter dans une tranche suivante.
P4 | L’ordre du build pourrait être renforcé avec des références de projets TypeScript. | Amélioration facultative.

Le classement permet d’éviter deux erreurs opposées : ignorer un problème structurel parce que les tests sont verts, ou transformer une revue ciblée en refonte complète du socle.

P1 : trancher la stratégie de publication
La contradiction détectée
Le package claudoscope déclare une dépendance locale vers le core :

{
"dependencies": {
"@claudoscope/core": "workspace:*"
}
}

Dans le monorepo, cette dépendance fonctionne parce que pnpm relie directement les deux packages du workspace.
Le package @claudoscope/core possède cependant la propriété suivante :

{
"private": true
}

Cette combinaison pose un problème lors de la publication. Le CLI n’embarque pas le code du core, car le build repose uniquement sur tsc et n’effectue aucun bundling.
Lors de la création de l’archive du CLI, la dépendance locale est remplacée par la version actuelle du package :

{
"dependencies": {
"@claudoscope/core": "0.0.0"
}
}

Le consommateur du package doit donc pouvoir télécharger @claudoscope/core@0.0.0 depuis le registre. Or la propriété private empêche ce package d’être publié.

Dans le workspace :
claudoscope
↓ workspace:*
@claudoscope/core
↓ lien local disponible
fonctionne

Après publication :
claudoscope
↓ @claudoscope/core@0.0.0
registre npm
↓ package absent
installation cassée

Le socle passe ses tests locaux tout en préparant un package impossible à installer depuis le registre. Il s’agit donc d’une contradiction d’architecture, pas d’une simple métadonnée manquante.

Les trois options proposées
Option | Principe | Conséquence
---|---|---
Publier aussi @claudoscope/core | Retirer private et ajouter les métadonnées nécessaires. | Le CLI conserve une dépendance publique séparée.
Bundler le core dans le CLI | Produire un artefact autonome contenant le code des deux packages. | Le choix d’un build uniquement avec tsc doit être revu.
Conserver le core interne et publier un artefact autonome autrement | Ajouter une étape de construction spécifique avant publication. | La chaîne de publication devient plus complexe.

Ce point ne peut pas être corrigé sans choisir la stratégie de distribution. L’agent ne doit donc pas appliquer arbitrairement l’une des trois options.

La décision retenue
Le commentaire placé directement sur P1 tranche la question :

Retire private: true.
Le core sera une dépendance publique.

@claudoscope/core devient donc un package public autonome. Le package claudoscope continue de le déclarer comme dépendance.
Cette décision conserve les choix existants :

Deux packages distincts.
Aucun bundler.
Compilation avec tsc.
Frontière publique entre le core et le CLI.
Publication des deux packages.

P2 : compléter les métadonnées de publication
Les informations manquantes
Le package claudoscope annonce déjà une future publication, mais son manifeste ne contient pas encore toutes les informations utiles à cette distribution.
Le rapport identifie notamment :
license
description
repository
homepage
keywords
publishConfig.access
engines.node
LICENSE

Ces informations ne bloquent pas les tests locaux. Elles alignent cependant le socle sur l’intention de publier le produit sous licence MIT.

La décision retenue
Le commentaire placé sur P2 autorise la correction :
Ajoute les licences.

Le correctif est appliqué aux deux packages, car le core doit maintenant être publié au même titre que le CLI.
Les champs repository et homepage ne peuvent pas encore recevoir une valeur fiable tant qu’aucun dépôt distant n’est configuré. Ils restent donc volontairement absents.

P3 : exercer la frontière entre le core et le CLI
Une dépendance déclarée, mais pas encore exécutée
Le fichier packages/cli/src/program.ts n’importe pas encore @claudoscope/core.
Le socle vérifie donc plusieurs éléments :
Le package existe.
La dépendance workspace existe.
Le typage des deux packages passe.
Le build des deux packages passe.

Il ne vérifie pas encore qu’un fichier JavaScript construit dans le CLI peut réellement importer et exécuter le core.
Les problèmes suivants pourraient donc rester invisibles :
exports incorrects dans package.json ;
résolution ESM incorrecte ;
ordre de build insuffisant ;
fichier dist absent ;
déclaration de types incohérente ;
package local disponible au typage mais pas à l'exécution.

Le correctif proposé
Le rapport propose d’importer temporairement la fonction analyze depuis le core, puis d’ajouter un test traversant réellement cette frontière.
import { analyze } from "@claudoscope/core";

Ce test ferait échouer immédiatement le socle si la résolution du package construit était incorrecte.

La décision retenue
Le commentaire placé sur P3 repousse cette modification :
On ignore pour l'instant.

Le point ne disparaît pas. Il reste identifié comme risque à fermer lorsque la première tranche utilisera réellement le moteur depuis le CLI.
Reporter un correctif n’est pas l’oublier. La décision doit rester visible avec son risque et sa future preuve de fermeture.

P4 : renforcer l’ordre de build
Le fonctionnement actuel
Le build du CLI dépend des fichiers produits dans le dossier dist du core.
Le monorepo garantit actuellement l’ordre d’exécution avec les commandes récursives de pnpm. Le core est construit avant le package qui en dépend.

L’amélioration proposée
Le rapport propose d’ajouter des références de projets TypeScript. Elles rendraient la relation entre les deux compilations explicite dans les fichiers tsconfig.json.
{
"references": [
{
"path": "../core"
}
]
}
La compilation pourrait ensuite utiliser le mode build de TypeScript :
tsc -b

La décision retenue
Le commentaire placé sur P4 repousse également cette modification :
On ignore pour l'instant.

Le build actuel passe et la correction n’est pas nécessaire à la gate de publication des packages. Elle reste notée comme amélioration de robustesse.

Arbitrer directement dans le rapport
Commenter chaque proposition
Le rapport est affiché dans un document qui permet de sélectionner un passage et de laisser un commentaire à Claude Code.
Chaque priorité reçoit donc une décision distincte :

P1 - Trancher la stratégie de publication
Décision : retire private: true et publie le core comme dépendance.
P2 - Métadonnées de publication
Décision : ajoute les licences.
P3 - Exercer la frontière core / CLI
Décision : ignorer pour l'instant.
P4 - Robustesse du build
Décision : ignorer pour l'instant.

Cette méthode donne à l’agent une instruction précise pour chaque point. Elle évite une demande vague comme « corrige le rapport », qui pourrait l’autoriser à appliquer aussi les optimisations refusées.

Conserver le contrôle du périmètre
Action | Décision
---|---
Corriger une contradiction de publication | Autorisé.
Ajouter les métadonnées nécessaires aux packages publiables | Autorisé.
Modifier le code du CLI pour appeler le core | Repoussé.
Reconfigurer le build avec des références de projets | Repoussé.
Ajouter les fixtures ou les premières règles | Hors périmètre.
Corriger les coquilles isolées du design doc | Hors périmètre.

La revue sert à prendre des décisions, pas à donner un blanc-seing à l’agent.

Appliquer les correctifs approuvés
Rendre @claudoscope/core publiable
Le champ private est retiré du fichier packages/core/package.json.
Le package reçoit également ses métadonnées de distribution :

{
"name": "@claudoscope/core",
"version": "0.0.0",
"description": "Moteur d'analyse déterministe de Claudoscope",
"license": "MIT",
"type": "module",
"engines": {
"node": ">=20"
},
"publishConfig": {
"access": "public"
},
"keywords": [
"claude-code",
"linter",
"analyse-statique"
],
"files": [
"dist",
"LICENSE"
]
}

Le package reste indépendant des entrées-sorties. Le correctif modifie sa distribution, pas son architecture interne.

Compléter les métadonnées du CLI
Le fichier packages/cli/package.json reçoit les mêmes informations de base.

{
"name": "claudoscope",
"version": "0.0.0",
"description": "Linter déterministe pour les fichiers de configuration Claude Code",
"license": "MIT",
"type": "module",
"engines": {
"node": ">=20"
},
"publishConfig": {
"access": "public"
},
"keywords": [
"claude-code",
"cli",
"linter",
"analyse-statique"
],
"files": [
"dist",
"LICENSE"
],
"dependencies": {
"@claudoscope/core": "workspace:*"
}
}

La dépendance reste exprimée avec workspace:* dans le dépôt. Elle sera transformée dans l’archive publiable.

Ajouter la licence
Le manifeste racine reste privé, mais il déclare lui aussi la licence du projet.

{
"private": true,
"license": "MIT"
}

Un fichier LICENSE est ajouté à la racine, puis copié dans chacun des packages publiables.
LICENSE
packages/core/LICENSE
packages/cli/LICENSE
Le projet dispose ainsi d’un texte de licence commun et chaque archive publiable contient explicitement sa copie.

Vérifier les correctifs
Relancer la chaîne technique
Les modifications doivent d’abord conserver toutes les validations du socle.

pnpm install
pnpm run typecheck
pnpm run test
pnpm run build

Le résultat obtenu est le suivant :
Installation : réussie
Typecheck : réussi
Tests : 3 tests réussis
Build : réussi

Les correctifs n’ont donc pas modifié le comportement existant du socle.

Construire les archives de publication
Les tests locaux ne suffisent pas pour vérifier une stratégie de publication. Il faut construire les archives qui seraient envoyées au registre.
Depuis le package core :
cd packages/core
pnpm pack

Puis depuis le package CLI :
cd ../cli
pnpm pack

Les deux commandes produisent des fichiers .tgz.

Inspecter le contenu des archives
Chaque archive doit contenir les fichiers de distribution attendus.
tar -tf <archive-core.tgz>
tar -tf <archive-cli.tgz>

Les contrôles confirment notamment la présence de :
package/dist/
package/package.json
package/LICENSE

Le code source de développement, les tests et les fichiers inutiles ne doivent pas remplacer les fichiers compilés attendus.

Vérifier le manifeste transformé du CLI
Le package.json contenu dans l’archive du CLI doit être inspecté.
tar -xOf <archive-cli.tgz> package/package.json

La dépendance locale suivante :
{
"@claudoscope/core": "workspace:*"
}
est transformée dans l’archive en :
{
"@claudoscope/core": "0.0.0"
}

Cette transformation est maintenant cohérente, car @claudoscope/core n’est plus privé et possède une configuration de publication publique.
La contradiction structurelle P1 est fermée.

Distinguer les points corrigés et les points reportés
Récapitulatif des modifications

Changement | Fichiers
---|---
core rendu publiable, champ private retiré, description, licence, moteur Node.js, accès public, mots-clés et liste des fichiers ajoutés. | packages/core/package.json
Métadonnées du CLI complétées. | packages/cli/package.json
Licence MIT déclarée à la racine, qui reste privée. | package.json
Texte de licence ajouté à la racine et dans les deux packages. | LICENSE, packages/core/LICENSE, packages/cli/LICENSE

Travaux explicitement reportés

Travail | Statut | Future preuve attendue
---|---|---
Importer analyze depuis le core dans le CLI. | Reporté. | Un test traverse réellement la frontière entre les packages.
Ajouter des références de projets TypeScript. | Reporté. | Le build utilise un graphe explicite avec un ordre indépendant de la commande pnpm.
Ajouter repository et homepage. | Reporté. | Un dépôt distant existe et fournit des adresses réelles.
Augmenter la version au-delà de 0.0.0. | Reporté jusqu’à la première publication. | Les deux packages reçoivent une version publiable cohérente.

Le rapport conserve ainsi les risques non traités sans les faire passer artificiellement pour des erreurs fermées.

Ne pas commiter à la place du développeur
Laisser la dernière décision à l’utilisateur
Claude Code applique les correctifs, exécute les validations et fournit son récapitulatif. Il ne crée pas automatiquement de commit.
Cette limite permet d’inspecter le diff avant de stabiliser la modification.

Rien n'a été commité.
Je te laisse la main sur le commit.

git status
git diff

Le diff attendu doit rester limité aux manifestes et aux fichiers de licence. Il ne doit contenir aucune modification du moteur, du programme CLI, des tests fonctionnels ou du design doc.

Résultat final
Rapport de fermeture

Tous les correctifs approuvés sont appliqués et vérifiés.
Modifications :
- @claudoscope/core est maintenant publiable ;
- les deux packages déclarent leur description, licence, moteur Node.js,
accès public, mots-clés et fichiers publiés ;
- la licence MIT existe à la racine et dans chaque package ;
- le package racine reste privé.
Contrôles :
- pnpm install passe ;
- pnpm run typecheck passe ;
- pnpm run test passe avec 3 tests ;
- pnpm run build passe ;
- pnpm pack passe sur les deux packages ;
- chaque archive contient dist et LICENSE ;
- le package.json publié du CLI résout @claudoscope/core@0.0.0.
Reportés :
- import réel de analyze depuis le CLI et test de frontière ;
- références de projets TypeScript ;
- repository et homepage ;
- augmentation de version avant la première publication.
Aucun commit n'a été créé.
