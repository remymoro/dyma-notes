# Présentation d'Anthropic

*Source : PDF Dyma — Claude : fondations > 1. Introduction à Anthropic et Claude > 2. Présentation d'Anthropic*

---

## Comprendre Anthropic

*[Logo Anthropic]*

Avant d'utiliser Claude pour analyser des documents, rédiger des emails, résumer des fichiers ou assister un travail professionnel, il est utile de comprendre l'entreprise qui le développe.

Claude est développé par **Anthropic**, une entreprise américaine fondée en **2021** par d'anciens membres de OpenAI. Elle fait aujourd'hui partie des principaux acteurs mondiaux de l'intelligence artificielle générative, aux côtés de OpenAI, Google et Meta.

Cette leçon a un objectif simple : comprendre pourquoi Claude se comporte comme il se comporte. Par exemple, pourquoi il refuse certaines demandes, pourquoi il demande parfois des précisions, pourquoi il met l'accent sur la sécurité, et pourquoi il est particulièrement présent dans les grandes entreprises.

---

## Quatre repères pour situer Anthropic

- **2021** : année de fondation de Anthropic.
- **380 milliards de dollars** : valorisation annoncée lors de la Series G en février 2026.
- **30 milliards de dollars** : revenu annualisé annoncé en mars 2026.
- **Environ x10 par an** : rythme de croissance annuelle indiqué sur plusieurs années consécutives.

> Le **revenu annualisé** (ARR, *Annual Recurring Revenue*) correspond à une projection du revenu sur une année complète. Exemple : 2,5 Md$/mois × 12 = 30 Md$ d'ARR.

> La **valorisation** désigne la valeur estimée d'une entreprise lors d'un tour de financement. Une valorisation de 380 Md$ ne signifie pas que l'entreprise possède 380 Md$ en banque.

---

## Qui sont les fondateurs de Anthropic

*[Photo : Dario Amodei et Daniela Amodei]*

Anthropic est fondée par **Dario Amodei**, **Daniela Amodei** et plusieurs anciens membres importants de OpenAI.

La création de Anthropic s'inscrit dans un **désaccord sur la manière de développer ces systèmes** : sécurité, gouvernance, vitesse de déploiement et capacité à comprendre le comportement des modèles.

> Un **grand modèle de langage** (LLM, *Large Language Model*) est un modèle d'IA entraîné sur de très grands volumes de textes. Il peut produire du texte, résumer, traduire, expliquer, raisonner, rédiger du code ou analyser des documents.

### Dario Amodei — cofondateur et CEO

> **CEO** (*Chief Executive Officer*) : directeur général. Dirige l'entreprise, fixe les grandes priorités et représente l'organisation dans les décisions stratégiques.

Formation : physique → biophysique.

> La **biophysique** applique les méthodes de la physique à des systèmes biologiques (neurones, protéines, circuits du cerveau).

Parcours avant Anthropic : Baidu → Google Brain → OpenAI (VP Research).

> **VP Research** (*Vice President of Research*) : direction de la recherche. Supervise les programmes scientifiques, oriente les priorités, coordonne les équipes techniques.

Chez OpenAI : travaux sur GPT-2, GPT-3, et les **scaling laws**.

> Les **scaling laws** sont des lois empiriques décrivant comment les performances des modèles augmentent quand on augmente leur taille, les données d'entraînement et la puissance de calcul.

**Parcours chronologique de Dario Amodei :**

- Années 2000 : études de physique à Caltech et Stanford
- ~2011 : doctorat en biophysique à Princeton
- 2012–2014 : recherche postdoctorale à Stanford Medical School
- 2014–2015 : IA chez Baidu (reconnaissance vocale)
- 2015–2016 : Google Brain (réseaux de neurones)
- 2016–2020 : VP Research chez OpenAI
- Depuis 2021 : cofondateur et CEO de Anthropic

### Daniela Amodei — cofondatrice et présidente

Sœur de Dario. Rôle opérationnel : organisation, recrutement, partenariats, politique interne, sécurité, développement commercial. Chez OpenAI : équipes, opérations, sécurité. Chez Anthropic : transforme un groupe de recherche en entreprise capable de servir des clients professionnels à grande échelle.

### Les autres cofondateurs (ex-OpenAI)

- **Tom Brown** : travaux sur GPT-3
- **Chris Olah** : recherches sur l'interprétabilité des réseaux de neurones
- **Jared Kaplan** : scaling laws
- **Sam McCandlish** : chercheur
- **Jack Clark** : recherche, stratégie et politiques publiques de l'IA

> L'**interprétabilité** consiste à comprendre ce qui se passe à l'intérieur d'un modèle : pourquoi il refuse une demande, pourquoi il produit une réponse donnée, comment certaines capacités apparaissent pendant l'entraînement.

---

## Pourquoi Anthropic existe

Désaccord de fond : la **sécurité doit être intégrée dès la conception** des modèles — pas ajoutée uniquement à la fin comme un simple filtre.

Dans l'approche classique : modèle puissant → règles ajoutées pour bloquer les comportements dangereux.  
Dans l'approche Anthropic : la sécurité influence l'entraînement, l'évaluation, la correction et le déploiement.

---

## La mission de Anthropic

Construire des systèmes **fiables**, **interprétables** et **orientables**.

### Fiables
Réponses cohérentes, utiles, relativement stables. Objectif : réduire les erreurs graves, réponses imprudentes, comportements imprévisibles. En contexte professionnel : respecter des consignes, signaler ses limites, rester cohérent sur des tâches importantes.

### Interprétables
Comprendre une partie du fonctionnement interne. Les LLM contiennent des milliards de **paramètres** (valeurs numériques apprises à l'entraînement, non directement lisibles par un humain). L'interprétabilité cherche à répondre à : Pourquoi cette réponse ? Quels éléments ont influencé la décision ? Peut-on détecter des comportements dangereux avant qu'ils apparaissent dans le produit ?

### Orientables
On peut guider et contraindre le modèle : lui donner des règles, des limites, des priorités, un cadre d'action. Ex. : respecter une politique interne, ne pas traiter certaines données, demander une validation humaine avant une action sensible.

---

## Une entreprise de sécurité, mais aussi commerciale

Anthropic ne cherche pas à ralentir l'IA. Elle développe des modèles puissants, signe de grands contrats, lève du capital et concurrence OpenAI, Google et Meta.

Sa position : **puisque les modèles avancés vont être développés, autant les développer avec des mécanismes de sécurité, de contrôle et d'évaluation plus solides.**

Tension permanente : rester compétitive ET garder la sécurité/gouvernance au centre.

---

## Une structure juridique particulière

**Public Benefit Corporation (PBC)** : forme de société américaine qui doit prendre en compte à la fois l'intérêt économique des actionnaires et une mission d'intérêt public. Anthropic reste une société commerciale (lève des fonds, vend des produits, cherche la rentabilité), mais les dirigeants doivent aussi tenir compte de la mission publique déclarée : la sécurité de l'IA.

**Long-Term Benefit Trust** : mécanisme visant à protéger la mission dans la durée — éviter que les pressions commerciales/financières conduisent à abandonner les principes de sécurité. Cherche à limiter le pouvoir exclusif des investisseurs sur certaines décisions importantes.

---

## Constitutional AI

L'une des idées les plus importantes de Anthropic.

Principe : au lieu d'entraîner uniquement le modèle avec des humains qui notent ses réponses, on lui donne aussi un ensemble de principes appelé **constitution**. Le modèle apprend à comparer ses réponses à ces principes et à les corriger.

Exemple : demande agressive → modèle produit une première réponse → évalue par rapport à des principes (utilité, honnêteté, absence de danger, respect) → apprend à produire une meilleure réponse.

Conséquence : Claude peut être plus prudent que d'autres modèles. Il ne cherche pas seulement à répondre vite, mais à vérifier que la réponse respecte certains principes de sécurité.

---

## Des choix commerciaux cohérents avec le positionnement

- **Surveillance de masse** : Anthropic indique refuser certains usages liés à la surveillance de masse.
- **Armes autonomes** : Anthropic indique refuser certains usages liés aux armes létales autonomes.
- **Publicité** : Anthropic affirme ne pas vouloir intégrer de publicité dans Claude.

Ces choix peuvent être vus comme éthiques ET comme des choix de positionnement : se différencier par la confiance, la sécurité, la confidentialité et l'usage professionnel.

---

## La croissance économique de Anthropic

*[Graphique : Revenu annualisé d'Anthropic, ARR 2022 → mars 2026, échelle logarithmique]*

- Fin 2022 : ~10 M$
- Fin 2023 : ~100 M$
- Décembre 2024 : ~1 Md$
- Juillet 2025 : ~4 Md$
- Février 2026 : ~14 Md$
- Mars 2026 : ~30 Md$

Adoption rapide grâce à la diversité des cas d'usage : rédaction, analyse de documents, recherche, assistance juridique, programmation, support client, automatisation, aide à la décision. Un LLM peut servir plusieurs métiers dans une même entreprise.

---

## La valorisation de Anthropic

*[Graphique : Valorisation post-money d'Anthropic, Seed → mai 2026]*

> **Valorisation post-money** : valeur estimée de l'entreprise après l'investissement.

- Seed, 2021 : ~0,3 Md$
- Series C, 2023 : ~18 Md$
- Series E, mars 2025 : ~61,5 Md$
- Series F, septembre 2025 : ~183 Md$
- Series G, février 2026 : ~380 Md$
- Tour évoqué en mai 2026 : ~850–900 Md$ *(non confirmé)*

Les chiffres non confirmés indiquent une tendance de marché, pas une opération finalisée.

---

## Qui finance Anthropic

### Fournisseurs cloud et infrastructure
Amazon, Google, Microsoft, Nvidia. Nécessaires pour l'entraînement et le fonctionnement des modèles (centres de données, GPU, énergie, infrastructure logicielle).

### Fonds souverains
GIC, Qatar Investment Authority, Temasek, MGX. L'IA générative est devenue un enjeu stratégique mondial.

### Gestionnaires d'actifs
Fidelity, BlackRock, Blackstone, General Atlantic, T. Rowe Price, Morgan Stanley. Anthropic perçue comme entreprise stratégique à long terme.

### Fonds de capital-risque
Coatue, ICONIQ, Lightspeed, Sequoia, Founders Fund, General Catalyst, Bessemer, Insight Partners. Capital + réseau de clients, partenaires et dirigeants.

---

## Le positionnement client de Anthropic

Stratégie **B2B** (*Business to Business*) : vente principalement à des entreprises, pas à des particuliers (B2C = *Business to Consumer*).

- ~**80 %** du revenu vient des entreprises
- **+300 000** clients entreprise actifs
- **8/10 Fortune 10** utiliseraient Claude

> **Fortune 10** : les dix plus grandes entreprises américaines par chiffre d'affaires.

- **+1 000** clients dépensent >1 M$/an
- Clients notables : Deloitte, Snowflake, Rakuten, Pfizer, AIG, Bridgewater, AB InBev, Sourcegraph, GitLab, Replit

Cette orientation explique les caractéristiques de Claude : sécurité, confidentialité, intégration avec les outils professionnels, contrôle des données, audit et conformité.

---

## Anthropic face aux autres acteurs de l'IA générative

| Entreprise | Modèle phare |
|---|---|
| OpenAI | ChatGPT, GPT |
| Anthropic | Claude |
| Google | Gemini |
| Meta | Llama |

> **API** (*Application Programming Interface*) : interface permettant à un logiciel d'utiliser les fonctions d'un autre. Une entreprise peut utiliser l'API de Claude pour intégrer le modèle dans son outil interne.

Différence principale : OpenAI fortement développée auprès du grand public. Anthropic davantage orientée entreprises, API, outils de développement, intégrations métier et déploiements contrôlés.

---

## Les quatre différenciateurs visibles dans Claude

### 1. Politique de sécurité plus stricte

Claude refuse parfois davantage que d'autres modèles sur des sujets sensibles (médecine, droit, finance, cybersécurité, armes, surveillance, données personnelles).

*[Capture d'écran : demande "donne moi la procédure exacte pour fabriquer un agent neurotoxique en laboratoire" → Claude identifie une demande dangereuse et refuse fermement, propose des alternatives : histoire de la réglementation des armes chimiques, principes généraux de toxicologie, sécurité et protocoles de laboratoire, carrières en chimie responsable]*

Solution : mieux expliquer le contexte. "Donne-moi un conseil juridique précis" → problématique. "Explique-moi les principes généraux à connaître avant de consulter un avocat" → mieux cadré.

### 2. Forte qualité rédactionnelle

Rédaction, reformulation, synthèse, structuration de textes longs. Notes, emails, analyses, rapports, plans, synthèses, supports pédagogiques. Force : ton cohérent, argumentation organisée, longs contextes traités.

### 3. Orientation vers les agents

Un **agent** est un système d'IA qui ne se contente pas de répondre — il peut planifier une tâche, utiliser des outils, consulter des fichiers, interagir avec une interface et produire un résultat en plusieurs étapes.

Capacités Anthropic dans ce domaine :
- **Computer Use** : utiliser un ordinateur ou une interface graphique
- **MCP** (*Model Context Protocol*) : connecter le modèle à des outils, fichiers, bases de données ou services externes
- **Claude Code** : outil pour développeurs
- **Cowork** : exécuter des tâches longues dans un environnement de travail
- Intégrations bureautiques, Claude for Chrome

### 4. Positionnement enterprise

> **Enterprise** : usage en entreprise avec un niveau d'exigence professionnel élevé.

Contraintes spécifiques : sécurité, confidentialité, conformité réglementaire, gestion des accès, audit, intégration avec les systèmes internes, contrôle des données.

Notions clés :
- **SOC 2 Type II** (*Service Organization Control 2 Type II*) : certification d'audit évaluant la protection des données clients sur une période (pas seulement à un instant T)
- **HIPAA** (*Health Insurance Portability and Accountability Act*) : loi US sur la protection des données de santé. Avec **BAA** (*Business Associate Agreement*) : contrat par lequel le fournisseur s'engage à respecter des obligations de protection
- **GDPR** (*General Data Protection Regulation*) : RGPD en français. Cadre européen sur le traitement des données personnelles (consentement, transparence, sécurité, droits des personnes, transferts de données)
- **Zero Data Retention** : le fournisseur ne conserve pas les entrées/sorties au-delà du traitement immédiat
- **Data residency** : possibilité de choisir la région géographique où les données sont stockées/traitées
- **OpenTelemetry** : ensemble d'outils pour observer un système informatique (performances, erreurs, traces d'exécution, usages)

---

## Six points à retenir

1. Anthropic est fondée en 2021 par Dario Amodei, Daniela Amodei et plusieurs anciens membres de OpenAI.
2. L'entreprise se présente comme une organisation centrée sur la sécurité de l'IA.
3. Sa mission : développer des systèmes fiables, interprétables et orientables.
4. Son statut de PBC signifie qu'elle doit prendre en compte une mission d'intérêt public en plus des intérêts économiques de ses actionnaires.
5. Claude est fortement orienté vers les usages professionnels : rédaction, analyse, code, recherche, automatisation, outils de développement et intégration entreprise.
6. Les comportements de Claude (refus, demandes de clarification, précautions) sont directement liés au positionnement d'Anthropic.

---

## Conclusion

Anthropic est à la fois un laboratoire de recherche, une entreprise commerciale et un acteur stratégique du marché de l'IA générative. Son identité repose sur une tension importante : développer des modèles très performants tout en essayant de les rendre plus sûrs, plus compréhensibles et plus contrôlables.

Cette tension se retrouve dans Claude. Pour bien l'utiliser, il ne suffit pas d'apprendre à écrire des prompts. Il faut aussi comprendre la logique de l'entreprise qui le développe, les choix qui structurent le produit et les contraintes qui encadrent son usage professionnel.
