---
title: "Comprendre les sources de contexte dans Claude Code"
description: "Identifier comment la fenêtre de contexte est alimentée (fichiers, commandes, mémoire) pour éviter de la polluer."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - contexte
  - compaction
categories:
  - "Chapitre 9"
cours: Claude Code
chapitre: 09-gestion-sessions-contexte
leçon: 01-comprendre-sources-contexte
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Fenêtre de contexte vs Dépôt ?** | Le contexte, c'est ce qui est *actuellement* chargé en mémoire par l'agent. Le dépôt, ce sont tous les fichiers existants. Claude Code n'a pas tout le dépôt en mémoire par défaut ; il faut qu'il le lise. |
| **Utilité de `/context` ?** | Cette commande affiche l'état et l'utilisation actuelle du budget de contexte de la session (fichiers, outils, chat, etc.). |
| **Sources de démarrage ?** | Des éléments sont chargés d'office : instructions globales, `CLAUDE.md` racine, mémoire automatique, descriptions d'outils MCP et des skills. |
| **Danger des grosses commandes ?** | Exécuter un `cat` sur un gros log ou un `find` trop vaste peut "polluer" la session en remplissant la mémoire de bruit. Le modèle devient confus. |
| **Signes de pollution ?** | Si Claude devient verbeux, oublie des consignes récentes, ou s'entête sur de vieilles idées rejetées, c'est que son contexte est pollué. |
| **Compaction (`/compact`) ?** | Libère la mémoire en transformant les vieux échanges en résumé. Les éléments "durs" (`CLAUDE.md`, MCP, mémoire auto) sont rechargés. Les détails anciens sont condensés. Les descriptions de skills non-utilisées disparaissent. |
| **Sous-agents ?** | Excellente technique pour limiter la pollution : déléguer une exploration lourde à un sous-agent qui tourne dans sa propre fenêtre de contexte et renvoie un résumé à la session principale. |

## Synthèse
La fenêtre de contexte de Claude Code ne se limite pas à l'historique de vos messages. Elle englobe également des sources passives chargées au démarrage (comme `CLAUDE.md` ou la mémoire automatique) et des sources actives ajoutées pendant la session (fichiers lus, sorties de commandes, retours d'outils). Tout l'enjeu est de maîtriser ce budget pour éviter la **pollution du contexte**. En privilégiant des commandes ciblées, en recourant aux sous-agents pour les tâches lourdes, et en surveillant l'état avec `/context`, vous gardez un agent vif et pertinent, même après des cycles de compaction.

## Glossaire
- **Fenêtre de contexte** : Espace mémoire limité dont dispose le LLM pour élaborer sa prochaine réponse.
- **Compaction** : Processus de purge de l'historique long, condensé sous forme de résumé afin de regagner des jetons de contexte.
- **Pollution de contexte** : Encombrement de la fenêtre par des données inutiles ou obsolètes, dégradant la pertinence de l'agent.

## Questions d'auto-évaluation
1. Un fichier est présent dans le dépôt Git de votre projet. Fait-il forcément partie de la fenêtre de contexte de l'agent ?
2. Quel est le risque de demander à Claude d'explorer un répertoire entier avec des centaines de fichiers sans préciser de périmètre ?
3. Lors d'une compaction (`/compact`), que deviennent les règles écrites dans le fichier `CLAUDE.md` situé à la racine ?
4. Comment éviter qu'une vaste recherche dans les logs applicatifs ne vienne polluer votre session principale ?

# Comprendre les sources de contexte dans Claude Code

**Durée : 20 minutes**

## Objectif de la leçon
Comprendre l'anatomie et l'alimentation de la fenêtre de contexte pour éviter la saturation ("pollution") et apprendre à guider l'agent de manière chirurgicale. Un contexte maîtrisé donne un agent puissant et obéissant.

---

# 1. Anatomie de la fenêtre de contexte

```text
Environnement / dépôt
        ↓
beaucoup d'informations disponibles
        ↓
Claude récupère ce qui est nécessaire
        ↓
FENÊTRE DE CONTEXTE
        ↓
informations chargées ou résumées
        ↓
raisonnement et réponse
```

---

# 2. Survivre à la Compaction

```text
La compaction condense les anciens échanges pour regagner de l'espace.

[RECHARGÉ AUTOMATIQUEMENT]
- CLAUDE.md (racine)
- Serveurs MCP
- Mémoire automatique
- Règles sans portée (globales)

[CONDENSÉ (Perte de détails)]
- Anciennes conversations (résumées)
- Fichiers lus très tôt
- Longues sorties d'outils

[ATTENTION (Disparaît si non utilisé)]
- Les descriptions des *skills* (si non invoquées avant la compaction)
```

# Tableau des commandes à retenir

| Commande | Rôle |
|---|---|
| `/context` | Affiche l'utilisation actuelle du budget de contexte sous forme de grille. |
| `/compact` | Transforme l'historique de chat en résumé structuré pour libérer de l'espace. |
| `/clear` | (Aperçu) Efface le contexte pour repartir d'une session vierge. |

---

# Fiche finale de synthèse

| Catégorie | Notion | Rôle |
|---|---|---|
| Fondamentale | Fenêtre de contexte | Informations que Claude peut utiliser maintenant |
| Observation | `/context` | Voir l’utilisation du budget de contexte |
| Démarrage | Contexte initial | Certaines informations sont déjà chargées avant le premier prompt |
| Interaction | Messages | Ajoutent objectifs, contraintes, erreurs et décisions |
| Fichiers | Fichiers lus | Deviennent du contexte lorsqu’ils sont lus/référencés/extraits |
| Terminal | Sorties de commandes | Peuvent alimenter et encombrer le contexte |
| Instructions | `CLAUDE.md` | Conventions et instructions durables du projet |
| Mémoire | Mémoire automatique | Apprentissages issus des corrections |
| Instructions | `CLAUDE.md` imbriqués | Instructions adaptées à certaines zones du projet |
| Réutilisation | Skills | Procédures/connaissances chargées lorsqu’elles sont nécessaires |
| Externe | MCP | Accès à des outils et informations externes |
| Instructions | Règles | Instructions générales ou limitées à des chemins |
| Automatisation | Hooks | Actions déclenchées par des événements |
| Agents | Sous-agents | Effectuent des investigations dans un contexte séparé |
| Qualité | Contexte pertinent | Garder seulement les informations utiles |
| Diagnostic | Session polluée | Contexte ancien, contradictoire ou inutile |
| Gestion | `/compact` | Résume la conversation et libère de l’espace |
| Compaction | Rechargement | Certaines sources reviennent, d’autres sont condensées |

# Les 5 points les plus importants

1. **Le Dépôt n'est pas le Contexte** : L'agent ne "connaît" que ce qu'il a explicitement lu ou ce qui est configuré au lancement.
2. Soyez **chirurgical** : Évitez les requêtes larges ou les commandes générant des milliers de lignes de logs.
3. Observez régulièrement `/context` pour identifier les outils ou fichiers qui accaparent votre budget mémoire.
4. Les symptômes d'un **contexte pollué** incluent : oublis récents, régression sur des tâches terminées, ou verbiage excessif.
5. Après une **compaction**, la configuration "dure" (`CLAUDE.md`, MCP) est restaurée, mais les détails anciens et les descriptions de skills non-invoquées sont perdus.

---

# Carte mentale

```text
CONTEXTE CLAUDE CODE
│
├── Fenêtre de contexte
│   ├── limitée
│   ├── informations chargées
│   └── informations résumées
│
├── Sources
│   ├── messages
│   ├── fichiers lus
│   ├── commandes
│   ├── CLAUDE.md
│   ├── mémoire
│   ├── skills
│   ├── MCP
│   └── règles
│
├── Actions
│   ├── hooks
│   └── sous-agents
│
├── Bonne gestion
│   ├── lectures ciblées
│   ├── commandes courtes
│   ├── résultats MCP ciblés
│   └── éviter les contenus inutiles
│
└── Quand le contexte grossit
    │
    ├── pollution possible
    │
    └── /compact
        ├── résume
        ├── libère de la place
        └── peut perdre des détails
```

---

# Mini fiche de révision

```text
Formule à mémoriser (Démarrage) :
CLAUDE CODE N'EST PAS VIDE ET CLAUDE CODE NE CHARGE PAS TOUT.
-> Il y a un contexte initial (MCP, mémoire, CLAUDE.md) mais PAS tout le dépôt.

Pollution : Causée par des sorties de commandes trop longues, exploration non ciblée.
Remède : Utiliser /context pour mesurer, /compact pour purger.
Astuce : Les sous-agents isolent le contexte d'une recherche lourde pour ne renvoyer qu'un résumé.
```

> **Phrase à retenir** : Le contexte n'est pas seulement une ressource consommée par Claude, c'est un espace de travail que vous devez construire et protéger avec rigueur.
