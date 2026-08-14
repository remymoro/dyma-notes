# Révision — Chapitre 2 : Comprendre l'intelligence artificielle générative

---

## Points à retravailler

| # | Question | Problème identifié |
|---|---|---|
| Q3 | Définition d'un token et raison du découpage | Manque : définition complète (mot, partie, ponctuation...) + rôle de la fréquence (pas juste la longueur) |
| Q4 | Différence identifiant vs embedding | Embedding décrit partiellement (vecteur/dimensions) mais manque : identifiant = reconnaître, embedding = manipuler/calculer des relations |

---

## Leçon 1 — Fonctionnement d'un LLM

**Q1.** Que signifie l'acronyme LLM et comment peut-on le traduire en français ?

**Q2.** Quels sont les quatre repères fondamentaux pour comprendre le fonctionnement d'un LLM ?

**Q3.** ❌ Qu'est-ce qu'un token ? Pourquoi un mot long comme *internationalisation* est-il découpé en plusieurs tokens ?

**Q4.** ❌ Quelle est la différence entre un identifiant de token et un embedding ?

**Q5.** À quoi sert le positional encoding ? Donnez un exemple concret illustrant son importance.

**Q6.** Expliquez en quelques mots le mécanisme de self-attention. Pourquoi le mot *banque* n'aura-t-il pas la même représentation interne dans tous les contextes ?

**Q7.** Quels sont les trois concepts du mécanisme d'attention ? Décrivez brièvement le rôle de chacun.

**Q8.** Qu'est-ce que les logits ? Quel est le rôle de la fonction Softmax ?

**Q9.** Comment la température influence-t-elle la génération de tokens ? Qu'arrive-t-il avec une température élevée vs une température basse ?

**Q10.** Quelle est la différence fondamentale entre un LLM, un moteur de recherche et une base de données ? Qu'est-ce qu'une hallucination dans ce contexte ?

---

## Leçon 2 — Les phases d'entraînement d'un LLM

**Q11.** Que sont les paramètres (weights) d'un LLM ? Quel est le principe général de l'entraînement ?

**Q12.** Quelles sont les 6 grandes phases de l'entraînement d'un LLM ? Citez-les dans l'ordre.

**Q13.** Qu'est-ce que la déduplication et le filtrage dans la préparation des données ? Pourquoi sont-ils importants ?

**Q14.** Quel est le rôle de chacun des trois ensembles de données (training set, validation set, test set) ?

**Q15.** Qu'est-ce que la loss function (fonction de perte) lors du pretraining ?

**Q16.** Expliquez en quoi consistent la backpropagation et la descente de gradient. Utilisez l'analogie de la montagne.

**Q17.** Qu'est-ce que le learning rate ? Que se passe-t-il s'il est trop bas ou trop haut ?

**Q18.** Définissez batch, epoch et checkpoint dans le contexte de l'entraînement.

**Q19.** Pourquoi le SFT (Supervised Fine-Tuning) est-il nécessaire après le pretraining ? Quel problème corrige-t-il ?

**Q20.** Quelle est la différence entre RLHF, RLAIF et DPO ? Quel objectif partagent-ils ?

**Q21.** Qu'est-ce que l'inference ? Pourquoi les paramètres du modèle sont-ils figés lors de l'utilisation ?

---

## Leçon 3 — Du LLM classique au modèle de raisonnement (LRM)

**Q22.** Qu'est-ce qu'un LRM ? En quoi se distingue-t-il d'un LLM classique ?

**Q23.** Donnez deux exemples de tâches pour lesquelles la génération directe suffit, et un exemple de tâche nécessitant un raisonnement plus élaboré.

**Q24.** Qu'est-ce que le test-time compute ? Pourquoi est-ce un levier important pour les LRM ?

**Q25.** Expliquez l'analogie avec la Dual Process Theory de Kahneman. Quelles sont ses limites appliquées à l'IA ?

**Q26.** Que sont les thinking tokens ? Pourquoi l'utilisateur ne les voit-il généralement pas ?

**Q27.** Quelle est la différence entre le thinking budget (Anthropic) et le reasoning effort (OpenAI) ? Quand utiliser un niveau d'effort élevé ?

**Q28.** Citez les 5 opérations que permet d'effectuer le raisonnement supplémentaire dans un LRM.

**Q29.** Quelle est la différence entre un ORM et un PRM ? Quel est l'avantage du PRM pour entraîner au raisonnement ?

**Q30.** Qu'est-ce que DeepSeek-R1-Zero a démontré ? Quelles étaient ses limites ?

**Q31.** En quoi consiste la distillation ? Quelle est la principale limite d'un modèle distillé ?

---

## Leçon 4 — Composition et gestion du contexte

**Q32.** Qu'est-ce que la fenêtre de contexte ? À quelle analogie peut-on la comparer ?

**Q33.** Listez les 5 éléments qui occupent la fenêtre de contexte lors d'une requête.

**Q34.** Pourquoi une fenêtre de 128 000 tokens ne permet-elle pas de fournir 128 000 tokens de documents en entrée ?

**Q35.** Quelles stratégies un système hôte peut-il appliquer lorsqu'une conversation devient trop longue ?

**Q36.** Calculez le taux utile pour un modèle à 200 000 tokens avec 140 000 tokens d'entrée et 10 000 tokens de sortie prévus. Quel diagnostic donnez-vous ?

**Q37.** Qu'est-ce que la dilution de l'attention ? Dans quel contexte apparaît-elle ?

**Q38.** Décrivez les 5 techniques de compression du contexte et leur limite respective.

**Q39.** Quelles sont les trois capacités distinctes d'un LLM face au contexte ? En quoi une grande fenêtre ne garantit-elle pas la précision ?

**Q40.** Citez les 5 bonnes pratiques de gestion du contexte.

**Q41.** Pourquoi est-il recommandé de placer la consigne de travail *après* les documents longs dans le prompt ?

---

## Leçon 5 — La spécificité Anthropic : la Constitution IA

**Q42.** Qu'est-ce que le Constitutional AI (IA constitutionnelle) ? Quand a-t-il été introduit et quand la constitution de Claude a-t-elle été refondue ?

**Q43.** Quelles sont les 4 limites du RLHF identifiées par Anthropic ?

**Q44.** En quoi consiste la Phase 1 du Constitutional AI (critique et révision supervisées) ? Décrivez la boucle en 3 étapes.

**Q45.** Qu'est-ce que le RLAIF (Phase 2) ? En quoi remplace-t-il les annotateurs humains ?

**Q46.** Qu'entend-on par "amélioration de Pareto" dans le contexte du Constitutional AI ?

**Q47.** Quelles étaient les sources d'inspiration de la constitution de 2023 (58 principes) ?

**Q48.** Décrivez les 4 niveaux hiérarchiques de la constitution de 2026 en précisant ce que chacun couvre.

**Q49.** Qu'est-ce qu'une injection de prompt ? Comment la constitution de 2026 tente-t-elle de s'en protéger ?

**Q50.** Quelle est la différence entre les Hard Constraints (contraintes fortes) et les comportements instructibles ? Donnez un exemple de chaque.

**Q51.** Décrivez les 4 types de réponses que Claude peut donner face à une demande sensible.

**Q52.** Quels étaient les résultats de l'expérience Collective Constitutional AI (2023) ? Quelle conclusion en tirer sur la gouvernance de l'IA ?

**Q53.** Citez les 4 critiques principales adressées au Constitutional AI.

---

## Leçon 6 — L'économie des tokens et la facturation

**Q54.** Quels sont les 4 facteurs qui font varier le coût d'une requête API ?

**Q55.** Quelle est la différence entre la facturation par abonnement et la facturation API à l'usage ?

**Q56.** Qu'est-ce que les input tokens et les output tokens ? Écrivez la formule du coût total d'une requête.

**Q57.** Pourquoi les output tokens coûtent-ils 3 à 5 fois plus cher que les input tokens ?

**Q58.** Citez 3 facteurs côté input et 3 facteurs côté output qui font augmenter la consommation de tokens.

**Q59.** Pourquoi les systèmes agentiques sont-ils particulièrement coûteux en tokens ? Donnez un exemple concret.

**Q60.** Que sont les Rate Limits ? Expliquez les acronymes RPM et TPM.

**Q61.** Qu'est-ce que le Prompt Caching ? Dans quel cas l'utiliser et quel bénéfice en attend-on ?

**Q62.** Qu'est-ce que le Batch Processing ? Quel est l'avantage financier et quelle précaution faut-il prendre avant de l'industrialiser ?

**Q63.** Complétez le tableau : pour chaque levier d'optimisation (cadrer la demande, limiter le livrable, sélectionner les documents, adapter le modèle, exploiter le cache), donnez le bénéfice attendu.
