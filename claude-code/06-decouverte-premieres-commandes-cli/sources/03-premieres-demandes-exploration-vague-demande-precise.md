# Première session en lecture seule : comprendre avant de modifier

Dans cette leçon, vous allez utiliser Claude Code pour comprendre le mini-projet `convertisseur-temperature` sans lui demander de modification. L'objectif est de partir du bon dossier, faire lire les fichiers essentiels, comprendre les scripts, identifier les tests, repérer les zones sensibles et préparer une première demande exploitable.

Cette étape est essentielle avec un agent de code. Claude Code peut lire, exécuter des commandes, proposer des changements et modifier des fichiers. Avant de lui déléguer une correction, vous devez donc vérifier qu'il comprend le bon contexte et qu'il ne part pas d'une hypothèse fausse.

## Revenir à la racine du projet

Commencez depuis la racine du mini-projet. Si vous avez suivi la leçon précédente, le dossier s'appelle `convertisseur-temperature`.

Vérifiez ensuite que vous êtes bien dans le bon dossier et que les fichiers attendus sont présents. Vous devez retrouver notamment `package.json`, `README.md`, `index.html`, `server.js`, le dossier `src` et le dossier `test`.

```bash
cd convertisseur-temperature
pwd
ls
git status
```

Vérifiez aussi l'état Git pour connaître le point de départ. Si le dépôt est propre, vous pouvez continuer. Si des fichiers sont déjà modifiés, inspectez-les avant d'ouvrir Claude Code.

## Lancer Claude Code depuis le bon dossier

Lancez Claude Code depuis la racine du projet.

```bash
claude
```

Le dossier de lancement est important. Si vous lancez Claude Code depuis un dossier parent ou depuis un autre projet, Claude risque de lire le mauvais contexte.

## Cadrer la session en lecture seule

La première demande doit poser une limite explicite : Claude peut lire, mais il ne doit rien modifier.

```text
Nous allons commencer par une session en lecture seule.
Ne modifie aucun fichier.
Ne crée aucun fichier.
Ne lance aucune commande qui écrit dans le projet.
Ne fais pas de git add, git commit, npm install ou équivalent.
Tu peux lire les fichiers, inspecter l'arborescence et exécuter des commandes en lecture seule.
Commence par confirmer que tu es dans le projet convertisseur-temperature.
Ensuite, donne-moi un résumé très court de ce que tu vois.
```

Cette demande fixe le cadre : lecture autorisée, écriture interdite. Les modifications viendront plus tard, quand le périmètre et la preuve attendue seront clairs.

## Faire lire le dépôt progressivement

### Lire l'arborescence

L'arborescence donne une première carte du projet : fichiers racine, dossiers, code source, tests et configuration.

```text
Lis l'arborescence du projet sans modifier de fichier.
Tu peux utiliser des commandes de lecture comme ls, find ou équivalent.
Réponds avec :
1. les fichiers à la racine ;
2. les dossiers principaux ;
3. le rôle probable de chaque dossier ;
4. les fichiers que tu veux lire ensuite pour comprendre le projet.
```

Si la réponse reste trop générale, demandez à Claude de citer les fichiers réels :

```text
Précise ta réponse en citant les fichiers réels du dépôt.
Ne reste pas au niveau général.
Pour chaque fichier important, indique pourquoi tu le juges important.
```

### Lire les scripts et la configuration

Dans un projet JavaScript, `package.json` est souvent le meilleur point d'entrée. Il indique les scripts disponibles, le type de module et les dépendances. Dans ce mini-projet, Claude devrait repérer notamment `npm test`, `npm run dev` et l'usage de `"type": "module"`.

```text
Lis package.json et explique-moi les scripts disponibles.
Réponds avec :
1. la commande pour lancer les tests ;
2. la commande pour lancer le serveur de développement ;
3. le type de module utilisé ;
4. ce que tu peux déduire des dépendances.
```

### Lire le README

Le README donne l'intention du projet. Il permet de comparer ce que le projet annonce avec ce que les fichiers montrent réellement.

```text
Lis README.md.
Compare ce que le README annonce avec ce que tu as vu dans les fichiers.
Dis-moi :
1. ce que le projet prétend faire ;
2. quelles commandes sont documentées ;
3. si la documentation est cohérente avec les scripts du package.json ;
4. ce qui manque pour quelqu'un qui découvre le projet.
```

Claude ne doit pas seulement répéter le README, mais le confronter aux fichiers présents.

### Lire le code source

Une fois les scripts compris, demandez à Claude de lire les fichiers du dossier `src`. Dans ce projet, `src/conversion.js` contient la logique de conversion et d'arrondi. `src/main.js` relie cette logique à l'interface utilisateur.

```text
Lis les fichiers du dossier src sans les modifier.
Pour chaque fichier, explique :
1. son rôle ;
2. les fonctions ou éléments importants ;
3. les dépendances internes ;
4. les hypothèses visibles dans le code ;
5. les risques ou limites que tu vois déjà.
```

### Lire les tests

Les tests indiquent ce qui est déjà vérifié et ce qui ne l'est pas encore. Dans ce mini-projet, Claude devrait distinguer les conversions déjà testées, l'arrondi et les cas limites non couverts : entrée vide, valeur non numérique, valeurs décimales, nombres négatifs ou très grands nombres.

```text
Lis les tests dans le dossier test sans les modifier.
Explique :
1. quelles fonctions sont couvertes ;
2. quels cas sont vérifiés ;
3. quels cas limites ne sont pas encore testés ;
4. quelle commande permet de lancer ces tests ;
5. ce que ces tests ne prouvent pas.
```

### Identifier les fichiers critiques

Tous les fichiers n'ont pas le même niveau de risque. Demandez à Claude d'identifier les fichiers qui concentrent le plus de responsabilité. Dans le mini-projet, `src/conversion.js` est critique pour la logique métier, `src/main.js` pour l'interface, `test/conversion.test.js` pour la preuve, `package.json` pour les scripts et `server.js` pour le lancement local.

```text
À partir de ta lecture, identifie les fichiers critiques.
Pour chaque fichier critique, indique :
1. pourquoi il est important ;
2. ce qui pourrait casser si on le modifie mal ;
3. quelle vérification permettrait de sécuriser une modification.
```

### Construire une carte courte du dépôt

Après la lecture, demandez une carte courte, concrète et utile pour la suite.

```text
Fais maintenant une carte courte du dépôt.
Format attendu :
* rôle du projet ;
* pile technique ;
* fichiers principaux ;
* commande de test ;
* commande de lancement local ;
* logique métier centrale ;
* interface utilisateur ;
* tests existants ;
* risques visibles ;
* prochaine question utile à poser avant toute modification.
```

Si la carte contient une erreur, corrigez-la immédiatement. Une mauvaise hypothèse au début peut polluer toute la suite de la session.

## Poser des questions ciblées

Une bonne première session ne se limite pas à un résumé. Vous pouvez interroger Claude comme un développeur expérimenté qui vient de lire le dépôt.

### Vérifier ce qui existe vraiment

Si Claude s'est trompé dans sa carte du dépôt, corrigez-le immédiatement :

```text
Corrige ta carte du dépôt.
Tu as dit que le projet utilise un framework frontend, alors que ce n'est pas le cas.
Refais le résumé en te limitant aux fichiers réellement présents.
```

Vous pouvez aussi tester si Claude invente des éléments absents du projet :

```text
Y a-t-il une stratégie de logging dans ce projet ?
Réponds uniquement à partir du code présent.
S'il n'y en a pas, dis-le clairement.
Indique où un logging minimal pourrait être ajouté si besoin plus tard.
```

Dans ce projet, Claude devrait répondre qu'il n'y a pas de vraie stratégie de logging. Il peut mentionner le `console.log` dans `server.js`, mais il ne doit pas inventer une architecture de logs.

```text
Ce projet contient-il un flux d'authentification ?
Réponds à partir des fichiers présents.
S'il n'y en a pas, explique quels fichiers ou concepts seraient concernés si on voulait en ajouter un plus tard.
```

Dans ce mini-projet, Claude ne doit pas inventer de middleware, de session, de token ou d'utilisateur.

### Identifier les cas limites

Cette question prépare une future modification sans autoriser l'écriture.

```text
Quels cas limites vois-tu dans ce projet ?
Classe-les en trois catégories :
1. cas limites de conversion ;
2. cas limites d'arrondi ;
3. cas limites d'interface utilisateur.
Ne propose pas encore de correction.
Donne seulement l'analyse.
```

### Explorer une future API sans modifier

Cette question prépare une réflexion d'architecture sans déclencher de modification.

```text
Si je voulais ajouter plus tard un endpoint HTTP pour convertir une température, ne modifie rien.
Explique :
1. quel fichier serait probablement concerné ;
2. quelles fonctions existantes pourraient être réutilisées ;
3. quel test il faudrait ajouter ;
4. pourquoi ce changement dépasse le projet actuel.
```

## Distinguer faits, hypothèses et recommandations

Quand Claude lit un dépôt, il peut mélanger ce qu'il a vu, ce qu'il suppose et ce qu'il recommande. Demandez-lui de séparer ces niveaux.

Un fait peut être : `src/conversion.js` exporte une fonction de conversion. Une hypothèse peut être : le projet sert de démonstration. Une recommandation peut être : ajouter une gestion explicite des entrées invalides dans l'interface.

```text
Reprends ton analyse du projet en trois sections :
1. Faits vérifiés dans les fichiers.
2. Hypothèses raisonnables mais non prouvées.
3. Recommandations possibles pour plus tard.
Ne mets dans la première section que ce que tu as réellement lu.
```

## Limiter le périmètre si nécessaire

Si Claude explore trop loin, ramenez-le à un périmètre court.

```text
Réduis le périmètre.
Pour cette session, limite-toi à :
* package.json ;
* README.md ;
* src/conversion.js ;
* src/main.js ;
* test/conversion.test.js ;
* index.html ;
* server.js.
```

Plus le périmètre est clair, plus les prochaines demandes seront fiables.

## Terminer par une synthèse exploitable

À la fin de la lecture, demandez une synthèse courte. Elle servira de base pour formuler la première demande utile.

```text
Termine cette session de lecture par une synthèse courte.
Format attendu :
1. Ce que fait le projet.
2. Les fichiers les plus importants.
3. Les commandes disponibles.
4. Les tests existants.
5. Les zones non couvertes par les tests.
6. Les risques principaux.
7. Une première modification simple que tu recommandes.
8. La preuve à demander si cette modification est faite.
Ne parle pas de fonctionnalités futures sauf si je te le demande explicitement.
```

La dernière ligne est importante. Une proposition de modification sans preuve associée reste incomplète.

## Formuler les premières demandes utiles

Une fois le dépôt compris, vous pouvez commencer à formuler vos premières demandes. Le point essentiel est de distinguer deux usages : explorer et agir.

Une demande vague peut être utile pour explorer, demander un avis ou faire apparaître des pistes. Une demande précise devient nécessaire dès que vous voulez autoriser une modification.

### Comprendre la différence entre explorer et agir

**Demande vague utile** — reste en lecture seule, sert à explorer :

```text
Regarde le fichier src/main.js sans le modifier.
Que changerais-tu dans ce fichier si tu voulais l'améliorer ?
Ne fais aucune modification.
Donne seulement tes observations.
Classe-les par priorité.
```

Cette demande est ouverte, mais elle reste sûre parce qu'elle interdit explicitement toute modification.

**Demande vague dangereuse** — n'interdit rien, autorise l'écriture sans cadre :

```text
Améliore src/main.js.
```

Cette demande ne précise ni le problème, ni le périmètre, ni les contraintes, ni la preuve attendue. Dans un vrai dépôt, elle peut produire une modification trop large ou difficile à valider.

### Utiliser une demande vague pour choisir une piste

Une bonne demande exploratoire doit autoriser l'analyse, mais pas l'écriture.

```text
Analyse src/conversion.js sans le modifier.
Question volontairement ouverte :
que changerais-tu dans ce fichier si tu voulais améliorer sa robustesse ?
Réponds avec :
1. les points solides du fichier ;
2. les limites visibles ;
3. les cas limites non couverts ;
4. les changements possibles, classés du plus simple au plus complexe.
Ne modifie rien.
```

Si la réponse est trop longue, demandez à Claude de réduire :

```text
Réduis ta réponse.
Garde seulement les trois changements les plus utiles.
Pour chaque changement, indique :
* le fichier concerné ;
* le risque ;
* la vérification possible.
```

L'objectif n'est pas d'obtenir beaucoup d'idées, mais de choisir une prochaine action claire.

### Choisir une première tâche limitée

Pour une première modification, choisissez une tâche courte, lisible et vérifiable. Dans ce mini-projet, une bonne candidate consiste à mieux gérer une entrée vide ou invalide dans l'interface.

```text
Parmi les pistes que tu as proposées, choisis une piste.
Contraintes :
* elle doit toucher le moins de fichiers possible ;
* elle doit être compréhensible en lisant le diff ;
* elle doit avoir une vérification simple ;
* elle ne doit pas ajouter de dépendance ;
* elle doit préparer la prochaine leçon sur la première modification de code.
Ne modifie rien.
Propose seulement la tâche.
```

Cette demande garde la session dans une phase de décision. Claude peut aider à choisir, mais il n'a pas encore l'autorisation d'implémenter.

### Transformer une piste en demande précise

Une demande précise doit dire à Claude quoi modifier, où modifier, quoi préserver, comment vérifier et quand considérer le travail terminé.

### Préparer une correction sans l'appliquer

Voici une demande précise adaptée au mini-projet. Elle demande un plan, pas encore une modification.

Une bonne demande contient généralement :
1. Le fichier ou la zone ciblée.
2. Le problème à résoudre.
3. Les contraintes à respecter.
4. L'exemple existant à suivre.
5. La vérification attendue.
6. La définition de terminé.

```text
Prépare une modification limitée dans src/main.js.

Problème :
quand le champ de température est vide ou contient une valeur non numérique, l'interface affiche un résultat incorrect.

Objectif :
proposer une correction simple pour afficher un message d'erreur clair à l'utilisateur.

Contraintes :
* modifier uniquement src/main.js si possible ;
* ne pas ajouter de dépendance ;
* conserver la structure actuelle du mini-projet ;
* ne pas modifier src/conversion.js ;
* ne pas modifier le HTML sauf si tu expliques pourquoi c'est nécessaire ;
* garder un changement court et lisible.

Vérification préférée :
lancer npm test pour vérifier que la logique existante n'est pas cassée.
Prévoir aussi une vérification manuelle dans le navigateur.
```

Cette demande oblige Claude à raisonner avant d'écrire.

### Demander un plan court avant l'exécution

Avant une première modification réelle, demandez un plan court. Le plan permet de repérer une mauvaise interprétation avant que Claude n'écrive dans le dépôt.

```text
Pour l'instant, donne seulement ton plan de modification.
Donne-moi un plan en trois étapes maximum pour cette tâche.
Pour chaque étape, indique :
1. le fichier concerné ;
2. le changement prévu ;
3. la vérification associée.
Ne modifie aucun fichier tant que je n'ai pas validé le plan.
```

Si le plan est trop large, recadrez-le :

```text
Le plan est trop large.
Réduis-le à une seule modification dans src/main.js.
Ne modifie pas index.html.
Ne touche pas à src/conversion.js.
Garde npm test comme vérification minimale.
```

### Produire une demande finale prête à exécuter

Vous pouvez valider le plan sans autoriser encore l'écriture. Demandez ensuite à Claude de réécrire la consigne finale pour la prochaine leçon.

```text
Le plan est correct.
Ne modifie toujours aucun fichier.
Réécris maintenant la demande finale que je devrai utiliser.
La demande finale doit inclure :
* le fichier ciblé ;
* les contraintes ;
* la vérification ;
* le résumé attendu à la fin.
```

Une demande finale exploitable peut ressembler à ceci :

```text
Implémente la correction limitée dans src/main.js.

Problème :
si le champ de température est vide ou invalide, afficher un message d'erreur clair.

Contraintes :
* modifie uniquement src/main.js ;
* ne modifie pas src/conversion.js ;
* ne modifie pas index.html ;
* n'ajoute aucune dépendance ;
* garde le changement le plus petit possible ;
* conserve le style actuel du code.

Vérification :
* lance npm test ;
* indique comment vérifier manuellement le comportement dans le navigateur.

Définition de terminé :
* le message d'erreur est clair pour une entrée vide ou invalide ;
* les tests existants passent ;
* tu fournis le résumé du diff ;
* tu indiques exactement ce qui a été vérifié ;
* tu indiques ce qui n'a pas été vérifié.
```

Cette demande est prête pour une première modification réelle. Elle est limitée, vérifiable et réversible.

### Comparer trois niveaux de demande

**Niveau 1 : trop vague** — cette demande ne donne presque aucun cadre. Elle peut servir à explorer, mais pas à autoriser une modification.

```text
Améliore le convertisseur.
```

**Niveau 2 : mieux, mais incomplet** — le problème est indiqué, mais il manque encore le fichier, les contraintes, la vérification et la définition de terminé.

```text
Corrige le comportement quand le champ de température est vide.
```

**Niveau 3 : exploitable**

```text
Corrige le comportement du champ de température vide.

Contraintes :
* modifie uniquement src/main.js ;
* n'ajoute pas de dépendance ;
* ne modifie pas la logique métier dans src/conversion.js ;
* garde le changement court.

Vérification :
* lance npm test ;
* explique comment vérifier manuellement avec npm run dev.

Définition de terminé :
* le message affiché est clair ;
* les tests existants passent ;
* le diff est résumé ;
* les limites restantes sont indiquées.
```

Cette troisième version est celle à viser. Elle laisse Claude agir, mais dans un cadre clair.

## Utiliser /btw pour les questions rapides

`/btw` permet de poser une question courte à partir du contexte déjà présent dans la session. Elle est utile pour demander une précision sans changer la tâche principale.

```text
/btw Quel fichier contient actuellement la logique de conversion ?
/btw Quelle commande dois-je lancer pour vérifier les tests ?
/btw Est-ce que tu as vu une dépendance externe dans ce projet ?
/btw Est-ce que la correction prévue touche la logique métier ?
```

Ces questions sont courtes et latérales. Elles ne changent pas l'objectif principal.

### Ne pas utiliser /btw pour changer la tâche

```text
/btw Finalement, modifie aussi src/conversion.js.
```

Cette instruction change le périmètre. Elle doit être écrite dans la conversation principale, avec des contraintes et une vérification :

```text
Je veux changer le périmètre de la tâche.
Nouvelle contrainte :
tu peux aussi modifier src/conversion.js si c'est nécessaire.
Avant de modifier quoi que ce soit, explique :
1. pourquoi src/main.js ne suffit pas ;
2. quelle modification serait nécessaire dans src/conversion.js ;
3. quel test permettrait de vérifier ce changement.
```

## Forcer la définition de terminé

La définition de terminé est indispensable. Sans elle, Claude peut considérer que le travail est fini après avoir écrit du code. Ce n'est pas suffisant.

```text
Pour cette tâche, terminé signifie :
1. le changement est limité au fichier autorisé ;
2. le comportement attendu est visible dans le code ;
3. npm test a été lancé ;
4. la vérification manuelle est décrite ;
5. le diff est résumé ;
6. les limites restantes sont indiquées.
```

Cette définition transforme une demande de code en demande vérifiable.

## Demander une preuve avant de faire confiance

Une preuve peut être une sortie de test, une commande exécutée, un comportement observé dans le navigateur, un diff lisible ou une explication des limites.

```text
Quand tu réaliseras cette tâche, ne conclus pas seulement par un résumé.
Termine avec :
1. la commande exacte exécutée ;
2. le résultat de cette commande ;
3. les fichiers modifiés ;
4. le comportement vérifié ;
5. ce qui n'a pas été vérifié.
```

Vous ne voulez pas seulement que Claude soit confiant. Vous voulez savoir ce qu'il a réellement vérifié.

## Garder une session propre

Une session propre suit un fil simple : lecture, analyse, plan, demande précise, vérification. Si vous mélangez trop de sujets, Claude peut perdre la priorité réelle.

```text
Pour cette session, garde un seul sujet :
la gestion d'une entrée vide ou invalide dans l'interface.
Ne propose pas encore :
* de CSS ;
* de nouvelle API ;
* de refonte HTML ;
* de changement de src/conversion.js ;
* de nouvelle fonctionnalité Fahrenheit vers Celsius.
```

Ce cadrage réduit le bruit. Une bonne première modification doit être assez petite pour être comprise, vérifiée et annulée facilement.
