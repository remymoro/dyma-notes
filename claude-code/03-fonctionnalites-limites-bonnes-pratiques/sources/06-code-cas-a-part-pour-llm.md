# Pourquoi le code est un cas à part pour les LLM

*Claude : fondations → 3. Fonctionnalités, limites et bonnes pratiques → 6. Pourquoi le code est un cas à part pour les LLM*

Pour la majorité des développeurs, le premier contact sérieux avec un LLM appliqué au code est souvent un choc positif. En quelques secondes, le modèle génère une fonction cohérente, propose une implémentation raisonnable, explique un algorithme existant ou refactorise un bloc de code de manière lisible. 

Cette efficacité est réelle, mais elle est aussi profondément trompeuse. Elle repose sur des propriétés spécifiques du code en tant qu’objet linguistique et formel, et non sur une compréhension conceptuelle ou d'exécution informatique.

L’objectif de cette leçon est de déconstruire ce paradoxe : comprendre pourquoi les LLM fonctionnent si bien pour coder, et pourquoi cette performance ne doit jamais être interprétée comme une garantie de justesse.

---

## 1. Le code comme langage artificiel contraint

Contrairement au langage naturel, le code est conçu pour éliminer toute ambiguïté. Chaque langage impose une grammaire stricte, des règles de composition rigides et un vocabulaire fini. Cette contrainte formelle réduit drastiquement l’espace des séquences statistiquement valides.

Pour un modèle probabiliste, cette contrainte est un avantage considérable. Après un mot-clé comme `if`, `for`, `return` ou `class`, le nombre de suites plausibles est très limité. Le modèle n'a pas besoin de naviguer dans un vaste espace sémantique ; il suit des chemins syntaxiques hautement balisés dans ses données d'entraînement. C'est pourquoi les LLM excellent dans la **complétion locale de code**.

---

## 2. La répétitivité structurelle et les patterns récurrents

Les projets logiciels modernes reposent sur un nombre relativement restreint de patterns récurrents (ex: contrôleurs REST, requêtes de bases de données, gestion d'erreurs, tests unitaires, formulaires de validation).

Les LLM ont été exposés à ces structures à une échelle massive (millions de dépôts Open Source). Ils reproduisent donc des formes statistiques stabilisées très idiomatiques d'un écosystème, sans pour autant comprendre la logique métier ou l'intention de l'application.

---

## 3. Le poids des conventions sociales

Le code est un objet social, écrit par des humains pour être relu par d'autres humains. Cette nature induit des conventions de nommage (`validateEmail`, `fetchUserData`), d'organisation de dossiers ou de styles de commentaires. 

Le LLM apprend ces conventions par exposition statistique. Cette conformité sociale du code généré renforce l'illusion de "bonne compréhension" pour le relecteur humain. Toutefois, le modèle applique le pattern le plus fréquent globalement, même s'il contredit les conventions locales ou spécifiques d'un projet d'entreprise.

---

## 4. L'externalisation du raisonnement logique

Dans le code, le raisonnement humain est matérialisé de façon explicite par la syntaxe (boucles, branchements conditionnels, types). Contrairement au langage naturel où les liens logiques ou causaux sont souvent implicites ou sous-entendus, le code force à tout écrire explicitement. Cette externalisation de la logique dans la grammaire même réduit la charge cognitive du modèle.

---

## L'illusion de compréhension sémantique

Le modèle probabiliste n'a aucune notion de ce que fait un programme lorsqu'il s'exécute. Il ne connaît pas la pile d'exécution (*stack*), l'allocation de mémoire (*heap*) ni les changements d'état mutable. 
- **Code correct** : Le LLM a assemblé des patterns fréquemment observés compatibles entre eux.
- **Code incorrect** : Le LLM a combiné des patterns plausibles mais incompatibles à l'exécution.

---

## Limites spécifiques et hallucinations de code

- **Hallucinations d'APIs** : Création de méthodes ou de paramètres plausibles mais inexistants dans les bibliothèques réelles (l'IA invente une signature de fonction qui "semble" logique).
- **Mélanges de versions** : Fusion de morceaux de code obsolètes et récents d'un framework au sein d'une même fonction, produisant un code syntaxiquement correct mais impossible à exécuter.
- **Absence totale de vérification interne** : Un LLM ne compile pas, ne linter pas et ne résout pas les dépendances. Toute garantie de validité doit provenir d'outils externes (compilateurs, linters, tests unitaires, revue humaine).

---

## Pourquoi le code reste le meilleur terrain d'application

Malgré ses limites, le code possède une caractéristique unique : il est **évaluable de manière déterministe**. 
On peut soumettre chaque proposition de l'IA à des tests objectifs :
1. *Est-ce que le code compile ?*
2. *Est-ce que les linters et types sont respectés ?*
3. *Est-ce que les tests unitaires passent ?*

Cette vérifiabilité immédiate permet d'intégrer le LLM dans des boucles de feedback automatisées rapides (comme Claude Code ou les extensions d'IDE) pour corriger ses propres erreurs de manière autonome.

---

## Posture recommandée pour le développeur

Le développeur doit adopter une posture de **contrôle et de scepticisme bienveillant** :
- Considérer le modèle comme un accélérateur de propositions et d'écriture, jamais comme une source de vérité.
- Conserver la responsabilité de l'exécution, de la sécurité et des choix d'architecture.
- Utiliser systématiquement la validation outillée (compilateur, suite de tests) pour éliminer les hallucinations logiques.
