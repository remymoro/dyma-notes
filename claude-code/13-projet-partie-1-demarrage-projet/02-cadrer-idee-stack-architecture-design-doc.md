---
title: "Cadrer l'idée, la stack et l'architecture avec Claude Code"
description: "Comment utiliser Claude Code comme partenaire de réflexion pour générer un Design Doc avant de coder."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - design-doc
  - architecture
  - prompt
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 02-cadrer-idee-stack-architecture-design-doc
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-03
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quel est le but d'une session de cadrage ?** | Forcer l'agent à agir comme un **partenaire d'architecture**, sans écrire une seule ligne de code. Le livrable unique est un fichier `design-doc.md`. |
| **Que doit contenir le prompt de cadrage ?** | 1. Le rôle ("partenaire d'architecture et de critique").<br>2. L'interdiction formelle de coder.<br>3. Le livrable attendu (les 8 sections du design doc).<br>4. Un déroulé en étapes (interview ciblée).<br>5. Des garde-fous stricts. |
| **Pourquoi imposer l'utilisation de `[OUVERT: question]` ?** | Les agents ont tendance à "halluciner" ou inventer des réponses plausibles pour boucher les trous. Ce marqueur force l'IA à exposer explicitement ce qu'elle ne sait pas, évitant de transformer une supposition en contrainte. |
| **Pourquoi demander à l'agent de *nous* interviewer ?** | L'agent a l'expérience de milliers de projets. En lui demandant de poser des questions (par lots de 5), il identifiera les trous dans notre réflexion (ex: "Quel comportement de sortie pour le CLI ?"). |
| **Pourquoi exiger que le brouillon soit rédigé *dans la conversation* ?** | Pour distinguer la "proposition" (réversible et facile à corriger) de la "décision" (écriture sur le disque). L'agent ne doit écrire le fichier `design-doc.md` qu'après un `go` explicite. |
| **Pourquoi lister les "Alternatives écartées" ?** | Pour se souvenir du *trade-off* (compromis) qui a mené au rejet d'une option. Ex: "On rejette Go/Rust car Node.js est déjà connu de l'équipe, bien que Go soit plus rapide au démarrage." |

## Synthèse
Le démarrage d'un projet de zéro avec une IA ne doit jamais consister à lui dire "Crée-moi cette application". Si l'intention est floue, l'agent prendra des décisions architecturales arbitraires (souvent les plus populaires, pas les plus adaptées). Le but de cette première étape est de l'utiliser comme un **architecte consultant**. Le prompt de départ est ultra-contraint : il interdit tout code, exige que l'agent vous interviewe pour clarifier le produit (surface, utilisateurs cibles, contraintes), et oblige à consigner le résultat dans un unique `design-doc.md`. Ce processus en plusieurs tours ("interview -> recommandation -> relecture dans le chat -> écriture du fichier") permet de fermer le périmètre, d'établir des invariants d'architecture fermes (ex: séparation stricte entre *core* et *CLI*), et de lister les alternatives rejetées pour documenter les compromis.

## Glossaire
- **Design Doc** : Le livrable unique du cadrage, contenant 8 sections (Contexte, Objectifs/Non-objectifs, Design, Alternatives, Invariants, Gates, Questions ouvertes, Verdict).
- **`[OUVERT: question]`** : Garde-fou imposé dans le prompt pour forcer l'agent à signaler les trous de spécification plutôt que de les combler avec de fausses évidences.
- **Tranche verticale (Vertical Slice)** : Le plus petit comportement de bout-en-bout (ex: un scan complet d'un fichier avec sortie console) permettant de valider l'architecture.
- **Invariants d'architecture** : Règles strictes qui ne doivent jamais être violées (ex: "Le package `core` ne fait aucune I/O, il ne touche jamais au système de fichiers").

## Questions d'auto-évaluation
1. Si je lance un projet de zéro et que je laisse Claude Code créer le `package.json` tout de suite, quel est le risque principal ?
2. À quoi sert la section "Non-objectifs" lors de cette phase ?
3. Dans la méthodologie décrite, quand l'agent est-il autorisé à créer le fichier `design-doc.md` sur le disque ?
4. Si l'agent doit choisir entre un moteur LLM et des règles déterministes codées, comment gère-t-il l'option non retenue dans le document ?

# Cadrer l'idée, la stack et l'architecture avec Claude Code

**Durée : 20 minutes**

## Objectif de la leçon
Apprendre à maîtriser "l'angoisse de la page blanche" en utilisant Claude Code non pas comme un exécutant qui code, mais comme un Lead Tech qui vous challenge et rédige le cahier des charges (`design-doc.md`).

---

# 1. Le principe de base : Zéro code !

Nous partons d'un dossier totalement vide. 
Le piège classique : *"Je veux créer Claudoscope, un linter de configurations. Crée le projet."*
Conséquence : L'agent invente une architecture, choisit une stack arbitraire, et commence à commence à créer des fichiers.

**Le premier livrable N'EST PAS du code.** C'est un `design-doc.md`.

Pendant toute cette session, Claude Code est un **partenaire d'architecture**. Il a l'interdiction formelle de coder, de créer un `package.json` ou de proposer des lignes de code.

---

# 2. L'art de contraindre l'agent (Le Prompt Initial)

Pour que la session soit productive, le prompt initial est long et très structuré. Il fixe 4 éléments :

1. **Le Rôle** : Partenaire d'architecture et de critique. Interdiction de coder.
2. **Le Livrable** : Un `design-doc.md` avec 8 sections très précises (Contexte, Non-objectifs, Invariants, etc.).
3. **Le Déroulé** : *"Commence par m'interviewer par lots de 5 questions max. Ne réponds pas à ma place."*
4. **Les Garde-fous** : *"Si une information manque, marque-la avec `[OUVERT: question]`. N'invente jamais une réponse plausible."*

> [!TIP]
> **Le pouvoir du marqueur `[OUVERT]`**
> Les LLMs détestent le vide. S'ils ne savent pas, ils inventent. Ce marqueur est une contrainte magique qui force l'agent à admettre son ignorance, vous protégeant ainsi des hallucinations architecturales.

---

# 3. L'Interview Inversée (L'IA vous questionne)

Au lieu de faire un monologue, vous laissez l'IA vous poser les questions structurantes.

### Premier tour : Les choix lourds
L'agent va poser des questions qui changent radicalement le système :
- *Moteur déterministe ou analyse par LLM ?* (Impacte les coûts, la vitesse, la fiabilité).
- *Surface produit ?* (CLI, Web, Extension VSCode ?).

### Deuxième tour : Fermer le périmètre
Une fois la stack choisie (ex: TypeScript + Node), l'agent creuse les détails :
- *Comment gère-t-on la sortie (JSON ou texte) ?*
- *Veut-on de l'auto-correction (`--fix`) dès la v1 ?* (La réponse "Non" devient un **Non-objectif**).

---

# 4. De la validation à l'écriture

C'est ici qu'intervient une nuance cruciale : **On valide dans le chat AVANT d'écrire sur le disque.**

1. L'agent propose une synthèse de la stack et de l'architecture dans la fenêtre de discussion.
2. Vous corrigez les détails (ex: "Non, je veux utiliser `pnpm`, pas `npm`").
3. Vous donnez le feu vert explicite : *"Go. Écris maintenant uniquement le fichier design-doc.md".*

### Que contient le Design Doc final ?

Le document généré (et enregistré sur votre disque) va figer l'architecture pour le reste du développement.
- **Invariants d'architecture** : Règles d'or. Ex : *Le package `@claudoscope/core` est pur, il ne fait jamais de requêtes réseau ou de lecture fichier.*
- **Tranche verticale** : Le chemin exact de la première version. (Commande -> Lecture -> Analyse -> Rapport).
- **Alternatives écartées** : Trace historique des décisions. *Ex : "Nous avons écarté l'option d'un parser complet pour l'instant (surdimensionné), une simple lecture ligne par ligne suffit."*

---

# Cartes mentales

```text
              WORKFLOW DE CADRAGE AVEC CLAUDE CODE
              (Objectif : Obtenir un Design Doc sans générer de code)

                       1. LE PROMPT INITIAL
                                │
        ┌───────────────────────┼───────────────────────┐
        ↓                       ↓                       ↓
   CONTRAINTES            DÉROULÉ IMPOSÉ            GARDE-FOUS
 - Zéro code !         - Interview par lots       - [OUVERT: question]
 - Un seul livrable    - 2 tours maximum          - Ne rien inventer

                                │
                                ↓
                     2. L'INTERVIEW INVERSÉE
                                │
        ┌───────────────────────┴───────────────────────┐
        ↓                                               ↓
  TOUR 1 : FONDATIONS                         TOUR 2 : PÉRIMÈTRE
 - Moteur (LLM ou règles ?)                 - Quels fichiers analysés ?
 - Surface (CLI, Web ?)                     - Formats de sortie ?
 - Stack (TypeScript, Node ?)               - Mode lecture seule ?

                                │
                                ↓
                    3. SYNTHÈSE & VALIDATION
            (Se passe dans le chat, avant d'écrire)
                                │
                                ↓
                       4. LE "GO" FINAL
            Claude génère le `design-doc.md` sur le 
             disque avec ses 8 sections obligatoires 
           (Invariants, Alternatives écartées, etc.)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les 8 sections imposées au Design Doc :
1. Contexte
2. Objectifs / Non-objectifs (Hyper important pour borner !)
3. Design (Surface, Stack, Première tranche verticale)
4. Alternatives écartées (Avec les compromis)
5. Invariants d'architecture (Les lois absolues du projet)
6. Gates de validation (Comment prouver que ça marche)
7. Questions ouvertes (S'il en reste)
8. Verdict final (Go / No-go)
```

> **La phrase centrale de la leçon :**
> Ne demandez jamais à un agent de créer un projet à partir d'une idée floue. Utilisez l'agent pour affiner l'idée par le biais d'une interview inversée, et figez les décisions (et les non-choix) dans un Design Doc avant d'autoriser la moindre ligne de code.
