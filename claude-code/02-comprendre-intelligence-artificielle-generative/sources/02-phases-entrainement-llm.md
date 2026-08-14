# Les phases d'entraînement d'un LLM

*Claude : fondations → 2. Comprendre l'intelligence artificielle générative → 2. Les phases d'entraînement d'un LLM*

Un LLM ne naît pas avec la capacité de répondre à des questions, de résumer un document ou de rédiger un texte structuré. Il apprend progressivement à partir de très grands volumes de données, puis il est ajusté pour devenir plus utile, plus clair et plus adapté aux demandes humaines.

Entraîner un LLM, ce n'est pas lui donner une liste de règles à apprendre par cœur. C'est ajuster des milliards de valeurs numériques internes pour qu'il devienne capable de prédire, comprendre et produire du langage.

Ces valeurs numériques internes s'appellent des **paramètres**, ou parfois des **weights** (poids).

Le principe général est le suivant : on donne au modèle beaucoup d'exemples, on mesure ses erreurs, puis on modifie progressivement ses paramètres pour réduire ces erreurs.

---

## Quatre repères pour comprendre l'entraînement

L'entraînement d'un LLM s'appuie sur quatre repères fondamentaux :

1. **Le modèle apprend sur des données** : Textes, code, documents, conversations, exemples annotés et parfois contenus multimodaux.
2. **Le modèle apprend à prédire** : La phase centrale consiste à prédire le prochain token.
3. **Le modèle apprend par correction progressive** : Chaque prédiction est comparée à la suite attendue, puis les paramètres sont ajustés.
4. **Le modèle est ensuite ajusté (aligné)** : Après l'entraînement brut, il est affiné pour mieux suivre les consignes humaines.

> **Rappels** :
> - Un **token** est l'unité de texte de base du modèle (mot, partie de mot, ponctuation).
> - L'**alignement** désigne les techniques qui cherchent à rendre le modèle plus utile, plus clair, plus prudent et plus conforme aux attentes humaines.

---

## Vue d'ensemble des grandes phases de l'entraînement

L'entraînement d'un LLM se divise en plusieurs phases successives :

| Phase | Nom technique | Rôle principal |
|---|---|---|
| **Phase 1** | Préparation des données | Constitution et nettoyage du *dataset*. |
| **Phase 2** | Pretraining (Pré-entraînement) | Apprentissage général du langage et prédiction du prochain token à très grande échelle. |
| **Phase 3** | SFT (Supervised Fine-Tuning) | Ajustement supervisé pour apprendre au modèle à répondre à des consignes. |
| **Phase 4** | Alignement (RLHF / RLAIF / DPO) | Optimisation du comportement selon les préférences humaines (utilité, ton, sécurité). |
| **Phase 5** | Évaluation et tests | Mesure des performances via des benchmarks et des tests humains. |
| **Phase 6** | Déploiement et inference | Utilisation opérationnelle du modèle figé. |

---

## Phase 1 : Préparer les données (Le Dataset)

Le point de départ de tout LLM est son **dataset** (ensemble de données), qui peut contenir des milliers de milliards de tokens.

### Les types de données utilisées
- **Textes généraux** : Articles, livres, pages web, encyclopédies, documents publics.
- **Textes techniques** : Documentation, manuels, papiers scientifiques.
- **Code** : Fichiers de programmation, dépôts de code (GitHub), commentaires.
- **Données conversationnelles** : Dialogues d'assistance, questions/réponses.
- **Données spécialisées** : Textes juridiques, financiers ou médicaux.

### Le nettoyage des données
Les données brutes d'Internet contiennent beaucoup de "bruit" (publicités, doublons, caractères corrompus, fragments incomplets). Il faut donc effectuer :
- **La déduplication** : Retirer les contenus répétés pour éviter que le modèle ne leur donne trop d'importance.
- **Le filtrage** : Sélectionner les données selon la langue, la qualité et la pertinence. L'équilibre du dataset oriente les futures forces du modèle (ex: un modèle entraîné sur beaucoup de code sera meilleur en programmation).

### Les ensembles de données (Split)
Les données sont séparées en trois ensembles :
- **Training set** : Utilisé directement pour modifier les paramètres du modèle.
- **Validation set** : Sert à suivre les performances pendant l'entraînement et à comparer les versions du modèle.
- **Test set** : Utilisé pour évaluer le modèle à la toute fin sur des données qu'il n'a jamais vues, vérifiant sa capacité à généraliser.

---

## Phase 2 : Pré-entraîner le modèle (Pretraining)

Le **pretraining** est la phase où le modèle apprend les structures générales du langage. C'est la phase la plus lourde en calcul, en temps et en coût financier.

### Le principe du prochain token
À partir d'une séquence de texte, le modèle tente de deviner le token suivant. Au début, ses paramètres étant aléatoires, il fait des erreurs. L'écart entre sa prédiction et le token attendu est mesuré par une fonction mathématique appelée la **loss function** (fonction de perte ou d'erreur). Le but de l'entraînement est de réduire cette loss.

### Les mécanismes de correction
- **La backpropagation (rétropropagation)** : Calcule la contribution de chaque paramètre (weight) à l'erreur commise par le modèle. L'erreur est propagée en sens inverse dans les couches de calcul.
- **La descente de gradient (gradient descent)** : Ajuste les paramètres dans la direction qui réduit l'erreur (comme descendre une montagne dans le brouillard en suivant la pente locale).
- **Le learning rate (taux d'apprentissage)** : Détermine l'ampleur des ajustements de paramètres. S'il est trop bas, l'apprentissage est trop lent ; s'il est trop haut, le modèle devient instable.

### Organisation de l'apprentissage
- **Batch** : Les données sont traitées par petits lots d'exemples. Le modèle lit un batch, calcule la loss, ajuste ses paramètres, puis passe au batch suivant.
- **Epoch** : Un passage complet sur l'ensemble du dataset.
- **Checkpoint** : Sauvegarde intermédiaire de l'état du modèle pendant son entraînement (permet de reprendre l'apprentissage en cas de panne de machine).

### La puissance de calcul
L'entraînement nécessite des milliers de processeurs spécialisés fonctionnant en parallèle :
- **GPU** (*Graphics Processing Unit*) : Processeur graphique très efficace pour les calculs matriciels en parallèle.
- **TPU** (*Tensor Processing Unit*) : Processeur spécialisé conçu par Google spécifiquement pour l'IA.
- **Le parallélisme** : Répartition complexe des calculs et du modèle lui-même entre des grappes (clusters) de machines qui doivent rester synchronisées en permanence.

---

## Phase 3 : Ajuster le modèle avec le SFT

Après le pretraining, le modèle sait générer du texte fluide, mais il tend à imiter ou compléter des phrases plutôt qu'à obéir à des consignes (ex: à la question *"Peux-tu résumer ce texte ?"*, il pourrait répondre en écrivant *"Peux-tu traduire ce texte ?"* par pure logique de complétion).

Le **SFT** (*Supervised Fine-Tuning* ou ajustement supervisé) corrige cela en entraînant le modèle sur un dataset propre de dialogues structurés sous forme de **consignes / réponses idéales**. Il apprend ainsi à se comporter en assistant qui répond à des tâches précises (résumer, traduire, coder, expliquer).

---

## Phase 4 : Aligner le modèle sur des préférences

L'alignement façonne les réponses du modèle pour qu'elles correspondent aux attentes qualitatives, éthiques et de ton des humains. On compare plusieurs réponses générées par le modèle pour une même question, et on indique laquelle est préférable.

Plusieurs techniques sont utilisées :
- **RLHF** (*Reinforcement Learning from Human Feedback*) : Des humains évaluent et classent les réponses. Ces préférences entraînent un modèle de récompense (*reward model*) qui va à son tour ajuster le LLM pour qu'il produise des réponses à score élevé.
- **RLAIF** (*Reinforcement Learning from AI Feedback*) : Un autre modèle d'IA plus puissant remplace ou assiste les humains dans le classement pour rendre la méthode scalable (capable de passer à l'échelle).
- **DPO** (*Direct Preference Optimization*) : Simplifie le RLHF en ajustant directement les paramètres du modèle à partir des paires de préférences (bonne vs mauvaise réponse), sans passer par un modèle de récompense séparé.

Le **post-training** regroupe toutes ces phases (SFT + Alignement) qui transforment le socle brut du pretraining en un assistant fluide et sécurisé.

---

## Phase 5 : Évaluer le modèle

Avant le déploiement, on mesure les capacités du modèle :
- **Les benchmarks** : Tests standardisés et automatisés évaluant le raisonnement, les mathématiques, le code (ex: *HumanEval*), la compréhension de texte.
- **Les tests humains** : Évaluateurs qui notent le style, le ton, l'utilité globale et la sécurité de la réponse.
- **La comparaison de checkpoints** : Permet de choisir la version offrant le meilleur compromis de performance.

---

## Phase 6 : Déployer et utiliser le modèle (L'Inference)

Une fois finalisé, le modèle est figé et déployé via des applications ou des API. 

L'utilisation du modèle est appelée l'**inference** (inférence) :
- Pendant l'**entraînement et l'ajustement**, les paramètres (weights) sont **modifiés** à chaque calcul d'erreur.
- Pendant l'**inference** (l'utilisation par l'utilisateur), les paramètres restent **fixes**. Le prompt de l'utilisateur fournit un contexte de travail temporaire, mais ne réentraîne pas le modèle sous-jacent.

---

## Synthèse des différences clés

| Phase | Modification des paramètres | Objectif | Consommation ressources |
|---|---|---|---|
| **Entraînement (Pretraining)** | Oui (massivement) | Apprendre la structure du langage et prédire le prochain token. | Énorme (millions de dollars, GPU/TPU). |
| **Ajustement (SFT + Alignement)** | Oui (finement) | Apprendre à suivre des consignes et adopter un ton utile et sûr. | Modérée (post-training ciblé). |
| **Utilisation (Inference)** | Non (paramètres figés) | Répondre à une demande en utilisant un contexte temporaire. | Faible par requête. |
