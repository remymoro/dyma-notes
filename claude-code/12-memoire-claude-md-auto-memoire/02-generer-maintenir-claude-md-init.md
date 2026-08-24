---
title: "Générer et maintenir CLAUDE.md avec /init"
description: "Comment utiliser /init pour créer une mémoire de projet et comment la nettoyer."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - claude-md
  - init
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 02-generer-maintenir-claude-md-init
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **À quoi sert la commande `/init` ?** | Elle génère une première **ébauche** du fichier `CLAUDE.md` en analysant la base de code pour trouver des commandes (`npm run...`) et des conventions visibles. |
| **Faut-il accepter le fichier généré tel quel ?** | **Jamais**. `/init` est une proposition, pas une autorité. Il faut toujours relire, raccourcir et corriger le fichier (Claude peut deviner un `npm run test` générique au lieu du script officiel de CI). |
| **Qu'est-ce que Claude ne peut *pas* deviner avec `/init` ?** | Les décisions d'équipe hors code : la vraie commande officielle, les contraintes d'environnement, les règles de PR, les erreurs passées, et surtout **les migrations en cours** (le vieux code est toujours visible). |
| **Quelle est la méthode en 3 passes après `/init` ?** | 1. **Supprimer** : les généralités, docs d'API, tutoriels et doublons.<br>2. **Préciser** : changer les "fais attention à" en instructions concrètes.<br>3. **Compléter** : ajouter les pièges, migrations et commandes officielles. |
| **Que fait la variable d'environnement `CLAUDE_CODE_NEW_INIT=1` ?** | Elle active un flux interactif expérimental (multi-phases) où un sous-agent explore le code et vous pose des questions avant de rédiger le `CLAUDE.md`. |

## Synthèse
La commande `/init` est un excellent point de départ pour générer la mémoire d'un projet (`CLAUDE.md`), car elle scanne le code pour détecter des commandes standards et des conventions. Cependant, le fichier produit n'est qu'un brouillon qu'il faut obligatoirement "raffiner". La première étape (souvent oubliée) consiste à **supprimer** tout le bruit : descriptions fichier par fichier, copier-coller de README, etc. Il faut ensuite **préciser** les règles vagues (remplacer "teste bien" par la vraie commande `pnpm test:unit`) et **compléter** avec ce que l'IA ne peut pas deviner, comme les migrations en cours ou les gotchas d'équipe. Un fichier `CLAUDE.md` doit être traité comme du code : relu en PR, nettoyé de sa dette technique, et gardé aussi court et actionnable que possible.

## Glossaire
- **`/init`** : Commande interne de Claude Code pour bootstraper ou proposer des améliorations à `CLAUDE.md`.
- **Règles vagues** : Instructions non vérifiables ("respecte le style") qui diluent le contexte. À remplacer par des actions concrètes.
- **Migration partielle** : Quand un dépôt contient à la fois l'ancien et le nouveau pattern de code. Un danger majeur pour l'IA, qui doit être explicitement documenté dans le `CLAUDE.md`.
- **`CLAUDE_CODE_NEW_INIT=1`** : Flag activant un processus d'initialisation interactif avec un sous-agent.

## Questions d'auto-évaluation
1. Après un `/init`, Claude a généré 150 lignes décrivant le rôle de chaque dossier du projet. Que dois-je faire ?
2. L'équipe vient de changer de framework de test (Jest vers Vitest). La moitié des fichiers utilisent encore Jest. Comment le dire à Claude ?
3. Que faire de l'instruction générée "Garde le code propre et lisible" ?
4. Si je veux utiliser le nouveau flux interactif de génération, quelle commande dois-je lancer ?

# Générer et maintenir CLAUDE.md avec `/init`

**Durée : 20 minutes**

## Objectif de la leçon
Savoir utiliser la commande `/init` pour démarrer, mais surtout comprendre la méthode de raffinement indispensable (Supprimer, Préciser, Compléter) pour transformer ce brouillon généré par l'IA en une véritable mémoire de projet efficace.

---

# 1. Le vrai rôle de `/init`

La commande `/init` sert à éviter la page blanche. Elle scanne votre `package.json`, votre structure de dossier, et tente de deviner les commandes et conventions du projet.

> [!WARNING]
> **Ne jamais commit le résultat direct de `/init`**
> `/init` est une proposition, pas une autorité. Il va souvent deviner une commande "logique" (`npm run test`) alors que votre équipe utilise un script spécifique (`pnpm test:ci`). Il va aussi lister des évidences que Claude peut lire tout seul.

### Le flux interactif (`CLAUDE_CODE_NEW_INIT=1`)
Si vous lancez `CLAUDE_CODE_NEW_INIT=1 claude`, puis `/init`, vous activez un sous-agent interactif. Il va explorer votre dépôt et vous poser des questions pour combler ses manques. Vos réponses doivent rester courtes et ciblées (ne rédigez pas toute la doc dans le chat !).

---

# 2. La méthode de raffinement en 3 passes

Dès que `/init` a fini son travail, ouvrez `CLAUDE.md` et appliquez cette méthode :

### Passe 1 : Supprimer (L'erreur commune)
Beaucoup d'équipes ajoutent immédiatement du texte. C'est l'inverse qu'il faut faire :
- **Supprimez** les descriptions "fichier par fichier".
- **Supprimez** les copiés-collés de la documentation API.
- **Supprimez** les phrases génériques ("sois pro").
*Rappel : Claude lit très bien le code tout seul, ne lui répétez pas ce qui est évident.*

### Passe 2 : Préciser (Rendre actionnable)
Une règle qui n'est pas vérifiable est inutile.
- *Faible :* "Respecte le style du projet."
- *Meilleur :* "Utilise pnpm, pas npm. Lance `pnpm test:unit` pour vérifier ton code."
- *Faible :* "Ne casse pas l'authentification."
- *Meilleur :* "Ne modifie pas `src/auth/session.ts` sans lancer le test ciblé `auth.session.test.ts`."

### Passe 3 : Compléter (L'invisible)
Ajoutez ce que le code ne dit pas :
- Les **contraintes environnementales** (Comment lancer la base locale ?).
- Les **décisions d'équipe** (Workflow de Pull Request).
- Les **Gotchas** récurrents (Les pièges de votre infrastructure).

---

# 3. Le danger absolu : Les Migrations Partielles

C'est le pire ennemi de l'agent. Si vous migrez de `ClientA` vers `ClientB`, pendant des mois, les deux coexistent dans le code.
Quand Claude cherche un exemple, il a 80% de chances de tomber sur l'ancien pattern (le plus présent) et de le recopier.

**Votre `CLAUDE.md` doit contenir un bloc explicite pour ce cas :**
```text
## Migrations en cours
Le projet migre vers src/lib/api-client.ts.
- A utiliser pour tout nouveau code : src/lib/api-client.ts
- A ne plus utiliser : src/legacy/request.ts (conservé pour rétrocompatibilité)
```

---

# 4. Traiter `CLAUDE.md` comme du code

Un fichier de mémoire est un fichier de configuration.
- Il doit être **relu en Pull Request** par l'équipe.
- Il doit être **testé** (demandez une tâche simple à Claude et vérifiez s'il applique les règles du fichier).
- Il doit être **nettoyé**. Une règle obsolète (ex: "attention au bug de la librairie X" alors que la lib a été mise à jour) devient une *dette contextuelle*.

---

# Cartes mentales

```text
               TRAITER LE RÉSULTAT DE /init
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
      1. SUPPRIMER    2. PRÉCISER      3. COMPLÉTER
           │               │               │
     Bruit, docs,    Règles vagues   Choix d'équipe,
     évidences       → Actionnables  migrations (!!!),
                                     commandes réelles
                           │
                           ↓
                   4. TESTER & RELIRE
              (Le CLAUDE.md est du code !)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Structure recommandée d'un CLAUDE.md court
# Instructions projet pour Claude Code
## Commandes
Test unitaire : pnpm test:unit
Lint : pnpm lint

## Architecture
Le code applicatif est dans src. (Seulement si non standard)

## Conventions
Utiliser pnpm, pas npm.
Garder les corrections de bug minimales (pas de refactor).

## Migrations en cours
Nouveau pattern : X / Ancien pattern : Y

## Vérification
Ajouter un test reproduisant le bug avant de corriger.
```

> **La phrase centrale de la leçon :**
> L'outil `/init` est un assistant de démarrage, pas un oracle. Une mémoire de projet n'a de valeur que si elle consigne les contraintes invisibles et les migrations en cours, tout en supprimant le bruit documentaire.
