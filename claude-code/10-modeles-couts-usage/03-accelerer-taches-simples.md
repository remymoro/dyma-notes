---
title: "Accélérer les tâches simples"
description: "Utiliser le mode rapide et suivre les crédits consacrés aux tâches simples."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - performance
  - couts
categories:
  - "Chapitre 10"
cours: Claude Code
chapitre: 10-modeles-couts-usage
leçon: 03-accelerer-taches-simples
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **À quoi sert `/fast` ?** | Réduire la latence des réponses (vitesse > coût). Ce n'est pas un modèle léger, c'est Opus configuré pour la haute vitesse. |
| **Quel est l'impact sur le coût ?** | Coût par jeton plus élevé. À éviter pour des tâches longues et autonomes où l'attente n'est pas gênante. |
| **Comment l'activer / désactiver ?** | `/fast`, `/fast on`, `/fast off`. Une icône ↯ apparaît quand il est actif. |
| **Que se passe-t-il quand on le désactive ?** | La session *reste sur Opus*. Il faut faire `/model` pour repasser à un modèle plus économique (ex: Sonnet). |
| **Peut-on le combiner avec `/effort` ?** | Oui. `/fast on` + `/effort low` maximise la vitesse pour une tâche très simple (latence minimale, réflexion courte). |
| **Pourquoi faire attention dans une longue session ?** | L'activer tard facture tout le contexte d'entrée non mis en cache au prix "rapide". Mieux vaut `/clear` avant d'activer `/fast`. |

## Synthèse
Le mode rapide (`/fast`) n'est pas un modèle économique, mais une version accélérée (et plus coûteuse) de Claude Opus conçue pour réduire le temps d'attente entre les tours. Il est idéal pour le débogage interactif en direct ou les tâches simples urgentes. Étant facturé plus cher, il est déconseillé pour les longs traitements autonomes. Attention : le désactiver (`/fast off`) ne vous ramène pas automatiquement à votre modèle précédent ; vous restez sur Opus jusqu'à ce que vous changiez explicitement avec `/model`.

## Fiche finale — /fast

| Catégorie | Notion | Rôle |
|---|---|---|
| Vitesse | `/fast on` | Réduire la latence d’Opus |
| Vitesse | `/fast off` | Désactiver la configuration haute vitesse |
| Modèle | `/model` | Choisir le modèle actif |
| Raisonnement | `/effort` | Régler la profondeur de raisonnement |
| Usage | Itération rapide | Cas adapté à `/fast` |
| Usage | Debugging en direct | Cas particulièrement adapté à `/fast` |
| Usage | Tâche simple urgente | `/fast` peut réduire l’attente |
| Coût | Tâche longue autonome | Mode standard généralement préférable |
| Coût | Première activation tardive | Peut être coûteuse dans une longue conversation |
| Disponibilité | Opus | `/fast` repose sur Opus |
| Organisation | `availableModels` | Peut indirectement interdire `/fast` si Opus est interdit |
| Configuration | `fastMode` | Mémorise la préférence de mode rapide |
| Configuration | `fastModePerSessionOptIn` | Force une décision à chaque session |
| Contexte | `/compact`, `/clear`, `/rewind` | Gèrent les problèmes de contexte, pas la vitesse |

## Questions d'auto-évaluation
1. Le mode `/fast` utilise-t-il Haiku pour aller plus vite ?
2. Que se passe-t-il au niveau du modèle si vous tapez `/fast off` après l'avoir utilisé ?
3. Est-il recommandé d'activer `/fast` au beau milieu d'une très longue conversation ?
4. Dans quel cas combiner `/fast on` et `/effort low` est-il pertinent ?

# Accélérer les tâches interactives

**Durée : 10 minutes**

## Objectif de la leçon
Comprendre le fonctionnement du mode rapide (`/fast`), savoir quand l'utiliser pour fluidifier l'expérience interactive (débogage en direct), et surtout quand l'éviter pour ne pas faire exploser les coûts.

---

# 1. Le mode rapide n'est pas un "modèle léger"

L'erreur classique est de penser que `/fast` appelle un modèle plus petit (comme Haiku). C'est faux.
`/fast` est **une configuration haute vitesse pour Claude Opus**. Il offre la même qualité qu'Opus, répond environ 2,5 fois plus vite, mais **coûte plus cher par jeton**.

**Distinguer les 3 réglages :**
- `/model` : Règle la capacité globale (Sonnet, Opus, Haiku).
- `/effort` : Règle la profondeur de réflexion.
- `/fast` : Règle la vitesse (latence) sur Opus, contre un supplément de coût.

> [!WARNING]
> **Le piège de la désactivation**
> Si vous activez `/fast`, la session bascule sur Opus. Si vous tapez `/fast off`, vous désactivez la vitesse, **mais la session reste sur Opus**. N'oubliez pas d'utiliser `/model` (ex: `/model sonnet`) pour retrouver un modèle économique.

---

# 2. Quand utiliser `/fast` ?

La règle est simple : **utilisez-le lorsque la latence vous gêne dans votre travail interactif.**

- **Débogage en direct** : Si vous reproduisez un bug manuellement dans l'UI ou surveillez un serveur local, chaque seconde d'attente casse votre élan.
- **Tâches simples urgentes** : Vous voulez juste faire expliquer une erreur ou valider une petite diff immédiatement.

*Exemple de combinaison pour une tâche simple et urgente :*
```bash
/fast on
/effort low
Explique rapidement cette erreur. Ne modifie rien.
```

---

# 3. Quand ÉVITER `/fast` ?

Puisqu'il s'agit d'une ressource premium (facturée plus chère ou déduisant des limites de taux séparées), évitez-le pour :

1. **Les tâches longues et autonomes** : L'utilisateur n'attend pas la réponse devant son écran. Contrôlez plutôt l'effort et le budget.
2. **Les sessions déjà très longues** : La première activation de `/fast` facture tout l'historique non mis en cache au tarif "mode rapide". Si la session est lourde, faites un `/clear` avant d'activer le mode rapide.
3. **Le travail sensible au coût**.

---

# 4. Configurations persistantes

Il est possible d'activer le mode rapide de façon globale via les paramètres, mais cela demande de la vigilance.

- **`"fastMode": true`** : Active le mode rapide de façon persistante. Pratique mais dangereux pour les coûts à long terme.
- **`"fastModePerSessionOptIn": true`** : Réglage d'équipe très utile. Il force le mode rapide à se désactiver au lancement de chaque nouvelle session, demandant à l'utilisateur de taper consciemment `/fast` s'il en a besoin.

---

# 5. L'erreur la plus fréquente (À revoir absolument)

Le principal piège est de croire que `/fast off` suffit pour revenir à son état précédent. 
**Désactiver la vitesse ne change pas le modèle.**

*Exemple de la double étape obligatoire si vous étiez sur Sonnet :*
1. **Sonnet** (Départ)
2. `/fast on` → Bascule sur Opus rapide
3. `/fast off` → Bascule sur **Opus standard** *(Attention : vous n'êtes pas sur Sonnet !)*
4. `/model sonnet` → Retour effectif sur Sonnet

> **La règle absolue à mémoriser :**
> Quitter `/fast` ne signifie pas quitter Opus.

---

# Cartes mentales finales

**1. Mécanisme et cas d'usage**
```text
                         /fast
                           │
           ┌───────────────┼────────────────┐
           │               │                │
           ▼               ▼                ▼
        VITESSE          MODÈLE            COÛT
           │               │                │
   réduit la latence    repose sur       plus élevé
       d'Opus             Opus           par jeton
           │
           ▼
     Quand l'utiliser ?
           │
     ┌─────┼───────────────┐
     ▼     ▼               ▼
 itération debug       tâche simple
 rapide   en direct      urgente

           Quand l'éviter ?
                  │
       ┌──────────┼───────────┐
       ▼          ▼           ▼
 tâche longue   budget     session déjà
 autonome      prioritaire   très longue
```

**2. Les commandes et le contexte**
```text
                         /fast
                           │
                  accélérer OPUS
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
         latence ↓                 coût/token ↑
              │
              ▼
       Quand l'utiliser ?
              │
     ┌────────┼──────────┐
     ▼        ▼          ▼
  debug     petites    itérations
  direct    tâches      rapides
            urgentes


/model                  /effort
   │                        │
   ▼                        ▼
quel modèle ?       combien réfléchir ?


            CONTEXTE
                │
      ┌─────────┼─────────┐
      ▼         ▼         ▼
  /compact    /clear    /rewind
      │
      └────── ≠ /fast
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Combinaisons clés
- /fast + /effort low  → Tâche simple et interactive
- /fast + /effort high → Tâche complexe mais interactive

■ Les commandes de contexte (Ne pas confondre avec la vitesse)
- Le mode rapide n'arrange pas un mauvais contexte.
- Si le contexte est lourd ou pollué, utilisez plutôt /clear, /compact ou /rewind.
```

> **La formule centrale de la leçon :**
> - `/model`  → **QUI ?**
> - `/effort` → **COMBIEN RÉFLÉCHIR ?**
> - `/fast`   → **À QUELLE VITESSE OPUS ?**
