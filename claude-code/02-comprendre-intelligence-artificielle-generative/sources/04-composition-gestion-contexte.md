# Composition et gestion du contexte

*Claude : fondations → 2. Comprendre l'intelligence artificielle générative → 4. Composition et gestion du contexte*

Le texte envoyé au modèle est découpé en tokens avant d'être traité. Le découpage exact dépend du modèle : un mot fréquent peut correspondre à un seul token, tandis qu'un mot rare ou long, une URL ou du code peuvent être découpés en plusieurs unités.

---

## Qu'est-ce que la fenêtre de contexte ?

La **fenêtre de contexte** correspond à la quantité maximale de tokens qu'un modèle peut prendre en compte à un moment donné (en entrée et en sortie cumulées).

Elle inclut temporairement :
- Les instructions (prompts système et utilisateur).
- L'historique des messages précédents.
- Les documents et fichiers fournis.
- Les résultats d'exécution des outils externes.
- La réponse que le modèle est en train de produire.

> **Analogie** : La fenêtre de contexte ne correspond pas à tout ce que le modèle a appris pendant son entraînement (sa mémoire à long terme). Elle ressemble plutôt à une **mémoire de travail temporaire** (RAM), limitée en taille.

*Exemple :*
Si un modèle accepte 128 000 tokens de contexte, cela ne veut pas dire qu'on peut lui fournir 128 000 tokens de documents en entrée. Il faut impérativement garder de la place pour la réponse. Si l'entrée utilise déjà 126 000 tokens, il ne restera que 2 000 tokens d'espace libre pour que le modèle formule sa sortie.

---

## Conversation et gestion du contexte

Dans une interface de chat, l'utilisateur a souvent l'impression que le modèle possède une mémoire naturelle et infinie de la conversation. En réalité, chaque nouveau message renvoie **l'intégralité de l'historique** dans le contexte du modèle.

Quand la conversation devient trop longue, le système hôte applique des stratégies de gestion :
- **Conserver** uniquement les parties essentielles.
- **Résumer** les échanges passés.
- **Compresser** ou compacter les données historiques.
- **Supprimer** les messages les plus anciens (tronquage).

Le modèle ne peut utiliser que ce qui rentre dans sa fenêtre de contexte effective. Si le contexte devient trop lourd, il faut filtrer les informations importantes et retirer le bruit.

---

## Taux de remplissage de la fenêtre

Le taux de remplissage indique la part de la fenêtre déjà consommée par l'historique et les documents :

$$\text{Taux de remplissage} = \frac{\text{Tokens utilisés}}{\text{Capacité maximale}}$$

Dans une requête réelle, il faut intégrer la marge nécessaire à la réponse :

$$\text{Taux utile} = \frac{\text{Tokens d'entrée} + \text{Tokens de sortie prévus}}{\text{Capacité maximale}}$$

*Exemple :*
Pour un modèle à 128 000 tokens, si l'utilisateur fournit 90 000 tokens de documents et qu'on réserve 8 000 tokens pour la réponse :
$$\text{Taux utile} = \frac{90\,000 + 8\,000}{128\,000} = 76,56\%$$

Voici des repères d'évaluation de la densité du contexte :

| Taux utile | Diagnostic | Risque principal |
|---|---|---|
| **Moins de 40 %** | Confortable | Risque faible de perte de contexte ou d'erreur. |
| **40 % à 70 %** | Significatif | Penser à éviter d'ajouter des éléments inutiles ou redondants. |
| **70 % à 85 %** | Dense | Augmentation du coût, de la latence, et risque de dilution de l'information. |
| **Plus de 85 %** | Proche de la saturation | Risque de manque de place pour la sortie ou de perte d'éléments utiles. |

---

## Saturation du contexte

La saturation apparaît lorsque le contexte devient trop long, trop dense ou trop bruyant. Elle peut provoquer plusieurs problèmes majeurs :
- Le prompt dépasse la limite absolue du modèle (erreur système).
- Il reste trop peu d'espace pour que l'IA formule sa réponse.
- Une partie importante de l'historique doit être élaguée ou compressée.
- La génération devient plus lente et beaucoup plus coûteuse financièrement.
- **Dilution de l'attention** : Le modèle repère moins bien les informations importantes au milieu du bruit.

Avoir une grande fenêtre de contexte (ex: 200k+ tokens) permet certes d'ajouter plus d'informations, mais n'immunise pas contre le bruit. Il est toujours préférable de fournir un contexte **court, propre et bien structuré**.

---

## Techniques de compression du contexte

La compression consiste à réduire la taille du contexte tout en préservant le maximum de valeur informative.

| Méthode | Principe | Limite |
|---|---|---|
| **Résumé (Summarization)** | Remplacer une partie de l'historique par une synthèse textuelle. | Certains détails fins ou techniques peuvent disparaître. |
| **Extraction** | Conserver uniquement les faits et les contraintes utiles au problème. | Le tri automatique peut être imparfait. |
| **Suppression (Truncation)** | Retirer purement et simplement les éléments jugés non pertinents ou trop anciens. | Une information supprimée est perdue définitivement pour la session. |
| **RAG (Retrieval-Augmented Generation)** | Récupérer uniquement les passages du document pertinents pour la question posée. | La recherche sémantique peut manquer un passage important (faux négatif). |
| **Compaction** | Créer un état condensé de la conversation sous forme de variables ou d'historique compressé. | Le contexte devient moins détaillé que l'historique complet. |

### Exemple de synthèse structurée de conversation
Pour économiser des tokens, on peut remplacer un long historique par une synthèse structurée contenant :
- L'objectif principal de l'utilisateur.
- Les contraintes validées.
- Les décisions architecturales ou de code déjà prises.
- Les points restants ouverts.
- Le format de sortie attendu.

---

## Pourquoi une grande fenêtre de contexte ne suffit pas

Une grande fenêtre augmente la capacité de stockage mais ne garantit pas la précision du traitement. On distingue trois capacités chez un LLM :

| Capacité | Question clé | Exemple concret |
|---|---|---|
| **Stockage contextuel** | Combien de tokens peuvent entrer ? | Recevoir un très long document (ex: 80 pages). |
| **Récupération (Retrieval)** | Le modèle retrouve-t-il le bon passage ? | Identifier une clause spécifique cachée au milieu d'un grand contrat. |
| **Raisonnement** | Le modèle utilise-t-il correctement l'information ? | Comparer plusieurs clauses éloignées pour en déduire un risque global. |

Un grand contexte n'est utile que si l'information y est **pertinente et structurée**.

---

## Bonnes pratiques de gestion du contexte

1. **Donner uniquement le contexte utile** : Éviter d'inonder le modèle de documents inutiles ou de doublons.
2. **Structurer les informations dans le prompt** : Séparer clairement l'objectif, le public cible, les documents fournis et la sortie attendue.
3. **Placer la consigne de travail après les documents longs** : Mettre la question ou l'instruction à la toute fin du prompt permet de mieux focaliser l'attention finale du modèle.
4. **Garder de la place pour la réponse** : Réserver une marge de tokens suffisante pour la sortie.
5. **Résumer les longues conversations** : Créer régulièrement des synthèses d'état au cours de la session.

### Comparaison d'utilisation

* **Demande faible (vague/bruitée) :**
  > *"Voici tous mes documents [10 PDF collés]. Analyse-les."*
  *(Le modèle risque de produire une réponse superficielle ou de noyer l'attention).*

* **Demande efficace (précise/structurée) :**
  > *"Analyse les documents ci-dessous pour identifier les risques contractuels. Ignore les e-mails redondants. Utilise uniquement les clauses sur le prix, la durée, la résiliation, les pénalités et la confidentialité. Termine par un tableau avec quatre colonnes : Risque, Gravité, Justification, Action recommandée."*
  *(Le modèle sait exactement ce qui compte, ce qu'il doit filtrer et le format attendu).*
