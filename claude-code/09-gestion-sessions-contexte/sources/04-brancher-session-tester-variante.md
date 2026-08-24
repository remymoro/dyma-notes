# Brancher une session, tester une variante

Brancher une session consiste à créer une copie de la conversation jusqu’au point courant, puis à continuer dans cette copie, pendant que la session d’origine reste intacte. Dans Claude Code, cette opération sert à tester une direction différente sans perdre le chemin de travail déjà construit.

Une branche de session est une bifurcation conversationnelle. Elle copie l’historique utile de la session, crée un nouvel identifiant de session, puis vous place dans cette nouvelle trajectoire. À partir de ce moment, les messages ajoutés dans la branche n’affectent plus la transcription de la session d’origine.

Cette mécanique est utile quand une tâche atteint un point de décision : plusieurs corrections semblent possibles, une refactorisation peut être abordée de plusieurs manières, une hypothèse paraît plausible mais risquée, ou une stratégie mérite d’être testée sans dégrader la conversation principale.

Il faut cependant poser une limite dès le départ : brancher une session ne branche pas automatiquement le système de fichiers. La conversation est copiée ; les fichiers du projet, eux, restent ceux du worktree courant, sauf si vous utilisez explicitement un worktree Git, un checkpoint ou un mécanisme de restauration. Cette distinction est centrale pour éviter de confondre sécurité conversationnelle et isolation des fichiers.

## Ce que fait exactement `/branch`

### Copier la conversation, puis basculer dans la copie
La commande centrale est `/branch`. Elle peut être appelée sans nom ou avec un nom explicite.
```bash
/branch tentative-correction-minimale
```
Après cette commande, Claude Code crée une nouvelle session qui reprend l’historique de la session courante jusqu’à ce point. Vous êtes immédiatement placé dans cette nouvelle branche. La session originale reste disponible dans le sélecteur de sessions.

Le branchement n’est donc pas une simple annotation. Il crée une nouvelle trajectoire de session. La branche possède son propre identifiant, son propre historique à partir du point de bifurcation et ses propres messages ultérieurs.

### La session originale reste inchangée
La session d’origine ne reçoit pas les messages produits dans la branche. Si la branche mène à une impasse, vous pouvez revenir à l’original avec `/resume` ou avec le sélecteur de sessions.
```bash
/resume
```
Dans le sélecteur, les sessions créées avec `/branch`, avec un fork de session en ligne de commande ou avec certaines opérations de rembobinage sont regroupées sous leur session racine. La flèche droite développe le groupe, la flèche gauche le réduit, et `Espace` permet de prévisualiser une session avant de la reprendre.

Le gain principal est la réversibilité conversationnelle. Vous pouvez explorer une variante sans polluer le chemin initial avec des hypothèses, des essais et des corrections qui ne seront peut-être pas retenus.

### Pourquoi nommer la branche
Nommer la branche n’est pas un détail cosmétique. Une session branchée sans nom clair devient rapidement difficile à retrouver. Le nom doit indiquer l’hypothèse ou la stratégie testée, pas seulement la zone du code.
```bash
/branch auth-correction-minimale
/branch auth-refactor-service
/branch auth-ajout-test-seul
```
`auth-correction-minimale` indique une correction limitée. `auth-refactor-service` indique une restructuration plus large. `auth-ajout-test-seul` indique une branche orientée reproduction ou vérification.

Une bonne branche de session doit porter le nom de l’hypothèse qu’elle teste. Un nom comme `auth-test` est trop vague ; un nom comme `auth-normalisation-token` est plus utile, parce qu’il indique la piste exacte explorée.

## Ce que `/branch` ne fait pas

### Ce n’est pas un `/clear`
`/clear` démarre une nouvelle conversation avec un contexte vide, tout en laissant la conversation précédente disponible dans `/resume`. `/branch`, au contraire, conserve l’historique jusqu’au point courant et crée une nouvelle trajectoire à partir de cet historique.
```bash
/clear nouvelle-tache
/branch variante-sur-la-tache-actuelle
```
La première commande sert à repartir proprement sur une autre tâche. La seconde sert à explorer une variante dans le cadre de la même tâche.

### Ce n’est pas une compaction
`/compact` réduit le contexte de la session courante en remplaçant l’historique par un résumé. Il reste dans la même trajectoire. `/branch` ne compresse pas la conversation ; il crée une autre trajectoire.
```bash
/compact se concentrer sur le flux d'authentification
/branch approche-sans-refactorisation
```
La compaction sert à libérer de l’espace de contexte. Le branchement sert à tester une direction concurrente.

### Ce n’est pas une branche Git
Une branche de session n’est pas une branche Git. Elle ne crée pas automatiquement une nouvelle branche de dépôt. Elle ne duplique pas l’arborescence de fichiers. Elle ne protège pas les fichiers contre les modifications produites dans la branche de session.

Si vous voulez tester deux variantes de code qui modifient les mêmes fichiers, une simple branche de session peut être insuffisante. Il faut alors utiliser un worktree Git, un checkpoint ou une discipline stricte avec `git status`, `/diff` et `/rewind`.

La branche de session isole la conversation ; le worktree isole les fichiers.

## Quand brancher une session

### Après une phase d’analyse
Le moment le plus propre pour brancher est souvent après l’analyse, mais avant les modifications. À ce stade, la session contient le contexte utile : fichiers lus, hypothèses, contraintes, commandes de test, observations et état du problème. La branche hérite de ce contexte sans encore hériter d’un diff expérimental.
```text
Avant toute modification, formule le point de décision
- hypothèse principale ;
- hypothèse alternative ;
- fichiers concernés ;
- test de validation ;
- risque de chaque approche.
```
```bash
/branch approche-minimale
```
Cette séquence donne à la branche un point de départ propre. La nouvelle trajectoire ne commence pas dans le vide ; elle commence à partir d’un diagnostic déjà construit.

### Avant une modification risquée
Brancher est utile lorsqu’une modification risque d’entraîner beaucoup de bruit : refactorisation, changement d’architecture, migration, modification de tests anciens, remplacement d’un composant partagé ou correction dont l’impact exact n’est pas encore clair.
```bash
/branch refactorisation-cache-auth
```
```text
Dans cette branche, teste une refactorisation limitée
Ne touche pas à l'API publique.
Garde le diff aussi petit que possible.
Lance uniquement les tests ciblés au départ.
```
Si la trajectoire devient trop large, vous pourrez revenir à la session d’origine sans conserver cette discussion dans le chemin principal.

### Pour comparer deux stratégies
Le branchement est particulièrement adapté aux situations où deux stratégies sont raisonnables mais incompatibles. Par exemple : corriger un bug localement ou extraire une abstraction ; adapter un test existant ou créer un nouveau test ; corriger une API ou durcir le client ; supprimer une dépendance ou l’encapsuler.
```bash
/branch correction-locale
```
```text
Explore une correction locale.
Objectif :
- diff minimal ;
- aucun changement d'API ;
- test ciblé qui passe ;
- résumé clair des limites de cette approche.
```
```bash
/resume
/branch abstraction-service
```
```text
Explore une solution avec extraction d'un service.
Objectif :
- réduire la duplication ;
- conserver le comportement existant ;
- expliquer si le coût du refactor est justifié.
```
La comparaison devient plus nette parce que chaque branche contient sa propre trajectoire, ses propres observations et ses propres justifications.

## Le risque principal : confondre conversation et fichiers

### La branche ne protège pas le disque
Le point le plus important de cette leçon est négatif : `/branch` ne crée pas un instantané complet du projet. Si vous branchez une session puis laissez Claude modifier des fichiers, ces modifications sont appliquées dans le worktree courant.

La session d’origine reste conversationnellement intacte, mais les fichiers sur disque peuvent avoir changé. Si vous revenez à l’original avec `/resume`, cette session verra l’état actuel du disque, pas nécessairement l’état exact du disque au moment du branchement.

Brancher une session ne suffit donc pas à tester deux patchs incompatibles sur les mêmes fichiers.

### Contrôler le diff avant et après
Avant de brancher pour tester une variante de code, il faut vérifier l’état du dépôt.
```bash
/diff
```
```text
Avant de continuer, indique :
- les fichiers déjà modifiés ;
- les changements non validés ;
- si la branche de session part d'un état de travail propre
```
Après la variante, il faut refaire la même inspection.
```bash
/diff
```
```text
Résume cette variante :
- fichiers modifiés ;
- comportement changé ;
- tests exécutés ;
- résultat obtenu ;
- risques restants ;
- coût de la solution.
```
Ce protocole permet de comparer une branche de session sur des faits observables, pas seulement sur une impression de qualité.

### Quand utiliser un worktree à la place
Si plusieurs variantes doivent modifier les mêmes fichiers indépendamment, il faut utiliser un `worktree` Git plutôt qu’une simple branche de session. Le `worktree` crée un répertoire de travail séparé avec sa propre branche. Les modifications d’une session ne touchent alors pas directement les fichiers de l’autre.

La règle est simple : pour tester une variante de raisonnement, `/branch` suffit souvent ; pour tester une variante de code en parallèle, il faut isoler les fichiers.

Nous verrons en détail les `worktrees` dans un futur chapitre.

## Permissions et branche de session

### Les autorisations temporaires ne suivent pas
Les autorisations accordées uniquement pour une session ne sont pas automatiquement reportées dans la branche. C’est volontaire. Une branche est une nouvelle trajectoire, et le système ne doit pas transporter aveuglément une décision de confiance ancienne dans un contexte qui peut devenir différent.

Cette règle peut créer une friction : Claude peut redemander une permission déjà accordée dans la session d’origine. Mais cette friction protège contre une erreur plus grave : laisser une branche expérimentale agir avec des droits hérités sans réévaluation.

La branche hérite du contexte conversationnel, pas de toute la confiance opérationnelle.

### Les règles persistantes restent applicables
Les règles définies dans les paramètres, les permissions de projet, les paramètres utilisateur ou les politiques gérées continuent de s’appliquer. Ce qui ne suit pas, ce sont les approbations temporaires propres à la session.

Il faut donc distinguer deux niveaux : les permissions configurées, qui relèvent de la politique active ; et les approbations ponctuelles, qui appartiennent à un contexte de session.

## Retrouver la session originale

### Utiliser le sélecteur
Après un branchement, le plus sûr est souvent d’utiliser le sélecteur `/resume`.
```bash
/resume
```
Dans le sélecteur, les branches sont regroupées sous leur session racine. Vous pouvez développer le groupe, prévisualiser une branche avec `Espace`, puis reprendre la session correcte avec `Entrée`.

Ce comportement évite de reprendre une branche au hasard, surtout si plusieurs variantes ont été créées pendant une même tâche.

### Utiliser un nom explicite
Si la session originale ou la branche possède un nom clair, vous pouvez la reprendre directement.
```bash
/resume auth-diagnostic-original
```
Il est donc judicieux de nommer la session racine avant de créer des branches.
```bash
/rename auth-diagnostic-original
/branch auth-correction-minimale
```
Nommer la racine avant de brancher rend le graphe de sessions beaucoup plus lisible.

## Brancher depuis le terminal

### Le fork de session en ligne de commande
Le branchement n’existe pas seulement dans une session interactive. Depuis le terminal, Claude Code permet aussi de créer une branche de session en combinant une reprise ou une continuation avec l’option de fork de session `--fork-session`.

Cette forme est utile quand vous voulez reprendre une session existante, mais sans ajouter vos nouveaux messages à la trajectoire originale. Le système reconstruit la session source, crée une nouvelle session dérivée, puis continue dans cette branche.
```bash
claude --resume "auth-refactor" --fork-session
# Reprend la session auth-refactor dans une branche
claude --continue --fork-session
# Continue la dernière session, mais dans une nouvelle branche
```
Le principe est le même que `/branch` : créer une copie conversationnelle, puis continuer dans la copie. La différence tient seulement au point d’entrée. `/branch` s’utilise depuis une session active ; le fork de session en ligne de commande s’utilise au lancement ou à la reprise depuis le terminal.

### Quand préférer cette forme
Elle est pertinente lorsque vous savez déjà quelle session reprendre et que vous voulez immédiatement tester une variante sans ouvrir d’abord la session originale.
```text
Reprendre la dernière session du projet,
créer une branche de session,
puis tester une autre stratégie sans modifier la trajectoire
```
Dans un cours, il est préférable d’expliquer cette mécanique après `/branch`, car elle répond au même besoin mais dans un contexte non interactif ou semi-automatisé.

## `/branch` et `/fork`

### Une commande en transition
Le cas de `/fork` demande de la précision, car son comportement a changé au fil des versions. `/fork` peut désigner deux opérations distinctes.

### La distinction pratique à retenir
Pour ce cours, la règle utile est simple et stable, indépendamment des détails de version.
```bash
/branch
# Crée une branche de la conversation et vous y place
/fork <directive>
# Sur une version récente : délègue une tâche à un sous-agent
# qui hérite de toute la conversation.
```
Pour tester une variante de trajectoire en restant maître de la conversation, utilisez `/branch` : son comportement ne dépend d’aucune variable et ne prête pas à confusion. Pour confier une analyse ou une tâche secondaire à un agent sans quitter la session principale, utilisez `/fork`.

Une précision de vocabulaire : le fork de sous-agent (`/fork`) ne doit pas être confondu avec le fork de session en ligne de commande (`--fork-session`) vu plus haut. Le premier délègue à un agent d’arrière-plan ; le second crée une branche de session que vous reprenez vous-même. Les deux contiennent le mot « fork », mais répondent à des besoins différents.

## Brancher, reprendre, rembobiner ou déléguer

### Choisir la bonne opération

| Besoin | Commande ou mécanisme | Effet principal |
|---|---|---|
| Tester une autre direction sans perdre la conversation actuelle | `/branch` | Crée une nouvelle trajectoire de session et vous y place |
| Créer une variante de session depuis le terminal au moment de reprendre | `--fork-session` | Crée une session dérivée sans modifier l’originale |
| Déléguer une analyse à un sous-agent qui hérite de la conversation | `/fork <directive>` | Lance un fork de sous-agent en arrière-plan |
| Revenir à une conversation existante | `/resume` | Rouvre une session déjà enregistrée |
| Repartir sur une nouvelle tâche | `/clear` | Vide le contexte actif pour une nouvelle conversation |
| Réduire le contexte sans quitter la session | `/compact` | Remplace l’historique par un résumé |
| Revenir sur du code ou sur une portion de conversation | `/rewind` | Restaure ou résume à partir d’un point choisi |
| Exécuter deux variantes de code sans collision de fichiers | `Worktree Git` | Isole les fichiers dans un autre répertoire |

Cette distinction évite de surutiliser `/branch`. Le branchement est puissant, mais il n’est pas le bon outil pour chaque forme de retour arrière, de délégation ou d’isolation.

## Protocole recommandé

### Avant le branchement
```bash
/rename auth-diagnostic-original
/diff
/context
```
```text
Prépare un point de branchement :
- état du problème ;
- fichiers lus ;
- fichiers modifiés ;
- hypothèses ;
- tests disponibles ;
- risque de modification.
```
Ce protocole donne un nom à la session racine, vérifie le diff, inspecte le contexte et force une synthèse exploitable avant la bifurcation.

### Pendant la branche
```bash
/branch auth-correction-minimale
```
```text
Dans cette branche, applique uniquement la correction minimale
Ne refactorise pas.
Ajoute ou adapte un test ciblé.
Exécute la vérification ciblée.
Arrête-toi si le diff dépasse le périmètre prévu.
```
La branche reçoit une consigne stricte. Elle ne devient pas un espace général où toutes les idées sont testées en même temps.

### Avant de quitter la branche
```bash
/diff
```
```text
Rédige le bilan de cette branche :
- approche suivie ;
- fichiers modifiés ;
- tests exécutés ;
- résultat ;
- décision recommandée ;
- raisons de conserver ou d'abandonner cette variante.
```
Ce bilan transforme la branche en élément de décision. Sans cette étape, l’utilisateur devra relire l’historique pour comprendre ce qui a été essayé.

### Retourner à l’original
```bash
/resume
```
Dans le sélecteur, reprenez la session racine ou une autre branche. Prévisualisez toujours avant de reprendre si plusieurs variantes portent des noms proches.
