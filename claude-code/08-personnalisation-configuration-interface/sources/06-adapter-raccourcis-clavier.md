# Adapter les raccourcis clavier

## Les commandes de cette leçon

### Les commandes principales
Cette leçon utilise plusieurs commandes et chemins de configuration de Claude Code.

*   `/keybindings` ouvre ou crée le fichier `~/.claude/keybindings.json`. Ce fichier contient vos raccourcis clavier personnels pour Claude Code. Les modifications sont détectées automatiquement, sans redémarrer Claude Code.
*   `/config` ouvre l’interface de configuration de Claude Code. Elle permet notamment de régler le mode d’édition, le thème, certains comportements de session et plusieurs options de l’interface.
*   `/vim` doit être connu, mais il ne doit plus être présenté comme la méthode principale. Dans les versions récentes, cette commande a été supprimée. Elle reste importante à mentionner parce que vous pouvez la voir dans d’anciens tutoriels, dans de vieilles notes ou dans des habitudes héritées des premières versions.
*   `/terminal-setup` sert à corriger certains problèmes de transmission des touches entre le terminal et Claude Code. Il est utile si Shift+Enter, Option, Alt ou certaines combinaisons ne sont pas correctement reçues par le CLI.
*   `/doctor` sert à diagnostiquer l’environnement et la configuration. Après une personnalisation des raccourcis, il permet notamment de repérer un fichier JSON invalide, un contexte incorrect, un raccourci réservé, une duplication ou un conflit avec le terminal.

## Comprendre ce que les raccourcis contrôlent

### Les raccourcis pilotent l’interface
Les raccourcis clavier ne changent pas le modèle, les permissions ou le comportement du code. Ils changent la manière dont vous pilotez l’interface. Ils servent à déclencher des actions dans différents contextes : chat, autocomplétion, confirmation, transcription, historique, tâche, diff, sélection, défilement, paramètres ou docteur.

Exemples d’actions pilotées par des raccourcis :
- envoyer un message ;
- insérer une nouvelle ligne ;
- ouvrir l’éditeur externe ;
- interrompre une opération ;
- quitter Claude Code ;
- afficher la transcription ;
- chercher dans l’historique ;
- naviguer dans un diff ;
- mettre une tâche en arrière-plan ;
- copier une sélection ;
- activer la dictée vocale.

### Distinguer problème de terminal et problème de raccourci
Cette distinction est importante. Si une touche n’arrive pas correctement au CLI, le problème peut venir du terminal. Dans ce cas, il faut utiliser `/terminal-setup`, vu dans une leçon précédente. Si la touche arrive correctement mais déclenche une action qui ne vous convient pas, il faut utiliser `/keybindings`.

```bash
/terminal-setup
# Aide le terminal à transmettre correctement certaines touches.

/keybindings
# Change les actions associées aux touches dans Claude Code.
```

## Ouvrir le fichier de raccourcis avec /keybindings

### Lancer la commande
Lancez la commande : `/keybindings`

Cette commande ouvre ou crée le fichier `~/.claude/keybindings.json`. Ce fichier est personnel. Il se trouve dans votre dossier utilisateur, pas dans le dépôt du projet. Il ne doit pas être versionné avec `convertisseur-temperature`.

### Observer le fichier minimal
Un fichier minimal ressemble à ceci :
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": []
}
```
Le champ `bindings` contient une liste de blocs. Chaque bloc précise un contexte et les touches à associer à des actions.

## Comprendre la structure du fichier

### Lire les trois niveaux
La structure générale est simple :
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+e": "chat:externalEditor"
 }
 }
 ]
}
```
Dans cet exemple, le contexte est `Chat`. La touche `Ctrl+E` déclenche l’action `chat:externalEditor`, c’est-à-dire l’ouverture du prompt dans un éditeur externe.

Le fichier se lit donc en trois niveaux :
1. Un fichier JSON personnel.
2. Une liste de contextes.
3. Une correspondance entre touches et actions dans ce contexte.

### Modifier le fichier avec prudence
Il faut modifier ce fichier comme un fichier de configuration sensible. Une faute de JSON, un nom de contexte invalide ou un raccourci réservé peut provoquer un avertissement.

## Comprendre les contextes

### Pourquoi les contextes existent
Un raccourci ne s’applique pas forcément partout. Il dépend du contexte. Par exemple, une touche peut avoir un rôle dans la zone de chat, un autre rôle dans un dialogue de confirmation, et un autre rôle dans une vue de diff.

Contextes fréquents :
`Global`, `Chat`, `Autocomplete`, `Settings`, `Confirmation`, `Transcript`, `HistorySearch`, `Task`, `ThemePicker`, `Footer`, `DiffDialog`, `ModelPicker`, `Scroll`, `Doctor`

### Comprendre les contextes principaux
Le contexte `Global` s’applique largement dans l’application. Le contexte `Chat` concerne la zone de saisie principale. Le contexte `Confirmation` concerne les dialogues d’autorisation ou de confirmation. Le contexte `Transcript` concerne la vue de transcription. Le contexte `Scroll` concerne le défilement et la sélection dans le rendu plein écran.

Ne placez pas tout dans `Global`. Plus un raccourci est global, plus il peut créer des effets inattendus. Pour une première personnalisation, ciblez le contexte précis.

## Commencer par une modification simple

### Ajouter un raccourci pour l’éditeur externe
La première modification raisonnable consiste à ajouter un raccourci pour ouvrir l’éditeur externe. C’est utile quand vous voulez écrire un prompt long, structuré, relu et corrigé avant l’envoi.

```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+e": "chat:externalEditor"
 }
 }
 ]
}
```
Après avoir enregistré le fichier, revenez dans Claude Code. Les modifications doivent être détectées automatiquement. Testez le raccourci dans la zone de saisie.
Si vous utilisez déjà `Ctrl+E` dans votre terminal ou votre éditeur pour autre chose, choisissez un autre raccourci. Le but n’est pas de casser vos habitudes, mais de rendre les prompts longs plus faciles à écrire.

## Utiliser l’éditeur externe pour les prompts longs

### Rédiger une demande structurée
Une fois le raccourci configuré, testez-le avec une demande détaillée. Ouvrez l’éditeur externe, puis écrivez un prompt comme celui-ci :
```text
Ne modifie aucun fichier.
Je veux préparer une future modification dans le projet.
Analyse uniquement :
- src/main.js ;
- src/conversion.js ;
- test/conversion.test.js.
Réponds avec :
1. ce que fait chaque fichier ;
2. les cas limites visibles ;
3. une amélioration simple à faire plus tard ;
4. la preuve qu’il faudrait demander si cette amélioration était faite.
```
Ce type de prompt est plus confortable dans un éditeur que directement dans une ligne de terminal. Vous pouvez le relire, déplacer les sections, corriger les noms de fichiers et éviter d’envoyer trop tôt.

## Ne pas remapper les touches essentielles trop tôt

### Conserver les raccourcis vitaux
Certains raccourcis sont fondamentaux. Ne les modifiez pas au début. Par exemple, `Entrée` envoie le message, `Ctrl+J` insère une nouvelle ligne, `Ctrl+C` interrompt, et `Ctrl+D` quitte.

Raccourcis à ne pas toucher au début :
- `Entrée` ;
- `Ctrl+J` ;
- `Ctrl+C` ;
- `Ctrl+D` ;
- `Échappement` ;
- `Tab` ;
- `Haut` / `Bas`.

Une personnalisation trop agressive rend la session difficile à diagnostiquer. Si un comportement devient étrange, vous ne saurez plus si le problème vient de Claude Code, du terminal, de tmux, de votre fichier de raccourcis ou du mode Vim.

## Délier un raccourci

### Utiliser null
Vous pouvez désactiver un raccourci en mettant son action à `null`. Par exemple, si `Ctrl+S` vous gêne dans le contexte de chat, vous pouvez le délier.

```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+s": null
 }
 }
 ]
}
```
Cette technique est utile quand un raccourci est déclenché par erreur. Elle doit rester ciblée. Ne désactivez pas une série de raccourcis sans savoir à quoi ils servent.

## Utiliser les accords de touches

### Comprendre le principe
Un accord est une suite de touches. Par exemple, `Ctrl+K`, puis `Ctrl+S`. Cette forme est utile si vous voulez éviter de surcharger les raccourcis simples.

```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+k ctrl+e": "chat:externalEditor",
 "ctrl+k ctrl+n": "chat:newline"
 }
 }
 ]
}
```
Les accords sont plus difficiles à déclencher par accident. Ils sont utiles pour les actions moins fréquentes, comme ouvrir un éditeur externe ou déclencher une action de navigation.
Ne créez pas trop d’accords au début. Deux ou trois raccourcis bien choisis valent mieux qu’une carte complète que vous ne mémoriserez pas.

## Comprendre la syntaxe des touches

### Utiliser les modificateurs
Les touches sont écrites en minuscules, avec des modificateurs séparés par `+`.

Exemples :
`ctrl+k`, `shift+tab`, `meta+p`, `ctrl+shift+c`, `ctrl+k ctrl+s`

Les modificateurs principaux sont :
```bash
ctrl ou control
# Touche Contrôle.
shift
# Touche Maj.
alt, opt, option ou meta
# Alt sur Windows et Linux, Option sur macOS.
cmd, command, super ou win
# Commande sur macOS, Windows sur Windows, Super sur Linux.
```
Pour des raccourcis portables entre terminaux, préférez `ctrl` ou `meta`. Le modificateur `cmd` n’est pas transmis par tous les terminaux.

### Utiliser les touches spéciales
Les touches spéciales ont des noms explicites.
`escape`, `esc`, `enter`, `return`, `tab`, `space`, `up`, `down`, `left`, `right`, `backspace`, `delete`.

Par exemple :
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+enter": "chat:submit",
 "shift+enter": "chat:newline"
 }
 }
 ]
}
```
Ce type de configuration dépend fortement du terminal. Si `Shift+Enter` n’est pas transmis correctement, le raccourci ne fonctionnera pas, même si le fichier JSON est correct. Dans ce cas, revenez à `/terminal-setup` ou utilisez `Ctrl+J`.

## Connaître les raccourcis réservés

### Identifier les touches non remappables
Certains raccourcis ne peuvent pas être remappés.
```bash
Ctrl+C
# Interruption ou annulation.
Ctrl+D
# Sortie.
Ctrl+M
# Identique à Entrée dans les terminaux.
Caps Lock
# Non transmis aux applications de terminal.
```
Si vous essayez de les utiliser dans `keybindings.json`, Claude Code affichera un avertissement. Il vaut mieux les considérer comme indisponibles.

## Éviter les conflits de terminal

### Repérer les raccourcis déjà utilisés
Certains raccourcis sont déjà utilisés par le terminal, le shell ou un multiplexeur comme tmux.
```bash
Ctrl+B
# Préfixe tmux.
Ctrl+A
# Préfixe GNU screen si configuré ainsi.
Ctrl+Z
# Suspension de processus Unix.
```
Si vous utilisez tmux, évitez de placer une action importante sur `Ctrl+B`. Si vous utilisez screen, évitez `Ctrl+A`. Si vous utilisez un shell Unix classique, évitez `Ctrl+Z` pour une action courante.
Le bon réflexe consiste à choisir des raccourcis qui ne sont pas déjà chargés d’un sens fort dans votre environnement.

## Utiliser /doctor pour vérifier les raccourcis

### Lancer le diagnostic
Après avoir modifié `~/.claude/keybindings.json`, lancez `/doctor`.
Cette commande peut signaler des problèmes de configuration, y compris des erreurs de raccourcis : JSON invalide, contexte inconnu, conflit avec un raccourci réservé, conflit de multiplexeur ou liaison dupliquée.
Si `/doctor` signale une erreur, corrigez le fichier avant de continuer. Un raccourci mal configuré peut créer des comportements difficiles à interpréter pendant une session réelle.

## Exemple de configuration raisonnable

### Commencer avec peu de changements
Voici une configuration volontairement courte. Elle ajoute un raccourci pour ouvrir l’éditeur externe, ajoute un accord pour insérer une nouvelle ligne, et désactive `Ctrl+S` si vous le déclenchez souvent par erreur.
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Chat",
 "bindings": {
 "ctrl+e": "chat:externalEditor",
 "ctrl+k ctrl+n": "chat:newline",
 "ctrl+s": null
 }
 }
 ]
}
```
Cette configuration ne modifie pas les raccourcis de sortie, d’interruption ou de confirmation. Elle reste donc assez sûre pour commencer.

## Exemple de configuration pour le rendu plein écran

### Personnaliser le défilement
Si vous utilisez le rendu plein écran, vous pouvez aussi personnaliser le défilement. Le contexte utile est `Scroll`.
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Scroll",
 "bindings": {
 "ctrl+u": "scroll:halfPageUp",
 "ctrl+d": "scroll:halfPageDown",
 "G": "scroll:bottom",
 "g": "scroll:top"
 }
 }
 ]
}
```
Cette configuration rapproche le défilement de certaines habitudes Vim. Elle n’active pas le mode Vim. Elle ne fait que modifier des actions de défilement dans le contexte `Scroll`.
Attention à `Ctrl+D`. Selon le contexte et selon la version, il peut être réservé pour quitter l’application. Si `/doctor` signale un conflit, choisissez une autre touche.

## Exemple de configuration pour les confirmations

### Modifier les dialogues avec prudence
Vous pouvez aussi personnaliser les dialogues de confirmation. Il faut rester prudent, car ces raccourcis servent souvent à accepter ou refuser des actions.
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Confirmation",
 "bindings": {
 "tab": "confirm:nextField",
 "shift+tab": "confirm:previousField",
 "ctrl+e": "confirm:toggleExplanation"
 }
 }
 ]
}
```
Ne remappez pas `confirm:yes` sur une touche trop facile à déclencher par erreur. Les confirmations contrôlent parfois des actions sensibles : modification de fichier, lancement de commande, permission d’outil ou action externe.

## Exemple de configuration pour les tâches en arrière-plan

### Utiliser le contexte Task
Le contexte `Task` permet de déclencher certaines actions quand une tâche est en cours. Par exemple, vous pouvez mettre une tâche en arrière-plan.
```json
{
 "$schema": "https://www.schemastore.org/claude-code",
 "$docs": "https://code.claude.com/docs/fr/keybindings",
 "bindings": [
 {
 "context": "Task",
 "bindings": {
 "ctrl+k ctrl+b": "task:background"
 }
 }
 ]
}
```
Ce type de raccourci est utile dans les sessions longues, mais il n’est pas prioritaire pour une première personnalisation. Commencez par les raccourcis de saisie, puis ajoutez les autres seulement si vous en ressentez le besoin.

## Tester les raccourcis dans une session courte

### Faire un test sans risque
Après avoir modifié `keybindings.json`, testez vos raccourcis avec une demande sans risque.
```text
Ne modifie aucun fichier.
Ceci est un test de raccourcis.
Réponds avec :
1. projet ouvert ;
2. mode d’édition actuel ;
3. raccourcis que je viens de tester ;
4. comportement observé.
```
Testez seulement quelques actions :
1. insertion d’une nouvelle ligne ;
2. ouverture de l’éditeur externe ;
3. recherche d’historique ;
4. affichage de la transcription ;
5. interruption contrôlée d’une réponse non critique.

Ne testez pas une nouvelle configuration de raccourcis pendant une modification de code. Les raccourcis doivent être validés dans une session calme.

## Utiliser l’historique et la transcription

### Retrouver les actions importantes
Deux raccourcis sont particulièrement utiles dans les sessions longues : la recherche d’historique et la transcription.
```bash
Ctrl+R
# Ouvrir la recherche d’historique.
Ctrl+O
# Basculer la transcription détaillée.
```
Si vous personnalisez ces raccourcis, gardez une alternative facile à mémoriser. Ce sont des actions de navigation importantes. Les perdre rend les sessions longues moins exploitables.

## Gérer les raccourcis dans un terminal intégré

### Comparer terminal externe et terminal intégré
Les terminaux intégrés d’IDE peuvent intercepter certaines touches. Si un raccourci fonctionne dans un terminal externe mais pas dans le terminal intégré, le problème peut venir de l’IDE.

Diagnostic simple :
1. tester le raccourci dans un terminal externe ;
2. tester le même raccourci dans le terminal intégré ;
3. vérifier `/terminal-setup` ;
4. vérifier les raccourcis de l’IDE ;
5. choisir un raccourci plus portable si nécessaire.

Pour les raccourcis importants, préférez des combinaisons simples comme `Ctrl+E`, `Ctrl+K Ctrl+E` ou `Meta+P`, selon votre terminal. Évitez de dépendre d’une touche que votre IDE intercepte déjà.

## Versionner ou ne pas versionner les raccourcis

### Garder les raccourcis personnels hors du projet
Le fichier `~/.claude/keybindings.json` est personnel. Il ne fait pas partie du projet. Il ne doit pas être versionné dans `convertisseur-temperature`.
Si une équipe veut recommander des raccourcis, elle peut documenter une configuration exemple dans un fichier de documentation, mais elle ne doit pas écraser les préférences individuelles.

Bonne pratique d’équipe :
`docs/claude-keybindings-exemple.md` (Documente des raccourcis recommandés.)
Mauvaise pratique :
forcer les raccourcis personnels de quelqu’un dans un fichier de configuration partagé.

Les raccourcis dépendent trop du clavier, du terminal, du système d’exploitation et des habitudes d’édition pour être imposés sans discussion.

## Demander une revue de votre fichier de raccourcis

### Faire auditer keybindings.json
Vous pouvez aussi demander une revue de `~/.claude/keybindings.json`. Cette demande doit rester centrée sur la configuration, pas sur le code du projet.

```text
Analyse mon fichier ~/.claude/keybindings.json.
Ne modifie aucun fichier.
Réponds avec :
1. raccourcis utiles ;
2. raccourcis potentiellement dangereux ;
3. conflits possibles avec tmux, screen ou le terminal ;
4. raccourcis réservés à éviter ;
5. modifications minimales recommandées.
```
Cette revue est utile si vous avez commencé à modifier plusieurs raccourcis. Elle peut repérer des conflits ou des choix difficiles à mémoriser.
