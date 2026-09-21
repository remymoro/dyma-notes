---
title: "Les 5 mécanismes de pilotage de Claude Code"
description: "Référence transversale : CLAUDE.md, rules, skills, permissions et hooks — quand chacun se charge, ce qu'il coûte en contexte, et pourquoi une intention n'est jamais une frontière."
date: 2026-09-21
draft: true
tags:
  - claude-code
  - synthese
  - reference
  - configuration
  - memoire
categories:
  - "Transversal"
cours: Claude Code
chapitre: transversal
leçon: revision-5-mecanismes-pilotage
statut: référence
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quel est le seul critère qui sépare les 5 mécanismes ?** | **Quand le texte entre dans le contexte.** `CLAUDE.md` → toujours. `.claude/rules/` → si le chemin travaillé correspond aux `paths`. Skills → si la description matche la demande (*lazy loading*). Permissions et hooks → **jamais dans le contexte** : ils agissent sur le harnais, pas sur le raisonnement. |
| **Pourquoi le coût en tokens est-il un critère d'architecture ?** | `CLAUDE.md` est relu à **chaque requête**. Une consigne de 200 lignes qui ne sert qu'aux *releases* se paie aussi quand on corrige une typo. Le contexte n'est pas seulement une facture : c'est une ressource d'**attention** — plus il est encombré, plus l'agent dilue les instructions qui comptent. |
| **Intention ≠ frontière : qu'est-ce que ça change ?** | `CLAUDE.md`, `rules` et skills sont du **texte** : l'agent les lit, les respecte *en général*, et peut s'en affranchir face à un bug tordu. Les permissions et les hooks sont exécutés par le **harnais**, hors du raisonnement du modèle : ils ne se négocient pas. Une consigne critique doit exister dans les deux registres. |
| **Qu'est-ce que le *lazy loading* d'une skill ?** | Claude Code ne connaît au départ que le **nom** et la **description** d'une skill. Si la description correspond à la demande, il charge le `SKILL.md` complet — **et seulement pour la durée de la tâche**. C'est ce qui rend un workflow de 8 000 caractères gratuit tant qu'on ne s'en sert pas. |
| **Piège de vocabulaire : « règle » désigne quoi ?** | **Deux choses sans rapport.** (1) `.claude/rules/*.md` : un mécanisme de Claude Code. (2) `MEM001`, `MEM002`, `MEM003` : les règles de **lint de Claudoscope**, le projet-exemple du cours — du code métier dans `packages/core/`. Le préfixe `MEM` vient de « mémoire projet » parce que ce linter analyse des `CLAUDE.md`. Aucun rapport avec la mémoire de l'agent. |
| **Pourquoi `CLAUDE.md` s'écrit-il APRÈS le socle ?** | Parce qu'il doit décrire l'architecture **réelle**, pas l'architecture espérée. Écrit avant, il fige des suppositions. Même logique pour les permissions : on ne peut pas autoriser `pnpm test` avant que le script existe — on devinerait. La mémoire se rédige sur des faits produits par les étapes précédentes. |
| **Où vit un mécanisme ? (portées)** | **Personnelle** `~/.claude/` (suit la machine, non versionnée) · **Projet** `.claude/` (versionnée, partagée avec l'équipe) · **Package** `packages/x/.claude/` (ciblée dans un monorepo) · **Entreprise** via un plugin (distribution à toute une organisation). |

## Synthèse

Claude Code offre cinq façons de le piloter, et on les confond parce qu'on les classe par
leur contenu au lieu de les classer par leur **moment de chargement**. `CLAUDE.md` est la
mémoire permanente : tout ce qu'on y met est relu à chaque requête, donc il doit rester
court et ne contenir que ce qui sert presque toujours — architecture macro, commandes,
stack. Les `.claude/rules/` déportent les contraintes qui ne valent que pour un dossier :
elles ne coûtent rien tant qu'on ne touche pas aux `paths` déclarés. Les skills déportent
les workflows multi-étapes utilisés ponctuellement, et leur chargement paresseux les rend
gratuites au repos. Ces trois mécanismes sont du texte : ils formulent une **intention**,
que l'agent suit d'ordinaire mais peut trahir. Les permissions et les hooks, eux, sont
exécutés par le harnais et non par le modèle : ce sont des **frontières**, elles ne se
négocient pas. D'où la règle qui gouverne toute la configuration d'un projet sérieux :
une consigne critique doit être écrite **et** rendue mécaniquement infranchissable.

## Glossaire

- **Mémoire projet** : le `CLAUDE.md` lu automatiquement à chaque nouvelle session, à la racine du projet.
- **Lazy loading** : chargement d'une skill à la demande — seules son nom et sa description sont connus par défaut.
- **`paths` (frontmatter d'une rule)** : le motif de chemins qui déclenche le chargement de la règle (`packages/core/**`).
- **Intention** : consigne textuelle que l'agent lit et respecte *en général* (`CLAUDE.md`, rules, skills).
- **Frontière** : contrainte exécutée par le harnais, hors du raisonnement du modèle (permissions, hooks).
- **Portée** : niveau où vit un mécanisme — personnelle, projet, package, entreprise.
- **Dossier de capacité** : la structure d'une skill (`SKILL.md` + `references/` + `examples/` + `scripts/`).
- **Auto-mémoire** : l'ajout d'une consigne durable à `CLAUDE.md` depuis une correction faite en session.

## Questions d'auto-évaluation

1. Une consigne utile dans 3 sessions sur 100 : pourquoi la mettre dans `CLAUDE.md` est-il un mauvais calcul, même si elle ne fait que deux lignes ?
2. Tu écris dans `.claude/rules/core.md` : « le core ne fait aucune I/O ». Qu'est-ce qui peut arriver malgré cette règle, et qu'est-ce qu'il faut ajouter pour que ça devienne impossible ?
3. Pourquoi une skill est-elle presque gratuite au repos, alors que la même consigne dans `CLAUDE.md` coûte à chaque requête ?
4. Qu'est-ce qui se passerait si on rédigeait `CLAUDE.md` et `.claude/settings.json` **avant** de créer le socle technique ?
5. Le workflow « archive la source, pose les questions, écris la fiche, mets le README à jour » : justifie, avec la matrice de décision, pourquoi c'est une skill et pas une entrée de `CLAUDE.md`.

# Les 5 mécanismes de pilotage de Claude Code

## À quoi sert cette fiche

Cette fiche n'est pas une leçon : c'est la **synthèse transversale** d'un sujet que le
cours traite en morceaux dispersés — chapitre 12 (mémoire), 13/05 (`CLAUDE.md` + rules),
13/06 (permissions), chapitre 14 (skills) et chapitre 22 (hooks).

Elle répond à une question que les fiches individuelles ne posent jamais frontalement :
**devant une consigne à donner à l'agent, où faut-il l'écrire ?**

En cas de doute sur un détail d'exécution, c'est la fiche de la leçon qui fait foi.

---

# 1. Le seul critère qui compte : quand est-ce chargé ?

On classe spontanément les mécanismes par leur contenu (« ça parle d'architecture », « ça
parle de release »). C'est le mauvais axe. Le bon axe est **le moment où le texte entre
dans le contexte de l'agent**, parce que c'est lui qui détermine le coût et la portée.

```text
                      QUAND LE TEXTE EST-IL CHARGÉ ?

     TOUJOURS              SI LE CHEMIN            À LA DEMANDE
                            CORRESPOND          (nom + description
        │                       │                    matchent)
        ↓                       ↓                       ↓
   CLAUDE.md             .claude/rules/              Skills
        │                       │                       │
  coût PERMANENT         coût CONDITIONNEL        coût PONCTUEL
  (chaque requête)      (si on touche aux        (durée de la tâche
        │                    paths)                    seulement)
        │                       │                       │
   ─────┴───────────────────────┴───────────────────────┴──────
                      TEXTE LU PAR LE MODÈLE
                    = INTENTION, contournable
   ────────────────────────────────────────────────────────────
                    EXÉCUTÉ PAR LE HARNAIS
                  = FRONTIÈRE, non négociable
        │                                               │
        ↓                                               ↓
  .claude/settings.json                              Hooks
    (permissions)                              (sur événement)
   allow / deny                              lint après écriture,
   jamais dans le contexte                   test avant commit…
```

---

# 2. `CLAUDE.md` — la mémoire toujours active

Relu à **chaque nouvelle conversation**. C'est sa force et son piège : tout ce qu'on y
met se paie en permanence, même quand la requête n'a rien à voir.

| Ce qui DOIT y être | Ce qui doit en SORTIR | Et va où ? |
|---|---|---|
| Présentation du projet en une phrase | L'historique des arbitrages, les alternatives écartées | `design-doc.md` |
| Architecture macro (« le CLI dépend du core, le core est pur ») | Le catalogue des futures fonctionnalités | `design-doc.md` |
| Les commandes de validation | Le détail d'implémentation d'une brique | `.claude/rules/` |
| La stack globale (Node 20, TS strict, Vitest) | Les procédures ponctuelles (release, audit) | une **skill** |

Deux conséquences d'ordre :

- **`CLAUDE.md` s'écrit après le socle**, jamais avant. Il synthétise l'architecture
  *réelle*. Écrit avant, il fige des suppositions — et l'agent les prend pour des faits.
- **Il ne s'invente pas** : on fait d'abord explorer le dépôt à l'agent (les
  `package.json`, la config TypeScript, les tests), puis on réaligne `design-doc.md` sur
  la réalité, et seulement ensuite on rédige la mémoire.

---

# 3. `.claude/rules/` — la contrainte locale à un dossier

Le problème résolu : une consigne architecturale stricte mais **localisée**. La mettre
dans `CLAUDE.md` la ferait payer partout ; la mettre dans une rule la fait payer
uniquement quand on travaille dans le dossier concerné.

```text
.claude/rules/mon-core.md
┌─────────────────────────────────────────┐
│ ---                                     │
│ paths:                                  │  ← le déclencheur
│   - "packages/core/**"                  │
│ ---                                     │
│                                         │
│ - Aucune I/O : fonctions pures          │  ← la consigne
│   contenus -> findings                  │
│ - Aucune requête réseau, aucune clé API │
│ - Toute règle a un id stable, une       │
│   sévérité, et des tests fixture        │
│   sain / fautif                         │
└─────────────────────────────────────────┘

  je modifie packages/core/…  →  la règle est chargée
  je modifie packages/cli/…   →  la règle reste silencieuse
```

> Piège de vocabulaire. « Règle » désigne deux choses sans rapport dans ce cours :
> `.claude/rules/` (mécanisme de Claude Code) et `MEM001`/`MEM002`/`MEM003` (les règles
> de **lint de Claudoscope**, du code métier dans `packages/core/`). Le préfixe `MEM`
> vient de « mémoire projet » parce que ce linter analyse des fichiers `CLAUDE.md`.

---

# 4. Les skills — le workflow chargé à la demande

Une skill n'est pas un texte, c'est un **dossier de capacité** :

```text
.claude/skills/tuteur-dyma/
├── SKILL.md            point d'entrée : nom, description, instructions
├── references/         check-lists longues
├── examples/           modèles de rendu attendu
└── scripts/            utilitaires locaux
```

**Le lazy loading est tout l'intérêt.** Claude Code ne connaît au départ que le `name` et
la `description`. Si la description matche la demande, le `SKILL.md` complet est chargé —
et seulement pour la durée de la tâche.

```text
au repos          demande « nouvelle leçon »        tâche finie
    │                        │                          │
 nom + description  →  SKILL.md entier chargé  →  déchargé
   ≈ 40 tokens           ≈ 2 000 tokens            ≈ 40 tokens
```

C'est ce qui rend un workflow de 8 000 caractères **gratuit tant qu'on ne s'en sert pas**.
La même consigne dans `CLAUDE.md` serait facturée à chaque correction de typo.

---

# 5. Permissions et hooks — les frontières

C'est ici que le registre change complètement. Les trois mécanismes précédents sont du
**texte lu par le modèle**. Ces deux-là sont **exécutés par le harnais**, hors du
raisonnement de l'agent — donc incontournables.

| | Permissions (`.claude/settings.json`) | Hooks |
|---|---|---|
| **Déclenchement** | à chaque tentative d'action | sur un événement (après écriture, avant commit…) |
| **Effet** | autorise, demande, ou **refuse** | exécute une commande |
| **Dans le contexte ?** | non | non |
| **Négociable par l'agent ?** | **non** | **non** |

Le principe de découpage des permissions : séparer ce qui demande une **intuition
humaine** de ce qui est purement **mécanique**, et poser un **veto absolu** sur le
destructeur.

```text
allow   →  mécanique, sans risque      pnpm lint, pnpm test, pnpm build
ask     →  demande du jugement         modifier les dépendances, git push
deny    →  destructeur, jamais         rm -rf, force push, secrets
```

---

# 6. Intention ≠ frontière : la règle qui gouverne tout

C'est le point le plus important de la fiche, et le plus vite oublié.

Un agent lit `« le core ne fait aucune I/O »` et, en général, le respecte. Mais face à un
bug complexe, trois phases plus loin, il peut très bien importer `fs` « juste pour
déboguer » — et ne pas le retirer.

**`CLAUDE.md` n'est pas une barrière technique.** Toute intention critique doit être
doublée d'une sanction déterministe :

| L'intention (du texte) | La barrière (de la mécanique) |
|---|---|
| rule : « le core ne fait pas d'I/O » | une règle ESLint qui **interdit** l'import de `fs` dans ce dossier |
| `CLAUDE.md` : « le typage est strict » | `tsconfig` en `strict` + `pnpm typecheck` en CI |
| skill : « ne pousse pas pendant une release » | `deny` sur `git push` dans les permissions |
| rule : « toute règle a des tests fixture » | un test qui échoue si la fixture manque |

C'est exactement la logique d'un **invariant d'architecture** : un invariant sans colonne
« comment il est sanctionné » n'est pas un invariant, c'est un vœu.

---

# 7. Les voisins : ce qui n'est PAS un des 5

Trois mécanismes complètent l'écosystème sans piloter le comportement de l'agent au sens
de cette fiche :

| Mécanisme | Sert à |
|---|---|
| **Serveur MCP** | donner à l'agent l'accès à une **API ou une base externe** |
| **Sous-agent** | analyser un gros périmètre **sans polluer la session courante** |
| **Plugin** | **distribuer** skills, hooks et MCP à toute une organisation |

Et deux fichiers qui ne sont pas des mécanismes du tout : `design-doc.md` (l'historique et
les arbitrages, lu **sur demande**) et `README.md` (pour les humains).

---

# Résumé & Schéma global

```text
                    OÙ ÉCRIRE UNE CONSIGNE ?

  Utile dans presque TOUTES les sessions ?  ──────→  CLAUDE.md
                    │ non
                    ↓
  Ne vaut que pour UN DOSSIER précis ?  ─────────→  .claude/rules/
                    │ non
                    ↓
  Workflow MULTI-ÉTAPES, usage ponctuel ?  ──────→  Skill
                    │ non
                    ↓
  Doit s'exécuter AUTOMATIQUEMENT ?  ────────────→  Hook
                    │ non
                    ↓
  Doit être BLOQUÉ quoi qu'en pense l'agent ?  ──→  Permissions
                    │ non
                    ↓
  Faut-il une API / base EXTERNE ?  ─────────────→  MCP
                    │ non
                    ↓
  Gros périmètre sans polluer la session ?  ─────→  Sous-agent


  ⚠ Et si la consigne est CRITIQUE : les deux registres.
     l'intention (texte)  +  la barrière (lint, test, deny, hook)
```

# Tableau des mécanismes à retenir

| Mécanisme | Emplacement | Chargé quand | Nature |
|---|---|---|---|
| Mémoire projet | `CLAUDE.md` (racine) | à chaque session, **toujours** | intention |
| Règles ciblées | `.claude/rules/*.md` | si les `paths` correspondent | intention |
| Skills | `.claude/skills/<nom>/SKILL.md` | si la description matche (*lazy*) | intention |
| Permissions | `.claude/settings.json` | à chaque action, **hors contexte** | **frontière** |
| Hooks | `settings.json` | sur événement, **hors contexte** | **frontière** |
| *MCP* | config serveur | à l'appel d'outil | *accès externe* |
| *Sous-agent* | `.claude/agents/` | à l'invocation | *isolation de contexte* |

# Les 5 points les plus importants

1. **Le critère est le moment de chargement, pas le contenu** : toujours / selon le chemin / à la demande. C'est lui qui fixe le coût et la portée.
2. **`CLAUDE.md` est la mémoire permanente, donc il doit être dégraissé** : architecture macro, commandes, stack. L'historique va au `design-doc.md`, les workflows vont en skills.
3. **Le lazy loading rend une skill gratuite au repos** : seuls nom et description sont connus tant que la demande ne matche pas.
4. **Intention ≠ frontière** : `CLAUDE.md`, rules et skills sont contournables par l'agent ; permissions et hooks ne le sont pas. Une consigne critique s'écrit dans les deux registres.
5. **La mémoire se rédige APRÈS le socle** : elle décrit l'architecture réelle et autorise les commandes réelles. Écrite avant, elle fige des suppositions.

---

# Carte mentale

```text
PILOTER CLAUDE CODE
│
├── INTENTIONS (texte lu par le modèle — contournable)
│   ├── CLAUDE.md ......................... toujours chargé
│   │   ├── présentation, archi macro
│   │   ├── commandes de validation
│   │   ├── stack globale
│   │   └── ✗ PAS l'historique, PAS les catalogues, PAS les workflows
│   ├── .claude/rules/*.md ................ chargé si paths matchent
│   │   ├── frontmatter : paths
│   │   └── contraintes locales à un dossier
│   └── .claude/skills/<nom>/ ............. chargé à la demande (lazy)
│       ├── SKILL.md (nom + description + instructions)
│       ├── references/ · examples/ · scripts/
│       └── portées : ~/.claude · projet · package · plugin
│
├── FRONTIÈRES (exécuté par le harnais — non négociable)
│   ├── .claude/settings.json ............. allow / ask / deny
│   │   ├── allow  → mécanique (lint, test, build)
│   │   ├── ask    → jugement humain (deps, push)
│   │   └── deny   → destructeur (rm -rf, force push)
│   └── hooks ............................. sur événement
│
├── VOISINS
│   ├── MCP ............................... API / base externe
│   ├── sous-agent ........................ isoler le contexte
│   └── plugin ............................ distribuer à l'organisation
│
└── PAS DES MÉCANISMES
    ├── design-doc.md ..................... historique, arbitrages (lu sur demande)
    └── README.md ......................... pour les humains
```

---

# Mini fiche de révision

```text
CLAUDE.md        → mémoire TOUJOURS active. Court. Archi macro + commandes + stack.
.claude/rules/   → contrainte locale. Chargée si les `paths` correspondent.
Skill            → workflow multi-étapes. Lazy loading : gratuite au repos.
Permissions      → allow / ask / deny. Hors contexte. Non négociable.
Hooks            → exécution automatique sur événement. Hors contexte.

Lazy loading     → seuls nom + description connus jusqu'au match.
Intention        → texte lu par le modèle, contournable.
Frontière        → exécutée par le harnais, infranchissable.
Ordre d'écriture → socle D'ABORD, mémoire et permissions ENSUITE.
Piège            → MEM001/002/003 = lint de Claudoscope, PAS .claude/rules/.
```

> **Phrase à retenir** : on ne choisit pas un mécanisme d'après ce qu'on veut dire, mais
> d'après le moment où l'agent doit l'entendre — et si la consigne est critique, on ne se
> contente jamais de la dire : on la rend mécaniquement infranchissable.
