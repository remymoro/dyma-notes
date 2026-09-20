Claude Code 14. Les compétences (skills) 1. Situer les skills dans l’écosystème Claude Code

Une skill est une capacité réutilisable que Claude Code peut charger quand une situation le justifie. Elle peut contenir des instructions, un workflow, des connaissances de domaine, des exemples, des scripts, des templates ou des fichiers de référence.
Son rôle n’est pas de remplacer la mémoire du projet, ni les permissions, ni les hooks, ni les sous-agents. Son rôle est de rendre disponible une capacité spécialisée sans la charger en permanence dans toutes les sessions.

Une skill n’est pas simplement un prompt sauvegardé. Dans Claude Code, une skill est un dossier structuré, avec un fichier d’entrée SKILL.md et, si nécessaire, des fichiers de support. Le fichier principal explique quand et comment utiliser la skill. Les fichiers annexes permettent de fournir des checklists, exemples, scripts ou références sans alourdir la description principale.

La bonne question n’est donc pas seulement : « Comment créer une skill ? » La bonne question est : « Ce besoin doit-il vraiment devenir une skill ? » Un projet Claude Code mature utilise plusieurs mécanismes de pilotage. Chacun a une portée différente, un coût de contexte différent et une autorité différente.

Le problème que les skills résolvent
Éviter de tout mettre dans CLAUDE.md
CLAUDE.md doit rester court. Il porte les invariants qui doivent être visibles dans presque toutes les sessions : commandes de validation, architecture du projet, conventions non évidentes, pièges récurrents et contraintes stables. S’il devient un manuel complet, il consomme du contexte à chaque session, même lorsque la plupart de son contenu n’est pas utile à la tâche courante.

Les skills répondent à ce problème. Elles permettent de sortir de la mémoire principale les procédures qui ne servent que parfois.

Exemples de contenu à ne pas mettre dans CLAUDE.md :
procédure complète de release ;
checklist longue de revue ;
workflow d'ajout d'une fonctionnalité ;
procédure de vérification produit ;
audit de dette technique ;
instructions spécifiques à un sous-dossier ;
recette de lancement d'une application complexe.

Ces contenus sont utiles, mais ils ne doivent pas être chargés à chaque session. Une skill permet de les charger quand ils deviennent pertinents.

Charger une capacité au bon moment
Une skill possède une description. Cette description sert à indiquer à Claude Code quand la skill peut être pertinente.
Le corps complet de la skill n’a pas besoin d’être présent en permanence dans le contexte. Il est chargé quand la skill est invoquée, manuellement ou automatiquement selon la configuration.

CLAUDE.md :
toujours utile.
Skill :
utile dans certains workflows.
Sous-agent :
utile pour une tâche isolée ou volumineuse.
Hook :
utile pour une action déterministe.
MCP :
utile pour ajouter des outils ou données externes.

Cette logique rend les skills particulièrement adaptées aux workflows récurrents : vérifier un produit, préparer une revue, diagnostiquer une commande, auditer de la dette, piloter une migration ou appliquer une checklist spécifique.

Ce qu’est une skill
Un dossier de capacité
Une skill projet vit dans un dossier comme .claude/skills/<nom>/. Son point d’entrée est SKILL.md. Le reste du dossier est optionnel, mais c’est souvent là que les skills deviennent vraiment utiles.

.claude/
skills/
techdebt/
SKILL.md
references/
checklist.md
examples/
report.md
scripts/
scan-techdebt.sh

SKILL.md doit rester lisible et orienté usage. Il ne doit pas devenir une archive exhaustive. Les détails longs vont dans references/. Les scripts vont dans scripts/. Les exemples de sortie vont dans examples/. Cette structure permet à Claude Code de charger progressivement ce dont il a besoin.

Un workflow réutilisable
Une skill doit encapsuler une manière de travailler. Elle n’est pas seulement un rappel général. Elle doit dire ce qu’il faut produire, quelles contraintes respecter, quels outils utiliser ou éviter, quelles sorties attendre et quels pièges surveiller.

Bonne skill :
audite la dette technique après une session de développement.
Produit un rapport classé par risque.
Ne modifie aucun fichier sans demande explicite.
Signale les tests manquants, duplications et incohérences d'architecture.

Mauvaise skill :
sois rigoureux et fais du bon code.

La première skill décrit un workflow. La seconde répète une intention trop générale. Une skill utile pousse Claude Code vers un comportement spécifique, observable et réutilisable.

Ce qu’une skill n’est pas
Ce n’est pas une mémoire toujours active
Une information qui doit être présente dans toutes les sessions appartient plutôt à CLAUDE.md. Une skill est faite pour être disponible quand elle est pertinente, pas pour porter les invariants fondamentaux du projet.

À mettre dans CLAUDE.md :
la couche métier ne dépend d'aucun framework.
la couche d'entrée-sortie valide les entrées et formate les réponses.
les commandes de validation sont lint, test et build.
les migrations ne se lancent jamais automatiquement.

À mettre dans une skill :
procédure de release ;
checklist de vérification produit ;
audit de dette technique ;
workflow de revue de diff.

Si une instruction doit être toujours visible, elle ne doit pas attendre l’invocation d’une skill. Si elle ne sert que dans certains workflows, elle ne doit pas grossir CLAUDE.md.

Ce n’est pas un contrôle de sécurité
Une skill guide Claude Code. Elle ne remplace pas une permission, un hook, un test ou une sandbox. Si une action doit être bloquée, elle doit être bloquée par une couche de contrôle.

Instruction dans une skill :
ne pousse pas vers le remote pendant cette procédure.
Contrôle effectif :
Bash(git push:*) en deny dans les permissions.

La skill peut rappeler une intention. Les permissions appliquent la limite. Les hooks peuvent automatiser une vérification. Les tests peuvent prouver un comportement. Ces niveaux ne doivent pas être confondus.

Ce n’est pas toujours le bon outil
Un besoin récurrent ne doit pas automatiquement devenir une skill. Il faut d’abord identifier sa nature : instruction permanente, workflow ponctuel, contrôle déterministe, outil externe, tâche isolée ou distribution d’équipe.

Besoin | Mécanisme adapté | Pourquoi
---|---|---
Rappeler l’architecture du projet à chaque session. | CLAUDE.md | Information toujours utile.
Charger une procédure de release seulement au moment de releaser. | Skill | Workflow récurrent mais non permanent.
Empêcher git push. | Permissions | Contrôle d’exécution.
Lancer un linter après une modification. | Hook | Automatisation déterministe.
Analyser beaucoup de fichiers sans polluer la session principale. | Sous-agent | Contexte isolé et retour résumé.
Donner accès à une base de tickets ou à un outil interne. | MCP | Nouvelle surface d’outil externe.
Distribuer skills, hooks, agents et MCP ensemble. | Plugin | Packaging multi-composants.

Les mécanismes à distinguer
CLAUDE.md
CLAUDE.md est la mémoire de projet. Il charge des instructions persistantes, visibles pendant la session. Il convient aux invariants stables : commandes de validation, architecture, conventions propres au dépôt, contraintes de séparation et erreurs récurrentes à ne plus refaire.

Bon usage :
la couche métier reste pure.
la couche d'entrée-sortie ne contient pas de logique métier.
chaque fonctionnalité a des tests.

Mauvais usage :
coller toute la procédure de release avec vingt étapes.

La mémoire doit rester courte. Une procédure longue devient rapidement une dette de contexte.

.claude/rules/
Les règles complètent CLAUDE.md quand une instruction doit s’appliquer à une zone précise du code. Elles sont particulièrement utiles avec paths, lorsque le projet contient plusieurs sous-domaines ou packages.

Usage adapté :
règle spécialisée pour packages/api/** ;
règle spécialisée pour packages/web/** ;
règle propre à un dossier de tests.

Une règle est plus proche d’une instruction contextuelle ciblée. Une skill est plus proche d’un workflow réutilisable.

Skill
Une skill charge un workflow ou une expertise seulement quand elle est pertinente. Elle peut être invoquée manuellement avec une commande slash, ou proposée automatiquement selon sa description et son contexte.

Exemples de skills projet :
/release
/review-diff
/techdebt
/db-migrate

Ces skills ne doivent pas être dans CLAUDE.md. Elles sont utiles, mais pas à chaque minute de chaque session.

Hook
Un hook s’exécute lors d’un événement du cycle de vie : avant un outil, après une modification, au démarrage ou à la fin d’une session selon la configuration disponible. Il est adapté aux comportements déterministes.

Exemples :
bloquer une commande dangereuse ;
lancer une vérification après une modification ;
journaliser une action ;
injecter un message d'erreur contrôlé.

Une skill dit à Claude comment travailler. Un hook exécute une logique lorsque l’événement survient.

Sous-agent
Un sous-agent travaille dans un contexte isolé. Il convient aux recherches volumineuses, revues en contexte frais, analyses de logs, explorations de code ou tâches parallèles qui ne doivent pas charger tout leur historique dans la session principale.

Usage adapté :
revue de diff indépendante ;
audit de dette sur plusieurs dossiers ;
exploration d'un module inconnu ;
analyse d'une erreur longue.

Une skill peut déclencher un sous-agent si elle utilise un mode d’exécution isolé. Dans ce cas, la skill fournit le workflow, et le sous-agent fournit l’isolation de contexte.

MCP
MCP sert à ajouter des outils ou des données externes. Si le besoin est d’interroger une base, un outil interne, un gestionnaire de tickets, une API documentaire ou une ressource externe structurée, ce n’est pas une skill seule qui convient. Il faut un outil.

Usage adapté de MCP :
lire une issue ;
interroger une base ;
chercher dans une documentation interne ;
récupérer l'état d'une CI ;
accéder à une source externe structurée.

Une skill peut expliquer quand utiliser un outil MCP, mais elle ne remplace pas l’outil lui-même.

Plugin
Un plugin sert à distribuer plusieurs composants ensemble : skills, hooks, agents, serveurs MCP, styles de sortie ou réglages.
Il devient pertinent quand une équipe veut partager un paquet cohérent d’extensions, pas seulement une skill isolée.

Usage adapté :
bibliothèque interne de workflows ;
package d'outillage pour plusieurs dépôts ;
distribution d'un ensemble skill + hook + agent + MCP.

En pratique, les premières skills d’un projet restent au niveau projet. Le plugin ne vient que si ces capacités deviennent utiles dans plusieurs dépôts.

Les skills et le coût de contexte
Pourquoi les skills sont peu coûteuses par défaut
Une skill est visible par son nom et sa description. Son contenu complet n’est pas chargé tant qu’elle n’est pas utilisée. Ce comportement est la raison principale de son intérêt : elle permet d’avoir une bibliothèque de workflows sans gonfler chaque session.

Skill disponible :
le nom et la description aident Claude à savoir qu'elle existe.
Skill invoquée :
le contenu du SKILL.md et les ressources utiles entrent dans la tâche.

Cette propriété encourage une architecture de contexte plus propre. Les invariants restent dans la mémoire. Les procédures restent disponibles, mais ne consomment pas de contexte tant qu’elles ne sont pas utiles.

La description est un déclencheur
La description d’une skill n’est pas un texte marketing. Elle doit aider Claude Code à décider quand utiliser la skill. Une bonne description mentionne le cas d’usage, les signaux de déclenchement et la sortie attendue.

Description faible :
Aide à faire de la dette technique.
Description utile :
Analyse les changements récents pour repérer duplication, logique placée dans la mauvaise couche

Une description trop vague déclenche mal. Une description trop large peut déclencher trop souvent. Une description précise rend la skill plus fiable.

Application à un projet
Ce qui reste dans la mémoire
Un projet possède des invariants. Ils doivent rester dans CLAUDE.md, car ils sont toujours utiles.

Invariants à garder dans CLAUDE.md :
l'architecture en couches du projet ;
la separation entre logique métier et entrées-sorties ;
les commandes de validation ;
les contraintes produit stables.

Ces informations ne sont pas des workflows. Ce sont des contraintes transversales. Elles guident toutes les sessions.

Ce qui devient une skill
Les workflows récurrents doivent sortir de la mémoire principale. Ils deviendront des skills projet.

Skill future | Usage | Pourquoi une skill
---|---|---
/release | Préparer et publier une version. | Workflow récurrent mais non permanent.
/review-diff | Revue systématique d’un diff avant validation. | Procédure répétable de fin de tâche.
/techdebt | Auditer dette, duplication et incohérences. | Analyse de fin de session qui ne doit pas être toujours chargée.

Ces skills sont créées quand le besoin se stabilise. L’objectif à ce stade est de savoir pourquoi elles doivent exister et pourquoi elles ne doivent pas être collées dans CLAUDE.md.

Ce qui doit rester un contrôle
Certains besoins ne doivent pas devenir des skills, car ils doivent être imposés.

À garder en permissions ou hooks :
refuser git push ;
refuser la lecture de .env ;
contrôler les commandes réseau ;
lancer une vérification déterministe ;
bloquer une action hors périmètre.

Une skill peut rappeler ces règles, mais elle ne doit pas être le seul garde-fou.

Où vivent les skills
Portée personnelle, projet, plugin ou entreprise
L’emplacement d’une skill détermine qui peut l’utiliser. Une skill personnelle convient à un usage individuel. Une skill projet convient à un dépôt et doit être versionnée. Une skill de plugin convient à une distribution plus large. Une skill gérée par l’organisation convient aux standards internes.

Portée | Emplacement type | Usage
---|---|---
Personnelle | ~/.claude/skills/<nom>/SKILL.md | Disponible dans tous les projets de l’utilisateur.
Projet | .claude/skills/<nom>/SKILL.md | Versionnée avec le dépôt.
Plugin | <plugin>/skills/<nom>/SKILL.md | Distribuée avec un ensemble d’extensions.
Entreprise | Paramètres gérés | Politique ou workflow commun à l’organisation.

Les premières skills d’un projet sont des skills projet, dans .claude/skills/. Elles appartiennent au dépôt et doivent être revues comme le reste de la configuration.

Cas des monorepos
Dans un monorepo, une skill peut être placée au niveau racine ou dans un sous-dossier. Une skill racine porte un workflow transversal. Une skill imbriquée porte un workflow propre à un package ou à une zone.

.claude/skills/techdebt/SKILL.md
packages/api/.claude/skills/db-migrate/SKILL.md
packages/web/.claude/skills/build-check/SKILL.md

Ce placement évite de rendre toutes les skills visibles de la même manière. Une procédure propre à un package ne doit pas polluer les travaux sur un autre.

Matrice de décision
Choisir le bon mécanisme
La matrice suivante sert à classer les besoins avant de créer une skill. Elle doit être utilisée comme filtre de conception.

Question | Si oui | Mécanisme
---|---|---
Cette information doit-elle être visible dans presque toutes les sessions ? | Oui. | CLAUDE.md
Cette consigne concerne-t-elle une zone précise du dépôt ? | Oui. | .claude/rules/
Ce workflow revient-il souvent, mais seulement dans certains cas ? | Oui. | Skill
Cette action doit-elle se déclencher automatiquement sur un événement ? | Oui. | Hook
Cette action doit-elle être bloquée ou approuvée mécaniquement ? | Oui. | Permissions
Cette tâche doit-elle travailler dans un contexte isolé ? | Oui. | Sous-agent
Ce besoin exige-t-il un outil ou une donnée externe ? | Oui. | MCP
Cette capacité doit-elle être distribuée avec plusieurs composants ? | Oui. | Plugin

Si plusieurs lignes semblent vraies, il faut souvent combiner les mécanismes. Par exemple, une skill de release peut être manuelle, utiliser des permissions strictes, appeler des scripts déterministes et être distribuée plus tard dans un plugin.
