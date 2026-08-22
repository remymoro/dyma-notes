# Éditer efficacement son prompt dans Claude Code

Dans cette leçon, vous allez apprendre les principaux raccourcis d’édition du prompt dans Claude Code. Ces raccourcis servent à corriger rapidement une consigne, déplacer le curseur, supprimer une partie du texte ou récupérer du texte supprimé sans tout réécrire.

Ils sont particulièrement utiles quand votre prompt devient long : demande de correction, consigne de refactorisation, plan de travail, message multi-ligne ou instruction précise avant une modification de code.

## Se déplacer dans la ligne

Les deux premiers raccourcis permettent de déplacer rapidement le curseur au début ou à la fin de la ligne en cours. Ils évitent d’utiliser plusieurs fois les flèches gauche et droite.

**Aller au début de la ligne :**
```bash
Ctrl+A
# Déplacer le curseur au début de la ligne actuelle.
```

Ce raccourci est utile pour ajouter une précision au début du prompt, par exemple *Ne modifie aucun fichier*, *Explique avant d’agir* ou *Commence par analyser*.

**Aller à la fin de la ligne :**
```bash
Ctrl+E
# Déplacer le curseur à la fin de la ligne actuelle.
```

Ce raccourci sert à reprendre immédiatement la saisie à la fin du prompt, sans déplacer le curseur manuellement.

## Supprimer rapidement une partie du prompt

Les raccourcis suivants permettent de supprimer du texte autour du curseur. Le texte supprimé avec `Ctrl+K`, `Ctrl+U` ou `Ctrl+W` est conservé temporairement et peut être recollé avec `Ctrl+Y`.

**Supprimer jusqu’à la fin de la ligne :**
```bash
Ctrl+K
# Supprimer le texte depuis le curseur jusqu’à la fin de la ligne.
```

Ce raccourci est utile quand la fin du prompt n’est plus bonne. Placez le curseur avant la partie à remplacer, utilisez `Ctrl+K`, puis retapez une consigne plus précise.

**Supprimer jusqu’au début de la ligne :**
```bash
Ctrl+U
# Supprimer le texte depuis le curseur jusqu’au début de la ligne.
```

Ce raccourci est utile quand vous voulez conserver la fin d’une consigne, mais remplacer son début. Dans une saisie multi-ligne, il agit sur la ligne logique courante.

**Supprimer le mot précédent :**
```bash
Ctrl+W
# Supprimer le mot situé avant le curseur.
```

Ce raccourci sert à corriger rapidement un mot, une commande, un nom de fichier ou une option. Sur Windows, `Ctrl+Backspace` peut aussi supprimer le mot précédent selon le terminal.

## Récupérer du texte supprimé

Quand vous supprimez du texte avec `Ctrl+K`, `Ctrl+U` ou `Ctrl+W`, vous pouvez le remettre dans le prompt avec `Ctrl+Y`. C’est l’équivalent d’un collage interne pour le texte supprimé par ces raccourcis.

**Coller le dernier texte supprimé :**
```bash
Ctrl+Y
# Coller le texte supprimé avec Ctrl+K, Ctrl+U ou Ctrl+W.
```

Ce raccourci est utile quand vous avez supprimé trop vite une partie du prompt ou quand vous voulez déplacer une portion de texte. Supprimez le texte, placez le curseur ailleurs, puis utilisez `Ctrl+Y`.

**Parcourir l’historique des textes supprimés :**
```bash
Alt+Y
# Après Ctrl+Y, remplacer le texte collé par un texte supprimé précédemment.
```

`Alt+Y` s’utilise juste après `Ctrl+Y`. Il permet de parcourir les suppressions précédentes lorsque plusieurs morceaux de texte ont été supprimés successivement.

## Se déplacer mot par mot

Quand un prompt devient long, se déplacer caractère par caractère est lent. Les raccourcis suivants permettent de naviguer mot par mot.

**Reculer d’un mot :**
```bash
Alt+B
# Reculer le curseur d’un mot.
```

Ce raccourci est utile pour revenir rapidement sur une instruction, un nom de fichier, une option ou un terme technique placé avant le curseur.

**Avancer d’un mot :**
```bash
Alt+F
# Avancer le curseur d’un mot.
```

Ce raccourci permet de traverser rapidement une consigne longue sans maintenir la flèche droite.

### Cas particulier sur macOS

Sur macOS, la touche `Alt` correspond généralement à la touche `Option`. Dans beaucoup de terminaux, les raccourcis comme `Alt+B`, `Alt+F` ou `Alt+Y` ne fonctionnent pas tant que `Option` n’est pas configurée comme touche Meta.

**Réglage à vérifier :**
```bash
Option comme Meta
# Activer ce réglage dans le terminal si les raccourcis ne fonctionnent pas.
```

Selon le terminal, le réglage peut s’appeler *Use Option as Meta Key*, *Esc+* ou *macOptionIsMeta*. Sans ce réglage, le terminal peut interpréter `Option` autrement et ne pas transmettre correctement le raccourci à Claude Code.

## Exemple d’utilisation complète

Imaginez que vous avez commencé à écrire ce prompt :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

*Analyse le fichier auth.ts et corrige directement le bug.*

</div>

Vous vous rendez compte que la fin est trop risquée. Placez le curseur avant "corrige directement", puis utilisez :

```bash
Ctrl+K
# Supprimer la fin de la ligne.
```

Vous pouvez ensuite remplacer la fin par une consigne plus sûre :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

*Analyse le fichier auth.ts et propose un plan avant toute action.*

</div>

Si vous voulez récupérer la partie supprimée, utilisez :

```bash
Ctrl+Y
# Recoller le texte supprimé.
```

## Résumé des raccourcis

### Déplacement
```bash
Ctrl+A
# Aller au début de la ligne.

Ctrl+E
# Aller à la fin de la ligne.

Alt+B
# Reculer d’un mot.

Alt+F
# Avancer d’un mot.
```

### Suppression
```bash
Ctrl+K
# Supprimer du curseur à la fin de la ligne.

Ctrl+U
# Supprimer du curseur au début de la ligne.

Ctrl+W
# Supprimer le mot précédent.
```

### Récupération
```bash
Ctrl+Y
# Coller le texte supprimé par Ctrl+K, Ctrl+U ou Ctrl+W.

Alt+Y
# Après Ctrl+Y, parcourir les textes supprimés précédemment.
```
