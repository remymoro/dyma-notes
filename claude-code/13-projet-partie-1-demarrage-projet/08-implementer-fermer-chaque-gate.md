---
title: "Implémenter sous contrôle et fermer chaque gate"
description: "Comment piloter Claude Code phase par phase, du moteur (core) jusqu'à l'interface (CLI), en respectant les frontières architecturales."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - implémentation
  - tdd
  - architecture
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 08-implementer-fermer-chaque-gate
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi s'arrêter avant la phase 4 ?** | La phase 4 est dédiée aux fixtures, snapshots et dogfooding final (tests de haut niveau E2E). Les phases 2 et 3 consistent à coder les règles et brancher le CLI (tests unitaires et I/O). On isole volontairement ces types de tests pour ne pas mélanger les couches. |
| **Qu'est-ce qu'un "titre conteneur" et comment la règle `MEM002` le gère-t-elle ?** | Un titre conteneur (ex: `## Installation`) n'a pas de texte direct sous lui, mais est immédiatement suivi d'un sous-titre (ex: `### Windows`). La règle `MEM002` (qui détecte les sections vides) ne doit pas signaler cette section comme "vide", car le sous-titre prouve qu'elle a du contenu indirect. |
| **Comment tester le moteur (`core`) de manière réaliste sans briser sa "pureté" ?** | En effectuant la lecture du fichier (`readFileSync`) *dans le code du test unitaire* (`rules.test.ts`), puis en passant le contenu en mémoire à `analyze()`. Le fichier `CLAUDE.md` réel est ainsi utilisé comme premier test de "dogfooding", tout en gardant le moteur pur (pas de dépendance à `fs`). |
| **Pourquoi le CLI (`packages/cli`) ne doit-il importer *que* `index.ts` du `core` ?** | Le fichier `index.ts` expose l'API publique du `core` (`analyze`, `rules`, les types). Le CLI ne doit en aucun cas importer les règles individuelles (`mem001.ts`) ou le parseur Markdown (`markdown.ts`). Cela garantit l'étanchéité des frontières et cache les détails d'implémentation du moteur. |
| **Pourquoi l'absence de fichier (`claudoscope scan inexistant.md`) retourne-t-elle le code de sortie `0` ?** | Dans cette première version, on considère que si le linter ne trouve pas de fichier, il n'y a pas d'erreur de conformité. Cela permet d'ajouter le linter à la CI (`gate` facultative) même sur des dépôts qui n'ont pas encore de fichier `CLAUDE.md`, sans casser le pipeline. |
| **Comment vérifier qu'il n'y a pas eu de "dérive" architecturale ?** | En demandant à l'agent une "revue ciblée" sur le `diff` Git. S'il y a de la lecture de disque dans `packages/core` ou de la logique métier/parsing (ex: un calcul de sévérité) dans `packages/cli`, la frontière a été violée. |

## Synthèse
Le plan est prêt, place à l'implémentation. Cette leçon montre comment dicter à l'agent l'exécution des phases de manière séquentielle et stricte. On commence par la **Phase 2** (le moteur) : l'agent implémente les règles `MEM001` (taille max), `MEM002` (sections vides) et `MEM003` (structure minimale) dans le `core`. Ces règles s'appuient sur l'AST généré par le parseur de la Phase 1. La règle d'or est respectée : les règles ne font pas d'I/O. On valide cette phase avec des tests unitaires, et on utilise le `CLAUDE.md` réel du projet comme premier test d'intégration ("Dogfooding"). Une fois la gate 2 fermée, on passe à la **Phase 3** (le CLI). L'agent écrit la logique d'I/O (lecture du fichier via `fs`), appelle le moteur via l'API publique (`index.ts`), et gère les sorties (texte, JSON, code de retour 0/1/2 selon `--fail-on`). À la fin, avant de commiter, on exige de l'agent une relecture critique du `git diff` pour s'assurer qu'aucune "fuite" de logique n'a eu lieu d'un package à l'autre.

## Glossaire
- **Titre conteneur** : Titre Markdown suivi directement par un autre titre d'un niveau inférieur, sans paragraphe de texte intermédiaire.
- **Dogfooding** : Méthodologie consistant à utiliser son propre outil en interne. Ici, passer le propre `CLAUDE.md` du projet dans le linter `claudoscope`.
- **API Publique (d'un package interne)** : Fichier point d'entrée (`index.ts`) qui expose sélectivement les fonctions (ex: `analyze`) d'un module, cachant volontairement les détails (`markdown.ts`, `mem001.ts`).
- **Code de retour `0` vs `1` vs `2`** : 0 = Succès (ou fichier absent), 1 = Échec fonctionnel (un warning ou erreur a dépassé le seuil), 2 = Échec technique (ex: permission refusée, plantage NodeJS).

## Questions d'auto-évaluation
1. Dans quel package (`core` ou `cli`) la fonction `trim()` est-elle utilisée pour vérifier si une section est vide ?
2. Quelle méthode NodeJS est appelée dans `rules.test.ts` pour charger le fichier `CLAUDE.md` ? Pourquoi est-ce acceptable ici ?
3. Que doit faire le CLI si la commande est `claudoscope scan CLAUDE.md --format json` et qu'il y a un finding ?
4. Donnez deux exemples de "dérive architecturale" que l'agent doit traquer dans le `git diff` final.

# Implémenter sous contrôle et fermer chaque gate

**Durée : 30 minutes**

## Objectif de la leçon
Gérer l'exécution d'un plan complexe en forçant l'agent à implémenter phase par phase, à respecter les contrats des interfaces et à garantir l'étanchéité totale entre la logique métier et l'interface utilisateur.

---

# 1. Phase 2 : Implémenter les règles dans le `core`

Les règles doivent être ajoutées au `packages/core`. C'est le cœur du réacteur.

### Le cahier des charges des règles :
- **MEM001 (Warn)** : Fichier > 200 lignes. (Utilise la liste `lines` du parseur).
- **MEM002 (Warn)** : Section vide. (Vérifie si `lines` est vide, mais **ignore les titres conteneurs** : si une section est suivie d'une sous-section, elle n'est pas "vide").
- **MEM003 (Error)** : Présence obligatoire de 3 sections ("Commandes", "Architecture", "Vérification"). (La règle doit tolérer la casse, les accents et les mots anglais en utilisant une fonction `normalizeTitle`).

### Le Registre
Les règles sont déclarées dans un tableau ordonné dans `rules/index.ts`. Le moteur exécutera toujours les règles dans cet ordre strict, garantissant la **reproductibilité**.

### Test d'intégration (Le premier Dogfooding)
Le `core` est testé unitairement, mais aussi globalement via `rules.test.ts`. 
On y lit le vrai `CLAUDE.md` du dépôt (via `readFileSync` dans le fichier de test) et on vérifie qu'il donne `0` finding :
```typescript
const content = readFileSync(new URL("../../../../CLAUDE.md", import.meta.url), "utf8");
expect(analyze([{path: "CLAUDE.md", content}], rules)).toEqual([]);
```

> [!WARNING]
> La lecture du disque (`readFileSync`) est ici dans le code de test, **pas dans le code de production du core**. L'invariant "Le core est pur" reste donc intact !

---

# 2. Clôture de la Phase 2

On vérifie que les tests passent :
```bash
pnpm run test
pnpm run typecheck
```
Tant que c'est vert, la gate de la phase 2 est fermée. On passe à l'interface graphique en ligne de commande.

---

# 3. Phase 3 : Brancher le `CLI`

Le CLI (`packages/cli`) est le chef d'orchestre des entrées-sorties. Il est idiot : il ne calcule rien, il ne fait qu'appeler le `core` et formater la réponse.

### Ses responsabilités :
1. **Lire le fichier** : Prend l'argument (ex: `CLAUDE.md`), lit le contenu brut sur le disque.
2. **Construire l'entrée** : Crée l'objet `SourceFile` `{path, content}`.
3. **Appeler le moteur** : `const findings = analyze([sourceFile], rules);`
4. **Traduire la sortie** : Afficher en texte clair OU en JSON selon l'option `--format`.
5. **Appliquer le code de sortie** :
    - `0` : Si tout va bien (ou si le fichier est introuvable, tolérance pour la CI).
    - `1` : Si un finding dépasse le seuil défini par `--fail-on` (`warn` ou `error`).
    - `2` : Si une erreur de runtime survient (le code plante).

> [!IMPORTANT]
> **La barrière d'import**
> Le CLI doit importer : `import { analyze, rules } from "@claudoscope/core";`
> Il ne doit JAMAIS importer `@claudoscope/core/src/rules/mem001`. Le registre est fermé.

---

# 4. L'Épreuve de vérité : Relire le Diff

C'est ici qu'un LLM a tendance à dériver et à mélanger les couches. Demandez à l'agent de relire son propre `git diff` avec des consignes très dures.

**Signaux d'alarme (Dérives) :**
- Il a copié la constante `MAX_LINES=200` dans le CLI ? ➔ **Dérive** (La sévérité est une affaire de `core`).
- Il a appelé `fs.readFileSync` dans le `core` ? ➔ **Dérive** (Le core devient impur).
- Il a filtré ou trié les findings dans le CLI ? ➔ **Dérive** (C'est le moteur qui dicte l'ordre d'affichage).
- Il a importé le module de parsing dans le CLI ? ➔ **Dérive** (Le CLI ne connaît pas l'AST).

S'il trouve une erreur, dites-lui de corriger. Si l'analyse est validée, la session se termine !

---

# Cartes mentales

```text
                        LE FLUX D'EXÉCUTION (DE BOUT EN BOUT)
                                          │
            ┌─────────────────────────────┴─────────────────────────────┐
            ↓                                                           ↓
      PACKAGES/CLI (I/O)                                       PACKAGES/CORE (Pur)
            │                                                           │
    1. Lit l'argument CLI ──────────────────────────────┐               │
    2. fs.readFileSync()                                │               │
    3. Construit {SourceFile}                           ↓               │
    4. Appel ───────────────────────────────> analyze(files, rules)     │
            │                                           │               │
            │                                           ├── parseMarkdown() -> AST
            │                                           ├── MEM001 (lines)
            │                                           ├── MEM002 (sections vides)
            │                                           └── MEM003 (structure req.)
            │                                           │               │
    5. Reçoit [Findings] <──────────────────────────────┘               │
    6. Formate (JSON/Text)                              │               │
    7. process.exit(0/1/2)                              │               │
            │                                           │               │
    (Responsabilité technique)                  (Responsabilité métier / déterministe)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les étapes de l'implémentation guidée :
1. Envoyer le plan détaillé (phase 2) et exiger les tests d'abord.
2. Demander la validation des tests (`test`, `typecheck`).
3. Bloquer la session (Clôture Phase 2).
4. Envoyer le plan de la phase 3 (CLI), en rappelant les limites du package public.
5. Exécuter la commande finale de visu (`node packages/cli/dist/index.js scan CLAUDE.md`).
6. Demander une revue "Anti-Dérive" stricte du `git diff` avant de valider le travail de l'agent.
```

> **La phrase centrale de la leçon :**
> L'implémentation phase par phase empêche l'agent de fusionner les logiques métier et technique dans un seul fichier "spaghetti" ; le `core` reste ainsi pur, prédictible et réutilisable, tandis que le `cli` se cantonne à un simple tuyau d'entrée/sortie.
