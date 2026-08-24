---
title: "Choisir le mode de permission"
description: "Découvrir les postures globales d'autonomie et savoir quand les utiliser."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - securite
  - permissions
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 02-choisir-mode-permission
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre une règle et un mode ?** | Une *règle* (allow/deny) gère une action précise (ex: lire un fichier). Un *mode* définit la **posture globale** de la session (exploration, automatisation, prudence). |
| **Quel mode utiliser au tout début d'un projet inconnu ?** | `default` (ou `plan`). Cela permet d'observer quelles actions Claude veut faire, et de construire ensuite une politique de sécurité adaptée. |
| **Comment basculer d'un mode à l'autre dans la CLI ?** | Avec le raccourci `Maj + Tab`. Il fait défiler les modes `default`, `acceptEdits`, et `plan`. |
| **Pourquoi `acceptEdits` déplace-t-il le contrôle ?** | Au lieu d'approuver l'édition de chaque fichier avant l'action, on la laisse passer, et on relit *après coup* (via git diff, typecheck, tests). |
| **À quoi sert le mode `dontAsk` ?** | C'est une posture verrouillée pour l'automatisation (CI, scripts). Il ne demande jamais d'avis : si l'action n'est pas déjà explicitement pré-autorisée, elle est refusée en bloc. |
| **Pourquoi `bypassPermissions` est-il dangereux ?** | Il ignore presque tous les garde-fous. Il ne doit être utilisé *que* dans des environnements 100% jetables ou virtuels. |

## Synthèse
Les modes de permission ne remplacent pas les règles (`allow/deny`) : ils définissent la "posture" d'autonomie générale de votre session. Dans un dépôt inconnu ou sensible, on commence toujours en `default` pour observer, ou en `plan` pour exiger une stratégie claire. Une fois en phase d'implémentation (avec un diff lisible et des tests), on peut basculer sur `acceptEdits` ou `auto` pour réduire la friction. Enfin, les modes `dontAsk` et `bypassPermissions` sont réservés à des cas très spécifiques : l'automatisation stricte pour le premier, et les environnements virtuels jetables pour le second. On augmente l'autonomie uniquement quand la vérification reste sous contrôle.

## Fiche finale — Distinctions et pièges (À revoir)

| Notion | Distinction / Piège à éviter |
|---|---|
| **`default`** | **Découvrir.** Dépôt inconnu. *Piège :* ne pas l'associer à un environnement jetable (c'est pour les vrais dépôts). |
| **`plan`** | **Comprendre.** "Je dois comprendre comment agir." *Piège :* ne pas utiliser `auto` pour résoudre une tâche floue, utiliser `plan` à la place. |
| **`acceptEdits`** | **Implémenter.** "Je sais déjà comment agir." On code et on vérifie après coup. |
| **`auto`** | **Réduire les interruptions.** Seulement pour une tâche claire et bien cadrée. |
| **`dontAsk`** | **Automatiser.** Aucune interaction humaine. *Piège :* Ce n'est pas permissif ; ce qui n'est pas préautorisé est refusé. |
| **`bypassPermissions`** | **Contourner.** Réservé aux environnements isolés et sacrifiables. *Piège :* À bannir sur un vrai dépôt avec secrets ou accès prod. |

## Questions d'auto-évaluation
1. Dans un projet que vous découvrez pour la première fois, devriez-vous utiliser `acceptEdits` immédiatement ?
2. Quel raccourci clavier permet de changer rapidement de mode dans la CLI ?
3. Le mode `dontAsk` transformera-t-il une requête non autorisée en invite `ask` ?
4. Le mode `auto` est-il un substitut total aux règles de sécurité déterministes ?

# Piloter l'autonomie de la session

**Durée : 10 minutes**

## Objectif de la leçon
Comprendre que l'autonomie est un curseur. Apprendre à adapter le mode de permission à la phase de travail (découverte, analyse, implémentation locale, automatisation) pour être productif sans sacrifier la sécurité.

---

# 1. Le Gradient d'autonomie

Si les règles `allow` et `deny` gèrent le cas par cas, le **Mode de permission** gère la "confiance globale". L'objectif est d'augmenter l'autonomie au fur et à mesure que l'on maîtrise le dépôt.

| Mode | Posture | Usage type |
|---|---|---|
| **`default`** | Supervision | Dépôt inconnu, observation des actions. |
| **`plan`** | Analyse | Refactor, migration, avant de toucher au code. |
| **`acceptEdits`** | Itération | Implémentation de code avec relecture (diff, tests). |
| **`auto`** | Autonomie contrôlée | Tâches cadrées, pour éviter la fatigue de validation. |
| **`dontAsk`** | Verrouillage | Scripts, CI, automatisation pure (sans humain). |
| **`bypassPermissions`** | Contournement | **DANGER** : Environnements jetables uniquement. |

> [!TIP]
> **Le raccourci `Maj + Tab`**
> Dans la CLI, appuyez sur `Maj + Tab` pour naviguer rapidement entre `default`, `acceptEdits`, et `plan` en plein milieu de votre session.

---

# 2. La progression recommandée

La règle d'or est de ne jamais démarrer en autonomie totale.
1. **Départ (`default` ou `plan`)** : Vous découvrez le code, vous vérifiez chaque intention de Claude.
2. **Implémentation (`acceptEdits`)** : L'objectif est clair, Claude code, vous vérifiez ensuite le `git diff` et vous lancez les tests.
3. **Tâche longue (`auto`)** : Le cadre est ultra-précis, vous laissez le classificateur autoriser les petites actions pour ne pas être interrompu toutes les 10 secondes.

---

# 3. Pièges et fausses croyances

- **`acceptEdits` n'est pas un feu vert total** : Il autorise les écritures de fichiers, mais pas les commandes d'infrastructure destructrices.
- **`plan` n'est pas décoratif** : Si vous êtes en `plan`, exigez un *vrai* plan (fichiers concernés, risques, tests à faire).
- **`auto` ne remplace pas les règles** : Le classificateur derrière `auto` est pratique mais il ne remplace pas un `deny` ou un `sandbox` formel.

> [!WARNING]
> **Le piège de la solution de facilité**
> Ne répondez jamais à la "fatigue de validation" en activant `bypassPermissions` sur votre machine de travail. Ce mode n'offre aucune protection contre les injections. Ne l'utilisez que dans un Docker ou un devcontainer jetable.

---

# Carte mentale finale

```text
MODES DE PERMISSION
│
├── default
│   └── "Je découvre, je supervise"
│
├── plan
│   └── "Je dois comprendre avant d'agir"
│
├── acceptEdits
│   └── "Je sais quoi modifier"
│
├── auto
│   └── "La tâche est claire, je veux moins d'interruptions"
│
├── dontAsk
│   └── "Personne ne peut répondre"
│       └── non autorisé → refus
│
└── bypassPermissions
    └── "L'environnement est sacrifiable et isolé"
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Progression des modes
1. Découvrir → default
2. Comprendre → plan
3. Implémenter → acceptEdits
4. Réduire les interruptions → auto
5. Automatiser sans humain → dontAsk

(Cas à part : Environnement sacrifiable → bypassPermissions)
```

> **La phrase centrale de la leçon :**
> L’autonomie n’est acceptable que si le résultat reste contrôlable : n'augmentez le mode de permission que si vous avez les moyens de vérifier le travail (diff, typecheck, tests).
