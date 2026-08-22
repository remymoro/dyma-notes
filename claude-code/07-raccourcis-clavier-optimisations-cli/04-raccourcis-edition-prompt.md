---
title: "Éditer efficacement son prompt dans Claude Code"
description: "Apprendre les principaux raccourcis clavier pour naviguer, corriger, supprimer et récupérer du texte pendant la rédaction d’un prompt."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - prompts
  - raccourcis
  - cli
categories:
  - "Chapitre 7"
cours: Claude Code
chapitre: 07-raccourcis-clavier-optimisations-cli
leçon: 04-raccourcis-edition-prompt
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| À quoi servent les raccourcis d’édition du prompt ? | À corriger, déplacer le curseur, supprimer ou récupérer du texte sans devoir réécrire toute la consigne. |
| Comment aller au début d’une ligne ? | `Ctrl+A`. |
| Comment aller à la fin d’une ligne ? | `Ctrl+E`. |
| Comment supprimer depuis le curseur jusqu’à la fin ? | `Ctrl+K`. |
| Comment supprimer depuis le curseur jusqu’au début ? | `Ctrl+U`. |
| Comment supprimer le mot précédent ? | `Ctrl+W`. |
| Que devient le texte supprimé avec ces raccourcis ? | Il est conservé temporairement afin de pouvoir être récupéré. |
| Comment récupérer le dernier texte supprimé ? | `Ctrl+Y`. |
| À quoi sert `Alt+Y` ? | Après `Ctrl+Y`, il permet de parcourir les textes supprimés précédemment. |
| Comment reculer d’un mot ? | `Alt+B`. |
| Comment avancer d’un mot ? | `Alt+F`. |
| Pourquoi les raccourcis `Alt` peuvent-ils poser problème sur macOS ? | Parce que `Option` doit souvent être configurée comme touche Meta dans le terminal. |
| Dans quel cas `Ctrl+K` est-il particulièrement utile ? | Lorsqu’on souhaite conserver le début d’un prompt mais remplacer toute sa fin. |
| Peut-on utiliser ces raccourcis pour déplacer du texte ? | Oui. On peut supprimer une portion avec `Ctrl+K`, `Ctrl+U` ou `Ctrl+W`, déplacer le curseur, puis la recoller avec `Ctrl+Y`. |

## Synthèse

Les raccourcis d’édition permettent de corriger rapidement un prompt sans tout réécrire. Les plus importants permettent de se déplacer dans la ligne, supprimer une portion du texte puis récupérer ce qui a été supprimé.

## Glossaire

- curseur : position actuelle où le prochain caractère sera écrit.
- ligne courante : ligne logique dans laquelle se trouve actuellement le curseur.
- `Ctrl+A` : aller au début de la ligne.
- `Ctrl+E` : aller à la fin de la ligne.
- `Ctrl+K` : supprimer depuis le curseur jusqu’à la fin de la ligne.
- `Ctrl+U` : supprimer depuis le curseur jusqu’au début de la ligne.
- `Ctrl+W` : supprimer le mot précédant le curseur.
- `Ctrl+Y` : récupérer le dernier texte supprimé avec les raccourcis d’édition.
- `Alt+Y` : parcourir les suppressions précédentes après un `Ctrl+Y`.
- `Alt+B` : déplacer le curseur d’un mot vers l’arrière.
- `Alt+F` : déplacer le curseur d’un mot vers l’avant.
- Meta : modification clavier utilisée par certains raccourcis de terminal et souvent associée à `Option` sur macOS.
- `$EDITOR` : variable pouvant indiquer l’éditeur de texte par défaut du terminal.

## Questions d'auto-évaluation

1. Pourquoi les raccourcis d’édition deviennent-ils particulièrement utiles avec un prompt long ?
2. Que fait `Ctrl+A` ?
3. Que fait `Ctrl+E` ?
4. Quelle différence existe-t-il entre `Ctrl+K` et `Ctrl+U` ?
5. À quoi sert `Ctrl+W` ?
6. Que devient le texte supprimé avec `Ctrl+K`, `Ctrl+U` ou `Ctrl+W` ?
7. À quoi sert `Ctrl+Y` ?
8. Dans quel ordre utiliser `Ctrl+Y` et `Alt+Y` ?
9. Quelle différence existe-t-il entre `Alt+B` et `Alt+F` ?
10. Pourquoi `Option+B` ou `Option+F` peuvent-ils ne pas fonctionner sur macOS ?
11. Quel réglage faut-il vérifier dans ce cas ?
12. Comment utiliser `Ctrl+K` pour rendre un prompt trop directif plus prudent ?
13. Comment déplacer une portion de texte sans utiliser le presse-papiers classique ?
14. Quel raccourci utiliser pour remplacer uniquement le début d’une consigne ?
15. Quel raccourci utiliser pour corriger rapidement le mot juste avant le curseur ?

# Éditer efficacement son prompt dans Claude Code

**Durée : 12 minutes**

## Notes

Les prompts adressés à Claude Code peuvent rapidement devenir longs.

Ils peuvent contenir :

- un objectif ;
- plusieurs contraintes ;
- des noms de fichiers ;
- une procédure ;
- des critères de vérification ;
- un format de sortie.

Par exemple :

```text
Analyse @src/auth/session.ts.

Objectif :
identifier pourquoi le renouvellement échoue.

Contraintes :
- ne modifie aucun fichier ;
- vérifie les tests existants ;
- commence par expliquer la cause probable.
```

Lorsqu’une consigne de ce type doit être corrigée, il est souvent plus rapide d’utiliser les raccourcis d’édition que de supprimer et réécrire manuellement tout le prompt.

Le premier groupe de raccourcis concerne le déplacement du curseur.

```text
Ctrl+A
→ début de la ligne

Ctrl+E
→ fin de la ligne
```

`Ctrl+A` permet d’aller immédiatement au début de la ligne actuelle.

Il devient utile lorsqu’on veut ajouter une contrainte importante devant une demande déjà écrite.

Par exemple :

```text
Analyse le fichier auth.ts.
```

On utilise :

```text
Ctrl+A
```

Puis on ajoute :

```text
Ne modifie aucun fichier. Analyse le fichier auth.ts.
```

Le raccourci évite de revenir caractère par caractère avec la flèche gauche.

À l’inverse :

```text
Ctrl+E
```

déplace immédiatement le curseur à la fin de la ligne.

Cela permet de reprendre la saisie rapidement.

On peut retenir :

```text
Ctrl+A
→ début

Ctrl+E
→ fin
```

Un deuxième groupe de raccourcis concerne la suppression.

Le premier est :

```text
Ctrl+K
```

Il supprime tout ce qui se trouve entre le curseur et la fin de la ligne.

Imaginons :

```text
Analyse auth.ts et corrige directement le bug.
```

On se rend compte que :

```text
corrige directement le bug
```

est trop directif.

On place le curseur juste avant cette partie puis :

```text
Ctrl+K
```

On obtient :

```text
Analyse auth.ts et 
```

On peut alors écrire :

```text
Analyse auth.ts et propose un plan avant toute action.
```

Le principe est :

```text
Bonne première partie | Mauvaise fin
                      ↑
                   curseur
                      ↓
                   Ctrl+K
                      ↓
Bonne première partie
```

`Ctrl+K` est donc particulièrement pratique lorsque le début du prompt est correct mais que sa fin doit être remplacée.

Le raccourci inverse est :

```text
Ctrl+U
```

Il supprime depuis le curseur jusqu’au début de la ligne.

Par exemple :

```text
Corrige directement le bug puis exécute les tests.
                         ↑
                      curseur
```

Avec :

```text
Ctrl+U
```

on peut conserver la fin :

```text
puis exécute les tests.
```

et remplacer uniquement le début.

Dans une saisie multi-ligne, l’action concerne la ligne logique courante.

On peut donc retenir :

```text
Ctrl+K
→ Kill vers la fin

Ctrl+U
→ supprimer vers le début
```

Pour une correction encore plus locale :

```text
Ctrl+W
```

supprime le mot situé juste avant le curseur.

Exemple :

```text
Analyse @src/autentication/session.ts
                         ↑
```

Si le mot précédent est incorrect :

```text
Ctrl+W
```

permet de le supprimer rapidement puis de saisir la bonne valeur.

Ce raccourci est pratique pour corriger :

* un nom de fichier ;
* une commande ;
* une option ;
* un terme technique ;
* un mot mal écrit.

Selon le terminal sous Windows :

```text
Ctrl+Backspace
```

peut également supprimer le mot précédent.

Ces trois raccourcis possèdent une propriété intéressante.

Le texte supprimé n’est pas nécessairement perdu.

```text
Ctrl+K
Ctrl+U
Ctrl+W
        ↓
texte supprimé
        ↓
conservé temporairement
```

Pour le récupérer :

```text
Ctrl+Y
```

`Ctrl+Y` recolle le dernier texte supprimé par ces raccourcis.

Prenons :

```text
Analyse auth.ts et corrige directement le bug.
```

On supprime la fin avec :

```text
Ctrl+K
```

Puis on change d’avis.

```text
Ctrl+Y
```

permet de remettre le texte supprimé.

On peut également utiliser ce comportement pour déplacer du texte.

```text
Texte à déplacer
      ↓
Ctrl+K
      ↓
déplacer le curseur
      ↓
Ctrl+Y
      ↓
texte déplacé
```

Il s’agit donc d’une forme de couper-coller interne à l’éditeur de ligne.

Claude Code permet également de parcourir plusieurs suppressions précédentes.

Après :

```text
Ctrl+Y
```

on peut utiliser :

```text
Alt+Y
```

pour remplacer le texte restauré par une suppression plus ancienne.

Le fonctionnement est :

```text
Suppression A
Suppression B
Suppression C

        ↓

Ctrl+Y
→ C

Alt+Y
→ B

Alt+Y
→ A
```

`Alt+Y` doit donc être utilisé après `Ctrl+Y`.

Cette fonctionnalité devient intéressante lorsqu’on a modifié plusieurs parties d’un prompt et qu’on souhaite récupérer une ancienne formulation.

Le troisième groupe concerne la navigation mot par mot.

Pour reculer d’un mot :

```text
Alt+B
```

Pour avancer :

```text
Alt+F
```

On peut mémoriser :

```text
Alt+B
→ Backward

Alt+F
→ Forward
```

Imaginons :

```text
Analyse le fichier src/auth/session.ts avant de modifier quoi que ce soit.
                                                            ↑
```

Si l’on veut revenir rapidement jusqu’à :

```text
src/auth/session.ts
```

il est beaucoup plus rapide d’utiliser plusieurs fois :

```text
Alt+B
```

que de maintenir la flèche gauche.

Le fonctionnement général est :

```text
caractère par caractère
→ ← →

mot par mot
→ Alt+B / Alt+F
```

Ces raccourcis deviennent très utiles sur des prompts contenant :

* des chemins ;
* des commandes ;
* des noms de fonctions ;
* des contraintes longues.

Sur macOS, il existe un cas particulier.

La touche `Alt` correspond généralement à :

```text
Option
```

On pourrait donc s’attendre à utiliser :

```text
Option+B
Option+F
Option+Y
```

Mais cela ne fonctionne pas nécessairement par défaut.

Le terminal doit souvent interpréter `Option` comme une touche Meta.

Le réglage peut apparaître sous différents noms :

```text
Use Option as Meta Key
```

ou :

```text
Esc+
```

ou :

```text
macOptionIsMeta
```

Le chemin conceptuel est :

```text
Option+B
      ↓
Terminal
      ↓
Option configurée comme Meta ?
      ↓
Oui → Alt+B transmis à Claude Code
Non → comportement différent
```

Si `Alt+B`, `Alt+F` ou `Alt+Y` ne fonctionnent pas sur macOS, il faut donc d’abord vérifier la configuration du terminal.

Un exemple complet permet de regrouper les différentes notions.

Prompt initial :

```text
Analyse le fichier auth.ts et corrige directement le bug.
```

On souhaite conserver :

```text
Analyse le fichier auth.ts et 
```

mais remplacer :

```text
corrige directement le bug.
```

On place le curseur :

```text
Analyse le fichier auth.ts et |corrige directement le bug.
```

Puis :

```text
Ctrl+K
```

Le résultat devient :

```text
Analyse le fichier auth.ts et 
```

On écrit ensuite :

```text
propose un plan avant toute action.
```

Résultat :

```text
Analyse le fichier auth.ts et propose un plan avant toute action.
```

Cette nouvelle formulation est plus prudente.

Si finalement on veut récupérer le texte supprimé :

```text
Ctrl+Y
```

permet de le restaurer.

Les raccourcis peuvent donc être organisés en trois familles :

```text
ÉDITION DU PROMPT
│
├── Déplacement
│   ├── Ctrl+A
│   ├── Ctrl+E
│   ├── Alt+B
│   └── Alt+F
│
├── Suppression
│   ├── Ctrl+K
│   ├── Ctrl+U
│   └── Ctrl+W
│
└── Récupération
    ├── Ctrl+Y
    └── Alt+Y
```

Le tableau mental le plus simple est :

```text
Ctrl+A
→ début ligne

Ctrl+E
→ fin ligne

Alt+B
→ mot précédent

Alt+F
→ mot suivant

Ctrl+K
→ supprimer vers la fin

Ctrl+U
→ supprimer vers le début

Ctrl+W
→ supprimer le mot précédent

Ctrl+Y
→ récupérer

Alt+Y
→ ancienne suppression
```

Il n’est pas nécessaire de mémoriser tous ces raccourcis immédiatement.

Les quatre plus utiles pour commencer peuvent être :

```text
Ctrl+A
→ début

Ctrl+E
→ fin

Ctrl+W
→ supprimer un mot

Ctrl+Y
→ récupérer
```

Puis ajouter progressivement :

```text
Ctrl+K
Ctrl+U
Alt+B
Alt+F
Alt+Y
```

à mesure que les prompts deviennent plus longs.

L’objectif n’est pas d’écrire le plus vite possible.

L’intérêt est surtout de pouvoir corriger une consigne avant de l’envoyer.

Dans Claude Code, cette étape peut avoir beaucoup d’importance.

Modifier :

```text
Corrige directement.
```

en :

```text
Analyse d’abord et propose un plan avant toute modification.
```

peut changer la trajectoire de travail de l’agent.

Les raccourcis d’édition ne sont donc pas seulement des outils de confort.

Ils permettent aussi de reprendre rapidement le contrôle sur la formulation exacte de la tâche avant son envoi.

## Points clés

* Les raccourcis d’édition deviennent particulièrement utiles avec les prompts longs.
* `Ctrl+A` déplace le curseur au début de la ligne.
* `Ctrl+E` déplace le curseur à la fin de la ligne.
* `Ctrl+K` supprime depuis le curseur jusqu’à la fin de la ligne.
* `Ctrl+U` supprime depuis le curseur jusqu’au début de la ligne.
* `Ctrl+W` supprime le mot précédent.
* Le texte supprimé avec `Ctrl+K`, `Ctrl+U` ou `Ctrl+W` peut être récupéré.
* `Ctrl+Y` recolle le dernier texte supprimé.
* `Alt+Y` parcourt les suppressions précédentes après `Ctrl+Y`.
* `Alt+B` recule d’un mot.
* `Alt+F` avance d’un mot.
* Les déplacements mot par mot sont pratiques dans les prompts longs.
* Sur macOS, `Option` correspond généralement à `Alt`.
* `Option` doit parfois être configurée comme touche Meta.
* Les noms du réglage Meta peuvent varier selon le terminal.
* `Ctrl+K` est particulièrement utile pour remplacer la fin d’une consigne.
* `Ctrl+U` permet de conserver la fin et remplacer le début.
* `Ctrl+W` est utile pour corriger rapidement un mot ou un chemin.
* `Ctrl+Y` peut servir à déplacer une portion de texte.
* Ces raccourcis permettent de corriger précisément un prompt avant de l’envoyer.
* Une meilleure édition du prompt permet aussi de mieux contrôler la trajectoire de Claude Code.
