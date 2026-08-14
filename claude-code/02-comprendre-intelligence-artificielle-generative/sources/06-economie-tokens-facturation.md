# L’économie des tokens et la facturation

*Claude : fondations → 2. Comprendre l'intelligence artificielle générative → 6. L'économie des tokens et la facturation*

Quand on utilise une intelligence artificielle générative dans une interface de chat grand public, le coût est souvent masqué par un abonnement mensuel fixe. Mais dès qu'on utilise le modèle via une API (interface de programmation), le fonctionnement économique devient visible : chaque requête consomme des ressources système, mesurées et facturées principalement en **tokens**.

Cette leçon explique la logique économique générale : comment se construit le coût d’une requête, pourquoi deux demandes apparemment proches peuvent avoir des coûts différents, pourquoi les modèles n’ont pas tous le même prix, et pourquoi les limites d’usage ne sont pas seulement des contraintes commerciales, mais aussi des contraintes physiques.

---

## Quatre repères pour comprendre la facturation

1. **Le volume traité** : Plus le système doit lire et produire de texte (ou de code), plus il consomme de tokens.
2. **Le modèle utilisé** : Un modèle plus puissant (ex: Claude 3.5 Sonnet ou Opus) coûte plus cher à faire tourner qu'un modèle plus rapide et léger (ex: Claude 3.5 Haiku).
3. **Les outils mobilisés** : L'accès à la recherche web, l'analyse de fichiers, les connecteurs tiers, l'exécution de code ou les agents ajoutent du travail computationnel indirect.
4. **La surface d'usage** : L'abonnement mensuel individuel, l'API à la consommation brute, le traitement différé en lots ou les solutions d'entreprise intégrées obéissent à des règles de tarification différentes.

---

## Deux logiques : Abonnement vs API

### La facturation par abonnement
L'utilisateur paie un forfait mensuel pour accéder à une interface de conversation. L'usage n'est cependant pas "infini" : les fournisseurs imposent des **limites d'usage** (nombre de messages par période, taille et nombre maximal de documents importés, quota d'utilisation du modèle le plus puissant) pour protéger leurs serveurs et l'accès des autres utilisateurs.

### La facturation API à l'usage
L'organisation paie selon la consommation réelle de la requête (calculée par million de tokens traités). Chaque appel à l'API est décomposé ainsi :
- **Les input tokens (tokens d'entrée)** : Tout ce qui est transmis au modèle (votre question, l'historique complet de la discussion, les instructions système cachées, les documents joints, les résultats des outils externes).
- **Les output tokens (tokens de sortie)** : Tout ce qui est généré par le modèle (la réponse finale visible, le code produit, les pensées ou traces intermédiaires).

Le coût total d'une requête est défini par la formule :

$$\text{Coût total} = (\text{Tokens d'entrée} \times \text{Tarif Entrée}) + (\text{Tokens de sortie} \times \text{Tarif Sortie}) + \text{Frais d'outils / options}$$

> **Pourquoi les output tokens sont plus chers ?**
> Les tokens de sortie coûtent souvent 3 à 5 fois plus cher que les tokens d'entrée. Cela s'explique par la nature auto-régressive de l'IA : générer du texte demande beaucoup plus de calculs que de lire du texte, car le modèle doit calculer la probabilité du token suivant un par un, en réanalysant tout ce qui précède à chaque étape.

---

## Ce qui fait varier la consommation de tokens

### Côté Input (Entrée)
- **L'historique de la conversation** : Pour maintenir le contexte, chaque nouveau message d'un chat renvoie la totalité de l'historique au modèle. Une discussion très longue devient exponentiellement plus chère et plus lente.
- **Les consignes et consignes système invisibles** : Les instructions de formatage, les règles de sécurité ou les comportements imposés par l'interface consomment de l'espace d'entrée.
- **Les fichiers joints** : Analyser un document de 100 pages, une base de données CSV ou un fichier de logs techniques pèse lourdement sur la facture en tokens, même si votre question finale ne fait que trois mots.
- **Les connecteurs et outils** : Si le modèle doit lire des e-mails, consulter le web ou interroger une base de connaissances (RAG), ces extraits de textes sont réinjectés en entrée du modèle.

### Côté Output (Sortie)
- **La longueur attendue** : Un rapport d'analyse de 5 pages consommera beaucoup plus de tokens de sortie qu'un résumé en une phrase.
- **Les formats structurés (JSON, HTML, CSV, Code)** : Ces langages structurés requièrent de nombreux caractères techniques répétés (guillemets, accolades, balises, retours à la ligne) qui consomment des tokens supplémentaires.
- **Les révisions multiples** : Demander *"Raccourcis la réponse"*, puis *"Traduis-la en anglais"*, puis *"Mets-la sous forme de tableau"* génère une facture à chaque itération.

---

## Les outils et les coûts additionnels

Dès qu'on sort du texte pur, des couches computationnelles et financières s'ajoutent :
- **Recherche web** : Les extraits trouvés s'ajoutent aux tokens d'entrée.
- **Exécution de code (Sandboxing)** : Faire tourner des calculs ou générer des graphiques en Python requiert d'ouvrir un environnement d'exécution sécurisé temporaire.
- **Analyse visuelle** : L'envoi d'images, de captures d'écran ou de graphiques complexes est converti en tokens d'image, souvent plus gourmands que le texte brut.

---

## Les agents et les coûts cachés

Les systèmes agentiques (workflows autonomes) sont particulièrement consommateurs de tokens car ils fonctionnent en boucle fermée. Pour une seule consigne utilisateur (ex: *"Prépare un rapport financier à partir de ce dossier"*), l'agent peut effectuer 10 ou 15 requêtes internes en arrière-plan :
1. Planifier les étapes.
2. Lire les fichiers un par un.
3. Extraire et comparer les données.
4. Effectuer des recherches complémentaires.
5. Rédiger un brouillon.
6. Auto-corriger les erreurs de calcul.
7. Générer le fichier final.

Pour maîtriser ces coûts, il est indispensable de configurer des **critères d'arrêt** (nombre maximum de boucles ou de tokens alloués) pour éviter qu'un agent ne boucle à l'infini en cas d'erreur.

---

## Les limites d'usage et de débit

Les plateformes et API appliquent plusieurs limites :
- **Limites de messages/session** : Pour éviter la surcharge des serveurs.
- **Limites de débit (Rate Limits)** : Restreignent le rythme d'appel de l'API par minute ou par jour, exprimées en **RPM** (*Requests Per Minute*) et **TPM** (*Tokens Per Minute*).
- **Limites de budget** : Plafonds financiers configurables pour bloquer les appels API et éviter les surprises en fin de mois dues à une boucle infinie de code.

---

## Deux leviers d'optimisation en entreprise

### 1. Le Prompt Caching (Mise en cache du prompt)
C'est un mécanisme clé pour réduire les coûts sur les requêtes répétitives. Si vous utilisez un contexte stable volumineux (ex: une documentation technique de 50 pages, une charte d'entreprise, ou un gros prompt système) sur plusieurs requêtes successives, le fournisseur "met en cache" ce segment.
- Les requêtes suivantes lisent ce cache au lieu de le recalculer.
- Le prompt caching permet de **réduire le coût de lecture de l'entrée jusqu'à 90 %** et de diviser la latence par deux.

### 2. Les traitements en lots (Batch Processing)
Pour les tâches volumineuses non urgentes (ex: classer 10 000 tickets de support, extraire les données de 5 000 factures), l'API permet d'envoyer les données en "lots". Le fournisseur traite ces requêtes pendant ses heures creuses sous 24 heures en échange d'une **réduction de tarif de 50 %**.

> **Important** : Avant d'industrialiser un traitement en lots sur 10 000 lignes, il faut impérativement tester son prompt sur un **échantillon représentatif** pour mesurer la qualité des sorties, le format, le taux d'erreur et estimer précisément la facture finale.

---

## Synthèse : Comment réduire les coûts sans perdre en qualité ?

| Levier d'action | Comment faire concrètement ? | Bénéfice attendu |
|---|---|---|
| **Cadrer la demande** | Indiquer précisément l'objectif et les contraintes pour éviter les itérations et corrections successives. | Moins d'appels API cumulés. |
| **Limiter le livrable** | Demander un format concis (ex: *"Réponds en 10 lignes"*, *"Donne uniquement les 3 risques principaux"*). | Économie de tokens de sortie (les plus chers). |
| **Sélectionner les documents** | Nettoyer le bruit et ne fournir que les pièces ou extraits utiles au lieu d'envoyer des dossiers entiers de doublons. | Économie de tokens d'entrée. |
| **Adapter le modèle** | Réserver Claude Sonnet/Opus pour le code et l'analyse complexe ; utiliser Claude Haiku pour les classifications et extractions simples. | Facture divisée par 5 ou 10 sur les tâches basiques. |
| **Exploiter le cache** | Regrouper les consignes et bases documentaires réutilisées au début du prompt pour activer le *Prompt Caching*. | Réduction de 90 % du coût d'entrée sur les requêtes suivantes. |
