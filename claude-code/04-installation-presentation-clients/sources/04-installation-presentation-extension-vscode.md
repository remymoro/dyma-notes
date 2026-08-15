# Installer et présenter l’extension VS Code Claude Code

*Claude : fondations → 4. Installation et présentation des clients → 4. Installation et présentation de l’extension VS Code*

L'extension VS Code Claude Code fournit une interface graphique native pour Claude Code directement au sein de votre éditeur de code. Elle permet d'interagir avec l'agent sans avoir à basculer constamment vers un terminal système externe. Vous pouvez lui demander des modifications sur le fichier ouvert, relire des diffs, valider des propositions et piloter un agent tout en gardant votre code visible à l'écran.

---

## Les prérequis à l'installation
- **VS Code** : Version **1.98.0** ou supérieure.
- **Compte Anthropic** : Abonnement compatible Claude Pro, Claude Max, Team, Enterprise, ou compte Console. L'authentification passe par le navigateur, sans saisie manuelle de clé API dans un usage standard.
- **CLI vs Extension** : L’extension VS Code embarque sa propre copie du CLI Claude Code pour fonctionner de façon autonome. Cependant, si vous souhaitez exécuter la commande `claude` dans le terminal intégré de VS Code, vous devez avoir installé séparément le **CLI autonome** sur votre machine.

---

## Installation et démarrage

### 1. Installation
1. Ouvrez l'onglet **Extensions** dans VS Code (`Cmd+Shift+X` sur macOS / `Ctrl+Shift+X` sur Windows/Linux).
2. Recherchez **Claude Code** (publié par Anthropic).
3. Cliquez sur **Install**.
4. En cas de dysfonctionnement après installation, rechargez la fenêtre via le raccourci `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux) puis tapez la commande : `Developer: Reload Window`.

### 2. Ouverture de l'interface
L'onglet Claude Code s'ouvre par :
- Un clic sur l'icône **Spark** (étincelle) dans la barre latérale ou la barre d'outils de l'éditeur.
- La palette de commandes (`Cmd+Shift+P` / `Ctrl+Shift+P`) en saisissant : `Claude Code: Open in New Tab`.

### 3. Connexion initiale
Au premier affichage de l'interface de l'extension, cliquez sur le bouton **Sign in**. Le navigateur s'ouvre pour autoriser l'application. Une fois validée, l'extension est fonctionnelle. 

*(Pour les fournisseurs tiers comme Amazon Bedrock ou Google Vertex AI, les identifiants et configurations s'injectent directement dans les paramètres globaux de l'application).*

---

## Fonctionnalités clés de l'extension

### 1. Sélection contextuelle et @-mentions
- **@-mentions** : Permet de cibler précisément un fichier ou une plage de lignes dans vos prompts (ex: `@src/app.ts` ou `@src/app.ts#5-20`). Cela évite au modèle d'analyser l'intégralité du projet et fiabilise sa réponse.
- Raccourci d'insertion rapide de référence depuis le code sélectionné :
  - **macOS** : `Option+K`
  - **Windows / Linux** : `Alt+K`

### 2. Relecture de diffs interactifs
Lorsqu'une modification est proposée par Claude :
- L'extension ouvre une comparaison graphique interactive entre le fichier original et la suggestion.
- Le développeur peut accepter le changement, le refuser pour demander une autre version, ou **modifier directement la proposition de diff à la main** avant de la valider. Claude s'adaptera aux ajustements manuels effectués.

### 3. Les conversations multiples par onglets
Vous pouvez ouvrir plusieurs panneaux de chat Claude Code en parallèle pour traiter des tâches indépendantes (ex: corriger un bug sur l'onglet A, écrire un script de test sur l'onglet B) sans polluer le contexte mémoire du modèle.

### 4. La gestion des Checkpoints (Points de restauration)
L'extension propose un historique des **checkpoints** lors des modifications successives de fichiers réalisées par Claude. Si l'agent prend une mauvaise direction ou si vous souhaitez annuler ses 5 dernières étapes de modification, vous pouvez revenir en arrière instantanément. *(Note : ces checkpoints s'exécutent en mémoire de travail de la session et ne remplacent pas les commits Git formels).*

---

## Configuration partagée et fichier `settings.json`

Les paramètres de l'extension sont modifiables via l'interface standard de configuration de VS Code (`Cmd+,` sur macOS / `Ctrl+,` sur Windows/Linux) sous la section *Extensions -> Claude Code*.

Certains paramètres avancés (variables d'environnement, permissions d'outils, serveurs MCP, hooks) sont stockés dans le fichier de configuration global de Claude Code :
```bash
~/.claude/settings.json
```
Cette architecture permet de **partager la même configuration technique** entre l'extension de votre éditeur VS Code et l'usage en ligne de commande (CLI).

---

## Comparatif : Extension VS Code vs CLI autonome

| Critère | Extension VS Code | CLI autonome |
|---|---|---|
| **Intégration** | Graphique, intégrée dans le workflow visuel de l'éditeur. | Textuelle brute dans la console système. |
| **Sélections** | Contextuelle via @-mentions et raccourcis clavier (`Alt+K`). | Requiert d'écrire les chemins de fichiers manuellement. |
| **Checkpoints** | Restaurations visuelles faciles depuis l'interface graphique. | Gérés via commandes internes ou Git. |
| **MCP et Skills** | Supportés, mais la configuration avancée se fait via le CLI. | Support natif complet, idéal pour les configurations complexes. |
| **Terminal intégré** | Permet de lancer le CLI autonome directement en console. | Exécution principale. |
