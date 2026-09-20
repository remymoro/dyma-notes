Pendant plusieurs décennies, le développement logiciel a été organisé autour d’une ressource rare : la capacité humaine à transformer une intention en code fonctionnel.
Les équipes disposaient généralement de beaucoup plus d’idées, de demandes et de corrections que de temps de développement. Le travail s’accumulait donc dans un backlog, puis avançait progressivement vers l’implémentation, les tests et la livraison.

Backlog
↓
En cours de développement
↓
Revue et tests
↓
Terminé

L’arrivée des agents de développement ne supprime pas ce flux. Elle modifie la capacité de chacune de ses étapes.
Un agent peut explorer un dépôt, modifier plusieurs fichiers, lancer des commandes, écrire des tests, corriger les erreurs et produire une pull request. La production de code peut donc augmenter beaucoup plus vite que la capacité humaine à définir le bon changement et à établir qu’il est acceptable.
Le goulot d’étranglement se déplace. Il ne se situe plus nécessairement au centre du flux, dans l’écriture du code. Il se situe de plus en plus aux deux extrémités :

En amont | Au centre | En aval
---|---|---
Framing, cadrage du problème, conception et définition des preuves attendues. | Implémentation par un ou plusieurs agents. | Vérification, validation produit, revue, observation et responsabilité de la livraison.

Le développeur ne disparaît pas de ce processus. Son travail devient plus proche de celui d’un ingénieur système : formuler l’intention, concevoir les contraintes, organiser l’exécution et exiger des preuves.

Avant les agents : l’implémentation était la ressource rare
Le tableau de travail classique
Un tableau simplifié de développement contient souvent des colonnes comme Backlog, En cours, Test et Terminé. Ce tableau ne constitue pas à lui seul la définition de Scrum, mais il représente correctement le flux visible de nombreuses équipes.
Dans Scrum, le Product Backlog contient la liste ordonnée de ce qui pourrait améliorer le produit. Une partie de ces éléments est sélectionnée dans le Sprint Backlog. Le travail produit un incrément uniquement lorsqu’il respecte la Definition of Done.

Dans la pratique, le flux pouvait être représenté ainsi :
Étape | Travail principal | Contrainte habituelle
---|---|---
Backlog | Accumuler, ordonner et décrire les demandes. | Le nombre d’idées était rarement limitant.
En cours | Comprendre la demande, concevoir et écrire le code. | Temps et expertise des développeurs.
Test et revue | Rechercher les défauts et confirmer le comportement. | Disponibilité des testeurs et des reviewers.
Terminé | Intégrer ou livrer un incrément utilisable. | Respect de la Definition of Done.

Le backlog n’était pas le goulot
Un backlog volumineux ne constitue pas lui-même un goulot d’étranglement. Il constitue une file d’attente.
Le goulot est l’étape dont la capacité limite le débit du système. Pendant longtemps, cette contrainte se trouvait fréquemment dans l’implémentation : produire un changement fiable exigeait de comprendre le besoin, l’architecture, le langage, les bibliothèques, les conventions, les tests et les conditions de déploiement.
Le code était long à produire, coûteux à modifier et difficile à paralléliser. Une équipe pouvait ajouter cent idées au backlog en une journée, mais elle ne pouvait pas implémenter cent fonctionnalités dans le même temps.

Capacité à produire des idées :
très élevée
Capacité à transformer ces idées en logiciel fiable :
limitée
Conséquence :
le backlog s'allonge devant la capacité de développement.

La valeur visible du développeur était donc fortement associée à sa capacité à produire le code : connaître la syntaxe, les outils, les frameworks, les API et les techniques d’implémentation.
Le cadrage et la validation existaient déjà, mais l’écriture du code occupait une part suffisamment importante du cycle pour rester la contrainte centrale de nombreuses équipes.

Avec les agents : la capacité d’implémentation augmente
Le centre du flux devient plus rapide
Un agent de développement comme Claude Code ne se limite pas à proposer une complétion dans un éditeur. Il peut explorer un dépôt, rechercher des symboles, lire les tests existants, modifier plusieurs fichiers, exécuter les commandes du projet et itérer sur les erreurs.

Cette boucle permet de déléguer une part croissante de l’exécution :
Comprendre la tâche
↓
Explorer le dépôt
↓
Proposer un plan
↓
Modifier les fichiers
↓
Lancer les validations
↓
Corriger les erreurs
↓
Produire un diff

La quantité de code qu’une personne peut provoquer augmente alors fortement. Plusieurs agents peuvent également travailler en parallèle sur des recherches, des tests, des migrations ou des changements indépendants.
Cette accélération ne signifie pas que le système livre automatiquement plus de valeur. Elle signifie d’abord que le centre du processus peut produire davantage de changements.

Produire plus vite ne résout pas automatiquement le flux
Une équipe peut produire davantage de code sans augmenter son débit de livraison. Les changements peuvent s’accumuler devant la revue, la CI, les tests d’intégration, la validation produit ou le déploiement.
Une accélération locale peut donc déplacer la file d’attente :

Avant :
beaucoup de demandes
↓
peu de capacité d'implémentation
↓
volume limité à valider

Avec les agents :
beaucoup de demandes
↓
forte capacité d'implémentation
↓
beaucoup de changements à comprendre et à valider

Le risque n’est plus seulement de ne pas produire assez vite. Le risque devient de produire plus vite que l’organisation ne peut comprendre, tester, revoir, exploiter et maintenir.

Le nouveau goulot : cadrer et établir la confiance
Un changement observé par les responsables techniques
Plusieurs responsables et praticiens reconnus décrivent le même déplacement sous des formulations différentes.

Personne | Constat | Conséquence opérationnelle
---|---|---
Thomas Dohmke, dirigeant de GitHub | « Une startup peut se lancer avec du code généré par l’ IA, mais elle ne peut pas passer à l’échelle sans développeurs expérimentés. » | La génération permet de commencer. L’expertise permet de construire un système durable.
Addy Osmani, responsable d’ingénierie chez Google | « La contrainte déterminante n’est plus la vitesse d’écriture, mais la vitesse à laquelle un humain de confiance peut établir qu’un changement est correct. » | La capacité de revue et de validation doit être traitée comme une ressource limitée.
Chad Fowler, dirigeant et auteur logiciel | « Si la génération de code devient plus facile, le jugement doit devenir plus strict. » | La rigueur ne disparaît pas. Elle se déplace vers les spécifications, les contraintes et les preuves.
Andrej Karpathy, chercheur et ingénieur en IA | « Si une tâche est vérifiable, elle est optimisable. » | Un agent devient plus efficace lorsque le résultat attendu peut être testé, noté ou comparé objectivement.
Simon Willison, créateur et praticien du logiciel | « Votre travail consiste à livrer du code dont vous avez prouvé le fonctionnement. » | Une pull request doit transporter le changement et ses preuves, pas transférer la validation au reviewer.
Charity Majors, cofondatrice et CTO de Honeycomb | « Les méthodes formelles et les tests sont des simulateurs de vol. La production est le vol réel. » | La validation ne s’arrête pas aux tests. Elle se poursuit avec le déploiement, l’observation et l’apprentissage.
Boris Cherny, créateur de Claude Code | Avec les agents, la distance entre une idée et un programme exécutable se réduit fortement. | La qualité de l’idée, de son cadrage et de ses limites devient encore plus déterminante.
Dave Rensin, ingénieur chez Google | Lorsque les agents produisent plus de code qu’un humain ne peut raisonnablement en lire, les décisions écrites prennent davantage de valeur. | Le design doc devient une interface stable entre l’intention humaine et l’exécution agentique.

Ces constats ne signifient pas que le code n’a plus d’importance. Ils signifient que la frappe manuelle du code n’est plus nécessairement l’activité la plus rare.
La valeur se déplace vers les activités que l’agent ne peut pas déduire correctement sans contexte : comprendre le problème, arbitrer les compromis, choisir les risques acceptables, définir ce qui compte et assumer le résultat.

Le nouveau flux : Framing, implémentation et validation
Le Framing
Le Framing transforme une demande vague en contrat d’ingénierie. Il ne consiste pas uniquement à écrire un meilleur prompt. Il consiste à définir les informations qui doivent rester vraies pendant toute l’implémentation.

Élément | Question à résoudre
---|---
Problème | Quelle difficulté utilisateur ou opérationnelle doit être résolue ?
Résultat | Quel comportement observable doit changer ?
Périmètre | Qu’est-ce qui appartient explicitement au changement ?
Non-objectifs | Qu’est-ce qui ne doit pas être construit maintenant ?
Contraintes | Quelles limites techniques, produit, juridiques ou de sécurité doivent être respectées ?
Conception | Quelles frontières, données, API et responsabilités doivent être conservées ?
Critères d’acceptation | Quels exemples permettent de distinguer un résultat correct d’un résultat incorrect ?
Quality gates | Quelles preuves devront être produites avant de considérer le changement comme terminé ?
Risques | Quels échecs sont plausibles, et comment seront-ils détectés ou annulés ?

Le cadrage ne doit pas décrire chaque ligne de code. Il doit définir un espace de solution suffisamment précis pour empêcher l’agent de construire une solution plausible, mais incorrecte.

L’implémentation agentique
Une fois le cadrage validé, l’agent peut disposer d’une marge de manœuvre importante sur l’exécution.
L’humain définit principalement :
Ce qui doit changer.
Pourquoi ce changement existe.
Ce qui ne doit pas changer.
Les contraintes à respecter.
Les preuves attendues.
Le niveau de risque acceptable.

L’agent peut ensuite déterminer :
Quels fichiers explorer.
Quels symboles rechercher.
Quel ordre d'implémentation suivre.
Quels tests existants réutiliser.
Quelles commandes exécuter.
Comment corriger les erreurs rencontrées.

Cette division du travail ne dispense pas le développeur de comprendre le système. Pour déléguer correctement, il doit savoir reconnaître une architecture fragile, une abstraction prématurée, un test trompeur ou une modification hors périmètre.

La validation
Le terme validation recouvre deux questions différentes.

Question | Activité | Exemple
---|---|---
Avons-nous correctement construit ce qui était demandé ? | Vérification. | Comparer le diff, les tests et le comportement aux spécifications.
Avons-nous construit la bonne chose ? | Validation produit. | Observer l’usage, la production et l’effet obtenu pour l’utilisateur.

Un changement peut passer tous les tests tout en répondant au mauvais besoin. Il peut également satisfaire une démonstration locale tout en échouant dans les conditions réelles de production.
La validation complète doit donc relier le contrat initial au comportement du système réel.

Le design doc : l’interface entre l’intention et l’agent
Une revue de code avant le code
Chez Google, les changements importants commencent fréquemment par un design doc soumis à discussion et à approbation.
Le document décrit les objectifs, la stratégie d’implémentation, les principales décisions et les compromis associés. Il présente également les alternatives envisagées, leurs avantages et leurs faiblesses.
La revue du design doc agit comme une revue de code avant que le coût du code n’ait été engagé. Elle permet de détecter une mauvaise frontière, un risque de sécurité, une dépendance inutile ou une solution disproportionnée avant leur propagation dans le dépôt.
Avec un agent rapide, cette propriété devient encore plus importante. Une mauvaise décision architecturale peut être implémentée dans des dizaines de fichiers avant que l’équipe ne constate que le point de départ était incorrect.

Le contenu utile d’un design doc
Il n’existe pas de structure universelle, mais un document exploitable par une équipe et par un agent doit couvrir les informations suivantes.

Section | Contenu attendu
---|---
Contexte | État actuel, utilisateurs concernés et raison du changement.
Problème | Difficulté précise à résoudre, sans imposer immédiatement une solution.
Objectifs | Résultats observables que le changement doit produire.
Non-objectifs | Extensions volontairement exclues du périmètre.
Contraintes | Compatibilité, performance, sécurité, confidentialité, coût et exploitation.
Options | Solutions envisagées et compromis de chacune.
Décision | Solution retenue et justification.
Architecture | Composants, responsabilités, flux de données et interdictions.
Interfaces | Commandes, API, schémas, événements ou contrats exposés.
Migration | Compatibilité avec l’existant, déploiement progressif et retour arrière.
Validation | Tests, démonstrations, métriques et observations attendues.
Questions ouvertes | Incertitudes restantes et personnes responsables de leur résolution.

Un document de décision, pas une spécification infinie
Un design doc ne doit pas prédire chaque détail de l’implémentation. Un document trop long peut cacher les décisions importantes sous des informations secondaires.
Il doit surtout rendre explicites les éléments difficiles à reconstruire depuis le code :
Pourquoi cette solution a été choisie.
Quelles alternatives ont été rejetées.
Quelles contraintes ne doivent jamais être violées.
Quels risques ont été acceptés.
Quelles preuves détermineront la réussite.
Quels éléments sont volontairement hors périmètre.

Le code indique ce que le système fait. Le design doc préserve pourquoi il doit le faire de cette manière.

Construire un socle avant d’accumuler les fonctionnalités
Le socle
Le socle est l’environnement minimal qui rend le travail reproductible et vérifiable.
Il contient notamment :

Élément | Rôle
---|---
Structure du dépôt | Matérialiser les principales frontières d’architecture.
Gestion des dépendances | Installer et verrouiller l’environnement de manière reproductible.
Commandes standard | Fournir une interface stable pour le lint, les types, les tests et le build.
Tests initiaux | Prouver que l’environnement peut exécuter les validations.
CI | Rejouer les preuves hors de la machine du développeur.
Règles de contribution | Définir ce qu’un changement doit fournir avant la revue.
Observabilité minimale | Permettre de comprendre les comportements lorsqu’ils s’exécutent réellement.

Ce socle réduit l’espace dans lequel un agent peut produire un changement apparemment correct sans preuve reproductible.
Un agent est plus fiable lorsqu’il peut appeler une commande stable et recevoir un verdict explicite :
pnpm lint
pnpm typecheck
pnpm test
pnpm build

Ces commandes ne prouvent pas que le produit répond au bon besoin. Elles constituent néanmoins des contraintes déterministes que l’agent ne peut pas remplacer par une explication convaincante.

Le walking skeleton
Un walking skeleton est une implémentation minuscule qui relie les principaux composants du système de bout en bout.
Il doit pouvoir être construit, exécuté et testé. Il ne doit pas seulement montrer que les dossiers existent ou que le compilateur démarre.
Pour un CLI, le premier walking skeleton pourrait :
Recevoir une commande.
Lire une entrée réelle.
Appeler le moteur principal.
Produire une sortie.
Retourner un code de sortie.
Passer dans la CI.

La logique métier peut encore être extrêmement petite. L’objectif est de valider le chemin architectural et opérationnel complet.

La tranche verticale
Une tranche verticale ajoute un comportement cohérent et observable à travers toutes les couches nécessaires.
Elle ne construit pas d’abord toute la base de données, puis toute l’API, puis toute l’interface. Elle choisit un cas d’usage fin et le termine de bout en bout.

Approche horizontale | Tranche verticale
---|---
Construire tous les modèles de données. | Construire uniquement les données nécessaires à un comportement.
Construire toutes les routes de l’API. | Construire une route utilisable de bout en bout.
Construire toute l’interface. | Rendre un parcours utilisateur minimal fonctionnel.
Tester les couches isolément. | Prouver le comportement complet traversant les couches.

Le Framing devient un travail d’ingénierie
Passer d’une demande à un contrat exécutable
Une demande comme « ajoute l’authentification » ou « crée un linter pour Claude Code » ne constitue pas un cadrage suffisant.
Elle ne définit ni le comportement attendu, ni les limites, ni les risques, ni les preuves.
Un contrat de cadrage plus exploitable peut suivre cette structure :

Problème :
quel comportement actuel est insuffisant ?
Résultat attendu :
quel changement observable doit être obtenu ?
Utilisateurs concernés :
qui utilise ou subit ce comportement ?
Périmètre :
quels cas doivent être couverts ?
Non-objectifs :
quels cas sont volontairement repoussés ?
Contraintes :
quelles règles techniques et produit doivent rester vraies ?
Conception :
quelles frontières et interfaces doivent être utilisées ?
Critères d'acceptation :
quels exemples prouvent que le comportement est correct ?
Validation :
quels tests, commandes, artefacts et observations sont exigés ?
Risques :
quels échecs doivent être anticipés ?
Retour arrière :
comment annuler le changement sans incident ?

Plus l’agent est autonome, plus ce contrat doit définir clairement les limites et le critère d’arrêt.

Définir les quality gates avant le code
Une quality gate est une condition observable qui doit être satisfaite avant de poursuivre ou de terminer une phase.
Elle doit être définie avant l’implémentation. Dans le cas contraire, l’équipe risque de choisir après coup les preuves qui confirment ce qui a déjà été construit.

Gate | Question | Preuve
---|---|---
Cadrage | Le problème et le périmètre sont-ils compris sans contexte caché ? | Relecture du design doc par une personne ou un agent indépendant.
Conception | Les frontières, risques et compromis sont-ils acceptables ? | Approbation explicite de la décision technique.
Implémentation | Le changement respecte-t-il le contrat et reste-t-il dans son périmètre ? | Diff ciblé et comparaison avec le plan.
Qualité technique | Le changement respecte-t-il les contraintes déterministes ? | Lint, types, tests, analyse statique et build.
Comportement | Le flux complet fonctionne-t-il dans un environnement réaliste ? | Test d’intégration, test de bout en bout ou démonstration reproductible.
Revue | Un regard indépendant a-t-il recherché les erreurs importantes ? | Revue agentique et revue humaine proportionnées au risque.
Livraison | Le changement se comporte-t-il correctement hors de l’environnement local ? | Déploiement progressif, métriques, journaux et absence de régression observable.

La gate n’indique pas à l’agent comment écrire le code. Elle lui indique ce que le résultat doit prouver.

La validation devient un système
Ne pas réduire la validation à une suite de tests
Les tests automatisés sont essentiels, mais aucune catégorie de test ne suffit seule.
Une validation robuste combine plusieurs niveaux dont les erreurs ne sont pas parfaitement corrélées.

Niveau | Rôle | Exemples
---|---|---
Analyse statique | Détecter rapidement des violations mécaniques. | Lint, types, formatage, analyse de dépendances et recherche de secrets.
Tests unitaires | Vérifier des comportements isolés et des cas limites. | Entrées valides, invalides, valeurs limites et erreurs attendues.
Tests de propriétés | Vérifier des invariants sur un grand nombre d’entrées. | Idempotence, conservation, absence d’exception ou stabilité d’un format.
Tests d’intégration | Vérifier les contrats entre composants réels. | Base de données, système de fichiers, file de messages ou service externe simulé.
Tests de bout en bout | Vérifier le parcours depuis l’entrée utilisateur jusqu’au résultat final. | Commande réelle, navigateur, API publique ou installation complète.
Revue du diff | Détecter les changements hors périmètre, les risques et les incohérences. | Comparaison du code, des tests et du design doc.
Validation en environnement | Vérifier le comportement dans des conditions proches de la production. | Environnement de prévisualisation, données réalistes et tests exploratoires.
Observation en production | Confirmer les effets réels et détecter les comportements imprévus. | Métriques, traces, journaux, alertes, retours utilisateurs et indicateurs produit.

Faire travailler l’agent producteur contre des preuves
L’agent qui implémente doit recevoir des critères qu’il peut vérifier lui-même.

Implémente le changement décrit dans le design doc.
Avant de modifier le code :
- identifie les fichiers concernés ;
- localise les tests existants ;
- liste les critères d'acceptation ;
- signale les ambiguïtés bloquantes.
Pendant l'implémentation :
- reste dans le périmètre ;
- ajoute ou adapte les tests ;
- ne désactive aucune validation ;
- n'abaisse aucun seuil de qualité.
Avant de terminer :
- exécute les validations ;
- inspecte le diff ;
- compare le résultat au design doc ;
- fournis les commandes exécutées et leurs résultats.

L’agent ne doit pas seulement affirmer que le travail fonctionne. Il doit produire les artefacts permettant à une autre partie de le constater.

Utiliser un agent indépendant pour la revue
L’agent qui a produit le changement connaît son propre raisonnement. Il peut donc reproduire les mêmes hypothèses pendant la revue.
Un second agent, lancé dans un contexte neuf, dispose d’une distribution d’erreurs partiellement différente. Il peut recevoir uniquement :
Le design doc.
Les critères d'acceptation.
Le diff.
Les résultats des validations.
Les instructions de revue.

Sa mission doit rechercher les écarts importants, pas produire une liste infinie de préférences stylistiques.

Relis ce diff comme un reviewer indépendant.
Compare-le au design doc.
Recherche uniquement :
- exigence absente ;
- comportement incorrect ;
- cas limite non traité ;
- régression ;
- risque de sécurité ;
- modification hors périmètre ;
- test insuffisant ou trompeur ;
- violation d'une frontière d'architecture.
Ne signale pas les préférences stylistiques sans impact.
Ne propose pas d'abstraction supplémentaire sans besoin concret.
Classe les constats par gravité et fournis une preuve pour chacun.

Cette revue peut être exécutée localement ou dans la pull request. Elle constitue un capteur supplémentaire, pas une autorisation automatique de fusion.

Examiner les modifications de tests
Un agent peut modifier un test pour l’adapter au comportement qu’il vient de produire. Cette modification peut être correcte, mais elle peut également masquer une régression en remplaçant l’attente initiale par le nouveau comportement erroné.
Une pull request qui modifie fortement les tests exige donc une revue particulière.

Pour chaque test modifié :
- quelle exigence justifie le changement ?
- l'ancien comportement était-il incorrect ?
- le test est-il devenu moins strict ?
- une assertion a-t-elle été supprimée ?
- un cas limite a-t-il disparu ?
- le test échoue-t-il réellement sans le correctif ?

Un indicateur vert n’a de valeur que si le système de mesure lui-même est digne de confiance.

Garder une responsabilité humaine sur la fusion
Les agents peuvent produire le code, les tests, la revue et même une recommandation de fusion. Ils ne portent pas la responsabilité opérationnelle du changement.
La personne qui accepte la pull request doit pouvoir expliquer :
Pourquoi le changement existe.
Pourquoi cette conception a été retenue.
Quelles preuves ont été examinées.
Quels risques subsistent.
Comment le changement sera observé.
Comment il pourra être annulé.

La revue humaine peut être plus ciblée grâce aux agents et aux contrôles déterministes. Elle ne doit pas devenir une validation symbolique.

Le nouveau tableau de flux
Faire apparaître le travail devenu rare
Un tableau centré uniquement sur l’écriture du code masque les nouvelles files d’attente.
Un flux adapté au développement agentique peut être représenté ainsi :

À cadrer
↓
Cadrage en cours
↓
Cadrage validé
↓
Implémentation agentique
↓
Preuves à produire
↓
Revue et validation
↓
Déployé et observé
↓
Terminé

Colonne | Condition d’entrée | Condition de sortie
---|---|---
À cadrer | Une opportunité, un problème ou une demande existe. | Une personne est responsable du cadrage.
Cadrage en cours | Le problème est prioritaire. | Objectifs, non-objectifs, conception et gates sont explicites.
Cadrage validé | Le document a été relu. | Un agent sans contexte caché peut expliquer et exécuter le plan.
Implémentation agentique | Le contrat est stable. | Le diff est produit et reste dans le périmètre.
Preuves à produire | Le comportement semble implémenté. | Toutes les validations requises sont exécutées et enregistrées.
Revue et validation | La pull request contient le contexte, le diff et les preuves. | Les constats importants sont corrigés ou explicitement acceptés.
Déployé et observé | Le changement peut être exposé sans risque disproportionné. | Le comportement réel est cohérent avec le résultat attendu.
Terminé | La vérification et la validation sont suffisantes pour le niveau de risque. | Le changement est intégré, compris, observable et maintenable.

Limiter le travail de cadrage et de validation
Lorsque l’implémentation devient rapide, lancer davantage d’agents ne résout pas nécessairement le goulot. Cela peut uniquement augmenter le nombre de changements en attente de revue.
Les limites de travail en cours doivent donc protéger les ressources rares :

Limiter le nombre de cadrages ouverts.
Limiter le nombre de changements implémentés sans preuves.
Limiter la taille des pull requests.
Limiter le nombre de pull requests en attente de revue.
Terminer la validation avant de lancer davantage de génération.

Une petite pull request n’est plus seulement une courtoisie envers le reviewer. Elle devient une contrainte d’architecture du processus de validation.

Le nouveau rôle du développeur
Cadreur de problèmes
Le développeur doit distinguer la demande formulée du problème réel. Il recherche les hypothèses cachées, les besoins contradictoires, les cas limites, les utilisateurs concernés et les conséquences opérationnelles.
Une mauvaise demande transmise à un agent rapide produit une mauvaise solution plus rapidement.

Concepteur de systèmes
Le développeur définit les composants, leurs responsabilités, leurs interfaces et leurs interdictions. Il choisit les compromis entre simplicité, performance, sécurité, maintenabilité, coût et vitesse de livraison.
L’agent peut proposer plusieurs architectures. La responsabilité du choix reste humaine.

Concepteur de l’environnement des agents
Un agent dépend fortement de son environnement. Le développeur construit donc le système qui rend le travail de l’agent fiable :
Contexte projet court et pertinent.
Commandes de validation stables.
Tests représentatifs.
Fixtures réalistes.
Permissions limitées.
Règles d'architecture explicites.
Environnements reproductibles.
Boucles de revue indépendantes.
Observabilité exploitable.

La productivité ne dépend plus uniquement de la qualité du modèle. Elle dépend de la qualité du système dans lequel le modèle agit.

Évaluateur
Le développeur définit ce qui constitue un bon résultat et organise les moyens de le mesurer. Il transforme autant que possible les attentes implicites en signaux vérifiables : tests, contrats, exemples, seuils, invariants, comparaisons visuelles, métriques ou politiques automatisées.
Lorsqu’un agent ou un reviewer signale régulièrement le même problème, le développeur transforme ce retour en contrôle déterministe plutôt que de le répéter indéfiniment dans les instructions.

Reviewer responsable
Le développeur ne relit pas uniquement la syntaxe. Il examine les intentions, les compromis, les risques, les tests et les conséquences en production. Il sait également ignorer les remarques agentiques qui n’améliorent ni la correction, ni la sécurité, ni le respect des exigences. Une revue qui poursuit chaque suggestion produit de la sur-ingénierie.

Opérateur du logiciel
Le travail ne s’arrête pas au moment de la fusion. Le développeur doit pouvoir suivre le changement dans son environnement réel, observer son effet, identifier une régression et déclencher un retour arrière.
Les tests indiquent ce qui s’est produit dans les scénarios prévus. La production révèle ce qui se produit dans les scénarios que personne n’avait anticipés.
