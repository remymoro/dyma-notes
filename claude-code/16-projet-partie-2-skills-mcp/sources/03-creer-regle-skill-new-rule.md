Préparer les specs de l’issue

Un prompt en deux temps
La demande annonce d'emblée sa structure : d'abord préparer les specs, ensuite créer l'issue.
> Je vais réaliser une nouvelle règle pour Claudoscope.
> Cette session a pour tâche, dans un premier temps, de préparer la création d'une issue dans laquelle on va mettre l'ensemble des spécifications de cette règle. Dans un second temps, il faudra créer l'issue.
> Contexte : je souhaiterais ajouter une règle qui vérifie s'il y a des doublons au niveau des titres, ce qui nuit à la qualité du fichier CLAUDE.md.
> La règle ne doit pas produire d'erreur critique, ce sera simplement des avertissements à signaler.
> Si on se rend compte qu'il y a trois fois le même titre, il faudra gérer ce cas, probablement en deux findings.
> Pour l'implémentation de cette règle, on va utiliser la skill new-rule. Par conséquent, prends-la en compte et dis-moi s'il y a des ambiguïtés dans ma demande. Si ce n'est pas le cas, commence à rédiger les specs de l'issue et fais-moi un retour une fois terminé.
> Je validerai au préalable, avant que tu crées l'issue en utilisant le serveur MCP GitHub.

La sévérité est déjà tranchée (évite une question de l'IA). Le cas de la triple occurrence est anticipé. La création est conditionnée à la validation.

La session charge d'abord la skill pour connaître les conventions attendues.
> Je vais d'abord charger la skill new-rule pour comprendre les conventions attendues, puis rédiger les specs de l'issue.

Les quatre questions de spécification
- Comment comparer deux titres ? -> Insensible casse et accents.
- Titres de niveaux différents ? -> Oui.
- Où placer le finding ? -> Sur chaque doublon.
- En-têtes sans texte ? -> Les ignorer.
Aucune question ne porte sur la procédure (déjà couverte par la skill), toutes portent sur le comportement.

Les specs proposées
Titre et contexte, spécification (ID MEM004, `warn`, logique de détection via `normalize`, findings sur les répétitions, check pur).

Les cas limites tranchés
C'est la section qui évite les surprises.
- En-têtes sans texte : ignorés.
- En-têtes dans des fences de code : jamais comptés.
- Fichier vide : 0 finding.
- Titres avec dièses de fermeture : normalisés.

Tests, fixtures et dogfooding
- Test unitaire : `mem004.test.ts`.
- Agrégation : ajouter `MEM004` dans `rules.test.ts` et `e2e.test.ts`.
- Fixtures CLI : modifier `fautif`, `avertissements` et `sain`.
- Snapshot CLI :
> régénérer via pnpm exec vitest run -u, puis relire le diff ligne par ligne.

Effet de bord signalé
Modifier une fixture partagée affecte les règles déjà en place. Le snapshot capturera ce changement, il faudra le relire et non le régénérer sans regarder.

Les critères d'acceptation
Rédigés en cases à cocher `[ ]`. Ils inscrivent la procédure dans l'issue, garantissant que l'implémentation ne partira pas dans une autre direction.

Créer l'issue après validation
C'est seulement à ce moment que l'issue est créée sur GitHub via MCP. Le point de contrôle évite d'avoir à corriger une issue déjà ouverte et notifiée.

Obtenir le plan dans une session neuve
> Récupère-moi la liste des issues ouvertes sur GitHub.
> Oui, commence à traiter l'issue et génère-moi un plan.
La session explore le dépôt, la procédure de la skill, puis construit son plan sans rien réinventer (puisque tout a été tranché dans l'issue).

Erreurs à éviter
- Rédiger l'issue sans consulter la procédure : oublie les fichiers d'agrégation.
- Créer l'issue avant relecture : coûte plus cher de corriger après notification.
- Laisser un cas limite non tranché : ils seront tranchés en silence par Claude pendant le dev.
- Oublier la première occurrence : risque de doubler les findings.
- Régénérer un snapshot sans le relire : accepte les régressions silencieusement.
- Modifier une fixture partagée sans mesurer l'impact : les fixtures sont transverses aux règles.
