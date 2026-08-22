# Activer le rendu plein écran, réduire le scintillement et utiliser /focus

Dans cette leçon, vous allez découvrir le rendu plein écran de Claude Code. Ce mode ne consiste pas à maximiser la fenêtre du terminal. Il change la manière dont Claude Code dessine son interface dans le terminal. Il utilise un rendu plus fluide, réduit le scintillement, stabilise l’usage mémoire dans les longues conversations et ajoute une meilleure gestion de la souris.

Ce réglage devient utile quand une session commence à être longue, quand le terminal scintille pendant que Claude affiche des sorties d’outils, quand le défilement saute, ou quand vous voulez une interface plus stable pour suivre le travail. Il est particulièrement intéressant dans des environnements où le rendu du terminal peut devenir le goulot d’étranglement : terminal intégré d’IDE, tmux, iTerm2 ou session longue avec beaucoup de sorties.

Vous allez aussi utiliser `/focus`. Ce mode réduit le bruit visuel : au lieu d’afficher tout le travail intermédiaire en détail, il montre surtout la dernière demande, un résumé court des appels d’outils et la réponse finale. Il est utile pour les démonstrations, les revues finales ou les sessions où vous voulez voir le résultat sans suivre chaque étape.

## Les commandes de cette leçon

Cette leçon utilise trois commandes principales :
`/tui fullscreen` active le rendu plein écran. `/tui default` revient au rendu classique. `/focus` active ou désactive un affichage plus calme dans le rendu plein écran.

Vous verrez aussi la commande `/tui` seule, qui permet de voir quel moteur de rendu est actif.

```bash
/tui fullscreen
/tui default
/focus
```

Le point important est de ne pas chercher une commande `/fullscreen`. Le plein écran passe par `/tui fullscreen`.

## Revenir dans le mini-projet

Revenez dans le projet `convertisseur-temperature`.

```bash
cd convertisseur-temperature
```

Vérifiez l’état du dépôt.

```bash
git status
```

Si le dépôt contient des changements, regardez le diff avant de continuer.

```bash
git diff
```

Cette leçon porte sur l’interface, pas sur une modification du code. Le dépôt peut rester inchangé du début à la fin. Si vous testez des commandes, faites-le avec des demandes de lecture seule.

Ouvrez Claude Code.
Lancez Claude Code depuis la racine du projet.

```bash
claude
```

Dans la session, demandez d’abord un rappel court du contexte, sans modification.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande de rappel court :**

*« Ne modifie aucun fichier.*

*Rappelle en trois lignes :*
*1. le projet ouvert ;*
*2. la commande de test principale ;*
*3. le fichier de logique métier principal. »*

</div>

Cette demande sert seulement à vérifier que vous êtes dans le bon projet avant de changer le mode d’affichage.

## Comprendre ce que change le rendu plein écran

Le rendu plein écran ne change pas le modèle, ne change pas les permissions et ne change pas la manière dont Claude raisonne. Il change la manière dont l’interface est dessinée dans le terminal.

Dans le rendu classique, la conversation vit dans le scrollback natif du terminal. Dans le rendu plein écran, Claude Code utilise le tampon d’écran alternatif du terminal, comme des outils tels que vim, htop ou less. L’interface garde alors une zone d’entrée fixe en bas de l’écran et ne redessine que ce qui est visible.

**Rendu classique :**
- la conversation s’accumule dans le scrollback du terminal ;
- la recherche native du terminal fonctionne naturellement ;
- le défilement dépend surtout du terminal.

**Rendu plein écran :**
- Claude Code dessine dans un tampon d’écran alternatif ;
- l’entrée reste fixe en bas ;
- le rendu scintille moins ;
- la mémoire reste plus stable dans les longues conversations ;
- la souris peut interagir avec l’interface.

Le terme "plein écran" peut donc être trompeur. Vous n’avez pas besoin de mettre votre terminal en plein écran sur le bureau. La commande fonctionne à n’importe quelle taille de fenêtre. Elle décrit la manière dont Claude Code prend le contrôle de la surface de dessin du terminal.

## Activer le rendu plein écran

Pour activer le rendu plein écran dans la session courante, utilisez :

```bash
/tui fullscreen
```

Quand le mode est activé, le CLI peut redémarrer l’interface avec la conversation intacte. Vous ne perdez pas le contexte de travail. Vous devez simplement observer que l’entrée reste fixe en bas de l’écran et que la conversation se comporte comme une interface plein écran.

Vérifiez ensuite le moteur de rendu actif :

```bash
/tui
```

Si le rendu plein écran est actif, continuez avec une demande simple.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Tester le rendu :**

*« Ne modifie aucun fichier.*

*Fais une lecture très courte du projet :*
*1. rôle du projet ;*
*2. fichiers principaux ;*
*3. commande de test ;*
*4. prochaine vérification utile. »*

</div>

Observez l’affichage pendant la réponse. Le but est de voir si le rendu est plus stable, si l’entrée reste en bas et si le défilement est plus confortable.

### Activer le mode sans scintillement au démarrage

Vous pouvez aussi démarrer Claude Code directement avec le rendu sans scintillement en définissant une variable d’environnement avant le lancement.

```bash
CLAUDE_CODE_NO_FLICKER=1 claude
```

Cette méthode est utile si vous voulez tester le rendu plein écran sans passer par une session déjà ouverte, ou si votre version recommande encore cette variable pour activer le rendu sans scintillement.

Vous pouvez aussi l’exporter dans votre shell pour plusieurs lancements :

```bash
export CLAUDE_CODE_NO_FLICKER=1
claude
```

Ne le mettez pas immédiatement dans votre configuration permanente. Testez d’abord le comportement dans votre terminal réel. Si le rendu vous convient, vous pourrez décider plus tard s’il doit devenir votre valeur par défaut personnelle.

## Revenir au rendu classique

Si le rendu plein écran ne vous convient pas, revenez au rendu classique avec :

```bash
/tui default
```

Vous pouvez aussi forcer le rendu classique au démarrage avec une variable d’environnement :

```bash
CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1 claude
```

Cette option est utile si votre terminal, votre configuration SSH, votre usage de tmux ou votre méthode de copie rend le tampon d’écran alternatif inconfortable.

## Régler la vitesse de défilement

Si le défilement à la molette est trop lent ou trop rapide, vous pouvez régler la vitesse avec une variable d’environnement.

```bash
export CLAUDE_CODE_SCROLL_SPEED=3
claude
```

Vous pouvez aussi utiliser la commande interactive si elle est disponible dans votre version :

```bash
/scroll-speed
```

Cette commande permet d’ajuster la vitesse de défilement pendant que vous testez le comportement. Elle est utile si vous utilisez un terminal qui envoie des événements de molette très lents ou très rapides.

Si vous voulez désactiver l’accélération de la molette et garder une vitesse constante, vous pouvez utiliser un réglage dans les settings :

```json
{
  "wheelScrollAccelerationEnabled": false
}
```

Ce réglage est une préférence personnelle. Il doit rester local, sauf si toute l’équipe utilise exactement le même environnement et veut standardiser ce comportement.

## Utiliser la souris

Le rendu plein écran ajoute une meilleure gestion de la souris. Vous pouvez cliquer dans l’invite pour placer le curseur, cliquer sur certaines suggestions, développer des sorties d’outils réduites, ouvrir des URLs ou des chemins de fichiers, sélectionner du texte et faire défiler la conversation.

**Actions possibles avec la souris :**
1. cliquer dans l’invite ;
2. sélectionner une suggestion ;
3. développer une sortie d’outil réduite ;
4. ouvrir un lien ;
5. ouvrir un chemin de fichier ;
6. sélectionner du texte ;
7. faire défiler la conversation.

La sélection de texte est gérée dans l’application. Selon votre configuration, le texte sélectionné peut être copié automatiquement au relâchement de la souris. Si vous préférez copier manuellement, vérifiez l’option de copie à la sélection dans `/config`.

```bash
/config
```

Si la copie automatique est désactivée, utilisez un raccourci de copie manuel adapté à votre terminal. Certains terminaux supportent `Cmd+C` avec une sélection active, d’autres utilisent `Ctrl+Shift+C`.

### Conserver la sélection native du terminal

La capture de souris peut gêner si vous avez l’habitude de sélectionner du texte avec les mécanismes natifs du terminal, de tmux ou d’un outil comme Kitty. Dans ce cas, vous pouvez maintenir une touche pendant la sélection pour forcer la sélection native.

- **Terminal.app :** maintenir `Fn` pendant la sélection.
- **iTerm2 :** maintenir `Option` pendant la sélection.
- **VS Code, Cursor, Devin Desktop :** maintenir `Shift` pendant la sélection.
- **La plupart des autres terminaux :** maintenir `Shift` pendant la sélection.

Si vous voulez désactiver complètement la capture de souris tout en gardant le rendu sans scintillement, démarrez avec :

```bash
CLAUDE_CODE_NO_FLICKER=1 CLAUDE_CODE_DISABLE_MOUSE=1 claude
```

Avec cette configuration, le terminal reprend la sélection native. En contrepartie, vous perdez certaines interactions souris dans Claude Code : clic pour placer le curseur, clic pour développer une sortie, clic sur une URL et défilement à la molette dans l’application.

## Quand utiliser le rendu plein écran

Le rendu plein écran est utile quand le rendu classique devient inconfortable.

**Utilisez `/tui fullscreen` si :**
1. l’écran scintille pendant les sorties longues ;
2. la position de défilement saute ;
3. la session devient très longue ;
4. vous voulez une entrée fixe en bas ;
5. vous voulez utiliser la souris dans l’interface ;
6. vous travaillez dans un terminal intégré d’IDE ;
7. vous suivez une tâche qui produit beaucoup de sorties.

**Gardez `/tui default` si :**
1. vous dépendez de `Cmd+F` dans le terminal ;
2. vous utilisez beaucoup le mode copie de tmux ;
3. la souris capturée vous gêne ;
4. votre terminal affiche mal le tampon alternatif ;
5. vous faites une session courte sans sortie volumineuse.

Le bon choix dépend du terminal, du projet et du type de session. Il n’y a pas une seule configuration correcte.

## Activer /focus

`/focus` fonctionne dans le rendu plein écran. Il réduit l’affichage du travail intermédiaire et met l’accent sur le dernier prompt, les appels d’outils résumés et la réponse finale.

La commande agit comme un interrupteur.

```bash
/focus
```

Pour le désactiver, relancez :

```bash
/focus
```

Le réglage peut persister entre les sessions. Si vous ne retrouvez plus le niveau de détail habituel, vérifiez si `/focus` est encore actif.

### Comprendre ce que /focus masque

`/focus` ne change pas le travail de Claude. Il change ce que vous voyez. L’agent peut toujours lire des fichiers, lancer des commandes, modifier des fichiers si vous l’autorisez et produire une réponse finale. Le mode focus masque surtout les détails intermédiaires pour rendre la sortie plus calme.

Il ne faut donc pas utiliser `/focus` comme preuve que la tâche est plus sûre. C’est un mode d’affichage, pas un garde-fou.

**`/focus` ne change pas :**
- le modèle ;
- les permissions ;
- le contexte ;
- les outils disponibles ;
- la capacité à modifier des fichiers ;
- la nécessité de vérifier le diff.

**`/focus` change :**
- la quantité de détails affichés ;
- la visibilité des appels d’outils ;
- la lisibilité des sessions de démonstration ;
- le bruit visuel pendant le travail.

### Tester /focus sur une demande de lecture seule

Activez le rendu plein écran, puis le mode focus.

```bash
/tui fullscreen
/focus
```

Envoyez ensuite une demande de lecture seule.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Test avec /focus :**

*« Ne modifie aucun fichier.*

*Analyse rapidement le mini-projet convertisseur-temperature.*
*Réponds uniquement avec :*
*1. le rôle du projet ;*
*2. les fichiers les plus importants ;*
*3. la commande de test ;*
*4. une amélioration possible à étudier plus tard. »*

</div>

Observez la différence. Le mode focus doit rendre la sortie plus compacte, en limitant la place prise par les détails intermédiaires.

Pour comparer, désactivez `/focus`, puis reposez une demande proche.

```bash
/focus
```

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Test détaillé (sans /focus) :**

*« Ne modifie aucun fichier.*

*Refais la même analyse, mais avec un peu plus de détails. »*

</div>

Cette comparaison montre quand le mode focus est utile. Si vous voulez comprendre les étapes, désactivez-le. Si vous voulez seulement le résultat final, activez-le.

### Utiliser /focus pour les démonstrations

`/focus` est particulièrement utile quand vous montrez une session à quelqu’un. Il évite d’afficher trop de sorties intermédiaires et garde l’attention sur le résultat.

Vous pouvez ensuite demander :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple de démonstration :**

*« /focus*

*Ne modifie aucun fichier.*

*Prépare une explication courte du projet pour un nouvel arrivant.*
*Format :*
*1. phrase d’introduction ;*
*2. schéma mental du projet ;*
*3. rôle de chaque fichier ;*
*4. commande de vérification ;*
*5. prochaine modification possible. »*

</div>

Le mode focus convient bien à ce type de demande, parce que vous ne cherchez pas à inspecter chaque appel d’outil. Vous voulez surtout une réponse finale claire.

### Utiliser le mode transcription après /focus

Si vous avez travaillé en `/focus` et que vous voulez examiner la session, utilisez le mode transcription.

```bash
Ctrl+O
```

Recherchez ensuite un terme précis :

```bash
/conversion
```

Vous pouvez naviguer entre les occurrences avec :

```bash
n
N
```

## Tester les trois modes d’affichage

Pour bien comprendre, testez les trois états dans une session courte.

**État 1 : rendu classique**
```bash
/tui default
```
*« Ne modifie aucun fichier. Résume le projet en trois points. »*

**État 2 : rendu plein écran**
```bash
/tui fullscreen
```
*« Ne modifie aucun fichier. Résume le projet en trois points. »*

**État 3 : rendu plein écran avec focus**
```bash
/focus
```
*« Ne modifie aucun fichier. Résume le projet en trois points. »*

Comparez la sensation de lecture. Le rendu classique est simple et compatible avec les habitudes du terminal. Le rendu plein écran est plus stable sur les sessions longues. Le mode focus rend la sortie plus calme.

## Configurer le rendu plein écran dans les settings

Si le rendu plein écran vous convient, vous pouvez le définir dans vos settings personnels.

Ce réglage doit généralement rester personnel, par exemple dans `~/.claude/settings.json`. Il dépend de votre terminal, de votre usage de la souris et de votre préférence de défilement.

```json
{
  "tui": "fullscreen"
}
```

Si vous voulez garder le rendu classique :

```json
{
  "tui": "default"
}
```

Ne mettez ce réglage dans `.claude/settings.json` que si toute l’équipe a une raison claire de partager ce choix. Dans la plupart des cas, le moteur de rendu est une préférence d’interface personnelle.

## Configurer le mode focus dans les settings

Si vous voulez démarrer régulièrement avec une interface plus calme, vous pouvez régler le mode d’affichage.

```json
{
  "viewMode": "focus"
}
```

Ce réglage est utile si vous faites souvent des sessions de démonstration ou si vous préférez lire uniquement les résultats. Il est moins adapté si vous voulez voir les sorties d’outils en détail.

Pour revenir à un affichage standard :

```json
{
  "viewMode": "default"
}
```

Comme pour `tui`, ce réglage est généralement personnel. Il ne doit pas être imposé à une équipe sans raison.

## Préparer une session longue avec rendu plein écran

Avant une session longue, vous pouvez préparer un environnement stable.

```bash
cd convertisseur-temperature
git status
claude
```

Dans Claude Code :

```bash
/tui fullscreen
```

Ensuite :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande pour session longue :**

*« Ne modifie aucun fichier.*

*Prépare une lecture de projet en trois étapes :*
*1. arborescence ;*
*2. fichiers src ;*
*3. tests.*

*Pour chaque étape, donne un résumé court et indique ce que tu observes. »*

</div>

Ce type de session est plus confortable en rendu plein écran, car l’entrée reste fixe et le défilement est géré dans l’application.
