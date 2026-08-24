# Nettoyer, compacter ou repartir sur une nouvelle tâche

Dans cette leçon, vous allez décider quoi faire quand une session Claude Code devient longue, bruyante ou moins fiable. Vous avez vu dans la leçon précédente que la fenêtre de contexte se remplit progressivement avec vos messages, les réponses de Claude, les fichiers lus, les sorties de commandes, les résultats d’outils et les instructions persistantes. Cette fenêtre est une ressource critique. Il faut donc apprendre à la surveiller, à la nettoyer et à la compacter.

Le problème à éviter s’appelle souvent pollution du contexte (`context rot`). Plus une session accumule d’informations anciennes, contradictoires, inutiles ou liées à d’autres tâches, plus Claude risque de se dégrader : il peut revenir à une piste abandonnée, oublier une contrainte récente, mélanger deux objectifs ou proposer une modification hors périmètre.

Le bon réflexe est simple : ne laissez pas une session devenir une pièce fourre-tout. Si la tâche change réellement, repartez sur un contexte propre. Si la tâche continue mais que l’historique devient lourd, compactez avec des instructions précises.

## Les commandes utilisées dans cette leçon

### Surveiller le contexte
`/context` montre l’utilisation actuelle de la fenêtre de contexte. Si vous avez configuré une `statusline` au chapitre précédent, elle peut aussi afficher le pourcentage de contexte en continu. La `statusline` sert de signal permanent ; `/context` sert au diagnostic détaillé.

`/recap` produit un résumé d’une ligne de la session courante. Il est utile pour vérifier rapidement si la session a encore une direction claire. Ce résumé apparaît aussi automatiquement lorsque vous revenez au terminal après une pause — la fonctionnalité est active par défaut — et `/recap` permet en plus de le générer à la demande.

### Repartir sur une nouvelle tâche
`/clear` démarre une nouvelle conversation avec un contexte vide. La conversation précédente reste disponible dans `/resume`. `/reset` et `/new` sont ses alias.

### Compacter la session
`/compact` libère du contexte en résumant la conversation actuelle. Contrairement à `/clear`, il ne démarre pas une nouvelle tâche. Il sert à continuer le même travail avec un historique synthétisé.

### Poser une question rapide hors historique
`/btw` permet de poser une question rapide sans l’ajouter à l’historique principal. C’est utile pour vérifier un détail sans gonfler le contexte.

## Plan de décision

### Étape 1 : regarder l’état du contexte
Avant de nettoyer ou de compacter, commencez par observer. Lancez :
```bash
/context
```
Si la session reste courte et claire, ne faites rien. Une session n’a pas besoin d’être nettoyée simplement parce qu’elle existe depuis plusieurs tours. Le contexte est utile tant qu’il reste lié à la tâche actuelle.

Vous pouvez aussi demander :
```bash
/recap
```
Si le récapitulatif ne correspond plus à ce que vous voulez faire maintenant, c’est un signal fort : la session a probablement changé de direction.

### Étape 2 : décider si la tâche continue
La question principale n’est pas “le contexte est-il long ?”. La vraie question est : “l’historique aide-t-il encore la tâche actuelle ?”.

```text
Si l’historique aide encore :
utilisez plutôt /compact.

Si l’historique n’aide plus :
utilisez plutôt /clear.

Si l’historique contient trop d’erreurs :
utilisez plutôt /clear avec un meilleur brief.

Si la tâche est sensible :
gardez un contexte bas et explicite.
```
Une tâche liée peut réutiliser le contexte. Par exemple, si vous venez de lire `src/main.js` et que vous continuez à corriger le comportement d’une saisie invalide, l’historique est utile. En revanche, si vous passez d’une correction frontend à une documentation, puis à une réflexion d’architecture, puis à une préparation de pull request, la session devient trop mélangée.

### Étape 3 : choisir l’action
```bash
/clear
# Nouvelle tâche réelle.

/compact
# Même tâche, contexte trop lourd.

/btw
# Question rapide qui ne doit pas rester dans l’historique.

/recap
# Vérification courte de la direction de la session.
```

## Utiliser /clear entre tâches non liées

### La règle : nouvelle tâche réelle, nouvelle session
`/clear` est la commande à utiliser quand vous changez de tâche. Elle évite que l’ancienne conversation influence la nouvelle. C’est l’un des meilleurs moyens de réduire le `context rot`.

Vous pouvez aussi nommer la conversation précédente au moment du nettoyage :
```bash
/clear lecture-initiale-convertisseur
```
Le nom permet de retrouver plus facilement l’ancienne session avec `/resume`.

### Quand utiliser /clear
Utilisez `/clear` quand :
- vous changez réellement de tâche ;
- vous passez du debug à la documentation ;
- vous passez d’une exploration à une implémentation complète ;
- Claude a suivi plusieurs mauvaises pistes ;
- vous avez corrigé deux fois le même problème ;
- la session mélange trop de sujets ;
- vous voulez repartir avec un brief plus propre.

Après deux corrections sur le même problème, ne continuez pas à empiler les rectifications. La session contient déjà des approches échouées. Utilisez `/clear`, puis rédigez une nouvelle demande qui intègre ce que vous avez appris.

### Exemple de nouveau départ contrôlé
```bash
/clear correction-saisie-invalide
```
Puis:
```text
Nous repartons sur une session propre.
Contexte :
le projet convertisseur-temperature contient une interface HTML.
La logique de conversion est dans src/conversion.js.
Les tests existants sont dans test/conversion.test.js.
Objectif :
analyser uniquement la gestion des saisies vides ou invalides.
Contraintes :
- ne modifie aucun fichier ;
- lis seulement src/main.js, index.html et src/conversion.js ;
- résume le comportement actuel ;
- propose une correction limitée ;
- indique quelle preuve demander avant validation.
```
Ce brief écrit donne plus de contrôle qu’une compaction automatique. Vous choisissez exactement ce que la nouvelle session reçoit.

## Utiliser /compact quand la tâche continue

### Compacter sans changer d’objectif
`/compact` est utile quand la tâche reste la même, mais que le contexte commence à peser. La commande résume l’historique et libère de la place. Elle garde une continuité, mais elle transforme des détails bruts en synthèse.

Cette opération est pratique, mais elle n’est pas neutre. Une compaction est une synthèse avec perte. Certains détails peuvent disparaître, être simplifiés ou perdre leur ordre exact.

### Compacter avec une instruction précise
Il vaut mieux ne pas compacter sans consigne quand la tâche est importante. Donnez à Claude ce qu’il doit préserver.
```bash
/compact Garde les fichiers lus, les fichiers modifiés, et l'objectif en cours
```
Pour une correction de code, la compaction doit garder au minimum :
```text
À préserver :
- objectif actuel ;
- fichiers concernés ;
- fichiers modifiés ;
- contraintes ;
- décisions prises ;
- tests exécutés ;
- résultats de tests ;
- erreurs restantes ;
- points non vérifiés ;
- prochaine action.
```
À l’inverse, il faut explicitement ignorer ce qui pollue :
```text
À ignorer :
- pistes abandonnées ;
- hypothèses réfutées ;
- anciennes commandes inutiles ;
- sorties trop longues déjà résumées ;
- discussions latérales ;
- explications qui ne servent plus à la tâche.
```
Une précision utile : le `CLAUDE.md`, la mémoire automatique et les noms d’outils MCP sont rechargés automatiquement après une compaction. Inutile donc de demander à Claude de les conserver : votre instruction ne porte que sur le contenu de la conversation. La seule exception est la liste des descriptions de `skills`, qui n’est pas réinjectée ; seules les skills réellement invoquées pendant la session restent disponibles.

## Ne pas attendre l’auto-compaction sans indication

### La compaction automatique arrive parfois trop tard
Claude Code peut compacter automatiquement quand la session approche des limites de contexte. Cette compaction peut préserver les éléments importants, mais elle arrive parfois après que la session est déjà devenue confuse.

Si vous sentez que la session se dégrade, n’attendez pas. Utilisez `/compact` avec une instruction précise, ou utilisez `/clear` avec un brief écrit.
```text
Si la tâche continue :
/compact Garde seulement le plan actuel, les fichiers modifiés et l'erreur

Si la tâche devient critique :
/clear
# Puis nouveau brief écrit.
```
Pour une étape critique, `/clear` avec un brief écrit est souvent plus fiable que `/compact`. Vous contrôlez entièrement ce qui entre dans la nouvelle session.

## Ajouter des consignes de compaction dans CLAUDE.md

### Préserver les informations critiques
Si un projet utilise souvent des sessions longues, vous pouvez ajouter une instruction de compaction dans `CLAUDE.md`. Elle doit rester courte.
```markdown
## Compaction
Lors d’une compaction, préserver toujours :
- la liste des fichiers lus ;
- la liste des fichiers modifiés ;
- les décisions techniques prises ;
- les tests exécutés et leurs résultats ;
- les erreurs restantes ;
- les points non vérifiés ;
- la prochaine étape recommandée.

Supprimer ou réduire :
- les pistes abandonnées ;
- les logs déjà résumés ;
- les explications qui ne sont plus utiles ;
- les discussions latérales.
```
Cette règle aide Claude à produire des résumés plus utiles. Elle ne remplace pas votre jugement. Si la session est déjà très mauvaise, repartez plutôt avec `/clear`.

## Utiliser /btw pour ne pas gonfler l’historique

### Question rapide, pas nouvelle tâche
`/btw` est utile pour les questions latérales. La réponse n’entre pas dans l’historique principal. Cela évite d’ajouter du bruit dans la session.
```bash
/btw Quelle commande de test a été exécutée ?
/btw Quel fichier contient la logique de conversion ?
/btw Est-ce que cette session a déjà lu src/main.js ?
```
Ne l’utilisez pas pour changer la tâche. Si vous voulez modifier les contraintes, autoriser une action ou changer le périmètre, écrivez une instruction normale.
```text
Mauvais usage :
/btw Finalement modifie aussi src/conversion.js.

Bon usage :
Je change le périmètre. Avant toute modification, explique pourquoi src/conversion.js doit être modifié.
```

## Repères pratiques de contexte

### Heuristiques, pas règles officielles
Voici des repères communautaires utiles, mais ils ne doivent pas être présentés comme des règles officielles. Ils servent à développer votre intuition.
```text
Contexte bas :
préférable pour les tâches sensibles.

Autour de 40 % :
commencez à surveiller plus attentivement.

Autour de 60 % :
envisagez /compact ou /clear.

Tâche difficile ou critique :
soyez plus agressif avec le nettoyage.
```
Ces seuils ne sont pas mécaniques. Une session à 30 % peut être mauvaise si elle contient des erreurs contradictoires. Une session à 55 % peut être très bonne si tout le contexte concerne la même tâche. Le critère principal reste la pertinence, pas seulement le pourcentage.

## Traiter les échecs répétés

### Après deux corrections, repartir
Si Claude échoue deux fois sur le même problème, ne continuez pas à corriger indéfiniment dans la même session. Les tentatives ratées deviennent elles-mêmes du contexte. Elles peuvent renforcer de mauvaises pistes.
```text
Règle pratique :
1. première erreur : corriger clairement ;
2. deuxième erreur : corriger une dernière fois ;
3. troisième tentative nécessaire : /clear et nouveau prompt.
```
Le nouveau prompt doit intégrer ce que vous avez appris.

### Exemple complet de séquence
```bash
/clear correction-saisie-invalide-v2
```
Puis :
```text
Nous repartons avec une meilleure demande.
À ne pas refaire :
- ne pas modifier src/conversion.js ;
- ne pas ajouter de dépendance ;
- ne pas changer index.html ;
- ne pas traiter une saisie vide comme zéro.
Objectif :
analyser uniquement src/main.js et proposer une correction pour les entrées non numériques.
Preuve attendue :
- npm test ;
- vérification manuelle avec champ vide ;
- vérification manuelle avec valeur 20.
```

## Observer, décider, agir
```bash
cd convertisseur-temperature
git status
claude

/context
/recap
```
Si la session continue dans la même direction :
```bash
/compact Garde l’objectif actuel, les fichiers lus, les erreurs restantes.
```
Si la tâche change :
```bash
/clear nouvelle-tache-documentation
```
Puis brief écrit :
```text
Nouvelle tâche :
préparer une explication courte du projet.
Contraintes :
- ne modifie aucun fichier ;
- lis seulement README.md et package.json ;
- réponds en moins de dix lignes.
```
