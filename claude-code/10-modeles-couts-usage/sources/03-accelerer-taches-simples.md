Dans Claude Code , /fast sert à activer le mode rapide. Ce mode vise une chose précise : réduire la latence des
réponses lorsque la vitesse compte plus que l'optimisation du coût.

Le mode rapide n'est pas un modèle différent. C'est une configuration haute vitesse pour Claude Opus : il utilise Opus
avec une configuration API qui privilégie la vitesse plutôt que l'efficacité des coûts. Il peut rendre les réponses jusqu'à
environ 2,5 fois plus rapides, avec un coût par jeton plus élevé. Il n'est pas disponible sur Sonnet, Haiku ou les autres
modèles.

Il faut donc éviter une confusion fréquente : /fast ne veut pas dire « modèle léger ». Pour utiliser un modèle plus
économique, on passe plutôt par /model . Pour réduire la profondeur de raisonnement, on passe plutôt
par /effort . /fast , lui, accélère Opus.

Le rôle de /fast

Activer ou désactiver le mode rapide
La commande principale est /fast . Elle permet d'activer ou de désactiver le mode rapide dans la CLI Claude Code . Les
formes /fast on et /fast off sont aussi disponibles.

/fast
/fast on
/fast off

Quand le mode rapide est activé, Claude Code affiche un message de confirmation, et une icône ↯ apparaît à côté de
l'invite. Relancer /fast permet aussi de vérifier l'état courant du mode rapide.

Ce qui se passe lors de l'activation
Si la session est sur un autre modèle, activer /fast peut faire basculer automatiquement la session vers Opus, car le
mode rapide est une configuration Opus. Désactiver ensuite le mode rapide ne ramène pas automatiquement au modèle
précédent : la session reste sur Opus. Pour revenir à un autre modèle, il faut utiliser /model .

/fast
/model sonnet

Ce comportement est important en pratique. Si vous activez /fast pour une phase courte, puis que vous voulez revenir à
un mode plus économique, il faut penser à changer explicitement le modèle après la désactivation.

Quand utiliser /fast

Itération rapide
/fast est adapté aux tâches interactives où l'attente entre deux tours gêne le travail. Les usages typiques incluent
l'itération rapide sur les modifications de code, le débogage en direct et les tâches sensibles au temps.

/fast on
Nous allons itérer rapidement sur cette erreur.
Lis la sortie du test ciblé.
Propose une correction minimale.
Relance uniquement le test ciblé.

Dans ce type de session, la vitesse permet de garder un rythme de travail fluide. Le gain vient moins d'une réduction du
nombre de tours que d'une réduction du temps d'attente entre les tours.

Débogage en direct
Le mode rapide est particulièrement utile lorsque vous surveillez un problème en direct : serveur local, test ciblé, erreur
reproduite manuellement, comportement UI, log qui change ou correction à valider immédiatement.

/fast on
Aide-moi à déboguer cette erreur en direct.
Reste sur le périmètre actuel.
Ne lis pas tout le projet.
À chaque tour, propose la prochaine vérification min

Dans un débogage en direct, la latence a une valeur opérationnelle. Si chaque aller-retour prend trop longtemps,
l'utilisateur perd le fil de la reproduction, du terminal, du navigateur ou du serveur local.

Tâches simples mais urgentes
/fast peut aussi servir sur des tâches simples lorsque le délai compte : expliquer une erreur, relire une petite diff,
reformuler une commande, vérifier un comportement local ou produire un résumé court.

/fast on
Explique rapidement cette erreur.
Ne propose pas encore de modification.
Donne seulement la cause probable et la prochaine vé

Dans ce cas, /fast n'est pas utilisé parce que la tâche est intellectuellement difficile, mais parce que l'interaction doit être
rapide.

Quand éviter /fast

Tâches longues autonomes
Le mode standard est préférable pour les tâches autonomes longues, le traitement par lots, les pipelines CI/CD et les
charges sensibles au coût.

Sur une tâche longue, l'utilisateur n'attend pas nécessairement chaque tour en direct. Le gain de latence devient moins
important que le coût total de la trajectoire. Dans ce cas, il vaut mieux choisir soigneusement le modèle, l'effort, le nombre
de tours, le périmètre et les vérifications.

Travail sensible au coût
/fast a un coût par jeton plus élevé que le mode Opus standard. La tarification par MTok est plus élevée pour le mode
rapide, avec un tarif différent selon la version Opus prise en charge. La tarification et la disponibilité peuvent évoluer, car le
mode rapide est en aperçu de recherche.

Le mode rapide doit donc être activé pour une raison claire. Si le coût compte plus que la latence, le mode standard est
préférable.

Session déjà très longue
La première activation du mode rapide dans une conversation peut entraîner un coût complet sur tout le contexte d'entrée
non mis en cache de la conversation. Plus vous activez le mode rapide tard dans une conversation, plus cette première
activation peut coûter cher. Mieux vaut donc l'activer au début d'une session pour une meilleure efficacité des coûts. Ce
coût ne s'applique qu'une seule fois par conversation : désactiver puis réactiver le mode rapide ensuite ne le facture pas
de nouveau.

Si une session est déjà longue, il faut réfléchir avant d'activer /fast . Dans certains cas, mieux vaut faire /clear , rédiger
un brief propre, puis activer /fast au début de la nouvelle session.

/clear debug-auth-rapide
/fast on

/fast , /model et /effort
Ne pas confondre les trois réglages
/model , /effort et /fast agissent sur des dimensions différentes. /model choisit la famille de
capacité. /effort règle la profondeur de raisonnement. /fast réduit la latence sur Opus au prix d'un coût par jeton plus
élevé. La différence avec l'effort est nette : le mode rapide conserve la même qualité de modèle avec une latence
inférieure et un coût plus élevé, tandis qu'un effort inférieur réduit le temps de réflexion avec une qualité potentiellement
plus faible sur les tâches complexes.

Réglage Ce qu'il modifie Risque principal
/model Le modèle actif Choisir une capacité inadéquate pour la tâche
/effort La profondeur de raisonnement Réduire trop le raisonnement sur une tâche complexe
/fast La latence sur Opus Augmenter le coût sans nécessité

Combiner /fast et un effort plus bas
Pour une tâche simple, il est possible de combiner le mode rapide avec un niveau d'effort bas ou moyen : les deux
réglages sont indépendants, et cette combinaison peut maximiser la vitesse là où la profondeur de raisonnement n'est pas
critique.

/fast on
/effort low
Réponds rapidement.
Ne modifie rien.
Donne seulement l'explication la plus probable.

Cette combinaison doit rester réservée aux tâches simples. Pour un debugging profond, une migration ou une décision
d'architecture, réduire l'effort peut dégrader l'analyse.

Utiliser un modèle fort pour planifier, puis accélérer l'itération
Un pattern utile consiste à utiliser un modèle fort pour le plan ou la revue, puis à passer dans un mode plus rapide pour
l'itération si le coût et la politique d'organisation le permettent.

/model opus
/effort high
Prépare le plan.
Ne modifie aucun fichier.
Identifie la vérification minimale.

/fast on
Applique maintenant le plan validé.
Garde le diff minimal.
Relance uniquement le test ciblé.

Ce pattern n'est pas obligatoire. Il est utile lorsque la phase de décision est plus difficile que la phase d'exécution, et
lorsque la latence devient le facteur limitant pendant l'implémentation.

Disponibilité et limites

Disponibilité réelle
Le mode rapide nécessite une version récente de Claude Code , il est disponible pour les utilisateurs Claude Code sur les
plans d'abonnement et Claude Console, mais il n'est pas disponible sur certains fournisseurs tiers comme Bedrock, Vertex
AI, Azure Foundry ou Claude Platform sur AWS. Il n'est pas non plus pris en charge dans l'extension VS Code.

Il faut donc vérifier la disponibilité réelle au moment de l'utilisation. Selon l'organisation, le plan, le fournisseur, la version ou
les restrictions de modèles, /fast peut ne pas être disponible.

Restrictions d'organisation
Une organisation peut restreindre les modèles disponibles avec availableModels . Si activer /fast implique de basculer
vers un modèle Opus non autorisé, la commande est refusée. Les modèles exclus sont masqués du sélecteur, et
l'activation du mode rapide est refusée lorsque le modèle cible est hors liste d'autorisation.

{
 "$schema": "https://json.schemastore.org/claude-co
 "availableModels": ["sonnet", "haiku"]
}

Dans cet exemple, une organisation qui n'autorise pas Opus empêche implicitement l'usage de /fast , puisque le mode
rapide repose sur Opus.

Sur les plans Team et Enterprise, le mode rapide est désactivé par défaut : un administrateur doit l'activer avant que les
utilisateurs puissent y accéder. Tant que ce n'est pas fait, /fast affiche un message indiquant que le mode rapide a été
désactivé par l'organisation. Pour le couper entièrement, on peut aussi définir la variable
d'environnement CLAUDE_CODE_DISABLE_FAST_MODE=1 .

Crédits et limites de taux
Pour les plans d'abonnement, le mode rapide utilise les crédits d'utilisation et n'est pas inclus dans les limites de taux
d'abonnement. Le mode rapide possède aussi des limites de taux séparées. Quand ces limites sont atteintes ou que les
crédits sont insuffisants, le mode rapide revient temporairement à la vitesse standard, puis se réactive automatiquement
après refroidissement. Pendant ce refroidissement, l'icône ↯ apparaît grisée.

Le mode rapide doit donc être surveillé comme une ressource payante et limitée. Il ne suffit pas de l'activer
globalement et de l'oublier.

Configuration persistante

Activer le mode rapide dans les paramètres utilisateur
Le mode rapide peut être activé avec /fast , ou défini via fastMode dans le fichier de paramètres utilisateur. Par défaut,
la préférence persiste entre les sessions.

{
 "$schema": "https://json.schemastore.org/claude-co
 "fastMode": true
}

Cette configuration doit être utilisée avec prudence. Elle rend le mode rapide plus facile à oublier, surtout si vous travaillez
souvent sur des tâches longues ou sensibles au coût.

Exiger une activation par session
Les administrateurs peuvent configurer fastModePerSessionOptIn pour que chaque session commence avec le mode
rapide désactivé, même si la préférence utilisateur est enregistrée. Ce réglage est utile pour contrôler les coûts dans les
organisations où les utilisateurs lancent plusieurs sessions simultanées.

{
 "$schema": "https://json.schemastore.org/claude-co
 "fastModePerSessionOptIn": true
}

Ce réglage est préférable dans un environnement d'équipe. Il force l'utilisateur à décider explicitement que la vitesse vaut
le coût pour la session courante.

Protocole recommandé

Tâche simple et rapide
/fast on
/effort low
Explique cette erreur.
Ne modifie rien.
Retourne seulement la cause probable et une vérifica

Débogage interactif
/fast on
/effort high
Nous allons déboguer en direct.
Reste sur le test ciblé.
Ne lance pas toute la suite.
Après chaque commande, propose seulement la prochain

Retour au mode standard
/fast off
/model sonnet

Ce retour est volontairement en deux étapes. Désactiver /fast retire la configuration haute vitesse, mais ne revient pas
automatiquement au modèle précédent. Si vous voulez quitter Opus, utilisez /model .

Session sensible au coût
/fast off
/effort medium
Travaille avec un budget réduit.
Lis seulement les fichiers explicitement nécessaires
Ne lance que les tests ciblés.
Arrête-toi avant toute exploration large.

Erreurs fréquentes

Croire que /fast est un modèle économique
/fast accélère Opus avec un coût par jeton plus élevé. Pour économiser, il faut plutôt choisir un modèle plus adapté
avec /model , réduire l'effort avec /effort , limiter le contexte ou réduire le nombre d'outils appelés.

Activer /fast trop tard dans une longue session
Activer le mode rapide tard dans une conversation peut coûter davantage, car la première activation dans la conversation
peut s'appliquer à tout le contexte d'entrée non mis en cache. Pour une session prévue comme rapide, activez /fast tôt,
ou repartez avec /clear et un brief propre.

Oublier que /fast off ne revient pas au modèle précédent
Après désactivation, la session reste sur Opus. Si l'objectif est de revenir à un modèle plus économique ou plus standard,
utilisez explicitement /model .

Utiliser /fast pour masquer un mauvais contexte
Le mode rapide réduit la latence, mais il ne nettoie pas le contexte. Si la session est polluée, longue ou contradictoire,
utilisez plutôt /context , /compact , /clear ou /rewind .

Utiliser /fast pour une tâche longue autonome
Si vous lancez une tâche longue que vous ne surveillez pas en direct, la latence devient moins importante. Dans ce cas, il
vaut mieux contrôler le budget, le nombre de tours, le nombre d'agents, les outils disponibles et les vérifications.
