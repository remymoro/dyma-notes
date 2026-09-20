---
title: "Structurer les instructions : rules et imports"
description: "Organiser les instructions de projet avec .claude/rules/ et @path pour optimiser le contexte."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - rules
  - optimisation
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 04-structurer-instructions-rules-imports
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-02
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **L'import `@path` réduit-il la consommation de tokens ?** | **Non**. Les fichiers importés via `@path` sont développés et chargés *intégralement* avec le fichier parent. C'est un outil d'organisation (DRY), pas un outil de chargement conditionnel. |
| **Comment lier une documentation sans forcer son chargement ?** | Utilisez des backticks : `` `docs/migration.md` ``. Hors backticks, `@README.md` importe tout le fichier. Dans les backticks, c'est juste un chemin que Claude lira *seulement s'il en a besoin*. |
| **À quoi sert le dossier `.claude/rules/` ?** | À découper les instructions en fichiers thématiques autonomes (ex: `testing.md`, `security.md`). Cela évite d'avoir un fichier `CLAUDE.md` énorme ("fourre-tout"). |
| **Comment cibler une règle sur un dossier spécifique ?** | Utilisez le frontmatter YAML `paths:` en haut du fichier de règle. Ex: `paths: ["src/api/**/*.ts"]`. La règle ne sera chargée dans le contexte que lorsque Claude *lira* ou *travaillera* sur ces fichiers. |
| **Quel est le piège majeur des règles avec `paths` (globs) ?** | Elles ne se déclenchent que si Claude *lit* ou *édite* un fichier correspondant. Lors de la **création** d'un nouveau fichier (qui n'existe pas encore), la règle risque de ne pas être chargée dans le contexte ! |
| **Quelle est la différence entre une règle et une Skill ?** | Une règle dit *comment se comporter* dans une zone (ex: "Utilise tel format de date"). Une Skill décrit *comment exécuter un workflow* multi-étapes (ex: "Procédure de release en 10 étapes"). |

## Synthèse
Lorsque le projet grandit, le fichier `CLAUDE.md` central devient rapidement trop lourd, ce qui consomme du contexte inutilement et dilue l'adhérence de l'agent aux instructions. Pour résoudre cela, il faut structurer l'information. L'import `@path` permet de mutualiser des fichiers communs (comme un `AGENTS.md` existant), mais ne réduit pas la taille du contexte. Pour un vrai chargement conditionnel, il faut utiliser le dossier `.claude/rules/`. En créant des fichiers thématiques (ex: `react.md`) dotés d'un bloc YAML `paths:`, on s'assure que les conventions frontend ne sont chargées *que* lorsque l'agent travaille sur le frontend. Enfin, les documentations longues (historiques de migration) doivent rester dans un dossier de notes et n'être pointées que par leur chemin littéral (entre backticks), tandis que les workflows répétitifs doivent être extraits sous forme de *Skills*.

## Glossaire
- **`@path`** : Syntaxe d'import direct dans un `CLAUDE.md`. (Le contenu est concaténé au chargement).
- **`.claude/rules/`** : Dossier magique découvert récursivement par Claude Code, conçu pour héberger des règles thématiques.
- **Règle inconditionnelle** : Fichier dans `rules/` sans champ `paths`. Se charge globalement comme `CLAUDE.md`.
- **Règle conditionnelle (`paths:`)** : Fichier dans `rules/` avec un frontmatter YAML. Ne se charge *que* lorsque l'agent lit ou manipule les fichiers visés par les globs.
- **Backticks (`` `chemin` ``)** : Permet de mentionner un fichier sans déclencher l'importation de son contenu.

## Questions d'auto-évaluation
1. J'ai mis un énorme guide d'architecture dans `CLAUDE.md` avec la syntaxe `@docs/architecture.md`. Ai-je réduit ma consommation de contexte ?
2. Je veux que Claude vérifie la sécurité seulement quand il modifie les fichiers sous `src/server/`. Comment l'implémenter ?
3. Je crée un fichier `.claude/rules/misc.md` avec toutes les petites consignes restantes. Est-ce une bonne pratique ?
4. J'ai une règle avec `paths: ["**/*.test.ts"]` qui dit d'utiliser `describe/it`. Claude doit créer un nouveau fichier de test en partant de zéro. La règle va-t-elle s'appliquer ?

# Structurer les instructions : rules et imports

**Durée : 15 minutes**

## Objectif de la leçon
Apprendre à fragmenter un gros `CLAUDE.md` en utilisant les imports (`@path`) pour l'organisation, et le dossier `.claude/rules/` (avec ses métadonnées `paths`) pour le chargement conditionnel, afin d'optimiser le contexte de l'agent.

---

# 1. Ne confondez pas "Organiser" et "Économiser du contexte"

### L'import `@path` (Organiser)
Vous pouvez inclure un fichier dans un autre avec `@chemin/vers/fichier.md`.
**Attention :** Le fichier importé est complètement déplié au chargement. Cela *n'économise pas* de tokens de contexte. C'est juste utile pour éviter de dupliquer du texte (le fameux principe DRY).

### Les chemins littéraux en backticks (Économiser)
Si vous avez une longue documentation de migration API, ne l'importez pas. Dites plutôt à Claude où elle se trouve pour qu'il aille la lire **uniquement s'il en a besoin**.
```markdown
# Dans CLAUDE.md
Pour voir la documentation de la migration API, lis le fichier `docs/migration-api.md`.
```
*(L'utilisation des backticks `` ` `` empêche le parseur de faire un import global).*

---

# 2. Le dossier magique `.claude/rules/`

Quand votre projet grandit, remplacez votre gros `CLAUDE.md` par des petits fichiers thématiques (un par sujet) : `testing.md`, `security.md`, `api.md`.
Placez-les dans un dossier `.claude/rules/`. Claude les découvrira automatiquement.

*Astuce : Ne nommez jamais vos fichiers `misc.md` ou `toutes-les-regles.md`. Le nom du fichier compte pour la lisibilité humaine et agentique.*

---

# 3. Le vrai chargement conditionnel : `paths`

C'est ici que l'on gagne de la performance. Vous pouvez limiter le chargement d'une règle *uniquement* lorsque Claude travaille dans les bons dossiers.

Pour cela, on utilise le Frontmatter YAML en haut du fichier Markdown :

**Fichier : `.claude/rules/backend.md`**
```yaml
---
paths:
  - "src/server/**/*.ts"
  - "src/db/**/*.ts"
---
# Règles Backend
- Ne jamais utiliser de SQL brut, utiliser le Repository.
```
*Ici, si l'agent modifie un composant React dans `src/components/`, cette règle backend **ne sera pas chargée** dans son contexte !*

### Le piège de la "Création"
La règle `paths` se déclenche quand l'agent **lit** ou **édite** un fichier correspondant.
S'il est chargé de **créer** un nouveau fichier de zéro, la règle ne s'activera peut-être pas (puisque le fichier n'existe pas encore pour déclencher le glob !).
Pour les conventions obligatoires à la création pure, laissez la règle en global (sans `paths`) ou utilisez un Hook.

---

# 4. Quelle structure choisir ? La matrice décisionnelle

Ne mettez pas tout dans `.claude/rules/`. Voici la bonne répartition :

| Type de contenu | Destination |
|---|---|
| Commande officielle de test CI | `CLAUDE.md` (Noyau permanent) |
| Conventions de code pour React | `.claude/rules/react.md` avec `paths: ["**/*.tsx"]` |
| Historique complet des choix d'architecture | `docs/claude-notes/archi.md` (mentionné avec des backticks) |
| Procédure de release en 10 étapes | Dossier **Skill** |
| Refus de lire les clés AWS | Permissions `deny` ou Hooks |

---

# Cartes mentales

```text
               RÉDUIRE LA TAILLE DU CONTEXTE
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
   SÉPARER PAR ZONE      DOCUMENTER     PROCÉDURER
           │               │               │
     .claude/rules/    docs/notes.md    Les Skills
   avec YAML "paths"   (Chemins dans  (Workflows longs)
   (Chargement auto     backticks)
    si fichier lu)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Arborescence idéale d'un projet standard
project/
  CLAUDE.md             ← Noyau court et permanent
  .claude/
    rules/
      testing.md        ← Règle thématique (globale ou avec paths)
      security.md
  docs/
    claude-notes/
      historique.md     ← Doc longue, lue à la demande
```

> **La phrase centrale de la leçon :**
> Utiliser `@path` aide à ranger mais coûte toujours autant de contexte. Pour vraiment alléger la session, il faut utiliser `.claude/rules/` couplé au champ YAML `paths`, ou mentionner les docs lourdes entre backticks pour forcer une lecture à la demande.
