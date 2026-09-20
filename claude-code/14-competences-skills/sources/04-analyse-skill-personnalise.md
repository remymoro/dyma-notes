Claude Code 14. Les compétences (skills) 4. Analyse d'un skill personnalisé

Créer et fiabiliser une première skill projet
Une skill permet d’enregistrer dans Claude Code un workflow réutilisable. Au lieu de répéter les mêmes consignes dans chaque conversation, vous les placez dans un dossier contenant un fichier SKILL.md et, si nécessaire, des références ou des scripts.

Nous allons créer /techdebt, une skill chargée d’analyser la dette technique du convertisseur de température. Elle recherchera les duplications, la complexité accidentelle, les responsabilités mal séparées, les cas limites ignorés, les tests manquants et les incohérences de conception.

Cette skill produira un rapport argumenté sans modifier le projet.

Choisir une skill propre au projet
Une skill personnelle placée dans ~/.claude/skills/ est disponible dans tous les projets. Une skill projet est placée dans .claude/skills/ et peut être versionnée avec le dépôt.

Comme /techdebt doit connaître la structure, les invariants et les pièges du convertisseur, créez-la dans le projet :

mkdir -p .claude/skills/techdebt/references
mkdir -p .claude/skills/techdebt/scripts

La structure finale est la suivante :
.claude/
skills/
techdebt/
SKILL.md
references/
conventions.md
scripts/
inspecter-projet.mjs

Le nom du dossier détermine la commande d’invocation. Le dossier techdebt crée donc la commande /techdebt.

Chaque fichier possède une responsabilité précise :
Fichier | Responsabilité
---|---
SKILL.md | Définir le déclenchement, le workflow, les contraintes et le format du rapport.
references/conventions.md | Conserver les règles et les pièges propres au convertisseur.
scripts/inspecter-projet.mjs | Collecter l’état Git et le résultat des tests de manière reproductible.

Cette séparation évite de surcharger SKILL.md. Les détails ne sont chargés que lorsque la skill devient pertinente.

Extraire les conventions du convertisseur
Créez le fichier .claude/skills/techdebt/references/conventions.md avec le contenu suivant :

# Conventions du convertisseur
## Structure
- `src/conversion.js` contient les fonctions de conversion et d'arrondi.
- `src/main.js` contient les interactions avec la page HTML.
- Les tests utilisent `node:test` et `node:assert/strict`.
- La commande de test est `npm test`.
- La commande de lancement est `npm run dev`.

## Invariants
- Les résultats sont arrondis à un chiffre après la virgule.
- Une saisie invalide ne doit jamais afficher `NaN`.
- Les fonctions de conversion doivent rester indépendantes du DOM.
- Une correction locale ne doit pas entraîner de refactorisation générale.

## Pièges connus
- `Number('')` retourne `0` : une saisie vide doit être détectée avant la conversion.
- Les tests unitaires des fonctions ne vérifient pas automatiquement le formulaire.
- L'absence de TypeScript ou de framework n'est pas une dette technique dans ce projet.
- Une préférence de style ne doit pas être présentée comme un problème bloquant.

Une bonne référence contient surtout ce que Claude ne peut pas déduire avec certitude depuis le code : les conventions internes, les invariants fonctionnels et les erreurs déjà observées.
Elle évite notamment qu’un choix volontaire du projet soit présenté comme une dette technique.

Ajouter un script déterministe
Claude doit interpréter les résultats, mais il n’a pas besoin de reconstruire à chaque invocation les commandes servant à inspecter le dépôt.

Créez le fichier .claude/skills/techdebt/scripts/inspecter-projet.mjs :

import { spawnSync } from 'node:child_process';
const commandeNpm = process.platform === 'win32' ? 'npm.cmd' : 'npm';
function executer(titre, commande, argumentsCommande) {
console.log(`\n## ${titre}`);
const resultat = spawnSync(commande, argumentsCommande, {
encoding: 'utf8',
shell: false
});
if (resultat.error) {
console.error(
`Impossible d'exécuter la commande : ${resultat.error.message}`
);
return;
}
if (resultat.stdout.trim()) {
console.log(resultat.stdout.trim());
}
if (resultat.stderr.trim()) {
console.error(resultat.stderr.trim());
}
console.log(`Code de sortie : ${resultat.status ?? 1}`);
}
executer('État Git', 'git', ['status', '--short']);
executer('Résumé du diff', 'git', ['diff', '--stat']);
executer('Fichiers modifiés', 'git', ['diff', '--name-only']);
executer('Tests automatisés', commandeNpm, ['test']);

Ce script ne décide pas si le code est maintenable. Il collecte uniquement des faits reproductibles :
l’état du dépôt ;
les fichiers modifiés ;
la taille du diff ;
le résultat des tests.

Claude peut ainsi consacrer son analyse à la qualification des problèmes et à leur priorité.

Écrire le fichier SKILL.md
Une skill contient un frontmatter YAML, utilisé pour sa découverte et sa configuration, puis des instructions Markdown chargées lorsqu’elle est invoquée.

Créez ou remplacez le fichier .claude/skills/techdebt/SKILL.md avec le contenu suivant :

---
name: techdebt
description: Analyse la maintenabilité du code ou du diff courant pour détecter la dette techniq
argument-hint: [périmètre optionnel]
allowed-tools:
- Read
- Grep
- Glob
- 'Bash(node "${CLAUDE_SKILL_DIR}/scripts/inspecter-projet.mjs")'
disallowed-tools:
- Edit
- Write
- NotebookEdit
---
# Audit de dette technique
## Périmètre demandé
$ARGUMENTS
Si aucun périmètre n'est fourni, analyse le diff Git courant.
Si le diff est vide, analyse les fichiers principaux du convertisseur.
## Contexte déterministe
!`node "${CLAUDE_SKILL_DIR}/scripts/inspecter-projet.mjs"`
## Référence projet
Lis `references/conventions.md` avant de produire le rapport.
Utilise uniquement les conventions pertinentes pour le périmètre analysé.
## Procédure
1. Détermine le périmètre exact de l'audit.
2. Examine les preuves collectées par le script.
3. Lis uniquement les fichiers nécessaires.
4. Recherche :
- les duplications ;
- la complexité accidentelle ;
- les responsabilités mal séparées ;
- les noms imprécis ou trompeurs ;
- les cas limites ignorés ;
- les tests manquants ou fragiles ;
- le code mort ;
- les incohérences avec les conventions du projet.
5. Ne signale que les problèmes démontrés.
6. Ne modifie aucun fichier.
7. Ne crée aucun commit.
8. N'installe aucune dépendance.
9. Ne propose pas de refactorisation sans expliquer son bénéfice concret.
## Format du rapport
Présente :
1. le périmètre analysé ;
2. les preuves collectées ;
3. les problèmes importants ;
4. la dette non bloquante ;
5. les tests ou validations manquants ;
6. les recommandations prioritaires ;
7. la prochaine action minimale.
Pour chaque problème, indique :
- le fichier concerné ;
- la preuve observée ;
- l'impact concret ;
- la correction minimale envisageable.
Si aucune dette significative n'est trouvée, indique-le clairement.

Comprendre les éléments de la skill

Élément | Rôle
---|---
description | Indique les demandes qui doivent et ne doivent pas déclencher la skill.
argument-hint | Indique le type d’argument attendu dans l’autocomplétion.
$ARGUMENTS | Insère explicitement le périmètre fourni après /techdebt.
${CLAUDE_SKILL_DIR} | Référence le dossier de la skill, indépendamment du répertoire courant.
!`commande` | Exécute une commande et injecte son résultat dans le contexte.
allowed-tools | Préapprouve les outils nécessaires au workflow.
disallowed-tools | Retire certains outils pendant l’invocation.

La description doit être écrite pour le modèle. Claude l’utilise pour décider si la skill correspond à la demande.
Le cas d’usage principal doit donc apparaître clairement, avec les exclusions importantes.

allowed-tools ne constitue pas nécessairement une liste totalement restrictive. Il préapprouve certains outils, tandis que les autres restent soumis aux permissions habituelles.

disallowed-tools réduit les outils disponibles pendant l’invocation, mais ne remplace pas une politique générale de sécurité.

Vérifier que la skill est disponible
Dans Claude Code, affichez les skills disponibles :
/skills
techdebt doit apparaître comme une skill projet.

Les modifications d’un dossier de skills déjà détecté sont normalement prises en compte pendant la session.
Si .claude/skills/ n’existait pas au démarrage, redémarrez la session afin que le nouveau dossier soit détecté.

Tester l’invocation manuelle
Lancez d’abord un audit général :
/techdebt

S’il existe des changements non validés, le diff courant doit constituer le périmètre par défaut.
Si le diff est vide, la skill doit examiner les fichiers principaux du convertisseur.

Testez ensuite un fichier précis :
/techdebt src/main.js

Puis une préoccupation particulière :
/techdebt analyse uniquement la gestion des saisies invalides et les tests associés

Le rapport doit respecter le périmètre fourni. Une invocation ciblée ne doit pas provoquer une exploration complète du dépôt.

Parmi les constats possibles, la skill peut relever que l’interface utilise directement Number().
Comme Number('') retourne 0, une saisie vide risque d’être traitée comme une valeur valide si elle n’est pas vérifiée avant la conversion.

Tester le déclenchement automatique
Claude peut charger automatiquement la skill lorsqu’une demande correspond à sa description.

Demandes qui doivent déclencher /techdebt
Analyse la dette technique actuelle du convertisseur.
Effectue un audit de maintenabilité avant le commit.
Repère les duplications, la complexité inutile et les tests manquants.

Demandes qui ne doivent pas déclencher /techdebt
Corrige la gestion des saisies invalides.
Lance le serveur de développement.
Vérifie le formulaire dans le navigateur.
Relis le diff pour trouver des bugs.

Ces demandes correspondent respectivement à une implémentation, à l’exécution du projet, à une vérification fonctionnelle et à une revue de correction.

Si /techdebt se déclenche dans ces situations, rendez sa description plus restrictive.
Si elle ne se déclenche pas sur une demande explicite de dette technique, précisez davantage son cas d’usage principal.

Vérifier l’absence d’effets de bord
Relevez l’état du dépôt avant l’audit :
git status --short

Lancez la skill :
/techdebt src/main.js

Contrôlez de nouveau le dépôt :
git status --short

Les deux états doivent être identiques. La skill peut recommander une correction, mais elle ne doit ni l’appliquer, ni créer un commit, ni installer une dépendance.

Les instructions et les restrictions d’outils réduisent le risque. Lorsqu’une interdiction doit être garantie indépendamment du comportement du modèle, elle doit également être imposée par les permissions ou par un contrôle externe adapté.

Comparer le résultat avec et sans la skill
Le déclenchement correct ne suffit pas. Il faut également vérifier que la skill améliore réellement le résultat.

Dans une session fraîche, exécutez :
Analyse la dette technique de src/main.js.

Conservez le rapport obtenu. Désactivez ensuite techdebt depuis /skills, ouvrez une nouvelle session et répétez exactement la même demande.

Comparez les deux résultats :
Critère | Avec la skill | Sans la skill
---|---|---
Respect du périmètre | Analyse limitée à la demande. | Exploration potentiellement plus large.
Conventions du projet | Invariants et pièges explicitement pris en compte. | Conventions déduites uniquement depuis le code.
Preuves | État Git et tests collectés systématiquement. | Collecte variable selon la réponse.
Format | Rapport stable et exploitable. | Structure moins prévisible.
Effets de bord | Modifications explicitement exclues. | Comportement dépendant de la demande.

La skill est utile seulement si elle améliore effectivement la précision, la reproductibilité ou la sécurité du résultat.

Ne pas ajouter de complexité inutile
Le convertisseur est un petit projet. /techdebt n’a pas besoin, à ce stade, d’un sous-agent, d’un hook dédié ou de plusieurs fichiers de référence supplémentaires.

Un sous-agent devient pertinent lorsque l’analyse doit parcourir de nombreux fichiers sans encombrer le contexte principal.
Un hook convient lorsqu’une action doit toujours être exécutée ou bloquée.
Une skill reste adaptée à un workflow lancé à la demande et nécessitant le jugement de Claude.

Utiliser le workflow final
/techdebt intervient maintenant à un endroit précis du workflow :
/techdebt src/main.js
→ correction ciblée
→ npm test
→ /verify
→ /code-review

Chaque étape possède une responsabilité distincte :

Étape | Responsabilité
---|---
/techdebt | Analyser la maintenabilité selon les conventions du projet.
Correction ciblée | Appliquer uniquement les changements retenus.
npm test | Vérifier les fonctions avec un résultat de réussite ou d’échec.
/verify | Vérifier le comportement réel du convertisseur.
/code-review | Rechercher les problèmes de correction dans le diff final.

Une bonne boucle de développement fournit à Claude des critères de vérification exécutables et lui demande de présenter les preuves obtenues, plutôt que d’affirmer simplement que le travail est terminé.

Synthèse
Une skill projet fiable combine :
une responsabilité limitée ;
une description conçue pour le déclenchement ;
des arguments pour contrôler le périmètre ;
des conventions séparées du workflow ;
un script pour collecter les faits déterministes ;
des outils limités au besoin réel ;
un format de sortie stable ;
des tests positifs et négatifs de déclenchement ;
une comparaison avec et sans la skill ;
une amélioration progressive à partir des échecs observés.

/techdebt devient ainsi une capacité propre au convertisseur. Elle produit un audit cohérent, justifié par des preuves et reproductible, sans modifier le projet ni empiéter sur les workflows de correction et de vérification.
