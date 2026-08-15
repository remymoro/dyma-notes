# Installer et présenter le CLI Claude Code

*Claude : fondations → 4. Installation et présentation des clients → 2. Installation et présentation du CLI*

Le CLI (Command Line Interface) est l’interface en ligne de commande de Claude Code. Elle permet de travailler directement depuis le terminal, dans un projet réel, avec un agent capable de lire le codebase, de modifier des fichiers, d’exécuter des commandes système et de vous aider à corriger ou faire évoluer une application.

---

## Les prérequis à l'installation
Avant d’installer Claude Code, vous devez disposer d’un terminal ouvert, d’un projet de code existant localement et d’un compte utilisateur compatible (abonnement Claude Pro/Team, compte Anthropic API Console ou accès via un fournisseur cloud partenaire).

---

## Méthodes d'installation

### 1. L'installation native (Recommandée)
C'est la méthode recommandée pour démarrer rapidement. Elle installe le binaire directement sur votre machine.

* **macOS / Linux / WSL (Windows Subsystem for Linux)** :
  ```bash
  curl -fsSL https://claude.ai/install.sh | bash
  ```
* **Windows (PowerShell - identifiable par le préfixe `PS C:\`)** :
  ```powershell
  irm https://claude.ai/install.ps1 | iex
  ```
* **Windows (CMD - identifiable par le préfixe `C:\`)** :
  ```cmd
  curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd
  ```

> [!NOTE]
> L'installation native dispose d'un avantage majeur : elle intègre un mécanisme de **mise à jour automatique**.

### 2. L'installation par gestionnaire de paquets
Utile dans les environnements de développement standardisés. Ces installations doivent être mises à jour manuellement.
* **macOS (via Homebrew)** :
  ```bash
  brew install --cask claude-code
  ```
* **Windows (via WinGet)** :
  ```cmd
  winget install Anthropic.ClaudeCode
  ```

### 3. L'installation via npm
Si Node.js 18 (ou plus récent) est installé, Claude Code peut être installé globalement :
```bash
npm install -g @anthropic-ai/claude-code
```
> [!WARNING]
> Évitez de forcer l'installation globale via `sudo npm install -g` car cela crée des conflits de permissions et des risques de sécurité.

---

## Démarrage et Authentification

Une fois l’installation terminée, ouvrez votre terminal dans le répertoire de votre projet :
```bash
cd /chemin/vers/votre/projet
claude
```

Au premier lancement, le CLI demande une authentification qui s'effectue de manière sécurisée dans votre navigateur web. Une fois finalisée, le token d'authentification est stocké localement sur votre machine pour éviter d'avoir à s'authentifier à chaque démarrage.

Pour changer de compte ou renouveler une authentification expirée, utilisez la commande interne de session suivante :
```markdown
/login
```

---

## Typologie des commandes

Il faut distinguer deux familles de commandes :
1. **Les commandes shell (ou système)** : Lancées depuis votre terminal classique pour démarrer ou piloter Claude Code depuis l'extérieur.
2. **Les commandes de session** : Commencent par un slash `/` et se tapent uniquement à l'intérieur de l'interface conversationnelle interactive de Claude Code.

### 1. Commandes Shell essentielles
- `claude` : Ouvre une session interactive vierge dans le répertoire actuel.
- `claude "consigne"` : Lance l'agent avec une tâche ou question explicite immédiate (ex: `claude "explique l'architecture de ce projet"`).
- `claude -p "question"` : Pose une question ponctuelle (one-off) en mode passif et quitte la session directement après avoir imprimé la réponse.
- `claude -c` : Continue la conversation active la plus récente dans ce dossier.
- `claude -r` : Reprend une session conversationnelle précédente en listant l'historique récent.
- `claude doctor` : Lance un diagnostic de santé de l'installation du CLI (vérification du réseau, de l'authentification et des dépendances).

### 2. Commandes de session interactives essentielles
- `/help` : Affiche l'aide et la documentation des commandes internes.
- `/clear` : Efface l'historique et réinitialise le contexte de la conversation en cours.
- `/exit` (ou raccourci `Ctrl+D`) : Quitte la session interactive actuelle.
- `/` (suivi de la touche Tab) : Déclenche l'autocomplétion des commandes de session.
- **Flèche du haut** : Rappelle l'historique des prompts précédents dans la session.
- **Shift+Tab** : Permet de basculer et de parcourir les modes de permission d'exécution des outils.

---

## Maintenance et Mises à jour

Claude Code évolue très rapidement. Pour garantir la sécurité et profiter des dernières optimisations :

- **Mise à jour en shell (terminal système)** :
  ```bash
  claude update
  ```
  *(Télécharge et installe la dernière version stable).*

- **Mise à jour en session interactive** :
  ```markdown
  /upgrade
  ```
  *(Permet de mettre à niveau les options du compte ou d'environnement).*

- **Consulter le changelog et les notes** :
  ```markdown
  /release-notes
  ```
  *(Affiche les correctifs de bugs, nouvelles fonctionnalités et modifications de permissions directement dans l'interface).*
