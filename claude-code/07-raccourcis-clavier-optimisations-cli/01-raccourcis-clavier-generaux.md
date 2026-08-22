---
title: "Raccourcis et commandes rapides dans Claude Code"
description: "Découvrir les principaux raccourcis permettant de saisir, naviguer, interrompre, inspecter et piloter efficacement une session Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - raccourcis
  - productivite
categories:
  - "Chapitre 7"
cours: Claude Code
chapitre: 07-raccourcis-clavier-optimisations-cli
leçon: 01-raccourcis-clavier-generaux
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                   | Notes détaillées                                                                                                                          |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Pourquoi apprendre les raccourcis par contexte ?           | Parce qu’une même touche peut avoir un comportement différent dans le chat principal, un sélecteur, la transcription, `/diff` ou Desktop. |
| De quoi dépendent les raccourcis ?                         | Du terminal, du système d’exploitation, de la version de Claude Code et d’outils comme tmux, screen ou certains IDE.                      |
| Comment insérer une nouvelle ligne ?                       | `Shift + Enter` lorsque le terminal le prend en charge, ou `Ctrl + J` comme alternative portable.                                         |
| À quoi sert le préfixe `!` ?                               | À exécuter directement une commande shell depuis la session Claude Code.                                                                  |
| À quoi sert `/terminal-setup` ?                            | À configurer certains terminaux pour que les raccourcis comme `Shift + Enter` fonctionnent correctement.                                  |
| Comment envoyer un prompt ?                                | Avec `Entrée`.                                                                                                                            |
| Comment ouvrir le prompt dans un éditeur externe ?         | Avec `Ctrl + G`, ou `Ctrl + X` puis `Ctrl + E` selon le mode d’édition.                                                                   |
| Comment mettre un prompt de côté ?                         | `Ctrl + S`.                                                                                                                               |
| Comment rechercher un ancien prompt ?                      | `Ctrl + R` ouvre la recherche inversée dans l’historique.                                                                                 |
| Comment interrompre Claude rapidement ?                    | `Esc` interrompt la réponse ou l’appel d’outil en cours.                                                                                  |
| Que fait `Esc` puis `Esc` ?                                | Selon le contexte, ouvre le menu de rembobinage ou efface le brouillon en le conservant dans l’historique.                                |
| À quoi sert `Ctrl + C` ?                                   | À interrompre une opération ; sans opération active, il peut effacer l’entrée puis permettre de quitter.                                  |
| Comment quitter Claude Code au clavier ?                   | `Ctrl + D`.                                                                                                                               |
| Comment mettre une tâche en arrière-plan ?                 | `Ctrl + B`, ou `Ctrl + X` puis `Ctrl + B` pour limiter les conflits avec tmux.                                                            |
| Comment voir les tâches en arrière-plan ?                  | `Ctrl + T` affiche ou masque leur liste ; `/tasks` ouvre leur gestion.                                                                    |
| À quoi sert `Ctrl + O` dans le CLI ?                       | À afficher ou masquer la visionneuse de transcription détaillée.                                                                          |
| À quoi sert `/diff` ?                                      | À ouvrir une visionneuse interactive des différences.                                                                                     |
| Comment changer de mode de permission ?                    | `Shift + Tab`.                                                                                                                            |
| Comment ouvrir le sélecteur de modèle ?                    | `Alt + P` ou `Option + P`.                                                                                                                |
| Comment activer ou désactiver le mode rapide ?             | `Alt + O` ou `Option + O`.                                                                                                                |
| Comment basculer la réflexion étendue ?                    | `Alt + T` ou `Option + T`.                                                                                                                |
| Comment naviguer dans les sélecteurs ?                     | Généralement avec `Haut/Bas`, `J/K`, `Ctrl + N/P`, puis `Entrée` pour valider et `Esc` pour annuler.                                      |
| Les raccourcis Desktop sont-ils identiques à ceux du CLI ? | Non. Desktop possède son propre ensemble de raccourcis pour les sessions, panneaux, chat et terminal intégré.                             |

## Synthèse

Les raccourcis de Claude Code permettent surtout de reprendre rapidement le contrôle de la session, modifier un prompt, naviguer dans l’historique, inspecter l’exécution et gérer des tâches. Il faut apprendre en priorité quelques commandes essentielles et toujours tenir compte de la zone dans laquelle le raccourci est utilisé.

## Glossaire

* raccourci clavier : combinaison de touches permettant de déclencher rapidement une action.
* contexte de raccourci : zone de Claude Code dans laquelle une touche possède un comportement donné.
* `/terminal-setup` : commande facilitant la configuration de certains raccourcis selon le terminal.
* shell mode : mode permettant d’exécuter directement une commande shell avec le préfixe `!`.
* historique : ensemble des prompts précédemment envoyés.
* recherche inversée : recherche dans l’historique déclenchée avec `Ctrl + R`.
* rembobinage : mécanisme permettant de revenir à un état antérieur de la session.
* arrière-plan : mode dans lequel une commande ou un agent continue de travailler sans bloquer l’interaction principale.
* `/tasks` : commande de gestion des tâches en arrière-plan.
* transcription : vue détaillée montrant notamment les outils et étapes d’exécution de la session.
* `/diff` : visionneuse interactive des changements.
* mode de permission : niveau déterminant la manière dont Claude Code demande ou reçoit l’autorisation d’agir.
* sélecteur de modèle : interface permettant de choisir un modèle ou un niveau d’effort.
* `/btw` : mécanisme permettant de poser une question secondaire sans l’intégrer de la même manière à la trajectoire principale.
* tmux : multiplexeur de terminal pouvant intercepter certains raccourcis.
* autocomplétion : système proposant automatiquement des commandes ou valeurs pendant la saisie.

## Questions d'auto-évaluation

1. Pourquoi ne faut-il pas apprendre les raccourcis Claude Code comme une simple liste ?
2. Quels éléments peuvent modifier le fonctionnement d’un raccourci ?
3. Quelle différence existe-t-il entre `Shift + Enter` et `Ctrl + J` ?
4. À quoi sert `/terminal-setup` ?
5. Que signifie un message commençant par `!` ?
6. Pourquoi faut-il utiliser `!` avec prudence ?
7. Comment ouvrir un prompt long dans un éditeur externe ?
8. À quoi sert `Ctrl + S` pendant la rédaction ?
9. Quels raccourcis permettent de se déplacer au début ou à la fin d’une ligne ?
10. À quoi servent `Ctrl + K` et `Ctrl + U` ?
11. Comment rechercher un ancien prompt ?
12. Quelle différence existe-t-il entre `Esc`, `Ctrl + C` et `Ctrl + D` ?
13. Que peut faire `Esc` puis `Esc` ?
14. Comment mettre une commande Bash ou un agent en arrière-plan ?
15. Pourquoi `Ctrl + B` peut-il poser problème avec tmux ?
16. À quoi servent `Ctrl + T` et `/tasks` ?
17. À quoi sert `Ctrl + O` dans le CLI ?
18. Pourquoi `Ctrl + O` ne doit-il pas être mémorisé sans son contexte ?
19. À quoi sert `/diff` ?
20. Quels raccourcis permettent de naviguer dans la visionneuse `/diff` ?
21. Comment changer rapidement de mode de permission ?
22. Comment ouvrir le sélecteur de modèle ?
23. À quoi servent `Alt + O` et `Alt + T` ?
24. Comment fonctionnent généralement les dialogues de confirmation ?
25. Pourquoi faut-il séparer les raccourcis CLI et Desktop ?
26. Quels raccourcis faut-il connaître en priorité pour reprendre le contrôle d’une session ?

# Raccourcis et commandes rapides dans Claude Code

**Durée : 22 minutes**

## Notes

Les raccourcis de Claude Code ne servent pas uniquement à gagner quelques secondes.

Ils permettent de **piloter la session**.

Ils servent notamment à :

```text
écrire plus vite
        ↓
interrompre une mauvaise trajectoire
        ↓
naviguer dans l'historique
        ↓
inspecter l'exécution
        ↓
gérer les tâches
        ↓
changer de mode
```

Une règle est cependant essentielle :

```text
Un raccourci
    +
son contexte
    =
son comportement réel
```

Une même combinaison peut produire une action différente selon qu’on se trouve dans :

* le chat principal ;
* la recherche d’historique ;
* un sélecteur ;
* la transcription ;
* `/diff` ;
* Desktop.

Il ne faut donc pas apprendre uniquement :

```text
Ctrl + O = ...
```

mais plutôt :

```text
Ctrl + O dans le CLI
→ transcription

Ctrl + O dans Desktop
→ changement de vue de transcription
```

Le terminal lui-même peut également influencer les raccourcis.

Le fonctionnement dépend notamment :

* du système d’exploitation ;
* du terminal ;
* de Claude Code ;
* de tmux ;
* de screen ;
* de certains IDE.

Par exemple, pour insérer une nouvelle ligne :

```text
Shift + Enter
→ fonctionne si le terminal le prend en charge
```

Sinon :

```text
Ctrl + J
→ alternative portable
```

Certains terminaux peuvent nécessiter :

```text
/terminal-setup
```

Cette commande aide notamment lorsque `Shift + Enter` n’est pas correctement transmis à Claude Code.

Sur macOS, les raccourcis utilisant `Option` peuvent également dépendre de la configuration du terminal.

Le terminal doit parfois envoyer `Option` comme touche `Meta`.

### Exécuter rapidement une commande shell

Claude Code possède un préfixe de saisie particulier :

```text
!
```

Lorsqu’un message commence par `!`, il est interprété comme une commande shell directe.

Par exemple :

```text
!git status
```

On peut représenter la différence ainsi :

```text
git status
dans une phrase
        ↓
demande adressée à Claude
```

contre :

```text
!git status
        ↓
commande shell exécutée directement
```

La sortie devient ensuite disponible dans la conversation.

Cela peut être pratique pour vérifier rapidement :

* Git ;
* un fichier ;
* une commande ;
* un test ;
* un script.

Mais le préfixe `!` agit dans l’environnement réel.

Il doit donc être utilisé avec la même prudence qu’un terminal normal.

### Écrire et envoyer un prompt

Le raccourci de base est :

```text
Entrée
→ envoyer le message
```

Pour insérer une nouvelle ligne :

```text
Shift + Enter
```

ou :

```text
Ctrl + J
```

Cette différence est importante pour les prompts structurés.

Par exemple :

```text
Objectif :
corriger le bug.

Contraintes :
- ne pas modifier l'API ;
- ajouter un test.
```

Sans raccourci de nouvelle ligne, la rédaction de prompts longs devient moins confortable.

Pour un prompt encore plus important, on peut ouvrir un éditeur externe :

```text
Ctrl + G
```

Une autre variante est :

```text
Ctrl + X
puis
Ctrl + E
```

selon la liaison clavier utilisée.

Cela permet de rédiger dans son éditeur habituel plutôt que directement dans une petite ligne de terminal.

### Mettre un prompt de côté

Claude Code permet également de mettre temporairement de côté le prompt en cours avec :

```text
Ctrl + S
```

Cela permet de conserver un brouillon et d’effectuer autre chose avant de reprendre la rédaction.

On peut représenter cela ainsi :

```text
Prompt en cours
      ↓
Ctrl + S
      ↓
mis de côté
      ↓
autre interaction
      ↓
reprise ultérieure
```

### Modifier rapidement une ligne

Plusieurs raccourcis hérités des comportements de terminal classiques sont disponibles.

```text
Ctrl + A
→ début de ligne

Ctrl + E
→ fin de ligne
```

Pour supprimer :

```text
Ctrl + K
→ supprimer jusqu'à la fin

Ctrl + U
→ supprimer jusqu'au début

Ctrl + W
→ supprimer le mot précédent
```

Pour récupérer du texte supprimé :

```text
Ctrl + Y
```

Puis éventuellement :

```text
Alt + Y
```

pour parcourir les éléments supprimés précédemment.

Pour naviguer mot par mot :

```text
Alt + B
→ mot précédent

Alt + F
→ mot suivant
```

Ces raccourcis deviennent particulièrement pratiques lorsque le prompt est long.

### Naviguer dans l’historique

Les touches :

```text
Haut
Bas
```

permettent de parcourir les prompts précédents.

Pour une recherche plus précise :

```text
Ctrl + R
```

ouvre la recherche inversée.

On peut alors rechercher un ancien prompt à partir d’un fragment.

Par exemple :

```text
authentification
```

Claude Code peut rechercher les prompts correspondants dans l’historique.

Dans cette vue, `Ctrl + R` peut passer à une autre correspondance.

Selon le contexte :

```text
Ctrl + S
```

peut changer la portée de recherche entre :

```text
session
projet
tous les projets
```

Les raccourcis étant contextuels, il faut distinguer :

```text
Ctrl + S dans le prompt
→ mettre le prompt de côté

Ctrl + S dans la recherche
→ modifier la portée
```

C’est un exemple typique montrant pourquoi le **contexte du raccourci** doit toujours être mémorisé.

### Interrompre Claude

L’un des raccourcis les plus importants est :

```text
Esc
```

`Esc` permet d’interrompre :

* une réponse ;
* un appel d’outil ;
* une trajectoire en cours.

Par exemple :

```text
Claude part dans une mauvaise direction
                ↓
               Esc
                ↓
reprendre le contrôle
```

Cette capacité est importante dans un outil agentique.

Il vaut souvent mieux interrompre rapidement une mauvaise trajectoire que laisser Claude accumuler des actions inutiles.

Une deuxième pression :

```text
Esc puis Esc
```

a un comportement différent selon le contexte.

Elle peut notamment ouvrir le mécanisme de rembobinage lorsque l’invite est vide.

Dans d’autres situations, elle peut effacer le brouillon tout en le conservant dans l’historique.

Autre raccourci :

```text
Ctrl + C
```

Il permet d’interrompre une opération en cours.

Lorsqu’aucune opération ne tourne, son comportement peut servir à nettoyer l’entrée puis préparer la sortie.

Pour quitter directement la session :

```text
Ctrl + D
```

Sur les systèmes Unix :

```text
Ctrl + Z
```

suspend le processus.

Il faut donc distinguer :

```text
Esc
→ interrompre Claude

Ctrl + C
→ interrompre une opération

Ctrl + D
→ quitter

Ctrl + Z
→ suspendre le processus Unix
```

### Mettre une tâche en arrière-plan

Claude Code peut exécuter certaines commandes ou agents pendant que l’utilisateur continue à travailler.

Pour mettre une tâche en arrière-plan :

```text
Ctrl + B
```

Cela peut concerner :

* une commande Bash ;
* un agent.

Avec `tmux`, `Ctrl + B` peut entrer en conflit avec le préfixe du multiplexeur.

Une variante est alors :

```text
Ctrl + X
puis
Ctrl + B
```

Le principe est :

```text
Tâche en cours
     ↓
Ctrl + B
     ↓
arrière-plan
     ↓
session principale disponible
```

Pour afficher ou masquer la liste des tâches :

```text
Ctrl + T
```

Pour gérer plus précisément les tâches :

```text
/tasks
```

Il faut distinguer :

```text
Ctrl + T
→ afficher rapidement la liste

/tasks
→ ouvrir la gestion des tâches
```

Une autre combinaison permet, avec confirmation, d’arrêter les agents en arrière-plan :

```text
Ctrl + X
puis
Ctrl + K
```

### Inspecter la transcription

Dans le CLI :

```text
Ctrl + O
```

ouvre ou ferme la visionneuse de transcription.

Cette vue permet d’observer plus en détail :

* les outils utilisés ;
* l’exécution ;
* certains échanges internes visibles ;
* les différentes étapes de la session.

On peut donc l’utiliser pour répondre à une question comme :

```text
Qu'est-ce que Claude vient réellement de faire ?
```

Dans la visionneuse, plusieurs touches ont leur propre signification.

Par exemple :

```text
?
→ afficher l'aide

Ctrl + E
→ basculer l'affichage complet

q
Ctrl + C
Esc
→ quitter
```

Selon la vue :

```text
{
}
```

permettent de naviguer entre différentes invites.

Le PDF insiste également sur un point :

```text
Ctrl + O dans le CLI
        ≠
Ctrl + O dans Desktop
```

Dans Desktop, la combinaison contrôle plutôt les modes d’affichage de la transcription.

### Inspecter les modifications avec /diff

La commande :

```text
/diff
```

ouvre une visionneuse interactive des différences.

Elle possède elle-même ses propres raccourcis.

Par exemple :

```text
Esc
→ fermer /diff

Gauche / Droite
→ changer de source de diff
```

Pour naviguer :

```text
Haut / Bas
K / J
```

Pour afficher le détail :

```text
Entrée
```

Pour faire défiler :

```text
PageUp
PageDown
Espace
Shift + Espace
```

Pour aller au début ou à la fin :

```text
G
Home
Shift + G
End
```

Il ne faut donc pas considérer `/diff` comme une simple sortie texte.

C’est une véritable **surface interactive avec ses propres raccourcis**.

### Changer de mode de permission

Claude Code permet de parcourir les modes de permission avec :

```text
Shift + Tab
```

Cela permet de modifier rapidement le comportement de la session vis-à-vis des autorisations.

Ce raccourci peut également apparaître dans certains dialogues de permission.

### Changer de modèle

Le sélecteur de modèle peut être ouvert avec :

```text
Alt + P
```

ou sur macOS :

```text
Option + P
```

Cela permet d’ouvrir le sélecteur sans perdre le prompt courant.

Dans le sélecteur, certaines touches prennent alors un nouveau sens.

Par exemple :

```text
Gauche
→ réduire l'effort

Droite
→ augmenter l'effort
```

lorsque le modèle prend cette fonctionnalité en charge.

La touche :

```text
s
```

permet, selon la vue, d’appliquer le modèle sélectionné uniquement à la session courante.

Encore une fois :

```text
Gauche / Droite dans le sélecteur de modèle
        ≠
Gauche / Droite partout dans Claude Code
```

### Mode rapide et réflexion étendue

Claude Code expose également des raccourcis de comportement.

```text
Alt + O
ou Option + O
```

permet de basculer le mode rapide.

Et :

```text
Alt + T
ou Option + T
```

permet de basculer la réflexion étendue.

Ces raccourcis doivent eux aussi être appris comme des comportements propres à la session Claude Code, et non comme des raccourcis universels du terminal.

### Autocomplétion

Lorsque Claude Code propose une suggestion :

```text
Tab
→ accepter

Esc
→ fermer

Haut / Bas
→ parcourir les propositions
```

Ce schéma apparaît fréquemment dans les interfaces terminal.

### Dialogues de confirmation

Lorsqu’une permission ou une confirmation est demandée :

```text
Y
ou
Entrée
→ confirmer
```

Pour refuser :

```text
N
ou
Esc
```

Pour choisir une autre option :

```text
Haut
Bas
```

Pour changer de champ :

```text
Tab
```

Et dans certains dialogues :

```text
Ctrl + E
```

permet d’afficher ou masquer l’explication liée à la permission.

### Sélecteurs généraux

De nombreux sélecteurs suivent une convention proche de Vim ou des interfaces terminal classiques.

Pour descendre :

```text
Bas
J
Ctrl + N
```

Pour monter :

```text
Haut
K
Ctrl + P
```

Pour accepter :

```text
Entrée
```

Pour annuler :

```text
Esc
```

Il est donc inutile d’apprendre chaque sélecteur comme une interface entièrement nouvelle.

On retrouve souvent les mêmes conventions.

### Ne pas mélanger CLI et Desktop

L’application Desktop possède ses propres raccourcis.

Par exemple, selon la plateforme :

```text
Cmd + /
ou
Ctrl + /
→ afficher les raccourcis Desktop
```

Pour créer une nouvelle session :

```text
Cmd + N
ou
Ctrl + N
```

Pour parcourir les sessions :

```text
Ctrl + Tab
Ctrl + Shift + Tab
```

Pour ouvrir le terminal intégré :

```text
Ctrl + `
```

Pour ouvrir le chat latéral :

```text
Cmd + ;
ou
Ctrl + ;
```

Ces raccourcis ne doivent pas être mélangés avec ceux du CLI.

On peut résumer :

```text
CLI
→ pilote directement l'invite terminal

Desktop
→ pilote les panneaux, sessions et vues graphiques
```

### Les raccourcis à connaître en priorité

Il n’est pas nécessaire de mémoriser immédiatement toutes les combinaisons.

Une première liste utile est :

```text
Esc
→ interrompre Claude

Esc puis Esc
→ rembobiner / gérer le brouillon

Ctrl + D
→ quitter

Ctrl + L
→ redessiner l'écran

Ctrl + G
→ éditeur externe

Ctrl + S
→ mettre le prompt de côté

Ctrl + R
→ historique

Ctrl + O
→ transcription dans le CLI

Ctrl + B
→ tâche en arrière-plan

Ctrl + T
→ afficher les tâches

/tasks
→ gérer les tâches

Shift + Tab
→ changer de mode de permission

Alt / Option + P
→ modèle

Alt / Option + O
→ mode rapide

Alt / Option + T
→ réflexion étendue

!
→ commande shell directe
```

Le document mentionne aussi :

```text
/btw
```

pour poser une question secondaire en dehors de la trajectoire principale.

Dans la surimpression `/btw`, certains raccourcis ont encore une signification propre.

Par exemple :

```text
Espace / Entrée / Esc
→ fermer la réponse

Haut / Bas
→ faire défiler

c
→ copier la réponse

f
→ créer une nouvelle session à partir de l'échange

x
→ effacer les anciens échanges /btw affichés
```

Cela illustre parfaitement le principe général de cette leçon :

```text
Une touche seule
n'est pas une connaissance suffisante.

Il faut retenir :

touche
+
surface
+
contexte
+
action
```

L’objectif n’est donc pas de mémoriser des dizaines de raccourcis dès maintenant.

Il faut d’abord maîtriser ceux qui permettent de :

```text
reprendre le contrôle
        ↓
écrire efficacement
        ↓
naviguer
        ↓
inspecter
        ↓
gérer les tâches
```

Puis apprendre les raccourcis spécifiques aux différentes vues lorsqu’elles deviennent réellement utiles.

## Points clés

* Les raccourcis Claude Code doivent toujours être associés à leur contexte.
* Le terminal et le système d’exploitation peuvent modifier leur fonctionnement.
* `/terminal-setup` peut aider à configurer certaines touches.
* `Entrée` envoie le prompt.
* `Shift + Enter` permet généralement d’insérer une nouvelle ligne.
* `Ctrl + J` est une alternative portable pour insérer une nouvelle ligne.
* `Ctrl + G` ouvre le prompt dans un éditeur externe.
* `Ctrl + S` permet de mettre un prompt de côté.
* `Ctrl + R` ouvre la recherche dans l’historique.
* `!` exécute directement une commande shell.
* Les commandes `!` agissent dans l’environnement réel.
* `Esc` est le raccourci principal pour interrompre Claude.
* `Esc` puis `Esc` permet notamment d’accéder au rembobinage selon le contexte.
* `Ctrl + C` interrompt une opération.
* `Ctrl + D` quitte la session.
* `Ctrl + B` met une commande ou un agent en arrière-plan.
* `Ctrl + X` puis `Ctrl + B` est utile avec tmux.
* `Ctrl + T` affiche ou masque les tâches.
* `/tasks` permet de gérer les tâches en arrière-plan.
* `Ctrl + O` ouvre la transcription détaillée dans le CLI.
* `/diff` ouvre une visionneuse interactive des modifications.
* Les raccourcis de `/diff` ne doivent pas être généralisés au chat principal.
* `Shift + Tab` permet de changer de mode de permission.
* `Alt + P` ou `Option + P` ouvre le sélecteur de modèle.
* `Alt + O` ou `Option + O` bascule le mode rapide.
* `Alt + T` ou `Option + T` bascule la réflexion étendue.
* Les dialogues utilisent généralement `Entrée/Y` pour confirmer et `Esc/N` pour refuser.
* Les sélecteurs utilisent souvent `Haut/Bas`, `J/K` ou `Ctrl + N/P`.
* Desktop possède ses propres raccourcis.
* Les raccourcis CLI et Desktop ne doivent pas être mélangés.
* Il vaut mieux mémoriser d’abord quelques raccourcis essentiels plutôt qu’une liste complète.
* Les raccourcis les plus importants sont ceux permettant d’interrompre, naviguer, inspecter et gérer les tâches.
