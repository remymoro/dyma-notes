Claude Code 14. Les compétences (skills) 3. Présentation de /simplify et /code-review

Relire et améliorer un changement
Claude Code fournit trois skills complémentaires pour relire ou transformer un changement :

Skill | Objectif principal | Effet sur le code
---|---|---
/code-review | Rechercher des bugs de correction et des améliorations dans un diff. | Produit un rapport par défaut. Peut appliquer les corrections avec --fix.
/simplify | Nettoyer et simplifier un changement déjà fonctionnel. | Applique directement les améliorations retenues.
/batch | Décomposer et exécuter un changement massif en parallèle. | Crée plusieurs travaux isolés pouvant aboutir à plusieurs pull requests.

Ces skills ne sont pas interchangeables. /code-review vérifie principalement la correction du changement, /simplify améliore sa structure et /batch orchestre une transformation à grande échelle.

/code-review
/code-review analyse un diff afin de rechercher des bugs, des régressions, des cas limites incorrectement traités et certaines possibilités de réutilisation, de simplification ou d’amélioration de l’efficacité.

Par défaut, la revue locale couvre :
les commits de la branche courante qui ne sont pas encore présents dans sa branche distante de référence ;
les changements non commités présents dans l’arbre de travail ;
les fichiers nécessaires pour comprendre le diff dans le contexte du projet.

La commande produit un rapport. Elle ne modifie pas le code tant que l’option --fix n’est pas utilisée.

Syntaxe complète
/code-review [low|medium|high|xhigh|max|ultra] [--fix] [--comment] [cible]

Argument ou option | Rôle
---|---
low | Effectuer une revue rapide avec peu de résultats et un niveau de confiance élevé.
medium | Augmenter la couverture tout en conservant une revue relativement ciblée.
high | Effectuer une analyse plus large du changement et de son contexte.
xhigh | Approfondir davantage la recherche de problèmes et les vérifications associées.
max | Utiliser le niveau de revue locale le plus approfondi.
ultra | Lancer une revue approfondie et multi-agent dans un environnement cloud distant.
--fix | Appliquer les corrections retenues dans l’arbre de travail après la revue.
--comment | Publier les résultats sous forme de commentaires en ligne dans une pull request GitHub.
cible | Limiter ou redéfinir le périmètre de la revue.

Choisir le niveau d’effort
Les niveaux faibles produisent moins de résultats et privilégient les problèmes les plus certains. Les niveaux élevés couvrent davantage de code et peuvent également remonter des problèmes plus incertains.

/code-review low
/code-review medium
/code-review high
/code-review xhigh
/code-review max

Lorsqu’aucun niveau n’est fourni, /code-review utilise le niveau d’effort actif dans la session.
Pour le convertisseur, une revue medium ou high est généralement suffisante :
/code-review high

Cibler une revue
La cible peut être un chemin de fichier, une pull request, une branche ou une plage de références Git.

Cible | Exemple
---|---
Un fichier ou un dossier | /code-review high src/main.js
Une pull request | /code-review medium 123
Une branche | /code-review high feature/saisie-invalide
Une plage Git | /code-review high main...feature/saisie-invalide

La plage utilisant trois points permet de revoir exactement le diff qu’une pull request de la branche de fonctionnalité vers main contiendrait, indépendamment de la branche distante suivie localement.

Appliquer les corrections avec --fix
Par défaut, /code-review présente ses conclusions sans modifier les fichiers.
L’option --fix demande à Claude d’appliquer les corrections correspondant aux problèmes retenus :

/code-review --fix

Elle peut être associée à un niveau d’effort et à une cible :
/code-review high --fix src/main.js

Après l’application des corrections, relisez systématiquement le nouveau diff et relancez les validations :
git diff
npm test

--fix ne signifie pas que toutes les propositions doivent être acceptées sans contrôle. La correction peut modifier plusieurs fichiers si le problème nécessite une adaptation cohérente du code et des tests.

Publier les conclusions avec --comment
L’option --comment permet de publier les conclusions de la revue sous forme de commentaires en ligne sur une pull request GitHub.

/code-review medium --comment 123

Cette option nécessite :
une pull request identifiable ;
un accès GitHub correctement configuré ;
les permissions nécessaires pour publier des commentaires.

Utilisez-la seulement après avoir relu les conclusions. Une revue locale permet de contrôler les résultats avant de les rendre visibles dans la pull request.

Utiliser le mode ultra
/code-review ultra lance une revue approfondie dans un environnement cloud distant. Plusieurs agents spécialisés explorent le changement en parallèle et les problèmes remontés sont vérifiés avant d’être présentés.

/code-review ultra

Sans cible, la revue compare la branche courante à la branche par défaut du dépôt. Elle inclut également les changements indexés et non commités présents dans l’arbre de travail.

Pour revoir directement une pull request :
/code-review ultra 123

Dans ce cas, l’environnement distant clone la pull request depuis GitHub au lieu d’envoyer l’état local du dépôt.
Il est également possible d’appliquer les corrections retournées par la revue distante :

/code-review ultra --fix

Avant le lancement, Claude Code affiche :
le périmètre de la revue ;
le nombre de fichiers et de lignes concernés ;
les éventuelles utilisations gratuites restantes ;
une estimation du coût lorsque des crédits d’usage sont nécessaires.

La revue s’exécute ensuite en arrière-plan. Son état peut être consulté avec :
/tasks

Le mode ultra nécessite une authentification avec un compte Claude.ai. Il n’est pas disponible avec une connexion reposant uniquement sur une clé API, ni dans certains environnements cloud tiers.
Il est disproportionné pour une modification de quelques lignes dans le convertisseur. Il devient pertinent pour une pull request importante, risquée ou difficile à vérifier localement.

Utiliser la revue ultra dans un script ou une CI
La commande non interactive équivalente est :
claude ultrareview [cible]

Exemples :
claude ultrareview
claude ultrareview 123
claude ultrareview origin/main

Deux options sont disponibles :
Option | Rôle
---|---
--json | Afficher le résultat JSON brut plutôt que le rapport formaté.
--timeout <minutes> | Définir la durée maximale d’attente. La valeur par défaut est de 30 minutes.

claude ultrareview origin/main \
--json \
--timeout 20

La commande retourne le code 0 lorsque la revue se termine, qu’elle trouve ou non des problèmes. Elle retourne le code 1 en cas d’échec ou de dépassement du délai, et 130 lorsqu’elle est interrompue avec Ctrl+C.

Application au convertisseur
Après avoir corrigé la gestion des saisies invalides, la revue doit notamment vérifier :
que la saisie vide est détectée avant la conversion ;
que les valeurs non numériques sont refusées ;
que les conversions valides fonctionnent toujours ;
que le comportement affiché reste cohérent avec les fonctions de conversion ;
que les tests utiles ont été ajoutés ;
que le changement reste limité au problème demandé.

/code-review high src/main.js

/code-review n’est pas un outil général de mesure de couverture. L’absence d’un test devient surtout pertinente lorsqu’elle empêche de vérifier un comportement modifié ou laisse passer un problème de correction.

/simplify
/simplify examine un changement déjà fonctionnel afin de rechercher des améliorations de lisibilité, de réutilisation et de structure.

Contrairement à /code-review, cette skill ne cherche pas prioritairement les bugs de correction dans les versions actuelles. Elle applique directement les améliorations retenues dans l’arbre de travail.

Syntaxe complète
/simplify [cible]

/simplify ne possède pas d’option --fix : les corrections sont appliquées automatiquement.

Invocation | Périmètre
---|---
/simplify | Examiner le code modifié dans le changement courant.
/simplify src/main.js | Limiter la simplification à un fichier.
/simplify src/ | Limiter la simplification à un dossier.
/simplify 123 | Examiner une pull request particulière.

Les quatre axes de revue
/simplify lance quatre agents de revue en parallèle. Ils examinent le changement selon quatre axes complémentaires :

Axe | Question examinée
---|---
Réutilisation | Le changement recrée-t-il une fonction, un helper ou un mécanisme déjà présent dans le projet ?
Simplification | Le code contient-il une logique, des branches ou des abstractions inutilement complexes ?
Efficacité | Le changement effectue-t-il des opérations inutiles ou utilise-t-il une approche moins efficace que nécessaire ?
Niveau d’abstraction | La logique se trouve-t-elle au bon endroit et au bon niveau dans l’architecture ?

Le résultat de ces analyses est regroupé, puis les améliorations retenues sont appliquées au code.

Quand utiliser /simplify
/simplify doit intervenir lorsque le changement fonctionne déjà.

Ordre conseillé :
1. implémenter le changement ;
2. lancer les tests ;
3. vérifier le comportement réel ;
4. rechercher les bugs avec /code-review ;
5. nettoyer le changement avec /simplify ;
6. relancer les tests et relire le diff.

Évitez de lancer /simplify lorsque :
les tests sont encore en échec ;
la cause du problème n’est pas comprise ;
le comportement attendu n’a pas été vérifié ;
le changement est encore en cours de conception.

Application au convertisseur
Après la correction du formulaire, utilisez :
/simplify src/main.js

La skill peut notamment vérifier :
si la validation des saisies est répétée inutilement ;
si une fonction existante peut être réutilisée ;
si les conditions sont plus complexes que nécessaire ;
si la logique métier reste séparée du DOM ;
si une abstraction ajoutée est disproportionnée pour un projet aussi petit.

Après son exécution :
git diff
npm test

Comme /simplify modifie directement les fichiers, la relecture du diff est obligatoire.

Évolution du comportement
Dans les anciennes versions de Claude Code, /simplify pouvait également rechercher des bugs et correspondait au comportement actuel de /code-review --fix.
Dans les versions récentes, les responsabilités sont séparées :

/code-review
→ rechercher les bugs et produire un rapport
/code-review --fix
→ rechercher les bugs et appliquer les corrections
/simplify
→ rechercher uniquement les nettoyages et les appliquer

/batch
/batch orchestre des transformations importantes réparties dans une grande partie d’un dépôt Git.

/batch <instruction>

Fonctionnement de /batch
Le workflow se déroule en plusieurs étapes :
1. Claude explore le dépôt et recherche les zones concernées.
2. Il décompose le changement en 5 à 30 unités indépendantes.
3. Il présente un plan avant de commencer l’implémentation.
4. Après validation, chaque unité est confiée à un sous-agent exécuté en arrière-plan.
5. Chaque sous-agent travaille dans un worktree Git isolé.
6. Chaque unité est implémentée et testée séparément.
7. Chaque sous-agent peut ouvrir une pull request pour son unité de travail.

Instruction globale
│
▼
Plan de 5 à 30 unités
│
▼
Validation humaine
│
├── Sous-agent 1 → worktree 1 → tests → PR
├── Sous-agent 2 → worktree 2 → tests → PR
└── Sous-agent N → worktree N → tests → PR

Prérequis
/batch nécessite un dépôt Git.
La création effective de pull requests suppose également :
un dépôt distant configuré ;
une authentification GitHub disponible ;
les permissions nécessaires pour pousser des branches et ouvrir des pull requests.

Les différents sous-agents consomment du contexte et des tokens séparément. Une exécution parallèle peut donc consommer beaucoup plus de quota qu’une modification effectuée par une seule session.

Quand utiliser /batch
/batch convient aux tâches importantes mais divisibles en unités relativement indépendantes.

/batch Migrer tous les composants de src/ depuis l'ancienne API
vers la nouvelle API interne.
Contraintes :
- ne modifie pas les fichiers générés ;
- conserve le comportement public ;
- ajoute ou adapte les tests de chaque composant ;
- une unité de travail ne doit pas dépendre des modifications
d'une autre unité.

Exemples adaptés :
migrer plusieurs dizaines de composants vers une nouvelle API ;
mettre à jour un grand nombre de modules indépendants ;
remplacer une convention dans plusieurs packages ;
ajouter le même type de test à de nombreux services séparés ;
transformer une grande quantité de fichiers selon une règle vérifiable.

Quand ne pas utiliser /batch
/batch est inadapté lorsque :
la correction concerne seulement quelques fichiers ;
les différentes unités dépendent fortement les unes des autres ;
plusieurs agents devraient modifier les mêmes fichiers centraux ;
l’architecture cible n’est pas encore définie ;
la tâche ne peut pas être validée indépendamment par unité ;
le coût de coordination dépasse celui de l’implémentation.

Le convertisseur de température est trop petit pour justify cette orchestration.
Mauvais usage :
/batch Corriger la validation dans src/main.js
Une demande directe suffit :
Corrige la gestion des saisies invalides dans src/main.js, ajoute les tests utiles puis vérifie le comportement.

Suivre le travail parallèle
Les unités sont exécutées en arrière-plan. Leur progression peut être consultée depuis :
/tasks

Avant d’approuver le plan proposé par /batch, vérifiez :
que les unités sont réellement indépendantes ;
que leur périmètre ne se chevauche pas ;
que chaque unité possède une validation précise ;
que les fichiers générés ou sensibles sont exclus ;
que le nombre d’unités reste proportionné au changement.

Choisir la bonne skill
Situation | Skill adaptée
---|---
Rechercher un bug dans un diff | /code-review
Rechercher un bug et appliquer la correction | /code-review --fix
Publier les conclusions dans une pull request | /code-review --comment
Effectuer une revue distante très approfondie | /code-review ultra
Nettoyer un changement déjà valide | /simplify
Migrer de nombreux modules indépendants | /batch
