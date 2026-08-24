---
title: "Maîtriser les coûts dans les workflows longs"
description: "Mettre en œuvre des pratiques permettant de limiter les coûts des longues sessions."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - couts
  - workflows
categories:
  - "Chapitre 10"
cours: Claude Code
chapitre: 10-modeles-couts-usage
leçon: 05-maitriser-couts-workflows-longs
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi une tâche longue coûte cher ?** | Multiplication des tours, accumulation du contexte (qui est refacturé à chaque tour), orchestration lourde (workflows, agents). |
| **Comment budgéter une tâche ?** | Définir un périmètre strict, imposer des limites qualitatives ("lecture seule", "rapport court") et quantitatives (`maxTurns`, `maxBudgetUsd` en CLI/SDK). |
| **Quel est l'impact des sous-agents ?** | Ils isolent le contexte d'une recherche volumineuse, mais ils consomment leurs propres tokens. Une équipe d'agents peut coûter 7x plus qu'une session standard. |
| **Comment désactiver les workflows ?** | `disableWorkflows: true` ou `workflowKeywordTriggerEnabled: false` dans `settings.json`. |
| **Quand faut-il utiliser un workflow dynamique ?** | Uniquement pour des tâches nécessitant une vérification croisée, un audit large ou une migration complexe. Pas pour une correction locale. |
| **Que faire après une longue phase d'exploration ?** | Demander à Claude de générer un "brief de transition", puis faire un `/clear` et repartir au propre pour l'implémentation. |

## Synthèse
Le coût d'une session dépend de sa trajectoire (nombre de tours et contexte accumulé), qui agit comme un multiplicateur. Pour maîtriser un workflow dynamique, il est vital de définir un "budget" clair avant de lancer l'orchestration : limiter le périmètre, brider les outils et encadrer le nombre d'agents. Les sous-agents protègent le contexte parent mais génèrent leur propre coût. Si la tâche dérape, un simple ajout de crédits ne règle rien : il vaut mieux nettoyer le contexte (`/clear`) ou désactiver les outils superflus (`/mcp`, `plugins`).

## Fiche finale — Distinctions essentielles (À revoir)

| Notion | Distinction |
|---|---|
| `/usage` vs `/context` | `/usage` = consommation ; `/context` = ce qui remplit la fenêtre |
| `disableWorkflows` vs `workflowKeywordTriggerEnabled` | Désactivation complète vs Désactivation du déclenchement par mot-clé |
| Contexte déjà pollué | Brief de transition + `/clear` (pas d'ajout automatique de sous-agents) |
| Philosophie générale | Mécanisme proportionné, pas de suppression des mécanismes puissants |
| Vérification croisée | Filtrer les conclusions non confirmées |
| Périmètre d’audit | Besoin de sortir du périmètre → arrêt et validation |
| `ultracode` | Phase lourde seulement, puis retour à un effort adapté |

## Questions d'auto-évaluation
1. Un sous-agent réduit-il automatiquement le coût global d'une tâche ?
2. Quelle commande permet de voir en temps réel ce que fait un workflow en arrière-plan ?
3. Pourquoi une équipe d'agents coûte-t-elle souvent plus cher qu'une session normale ?
4. Est-il utile de lancer un workflow dynamique pour corriger un simple bug local ?

# Cadrer l'orchestration et les workflows

**Durée : 10 minutes**

## Objectif de la leçon
Apprendre à piloter des tâches lourdes (migrations, audits) sans laisser la machine dépenser de l'argent inutilement. Comprendre que la délégation (agents, workflows) est un multiplicateur de coût qui nécessite un "budget" écrit strict.

---

# 1. La mécanique des coûts exponentiels

Dans un workflow long, la ressource la plus traître est **le contexte ancien**. Une erreur massive au tour 2 continuera d'être lue (et facturée) au tour 5, 10, et 15.

**Les grands multiplicateurs :**
1. **Les tours** : Chaque aller-retour d'outil recharge le contexte.
2. **Les sorties verbeuses** : Un log de test de 10 000 lignes non filtré.
3. **Les sous-agents** : Ils protègent le contexte parent (en ne renvoyant qu'un résumé), mais ils consomment leurs propres tokens en tâche de fond. Une équipe d'agents peut multiplier par 7 le coût d'une session.
4. **Les MCP/Plugins inactifs** : Un serveur MCP branché mais inutile alourdit le contexte système pour rien.

---

# 2. Le secret : "Budgéter" avant de lancer

Ne lancez jamais un `/effort ultracode` ou un workflow sans lui donner des "bornes qualitatives". C'est ce qu'on appelle budgéter.

**Exemple de budget pour un sous-agent :**
```text
Utilise un agent pour explorer src/auth.
- lecture seule, pas de modification
- fichiers réellement consultés uniquement
- résumé final de 10 lignes max
```

En mode non interactif, utilisez les sécurités dures : `--max-turns` ou `--max-budget-usd`.

---

# 3. Surveiller et intervenir

Lorsqu'un workflow est lancé en arrière-plan, gardez un œil sur :
- **`/workflows`** : Affiche les phases, les agents actifs, le coût en tokens et la durée.
- **`/tasks`** : Liste ce qui s'exécute en arrière-plan.
- **`/usage` et `/context`** : Pour vérifier d'où vient la dérive.

> [!WARNING]
> **Le piège de la persévérance**
> Si un workflow échoue plusieurs fois en boucle, n'ajoutez pas de l'effort ou des crédits. Demandez un résumé, faites `/clear`, et repartez sur une session saine. Une session polluée coûte très cher sans progresser.

---

# 4. Le brief de transition

C'est un pattern essentiel de Claude Code. Après une longue exploration (par exemple pour comprendre un code inconnu), le contexte est rempli d'hypothèses et d'erreurs.

1. `Prépare un brief de transition (objectif, fichiers, décisions, plan).`
2. Copiez le brief.
3. `/clear`
4. Collez le brief et lancez l'implémentation sur une session vierge.

---

# Carte mentale finale à retenir

```text
           TÂCHE
             │
             ↓
      Quelle difficulté ?
             │
   ┌─────────┼──────────┐
   ↓         ↓          ↓
 simple    complexe    volumineuse
   │         │          │
session    effort      sous-agent /
normale    adapté      workflow
   │         │          │
   └─────────┼──────────┘
             ↓
          ENCADRER
             │
     ┌───────┼────────┐
     ↓       ↓        ↓
 périmètre  tours    budget
            max       max
             │
             ↓
         SURVEILLER
             │
   /usage /context /workflows
             │
             ↓
       dérive détectée ?
        │           │
       non         oui
        │           ↓
     continuer   diagnostiquer
                    ↓
             brief / clear /
                rewind
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice de décision
1. Correction locale   → Session normale + test ciblé
2. Debugging complexe  → Modèle fort + effort élevé
3. Audit / Migration   → Workflow dynamique encadré (ultracode)

■ Désactivation des workflows
- /config -> disableWorkflows: true (Désactivation totale)
- workflowKeywordTriggerEnabled: false (Désactive le mot "ultracode" dans le prompt, mais garde /effort ultracode)
```

> **La phrase centrale de toute la leçon :**
> Maîtriser les coûts, ce n’est pas empêcher Claude Code de travailler : c’est empêcher sa trajectoire de devenir inutilement lourde.
