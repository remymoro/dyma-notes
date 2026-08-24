# Comprendre les sources de contexte dans Claude Code

Dans cette leçon, vous allez comprendre ce que Claude peut utiliser pendant une session Claude Code. Le sujet central est la fenêtre de contexte appliquée au développement agentique : messages, fichiers lus, sorties de commandes, instructions projet, mémoire, skills, outils, règles, sous-agents et historique de conversation.

Cette notion est plus importante dans Claude Code que dans un chat classique. Dans un chat, le contexte vient surtout de vos messages et des réponses de l’assistant. Dans Claude Code, il peut aussi inclure des fichiers du dépôt, des sorties de terminal, des résultats d’outils, des instructions persistantes et des informations chargées automatiquement.

Le point essentiel est le suivant : Claude ne travaille pas avec tout le dépôt en mémoire permanente. Il travaille avec ce qui est actuellement chargé, résumé ou accessible dans la fenêtre de contexte, et avec les outils qu’il peut appeler pour aller chercher d’autres informations.

## Les commandes utilisées dans cette leçon

### Afficher l’utilisation du contexte
La commande principale de cette leçon est `/context`. Elle permet d’observer l’utilisation actuelle de la fenêtre de contexte.
```bash
/context
```
Elle sert à voir où part le budget de contexte : conversation, fichiers, sorties d’outils, instructions, mémoire, skills ou autres catégories selon la version et l’état de la session.
Selon la version, `/context` présente ces catégories sous forme de grille colorée et peut signaler des optimisations possibles : outils qui consomment beaucoup de contexte, mémoire devenue trop volumineuse ou approche de la limite de capacité.

## Préparer une session propre

### Revenir dans le mini-projet
Revenez dans le projet `convertisseur-temperature`.
```bash
cd convertisseur-temperature
```
Vérifiez l’état du dépôt.
```bash
git status
```
Cette leçon ne doit pas modifier le code. Si le dépôt contient déjà des changements, regardez-les avant de continuer.
```bash
git diff
```

### Ouvrir Claude Code
Lancez Claude Code depuis la racine du projet.
```bash
claude
```

### Observer le contexte initial
Lancez maintenant :
```bash
/context
```
La sortie exacte dépend de votre version, de votre configuration, du projet, des skills disponibles, des serveurs MCP configurés, du style de sortie et de la mémoire chargée. L’objectif n’est pas de mémoriser chaque catégorie, mais de constater qu’une session contient déjà du contexte avant même que vous demandiez à Claude de lire un fichier.

## Définition opérationnelle du contexte

### La fenêtre de contexte
La fenêtre de contexte est l’espace dans lequel le modèle reçoit les informations utiles pour produire sa prochaine réponse. Elle peut contenir des instructions, l’historique de conversation, des fichiers lus, des sorties d’outils, des résumés et certains éléments qui ne sont pas affichés directement dans le terminal.
```text
Fenêtre de contexte :
ce que Claude peut utiliser maintenant pour produire
```
Elle est limitée. Une sortie longue, une exploration trop large ou une conversation confuse peuvent donc réduire la qualité du travail.

### Les notions à ne pas confondre
Le contexte n’est pas le dépôt, il n’est pas Git, il n’est pas la transcription complète et il n’est pas une preuve de correction.
```text
Le dépôt :
tous les fichiers disponibles sur le disque.
Le contexte :
les informations actuellement chargées ou résumées dans la fenêtre.
La mémoire :
les instructions ou apprentissages persistants chargés.
La transcription :
l’historique local de la conversation sauvegardé sur disque.
Git :
l’état versionné ou non versionné du projet.
Le diff :
ce qui a changé dans les fichiers par rapport à l’état précédent.
```
Un fichier peut exister dans le dépôt sans être dans le contexte. Un fichier peut avoir été lu plus tôt, puis n’être conservé que sous forme résumée après compaction. Une règle peut exister dans `CLAUDE.md`, mais devenir moins visible si la session est saturée. Un diff peut exister dans Git sans que Claude l’ait encore relu.

## Identifier les sources qui alimentent le contexte

### Le contexte chargé au démarrage
Au lancement, plusieurs sources peuvent déjà être présentes.
```text
Sources possibles au démarrage :
- invite système de Claude Code ;
- style de sortie actif ;
- instructions utilisateur globales ;
- CLAUDE.md du projet ;
- CLAUDE.local.md si présent ;
- mémoire automatique ;
- descriptions de skills disponibles ;
- noms ou descriptions d’outils MCP ;
- informations d’environnement (répertoire de travail) ;
- configuration de session ;
- instructions ajoutées par certaines options de lancement.
```
Ces éléments ne sont pas toujours visibles comme des messages normaux. Pourtant, ils peuvent influencer les réponses. Une session Claude Code ne doit donc pas être comprise seulement comme ce qui apparaît dans le terminal.

### Les messages que vous envoyez
Chaque message envoyé ajoute du contexte. Une demande courte consomme peu. Une erreur de plusieurs centaines de lignes consomme beaucoup. Une contrainte claire aide la session. Une consigne ambiguë peut la polluer.
```text
Vos messages peuvent ajouter :
- objectif ;
- contraintes ;
- fichiers ciblés ;
- exemples ;
- erreurs ;
- logs ;
- captures ou images collées ;
- critères de réussite ;
- corrections données à Claude ;
- décisions prises pendant la session.
```
Le contexte n’est donc pas seulement une ressource consommée par Claude. C’est aussi une ressource que vous construisez.

### Les fichiers lus
Un fichier du dépôt n’est pas automatiquement chargé en entier dans le contexte. Il devient contexte quand Claude le lit, quand vous le référencez, quand une commande l’affiche ou quand un outil en extrait du contenu.
```text
Exemples :
- Claude lit src/main.js ;
- vous mentionnez @src/conversion.js ;
- une commande affiche package.json ;
- un test affiche une erreur contenant du code ;
- un outil retourne un extrait de fichier ;
- un diff est affiché dans la conversation.
```
Claude Code peut accéder au dépôt, mais l’accès n’est pas la même chose que la présence dans le contexte. L’agent peut aller chercher des fichiers quand il en a besoin, sans garder tout le projet chargé en permanence.

### Les sorties de commandes
Quand Claude lance une commande, sa sortie peut entrer dans le contexte. Une sortie courte est utile. Une sortie massive peut devenir un problème.
```text
Sorties utiles :
- git status --short ;
- npm test avec sortie courte ;
- git diff --stat ;
- grep ciblé ;
- liste courte de fichiers.
Sorties à contrôler :
- logs complets ;
- tests très verbeux ;
- build très long ;
- find sans limite ;
- cat d’un gros fichier ;
- grep récursif trop large.
```
Demandez des commandes ciblées. Une exploration large peut remplir la fenêtre de contexte sans améliorer la compréhension.
```text
Ne modifie aucun fichier.
Utilise des commandes de lecture courtes.
Évite les sorties longues.
Si une commande risque de produire beaucoup de lignes, tronque-la.
```

### Les instructions persistantes
`CLAUDE.md` et la mémoire automatique sont deux sources persistantes, mais elles n’ont pas le même rôle.
```text
CLAUDE.md :
instructions écrites par vous ou par l’équipe.
Mémoire automatique :
notes apprises par Claude à partir de vos corrections.
```
`CLAUDE.md` sert à transmettre des conventions, des commandes de test, une architecture ou des pièges connus. La mémoire automatique sert plutôt à conserver des apprentissages issus de vos corrections.
Ces deux mécanismes guident Claude, mais ce ne sont pas des garde-fous techniques. Pour bloquer une action, il faut utiliser des permissions ou des hooks. Une instruction dans `CLAUDE.md` reste une instruction, pas une interdiction déterministe. Nous les reverrons en détail dans un chapitre dédié.

### Les CLAUDE.md imbriqués
Dans un grand projet, il peut exister plusieurs fichiers `CLAUDE.md`. Les fichiers situés dans la hiérarchie du répertoire courant peuvent être chargés au lancement. Les fichiers placés dans des sous-répertoires peuvent être chargés quand Claude travaille avec les fichiers correspondants.
```text
Exemple :
CLAUDE.md
src/CLAUDE.md
src/auth/CLAUDE.md
test/CLAUDE.md
```
Dans un petit projet, un seul `CLAUDE.md` à la racine suffit. Dans un monorepo, les fichiers imbriqués peuvent être utiles, mais ils doivent rester courts et cohérents.

### Les skills
Les skills ajoutent des connaissances ou des workflows réutilisables. Leur description peut être disponible pour que Claude sache qu’elles existent. Leur contenu complet est chargé quand elles sont invoquées ou quand Claude les utilise.
```text
Skill disponible :
Claude peut voir qu’elle existe et quand elle peut être utile.
Skill invoquée :
son contenu devient contexte pour la tâche.
```
Une skill convient mieux qu’un long `CLAUDE.md` pour une procédure réutilisable qui ne sert pas à chaque session. Si une information doit être toujours disponible, elle peut aller dans `CLAUDE.md`. Si elle ne sert que parfois, elle doit plutôt aller dans une skill.

### Le MCP
Les serveurs MCP connectent Claude Code à des services et outils externes. Les noms ou descriptions de ces outils peuvent faire partie du contexte de démarrage. Les résultats retournés pendant la session peuvent aussi consommer du contexte.
```text
Exemples de contexte MCP :
- description d’un outil disponible ;
- résultat d’une recherche dans un outil externe ;
- ticket lu depuis un gestionnaire de projet ;
- extrait de documentation ;
- résultat d’une requête interne.
```
Le risque est le même qu’avec les fichiers locaux : une source externe peut produire trop d’information. Demandez des résultats ciblés.
```text
Quand tu utilises un outil externe, récupère seulement l'information pertinente.
Évite de charger de longs historiques si un résumé ou le dernier état suffit.
```

### Les règles et les hooks
Les règles de projet peuvent être générales ou limitées à certains chemins. Les règles générales ressemblent à des instructions persistantes. Les règles limitées par chemin se chargent seulement quand Claude travaille avec les fichiers correspondants.
```text
Règle générale :
utile pour une convention globale.
Règle limitée par chemin :
utile pour un sous-dossier, un type de fichier ou un composant spécifique.
```
Les hooks, eux, sont différents. Ce sont des actions exécutées lors d’événements du cycle de vie. Ils peuvent produire une sortie, mais ils ne sont pas du contexte textuel stable comme un fichier d’instructions.
```text
Hook :
script, requête, prompt ou sous-agent déclenché par un événement.
```

### Les sous-agents
Un sous-agent peut travailler dans une fenêtre de contexte séparée. Il peut lire beaucoup de fichiers, enquêter sur une zone large, puis renvoyer seulement un résumé à la session principale.
```text
Usage typique :
utiliser un sous-agent pour enquêter sur une zone large
puis récupérer seulement le résumé utile.
```
Cette technique permet de préserver le contexte principal. Elle est particulièrement utile pour les recherches volumineuses, les logs longs ou les analyses secondaires.

## Repérer ce qui n’est pas automatiquement du contexte

### Les informations disponibles ne sont pas toujours chargées
Tout ce qui existe dans votre environnement n’est pas automatiquement présent dans la fenêtre de contexte.
```text
Pas automatiquement dans le contexte :
- tous les fichiers du dépôt ;
- toute l’histoire Git ;
- toutes les branches ;
- tous les worktrees ;
- tous les logs ;
- toutes les variables d’environnement ;
- toutes les issues ;
- toutes les PR ;
- toutes les pages de documentation externe ;
- tous les secrets.
```
Claude peut parfois accéder à certaines de ces informations avec des outils, des commandes ou des connecteurs, mais elles ne sont pas présentes par défaut comme connaissances actives.

### Les contenus à ne pas charger inutilement
Certains contenus doivent être évités pour des raisons de contexte, de sécurité ou de confidentialité.
```text
À éviter :
- secrets ;
- tokens ;
- mots de passe ;
- valeurs complètes de fichiers .env ;
- logs contenant des données personnelles ;
- dumps volumineux ;
- fichiers générés massifs ;
- dépendances vendored ;
- fichiers build ;
- historiques trop longs.
```

## Diagnostiquer le contexte avec /context

### Comparer avant et après une lecture
Faites une comparaison simple. Commencez par afficher l’état actuel.
```bash
/context
```
Demandez ensuite une lecture ciblée.
```text
Ne modifie aucun fichier.
Lis uniquement :
- README.md ;
- package.json ;
- src/conversion.js ;
- src/main.js ;
- test/conversion.test.js.
Résume en dix lignes maximum :
1. rôle du projet ;
2. fichiers principaux ;
3. commande de test ;
4. limite visible du projet.
```
Relancez ensuite :
```bash
/context
```
La session devrait être plus chargée. Les fichiers lus, votre demande, la réponse de Claude et les éventuelles sorties d’outils ont ajouté du contenu.

### Demander une carte du contexte actif
Vous pouvez aussi demander à Claude de distinguer les sources de contexte visibles et probables.
```text
Ne modifie aucun fichier.
À partir de cette session, explique quelles sources forment ton contexte.
Classe-les en :
1. messages de conversation ;
2. fichiers lus ;
3. sorties d’outils ou de commandes ;
4. instructions projet ;
5. mémoire ou instructions persistantes ;
6. éléments probablement absents du contexte.
Ne prétends pas voir ce que tu ne peux pas vérifier.
Si une source est incertaine, dis-le.
```
Cette demande force Claude à distinguer les faits lus, les hypothèses et les informations incertaines.

## Garder le contexte pertinent

### Limiter l’exploration
Pour éviter de remplir inutilement la fenêtre de contexte, donnez toujours un périmètre.
```text
Mauvaise demande :
Explore tout le projet et dis-moi ce qu’il fait.

Meilleure demande :
Lis seulement README.md, package.json, src/conversion.js.
Ne lis pas les fichiers générés.
Ne lance pas de commande récursive large.
Résume en dix lignes maximum.
```
La deuxième demande produit un contexte plus propre. Elle donne à Claude assez d’information pour répondre, sans l’inciter à lire inutilement tout le dépôt.

### Reconnaître une session polluée
Une session devient polluée quand le contexte contient trop d’informations non pertinentes, anciennes ou contradictoires.
```text
Signes de contexte pollué :
- Claude revient à une ancienne tâche ;
- Claude répète une approche déjà rejetée ;
- Claude oublie une contrainte récente ;
- Claude mélange deux objectifs ;
- Claude propose de modifier des fichiers hors périmètre ;
- Claude cite des hypothèses anciennes comme si elles étaient toujours valides ;
- Claude devient plus hésitant ou plus verbeux.
```
Dans ce cas, ne corrigez pas indéfiniment. Les corrections successives peuvent devenir du contexte parasite. Les leçons suivantes montreront quand utiliser `/clear`, `/compact`, `/rewind`, `/resume` ou `/branch`.

### Demander une synthèse avant une tâche importante
Avant une modification importante, demandez une synthèse courte du contexte actif.
```text
Ne modifie aucun fichier.
Avant de faire quoi que ce soit, résume le contexte actuel.
Réponds avec :
1. ce que tu sais du projet ;
2. les fichiers que tu as réellement lus ;
3. les hypothèses non vérifiées ;
4. les contraintes encore actives ;
5. ce que tu dois relire avant une modification.
```
Cette demande réduit les mauvaises surprises. Elle oblige Claude à séparer ce qu’il sait, ce qu’il suppose et ce qu’il doit encore vérifier.

## Comprendre le lien entre contexte et compaction

### Le principe de la compaction
La compaction transforme une conversation longue en résumé. Elle libère de la place dans la fenêtre de contexte, mais elle change la granularité de ce que Claude conserve. Certains détails peuvent disparaître ou être réduits.
```text
Avant compaction :
Claude peut avoir beaucoup de détails bruts.
Après compaction :
Claude dispose surtout d’un résumé structuré.
```
La compaction automatique peut se déclencher quand la session approche de la limite. Vous pouvez aussi compacter manuellement avec `/compact`, ce qui sera étudié dans la leçon suivante.

### Ce qui survit mieux à la compaction
Après compaction, tous les éléments ne survivent pas de la même manière. La majeure partie du contexte de démarrage est rechargée automatiquement : l’invite système, le style de sortie, le `CLAUDE.md` racine, la mémoire automatique et les noms d’outils MCP reviennent sans action de votre part. Les détails anciens de la conversation, eux, sont condensés dans le résumé.
```text
Rechargé automatiquement après compaction :
- invite système ;
- style de sortie ;
- CLAUDE.md racine ;
- règles sans portée ;
- mémoire automatique ;
- noms d’outils MCP.

Peut devoir être rechargé selon le travail en cours :
- CLAUDE.md imbriqué ;
- règle limitée par chemin.

Condensé dans le résumé (détail brut perdu) :
- détail ancien d’une conversation ;
- sortie d’outil longue ;
- fichier lu longtemps avant la compaction.

Cas particuliers :
- descriptions de skills : la liste n’est pas réinjectée automatiquement.
- hooks : ce sont des scripts exécutés, pas du contexte statique.
```
Les descriptions de `skills` méritent une attention particulière. Cette liste fait partie du contexte de démarrage, mais elle n’est pas réinjectée après une compaction. Seules les skills que Claude a réellement invoquées pendant la session restent disponibles ensuite. Une skill simplement présente au démarrage peut donc sortir du contexte après `/compact`, alors que l’invite système, les `CLAUDE.md`, la mémoire et les outils MCP sont, eux, rechargés automatiquement.

Si un détail est critique, ne le laissez pas uniquement dans un ancien message. Reformulez-le dans le prompt courant, placez-le dans `CLAUDE.md` si c’est une règle durable, ou demandez à Claude de le préserver explicitement lors d’une compaction.
