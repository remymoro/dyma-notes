---
title: "Analyse d'un skill personnalisé"
description: "Comment créer un skill de bout en bout (ex: /techdebt), en maîtrisant le frontmatter YAML, les scripts déterministes et la validation."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - frontmatter
  - automatisation
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 04-analyse-skill-personnalise
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Comment est structurée l'architecture d'un dossier de Skill ?** | Le nom du dossier correspond au nom de la commande (ex: `techdebt` -> `/techdebt`). Il contient `SKILL.md` (qui définit le déclencheur et la procédure), `references/` (qui stocke les conventions métier) et `scripts/` (qui héberge les scripts qui génèrent des données reproductibles). |
| **Pourquoi utiliser un script JS/Bash dans une Skill ?** | Parce que Claude n'a pas besoin de "réfléchir" pour faire un `git diff` ou un `npm test`. Un script `inspecter-projet.mjs` injecte directement les faits bruts dans le contexte (`!node scripts/inspecter-projet.mjs`). Cela économise du temps et oblige Claude à baser son analyse sur des faits concrets. |
| **Que trouve-t-on dans le frontmatter YAML d'un `SKILL.md` ?** | `name`, `description` (crucial pour le déclenchement auto), `argument-hint` (autocomplétion CLI), `allowed-tools` (pré-approuve des outils comme `Read`, `Grep`), et `disallowed-tools` (retire des outils du contexte, comme `Edit` ou `Write`). |
| **Comment injecter le résultat d'une commande directement dans le contexte ?** | En utilisant la syntaxe `!\`commande\`` dans le `SKILL.md` (ex: `!\`node "${CLAUDE_SKILL_DIR}/scripts/inspecter.mjs"\``). |
| **Comment s'assurer qu'une Skill n'a pas d'effets de bord ?** | 1. En ajoutant `Edit` et `Write` dans `disallowed-tools`. 2. En lui interdisant explicitement d'écrire dans la `Procédure`. 3. En exécutant `git status --short` avant et après la skill : l'état doit être strictement identique. |
| **Pourquoi tester explicitement les "faux positifs" du déclenchement automatique ?** | Une description trop générique déclenchera la skill quand vous ne le voulez pas (ex: vous demandez de "corriger le formulaire", Claude lance "l'audit de dette"). Il faut affiner la description jusqu'à ce que seules les demandes explicites d'audit déclenchent `/techdebt`. |

## Synthèse
La création d'une skill "projet" passe par la création d'un dossier (ex: `.claude/skills/techdebt/`). Le cœur de la skill réside dans `SKILL.md`. Ce fichier commence par un Frontmatter YAML (qui définit la description utilisée par Claude pour le "lazy loading", ainsi que les permissions d'outils via `allowed-tools` / `disallowed-tools`).
Pour éviter de surcharger le prompt de détails, on utilise la **divulgation progressive** : la skill indique à l'agent de lire `references/conventions.md` (qui contient les spécificités métier ou les pièges) uniquement si c'est pertinent. De plus, on ajoute un script NodeJS ou Bash dans le dossier `scripts/` que le `SKILL.md` exécute immédiatement via la syntaxe `!\`commande\``. Ce script va collecter les faits "déterministes" (statut git, tests qui passent) et les donner "pré-mâchés" à Claude. L'agent n'a plus qu'à se concentrer sur son expertise : qualifier les problèmes et rédiger le rapport. Une fois la skill écrite, on doit vérifier son déclenchement, son respect du format de sortie, et surtout son absence d'effets de bord.

## Glossaire
- **Frontmatter YAML** : Bloc situé au tout début d'un fichier Markdown délimité par `---`, qui contient des métadonnées (nom, description, outils autorisés).
- **`${CLAUDE_SKILL_DIR}`** : Variable d'environnement interne fournie par Claude Code qui pointe toujours vers le chemin absolu du dossier de la skill en cours d'exécution.
- **Divulgation progressive** : Fait de ne pas tout mettre dans le prompt principal. L'agent commence avec un point d'entrée, puis lit d'autres fichiers (ex: `conventions.md`) au fil de l'eau, si le contexte le justifie.
- **`disallowed-tools`** : Clé YAML dans le frontmatter qui désactive certains outils (ex: `Edit`, `Write`) pour la durée d'exécution de la skill, limitant ainsi drastiquement les risques de casse.

## Questions d'auto-évaluation
1. À quoi sert la syntaxe `$ARGUMENTS` dans un fichier `SKILL.md` ?
2. Quelle commande CLI permet de lister toutes les skills actuellement reconnues par Claude dans votre dépôt ?
3. Pourquoi est-il déconseillé d'écrire "Aide à faire de la dette technique" comme `description` dans le frontmatter YAML ?
4. Comment s'assurer (sans dépendre du frontmatter) que la skill respecte la politique de sécurité globale de l'entreprise (ex: interdire de pousser vers Github) ?

# Analyse d'un skill personnalisé

**Durée : 25 minutes**

## Objectif de la leçon
Décortiquer la création de la skill `/techdebt`, de l'organisation des fichiers à l'injection de scripts automatiques, jusqu'à sa validation fonctionnelle.

---

# 1. Structure d'une Skill mature

Une skill robuste n'est pas un unique fichier Markdown énorme. C'est un dossier.

```text
.claude/skills/techdebt/
├── SKILL.md                     # Chef d'orchestre (frontmatter + procédure)
├── references/conventions.md    # Base de connaissance métier (Lazy loaded)
└── scripts/inspecter-projet.mjs # Fournisseur de faits incontestables (Git/Tests)
```

**Pourquoi séparer ?**
Claude ne lira `conventions.md` que s'il audite des fichiers concernés. Le script NodeJS tourne de manière déterministe et donne un rapport "Git + Tests" instantané. Claude concentre alors ses tokens sur l'*analyse* de cette donnée, au lieu de chercher comment exécuter des commandes.

---

# 2. Le Frontmatter YAML (Configuration)

Le haut du fichier `SKILL.md` est le panneau de contrôle de la skill :

```yaml
---
name: techdebt
description: Analyse la maintenabilité du code ou du diff courant pour détecter la dette technique.
argument-hint: [périmètre optionnel]
allowed-tools:
  - Read
  - Grep
  - 'Bash(node "${CLAUDE_SKILL_DIR}/scripts/inspecter-projet.mjs")'
disallowed-tools:
  - Edit
  - Write
---
```

- **`description`** : C'est le "SEO" de la skill pour le LLM. C'est ce qui fait que Claude décidera de l'utiliser tout seul si vous dites *"Fais un audit de maintenabilité"*.
- **`allowed-tools`** : Pré-approuve des outils. La commande Bash qui lance notre script est pré-approuvée, évitant un prompt bloquant à l'utilisateur.
- **`disallowed-tools`** : Bridage fort. En retirant `Edit` et `Write`, l'agent ne *peut matériellement pas* modifier un fichier. La skill devient 100% "Read-Only".

---

# 3. L'exécution dynamique (Injection de contexte)

Dans le corps de `SKILL.md`, deux syntaxes sont particulièrement puissantes :

1. **`$ARGUMENTS`** : Représente ce que l'utilisateur a tapé après la commande (ex: si l'utilisateur tape `/techdebt src/main.js`, `$ARGUMENTS` sera remplacé par `src/main.js`).
2. **`!\`commande\``** : Claude exécute cette ligne dans le shell et injecte le résultat `stdout` directement dans le prompt avant même de commencer à "réfléchir".

```markdown
## Contexte déterministe
!`node "${CLAUDE_SKILL_DIR}/scripts/inspecter-projet.mjs"`
```
*Note : `${CLAUDE_SKILL_DIR}` évite les problèmes de chemin relatif quel que soit l'endroit d'où est lancée la commande dans le dépôt.*

---

# 4. Définir le comportement attendu (Procédure et Format)

La suite de `SKILL.md` ressemble au plan d'implémentation du chapitre 13 :
- **Procédure** : Une check-list numérotée (1. Lis `conventions.md`, 2. Cherche les duplications, 3. Ne crée pas de commits).
- **Format du rapport** : Une liste stricte de ce que doit contenir la réponse (Fichier concerné, Preuve, Impact, Correction minimale).

> [!TIP]
> **Privilégiez les pièges réels (Gotchas)**
> Ne mettez pas dans `conventions.md` des choses comme "Fais du code propre". Mettez des vrais pièges locaux : `"Number('')` retourne `0`, donc les champs vides passent les validations numériques."

---

# 5. Tester la Skill

Créer la skill ne suffit pas. Il faut valider 3 dimensions :

1. **Test du déclenchement** : Tapez `"Analyse la dette technique"`. La skill s'est-elle déclenchée automatiquement ? Tapez `"Corrige le formulaire"`. La skill s'est-elle abstenue ? (Si oui, votre `description` est bonne).
2. **Test d'absence d'effet de bord** : Faites un `git status`. Lancez `/techdebt`. Refaites un `git status`. Si le code a changé, votre skill est dangereuse.
3. **Test d'utilité** : Posez la même question à Claude **avec** la skill activée, puis **sans** la skill (en l'ayant retirée). Si les deux réponses sont identiques, la skill ne sert à rien. Elle doit apporter une précision indéniable (grâce aux conventions et au format forcé).

---

# Cartes mentales

```text
                  DÉCLENCHEMENT D'UNE SKILL (LE CHEMINEMENT)
                                      │
                 Utilisateur: "Fais un audit de dette"
                                      │
            ┌─────────────────────────┴─────────────────────────┐
            ↓                                                   ↓
   Match la description YAML                             Match échoue
   (Skill invoquée)                                    (Réponse standard)
            │
            ↓
    1. Parse le Frontmatter (Bloque Edit/Write)
    2. Interpole `$ARGUMENTS`
    3. Exécute les commandes `!` (Injecte l'état git/tests)
    4. Envoie tout le `SKILL.md` au LLM
            │
            ↓
    Claude lit les conventions (Divulgation progressive)
    et produit le rapport formaté.
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Cycle de développement d'une Skill :
1. Isoler le besoin (ex: Audit).
2. Créer le script Bash/Node qui récupère les faits fastidieux.
3. Créer le `conventions.md` avec les "gotchas" locaux.
4. Rédiger le `SKILL.md` (YAML restrictif + Procédure numérotée).
5. Tester les déclenchements "faux positifs" et "faux négatifs".
6. Vérifier l'absence d'effets de bord (`git status`).
```

> **La phrase centrale de la leçon :**
> Une skill performante décharge le LLM des opérations déterministes (en injectant l'état des tests via un script) pour concentrer son intelligence sur l'analyse, tout en bridant ses outils (`disallowed-tools`) pour prévenir le moindre effet de bord.
