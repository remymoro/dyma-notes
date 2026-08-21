---
title: "Comprendre la recherche en mode TUI"
description: "Apprendre à rechercher, parcourir, relire et exporter une conversation Claude Code depuis le rendu plein écran."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - tui
  - transcription
  - recherche
categories:
  - "Chapitre 7"
cours: Claude Code
chapitre: 07-raccourcis-clavier-optimisations-cli
leçon: 03-recherche-transcription-tui
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                    | Notes détaillées                                                                                                                             |
| ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Pourquoi la recherche change-t-elle en mode TUI ?           | En rendu plein écran, la conversation n’est pas forcément stockée comme un simple historique de lignes dans le scrollback natif du terminal. |
| Quelle recherche utiliser en rendu classique ?              | La recherche native du terminal, par exemple `Cmd+F`, la recherche intégrée ou le mode copie de tmux.                                        |
| Quelle recherche utiliser en rendu plein écran ?            | Le mode transcription de Claude Code.                                                                                                        |
| Comment ouvrir le mode transcription ?                      | Avec `Ctrl+O`.                                                                                                                               |
| Comment afficher l’aide des raccourcis ?                    | Avec `?`.                                                                                                                                    |
| Comment lancer une recherche ?                              | Avec `/`.                                                                                                                                    |
| Comment aller à l’occurrence suivante ?                     | Avec `n`.                                                                                                                                    |
| Comment revenir à l’occurrence précédente ?                 | Avec `N`.                                                                                                                                    |
| Comment défiler ligne par ligne ?                           | Avec `j`, `k`, `↓` et `↑`.                                                                                                                   |
| Comment défiler par demi-page ?                             | `Ctrl+D` descend, `Ctrl+U` remonte.                                                                                                          |
| Comment défiler par page entière ?                          | `Espace` descend, `b` remonte.                                                                                                               |
| Comment aller au début ou à la fin ?                        | `g` va au début, `G` à la fin.                                                                                                               |
| Comment naviguer entre les prompts utilisateur ?            | Avec `↑` et `↓` selon le contexte, ou `{` et `}` lorsque ces raccourcis sont supportés.                                                      |
| Comment remettre la conversation dans le scrollback natif ? | Ouvrir le mode transcription avec `Ctrl+O`, puis utiliser `[`.                                                                               |
| Pourquoi exporter vers le scrollback ?                      | Pour utiliser les outils habituels du terminal : recherche native, sélection, copie, `Cmd+F` ou mode copie de tmux.                          |
| Comment ouvrir la conversation dans un éditeur ?            | Avec `Ctrl+O`, puis `v`.                                                                                                                     |
| Quel éditeur est utilisé ?                                  | Celui configuré avec `$VISUAL` ou `$EDITOR`.                                                                                                 |
| Comment quitter le mode transcription ?                     | Avec `q`, `Échap` ou `Ctrl+C`.                                                                                                               |
| Comment défiler en plein écran sans transcription ?         | Avec `PageUp`, `PageDown`, `Ctrl+Home`, `Ctrl+End` ou la molette.                                                                            |
| Que fait `Ctrl+End` ?                                       | Il revient au dernier message et réactive le suivi automatique.                                                                              |

## Synthèse

En rendu classique, la recherche du terminal suffit souvent parce que la conversation reste dans le scrollback natif. En rendu plein écran, il faut surtout utiliser le mode transcription de Claude Code avec `Ctrl+O` pour rechercher, naviguer, exporter ou ouvrir la conversation dans un éditeur.

## Glossaire

* TUI : interface utilisateur textuelle fonctionnant en plein écran dans le terminal.
* scrollback : historique natif des lignes affichées par le terminal.
* mode transcription : vue permettant de relire et naviguer dans toute la conversation Claude Code.
* `Ctrl+O` : raccourci permettant d’ouvrir ou fermer le mode transcription.
* pager : outil de lecture de texte permettant notamment la navigation et la recherche, comme `less`.
* `/` : raccourci permettant d’ouvrir la recherche dans la transcription.
* `n` : aller à l’occurrence suivante.
* `N` : revenir à l’occurrence précédente.
* `j` : faire défiler vers le bas.
* `k` : faire défiler vers le haut.
* `Ctrl+D` : descendre d’une demi-page.
* `Ctrl+U` : remonter d’une demi-page.
* `g` : aller au début.
* `G` : aller à la fin.
* `$VISUAL` : variable d’environnement pouvant définir l’éditeur visuel utilisé.
* `$EDITOR` : variable d’environnement définissant généralement l’éditeur de texte par défaut.
* suivi automatique : comportement maintenant la vue positionnée sur les derniers messages.
* tmux : multiplexeur de terminal possédant notamment son propre système de défilement et de copie.

## Questions d'auto-évaluation

1. Quelle différence existe-t-il entre la recherche en rendu classique et en rendu plein écran ?
2. Pourquoi `Cmd+F` peut-il ne pas retrouver un texte visible dans la TUI ?
3. À quoi sert le mode transcription ?
4. Comment ouvrir le mode transcription ?
5. Comment afficher l’aide de ses raccourcis ?
6. Quel raccourci lance une recherche ?
7. Comment aller au résultat suivant ?
8. Comment revenir au résultat précédent ?
9. À quoi servent `j` et `k` ?
10. Quelle différence existe-t-il entre `Ctrl+D` et `Ctrl+U` ?
11. Comment descendre d’une page entière ?
12. Comment remonter d’une page entière ?
13. Comment aller directement au début de la transcription ?
14. Comment aller directement à la fin ?
15. Comment naviguer entre les prompts utilisateur ?
16. À quoi sert le raccourci `[` ?
17. Pourquoi peut-il être utile de remettre la conversation dans le scrollback natif ?
18. Comment ouvrir la conversation dans un éditeur externe ?
19. À quoi servent `$VISUAL` et `$EDITOR` ?
20. Comment quitter le mode transcription ?
21. Comment faire défiler la conversation sans passer par la transcription ?
22. À quoi sert `Ctrl+Home` ?
23. À quoi sert `Ctrl+End` ?
24. Que faire si les raccourcis diffèrent de ceux appris dans la leçon ?

# Comprendre la recherche en mode TUI

**Durée : 15 minutes**

## Notes

Dans le rendu classique du terminal, Claude Code utilise le **scrollback natif**.

La conversation s’accumule donc comme les autres sorties du terminal.

On peut généralement utiliser :

```text
Cmd+F
recherche du terminal
sélection à la souris
mode copie de tmux
```

Le fonctionnement est :

```text
Claude Code
    ↓
rendu classique
    ↓
scrollback du terminal
    ↓
outils de recherche du terminal
```

En rendu plein écran, le fonctionnement change.

Claude Code utilise une **TUI**, c’est-à-dire une interface textuelle plein écran.

```text
Claude Code
    ↓
rendu plein écran
    ↓
TUI
```

Dans ce mode, ce qui est affiché à l’écran ne correspond pas toujours directement à l’historique natif du terminal.

On peut donc avoir cette situation :

```text
Texte visible dans Claude Code
          ↓
Cmd+F
          ↓
aucun résultat
```

Cela ne signifie pas nécessairement que le texte n’existe plus.

Il peut simplement se trouver dans la TUI plutôt que dans le scrollback natif.

Pour travailler avec toute la conversation, Claude Code fournit le **mode transcription**.

### Ouvrir le mode transcription

Le raccourci principal est :

```text
Ctrl+O
```

Il permet de basculer vers le mode transcription.

Cette vue sert à :

* relire la conversation ;
* rechercher du texte ;
* naviguer dans une longue session ;
* retrouver un ancien prompt ;
* exporter la conversation ;
* ouvrir la conversation dans un éditeur.

Le fonctionnement général est :

```text
Longue conversation
        ↓
Ctrl+O
        ↓
Transcription
        ↓
Recherche / navigation / export
```

### Afficher l’aide

Dans le mode transcription :

```text
?
```

affiche ou masque l’aide.

Le réflexe utile est donc :

```text
Ctrl+O
   ↓
?
```

Cette aide est importante car certains raccourcis peuvent dépendre :

* de la version de Claude Code ;
* du terminal ;
* du système ;
* du mode de rendu.

Il vaut mieux consulter l’aide réelle de la session lorsqu’un comportement diffère.

### Rechercher dans la transcription

La recherche fonctionne comme dans un pager de type `less`.

Pour ouvrir la recherche :

```text
/
```

On saisit ensuite le terme recherché.

Par exemple :

```text
/conversion
```

Pour aller à l’occurrence suivante :

```text
n
```

Pour revenir à la précédente :

```text
N
```

On obtient :

```text
Ctrl+O
   ↓
/
   ↓
terme recherché
   ↓
n
   ↓
occurrence suivante
```

et :

```text
N
→ occurrence précédente
```

Cette recherche est particulièrement utile lorsque la recherche native du terminal ne retrouve pas un passage pourtant visible dans la session.

### Faire défiler ligne par ligne

Pour descendre :

```text
j
```

ou :

```text
↓
```

Pour remonter :

```text
k
```

ou :

```text
↑
```

On peut retenir :

```text
j / ↓
→ descendre

k / ↑
→ remonter
```

### Faire défiler par demi-page

Pour descendre plus rapidement :

```text
Ctrl+D
```

Pour remonter :

```text
Ctrl+U
```

Le moyen mnémotechnique est simple :

```text
Ctrl+D
→ Down

Ctrl+U
→ Up
```

### Faire défiler par page entière

Pour descendre d’une page :

```text
Espace
```

Pour remonter d’une page :

```text
b
```

Donc :

```text
Espace
→ page suivante

b
→ page précédente
```

### Aller directement au début ou à la fin

Pour aller au début de la transcription :

```text
g
```

Pour aller à la fin :

```text
G
```

On retrouve ici une convention proche de Vim.

```text
g
→ début

G
→ fin
```

### Naviguer entre les prompts

Une longue session peut contenir de nombreuses demandes utilisateur.

Il peut être plus rapide de naviguer directement entre elles.

Selon le contexte :

```text
↑
→ prompt précédent

↓
→ prompt suivant
```

Certaines versions ou configurations peuvent également proposer :

```text
{
→ prompt utilisateur précédent

}
→ prompt utilisateur suivant
```

On peut alors passer conceptuellement de :

```text
Prompt utilisateur 1
        ↓
Prompt utilisateur 2
        ↓
Prompt utilisateur 3
```

sans relire chaque ligne intermédiaire.

Ces raccourcis peuvent varier.

En cas de doute :

```text
Ctrl+O
?
```

permet de vérifier l’aide de la session.

### Écrire la conversation dans le scrollback natif

Parfois, on souhaite sortir du fonctionnement propre à la TUI et retrouver les outils classiques du terminal.

Pour cela :

```text
Ctrl+O
```

puis :

```text
[
```

Le raccourci `[` écrit la conversation complète dans le scrollback natif.

On obtient :

```text
TUI
 ↓
Ctrl+O
 ↓
[
 ↓
conversation complète
 ↓
scrollback du terminal
```

Une fois cette opération effectuée, on peut utiliser :

* `Cmd+F` ;
* la recherche native ;
* la sélection à la souris ;
* la copie ;
* le mode copie de tmux.

Cette opération devient particulièrement utile pour :

```text
rechercher
copier
inspecter
archiver
```

une longue conversation.

Elle peut prendre un moment si la session contient beaucoup de contenu.

### Ouvrir la conversation dans un éditeur

Le mode transcription permet également d’ouvrir la conversation dans un éditeur externe.

On ouvre d’abord :

```text
Ctrl+O
```

Puis :

```text
v
```

Le fonctionnement est alors :

```text
Transcription
     ↓
v
     ↓
fichier temporaire
     ↓
éditeur
```

L’éditeur utilisé dépend généralement de :

```text
$VISUAL
```

ou :

```text
$EDITOR
```

Cette méthode est intéressante pour :

* relire une longue session ;
* utiliser une recherche d’éditeur ;
* copier des passages ;
* préparer une synthèse ;
* conserver une trace de travail.

Avant d’ouvrir la transcription, on peut demander à Claude :

```text
Ne modifie aucun fichier.

Ajoute un résumé final de cette session :

1. commandes testées ;
2. rendu actif ;
3. points à retenir ;
4. limites observées ;
5. prochaine action recommandée.
```

Puis :

```text
Ctrl+O
v
```

La transcription ouverte dans l’éditeur contient alors également ce résumé final.

### Quitter le mode transcription

Pour revenir à la conversation normale :

```text
q
```

ou :

```text
Échap
```

ou :

```text
Ctrl+C
```

On peut mémoriser :

```text
Mode transcription
       ↓
q / Échap / Ctrl+C
       ↓
Conversation normale
```

### Faire défiler en rendu plein écran

Il n’est pas obligatoire d’ouvrir le mode transcription simplement pour remonter dans la conversation.

Le rendu plein écran propose également des raccourcis de navigation directe.

Pour monter :

```text
PageUp
```

Pour descendre :

```text
PageDown
```

Ces déplacements correspondent à une portion importante de la fenêtre.

Pour aller directement au début :

```text
Ctrl+Home
```

Pour revenir au dernier message :

```text
Ctrl+End
```

`Ctrl+End` permet également de réactiver le suivi automatique.

Le fonctionnement est :

```text
Ctrl+Home
→ début de la conversation

Ctrl+End
→ dernier message
→ suivi automatique
```

### Utiliser un clavier portable

Sur certains ordinateurs portables, `PageUp`, `PageDown`, `Home` et `End` ne possèdent pas de touches dédiées.

On peut alors avoir :

```text
Fn+↑
→ PageUp

Fn+↓
→ PageDown

Fn+←
→ Home

Fn+→
→ End
```

Le comportement précis dépend du clavier.

### Utiliser la souris

Lorsque le terminal transmet les événements de souris, la molette peut servir à faire défiler la conversation.

```text
Molette
    ↓
défilement
```

Le comportement dépend cependant du terminal et de la configuration du rendu plein écran.

### Choisir la bonne méthode

On peut finalement distinguer trois besoins.

Pour une recherche simple en rendu classique :

```text
Rendu classique
      ↓
Cmd+F / recherche terminal
```

Pour simplement remonter dans une conversation plein écran :

```text
Rendu plein écran
      ↓
PageUp / PageDown
```

Pour rechercher ou inspecter précisément :

```text
Rendu plein écran
      ↓
Ctrl+O
      ↓
mode transcription
      ↓
/
```

Pour utiliser les outils natifs du terminal sur toute la conversation :

```text
Ctrl+O
   ↓
[
   ↓
scrollback natif
```

Pour effectuer une relecture approfondie dans un éditeur :

```text
Ctrl+O
   ↓
v
   ↓
éditeur
```

Le mode transcription joue donc le rôle de passerelle entre une conversation TUI et plusieurs méthodes d’inspection.

### Raccourcis principaux du mode transcription

| Raccourci              | Action                                                               |
| ---------------------- | -------------------------------------------------------------------- |
| `Ctrl+O`               | Basculer vers le mode transcription.                                 |
| `?`                    | Afficher ou masquer l’aide.                                          |
| `/`                    | Ouvrir la recherche.                                                 |
| `n`                    | Occurrence suivante.                                                 |
| `N`                    | Occurrence précédente.                                               |
| `j`                    | Défiler vers le bas.                                                 |
| `k`                    | Défiler vers le haut.                                                |
| `↓`                    | Défiler vers le bas ou aller au prompt suivant selon le contexte.    |
| `↑`                    | Défiler vers le haut ou aller au prompt précédent selon le contexte. |
| `Ctrl+D`               | Descendre d’une demi-page.                                           |
| `Ctrl+U`               | Remonter d’une demi-page.                                            |
| `Espace`               | Descendre d’une page.                                                |
| `b`                    | Remonter d’une page.                                                 |
| `g`                    | Aller au début.                                                      |
| `G`                    | Aller à la fin.                                                      |
| `{`                    | Aller au prompt utilisateur précédent si supporté.                   |
| `}`                    | Aller au prompt utilisateur suivant si supporté.                     |
| `[`                    | Écrire la conversation dans le scrollback natif.                     |
| `v`                    | Ouvrir la conversation dans l’éditeur configuré.                     |
| `q`, `Échap`, `Ctrl+C` | Quitter le mode transcription.                                       |

### Raccourcis principaux du rendu plein écran

| Raccourci           | Action                                                      |
| ------------------- | ----------------------------------------------------------- |
| `PageUp` / `Fn+↑`   | Défiler vers le haut.                                       |
| `PageDown` / `Fn+↓` | Défiler vers le bas.                                        |
| `Ctrl+Home`         | Aller au début de la conversation.                          |
| `Ctrl+End`          | Aller au dernier message et réactiver le suivi automatique. |
| `Molette de souris` | Défiler si le terminal transmet les événements de souris.   |

La règle centrale est finalement :

```text
La bonne méthode de recherche
dépend du mode d'affichage.
```

Il ne faut donc pas conclure qu’une recherche est cassée simplement parce que `Cmd+F` ne fonctionne pas comme prévu en TUI.

Le contenu est toujours présent dans Claude Code.

Il faut simplement utiliser la surface adaptée :

```text
scrollback
→ recherche terminal

TUI
→ transcription
```

## Points clés

* Le rendu classique conserve la conversation dans le scrollback natif.
* La recherche habituelle du terminal fonctionne donc bien en rendu classique.
* Le rendu plein écran utilise une TUI.
* La TUI ne correspond pas toujours au scrollback natif du terminal.
* `Ctrl+O` ouvre le mode transcription.
* Le mode transcription permet de rechercher, naviguer, exporter et relire la conversation.
* `?` affiche l’aide des raccourcis.
* `/` ouvre une recherche.
* `n` passe à l’occurrence suivante.
* `N` revient à l’occurrence précédente.
* `j` et `k` permettent de défiler ligne par ligne.
* `Ctrl+D` descend d’une demi-page.
* `Ctrl+U` remonte d’une demi-page.
* `Espace` descend d’une page.
* `b` remonte d’une page.
* `g` va au début.
* `G` va à la fin.
* `↑`, `↓`, `{` et `}` peuvent permettre de naviguer entre les prompts selon la version et le contexte.
* `[` écrit la conversation complète dans le scrollback natif.
* L’export dans le scrollback permet de réutiliser les outils classiques du terminal.
* `v` ouvre la conversation dans l’éditeur configuré.
* `$VISUAL` et `$EDITOR` peuvent déterminer l’éditeur utilisé.
* `q`, `Échap` et `Ctrl+C` permettent de quitter le mode transcription.
* `PageUp` et `PageDown` permettent de naviguer directement dans le rendu plein écran.
* `Ctrl+Home` va au début de la conversation.
* `Ctrl+End` retourne au dernier message et réactive le suivi automatique.
* Les touches `Fn` peuvent être nécessaires sur certains claviers portables.
* La molette peut permettre de faire défiler la conversation.
* Les raccourcis peuvent varier selon la version et le terminal.
* En cas de doute, utilisez `Ctrl+O` puis `?`.
* La recherche native est adaptée au scrollback.
* La transcription est adaptée à la TUI.
