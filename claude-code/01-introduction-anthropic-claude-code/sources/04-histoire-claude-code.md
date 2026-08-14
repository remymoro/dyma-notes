# Histoire de Claude Code

*Claude : fondations → 1. Introduction à Anthropic et Claude → 4. Histoire de Claude Code*

## L'assistance au développement avant Claude Code

Avant l'arrivée de Claude Code, l'assistance au développement logiciel reposait principalement sur 3 catégories d'outils :
- **Les IDE** : Ils permettaient de naviguer dans un projet, de lancer des tests, d'inspecter les erreurs et d'utiliser des fonctionnalités de refactorisation.
- **Les moteurs de recherche** : Ils permettaient de trouver des documentations, des exemples de code ou des réponses techniques.
- **Les assistants de complétion** : Ils proposaient du code dans l'éditeur, souvent à partir des fichiers courants ou d'un contexte très limité.

Les assistants conversationnels ont ensuite permis de demander des explications, de générer des fonctions, d'écrire des tests ou de corriger des erreurs en langage naturel. Mais ces assistants restaient souvent séparés de l'environnement réel du développeur. Ils pouvaient produire du code, mais ils ne voyaient pas toujours le dépôt complet, ne lançaient pas les tests, ne modifiaient pas directement les fichiers et ne pouvaient pas vérifier eux-mêmes le résultat. 

Claude Code apparaît précisément dans cet espace. Sa différence historique n'est pas seulement d'avoir un meilleur modèle de langage ; sa différence majeure est d'être conçu comme un **agent de développement** qui travaille directement dans l'environnement du projet (le terminal, les fichiers, les commandes, les tests, les erreurs, les changements de code et les vérifications).

## Les origines internes chez Anthropic

L'histoire publique de Claude Code commence avant son annonce officielle. Le projet naît d'expérimentations internes chez Anthropic autour d'une idée simple : donner à Claude une interface dans le terminal, puis lui permettre de lire du code, d'exécuter des commandes et de modifier des fichiers. 

Dans les récits publics associés au projet, **Boris Cherny** est l'un des noms les plus directement liés à l'origine technique de Claude Code. L'idée initiale n'est pas décrite comme un grand produit planifié dès le départ, mais comme une expérimentation pratique : que se passe-t-il si un modèle comme Claude n'est plus seulement dans une fenêtre de chat, mais dans le terminal d'un développeur, avec accès au dépôt et aux outils du projet ?

Le prototype devient réellement utile lorsqu'il cesse d'être seulement conversationnel. Dès que l'agent peut explorer les fichiers, lancer des commandes, lire les sorties du terminal et recommencer après une erreur, il devient capable de participer à des tâches de développement complètes. C'est ce passage du texte vers l'action qui donne à Claude Code sa forme historique.

La philosophie du projet est fortement marquée par l'univers du terminal et des outils Unix. Claude Code n'est pas d'abord pensé comme une interface graphique lourde. Il est pensé comme un outil simple, composable, textuel, proche des habitudes des développeurs qui travaillent déjà avec Git, les tests, les scripts, les fichiers de configuration et la ligne de commande.

Cette origine explique plusieurs choix fondamentaux dans l'évolution du produit :
- L'importance primordiale du terminal.
- L'utilisation de fichiers de contexte comme `CLAUDE.md`.
- L'importance de la gestion fine des permissions.
- La vérification systématique par commandes.
- L'idée que l'agent doit être intégré aux outils existants plutôt que de remplacer l'environnement de développement complet.

### L'équipe publiquement associée à Claude Code

Anthropic n'a pas publié une liste exhaustive et définitive de toutes les personnes ayant contribué à Claude Code. En revanche, plusieurs noms sont publiquement associés à son histoire :
- **Boris Cherny** : L'un des noms les plus liés à l'origine technique du projet. Présenté comme une figure centrale de l'ingénierie de Claude Code.
- **Cat Wu** : Associée au pilotage produit. Son rôle a concerné la transformation du prototype technique en produit utilisable, documenté et intégré dans l'offre commerciale d'Anthropic.
- **Sid Bidasaria** : Se présente publiquement comme *founding engineer* et *tech lead* de Claude Code, indiquant une implication fondatrice dans sa construction technique.
- **Cal Rueb** : Intervient dans la communication publique, notamment dans les démonstrations de fonctionnement et de bonnes pratiques.

## Chronologie de l'évolution (2025 - 2026)

### 24 février 2025 : L'annonce publique de Claude Code

La première grande date publique est le **24 février 2025**. Anthropic annonce alors le modèle **Claude 3.7 Sonnet** et présente en même temps Claude Code.

À ce moment, il est annoncé en **Limited Research Preview**. L'outil est présenté comme prometteur mais encore expérimental. Les capacités fondamentales sont déjà en place : recherche et lecture de code, modification de fichiers, exécution de tests, utilisation de Git, création de commits, push vers GitHub et interactions avec la ligne de commande.

Ce lancement positionne d'emblée Claude Code comme un agent autonome à qui l'on délègue des tâches d'ingénierie (comprendre une base de code, modifier plusieurs fichiers, valider les tests, etc.) plutôt qu'un simple outil de complétion.

### La période de Research Preview (Février - Mai 2025)

Pendant cette phase, Claude Code évolue rapidement. Anthropic teste les fondations de l'outil et résout des problèmes de base : la gestion du contexte, le contrôle des actions dangereuses, la reprise de session, la validation des modifications et la lisibilité des diffs.

#### 2 avril 2025 : Première grande consolidation fonctionnelle
Le changelog montre une accélération majeure :
- **Commandes personnalisées** via `/project:` et `/user:` pour enregistrer des routines réutilisables.
- **Support de MCP (Model Context Protocol)** pour connecter l'agent à des outils et serveurs externes.
- **Mémoire persistante** avec les souvenirs (préfixe `#`), les fichiers de contexte et la compaction automatique pour les sessions longues.
- **Permissions affinées** pour contrôler les actions sans interrompre constamment l'utilisateur.
- **Ergonomie** : Autocomplétion de chemins, diffs détaillés, mots-clés de réflexion (`think`, `think hard`, `ultrathink`).

#### Avril 2025 : L'agent devient plus pilotable
- Mise en file d'attente des messages pendant que l'agent travaille.
- Traitement des images collées dans le chat.
- Mention directe de fichiers avec `@`.
- Commandes réseau mieux gérées (comme `curl` et la recherche web en parallèle).
- Structuration de la notion de "tâche" par étapes (exploration, modification, vérification).

#### Mai 2025 : Préparation de la disponibilité générale
- Importation et composition de plusieurs fichiers de contexte dans `CLAUDE.md` (séparation des conventions de code, règles de test, etc.).
- Intégration directe de la recherche web.

### 22 mai 2025 : Disponibilité générale (GA)

Le **22 mai 2025**, lors de l'annonce de **Claude 4**, Claude Code devient **Generally Available (GA)**.

Cette étape s'accompagne d'une extension importante des surfaces :
- Intégrations natives avec les IDE (**VS Code** et **JetBrains**).
- Tâches en arrière-plan via **GitHub Actions**.
- Lancement d'un **SDK** pour construire ses propres agents à partir du noyau de Claude Code.

### Juin 2025 : Abonnements et extension du SDK

- Support de l'abonnement Pro pour un accès plus large.
- Publication officielle du SDK en **TypeScript** et en **Python** pour réutiliser le moteur agentique de Claude Code dans d'autres applications.

### Été 2025 : Subagents et hooks

L'été 2025 marque l'ère de la spécialisation :
- **Subagents** : Possibilité de déléguer des sous-tâches à des agents spécialisés (exploration, revue, tests, documentation).
- **Hooks** : Automatisation de vérifications ou injection de contexte à des moments précis du cycle de travail.
- **Commandes en arrière-plan** et ligne de statut (août 2025) pour suivre l'état de l'agent sans bloquer le terminal lors de tâches longues (builds, migrations).

### Septembre 2025 : Claude Sonnet 4.5 et le codage long

L'annonce de **Claude Sonnet 4.5** le 29 septembre 2025 booste Claude Code. Le modèle est taillé pour les tâches longues. En parallèle, Claude Code intègre :
- Des **checkpoints** pour revenir facilement en arrière si une modification longue se passe mal.
- Une interface terminal rafraîchie.
- Une extension VS Code améliorée.

### Automne 2025 : Plugins, Skills et Sandbox

- **Plugins et Skills** : Outils de personnalisation et packs métiers.
- **Mode Sandbox** : Exécution de commandes risquées dans un environnement sécurisé pour augmenter l'autonomie tout en protégeant la machine de l'utilisateur.
- **Gestion des permissions** : Interfaces plus claires pour autoriser ou auditer les actions de l'agent.

### Novembre 2025 : Permissions avancées

- Hooks de permissions pour intercepter finement les requêtes sensibles.
- Tâches en arrière-plan exécutables vers des environnements web.

### 2026 : Travail en équipe, mémoire automatique et contrôle distant

En 2026, l'outil s'oriente vers des workflows distribués :
- **Agent Teams** (en Research Preview) : Coopération de plusieurs agents organisés comme une équipe de développement.
- **Mémoire automatique** : Amélioration de la conservation du contexte entre les sessions sans avoir besoin de répéter les mêmes consignes.
- **Contrôle distant** : Possibilité de piloter des sessions locales depuis d'autres interfaces (navigateur, mobile).

---

## L'évolution des surfaces de Claude Code

L'outil est passé d'un simple noyau terminal à un écosystème multi-surfaces :
1. **Terminal** : Interface d'origine, proche de la philosophie Unix.
2. **IDE (VS Code, JetBrains, Xcode)** : Intégration visuelle directe dans l'éditeur.
3. **CI/CD (GitHub Actions)** : Exécution de tâches asynchrones sur les dépôts distants (PRs, builds).
4. **SDK (Python/TypeScript)** : Brique d'infrastructure pour programmer des agents sur mesure.
5. **Web, Desktop, Mobile, Slack** : Interfaces de pilotage à distance et de communication.

---

## Adoption et cas d'usage réels

### Adoption interne chez Anthropic
Avant son lancement, Claude Code a été testé en interne. Anthropic indique qu'en 2026, la majorité du code fusionné (merged) dans ses propres bases de code est attribuée à ou générée par Claude, démontrant l'efficacité de l'outil sur des dépôts réels (bien sûr toujours validé par des ingénieurs humains).

### Le cas Stripe
Stripe utilise Claude Code à grande échelle. L'entreprise l'a notamment utilisé pour des migrations de code massives (milliers de lignes de code migrées en quelques jours au lieu de plusieurs semaines de travail manuel).

### Le cas Ramp
Ramp utilise Claude Code non seulement pour générer du code mais aussi pour mener des investigations sur des incidents, analyser des métriques d'observabilité et naviguer dans des contextes complexes de bugs de production.

### Le cas Wiz
Wiz utilise Claude Code pour des migrations de volumes importants de fichiers et des conversions de langages (notamment du Python/C++ vers Go) à un rythme très soutenu.

---

## L'incident de sécurité de 2026 : Le Source Map

En 2026, une version du paquet npm `@anthropic-ai/claude-code` est publiée par erreur avec un fichier **source map** exposant une partie importante du code source TypeScript du client.

### Conséquences réelles
- Cet incident n'a pas rendu Claude Code open source et n'a pas exposé le modèle ou les données serveurs.
- Il a toutefois mis en lumière les risques de la chaîne d'approvisionnement (supply chain) des outils de développement basés sur l'IA (qui s'exécutent avec des accès privilégiés sur la machine).
- Il a permis aux chercheurs d'étudier l'architecture interne de l'agent (gestion des permissions, prompts système, etc.).
- Il a entraîné l'apparition de dépôts miroirs non officiels et de faux paquets npm distribuant des malwares, soulignant l'importance de n'installer que les paquets vérifiés d'Anthropic.
