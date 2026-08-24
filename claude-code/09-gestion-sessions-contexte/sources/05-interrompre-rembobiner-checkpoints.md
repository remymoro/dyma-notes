# Interrompre tôt et rembobiner avec les checkpoints

Dans Claude Code, la gestion d’une session ne consiste pas seulement à reprendre une conversation ou à la brancher. Elle consiste aussi à savoir interrompre une trajectoire avant qu’elle ne se dégrade, puis à utiliser les checkpoints pour revenir à un état antérieur du code, de la conversation, ou des deux.

Interrompre tôt est une compétence de pilotage. Il ne faut pas attendre que Claude termine une séquence manifestement mauvaise. Une trajectoire agentique peut accumuler rapidement du bruit : lectures inutiles, hypothèses erronées, modifications hors périmètre, commandes mal choisies, corrections successives et contexte pollué. Plus l’intervention arrive tard, plus la session devient difficile à redresser.

Les checkpoints fournissent le second mécanisme de contrôle. Chaque invite utilisateur crée un point de contrôle, et Claude Code crée automatiquement des instantanés de fichiers avant les modifications faites par ses outils d’édition. Ces checkpoints persistent entre les sessions et sont nettoyés avec les sessions après une durée configurable, documentée par défaut à trente jours.

## Interrompre tôt

### `Esc` comme arrêt de trajectoire
La touche `Esc` sert à arrêter Claude pendant qu’il agit. La documentation de bonnes pratiques précise que le contexte est préservé, ce qui permet de rediriger la session au lieu de la perdre.

Cette interruption doit être comprise comme un arrêt de trajectoire, pas comme une annulation complète. Elle coupe l’action en cours ou la séquence actuelle, mais elle ne réécrit pas automatiquement l’historique, ne restaure pas nécessairement les fichiers et ne supprime pas les observations déjà produites.

`Esc` sert à reprendre le contrôle avant que le coût contextuel augmente. C’est le bon geste lorsque Claude explore trop largement, part sur une hypothèse manifestement fausse, ignore une contrainte, propose une modification trop large ou s’apprête à exécuter une commande dont le périmètre n’est pas clair.

### Quand interrompre
Il faut interrompre dès que la trajectoire devient incohérente avec l’objectif. Attendre la réponse finale revient souvent à laisser la session enregistrer une chaîne complète d’hypothèses inutiles. Ces hypothèses peuvent ensuite rester dans le contexte, être résumées lors d’une compaction, ou influencer les itérations suivantes.
```text
Arrête cette piste.
Ne modifie rien de plus pour l’instant.
Rappelle ce que tu as déjà observé.
Distingue les faits vérifiés des hypothèses.
Propose une reprise plus limitée.
```
Cette forme de redirection conserve ce qui est exploitable, mais empêche la session de continuer sur une base faible.

### Interruption et observation
Après une interruption, il faut rétablir l’état de travail. La bonne réaction n’est pas forcément de demander immédiatement une autre correction. Il faut d’abord inspecter ce qui a été lu, ce qui a été modifié, ce qui a échoué et ce qui reste incertain.
```text
Avant toute nouvelle action :
- indique les fichiers que tu as lus ;
- indique les fichiers que tu as modifiés ;
- indique les commandes exécutées ;
- indique les hypothèses qui restent non vérifiées ;
- propose la prochaine action minimale.
```
Cette étape transforme l’interruption en point de contrôle intellectuel. Elle évite que la session reparte immédiatement dans une autre direction tout aussi fragile.

## Rembobiner avec les checkpoints

### Ouvrir le menu de rembobinage
Le menu de rembobinage s’ouvre avec `/rewind`. Il peut aussi s’ouvrir avec `Esc` deux fois lorsque le champ de saisie est vide. Si le champ contient du texte, le double `Esc` efface d’abord ce texte ; le texte effacé reste dans l’historique de saisie et peut être rappelé avec la flèche du haut.
```bash
/rewind
/checkpoint
```
`/checkpoint` est l’alias de `/rewind`. La commande sert à rembobiner la conversation, le code, ou les deux, ou à résumer une partie de la conversation depuis un message sélectionné.

### Ce que le menu affiche
Le menu de rembobinage liste les invites envoyées pendant la session. L’utilisateur choisit un point, puis sélectionne une action. Ce point correspond à une frontière de reprise : il ne s’agit pas seulement d’un affichage historique, mais d’un endroit où l’on peut restaurer ou compresser l’état de la session.

Le choix est important parce que toutes les options n’ont pas le même effet. Certaines changent le code, certaines changent la conversation, certaines ne changent pas les fichiers et ne font que réduire le contexte.

## Les actions de rembobinage

### Restaurer le code et la conversation
Restaurer le code et la conversation ramène à la fois l’état des fichiers suivis et l’historique conversationnel au point sélectionné. C’est l’option la plus radicale. Elle convient lorsque la trajectoire entière est mauvaise : mauvaise hypothèse, mauvais patch, conversation polluée et code devenu incohérent.

Cette option doit être utilisée lorsque le problème n’est pas seulement dans les fichiers, mais aussi dans le raisonnement accumulé. Elle coupe la branche de travail courante et revient à un état plus ancien du dialogue et du code.

### Restaurer la conversation
Restaurer la conversation rembobine jusqu’au message choisi tout en conservant le code actuel. Cette option est utile lorsque les fichiers sont dans un état acceptable, mais que la conversation a pris une direction confuse.

Elle permet de garder le résultat matériel du travail, tout en retirant du contexte les échanges qui ont suivi le point choisi. C’est une opération de nettoyage conversationnel, pas une restauration du disque.

### Restaurer le code
Restaurer le code annule les modifications de fichiers suivies par les checkpoints, tout en conservant l’historique complet de la conversation. Cette option convient lorsque la discussion reste utile, mais que le patch produit doit être annulé.

Restaurer le code permet de conserver l’apprentissage de la session sans conserver l’effet matériel de la mauvaise tentative. C’est souvent l’option la plus pertinente après une expérimentation de code qui échoue mais qui a produit un diagnostic utile.

### Résumer à partir d’ici
Résumer à partir d’ici conserve les messages antérieurs au point sélectionné, puis remplace le message sélectionné et ce qui suit par un résumé. Cette option sert à abandonner une discussion secondaire ou une piste devenue inutile, tout en gardant le contexte initial détaillé.

Elle ne modifie pas les fichiers sur le disque. Elle agit sur la pression de contexte. Elle est proche de `/compact`, mais plus ciblée, parce que l’utilisateur choisit le côté de la conversation à compresser.

### Résumer jusqu’à ici
Résumer jusqu’à ici remplace les messages antérieurs au point choisi par un résumé, tout en conservant les messages récents intacts. Cette option est utile lorsqu’une longue phase de configuration, d’exploration ou de clarification est devenue trop volumineuse, mais que le travail récent doit rester disponible en détail.

Dans les deux modes de résumé, les messages originaux restent conservés dans la transcription de session. Le résumé réduit ce que la session active expose au modèle, mais il ne transforme pas la transcription durable en simple texte compressé.

Un détail pratique du menu : après Restaurer la conversation ou Résumer à partir d’ici, l’invite d’origine du message sélectionné est replacée dans le champ de saisie, prête à être renvoyée ou modifiée. Résumer jusqu’à ici, en revanche, vous laisse à la fin de la conversation avec un champ de saisie vide.

## Restaurer et résumer ne répondent pas au même problème

### Restaurer annule un état
Les options de restauration servent à annuler : annuler du code, annuler une portion de conversation, ou annuler les deux. Elles conviennent quand la trajectoire suivie ne doit pas être conservée dans sa forme actuelle.

Restaurer est donc une opération de retour. Elle sert à revenir à un état antérieur de travail.

### Résumer compresse un contexte
Les options de résumé ne restaurent pas le disque. Elles compressent une portion de conversation. Elles conviennent lorsque la trajectoire contient encore une information utile, mais qu’elle consomme trop de contexte.

Restaurer répond à une erreur d’état ; résumer répond à une pression de contexte. Les confondre produit de mauvaises décisions. Il ne faut pas résumer un patch à abandonner ; il faut restaurer ou utiliser Git. Il ne faut pas restaurer une longue discussion utile uniquement parce qu’elle occupe trop de place ; il faut la résumer.

## Rembobiner au-delà d’un `/clear`

### Reprendre la session précédente
Lorsque `/clear` a été exécuté plus tôt dans le même processus Claude Code, le menu de rembobinage peut afficher une entrée permettant de reprendre la conversation active avant le `/clear`. La documentation précise que cette entrée est disponible jusqu’à la sortie de Claude Code ou jusqu’à la reprise d’une autre session, avec une exigence de version pour les versions récentes concernées.

Cette capacité est utile lorsque l’utilisateur efface le contexte trop vite. `/clear` démarre une nouvelle tâche avec un contexte vide, mais la conversation précédente n’est pas nécessairement perdue. Elle reste récupérable par les mécanismes de session et de rembobinage lorsque les conditions sont réunies.

## Ce que les checkpoints suivent réellement

### Les modifications faites par les outils d’édition
Le checkpointing suit les modifications apportées par les outils d’édition de fichiers de Claude Code. Les instantanés sont créés avant les modifications, ce qui permet ensuite à `/rewind` de restaurer l’état antérieur des fichiers suivis.

Dans le fichier de paramètres, cette capacité correspond à `fileCheckpointingEnabled`. Elle est activée par défaut et apparaît dans `/config` sous le libellé Rewind code ou checkpoints.
```json
{
  "$schema": "https://json.schemastore.org/claude-code",
  "fileCheckpointingEnabled": true
}
```
Ce réglage appartient à la réversibilité locale de la session. Le désactiver réduit la capacité à revenir rapidement sur les modifications faites par Claude.

Le suivi peut aussi être désactivé au lancement via la variable d’environnement `CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING` définie à `1`. Lorsque le suivi des fichiers est désactivé, `/rewind` peut encore rembobiner la conversation, mais il ne peut plus restaurer les fichiers.

### Un stockage séparé de la transcription
Le papier d’architecture distingue la transcription de session et les checkpoints de fichiers. Les transcriptions sont principalement des fichiers `JSONL` append-only, tandis que les checkpoints de fichiers sont des instantanés destinés à restaurer les changements du système de fichiers. Le papier localise ces snapshots de fichiers sous `~/.claude/file-history/<sessionId>/` et précise qu’il s’agit de checkpoints de fichiers, pas d’un stockage générique de snapshots.

Cette séparation est essentielle. La conversation durable, la fenêtre de contexte active et les snapshots de fichiers ne sont pas le même objet. `/rewind` coordonne ces éléments, mais ils ne possèdent pas la même portée ni les mêmes limites.

## Les limites des checkpoints

### Les modifications faites par Bash ne sont pas suivies
Le checkpointing ne suit pas les fichiers modifiés par les commandes `Bash`. Si une commande supprime, déplace, copie ou régénère des fichiers, ces changements ne peuvent pas être annulés par le rembobinage, sauf s’ils correspondent par hasard à des fichiers déjà suivis par les mécanismes de modification directe. La documentation explicite cette limite avec des commandes comme `rm`, `mv` et `cp`.
```bash
rm fichier.txt
mv ancien.txt nouveau.txt
cp source.txt destination.txt
```
Une commande shell peut produire des effets que `/rewind` ne sait pas restaurer. C’est pourquoi les commandes qui modifient le système de fichiers doivent être traitées avec plus de prudence que les éditions directes faites par les outils de Claude Code.

### Les modifications externes ne sont pas suivies
Le checkpointing ne capture pas normalement les modifications manuelles faites en dehors de Claude Code, ni les modifications produites par d’autres sessions concurrentes. La documentation précise que les checkpoints suivent les fichiers modifiés au cours de la session actuelle, avec des exceptions seulement lorsque les mêmes fichiers sont concernés par hasard.

Cette limite devient critique lorsque plusieurs sessions, plusieurs terminaux ou des outils externes modifient le même dépôt. Dans ce cas, `/rewind` peut donner une impression de sécurité supérieure à sa portée réelle.

### Ce n’est pas un remplacement de Git
Les checkpoints sont conçus pour une récupération rapide au niveau de la session. Ils complètent Git, mais ne remplacent pas les commits, les branches, l’historique long terme et la collaboration. La documentation formule explicitement cette distinction : les checkpoints sont une forme d’annulation locale, tandis que Git reste l’historique permanent.

Dans une tâche sérieuse, il faut utiliser les deux niveaux. Les checkpoints servent à récupérer vite pendant l’expérimentation. Git sert à enregistrer, comparer, partager et revenir durablement à des états de projet.

## `/rewind`, `/branch`, `/clear` et Git

### Choisir le bon outil de contrôle

| Besoin | Mécanisme adapté | Effet principal |
|---|---|---|
| Arrêter une trajectoire en cours | `Esc` | Interrompt l’action ou la réponse en cours tout en préservant le contexte. |
| Revenir à un état antérieur de conversation ou de code | `/rewind` | Restaure le code, la conversation, ou les deux selon l’option choisie. |
| Compresser une partie précise de l’historique | `/rewind` puis option de résumé | Réduit le contexte sans modifier les fichiers. |
| Repartir sur une tâche sans rapport | `/clear` | Démarre une conversation avec un contexte vide. |
| Tester une variante conversationnelle | `/branch` | Crée une copie de la conversation et continue dans cette copie. |
| Isoler durablement des variantes de code | `Git` | Crée un historique et une séparation de travail indépendants de la session. |

Le choix dépend de ce qui doit être contrôlé : l’action en cours, le contexte, le code, la trajectoire conversationnelle ou l’historique durable du projet.

## Travailler avec les checkpoints dans l’interface VS Code

### Rembobiner depuis un message
L’extension VS Code expose aussi les checkpoints. En survolant un message, l’utilisateur peut révéler un bouton de rembobinage, puis choisir entre trois actions : créer une branche de conversation depuis ce message en conservant les changements de code, rembobiner le code jusqu’à ce message en conservant l’historique complet, ou créer une branche de conversation tout en rembobinant le code.

Ces options reprennent la même distinction fondamentale : isoler la conversation, restaurer le code, ou combiner les deux. L’interface change, mais la logique reste celle des checkpoints et des sessions.

## Protocoles de travail

### Interrompre une trajectoire trop large
```bash
Esc
```
```text
Tu es en train d’élargir le périmètre.
Arrête cette piste.
Ne lis pas d’autres dossiers.
Reviens aux fichiers déjà observés.
Formule uniquement la prochaine action minimale.
```
Ce protocole est adapté lorsque Claude explore trop de fichiers ou s’éloigne de la demande initiale.

### Récupérer après une mauvaise modification
```bash
/diff
/rewind
```
```text
Après le rembobinage :
- indique l’état actuel du diff ;
- rappelle quelle hypothèse a été abandonnée ;
- propose une correction plus limitée ;
- n’exécute aucune modification avant validation.
```
Le `/diff` avant et après le rembobinage évite de croire qu’un retour arrière a restauré plus de choses qu’il ne l’a réellement fait.

### Compresser une piste inutile sans perdre tout le travail
```bash
/rewind
```
```text
Choisir un message.
Sélectionner Résumer à partir d’ici.
Demander de préserver :
- les fichiers réellement impliqués ;
- les tests exécutés ;
- les conclusions vérifiées ;
- les hypothèses abandonnées.
```
Cette opération garde la session dans la même trajectoire, mais réduit le poids d’une discussion qui n’a plus besoin d’être présente en détail complet.

### Tester une approche risquée
```text
Avant d’essayer cette approche :
- indique le point de départ ;
- indique les fichiers susceptibles d’être modifiés ;
- indique la commande de vérification ;
- limite la tentative à une seule hypothèse.
```
Comme chaque invite crée un checkpoint, cette demande constitue aussi un repère explicite dans le menu de rembobinage. Si la tentative échoue, il sera plus facile de retrouver le point précis où revenir.

## Bonnes pratiques

### Nommer avant les expériences longues
Avant une tentative risquée, il est utile de nommer la session. Cela facilite la reprise et limite la confusion entre les variantes.
```bash
/rename correction-auth-approche-minimale
```
Le nom de session n’est pas un mécanisme de restauration, mais il rend les points de reprise beaucoup plus exploitables.

### Vérifier le diff avant de restaurer
Il faut inspecter le diff avant de rembobiner, surtout si des commandes shell, des outils externes ou des modifications manuelles ont été utilisés. Le rembobinage ne restaure pas nécessairement tout ce que Git voit.
```bash
/diff
```
```text
Compare le diff actuel avec les changements que tu penses avoir annulés.
Indique les fichiers qui pourraient ne pas être couverts par ton annulation.
```

### Ne pas confondre "Annuler cela" et `/rewind`
Dire "Annuler cela" demande au modèle de produire une opération inverse. Cela peut être utile, mais ce n’est pas la même chose qu’un retour à un checkpoint. `/rewind` s’appuie sur l’état enregistré par le système ; "Annuler cela" s’appuie sur la capacité de Claude à raisonner sur les changements et à les inverser.

Pour une correction légère, une demande d’annulation peut suffire. Pour revenir à un état précis, il faut utiliser `/rewind`.

### Garder Git comme référence durable
Avant une séquence de travail importante, il reste préférable de partir d’un état Git propre ou d’une branche dédiée. Les checkpoints sont adaptés à la récupération locale rapide. Git reste le mécanisme de référence pour la collaboration, l’audit, les comparaisons longues et les retours arrière durables.
```bash
git status
```
```text
Avant de continuer :
- confirme que le dépôt est dans l’état attendu ;
- distingue les changements Git des changements couverts par tes checkpoints ;
- ne suppose pas que le rembobinage remplacera Git.
```
