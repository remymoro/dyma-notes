---
title: "Les différentes catégories de skills et les bonnes pratiques"
description: "Classifier les skills (référence, procédure, déploiement) et maîtriser les bonnes pratiques (pièges, description, disable-model-invocation)."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - bonnes-pratiques
  - architecture
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 05-categories-skills-bonnes-pratiques
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-04
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi classer ses skills par catégorie ?** | Une skill doit avoir une responsabilité unique (ex: "Déploiement", "Vérification", "Documentation"). Si une skill fait trop de choses à la fois, elle sera difficile à maintenir et Claude ne saura pas quand l'invoquer de façon pertinente. |
| **Qu'est-ce qu'une "skill de référence" vs "skill procédurale" ?** | **Référence** : Apporte des connaissances (règles métier, comment utiliser une API locale). Invoquée automatiquement par l'agent quand il code. **Procédurale** : Décrit une suite d'étapes (ex: une release). Doit souvent être lancée manuellement. |
| **Comment forcer une skill à n'être lancée que manuellement ?** | En ajoutant `disable-model-invocation: true` dans son frontmatter YAML. L'agent ne pourra pas décider seul de l'utiliser ; seul l'humain pourra le faire via `/nom-de-la-skill`. Obligatoire pour les skills de déploiement ! |
| **Pourquoi ne pas mettre "écris du code propre" dans une skill ?** | Parce que Claude le sait déjà. Une skill ne doit contenir que la connaissance que Claude **ne peut pas deviner** (les conventions propres au projet, l'architecture locale, les `gotchas` ou pièges récurrents). |
| **Pourquoi faut-il documenter les "Gotchas" (pièges connus) ?** | C'est la section la plus précieuse d'une skill. Elle évolue avec le temps. Si Claude fait 3 fois la même erreur (ex: oublier que `Number('') === 0`), on l'ajoute dans `pieges-connus.md`. Cela lui évitera de reproduire cette erreur spécifique au projet. |
| **Quelle est l'erreur courante lors de l'écriture d'une procédure dans `SKILL.md` ?** | Être trop rigide. Si vous écrivez "Lis src/main.js, puis lis package.json, puis exécute git diff", la skill cassera dès que l'architecture changera. Préférez : "Identifie le périmètre. Inspecte le changement Git. Lis uniquement les fichiers nécessaires." Laissez l'agent s'adapter. |

## Synthèse
Anthropic a identifié 9 grandes catégories de skills, allant de la simple référence d'API jusqu'aux opérations d'infrastructure. La règle d'or est qu'une skill ne doit couvrir **qu'une seule catégorie**. Par exemple, `/techdebt` fait de la "Qualité et revue de code". Elle ne doit pas en plus lancer le déploiement.
Pour qu'une skill soit efficace, il ne faut surtout pas la remplir de conseils génériques (comme "Sois rigoureux"). Le LLM sait comment coder. La skill doit lui apporter ce qu'il ignore : vos règles de nommage locales, vos choix d'architecture, et surtout vos "Pièges connus" (Gotchas).
Si une skill a des effets de bord irréversibles (ex: un déploiement en production), elle ne doit jamais pouvoir être lancée de la propre initiative de l'agent. On utilise pour cela `disable-model-invocation: true` dans le YAML. 
Enfin, la procédure décrite dans le `SKILL.md` doit donner des directions claires (le but, les contraintes, le format attendu) sans micro-manager l'agent avec une rigidité absolue.

## Glossaire
- **Gotchas** : Anglicisme désignant un "piège" ou un comportement inattendu spécifique à une base de code, qu'un nouvel arrivant (ou un LLM) a de fortes chances de ne pas anticiper.
- **`disable-model-invocation: true`** : Propriété YAML qui empêche le LLM de déclencher "secrètement" ou "de son propre chef" une skill. Elle devient 100% manuelle.
- **Skill de référence** : Skill dont le but principal est d'injecter du contexte passif (ex: la documentation d'une librairie interne) sans forcément dicter des actions.
- **Skill procédurale** : Skill dont le but principal est de guider l'agent à travers un workflow étape par étape (ex: vérifier une Pull Request).

## Questions d'auto-évaluation
1. Dans quelle situation devriez-vous utiliser `disable-model-invocation: true` ?
2. Vrai ou Faux : Il est recommandé de lister tous les dossiers à lire (`cat src/A.js`, `cat src/B.js`) dans la procédure d'une skill pour être sûr que l'agent ne les oublie pas.
3. Pourquoi est-ce une mauvaise pratique de demander à l'agent de respecter les "bonnes pratiques JavaScript" dans une skill ?
4. Quelle est la différence majeure entre l'évaluation du déclenchement d'une skill et l'évaluation de sa qualité de sortie ?

# Les différentes catégories de skills et les bonnes pratiques

**Durée : 20 minutes**

## Objectif de la leçon
Apprendre à classifier ses skills pour garantir leur responsabilité unique et appliquer les meilleures pratiques de rédaction pour maximiser la compréhension du LLM.

---

# 1. Les 9 grandes catégories de skills

Une bonne skill ne fait qu'une chose. Selon Anthropic, elles se divisent généralement ainsi :

1. **Références d'API / Lib** (ex: `/billing-api` - Comment utiliser notre SDK interne)
2. **Vérification du produit** (ex: `/verify-product` - Tester manuellement des saisies)
3. **Analyse de données** (ex: `/analyse-logs`)
4. **Automatisation d'équipe** (ex: `/weekly-recap`)
5. **Génération de code** (ex: `/create-component` - Scaffold un composant selon nos conventions)
6. **Qualité et revue** (ex: `/techdebt`)
7. **CI/CD et Déploiement** (ex: `/release-check`)
8. **Diagnostic / Runbooks** (ex: `/debug-service` - Procédure en cas d'incident prod)
9. **Infrastructure** (ex: `/cleanup-resources`)

*Règle : Si votre skill `/techdebt` essaie aussi de faire du `/release-check`, vous allez diluer son efficacité.*

---

# 2. Distinguer "Référence" et "Procédure"

- **Le contenu de référence** (`/billing-api`) : Sert de "documentation à la volée". Claude peut l'invoquer de lui-même pendant qu'il code s'il a besoin de comprendre comment utiliser l'API.
- **Le contenu procédural** (`/release-check`) : C'est une action métier lourde. L'utilisateur veut généralement garder le contrôle sur le *moment* où cela s'exécute.

**Le bouton d'arrêt d'urgence (`disable-model-invocation`)**
Pour une skill procédurale ayant des effets externes (déploiement, manipulation de BDD), vous **devez** bloquer l'initiative de l'agent :
```yaml
---
name: release-check
description: Vérifie que le convertisseur est prêt à être livré.
disable-model-invocation: true
---
```
Ainsi, la skill n'existera que si l'utilisateur tape explicitement `/release-check`.

---

# 3. Ce que le LLM ne sait pas : Les "Gotchas"

Le LLM a lu tout internet. Inutile de lui écrire : *"Sois rigoureux, fais du code propre, gère les erreurs"*. Cela gâche des tokens et ne lui apprend rien.

Ce qu'il lui faut, ce sont les particularités de **votre** projet, les fameux **Pièges connus (Gotchas)**.

> Créez un fichier `.claude/skills/votre-skill/references/pieges-connus.md`
> - `Number('')` retourne `0`. Une saisie vide passe nos validations si on ne fait pas gaffe.
> - L'API d'authentification met 2 secondes à répondre, toujours implémenter un spinner.
> - Ne pas utiliser le module `fs` dans le dossier `client/`.

C'est cette section qui fait qu'une skill est "vivante" et gagne en valeur au fil des semaines.

---

# 4. Ne pas enfermer l'agent (Flexibilité)

Une skill doit guider l'intelligence du modèle, pas la court-circuiter.

❌ **Procédure trop rigide (à éviter) :**
> 1. Lis le fichier `package.json`.
> 2. Lis le fichier `src/main.js`.
> 3. Fais un `git diff`.
> 4. Sors exactement 5 problèmes.

*(Si vous renommez `main.js` en `app.js`, la skill plantera bêtement).*

✅ **Procédure robuste :**
> 1. Identifie le périmètre ciblé par la requête.
> 2. Explore les changements Git sur ce périmètre.
> 3. Sélectionne et lis uniquement les fichiers impactés.
> 4. Classe les problèmes pertinents trouvés.

---

# 5. Comment tester une Skill (La séparation des évaluations)

Une skill doit être évaluée sur 2 dimensions bien distinctes :

1. **Le Déclenchement** (La skill est-elle invoquée quand il faut ?)
   - *Test* : Dans une nouvelle session, tapez des intentions floues. *"Peux-tu corriger le formulaire ?"* -> Elle ne doit PAS se déclencher. *"Peux-tu vérifier la maintenabilité ?"* -> Elle DOIT se déclencher. (Ajustez le champ `description` du YAML en conséquence).
2. **La Qualité de Sortie** (Le résultat est-il bon ?)
   - *Test* : Posez la question sans la skill, sauvegardez la réponse. Activez la skill, posez la même question. Le rapport généré avec la skill doit être indéniablement supérieur (plus stable, tenant compte de vos conventions).

> **La phrase centrale de la leçon :**
> Une bibliothèque de skills efficace est composée de petites unités très ciblées, qui n'enseignent pas à Claude comment coder, mais comment survivre aux particularités de votre projet.
