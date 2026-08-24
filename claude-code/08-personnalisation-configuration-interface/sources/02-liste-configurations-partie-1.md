# Liste des configurations — partie 1

Cette leçon présente une première série de configurations importantes dans Claude Code. L’objectif n’est pas seulement de lister des interrupteurs d’interface. Il faut comprendre ce que chaque réglage modifie réellement : l’affichage, le contexte, la compaction, le comportement du modèle, les permissions, les workflows ou l’environnement de travail.

Une configuration n’a pas le même statut qu’un prompt. Un prompt agit sur une tâche donnée. Une configuration modifie le cadre dans lequel les sessions s’exécutent. Elle peut changer la manière dont Claude Code affiche ses réponses, compacte l’historique, demande des permissions etc.

Il faut aussi distinguer deux niveaux. Certains réglages sont des clés persistantes dans `settings.json`. D’autres sont exposés dans `/config` mais ne sont pas nécessairement documentés comme clés stables dans le tableau des paramètres. D’autres encore sont des options de session, des variables d’environnement ou des options CLI.

## La commande de configuration

`/config` ouvre l’interface de configuration de Claude Code. C’est le point d’entrée principal pour modifier les réglages interactifs sans éditer directement les fichiers JSON. Les versions récentes permettent aussi d’utiliser une forme directe avec `key=value`.

`/config --help` est important parce que toutes les clés ne sont pas nécessairement disponibles dans toutes les versions, tous les environnements ou tous les plans. Une configuration peut être documentée, mais désactivée dans une session par une politique gérée, une version de CLI, un mode d’exécution ou une fonctionnalité non activée.

```bash
/config
/config --help
/config verbose=true
/config autoCompactEnabled=false
```

`/config` ne remplace pas les fichiers de configuration. Il fournit une interface pour les lire et les modifier. Les valeurs persistantes se retrouvent ensuite dans les fichiers de paramètres appropriés, sauf pour les réglages explicitement temporaires ou session-only.

`/settings` est l’alias de `/config`. Les deux commandes ouvrent la même logique de configuration.

## Commandes et fichiers

Les réglages peuvent provenir de plusieurs couches. La configuration gérée par l’organisation a la priorité la plus forte. Les arguments CLI viennent ensuite. Puis viennent les paramètres locaux du projet, les paramètres partagés du projet, et enfin les paramètres utilisateur.

Cette hiérarchie explique pourquoi un réglage visible dans un fichier peut sembler ne pas s’appliquer. Une couche plus haute peut le remplacer, ou une politique gérée peut le verrouiller. Pour diagnostiquer ce type de situation, il faut inspecter la configuration effective plutôt que supposer que le dernier fichier édité est celui qui décide.

**Priorité (de la plus élevée à la plus basse) :**
- Managed settings
- Arguments CLI
- .claude/settings.local.json
- .claude/settings.json
- ~/.claude/settings.json

## Contexte, historique et continuité

### autoCompactEnabled (Auto-compact)

`autoCompactEnabled` contrôle la compaction automatique de la conversation lorsque le contexte approche de sa limite. Par défaut, ce réglage est activé.

La compaction automatique permet à une session longue de continuer sans saturer la fenêtre de contexte. Elle résume ou transforme une partie de l’historique pour libérer de l’espace. Ce réglage intervient donc directement dans la capacité de Claude Code à maintenir une trajectoire de travail sur une longue session.

Auto-compact protège la continuité, mais transforme l’information. Une session compactée ne donne pas au modèle tout l’historique brut. Elle lui donne une représentation compressée de cet historique. Désactiver ce réglage peut être utile pour diagnostiquer un comportement de compaction, mais ce n’est pas un choix prudent pour les longues sessions.

```json
{
  "autoCompactEnabled": true
}
```

### awaySummaryEnabled (Session recap)

`awaySummaryEnabled` active ou désactive le récapitulatif automatique lorsque l’utilisateur revient au terminal après une absence. Ce réglage correspond à la fonction de session recap.

Le récapitulatif de session est un élément d’interface. Il ne modifie pas le code, ne change pas les permissions et ne remplace pas une synthèse manuelle. Il sert à restituer brièvement ce qui s’est passé pendant que l’utilisateur n’était pas attentif à la session.

`/recap` permet aussi de demander un récapitulatif à la demande.

```json
{
  "awaySummaryEnabled": true
}
```

Ce réglage est utile lorsque des tâches longues, des outils d’arrière-plan ou des workflows continuent pendant que l’utilisateur fait autre chose. Il réduit la perte de continuité sans surcharger le prompt initial.

### fileCheckpointingEnabled (Rewind code)

`fileCheckpointingEnabled` contrôle la création de checkpoints de fichiers avant les modifications. Dans l’interface, ce réglage correspond à Rewind code.

Quand cette option est activée, Claude Code peut conserver des snapshots de fichiers modifiés. Cela rend possible un retour arrière sur les changements de code via les mécanismes de rewind (`/rewind`).

Rewind code est une configuration de réversibilité. Elle ne garantit pas que chaque décision de l’agent sera correcte, mais elle fournit un mécanisme pour revenir sur des modifications de fichiers. Dans un environnement de développement, cette capacité est importante parce que les erreurs les plus coûteuses ne sont pas toujours visibles immédiatement.

```json
{
  "fileCheckpointingEnabled": true
}
```

## Modèle, signalement et raisonnement

### Switch models when a message is flagged

*Switch models when a message is flagged* désigne un réglage exposé dans `/config` pour le comportement de bascule de modèle lorsqu’un message est signalé. La documentation décrit ce cas notamment avec Fable 5 : lorsqu’une requête est signalée, Claude Code peut basculer automatiquement vers le modèle par défaut. Si l’utilisateur désactive cette option dans `/config`, la session demande alors de choisir entre basculer de modèle ou modifier le prompt puis réessayer.

Ce réglage ne doit pas être confondu avec `fallbackModel`. Un modèle de secours sert à gérer certains échecs ou indisponibilités. Le réglage *switch models when a message is flagged* concerne un cas particulier où un message est signalé et où la session décide si elle doit changer automatiquement de modèle.

Dans les sources officielles consultées, ce réglage est décrit comme une option de `/config`, mais il n’est pas exposé dans le tableau principal des clés `settings.json` comme une clé stable à écrire manuellement. Il faut donc éviter d’inventer une clé JSON pour ce comportement. La manière sûre de le modifier est d’utiliser l’interface `/config`.

Ce réglage a une portée pratique importante : il contrôle le niveau d’automatisme accordé à Claude Code lorsqu’un message déclenche un signal de sécurité ou de conformité côté modèle.

### alwaysThinkingEnabled (Thinking mode)

`alwaysThinkingEnabled` active le mode de raisonnement étendu par défaut. Dans l’interface, ce réglage correspond au thinking mode.

Le mode de raisonnement étendu ne doit pas être compris comme une garantie de meilleure réponse dans tous les cas. Il augmente la place donnée au raisonnement interne du modèle, ce qui peut être utile pour des tâches complexes, des corrections délicates, des analyses de code longues ou des décisions avec plusieurs contraintes.

```json
{
  "alwaysThinkingEnabled": false
}
```

Le thinking mode est un réglage de profondeur de raisonnement, pas un réglage d’action. Il ne donne pas plus de droits au modèle, ne modifie pas les permissions et ne remplace pas une vérification externe. Il influence la manière dont le modèle traite la tâche avant de produire sa sortie ou de demander un outil.

### showThinkingSummaries (Affichage des résumés de raisonnement)

`showThinkingSummaries` contrôle l’affichage des résumés de raisonnement étendu dans les sessions interactives.

Ce réglage concerne l’affichage, pas l’activation du raisonnement lui-même. On peut donc distinguer deux choses : activer le mode de raisonnement étendu, et décider si l’interface doit afficher des résumés de ce raisonnement.

```json
{
  "showThinkingSummaries": false
}
```

Dans une configuration sobre, il est possible d’activer le raisonnement étendu tout en gardant l’affichage des résumés désactivé. Cela permet de réduire le bruit visuel sans nécessairement réduire l’effort de raisonnement demandé au modèle.

## Interface, lisibilité et confort d’utilisation

### spinnerTipsEnabled (Show tips)

`spinnerTipsEnabled` active ou désactive les conseils affichés pendant que Claude Code travaille. Dans `/config`, ce réglage correspond à Show tips.

```json
{
  "spinnerTipsEnabled": false
}
```

Ce réglage est purement ergonomique. Il ne change pas les capacités de Claude Code, ne modifie pas le modèle, ne change pas les permissions et n’affecte pas la boucle agentique.

### spinnerTipsOverride (Personnalisation des tips)

Il est aussi possible de personnaliser les conseils affichés via `spinnerTipsOverride`. Cette option permet de remplacer ou compléter les conseils par défaut.

```json
{
  "spinnerTipsOverride": {
    "excludeDefault": true,
    "tips": [
      "Lire le diff avant de conclure.",
      "Vérifier avant de résumer.",
      "Préférer une correction ciblée."
    ]
  }
}
```

Cette configuration peut être utile dans un contexte pédagogique ou d’équipe, mais elle doit rester courte. Des conseils trop nombreux ou trop génériques recréent le bruit que l’on cherchait souvent à supprimer.

### prefersReducedMotion (Reduce motion)

`prefersReducedMotion` réduit ou désactive certaines animations de l’interface. Dans `/config`, ce réglage correspond à Reduce motion.

```json
{
  "prefersReducedMotion": true
}
```

Ce réglage relève de l’accessibilité et du confort d’utilisation. Il est particulièrement pertinent pour les utilisateurs sensibles aux animations, pour les environnements de capture vidéo, ou pour les terminaux où les effets visuels rendent la sortie moins lisible.

Reduce motion ne change pas le comportement agentique. Il change la manière dont l’interface représente l’activité de la session.

### Prompt suggestions

*Prompt suggestions* désigne les suggestions de prompts que Claude Code peut afficher dans certaines situations. Ces suggestions peuvent apparaître au début d’une session ou après certaines réponses, selon le contexte, le mode d’exécution et la disponibilité du cache de prompt.

La suggestion n’est pas un ordre donné au modèle. C’est une aide d’interface. L’utilisateur peut l’accepter, la modifier ou l’ignorer.

Dans les sessions interactives, ce réglage se contrôle via `/config`. Dans les modes non interactifs, il existe aussi une option CLI spécifique :

```bash
claude -p "Analyse les changements du dépôt." --pr
```

Il est également possible de désactiver les suggestions avec une variable d’environnement :

```bash
CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false claude
```

Prompt suggestions doit être compris comme un mécanisme de surface. Il n’étend pas les outils, ne change pas les permissions et ne modifie pas la configuration de sécurité. Il influence seulement la manière dont l’interface aide l’utilisateur à formuler la prochaine demande.

### verbose (Verbose output)

`verbose` active une sortie plus détaillée. Dans `/config`, ce réglage correspond à Verbose output.

```json
{
  "verbose": true
}
```

En mode verbose, Claude Code affiche davantage de détails sur les sorties d’outils et l’activité de la session. C’est utile pour le diagnostic, l’audit, la formation, la compréhension des appels d’outils ou l’analyse d’un comportement inattendu.

Verbose output augmente l’observabilité, mais peut réduire la lisibilité. Dans une session longue, trop de détails peuvent distraire l’utilisateur. Pour une tâche de production courante, une sortie concise est souvent préférable. Pour un diagnostic, le mode verbose est plus approprié.

### terminalProgressBarEnabled (Terminal progress bar)

`terminalProgressBarEnabled` active ou désactive la barre de progression dans les terminaux compatibles.

```json
{
  "terminalProgressBarEnabled": true
}
```

Ce réglage concerne la visualisation de l’avancement. Il n’est pas un indicateur de correction. Une barre de progression peut indiquer que Claude Code travaille, mais elle ne prouve pas que la tâche est réussie. La progress bar est un signal d’activité, pas un signal de validité.

### showTurnDuration (Show turn duration)

`showTurnDuration` contrôle l’affichage de la durée d’un tour. Dans l’interface, ce réglage correspond à Show turn duration.

```json
{
  "showTurnDuration": true
}
```

Ce réglage est utile pour comprendre le coût temporel d’une action. Il permet de repérer les tâches lentes, les prompts trop larges, les appels d’outils coûteux ou les workflows qui prennent plus de temps que prévu. Il ne faut cependant pas confondre durée et qualité.

## Workflows, ultracode et orchestration

### disableWorkflows (Dynamic workflows)

`disableWorkflows` contrôle l’activation des dynamic workflows. La formulation est négative : lorsque `disableWorkflows` vaut `true`, les workflows dynamiques sont désactivés.

```json
{
  "disableWorkflows": false
}
```

Les dynamic workflows permettent à Claude Code d’orchestrer des tâches plus lourdes avec des sous-agents et un script de workflow généré ou relancé pendant la session.

Il est aussi possible de désactiver les workflows par variable d’environnement :

```bash
CLAUDE_CODE_DISABLE_WORKFLOWS=1 claude
```

### workflowKeywordTriggerEnabled (Ultracode keyword trigger)

`workflowKeywordTriggerEnabled` contrôle le déclenchement de workflow associé au mot-clé `ultracode` dans un prompt.

```json
{
  "workflowKeywordTriggerEnabled": true
}
```

Ce réglage ne désactive pas nécessairement toutes les formes de workflows. Il contrôle le déclenchement par mot-clé. Pour désactiver globalement les workflows, le réglage pertinent est `disableWorkflows`.

### ultracode (Effort de session)

`ultracode` peut aussi être utilisé comme niveau d’effort ou mode d’orchestration pour la session. Ce point doit être distingué de `workflowKeywordTriggerEnabled`.

Dans la documentation des settings, `ultracode` est indiqué comme un réglage de session seulement. La commande `/effort ultracode` est une commande de session qui modifie le niveau d’effort.

## Permissions et autonomie

### permissions.defaultMode (Default permission mode)

`permissions.defaultMode` définit le mode de permission par défaut à l’ouverture de Claude Code.

```json
{
  "permissions": {
    "defaultMode": "default"
  }
}
```

Les valeurs documentées incluent notamment `default`, `acceptEdits`, `plan`, `auto`, `dontAsk` et `bypassPermissions`. Ce réglage est l’un des plus structurants. Il détermine le niveau d’autonomie initial de la session. Un mode prudent demande plus souvent confirmation.

## Worktrees et base de travail

### worktree.baseRef (Worktree base ref)

`worktree.baseRef` définit la base utilisée pour créer un worktree lorsque Claude Code travaille en isolation de worktree.

```json
{
  "worktree": {
    "baseRef": "fresh"
  }
}
```

La valeur `fresh` crée le worktree depuis origin. La valeur `head` crée le worktree depuis le HEAD local.

## Exemple de configuration cohérente

L’exemple suivant montre une configuration volontairement sobre :

```json
{
  "$schema": "https://json.schemastore.org/claude-",
  "autoCompactEnabled": true,
  "awaySummaryEnabled": true,
  "fileCheckpointingEnabled": true,
  "alwaysThinkingEnabled": false,
  "showThinkingSummaries": false,
  "spinnerTipsEnabled": false,
  "prefersReducedMotion": true,
  "verbose": false,
  "terminalProgressBarEnabled": true,
  "showTurnDuration": true,
  "disableWorkflows": false,
  "workflowKeywordTriggerEnabled": true,
  "permissions": {
    "defaultMode": "default"
  },
  "worktree": {
    "baseRef": "fresh"
  }
}
```

Cette configuration n’est pas universelle. Elle illustre surtout la logique de placement.

## Critère de décision

Pour chaque configuration, il faut poser une question simple : est-ce que ce réglage modifie l’apparence, le contexte, le raisonnement, l’autonomie, l’orchestration ou l’environnement de travail ?
Une bonne configuration ne consiste pas à tout activer. Elle consiste à rendre le comportement de Claude Code prévisible, lisible et adapté au risque du projet.
