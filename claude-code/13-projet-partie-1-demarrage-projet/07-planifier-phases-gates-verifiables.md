---
title: "Planifier par phases avec des gates vérifiables"
description: "Comment décomposer une tranche verticale en phases d'implémentation testables, et verrouiller le comportement d'un parseur Markdown pur avant de l'implémenter."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - planification
  - tdd
  - parsing
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 07-planifier-phases-gates-verifiables
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-03
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi écrire DEUX niveaux de plans avant de coder ?** | Le premier plan (`tranche-verticale.md`) fixe la direction "macro" (l'ordre des phases de toute la tranche, de l'entrée CLI jusqu'au rendu final). Le deuxième plan (Plan de la Phase 1) fixe le "micro" (contrats d'interfaces, cas limites à tester) pour éviter de s'enfermer dans un algorithme hasardeux. |
| **Quel est l'ordre des 4 phases de la Tranche Verticale ?** | **1.** Parsing Markdown (core) ➔ **2.** Règles d'audit (core) ➔ **3.** Branchement CLI (entrées/sorties) ➔ **4.** Fixtures et Dogfooding. L'ordre garantit qu'on ne branche l'I/O qu'une fois le moteur pur testé et validé. |
| **Pourquoi demander à l'agent de chercher les "ambiguïtés" avant de faire le plan détaillé ?** | Parser du Markdown paraît simple, mais cache plein de cas limites : fins de ligne CRLF vs LF, BOM caché, blocs de code non fermés, titres de niveaux différents qui s'enchaînent. Si on laisse l'agent coder directement, il fera des choix invisibles dans des regex illisibles. En les remontant d'abord, on décide du comportement métier attendu. |
| **Qu'est-ce qu'une "section plate" par opposition à un "arbre imbriqué" ?** | Le parseur ne cherche pas à savoir si le titre `###` est "l'enfant" du titre `##`. Dès qu'il voit un titre (quel que soit le niveau), il ferme la section précédente et en ouvre une nouvelle. C'est beaucoup plus simple, et c'est suffisant pour les règles métier de cette tranche. |
| **Pourquoi le parseur doit-il rester masqué (`interne`) dans le core ?** | Si on l'exporte dans `packages/core/src/index.ts`, il devient une API publique. Cela engagerait le projet à maintenir cette API pour des utilisateurs externes, alors qu'il n'est qu'un détail d'implémentation interne pour les règles de la v1. |
| **À quoi ressemble le plan de phase final ?** | Il liste les fichiers précis à créer (`markdown.ts`, `markdown.test.ts`), les interfaces précises (`Section`, `ParsedMarkdown`), les 11 cas limites à tester (Fichier vide, Titre dupliqué, etc.), et les commandes de validation à exécuter à la fin. Toujours sans avoir écrit une seule ligne de logique. |

## Synthèse
La leçon illustre la bascule entre le cadrage global (Design Doc) et le travail d'implémentation. Mais au lieu de sauter sur le clavier, on planifie l'implémentation. On crée d'abord un fichier `tranche-verticale.md` qui divise le travail en 4 phases chronologiques, en commençant par le plus bas niveau (le parseur Markdown dans le `core`), puis les règles, puis le CLI. Ensuite, on zoome sur la Phase 1 (le parseur). Au lieu de laisser l'agent improviser son algorithme, on lance un "sous-agent d'exploration" qui liste toutes les ambiguïtés du parsing Markdown (CRLF, blocs de code ignorés, titres Setext vs ATX). On tranche ces ambiguïtés pour formuler un plan de phase extrêmement rigoureux. Ce plan fige les interfaces (`Section`, `ParsedMarkdown`), détermine l'algorithme (une seule passe ligne par ligne) et définit 11 groupes de tests unitaires couvrant tous les cas limites. L'agent sait exactement ce qu'il devra coder à la prochaine étape, et comment le valider, sans avoir encore rien implémenté.

## Glossaire
- **Plan Macroscopique (`tranche-verticale.md`)** : Document découpant une fonctionnalité transverse (du CLI au Moteur) en phases séquentielles, avec des jalons d'entrée et de sortie.
- **Plan de Phase (Contrat d'implémentation)** : Plan détaillé d'une seule phase. Il spécifie les types, les signatures de fonctions, les cas d'usage et les tests à écrire.
- **Section Plate** : Structure de données en liste `[Section1, Section2]` sans notion de hiérarchie parent/enfant.
- **Titres ATX** : Titres Markdown utilisant les dièses (ex: `### Titre`). C'est le seul format reconnu par ce parseur (excluant les titres Setext avec `===` en dessous).
- **Dogfooding** : Fait d'utiliser son propre outil sur son propre projet (Phase 4).

## Questions d'auto-évaluation
1. Pourquoi est-il dangereux de dire à Claude Code "Implémente un parseur de Markdown" sans lister au préalable les ambiguïtés et cas limites ?
2. Selon le plan de la Phase 1, que se passe-t-il si un fichier Markdown contient un bloc de code (` ``` `) qui n'est jamais refermé ?
3. Le parseur est-il censé analyser la validité de l'ordre des titres (ex: vérifier qu'un `###` n'arrive pas avant un `##`) ?
4. Pourquoi demande-t-on expressément à ce que la fonction de parsing ne soit pas exportée dans `packages/core/src/index.ts` ?

# Planifier par phases avec des gates vérifiables

**Durée : 25 minutes**

## Objectif de la leçon
Passer de l'architecture macroscopique à l'implémentation en utilisant la technique de la double planification (Tranche > Phase) et la levée des ambiguïtés via un agent explorateur.

---

# 1. Le premier niveau : Le Plan de Tranche (`tranche-verticale.md`)

Avant de coder, on découpe le travail en phases. L'ordre d'implémentation est primordial. On commence toujours par le code pur sans dépendances (le moteur), pour finir par la couche d'I/O (le CLI).

**Les 4 phases de notre tranche verticale :**
- **Phase 1** : Parsing Markdown minimal (Moteur pur, `core`).
- **Phase 2** : Implémentation des 3 règles `MEM` (Moteur pur, `core`).
- **Phase 3** : CLI de bout en bout (Branchement moteur + I/O).
- **Phase 4** : Fixtures, Snapshots et Dogfooding.

Ce plan est enregistré à la racine du projet (`tranche-verticale.md`) pour que l'agent ne perde jamais la vue d'ensemble.

---

# 2. Le deuxième niveau : Le Plan de Phase (Spécification)

Plutôt que de coder la **Phase 1** immédiatement, il faut l'étudier. Parser du Markdown est le meilleur moyen d'accumuler des bugs silencieux et des comportements inattendus.

**L'astuce de l'Agent d'Exploration :**
Au lieu de donner toutes les instructions, demandez à un agent de réfléchir :
> *"Avant de produire le plan d'implémentation de la phase 1, recherche les ambiguïtés du parsing Markdown minimal, liste les cas limites et propose une recommandation. Ne modifie aucun fichier."*

---

# 3. Trancher les ambiguïtés (Les choix cachés)

Le rapport de l'agent va lever les lièvres. Vous fixez ensuite les règles métier du parseur.

- **Titres :** On ignore les titres Setext (`===`), on n'accepte que les ATX (`### Titre`).
- **Structure :** On ne fait pas d'arbre complexe parent/enfant. C'est une liste de "sections plates" (un titre = une nouvelle section, point).
- **Fences (Blocs de code) :** Tout ce qui est à l'intérieur d'un bloc de code `` ``` `` est ignoré (on n'y cherche pas de titre). Si une fence n'est pas fermée, la fin du fichier est considérée comme du code.
- **Prologue :** Tout le texte avant le premier titre est gardé dans une propriété `prologue`.

Ces décisions permettent de concevoir une fonction **pure** en une seule passe, beaucoup plus robuste.

---

# 4. Définir le Contrat (Les Interfaces)

Le plan de phase inclut explicitement les interfaces TypeScript attendues. L'agent n'a plus qu'à s'y conformer :

```typescript
export interface Section {
  readonly level: number;
  readonly title: string;
  readonly headingLine: number;
  readonly lines: readonly string[];
}

export interface ParsedMarkdown {
  readonly lines: readonly string[];
  readonly prologue: readonly string[];
  readonly sections: readonly Section[];
}
```

> [!IMPORTANT]
> **API Publique vs Détail Interne**
> Le parseur est un outil interne au `core`. Le plan stipule expressément qu'il ne doit **pas** être exporté via le `index.ts` principal du package. Ce niveau de précision évite d'engager la responsabilité publique du package sur un parseur basique.

---

# 5. Verrouiller par les Tests d'abord

Le plan de phase liste les 11 cas de tests (Nominal, CRLF/LF, Fichier vide, Fence non fermée, BOM, etc.) qui devront être codés dans `markdown.test.ts`.

La toute dernière rubrique du plan définit la **Gate (Jalon de fin)** :
- Exécuter `pnpm run test` (les 11 tests doivent passer).
- Exécuter `pnpm run typecheck` (pas d'erreurs TypeScript).
- S'arrêter. (L'agent ne doit pas enchaîner sur la Phase 2 !).

---

# Cartes mentales

```text
                  LA DOUBLE PLANIFICATION (TDD PILOTÉ PAR AGENT)
                                      │
            ┌─────────────────────────┴─────────────────────────┐
            ↓                                                   ↓
   1. PLAN MACROSCOPIQUE (Tranche)                    2. PLAN MICROSCOPIQUE (Phase 1)
   (Document : tranche-verticale.md)                  (Contrat d'implémentation)
            │                                                   │
    - Ordre des 4 phases                              - Détection des ambiguïtés (CRLF, etc)
    - Objectifs de chaque phase                       - Choix d'algorithme (1 passe, liste plate)
    - Jalons de validation                            - Interfaces TypeScript figées
                                                      - 11 Cas de tests listés
                                                      - Commandes de validation finales
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Avant d'autoriser l'agent à créer un fichier `.ts` métier :
1. Produire un fichier récapitulant les phases de toute la feature (`tranche-verticale.md`).
2. Pour la phase courante, demander à un agent de lister les ambiguïtés cachées (edge cases).
3. Rédiger le plan détaillé fixant les comportements, les interfaces (types) et les tests à couvrir.
4. Ajouter les commandes de vérification (`test`, `typecheck`) comme condition d'arrêt.
=> Ce n'est qu'ensuite qu'on donne le go pour l'implémentation (ce qui sera fait à la leçon 8).
```

> **La phrase centrale de la leçon :**
> Laisser un LLM concevoir et coder un algorithme de parsing en une seule étape, c'est l'assurance d'obtenir une boîte noire truffée de choix implicites ; forcer l'agent à planifier les interfaces, les cas limites et les tests avant toute implémentation est le secret d'un code prédictible et robuste.
