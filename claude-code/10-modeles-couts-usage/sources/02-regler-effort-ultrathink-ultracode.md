Dans Claude Code , le modèle choisi ne suffit pas à déterminer la qualité d'une session. Il faut aussi régler le niveau
d'effort, c'est-à-dire la quantité de raisonnement adaptatif que le modèle peut engager pendant le travail.

L'effort n'est pas un modèle. Le modèle définit la capacité de base. L'effort règle la profondeur de raisonnement utilisée par
ce modèle, lorsque celui-ci prend en charge cette capacité. Un effort faible privilégie la rapidité et la réduction des tokens.
Un effort élevé donne plus de marge au raisonnement, mais peut augmenter le coût par tour et la latence. Les niveaux
disponibles dépendent du modèle actif.

La commande centrale est /effort . Elle permet d'ouvrir un curseur interactif, de définir directement un niveau, ou de
revenir au niveau par défaut du modèle avec /effort auto . Le niveau d'effort peut aussi être ajusté depuis le
sélecteur /model avec les flèches gauche et droite lorsque le modèle sélectionné le supporte.

Le rôle de /effort
Modifier la profondeur de raisonnement
/effort contrôle le niveau de raisonnement adaptatif utilisé dans la session. Ce réglage sert à adapter Claude Code à la
difficulté de la tâche. Une correction simple ne justifie pas toujours un raisonnement très coûteux. Une enquête complexe,
une décision d'architecture ou un refactor transversal peuvent au contraire bénéficier d'un effort plus élevé.

/effort
/effort low
/effort medium
/effort high
/effort xhigh
/effort max
/effort auto

/effort auto réinitialise le niveau d'effort sur la valeur par défaut du modèle courant. C'est utile après une phase difficile
si vous voulez revenir à un comportement plus standard.

Ne pas confondre effort et vérification
Un effort élevé peut améliorer l'analyse, mais il ne prouve pas que le résultat est correct. La correction d'un bug, une
migration, une revue de sécurité ou une refactorisation restent dépendantes d'un signal externe : test, build, typecheck,
linter, inspection de diff ou validation humaine.

Plus l'effort est élevé, plus la trajectoire peut être autonome, mais plus la vérification doit être explicite. L'effort sert à mieux
décider, pas à remplacer la preuve.

Les niveaux d'effort

low
low convient aux tâches courtes, bien délimitées, sensibles à la latence et peu exigeantes en intelligence. Il est adapté
lorsque le coût et la vitesse comptent davantage que la profondeur d'analyse.

/effort low
Résume ce fichier en cinq lignes.
Ne modifie rien.
Indique seulement son rôle principal.

Ce niveau est raisonnable pour une extraction simple, une reformulation courte, une inspection locale ou une réponse à
faible risque.

medium
medium réduit l'utilisation de tokens pour un travail sensible au coût, tout en conservant davantage de capacité qu'un
niveau minimal. C'est un compromis utile pour des tâches ordinaires mais peu critiques.

/effort medium
Lis les tests existants liés au module de facturation
Identifie les cas déjà couverts.
Ne modifie aucun fichier.

Ce niveau convient lorsque la tâche demande un peu d'analyse, mais que les conséquences d'une erreur sont limitées ou
faciles à vérifier.

high
high est le niveau d'équilibre pour beaucoup de tâches de codage. Il constitue un compromis entre utilisation des tokens
et intelligence, et peut être le niveau par défaut sur les modèles récents.

/effort high
Analyse l'échec du test ciblé.
Lis uniquement les fichiers nécessaires.
Propose une correction minimale.
Lance la vérification ciblée avant de conclure.

C'est généralement le niveau à privilégier pour une tâche de développement standard : comprendre un comportement,
corriger un bug localisé, écrire un test, adapter une API interne ou produire une modification vérifiable.

xhigh
xhigh fournit un raisonnement plus profond avec une dépense en tokens plus élevée. Il n'est pas disponible sur tous les
modèles. Si vous demandez un niveau non supporté, Claude Code revient au niveau le plus élevé pris en charge au
niveau demandé ou en dessous. Par exemple, xhigh peut s'exécuter comme high sur certains modèles qui ne prennent
pas en charge xhigh .

/effort xhigh
Analyse cette régression difficile.
Commence par distinguer les faits observés, les hypoth
Ne modifie rien tant que la cause probable n'est pas a

xhigh est pertinent pour le debugging complexe, l'architecture, les migrations ambiguës, les refactors étendus et les
revues où le coût d'une mauvaise décision est supérieur au coût du raisonnement.

max
max fournit le raisonnement le plus profond, mais il peut présenter des rendements décroissants et conduire à une forme
de surréflexion. Mieux vaut le tester avant de l'adopter largement. Il s'applique à la session actuelle uniquement, sauf
lorsqu'il est imposé via la variable d'environnement prévue pour l'effort.

/effort max
Nous devons prendre une décision d'architecture.
Compare les options.
Évalue les risques.
Ne propose pas d'implémentation tant que la stratégie

max ne doit pas devenir un réflexe. Il est adapté aux décisions lourdes, mais pas aux corrections mécaniques. Sur une
tâche simple, il peut coûter plus cher sans améliorer significativement le résultat.

Configurer l'effort de manière persistante

Le paramètre effortLevel
Pour une préférence persistante, Claude Code expose le paramètre effortLevel . Les
valeurs low , medium , high et xhigh peuvent être définies dans les fichiers de paramètres. max et ultracode ne
doivent pas être placés dans effortLevel comme des valeurs persistantes ordinaires.

{
 "$schema": "https://json.schemastore.org/claude-code
 "effortLevel": "high"
}

Cette configuration est utile si vous voulez que vos sessions démarrent avec un niveau d'effort stable. Cette valeur doit
toutefois rester adaptée au modèle et au contexte réel de l'environnement.

La variable CLAUDE_CODE_EFFORT_LEVEL
La variable d'environnement CLAUDE_CODE_EFFORT_LEVEL peut aussi contrôler l'effort. Elle prend priorité sur les autres
méthodes de configuration.

CLAUDE_CODE_EFFORT_LEVEL=high claude

Ce mode est utile pour une session ponctuelle, un environnement d'équipe ou un script local. Il faut cependant éviter de
l'oublier dans son shell : si cette variable reste définie, elle peut expliquer pourquoi /effort ou les paramètres semblent
ne pas produire l'effet attendu.

Priorité des réglages
La priorité pratique est la suivante : variable d'environnement, puis niveau configuré, puis valeur par défaut du modèle. Un
effort défini dans le frontmatter d'une skill ou d'un subagent peut remplacer le niveau de session quand cette skill ou ce
subagent s'exécute, mais il ne remplace pas la variable d'environnement.

Quand le comportement semble incohérent, vérifiez d'abord la source du réglage actif. Une valeur peut venir de la session,
d'un fichier de configuration, d'une variable d'environnement, d'une skill, d'un subagent ou du modèle lui-même.

ultrathink
Un raisonnement profond ponctuel
ultrathink est un mot-clé à écrire dans le prompt. Il demande un raisonnement plus profond pour ce tour, sans modifier
le niveau d'effort de session. Claude Code reconnaît explicitement ultrathink et ajoute une instruction en contexte,
tandis que d'autres formulations comme think , think hard ou think more sont traitées comme du texte ordinaire.

ultrathink
Analyse cette régression.
Ne modifie aucun fichier.
Distingue les faits observés, les hypothèses probables

ultrathink est utile quand la difficulté est ponctuelle. Il sert à demander un effort d'analyse sur un tour précis sans
changer toute la session.

Quand utiliser ultrathink
Utilisez ultrathink lorsqu'un seul passage demande une analyse plus profonde : choisir une stratégie, relire une diff
critique, examiner une hypothèse de bug, comparer deux architectures ou produire une revue avant modification.

ultrathink
Relis cette proposition de migration.
Cherche les risques d'incompatibilité.
Ne propose pas de code.
Retourne seulement les décisions à prendre avant implé

Ce mot-clé est moins adapté si toute la session doit rester en raisonnement profond. Dans ce cas, utilisez plutôt /effort
high , /effort xhigh ou un niveau adapté disponible dans votre environnement.

ultracode
Un mode Claude Code , pas seulement un effort modèle
ultracode n'est pas un simple niveau d'effort du modèle. C'est un paramètre propre à Claude Code : il envoie xhigh au
modèle et active l'orchestration automatique de workflows dynamiques pour les tâches substantielles. Il s'applique à la
session actuelle uniquement. On l'active avec /effort ultracode , ou en passant "ultracode": true via --settings ou
une requête de contrôle de l'Agent SDK. Ce n'est pas une valeur de niveau d'effort : il ne peut pas être défini
dans effortLevel , avec le drapeau --effort , ni via CLAUDE_CODE_EFFORT_LEVEL .

/effort ultracode

Avec ultracode , Claude Code peut décider qu'une tâche justifie un workflow dynamique. Une même demande peut alors
conduire à plusieurs phases : compréhension du code, modification, vérification ou revue croisée. Ce comportement utilise
plus de tokens et prend généralement plus de temps qu'un niveau d'effort ordinaire.

Quand utiliser ultracode
ultracode est adapté aux tâches substantielles : audit de base de code, migration large, recherche approfondie, revue
multi-angle, refactor massif, vérification croisée ou exploration impliquant plusieurs sous-agents.

/effort ultracode
Audite les endpoints sous src/routes pour repérer les
Structure le travail en phases.
Vérifie les conclusions avant le rapport final.
Ne modifie rien sans plan explicite.

Ce mode doit être réservé aux tâches qui justifient une orchestration lourde. Pour une correction locale, il peut ajouter du
coût et de la complexité sans bénéfice proportionnel.

Revenir à un effort ordinaire
Après une tâche en ultracode , revenez explicitement à un niveau adapté au travail courant.

/effort high

Ce retour évite que des demandes ordinaires continuent à utiliser un mode plus coûteux que nécessaire.

Le mot-clé ultracode dans un prompt
Déclencher un workflow sans changer toute la session
Il est possible de demander un workflow pour une seule tâche en incluant ultracode dans le prompt, ou en demandant
explicitement un workflow en langage naturel. Cela permet de déclencher un workflow ponctuel sans définir /effort
ultracode pour toute la session.

ultracode
Audite les routes API pour trouver les endpoints sans
Retourne un rapport avec les fichiers, les risques et 
Ne modifie aucun fichier.

Ce mécanisme dépend de la version et de la configuration. Le paramètre workflowKeywordTriggerEnabled contrôle si le
mot-clé ultracode dans une invite déclenche un workflow dynamique. Le désactiver empêche le mot-clé de déclencher
un workflow, sans désactiver les workflows eux-mêmes ni le niveau /effort ultracode .

{
 "$schema": "https://json.schemastore.org/claude-code
 "workflowKeywordTriggerEnabled": true
}

Différence entre ultrathink et ultracode
Mécanisme Portée Effet principal Usage typique
ultrathink Un tour Demande un raisonnement plus profond sans changer l'effort de session Analyse ponctuelle, revue, décision difficile
/effort high ou /effort xhigh Session Règle le niveau d'effort de raisonnement Debugging, codage difficile, refactor avec vérification
/effort max Session actuelle Raisonnement très profond, avec risque de rendements décroissants Décision critique, architecture, analyse exceptionnelle
ultracode dans le prompt Tâche ponctuelle Demande un workflow dynamique pour cette tâche Audit ou recherche large sans changer toute la session
/effort ultracode Session actuelle Combine effort xhigh et orchestration dynamique pour les tâches substantielles Travail lourd, multi-phase, multi-agent ou fortement vérifié

Choisir le bon niveau

Selon la difficulté
Pour une tâche simple, utilisez low ou medium . Pour une tâche de développement ordinaire, utilisez high . Pour une
enquête complexe ou une décision lourde, utilisez xhigh si le modèle le supporte. Pour une tâche exceptionnelle,
testez max . Pour une orchestration substantielle, utilisez ultracode .

Selon le coût
Un effort élevé peut coûter plus par tour. Il peut toutefois réduire le nombre d'itérations si la difficulté principale est
l'analyse. Une mauvaise trajectoire en effort bas peut coûter davantage au total si elle exige plusieurs corrections, lectures
inutiles et retours arrière.
Le coût pertinent n'est pas seulement le coût d'un tour. C'est le coût de la trajectoire complète : nombre de tours, outils
appelés, fichiers lus, workflows déclenchés, sous-agents lancés et vérifications répétées.

Selon la capacité de vérification
Si la tâche est facilement vérifiable, vous pouvez souvent utiliser un effort plus modéré. Si la tâche est difficile à vérifier, le
risque de raisonnement augmente, et un effort plus élevé peut être justifié.

/effort high
Corrige ce bug.
Ajoute un test qui échoue avant la correction.
Lance le test ciblé.
Ne conclus que si le test passe.

Lorsque la vérification est faible, il faut être plus prudent : demander une analyse séparée, demander un plan,
utiliser ultrathink , augmenter l'effort ou faire relire par une autre trajectoire.

Effort élevé et workflows longs

Pourquoi l'effort peut augmenter les coûts indirects
Un effort élevé ne se contente pas d'augmenter la profondeur de raisonnement. Il peut aussi encourager des trajectoires
plus longues : exploration plus large, plus d'hypothèses, plus de vérifications, plus de sous-agents et davantage d'outils.
Avec ultracode , cette dynamique est encore plus nette, car l'orchestration de workflows peut lancer plusieurs agents ou
phases de travail. ultracode peut utiliser plus de tokens et prendre plus de temps que les niveaux d'effort inférieurs.

Un effort élevé doit donc être accompagné d'un budget explicite. Définissez le périmètre, le nombre de fichiers, les tests
attendus, les agents autorisés, le niveau de rapport et la condition d'arrêt.

/effort xhigh
Analyse uniquement le module auth.
Ne lis pas les dossiers legacy.
Ne lance que les tests ciblés.
Arrête-toi après avoir identifié une cause probable et

Budgéter ultracode

/effort ultracode
Objectif :
auditer les endpoints sensibles.
Budget :
limite l'analyse aux fichiers sous src/routes et src/m
Ne lance pas plus de deux phases de workflow.
Ne modifie aucun fichier.
Retourne un rapport court avec preuves et incertitudes

Ce type de cadrage évite qu'un mode puissant se transforme en exploration ouverte. Plus la capacité d'orchestration est
élevée, plus le prompt doit définir un périmètre.

Erreurs fréquentes

Utiliser max pour tout
max peut être utile, mais il n'est pas un réglage universel. Sur des tâches simples, il peut ralentir la session et augmenter
le coût sans améliorer le résultat. Il peut aussi pousser le modèle à suranalyser.

Utiliser ultracode pour une petite correction
ultracode est conçu pour des tâches substantielles. Pour une correction locale avec test ciblé, high ou xhigh suffit
souvent.

Confondre ultrathink et /effort
ultrathink agit sur un tour. /effort règle la session. Si vous voulez une analyse ponctuelle, utilisez ultrathink . Si
vous voulez que toute la session travaille avec plus de profondeur, utilisez /effort .

Oublier de redescendre l'effort
Après une phase complexe, il faut revenir à un niveau plus adapté au travail courant.

/effort high

Cette discipline évite de payer un effort élevé pour des tâches simples.

Augmenter l'effort au lieu de nettoyer le contexte
Si la session est polluée, contradictoire ou trop longue, augmenter l'effort peut aider marginalement, mais la meilleure
solution est souvent /context , /compact , /clear ou /rewind .
Un mauvais contexte avec un effort élevé reste un mauvais contexte.

Protocole recommandé

Tâche simple
/effort low
Réponds rapidement.
Ne modifie rien.
Donne seulement l'information demandée.

Tâche de codage standard
/effort high
Corrige le bug avec un diff minimal.
Lance le test ciblé.
Résume les fichiers modifiés et les vérifications.

Debugging complexe
/effort xhigh
Avant toute modification :
- reconstruis le flux ;
- distingue faits et hypothèses ;
- propose une vérification minimale ;
- demande confirmation si plusieurs causes restent pla

Analyse ponctuelle critique
ultrathink
Relis cette stratégie.
Cherche les failles de raisonnement.
Retourne uniquement les risques, les hypothèses et les

Workflow substantiel
/effort ultracode
Analyse cette migration comme un workflow.
Découpe en phases.
Garde les résultats intermédiaires vérifiables.
Ne modifie rien sans plan approuvé.
