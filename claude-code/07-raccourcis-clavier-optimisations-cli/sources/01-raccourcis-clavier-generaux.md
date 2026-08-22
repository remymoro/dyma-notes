# Raccourcis et commandes rapides dans Claude Code

Les raccourcis de Claude Code ne doivent pas être appris comme une simple liste de touches. Ils structurent le pilotage de la session : saisir plus vite, interrompre une mauvaise trajectoire, ouvrir une transcription, envoyer une commande shell, gérer les tâches en arrière-plan, changer de mode, inspecter un diff ou poser une question secondaire sans polluer le contexte principal.

Un raccourci n’est fiable que dans son contexte. Une même touche peut avoir un sens différent dans le chat principal, la recherche d’historique, le sélecteur de sessions, la visionneuse de transcription, la visionneuse de diff ou l’application Desktop. Il faut donc toujours associer le raccourci à sa zone d’application.

## Avant de commencer

### Les raccourcis dépendent du terminal

Les raccourcis peuvent varier selon le terminal, le système d’exploitation, le mode de rendu, la version de Claude Code et les raccourcis interceptés par `tmux`, `screen` ou l’éditeur intégré. La documentation indique par exemple que `Shift + Enter` fonctionne directement dans plusieurs terminaux, mais que VS Code, Cursor, Devin Desktop, Alacritty et Zed peuvent nécessiter `/terminal-setup`. Lorsque `Shift + Enter` n’est pas disponible, `Ctrl + J` reste l’alternative portable pour insérer une nouvelle ligne.

Sur macOS, les raccourcis avec `Option` ou `Alt`, comme `Option + P`, `Option + T` ou `Option + O`, exigent souvent que le terminal envoie `Option` comme touche Meta.

## Préfixes de saisie

### ! : exécuter une commande shell

Un message qui commence par `!` exécute une commande shell directement depuis la session. La sortie devient disponible dans la conversation, ce qui peut être utile pour consulter rapidement l’état du projet. Il faut l’utiliser avec la même prudence qu’une commande shell normale, car elle agit dans l’environnement réel.

Le mode shell se quitte avec `Esc`, `Backspace` ou `Ctrl + U` lorsque l’invite est vide. Il ne faut pas confondre ce préfixe avec une demande faite à Claude : ici, vous demandez une exécution shell directe.

```bash
!git status
```

### Touches de la surimpression /btw

| Touche | Action |
| --- | --- |
| `Espace`, `Entrée` ou `Esc` | Fermer la réponse et revenir à l’invite. |
| `Haut` et `Bas` | Faire défiler la réponse. |
| `Gauche` et `Droite` | Naviguer entre les réponses `/btw` antérieures de la session, selon version. |
| `c` | Copier la réponse en Markdown brut. |
| `f` | Diviser l’échange en nouvelle session avec accès complet aux outils. |
| `x` | Effacer les anciens échanges `/btw` affichés dans la surimpression. |

## Saisir et éditer un prompt

### Raccourcis de saisie principaux

| Raccourci | Action |
| --- | --- |
| `Entrée` | Envoyer le message. |
| `Shift + Enter` | Insérer une nouvelle ligne lorsque le terminal le supporte. |
| `Ctrl + J` | Insérer une nouvelle ligne sans envoyer le message. |
| `Ctrl + G` | Ouvrir l’invite dans l’éditeur externe par défaut. |
| `Ctrl + X` puis `Ctrl + E` | Ouvrir l’invite dans l’éditeur externe avec la liaison native de type readline. |
| `Ctrl + S` | Mettre le prompt courant de côté. |
| `Ctrl + _` ou `Ctrl + Shift + -` | Annuler la dernière action de saisie. |
| `Ctrl + V`, `Cmd + V` dans iTerm2, ou `Alt + V` sous Windows/WSL | Coller une image depuis le presse-papiers. |

`Ctrl + L` force un redessinage complet de l’écran, tout en conservant l’entrée et l’historique de la conversation.

### Raccourcis de ligne et de mots

| Raccourci | Action habituelle |
| --- | --- |
| `Ctrl + A` | Aller au début de la ligne. |
| `Ctrl + E` | Aller à la fin de la ligne. |
| `Ctrl + K` | Supprimer jusqu’à la fin de la ligne. |
| `Ctrl + U` | Supprimer jusqu’au début de la ligne. |
| `Ctrl + W` | Supprimer le mot précédent. |
| `Ctrl + Y` | Coller le dernier texte supprimé par les raccourcis d’édition de ligne. |
| `Alt + Y` | Après `Ctrl + Y`, parcourir l’historique du texte supprimé. |
| `Alt + B` | Déplacer le curseur d’un mot vers l’arrière. |
| `Alt + F` | Déplacer le curseur d’un mot vers l’avant. |

## Naviguer dans l’historique

### Historique des prompts

| Raccourci | Action |
| --- | --- |
| `Haut` et `Bas` | Parcourir les prompts précédents et suivants. |
| `Ctrl + R` | Ouvrir la recherche inversée dans l’historique. |
| `Ctrl + R` dans la recherche | Aller à la correspondance suivante. |
| `Ctrl + S` dans la recherche | Changer la portée de recherche entre session, projet et tous les projets. |
| `Entrée` dans la recherche | Exécuter la commande sélectionnée. |
| `Esc` ou `Tab` dans la recherche | Accepter la sélection sans forcément l’exécuter. |
| `Ctrl + C` dans la recherche | Annuler la recherche. |

### Contrôler l’exécution

#### Interrompre et reprendre le contrôle

| Raccourci | Action |
| --- | --- |
| `Esc` | Interrompre la réponse actuelle ou l’appel d’outil en cours. |
| `Esc` puis `Esc` | Si l’invite est vide, ouvrir le menu de rembobinage ; sinon effacer le brouillon et le conserver dans l’historique. |
| `Ctrl + C` | Interrompre une opération en cours ; si rien ne s’exécute, effacer l’entrée puis quitter à la pression suivante. |
| `Ctrl + D` | Quitter la session Claude Code. |
| `Ctrl + Z` | Suspendre le processus dans un environnement Unix. |

#### Tâches en arrière-plan

| Raccourci ou commande | Action |
| --- | --- |
| `Ctrl + B` | Mettre en arrière-plan une commande Bash ou un agent. |
| `Ctrl + X` puis `Ctrl + B` | Mettre la tâche actuelle en arrière-plan, avec moins de conflit avec tmux. |
| `Ctrl + T` | Afficher ou masquer la liste des tâches. |
| `Ctrl + X` puis `Ctrl + K` | Arrêter tous les agents en arrière-plan de la session, avec confirmation. |
| `/tasks` | Afficher et gérer les tâches en arrière-plan. |

## Inspecter la session

### Ctrl + O : visionneuse de transcription dans le CLI

Dans le CLI, `Ctrl + O` affiche ou masque la visionneuse de transcription. Cette vue montre l’utilisation détaillée des outils et l’exécution.

| Raccourci dans la visionneuse | Action |
| --- | --- |
| `?` | Afficher l’aide des raccourcis de la visionneuse. |
| `Ctrl + E` | Basculer l’affichage de tout le contenu. |
| `q`, `Ctrl + C` ou `Esc` | Quitter la visionneuse. |
| `{` et `}` | Aller à l’invite utilisateur précédente ou suivante, selon la vue. |
| `[` | Écrire la conversation complète dans le défilement natif du terminal, selon version. |
| `v` | Ouvrir la conversation dans un fichier temporaire avec l’éditeur, selon version. |

Il faut séparer `Ctrl + O` dans le CLI et `Ctrl + O` dans l’application Desktop. Dans le CLI, il ouvre ou ferme la visionneuse de transcription. Dans Desktop, il parcourt les modes d’affichage de la transcription.

### /diff et raccourcis de la visionneuse de diff

`/diff` ouvre une visionneuse interactive des différences. Dans cette visionneuse, les raccourcis appartiennent au contexte `DiffDialog`.

| Raccourci | Action dans `/diff` |
| --- | --- |
| `Esc` | Fermer la visionneuse de diff. |
| `Gauche` et `Droite` | Changer la source de diff. |
| `Haut`, `Bas`, `K` et `J` | Naviguer entre les fichiers ou faire défiler la vue détaillée. |
| `Entrée` | Afficher les détails du diff. |
| `PageUp` et `PageDown` | Faire défiler la vue détaillée par demi-page. |
| `Espace` et `Shift + Espace` | Faire défiler par page dans la vue détaillée. |
| `G`, `Home`, `Shift + G` ou `End` | Aller au début ou à la fin. |

## Changer de mode, de modèle et d’effort

### Raccourcis de comportement

| Raccourci | Action |
| --- | --- |
| `Shift + Tab` | Faire défiler les modes de permission. |
| `Alt + M` ou `Meta + M` | Alternative dans certaines configurations Windows sans mode VT. |
| `Alt + P` ou `Option + P` | Ouvrir le sélecteur de modèle sans vider le prompt. |
| `Alt + O` ou `Option + O` | Activer ou désactiver le mode rapide. |
| `Alt + T` ou `Option + T` | Activer ou désactiver la réflexion étendue. |

### Dans le sélecteur de modèle

| Raccourci | Action |
| --- | --- |
| `Gauche` | Diminuer le niveau d’effort lorsque le modèle le prend en charge. |
| `Droite` | Augmenter le niveau d’effort lorsque le modèle le prend en charge. |
| `s` | Appliquer le modèle sélectionné seulement à la session actuelle. |

Ces raccourcis sont propres au sélecteur de modèle et ne doivent pas être généralisés au chat principal.

## Dialogues, sélecteurs et autocomplétion

### Autocomplétion

| Raccourci | Action |
| --- | --- |
| `Tab` | Accepter la suggestion. |
| `Esc` | Fermer le menu d’autocomplétion. |
| `Haut` et `Bas` | Suggestion précédente ou suivante. |

### Dialogues de confirmation et de permission

| Raccourci | Action |
| --- | --- |
| `Y` ou `Entrée` | Confirmer l’action. |
| `N` ou `Esc` | Refuser l’action. |
| `Haut` et `Bas` | Option précédente ou suivante. |
| `Tab` | Champ suivant. |
| `Espace` | Basculer la sélection. |
| `Shift + Tab` | Changer de mode de permission dans dialogues compatibles. |
| `Ctrl + E` | Basculer l’explication de permission. |

### Sélecteurs généraux

| Raccourci | Action |
| --- | --- |
| `Bas`, `J` ou `Ctrl + N` | Option suivante. |
| `Haut`, `K` ou `Ctrl + P` | Option précédente. |
| `Entrée` | Accepter la sélection. |
| `Esc` | Annuler la sélection. |

## Tâches, agents et arrière-plan

### /tasks et Ctrl + T

`Ctrl + T` affiche ou masque la liste des tâches dans la zone d’état du terminal. `/tasks` ouvre la gestion des tâches en arrière-plan. La page Desktop précise aussi que le volet des tâches affiche le travail en arrière-plan de la session : agents secondaires, commandes shell et workflows dynamiques.

Il faut utiliser `/tasks` pour gérer les travaux en arrière-plan. La touche `x` ne nettoie pas les tâches ; elle nettoie les anciens échanges `/btw` dans la surimpression latérale.

### Mettre un agent ou une commande en arrière-plan

`Ctrl + B` met en arrière-plan les commandes Bash et les agents. Sous `tmux`, la documentation indique qu’il faut souvent appuyer deux fois, car `Ctrl + B` est aussi le préfixe de tmux.

```bash
/tasks
```

```bash
Ctrl + B
# Mettre la commande ou l’agent courant en arrière-plan

Ctrl + X puis Ctrl + B
# Variante utile pour éviter le conflit avec tmux.
```

## Application Desktop

### Ne pas mélanger CLI et Desktop

L’application Desktop possède ses propres raccourcis.

| Raccourci Desktop | Action |
| --- | --- |
| `Cmd + /` (macOS) ou `Ctrl + /` (Windows) | Afficher les raccourcis disponibles dans l’onglet Code. |
| `Ctrl + O` | Parcourir les modes d’affichage de la transcription. |
| `Cmd + N` (macOS) ou `Ctrl + N` (Windows) | Créer une nouvelle session. |
| `Ctrl + Tab` et `Ctrl + Shift + Tab` | Parcourir les sessions. |
| `Cmd + \` (macOS) ou `Ctrl + \` (Windows) | Fermer le volet actif. |
| `Ctrl + \`` | Ouvrir le terminal intégré. |
| `Cmd + ;` (macOS) ou `Ctrl + ;` (Windows) | Ouvrir le chat latéral. |

Ce bloc doit rester séparé de la leçon CLI. Les raccourcis Desktop pilotent des volets, des sessions visuelles, le terminal intégré et le chat latéral dans l’application graphique. Les raccourcis CLI pilotent directement l’invite terminal.

## Les raccourcis à connaître en priorité

| Action | Raccourci ou commande |
| --- | --- |
| Interrompre Claude | `Esc` |
| Rembobiner ou effacer le brouillon selon le contexte | `Esc` puis `Esc` |
| Quitter | `Ctrl + D` |
| Redessiner l’écran sans perdre l’entrée | `Ctrl + L` |
| Ouvrir l’éditeur externe | `Ctrl + G` |
| Mettre le prompt de côté | `Ctrl + S` |
| Recherche d’historique | `Ctrl + R` |
| Transcription détaillée dans le CLI | `Ctrl + O` |
| Mettre une tâche en arrière-plan | `Ctrl + B` |
| Afficher la liste des tâches | `Ctrl + T` |
| Gérer les tâches | `/tasks` |
| Changer de mode de permission | `Shift + Tab` |
| Ouvrir le modèle | `Alt + P` ou `Option + P` |
| Basculer le mode rapide | `Alt + O` ou `Option + O` |
| Basculer la réflexion étendue | `Alt + T` ou `Option + T` |
| Commande shell directe | `!` |
| Question latérale hors historique | `/btw` |
| Effacer les anciens échanges `/btw` affichés | `x` dans la surimpression `/btw` |
