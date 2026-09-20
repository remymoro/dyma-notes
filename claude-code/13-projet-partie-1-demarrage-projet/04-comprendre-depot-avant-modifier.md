---
title: "Comprendre le dépôt avant de modifier"
description: "Comment auditer le socle technique généré face au Design Doc et prioriser les actions avant d'aller plus loin."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - audit
  - monorepo
  - pnpm
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 04-comprendre-depot-avant-modifier
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi faire une revue d'adéquation ?** | Le socle vient d'être créé. Avant d'écrire la moindre règle métier, il faut s'assurer que le socle généré respecte à 100% les décisions du `design-doc.md`. S'il y a un décalage structurel, mieux vaut le corriger maintenant. |
| **Comment forcer l'agent à faire un rapport utile ?** | En lui demandant de ne **rien modifier** dans un premier temps. Il doit lister les écarts par priorité (P1, P2, P3, P4) : blocages structurels (P1), corrections non bloquantes (P2), risques futurs (P3), et optimisations (P4). |
| **Qu'est-ce qu'une "contradiction structurelle" (P1) dans cet exemple ?** | Le CLI dépend du package `core` via `workspace:*`. À la publication (npm), cette dépendance deviendra une version statique (ex: `0.0.0`). Si le package `core` est marqué `private: true`, son installation par l'utilisateur échouera lamentablement sur npm, même si les tests locaux sont verts. |
| **Pourquoi repousser volontairement certaines optimisations (P3/P4) ?** | L'objectif est de franchir la "Gate" actuelle sans dériver. Ajouter des références TypeScript strictes (P4) n'est pas vital pour publier les packages. Importer temporairement `analyze` juste pour faire un test de frontière (P3) pollue le socle. On les "repousse" explicitement : ils ne sont pas oubliés, ils sont notés pour la prochaine tranche. |
| **Comment simuler une publication npm sans la faire ?** | En utilisant la commande `pnpm pack` dans le dossier du package. Cela génère un fichier `.tgz` (archive) qu'on peut inspecter avec `tar -tf <archive.tgz>` pour vérifier si les fichiers attendus (`dist`, `package.json`, `LICENSE`) sont présents et si la dépendance `workspace:*` a bien été convertie. |
| **Pourquoi exiger que l'agent ne fasse pas le commit ?** | Le développeur garde la responsabilité finale. Il doit pouvoir exécuter un `git diff` et vérifier que l'agent n'a touché *que* ce qui était autorisé (ici : des manifestes et des licences), sans altérer le moteur ou le Design Doc en douce. |

## Synthèse
Le socle (Walking Skeleton) est là. Les tests passent. Mais des tests verts en local ne prouvent pas que l'architecture de distribution est viable. Cette leçon montre comment demander à Claude Code de se transformer en "Auditeur" : il compare le projet actuel au `design-doc.md` et dresse un rapport priorisé (P1 à P4) sans modifier aucun fichier. Dans l'exemple de Claudoscope, l'audit révèle une erreur fatale silencieuse (P1) : le package CLI, destiné à être public, dépend du package `core` qui a été configuré en `private`. Si on ignore cela, le CLI plantera chez les utilisateurs après publication. La méthode consiste à répondre directement au rapport de l'agent point par point ("P1 : Autorisé, P2: Autorisé, P3: Ignorer pour l'instant"). L'agent applique alors les correctifs approuvés, valide par des commandes (`pnpm pack`, `tar -xOf`), et s'arrête avant le commit, vous laissant le contrôle final du `git diff`.

## Glossaire
- **Revue d'adéquation** : Vérifier que le code généré correspond au document de conception (`design-doc.md`) avant de passer à l'implémentation métier.
- **P1, P2, P3, P4** : Échelle de priorisation d'un rapport. P1 = Blocage structurel, P4 = Optimisation facultative.
- **`pnpm pack`** : Commande qui crée l'archive `.tgz` exacte qui serait envoyée à un registre npm, idéale pour vérifier le contenu de la publication sans publier.
- **`workspace:*` vs version statique** : Lors d'un `pnpm pack`, pnpm convertit intelligemment le `workspace:*` du `package.json` en version statique (`0.0.0`) pour l'archive.
- **Blanc-seing** : Donner carte blanche. Une revue d'agent ne donne jamais de blanc-seing ; chaque action doit être arbitrée.

## Questions d'auto-évaluation
1. Dans un monorepo pnpm, pourquoi un package A public ne devrait-il pas dépendre d'un package B privé ?
2. Quelle commande permet d'inspecter le contenu de l'archive `.tgz` générée par `pnpm pack` ?
3. Pourquoi a-t-on expressément demandé à l'agent de repousser l'exercice de la frontière (importer `analyze` depuis le CLI) à la priorité P3 ?
4. Selon la leçon, qui doit effectuer le commit final après les corrections de l'agent, et pourquoi ?

# Comprendre le dépôt avant de modifier

**Durée : 15 minutes**

## Objectif de la leçon
Apprendre à effectuer une revue d'adéquation (Audit du code vs Design Doc) et piloter un agent pour prioriser et appliquer uniquement les correctifs architecturaux nécessaires, sans jamais lui donner un blanc-seing.

---

# 1. Ne jamais foncer tête baissée (Le Prompt d'Audit)

Le socle de fichiers a été généré, et les tests passent (`b93cf13`). Est-on prêt à coder les règles métier ? Non. 
Il faut d'abord demander à Claude Code de s'auto-évaluer face au `design-doc.md`.

**Le prompt d'audit idéal :**
```text
Compare le socle technique actuel au fichier @design-doc.md.
Objectif : vérifier le respect des décisions, identifier les écarts et les risques.
NE MODIFIE ENCORE AUCUN FICHIER.
Classe les correctifs par priorité (P1 à P4).
```

---

# 2. Lire le rapport et identifier les "Pièges Silencieux"

L'agent vous liste 4 points :
- **P1 (Bloquant)** : Le CLI (public) dépend du `core` (privé). Cela fonctionne en local grâce à `pnpm workspaces`, mais à la publication npm, l'installation plantera car le `core` n'existera pas sur le registre public.
- **P2 (Important)** : Manque de métadonnées (licence, repository).
- **P3 (Risque futur)** : On n'a pas encore vérifié si le CLI arrive techniquement à importer la fonction `analyze` du `core` compilé.
- **P4 (Optionnel)** : Ordre de build TypeScript perfectible.

> [!WARNING]
> Les tests locaux verts peuvent cacher une architecture de distribution cassée. C'est tout l'intérêt de la priorité P1 qui lève ce lièvre.

---

# 3. L'Arbitrage (Diriger l'Agent)

Face au rapport, le rôle du développeur (vous) n'est pas de dire "Corrige tout". C'est de décider point par point.
Vous répondez :

```text
P1 - Trancher la stratégie de publication
Décision : retire private: true et publie le core comme dépendance.

P2 - Métadonnées de publication
Décision : ajoute les licences.

P3 - Exercer la frontière core / CLI
Décision : ignorer pour l'instant.

P4 - Robustesse du build
Décision : ignorer pour l'instant.
```

> [!TIP]
> **Le pouvoir du "Ignorer pour l'instant"**
> Repousser une tâche ne signifie pas l'oublier, cela signifie maintenir la "Gate" actuelle pure. Ne laissez pas l'agent coder des tests "bouchons" inutiles juste pour valider un P3.

---

# 4. Vérifier la publication sans publier (`pnpm pack`)

L'agent applique les corrections (P1 et P2). Pour vérifier que le problème P1 est bien résolu, il n'est pas question de publier sur npm. On utilise la commande `pack` :

```bash
cd packages/core && pnpm pack  # -> produit archive-core.tgz
cd ../cli && pnpm pack         # -> produit archive-cli.tgz
```

On peut ensuite inspecter l'archive pour s'assurer que `pnpm` a bien transformé le `"workspace:*"` en version statique (`0.0.0`) :
```bash
tar -xOf <archive-cli.tgz> package/package.json
```

---

# 5. La main au développeur pour le Commit

Le prompt ou les Custom Instructions doivent toujours stipuler : **"Ne crée pas automatiquement le commit"**.

Après l'exécution de l'agent, vous tapez vous-même :
```bash
git diff
```
Vous vérifiez que seuls les `package.json` et les `LICENSE` ont été touchés, et que l'agent n'a pas subrepticement modifié le `design-doc.md` ou écrit de la logique métier. Puis, **vous commitez**.

---

# Cartes mentales

```text
                 L'AUDIT DE SOCLE (REVUE D'ADÉQUATION)
                                  │
           ┌──────────────────────┴──────────────────────┐
           ↓                                             ↓
     1. DEMANDER LE RAPPORT                      2. ANALYSE ET ARBITRAGE
   - "Ne modifie rien"                         - P1 (Bloquant) -> Autorisé
   - "Compare au design-doc"                   - P2 (Important)-> Autorisé
   - "Classe de P1 à P4"                       - P3 (Futur)    -> Ignoré
                                               - P4 (Option)   -> Ignoré
                                                         │
                                                         ↓
                                                 3. APPLICATION 
                                        - Modification des fichiers
                                        - Preuve par `pnpm pack`
                                                         │
                                                         ↓
                                                 4. CONTRÔLE FINAL
                                        - `git diff` par l'humain
                                        - Humain fait le Commit !
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les 3 piliers de la session d'audit :
1. Interdire les modifications avant l'évaluation (Pas de blanc-seing).
2. Vérifier les "pièges de publication" locaux avec `pnpm pack` et `tar`.
3. Dire NON aux optimisations anticipées (P3/P4) pour garder le focus. Garder la main sur le `git commit`.
```

> **La phrase centrale de la leçon :**
> Des tests locaux au vert ne garantissent pas une architecture saine ; la revue d'adéquation sert à débusquer les contradictions structurelles que les tests automatisés ne peuvent pas encore voir, avant même d'écrire la première ligne de logique métier.
