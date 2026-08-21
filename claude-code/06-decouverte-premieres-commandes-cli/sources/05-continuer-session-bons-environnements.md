# Continuer la session dans les bons environnements

Dans cette leçon, vous allez apprendre à continuer une session Claude Code dans différents environnements : le terminal, l’éditeur, l’application Desktop, le navigateur, le mobile et le contrôle distant. Jusqu’ici, vous avez travaillé dans le CLI sur le mini-projet `convertisseur-temperature`. Vous avez préparé le dépôt, demandé une lecture seule, formulé une demande précise, puis réalisé une première modification contrôlée.

Cette leçon ne cherche pas à ajouter une nouvelle fonctionnalité au projet. Elle sert à comprendre où continuer le travail selon le contexte. Une session Claude Code peut rester dans le terminal, se rapprocher de l’éditeur, être reprise dans l’application Desktop, être rendue accessible à distance ou être pilotée depuis un autre appareil. Le bon choix dépend de ce que vous voulez faire : lire un diff, inspecter des fichiers, vérifier une interface, suivre une tâche longue ou simplement fermer proprement la session.

## Les commandes de cette leçon

Cette leçon utilise les commandes suivantes : `/ide`, `/desktop`, `/app`, `/mobile`, `/ios`, `/android`, `/remote-control`, `/rc`, `/remote-env`, `/exit` et `/quit`.

- `/ide` sert à gérer les intégrations avec l’éditeur et à vérifier leur état.
- `/desktop` permet de continuer la session dans l’application Claude Code Desktop, lorsque la plateforme et le compte le permettent. `/app` est l’alias de `/desktop`.
- `/mobile` affiche un QR code pour installer ou ouvrir l’application mobile. `/ios` et `/android` sont ses alias.
- `/remote-control` rend la session locale accessible depuis claude.ai/code ou depuis l’application mobile. `/rc` est son alias.
- `/remote-env` permet de choisir l’environnement par défaut pour les agents cloud.
- `/exit` quitte le CLI. `/quit` est son alias. Ces deux commandes servent à fermer proprement une session interactive. Elles ne doivent pas être confondues avec `/logout`, qui déconnecte le compte et sera traité dans la leçon suivante.

## Repartir du mini-projet

Revenez dans le dossier du projet.

```bash
cd convertisseur-temperature
```

Vérifiez l’état du dépôt.

```bash
git status
```

Si vous avez conservé la modification de la leçon précédente, le dépôt peut être propre si vous avez fait un commit, ou contenir encore le changement dans `src/main.js`. Les deux situations sont acceptables, à condition de savoir dans quel état vous êtes.

Pour cette leçon, l’état idéal est le suivant : les tests passent, le diff est connu, et vous savez ce qui a changé dans le projet.

Si `git diff` ne montre rien, cela signifie que le changement a probablement été commit ou annulé. Si `git diff` montre `src/main.js`, relisez rapidement le diff avant d’ouvrir Claude Code.

## Ouvrir la session dans le terminal

Lancez Claude Code depuis la racine du projet.

```bash
claude
```

Le terminal reste la surface la plus directe. Il est adapté aux tâches courtes, aux vérifications, aux commandes, aux tests et aux échanges rapides. Si vous travaillez déjà dans le répertoire du projet, le CLI donne à Claude le contexte local nécessaire : fichiers, scripts, état Git et commandes disponibles.

Commencez par faire rappeler l’état de la session.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple de demande pour rappeler l’état de la session :**

*« Nous allons uniquement vérifier les surfaces de travail.*
*Ne modifie aucun fichier.*

*Rappelle en quelques lignes :*
*1. le projet ouvert ;*
*2. l’état Git visible ;*
*3. la dernière modification connue ;*
*4. les commandes de vérification disponibles. »*

</div>

Cette demande garde la session dans un mode sûr. Vous n’êtes pas en train de demander une nouvelle correction. Vous vérifiez seulement que Claude voit le bon projet et comprend l’état actuel.

## Utiliser /ide pour rapprocher Claude de l’éditeur

La commande `/ide` sert à gérer les intégrations avec l’éditeur et à vérifier leur état.

```bash
/ide
```

L’éditeur est utile quand vous voulez lire les fichiers, parcourir le diff, inspecter plusieurs zones du projet ou garder le code visible pendant la conversation. Le terminal est efficace pour commander. L’éditeur est plus confortable pour vérifier.

Dans le mini-projet, l’usage est simple : ouvrez `src/main.js`, `src/conversion.js`, `test/conversion.test.js` et `index.html`. Ces fichiers donnent une vue complète du changement réalisé précédemment.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande avec l’IDE ouvert :**

*« Avec le contexte de l’IDE, aide-moi à relire les fichiers ouverts.*
*Ne modifie rien.*

*Regarde surtout :*
*- src/main.js ;*
*- src/conversion.js ;*
*- test/conversion.test.js ;*
*- index.html.*

*Dis-moi si le changement dans src/main.js reste cohérent avec l'ensemble. »*

</div>

Cette demande utilise l’éditeur comme surface de revue. Elle ne demande pas de nouvelle implémentation. Elle sert à vérifier que le changement local s’intègre bien dans le projet.

## Quand rester dans le terminal

Restez dans le terminal quand la tâche est principalement textuelle ou commandée par des scripts. Par exemple, pour lancer les tests, lire l’état Git, demander un résumé, vérifier un diff court ou corriger une petite erreur, le CLI suffit largement.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple de revue compacte en terminal :**

*« Reste dans le contexte terminal.*
*Ne modifie aucun fichier.*

*Dis-moi seulement quelles commandes je dois lancer pour relancer les tests et voir l'état Git.*

*Relis src/main.js comme une revue de code courte.*
*Ne propose pas de refactorisation.*

*Réponds seulement à ces questions :*
*1. le changement est-il limité ?*
*2. le comportement est-il clair ?*
*3. y a-t-il une incohérence avec index.html ?*
*4. faut-il absolument modifier un autre fichier ? »*

</div>

Dans le mini-projet, la réponse doit rester courte. Le terminal est la bonne surface quand vous voulez de la vitesse, de la précision et peu de distraction. Il est moins confortable quand vous devez comparer beaucoup de fichiers visuellement ou suivre une interface graphique. Cette question force une revue compacte. Elle évite de transformer une vérification en nouvelle session d’amélioration générale.

## Continuer dans l’application Desktop avec /desktop

La commande `/desktop` permet de continuer la session dans l’application Claude Code Desktop, lorsque cette commande est disponible dans votre environnement. Vous pouvez aussi utiliser son alias `/app`.

```bash
/desktop
```

Ou :

```bash
/app
```

L’application Desktop est utile quand vous voulez une surface plus visuelle que le terminal. Elle peut être plus confortable pour suivre une conversation longue, organiser plusieurs panneaux, relire un diff, regarder un aperçu, ou continuer une session sans rester uniquement dans l’interface texte du CLI.

Dans le contexte du mini-projet, `/desktop` peut servir après la première modification. Vous avez déjà un changement simple, une preuve et une vérification. Vous pouvez continuer dans l’application pour relire la session ou préparer une nouvelle demande.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande avant de changer de surface :**

*« Avant de continuer dans Desktop, prépare un résumé de reprise.*

*Format :*
*1. projet ouvert ;*
*2. modification précédente ;*
*3. fichier modifié ;*
*4. vérifications faites ;*
*5. prochaine action raisonnable ;*
*6. limite à ne pas dépasser. »*

</div>

Ensuite, lancez la commande `/desktop`.

Ce résumé de reprise est important. Changer de surface ne doit pas créer de confusion. Vous devez savoir ce qui a été fait, ce qui a été vérifié et ce qui reste hors périmètre.

## Préparer l’application mobile avec /mobile

La commande `/mobile` affiche un QR code pour télécharger ou ouvrir l’application mobile. 

Les alias sont :

```bash
/ios
/android
```

La commande `/mobile` ne sert pas à modifier le code. Elle sert à préparer l’accès depuis un téléphone. Elle est utile si vous voulez surveiller une session, recevoir une notification, ou reprendre une discussion sans rester devant le terminal.

Pour le mini-projet, l’usage reste très simple. Vous pouvez préparer le mobile après avoir lancé une tâche de vérification ou avant d’activer le contrôle distant.

Une fois l’application mobile installée ou ouverte, vous pouvez utiliser le même compte que celui utilisé dans le CLI. Le point important est la continuité : vous ne changez pas de projet mentalement. Vous continuez la même session ou vous préparez l’accès à une session contrôlée à distance.

## Activer le contrôle distant avec /remote-control

`/remote-control` rend une session locale accessible depuis un navigateur ou depuis l’application mobile. C’est différent d’une session cloud : la session continue de tourner sur votre machine. Le navigateur ou le téléphone sert de fenêtre de pilotage.

Vous pouvez utiliser l’alias :

```bash
/rc
```

Vous pouvez aussi donner un nom à la session pour la retrouver plus facilement :

```bash
/remote-control Convertisseur température
```

Après l’activation, Claude Code affiche généralement une URL ou un QR code selon l’environnement. Vous pouvez ouvrir cette session depuis un autre appareil, depuis claude.ai/code ou depuis l’application mobile.

Ce mode est utile si vous avez lancé une tâche locale et que vous voulez la suivre ailleurs. Par exemple, vous pouvez demander à Claude de lancer une vérification, puis surveiller la fin depuis votre téléphone.

Cette tâche est volontairement simple. Pour une première utilisation du remote, il ne faut pas lancer une migration complexe ou une modification sensible. Commencez par une vérification sans risque.

## Comprendre ce que le contrôle distant change

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Tester le contrôle distant sur une tâche simple :**

*« Nous allons tester le contrôle distant sur une tâche simple.*
*Ne modifie aucun fichier.*

*Lance npm test.*

*Quand la commande est terminée, résume le résultat en 3 lignes.*
*Si le contrôle distant est actif, indique que je peux vérifier la réponse sur mon téléphone. »*

</div>

Le contrôle distant change la surface de pilotage, pas nécessairement l’environnement d’exécution. La session locale continue d’utiliser votre machine, votre dépôt, vos fichiers, vos outils et votre configuration. Cela signifie que les commandes sont exécutées dans le contexte local.

Cette distinction est importante. Si vous avez besoin de votre dépôt local, de vos fichiers non commités, de votre serveur local ou d’une configuration spécifique à votre machine, le contrôle distant est plus adapté qu’une session cloud séparée.

Dans le mini-projet, cela signifie que Claude voit toujours le dossier `convertisseur-temperature` ouvert dans votre terminal. Si vous fermez le terminal ou arrêtez le processus local, la session distante ne peut plus piloter ce contexte.

## Utiliser /remote-control pour surveiller une tâche longue

Le mini-projet est petit, donc les commandes sont rapides. Dans un vrai dépôt, les tests, le build ou une vérification frontend peuvent prendre plus de temps. Le contrôle distant devient alors plus utile.

Vous pouvez simuler le bon réflexe avec une tâche courte :

```bash
/rc Convertisseur température - vérification
```

Puis demandez une vérification simple :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Lancer une tâche avant de changer de terminal :**

*« Lance une vérification complète du mini-projet.*
*Ne modifie aucun fichier.*

*Étapes :*
*1. lance npm test ;*
*2. vérifie l’état Git ;*
*3. rappelle comment tester manuellement l’interface.*

*Termine par :*
*- résultat des tests ;*
*- état Git ;*
*- prochaine décision recommandée. »*

</div>

Vous pouvez ensuite ouvrir la session depuis un autre appareil et lire le résultat. Le point important est la discipline : même à distance, vous ne validez pas sans preuve. Le fait de piloter depuis un mobile ne doit pas réduire le niveau de vérification.

## Utiliser /remote-env pour les agents cloud

La commande `/remote-env` permet de choisir l’environnement par défaut pour les agents cloud.

```bash
/remote-env
```

Cette commande ne sert pas au même besoin que `/remote-control`. `/remote-control` rend une session locale accessible depuis un autre appareil. `/remote-env` concerne le choix de l’environnement utilisé par des agents cloud.

Cette distinction doit être claire dès maintenant. Les noms se ressemblent, mais les usages sont différents.

Dans le mini-projet, `/remote-env` n’est pas indispensable. Le dépôt est local, court et facile à tester. Mais la commande devient importante quand vous utilisez des agents cloud, des environnements distants ou des tâches exécutées hors de votre machine.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande d'explication des rôles :**

*« Compare /remote-control et /remote-env pour ce projet.*

*Réponds sous forme de tableau texte :*
*- commande ;*
*- rôle ;*
*- où le code s’exécute ;*
*- quand l’utiliser ;*
*- risque principal à vérifier. »*

</div>

La bonne réponse doit rester concrète. Avec `/remote-control`, la session garde le dépôt local et les éventuels fichiers non commités. Avec une session cloud, le travail dépend d’un environnement distant, souvent relié à un dépôt GitHub et à une configuration séparée.

## Choisir la bonne surface selon la situation

Il faut maintenant construire un réflexe de choix. Chaque surface a un rôle. Le terminal est direct. L’IDE est bon pour lire le code. Desktop est bon pour une session plus visuelle. Mobile est bon pour suivre ou reprendre. Remote Control est bon pour piloter une session locale depuis ailleurs. Remote Env concerne les agents cloud.

Ce type de question est utile parce qu’il force à penser en termes de workflow, pas seulement en termes de commandes :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Quiz sur le choix des surfaces :**

*« Pour les situations suivantes, indique quelle surface utiliser :*

*1. Je veux relire src/main.js ligne par ligne.*
*2. Je veux lancer npm test rapidement.*
*3. Je veux suivre une vérification depuis mon téléphone.*
*4. Je veux continuer la session dans une interface plus large.*
*5. Je veux choisir l’environnement utilisé par les agents cloud.*
*6. Je veux fermer le CLI proprement. »*

</div>

Une réponse attendue peut ressembler à ceci :

1. IDE.
2. Terminal CLI.
3. `/remote-control` avec mobile.
4. `/desktop` ou `/app`.
5. `/remote-env`.
6. `/exit` ou `/quit`.
Ce type de question est utile parce qu’il force à penser en termes de workflow, pas seulement en termes de commandes.