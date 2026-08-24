Le suivi des coûts fait partie du pilotage quotidien de l'agent, pas d'une comptabilité séparée. Une session reste économique si elle est courte, ciblée et vérifiable. Elle devient coûteuse dès qu'elle lit trop de fichiers, accumule du contexte, lance plusieurs sous-agents, déclenche des workflows dynamiques ou interagit avec de nombreux serveurs MCP.
Le coût d'une session ne dépend pas seulement du modèle. Il dépend de la taille du contexte, du nombre de tours, des sorties d'outils, des tests lancés, des sous-agents, des plugins, des skills, des serveurs MCP, des équipes d'agents, du niveau d'effort et du mode rapide. Les coûts augmentent avec la taille du contexte, et les leviers sont connus : gérer le contexte, choisir le bon modèle, réduire la surcharge MCP, ajuster l'effort et déléguer les sorties volumineuses aux sous-agents.

Les commandes de suivi
/usage
/usage est la commande principale. Elle affiche le coût de la session, les limites d'utilisation du plan et les statistiques d'activité. Sur les plans Pro, Max, Team et Enterprise, elle affiche aussi une ventilation de l'utilisation par skill, sous-agent, plugin et serveur MCP. /cost et /stats sont des alias de /usage qui ouvrent des onglets spécifiques du même écran.
/usage répond à trois questions : combien la session consomme, où part l'utilisation, et quelle limite approche. Lancez-la avant une tâche longue, après une session lourde, ou dès qu'un comportement devient inhabituellement coûteux.

/cost
/cost ouvre /usage directement sur l'onglet coût. C'est le même écran et la même logique de suivi, avec une entrée plus rapide quand vous cherchez le coût de la session.
/usage reste la commande de référence, et /cost un raccourci de confort vers le même écran.

/stats
/stats ouvre /usage sur l'onglet orienté statistiques. Utilisez-le quand vous voulez regarder les statistiques d'activité plutôt que le coût immédiat.

Ce n'est pas un système de mesure indépendant : c'est le même écran que /usage, ouvert sur les statistiques.

/usage-credits
/usage-credits configure les crédits d'utilisation quand vous atteignez une limite ou voulez travailler au-delà de l'allocation de base. Sur les plans Pro et Max, elle permet notamment de définir une limite de dépense mensuelle sur les crédits ; si vous atteignez cette limite alors qu'il reste des crédits, Claude Code propose de l'ajuster sans quitter la CLI.
Cette commande s'appelait auparavant /extra-usage. L'ancien nom fonctionne encore comme alias, ce qui explique sa présence dans d'anciennes installations et configurations ; le nom actuel est /usage-credits.

/insights
/insights génère un rapport d'analyse sur vos sessions Claude Code : domaines de projet, modèles d'interaction et points de friction. Ce n'est pas un écran de facturation, mais un outil pour comprendre comment vous travaillez avec Claude Code.
/usage mesure l'utilisation ; /insights analyse les comportements. Une session peut être coûteuse parce qu'elle est longue, et /insights aide à comprendre pourquoi : corrections répétées, recherches trop larges, ou mauvais découpage des tâches.

Lire correctement /usage
Le bloc Session
Le bloc Session affiche les statistiques de la session courante : tokens, durée API, durée réelle, coût estimé et, parfois, changements de code. Le chiffre en dollars est une estimation calculée localement à partir des décomptes de tokens : il peut différer de la facture réelle. Pour une facturation fiable, consultez la Console Claude ou le fournisseur d'API concerné.
Le coût affiché localement est un instrument de pilotage, pas une facture officielle. Il sert à détecter une session anormalement chère, mais pas à tenir une comptabilité d'équipe.

Limites du plan
Pour les abonnés Claude Pro, Max, Team ou Enterprise, /usage affiche les barres d'utilisation du plan et les statistiques d'activité. Les chiffres de ventilation sont approximatifs, calculés depuis l'historique local de la machine ; ils n'incluent pas l'utilisation faite sur d'autres appareils ou sur claude.ai.
/usage donne donc une bonne lecture locale de la session et de la machine, mais ne remplace pas un tableau de bord organisationnel ou une console de facturation.

Ventilation par composant
Sur les plans compatibles, /usage attribue l'utilisation récente aux skills, sous-agents, plugins et serveurs MCP, chacun affiché en pourcentage du total. Cette ventilation demande une version récente de Claude Code.
Elle sert à identifier les sources de coût : un serveur MCP très utilisé, une skill trop longue, un subagent trop général ou un plugin qui charge beaucoup de contexte expliquent souvent une consommation élevée.

Coûts et limites ne signifient pas la même chose
Coût
Le coût correspond à la consommation estimée ou facturée. En usage API, la facturation dépend des tokens. Sur les plans d'abonnement, une partie de l'utilisation est incluse dans le plan, et /usage affiche plutôt les limites, barres d'utilisation et statistiques pertinentes pour l'abonné.
La lecture pertinente dépend donc du mode d'authentification : abonnement Claude, Console API, Bedrock, Vertex, Foundry ou passerelle LLM d'entreprise.

Limite
Une limite correspond à une allocation d'utilisation ou à une limite de taux. Quand une limite de session, de semaine ou de modèle est atteinte, Claude Code peut bloquer les demandes jusqu'à l'heure de réinitialisation. Trois options alors : attendre la réinitialisation, exécuter /usage pour voir les limites, ou utiliser /usage-credits si des crédits d'utilisation sont disponibles.
Le coût peut être acceptable alors que la limite est atteinte. Inversement, une session peut rester sous la limite tout en étant trop coûteuse pour la politique de l'équipe.

Crédits d'utilisation
/usage-credits configure les crédits d'utilisation pour continuer après certaines limites. Le contexte étendu 1M en est un cas particulier : si le modèle sélectionné utilise une fenêtre 1M qui nécessite des crédits, Claude Code peut demander de les activer avec /usage-credits, ou de revenir à une variante de modèle à contexte standard via /model.
Les crédits d'utilisation ne servent donc pas seulement à « acheter plus ». Ils peuvent être nécessaires pour certaines capacités, selon le plan, le modèle et le contexte sélectionnés.

Ce qui rend une session coûteuse
Le contexte
Le coût augmente avec la taille du contexte. Plus Claude doit traiter d'historique, de fichiers lus, de sorties d'outils, de règles, de mémoire, de skills et de résultats intermédiaires, plus la session consomme de tokens. Nettoyez entre tâches avec /clear, compactez avec des instructions ciblées, et surveillez le contexte avec /usage ou la ligne d'état.
Le contexte obsolète a un coût récurrent. Il n'est pas payé une seule fois : il peut être retraité à chaque tour suivant.

Le modèle et l'effort
Choisissez le modèle selon la tâche : Sonnet couvre la plupart des tâches de codage et coûte moins qu'Opus, qu'il vaut mieux réserver aux décisions architecturales complexes ou au raisonnement multi-étapes. Les tokens de réflexion sont facturés comme des tokens de sortie, et un budget de réflexion peut représenter des dizaines de milliers de tokens selon le modèle.
Le modèle le plus puissant et l'effort maximal ne sont donc pas toujours le bon réglage. Pour une tâche simple, un modèle plus économique et un effort plus bas suffisent. Pour une décision critique, un modèle plus fort réduit les corrections ultérieures.

Les serveurs MCP
Les serveurs MCP ajoutent des capacités, mais aussi une surface de contexte. Leurs définitions d'outils sont différées par défaut : seuls les noms d'outils entrent initialement en contexte, jusqu'à l'utilisation d'un outil spécifique. Préférez les outils CLI quand ils suffisent, et désactivez les serveurs MCP inutilisés avec /mcp.
Un serveur MCP utile réduit le travail manuel ; un serveur MCP inutile ajoute du bruit et parfois du coût.

Les sous-agents et équipes d'agents
Les sous-agents réduisent la pression sur le contexte principal : leurs sorties détaillées restent dans leur propre contexte, et seul un résumé revient à la conversation principale. Ils consomment toutefois leurs propres tokens. Pour les équipes d'agents, chaque coéquipier maintient sa propre fenêtre de contexte, et l'utilisation des tokens augmente avec le nombre de coéquipiers actifs et leur durée d'exécution. Une équipe d'agents peut consommer environ 7 fois plus de tokens qu'une session standard lorsque les coéquipiers s'exécutent en mode plan.
Déléguer une recherche volumineuse à un sous-agent protège le contexte principal ; multiplier les agents sans budget explicite augmente fortement le coût total.

Les hooks, skills et plugins
Les hooks réduisent les coûts quand ils prétraitent des données avant que Claude les voie. Par exemple, un hook peut filtrer une sortie de tests pour ne retourner que les échecs. Les skills réduisent l'exploration répétée en fournissant directement une expertise ou une vue du projet, et déplacer des instructions longues de CLAUDE.md vers des skills permet de ne les charger qu'à la demande.
Un hook ou une skill bien conçus ne sont pas seulement des extensions fonctionnelles. Ce sont aussi des outils d'économie de contexte.

Utiliser /insights
Un rapport qualitatif
/insights analyse vos sessions Claude Code. C'est un rapport HTML généré localement à partir de vos sessions des trente derniers jours environ : il s'ouvre dans votre navigateur, reste sur votre machine (dans le dossier ~/.claude) et ne transmet pas votre code source. Il porte sur les domaines de projet, les modèles d'interaction et les points de friction. /usage mesure, /insights interprète.
Lancez-le après une période d'utilisation, pas après chaque session. Il révèle des habitudes : sessions trop longues, prompts trop vagues, corrections en série, usage excessif de sous-agents, mauvais choix de modèle ou tâches mal découpées.

Quand lancer /insights
Lancez /insights après plusieurs jours ou semaines d'utilisation, avant de former une équipe, après une migration de workflow, ou lorsqu'une équipe constate une hausse de coûts sans cause évidente.
Le rapport ne remplace pas les métriques de facturation, mais il oriente les décisions de prompts, de configuration, de skills, de hooks et de modèles.

Suivi individuel, équipe et organisation
Suivi local
Pour un usage individuel, /usage, /cost, /stats et /insights suffisent. Ils donnent le coût approximatif, les limites, les statistiques et les habitudes de travail directement dans la CLI.

Suivi d'équipe
Au niveau organisation, des tableaux de bord analytiques prennent le relais. Sur Claude for Teams et Enterprise, les administrateurs et propriétaires disposent de métriques d'utilisation, de métriques de contribution avec intégration GitHub, d'un classement et d'exports CSV. Pour l'API via Claude Console, le tableau de bord inclut des métriques d'utilisation, le suivi des dépenses et des insights d'équipe.
Les deux niveaux sont complémentaires : /usage aide dans la session courante, tandis que les tableaux de bord et exports aident l'équipe à piloter l'adoption, la dépense et l'impact.

Surveillance par télémétrie
Via OpenTelemetry, la métrique claude_code.cost.usage suit le coût estimé par requête et permet d'attribuer les dépenses à des skills, plugins ou types de sous-agents grâce à des attributs comme skill.name, plugin.name et agent.name. Ces métriques de coûts restent approximatives ; les données officielles de facturation restent chez le fournisseur d'API.
Ce niveau de suivi devient pertinent quand l'usage sort du cadre individuel : équipes nombreuses, automatisations, passerelles LLM, usage API ou politiques de coût internes.

Protocoles de suivi
Avant une tâche longue
/usage
/context
Avant de commencer :
- limite la recherche aux fichiers nécessaires ;
- ne lance pas de workflow dynamique sans validation ;
- n'utilise pas de sous-agent sauf si la recherche est vo
- arrête-toi après un premier plan vérifiable.
Ce point de départ évite de découvrir seulement à la fin qu'une session a été coûteuse.

Pendant une tâche qui grossit
/usage
/context
La session devient lourde.
Indique ce qui consomme le plus :
- contexte ;
- fichiers lus ;
- sorties de commandes ;
- sous-agents ;
- MCP ;
- skills ou plugins.
Propose une réduction sans perdre l'objectif.
L'objectif n'est pas de couper mécaniquement, mais de savoir si la consommation est justifiée par la tâche ou produite par une dérive.

Après une session coûteuse
/usage
/insights
Analyse cette session :
- ce qui a consommé le plus ;
- ce qui était nécessaire ;
- ce qui aurait pu être évité ;
- quelles instructions seraient meilleures la prochaine f
- si une skill, un hook ou un sous-agent aurait réduit le
Ce protocole transforme une session coûteuse en apprentissage : il améliore les prochains prompts et la configuration au lieu de se contenter de constater le coût.
