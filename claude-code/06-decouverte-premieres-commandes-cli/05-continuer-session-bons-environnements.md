---
title: "Continuer la session dans les bons environnements"
description: "Comprendre comment poursuivre une session Claude Code depuis le terminal, l’IDE, Desktop, le mobile ou un environnement distant."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - ide
  - desktop
  - remote-control
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-premiere-session-claude-code
leçon: 02-continuer-session-bons-environnements
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                     | Notes détaillées                                                                                                                  |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| Quel est l’objectif de cette leçon ?                         | Comprendre quelle surface utiliser pour continuer une session Claude Code selon le type de travail à réaliser.                    |
| Quand rester dans le terminal ?                              | Pour les commandes, tests, vérifications rapides, Git et tâches principalement textuelles.                                        |
| À quoi sert `/ide` ?                                         | À gérer et vérifier l’intégration avec l’éditeur afin de faciliter la lecture des fichiers et des diffs.                          |
| Quand utiliser l’IDE ?                                       | Lorsqu’il faut parcourir plusieurs fichiers, lire du code ligne par ligne ou examiner visuellement un diff.                       |
| À quoi sert `/desktop` ?                                     | À continuer la session dans l’application Desktop avec une interface plus visuelle.                                               |
| Quel est l’alias de `/desktop` ?                             | `/app`.                                                                                                                           |
| À quoi sert `/mobile` ?                                      | À préparer l’accès depuis une application mobile, notamment avec un QR code.                                                      |
| Quels sont les alias de `/mobile` ?                          | `/ios` et `/android`.                                                                                                             |
| À quoi sert `/remote-control` ?                              | À rendre une session locale accessible depuis un navigateur ou un appareil mobile.                                                |
| Quel est l’alias de `/remote-control` ?                      | `/rc`.                                                                                                                            |
| Où s’exécute le code avec Remote Control ?                   | Sur la machine locale où la session Claude Code continue de tourner.                                                              |
| Remote Control est-il une session cloud ?                    | Non. Il change la surface de pilotage, pas nécessairement l’environnement d’exécution.                                            |
| À quoi sert `/remote-env` ?                                  | À choisir l’environnement par défaut utilisé par les agents cloud.                                                                |
| Quelle différence entre `/remote-control` et `/remote-env` ? | `/remote-control` pilote à distance une session locale ; `/remote-env` configure l’environnement d’agents exécutés dans le cloud. |
| À quoi servent `/exit` et `/quit` ?                          | À fermer proprement la session CLI interactive.                                                                                   |
| Quelle différence entre `/exit` et `/logout` ?               | `/exit` ferme la session CLI alors que `/logout` déconnecte le compte.                                                            |
| Pourquoi préparer un résumé avant de changer de surface ?    | Pour conserver une vision claire de l’état du projet, des modifications, des vérifications et de la prochaine action.             |

## Synthèse

Claude Code peut être utilisé depuis plusieurs surfaces, mais chacune répond à un besoin différent. Le terminal privilégie la rapidité, l’IDE la lecture du code, Desktop le confort visuel, Remote Control le pilotage à distance d’une session locale et Remote Env les agents cloud.

## Glossaire

* surface de travail : interface depuis laquelle l’utilisateur interagit avec Claude Code.
* CLI : interface en ligne de commande de Claude Code.
* IDE : environnement de développement intégré permettant notamment de lire et naviguer dans le code.
* `/ide` : commande permettant de gérer l’intégration de Claude Code avec l’éditeur.
* Desktop : application graphique permettant de continuer une session dans une interface plus visuelle.
* `/desktop` : commande permettant de poursuivre une session dans l’application Desktop.
* `/app` : alias de `/desktop`.
* `/mobile` : commande permettant de préparer l’accès à Claude depuis une application mobile.
* `/ios` : alias mobile destiné à iOS.
* `/android` : alias mobile destiné à Android.
* Remote Control : mécanisme permettant de piloter une session Claude Code locale depuis un autre appareil.
* `/remote-control` : commande activant le contrôle distant.
* `/rc` : alias de `/remote-control`.
* `/remote-env` : commande permettant de choisir l’environnement utilisé par les agents cloud.
* agent cloud : agent exécuté dans un environnement distant plutôt que directement sur la machine locale.
* résumé de reprise : synthèse de l’état courant permettant de continuer une tâche dans de bonnes conditions.
* `/exit` : commande permettant de quitter le CLI.
* `/quit` : alias de `/exit`.

## Questions d'auto-évaluation

1. Pourquoi Claude Code propose-t-il plusieurs surfaces de travail ?
2. Dans quel cas le terminal est-il généralement suffisant ?
3. À quoi sert `/ide` ?
4. Pourquoi l’IDE est-il plus confortable que le terminal pour certaines revues de code ?
5. À quoi sert `/desktop` ?
6. Quel est l’alias de `/desktop` ?
7. À quoi servent `/mobile`, `/ios` et `/android` ?
8. Qu’est-ce que `/remote-control` ?
9. Quel est l’alias de `/remote-control` ?
10. Où le code est-il exécuté lorsque Remote Control est actif ?
11. Pourquoi Remote Control est-il utile lorsque le dépôt contient des fichiers locaux non commités ?
12. Que se passe-t-il si la session locale est arrêtée pendant l’utilisation du contrôle distant ?
13. Quelle différence existe-t-il entre `/remote-control` et `/remote-env` ?
14. Dans quel cas utiliser `/remote-env` ?
15. Pourquoi faut-il continuer à vérifier les résultats même lorsqu’on pilote Claude Code depuis un mobile ?
16. Quelle surface choisir pour lire un fichier ligne par ligne ?
17. Quelle surface choisir pour lancer rapidement `npm test` ?
18. Quelle surface choisir pour suivre une tâche depuis un téléphone ?
19. Quelle commande permet de fermer proprement le CLI ?
20. Pourquoi un résumé de reprise est-il utile avant de changer de surface ?

# Continuer la session dans les bons environnements

**Durée : 18 minutes**

## Notes

Une session Claude Code n’est pas obligée de rester uniquement dans le terminal.

Selon la tâche, on peut continuer le travail depuis plusieurs surfaces :

```text
Terminal
IDE
Desktop
Mobile
Remote Control
Agents cloud
```

Le choix dépend surtout du type d’activité.

On peut résumer ainsi :

```text
Commande rapide
→ Terminal

Lecture approfondie du code
→ IDE

Conversation plus visuelle
→ Desktop

Suivi depuis un téléphone
→ Mobile + Remote Control

Agent exécuté à distance
→ Remote Env
```

Avant de changer de surface, il est utile de vérifier l’état du projet.

Par exemple :

```bash
cd convertisseur-temperature
git status
```

L’objectif est de savoir précisément :

* quels fichiers ont changé ;
* si les tests passent ;
* si le dépôt est propre ;
* si un diff existe encore ;
* ce qui a été fait pendant la session précédente.

Une session doit toujours être reprise à partir d’un état connu.

```text
État du projet connu
        ↓
Changement de surface
        ↓
Continuité du travail
```

Le terminal reste la surface la plus directe.

On ouvre Claude Code avec :

```bash
claude
```

Le terminal est particulièrement adapté lorsque la tâche consiste à :

* lancer des tests ;
* vérifier Git ;
* exécuter une commande ;
* lire une sortie courte ;
* demander un résumé ;
* effectuer une petite correction.

On peut par exemple demander :

```text
Ne modifie aucun fichier.

Rappelle :
1. le projet ouvert ;
2. l’état Git ;
3. la dernière modification connue ;
4. les commandes de vérification disponibles.
```

Cette demande sert à vérifier l’état de la session sans lancer de nouvelle modification.

Le terminal est efficace lorsque l’on recherche :

```text
rapidité
+
précision
+
peu de distraction
```

Il devient cependant moins confortable lorsqu’il faut comparer plusieurs fichiers ou parcourir beaucoup de code.

Dans ce cas, l’IDE devient plus intéressant.

La commande :

```text
/ide
```

permet de gérer l’intégration avec l’éditeur.

L’IDE facilite notamment :

* la lecture de plusieurs fichiers ;
* la navigation dans le projet ;
* l’inspection du diff ;
* la comparaison de plusieurs zones ;
* la conservation du code visible pendant la discussion.

Dans le mini-projet, on peut par exemple ouvrir :

```text
src/main.js
src/conversion.js
test/conversion.test.js
index.html
```

Ces fichiers permettent de comprendre l’ensemble du comportement du convertisseur.

Une demande adaptée pourrait être :

```text
Avec le contexte de l’IDE,
aide-moi à relire les fichiers ouverts.

Ne modifie rien.

Vérifie surtout si src/main.js
reste cohérent avec le reste du projet.
```

L’IDE devient alors principalement une **surface de revue**.

On peut représenter la différence ainsi :

```text
Terminal
→ commander

IDE
→ observer et vérifier
```

Le terminal reste préférable lorsque le besoin est très court.

Par exemple :

```text
Lancer npm test
Vérifier git status
Lire un petit diff
Obtenir un résumé
```

Dans ces situations, changer de surface peut être inutile.

Une autre possibilité est l’application Desktop.

La commande :

```text
/desktop
```

permet, lorsque la fonctionnalité est disponible, de continuer la session dans l’application Claude Code Desktop.

Son alias est :

```text
/app
```

Desktop fournit une interface plus visuelle.

Elle peut être intéressante pour :

* les conversations longues ;
* la lecture d’un diff ;
* plusieurs panneaux ;
* un aperçu ;
* la préparation d’une nouvelle demande.

Avant de changer de surface, il est préférable de demander un **résumé de reprise**.

Par exemple :

```text
Avant de continuer dans Desktop,
prépare un résumé de reprise.

1. projet ouvert ;
2. modification précédente ;
3. fichier modifié ;
4. vérifications réalisées ;
5. prochaine action ;
6. limite à ne pas dépasser.
```

Cette synthèse permet de conserver un état mental clair.

Le principe est :

```text
Avant changement de surface
        ↓
résumer l’état
        ↓
continuer
```

Claude Code peut également être utilisé depuis un appareil mobile.

La commande :

```text
/mobile
```

peut afficher un QR code permettant d’installer ou d’ouvrir l’application mobile.

Les alias sont :

```text
/ios
/android
```

L’application mobile peut être utile pour :

* suivre une tâche ;
* recevoir une notification ;
* reprendre une discussion ;
* surveiller une session.

Mais `/mobile` ne transforme pas automatiquement la session locale en session pilotable à distance.

Pour cela, il existe **Remote Control**.

La commande principale est :

```text
/remote-control
```

avec l’alias :

```text
/rc
```

On peut également donner un nom à la session :

```text
/remote-control Convertisseur température
```

Remote Control permet d’accéder à une session Claude Code locale depuis :

* un navigateur ;
* claude.ai/code ;
* une application mobile ;
* un autre appareil compatible.

Le point important est que la session continue de tourner **localement**.

```text
Téléphone / navigateur
        ↓
Remote Control
        ↓
Session Claude Code locale
        ↓
Machine locale
        ↓
Dépôt local
```

Le mobile n’exécute donc pas directement le code.

Il sert de surface de pilotage.

La session locale conserve :

* le dépôt local ;
* les fichiers non commités ;
* les outils installés ;
* les variables locales ;
* les services locaux ;
* la configuration de la machine.

Cette distinction est fondamentale.

```text
Remote Control
→ pilotage distant

Exécution
→ machine locale
```

Cela peut être utile lorsqu’un projet dépend d’éléments disponibles uniquement sur la machine locale.

Par exemple :

```text
fichiers non commités
serveur local
base locale
configuration locale
outils installés
```

Remote Control permet de continuer à utiliser cet environnement sans rester physiquement devant le terminal.

On peut tester le fonctionnement avec une tâche simple :

```text
Ne modifie aucun fichier.

Lance npm test.

Quand la commande est terminée,
résume le résultat en trois lignes.
```

Cette approche est plus sûre qu’une première expérience avec une migration ou une modification sensible.

Remote Control peut également servir à surveiller une tâche plus longue.

Dans un vrai projet, on peut avoir :

```text
tests longs
build
lint complet
analyse frontend
vérification complexe
```

La session locale continue de travailler pendant que l’utilisateur consulte le résultat ailleurs.

Même à distance, les règles de vérification restent les mêmes.

```text
Pilotage mobile
        ≠
moins de vérification
```

Il faut toujours vérifier :

* les tests ;
* le diff ;
* l’état Git ;
* les erreurs ;
* le résultat réel.

Un téléphone change la surface d’interaction, pas les exigences de qualité.

Il existe également une commande appelée :

```text
/remote-env
```

Elle répond à un besoin différent.

`/remote-env` permet de choisir l’environnement par défaut utilisé par des **agents cloud**.

Il faut donc distinguer deux mécanismes.

```text
/remote-control
        ↓
piloter une session locale à distance
```

et :

```text
/remote-env
        ↓
choisir l’environnement d’un agent cloud
```

Les noms sont proches, mais l’architecture est différente.

Avec Remote Control :

```text
Utilisateur distant
       ↓
Session locale
       ↓
Machine locale
```

Avec un agent cloud :

```text
Utilisateur
     ↓
Agent cloud
     ↓
Environnement distant
```

Dans le mini-projet `convertisseur-temperature`, `/remote-env` n’est pas indispensable.

Le projet est local, simple et facile à tester.

Mais cette commande devient importante lorsqu’un workflow utilise :

* des agents cloud ;
* des environnements distants ;
* des dépôts clonés ailleurs ;
* des tâches exécutées hors de la machine locale.

Le choix de la surface peut être résumé ainsi :

```text
Je veux lire src/main.js ligne par ligne
→ IDE

Je veux lancer npm test rapidement
→ Terminal

Je veux suivre une vérification depuis mon téléphone
→ Remote Control + Mobile

Je veux continuer dans une interface plus visuelle
→ Desktop

Je veux choisir l’environnement d’un agent cloud
→ Remote Env

Je veux fermer la session
→ /exit
```

La commande :

```text
/exit
```

permet de quitter le CLI.

Son alias est :

```text
/quit
```

Ces commandes ferment la session interactive.

Elles ne doivent pas être confondues avec :

```text
/logout
```

La différence est :

```text
/exit ou /quit
→ quitter la session CLI

/logout
→ déconnecter le compte
```

Choisir une surface de travail doit donc toujours répondre à un besoin concret.

Il ne faut pas changer d’environnement uniquement parce qu’une autre interface existe.

La bonne logique est :

```text
Quelle tâche dois-je faire ?
        ↓
Quelle surface facilite cette tâche ?
        ↓
Continuer la session
```

Le terminal est adapté à l’action rapide.

L’IDE facilite l’observation du code.

Desktop apporte davantage de confort visuel.

Le mobile facilite le suivi.

Remote Control permet de piloter une session locale depuis ailleurs.

Remote Env concerne l’exécution d’agents dans des environnements cloud.

La session reste donc la même logique de travail, mais la **surface utilisée doit être adaptée au besoin**.

## Points clés

* Claude Code peut être utilisé depuis plusieurs surfaces.
* Le choix de la surface dépend du type de travail à réaliser.
* Le terminal est adapté aux commandes, tests et vérifications rapides.
* `/ide` permet de gérer l’intégration avec l’éditeur.
* L’IDE facilite la lecture du code et l’inspection des diffs.
* `/desktop` permet de poursuivre la session dans Desktop.
* `/app` est l’alias de `/desktop`.
* Un résumé de reprise est utile avant de changer de surface.
* `/mobile` prépare l’accès depuis une application mobile.
* `/ios` et `/android` sont des alias de `/mobile`.
* `/remote-control` permet de piloter une session locale à distance.
* `/rc` est l’alias de `/remote-control`.
* Avec Remote Control, l’exécution reste sur la machine locale.
* Remote Control conserve l’accès au dépôt et aux fichiers locaux.
* Si la session locale s’arrête, le contrôle distant ne peut plus piloter cet environnement.
* Le mobile change la surface de pilotage, pas les exigences de vérification.
* `/remote-env` concerne les agents cloud.
* `/remote-control` et `/remote-env` répondent à deux besoins différents.
* `/exit` permet de quitter proprement le CLI.
* `/quit` est l’alias de `/exit`.
* `/exit` ne doit pas être confondu avec `/logout`.
* Il faut choisir la surface selon le workflow, pas selon la nouveauté de l’interface.
