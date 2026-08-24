/init sert à créer une première version de CLAUDE.md à partir du projet réel. La commande fait analyser la base de code par Claude Code, puis produit un fichier de départ avec les commandes, conventions et éléments de contexte qu’il peut déduire. Si un fichier CLAUDE.md existe déjà, /init propose des améliorations plutôt que de le remplacer.
/init ne produit pas une mémoire finale. Il produit une base. Cette base doit ensuite être relue, corrigée, réduite et complétée par des informations que Claude ne peut pas deviner avec certitude. Une bonne mémoire de projet ne se génère pas en une seule passe ; elle se stabilise par usage réel.
La démarche stable consiste à lancer /init lors de la première session dans un dépôt, puis à utiliser /memory pour affiner et vérifier les fichiers de mémoire chargés.

Le rôle de /init
Produire une base de départ
/init évite de partir d’un fichier vide. Il peut identifier des commandes évidentes, des fichiers de configuration, une structure de projet, des conventions visibles et des points de départ utiles. Cette génération est particulièrement utile dans un dépôt qui n’a jamais été préparé pour Claude Code.

/init

Après exécution, il faut considérer le résultat comme une proposition. Le fichier doit être traité comme une première revue automatique du projet, pas comme une vérité. Claude peut détecter une commande plausible sans savoir qu’une autre commande est la commande officielle de l’équipe. Il peut inférer une convention visible dans quelques fichiers, mais ignorer une règle de revue, une contrainte de CI ou une migration en cours.

Analyser avant de valider
La première relecture doit répondre à une question simple : est-ce que chaque ligne du fichier va réellement aider Claude dans les prochaines sessions ? Si une ligne ne change pas le comportement attendu, elle doit être supprimée ou déplacée.

Apres /init, relis le fichier genere.
Verifie :
les commandes proposees ;
les conventions detectees ;
les dossiers mentionnes ;
les regles trop generales ;
les informations deja evidentes dans le code ;
les elements manquants que Claude ne peut pas inferer.

Le fichier généré doit être raccourci avant d’être enrichi. Beaucoup d’équipes font l’erreur inverse : elles ajoutent immédiatement des sections, alors qu’il faut d’abord supprimer les généralités, les doublons et les descriptions que Claude peut retrouver dans le dépôt.

Ce que /init peut bien détecter
Commandes visibles dans le projet
/init est utile pour repérer les commandes déjà inscrites dans des fichiers standards : scripts package.json, fichiers de configuration de build, commandes de test, conventions de dépendances ou instructions présentes dans le README.

Exemples de sorties utiles a confirmer :
npm run test
npm run lint
npm run typecheck
pnpm test
bun run test
pytest
cargo test

Ces commandes doivent être validées humainement. Une commande peut exister dans le projet sans être la commande à utiliser pour les tâches courantes. Le fichier CLAUDE.md doit indiquer la commande recommandée, pas seulement la commande possible.

Structure générale du dépôt
/init peut aussi produire une carte sommaire du projet : répertoires principaux, langage, framework, outils de test, conventions apparentes et zones de code importantes.

Informations utiles :
src contient le code applicatif ;
tests contient les tests unitaires ;
docs contient la documentation ;
packages contient les modules du monorepo ;
scripts contient les utilitaires internes.

Cette carte doit rester courte. CLAUDE.md ne doit pas devenir une description fichier par fichier. Claude peut lire les fichiers lorsqu’il en a besoin. Le rôle de CLAUDE.md est d’indiquer les repères que l’on veut disponibles dès le début.

Conventions visibles mais à confirmer
Claude peut détecter un style apparent : gestionnaire de paquets, framework de test, convention de nommage, répertoire de composants, organisation des modules. Ces observations sont utiles, mais elles doivent être validées par l’équipe.
Une convention visible n’est pas forcément une convention voulue. Dans un projet ancien ou partiellement migré, le code peut contenir plusieurs styles. /init peut reprendre un pattern historique que l’équipe ne veut plus utiliser. La relecture humaine doit donc corriger explicitement les transitions.

Ce que /init ne peut pas savoir correctement
Les décisions d’équipe hors code
Une partie importante du contexte projet ne se trouve pas dans le code. /init peut lire le dépôt, mais il ne connaît pas automatiquement les habitudes de revue, les compromis d’architecture, les règles de PR, les préférences de l’équipe ou les incidents passés.

Information | Pourquoi elle doit être ajoutée manuellement
---|---
Commande officielle de CI locale | Plusieurs commandes peuvent exister, mais une seule être recommandée.
Convention de pull request | Elle vit souvent dans les pratiques de l’équipe, pas dans le code.
Ancien pattern à ne plus suivre | Il peut être encore présent dans le code et tromper Claude.
Contraintes d’environnement | Elles dépendent parfois du poste, du réseau ou de services internes.
Gotchas récurrents | Ils viennent souvent des erreurs passées, pas de la structure du dépôt.

Les migrations partielles
Un projet partiellement migré est un cas à risque. Si l’ancien et le nouveau pattern coexistent, Claude peut copier l’ancien parce qu’il le voit encore dans plusieurs fichiers. Le fichier CLAUDE.md doit rendre la transition explicite.

Le projet migre progressivement vers le nouveau client
A utiliser pour tout nouveau code :
src/lib/api-client.ts
A ne plus utiliser pour les nouveaux fichiers :
src/legacy/request.ts
Etat actuel :
auth et billing utilisent deja le nouveau client.
admin contient encore l'ancien client pour compatibilite

Ce type d’information est exactement ce que /init peut manquer. Il voit l’ancien code, mais ne sait pas nécessairement qu’il ne doit plus être copié.

Raffiner le fichier après génération
Première passe : supprimer
La première passe doit enlever ce qui n’a pas de valeur opérationnelle. Une mémoire courte et précise est plus fiable qu’un fichier exhaustif.

Supprimer :
descriptions fichier par fichier ;
phrases generiques ;
rappels evidents ;
documentation copiee du README ;
tutoriels ;
explications de framework standard ;
sections longues non utilisees a chaque session.

Gardez CLAUDE.md spécifique, concis et structuré, car il se charge dans la fenêtre de contexte et consomme des tokens avec le reste de la conversation.

Deuxième passe : préciser
Une instruction vague doit être remplacée par une instruction actionnable. Claude suit mieux une règle courte, concrète et observable qu’une intention générale.

Faible | Meilleur
---|---
Respecte le style du projet. | Utilise pnpm, pas npm. Lance pnpm test:unit pour les tests unitaires.
Ne fais pas de gros changements. | Garde les corrections de bug sous forme de diff minimal, sans refactor non demandé.
Écris de bons tests. | Pour un bug, ajoute ou adapte un test qui échoue avant la correction.
Fais attention à l’authentification. | Ne modifie pas src/auth/session.ts sans lancer le test ciblé auth.session.test.ts.

Troisième passe : compléter
Après suppression et précision, ajoutez ce que /init ne peut pas savoir. Ces ajouts doivent rester courts et directement utiles au comportement futur de Claude.

Ajouter :
commande officielle de test ;
commande officielle de typecheck ;
workflow de PR ;
zones sensibles ;
ancien pattern a eviter ;
nouveau pattern a utiliser ;
services locaux necessaires ;
erreurs recurrentes ;
contraintes de migration.

Le bon contenu est celui qui empêche une erreur future. Si une information n’aide pas Claude à choisir, lire, modifier ou vérifier correctement, elle ne mérite probablement pas d’être dans le fichier principal.

Structure recommandée après /init
Un fichier court et lisible
Un CLAUDE.md de départ peut tenir en quelques sections. Il ne doit pas tout expliquer ; il doit donner les repères qui améliorent les prochaines sessions.

# Instructions projet pour Claude Code
## Commandes
Test unitaire :
pnpm test:unit
Typecheck :
pnpm typecheck
Lint :
pnpm lint
## Architecture
Le code applicatif est dans src.
Les routes API passent par src/api/router.ts.
Les utilitaires partages sont dans src/lib.
## Conventions
Utiliser pnpm, pas npm.
Garder les corrections de bug minimales.
Ne pas introduire d'abstraction sans test cible.
## Migrations en cours
Le projet migre vers src/lib/api-client.ts.
Ne pas creer de nouveaux appels avec src/legacy/request.ts.
## Verification
Pour un bug, ajouter ou adapter un test qui reproduit le comportement.
Ne conclure qu'apres test cible ou justification explicite.

Ce type de fichier est plus utile qu’une documentation longue. Il donne les commandes, les contraintes et les critères de vérification qui changent réellement la conduite de la session.

Éviter les sections trop ambitieuses
Un CLAUDE.md généré peut parfois encourager à tout centraliser. Il faut résister à cette tendance. Certaines informations doivent aller ailleurs.

Contenu | Destination préférable
---|---
Procédure longue de release | Skill ou documentation dédiée.
Instructions propres à un seul dossier | Règle conditionnelle ou CLAUDE.md imbriqué.
Interdiction mécanique | Permissions ou hook.
Notes temporaires de tâche | Dossier de notes ou ticket.
Documentation API complète | Fichier de documentation existant, référencé si nécessaire.

Une skill est préférable lorsqu’une section de CLAUDE.md devient une procédure répétée ou une checklist multi étapes, car son contenu ne se charge que lorsqu’elle est utilisée.

Utiliser le flux interactif /init si disponible
CLAUDE_CODE_NEW_INIT
CLAUDE_CODE_NEW_INIT=1 active un flux interactif multi-phases. /init demande alors quels artefacts configurer (fichiers CLAUDE.md, skills et hooks), explore la base de code avec un sous-agent, comble les manques par des questions de suivi, puis présente une proposition relisable avant d’écrire le moindre fichier.

CLAUDE_CODE_NEW_INIT=1 claude
/init

Ce flux est une capacité dépendante de la version et de l’environnement. Il ne change pas la méthode stable : générer une base, relire, supprimer, préciser, compléter, puis vérifier le comportement.

Questions à poser pendant le flux interactif
Si le flux vous demande de préciser le projet, donnez des réponses courtes et concrètes. L’objectif n’est pas d’écrire toute la documentation dans la conversation, mais d’aider /init à produire un fichier exploitable.

Reponses utiles :
la commande de test officielle est pnpm test:unit ;
les nouvelles routes doivent passer par src/api/router.ts ;
ne pas utiliser l'ancien client src/legacy/request.ts ;
les PR doivent inclure le test cible lance ;
les fichiers .env ne doivent jamais etre lus.

Les interdictions critiques doivent ensuite être traduites dans les permissions. CLAUDE.md peut rappeler la règle, mais il ne doit pas être la seule couche de protection.

Traiter CLAUDE.md comme du code
Relire en revue
Un CLAUDE.md de projet doit être relu comme un fichier de configuration. Une modification peut changer le comportement de toutes les futures sessions. Il faut donc éviter les règles ambiguës, les préférences personnelles et les sections copiées sans validation.

Lors d'une revue de CLAUDE.md, verifier :
chaque commande est correcte ;
chaque regle est toujours actuelle ;
chaque instruction est actionnable ;
aucune regle personnelle n'est imposee a l'equipe ;
aucun secret ou detail sensible n'est expose ;
aucune interdiction critique ne depend uniquement du texte.

Mesurer par le comportement
La qualité d’un CLAUDE.md se mesure au comportement de Claude. Après modification, lancez une petite tâche contrôlée pour voir si la règle est suivie.

Test de comportement :
demande une correction locale ;
verifie si Claude choisit la bonne commande ;
verifie s'il evite l'ancien pattern ;
verifie s'il propose le bon test ;
verifie s'il garde le diff dans le perimetre.

Si Claude ignore une règle, le problème peut venir de la formulation, de la longueur du fichier, d’une contradiction, d’un mauvais emplacement ou d’un mécanisme plus adapté. Une règle critique doit parfois devenir une permission, un hook ou une skill.

Nettoyer régulièrement
Un fichier généré puis jamais nettoyé devient une dette contextuelle. Les commandes changent, les migrations se terminent, les conventions évoluent et certaines règles deviennent inutiles.

A chaque nettoyage :
supprimer les regles obsoletes ;
fusionner les doublons ;
raccourcir les sections longues ;
deplacer les procedures vers des skills ;
deplacer les instructions par zone vers des regles conditionnelles ;
verifier que les commandes fonctionnent encore.

Raffiner après une erreur récurrente
Mettre à jour après correction
Quand Claude répète une erreur, il ne suffit pas de corriger la session. Il faut décider si cette correction doit devenir une mémoire durable. Ajoutez une information à CLAUDE.md lorsque Claude refait une même erreur, lorsque vous retapez la même clarification ou lorsqu’une revue de code révèle une règle qu’il aurait dû connaître.

Mets a jour CLAUDE.md pour eviter cette erreur a l'avenir.
Ajoute une regle courte :
nouveau code API doit utiliser src/lib/api-client.ts ;
ne plus utiliser src/legacy/request.ts ;
garde la regle sous la section Migrations en cours.

La règle ajoutée doit être plus petite que l’erreur. Il ne faut pas écrire une longue justification historique. Il faut écrire une instruction qui empêchera la reproduction.

Ne pas tout mettre dans le fichier principal
Si l’erreur ne concerne qu’un sous-dossier, un type de fichier ou un workflow rarement utilisé, il vaut mieux ne pas gonfler le CLAUDE.md racine. Les instructions propres à une zone gagnent à vivre dans un CLAUDE.md imbriqué ou dans une règle limitée au chemin, qui ne se charge que dans le contexte concerné.

Protocole recommandé
Initialisation propre

/init
Apres generation :
ouvre CLAUDE.md ;
supprime les generalites ;
corrige les commandes ;
ajoute les conventions non deductibles ;
signale les migrations en cours ;
garde le fichier court ;
lance une tache test pour observer le comportement.

Demande de raffinement

Relis CLAUDE.md.
Objectif :
rendre ce fichier plus utile pour les futures sessions.
Actions :
supprime ce que Claude peut lire dans le code ;
garde seulement les commandes officielles ;
garde les conventions propres au projet ;
transforme les phrases vagues en consignes verifiables ;
signale les regles qui devraient plutot devenir permissions ou skills.

Validation avant commit

Avant de committer CLAUDE.md :
verifie que chaque section sert a une decision future ;
verifie que les commandes sont exactes ;
verifie que les migrations en cours sont decrites ;
verifie qu'aucune information sensible n'est presente ;
verifie que le fichier reste lisible par un humain en revue.

Erreurs fréquentes
Accepter le fichier généré sans relecture
/init est une aide, pas une autorité. Il peut proposer une commande plausible, une convention incomplète ou une description trop large. Le fichier doit être relu avant usage durable.

Transformer CLAUDE.md en documentation complète
Le fichier principal doit rester court. La documentation longue doit rester dans les docs, les notes ou les skills.

Écrire des règles que Claude peut déjà inférer
Répéter des conventions évidentes consomme du contexte sans gain. Gardez l’espace pour les contraintes invisibles, les décisions d’équipe et les pièges récurrents.

Oublier les migrations partielles
Si l’ancien pattern reste visible dans le code, Claude peut le recopier. La mémoire doit dire explicitement quel pattern suivre pour le nouveau code.

Utiliser CLAUDE.md comme seule barrière de sécurité
Une phrase dans CLAUDE.md ne remplace pas une permission. Pour les secrets, les commandes destructrices ou les chemins protégés, utilisez la couche de contrôle adaptée.
