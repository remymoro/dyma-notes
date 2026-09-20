Claude Code 14. Les compétences (skills) 5. Les différentes catégories de skills et les bonnes pratiques

Les différentes catégories de skills et les bonnes pratiques
Une skill doit répondre à un besoin identifiable. Avant de créer de nouvelles skills, il faut déterminer leur responsabilité, les informations qu’elles doivent fournir et le moment où elles doivent être chargées.

Après avoir analysé plusieurs centaines de skills utilisées en interne, Anthropic a identifié neuf grandes catégories. Cette classification n’est pas une règle stricte, mais elle permet de structurer une bibliothèque de skills et de repérer les responsabilités mal définies.

Les skills les plus efficaces appartiennent généralement à une catégorie principale. Une skill qui tente de couvrir plusieurs catégories devient plus difficile à comprendre, à déclencher et à maintenir.

Les neuf catégories de skills

Catégorie | Objectif | Exemple
---|---|---
Références de bibliothèques et d’API | Expliquer comment utiliser correctement une bibliothèque, un SDK, une API ou un outil en ligne de commande. | /billing-api
Vérification du produit | Lancer le produit et vérifier que son comportement réel correspond aux attentes. | /verify-product
Collecte et analyse de données | Interroger des données, des journaux, des métriques ou des outils de supervision. | /analyse-conversions
Processus métier et automatisation d’équipe | Automatiser un workflow répétitif impliquant plusieurs outils ou sources. | /weekly-recap
Génération de code et modèles | Créer une structure de code conforme aux conventions du projet. | /create-component
Qualité et revue de code | Analyser le code, les tests et la maintenabilité. | /techdebt
CI/CD et déploiement | Préparer, surveiller ou vérifier une livraison. | /release-check
Runbooks et diagnostic | Analyser un symptôme et conduire une procédure de diagnostic structurée. | /debug-service
Opérations d’infrastructure | Exécuter des procédures de maintenance ou d’administration avec des garde-fous. | /cleanup-resources

Les catégories couvrent des besoins très différents. Une skill de référence apporte surtout de la connaissance, tandis qu’une skill de déploiement exécute un workflow et peut produire des effets externes. Une skill d’infrastructure nécessite généralement davantage de contrôles qu’une skill d’analyse.

Positionner les skills du projet
La skill /techdebt créée précédemment appartient à la catégorie « qualité et revue de code ». Elle analyse le convertisseur et produit un rapport sans modifier les fichiers.

D’autres skills pourraient ensuite compléter le projet :

Skill | Catégorie principale | Responsabilité
---|---|---
/techdebt | Qualité et revue de code | Détecter la dette technique et les risques de maintenabilité.
/verify-product | Vérification du produit | Lancer le convertisseur et tester des saisies valides et invalides.
/add-test | Qualité et revue de code | Ajouter des tests selon les conventions du projet.
/release-check | CI/CD et déploiement | Vérifier les tests et l’état du dépôt avant une livraison.

Chaque skill possède une responsabilité principale. /techdebt ne doit pas ajouter automatiquement des tests, lancer une publication et créer une issue. Ces actions correspondent à d’autres workflows.

Ne pas répéter ce que Claude sait déjà
Une skill ne doit pas expliquer à Claude des pratiques générales qu’il connaît déjà.

Instructions trop générales :
- écris du code propre ;
- utilise des noms clairs ;
- évite les bugs ;
- ajoute des tests pertinents ;
- respecte les bonnes pratiques JavaScript.

Ces consignes consomment du contexte sans apporter de connaissance spécifique. Une skill doit plutôt contenir ce que Claude ne peut pas déduire facilement du dépôt.

Instructions utiles pour le convertisseur :
- les fonctions de conversion restent dans src/conversion.js ;
- les tests utilisent node:test et node:assert/strict ;
- les résultats sont arrondis à un chiffre après la virgule ;
- une saisie vide ou non numérique ne doit jamais afficher NaN ;
- l'audit ne modifie aucun fichier.

Il faut privilégier les conventions internes, les cas particuliers et les informations qui modifient réellement la manière dont Claude aborde le travail.

Documenter les pièges récurrents
La section la plus utile d’une skill est souvent celle qui décrit les erreurs fréquemment rencontrées. Ces pièges, parfois appelés gotchas, doivent provenir de problèmes réellement observés.

Pour /techdebt, une section de ce type pourrait être ajoutée après plusieurs utilisations :

## Pièges connus
- Number('') retourne 0 : une saisie vide doit être détectée avant la conversion.
- Les fonctions de conversion sont testables sans charger le DOM.
- Ne propose pas de framework pour un projet aussi réduit.
- Ne signale pas l'absence de TypeScript comme une dette technique.
- Ne transforme pas une préférence stylistique en problème bloquant.

Cette section ne doit pas être remplie avec des conseils génériques. Elle doit évoluer à partir des erreurs commises par Claude ou des particularités non évidentes du projet.

Écrire la description pour Claude
La description n’est pas uniquement un résumé destiné aux développeurs. Claude Code charge la liste des noms et descriptions disponibles afin de déterminer si une skill correspond à la demande actuelle.

La description doit donc préciser :
ce que fait la skill ;
dans quelles situations elle doit être utilisée ;
les formulations ou intentions qui doivent la déclencher ;
éventuellement les situations dans lesquelles elle ne doit pas intervenir.

Description trop vague :
Analyse le code.
Description plus efficace :
Analyse le code ou le changement courant pour détecter la dette technique, les duplications, la complexité inutile et les tests manquants.
Utilise cette skill lorsque l'utilisateur demande un audit de maintenabilité, une analyse de dette technique ou une revue de fin de session.

Le cas d’usage principal doit être placé au début. Une description trop générale peut déclencher la skill sur des demandes sans rapport. Une description trop étroite peut empêcher son déclenchement automatique.

Distinguer connaissance et procédure
Les skills peuvent contenir deux grands types d’informations.

Type | Rôle | Exemple
---|---|---
Contenu de référence | Apporter des conventions, des règles métier ou une connaissance spécialisée. | Les règles d’arrondi du convertisseur.
Contenu procédural | Décrire les étapes d’une action précise. | Lancer les tests, démarrer le serveur puis vérifier trois saisies.

Une skill de référence peut être chargée automatiquement lorsque Claude travaille sur le domaine concerné. Une procédure ayant des effets externes, comme un déploiement ou un commit, doit généralement être déclenchée manuellement.

---
name: release-check
description: Vérifie que le convertisseur est prêt à être livré.
disable-model-invocation: true
---

Le champ disable-model-invocation: true empêche Claude de lancer automatiquement une skill. Il est particulièrement pertinent pour les workflows dont le moment d’exécution doit rester sous le contrôle de l’utilisateur.

Garder SKILL.md concis
Quand une skill est invoquée, son contenu entre dans le contexte de la session. Un fichier inutilement long augmente donc le coût en contexte et peut diluer les instructions importantes.

Le fichier SKILL.md doit contenir :
l’objectif ;
le périmètre ;
les contraintes principales ;
la procédure générale ;
les ressources disponibles ;
le format de sortie.

Les informations volumineuses doivent être placées dans des fichiers de support.

.claude/
skills/
techdebt/
SKILL.md
references/
conventions.md
pieges-connus.md
examples/
rapport.md
scripts/
inspecter-projet.mjs

SKILL.md indique alors quand consulter chaque ressource :

## Ressources
- Consulte references/conventions.md pour les conventions du projet.
- Consulte references/pieges-connus.md pour les erreurs déjà observées.
- Utilise examples/rapport.md comme modèle de sortie.
- Exécute scripts/inspecter-projet.mjs uniquement si un inventaire déterministe est nécessaire.

Cette organisation applique la divulgation progressive : Claude charge d’abord le point d’entrée, puis consulte les détails seulement lorsqu’ils deviennent utiles.

Utiliser des scripts pour les opérations déterministes
Une instruction en langage naturel convient lorsqu’un jugement ou une adaptation au contexte est nécessaire. Un script est préférable lorsque l’opération doit toujours produire le même résultat.

Besoin | Meilleur support
---|---
Déterminer si une abstraction est excessive | Instructions dans SKILL.md
Lister les fichiers modifiés | Commande Git ou script
Vérifier que les tests réussissent | npm test
Comparer une sortie avec une valeur attendue | Assertion automatisée
Prioriser les problèmes de maintenabilité | Analyse de Claude

Les scripts évitent à Claude de reconstruire la même logique à chaque exécution. Claude peut alors consacrer son travail à l’interprétation des résultats et à la décision suivante.

Ne pas enfermer Claude dans une procédure trop rigide
Une skill doit donner une direction claire sans imposer inutilement chaque commande, chaque fichier et chaque ordre de lecture.

Procédure trop rigide :
1. Lis package.json.
2. Lis src/main.js.
3. Lis src/conversion.js.
4. Lis tous les tests.
5. Exécute git diff.
6. Produis exactement cinq problèmes.

Cette procédure peut devenir incorrecte si la structure du projet évolue ou si le périmètre demandé ne concerne qu’un fichier.

Procédure plus robuste :
1. Identifie le périmètre demandé.
2. Si aucun périmètre n'est fourni, inspecte les changements Git.
3. Lis uniquement les fichiers nécessaires.
4. Analyse les risques de maintenabilité et les tests associés.
5. Classe uniquement les problèmes réellement démontrés.

Les instructions doivent définir l’objectif, les contraintes et les preuves attendues, tout en laissant Claude adapter son exploration à la situation.

Choisir le bon mécanisme
Toute instruction ne doit pas devenir une skill.

Besoin | Mécanisme
---|---
Information utile dans presque toutes les sessions | CLAUDE.md
Workflow réutilisable chargé à la demande | skill
Instruction applicable uniquement à certains fichiers | Règle ciblée avec paths
Action qui doit toujours être exécutée | hook
Action qui doit être interdite de manière fiable | Permission ou hook
Travail isolé qui produirait beaucoup de contexte intermédiaire | Sous-agent

Une procédure comme un audit, une vérification de livraison ou une revue appartient naturellement à une skill. Une règle générale comme la commande utilisée pour lancer les tests peut appartenir à CLAUDE.md. Une interdiction absolue ne doit pas reposer uniquement sur une instruction : elle doit être appliquée par un mécanisme déterministe.

Évaluer séparément le déclenchement et le résultat
Le fait qu’une skill se déclenche ne prouve pas qu’elle produit un bon résultat. Deux dimensions doivent être évaluées séparément :

Dimension | Question
---|---
Déclenchement | La skill est-elle chargée pour les bonnes demandes et ignorée pour les autres ?
Qualité de sortie | Le rapport obtenu est-il plus précis, plus complet et plus exploitable ?

Pour tester /techdebt, préparez quelques demandes réalistes :

Demandes qui doivent déclencher la skill :
Analyse la dette technique du convertisseur.
Effectue une revue de maintenabilité avant le commit.
Repère les duplications et les tests manquants.

Demandes qui ne doivent pas la déclencher :
Corrige le formulaire.
Lance les tests.
Explique la formule de conversion.
Démarre le serveur de développement.

Exécutez ensuite les mêmes demandes dans des sessions fraîches, avec puis sans la skill. Une session fraîche évite que le contexte utilisé pendant sa création masque les informations absentes de SKILL.md.

Faire évoluer les skills progressivement
Une bonne skill ne naît pas nécessairement avec une structure complexe. Elle peut commencer avec quelques instructions et un premier piège connu.

Après chaque utilisation, vérifiez :
si elle s’est déclenchée au bon moment ;
si elle a exploré un périmètre raisonnable ;
si elle a produit des conclusions démontrées ;
si elle a utilisé les bonnes commandes ;
si elle a rencontré un nouveau piège récurrent ;
si une partie devrait devenir un script, un hook ou une règle permanente.

La skill doit évoluer à partir des échecs réellement observés, pas à partir de tous les cas théoriquement possibles. Plusieurs des meilleures skills peuvent commencer avec quelques lignes avant d’être enrichies progressivement à mesure que Claude rencontre de nouveaux cas limites.

Synthèse
Une skill efficace respecte quelques principes simples :
elle appartient à une catégorie principale ;
elle possède une responsabilité claire ;
elle apporte des informations que Claude ne peut pas facilement déduire ;
elle documente les pièges réellement rencontrés ;
sa description indique précisément quand la déclencher ;
son fichier SKILL.md reste concis ;
ses références et scripts sont chargés seulement lorsque nécessaire ;
elle utilise des mécanismes déterministes pour les opérations qui l’exigent ;
son déclenchement et la qualité de sa sortie sont évalués séparément ;
elle est améliorée progressivement à partir de résultats observables.

/techdebt constitue une première skill de qualité et de revue de code. Les prochaines skills du convertisseur pourront couvrir la vérification du produit, l’ajout de tests et la préparation d’une livraison, sans mélanger ces responsabilités dans un seul workflow.
