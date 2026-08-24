# Configurer le terminal, le thème et les retours à la ligne

Dans cette leçon, vous allez configurer la partie la plus visible de votre environnement Claude Code : le terminal. Le CLI fonctionne dans un terminal classique, mais certains détails changent fortement la qualité d’une session : les retours à la ligne, les raccourcis clavier transmis par le terminal, les notifications, le thème, les couleurs, tmux et le comportement des terminaux intégrés aux IDE.

Le but n’est pas de transformer votre terminal en environnement complexe. Le but est de supprimer les frictions qui ralentissent les sessions : un Shift+Enter qui envoie le message au lieu d’ajouter une ligne, une touche Option qui ne transmet pas le bon signal, une notification qui ne s’affiche pas, un thème illisible ou une session tmux qui bloque certains raccourcis.

Le fil rouge reste le projet `convertisseur-temperature`. Vous n’allez pas modifier sa logique dans cette leçon. Vous allez seulement utiliser ce projet comme contexte pour tester l’écriture d’invites multilignes, vérifier les notifications et choisir un thème lisible pour les prochaines sessions.

## Les commandes de cette leçon

Cette leçon utilise deux commandes principales :

*   `/theme` permet de choisir le thème de couleur de Claude Code. La commande propose notamment des thèmes clairs, sombres, automatiques, accessibles aux daltoniens, basés sur la palette ANSI du terminal, et des thèmes personnalisés si votre version les prend en charge.
*   `/terminal-setup` configure les raccourcis du terminal lorsque le terminal en a besoin. Cette commande est surtout utile pour corriger le comportement de Shift+Enter dans certains terminaux d’IDE ou certains émulateurs, et pour configurer correctement certains raccourcis transmis à Claude Code.

## Revenir dans le projet

Revenez dans le mini-projet utilisé dans les leçons précédentes. Vérifiez rapidement l’état du dépôt.
Cette vérification reste utile même pour une leçon d’interface. Vous devez savoir si le dépôt est propre avant de lancer une session. Si des fichiers sont modifiés, regardez le diff.
Ensuite, lancez Claude Code depuis la racine du projet.

```bash
cd convertisseur-temperature
git status
git diff
claude
```

La suite de la leçon se déroule dans la session interactive, avec quelques modifications possibles de configuration. Aucune modification du code source du mini-projet n’est nécessaire.

## Comprendre ce que le terminal contrôle

Il faut distinguer deux couches.
Claude Code contrôle son interface, ses commandes slash, ses réponses et son interaction avec le projet.
Le terminal, lui, contrôle la manière dont les touches sont transmises, la manière dont les couleurs sont rendues, les notifications, le presse-papiers, le défilement, les onglets, les splits et parfois l’intégration avec tmux.

Si une touche ne fonctionne pas, si Shift+Enter soumet le message, si Option+Enter ne fait rien sur macOS, ou si les notifications n’apparaissent pas, le problème ne vient pas forcément du prompt. Il peut venir de la configuration du terminal.

Cette distinction évite une confusion fréquente. `/terminal-setup` ne sert pas à décider ce que fait chaque action dans Claude Code. Il sert à aider certains terminaux à envoyer correctement les touches. Pour changer les actions internes, vous utiliserez `/keybindings` dans une autre leçon.

## Écrire une invite multiligne

Les prompts utiles sont souvent multilignes. Une demande précise contient un contexte, un fichier ciblé, des contraintes, une vérification et une définition de terminé. Il faut donc savoir écrire plusieurs lignes sans envoyer le message trop tôt.

Dans Claude Code, Entrée envoie le message. Pour insérer un saut de ligne sans envoyer, vous pouvez utiliser `Ctrl+J`. Vous pouvez aussi écrire un antislash `\`, puis appuyer sur `Entrée`.

À retenir :
*   `/theme` règle l’apparence de Claude Code.
*   `/terminal-setup` aide le terminal à transmettre les bons raccourcis.
*   `/keybindings`, vu plus tard, changera les actions internes de Claude Code.
*   Le terminal garde son propre thème, ses propres raccourcis et ses propres réglages.

Pour écrire ce message dans le CLI sans l’envoyer à chaque ligne, utilisez `Ctrl+J` entre les lignes. Vous pouvez aussi utiliser la méthode avec l’antislash si vous préférez un comportement qui fonctionne dans tous les terminaux.

Cette méthode est moins lisible pendant la saisie, mais elle est robuste. Elle permet de continuer même si le terminal ne transmet pas correctement Shift+Enter.

## Tester Shift+Enter

Dans beaucoup de terminaux, Shift+Enter ajoute directement un saut de ligne. Dans certains environnements, il soumet le message ou ne fonctionne pas comme prévu. Testez-le avec une demande sans risque.

Exemple d’invite multiligne (robuste avec antislash) :
```text
Lis ce projet sans modifier de fichiers.\
Explique uniquement :\
1. le rôle du projet ;\
2. les fichiers principaux ;\
3. la commande de test ;\
4. la prochaine vérification utile.
```

Écrivez cette demande en essayant d’insérer les lignes avec Shift+Enter. Si le message est envoyé dès la première ligne, votre terminal doit être configuré ou vous devez utiliser `Ctrl+J`.

Les terminaux comme Ghostty, Kitty, iTerm2, WezTerm, Warp, Apple Terminal et Windows Terminal prennent généralement en charge Shift+Enter sans configuration spécifique. Les terminaux intégrés comme VS Code, Cursor, Devin Desktop, ainsi que Alacritty et Zed, peuvent nécessiter `/terminal-setup`. Certains environnements comme gnome-terminal ou certains IDE JetBrains ne prennent pas en charge ce comportement dans ce contexte ; utilisez alors `Ctrl+J` ou l’antislash suivi de `Entrée`.

## Utiliser /terminal-setup

Si Shift+Enter ne se comporte pas correctement, lancez `/terminal-setup`.

La commande configure les raccourcis du terminal lorsque votre environnement en a besoin. Elle est particulièrement pertinente dans les terminaux intégrés d’IDE et certains émulateurs de terminal.

Il faut lancer `/terminal-setup` dans le terminal hôte. Si vous êtes dans tmux ou screen, sortez du multiplexeur ou ouvrez le terminal hôte pour exécuter la commande. La raison est simple : la commande doit écrire dans la configuration du terminal qui reçoit réellement les touches.

Bon réflexe :
1. ouvrir le terminal hôte ;
2. lancer claude ;
3. exécuter `/terminal-setup` ;
4. fermer puis rouvrir le terminal si la commande le demande ;
5. tester à nouveau Shift+Enter.

Si `/terminal-setup` indique qu’une liaison existe déjà, aucune action supplémentaire n’est forcément nécessaire. Testez simplement le comportement après la commande.

### Cas des terminaux d’IDE
Les terminaux intégrés à un éditeur sont pratiques, mais ils ajoutent une couche entre vos touches et Claude Code. VS Code, Cursor, Devin Desktop et d’autres environnements peuvent intercepter certaines combinaisons avant qu’elles n’arrivent au CLI.

Si le problème persiste, utilisez `Ctrl+J`. Ce raccourci reste le repli le plus fiable pour écrire une invite multiligne.

### Cas d’Apple Terminal et de la touche Option
Sur macOS, certains raccourcis utilisent la touche Option. Selon le terminal, cette touche peut ne pas être envoyée comme modificateur utilisable par les applications en ligne de commande. Le réglage s’appelle souvent Use Option as Meta Key ou une variante proche.

Dans Apple Terminal, ouvrez les paramètres du profil et cherchez le réglage qui permet d’utiliser Option comme touche Meta. Si `/terminal-setup` propose d’activer ce comportement lors de la première configuration, acceptez-le si vous voulez utiliser ces raccourcis.

Dans un terminal intégré d’IDE :
1. lancez claude depuis le projet ;
2. testez Shift+Enter ;
3. si le saut de ligne ne fonctionne pas, exécutez `/terminal-setup` ;
4. redémarrez l’éditeur si la configuration l’exige ;
5. testez à nouveau avec un prompt multiligne simple.

Cette configuration est utile pour les raccourcis qui dépendent de Option, mais elle peut aussi changer le comportement habituel de certaines touches dans votre terminal. Testez après modification.

## Choisir un thème avec /theme

Après les touches et les retours à la ligne, configurez le thème. Lancez la commande : `/theme`

Le thème doit être choisi en fonction de votre terminal réel. Un bon thème reste lisible pendant une session longue, avec des blocs de code, des diffs, des erreurs, des messages de succès, des confirmations et des sorties de commandes.

Les choix typiques sont :
*   `auto` : Suit le fond clair ou sombre du terminal quand l’environnement le permet.
*   `dark` : Thème sombre.
*   `light` : Thème clair.
*   `dark-daltonized` : Variante sombre plus accessible pour certains daltonismes.
*   `light-daltonized` : Variante claire plus accessible.

Le thème de Claude Code ne remplace pas le thème de votre terminal. Il règle l’apparence de l’interface de Claude Code à l’intérieur du terminal. Le terminal conserve sa propre police, sa palette, son fond, ses marges, son contraste et ses réglages de rendu.

### Utiliser le thème automatique
Le thème `auto` est un bon point de départ si votre terminal suit déjà l’apparence claire ou sombre de votre système. Choisissez ensuite `auto` dans le sélecteur, si l’option est disponible. Ce choix évite de changer manuellement le thème quand vous passez d’un environnement clair à un environnement sombre.

### Thèmes ANSI et personnalisés
Les thèmes ANSI peuvent être utiles si vous avez déjà une palette terminal bien réglée et que vous voulez que Claude Code s’y intègre plus naturellement :
*   `dark-ansi`
*   `light-ansi`

Selon votre version de Claude Code, `/theme` peut proposer la création de thèmes personnalisés. Ces thèmes sont stockés dans `~/.claude/themes/`. Un thème personnalisé peut être utile si les thèmes intégrés ne donnent pas assez de contraste dans votre terminal. Testez d'abord les thèmes intégrés.

Voici un exemple simple de thème personnalisé (dans `~/.claude/themes/contraste-personnel.json`) :
```json
{
 "name": "Contraste personnel",
 "base": "dark",
 "overrides": {
   "claude": "#a78bfa",
   "error": "#ff5555",
   "success": "#50fa7b"
 }
}
```
Un thème personnalisé est une préférence personnelle. Il doit généralement rester dans votre dossier utilisateur, pas dans le dépôt du projet.

## Ne pas confondre thème et couleur de session

`/theme` règle l’apparence générale de Claude Code. `/color`, qui sera étudié dans une leçon suivante, sert à différencier visuellement plusieurs sessions. Les deux commandes n’ont pas le même rôle.

Utilisez `/theme` pour le confort général. Utilisez plus tard `/color` pour distinguer une session de lecture seule, une session de correction, une session de refactorisation ou un worktree particulier.

## Configurer les notifications

Les notifications deviennent utiles quand vous laissez Claude travailler pendant que vous faites autre chose. Une notification peut signaler qu’une tâche est terminée ou qu’une autorisation est demandée.

Les notifications ne prouvent rien sur la qualité du travail. Elles indiquent seulement que votre attention est requise. La validation se fait toujours avec le diff, les tests et la preuve finale.

Vous pouvez vérifier ou ajuster les notifications depuis `/config`.
Selon votre environnement, vous pouvez aussi définir un canal de notification dans les settings. La clé utile est `preferredNotifChannel`.

Les valeurs possibles incluent notamment :
*   `auto` : Utilise le comportement automatique.
*   `terminal_bell` : Utilise la cloche du terminal.
*   `iterm2` : Utilise les notifications iTerm2.
*   `iterm2_with_bell` : Combine iTerm2 et la cloche.
*   `kitty` : Utilise les notifications Kitty.
*   `ghostty` : Utilise les notifications Ghostty.
*   `notifications_disabled` : Désactive les notifications.

Sur Ghostty, Kitty et iTerm2, les notifications de bureau sont généralement les plus pratiques pour les sessions longues. Dans d’autres terminaux, vous pouvez utiliser la cloche du terminal avec `terminal_bell` ou configurer un hook de notification plus tard.

### Tester une notification sans modifier le projet
Pour tester la notification, demandez une tâche courte qui ne modifie rien.

Quand la commande se termine, vérifiez si une notification s’affiche ou si une cloche retentit. Si rien ne se passe, regardez les réglages du terminal, les permissions de notification du système d’exploitation et la valeur de `preferredNotifChannel`.

## Configurer tmux pour les sessions longues

`tmux` est utile pour travailler avec plusieurs sessions Claude Code. Vous pouvez avoir une session pour la lecture seule, une session pour une correction, une session pour un test long et une session pour une revue de diff.

Mais `tmux` peut bloquer certains signaux. Par défaut, Shift+Enter peut ne pas être distingué de Entrée, et les notifications ou barres de progression peuvent ne pas atteindre le terminal externe.

Ajoutez les lignes suivantes dans `~/.tmux.conf` :
```text
set -g allow-passthrough on
set -s extended-keys on
set -as terminal-features 'xterm*:extkeys'
```
Puis rechargez la configuration : `tmux source-file ~/.tmux.conf`

Ces réglages permettent de mieux transmettre les signaux au terminal hôte. `allow-passthrough` aide les notifications et les mises à jour de progression à atteindre le terminal externe. `extended-keys` aide tmux à distinguer certaines combinaisons de touches.

## Organiser les multi-sessions

Dès que vous utilisez plusieurs sessions, l’organisation du terminal devient importante. Une session sans nom, sans couleur et sans contexte visible peut vite provoquer une erreur : mauvais répertoire, mauvaise branche, mauvaise tâche ou mauvais worktree.

### Utiliser des onglets nommés
Quand vous ouvrez plusieurs sessions, donnez un nom à chaque onglet ou panneau. Les noms doivent décrire la tâche, pas seulement le projet.
Pour un vrai dépôt, les noms peuvent inclure la branche ou le worktree (ex: `convertisseur-lecture`, `convertisseur-correction`).

Organisation recommandée :
1. un onglet ou split par tâche ;
2. un nom explicite pour chaque onglet ;
3. une session Claude Code par contexte ;
4. une vérification de `git status` avant chaque modification ;
5. une notification active pour les tâches longues ;
6. une couleur de session avec `/color` dans la leçon suivante ;
7. une barre de statut avec `/statusline` dans la leçon suivante.
