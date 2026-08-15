# Les gammes de modèles et leurs performances

*Claude : fondations → 3. Fonctionnalités, limites et bonnes pratiques → 1. Les gammes de modèles et leurs performances*

![Les gammes de modèles et la performance](../assets/gammes-modeles-performance.jpg)

Tous les LLM ne se valent pas. Deux modèles peuvent fonctionner selon le même principe général (recevoir un contexte, transformer ce contexte en représentations numériques, puis produire des tokens), tout en ayant des niveaux de performance très différents.

Certains modèles sont rapides, peu coûteux et suffisants pour des tâches simples. D'autres sont plus lents, plus coûteux et mieux adaptés aux tâches complexes : analyse de documents longs, raisonnement multi-étapes, code, comparaison de sources, stratégie, recherche d'erreurs ou décision sous contraintes.

Cette différence dépend de plusieurs facteurs combinés : la taille du modèle (nombre de paramètres), la qualité des données d'entraînement, l'architecture computationnelle, le post-training, la spécialisation, la fenêtre de contexte, les capacités multimodales, le temps de calcul accordé à la réponse (test-time compute) et l'utilisation de techniques d'optimisation comme la distillation.

---

## Quatre repères pour comparer les modèles

1. **La capacité du modèle** : Un modèle plus grand ou mieux conçu peut représenter davantage de relations, de nuances et de situations complexes.
2. **La qualité de l'entraînement** : Les données, leur nettoyage, le filtrage, le pretraining et le post-training influencent fortement le comportement final du modèle.
3. **Le coût d'utilisation** : Un modèle puissant consomme plus de puissance de calcul, ce qui augmente son prix et son temps de réponse (latence).
4. **L'adéquation à la tâche** : Le meilleur modèle n'est pas toujours le plus puissant, mais celui qui correspond au besoin réel (ex: une reformulation simple vs une analyse de contrat multi-documents).

---

## Les paramètres (weights) du modèle

Un des premiers facteurs de différence entre modèles est le **nombre de paramètres** (ou **weights** / poids). 

### Qu'est-ce qu'un paramètre ?
- C'est une valeur numérique interne apprise et ajustée pendant l'entraînement.
- Ces paramètres ne sont pas des phrases ou des faits stockés dans une base de données. Ce sont des valeurs mathématiques qui influencent la transformation d'une entrée en sortie.
- **Un paramètre n'est pas une connaissance isolée** : Le modèle ne stocke pas *"Paris est la capitale de la France"* dans une case spécifique. Les connaissances et comportements du modèle sont **distribués** dans un très grand nombre de paramètres sous forme de relations statistiques.

### Pourquoi le nombre de paramètres compte
Un modèle avec davantage de paramètres possède une plus grande capacité de représentation. Il peut capturer plus de relations subtiles entre les mots, les concepts, les styles, les domaines et les formes de raisonnement. 

Cependant, le nombre de paramètres ne fait pas tout : un modèle plus petit mais spécialisé ou mieux entraîné peut surpasser un grand modèle généraliste sur une tâche précise (comme le code ou l'extraction structurée).

---

## Taille du modèle : le compromis Qualité, Vitesse, Coût

| Catégorie | Rôle et usages typiques | Exemples concrets |
|---|---|---|
| **Modèles légers** | Rapides, économiques, adaptés aux tâches simples et peu risquées. | Classer un e-mail par priorité, extraire des données courtes (nom, date), reformuler une phrase. |
| **Modèles intermédiaires** | Compromis équilibré entre qualité, vitesse et coût pour les tâches courantes. | Résumer une note interne, transformer un compte rendu en plan d'action, comparer deux propositions commerciales. |
| **Modèles puissants** | Adaptés aux tâches complexes, ambiguës, multi-documents ou à fort enjeu. | Analyser un dossier financier multi-hypothèses, déboguer un code multi-fichiers, rédiger une recommandation stratégique. |

---

## Les données d'entraînement

Deux modèles de taille similaire peuvent avoir des performances très différentes selon la constitution de leur base d'apprentissage :
- **La diversité des données** : L'exposition à des textes scientifiques, du code, du droit, des tableaux ou des manuels techniques aide le modèle à reconnaître des formes variées de logique et de langage.
- **La qualité des données** : Éliminer le bruit (doublons, erreurs, textes mal extraits) évite au modèle d'apprendre de mauvaises régularités ou de surpondérer des informations répétées.
- **La spécialisation** : Renforcer l'entraînement sur des corpus spécialisés (ex: code source ou littérature médicale) rend le modèle extrêmement performant dans ces domaines.

---

## L'architecture du modèle : Dense vs MoE

![MOE (Mixture of Experts) : le principe expliqué simplement](../assets/moe-mixture-of-experts.jpg)

- **Modèles denses** : La quasi-totalité des paramètres est mobilisée pour traiter chaque token. C'est robuste mais coûteux et lent à exécuter.
- **Modèles MoE (Mixture of Experts)** : Le modèle contient plusieurs sous-parties spécialisées (les "experts"). Pour chaque entrée, le système n'active qu'une fraction de ces experts. Cela permet d'augmenter la capacité totale du modèle tout en limitant le coût de calcul à l'inférence.

---

## Les autres facteurs de performance

- **Fenêtre de contexte (Context Window)** : Une grande fenêtre permet d'injecter plus de documents en mémoire de travail, mais la capacité du modèle à récupérer et raisonner correctement sur cette masse reste une compétence distincte.
- **Capacités multimodales** : Aptitude à traiter des images, des graphiques ou des documents scannés, ce qui est indispensable pour l'analyse visuelle de factures ou de schémas.
- **Le post-training** : Transforme le socle pré-entraîné pour lui apprendre à suivre fidèlement des consignes complexes (robustesse aux contraintes multiples) et à adopter le ton et le style adéquats.

---

## Modèles spécialisés et de raisonnement

- **Modèles de code** : Optimisés pour comprendre les structures de fichiers, les dépendances logicielles, les tests unitaires et les logs d'erreurs.
- **Modèles d'embeddings** : Conçus non pas pour générer du texte, mais pour convertir des textes en représentations numériques (vecteurs). Indispensables pour les systèmes de recherche sémantique ou les architectures **RAG**.
- **Modèles de raisonnement** : Ajustés pour les problèmes logiques et mathématiques complexes exigeant :
  - **Un raisonnement multi-étapes** : Enchaîner plusieurs calculs et déductions logiques.
  - **Un raisonnement sous contraintes** : Maintenir simultanément le respect de contraintes budgétaires, techniques, juridiques ou de délais.
  - **La vérification et la critique** : Identifier les angles morts et critiquer une hypothèse pour éviter des erreurs d'analyse en entreprise.

Ces modèles de raisonnement induisent une **latence plus élevée** (test-time compute) et un coût de calcul accru, qui doivent être justifiés par la valeur et le risque de la tâche.
