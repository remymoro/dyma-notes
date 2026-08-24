---
title: "Régler le niveau d'effort et de raisonnement"
description: "Comprendre et utiliser les différents niveaux d'effort, ultrathink et ultracode pour adapter Claude Code à la tâche."
date: 2026-08-24
draft: true
tags:
  - claude-code
  - modeles
  - effort
categories:
  - "Chapitre 10"
cours: Claude Code
chapitre: 10-modeles-couts-usage
leçon: 01-choisir-modele
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
Dans Claude Code, le choix du modèle ne fait pas tout : le niveau d'effort définit la profondeur du raisonnement alloué à une tâche. La commande `/effort` (ou le fichier de paramètres) permet de l'ajuster (de `low` à `max`) selon la difficulté, équilibrant ainsi coût et performance. Pour un besoin ponctuel, le mot-clé `ultrathink` force une réflexion intense sur un seul tour. Pour de vastes chantiers (audit, refactoring massif), le mode `ultracode` déploie des workflows dynamiques avec sous-agents. Attention : un effort maximal coûte cher et ne remplace jamais la vérification externe (tests, linter).

## Glossaire (Fiche de synthèse)

| Catégorie | Notion | Rôle |
|---|---|---|
| Capacité | `/model` | Choisir le modèle utilisé |
| Raisonnement | `/effort low` | Tâches simples, rapides, faible coût |
| Raisonnement | `/effort medium` | Analyse modérée, compromis coût/capacité |
| Raisonnement | `/effort high` | Développement standard |
| Raisonnement | `/effort xhigh` | Debugging, architecture, analyse complexe |
| Raisonnement | `/effort max` | Raisonnement exceptionnellement profond |
| Raisonnement | `/effort auto` | Retour à la valeur par défaut du modèle |
| Configuration | `effortLevel` | Préférence persistante d'effort |
| Configuration | `CLAUDE_CODE_EFFORT_LEVEL` | Impose l'effort via l'environnement et prend priorité |
| Ponctuel | `ultrathink` | Raisonnement plus profond pour un tour |
| Orchestration | `ultracode` | `xhigh` + workflow dynamique pour tâches substantielles |
| Qualité | Vérification | Confirmer le résultat avec test, build, diff, etc. |
| Coût | Budget | Limiter périmètre, outils, phases et condition d'arrêt |
| Contexte | `/compact`, `/clear`, `/rewind` | Traiter une session devenue trop bruitée ou incohérente |

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

- **Utiliser `max` pour tout** : Ralentit la session et coûte cher sans améliorer les tâches simples.
- **Utiliser `ultracode` pour une petite correction** : `high` suffit amplement pour un bug localisé.
- **Confondre `ultrathink` et `/effort`** : L'un agit sur un tour, l'autre sur toute la session.
- **Oublier de redescendre l'effort** : Payer le prix fort pour des questions simples suivant un refactoring lourd.
- **Augmenter l'effort au lieu de nettoyer le contexte** : Si la session est polluée, l'effort ne sauvera pas les meubles. Préférez `/clear` ou `/compact`.

---

# Cartes mentales

```text
                     CLAUDE CODE
                          │
          ┌───────────────┴────────────────┐
          │                                │
        /model                           /effort
          │                                │
          ↓                                ↓
    capacité de base              profondeur de raisonnement
                                           │
             ┌─────────────┬───────────────┼─────────────┐
             ↓             ↓               ↓             ↓
          low/medium      high           xhigh          max
             │             │               │             │
          simple       dev standard     complexe    exceptionnel

                     CAS PARTICULIERS
                           │
             ┌─────────────┴─────────────┐
             │                           │
        ultrathink                   ultracode
             │                           │
          1 tour                  xhigh + workflow
                                     dynamique
```

> **Derrière tout cela :**
> EFFORT → améliore le raisonnement
> VÉRIFICATION → apporte la preuve

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Protocoles recommandés
- Tâche simple      : /effort low + consigne stricte ("Ne modifie rien").
- Codage standard   : /effort high + vérification ciblée (test).
- Bug complexe      : /effort xhigh + demande d'hypothèses avant de coder.
- Analyse critique  : Mot-clé "ultrathink" pour un diagnostic ponctuel.
- Chantier massif   : /effort ultracode + limites claires de budget/périmètre.

■ Configuration persistante (Ordre de priorité)
1. Variable d'environnement CLAUDE_CODE_EFFORT_LEVEL (écrase tout)
2. Paramètre effortLevel dans les fichiers .claude/settings.json
3. Valeur par défaut du modèle
```

> **La phrase centrale de la leçon :**
> Le modèle détermine ce dont Claude est capable ; l'effort détermine jusqu'où il pousse son raisonnement ; la vérification détermine si le résultat tient réellement.
