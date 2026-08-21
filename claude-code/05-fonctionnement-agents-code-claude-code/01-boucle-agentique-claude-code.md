---
title: "La boucle agentique de Claude Code"
description: "Comprendre le fonctionnement de la boucle agentique utilisée par Claude Code."
date: 2026-08-14
draft: false
tags:
  - claude-code
  - agents
  - boucle-agentique
categories:
  - "Chapitre 5"
cours: Claude Code
chapitre: 05-fonctionnement-agents-code-claude-code
leçon: 01-boucle-agentique-claude-code
statut: à revoir
etape_revision: 0
prochaine_revision: 
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce qu'une boucle agentique ? | Un cycle contrôlé qui permet à Claude Code de préparer un état de décision, appeler le modèle, interpréter sa sortie, exécuter éventuellement une action via un outil, récupérer une observation puis réinjecter cette observation dans l'itération suivante. |
| Pourquoi parle-t-on de trajectoire ? | Parce que le système ne se limite pas à produire une réponse immédiate : il peut enchaîner plusieurs décisions, actions, observations et corrections jusqu'à une condition d'arrêt. |
| Où se trouve l'agenticité ? | Elle ne réside pas uniquement dans le modèle. Elle vient de l'articulation entre le modèle, le harness, les outils, les permissions, l'état et l'environnement d'exécution. |
| Quel est le rôle du modèle ? | Le modèle décide de la prochaine opération pertinente à partir du contexte disponible. Il peut produire une réponse finale ou une demande structurée d'outil. |
| Quel est le rôle du harness ? | Le harness orchestre la demande du modèle, vérifie l'outil et ses paramètres, applique les règles d'autorisation, route l'action et réintègre le résultat dans la boucle. |
| Une demande d'outil est-elle déjà une action ? | Non. C'est une intention opératoire. Elle doit encore passer par le harness, les permissions et l'outil avant de produire un effet réel. |
| Qu'est-ce qu'une observation ? | Le retour produit par l'environnement ou le harness : contenu de fichier, sortie de commande, test, erreur, diff, état Git, refus de permission, etc. |
| Pourquoi l'observation est-elle essentielle ? | Elle permet de confronter les hypothèses du modèle à l'état réel de l'environnement et de corriger ou confirmer la trajectoire. |
| Quelle différence entre un tour et une itération ? | Le tour est la trajectoire complète déclenchée par une demande utilisateur. Une itération est un passage interne de la boucle : contexte → modèle → décision → action éventuelle → observation. |
| À quoi sert la vérification ? | À fournir un signal externe sur la qualité du résultat : tests, build, typecheck, linter, diff ou état de commande. |
| Que se passe-t-il si une action est refusée ? | Le refus revient dans la boucle comme observation. Le modèle peut proposer une autre trajectoire compatible ou expliquer le blocage. |
| Comment la boucle s'arrête-t-elle ? | Réponse finale, réussite vérifiée, besoin d'une validation humaine, refus, erreur non récupérable, limite atteinte ou interruption explicite. |

## Synthèse
La boucle agentique de Claude Code transforme une demande utilisateur en une trajectoire contrôlée composée de décisions, d'actions et d'observations. Le modèle propose ce qu'il faut faire, mais le harness, les permissions et les outils contrôlent l'exécution réelle. Chaque résultat revient dans la boucle afin de confirmer, corriger ou arrêter la trajectoire.

## Glossaire
- **Agent Loop** : boucle centrale qui maintient la continuité entre décision, action, observation et nouvelle décision.
- **Agenticité** : capacité du système à poursuivre une tâche sur plusieurs étapes en utilisant les retours de l'environnement.
- **Harness** : couche d'orchestration qui transforme une sortie du modèle en opération système contrôlée.
- **Tool request** : demande structurée produite par le modèle pour solliciter un outil.
- **Outil** : composant qui réalise une opération concrète, par exemple lire un fichier ou exécuter une commande.
- **Observation** : résultat externe renvoyé à la boucle après une action ou une tentative d'action.
- **Permission System** : mécanisme qui autorise, refuse ou demande une validation avant l'exécution d'une action.
- **Tour agentique** : trajectoire complète déclenchée par une demande utilisateur.
- **Itération** : un passage interne de la boucle : préparation du contexte, appel du modèle, traitement de la sortie et observation éventuelle.
- **État** : informations opérationnelles nécessaires pour conserver la continuité du tour.
- **Context Assembly** : assemblage des informations utiles transmises au modèle pour la prochaine décision.
- **Compaction** : mécanisme qui réduit ou résume le contexte lorsque cela est nécessaire pour poursuivre la session.
- **Vérification** : observation destinée à confirmer ou invalider le résultat d'une trajectoire.
- **Condition d'arrêt** : situation qui provoque la clôture, la suspension ou l'interruption de la boucle.

## Questions d'auto-évaluation
1. Pourquoi Claude Code ne doit-il pas être vu comme un simple chatbot ?
2. Quelles sont les quatre opérations fondamentales de la boucle agentique ?
3. Quelle différence existe entre une intention d'action et une action réellement exécutée ?
4. Quel est le rôle du modèle dans la boucle ?
5. Quel est le rôle du harness ?
6. Pourquoi une demande d'outil passe-t-elle par un système de permissions ?
7. Quelle différence existe entre un tour agentique et une itération ?
8. Pourquoi une erreur peut-elle être utile à la boucle ?
9. Qu'est-ce qui donne à une observation un statut différent d'une simple phrase générée par le modèle ?
10. Pourquoi la vérification fait-elle partie de la boucle elle-même ?
11. Que peut faire la boucle lorsqu'une permission est refusée ?
12. Quelles sont les principales conditions d'arrêt ?
13. Pourquoi la présence d'outils ne suffit-elle pas, à elle seule, à rendre un système agentique ?
14. Quelle place l'utilisateur conserve-t-il pendant l'exécution d'un tour ?
15. Comment résumer la différence entre modèle, harness, outil et environnement ?

# La boucle agentique de Claude Code

**Durée : 23 minutes**

---

# 1. Comprendre la boucle agentique

La boucle agentique de Claude Code est le mécanisme d'orchestration qui transforme une demande utilisateur en une trajectoire d'exécution.

Elle ne désigne pas une simple réponse du modèle et ne signifie pas non plus que le modèle possède une autonomie générale sur le système. Elle décrit un cycle contrôlé dans lequel Claude Code peut :
- préparer un état de décision ;
- appeler le modèle ;
- interpréter sa sortie ;
- demander éventuellement une action via un outil ;
- exécuter cette action dans un cadre autorisé ;
- récupérer une observation ;
- réinjecter cette observation dans l'itération suivante.

La boucle est dite agentique parce qu'elle maintient une continuité d'action. Le système peut avancer par étapes, tester ses hypothèses, recevoir des erreurs, ajuster sa trajectoire et continuer jusqu'à atteindre une condition d'arrêt.

L'agenticité ne vient donc pas seulement du modèle. Elle vient de l'articulation entre plusieurs composants :
- le modèle ;
- le harness ;
- les outils ;
- le système de permissions ;
- l'état ;
- l'environnement d'exécution.

```text
Utilisateur
    │
    ▼
Préparer
    │
    ▼
Décider
    │
    ▼
Agir
    │
    ▼
Observer
    │
    └──────────────► Décider à nouveau
```

La structure fondamentale de la boucle peut être résumée par quatre opérations :
**Préparer → Décider → Agir → Observer**

---

# 2. La position centrale de la boucle dans l'architecture

La boucle agentique se trouve au centre du trajet fonctionnel de Claude Code.

La demande vient de l'utilisateur, traverse une surface d'entrée, atteint la couche cœur puis entre dans l'Agent Loop. Si le modèle souhaite effectuer une action, la demande descend vers les mécanismes de sécurité et les outils. Le résultat remonte ensuite vers la boucle.

```text
┌──────────────────────────────────────────────────────────────┐
│ Surface Layer                                                │
│ CLI / IDE / Desktop / Browser / Headless / Agent SDK        │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│ Core Layer                                                   │
│                      Agent Loop                              │
│                          ↕                                   │
│                  Context / Compaction                        │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│ Safety / Action Layer                                       │
│ Permissions / Hooks / Built-in Tools / MCP / Subagents      │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│ Backend / Environment                                       │
│ Files / Shell / ressources locales, cloud ou distantes      │
└──────────────────────────────────────────────────────────────┘

               ▲
               │
┌──────────────────────────────────────────────────────────────┐
│ State Layer                                                  │
│ Context Assembly / Runtime State / Session / Memory          │
└──────────────────────────────────────────────────────────────┘
```

Les couches ne remplacent pas la boucle. Elles participent à son déroulement :
- la Surface Layer reçoit la demande et affiche la progression ;
- la Core Layer contient la boucle agentique ;
- la Safety / Action Layer intervient lorsqu'une action est demandée ;
- la State Layer fournit les éléments nécessaires à la continuité du tour ;
- la Backend Layer correspond à l'environnement où les outils produisent leurs effets.

La boucle est donc une structure de passage entre intention, décision, action et observation.

---

# 3. De la demande utilisateur à une trajectoire

Une demande utilisateur ne devient pas directement une action.

Elle est d'abord convertie en un état exploitable par le système. La boucle conserve ce qui a été demandé, ce qui a déjà été tenté, les résultats obtenus, les erreurs rencontrées et les informations nécessaires à la suite.

```text
Demande utilisateur
        │
        ▼
Construction d'un état de travail
        │
        ▼
Décision du modèle
        │
        ▼
Action éventuelle
        │
        ▼
Observation
        │
        ▼
Nouvel état de travail
```

Cette continuité distingue Claude Code d'un échange conversationnel simple.

Un chatbot classique peut être représenté ainsi :
**Prompt → Réponse**

Claude Code peut suivre une trajectoire plus longue :

```text
Objectif
   ↓
Décision
   ↓
Action
   ↓
Observation
   ↓
Réévaluation
   ↓
Nouvelle action
   ↓
Vérification
   ↓
Arrêt
```

Une tâche réelle n'est donc pas toujours représentée par une seule réponse. Elle peut nécessiter plusieurs transitions successives.

---

# 4. Le modèle décide, le harness orchestre

Le principe architectural central est la séparation entre décision et exécution.

Le modèle ne lit pas directement les fichiers, ne lance pas directement les commandes shell et ne modifie pas directement l'environnement.

Il produit une sortie.

Cette sortie peut être :
- une réponse destinée à l'utilisateur ;
- une demande structurée d'utilisation d'un outil.

Une demande d'outil n'est pas encore une action. Elle représente une intention opératoire que le harness doit interpréter.

```text
               Modèle
                 │
                 │ propose
                 ▼
          Demande d'outil
                 │
                 ▼
              Harness
                 │
      vérifie / contrôle / route
                 │
                 ▼
            Permission
                 │
                 ▼
               Outil
                 │
                 ▼
          Environnement réel
```

Le harness peut notamment vérifier :
- que l'outil demandé existe ;
- qu'il est exposé dans la session ;
- que les paramètres sont valides ;
- que l'action n'est pas interdite ;
- que les conditions d'autorisation sont satisfaites.

La règle mentale à retenir est :
**Intention ≠ Autorisation ≠ Exécution**

---

# 5. Le tour agentique et l'itération

Il faut distinguer deux niveaux : le tour et l'itération.

### Le tour agentique

Le tour correspond à la trajectoire complète déclenchée par une demande utilisateur.

Il commence lorsqu'une nouvelle demande entre dans la boucle et peut se terminer lorsqu'il y a :
- une réponse finale ;
- une réussite suffisamment vérifiée ;
- un blocage ;
- une suspension ;
- une interruption ;
- une erreur non récupérable.

```text
Utilisateur
    │
    ▼
┌──────────────────────────────┐
│ Tour agentique               │
│                              │
│ Itération 1                  │
│ Itération 2                  │
│ Itération 3                  │
│ ...                          │
└──────────────┬───────────────┘
               │
               ▼
        Fin / suspension
```

### L'itération

Une itération est un passage interne de la boucle.

```text
Assembler le contexte
        │
        ▼
Appeler le modèle
        │
        ▼
Traiter sa sortie
        │
        ▼
Action éventuelle
        │
        ▼
Récupérer l'observation
        │
        ▼
Préparer l'itération suivante
```

Le modèle ne repart donc pas nécessairement de zéro à chaque étape. Il reçoit une vue actualisée de l'état du travail.

---

# 6. La pipeline interne d'une itération

Chaque itération suit une pipeline relativement stable.

### 6.1 Préparer l'état de décision

Le système détermine les éléments nécessaires au tour :
- instructions actives ;
- contexte utilisateur ;
- configuration du modèle ;
- mode d'autorisation ;
- callbacks ;
- signal d'interruption ;
- options de configuration utiles.

La boucle maintient également un état mutable contenant les informations nécessaires à la poursuite du travail.

### 6.2 Assembler le contexte utile

Le système prépare ce qui doit être visible par le modèle pour la prochaine décision :
- la demande utilisateur ;
- les instructions applicables ;
- les observations déjà obtenues ;
- l'état de progression ;
- les informations nécessaires à la cohérence du tour.

Le modèle ne décide donc pas à partir d'une vision abstraite et totale du projet. Il décide à partir du contexte que la boucle lui présente à un instant donné.

### 6.3 Appeler le modèle

Le modèle reçoit :

```text
Contexte assemblé
        +
Surface d'outils disponible
        │
        ▼
      Modèle
```

Sa sortie peut mener soit à une réponse finale, soit à une demande d'outil.

### 6.4 Traiter la sortie

```text
Sortie du modèle
        │
        ├────► Réponse textuelle ───► réponse finale possible
        │
        └────► Tool request ────────► permissions / exécution
```

### 6.5 Réintégrer le résultat

Après l'exécution ou le refus, le résultat revient dans l'état opérationnel.

```text
Résultat outil
      │
      ▼
Observation
      │
      ▼
Nouvel état
      │
      ▼
Nouvel appel du modèle
```

La pipeline reste relativement stable, mais la trajectoire peut changer à chaque observation.

---

# 7. La demande d'outil : entre langage et action

La demande d'outil est le mécanisme qui permet au modèle de sortir de la simple production textuelle.

Elle indique que la prochaine étape pertinente est une action intermédiaire contrôlée.

Elle peut servir à :
- obtenir une information ;
- lire un fichier ;
- lancer une commande ;
- modifier un état ;
- interroger une ressource ;
- produire un signal de vérification.

Une demande d'outil est une forme intermédiaire entre langage et action.

```text
Langage du modèle
      │
      ▼
Intention opératoire structurée
      │
      ▼
Harness
      │
      ▼
Permission
      │
      ▼
Exécution réelle
```

Elle n'est ni une phrase ordinaire ni une exécution directe.

### Issues possibles d'une demande d'outil

Une demande peut :
- être autorisée et exécutée ;
- être refusée ;
- demander une validation humaine ;
- échouer pendant l'exécution ;
- produire un résultat vide ;
- produire une sortie trop volumineuse ;
- produire une observation ambiguë.

Dans tous ces cas, la boucle transforme l'événement en information exploitable pour la suite.

---

# 8. L'observation comme moteur de progression

L'observation est le retour produit par l'environnement après une action ou une tentative d'action.

Elle peut prendre de nombreuses formes :
- contenu d'un fichier ;
- sortie d'une commande ;
- diagnostic ;
- erreur ;
- résultat de test ;
- diff ;
- état Git ;
- refus de permission ;
- information provenant d'un service externe.

```text
Action
  │
  ▼
Environnement
  │
  ▼
Observation
  │
  ▼
Nouvelle décision
```

L'observation possède un statut particulier : elle ne vient pas simplement de la génération du modèle. Elle fournit un signal issu du système ou de l'environnement réel.

Sans observation, la boucle reste largement spéculative.

Avec une observation, elle peut :
- confirmer une hypothèse ;
- réfuter une hypothèse ;
- découvrir une nouvelle contrainte ;
- changer de stratégie ;
- déclencher une sous-opération ;
- arrêter la trajectoire si l'objectif est atteint.

### L'échec comme information

Une erreur n'est pas forcément une fin.

```text
Hypothèse
   │
   ▼
Action
   │
   ▼
❌ Erreur
   │
   ▼
Observation
   │
   ▼
Réévaluation
   │
   ▼
Nouvelle stratégie
```

Une erreur de test, un diagnostic de compilation, un refus de permission ou l'absence d'un fichier peuvent devenir des signaux à forte valeur décisionnelle.

---

# 9. La vérification ferme la trajectoire

La vérification occupe une place particulière car elle apporte un signal externe sur la qualité du travail effectué.

Une réponse cohérente produite par le modèle n'est pas automatiquement une preuve de réussite.

Dans un contexte de développement, la vérification peut prendre la forme de :
- tests ;
- build ;
- typecheck ;
- linter ;
- inspection du diff ;
- état Git ;
- résultat d'une commande.

```text
Modification
    │
    ▼
Vérification
    │
    ├────► ❌ problème
    │          │
    │          ▼
    │      correction
    │
    └────► ✅ résultat satisfaisant
               │
               ▼
             arrêt
```

La vérification n'est pas un supplément ajouté après coup. Elle appartient à la boucle elle-même.

Elle fournit :
- une condition de progression ;
- une condition de correction ;
- une condition d'arrêt.

---

# 10. Les transitions internes de la boucle

Après chaque appel au modèle ou chaque résultat d'outil, la boucle doit déterminer l'état suivant.

Les principales transitions sont :

**Réponse finale**
Le modèle ne demande pas d'outil supplémentaire et produit une réponse destinée à l'utilisateur.

**Action**
Le modèle demande un outil, l'action est autorisée puis exécutée, et le résultat est intégré à l'état.

**Blocage**
La continuation automatique devient impossible à cause :
- d'un refus ;
- d'une contrainte ;
- d'une erreur non récupérable ;
- d'un besoin de validation humaine.

**Réorientation**
Le résultat d'un outil contredit ou modifie la trajectoire initiale.

```text
                 Sortie / observation
                         │
           ┌─────────────┼─────────────┐
           ▼             ▼             ▼
       Répondre        Continuer      Bloquer
                           │
                           ▼
                       Réorienter
```

La boucle n'est donc pas un simple while naïf. Elle doit gérer plusieurs types d'états : décision, action, permission, erreur, attente, interruption et réponse finale.

---

# 11. Permissions et contrôle

Le système de permissions intervient au moment où une intention doit devenir une opération réelle.

```text
Modèle
  │
  ▼
Tool request
  │
  ▼
Permission System
  │
  ├──── Allow ───► exécution
  │
  ├──── Ask ─────► validation humaine
  │
  └──── Deny ────► refus
```

Toutes les actions n'ont pas les mêmes conséquences.

Lire une information, modifier un fichier, exécuter une commande, accéder au réseau ou contacter un service externe peuvent nécessiter des niveaux de contrôle différents.

Un refus n'est pas nécessairement la fin du tour.

```text
Demande
   │
   ▼
Refus
   │
   ▼
Observation
   │
   ├────► autre stratégie
   ├────► demande de validation
   └────► clôture explicite
```

La boucle agentique représente donc une délégation contrôlée, et non une délégation inconditionnelle au modèle.

---

# 12. Le rôle de l'utilisateur dans la boucle

L'utilisateur n'est pas extérieur au cycle agentique.

Il peut :
- fournir du contexte ;
- approuver une action ;
- refuser une action ;
- interrompre la trajectoire ;
- limiter le périmètre ;
- imposer une stratégie de vérification ;
- demander davantage de justification ;
- redéfinir la condition de réussite.

```text
                    Utilisateur
                   /     |      \
                  /      |       \
             approuve  corrige  interrompt
                  \      |       /
                   \     |      /
                    Agent Loop
```

Cette organisation combine :
**Autonomie locale du modèle + Autorité de contrôle du système + Autorité finale de l'utilisateur**

---

# 13. Les conditions d'arrêt

Une boucle agentique doit posséder des conditions d'arrêt.

Sans elles, le système pourrait continuer à demander des actions sans nécessité.

La boucle peut s'arrêter ou se suspendre lorsque :
- le modèle produit une réponse finale ;
- une observation fournit un critère suffisant de réussite ;
- une validation humaine est nécessaire ;
- une action indispensable est refusée ;
- une erreur non récupérable intervient ;
- une limite est atteinte ;
- l'utilisateur interrompt explicitement le tour.

```text
                  Agent Loop
                      │
       ┌──────────────┼──────────────┐
       ▼              ▼              ▼
    Réussite        Blocage      Interruption
       │              │              │
       ▼              ▼              ▼
      STOP           STOP           STOP

                      ou

               Besoin d'agir
                      │
                      ▼
                   CONTINUE
```

La réponse finale n'est donc qu'une forme d'arrêt parmi plusieurs.

---

# 14. Boucle agentique vs échange conversationnel

Un échange conversationnel classique peut être résumé par :
**Utilisateur → Modèle → Réponse**

Une boucle agentique suit une structure plus riche :

```text
Utilisateur
    │
    ▼
Objectif
    │
    ▼
Modèle
    │
    ▼
Décision
    │
    ▼
Contrôle
    │
    ▼
Action
    │
    ▼
Observation
    │
    ▼
Réévaluation
    │
    └──────────────► nouvelle décision
```

La présence d'outils ne suffit pas à rendre un système agentique.

L'agenticité vient de la continuité entre :
**Décision → Action → Observation → Réorientation**

C'est cette continuité qui permet à Claude Code de confronter ses décisions à l'état réel du projet, de corriger sa trajectoire et de poursuivre jusqu'à une condition d'arrêt.

---

# Tableau récapitulatif

| Élément | Description |
|---|---|
| **Utilisateur** | Définit l'objectif, fournit du contexte et conserve la capacité d'autoriser, refuser, corriger ou interrompre. |
| **Surface Layer** | Point d'entrée : CLI, IDE, Desktop, navigateur, mode headless ou SDK. |
| **Agent Loop** | Cœur de la trajectoire agentique. Coordonne les itérations et décide s'il faut continuer ou s'arrêter. |
| **Modèle** | Produit une décision : réponse textuelle ou demande d'outil. |
| **Harness** | Orchestre, contrôle, valide et route les demandes d'action. |
| **Tool request** | Intention structurée d'utiliser un outil. |
| **Permission System** | Autorise, demande validation ou refuse l'action. |
| **Outil** | Réalise concrètement l'opération demandée. |
| **Environnement** | Système sur lequel l'outil agit : fichiers, shell ou ressource externe. |
| **Observation** | Retour de l'environnement intégré à l'itération suivante. |
| **State Layer** | Conserve les éléments utiles à la continuité du tour. |
| **Context Assembly** | Construit le contexte visible par le modèle pour une décision donnée. |
| **Compaction** | Réduit ou résume le contexte lorsque nécessaire. |
| **Vérification** | Produit un signal externe permettant de confirmer ou corriger la trajectoire. |
| **Tour agentique** | Trajectoire complète initiée par une demande utilisateur. |
| **Itération** | Un cycle interne : contexte → modèle → action éventuelle → observation. |
| **Condition d'arrêt** | Événement qui clôt, suspend ou interrompt le tour. |

# Les 5 points les plus importants

1. La boucle agentique transforme une demande en trajectoire, pas seulement en réponse textuelle.
2. Le modèle décide mais n'exécute pas directement : le harness, les permissions et les outils séparent intention et effet réel.
3. L'observation est le moteur de progression : chaque résultat, erreur ou refus peut modifier la décision suivante.
4. La vérification fait partie de la boucle : tests, build, typecheck, linter ou diff permettent de confirmer la réussite.
5. L'autonomie reste contrôlée : le système de permissions et l'utilisateur conservent l'autorité sur les actions et les conditions d'arrêt.

# Carte mentale

```text
La boucle agentique de Claude Code
│
├── Entrée
│   ├── Utilisateur
│   └── Surface
│
├── Cœur
│   ├── Agent Loop
│   ├── État
│   ├── Context Assembly
│   └── Compaction
│
├── Décision
│   └── Modèle
│       ├── Réponse finale
│       └── Tool request
│
├── Contrôle
│   ├── Harness
│   ├── Permission System
│   │   ├── Allow
│   │   ├── Ask
│   │   └── Deny
│   └── Intervention utilisateur
│
├── Action
│   ├── Built-in Tools
│   ├── MCP Tools
│   ├── Shell
│   └── Environnement
│
├── Observation
│   ├── Résultat
│   ├── Erreur
│   ├── Refus
│   ├── Test
│   └── Diff
│
├── Réévaluation
│   ├── Continuer
│   ├── Corriger
│   ├── Réorienter
│   └── Vérifier
│
└── Arrêt
    ├── Réussite
    ├── Réponse finale
    ├── Refus
    ├── Erreur
    ├── Suspension
    └── Interruption
```

# Mini fiche de révision

- **Boucle agentique** → mécanisme qui maintient une trajectoire entre décisions, actions et observations
- **Agent Loop** → cœur qui orchestre les itérations d'un tour
- **Tour agentique** → trajectoire complète déclenchée par une demande utilisateur
- **Itération** → contexte → modèle → décision → action éventuelle → observation
- **Modèle** → décide de la prochaine opération pertinente
- **Harness** → orchestre et contrôle le passage de l'intention à l'action
- **Tool request** → demande structurée d'action produite par le modèle
- **Permission** → décide si l'action peut réellement être exécutée
- **Outil** → composant qui réalise l'opération concrète
- **Observation** → retour externe réinjecté dans la boucle
- **État** → informations nécessaires à la continuité du tour
- **Context Assembly** → sélection des informations transmises au modèle
- **Vérification** → signal externe permettant de confirmer ou invalider la trajectoire
- **Refus** → observation de contrôle pouvant provoquer une réorientation
- **Condition d'arrêt** → réussite, réponse finale, refus, erreur, suspension, limite ou interruption
- **Agenticité** → continuité entre décision, action, observation et réorientation

> **Phrase à retenir** : Le modèle décide, le harness orchestre et contrôle, les outils exécutent, l'environnement répond, puis la boucle utilise cette observation pour décider de la suite.
