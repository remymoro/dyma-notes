Analyser MEM002 pour extraire la procédure

Le prompt d’analyse se fait en mode plan. Il nomme la règle de référence, énumère les surfaces à inspecter et annonce l’usage final :
> Examine une règle existante du projet, par exemple MEM002.
> Regarde le fichier d'implémentation et le fichier de test.
> Regarde comment les règles sont enregistrées.
> Regarde également les fixtures, les snapshots et le dogfooding.
> Ensuite, liste-moi toutes les étapes pour l'ajout d'une nouvelle règle, en spécifiant tous les fichiers qui vont être concernés.
> L'objectif de cette analyse est de préparer la mise en place d'une issue GitHub.

La dernière phrase est cruciale : elle oriente toute la réponse pour obtenir une checklist ordonnée.

L’anatomie de MEM002
- Objet règle : `mem002.ts` (objet Rule pur, id, severity).
- Test unitaire : `mem002.test.ts` (fixtures inline, pas de snapshot).
- Enregistrement : `rules/index.ts` (tableau fixe). La CLI est agnostique.
- Verrou : `rules.test.ts` fige la liste des ids. L'ajout casse ce test volontairement.
- Fixtures CLI : Scénarios transversaux (`packages/cli/fixtures/`).
- Snapshots : Niveau CLI (`fixtures.test.ts.snap`).
- Dogfooding : `CLAUDE.md` doit produire 0 finding.

La checklist d’ajout d’une règle (extraite par l'analyse)
1. Créer `mem00N.ts`
2. Créer `mem00N.test.ts`
3. Modifier `index.ts`
4. Modifier `rules.test.ts` (ajouter l'id)
5. Adapter les fixtures CLI
6. Regénérer le snapshot CLI (`vitest -u`)
7. Vérifier le dogfooding
8. Vérification finale (`build`, `typecheck`, `test`, `lint`)
9. Docs (optionnel)

Les deux incohérences relevées
L'analyse relève des écarts (documentation en retard, mauvais format cité). Ces écarts ne se corrigent pas dans la foulée, ils sont notés pour l'issue.

Refuser le plan et créer l’issue
Le plan d'exécution est refusé car le livrable attendu était l'analyse, pas l'exécution.
> Le mode plan produit deux choses distinctes, une compréhension du terrain et une proposition d’action. Rien n’oblige à accepter la seconde pour garder la première.

Le prompt de création de l’issue (contexte, objectif, critères d'acceptation) produit une issue structurée.
> Crée une issue sur le repository qu'on va appeler "skill new-rule : création d'une nouvelle règle de lint".
> [...]
> Objectif : créer une skill nommée new-rule qui déroule la procédure complète et s'arrête pour demander des décisions de spec si ambigu.
> Critères d'acceptation : ...

Traiter l’issue dans une session neuve
Dans une nouvelle session :
> Récupère la liste des issues du répertoire.

Demander un plan sans rien inventer :
> Propose-moi un plan pour l'issue numéro 1 si jamais il y a des ambiguïtés dans le contenu de l'issue.
> Pose-moi des questions, on n'invente rien.

Les quatre questions posées :
Claude pose des questions (format de l'id, limitation au préfixe, comment valider la skill, quelle base pour l'exemple). Y répondre évite des réécritures ultérieures.

Livrer la skill
L'implémentation ajoute l'étape 4bis (oubli de l'issue initiale). Un écart signalé enrichit la procédure.
La vérification est faite en local (lint, test ok) confirmant que la skill est livrée seule.

Ouvrir la pull request via le serveur MCP
> valide et push
> et crée une pull request
> utilise le serveur MCP

Ce que le serveur a fait : Création branche distante depuis main, Push des 4 fichiers, Ouverture PR.
Le push ayant été fait par l'API GitHub, la branche distante porte un commit différent du local (SHA diffère). Conséquence : pour retravailler la branche localement, il faut faire `git fetch` puis recréer la branche locale depuis origin.
La fusion de la PR ferme l'issue. La boucle est complète.
