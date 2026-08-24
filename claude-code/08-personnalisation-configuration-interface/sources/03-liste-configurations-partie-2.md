# 03 — Liste des configurations — partie 2

## Plan fonctionnel de cette série de réglages

*   **Réglages de planification** : Cette famille concerne la manière dont Claude Code se comporte pendant le mode plan, notamment lorsqu’un mode d’autonomie plus avancé est disponible. Elle touche directement à la relation entre planification, permissions et exécution.
*   **Réglages de sélecteurs et de navigation** : Cette famille concerne les interactions de terminal : sélecteur de fichiers, sélecteur de copie, vue des agents et raccourcis de navigation.
*   **Réglages d’interface et de sortie** : Cette famille concerne le thème, le style de sortie, la langue, le mode d’édition, les notifications locales, les informations de pied de page et la présentation des réponses.
*   **Réglages d’intégration** : Cette famille concerne les liens avec l’IDE, Chrome, les notifications mobiles, Remote Control, les modèles et les outils de diff.

## Réglages de planification

### Use auto mode during plan
*Use auto mode during plan* correspond à la clé documentée `useAutoModeDuringPlan`. Elle contrôle si le mode plan utilise la sémantique du mode auto lorsque le mode auto est disponible. La valeur par défaut est `true`. La documentation précise aussi que cette clé n’est pas lue depuis les paramètres de projet partagés.

```json
{
  "useAutoModeDuringPlan": true
}
```

Le réglage est important parce qu’il modifie le comportement du plan face aux permissions. En mode plan, Claude prépare une trajectoire avant exécution. Si ce réglage est actif, le système peut appliquer la logique du mode auto à cette phase lorsque le mode auto est disponible. Cela réduit la friction, mais suppose que l’utilisateur accepte que le classificateur de sécurité participe davantage à l’évaluation des actions.

Ce réglage ne rend pas le plan équivalent à une exécution libre. Il modifie la sémantique d’autorisation pendant le plan. Les règles de refus, les permissions et les couches de sécurité restent pertinentes.

## Réglages de sélecteurs et de navigation

### Respect .gitignore in file picker
*Respect .gitignore in file picker* correspond à `respectGitignore`. Lorsque cette option vaut `true`, le sélecteur de fichiers utilisé avec `@` exclut les fichiers qui correspondent aux modèles de `.gitignore`. La documentation indique que `true` est la valeur par défaut.

```json
{
  "respectGitignore": true
}
```

Ce réglage réduit le bruit dans les suggestions de fichiers. Il évite d’exposer par défaut des artefacts générés, des dossiers de dépendances, des sorties de build ou des fichiers que le projet a explicitement choisi d’ignorer. Il ne faut pas le confondre avec une règle de sécurité.

### Skip the /copy picker
*Skip the /copy picker* concerne le comportement de `/copy`. La commande `/copy` copie la dernière réponse de l’assistant ; lorsqu’il y a des blocs de code, elle peut ouvrir un sélecteur interactif pour copier un bloc précis ou toute la réponse. Ici, le saut du sélecteur est désactivé, donc le sélecteur reste disponible lorsque le contexte le justifie.

Ce réglage relève de l’ergonomie. Il ne change pas le contenu produit, ni les permissions. Il modifie la manière dont l’utilisateur récupère une réponse ou un bloc de code. La bonne décision dépend du flux de travail (pédagogique vs rapide).

Commandes mentionnées :
*   `/copy`
*   `/copy 2`

### Open agents view by default et ← opens agents
*Open agents view by default* contrôle l’ouverture automatique de la vue des agents. *← opens agents* contrôle le raccourci de navigation qui ouvre cette vue avec la flèche gauche. La documentation officielle décrit la gestion des agents via `/agents` et la surveillance des agents d’arrière-plan via `claude agents`.

Ces deux préférences appartiennent à la surface d’interface. Elles n’ajoutent pas de capacité agentique. Elles changent la facilité d’accès à une vue qui sert à observer des sessions, des sous-agents ou des agents d’arrière-plan.

Ouvrir cette vue par défaut est utile quand le travail parallèle devient fréquent. Dans une utilisation simple, ce réglage peut être laissé désactivé.

Commandes mentionnées :
*   `/agents`
*   `claude agents`

## Mise à jour, thème et notifications locales

### Auto-update channel
*Auto-update channel* correspond à `autoUpdatesChannel`. Il contrôle le canal de mise à jour automatique. La valeur `latest` suit la version la plus récente. La valeur `stable` suit une version généralement plus ancienne et évite les versions présentant des régressions majeures.

```json
{
  "autoUpdatesChannel": "latest"
}
```
Ce choix est un compromis entre accès rapide aux fonctionnalités et stabilité.

### Theme
*Theme* correspond à `theme`. La documentation liste notamment `auto`, `dark`, `light`, les variantes daltonisées, les variantes ANSI, et les thèmes personnalisés.

```json
{
  "theme": "dark"
}
```
Ce réglage modifie seulement la lisibilité de l’interface.

### Local notifications
*Local notifications* correspond à `preferredNotifChannel`. Ce réglage détermine la méthode de notification locale : `auto`, cloche terminal, intégration iTerm2, Kitty, Ghostty, ou désactivation.

```json
{
  "preferredNotifChannel": "auto"
}
```
Ce réglage concerne les signaux locaux produits par le terminal lorsque la tâche se termine ou qu’une intervention est nécessaire.

## Notifications mobiles et Remote Control

### Push when actions required et Push when Claude decides
*Push when actions required* correspond à `inputNeededNotifEnabled`. Cette option envoie une notification push lorsqu’une permission ou une question attend une action.

*Push when Claude decides* correspond à `agentPushNotifEnabled`. Cette option autorise des notifications proactives lorsque Remote Control est connecté.

```json
{
  "inputNeededNotifEnabled": false,
  "agentPushNotifEnabled": true
}
```
La documentation Remote Control précise que les notifications push mobiles nécessitent une session Remote Control active, l’application Claude mobile connectée au même compte et l’autorisation de notification. Les deux bascules visibles dans `/config` sont les seules configurations par événement.

### Enable Remote Control for all sessions
*Enable Remote Control for all sessions* correspond à `remoteControlAtStartup`. Lorsque ce réglage vaut `true`, chaque session interactive tente de connecter Remote Control au démarrage.

```json
{
  "remoteControlAtStartup": false
}
```
Remote Control permet de piloter une session locale depuis le web ou le mobile. La session s’exécute toujours sur la machine locale.

Commande mentionnée :
*   `/remote-control`

## Sortie, langue et modèle

### Output style
*Output style* correspond à `outputStyle`. Ce réglage configure un style de sortie qui ajuste l’invite système.

```json
{
  "outputStyle": "default"
}
```
Le style de sortie peut modifier la forme des réponses, le degré d’explication et la posture rédactionnelle (travail rapide, pédagogie, revue...). Ce réglage agit sur la manière dont Claude répond, pas sur ce qu’il a le droit d’exécuter.

### Language
*Language* correspond à `language`. Cette clé configure la langue de réponse préférée. Elle influence aussi la langue de la dictée vocale et les titres de session.

```json
{
  "language": "french"
}
```
La langue de l’interface et la langue des réponses ne doivent pas être confondues.

### Model
*Model* correspond à `model`. Il définit le modèle par défaut.

```json
{
  "model": "default"
}
```
Le choix d'une valeur explicite est utile dans une équipe qui veut standardiser les coûts ou la latence. Le modèle est un réglage de capacité et de coût.

Commande mentionnée :
*   `/model`

## Édition, éditeur externe, diff et pied de page PR

### Editor mode
*Editor mode* correspond à `editorMode`. Ce réglage contrôle le mode d’édition de l’entrée dans l’interface terminal (ex: `normal` ou `vim`).

```json
{
  "editorMode": "normal"
}
```
C’est une préférence utilisateur.

### Show last response in external editor
*Show last response in external editor* correspond à `externalEditorContext` (stockée dans `~/.claude.json`). Ajoute la dernière réponse de Claude comme contexte commenté quand on ouvre l’éditeur externe avec `Ctrl+G`.

```json
{
  "externalEditorContext": false
}
```

### Show PR status footer
Concerne l’affichage d’informations de PR dans le pied de page. La clé `prUrlTemplate` personnalise le modèle d’URL utilisé pour le badge PR.

```json
{
  "prUrlTemplate": "https://reviews.example.com/{owner}/{repo}/pull/{numbe"
}
```

### Diff tool
Contrôle l’outil pour afficher les différences. La commande `/diff` ouvre un visualiseur interactif. Si réglé sur `auto`, Claude choisit le meilleur comportement selon l'environnement.

Commande mentionnée :
*   `/diff`

## IDE et navigateur

### Auto-install IDE extension
*Auto-install IDE extension* correspond à `autoInstallIdeExtension` (`~/.claude.json`). Réduit le frottement en installant automatiquement l'extension si Claude s'exécute dans un terminal VS Code ou JetBrains.

```json
{
  "autoInstallIdeExtension": true
}
```

### Claude in Chrome enabled by default
Concerne l’intégration Chrome via la commande `/chrome`. Prudent de le laisser sur `false` si on ne veut pas exposer des sessions authentifiées web.

Commande mentionnée :
*   `/chrome`
