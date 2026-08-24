Une tâche longue ne coûte pas seulement parce qu'elle utilise un modèle puissant. Elle coûte parce qu'elle accumule du
contexte, multiplie les tours, appelle des outils, lance des sous-agents, active des workflows, charge des skills, interroge
des serveurs MCP ou produit de longues sorties de commandes.

Le coût réel est celui de la trajectoire complète. Ne regardez pas uniquement le coût d'un message. Une tâche devient
chère parce qu'elle itère trop, lit trop large, corrige plusieurs mauvaises pistes, lance trop d'agents, ou laisse un workflow
dynamique explorer sans budget clair.

Les coûts augmentent avec la taille du contexte, et les leviers sont connus : gérer le contexte, choisir le modèle adapté,
limiter la surcharge MCP , ajuster l'effort, déléguer correctement les sorties volumineuses et surveiller l'utilisation avec les
commandes dédiées. Les workflows dynamiques, les sous-agents, les plugins et les serveurs MCP sont des capacités
puissantes, mais aussi des multiplicateurs de coût.

Pourquoi les workflows longs coûtent plus

Le nombre de tours
Un tour correspond à une itération où Claude répond, demande éventuellement des outils, reçoit leurs résultats, puis
continue. Une tâche simple prend un ou deux tours. Une migration, un audit, une recherche avec vérification ou une
correction complexe enchaînent de nombreux tours. La boucle continue jusqu'à ce que Claude produise une réponse
sans appel d'outil, ou jusqu'à atteindre une limite : un nombre maximal de tours ou un budget maximal.

Plus le nombre de tours augmente, plus les coûts augmentent. Chaque tour peut relire du contexte, appeler des outils,
produire des sorties et déclencher d'autres décisions. Une session longue doit donc avoir une condition d'arrêt explicite.

La taille du contexte
Le contexte est la ressource centrale. Une session qui a lu de nombreux fichiers, reçu de longs logs, chargé des
instructions, accumulé des résultats d'outils et conservé des corrections ratées devient plus chère à chaque tour. Le coût
ne vient pas seulement de l'information nouvelle : il vient aussi du contexte ancien que le modèle doit encore traiter.

Un contexte inutile est un coût récurrent. Une sortie de test massive, une exploration abandonnée ou une discussion
latérale qui reste dans la session continue de peser sur les tours suivants.

Les outils et leurs sorties
Les outils réduisent l'incertitude, mais ils produisent aussi du contexte. Une commande de test ciblée est utile. Une
commande récursive sans limite, un log complet ou une recherche trop large produisent un volume disproportionné.

Avant de lancer une commande :
- propose la version la plus ciblée ;
- évite les sorties longues ;
- filtre les logs si possible ;
- ne lis pas les dossiers générés ;
- arrête-toi si le résultat dépasse le besoin de la tâche.

Le bon réflexe n'est pas d'interdire les outils, mais de les contraindre. Un outil doit produire une observation utile, pas
remplir la fenêtre de contexte.

Sous-agents, workflows et équipes d'agents

Les sous-agents
Un sous-agent dispose de sa propre fenêtre de contexte. C'est utile pour isoler une recherche volumineuse : le sous-agent
lit, cherche, analyse, puis renvoie un résumé à la conversation principale. Cette architecture protège le contexte parent,
mais elle ne rend pas la recherche gratuite.

Un sous-agent consomme ses propres tokens. Il est donc approprié lorsque l'isolation justify le coût : recherche large,
revue spécialisée, vérification indépendante, analyse secondaire ou exploration d'un sous-système.

Utilise un seul sous-agent pour explorer le module auth.
Contraintes :
- lecture seule ;
- pas de modification ;
- rapport court ;
- fichiers réellement consultés ;
- incertitudes restantes ;
- aucune sortie brute volumineuse.

Le sous-agent est un outil de confinement du contexte, pas une réduction automatique du coût total.

Les workflows dynamiques
Les workflows dynamiques orchestrent de nombreux sous-agents à partir d'un script que Claude écrit et que le runtime
exécute en arrière-plan. Ils conviennent aux audits de base de code, aux migrations importantes et aux recherches avec
vérification croisée. La vue /workflows affiche chaque phase, le nombre d'agents, le total des tokens et le temps écoulé.

Réservez un workflow aux tâches où une simple conversation ne suffit pas : audit large, migration de nombreux fichiers,
recherche indépendante sur plusieurs angles, revue croisée, ou plan complexe à examiner sous plusieurs perspectives.

Une correction locale ne justifie pas un workflow dynamique. Un workflow a un coût de coordination : il lance des
phases, des agents, des vérifications et parfois des explorations que vous devez surveiller.

ultracode combine un effort de raisonnement élevé avec l'orchestration automatique de workflows pour les tâches
substantielles. Avec ultracode activé, une seule demande peut devenir plusieurs workflows successifs : comprendre le
code, faire le changement, puis vérifier. Cela utilise plus de tokens et prend plus de temps que les niveaux d'effort
inférieurs.

Activez ultracode pour une raison précise. Il convient à un audit, une migration, une recherche avec vérification croisée
ou une tâche qui mérite une orchestration multi-phase. Il ne doit pas rester activé par inertie pendant du travail courant.

Après une phase lourde, revenez explicitement à un niveau d'effort plus ordinaire.

Les équipes d'agents
Les équipes d'agents et les workflows peuvent multiplier fortement les tokens, car plusieurs agents travaillent avec leurs
propres contextes et leurs propres tours. Une équipe d'agents peut consommer environ sept fois plus de tokens qu'une
session standard lorsque les coéquipiers s'exécutent en mode plan.

Réservez ce type d'orchestration aux tâches dont la valeur justifie la dépense : revue critique, sécurité, architecture,
migration large, audit ou recherche nécessitant une validation croisée.

Les autres multiplicateurs de coût

MCP
Les serveurs MCP ajoutent des outils et des ressources externes. Ils réduisent le travail manuel, mais augmentent la
surface disponible. Un serveur connecté expose des outils, des schémas, des ressources et parfois des résultats
volumineux. Désactivez les serveurs inutilisés avec /mcp et limitez les outils externes à ce qui est nécessaire.

Un serveur MCP inutile est un coût potentiel et une surface de risque. Connectez ce qui sert réellement à la tâche, pas tout
ce qui est disponible.

Plugins
Un plugin peut charger des skills, des agents, des hooks, des serveurs MCP , des serveurs LSP ou d'autres composants.
Recharger des plugins annonce de nouveaux composants dans la conversation et a un coût en tokens sur la demande
suivante. Un plugin qui apporte des serveurs MCP est encore plus coûteux si ses outils ne sont pas différés par recherche
d'outils.

Chargez les plugins nécessaires au projet, puis désactivez ce qui n'est pas utilisé. Une configuration riche mais inactive
complique la session et augmente le contexte.

Skills
Les skills réduisent au contraire les coûts quand elles remplacent des prompts longs répétés. Le corps d'une skill ne se
charge que lorsqu'elle est utilisée, ce qui rend les longues procédures de référence presque gratuites tant qu'elles ne sont
pas invoquées.

Une skill bien conçue économise du contexte. Elle évite de coller les mêmes instructions dans chaque session et limite la
répétition d'explications longues dans CLAUDE.md .

Hooks
Les hooks aident à contrôler les coûts lorsqu'ils filtrent ou synthétisent des sorties avant qu'elles n'entrent dans le contexte.
Un hook peut par exemple ne retourner que les erreurs d'un test au lieu de tout le journal.

Un hook doit rester proportionné. Filtrer un log est économique ; lancer une vérification lourde et multi-tours à chaque
événement de session devient coûteux.

Budgéter un workflow avant de le lancer

Définir le périmètre
Un workflow long commence par un périmètre écrit. Sans périmètre, Claude peut explorer trop large, déléguer trop de
sous-tâches ou chercher des validations inutiles.

Avant de lancer le workflow :
- limite l'analyse à src/auth et src/middleware ;
- ignore les dossiers legacy ;
- ne lis pas les fichiers générés ;
- n'utilise pas plus de deux agents ;
- ne modifie aucun fichier sans plan validé ;
- retourne un rapport court avec preuves et incertitudes.

Cette consigne agit comme un budget qualitatif. Elle réduit le risque qu'un workflow se transforme en exploration ouverte.

Définir le nombre de tours
En mode non interactif ou via le SDK, vous pouvez limiter le nombre de tours. Le paramètre maxTurns (ou max_turns )
limite les allers-retours d'utilisation d'outils, et la CLI fournit l'option --max-turns pour le mode impression.

Le principe est simple : une exécution scriptée doit avoir une limite de tours. Une tâche ouverte comme « améliore cette
base de code » sans limite peut tourner longtemps et consommer beaucoup.

Définir un budget maximal
Le SDK permet aussi de définir un budget maximal en dollars avec maxBudgetUsd (ou max_budget_usd ), et la CLI fournit
l'option --max-budget-usd pour le mode impression. La boucle s'arrête lorsque le seuil est atteint, au lieu de laisser la
session décider seule ; le résultat porte alors un sous-type d'erreur dédié ( error_max_turns ou error_max_budget_usd ).

Pour une automatisation, un budget explicite est une bonne valeur par défaut. Sans budget, une tâche ouverte peut
consommer jusqu'à ce qu'elle termine, échoue ou atteigne une autre limite.

Définir les agents autorisés
Si la tâche peut lancer des sous-agents, précisez leur nombre et leur rôle.

Budget d'agents :
- un agent pour explorer ;
- un agent pour relire ;
- aucun agent supplémentaire sans validation ;
- chaque agent doit retourner un résumé en dix lignes maxim

Cette contrainte évite qu'une tâche se transforme en arbre de délégation difficile à surveiller.

Surveiller un workflow pendant l'exécution

/workflows
/workflows ouvre la vue de progression des workflows en cours ou terminés. Elle affiche les phases, les agents, les
tokens et le temps écoulé, et permet d'explorer le détail d'une exécution.

Cette commande est essentielle pour les workflows longs. Elle montre si le coût vient d'une phase précise, d'un agent trop
actif ou d'une recherche trop large.

/tasks et /agents
Les workflows s'exécutent en arrière-plan. /tasks liste ce qui s'exécute en arrière-plan dans la session actuelle, tandis
que /agents gère les sous-agents configurés.

/tasks sert à surveiller l'exécution ; /agents sert à gérer les configurations d'agents disponibles. Les deux ne répondent
pas au même besoin.

/usage et /context
Pendant une tâche longue, /usage et /context restent les commandes de diagnostic centrales. La première montre
l'utilisation et les limites ; la seconde montre où part la fenêtre de contexte.

Si la consommation augmente rapidement, diagnostiquez avant de poursuivre : modèle trop coûteux, effort trop élevé, trop
d'agents, trop de MCP , sortie trop longue, contexte trop lourd ou tâche mal découpée.

Réduire le coût sans perdre la qualité

Choisir le bon modèle pour chaque phase
Chaque agent utilise le modèle de la session, sauf si le script route une étape vers un autre modèle. Vérifiez /model avant
une exécution importante, et demandez un modèle plus petit pour les étapes qui n'ont pas besoin du modèle le plus fort.

Le pattern utile est simple : modèle fort pour la planification ou la revue critique, modèle plus économique pour les étapes
mécaniques si l'organisation l'autorise et si la vérification est robuste.

Ajuster l'effort
Un effort élevé réduit le nombre d'itérations sur une tâche difficile, mais augmente souvent le coût par tour. Utilisez-le
quand la difficulté vient réellement du raisonnement : architecture, debugging profond, migration ambiguë, revue sécurité
ou workflow de vérification croisée.

Pour les tâches ordinaires, un effort modéré ou élevé standard suffit. Pour les tâches substantielles, ultracode peut être
justifié, mais il doit être encadré.

Nettoyer le contexte entre phases
Après une phase d'exploration, produisez un brief, puis repartez sur une session plus propre avant l'implémentation.

Prépare un brief de transition :
- objectif ;
- fichiers concernés ;
- décisions prises ;
- risques ;
- tests à exécuter ;
- prochaines actions minimales.
/clear implementation-auth

Un brief écrit coûte souvent moins cher qu'une longue continuité bruitée. Il donne plus de contrôle qu'une session qui
traîne toutes les hypothèses, erreurs et sorties de l'exploration.

Limiter les sorties
Filtrez ou résumez les sorties longues avant qu'elles n'entrent dans la conversation. Un test ciblé, un log filtré ou une
recherche limitée vaut mieux qu'une sortie massive.

Pour chaque commande :
- préfère une commande ciblée ;
- retourne seulement les erreurs ;
- évite les sorties verbeuses ;
- ne colle pas tout le log si une synthèse suffit.

Protocoles recommandés

Audit de base de code
/usage
/context
/effort ultracode
Objectif : auditer les contrôles d'accès dans src/routes et src/middle
Budget :
- lecture seule ;
- deux phases maximum ;
- deux agents maximum ;
- pas de modification ;
- rapport final avec fichiers, preuves et incertitudes ;
- arrêt si le périmètre doit dépasser les dossiers indiqués

Ce protocole encadre l'orchestration : il rend ultracode proportionné à la tâche.

Migration large
/model
/usage
Prépare un plan de migration avant toute exécution.
Budget :
- lire uniquement les fichiers nécessaires ;
- proposer des lots indépendants ;
- limiter chaque lot à un périmètre clair ;
- exécuter les tests ciblés par lot ;
- arrêter après le premier lot si une hypothèse structurante est fausse.

Une migration longue doit être découpée. Une seule session ouverte qui modifie tout le dépôt sans point d'arrêt est difficile
à contrôler et souvent coûteuse.

Recherche avec vérification croisée
/workflows
Recherche :
- séparer les angles d'analyse ;
- vérifier les affirmations entre agents ;
- filtrer les conclusions non confirmées ;
- citer les preuves dans le rapport ;
- ne pas inclure les notes intermédiaires longues.

Ce type de tâche justifie un workflow, car la vérification croisée a une valeur propre qu'une correction locale n'a pas.

Session qui devient trop coûteuse
/usage
/context
La session devient coûteuse.
Diagnostique :
- contexte inutile ;
- fichiers trop nombreux ;
- sorties trop longues ;
- agents actifs ;
- serveurs MCP utilisés ;
- plugins ou skills chargés ;
- modèle et effort actifs.
Propose une réduction avant de continuer.

Le diagnostic précède la continuation. Ajouter des crédits ou augmenter le budget sans comprendre la cause ne résout pas
le problème de fond.

Quand désactiver ou limiter

Désactiver les workflows dynamiques
Les workflows se désactivent dans /config , avec disableWorkflows dans les paramètres, ou avec une variable
d'environnement. Une fois les workflows désactivés, les commandes de workflow groupées ne sont plus disponibles, le
mot-clé ultracode ne déclenche plus d'exécution, et ultracode est retiré du menu /effort .

{
 "$schema": "https://json.schemastore.org/claude-code-sett
 "disableWorkflows": true
}

Ce réglage évite que des utilisateurs déclenchent des workflows lourds par accident.

Désactiver le déclenchement par mot-clé
Le paramètre workflowKeywordTriggerEnabled contrôle si le mot-clé ultracode dans un prompt déclenche un workflow
dynamique. Le mettre à false désactive seulement le déclenchement par mot-clé ; le niveau d'effort ultracode , /workflows et les workflows enregistrés restent accessibles.

{
 "$schema": "https://json.schemastore.org/claude-code-sett
 "workflowKeywordTriggerEnabled": false
}

Ce réglage évite un déclenchement involontaire tout en conservant les workflows accessibles explicitement.

Erreurs fréquentes

Lancer un workflow pour une tâche locale
Un workflow dynamique n'est pas nécessaire pour corriger une fonction, ajouter un test local ou relire une petite diff. Dans
ces cas, une session normale avec un modèle adapté, un effort approprié et un test ciblé est plus économique.

Oublier de surveiller /workflows
Un workflow en arrière-plan doit être surveillé. La vue /workflows montre les phases, les agents, les tokens et le temps
écoulé. Ne pas la consulter revient à laisser l'orchestration consommer sans tableau de bord.

Multiplier les sous-agents sans rôle clair
Un sous-agent doit avoir une tâche définie. Trois sous-agents qui enquêtent sur le même périmètre sans différence claire
produisent du coût et des résumés redondants.

Charger trop de MCP
Chaque serveur MCP ajoute une surface d'action. Gardez les serveurs nécessaires, désactivez les autres, et vérifiez
avec /mcp avant une tâche coûteuse.

Confondre budget et qualité
Un budget élevé ne garantit pas une meilleure solution. Il autorise seulement une trajectoire plus longue ou plus coûteuse.
La qualité dépend du cadrage, du modèle, de l'effort, du contexte et de la vérification.

Continuer après plusieurs échecs
Si une tâche échoue plusieurs fois, le bon choix est souvent /clear avec un meilleur brief plutôt qu'un budget plus élevé.
Une session polluée coûte cher sans progresser.

Table de décision

| Situation | Décision recommandée | Raison |
|---|---|---|
| Correction locale | Session normale, test ciblé, effort raisonnable | Le coût d'orchestration n'est pas justifié. |
| Debugging complexe | Modèle fort, effort élevé, périmètre limité | Le raisonnement est la difficulté principale. |
| Audit large | Workflow dynamique avec budget écrit | La tâche justifie plusieurs agents et une vérification croisée. |
| Migration de nombreux fichiers | Lots indépendants, worktrees, limites de tours et vérification par lot | Le travail doit être découpé pour rester contrôlable. |
| Recherche volumineuse | Sous-agent ou workflow, résumé court au parent | Le contexte principal doit rester propre. |
| Session coûteuse sans progrès | /usage , /context , puis /clear ou /rewind | Le problème vient de la trajectoire ou du contexte. |
| Automatisation non interactive | Budget maximal, tours maximaux, outils limités | Une tâche scriptée doit avoir des bornes explicites. |
