# Le rôle et l'importance des prompts dans Claude Code

Dans Claude Code, le prompt n’est pas une simple phrase adressée à un modèle. C’est le point d’entrée d’une trajectoire agentique. Il détermine l’objectif initial, les contraintes, les références pertinentes, le niveau d’autonomie attendu, les critères de vérification et la forme du résultat final.

Un prompt efficace ne cherche pas à remplacer le raisonnement de Claude. Il encadre ce raisonnement. Il indique ce qui doit être accompli, ce qui compte comme réussite, ce qui est hors périmètre, quels éléments doivent être consultés et comment le résultat doit être vérifié.

La qualité d’un prompt se mesure moins à sa longueur qu’à sa capacité à réduire l’ambiguïté opératoire. Un prompt court peut être très efficace s’il définit clairement la cible, les contraintes et le signal de validation. Un prompt long peut être nuisible s’il mélange des règles secondaires, des préférences instables, des explications inutiles et des consignes contradictoires.

Dans un outil agentique, le prompt a donc une fonction plus forte que dans un simple échange conversationnel. Il ne déclenche pas seulement une réponse. Il oriente une boucle qui peut lire des fichiers, exécuter des commandes, produire des modifications, lancer des vérifications, demander des permissions et s’arrêter lorsqu’un critère est atteint.

## Le prompt comme entrée de la boucle agentique

### Un prompt déclenche une trajectoire, pas seulement une réponse

Lorsque l’utilisateur envoie un prompt, Claude Code assemble un contexte de décision, appelle le modèle, puis interprète la sortie produite. Cette sortie peut être une réponse textuelle, mais elle peut aussi être une demande d’outil : lire un fichier, rechercher une occurrence, modifier une zone du code, lancer un test, inspecter un journal, interroger une documentation ou déléguer une analyse.

Le prompt initial influence fortement cette première décision. Une demande vague force Claude à deviner le périmètre, les fichiers pertinents, la stratégie de vérification et le niveau de risque acceptable. Une demande bien cadrée réduit ces inférences. Elle donne au modèle un espace de travail plus stable et limite les corrections nécessaires pendant la session.

Le prompt est donc une contrainte d’entrée pour une procédure d’action. Il n’est pas seulement interprété comme du langage naturel ; il devient une partie du contexte qui oriente l’utilisation des outils et la progression de la boucle.

### Le prompt ne doit pas micro-diriger l’exécution

Un prompt efficace ne décrit pas nécessairement chaque fichier à lire, chaque commande à lancer ou chaque étape intermédiaire. Claude Code dispose d’outils pour explorer le projet. Le rôle du prompt n’est pas de simuler manuellement cette exploration, mais de définir l’objectif et les contraintes de l’exploration.

Il faut distinguer direction et micro-direction. Donner une direction consiste à nommer le résultat attendu, les limites et les critères de réussite. Micro-diriger consiste à imposer une séquence d’actions internes que Claude aurait souvent pu déterminer lui-même à partir du projet.

Une bonne formulation dit ce qui doit être vrai à la fin. Elle laisse à Claude la charge de déterminer les fichiers à lire, les symboles à suivre, les tests à lancer et les changements minimaux à appliquer.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple de formulation directionnelle (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <em>« Ajouter une protection contre les doubles soumissions dans le flux de paiement. »</em>
    
    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Contraintes :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 0;">
      <li>conserver le comportement actuel pour les paiements déjà validés ;</li>
      <li>réutiliser les composants existants si possible ;</li>
      <li>ne pas modifier l’API publique sans nécessité ;</li>
      <li>ajouter ou adapter les tests pertinents ;</li>
      <li>exécuter les tests ciblés avant de conclure.</li>
    </ul>
  </div>
</div>

## Les différents niveaux de prompt

### Le prompt immédiat

Le prompt immédiat est la demande envoyée dans la session courante. Il doit contenir ce qui est propre à la tâche actuelle : objectif, périmètre, artefacts, contraintes, niveau de détail attendu et condition de vérification.

Il ne doit pas contenir toute la politique permanente du projet. Les conventions stables doivent vivre dans des fichiers persistants. Les workflows réutilisables doivent être déplacés vers des skills ou des commandes. Les règles d’autorisation doivent être exprimées dans les permissions ou les hooks, pas seulement dans une phrase adressée au modèle.

### Les instructions persistantes dans CLAUDE.md

`CLAUDE.md` sert à stocker les instructions qui doivent être visibles au début des sessions : commandes de test, style de code propre au projet, conventions de branche, règles de revue, préférences d’architecture et informations que Claude ne peut pas déduire de la lecture du code.

`CLAUDE.md` ne doit pas devenir une décharge documentaire. Chaque ligne ajoutée consomme de l’attention et du contexte. Une règle qui répète une convention évidente, une documentation API détaillée ou une information qui change fréquemment dégrade la qualité du signal. Une règle persistante doit rester stable, générale et réellement discriminante.

Nous reverrons ce fichier en détail.

### Les compétences (skills) comme prompts spécialisés

Une skill peut être comprise comme une instruction spécialisée, chargée à la demande. Elle convient aux connaissances de domaine ou aux procédures qui ne doivent pas polluer toutes les sessions : conventions d’API, procédure de correction d’un ticket, protocole de migration, stratégie de revue sécurité, génération de documentation interne.

La différence avec `CLAUDE.md` est la portée. `CLAUDE.md` sert au contexte permanent. Une skill sert à un contexte conditionnel. Utiliser une skill évite de surcharger chaque prompt avec une procédure rarement nécessaire.

### Les prompts de subagents

Un subagent possède son propre contexte. Son prompt doit donc être plus autonome qu’une instruction envoyée dans la session principale. Il doit contenir la tâche, le périmètre, les fichiers ou artefacts à examiner, les outils autorisés si nécessaire, le format attendu du retour et les critères permettant de distinguer une observation utile d’un commentaire accessoire.

Un prompt de subagent doit être autosuffisant. Il ne faut pas supposer qu’il héritera de toute la conversation parent. Cette propriété est utile : elle garde le contexte principal propre. Mais elle impose de rédiger la délégation avec assez de précision pour que le subagent puisse travailler sans dépendre d’implicites.

## Pourquoi les prompts sont importants

### Ils déterminent le problème que Claude va réellement résoudre

Un modèle ne travaille jamais sur le besoin abstrait que l’utilisateur a en tête. Il travaille sur le besoin tel qu’il est représenté dans le contexte. Le prompt est donc une opération de traduction : il transforme une intention humaine en problème exploitable par la boucle agentique.

Lorsque le prompt est ambigu, Claude peut choisir une interprétation plausible mais incorrecte. Il peut corriger le mauvais comportement, lire le mauvais sous-système, optimiser une métrique secondaire ou produire un résultat formellement cohérent mais mal aligné avec l’objectif réel.

Le prompt n’est pas seulement une demande ; c’est une définition de tâche. Plus cette définition est stable, plus l’agent peut utiliser ses outils de manière pertinente.

### Ils réduisent le coût de correction

Une session mal cadrée accumule rapidement du bruit : fichiers inutiles, tentatives échouées, hypothèses dépassées, corrections successives, fragments de plans abandonnés. Ce bruit occupe le contexte et peut rendre les itérations suivantes moins fiables.

Un bon prompt initial réduit ce coût. Il évite que Claude explore trop largement, qu’il implémente avant d’avoir compris, qu’il modifie des zones hors périmètre ou qu’il conclue sans preuve. La qualité du prompt devient alors une forme d’économie : économie de contexte, de permissions, de lectures, de commandes et de corrections humaines.

### Ils définissent la condition d’arrêt

Dans une boucle agentique, une tâche doit pouvoir s’arrêter. Un prompt qui ne définit aucune condition de réussite laisse Claude décider seul quand le travail semble terminé. Cette clôture peut être prématurée.

Une bonne demande indique ce qui compte comme résultat valide : tests ciblés qui passent, typecheck sans erreur, diff limitée, couverture minimale, capture d’écran conforme, migration exécutée, documentation générée, absence de modification hors périmètre ou comparaison avec un artefact de référence.

Un prompt sans critère de vérification produit une trajectoire faible. Il peut conduire à une réponse plausible, mais pas nécessairement à un résultat démontré.

## La structure d’un prompt efficace

### Objectif

L’objectif doit être formulé comme un état final attendu. Il ne doit pas seulement nommer une activité. « Refactoriser le module » est une activité. « Réduire la duplication entre les adaptateurs Stripe et Adyen sans changer l’interface publique » est un objectif plus exploitable.

### Contexte source

Le contexte doit pointer vers des sources concrètes : fichier, dossier, log, erreur, sortie de test, capture d’écran, ticket, documentation ou ressource MCP. Il est préférable de fournir l’artefact réel plutôt qu’une paraphrase. Une description humaine d’une erreur perd souvent les détails déterminants.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple d'intégration de sources concrètes (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <em>« Le build échoue depuis la migration vers Vite. »</em>
    
    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Contexte :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 15px;">
      <li>erreur complète : <code>@build.log</code></li>
      <li>configuration : <code>@vite.config.ts</code></li>
      <li>scripts disponibles : <code>@package.json</code></li>
    </ul>

    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Objectif :</strong></p>
    <p style="margin-top: 0; margin-bottom: 0;">identifier la cause, proposer la correction minimale, l’appliquer, puis relancer la commande de build ciblée.</p>
  </div>
</div>

### Contraintes

Les contraintes empêchent l’agent de résoudre le bon problème de la mauvaise manière. Elles peuvent porter sur la compatibilité, la performance, la sécurité, les dépendances, l’API publique, le style, le périmètre ou le niveau de risque acceptable.

Une contrainte utile doit être discriminante. « Faire du code propre » est trop général. « Ne pas introduire de nouvelle dépendance runtime » est exploitable. « Préserver la compatibilité avec Node 20 » est exploitable. « Ne pas modifier le schéma de base de données dans cette tâche » est exploitable.

### Référence de cohérence

Lorsque le résultat doit s’intégrer dans un code existant, le prompt doit nommer un modèle à suivre : une page similaire, un test existant, un composant équivalent, un endpoint de référence, une convention de migration ou un ancien workflow.

Un exemple interne vaut souvent mieux qu’une description abstraite. Il permet à Claude d’aligner le nouveau code sur les conventions réelles du projet au lieu d’appliquer des conventions génériques.

### Vérification

La vérification doit être formulée explicitement. Elle peut être automatique ou manuelle, mais elle doit exister. Pour le code, il s’agit souvent d’un test, d’un typecheck, d’un lint, d’un build ou d’une commande ciblée. Pour une interface, il peut s’agir d’une comparaison avec une capture ou d’une liste d’états visuels attendus. Pour une documentation, il peut s’agir d’une structure, d’un public cible et d’un niveau de détail.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple de formulation de vérification (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <p style="margin-top: 0; margin-bottom: 5px;"><strong>Après modification :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 0;">
      <li>exécuter les tests ciblés liés à <code>PaymentSession</code> ;</li>
      <li>exécuter le typecheck ;</li>
      <li>afficher la liste des fichiers modifiés ;</li>
      <li>expliquer uniquement les changements fonctionnels et les vérifications effectuées.</li>
    </ul>
  </div>
</div>

### Format de sortie

Le format de sortie n’est pas décoratif. Il détermine la manière dont l’utilisateur pourra exploiter le résultat. Une revue de code, un plan d’implémentation, une synthèse d’incident, une spécification, une checklist de migration et un message de commit ne doivent pas avoir la même forme.

Pour les tâches automatisées, le format doit être encore plus strict. En mode non interactif, une sortie JSON, une liste de fichiers, une valeur OK / FAIL ou une structure stable peut être nécessaire pour intégrer Claude Code dans un script ou une CI.

## Décrire le résultat, pas les étapes internes

### Laisser l’agent explorer

La bibliothèque de prompts de Claude Code met en avant une règle simple : décrire le résultat plutôt que les étapes. Cette règle est particulièrement importante parce que Claude Code dispose d’outils d’exploration. Il peut trouver les fichiers, lire les tests, suivre les références et inspecter les commandes disponibles.

Un prompt trop procédural peut réduire la qualité du travail en enfermant l’agent dans une stratégie incorrecte. Si l’utilisateur impose les mauvais fichiers ou la mauvaise séquence d’actions, Claude risque d’optimiser localement autour d’une hypothèse fausse.

Le bon niveau de contrôle consiste à spécifier le résultat et les limites, pas à contrôler chaque geste.

### Quand être directif

Il faut cependant être directif lorsque la tâche contient un risque, une exigence de conformité ou une préférence non déductible du code. Par exemple : ne pas toucher aux migrations, ne pas modifier l’API publique, utiliser un runner de test précis, conserver une compatibilité descendante, ne pas ajouter de dépendance ou produire un format contractuel.

Le prompt doit donc être directif sur les invariants, mais délégatif sur les moyens. C’est cette combinaison qui donne de bons résultats : forte contrainte sur ce qui doit rester vrai, liberté sur l’exploration et l’implémentation.

## Donner les bons artefacts

### Référencer les fichiers avec @

Lorsqu’un fichier, un dossier ou une ressource est pertinent, il vaut mieux le référencer directement. La référence avec `@` évite de décrire approximativement un contenu que Claude peut lire lui-même. Elle réduit aussi les risques de mauvaise localisation.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple de ciblage avec les ressources (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <em>« Analyse <code>@src/auth/session.ts</code> et <code>@src/auth/session.test.ts</code>. »</em>
    
    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Objectif :</strong></p>
    <p style="margin-top: 0; margin-bottom: 15px;">comprendre pourquoi le renouvellement de session échoue après expiration du refresh token.</p>

    <p style="margin-top: 0; margin-bottom: 15px;"><em>Ne modifie rien pour l’instant.</em></p>

    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Retour attendu :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 0;">
      <li>cause probable ;</li>
      <li>fichiers impliqués ;</li>
      <li>test minimal à ajouter avant correction.</li>
    </ul>
  </div>
</div>

### Coller les erreurs et les journaux

Pour le débogage, le prompt doit contenir la sortie réelle : stack trace, erreur de build, message du compilateur, journal CI, capture d’écran, sortie de test ou reproduction exacte. Le détail qui semble secondaire à l’utilisateur peut être précisément celui qui permet à Claude de choisir la bonne piste.

Une erreur paraphrasée force l’agent à reconstituer le problème. Un artefact brut lui donne une observation exploitable.

### Fournir les documents de référence

Pour une intégration externe, une migration d’API ou une fonctionnalité dépendante d’un service, le prompt doit inclure la documentation officielle, le ticket, la spécification produit ou la ressource MCP pertinente. Le prompt ne doit pas seulement dire « fais comme dans la documentation » ; il doit fournir ou pointer la documentation que Claude doit utiliser.

## Prompts, contexte et économie d’attention

### Le contexte est une ressource limitée

Dans Claude Code, le contexte contient l’historique de conversation, les fichiers lus, les sorties d’outils, les instructions système, `CLAUDE.md`, la mémoire, les skills chargés et certains résultats de la boucle. Chaque élément ajouté au contexte peut aider ou nuire.

Un prompt efficace respecte cette contrainte. Il fournit les informations nécessaires, mais évite de saturer la session avec des détails non discriminants. Il distingue le contexte stable, qui doit être mémorisé dans `CLAUDE.md`, du contexte ponctuel, qui doit rester dans le prompt de la tâche.

### Nettoyer plutôt que corriger indéfiniment

Une session longue peut accumuler des tentatives échouées. Après plusieurs corrections sur le même problème, il est souvent préférable de repartir d’un contexte propre avec un prompt plus précis intégrant ce qui a été appris.

La correction répétée n’est pas toujours une amélioration. Elle peut ajouter du bruit. Une meilleure stratégie consiste à condenser l’apprentissage utile, effacer le contexte inutile et reformuler la tâche avec une cible plus stricte.

## Prompt et vérification

### Donner une preuve de réussite

Une bonne demande contient un moyen de vérifier le travail. Pour une correction de bug, il faut une commande de reproduction ou un test ciblé. Pour une refactorisation, il faut un comportement invariant. Pour une migration, il faut une commande de validation. Pour une interface, il faut un état visuel attendu ou une capture de référence.

La vérification transforme le prompt en contrat. Elle donne à la boucle agentique une condition de progression et d’arrêt.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple de prompt complet avec preuve de réussite (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <em>« Refactoriser le calcul des remises sans changer le comportement. »</em>
    
    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Contraintes :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 15px;">
      <li>conserver l’API publique de <code>DiscountCalculator</code> ;</li>
      <li>ne pas modifier les snapshots existants sauf justification ;</li>
      <li>ajouter un test pour les remises cumulées.</li>
    </ul>

    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Vérification :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 0;">
      <li>exécuter le test ciblé de <code>DiscountCalculator</code> ;</li>
      <li>exécuter le typecheck ;</li>
      <li>afficher un résumé du diff.</li>
    </ul>
  </div>
</div>

### Éviter le piège de la plausibilité

Un résultat peut être bien formulé et incorrect. Le prompt doit donc favoriser les observations externes : tests, builds, linters, sorties de commandes, comparaisons, captures, diff, vérification indépendante par subagent.

Plus la tâche est autonome, plus la vérification doit être explicite. Une boucle longue sans critère de vérification augmente le risque qu’un résultat plausible soit accepté trop tôt.

## Explorer avant d’implémenter

### Séparer recherche et modification

Pour les tâches complexes, il est préférable de séparer l’exploration et l’implémentation. Le premier prompt peut demander une analyse, une cartographie du code, une identification des points d’entrée et un plan. Le second prompt peut autoriser la modification après revue du plan.

Cette séparation réduit le risque de modifications prématurées. Elle permet à l’utilisateur de corriger l’analyse avant que le disque ne soit touché.

<div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 20px; color: #166534; font-size: 0.95em; margin: 15px 0;">
  <strong style="font-size: 1.1em;">Exemple de prompt d'exploration sans modification (bonne pratique) :</strong>
  <div style="margin-top: 15px; padding: 15px; background-color: rgba(255,255,255,0.6); border-radius: 8px; border: 1px dashed #86efac;">
    <em>« Explore le sous-système d’authentification sans modifier de fichier. »</em>
    
    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Objectif :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 15px;">
      <li>identifier où sont créés, rafraîchis et invalidés les tokens ;</li>
      <li>repérer les tests existants ;</li>
      <li>proposer un plan pour ajouter la révocation de session.</li>
    </ul>

    <p style="margin-top: 0; margin-bottom: 15px;"><em>Ne fais aucune modification.</em></p>

    <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Retour attendu :</strong></p>
    <ul style="margin-top: 0; line-height: 1.6; padding-left: 20px; margin-bottom: 0;">
      <li>fichiers clés ;</li>
      <li>flux actuel ;</li>
      <li>risques ;</li>
      <li>plan d’implémentation vérifiable.</li>
    </ul>
  </div>
</div>

### Faire produire une spécification avant la session d’implémentation

Pour une fonctionnalité importante, un bon prompt peut demander à Claude d’interroger l’utilisateur avant d’écrire. Le but n’est pas de retarder le travail, mais de produire une spécification autonome : fichiers impliqués, interfaces, exigences, hors périmètre, cas limites, vérification de bout en bout.

Une fois la spécification stabilisée, il est souvent préférable de lancer une session propre d’implémentation qui référence cette spécification. La session d’exécution reçoit alors un contexte plus propre et moins pollué par les discussions préalables.

## Corriger la trajectoire pendant la session

### Corriger tôt

Un prompt initial n’a pas besoin d’être parfait. Claude Code est conversationnel : on peut interrompre, corriger, resserrer le périmètre et réorienter. Mais il faut le faire tôt. Plus une trajectoire incorrecte dure longtemps, plus elle accumule de contexte inutile.

Corriger tôt signifie : arrêter l’exécution lorsque l’agent part dans une mauvaise direction, fournir la contrainte manquante, préciser le périmètre et demander de reprendre à partir de l’état corrigé.

### Réécrire plutôt que surcorriger

Lorsque deux corrections successives échouent sur le même point, le problème n’est souvent plus l’exécution locale. Il est dans la formulation de la tâche, le contexte accumulé ou l’absence de critère vérifiable. Dans ce cas, il faut reformuler le prompt à partir de ce qui a été appris, puis repartir dans une session plus propre.

Un prompt réécrit avec précision vaut mieux qu’une longue conversation saturée d’échecs.

## Prompts en mode non interactif

### Une invite automatisée doit être contractuelle

Avec `claude -p`, le prompt est utilisé dans un contexte non interactif. Il doit donc être plus strict qu’un prompt de session interactive. Il faut définir les entrées, les sorties, les outils autorisés, les erreurs attendues et le format de résultat.

Dans un script, une sortie libre est fragile. Il faut demander une réponse structurée, courte et analysable.

```bash
claude -p "Analyse le fichier indiqué et retourne le résultat sous un format strict."
```

### Limiter les permissions dans les lots

Pour les traitements à grande échelle, le prompt ne suffit pas. Il faut également restreindre les outils autorisés. Une invite de migration exécutée sur des dizaines ou centaines de fichiers doit avoir un périmètre d’action étroit, une sortie stable et une stratégie de vérification.

## Les erreurs typiques de prompting

### Le prompt trop vague
Un prompt trop vague délègue à Claude des décisions que l’utilisateur aurait dû cadrer : périmètre, priorité, niveau de risque, comportement attendu, vérification. Il peut être utile pour une exploration ouverte, mais il est faible pour une tâche de production.

### Le prompt trop procédural
Un prompt trop procédural impose une stratégie avant que l’environnement soit compris. Il peut empêcher Claude d’utiliser correctement ses outils d’exploration. La procédure doit être imposée seulement lorsqu’elle correspond à une contrainte réelle.

### L’absence de vérification
La demande « corrige ce bug » sans reproduction, test, log ou critère de validation force l’agent à conclure sur plausibilité. Une tâche de développement doit autant que possible se terminer par un signal externe.

### Le CLAUDE.md surchargé
Un fichier d’instructions trop long rend les règles importantes moins visibles. Il faut supprimer les évidences, déplacer les workflows conditionnels vers les skills et transformer les règles impératives en hooks, permissions ou tests.

### La confusion entre instruction et contrainte
Une instruction dans un prompt guide le modèle. Elle ne garantit pas l’exécution. Une contrainte qui doit être respectée sans exception doit être soutenue par un mécanisme déterministe : permission, hook, test, CI, sandbox, règle de revue ou format de sortie contrôlé.

```bash
claude -p "Migrer ce fichier vers la nouvelle API sans toucher aux imports externes."
```
