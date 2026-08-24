Dans Claude Code, une configuration sérieuse ne consiste pas à répéter les mêmes consignes dans chaque prompt. Elle consiste à identifier les comportements récurrents, puis à les déplacer vers la bonne couche de contrôle : settings, allowlists, hooks, paramètres gérés ou skills.
Une habitude devient une politique lorsqu’elle ne dépend plus de la mémoire de l’utilisateur. Si vous acceptez toujours les mêmes commandes de test, elles doivent devenir une allowlist. Si vous répétez toujours « ne touche pas aux fichiers de configuration », cette règle doit devenir une permission, un hook ou une politique gérée. Si vous appliquez toujours le même formatage après modification, il doit être automatisé par un hook. Les hooks exécutent du code à des points précis du cycle de vie et fournissent un contrôle déterministe, au lieu de dépendre du choix du modèle.
Cette leçon ne réexplique pas le modèle allow, ask, deny, ni les modes, ni la syntaxe complète des règles. Elle montre comment passer d’une pratique individuelle à une politique stable, lisible, versionnable et maintenable.

Identifier les habitudes à transformer
Les validations répétitives
La première source de politique vient des validations que vous acceptez toujours. Si une commande revient dans presque chaque session, qu’elle est sûre, qu’elle est bornée, et qu’elle sert à vérifier le travail, elle ne doit pas rester une interruption manuelle permanente.

Exemples d'habitudes a stabiliser :
accepter npm run lint ;
accepter npm run test sur un test cible ;
accepter npm run typecheck ;
accepter gh issue view ;
refuser git push ;
refuser la lecture des fichiers .env.

La commande /fewer-permission-prompts existe précisément pour ce cas. C’est une skill intégrée : elle analyse les transcriptions des sessions récentes (jusqu’à une cinquantaine), repère les appels Bash et MCP fréquents en lecture seule, écarte ceux déjà auto-approuvés et ceux qui équivaudraient à exécuter du code arbitraire, puis fusionne les plus fréquents dans une allowlist priorisée de .claude/settings.json.

/fewer-permission-prompts

Ce n’est pas un bouton pour tout autoriser. C’est un outil de diagnostic et de conversion : il transforme des validations fréquentes en règles de projet candidates, que l’équipe doit relire.

Les corrections répétées dans les prompts
La deuxième source vient des corrections que vous répétez au modèle. Si vous écrivez souvent la même instruction, il faut décider si cette instruction est une convention, une procédure ou un contrôle.

Répétition observée | Bonne destination | Raison
---|---|---
« Utilise toujours cette commande de test » | CLAUDE.md ou skill | C’est une procédure de travail.
« Cette commande est toujours sûre » | permissions.allow | C’est une autorisation répétitive.
« Ne lis jamais ce secret » | permissions.deny ou sandbox | C’est une interdiction déterministe.
« Formate après modification » | Hook PostToolUse | C’est une action automatique liée au cycle de vie.
« Bloque les commandes dangereuses » | Hook PreToolUse ou règle deny | C’est un garde-fou d’exécution.
« Toute l’équipe doit appliquer cette règle » | .claude/settings.json ou paramètres gérés | C’est une politique partagée.

La règle est simple : une convention va dans les instructions ; une autorisation va dans les permissions ; une action automatique va dans un hook ; une obligation d’organisation va dans les paramètres gérés.

Choisir la bonne couche
CLAUDE.md pour guider
CLAUDE.md reste utile pour les informations que Claude doit connaître : commandes recommandées, architecture du projet, conventions, pièges connus, structure des dossiers, critères de qualité. Mais ce fichier reste une instruction contextuelle. Il influence le comportement du modèle ; il ne constitue pas une barrière d’exécution.

A mettre dans CLAUDE.md :
commande de test recommandee ;
style de code ;
architecture du module ;
procedure de release ;
conventions de nommage ;
pieges connus du projet.

Lorsque la règle doit être appliquée sans dépendre de la bonne interprétation du modèle, elle doit quitter CLAUDE.md et aller vers les permissions, les hooks ou les paramètres gérés. Les règles de permission sont appliquées par Claude Code, pas par le modèle : les prompts et CLAUDE.md ne font que façonner ce que Claude essaie de faire, sans changer ce que Claude Code autorise.

settings pour déclarer
Les fichiers settings.json sont la couche déclarative. Ils conviennent aux règles de permission, au mode par défaut, aux paramètres de sandbox, aux variables d’environnement, aux plugins, aux hooks et aux choix partagés par un projet. Les fichiers principaux sont ~/.claude/settings.json, .claude/settings.json et .claude/settings.local.json. Les paramètres projet sont versionnables, les paramètres locaux servent aux préférences personnelles, et les paramètres gérés ne peuvent pas être contournés par les couches utilisateur ou projet.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Bash(npm run typecheck)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Bash(git push *)"
    ]
  }
}

Cette couche doit rester lisible. Une politique que personne ne comprend ne sera pas maintenue correctement.

Hooks pour imposer une logique
Les hooks servent lorsque la politique dépend d’un événement ou d’une condition : avant une commande, après une modification, au démarrage d’une session, avant une compaction, lors d’une demande de permission ou quand une configuration change. Les événements couvrent tout le cycle de vie, notamment SessionStart et SessionEnd, UserPromptSubmit, PreToolUse et PostToolUse, PermissionRequest et PermissionDenied, Stop, PreCompact et PostCompact, ainsi que des observateurs comme FileChanged, CwdChanged, ConfigChange et InstructionsLoaded.

Un hook est adapté quand une règle doit exécuter du code. Une allowlist dit « cette commande est autorisée ». Un hook peut dire « cette commande doit être journalisée », « cette entrée doit être réécrite », « cette action doit être bloquée si le contexte est production », ou « ce fichier doit être formaté après modification ».

Construire une allowlist saine
Partir des vérifications
Une allowlist doit commencer par les actions qui améliorent la qualité sans produire d’effet externe dangereux : lint, test ciblé, typecheck, inspection Git, consultation d’issues ou commandes de lecture. Ne commencez pas par autoriser une famille trop large comme Bash(npm *) ou Bash(gh *).

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Bash(npm run typecheck)",
      "Bash(gh issue view *)",
      "Bash(git status)",
      "Bash(git diff *)"
    ]
  }
}

L’objectif est de réduire les interruptions sur les actions de vérification, pas d’augmenter l’autonomie générale sans contrôle.

Garder des refus explicites
Une allowlist saine contient aussi des refus. Les refus protègent les secrets, les publications, les actions destructrices, les commandes réseau non souhaitées et les opérations d’infrastructure.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Bash(npm run test *)",
      "Bash(npm run typecheck)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Bash(git push *)",
      "Bash(kubectl delete *)",
      "Bash(terraform apply *)",
      "Bash(curl *)",
      "Bash(wget *)"
    ]
  }
}

Une bonne allowlist ne se juge pas seulement à ce qu’elle autorise. Elle se juge aussi à ce qu’elle interdit sans ambiguïté.

Relire ce que propose /fewer-permission-prompts
/fewer-permission-prompts peut accélérer la construction d’une allowlist, mais la sortie doit être relue. Une commande fréquente n’est pas automatiquement une commande sûre. Une commande en lecture seule peut être acceptable dans un dépôt et inadaptée dans un autre.

/fewer-permission-prompts
Apres generation :
relire les regles proposees ;
supprimer les motifs trop larges ;
garder les commandes verifiables ;
refuser les actions externes ;
committer seulement les regles utiles a l'equipe.

La bonne pratique consiste à utiliser cette commande comme un assistant d’audit, pas comme une autorité finale.

Utiliser les hooks comme politiques exécutables
Bloquer une commande avant exécution
PreToolUse se déclenche après la création des paramètres de l’outil et avant son exécution. Il peut autoriser, refuser, demander une confirmation ou réécrire l’entrée. Les règles de refus et de demande s’appliquent toujours, même si un hook retourne une autorisation.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git push *)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/log_git_push.sh"
          }
        ]
      }
    ]
  }
}

Le script peut lire l’entrée JSON sur stdin, décider, puis retourner une sortie structurée ou un code de sortie. Ce modèle convient aux règles qui exigent une logique de projet ou une vérification externe.

Ne pas faire d’un hook le seul garde fou dur
Le champ if des hooks filtre par outil et arguments, avec la même syntaxe que les règles de permission. Pour une lecture, une édition ou une écriture, il reconnaît les motifs de chemin ; mais pour une commande Bash qui ne peut pas être analysée, le filtrage est au mieux et peut laisser passer. Pour appliquer un refus dur, utilisez le système de permissions plutôt qu’un hook seul.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "deny": [
      "Bash(git push *)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git *)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/log_git.sh"
          }
        ]
      }
    ]
  }
}

Ici, la permission impose le refus. Le hook journalise ou applique une logique complémentaire. C’est une séparation saine.

Automatiser après modification
PostToolUse est adapté aux actions après succès : formater un fichier, injecter un contexte, auditer une modification ou déclencher une vérification légère. Le formatage automatique, l’audit des configurations, la réinjection de contexte et les notifications en sont des modèles courants.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/format_file.sh"
          }
        ]
      }
    ]
  }
}

Un hook de formatage doit rester limité. Il ne doit pas lancer toute la suite de tests, modifier des fichiers sans rapport ou transformer une petite édition en changement large.

Gérer les demandes de permission
PermissionRequest se déclenche lorsqu’un dialogue de permission va être montré à l’utilisateur. Il peut autoriser ou refuser au nom de l’utilisateur, réécrire l’entrée, ou ajouter des règles avec updatedPermissions. Un hook qui retourne allow ne remplace pas une règle deny correspondante.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(npm run lint)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/auto_approve_lint.sh"
          }
        ]
      }
    ]
  }
}

Cette forme est utile pour les équipes qui veulent router certaines validations vers une politique interne, mais il faut garder le matcher étroit. Un matcher vide ou trop large peut approuver automatiquement chaque demande de permission, y compris les écritures et les commandes shell.

Placer les hooks au bon niveau
Portées disponibles
L’endroit où un hook est déclaré détermine son périmètre. Les hooks utilisateur s’appliquent à vos projets, les hooks projet peuvent être commités, les hooks locaux restent propres à une machine, les hooks gérés appartiennent à l’organisation, et les hooks de plugin sont fournis avec le plugin activé.

Emplacement | Usage correct
---|---
~/.claude/settings.json | Automatisations personnelles valables dans plusieurs projets.
.claude/settings.json | Politique ou automatisation partagée par l’équipe du projet.
.claude/settings.local.json | Essai local, préférences personnelles, chemins propres à une machine.
Paramètres gérés | Politique d’organisation imposée.
Plugin | Politique distribuée avec un paquet réutilisable.

Une automatisation utile à toute l’équipe ne doit pas rester dans votre fichier local. Une expérimentation personnelle ne doit pas être commitée dans le projet.

Diagnostiquer les hooks actifs
/hooks affiche les configurations de hooks actives et sert d’éditeur interactif. Pour vérifier ce qui est réellement chargé, /context, /doctor, /hooks, /mcp et /permissions sont les commandes de diagnostic adaptées.

/hooks
/permissions
/doctor
/mcp

Une politique non chargée n’est pas une politique. Avant d’accuser Claude d’ignorer une règle, vérifiez que le fichier attendu est chargé, que le hook apparaît dans /hooks, que le serveur MCP visé existe, et que les permissions résolues correspondent à votre intention.

Paramètres gérés et politiques d’organisation
Quand passer au niveau géré
Un projet peut définir une politique partagée avec .claude/settings.json. Une organisation peut imposer une politique avec les paramètres gérés. Les paramètres gérés prennent la priorité sur les configurations locales et ne peuvent pas être contournés par les paramètres utilisateur ou projet. Ils peuvent être livrés depuis la console d’administration, par MDM, par registre Windows ou par fichiers système.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "deny": [
      "Read(//etc/secrets/**)",
      "Bash(kubectl delete *)",
      "Bash(terraform apply *)"
    ]
  },
  "allowManagedPermissionRulesOnly": true
}

Ce type de politique convient aux environnements où l’équipe ne doit pas pouvoir élargir localement les permissions : production, sécurité, infrastructure, données sensibles, postes administrés ou pipelines.

Limiter les hooks non gérés
Les paramètres gérés peuvent aussi contrôler les hooks. Le paramètre allowManagedHooksOnly permet de charger seulement les hooks gérés, les hooks SDK, et les hooks de plugins activés de force par l’organisation. Les hooks utilisateur, projet et autres hooks de plugins sont alors bloqués.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "allowManagedHooksOnly": true
}

C’est pertinent si les hooks sont eux-mêmes une surface de risque. Un hook peut exécuter du code, appeler un service HTTP ou modifier une décision de permission. Il doit donc être gouverné comme un composant d’exécution, pas comme une simple note de projet.

Transformer une procédure en skill plutôt qu’en hook
Quand utiliser une skill
Une skill est préférable lorsqu’il s’agit d’une procédure intellectuelle ou opérationnelle que Claude doit suivre : revue de sécurité, migration, checklist de release, analyse de logs, guide de refactor ou workflow de diagnostic. Les skills chargent des instructions et des workflows quand ils sont pertinents.

A transformer en skill :
checklist de code review ;
procedure de migration ;
methode de diagnostic ;
guide de release ;
routine d'audit.

Un hook exécute automatiquement une action à un événement. Une skill fournit une procédure que Claude peut invoquer. Ne mettez pas dans un hook ce qui demande du jugement, une analyse ou une stratégie.

Quand ne pas utiliser une skill
Une skill ne doit pas remplacer une politique de sécurité. Si l’objectif est de bloquer une lecture, refuser une commande ou imposer un sandbox, utilisez les permissions, les hooks ou les paramètres gérés. La skill guide ; elle n’impose pas seule une frontière d’exécution.

Workflow de conversion
Étape 1 : observer
Commencez par identifier ce qui revient souvent : commandes acceptées, refus répétés, erreurs d'usage, questions latérales, corrections fréquentes, sorties trop longues, modifications de fichiers sensibles. La skill /insights lit les mêmes transcriptions et produit un rapport des points de friction et des règles CLAUDE.md tirées de vos instructions les plus répétées.

/permissions
/fewer-permission-prompts
/hooks
/insights

Étape 2 : classer

Observation | Décision
---|---
Commande sûre et répétitive | Ajouter à permissions.allow.
Commande dangereuse | Ajouter à permissions.deny.
Action légitime mais contextuelle | Garder en ask.
Action à exécuter après événement | Créer un hook.
Procédure longue répétée | Créer une skill.
Règle obligatoire pour l’organisation | Déployer en paramètres gérés.

Étape 3 : écrire petit
Écrivez d’abord une règle étroite. Une politique large doit être justifiée par des preuves d’usage et par un risque faible.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "permissions": {
    "allow": [
      "Bash(npm run test *)"
    ],
    "ask": [
      "Bash(git commit *)"
    ],
    "deny": [
      "Bash(git push *)"
    ]
  }
}

Étape 4 : tester
/permissions
/hooks
/doctor

Demande de test :
indique quelles regles sont actives ;
explique quel fichier les fournit ;
ne modifie rien ;
propose une commande sure qui devrait passer ;
propose une commande qui devrait etre refusee.

Une politique doit être testée comme du code. Si elle ne produit pas le comportement attendu, il faut diagnostiquer le nom d’outil, la portée, la fusion des paramètres, le hook chargé ou le matcher.

Étape 5 : versionner ou garder local
Quand la règle appartient à l’équipe, placez-la dans .claude/settings.json et commitez-la. Quand elle dépend de votre machine, gardez-la dans .claude/settings.local.json. Quand elle doit être obligatoire, utilisez les paramètres gérés.

Erreurs fréquentes
Tout mettre dans CLAUDE.md
CLAUDE.md guide le modèle, mais ne force pas l’exécution. Les interdictions, les allowlists et les automatismes doivent aller dans les permissions, les hooks, le sandbox ou les paramètres gérés.

Créer un hook trop large
Un hook avec un matcher vide ou trop général peut s’exécuter sur trop d’actions. Cela augmente le coût, le risque d’effets secondaires et la difficulté de diagnostic.

Autoriser ce que l’on voulait seulement vérifier
Une commande fréquente n’est pas forcément une commande sûre. Une allowlist doit être relue en fonction du risque, pas seulement de la fréquence.

Faire dépendre une politique d’un fichier local
Si une règle est nécessaire à l’équipe, elle doit être dans le projet ou dans les paramètres gérés. Un fichier local ne garantit rien pour les autres développeurs.

Utiliser un hook comme seul blocage de sécurité
Un hook peut renforcer la politique, mais les refus durs doivent être exprimés dans les permissions ou dans une politique gérée. Les hooks peuvent échouer, être mal placés ou avoir des matchers trop larges.

Ne pas diagnostiquer la configuration résolue
Les problèmes de configuration viennent souvent d’un fichier non chargé, d’un mauvais emplacement, d’un autre fichier qui remplace la valeur, ou d’un serveur MCP absent. Utilisez /permissions, /hooks, /mcp, /context et /doctor avant de modifier la politique.

Table de décision

Besoin | Mécanisme recommandé | Pourquoi
---|---|---
Réduire des permissions répétitives | /fewer-permission-prompts puis allowlist relue | Transformer l’usage observé en règles candidates.
Préautoriser une commande sûre | permissions.allow | Éviter une interruption inutile.
Bloquer un risque déterministe | permissions.deny ou paramètre géré | Ne pas dépendre de l’attention humaine.
Demander validation selon contexte | permissions.ask | Conserver le jugement humain.
Exécuter une action sur événement | Hook | Automatiser un comportement déterministe.
Standardiser une procédure longue | Skill | Charger une méthode quand elle est pertinente.
Imposer une règle d’organisation | Paramètres gérés | Empêcher le contournement local.
