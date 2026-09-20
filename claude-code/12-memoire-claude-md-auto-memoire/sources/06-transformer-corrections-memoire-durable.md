Une correction ponctuelle règle une session. Une correction durable améliore les sessions futures. Dans Claude Code, la mémoire sert précisément à transformer certaines erreurs répétées en contexte permanent : une commande oubliée, un ancien pattern recopié, une convention de PR non respectée, une hypothèse récurrente ou une remarque de revue qui revient trop souvent.
Le but n'est pas d'écrire plus de mémoire, mais une mémoire qui réduit le taux d'erreur futur. Ce cycle suppose acquis les emplacements, les imports et l'audit déjà traités ; il porte ici sur une seule question : repérer une erreur récurrente, décider si elle mérite une règle durable, l'écrire au bon niveau, la tester, puis la nettoyer quand elle n'est plus utile.

Le principe de capitalisation
Corriger la cause, pas seulement la sortie
Quand Claude fait une erreur, la réponse immédiate consiste souvent à corriger le prompt courant. Cette correction est nécessaire, mais elle reste locale à la session. Si la même erreur se reproduit plus tard, le problème n'était pas seulement la réponse de Claude ; c'était l'absence d'une règle durable dans l'environnement de travail.

Correction locale :
Non, n'utilise pas l'ancien client API dans ce fichier.
Correction durable :
Mettre a jour CLAUDE.md : tout nouveau code reseau utilise src/lib/api-client.ts ;
src/legacy/request.ts ne doit plus servir aux nouveaux appels.

La correction durable doit être courte, précise et testable. Elle ne raconte pas l'histoire de l'erreur ; elle empêche l'erreur de se reproduire.

Le compounding engineering
On peut appeler ce mécanisme compounding engineering : chaque correction utile ajoute une petite amélioration au système de travail. Une règle de test, une convention de migration, un gotcha d'environnement ou une note de revue transformée en mémoire réduit légèrement la probabilité de refaire la même erreur. L'effet devient significatif lorsque ces corrections sont accumulées, relues et nettoyées. C'est une manière de cadrer le travail, pas une fonctionnalité de Claude Code.
Le gain est cumulatif seulement si la mémoire reste saine. Ajouter tout sans trier transforme la mémoire en dette contextuelle ; n'ajouter que les règles durables rend le projet progressivement plus facile à piloter.

Quand capitaliser
Une erreur mérite une règle durable lorsqu'elle est stable, répétitive et non évidente depuis le code. Une erreur isolée, une préférence temporaire ou une hypothèse de debugging ne suffisent pas. La distinction est la même que pour l'auto-mémoire : on conserve des patterns, pas des accidents de session. Le signal fort est la répétition à travers plusieurs sessions, plusieurs PR ou plusieurs corrections.
Le type d'erreur oriente la destination, selon la logique déjà posée : une commande systématiquement fausse va dans CLAUDE.md, une convention propre à une zone devient une règle limitée au chemin, une procédure recollée devient une skill, une action à bloquer techniquement relève d'une permission ou d'un hook. La nouveauté de cette leçon est qu'une remarque de revue récurrente est, elle aussi, un signal de capitalisation.

Capitaliser depuis la revue de PR
Transformer une remarque récurrente en règle
Une revue de PR est l'un des meilleurs endroits pour détecter les règles manquantes. Si un reviewer écrit plusieurs fois la même remarque, corriger la PR ne suffit pas : il faut se demander si la remarque doit devenir une instruction de projet, pour que la prochaine session reçoive la règle au bon moment au lieu de redécouvrir la convention après coup.

Remarque de revue recurrente :
les endpoints publics doivent retourner le format d'erreur standard.
Transformation :
mettre a jour .claude/rules/api.md : tout endpoint public retourne le format
d'erreur standard, avec un test du cas d'erreur si le comportement change.
Regle courte, limitee aux fichiers src/api, sans toucher au code applicatif.

Le déclencheur @claude
Pour l'intégration GitHub, le déclencheur documenté est @claude. Une mention @claude dans une PR ou une issue demande à Claude d'analyser le code, d'implémenter ou de corriger, en respectant les standards du projet définis dans CLAUDE.md. Le comportement se configure de deux façons : les critères de revue et les conventions dans CLAUDE.md (au besoin une section dédiée au contexte CI), et le paramètre prompt du workflow pour des instructions propres à l'exécution. Une mention écrite « @.claude » désigne le dossier .claude, pas le déclencheur.

Ne pas transformer toute préférence de reviewer
Une remarque ne devient pas automatiquement une règle. Avant de la convertir, vérifiez qu'elle est revenue plusieurs fois, qu'elle est vraie hors de cette PR, qu'elle est acceptée par l'équipe, qu'elle tient en une règle courte au périmètre clair, et qu'elle ne contredit pas une instruction existante. Une préférence de style isolée ou une décision propre à une PR ne doit pas devenir une instruction globale.

Protocole de conversion après erreur
Quand une erreur récurrente apparaît, cinq étapes courtes la transforment en règle utile sans sur-réagir.

Étape 1 : formuler l'erreur
Explique l'erreur que tu viens de faire.
Reponds uniquement avec :
erreur produite ; cause probable ;
regle durable qui l'aurait evitee ;
emplacement recommande ;
risque si on ajoute cette regle trop largement.

Cette étape évite la règle écrite à chaud ou trop large. Claude décrit d'abord le mécanisme précis de l'erreur.

Étape 2 : choisir la destination
La décision d'emplacement compte plus que la rédaction : une bonne règle au mauvais endroit devient soit invisible, soit trop globale. Le choix se fait parmi les destinations déjà connues, CLAUDE.md, .claude/rules/, CLAUDE.local.md ou mémoire utilisateur, auto-mémoire, skill, note consultable, permission ou hook, ou « aucune mémoire » si l'erreur n'était qu'un accident isolé.

Étape 3 : écrire petit
Ecris la regle minimale.
Contraintes :
moins de cinq lignes ; pas d'historique ni de justification narrative ;
un comportement a suivre ; un comportement a eviter ; un perimetre clair.

Étape 4 : tester le comportement
A partir de la nouvelle regle, explique quelle commande ou quel pattern
tu choisirais maintenant, et l'ancien comportement qu'elle doit empecher.
Ne modifie aucun fichier.

Ce test ne prouve rien de façon absolue, mais il vérifie que la règle est comprise et visible. Si Claude ne l'applique pas dans un cas simple, la formulation doit être retravaillée.

Étape 5 : faire relire
Une modification de mémoire partagée suit la même discipline qu'une modification de configuration : diff minimal, revue humaine, suppression des doublons. En CI, Claude respecte les standards définis dans CLAUDE.md ; les critères de revue s'affinent dans CLAUDE.md, au besoin une section dédiée au contexte CI, et via le paramètre prompt du workflow.

Deux exemples
Erreur de commande
Erreur : Claude lance npm test, mais le projet utilise pnpm test:unit.
Regle durable, dans CLAUDE.md (section Commandes) :
utiliser pnpm, pas npm ;
pour les tests unitaires, lancer pnpm test:unit ;
ne pas lancer toute la suite sans demande explicite.

Erreur de revue
Erreur : les PR de Claude oublient de mentionner les tests executes.
Regle durable, dans CLAUDE.md (section Pull requests) :
toute description de PR inclut les changements, les risques,
les tests executes, et les tests non executes avec leur raison.

Faire expirer les règles de capitalisation
Une règle issue d'une erreur récurrente n'est pas forcément permanente. Elle devient inutile quand le code est migré, quand un test empêche désormais l'erreur, quand la convention devient évidente, ou quand une permission bloque le risque. À la relecture, vérifiez si la migration mentionnée existe encore, si l'ancien pattern est encore visible, si un test ou une permission rend la règle redondante, et si elle n'est pas dupliquée ailleurs.
Le cas le plus piégeux est la section de migration : une règle transitoire qui survit à la transition devient une instruction fausse, et continue de charger un état dépassé dans chaque session. Donnez-lui une condition de suppression explicite.
Les commentaires HTML de bloc, vus pour les emplacements, servent justement à dater cette condition pour les humains sans peser sur le contexte de Claude.

Erreurs fréquentes
Ajouter une règle après chaque incident
Chaque erreur ne mérite pas une mémoire. Une mémoire excessive réduit la lisibilité, augmente le contexte et peut rendre Claude plus hésitant. Capitalisez les patterns, pas les accidents.

Conserver les règles de migration après migration
Une règle transitoire qui survit à la transition devient fausse. Toute section de migration doit avoir une condition de suppression, sinon elle oriente les sessions futures avec un état qui n'existe plus.

Laisser l'auto-mémoire décider pour l'équipe
Une mémoire automatique locale peut révéler une règle utile, mais elle ne devient une source d'autorité d'équipe qu'après revue humaine et promotion vers un fichier versionné.
