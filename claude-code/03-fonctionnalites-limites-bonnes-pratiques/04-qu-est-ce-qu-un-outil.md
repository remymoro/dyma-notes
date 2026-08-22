---
title: "Qu'est-ce qu'un outil ?"
description: "Comprendre le concept d'outil (tool use / function calling) et le cycle de communication entre le LLM et le système hôte."
date: 2026-08-15
draft: true
tags:
  - llm
  - outils
  - function-calling
  - api
categories:
  - "Chapitre 3"
cours: Claude Code
chapitre: 03-fonctionnalites-limites-bonnes-pratiques
leçon: 04-qu-est-ce-qu-un-outil
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Qu'est-ce qu'un outil ? | Passerelle externe (API, script, base de données) permettant au LLM d'agir hors de sa mémoire passive. |
| Comment est décrit un outil ? | Par un **nom**, une **description** (pourquoi l'utiliser) et un **JSON Schema** (arguments requis). |
| Qui exécute le code d'un outil ? | Le **système hôte** (l'application CLI/serveur), jamais le modèle lui-même. |
| Quel est le cycle de vie d'un appel ? | 1. Prompt ──> 2. Tool Call (IA) ──> 3. Execution (Hôte) ──> 4. Tool Result ──> 5. Réponse (IA). |
| Enjeux de sécurité ? | Encadrer les droits d'écriture, valider les schémas et exiger des autorisations sur les actions sensibles. |

## Synthèse
Un outil (ou *function calling*) permet à un LLM de dépasser le cadre d'un simple générateur de texte en sollicitant des services externes (fichiers, bases de données, recherches web). Le modèle n'exécute pas le code lui-même : il émet une intention d'appel en JSON que l'application hôte exécute avant de lui restituer le résultat.

## Glossaire
- **Function Calling** : Capacité d'un LLM à formuler une réponse sous forme d'arguments d'appel de fonction structurés.
- **JSON Schema** : Format décrivant le nom et le type des paramètres d'entrée exigés par un outil.
- **Système Hôte** : Application locale ou serveur qui exécute l'outil demandé par le modèle.
- **Tool Call / Response** : Paire de messages comprenant l'intention d'appel émise par l'IA et la réponse brute retournée par l'outil.

## Questions d'auto-évaluation
1. Pourquoi la description textuelle d'un outil est-elle indispensable pour que le modèle choisisse de l'invoquer au bon moment ?
2. Quel est le rôle exact du système hôte lors de l'exécution d'un outil ?
3. Pourquoi l'utilisation d'un outil de calculatrice améliore-t-elle la fiabilité des opérations mathématiques d'un LLM ?
4. Quels risques de sécurité existent si un outil permet de modifier arbitrairement des fichiers système ?

# Qu'est-ce qu'un outil ?

**Durée : 13 minutes**

## Objectif de la leçon
Comprendre le principe du *function calling*, l'échange de messages entre le LLM et l'application hôte, et les garanties de sécurité associées.

---

# 1. Le Cycle d'Exécution d'un Outil (Tool Use)

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      CYCLE D'APPEL D'UN OUTIL                           │
│                                                                         │
│  [1. Utilisateur] ──> Question ──> [2. LLM]                             │
│                                       │ (Demande un Tool Call JSON)     │
│                                       ▼                                 │
│  [5. Réponse]    <── Réponse <── [3. Hôte / CLI] ──> [4. Outil Externe] │
│                                  (Exécute le script/API)                │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 2. Anatomie de la Déclaration d'un Outil (JSON Schema)

```json
{
  "name": "lire_fichier",
  "description": "Lit le contenu d'un fichier du projet à partir de son chemin.",
  "input_schema": {
    "type": "object",
    "properties": {
      "chemin": { "type": "string", "description": "Chemin absolu ou relatif" }
    },
    "required": ["chemin"]
  }
}
```

---

# Résumé & Schéma global

```text
                     CONNEXION DU MODEL AU MONDE RÉEL
                                    │
       ┌────────────────────────────┼────────────────────────────┐
       ▼                            ▼                            ▼
  Description                  Tool Call                    Tool Result
(Rôle & Arguments)          (Intention de l'IA)          (Données système)
```

# Tableau récapitulatif des rôles

| Acteur | Rôle dans l'appel d'outil |
|---|---|
| **Le LLM** | Détecte le besoin, choisit l'outil et prépare la structure JSON. |
| **Le Système Hôte** | Vérifie les permissions, exécute l'action physique et capture la sortie. |
| **L'Outil Externe** | API Web, base de données ou commande terminal exécutant l'instruction. |

# Les 5 points les plus importants

1. **Le LLM n'exécute pas d'outils directement** : il émet une intention sous forme de structure JSON.
2. **C'est le système hôte (l'application CLI/IDE)** qui exécute physiquement la commande.
3. **La description de l'outil est essentielle** pour orienter la décision du modèle.
4. **Le résultat de l'outil est réinjecté dans le contexte** sous forme de `Tool Response`.
5. **Les actions destructrices nécessitent une validation** humaine explicite.

---

# Carte mentale

```text
Qu'est-ce qu'un outil ?
│
├── Concept & Définition
│   ├── Dépasser le texte pur
│   └── Accès aux données réelles (Web, BDD, Fichiers)
│
├── Mécanique (Function Calling)
│   ├── JSON Schema & Parameters
│   └── Séquence : Intent → Execute → Result
│
└── Sécurité & Exécution
    ├── Rôle du système hôte
    └── Contrôle des permissions
```

---

# Mini fiche de révision

```text
Function Calling → Capacité du LLM à formuler un appel d'outil JSON
Tool Call        → Intention émise par le modèle avec arguments
Tool Response    → Résultat de l'action renvoyé dans le contexte
Système hôte     → Programme qui exécute l'outil (ex: Claude Code)
```

> **Phrase à retenir** : Les outils transforment l'IA d'un conseiller bavard en un agent capable d'interagir avec les fichiers et l'environnement réel.
