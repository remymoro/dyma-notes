---
title: "Vérifier, récupérer et capitaliser"
description: "Valider le résultat, récupérer après un échec et conserver les enseignements du projet."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - projet
  - verification
  - capitalisation
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 09-verifier-recuperer-capitaliser
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quel est l'objectif de la Phase 4 ?** | Sécuriser tout ce qui a été fait dans les phases 1 à 3 par des tests de bout en bout (fixtures, snapshots, E2E). La phase 4 ne doit ajouter **aucune logique métier**. Son but est de verrouiller les gates 3 et 4 pour s'assurer qu'aucune régression ne surviendra. |
| **Pourquoi créer une fixture `avertissements` en plus de `sain` et `fautif` ?** | Pour prouver le bon fonctionnement de l'argument `--fail-on`. Avec `--fail-on error`, cette fixture doit retourner un exit code `0`. Avec `--fail-on warn`, elle doit retourner un exit code `1`. C'est la preuve que le seuil de sévérité modifie bien la décision d'échec sans modifier les findings eux-mêmes. |
| **Pourquoi ajouter un fichier `.gitattributes` pour les fixtures ?** | Windows, Linux et macOS gèrent différemment les fins de ligne (`CRLF` vs `LF`). Les fichiers de fixtures doivent être figés octet par octet pour garantir que les tests et les snapshots JSON générés ne diffèrent pas selon l'OS du contributeur. |
| **Pourquoi le test de "Dogfooding" n'utilise-t-il pas de snapshot ?** | Le test de dogfooding passe le vrai `CLAUDE.md` du projet au linter. La sortie du CLI contient le chemin absolu du fichier. Un chemin absolu dépend de la machine du développeur, donc utiliser un snapshot ferait échouer le test chez un autre collaborateur. On utilise plutôt des assertions directes : `exitCode === 0` et `output === ""`. |
| **Pourquoi le test E2E (Smoke test) est-il essentiel en plus des tests `runScan` ?** | `runScan` teste la logique interne du CLI mais pas le fichier compilé `dist/index.js`, ni le parsing des arguments système (`process.argv`), ni les vrais `stdout/stderr`. Le test E2E lance le vrai processus enfant via `execFile(process.execPath, ...)` pour simuler l'expérience réelle d'un utilisateur dans le terminal. |
| **Quelle modification du `package.json` le test E2E impose-t-il ?** | Le test E2E dépendant de `dist/index.js`, il faut obligatoirement recompiler le projet avant de lancer les tests. Le script `"test"` devient donc `"pnpm run build && vitest run"`. |

## Synthèse
La leçon se concentre sur l'étape ultime de la tranche verticale : la Phase 4. Le code métier (parsing, règles, CLI) a été écrit dans les phases 2 et 3. La phase 4 met le projet "sous cloche" en créant un harnais de tests complet. On commence par générer trois fixtures `Markdown` (sain, fautif, avertissements) figées par `.gitattributes` pour gérer le problème des fins de lignes (CRLF/LF). On confronte la fonction `runScan` à ces fixtures et on capture le résultat avec des snapshots (sorties exactes verrouillées). On rend le "Dogfooding" permanent via un test qui vérifie que le propre fichier `CLAUDE.md` du projet respecte les règles. Enfin, on va plus loin qu'un simple test unitaire en créant un Smoke Test "E2E" : on exécute le vrai binaire compilé (`dist/index.js`) dans un sous-processus Node pour s'assurer que la propagation des codes d'erreur (0, 1, 2) remonte correctement au système d'exploitation. Cette phase modifie la commande de test globale (`pnpm run test`) pour qu'elle recompile obligatoirement le projet avant les tests, protégeant ainsi le projet de toute dérive future.

## Glossaire
- **Snapshot (test)** : Capture du résultat exact (texte ou JSON) produit par une fonction à un instant T. Lors de la prochaine exécution, le framework (Vitest) compare la nouvelle sortie au snapshot. Si elle diffère, le test échoue.
- **Fixture** : Fichier de données fictif (ex: un faux `CLAUDE.md` rempli d'erreurs) créé spécifiquement pour servir d'entrée reproductible à un test.
- **Smoke test E2E (End-to-End)** : Test "boîte noire" qui n'appelle pas de fonctions internes, mais lance le programme compilé final comme le ferait un vrai utilisateur dans le terminal.
- **Dogfooding** : Tester l'outil sur lui-même (ici, vérifier que le fichier `CLAUDE.md` qui documente le projet Claudoscope est valide aux yeux de `claudoscope`).

## Questions d'auto-évaluation
1. Dans la matrice de tests, quel `exitCode` est attendu pour la fixture `avertissements` si on lance l'analyse avec `--fail-on error` ?
2. Quelle commande est recommandée pour exécuter le processus enfant de manière portable sous Windows et Linux (plutôt que d'appeler directement `node`) ?
3. Pourquoi une des fixtures fautives ne doit-elle pas contenir le mot `Recommandations` dans l'un de ses titres ?
4. Si l'agent modifiait le fichier `packages/core/src/engine.ts` durant la phase 4, pourquoi cela serait-il considéré comme un échec ?

# Vérifier, récupérer et capitaliser (Phase 4 : Fixtures, Snapshots et E2E)

**Durée : 25 minutes**

## Objectif de la leçon
Verrouiller la première tranche verticale par des tests de non-régression, des snapshots et des tests d'intégration complets (E2E), garantissant que le CLI compilé fonctionne comme attendu dans un terminal réel.

---

# 1. Le but de la Phase 4 (Preuves et Verrous)

La phase 4 n'ajoute **aucune fonctionnalité**. L'agent reçoit une consigne stricte : le `core` et le code du `CLI` doivent rester intouchés. Le but est de créer un filet de sécurité pour les développements futurs.

**Les 3 niveaux de validation :**
1. **Tester la logique (runScan)** : On crée des fichiers fictifs (fixtures) et on teste la fonction interne `runScan`.
2. **Tester le projet (Dogfooding)** : On scanne le vrai `CLAUDE.md` du projet de manière permanente.
3. **Tester le binaire (Smoke Test E2E)** : On exécute l'archive compilée dans un vrai processus système pour valider les codes de sortie OS.

---

# 2. Les Fixtures et les Snapshots

On crée 3 faux fichiers `CLAUDE.md` dans `packages/cli/fixtures/` :
- `sain/` : Respecte toutes les règles.
- `fautif/` : Casse les 3 règles.
- `avertissements/` : Casse MEM001 et MEM002 (des avertissements), mais possède la structure requise (MEM003).

> [!WARNING]
> **Le piège des fins de ligne (CRLF vs LF)**
> Si vous créez vos fixtures sur Windows, Vitest va générer des snapshots JSON basés sur CRLF. Si la CI est sous Linux (LF), le test échouera à cause de retours chariots invisibles. Il faut ajouter `packages/cli/fixtures/** text eol=lf` dans un fichier `.gitattributes` pour figer le fichier.

**Validation Snapshot :**
On utilise Vitest pour figer la sortie `text` et `json` de `runScan` avec les fixtures. Un snapshot est un fichier `.snap` commité. Toute modification future de l'affichage fera crasher la CI.

---

# 3. Rendre le Dogfooding Permanent

Au lieu de se contenter de tester manuellement, on ajoute un test `dogfooding.test.ts`. Il résout le chemin du `CLAUDE.md` situé à la racine du projet et le passe au moteur.

```typescript
const result = await runScan(claudeMd, { format: "text", failOn: "error" });
expect(result.exitCode).toBe(0);
expect(result.output).toBe(""); // Ne pas utiliser toMatchSnapshot() ici !
```

> [!TIP]
> Pourquoi pas de snapshot ici ? Parce que `runScan` affiche le chemin absolu du fichier analysé. Le chemin absolu varie d'un PC à un autre (`/home/alice/...` vs `C:\Users\bob\...`). Le snapshot crasherait systématiquement sur une autre machine.

---

# 4. Le Smoke Test E2E (Tester la vraie vie)

Les tests précédents testent la logique, mais pas si le programme compilé (`dist/index.js`) fonctionne dans un vrai terminal, s'il parse bien ses arguments, et s'il remonte le bon code d'erreur au shell.

On crée `e2e.test.ts`. Ce test utilise `child_process.execFile` pour lancer Node.

```typescript
// On utilise process.execPath (le chemin vers l'exécutable node courant) pour la portabilité cross-OS.
execFile(process.execPath, [
  "packages/cli/dist/index.js",
  "scan",
  "packages/cli/fixtures/fautif/CLAUDE.md",
  "--format", "json"
]);
```

**La modification structurelle cachée :**
Puisque le test E2E appelle `dist/index.js`, **le code doit avoir été buildé avant que les tests ne soient lancés**.
On demande donc à l'agent de modifier le script `"test"` dans le `package.json` racine :
```json
"scripts": {
  "test": "pnpm run build && vitest run"
}
```

---

# Cartes mentales

```text
               LA STRATÉGIE DE TESTS (PHASE 4)
                              │
       ┌──────────────────────┼──────────────────────┐
       ↓                      ↓                      ↓
  1. FIXTURES             2. DOGFOODING          3. SMOKE TEST E2E
(Tests Logiques)         (Test de projet)       (Test d'intégration)
       │                      │                      │
- 3 fichiers fictifs     - Scanne le vrai       - Lance process Node
- Valide `--fail-on`       CLAUDE.md            - Appelle `dist/index.js`
- Fige la sortie texte   - Assertions exactes   - Valide les stdout/stderr
  et JSON (Snapshots)      (Exit=0, Output="")  - Valide les exit codes OS
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les étapes de clôture de la Tranche Verticale :
1. Figer un ensemble de fichiers de tests (fixtures) pour les cas extrêmes et les avertissements.
2. Ajouter le fichier `.gitattributes` pour annuler la variabilité des fins de ligne inter-OS.
3. Utiliser les snapshots pour bétonner l'affichage JSON et texte.
4. Créer un test permanent sur le vrai fichier du projet (Dogfooding).
5. Créer un test E2E appelant le fichier compilé pour vérifier les codes de retour de l'OS.
6. Modifier la commande `test` pour forcer le `build` au préalable.
```

> **La phrase centrale de la leçon :**
> Une tranche verticale fonctionnelle n'est terminée que lorsqu'elle est transformée en contrat de non-régression, verrouillant à la fois la logique interne par des snapshots et le comportement système par des tests bout en bout du binaire compilé.
