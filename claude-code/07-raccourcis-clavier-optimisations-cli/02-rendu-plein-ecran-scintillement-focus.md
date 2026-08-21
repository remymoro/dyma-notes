---
title: "Activer le rendu plein écran, réduire le scintillement et utiliser /focus"
description: "Comprendre les modes d’affichage de Claude Code, activer le rendu plein écran et utiliser /focus pour réduire le bruit visuel."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - tui
  - focus
categories:
  - "Chapitre 7"
cours: Claude Code
chapitre: 07-raccourcis-clavier-optimisations-cli
leçon: 02-rendu-plein-ecran-scintillement-focus
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                     | Notes détaillées                                                                                                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Qu’est-ce que le rendu plein écran ?                         | Un mode dans lequel Claude Code utilise une interface terminal dédiée avec un tampon d’écran alternatif, une entrée fixe et un rendu plus stable. |
| Le plein écran signifie-t-il maximiser la fenêtre ?          | Non. Il concerne la manière dont Claude Code dessine son interface dans le terminal.                                                              |
| À quoi sert `/tui fullscreen` ?                              | À activer le rendu plein écran dans la session.                                                                                                   |
| À quoi sert `/tui default` ?                                 | À revenir au rendu classique du terminal.                                                                                                         |
| À quoi sert `/tui` ?                                         | À vérifier le moteur de rendu actuellement utilisé.                                                                                               |
| Pourquoi utiliser le rendu plein écran ?                     | Pour réduire le scintillement, stabiliser les longues sessions, conserver l’entrée fixe et améliorer certaines interactions souris.               |
| Le rendu plein écran change-t-il le modèle ?                 | Non. Il modifie uniquement l’affichage.                                                                                                           |
| Le rendu plein écran change-t-il les permissions ?           | Non. Les permissions restent identiques.                                                                                                          |
| Quelle différence entre rendu classique et plein écran ?     | Le classique utilise principalement le scrollback natif du terminal ; le plein écran utilise un tampon alternatif géré par Claude Code.           |
| Qu’est-ce qu’un tampon d’écran alternatif ?                  | Une surface terminal séparée, utilisée notamment par des applications comme `vim`, `less` ou `htop`.                                              |
| Comment démarrer avec le rendu sans scintillement ?          | Avec la variable `CLAUDE_CODE_NO_FLICKER=1`.                                                                                                      |
| Comment forcer le rendu classique au démarrage ?             | Avec `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1`.                                                                                                    |
| À quoi sert `/scroll-speed` ?                                | À ajuster la vitesse de défilement lorsque la commande est disponible.                                                                            |
| Que permet la souris en plein écran ?                        | Placer le curseur, sélectionner des suggestions, développer des sorties, ouvrir certains liens ou fichiers et faire défiler la conversation.      |
| Pourquoi la capture de souris peut-elle gêner ?              | Parce qu’elle peut entrer en conflit avec la sélection native du terminal ou de tmux.                                                             |
| À quoi sert `/focus` ?                                       | À réduire le détail visuel des étapes intermédiaires pour mettre davantage en avant la demande et la réponse finale.                              |
| `/focus` change-t-il le travail réellement effectué ?        | Non. Claude peut toujours utiliser les mêmes outils et effectuer les mêmes actions autorisées.                                                    |
| `/focus` améliore-t-il la sécurité ?                         | Non. C’est un mode d’affichage, pas un mécanisme de sécurité.                                                                                     |
| Quand utiliser `/focus` ?                                    | Pour les démonstrations, revues finales ou lorsqu’on souhaite surtout lire le résultat.                                                           |
| Quand désactiver `/focus` ?                                  | Lorsqu’on souhaite inspecter précisément les appels d’outils et les étapes intermédiaires.                                                        |
| Comment inspecter une session après avoir utilisé `/focus` ? | Avec la visionneuse de transcription, notamment `Ctrl + O`.                                                                                       |
| Quels sont les trois états à comparer ?                      | Rendu classique, rendu plein écran, rendu plein écran avec Focus.                                                                                 |
| Où enregistrer ces préférences ?                             | Généralement dans les settings personnels, car elles dépendent surtout du terminal et des préférences de l’utilisateur.                           |

## Synthèse

Le rendu plein écran de Claude Code change la façon dont l’interface est dessinée dans le terminal afin de rendre les sessions longues plus stables et plus confortables. `/focus` va plus loin en réduisant les informations intermédiaires affichées, mais ces deux fonctions ne changent ni le raisonnement, ni les permissions, ni les capacités réelles de Claude.

## Glossaire

* TUI : Terminal User Interface, interface utilisateur fonctionnant directement dans le terminal.
* `/tui` : commande permettant d’inspecter ou modifier le moteur de rendu utilisé par Claude Code.
* `/tui fullscreen` : commande activant le rendu plein écran.
* `/tui default` : commande rétablissant le rendu classique.
* rendu classique : affichage utilisant principalement le scrollback natif du terminal.
* rendu plein écran : affichage dans lequel Claude Code contrôle une surface terminal dédiée.
* tampon d’écran alternatif : espace d’affichage temporaire séparé du scrollback habituel du terminal.
* scintillement : effet visuel provoqué par des redessinages fréquents du terminal.
* scrollback : historique natif des lignes affichées dans un terminal.
* `/focus` : mode réduisant les détails intermédiaires visibles pendant le travail.
* capture de souris : gestion des événements souris directement par l’application terminal.
* `/scroll-speed` : commande permettant selon la version de régler la vitesse de défilement.
* `CLAUDE_CODE_NO_FLICKER` : variable permettant d’activer un rendu visant à réduire le scintillement.
* `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN` : variable permettant de désactiver l’utilisation du tampon d’écran alternatif.
* `CLAUDE_CODE_SCROLL_SPEED` : variable permettant d’ajuster la vitesse du défilement.
* `Ctrl + O` : raccourci permettant d’ouvrir la transcription détaillée dans le CLI.
* settings personnels : configuration propre à l’utilisateur, généralement placée dans `~/.claude/settings.json`.

## Questions d'auto-évaluation

1. Que signifie réellement « plein écran » dans Claude Code ?
2. Pourquoi ne faut-il pas confondre ce mode avec la maximisation de la fenêtre du terminal ?
3. Quelle commande active le rendu plein écran ?
4. Quelle commande permet de revenir au rendu classique ?
5. À quoi sert la commande `/tui` seule ?
6. Quelle différence existe-t-il entre le scrollback classique et le tampon d’écran alternatif ?
7. Pourquoi le rendu plein écran peut-il être plus confortable pendant une session longue ?
8. Le rendu plein écran modifie-t-il le modèle Claude utilisé ?
9. Modifie-t-il les permissions ?
10. Modifie-t-il le contexte ?
11. À quoi sert `CLAUDE_CODE_NO_FLICKER=1` ?
12. À quoi sert `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` ?
13. Dans quels cas vaut-il mieux conserver `/tui default` ?
14. Comment modifier la vitesse de défilement ?
15. Quelles interactions deviennent possibles avec la souris en mode plein écran ?
16. Pourquoi la capture de souris peut-elle entrer en conflit avec tmux ou la sélection du terminal ?
17. À quoi sert `/focus` ?
18. Que masque principalement `/focus` ?
19. `/focus` empêche-t-il Claude de modifier des fichiers ?
20. Pourquoi `/focus` ne doit-il pas être considéré comme un mécanisme de sécurité ?
21. Quand le mode Focus est-il particulièrement utile ?
22. Quand vaut-il mieux le désactiver ?
23. Comment retrouver les détails d’une session après avoir utilisé `/focus` ?
24. Quels sont les trois modes d’affichage qu’il est utile de comparer ?
25. Pourquoi les réglages TUI et Focus doivent-ils généralement rester personnels ?

# Activer le rendu plein écran, réduire le scintillement et utiliser /focus

**Durée : 18 minutes**

## Notes

Claude Code peut afficher son interface terminal de plusieurs façons.

Le mode par défaut utilise principalement le comportement classique du terminal.

Une session peut cependant devenir moins confortable lorsque :

* elle devient longue ;
* beaucoup de sorties d’outils sont affichées ;
* l’écran scintille ;
* le défilement saute ;
* le terminal intégré d’un IDE redessine difficilement l’interface.

Claude Code propose alors un **rendu plein écran**.

Il faut immédiatement clarifier une idée :

```text
Plein écran Claude Code
        ≠
maximiser la fenêtre
```

Le terme décrit la manière dont Claude Code contrôle l’affichage du terminal.

On peut représenter les deux modes ainsi :

```text
Rendu classique
      ↓
scrollback du terminal

Rendu plein écran
      ↓
tampon d'écran alternatif
      ↓
interface contrôlée par Claude Code
```

La commande principale est :

```text
/tui fullscreen
```

Pour revenir au comportement classique :

```text
/tui default
```

Et pour inspecter le mode actuellement utilisé :

```text
/tui
```

Il n’existe donc pas, dans le cadre de cette leçon, de commande à retenir sous la forme :

```text
/fullscreen
```

Le bon mécanisme est :

```text
/tui fullscreen
```

### Le rendu classique

Dans le rendu classique, la conversation s’intègre au comportement habituel du terminal.

On retrouve notamment :

```text
conversation
     ↓
scrollback natif
     ↓
historique du terminal
```

Ce mode est particulièrement adapté si l’on utilise beaucoup :

* la recherche native du terminal ;
* `Cmd + F` ou l’équivalent ;
* la sélection native ;
* les fonctions de copie de tmux ;
* le scrollback historique.

Il reste simple et compatible avec les habitudes classiques du terminal.

### Le rendu plein écran

En plein écran, Claude Code utilise un **tampon d’écran alternatif**.

C’est un principe similaire à ce qu’utilisent certaines applications terminal comme :

```text
vim
htop
less
```

Au lieu d’ajouter constamment des lignes dans le scrollback classique, l’application contrôle directement la surface visible.

On peut représenter cela ainsi :

```text
Terminal
   ↓
┌────────────────────────────┐
│ Conversation               │
│                            │
│ sorties                    │
│ résultats                  │
│                            │
├────────────────────────────┤
│ Invite toujours visible    │
└────────────────────────────┘
```

L’entrée reste ainsi plus stable en bas de l’écran.

Le plein écran cherche notamment à apporter :

```text
moins de scintillement
        +
défilement plus stable
        +
entrée fixe
        +
meilleure gestion souris
        +
sessions longues plus confortables
```

Il est particulièrement intéressant dans :

* les terminaux intégrés d’IDE ;
* tmux ;
* iTerm2 ;
* les conversations longues ;
* les sessions produisant beaucoup de sorties.

Mais il est essentiel de comprendre que :

```text
/tui fullscreen
       ↓
change l'affichage
```

et non :

```text
modèle
permissions
raisonnement
outils
```

Le travail de Claude reste le même.

### Activer le plein écran

Dans une session :

```text
/tui fullscreen
```

Claude Code peut alors réinitialiser l’affichage de l’interface tout en conservant la conversation.

Le contexte n’est pas nécessairement perdu.

On peut ensuite vérifier :

```text
/tui
```

Puis effectuer une demande simple.

Par exemple :

```text
Ne modifie aucun fichier.

Résume :
1. le rôle du projet ;
2. les fichiers principaux ;
3. la commande de test ;
4. la prochaine vérification utile.
```

Le but n’est pas d’évaluer la qualité de Claude.

Il faut surtout observer :

```text
l'entrée reste-t-elle fixe ?
le scintillement diminue-t-il ?
le défilement est-il confortable ?
```

### Activer le rendu dès le lancement

Le rendu visant à réduire le scintillement peut également être activé avant le démarrage.

Par exemple :

```bash
CLAUDE_CODE_NO_FLICKER=1 claude
```

Pour plusieurs lancements :

```bash
export CLAUDE_CODE_NO_FLICKER=1
claude
```

Cette configuration ne doit pas nécessairement être rendue permanente immédiatement.

La meilleure approche est :

```text
Tester
   ↓
observer dans son terminal réel
   ↓
comparer
   ↓
décider
```

Le comportement peut varier selon :

* le terminal ;
* tmux ;
* SSH ;
* l’IDE ;
* le système d’exploitation.

### Revenir au rendu classique

Si le plein écran est inconfortable :

```text
/tui default
```

Il est aussi possible de forcer la désactivation du tampon alternatif au démarrage :

```bash
CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1 claude
```

Cela peut être intéressant lorsque :

* le scrollback natif est important ;
* la recherche native est beaucoup utilisée ;
* tmux est au centre du workflow ;
* la sélection de texte pose problème ;
* le terminal gère mal le tampon alternatif.

On peut résumer :

```text
/tui fullscreen
→ stabilité / interface contrôlée

/tui default
→ comportement terminal traditionnel
```

Il n’existe pas une configuration universellement meilleure.

Le choix dépend du terminal et du workflow.

### Régler la vitesse de défilement

Le plein écran peut également modifier la sensation du défilement à la molette.

Il est possible de régler sa vitesse avec :

```bash
export CLAUDE_CODE_SCROLL_SPEED=3
claude
```

Selon la version, une commande interactive peut également être disponible :

```text
/scroll-speed
```

Le réglage doit rester une préférence personnelle.

Une vitesse adaptée à un terminal peut être désagréable sur un autre.

On peut également désactiver l’accélération de la molette dans les settings :

```json
{
  "wheelScrollAccelerationEnabled": false
}
```

Le défilement devient alors plus constant.

### Utiliser la souris

Le rendu plein écran améliore également l’intégration de la souris.

Elle peut permettre de :

1. cliquer dans l’invite ;
2. placer le curseur ;
3. choisir certaines suggestions ;
4. développer une sortie d’outil ;
5. ouvrir une URL ;
6. ouvrir un chemin de fichier ;
7. sélectionner du texte ;
8. faire défiler la conversation.

On peut donc avoir :

```text
Souris
│
├── navigation
├── sélection
├── ouverture de liens
├── expansion des sorties
└── défilement
```

Mais cette capture de souris peut entrer en conflit avec les mécanismes natifs du terminal.

Par exemple, un utilisateur de tmux peut préférer conserver son propre système de sélection.

Selon le terminal, une touche permet de temporairement revenir à la sélection native.

Exemples mentionnés dans la leçon :

```text
Terminal.app
→ Fn

iTerm2
→ Option

VS Code / Cursor / Devin Desktop
→ Shift

beaucoup d'autres terminaux
→ Shift
```

Le comportement dépend donc encore une fois de l’environnement.

Il est également possible de désactiver la capture souris tout en conservant un rendu sans scintillement.

Le compromis devient alors :

```text
capture souris active
→ interactions Claude Code enrichies

capture souris désactivée
→ sélection native du terminal
```

### Quand utiliser le rendu plein écran

Le plein écran devient intéressant lorsque :

```text
écran qui scintille
        ↓
défilement instable
        ↓
session longue
        ↓
beaucoup de sorties
        ↓
besoin d'une entrée fixe
```

Il est aussi pertinent si l’on souhaite utiliser davantage la souris.

On peut retenir :

```text
Utiliser /tui fullscreen si :

- session longue ;
- sorties nombreuses ;
- scintillement ;
- défilement qui saute ;
- terminal intégré d'IDE ;
- besoin d'une entrée fixe ;
- utilisation de la souris.
```

À l’inverse :

```text
Garder /tui default si :

- besoin important du scrollback natif ;
- utilisation fréquente de Cmd+F ;
- mode copie tmux important ;
- capture souris gênante ;
- mauvaise compatibilité du terminal ;
- session courte et simple.
```

### Utiliser /focus

Le deuxième mécanisme important de cette leçon est :

```text
/focus
```

`/focus` fonctionne avec le rendu plein écran.

Son objectif est différent.

`/tui fullscreen` agit principalement sur **le moteur d’affichage**.

`/focus` agit sur **la quantité d’informations affichées**.

On peut donc distinguer :

```text
/tui fullscreen
→ comment l'interface est dessinée

/focus
→ combien de détails sont montrés
```

Le mode Focus réduit le bruit visuel.

Au lieu d’afficher tout le travail intermédiaire en détail, il met davantage en avant :

```text
dernière demande
      ↓
résumé des outils
      ↓
réponse finale
```

Cela peut rendre une session beaucoup plus lisible.

### Ce que /focus ne change pas

Il faut cependant éviter une confusion importante.

`/focus` ne change pas :

* le modèle ;
* les permissions ;
* le contexte ;
* les outils disponibles ;
* la capacité de Claude à modifier des fichiers ;
* la nécessité de vérifier le résultat.

On peut représenter le fonctionnement ainsi :

```text
Claude travaille
│
├── lecture fichiers
├── commandes
├── outils
├── modifications autorisées
└── vérifications

        ↓

/focus

        ↓

affiche moins de détails
```

Le travail existe toujours.

Seule sa présentation change.

Cela signifie également que :

```text
/focus
≠
mode sécurité
```

Une interface plus calme n’est pas une preuve qu’il se passe moins de choses.

Il faut continuer à :

* vérifier les permissions ;
* inspecter les modifications ;
* lire le diff ;
* vérifier les tests.

### Activer et désactiver Focus

Pour activer :

```text
/focus
```

La commande fonctionne comme un interrupteur.

Pour revenir au comportement précédent :

```text
/focus
```

On peut donc avoir :

```text
Focus désactivé
      ↓
/focus
      ↓
Focus activé
      ↓
/focus
      ↓
Focus désactivé
```

Le réglage peut persister.

Si une session affiche soudainement moins de détails que prévu, il faut donc vérifier si Focus est actif.

### Quand utiliser Focus

Le mode Focus est intéressant lorsque l’on veut surtout :

* lire le résultat final ;
* montrer Claude Code à quelqu’un ;
* faire une démonstration ;
* effectuer une revue finale ;
* réduire le bruit d’une longue conversation.

Par exemple :

```text
Ne modifie aucun fichier.

Réponds uniquement avec :

1. rôle du projet ;
2. fichiers principaux ;
3. commande de test ;
4. amélioration possible.
```

Dans ce cas, il n’est pas nécessaire de regarder en détail chaque outil utilisé.

Focus permet de garder l’attention sur le résultat.

À l’inverse, il faut le désactiver lorsqu’on souhaite apprendre ou déboguer le comportement agentique.

```text
Je veux comprendre comment Claude travaille
→ Focus désactivé

Je veux principalement le résultat
→ Focus activé
```

### Inspecter après Focus

Utiliser Focus ne signifie pas que les informations intermédiaires sont nécessairement inutiles pour toujours.

Après une session, on peut vouloir comprendre ce qui s’est passé.

Dans le CLI :

```text
Ctrl + O
```

permet d’ouvrir la visionneuse de transcription.

Le workflow peut donc être :

```text
/focus
      ↓
travailler avec peu de bruit
      ↓
réponse finale
      ↓
Ctrl + O
      ↓
inspecter les détails si nécessaire
```

Focus permet donc de séparer :

```text
confort pendant l'exécution
        ↓
inspection après l'exécution
```

### Comparer les trois états

La meilleure manière de comprendre cette fonctionnalité est de comparer trois états.

#### État 1

```text
/tui default
```

Puis :

```text
Ne modifie aucun fichier.
Résume le projet en trois points.
```

On observe le rendu classique.

#### État 2

```text
/tui fullscreen
```

Puis la même demande.

On observe la différence de comportement de l’interface.

#### État 3

```text
/focus
```

Puis à nouveau une demande similaire.

On compare alors :

```text
Rendu classique
        ↓
simple / scrollback natif

Rendu plein écran
        ↓
plus stable / entrée fixe

Plein écran + Focus
        ↓
plus stable + moins de bruit visuel
```

Cette comparaison permet de choisir selon son besoin réel.

### Configurer le mode dans les settings

Si le plein écran convient, il peut être enregistré dans les préférences personnelles.

Par exemple :

```json
{
  "tui": "fullscreen"
}
```

Pour conserver le classique :

```json
{
  "tui": "default"
}
```

Le fichier personnel peut être :

```text
~/.claude/settings.json
```

Ce type de préférence dépend fortement :

* du terminal ;
* de la souris ;
* du défilement ;
* des habitudes de travail.

Il doit donc généralement rester **personnel**.

Il n’est pas nécessaire de l’imposer à tout un dépôt.

### Configurer Focus

Le mode Focus peut lui aussi être configuré.

```json
{
  "viewMode": "focus"
}
```

Pour revenir à l’affichage standard :

```json
{
  "viewMode": "default"
}
```

Focus est intéressant comme valeur par défaut pour une personne qui :

* fait souvent des démonstrations ;
* préfère les réponses finales ;
* ne souhaite pas voir toutes les opérations intermédiaires.

Il est moins adapté pour quelqu’un qui veut constamment observer :

* les outils ;
* les commandes ;
* les étapes agentiques ;
* les détails d’exécution.

### Préparer une session longue

Avant une session importante, on peut donc suivre une séquence simple :

```bash
cd convertisseur-temperature
git status
claude
```

Puis :

```text
/tui fullscreen
```

Et éventuellement :

```text
/focus
```

On obtient alors :

```text
Projet vérifié
      ↓
Claude Code
      ↓
rendu plein écran
      ↓
optionnel : Focus
      ↓
session longue plus confortable
```

Le principe général est finalement de distinguer **travail et affichage**.

```text
Claude travaille
        ↓
outils
raisonnement
permissions
actions

        ≠

Interface utilisée pour observer ce travail
```

`/tui fullscreen` et `/focus` appartiennent à la seconde catégorie.

Ils modifient **l’expérience visuelle de l’utilisateur**, pas les capacités fondamentales de l’agent.

## Points clés

* Le rendu plein écran ne signifie pas maximiser la fenêtre du terminal.
* `/tui fullscreen` active le rendu plein écran.
* `/tui default` restaure le rendu classique.
* `/tui` permet de vérifier le moteur de rendu actif.
* Le rendu classique utilise principalement le scrollback natif.
* Le plein écran utilise un tampon d’écran alternatif.
* Le tampon alternatif est comparable à celui utilisé par `vim`, `htop` ou `less`.
* Le plein écran peut réduire le scintillement.
* Il peut rendre le défilement plus stable.
* L’entrée reste fixe en bas de l’interface.
* Le rendu plein écran peut être particulièrement utile pendant les longues sessions.
* Il ne change pas le modèle.
* Il ne change pas les permissions.
* Il ne change pas le raisonnement de Claude.
* `CLAUDE_CODE_NO_FLICKER=1` permet de tester le rendu sans scintillement au lancement.
* `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` permet de désactiver le tampon alternatif.
* `CLAUDE_CODE_SCROLL_SPEED` permet d’ajuster le défilement.
* `/scroll-speed` peut permettre un réglage interactif selon la version.
* Le plein écran apporte une meilleure gestion de la souris.
* La capture de souris peut entrer en conflit avec la sélection native du terminal ou de tmux.
* Le choix entre rendu classique et plein écran dépend du terminal et du workflow.
* `/focus` réduit les détails intermédiaires visibles.
* `/focus` ne réduit pas les capacités de Claude.
* `/focus` ne change ni les outils ni les permissions.
* `/focus` n’est pas un mécanisme de sécurité.
* Focus est utile pour les démonstrations et les revues finales.
* Focus est moins adapté lorsqu’on souhaite comprendre précisément l’exécution.
* `Ctrl + O` permet d’inspecter la transcription après une session Focus.
* Les trois états utiles à comparer sont classique, plein écran et plein écran + Focus.
* Les préférences TUI doivent généralement rester dans les settings personnels.
* `"tui": "fullscreen"` permet de choisir le plein écran par défaut.
* `"viewMode": "focus"` permet d’utiliser Focus par défaut.
* Le moteur d’affichage et le travail de l’agent sont deux choses différentes.
