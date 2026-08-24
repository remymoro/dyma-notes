---
title: "Interrompre tôt et rembobiner avec les checkpoints"
description: "Interrompre une action et revenir à un état antérieur grâce aux checkpoints."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - checkpoints
  - sessions
categories:
  - "Chapitre 9"
cours: Claude Code
chapitre: 09-gestion-sessions-contexte
leçon: 05-interrompre-rembobiner-checkpoints
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Comment arrêter une action en cours ?** | Touche `Esc`. Cela stoppe la trajectoire agentique (génération de message ou outil) tout en conservant le contexte. Idéal quand Claude part sur une mauvaise piste. |
| **Qu'est-ce qu'un checkpoint ?** | Un instantané (snapshot) de l'état des fichiers, créé automatiquement par Claude avant *chaque* modification. Accessible via `/rewind`. |
| **Quelles actions avec `/rewind` ?** | - Restaurer le code et la conversation<br>- Restaurer la conversation (garder le code)<br>- Restaurer le code (garder la discussion)<br>- Résumer (à partir de / jusqu'à un point) |
| **Différence Restaurer vs Résumer ?** | **Restaurer** annule un état (erreur). **Résumer** compresse un contexte pour regagner de la place (piste utile mais trop lourde). |
| **Différence `/rewind` vs Git ?** | `/rewind` annule les éditions de Claude localement dans la session. `/rewind` **ne voit pas** les modifications faites par `bash` (`rm`, `mv`) ou manuellement ! Git reste indispensable. |

## Synthèse
Interrompre et rembobiner sont deux mécanismes de pilotage cruciaux dans Claude Code pour garder une session propre. La touche `Esc` permet de stopper immédiatement une trajectoire qui déraille (hallucination, lecture inutile) sans perdre l'historique. S'il est trop tard, la commande `/rewind` (ou `/checkpoint`) ouvre un menu interactif permettant de revenir à un état antérieur. Chaque invite crée un checkpoint automatique (code + conversation). Il est possible de restaurer l'un, l'autre, ou les deux, voire de compresser des parties inutiles de la conversation pour libérer du contexte. Attention : `/rewind` ne remplace en aucun cas `Git`. Il ne suit pas les modifications manuelles ni celles exécutées via des commandes bash (`rm`, `mv`, `cp`). Git reste la seule vraie source de vérité durable.

## Glossaire
- **`Esc`** : Touche pour interrompre une réponse ou une séquence d'outils en cours (arrêt de trajectoire).
- **`/rewind` (alias `/checkpoint`)** : Ouvre le menu interactif de rembobinage et de compression de contexte.
- **Checkpoint** : Instantané de l'état des fichiers, créé automatiquement par Claude Code avant d'utiliser un outil d'édition.
- **Restaurer** : Action d'annuler (code ou conversation) pour revenir à un état précis.
- **Résumer** : Action de compresser une partie de la conversation pour libérer de l'espace (le code reste intact).

## Questions d'auto-évaluation
1. Si je supprime un fichier avec la commande bash `rm`, puis-je le récupérer avec `/rewind` ?
2. Quelle commande ouvre le menu des checkpoints ?
3. Quelle est la différence fondamentale entre "Restaurer" et "Résumer" dans le menu de rembobinage ?
4. Quelle touche permet d'arrêter Claude s'il commence à lire massivement des dossiers inutiles ?

# Interrompre tôt et rembobiner avec les checkpoints

**Durée : 13 minutes**

## Objectif de la leçon
Savoir quand interrompre Claude (`Esc`) pour éviter la pollution contextuelle, et comprendre comment utiliser `/rewind` pour restaurer un état précédent du code ou de la conversation de manière ciblée, sans jamais confondre cet outil avec Git.

---

# 1. Le Danger des commandes Bash

```text
  [ CLAUDE MODIFIE (Outils internes) ]  => Suivi par /rewind ✅
           │
  [ CLAUDE EXÉCUTE: "rm file.txt" ]     => Ignoré par /rewind ❌
           │
  [ TOI TU MODIFIES DANS TON IDE ]      => Ignoré par /rewind ❌

=> /rewind ne peut annuler QUE ce qu'il a lui-même édité avec ses outils d'édition de code.
```

---

# Fiche de synthèse (Notions clés)

| Besoin | Mécanisme adapté | Effet principal |
|---|---|---|
| Arrêter une trajectoire en cours | `Esc` | Interrompt l'action/réponse en cours tout en préservant le contexte. |
| Revenir à un état antérieur (code/conv) | `/rewind` (Restaurer) | Annule les modifications pour revenir au point de contrôle. |
| Gagner de la place contextuelle | `/rewind` (Résumer) | Compresse l'historique sans altérer le code. |
| Sécuriser les commandes destructrices | `Git` | Protège des `rm`, `mv` et éditions manuelles. |

# Les 5 points les plus importants

1. **`Esc` tôt, pas tard** : N'attendez pas que Claude termine une séquence aberrante ; coupez-le vite pour éviter de polluer le contexte avec des hypothèses fausses ou de consommer du token pour rien.
2. **Restaurer vs Résumer** : *Restaurer* sert à annuler une erreur (code/raisonnement). *Résumer* sert à regagner de la place (pression mémoire/budget).
3. **Le Piège du Shell** : `/rewind` annule les éditions de code faites par les outils de Claude. Il ne peut PAS annuler les commandes bash destructrices (`rm`, `mv`, `cp`) ni vos modifications manuelles.
4. **Le Menu à la carte** : Le menu de rembobinage vous laisse choisir. Vous pouvez annuler *le code*, annuler *la conversation*, ou *les deux*. C'est très pratique si l'analyse est bonne mais que le code écrit est mauvais (on restaure juste le code).
5. **`/rewind` ≠ Git** : Les checkpoints sont faits pour la récupération rapide intra-session. Git reste la source de vérité absolue et permanente pour le dépôt.

---

# Carte mentale

```text
           CONTRÔLE DES TRAJECTOIRES
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
   INTERROMPRE (Esc)        REMBOBINER (/rewind)
          │                         │
  Couper une séquence               │
  avant la pollution                │
          │                   ┌─────┼─────┐
          ▼                   ▼     ▼     ▼
    Reprendre la             Code  Conv.  Les 2
       main               (Annuler des erreurs)

                                   OU
                                   ▼
                           Résumer (à partir de / jusqu'à)
                           (Gagner du contexte)

   DANGER : /rewind ne track pas Bash (rm, mv) ni vos éditions manuelles !
            => Git reste indispensable.
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les outils de rattrapage
Esc       → Arrête immédiatement l'agent (sans perdre l'historique).
/rewind   → Ouvre le menu temporel (checkpoints).

■ Le menu /rewind (Ce qu'on peut faire)
1. Restaurer code + conv  : Tout annuler (la piste était catastrophique).
2. Restaurer conversation : Garder le code, mais nettoyer les blablas d'explication.
3. Restaurer le code      : Garder le diagnostic utile, mais annuler le patch raté.
4. Résumer                : Ne rien annuler, juste compresser l'historique pour faire de la place.

■ Limites Absolues
/rewind ignore les commandes Shell (rm, mv) et les éditions manuelles de votre IDE.
```

> **La phrase centrale de la leçon :**
> Restaurer répond à une erreur d'état. Résumer répond à une pression de contexte. Et Git protège contre tout le reste.
