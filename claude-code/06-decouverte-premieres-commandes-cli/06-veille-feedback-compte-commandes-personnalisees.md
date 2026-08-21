---
title: "Gérer la veille, le compte et le feedback dans Claude Code"
description: "Apprendre à suivre les évolutions de Claude Code, gérer les réglages du compte, signaler un problème et fermer proprement son environnement."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - compte
  - veille
  - feedback
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-premiere-session-claude-code
leçon: 03-veille-compte-feedback-claude-code
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                                                          | Notes détaillées                                                                                                                                |
| --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| À quoi sert `/release-notes` ?                                                    | À consulter les notes de version de Claude Code depuis la session afin d’identifier les nouveautés, corrections et changements de comportement. |
| Pourquoi installer une routine de veille ?                                        | Parce que Claude Code évolue rapidement et que certaines commandes, capacités ou bonnes pratiques peuvent changer.                              |
| Quelle commande permet de connaître la version installée ?                        | `claude --version`.                                                                                                                             |
| Comment exploiter utilement les notes de version ?                                | En distinguant ce qui doit être utilisé immédiatement, testé plus tard ou ignoré pour le projet courant.                                        |
| À quoi sert `/upgrade` ?                                                          | À ouvrir la page permettant de passer à un plan supérieur lorsque cette possibilité est disponible.                                             |
| Un problème avec Claude Code signifie-t-il forcément qu’il faut changer de plan ? | Non. Il peut provenir du projet, du prompt, de l’installation ou de la configuration.                                                           |
| À quoi sert `/privacy-settings` ?                                                 | À consulter et modifier les réglages de confidentialité disponibles pour le compte.                                                             |
| Pourquoi vérifier la confidentialité avant un projet réel ?                       | Parce qu’un dépôt peut contenir du code privé, des secrets, des clés ou être soumis aux règles d’une organisation.                              |
| `/privacy-settings` remplace-t-il les règles de l’entreprise ?                    | Non. Les politiques internes, contraintes contractuelles et règles de sécurité restent applicables.                                             |
| À quoi sert `/passes` ?                                                           | À partager une période gratuite de Claude Code lorsque le compte est éligible.                                                                  |
| À quoi sert `/stickers` ?                                                         | À commander des stickers Claude Code. Cette commande est périphérique au travail de développement.                                              |
| À quoi sert `/feedback` ?                                                         | À envoyer un retour produit ou signaler un comportement problématique de Claude Code.                                                           |
| Quel est l’alias de `/feedback` ?                                                 | `/bug`.                                                                                                                                         |
| Que doit contenir un bon rapport de bug ?                                         | Le contexte, l’action réalisée, le résultat attendu, le résultat observé et si possible la version utilisée.                                    |
| Quand ne pas utiliser `/feedback` ?                                               | Lorsque le problème concerne le code du projet lui-même et non Claude Code.                                                                     |
| À quoi sert `/logout` ?                                                           | À déconnecter le compte Anthropic de Claude Code.                                                                                               |
| Quelle différence entre `/exit` et `/logout` ?                                    | `/exit` ferme la session CLI tandis que `/logout` déconnecte réellement le compte.                                                              |
| Quand `/logout` est-il particulièrement utile ?                                   | Sur une machine partagée, temporaire, empruntée ou peu contrôlée.                                                                               |

## Synthèse

Cette partie du CLI ne concerne pas directement la modification du code : elle sert à maintenir un environnement Claude Code sain dans la durée. Il faut savoir suivre les évolutions, distinguer les problèmes de plan des problèmes techniques, vérifier la confidentialité, signaler correctement un bug et choisir entre quitter une session ou se déconnecter.

## Glossaire

* note de version : document décrivant les nouveautés, corrections et changements apportés à une nouvelle version.
* veille : suivi régulier des évolutions d’un outil.
* `/release-notes` : commande permettant de consulter les notes de version de Claude Code.
* `claude --version` : commande terminal affichant la version de Claude Code installée.
* `/upgrade` : commande ouvrant les options de changement de plan.
* plan : niveau d’abonnement ou d’accès associé au compte.
* `/privacy-settings` : commande donnant accès aux réglages de confidentialité disponibles.
* confidentialité : ensemble des règles liées à l’utilisation, la conservation et l’exposition des données.
* `/passes` : commande permettant, selon l’éligibilité, de partager un accès temporaire à Claude Code.
* `/stickers` : commande périphérique permettant de commander des stickers Claude Code.
* `/feedback` : commande permettant d’envoyer un retour produit.
* `/bug` : alias de `/feedback`.
* rapport de bug : description structurée d’un comportement incorrect permettant sa reproduction.
* `/logout` : commande permettant de déconnecter le compte Anthropic.
* `/exit` : commande permettant de quitter la session interactive sans nécessairement déconnecter le compte.
* `/quit` : alias de `/exit`.

## Questions d'auto-évaluation

1. Pourquoi faut-il suivre régulièrement les notes de version de Claude Code ?
2. À quoi sert `/release-notes` ?
3. Quelle commande permet d’afficher la version installée de Claude Code ?
4. Pourquoi ne faut-il pas chercher à mémoriser toutes les nouveautés ?
5. Quelles trois décisions peut-on prendre après avoir lu une nouveauté ?
6. À quoi sert `/upgrade` ?
7. Pourquoi un problème dans une session ne signifie-t-il pas forcément qu’un changement de plan est nécessaire ?
8. Quels autres types de problèmes faut-il vérifier avant de penser à un upgrade ?
9. À quoi sert `/privacy-settings` ?
10. Pourquoi cette commande est-elle importante avant de travailler sur un dépôt professionnel ?
11. Quels types de données sensibles peuvent être présents dans un projet ?
12. Pourquoi `/privacy-settings` ne remplace-t-il pas une politique de sécurité d’entreprise ?
13. À quoi sert `/passes` ?
14. Pourquoi `/stickers` doit-il être considéré comme une commande périphérique ?
15. Quelles grandes familles de commandes peut-on distinguer dans Claude Code ?
16. À quoi sert `/feedback` ?
17. Quelle différence existe-t-il entre un problème produit et un problème dans son propre code ?
18. Quel est l’alias de `/feedback` ?
19. Quelles informations rendent un rapport de bug exploitable ?
20. Quelle différence existe-t-il entre `/exit`, `/quit` et `/logout` ?
21. Dans quelles situations `/logout` est-il préférable à `/exit` ?
22. Que faut-il vérifier avant de se déconnecter ?

# Gérer la veille, le compte et le feedback dans Claude Code

**Durée : 18 minutes**

## Notes

Claude Code évolue régulièrement.

Une bonne utilisation du CLI ne consiste donc pas uniquement à apprendre des commandes une fois pour toutes.

Il faut également savoir :

```text
suivre les évolutions
        ↓
comprendre ce qui change
        ↓
adapter son workflow
```

Plusieurs commandes étudiées dans cette leçon ne modifient pas directement le projet.

Elles concernent principalement :

```text
Veille
Compte
Confidentialité
Feedback
Déconnexion
```

Les commandes principales sont :

```text
/release-notes
/upgrade
/privacy-settings
/passes
/stickers
/feedback
/bug
/logout
```

Avant de commencer, il reste utile de repartir d’un état connu du mini-projet.

```bash
cd convertisseur-temperature
git status
npm test
```

L’objectif est toujours le même :

```text
État du projet connu
+
tests vérifiés
+
session ouverte au bon endroit
```

Ensuite :

```bash
claude
```

Dans cette leçon, on n’utilise pas ces commandes pour modifier la logique du convertisseur.

Elles appartiennent plutôt à la gestion quotidienne de Claude Code.

La première est :

```text
/release-notes
```

Cette commande permet de consulter les notes de version.

Claude Code évoluant rapidement, une nouveauté peut modifier :

* une commande ;
* un mode ;
* une intégration ;
* les permissions ;
* les sessions distantes ;
* le comportement d’un outil.

La veille peut être représentée ainsi :

```text
Nouvelle version
      ↓
Notes de version
      ↓
Comprendre les changements
      ↓
Décider
```

L’objectif n’est pas de mémoriser toutes les nouveautés.

Il faut surtout les classer selon leur utilité réelle.

Par exemple :

```text
Nouveauté
│
├── utile maintenant
│
├── à tester plus tard
│
└── sans intérêt pour ce projet
```

Une demande adaptée serait :

```text
Lis les notes de version visibles.

Résume uniquement ce qui change
notre usage quotidien.

Classe les changements :

1. à utiliser tout de suite ;
2. à tester plus tard ;
3. à ignorer pour ce mini-projet.

Ne modifie aucun fichier.
```

Le but est de transformer la veille en **décision pratique**.

On peut également vérifier la version installée depuis le terminal :

```bash
claude --version
```

Puis consulter :

```text
/release-notes
```

Cette combinaison peut devenir une routine courte.

```text
Vérifier version
      ↓
Lire changements récents
      ↓
Identifier ce qui nous concerne
      ↓
Continuer le travail
```

Il faut éviter deux extrêmes.

Le premier serait :

```text
Claude Code est figé
→ je ne regarde jamais les nouveautés
```

Le second :

```text
Je lis absolument tout
→ mais je ne sais pas ce qui change mon workflow
```

La bonne approche est :

```text
Veille
→ décision
```

Une autre commande est :

```text
/upgrade
```

Elle permet, lorsque l’option est disponible, d’accéder à une offre supérieure.

Cette commande appartient à la **gestion du compte**.

Elle ne :

* lit pas le dépôt ;
* modifie pas les fichiers ;
* corrige pas un bug ;
* lance pas les tests.

Il est important de ne pas confondre :

```text
Problème de code
        ≠
Problème de plan
```

Si Claude Code rencontre un problème, il faut d’abord déterminer sa nature.

Par exemple :

```text
Problème
│
├── plan
├── installation
├── configuration
├── prompt
└── projet
```

Si `/doctor` détecte une mauvaise configuration, changer de plan ne corrigera pas la configuration.

Si les tests étaient déjà cassés avant Claude Code, un upgrade ne réparera pas le projet.

Si le prompt est ambigu, le problème vient peut-être simplement du cadrage.

Il faut donc diagnostiquer avant de penser à `/upgrade`.

Une commande plus importante pour un usage professionnel est :

```text
/privacy-settings
```

Elle permet d’afficher et de modifier les réglages de confidentialité disponibles pour le compte.

Avant de travailler sur un projet réel, il faut se demander :

```text
Le dépôt est-il privé ?
        ↓
Contient-il des secrets ?
        ↓
Contient-il des clés API ?
        ↓
Existe-t-il une politique d’entreprise ?
        ↓
Le bon compte est-il utilisé ?
        ↓
Les réglages sont-ils adaptés ?
```

Ce réflexe est important même si le projet pédagogique actuel ne contient aucune donnée sensible.

Un projet professionnel peut contenir :

* du code propriétaire ;
* des configurations internes ;
* des clés ;
* des secrets ;
* des données clients ;
* des informations confidentielles.

Les réglages Claude Code ne remplacent cependant jamais les règles de l’organisation.

On peut représenter cela ainsi :

```text
Réglages Claude Code
        +
politique interne
        +
contrats
        +
sécurité de l’entreprise
```

`/privacy-settings` est donc un outil de configuration.

Ce n’est pas une politique de sécurité complète.

Une autre commande est :

```text
/passes
```

Elle permet, lorsque le compte est éligible, de partager un accès temporaire à Claude Code.

Cette commande ne change rien au projet.

Elle appartient plutôt à l’adoption ou à la découverte de Claude Code.

Dans une équipe, cela pourrait permettre à un collègue de découvrir l’outil.

Mais permettre l’accès à Claude Code ne constitue pas une stratégie d’adoption complète.

Il faut toujours penser à :

```text
dépôts autorisés
confidentialité
prompts
permissions
lecture des diffs
validation humaine
```

Une autre commande encore plus périphérique est :

```text
/stickers
```

Elle permet de commander des stickers Claude Code.

Cette commande existe, mais elle n’a évidemment pas le même poids qu’une commande comme :

```text
/status
/doctor
/help
/release-notes
/feedback
```

Cette différence permet de commencer à organiser mentalement les commandes du CLI par **familles**.

Par exemple :

```text
Commandes de travail
│
├── /status
├── /doctor
├── /help
├── /copy
├── /export
└── /release-notes
```

Puis :

```text
Commandes de surfaces
│
├── /ide
├── /desktop
├── /mobile
├── /chrome
├── /remote-control
└── /remote-env
```

Et :

```text
Commandes de compte ou périphériques
│
├── /upgrade
├── /privacy-settings
├── /passes
├── /stickers
├── /logout
└── /feedback
```

Cette organisation est plus utile qu’une liste plate de commandes à mémoriser.

Une autre commande importante est :

```text
/feedback
```

Elle permet de signaler :

* un bug de Claude Code ;
* un comportement inattendu ;
* une friction dans le CLI ;
* un retour sur l’expérience.

Son alias est :

```text
/bug
```

Il faut distinguer deux types de problèmes.

```text
Mon code ne fonctionne pas
        ↓
demande normale à Claude
```

et :

```text
Claude Code lui-même
se comporte incorrectement
        ↓
/feedback ou /bug
```

Par exemple, si le test du convertisseur échoue à cause d’une erreur dans `src/main.js`, ce n’est pas un bug de Claude Code.

En revanche, si une commande Claude Code produit systématiquement une erreur incohérente, `/feedback` peut être adapté.

Un signalement vague serait :

```text
Ça ne marche pas.
```

Cette formulation donne peu d’informations.

Un rapport plus exploitable contient :

```text
Contexte
Action
Résultat attendu
Résultat observé
Version
```

Par exemple :

```text
/bug

Contexte :
projet JavaScript minimal.

Action :
j'utilise une commande donnée
sur l'application locale.

Résultat attendu :
la commande doit fonctionner.

Résultat observé :
une erreur apparaît.

Version :
voir /status.
```

La structure générale d’un bon rapport est donc :

```text
Contexte
    ↓
Action
    ↓
Attendu
    ↓
Observé
    ↓
Version / environnement
```

Plus le problème est reproductible, plus le retour est utile.

Enfin, cette leçon introduit :

```text
/logout
```

Cette commande permet de **déconnecter le compte Anthropic**.

Elle ne doit pas être confondue avec :

```text
/exit
```

ou :

```text
/quit
```

La différence est fondamentale :

```text
/exit
→ ferme la session CLI

/quit
→ alias de /exit

/logout
→ déconnecte le compte
```

Sur une machine personnelle, il est généralement inutile de se déconnecter chaque fois que l’on ferme le CLI.

On peut simplement utiliser :

```text
/exit
```

En revanche, `/logout` devient plus pertinent sur :

* une machine partagée ;
* un ordinateur emprunté ;
* une machine temporaire ;
* un poste de formation ;
* un environnement peu contrôlé.

Avant de se déconnecter, il faut cependant vérifier l’état de la session.

Par exemple :

```text
Avant /logout

1. quel projet était ouvert ?
2. quels fichiers ont été modifiés ?
3. quels tests ont été lancés ?
4. quel résultat est connu ?
5. qu'ai-je besoin de conserver ?
6. quelle sera la prochaine étape ?
```

Une demande possible est :

```text
Avant de me déconnecter,
résume l’état final de cette session.

Format :

1. projet ouvert ;
2. fichiers modifiés ;
3. tests exécutés ;
4. résultat connu ;
5. éléments exportés ou copiés ;
6. prochaine action recommandée.
```

Le workflow de fin de session peut donc être :

```text
Comprendre l'état actuel
        ↓
Conserver ce qui est utile
        ↓
Décider :
        │
        ├── seulement quitter
        │      ↓
        │    /exit
        │
        └── déconnecter le compte
               ↓
             /logout
```

La logique générale de cette leçon est donc de distinguer les responsabilités.

```text
/release-notes
→ suivre l'évolution de Claude Code

/upgrade
→ gérer le plan

/privacy-settings
→ vérifier la confidentialité

/passes
→ partager un accès éligible

/stickers
→ commande périphérique

/feedback ou /bug
→ signaler un problème produit

/logout
→ déconnecter le compte
```

Ces commandes ne servent pas toutes à coder.

Elles montrent que le CLI Claude Code possède plusieurs dimensions :

```text
Développement
+
Session
+
Surfaces
+
Compte
+
Confidentialité
+
Veille
+
Feedback
```

Comprendre ces familles permet d’utiliser Claude Code comme un environnement de travail cohérent plutôt que comme une simple liste de commandes.

## Points clés

* Claude Code évolue régulièrement et nécessite une veille minimale.
* `/release-notes` permet de consulter les notes de version.
* `claude --version` permet de vérifier la version installée.
* La veille doit déboucher sur une décision : utiliser, tester plus tard ou ignorer.
* Il ne faut pas considérer Claude Code comme un outil figé.
* `/upgrade` appartient à la gestion du compte et du plan.
* Un problème de session n’est pas forcément un problème de plan.
* Avant un upgrade, il faut distinguer problème de projet, prompt, installation, configuration ou plan.
* `/privacy-settings` permet de gérer les réglages de confidentialité disponibles.
* Les réglages de confidentialité doivent être vérifiés avant un projet sensible ou professionnel.
* Les politiques de l’organisation restent prioritaires.
* `/passes` permet selon l’éligibilité de partager un accès temporaire.
* `/stickers` est une commande périphérique.
* Les commandes Claude Code peuvent être regroupées par familles.
* `/feedback` permet d’envoyer un retour produit.
* `/bug` est l’alias de `/feedback`.
* Un problème de code ne doit pas être signalé comme un bug de Claude Code.
* Un bon rapport de bug contient contexte, action, résultat attendu et résultat observé.
* Un signalement reproductible est plus utile qu’un message vague.
* `/logout` déconnecte le compte Anthropic.
* `/exit` ferme la session sans nécessairement déconnecter le compte.
* `/quit` est l’alias de `/exit`.
* `/logout` est particulièrement utile sur une machine partagée ou temporaire.
* Avant de quitter ou se déconnecter, il faut connaître l’état final de la session.
