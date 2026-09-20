---
title: "Cadrer la mémoire projet avec CLAUDE.md et .claude/rules"
description: "Comment extraire du socle technique et du Design Doc une mémoire persistante courte et ciblée, sans la surcharger d'historique."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - claude-md
  - rules
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 05-cadrer-memoire-projet
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi faut-il demander à l'agent de relire le projet *avant* de générer la mémoire ?** | Le `CLAUDE.md` ne doit pas être généré depuis un document abstrait ou des idées en l'air, mais depuis le code réel et les configurations du dépôt. Cela évite les hallucinations et s'assure que la mémoire est ancrée dans la réalité. |
| **Pourquoi réaligner `design-doc.md` et `README.md` ?** | Au fil de la leçon précédente, des décisions d'implémentation ont pu modifier le plan initial (ex: publier le package `core` en plus du `CLI`). Mettre à jour les documents de référence avant de figer la mémoire garantit qu'il n'y a pas de contradiction. |
| **Que doit contenir le fichier `CLAUDE.md` final ?** | Uniquement le contexte "global" : présentation courte du projet, l'architecture en frontières (qui dépend de qui), les commandes usuelles, et la stack technique. |
| **Qu'est-ce qui ne doit *PAS* figurer dans `CLAUDE.md` ?** | Tout l'historique du cadrage : les alternatives écartées, les gates de validation, le catalogue détaillé des règles futures, les fixtures à construire... Ces infos restent dans le `design-doc.md` pour ne pas consommer de jetons inutiles à chaque session. |
| **Pourquoi créer `.claude/rules/claudoscope-core.md` ?** | Pour les consignes hyper-spécifiques à une partie du projet (ex: "Le moteur ne fait aucune I/O et doit être pur"). On utilise le frontmatter `paths: - "packages/core/**"` pour que l'agent ne lise cette règle que s'il travaille sur ce dossier précis, allégeant encore le contexte global. |
| **Quelle est la différence entre "Mémoire" et "Contrôle" ?** | Le `CLAUDE.md` dicte les conventions à l'agent, mais ce n'est qu'un texte. Il ne remplace pas une barrière technique. L'injonction "pas d'I/O" dans la mémoire doit toujours être appuyée par des tests unitaires, du lint ou des analyses statiques pour constituer une vraie protection. |

## Synthèse
Le socle (Walking Skeleton) est validé, il faut maintenant le documenter pour les futures sessions de Claude Code. Cette étape de "création de mémoire" suit une logique stricte : on ne copie/colle pas le cahier des charges. L'agent doit d'abord relire tous les fichiers du socle (package.json, tsconfig, etc.) pour "comprendre" la réalité du dépôt. Ensuite, on lui demande de mettre à jour le `design-doc.md` si des décisions d'architecture ont évolué (ex: changement de stratégie de publication). Enfin, l'agent génère le `CLAUDE.md` avec une contrainte de taille : seules les commandes essentielles, la stack, et la description de l'architecture "macro" y figurent. Tout ce qui relève de l'historique ou du catalogue de fonctionnalités reste dans le `design-doc.md`. Les instructions trop locales (ex: comment coder une règle dans le package `core`) sont externalisées dans un fichier `.claude/rules/claudoscope-core.md` ciblé avec un `paths`. Ainsi, la mémoire de l'agent est extrêmement concise et optimisée pour la consommation de tokens.

## Glossaire
- **Réalignement** : Action de mettre à jour les documents de conception (ex: `design-doc.md`) pour qu'ils reflètent les décisions prises pendant la phase d'architecture/audit, avant de s'en servir comme référence pour l'avenir.
- **Règles ciblées (`.claude/rules/*.md`)** : Mécanisme permettant d'injecter des instructions spécifiques à l'agent uniquement lorsqu'il modifie des fichiers correspondants au motif `paths` défini dans l'en-tête (frontmatter) du fichier.
- **Barrière technique (Contrôle déterministe)** : Outils automatiques (TypeScript, ESLint, Tests) qui garantissent qu'une règle architecturale est respectée, indépendamment de la consigne textuelle donnée à l'agent dans le `CLAUDE.md`.

## Questions d'auto-évaluation
1. Si l'on écrit dans `CLAUDE.md` : "Toutes les règles d'audit doivent être des fonctions pures", est-ce suffisant pour garantir la fiabilité du projet ?
2. Quel fichier doit-on modifier si on veut ajouter une consigne qui ne s'applique qu'au dossier `packages/cli` ?
3. Le catalogue détaillé des futures fonctionnalités (ici, les règles MEM001, MEM002...) doit-il être placé dans le `CLAUDE.md` ? Pourquoi ?
4. Avant de générer le `CLAUDE.md`, que demande-t-on à l'agent de faire avec le `design-doc.md` et le code généré ?

# Cadrer la mémoire projet avec CLAUDE.md et .claude/rules

**Durée : 20 minutes**

## Objectif de la leçon
Extraire les connaissances essentielles du socle technique fraîchement créé et les injecter dans un `CLAUDE.md` minimaliste, en déportant le contexte hyper-local dans des `.claude/rules`.

---

# 1. Phase de compréhension et de Réalignement

Ne demandez jamais à l'agent : *"Écris le CLAUDE.md"*. 
Il pourrait l'inventer ou se baser sur de simples suppositions.

**Étape A : Exploration**
Demandez à l'agent de lire le `design-doc.md` existant ET de parcourir tous les fichiers du monorepo (les `package.json`, la config `typescript`, les tests vides). 

**Étape B : Réalignement**
Lors des étapes précédentes, l'architecture a pu être modifiée (ex: on a décidé de rendre le package `core` public).
Avant de figer la mémoire, il faut mettre à jour les références :
```text
Mets à jour uniquement design-doc.md et README.md.
Modifications à appliquer :
1. Les deux packages seront publiés (et non plus un seul).
2. Remplace l'ancienne liste de règles par : MEM001, MEM002, MEM003.
Ne crée aucune logique, ne modifie aucun fichier source.
```

---

# 2. Rédiger un CLAUDE.md ultra-concis

Le `CLAUDE.md` sera lu à chaque nouvelle conversation. Son coût en tokens est critique. Il doit être **dégraissé**.

### Ce qu'il doit contenir :
1. **La Présentation** : "Claudoscope est un linter déterministe."
2. **L'Architecture macro** : "Le CLI dépend du Core. Le Core est pur."
3. **Les Commandes** : `pnpm install`, `pnpm build`, `pnpm test`.
4. **La Stack globale** : `Node 20`, `TypeScript strict`, `Vitest`.

### Ce qu'il faut en BANNIR :
- Tout l'historique de pourquoi vous n'avez pas choisi Go ou Rust (Alternatives écartées).
- La liste complète de vos futures fonctionnalités (Le catalogue de règles).
- Le détail complexe de l'implémentation d'une brique spécifique.
Ces informations appartiennent au `design-doc.md` ou aux `rules`.

---

# 3. Alléger la mémoire globale grâce aux Rules

Si vous avez des consignes architecturales très strictes mais localisées, utilisez les règles de Claude Code (`.claude/rules/*.md`).

**Exemple : Cadrer le moteur pur (`packages/core`)**
On crée le fichier `.claude/rules/claudoscope-core.md` avec ce YAML (frontmatter) :
```yaml
---
paths:
  - "packages/core/**"
---
```
Et le contenu suivant :
```markdown
- Le core ne fait aucune I/O : fonctions pures `contenus -> findings`.
- Aucune requête réseau, aucune clé API.
- Toute règle a un id stable, une sévérité, et des tests fixture sain/fautif.
```

Ainsi, si vous demandez à l'agent de modifier le `CLI`, il ne s'encombrera pas l'esprit avec ces contraintes réservées au moteur.

---

# 4. Le piège de "la mémoire magique"

Il y a une différence fondamentale entre **la Mémoire** et **le Contrôle**.

Un agent lit le texte de la règle (`"Le moteur ne fait pas d'I/O"`), et en général il la respectera. Mais parfois, face à un bug complexe, il peut "halluciner" ou s'affranchir de la règle.

**Le `CLAUDE.md` n'est pas une barrière technique.**
Pour protéger véritablement le projet, cette injonction textuelle doit être doublée de barrières déterministes :
- ESLint (pour interdire l'import de `fs` dans ce dossier).
- TypeScript strict.
- Tests unitaires et snapshots.
- Hooks de pre-commit.

---

# Cartes mentales

```text
                  STRUCTURE DE LA MÉMOIRE CLAUDE CODE
                                   │
              ┌────────────────────┼────────────────────┐
              ↓                    ↓                    ↓
         DESIGN DOC            CLAUDE.MD             .CLAUDE/RULES
    (L'Historique et le     (Le Contexte Global)   (Les contraintes locales)
      Cahier des charges)          │                    │
              │             - L'objectif principal      - Fichier 1 (ex: Core)
        - Objectifs         - L'architecture Macro      ↳ paths: packages/core/**
        - Alternativ.       - Commandes (build...)        ↳ "Aucune I/O"
        - Catalogues        - Stack tech                - Fichier 2 (ex: CLI)
        - Arbitrages                                    ↳ paths: packages/cli/**
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Ordre de création de la mémoire :
1. Laisser l'agent explorer le socle vide (Compréhension).
2. Réaligner le `design-doc.md` pour refléter la réalité du code.
3. Rédiger un `CLAUDE.md` court (Stack, Commandes, Architecture macro).
4. Déporter les contraintes de bas niveau dans des `.claude/rules/` ciblées.
```

> **La phrase centrale de la leçon :**
> Le fichier `CLAUDE.md` ne doit pas être un cahier des charges indigeste contenant l'historique du projet ; il doit être une synthèse ultra-courte de l'architecture et des commandes, complétée par des règles ciblées (`.claude/rules`) pour ne fournir le contexte complexe qu'au moment où l'agent modifie les dossiers concernés.
