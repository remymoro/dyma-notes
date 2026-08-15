# Installer et présenter l’application Desktop Claude

*Claude : fondations → 4. Installation et présentation des clients → 3. Installation et présentation de l’application Desktop*

L’application Desktop Claude permet d’utiliser Claude (Chat), Claude Cowork et l'onglet Code (contenant l'intégration de Claude Code) depuis une interface graphique de bureau unifiée. Contrairement au CLI, elle propose un environnement visuel combinant fenêtres de chat, navigation dans les fichiers, visualisations de diffs, terminal et éditeur intégrés.

---

## Téléchargement et installation

### 1. Téléchargement sécurisé
Il est impératif d'utiliser les canaux officiels d'Anthropic pour obtenir les fichiers d'installation, l'application de bureau accédant à vos dossiers et clés de développement locaux.
- [Télécharger Claude Desktop (Officiel)](https://claude.ai/download)
- [Version macOS (Universelle Intel / Apple Silicon)](https://claude.ai/download)
- [Version Windows (x64 standard)](https://claude.ai/download)
- [Version Windows (ARM64 dédiée)](https://claude.ai/download)

### 2. Le cas Linux
**Claude Desktop n'est pas disponible sous Linux**. Les utilisateurs d'environnements Linux (VM, serveurs, conteneurs de développement) doivent piloter Claude Code exclusivement depuis le terminal via le **CLI**.

### 3. Connexion initiale
Après ouverture du paquet d'installation (Glisser-Déposer sous macOS, exécution de l'installateur sous Windows), connectez-vous avec votre compte Anthropic. Vos conversations, projets et accès se synchronisent automatiquement. Pour exploiter l'onglet **Code**, votre compte doit être associé à un abonnement compatible (Pro, Max, Team ou Enterprise).

---

## Les trois espaces majeurs de l'application

- **Chat** : L'interface conversationnelle classique, équivalente à l'expérience web dans le navigateur, optimisée pour l'analyse de documents unitaires et la génération textuelle simple.
- **Cowork** : Espace permettant d'assigner des tâches complexes en tâche de fond. Claude s'exécute de façon asynchrone sur l'infrastructure cloud d'Anthropic, libérant votre ordinateur local.
- **Code** : Interface graphique interactive pour Claude Code. Il permet de naviguer dans les fichiers de projets locaux ou distants, de relire des modifications de code via diffs et de valider ou rejeter les commits proposés par l'agent.

---

## Les types de sessions dans l'onglet Code

Pour lier un projet à l'onglet Code, trois types de connexion sont proposés :

1. **Session locale** : 
   L'agent travaille sur les dossiers présents sur votre machine physique. 
   *(Note sous Windows : L'outil Git est requis en local pour suivre l'historique et les diffs).*
2. **Session distante** :
   Le projet s'exécute sur l'infrastructure d'Anthropic. Utile pour déléguer de longs traitements et pouvoir fermer l'application de bureau sans interrompre l'agent.
3. **Connexion SSH** :
   Permet d'ouvrir un dossier situé sur un serveur distant, une machine virtuelle ou une instance cloud. L'application installe automatiquement la version de Claude Code compatible sur la cible SSH pour que vous puissiez la manipuler graphiquement.

---

## Fonctionnalités d'analyse visuelle et d'édition

- **Relecture visuelle de diffs** : À chaque suggestion de modification, l'application propose un diff ergonomique avec coloration syntaxique (lignes ajoutées/supprimées). Le développeur peut valider ou rejeter chaque bloc de changement en un clic.
- **Terminal et Éditeur intégrés** : L'interface regroupe en un seul écran le prompt utilisateur, la vue de code modifiable, les commandes de compilation et la console de log pour piloter l'agent de développement sans avoir à changer d'application.
- **Sessions multiples simultanées** : Permet de diviser les contextes (ex: une session pour fixer le bug A, une autre pour la couverture de test B, une troisième pour relire un diff Git), augmentant la pertinence et évitant le débordement de contexte.

---

## Comparatif : Application Desktop vs CLI

| Critère | CLI (Ligne de commande) | Application Desktop (Code) |
|---|---|---|
| **Interface** | Textuelle brute en console. | Graphique (diffs, éditeur et terminal côte à côte). |
| **Profil utilisateur** | Développeur habitué au terminal, scripts, outils CLI. | Développeur cherchant le confort visuel, le multi-session. |
| **Traitement parallèle** | Plus complexe (nécessite d'ouvrir plusieurs terminaux). | Natif (plusieurs onglets de session distincts). |
| **Environnement Linux** | Supporté nativement. | Non supporté (CLI obligatoire). |
| **Fonctionnalités sous-jacentes** | Identiques (mêmes MCP, permissions, skills et règles). | Identiques (mêmes MCP, permissions, skills et règles). |
