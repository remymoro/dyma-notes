---
title: "Formuler les premières demandes : exploration vague et demande précise"
description: "Apprendre à formuler une demande exploratoire ou une instruction précise dans Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - prompts
  - cli
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-decouverte-premieres-commandes-cli
leçon: 03-premieres-demandes-exploration-vague-demande-precise
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-22
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Pourquoi une session commence-t-elle en lecture seule ? | Pour vérifier que Claude comprend le bon contexte avant de lui déléguer une modification — une mauvaise hypothèse au début peut polluer toute la suite de la session. |
| "Améliore src/main.js" vs "Regarde src/main.js sans le modifier, que changerais-tu ?" — quelle différence ? | Le contenu est comparable (les deux sont ouvertes), mais la seconde **interdit explicitement l'écriture**. C'est cette interdiction, pas la précision du fond, qui rend une demande vague sûre plutôt que dangereuse. |
| Pourquoi demander un plan avant l'implémentation, même si le problème semble déjà cadré ? | Le plan est un point de contrôle bon marché : une mauvaise interprétation coûte beaucoup moins cher à corriger dans un texte que dans un diff déjà écrit. |
| Pourquoi `/btw` ne doit-il jamais servir à changer le périmètre d'une tâche ? | `/btw` est conçu pour des questions informatives sans conséquence — il n'a pas la structure (contraintes, justification, vérification) nécessaire pour porter une décision aussi lourde qu'élargir ce que Claude peut toucher. |
| Pourquoi exiger une preuve plutôt qu'un résumé de confiance ? | Un résumé peut être plausible sans être vrai. Seule une preuve externe (commande exécutée, résultat, ce qui n'a pas été vérifié) confirme réellement le travail. |
| Que contiennent les 3 niveaux de demande ? | Niveau 1 (trop vague) : aucun cadre. Niveau 2 (incomplet) : problème posé mais sans fichier/contraintes/vérification/définition de terminé. Niveau 3 (exploitable) : les quatre réunis. |
| Que doit contenir une "définition de terminé" ? | Le comportement attendu visible, les tests lancés, la vérification manuelle décrite, le diff résumé, et les limites restantes indiquées. |
| Comment distinguer faits, hypothèses et recommandations ? | Fait = ce qui a été réellement lu dans le code. Hypothèse = déduction raisonnable non prouvée. Recommandation = proposition pour plus tard. Séparer les trois évite de confondre observation et opinion. |

## Synthèse
Une première session productive commence toujours par de la lecture encadrée : arborescence, scripts, README, code, tests, fichiers critiques, puis une carte et une synthèse courtes. Ensuite, la qualité d'une demande ne se juge pas à sa précision de contenu mais à sa capacité à poser un cadre — une demande vague reste sûre tant qu'elle interdit explicitement l'écriture. Avant toute implémentation réelle, un plan permet de corriger une mauvaise interprétation à moindre coût, et `/btw` ne doit jamais servir à élargir discrètement un périmètre. Enfin, la confiance ne remplace jamais la preuve : un résumé plausible n'est pas un résumé vrai.

## Glossaire
- **Session en lecture seule** : phase où Claude peut lire et analyser, mais ne peut ni créer, ni modifier, ni exécuter de commande d'écriture.
- **Carte du dépôt** : synthèse structurée (rôle, pile technique, fichiers principaux, commandes, risques) produite après une lecture progressive.
- **Fichier critique** : fichier dont une mauvaise modification aurait un impact disproportionné (logique métier, tests, scripts).
- **Demande vague utile** : demande ouverte qui interdit explicitement toute modification — sert à explorer sans risque.
- **Demande vague dangereuse** : demande ouverte qui n'interdit rien — peut déclencher une écriture non cadrée.
- **Piste** : proposition d'action identifiée pendant l'exploration, pas encore une tâche formalisée.
- **Plan** : séquence de 2-3 étapes proposée avant toute écriture, servant de point de contrôle.
- **Demande précise** : demande qui indique le fichier, le problème, les contraintes, la vérification et la définition de terminé.
- **Définition de terminé** : liste explicite des critères qui font qu'une tâche est réellement achevée.
- **Preuve** : élément vérifiable (commande exécutée, résultat, diff, comportement observé) démontrant qu'un travail a été fait, distinct d'un résumé de confiance.
- **`/btw`** : commande pour poser une question courte et latérale à partir du contexte déjà présent, sans changer la tâche en cours.
- **Périmètre** : ensemble des fichiers et zones qu'une tâche est autorisée à toucher.
- **Faits / hypothèses / recommandations** : trois niveaux à séparer dans une analyse de dépôt — observé, déduit, proposé.

## Questions d'auto-évaluation
1. Pourquoi vérifier `pwd`, `ls` et `git status` avant même de lancer Claude Code ?
2. Que doit poser la toute première demande envoyée à Claude ?
3. Dans quel ordre lit-on progressivement le dépôt, et pourquoi cet ordre ?
4. Pourquoi confronter le README aux fichiers réels plutôt que de le résumer tel quel ?
5. Qu'est-ce qu'un fichier critique, et comment le repérer ?
6. Pourquoi demander à Claude s'il existe une stratégie de logging ou d'authentification, alors qu'on sait déjà que non ?
7. Quelle est la différence entre un fait, une hypothèse et une recommandation ?
8. Pourquoi limiter explicitement le périmètre de lecture si Claude explore trop loin ?
9. Qu'est-ce qui distingue une demande vague utile d'une demande vague dangereuse ?
10. Que manque-t-il au niveau 2 ("Corrige le comportement quand le champ est vide") pour devenir exploitable ?
11. Pourquoi demander un plan en 3 étapes avant d'autoriser l'implémentation ?
12. Que doit contenir une demande finale prête à exécuter ?
13. Pourquoi `/btw` est-il dangereux pour changer le périmètre d'une tâche ?
14. Que doit contenir une définition de terminé ?
15. Pourquoi une preuve est-elle plus fiable qu'un résumé de confiance ?

# Formuler les premières demandes : exploration vague et demande précise

**Durée : 17 minutes**

**Commande :** `/btw`

## Objectif de la leçon

Cette leçon apprend à graduer une session avec Claude Code en trois temps : **lire** le dépôt progressivement sous cadrage strict, **explorer** des pistes avec des demandes vagues mais sécurisées, puis **transformer** une piste en demande précise validée par un plan avant toute écriture réelle. Le fil conducteur : ce n'est jamais le contenu d'une demande qui la rend sûre, c'est le cadre qu'elle pose.

---

# 1. Pourquoi une première session en lecture seule

Claude Code peut lire, exécuter des commandes, proposer des changements et modifier des fichiers. Avant de lui déléguer une correction, il faut vérifier qu'il comprend le bon contexte — une mauvaise hypothèse au début peut polluer toute la suite de la session.

```text
Revenir à la racine (pwd, ls, git status)
        │
        ▼
Lancer claude depuis la racine du dépôt
        │
        ▼
Cadrer explicitement : lecture autorisée, écriture interdite
```

---

# 2. Lire le dépôt progressivement

```text
Arborescence
    │
    ▼
package.json (scripts, type de module, dépendances)
    │
    ▼
README.md (comparé aux fichiers réels, pas juste résumé)
    │
    ▼
src/ (rôle, fonctions, hypothèses, risques)
    │
    ▼
test/ (couvert vs cas limites non testés)
    │
    ▼
Fichiers critiques (poids de responsabilité)
    │
    ▼
Carte courte du dépôt
    │
    ▼
Synthèse exploitable (+ 1 piste + preuve à demander)
```

Chaque étape a un objectif précis : l'arborescence donne une carte générale, `package.json` révèle les commandes réelles, le README doit être **confronté** aux fichiers (pas juste répété), le code source expose les hypothèses et les risques, les tests révèlent ce qui est prouvé et ce qui ne l'est pas.

Si la réponse de Claude reste trop générale, on le recadre : *"Précise ta réponse en citant les fichiers réels du dépôt."*

---

# 3. Vérifier ce que Claude affirme

Une carte de dépôt peut contenir des erreurs ou des inventions. Il faut les corriger immédiatement, et tester la rigueur de Claude sur des éléments absents du projet :

```text
"Y a-t-il une stratégie de logging dans ce projet ?"
"Ce projet contient-il un flux d'authentification ?"
        │
        ▼
Bonne réponse : "Non, et voici pourquoi"
        │
        ▼
Mauvaise réponse : Claude invente une architecture absente
```

Dans ce mini-projet, il n'y a ni logging structuré, ni authentification. Un Claude qui invente un middleware, une session ou un token à partir de rien est un signal d'alerte : il ne faut jamais le laisser construire sur une hypothèse fausse.

---

# 4. Distinguer faits, hypothèses et recommandations

```text
Fait
→ src/conversion.js exporte une fonction de conversion
  (réellement lu dans le code)

Hypothèse
→ le projet sert de démonstration
  (déduction raisonnable, non prouvée)

Recommandation
→ ajouter une gestion explicite des entrées invalides
  (proposition pour plus tard)
```

Séparer ces trois niveaux évite de confondre une observation directe avec une opinion — un piège fréquent quand un agent lit un dépôt entier d'un coup.

---

# 5. Le critère qui décide : interdiction d'écrire, pas précision du fond

```text
"Améliore src/main.js."
        │
        ▼
   aucune limite posée
        │
        ▼
   Claude peut ÉCRIRE directement
        │
        ▼
   DANGEREUX


"Regarde src/main.js sans le modifier,
 que changerais-tu ?"
        │
        ▼
   écriture explicitement interdite
        │
        ▼
   Claude peut seulement OBSERVER / PROPOSER
        │
        ▼
   UTILE — tu restes décideur
```

Les deux demandes sont aussi vagues l'une que l'autre sur le fond. Ce qui les sépare, c'est uniquement la présence ou l'absence d'une interdiction explicite de modifier.

---

# 6. Les trois niveaux de demande

```text
Niveau 1 — trop vague
"Améliore le convertisseur."
→ aucun fichier, aucune contrainte, aucune preuve

Niveau 2 — incomplet
"Corrige le comportement quand le champ est vide."
→ problème posé, mais pas de fichier/contraintes/vérif/terminé

Niveau 3 — exploitable
Fichier ciblé + Contraintes + Vérification + Définition de terminé
→ prêt pour une implémentation réelle
```

Le niveau 3 est la cible : il laisse Claude agir, mais dans un cadre clair.

---

# 7. Du plan à la demande finale : un checkpoint avant l'écriture

```text
Piste choisie
      │
      ▼
Demande de PLAN (3 étapes max)
      │
      ▼
Erreur d'interprétation ? → corrigée ICI, en texte, gratuitement
      │
      ▼
Plan validé
      │
      ▼
Demande FINALE (fichier, contraintes, vérification, résumé attendu)
      │
      ▼
Implémentation réelle
```

Sauter cette étape revient à découvrir une mauvaise interprétation **après coup**, dans un diff déjà écrit — beaucoup plus coûteux à corriger qu'un plan mal formulé.

---

# 8. /btw : question latérale, jamais un changement de périmètre

```text
/btw
→ question courte, informative, sans conséquence
→ PAS de contraintes, PAS de vérification, PAS de justification


Changement de périmètre
→ nouvelle contrainte + justification exigée + vérification
→ DOIT passer par la conversation principale
```

`/btw Finalement, modifie aussi src/conversion.js.` a l'air anodin — c'est justement le problème : cette formulation légère autorise en fait Claude à toucher un fichier jusque-là protégé, sans le débat que mériterait cette décision.

---

# 9. Forcer la définition de terminé et exiger une preuve

```text
Résumé de confiance
"J'ai corrigé le bug, tout fonctionne."
        │
        ▼
   PLAUSIBLE ≠ VRAI


Preuve demandée
1. commande exacte exécutée
2. résultat de cette commande
3. fichiers modifiés
4. comportement vérifié
5. ce qui N'A PAS été vérifié
        │
        ▼
   VÉRIFIABLE
```

Sans définition de terminé explicite, Claude peut considérer le travail fini après avoir simplement écrit du code — ce n'est pas suffisant. Le point 5 (ce qui n'a pas été vérifié) est le plus important : il révèle les angles morts plutôt que de les cacher derrière une confiance affichée.

---

# 10. Garder une session propre

```text
Un seul sujet à la fois
        │
        ▼
"la gestion d'une entrée vide ou invalide"
        │
        ▼
Explicitement refusé pour cette session :
CSS, nouvelle API, refonte HTML,
changement de src/conversion.js, nouvelle fonctionnalité
```

Une bonne première modification doit être assez petite pour être comprise, vérifiée et annulée facilement.

---

# 11. Ancrage sur ta stack (web front/back JS-TS)

Sur un vrai projet front/back, cette progression se transpose directement :

- avant de demander une correction sur un composant React ou un endpoint API, fais lire à Claude le fichier concerné **et ses tests existants**, en lecture seule, avant d'autoriser l'écriture ;
- pour une première exploration d'un module que tu ne connais pas bien, utilise le même garde-fou : *"regarde X sans le modifier, que changerais-tu ?"* plutôt que *"améliore X"* ;
- avant une modification touchant une règle métier (validation de formulaire, calcul de prix, permission), demande systématiquement un plan en 2-3 étapes — le coût de relire un plan est nul comparé à celui de défaire un diff sur du code partagé en équipe ;
- ne laisse jamais une demande `/btw` élargir discrètement ce que Claude est autorisé à toucher sur un dépôt de production.

---

# Résumé & Schéma global

```text
Lecture cadrée      Exploration          Piste choisie       Plan          Demande finale
(arborescence   →   vague MAIS       →   (contraintes    →  (checkpoint →  (fichier,
→ scripts →         écriture             de sélection)       avant         contraintes,
README → src →      interdite)                                écriture)     vérification,
tests → critiques)                                                          terminé, preuve)
```

# Tableau des commandes à retenir

| Élément | Rôle |
|---|---|
| Cadrage lecture seule | Interdit explicitement toute création, modification ou commande d'écriture |
| Carte courte du dépôt | Rôle, pile technique, fichiers principaux, commandes, risques visibles |
| Synthèse exploitable | Résumé + 1 modification recommandée + preuve à demander |
| Demande vague utile | Ouverte, mais interdit explicitement l'écriture |
| Plan (3 étapes max) | Point de contrôle textuel avant toute écriture réelle |
| Définition de terminé | Critères explicites qui closent une tâche |
| Preuve | Commande exécutée + résultat + ce qui n'a pas été vérifié |
| `/btw` | Question courte et latérale — jamais un changement de périmètre |

# Les 5 points les plus importants

## 1. Ce n'est pas le contenu qui rend une demande sûre, c'est le cadre
Une demande vague reste utile tant qu'elle interdit explicitement l'écriture ; sans cette limite, elle devient dangereuse.

## 2. Lire progressivement avant de faire confiance
Arborescence → scripts → README confronté aux faits → code → tests → fichiers critiques, dans cet ordre.

## 3. Toujours passer par un plan avant l'implémentation
Corriger une mauvaise interprétation en texte coûte infiniment moins cher qu'en diff déjà écrit.

## 4. `/btw` ne porte jamais un changement de périmètre
Un élargissement de ce que Claude peut toucher doit passer par la conversation principale, avec justification et vérification.

## 5. Exiger une preuve, pas un résumé de confiance
Un résumé peut être plausible sans être vrai ; seule une preuve externe (commande, résultat, angles morts) confirme le travail.

---

# Carte mentale

```text
Première session en lecture seule
│
├── Se positionner
│   ├── pwd / ls / git status
│   └── claude (depuis la racine)
│
├── Cadrer
│   └── lecture autorisée, écriture interdite
│
├── Lire progressivement
│   ├── arborescence
│   ├── package.json
│   ├── README (confronté aux faits)
│   ├── src/ (rôle, hypothèses, risques)
│   ├── test/ (couvert vs cas limites)
│   └── fichiers critiques
│
├── Vérifier / distinguer
│   ├── faits vs hypothèses vs recommandations
│   └── tester si Claude invente (logging, auth)
│
├── Graduer la demande
│   ├── Niveau 1 : trop vague
│   ├── Niveau 2 : incomplet
│   └── Niveau 3 : exploitable
│
├── Avant d'écrire
│   ├── plan (3 étapes max)
│   ├── recadrer si trop large
│   └── demande finale (fichier, contraintes, vérif, terminé)
│
├── /btw
│   ├── question latérale OK
│   └── changement de périmètre INTERDIT
│
└── Après exécution
    ├── définition de terminé
    └── preuve (commande, résultat, non-vérifié)
```

---

# Mini fiche de révision

```text
1. pwd / ls / git status       → vérifier avant de lancer claude
2. Cadrage lecture seule        → interdiction explicite d'écrire
3. Lecture progressive          → arbo → scripts → README → src → tests → critiques
4. Vague utile                  → interdit l'écriture
   Vague dangereuse             → n'interdit rien
5. Niveau 3 exploitable         → fichier + contraintes + vérif + terminé
6. Plan avant écriture          → checkpoint bon marché
7. /btw                         → question latérale, JAMAIS le périmètre
8. Définition de terminé        → critères explicites de fin
9. Preuve                       → commande + résultat + non-vérifié
   ≠ résumé de confiance
```

## Phrase à retenir

> Une bonne première session ne demande pas à Claude d'agir vite — elle lui apprend à prouver qu'il a compris, avant d'écrire.
