# Comprendre l’exécution locale, remote et cloud

*Claude : fondations → 4. Installation et présentation des clients → 5. Exécution locale, remote et cloud et présentation de claude.ai/code*

Lorsque vous utilisez Claude Code, il est crucial de savoir où le code est lu, modifié et exécuté. Cela détermine quels fichiers sont accessibles, quelles commandes système peuvent être lancées, la sécurité des accès et comment configurer les outils de développement (MCP, variables, clés).

Il faut distinguer trois environnements d'exécution :
1. **L’exécution locale** : Claude Code s'exécute sur votre machine physique.
2. **Le Remote Control** : Vous pilotez à distance (ex: via un navigateur) une session locale active sur votre machine.
3. **L’exécution Cloud (ou Remote)** : Claude Code s'exécute dans une machine virtuelle (VM) gérée par Anthropic, liée à un dépôt GitHub.

---

## 1. L'exécution locale

Dans ce mode, le processus de l'agent s'exécute directement sur votre ordinateur.
- **Accès** : Il lit vos fichiers locaux, utilise vos outils installés (npm, docker, compilateur), accède à vos variables d'environnement locales et interroge vos bases de données en local.
- **Utilisation** : Activé par le CLI (`claude`), l'extension VS Code locale ou les sessions locales de l'application Desktop.
- **Commandes utiles** :
  - `claude --permission-mode plan` : Lance le mode Plan localement (l'agent explore et propose une stratégie d'écriture sans appliquer de changements directs).
- **Usages ciblés** : Idéal lorsque le projet dépend de configurations machine non committées, d'accès intranet ou d'outils de debug spécifiques.

---

## 2. Le Remote Control (Contrôle à distance)

Le **Remote Control** permet de déporter uniquement l'interface utilisateur (vers un navigateur ou mobile à l'adresse `claude.ai/code`), tandis que le calcul et l'exécution du code continuent d'opérer sur votre machine locale.
- **Limites** : Si le processus local s'arrête, si le terminal est fermé ou si l'ordinateur se met en veille, la session de travail s'interrompt immédiatement.
- **Activation en ligne de commande** :
  - `claude remote-control --name "Projet API"` : Lance un serveur de contrôle à distance nommé.
  - `claude --remote-control` (ou version courte `claude --rc`) : Démarre une session interactive locale tout en l'exposant au contrôle à distance.
- **Activation depuis une session active** :
  - `/remote-control` (ou version courte `/rc`) : Expose le fil de discussion en cours.

---

## 3. L'exécution SSH (Machine distante sous votre contrôle)

Le code s'exécute sur un serveur, une machine virtuelle ou un conteneur distant accessible en SSH. L'application Desktop s'y connecte pour installer Claude Code et piloter les changements.
- **Différence majeure** : Contrairement au *Remote Control* où le moteur tourne chez vous, la connexion SSH déporte le moteur sur votre serveur de développement distant.

---

## 4. L'exécution Cloud

Dans ce mode, Claude Code s'exécute sur une machine virtuelle isolée (Sandbox) hébergée par Anthropic. Le code local n'est pas utilisé directement (sauf envoi forcé par bundle).

### Processus basé sur GitHub
Le flux standard requiert de lier un dépôt Git :
1. Connexion à [claude.ai/code](https://claude.ai/code).
2. Installation de l'application GitHub Claude.
3. Choix du dépôt et de la branche.
4. Lancement de la tâche. L'agent effectue le travail dans sa VM cloud, puis pousse une branche Git ou crée une Pull Request pour revue humaine.

### Pilotage Cloud depuis le CLI (Terminal local)
Vous pouvez configurer et soumettre des tâches Cloud directement depuis votre console :
- **Configuration** (Une fois le GitHub CLI `gh` authentifié via `gh auth login`) :
  ```markdown
  /web-setup
  ```
  *(Associe votre compte GitHub local à votre compte Claude Cloud).*
- **Lancer une tâche distante** :
  ```bash
  claude --remote "Corrige le bug d'authentification dans src/auth/login.ts"
  ```
  *(Démarre une VM distante qui clone, exécute et pousse les modifications).*
- **Suivre les tâches en cours** (en session) :
  ```markdown
  /tasks
  ```
- **Téléporter la session en local** :
  ```bash
  claude --teleport
  # ou avec ID précis :
  claude --teleport <session-id>
  ```
  *(Télécharge la branche générée par le cloud, charge l'historique et vous permet de continuer la session en local).*
- **Forcer l'envoi d'un dépôt local non connecté** (via bundle compressé) :
  ```bash
  CCR_FORCE_BUNDLE=1 claude --remote "Lance la suite de tests"
  ```

---

## Configuration de l'environnement Cloud

Les sessions Cloud démarrent à partir d'un clone propre du dépôt distant. 
- **Fichiers partagés** : Seuls les fichiers committés dans le dépôt sont transmis au Cloud (notamment `CLAUDE.md`, `.claude/settings.json`, `.mcp.json`, et le dossier `.claude/skills/`).
- **Fichiers exclus** : Tout ce qui se trouve dans votre dossier utilisateur local (ex: `~/.claude/settings.json`) est **ignoré** par le Cloud.
- **Setup Script** : Script Bash exécuté au démarrage de la VM cloud pour installer les outils système ou dépendances nécessaires non incluses par défaut dans l'image système. Ces installations sont mises en cache pour accélérer les sessions suivantes.
- **Commandes de session Cloud** :
  - `/remote-env` : Choisit l'environnement cloud par défaut.
  - Configuration des variables d'environnement au format `.env` (à manipuler avec prudence car visibles par les administrateurs du workspace).

---

## Comparatif des environnements d'exécution

| Caractéristique | Local | Remote Control | SSH | Cloud |
|---|---|---|---|---|
| **Lieu d'exécution** | Machine locale. | Machine locale. | Serveur distant. | VM Anthropic (Sandbox). |
| **Interface de saisie** | CLI / IDE Local. | Web browser / Mobile. | IDE / Desktop local. | Web browser (claude.ai/code). |
| **Dépendance système** | Forte (outils locaux). | Forte (outils locaux). | Moyenne (outils SSH). | Nulle (clone de dépôt propre). |
| **Parallélisation** | Difficile. | Difficile. | Moyenne. | Excellente (multi-VMs). |
| **Sécurité machine** | Vigilance requise. | Vigilance requise. | Vigilance requise. | Maximale (isolation cloud). |
