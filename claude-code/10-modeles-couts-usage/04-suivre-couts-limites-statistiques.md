---
title: "Suivre les coûts, les limites et les statistiques"
description: "Surveiller la consommation, les coûts et les statistiques d’utilisation de Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - couts
  - statistiques
categories:
  - "Chapitre 10"
cours: Claude Code
chapitre: 10-modeles-couts-usage
leçon: 04-suivre-couts-limites-statistiques
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la commande de référence ?** | `/usage`. Elle montre le coût, les limites et les stats. `/cost` et `/stats` ne sont que des raccourcis vers ses onglets. |
| **Quelle est la différence entre coût et limite ?** | Le *coût* est facturé (tokens). La *limite* est un plafond de consommation bloquant (session, taux). On peut atteindre une limite avec un coût bas, ou faire exploser les coûts sans toucher de limite. |
| **À quoi sert `/insights` ?** | C'est un rapport HTML local qui analyse les habitudes sur 30 jours (points de friction, prompts vagues, choix de modèles). Ne transmet pas de code source. `/usage` mesure, `/insights` interprète. |
| **Comment gérer les dépassements de limite ?** | Avec `/usage-credits` (anciennement `/extra-usage`). Permet de débloquer des crédits (ou activer la fenêtre 1M). |
| **Pourquoi une session devient coûteuse ?** | L'accumulation de contexte (historique, fichiers, MCP inutiles, sous-agents). Le contexte obsolète est facturé à chaque tour ! |
| **L'estimation en $ de `/usage` est-elle officielle ?** | Non, c'est une estimation locale. La vraie facture dépend de la Console Claude ou du fournisseur d'API. |

## Synthèse
Dans Claude Code, la gestion des coûts ne se fait pas à la fin du mois, mais se pilote en direct grâce à `/usage`. Cette commande affiche l'estimation des coûts, l'état des limites du plan et les statistiques de la session. Un coût qui dérape provient généralement d'un contexte non nettoyé (fichiers inutiles, serveurs MCP activés pour rien) qui est facturé à chaque tour. Enfin, là où `/usage` donne des chiffres immédiats, `/insights` génère un rapport qualitatif sur vos habitudes pour vous aider à être plus efficace sur le long terme.

## Fiche finale — Les commandes à mémoriser

| Commande | Rôle | Formule mentale |
|---|---|---|
| `/usage` | Affiche coûts, limites et statistiques | "Combien et où ?" |
| `/cost` | Ouvre l'onglet coût de `/usage` | "Coût" |
| `/stats` | Ouvre l'onglet stats de `/usage` | "Statistiques" |
| `/insights` | Génère un rapport d'analyse comportementale local | "Pourquoi je travaille ainsi ?" |
| `/usage-credits` | Configure les crédits en cas de limite atteinte | "Gérer les crédits" |
| `/clear` | Nettoie le contexte | "Repartir proprement" |
| `/compact` | Réduit l'historique | "Garder l'essentiel" |
| `/model` | Règle la capacité | "Adapter le modèle" |
| `/effort` | Règle la profondeur | "Adapter le raisonnement" |
| `/mcp` | Désactive les serveurs inutiles | "Gérer les MCP" |

## Questions d'auto-évaluation
1. Les commandes `/cost` et `/stats` ouvrent-elles des écrans différents de `/usage` ?
2. Le montant en dollars affiché par `/usage` fait-il office de facture officielle ?
3. Pourquoi l'utilisation de serveurs MCP inutilisés augmente-t-elle les coûts sans rien faire ?
4. Quelle commande permet d'analyser vos mauvaises habitudes de prompt sur les 30 derniers jours ?

# Maîtriser son budget au quotidien

**Durée : 7 minutes**

## Objectif de la leçon
Apprendre à piloter la consommation de Claude Code sans freiner la productivité. Comprendre ce qui coûte cher, différencier coût et limite, et utiliser les bons outils (`/usage`, `/insights`) pour optimiser son travail.

---

# 1. Les outils de mesure

Le suivi individuel repose sur deux commandes fondamentales aux rôles bien distincts :

1. **`/usage`** (La Mesure)
   Affiche les données chiffrées de la session en cours : coût estimé, tokens utilisés, limites du plan.
   *Raccourcis : `/cost` pointe sur l'onglet coût, `/stats` sur l'onglet statistiques.*
   > **Note importante** : L'estimation en dollars est calculée localement, elle est approximative et ne remplace pas la facturation officielle.

2. **`/insights`** (L'Interprétation)
   Génère un rapport HTML local sur vos 30 derniers jours d'utilisation. Il identifie vos habitudes de travail : sessions trop longues, requêtes vagues, usage excessif d'agents, etc. Idéal pour optimiser votre façon de faire.

> [!TIP]
> **`/usage-credits` (ex `/extra-usage`)**
> Si vous bloquez sur une limite (ex: activation de la fenêtre de contexte 1M), cette commande vous permet d'allouer des crédits supplémentaires pour continuer à travailler.

---

# 2. Les pièges à éviter (À revoir)

**1. Coût ≠ Limite**
- **Coût** = consommation (tokens facturés).
- **Limite** = allocation / plafond bloquant.
> **Piège** : Atteindre une limite ne signifie pas que la session actuelle est forcément très coûteuse. Vous pouvez être bloqué avec un coût très bas.

**2. `/usage-credits` ≠ `/extra-usage`**
- `/usage-credits` est le nom actuel de la commande.
- `/extra-usage` est l'ancien nom (qui fonctionne encore comme alias).
> **Piège** : Ce ne sont pas deux systèmes différents, c'est exactement la même commande.

---

# 3. Ce qui fait exploser la facture

Dans Claude Code, **le contexte est un coût récurrent**. Si vous chargez 10 gros fichiers au tour 1, vous paierez les tokens de ces fichiers au tour 1, au tour 2, au tour 3...

Les pièges majeurs :
- **Ne pas nettoyer son contexte** : Un long historique coûte cher à chaque nouveau prompt. Utilisez `/clear` ou `/compact`.
- **Serveurs MCP inutiles** : Même s'ils ne font rien, les définitions des outils MCP prennent de la place dans le contexte. Désactivez-les avec `/mcp`.
- **Sous-agents abusifs** : L'utilisation d'une équipe d'agents en mode plan peut multiplier par 7 la consommation de tokens.
- **Mauvais choix de modèle/effort** : Opus avec un effort `max` n'est pas nécessaire pour changer la couleur d'un bouton.

> [!TIP]
> **Le rôle des Hooks et Skills**
> Les hooks et skills bien conçus *réduisent* les coûts. Un hook qui filtre des logs de tests pour ne garder que l'erreur réduit drastiquement les tokens envoyés à Claude.

---

# Carte mentale finale

La structure en arbre offre la vue la plus complète et pédagogique pour réviser l'ensemble du processus de suivi :

```text
SUIVI DES COÛTS CLAUDE CODE
│
├── Mesurer
│   ├── /usage
│   ├── /cost
│   └── /stats
│
├── Comprendre
│   ├── coût ≠ limite
│   ├── coût local = estimation
│   └── /insights = analyse des habitudes
│
├── Maîtriser la consommation
│   ├── contexte
│   │   ├── /clear
│   │   └── /compact
│   ├── modèle
│   │   └── /model
│   ├── effort
│   │   └── /effort
│   └── MCP
│       └── /mcp
│
├── Déléguer intelligemment
│   ├── sous-agents
│   ├── équipes d'agents
│   ├── hooks
│   ├── skills
│   └── plugins
│
├── Dépasser certaines limites
│   └── /usage-credits
│       └── ancien alias : /extra-usage
│
└── Piloter
    ├── AVANT → cadrer
    ├── PENDANT → surveiller
    └── APRÈS → analyser
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Protocoles de pilotage
- AVANT   → Cadrer la tâche (limiter recherche, planifier)
- PENDANT → /usage + /context (vérifier les dérives)
- APRÈS   → /usage + /insights (comprendre et améliorer)

■ La source n°1 des coûts
Le contexte ! Il est retraité à CHAQUE tour. Un fichier inutile chargé au début se paie tout le long de la session.
```

> **La formule centrale de toute la leçon :**
> Une bonne gestion des coûts ne consiste pas à toujours consommer moins, mais à vérifier que la consommation est justifiée par le travail demandé.
