Le chapitre 5 a montré ce que Claude Code peut voir : le dossier de lancement devient l’espace de travail principal, /add-dir et --add-dir ouvrent un dossier supplémentaire, /cd déplace la session vers un autre dossier principal, et le projet n’est jamais injecté en entier. Cette leçon part de là et va plus loin sur le contrôle : comment rendre un accès persistant, ce qui se charge vraiment quand on ouvre un dossier, et quels chemins restent protégés même dans des modes plus fluides.

L’accès au disque n’est pas identique à la configuration du projet. Ajouter un répertoire donne accès à ses fichiers, mais ne transforme pas automatiquement ce répertoire en nouvelle racine de configuration. Cette distinction est essentielle dans les monorepos, les projets multi dépôts et les environnements où plusieurs packages doivent être modifiés dans une même tâche.

Rappel : ce qui a déjà été vu
Trois points sont acquis et ne sont pas repris ici en détail.

Élément | Rôle (vu au chapitre 5)
---|---
Dossier de lancement | Devient l’espace de travail principal ; lancer à la racine ou dans un sous-dossier change la surface visible.
/add-dir et --add-dir | Ouvrent un dossier supplémentaire, en session ou au démarrage, sans déplacer la session.
/cd | Déplace la session vers un autre dossier principal.

La suite traite ce que le chapitre 5 n’a pas abordé : la persistance de ces accès, leur effet réel sur le chargement de configuration, les chemins protégés et les règles Cd.

Ce que /cd relocalise vraiment
/cd ne se contente pas de changer de dossier : il relocalise la session. Le CLAUDE.md du nouveau répertoire est chargé, et la reprise par --resume retrouve la session depuis ce nouveau contexte.

/cd ../web
# La session bascule vers ../web : son CLAUDE.md est chargé
# et --resume repart de ce contexte.

C’est la différence de fond avec /add-dir, qui élargit l’accès sans charger la configuration d’instructions du dossier ouvert.

Le comportement de cd dans Bash
Une commande cd vers un chemin situé dans le répertoire de travail ou dans un répertoire supplémentaire est considérée comme lecture seule et ne déclenche pas d’invite. Une commande composée comme cd packages/api && ls s’exécute sans invite quand chaque partie est elle-même autorisée. Si le changement aboutit hors des répertoires permis, Claude Code réinitialise le shell vers le répertoire du projet. Les sous-agents ne reportent pas ces changements de répertoire de la même manière.
Ce comportement évite qu’une commande shell déplace progressivement la session vers une zone non autorisée du système de fichiers. Le répertoire de travail reste borné par les espaces de travail connus de Claude Code.

Rendre l’accès persistant
permissions.additionalDirectories
/add-dir et --add-dir valent pour une session. Pour une équipe ou un projet qui a régulièrement besoin d’accéder à plusieurs packages, écrivez la configuration dans .claude/settings.json. permissions.additionalDirectories donne accès à des répertoires frères, et les chemins relatifs se résolvent par rapport au répertoire depuis lequel Claude Code est lancé.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "additionalDirectories": [
      "../shared",
      "../web"
    ]
  }
}

Cette configuration est adaptée si, depuis packages/api, Claude doit aussi lire ou modifier packages/shared et packages/web. Elle doit être versionnée seulement si toute l’équipe a besoin du même accès.

Projet, local ou utilisateur
Placez les répertoires communs dans .claude/settings.json. Placez vos répertoires personnels dans .claude/settings.local.json. Les listes fusionnent entre portées : un fichier local peut ajouter des chemins à la configuration validée, mais ne sert pas à retirer les chemins partagés.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "additionalDirectories": [
      "../fixtures-locales"
    ]
  }
}

Une règle d’équipe ne doit pas dépendre d’un fichier local. Si le projet ne fonctionne correctement qu’avec un répertoire frère, il doit être documenté et configuré dans la portée projet.

Accès aux fichiers et chargement de configuration
Ajouter un répertoire donne accès aux fichiers
Un répertoire ajouté devient une zone où Claude peut lire et modifier des fichiers. Cela ne fait pas de ce répertoire une racine de configuration complète : la plupart de la configuration .claude/ n’est pas découverte depuis les répertoires supplémentaires.
Cette distinction évite un piège fréquent. Dans un monorepo, ajouter ../shared permet de modifier le package partagé. Cela ne veut pas dire que le CLAUDE.md, les hooks ou tous les paramètres du package partagé deviennent automatiquement ceux de la session.

Exceptions pour les répertoires ajoutés avec /add-dir
Quelques types de configuration se chargent en exception, et uniquement pour les répertoires ajoutés avec --add-dir ou /add-dir : les skills sous .claude/skills peuvent se charger avec rechargement en direct, les sous-agents sous .claude/agents peuvent se charger, et seules certaines clés de paramètres sont prises en compte. Les fichiers CLAUDE.md, .claude/rules et CLAUDE.local.md ne se chargent depuis ces répertoires que si la variable d’environnement prévue à cet effet est définie. Les chemins listés dans permissions.additionalDirectories accordent uniquement l’accès aux fichiers, sans ces exceptions.

Source dans un répertoire ajouté | Comportement général
---|---
.claude/skills | Peut être chargé avec /add-dir, avec rechargement en direct.
.claude/agents | Peut être chargé avec /add-dir.
.claude/settings.json | Seules certaines clés sont concernées.
CLAUDE.md et .claude/rules | Chargement conditionnel selon la variable d’environnement dédiée.
permissions.additionalDirectories | Accès aux fichiers uniquement, pas de chargement de configuration additionnelle.

La règle pratique est simple : ajoutez un répertoire pour ses fichiers, pas pour importer toute sa politique. Pour partager une configuration, utilisez plutôt la portée utilisateur, un plugin, un fichier de paramètres projet ou démarrez directement Claude Code depuis le répertoire qui porte cette configuration.

Doser l’accès dans un monorepo
Garder un accès proportionné
Dans un monorepo, il est tentant de tout rendre accessible. Ce n’est pas toujours souhaitable. Un agent qui peut lire et modifier tout le dépôt peut aussi explorer plus large, produire un diff plus dispersé et toucher des zones qui n’étaient pas dans le périmètre initial. Démarrer dans un package puis ouvrir seulement les dépendances nécessaires réduit cette surface.

Situation :
la session est lancée depuis packages/api.
Besoin :
modifier aussi packages/shared.
Action :
ajouter ../shared comme répertoire supplémentaire.

Avant de modifier plusieurs packages :
indique les packages concernés ;
justifie pourquoi chacun doit être accessible ;
n’ajoute aucun autre répertoire ;
arrête-toi si un changement exige un troisième package.

L’accès multi dossiers doit rester proportionné à la tâche. Il faut accorder les répertoires nécessaires, pas transformer une correction locale en exploration globale.

Chemins protégés
Ce que protège Claude Code
Claude Code protège certains chemins dont les écritures ne sont jamais auto approuvées sauf en mode bypassPermissions. Ces chemins existent pour empêcher la corruption accidentelle de l’état du dépôt et de la configuration de Claude. En default, acceptEdits et plan, ces écritures demandent une validation ; en auto, elles sont routées vers le classificateur ; en dontAsk, elles sont refusées ; en bypassPermissions, elles sont autorisées.
Cette protection ne concerne pas seulement les secrets. Elle vise aussi des fichiers qui peuvent modifier le comportement du dépôt, du shell, du gestionnaire de paquets, des hooks Git, de l’IDE, des conteneurs ou de Claude Code lui-même.

Répertoires protégés
Les répertoires protégés incluent .git, .config/git, .vscode, .idea, .husky, .cargo, .devcontainer, .yarn, .mvn et .claude, avec une exception pour .claude/worktrees où Claude stocke ses propres données.

Exemples de zones sensibles :
.git
.husky
.devcontainer
.claude
.vscode
.idea

Ces répertoires ont une importance structurelle. Une modification peut changer les hooks, les worktrees, l’environnement de développement, les réglages de l’agent ou le comportement du dépôt.

Fichiers protégés
Les fichiers protégés incluent .gitconfig, .gitmodules, plusieurs fichiers de configuration shell, .envrc, .npmrc, .yarnrc, bunfig.toml, des fichiers de configuration de hooks, des wrappers de build, .devcontainer.json, .mcp.json et .claude.json.

Exemples de fichiers sensibles :
.gitconfig
.gitmodules
.envrc
.npmrc
.devcontainer.json
.mcp.json
.claude.json

Un fichier protégé n’est pas forcément un secret. Il peut être protégé parce qu’il change la manière dont les outils s’exécutent, dont les dépendances se chargent, dont les hooks se déclenchent ou dont l’agent se configure.

Une règle allow ne préapprouve pas les chemins protégés
Une règle permissions.allow ne suffit pas à préapprouver les écritures dans les chemins protégés. La vérification de sécurité s’exécute avant l’évaluation des règles allow, donc une entrée comme Edit(.claude/**) ne change pas le comportement par mode pour ces chemins.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Edit(.claude/**)"
    ]
  }
}

Dans les modes qui demandent une validation, l’invite d’écriture dans .claude/ propose une option « Yes, and allow Claude to edit its own settings for this session », qui approuve les écritures .claude/ suivantes pour la session sans redemander. Cette règle ne doit pas servir à rendre silencieuses les écritures dans .claude : une modification de configuration doit être explicitement relue et validée.

Chemins sensibles et secrets
Protéger la lecture, pas seulement l’écriture
Les chemins protégés concernent surtout les écritures auto approuvées. Cela ne suffit pas pour les secrets. Un fichier .env, une clé privée, un jeton cloud ou un fichier d’identifiants peut causer un problème dès la lecture, car son contenu peut entrer dans le contexte ou être écrit dans une transcription locale.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(**/.env)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Read(~/.kube/**)"
    ]
  }
}

Cette règle ne remplace pas les chemins protégés intégrés. Elle les complète. Les chemins protégés évitent certaines écritures sensibles ; les règles Read empêchent l’exposition de données.

Faire attention aux répertoires ajoutés
Lorsque vous ajoutez un répertoire, vous ajoutez aussi la possibilité que Claude y lise des fichiers sensibles. Avant d’ajouter un dépôt frère ou un dossier de fixtures, vérifiez s’il contient des fichiers d’environnement, des exports, des clés, des dumps ou des données personnelles.

Avant /add-dir :
vérifier les fichiers sensibles ;
limiter le répertoire ajouté ;
refuser les lectures de secrets ;
éviter les dumps volumineux ;
préférer des données fictives.

Ajouter un répertoire est une extension de confiance. Ce n’est pas seulement une commodité de navigation.

Règles Cd et déplacements contrôlés
Quand contrôler /cd
Les règles Cd contrôlent les répertoires vers lesquels /cd peut déplacer la session. Cd n’est pas un outil invocable par le modèle : Claude ne peut pas l’appeler, et les règles ne s’appliquent que lorsque vous lancez /cd vous-même. Une règle de refus Cd sans argument désactive entièrement /cd. Ajouter une règle d’autorisation Cd fait passer /cd en mode liste blanche : le répertoire cible résolu doit correspondre à l’une des règles autorisées, sinon /cd refuse. Sans règle Cd, /cd conserve son comportement par défaut et demande de faire confiance à un répertoire inconnu.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Cd(~/code/projets/**)"
    ],
    "deny": [
      "Cd(~/Telechargements/**)"
    ]
  }
}

Cette règle est utile pour les équipes qui veulent empêcher la session de se déplacer vers des dossiers non contrôlés, tout en permettant le travail dans un ensemble connu de dépôts.

Chemins résolus et liens symboliques
Les règles de refus vérifient chaque écriture du chemin cible, y compris chacun des sauts de liens symboliques qu’il traverse. Une règle écrite pour un chemin bloque donc aussi les cibles qui se résolvent vers ce chemin. C’est important dans les monorepos, les worktrees et les environnements où des dossiers sont liés symboliquement.
Il ne suffit pas de regarder le chemin apparent. Il faut aussi réfléchir au chemin réel atteint par les liens symboliques.

Combiner répertoires, permissions et sandbox
Les répertoires définissent la surface
/add-dir et permissions.additionalDirectories définissent où Claude peut travailler. Les règles Read, Edit, Bash et WebFetch définissent ce qui peut être fait dans cette surface. Le sandbox limite ce qu’une commande Bash peut atteindre au niveau du système d’exploitation.

Mécanisme | Question contrôlée
---|---
/add-dir | Quels répertoires supplémentaires sont accessibles dans cette session ?
permissions.additionalDirectories | Quels répertoires supplémentaires sont accessibles durablement ?
/cd | Quel est le répertoire principal de la session ?
Chemins protégés | Quelles écritures ne doivent pas être auto approuvées ?
Règles Read et Edit | Quels chemins doivent être lus, édités, demandés ou refusés ?
Sandbox | Quelles limites système s’appliquent aux commandes Bash ?

Défense en profondeur
Permissions et sandbox sont complémentaires : les permissions empêchent Claude d’essayer d’accéder à certaines ressources, tandis que le sandbox empêche les commandes Bash d’atteindre des ressources hors limites si elles s’exécutent. Les restrictions de sandbox peuvent aussi se combiner avec les règles Read, Edit et WebFetch.
La bonne configuration ne dépend donc pas d’un seul mécanisme. Elle combine une surface de travail limitée, des règles déterministes, des chemins protégés, un sandbox lorsque nécessaire et une relecture du diff.

Protocoles recommandés
Configurer un accès persistant d’équipe

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "additionalDirectories": [
      "../shared",
      "../web"
    ],
    "deny": [
      "Read(../shared/.env)",
      "Read(../web/.env)",
      "Read(**/.env)"
    ]
  }
}

Cette configuration donne accès aux packages nécessaires, tout en bloquant les fichiers d’environnement dans ces zones.

Travailler sur un chemin protégé
Avant toute modification dans une zone protégée :
explique le changement exact ;
indique le fichier visé ;
justifie pourquoi une règle ou un hook ne suffit pas ;
ne modifie rien sans validation explicite ;
prépare un diff minimal.

Cette méthode est adaptée aux changements dans .claude, .github, .devcontainer, .husky ou les fichiers de configuration de paquets.

Vérifier l’état des répertoires accessibles
/permissions
Demande à Claude :
liste le répertoire principal ;
liste les répertoires supplémentaires ;
indique lesquels viennent de la session ;
indique lesquels viennent des settings ;
indique les chemins sensibles à ne pas lire.

/permissions montre la politique active, y compris les répertoires supplémentaires accordés. Pour une ligne d’état personnalisée, une donnée workspace.added_dirs représente les répertoires ajoutés par /add-dir ou l’option de démarrage équivalente.

Erreurs fréquentes
Confondre accès aux fichiers et chargement de configuration
Un répertoire ajouté donne accès aux fichiers. Il ne devient pas automatiquement une racine complète de configuration. Pour partager agents, skills, hooks, settings ou instructions, il faut utiliser les mécanismes prévus : portée utilisateur, projet, plugin, paramètres gérés ou démarrage depuis le bon répertoire.

Ajouter tout le monorepo par facilité
Donner accès à tout le dépôt peut être inutilement large. Il vaut mieux démarrer au bon niveau ou ajouter seulement les packages nécessaires.

Oublier les secrets dans un répertoire ajouté
Un dossier frère peut contenir ses propres fichiers .env, fixtures privées ou exports. Ajoutez des règles de refus de lecture avant de l’ouvrir à la session.

Supposer que acceptEdits rend tout modifiable
Les chemins protégés ne sont pas auto approuvés dans les modes ordinaires. Ils demandent validation, passent par le classificateur, sont refusés ou sont autorisés selon le mode actif. Une règle allow ne contourne pas cette protection.

Penser que les règles de fichiers bloquent tout processus
Les règles Read et Edit gouvernent les outils et certaines commandes reconnues. Un script arbitraire exécuté par le shell peut nécessiter une isolation système pour être réellement contenu.
