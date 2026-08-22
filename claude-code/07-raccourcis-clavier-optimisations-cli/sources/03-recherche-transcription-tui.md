# Comprendre la recherche en mode tui

Dans le rendu classique du terminal, la conversation reste dans le scrollback natif. Vous pouvez donc souvent utiliser la recherche habituelle du terminal, par exemple `Cmd+F` sur macOS, la recherche intégrée de votre terminal ou le mode copie de tmux.

En rendu plein écran, la conversation est affichée dans une interface tui, c’est-à-dire une interface textuelle plein écran. Dans ce mode, le terminal ne voit pas toujours toute la conversation comme un simple historique de lignes. Pour relire, chercher ou exporter la conversation, il faut utiliser le mode transcription de Claude Code.

## Ouvrir le mode transcription

Le mode transcription sert à relire la conversation complète avec des raccourcis de navigation, de recherche, d’export vers le scrollback et d’ouverture dans un éditeur.

```bash
Ctrl+O
# Basculer vers le mode transcription.
```

### Afficher l’aide des raccourcis

Ce panneau d’aide est utile parce que certains raccourcis dépendent du rendu plein écran, du terminal et de la version de Claude Code. Quand vous avez un doute, ouvrez le mode transcription avec `Ctrl+O`, puis affichez l’aide avec `?`.

```bash
?
# Afficher ou masquer l’aide des raccourcis du mode transcription.
```

## Rechercher dans la transcription

Dans le mode transcription, la recherche fonctionne comme dans un pager de type `less`. Vous ouvrez la recherche, vous tapez le texte à trouver, puis vous naviguez entre les résultats.

**Ouvrir et parcourir les résultats :**
```bash
/
# Ouvrir la recherche.

n
# Aller à l’occurrence suivante.

N
# Aller à l’occurrence précédente.
```

Utilisez cette recherche quand la recherche native du terminal ne trouve pas un passage pourtant visible dans Claude Code. C’est le cas typique en rendu plein écran, où le contenu affiché ne correspond pas toujours au scrollback natif du terminal.

## Faire défiler la transcription

Le mode transcription fournit plusieurs raccourcis de défilement. Ils permettent de lire une longue conversation sans dépendre uniquement de la molette ou des raccourcis du terminal.

**Défiler ligne par ligne :**
```bash
j
# Faire défiler vers le bas.

k
# Faire défiler vers le haut.

↓
# Faire défiler vers le bas.

↑
# Faire défiler vers le haut.
```

**Défiler par demi-page :**
```bash
Ctrl+D
# Descendre d’une demi-page.

Ctrl+U
# Remonter d’une demi-page.
```

**Défiler par page entière :**
```bash
Espace
# Descendre d’une page.

b
# Remonter d’une page.
```

**Aller au début ou à la fin :**
```bash
g
# Aller au début de la transcription.

G
# Aller à la fin de la transcription.
```

## Naviguer entre les prompts

Le mode transcription permet aussi de se déplacer de prompt utilisateur en prompt utilisateur. C’est pratique pour retrouver rapidement une demande précise dans une longue session.

**Passer au prompt précédent ou suivant :**
```bash
↑
# Aller au prompt précédent.

↓
# Aller au prompt suivant.
```

Selon la version et le terminal, l’aide intégrée peut aussi indiquer des raccourcis de navigation de type vim pour passer d’un prompt utilisateur à l’autre :
```bash
{
# Aller au prompt utilisateur précédent.

}
# Aller au prompt utilisateur suivant.
```

## Écrire la conversation dans le scrollback natif

Si vous voulez remettre la conversation complète dans le scrollback natif du terminal, ouvrez d’abord le mode transcription. Puis utilisez le raccourci suivant.

Après cette action, vous pouvez utiliser les outils habituels du terminal : recherche native, sélection à la souris, copie, `Cmd+F` sur macOS ou mode copie de tmux.

```bash
Ctrl+O
# Ouvrir le mode transcription.

[
# Écrire la conversation complète dans le scrollback natif.
```

Cette opération peut prendre un moment sur une session longue. Utilisez-la quand vous avez besoin de rechercher, copier ou inspecter la conversation complète avec les outils du terminal plutôt qu’avec l’interface de Claude Code.

## Ouvrir la conversation dans l’éditeur

Le mode transcription permet aussi d’écrire la conversation dans un fichier temporaire et de l’ouvrir dans l’éditeur configuré avec `$VISUAL` ou `$EDITOR`.

**Ouvrir dans l’éditeur de code :**
Cette méthode est utile pour relire une longue session, chercher des passages, copier un extrait, préparer une synthèse ou archiver une trace de travail.

Avant d’ouvrir la transcription dans l’éditeur, vous pouvez demander à Claude de produire une synthèse finale de la session.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande de synthèse :**

*« Ne modifie aucun fichier.*

*Ajoute un résumé final de cette session :*
*1. commandes testées ;*
*2. rendu actif ;*
*3. points à retenir ;*
*4. limites observées ;*
*5. prochaine action recommandée. »*

</div>

Ensuite, ouvrez la transcription avec `Ctrl+O`, puis `v`.

```bash
Ctrl+O
# Ouvrir le mode transcription.

v
# Ouvrir la conversation dans l’éditeur configuré.
```

## Quitter le mode transcription

Quand vous avez terminé la recherche ou la relecture, vous pouvez quitter le mode transcription et revenir à la conversation normale.

**Sortir de la transcription :**
```bash
q
# Quitter le mode transcription.

Échap
# Quitter le mode transcription.

Ctrl+C
# Quitter le mode transcription.
```

## Faire défiler la conversation en rendu plein écran

En dehors du mode transcription, le rendu plein écran de Claude Code possède aussi des raccourcis de défilement. Ces raccourcis s’appliquent à la conversation affichée dans l’interface plein écran.

**Défilement principal :**
```bash
PageUp
# Faire défiler vers le haut d’une demi-hauteur de fenêtre.

PageDown
# Faire défiler vers le bas d’une demi-hauteur de fenêtre.

Ctrl+Home
# Aller au début de la conversation.

Ctrl+End
# Aller au dernier message et réactiver le suivi automatique.
```

Sur certains claviers, notamment les claviers de portable, les touches `PageUp`, `PageDown`, `Home` et `End` peuvent être accessibles avec `Fn`.

**Défilement alternatif :**
```bash
Fn+↑
# Équivalent de PageUp sur certains claviers.

Fn+↓
# Équivalent de PageDown sur certains claviers.

Fn+←
# Équivalent de Home sur certains claviers.

Fn+→
# Équivalent de End sur certains claviers.
```

**Défilement à la souris :**
```bash
Molette de souris
# Faire défiler la conversation si le terminal transmet les événements de souris.
```

## Résumé des raccourcis à connaître

### Mode transcription

| Raccourci | Action |
| --- | --- |
| `Ctrl+O` | Basculer vers le mode transcription. |
| `?` | Afficher ou masquer l’aide. |
| `/` | Ouvrir la recherche. |
| `n` | Occurrence suivante. |
| `N` | Occurrence précédente. |
| `j` | Défiler vers le bas. |
| `k` | Défiler vers le haut. |
| `↓` | Défiler vers le bas ou aller au prompt suivant selon le contexte. |
| `↑` | Défiler vers le haut ou aller au prompt précédent selon le contexte. |
| `Ctrl+D` | Descendre d’une demi-page. |
| `Ctrl+U` | Remonter d’une demi-page. |
| `Espace` | Descendre d’une page. |
| `b` | Remonter d’une page. |
| `g` | Aller au début. |
| `G` | Aller à la fin. |
| `{` | Aller au prompt utilisateur précédent si ce raccourci est supporté. |
| `}` | Aller au prompt utilisateur suivant si ce raccourci est supporté. |
| `[` | Écrire la conversation dans le scrollback natif. |
| `v` | Ouvrir la conversation dans l’éditeur configuré. |
| `q`, `Échap`, `Ctrl+C` | Quitter. |

### Rendu plein écran

| Raccourci | Action |
| --- | --- |
| `PageUp` / `Fn+↑` | Défiler vers le haut. |
| `PageDown` / `Fn+↓` | Défiler vers le bas. |
| `Ctrl+Home` | Aller au début de la conversation. |
| `Ctrl+End` | Aller au dernier message et réactiver le suivi automatique. |
| `Molette de souris` | Défiler si le terminal le permet. |
