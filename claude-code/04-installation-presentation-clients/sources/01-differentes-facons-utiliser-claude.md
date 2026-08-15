# Les différentes façons d'utiliser Claude (et les LLM) pour coder

*Claude : fondations → 4. Installation et présentation des clients → 1. Les différentes façons d'utiliser Claude*

Un LLM peut intervenir à plusieurs niveaux dans le travail d’un développeur : proposer la suite d’une ligne, répondre à une question sur un fichier, modifier une fonction localement ou agir comme un agent de code capable de lire un projet, modifier plusieurs fichiers, exécuter des commandes, analyser les erreurs et recommencer jusqu’à obtenir un résultat vérifiable.

Ces usages ne sont pas équivalents. Ils ne donnent pas le même niveau d’autonomie au modèle, ne présentent pas le même niveau de risque et ne s’utilisent pas dans les mêmes situations. La progression logique est la suivante : autocomplétion, chat dans l’éditeur, édition assistée, agent de code local, IDE agentique, puis agent cloud.

---

## 1. L’autocomplétion

L’autocomplétion est l’usage le plus simple d’un LLM pour le code. Le modèle observe le fichier ouvert, le langage utilisé, les lignes précédentes (et parfois d'autres fichiers du projet) et propose la suite probable du code. Cette proposition apparaît sous forme de texte grisé (ghost text) dans l’éditeur. Le développeur peut l’accepter (via Tab), la modifier ou l’ignorer.
- **Utilité** : Accélérer l'écriture de code répétitif, de structures simples, d'assertions de tests, d'annotations de types ou de fonctions standardisées (ex: `formatPrice`).
- **Limites** : Le modèle agit comme un accélérateur de saisie locale. Il ne prend pas en charge la conception globale, l'architecture, la cohérence du projet, ni la compilation et les tests.

---

## 2. Le chat dans l'éditeur (extensions VS Code / JetBrains)

Discussion interactive avec le LLM directement intégrée au panneau latéral ou à la ligne de code de l'IDE.
- **Rôle de l'extension** : Accéder au fichier ouvert, à la sélection, aux diagnostics d’erreurs de l’éditeur, à certains fichiers du projet et parfois au terminal.
- **Usages courants** : Sélectionner une fonction et demander : *"Explique cette fonction"*, *"Trouve les erreurs possibles"*, *"Ajoute les types manquants"* ou *"Écris les tests unitaires"*. 
- **Bénéfice** : Première étape vers le raisonnement agentique, car le développeur donne une intention, un contexte et un objectif précis de modification.

---

## 3. L'édition assistée (Inline editing)

Usage intermédiaire entre le chat et l'agent autonome. Le développeur demande au LLM de modifier directement une zone de code ciblée (un fichier, une classe, une sélection).
- **Usages courants** : Transformer une logique synchrone en version asynchrone, corriger des erreurs TypeScript locales, ajouter la gestion des erreurs dans un service.
- **Contrôle** : L'outil propose un diff visuel (avant/après) directement dans le fichier, et le développeur choisit d'accepter ou de rejeter le changement.

---

## 4. L'agent de code local (Terminal-based)

Un agent de code reçoit un objectif global (ex: *"Ajoute un système d'authentification"*). Il explore le projet, propose un plan, modifie plusieurs fichiers, exécute des commandes de vérification dans le terminal (compilation, tests), analyse les messages d'erreurs et itère jusqu'à la réussite de la tâche.

### Les assistants de terminal courants
- **Claude Code** : Outil d'Anthropic qui s'exécute directement en ligne de commande. Il peut lire le codebase local, exécuter des commandes système de tests ou de build, et utiliser Git pour inspecter des diffs ou préparer des commits.
- **Codex CLI** : Agent d'OpenAI fonctionnant de manière similaire en ligne de commande locale pour les tâches de build, migration, lint ou tests.
- **Antigravity CLI** : Plateforme agentique en terminal permettant à l'agent d'exécuter des workflows complexes et de corriger ses erreurs de manière autonome.

---

## 5. Les IDE agentiques

Un IDE agentique place l'agent d'IA au centre de l'expérience utilisateur de développement, plutôt que sous forme d'une simple extension greffée.
- **Cursor** : IDE basé sur VS Code intégrant nativement l'autocomplétion, le chat contextuel globale au codebase (Composer), l'édition assistée et les agents de code autonomes.
- **Google Antigravity** : Plateforme de développement *agent-first* où le développeur délègue des tâches complètes (ex: *"Implémente cette fonctionnalité, teste-la dans le navigateur et prépare la PR"*).

---

## 6. Les agents de code Cloud

Un agent distant qui travaille dans un conteneur cloud isolé plutôt que sur la machine locale du développeur.
- **Fonctionnement** : Il clone le dépôt Git dans un bac à sable (sandbox), installe les dépendances, exécute ses tests et builds, applique les modifications, puis propose le résultat sous forme de Pull Request ou de branche Git.
- **Avantages** : Isolation totale (aucun risque de suppression accidentelle de fichiers locaux ou d'exécution de code malveillant sur la machine physique) et possibilité de paralléliser plusieurs tâches complexes sans bloquer le terminal local.
- **Inconvénients** : Nécessite un environnement cloud entièrement reproductible (variables d'environnement, secrets API, accès réseau).

---

## Synthèse comparative des surfaces d'usage de Claude Code

| Interface | Rôle & Usage idéal | Exemple de tâche |
|---|---|---|
| **Terminal (CLI)** | Tâches de développement pures, correction de bugs complexes, exécution de scripts et tests unitaires en boucle fermée. | `claude "trouve le bug qui fait échouer le test X et corrige-le"` |
| **VS Code / JetBrains** | Travail visuel de réécriture, revue de code, explications textuelles interactives. | Ajouter des commentaires et typer un fichier TypeScript ouvert. |
| **Application de Bureau** | Découverte de l'outil pour les débutants, assistance rédactionnelle sans accès direct au terminal système. | Rédiger une documentation de projet. |
| **Navigateur (Session Cloud)** | Exécution de tâches isolées sur un conteneur distant, parallélisation de builds. | Cloner et auditer la sécurité d'un dépôt externe. |
| **Contrôle à distance (Remote)** | Suivi et pilotage à distance d'une session locale s'exécutant sur la machine de bureau. | Surveiller une longue tâche de build depuis son mobile ou navigateur. |
| **Slack / CI-CD** | Workflows collaboratifs d'équipe, revue de Pull Requests automatique. | Commenter automatiquement les violations de style sur une PR. |
