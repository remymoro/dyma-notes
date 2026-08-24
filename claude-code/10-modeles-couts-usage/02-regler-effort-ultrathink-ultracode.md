---
title: "Régler l’effort, ultrathink et ultracode"
description: "Adapter le niveau d’effort de raisonnement aux besoins de la tâche."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - effort
  - raisonnement
categories:
  - "Chapitre 10"
cours: Claude Code
chapitre: 10-modeles-couts-usage
leçon: 02-regler-effort-ultrathink-ultracode
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Je lis / résume** | `low` ou `medium` (tâche simple, lecture, extraction) |
| **Je code / corrige / teste** | `high` (développement standard, bug localisé) |
| **J'enquête sur un problème** | `xhigh` (debugging complexe, architecture) |
| **J'orchestre un gros travail** | `ultracode` (`xhigh` + workflow dynamique, multi-phases) |
| **Je dois analyser 1 seul tour** | `ultrathink` |
| **Cas exceptionnel critique** | `max` |
| **Retour au défaut du modèle** | `/effort auto` |
| **Contexte pollué** | `/compact`, `/clear`, ou `/rewind` |
| **Résultat à confirmer** | La vérification externe (tests, build, diff) |

## Synthèse
Le modèle définit ce dont Claude est capable, mais l'effort dicte la **profondeur de son raisonnement**. Vous pouvez ajuster cette profondeur globalement (`/effort`), demander une réflexion intense sur un seul tour pour un besoin ponctuel (`ultrathink`), ou déclencher un workflow dynamique multi-phases pour un travail lourd (`ultracode`). Quel que soit le niveau choisi, gardez en tête qu'un effort maximal a un coût et ne remplacera jamais la vérification externe (tests, build) pour apporter la preuve d'un résultat fiable.

## Fiche finale — /effort, ultrathink, ultracode

| Catégorie | Notion | Rôle principal |
|---|---|---|
| Capacité | Modèle | Définit la capacité de base |
| Raisonnement | Effort | Définit la profondeur utilisée |
| Session | `/effort low` | Tâches simples |
| Session | `/effort medium` | Analyse modérée |
| Session | `/effort high` | Développement standard |
| Session | `/effort xhigh` | Raisonnement profond pour tâches complexes |
| Session | `/effort max` | Raisonnement exceptionnellement profond |
| Session | `/effort auto` | Retour au niveau par défaut du modèle |
| Ponctuel | `ultrathink` | Raisonnement profond pour un tour |
| Orchestration ponctuelle | `ultracode` dans le prompt | Workflow dynamique pour une tâche |
| Orchestration session | `/effort ultracode` | `xhigh` + workflow dynamique |
| Persistance | `effortLevel` | `low`, `medium`, `high`, `xhigh` |
| Environnement | `CLAUDE_CODE_EFFORT_LEVEL` | Impose l’effort avec priorité élevée |
| Déclencheur | `workflowKeywordTriggerEnabled` | Autorise ou non le mot `ultracode` à déclencher le workflow |
| Fiabilité | Vérification | Tests, build, typecheck, diff, validation |
| Maîtrise | Budget | Limite périmètre, phases, outils et condition d’arrêt |

## Questions d'auto-évaluation
1. Quel niveau d'effort est généralement le bon compromis pour une tâche de développement standard ?
2. Comment forcer Claude à réfléchir profondément sur une seule question sans changer le niveau de toute la session ?
3. Quelle est la différence fondamentale entre `xhigh` et `ultracode` ?
4. Si vous configurez `CLAUDE_CODE_EFFORT_LEVEL=high`, cela a-t-il la priorité sur le niveau par défaut du modèle ?

# L'art de doser l'effort

**Durée : 15 minutes**

## Objectif de la leçon
Apprendre à calibrer finement le niveau de raisonnement de Claude Code pour éviter de gaspiller des tokens sur des tâches simples, tout en sachant mobiliser la puissance maximale (`ultrathink`, `ultracode`) lorsque la complexité l'exige.

---

# 1. Le rôle de `/effort` et ses niveaux

L'effort ne change pas le modèle, il définit la **profondeur de raisonnement** dont il dispose. Un effort faible privilégie la vitesse et l'économie ; un effort élevé donne de la marge au raisonnement mais coûte plus cher.

| Niveau | Cas d'usage |
|---|---|
| `low` / `medium` | **Tâches simples, courtes, faible risque.** Lecture, résumé simple, inspection locale. |
| `high` | **Le niveau d'équilibre (Développement standard).** Coder, corriger un bug (même localisé), tester et vérifier. |
| `xhigh` | **Debugging complexe / architecture.** Migrations ambiguës, analyse poussée. |
| `max` | **Décisions critiques exceptionnelles.** Raisonnement exceptionnellement profond (attention à la surréflexion). |

> [!WARNING]
> **Piège à éviter : `low` vs `high`**
> Un bug localisé n'est pas une "tâche triviale". Même localisé, un bug implique : *comprendre → modifier → tester → vérifier*. Il relève donc du développement standard (`high`) et non d'une tâche simple (`low`).

> [!TIP]
> Si une session est compliquée, vous pouvez taper `/effort auto` pour réinitialiser le niveau sur la valeur par défaut du modèle.

---

# 2. `ultrathink` : Raisonnement profond ponctuel

Si vous avez besoin d'une analyse pointue sans pour autant basculer toute votre session en mode lent et coûteux, utilisez **`ultrathink`**.
C'est un mot-clé à écrire littéralement au début de votre prompt.

```text
ultrathink
Analyse cette régression.
Ne modifie aucun fichier.
Distingue les faits observés des hypothèses.
```
Claude Code reconnaîtra le mot et appliquera un effort maximal **uniquement pour cette réponse**.

---

# 3. `ultracode` : L'orchestration dynamique

`ultracode` va plus loin qu'un simple effort de modèle. C'est un paramètre propre à Claude Code qui :
1. Passe l'effort en `xhigh`.
2. **Active l'orchestration automatique** de workflows (analyse multi-fichiers, sous-agents, itérations).

**Comment l'activer ?**
- Pour toute la session : `/effort ultracode`
- Pour un seul tour : Inclure le mot-clé `ultracode` dans le prompt.

> [!CAUTION]
> `ultracode` peut consommer énormément de temps et de tokens. Il faut **toujours le budgéter et le cadrer** (ex: "Limite l'analyse à `src/`, ne lance pas plus de deux phases de workflow"). N'oubliez pas de redescendre l'effort (ex: `/effort high`) une fois le travail substantiel terminé.

---

# 4. Différences : ultrathink vs /effort vs ultracode

| Mécanisme | Portée | Effet principal | Usage typique |
|---|---|---|---|
| `ultrathink` | **Un tour** | Raisonnement profond ponctuel | Analyse difficile, revue de code |
| `/effort high`| **Session** | Règle le niveau global | Codage standard, refactor |
| `ultracode` | **Tâche/Session** | Orchestration dynamique + `xhigh` | Audit massif, migration large |

---

# 5. Erreurs fréquentes à éviter

- **ultrathink vs /effort xhigh vs ultracode** : C'est le principal point de confusion. Ne choisissez pas `ultracode` juste parce que la tâche est "très difficile". Demandez-vous d'abord : *Ai-je seulement besoin de mieux réfléchir ?* → `ultrathink` (1 tour) ou `/effort xhigh` (session). *Ai-je besoin d'organiser un gros travail en phases ?* → `ultracode`.
- **Mettre `max` ou `ultracode` dans la configuration persistante** : Les valeurs persistantes ordinaires acceptées dans `effortLevel` sont `low`, `medium`, `high` et `xhigh`. Mettre `max` ou `ultracode` est une erreur.
- **Croire que `workflowKeywordTriggerEnabled = false` désactive totalement l'orchestration** : Cela empêche seulement le *mot* "ultracode" dans le prompt de lancer un workflow dynamique. La commande `/effort ultracode` reste, elle, totalement disponible.
- **Oublier de redescendre l'effort** : Payer le prix fort pour des questions simples suivant un refactoring lourd.
- **Augmenter l'effort au lieu de nettoyer le contexte** : Si la session est polluée, l'effort ne sauvera pas les meubles. Préférez `/clear` ou `/compact`.

---

# Cartes mentales

```text
                    CLAUDE CODE
                         │
              ┌──────────┴──────────┐
              │                     │
           MODÈLE                 EFFORT
              │                     │
        capacité de base      profondeur utilisée
                                    │
                ┌───────────────────┼──────────────────┐
                │                   │                  │
               low                high              xhigh
             simple             standard            complexe
                                                       │
                                                      max
                                                 exceptionnel


Besoin ponctuel
     │
     ├── réfléchir plus profondément
     │         ↓
     │     ultrathink
     │
     └── organiser un workflow
               ↓
       ultracode dans le prompt


Besoin pour la session
     │
     ├── raisonnement profond
     │         ↓
     │   /effort xhigh
     │
     └── raisonnement + orchestration
               ↓
       /effort ultracode
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ L'échelle d'effort (Plus puissant ≠ meilleur)
- SIMPLE        → low
- ORDINAIRE     → high
- COMPLEXE      → xhigh
- EXCEPTIONNEL  → max
- SUBSTANTIEL + MULTI-PHASE → ultracode

■ Décision clé pour les tâches difficiles
                 BESOIN
                   │
        ┌──────────┴──────────┐
        │                     │
   Plus réfléchir ?      Plus orchestrer ?
        │                     │
        ↓                     ↓
 ultrathink / xhigh        ultracode
```

> **La formule centrale de la leçon :**
> - **ponctuel** → `ultrathink`
> - **session complexe** → `xhigh`
> - **workflow lourd** → `ultracode`
