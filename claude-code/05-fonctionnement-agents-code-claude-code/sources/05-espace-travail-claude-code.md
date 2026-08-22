# Ce que Claude Code peut voir

Dans cette leçon, on va expliquer une idée simple : Claude Code ne travaille pas dans un espace abstrait. Il travaille à partir du projet, du dossier ou des fichiers qu’on lui donne.

Quand on lance Claude Code dans un dossier, ce dossier devient son espace de travail principal. Claude peut s’appuyer sur les fichiers, les sous-dossiers, l’état git, les instructions locales du projet et les éléments ajoutés pendant la session.

Mais cela ne veut pas dire que tout le projet est chargé d’un seul coup dans son contexte. Un fichier devient réellement utile quand il est mentionné, recherché, ouvert, résumé ou intégré à la conversation.

## Le dossier donné change ce que Claude voit

Le point de départ est important. Si on lance `claude` à la racine d’un dépôt, Claude peut raisonner à l’échelle du projet entier. Si on le lance dans un sous-dossier, sa vue de travail est plus locale.

Dans un petit projet, il est souvent logique de démarrer à la racine. Dans un monorepo, il peut être préférable de démarrer dans le package, le service ou le module concerné.

Plus le dossier donné est large, plus Claude peut explorer largement. Plus il est ciblé, plus son raisonnement reste concentré.

## Comprendre les workspaces dans Claude Code

Le mot *workspace* peut prêter à confusion, parce qu’il ne désigne pas toujours la même chose.

Il y a d’abord le workspace Claude Code dans la Console Anthropic. Celui-ci sert surtout à regrouper l’usage et le suivi des coûts de Claude Code dans l’organisation. Ce n’est pas un dossier de code. Il ne détermine pas directement quels fichiers Claude voit dans un projet.

Dans le travail quotidien, le workspace important est plutôt le dossier local depuis lequel on lance Claude Code. Par exemple :

```bash
cd /chemin/vers/mon-projet
claude
```

Dans ce cas, `/chemin/vers/mon-projet` devient le point de départ de la session. Claude peut alors analyser les fichiers de ce projet au fur et à mesure de la tâche.

On peut aussi ajouter un autre dossier de travail à une session déjà lancée :

```bash
/add-dir ../bibliotheque-partagee
```

Ou le faire dès le lancement :

```bash
claude --add-dir ../bibliotheque-partagee
```

Ajouter un dossier permet à Claude de travailler avec des fichiers situés en dehors du dossier principal. C’est utile quand un projet dépend d’un dépôt voisin, d’une bibliothèque partagée, d’une documentation locale ou d’un dossier de configuration commun.

Mais ajouter un dossier ne revient pas exactement à déplacer la session. Si on veut changer le dossier principal de travail, on utilise plutôt :

```bash
/cd ../autre-projet
```

La différence est importante : `/add-dir` élargit la session avec un dossier supplémentaire, tandis que `/cd` déplace la session vers un nouveau dossier principal.

## Le projet n’est pas injecté en entier

Claude ne reçoit pas automatiquement tous les fichiers du projet dans son contexte. Il construit progressivement sa compréhension à partir des fichiers consultés, des chemins mentionnés, des résultats de recherche, des sorties de commandes et des éléments fournis par l’utilisateur.

Un fichier peut exister dans le projet sans avoir été vu par Claude. À l’inverse, un fichier explicitement mentionné ou ouvert devient une partie active de son raisonnement.

## Donner un périmètre clair

Pour obtenir une réponse plus fiable, il faut indiquer clairement les fichiers, dossiers ou zones du projet à analyser. Les mentions de chemins, les noms de tests, les logs et les erreurs permettent à Claude de travailler sur le bon périmètre dès le départ.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple de cadrage (bonne pratique) :**

*« Analyse `@src/auth/session.ts`. »*

**Objectif :** expliquer comment ce fichier gère le renouvellement de session.

</div>

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Autre exemple de cadrage (bonne pratique) :**

*« Analyse `@src/billing/` et `@tests/billing.test.ts`. »*

**Objectif :** comprendre pourquoi les remises cumulées échouent.

</div>

Cette manière de cadrer la demande évite à Claude d’explorer trop largement ou de raisonner à partir d’un contexte incomplet.

La bonne question n’est donc pas seulement : *“À quoi Claude a accès ?”* mais plutôt : *“Qu’est-ce qui a été rendu visible à Claude pour cette tâche précise ?”*

## Vue d’ensemble : ce que Claude Code peut utiliser

Dans les prochaines leçons, on détaillera progressivement les différentes sources que Claude Code peut utiliser :
- les fichiers et dossiers du projet ;
- les dossiers ajoutés avec `/add-dir` ou `--add-dir` ;
- les worktrees pour travailler en parallèle ;
- l’état git du dépôt ;
- les commandes exécutées dans l’environnement de travail ;
- les fichiers d’instructions comme `CLAUDE.md` ;
- la mémoire locale du projet ;
- les outils web ;
- les serveurs MCP ;
- les intégrations avec l’IDE, le navigateur ou d’autres interfaces.
