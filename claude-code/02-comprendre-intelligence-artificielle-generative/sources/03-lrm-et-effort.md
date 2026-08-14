# Du LLM classique au modèle de raisonnement (LRM)

*Claude : fondations → 2. Comprendre l'intelligence artificielle générative → 3. Les LRM et l'effort*

![Du LLM classique au modèle de raisonnement (LRM)](../assets/lrm-classique-vs-raisonnement-3.jpg)

Un LLM classique est d'abord un modèle qui produit des tokens. Il reçoit un contexte, transforme ce contexte en représentations numériques, puis prédit progressivement les tokens les plus appropriés pour produire une réponse.

Cette description est correcte, mais elle ne suffit plus à expliquer les modèles récents. Certains modèles ne se contentent pas de produire directement une réponse visible. Ils peuvent consacrer davantage de calcul à la demande, décomposer le problème, tester plusieurs pistes, vérifier des contraintes, revenir en arrière ou utiliser des outils externes. C'est pour cela qu'on distingue de plus en plus les LLM généralistes des modèles orientés raisonnement.

---

## Le point de départ : la génération directe

Dans une utilisation simple, le modèle peut répondre presque directement car la tâche est courte, demande peu d'analyse et repose sur des motifs simples dans le texte.

*Exemples :*
- *"Reformule cette phrase dans un style plus professionnel."*
- *"Classe ce message en urgent, normal ou faible priorité."*

Mais toutes les demandes ne sont pas de ce type. Une demande plus complexe peut ressembler à ceci :
> *"Compare ces trois offres commerciales, identifie les risques, distingue les critères financiers des critères opérationnels, puis recommande une option pour une entreprise qui veut réduire ses coûts sans perdre en qualité de service."*

Ici, une réponse directe est insuffisante. Le modèle doit identifier les critères, comparer les options, maintenir plusieurs contraintes en même temps, éviter une conclusion trop rapide et justifier sa recommandation.

### Pourquoi certaines tâches demandent un raisonnement plus long
Une tâche devient difficile lorsqu'elle impose d'organiser la résolution du problème en combinant plusieurs opérations :
- Lire plusieurs documents.
- Comparer plusieurs options et repérer des contradictions.
- Faire un calcul mathématique et vérifier des hypothèses.
- Respecter un format strict tout en tenant compte d'un contexte métier complexe.

Un modèle faible peut répondre vite mais oublier des contraintes. Un modèle plus robuste prendra davantage de temps pour mieux gérer les étapes intermédiaires.

---

## Les LRM : modèles de langage orientés raisonnement

On rencontre l'expression **LRM** pour *Large Reasoning Model* (grand modèle de raisonnement). Un LRM n'est pas un outil totalement séparé des LLM ; c'est un LLM entraîné, ajusté ou configuré pour mieux traiter les tâches qui demandent plusieurs étapes de planification, de vérification et de raisonnement sous contraintes.

Les performances des modèles de raisonnement augmentent non seulement avec la puissance de calcul à l'entraînement, mais aussi avec le calcul utilisé au moment de la réponse : c'est le **test-time compute** (calcul à l'inférence).

### Analogie avec la "Dual Process Theory"
En psychologie cognitive, cette théorie popularisée par Daniel Kahneman distingue deux modes de pensée chez l'humain : le **Système 1** (rapide, intuitif et automatique) et le **Système 2** (lent, analytique et délibéré). 

Bien qu'un modèle d'IA ne pense pas et n'ait pas d'intuition consciente, l'analogie est très utile pour comparer les deux comportements :

| Caractéristique | Système 1 (Humain) / Génération directe (IA) | Système 2 (Humain) / Délibération computationnelle (IA) |
|---|---|---|
| **Chez l'humain** | Réaction immédiate, reconnaissance de motif, réponse intuitive. | Analyse plus lente, vérification, correction d'une première intuition. |
| **Dans un modèle** | Génération directe d'une réponse courte ou simple. | Utilisation de davantage de calcul, de tokens intermédiaires ou de vérifications. |

---

## Les tokens de raisonnement (Thinking Tokens)

Quand un utilisateur reçoit une réponse, il voit les **output tokens** (tokens de sortie visibles : phrases, tableaux, code). 

Mais certains modèles de raisonnement utilisent des **thinking tokens** (tokens de raisonnement ou intermédiaires) avant de produire la réponse finale. Ces tokens servent à :
- Décomposer une tâche en sous-problèmes.
- Formuler des hypothèses et comparer plusieurs pistes.
- Détecter des erreurs et revenir en arrière (backtracking).

Dans de nombreux systèmes, l'utilisateur ne voit qu'un résumé ou une conclusion de ce raisonnement interne, mais pas toutes les étapes. Ainsi, une réponse très courte (ex: *"L'option 2 est la plus équilibrée car..."*) peut avoir nécessité des milliers de tokens de calcul internes non affichés.

---

## Contrôler le raisonnement : Thinking Budget et Reasoning Effort

### Le test-time compute
Comme la qualité d'une réponse complexe dépend du temps de calcul accordé, l'utilisateur a intérêt à pouvoir contrôler la quantité de calcul à l'inférence (test-time compute).

### Le thinking budget
C'est le budget de réflexion ou de raisonnement (utilisé par Anthropic). C'est un paramètre permettant d'allouer un nombre de tokens de calcul maximum réservé au raisonnement. Plus le budget est élevé, plus le modèle peut explorer et corriger, mais cela augmente la latence, le coût et la consommation de tokens.

### Le reasoning effort
Le reasoning effort (effort de raisonnement, utilisé par OpenAI avec le paramètre `reasoning.effort`) permet d'indiquer un niveau d'effort qualitatif plutôt qu'un nombre précis de tokens :

| Niveau d'effort | Usage typique | Compromis |
|---|---|---|
| **Faible (Low)** | Classification simple, reformulation, extraction courte. | Rapide et économique, moins robuste sur les cas complexes. |
| **Moyen (Medium)** | Résumé, comparaison simple, plan d'action structuré. | Bon compromis entre qualité, vitesse et coût. |
| **Élevé (High)** | Analyse juridique, finance, code complexe, stratégie, audit. | Plus fiable sur les tâches difficiles, mais plus lent et plus coûteux. |

---

## Ce que fait le modèle avec du raisonnement supplémentaire

Le raisonnement supplémentaire permet au modèle d'effectuer des opérations méthodologiques indispensables :

1. **Le découpage** : Transformer une demande complexe en sous-problèmes (ex: pour analyser un contrat, il identifie d'abord les obligations, puis les pénalités, puis les clauses de résiliation avant de faire sa synthèse).
2. **La vérification régulière** : Contrôler à chaque étape si la réponse respecte bien toutes les contraintes imposées (jargon, longueur, ton).
3. **Le retour en arrière (Backtracking)** : Abandonner une piste logique qui semblait correcte au début mais s'avère violer une contrainte ou mener à une contradiction (ex: rejeter l'architecture système la moins chère si elle requiert trop de développeurs pour respecter les délais).
4. **La recherche d'information (RAG/Outils)** : Utiliser des outils externes pour interroger des bases de connaissances ou chercher sur le web des informations récentes (très utile pour les documentations techniques, prix ou actualités).
5. **La prise en compte fine du contexte** : Adapter les explications et le niveau de détail au public ciblé (développeur vs directeur financier).

---

## Les systèmes de récompense : ORM vs PRM

Pour entraîner un modèle à bien raisonner en apprentissage par renforcement, il faut un signal de correction appelé **système de récompense**.

### Outcome Reward Model (ORM)
L'ORM évalue uniquement le **résultat final** (ex: dans le calcul *17 × 24*, il vérifie si la réponse finale est bien *408*). 
- *Problème* : C'est une récompense dite "sparse" (peu détaillée). Le modèle peut tomber sur le bon résultat par hasard malgré un faux raisonnement, ou avoir fait un excellent raisonnement gâché par une simple faute de calcul finale.

### Process Reward Model (PRM)
Le PRM évalue **chaque étape du raisonnement** intermédiaire. Il valide ou rejette chaque ligne de calcul ou de déduction logique.
- *Avantage* : Bien plus informatif et précis pour guider l'entraînement de raisonnement complexe, même si c'est plus coûteux à mettre en œuvre.

### Récompenses vérifiables et formatées
Certaines tâches permettent d'automatiser entièrement la récompense :
- **Récompenses d'exactitude (maths, logique, code)** : Tester un code via un compilateur et des tests unitaires pour valider automatiquement la réponse (comme fait dans *DeepSeek-R1-Zero*).
- **Récompenses de format** : Valider via des scripts réguliers que la structure de sortie (JSON, Markdown) est respectée.
Pour les domaines non déterministes (synthèses managériales, avis juridiques), l'évaluation automatique est beaucoup plus ardue et nécessite des annotations humaines (RLHF).

---

## Les avancées clés apportées par DeepSeek-R1

DeepSeek-R1 a démontré l'émergence spontanée de comportements de raisonnement par l'apprentissage par renforcement (RL) pur :

- **DeepSeek-R1-Zero** : Entraîné par RL pur à grande échelle sans SFT préalable. Le modèle a développé de lui-même des comportements de réflexion comme le retour en arrière, l'exploration de pistes alternatives et le "Aha moment" (le moment où le modèle se rend compte de son erreur et reconsidère son approche initiale). Ses limites étaient des problèmes de lisibilité et le mélange de langues dans les réponses.
- **DeepSeek-R1** : Combine le RL à des données de démarrage SFT pour conserver les capacités de raisonnement tout en garantissant des réponses lisibles, structurées et homogènes.

---

## La distillation dans les modèles de raisonnement

La **distillation** consiste à transférer la logique et les capacités d'un modèle puissant (**teacher model** / modèle enseignant) vers un modèle plus petit et plus rapide (**student model** / modèle étudiant).

### Processus et intérêts
On utilise le grand modèle de raisonnement (ex: DeepSeek-R1) pour générer des milliers d'exemples de raisonnement complexes étape par étape. On entraîne ensuite un petit modèle sur ces traces de raisonnement.
Le petit modèle distillé obtient ainsi d'excellents résultats sur les benchmarks de raisonnement tout en étant beaucoup plus économique, rapide et adapté aux tâches répétitives à grand volume (ex: classification de tickets, extractions ciblées).

### Limite de la distillation
Le modèle distillé imite très bien les schémas fréquents, mais s'avère moins robuste et moins fiable face à des cas rares, ambigus ou inédits qui nécessitent une capacité de généralisation et d'analyse profonde que seul le grand modèle possède.

---

## Synthèse de la chaîne d'un modèle de raisonnement moderne

| Couche / Concept | Rôle | Exemple |
|---|---|---|
| **Pretraining** | Apprentissage général du langage, du code et des faits. | Lecture de téraoctets de données textuelles. |
| **SFT** | Apprentissage du suivi d'instructions. | Imitation de dialogues et guides rédigés. |
| **RLHF** | Alignement sur les préférences humaines de ton et de style. | Choix de la réponse la plus utile, concise et polie. |
| **ORM** | Récompense du résultat final. | Vérification du résultat final d'une équation. |
| **PRM** | Récompense de chaque étape logique. | Validation étape par étape d'un algorithme. |
| **Récompense vérifiable** | Règle ou outil automatique pour valider. | Lancement de tests unitaires sur du code généré. |
| **Test-time compute** | Calcul alloué à l'inférence. | Paramètre `reasoning.effort` réglé sur High. |
| **Distillation** | Transfert de capacités vers un modèle léger. | Entraîner un modèle de 8B paramètres sur les traces de réflexion d'un modèle 671B. |
