# Dyma Notes — Claude Code

Fiches de révision personnelles du cours **Claude Code** (Dyma), au format **hybride**, avec un cycle de **répétition espacée**.

Chaque leçon donne lieu à une fiche en deux blocs : la **fiche de révision** (tableau Cornell *indices / notes*, synthèse reformulée, glossaire, questions d'auto-évaluation), puis le **cours retravaillé** (sections thématiques, schémas ASCII, tableau des commandes, top 5, carte mentale, mini fiche et phrase à retenir).

## Progression

`██████░░░░░░░░░░░░░░`  **37 / 134** fiches rédigées — 28 %

| | |
|---|---|
| Chapitres | 25 |
| Leçons | 134 |
| Durée cumulée | 26 h 49 *(sur 110 leçons renseignées)* |
| Fiches complètes | 37 |
| Fiches à rédiger | 97 |

## Comment lire ce dépôt

```
claude-code/
└── NN-nom-du-chapitre/
    ├── NN-nom-de-la-lecon.md    ← la fiche hybride (le travail retravaillé)
    ├── sources/NN-....md         ← le contenu brut de la leçon, archivé
    └── assets/                   ← schémas et captures
```

- **La fiche** ne contient jamais de copier-coller. Le bloc de révision se relit à chaque échéance ; le cours retravaillé se relit quand une réponse est fausse.
- **La source** est l'archive brute de la leçon : ni frontmatter, ni squelette, elle sert d'ultime référence.
- Le modèle de référence est la fiche [04/05](claude-code/04-installation-presentation-clients/05-execution-locale-remote-cloud-claude-ai-code.md).

## Cycle de répétition espacée

Le champ `etape_revision` du frontmatter positionne la fiche dans la séquence :

| Étape | Prochaine révision | Nouvelle étape |
|---|---|---|
| 0 — rédigée, jamais révisée | J+1 | 1 |
| 1 | J+3 | 2 |
| 2 | J+7 | 3 |
| 3 | J+15 | 4 |
| 4 | aucune | reste à 4, `statut: acquis` |

Le skill `.claude/skills/tuteur-dyma` pilote ce cycle : il pose les questions **avant** de corriger, archive la source, puis met à jour `etape_revision`, `prochaine_revision` et `statut`.

## Outillage

| Commande | Rôle |
|---|---|
| `./init-fiches.sh` | Crée ou complète le frontmatter et le squelette de la fiche hybride. Idempotent : ne touche ni aux fiches rédigées, ni aux archives `sources/`. |
| `/tuteur-dyma` | Travaille une nouvelle leçon ou lance une session de révision. |

## Légende

✅ fiche rédigée · ⬜ squelette à remplir

## Chapitres

### 01 — Introduction à Anthropic et Claude Code

> 4/4 fiches · 38 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [À l’abordage](claude-code/01-introduction-anthropic-claude-code/01-a-l-abordage.md) | 4 min | ✅ | 0 | 2026-08-23 |
| 02 | [Histoire d'Anthropic et de Claude](claude-code/01-introduction-anthropic-claude-code/02-histoire-anthropic-et-claude.md) | — | ✅ | 0 | 2026-08-23 |
| 03 | [Tour d’horizon des produits Anthropic](claude-code/01-introduction-anthropic-claude-code/03-tour-horizon-produits-anthropic.md) | 20 min | ✅ | 0 | 2026-08-23 |
| 04 | [Histoire de Claude Code](claude-code/01-introduction-anthropic-claude-code/04-histoire-claude-code.md) | 14 min | ✅ | 0 | 2026-08-23 |

### 02 — Comprendre l'intelligence artificielle générative

> 6/6 fiches · 111 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Fonctionnement d’un LLM](claude-code/02-comprendre-intelligence-artificielle-generative/01-fonctionnement-llm.md) | 21 min | ✅ | 0 | 2026-08-23 |
| 02 | [Les phases d’entraînement d’un LLM](claude-code/02-comprendre-intelligence-artificielle-generative/02-phases-entrainement-llm.md) | 19 min | ✅ | 0 | 2026-08-23 |
| 03 | [Les LRM et l'effort](claude-code/02-comprendre-intelligence-artificielle-generative/03-lrm-et-effort.md) | 20 min | ✅ | 0 | 2026-08-23 |
| 04 | [Composition et gestion du contexte](claude-code/02-comprendre-intelligence-artificielle-generative/04-composition-gestion-contexte.md) | 13 min | ✅ | 0 | 2026-08-23 |
| 05 | [La spécificité Anthropic : la Constitution IA](claude-code/02-comprendre-intelligence-artificielle-generative/05-constitution-ia-anthropic.md) | 23 min | ✅ | 0 | 2026-08-23 |
| 06 | [L’économie des tokens et la facturation](claude-code/02-comprendre-intelligence-artificielle-generative/06-economie-tokens-facturation.md) | 15 min | ✅ | 0 | 2026-08-23 |

### 03 — Fonctionnalités, limites et bonnes pratiques

> 6/6 fiches · 98 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Les gammes de modèles et leurs performances](claude-code/03-fonctionnalites-limites-bonnes-pratiques/01-gammes-modeles-performance.md) | 18 min | ✅ | 0 | 2026-08-23 |
| 02 | [Les limites des LLM](claude-code/03-fonctionnalites-limites-bonnes-pratiques/02-limites-llm.md) | 18 min | ✅ | 0 | 2026-08-23 |
| 03 | [Les bonnes pratiques d'utilisation des LLM](claude-code/03-fonctionnalites-limites-bonnes-pratiques/03-bonnes-pratiques-utilisation-llm.md) | 18 min | ✅ | 0 | 2026-08-23 |
| 04 | [Qu'est-ce qu'un outil ?](claude-code/03-fonctionnalites-limites-bonnes-pratiques/04-qu-est-ce-qu-un-outil.md) | 13 min | ✅ | 0 | 2026-08-23 |
| 05 | [Qu'est-ce qu'un agent ?](claude-code/03-fonctionnalites-limites-bonnes-pratiques/05-qu-est-ce-qu-un-agent.md) | 12 min | ✅ | 0 | 2026-08-23 |
| 06 | [Pourquoi le code est un cas à part pour les LLM](claude-code/03-fonctionnalites-limites-bonnes-pratiques/06-code-cas-a-part-pour-llm.md) | 19 min | ✅ | 0 | 2026-08-23 |

### 04 — Installation et présentation des clients

> 5/5 fiches · 61 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Les différentes façons d’utiliser Claude](claude-code/04-installation-presentation-clients/01-differentes-facons-utiliser-claude.md) | 14 min | ✅ | 0 | 2026-08-23 |
| 02 | [Installation et présentation du CLI](claude-code/04-installation-presentation-clients/02-installation-presentation-cli.md) | 16 min | ✅ | 0 | 2026-08-23 |
| 03 | [Installation et présentation de l’application Desktop](claude-code/04-installation-presentation-clients/03-installation-presentation-desktop.md) | 9 min | ✅ | 0 | 2026-08-23 |
| 04 | [Installation et présentation de l’extension VS Code](claude-code/04-installation-presentation-clients/04-installation-presentation-extension-vscode.md) | 7 min | ✅ | 0 | 2026-08-23 |
| 05 | [Exécution locale, remote et cloud et présentation de claude.ai/code](claude-code/04-installation-presentation-clients/05-execution-locale-remote-cloud-claude-ai-code.md) | 15 min | ✅ | 0 | 2026-08-23 |

### 05 — Fonctionnement des agents de code et de Claude Code

> 5/5 fiches · 88 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [La boucle agentique de Claude Code](claude-code/05-fonctionnement-agents-code-claude-code/01-boucle-agentique-claude-code.md) | 23 min | ✅ | 0 | — |
| 02 | [Les outils de Claude Code](claude-code/05-fonctionnement-agents-code-claude-code/02-outils-claude-code.md) | 18 min | ✅ | 0 | — |
| 03 | [Étendre les capacités de Claude Code](claude-code/05-fonctionnement-agents-code-claude-code/03-etendre-capacites-claude-code.md) | 16 min | ✅ | 0 | — |
| 04 | [Rôle, importance et bonnes pratiques des prompts](claude-code/05-fonctionnement-agents-code-claude-code/04-role-importance-bonnes-pratiques-prompts.md) | 16 min | ✅ | 0 | — |
| 05 | [Ce que Claude Code peut voir](claude-code/05-fonctionnement-agents-code-claude-code/05-ce-que-claude-code-peut-voir.md) | 15 min | ✅ | 0 | — |

### 06 — Découverte et premières commandes du CLI

> 7/7 fiches · 98 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Entrer dans le CLI et vérifier que la session est saine](claude-code/06-decouverte-premieres-commandes-cli/01-entrer-cli-verifier-session.md) | 22 min | ✅ | 1 | 2026-08-22 |
| 02 | [Mise en place de la dictée vocale](claude-code/06-decouverte-premieres-commandes-cli/02-mise-en-place-dictee-vocale.md) | 15 min | ✅ | 1 | 2026-08-22 |
| 03 | [Formuler les premières demandes : exploration vague et demande précise](claude-code/06-decouverte-premieres-commandes-cli/03-premieres-demandes-exploration-vague-demande-precise.md) | 17 min | ✅ | 1 | 2026-08-22 |
| 04 | [Première modification de code et boucle de vérification](claude-code/06-decouverte-premieres-commandes-cli/04-premiere-modification-code-boucle-verification.md) | 20 min | ✅ | 1 | 2026-08-22 |
| 05 | [Continuer la session dans les bons environnements](claude-code/06-decouverte-premieres-commandes-cli/05-continuer-session-bons-environnements.md) | 18 min | ✅ | 0 | — |
| 06 | [Veille, feedback, compte et premières commandes personnalisées](claude-code/06-decouverte-premieres-commandes-cli/06-veille-feedback-compte-commandes-personnalisees.md) | 6 min | ✅ | 0 | — |
| 07 | [Glossaire et carte mentale des commandes](claude-code/06-decouverte-premieres-commandes-cli/07-glossaire-carte-mentale-commandes.md) | — | ✅ | 0 | — |

### 07 — Raccourcis clavier et optimisations du CLI

> 4/4 fiches · 56 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Les raccourcis clavier généraux](claude-code/07-raccourcis-clavier-optimisations-cli/01-raccourcis-clavier-generaux.md) | 18 min | ✅ | 0 | — |
| 02 | [Activer le rendu plein écran, réduire le scintillement et utiliser /focus](claude-code/07-raccourcis-clavier-optimisations-cli/02-rendu-plein-ecran-scintillement-focus.md) | 18 min | ✅ | 0 | — |
| 03 | [Comprendre la recherche en mode TUI](claude-code/07-raccourcis-clavier-optimisations-cli/03-recherche-transcription-tui.md) | 15 min | ✅ | 0 | — |
| 04 | [Les raccourcis clavier pour l’édition du prompt](claude-code/07-raccourcis-clavier-optimisations-cli/04-raccourcis-edition-prompt.md) | 5 min | ✅ | 0 | — |

### 08 — Personnalisation et configuration de l'interface

> 0/6 fiches · 78 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Portée de la configuration](claude-code/08-personnalisation-configuration-interface/01-portee-configuration.md) | 13 min | ⬜ | 0 | — |
| 02 | [Liste des configurations — partie 1](claude-code/08-personnalisation-configuration-interface/02-liste-configurations-partie-1.md) | 17 min | ⬜ | 0 | — |
| 03 | [Liste des configurations — partie 2](claude-code/08-personnalisation-configuration-interface/03-liste-configurations-partie-2.md) | 19 min | ⬜ | 0 | — |
| 04 | [Configurer le terminal, le thème, les notifications et les retours à la ligne](claude-code/08-personnalisation-configuration-interface/04-terminal-theme-notifications-retours-ligne.md) | 9 min | ⬜ | 0 | — |
| 05 | [Construire une barre de statut utile et différencier les sessions](claude-code/08-personnalisation-configuration-interface/05-barre-statut-differencier-sessions.md) | 12 min | ⬜ | 0 | — |
| 06 | [Adapter les raccourcis clavier](claude-code/08-personnalisation-configuration-interface/06-adapter-raccourcis-clavier.md) | 8 min | ⬜ | 0 | — |

### 09 — Gestion des sessions et du contexte

> 0/5 fiches · 58 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre les sources de contexte dans Claude Code](claude-code/09-gestion-sessions-contexte/01-sources-contexte-claude-code.md) | 15 min | ⬜ | 0 | — |
| 02 | [Nettoyer, compacter ou repartir sur une nouvelle tâche](claude-code/09-gestion-sessions-contexte/02-nettoyer-compacter-nouvelle-tache.md) | 14 min | ⬜ | 0 | — |
| 03 | [Reprendre, continuer et renommer les sessions](claude-code/09-gestion-sessions-contexte/03-reprendre-continuer-renommer-sessions.md) | 9 min | ⬜ | 0 | — |
| 04 | [Brancher une session pour tester une variante](claude-code/09-gestion-sessions-contexte/04-brancher-session-tester-variante.md) | 7 min | ⬜ | 0 | — |
| 05 | [Interrompre tôt et rembobiner avec les checkpoints](claude-code/09-gestion-sessions-contexte/05-interrompre-rembobiner-checkpoints.md) | 13 min | ⬜ | 0 | — |

### 10 — Modèles, coûts et usage

> 0/5 fiches · 43 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Choisir le modèle](claude-code/10-modeles-couts-usage/01-choisir-modele.md) | 15 min | ⬜ | 0 | — |
| 02 | [Régler l’effort, ultrathink et ultracode](claude-code/10-modeles-couts-usage/02-regler-effort-ultrathink-ultracode.md) | 6 min | ⬜ | 0 | — |
| 03 | [Accélérer les tâches simples](claude-code/10-modeles-couts-usage/03-accelerer-taches-simples.md) | 5 min | ⬜ | 0 | — |
| 04 | [Suivre les coûts, les limites et les statistiques](claude-code/10-modeles-couts-usage/04-suivre-couts-limites-statistiques.md) | 7 min | ⬜ | 0 | — |
| 05 | [Maîtriser les coûts dans les workflows longs](claude-code/10-modeles-couts-usage/05-maitriser-couts-workflows-longs.md) | 10 min | ⬜ | 0 | — |

### 11 — Permissions, contrôle et sécurité

> 0/7 fiches · 91 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre le modèle de permissions allow, ask, deny](claude-code/11-permissions-controle-securite/01-modele-permissions-allow-ask-deny.md) | 14 min | ⬜ | 0 | — |
| 02 | [Choisir un mode de permission](claude-code/11-permissions-controle-securite/02-choisir-mode-permission.md) | 18 min | ⬜ | 0 | — |
| 03 | [Configurer les règles avec /permissions et les fichiers settings](claude-code/11-permissions-controle-securite/03-configurer-regles-permissions-settings.md) | 16 min | ⬜ | 0 | — |
| 04 | [Isoler l’exécution avec /sandbox, Docker, devcontainers et données fictives](claude-code/11-permissions-controle-securite/04-isoler-execution-sandbox-docker-devcontainers.md) | 18 min | ⬜ | 0 | — |
| 05 | [Contrôler les répertoires de travail et les chemins protégés](claude-code/11-permissions-controle-securite/05-controler-repertoires-chemins-proteges.md) | 7 min | ⬜ | 0 | — |
| 06 | [Cadrer les sessions non interactives et les intégrations MCP](claude-code/11-permissions-controle-securite/06-sessions-non-interactives-integrations-mcp.md) | 9 min | ⬜ | 0 | — |
| 07 | [Transformer les habitudes en politiques avec hooks, settings et allowlists](claude-code/11-permissions-controle-securite/07-habitudes-politiques-hooks-settings-allowlists.md) | 9 min | ⬜ | 0 | — |

### 12 — Mémoire, CLAUDE.md et auto-mémoire

> 0/6 fiches · 82 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre CLAUDE.md : la mémoire de projet et les instructions persistantes](claude-code/12-memoire-claude-md-auto-memoire/01-comprendre-claude-md-memoire-projet.md) | 17 min | ⬜ | 0 | — |
| 02 | [Initialiser, rédiger et faire évoluer CLAUDE.md avec /init](claude-code/12-memoire-claude-md-auto-memoire/02-initialiser-rediger-faire-evoluer-claude-md.md) | 10 min | ⬜ | 0 | — |
| 03 | [Choisir le bon emplacement pour chaque mémoire](claude-code/12-memoire-claude-md-auto-memoire/03-choisir-emplacement-memoire.md) | 13 min | ⬜ | 0 | — |
| 04 | [Structurer les instructions avec .claude/rules/ et les imports @path](claude-code/12-memoire-claude-md-auto-memoire/04-structurer-instructions-rules-imports.md) | 25 min | ⬜ | 0 | — |
| 05 | [Auditer, nettoyer et maîtriser l’auto-mémoire avec /memory](claude-code/12-memoire-claude-md-auto-memoire/05-auditer-nettoyer-auto-memoire.md) | 9 min | ⬜ | 0 | — |
| 06 | [Capitaliser les retours d’expérience : transformer les corrections en mémoire durable](claude-code/12-memoire-claude-md-auto-memoire/06-transformer-corrections-memoire-durable.md) | 8 min | ⬜ | 0 | — |

### 13 — Projet (partie 1) — Démarrage du projet

> 0/9 fiches · 171 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Workflow de création de projet à l’ère de l’IA](claude-code/13-projet-partie-1-demarrage-projet/01-workflow-creation-projet-ere-ia.md) | 30 min | ⬜ | 0 | — |
| 02 | [Cadrer l’idée, la stack et l’architecture avec Claude Code](claude-code/13-projet-partie-1-demarrage-projet/02-cadrer-idee-stack-architecture-design-doc.md) | 32 min | ⬜ | 0 | — |
| 03 | [Créer le projet depuis zéro et obtenir une base vérifiable](claude-code/13-projet-partie-1-demarrage-projet/03-creer-projet-base-verifiable.md) | 18 min | ⬜ | 0 | — |
| 04 | [Comprendre le dépôt avant de modifier](claude-code/13-projet-partie-1-demarrage-projet/04-comprendre-depot-avant-modifier.md) | 16 min | ⬜ | 0 | — |
| 05 | [Cadrer la mémoire projet avec CLAUDE.md et .claude/rules/](claude-code/13-projet-partie-1-demarrage-projet/05-cadrer-memoire-projet-claude-md-rules.md) | 20 min | ⬜ | 0 | — |
| 06 | [Cadrer les permissions et la surface d’action](claude-code/13-projet-partie-1-demarrage-projet/06-cadrer-permissions-surface-action.md) | 17 min | ⬜ | 0 | — |
| 07 | [Planifier par phases avec des gates vérifiables](claude-code/13-projet-partie-1-demarrage-projet/07-planifier-phases-gates-verifiables.md) | 26 min | ⬜ | 0 | — |
| 08 | [Implémenter sous contrôle et fermer chaque gate](claude-code/13-projet-partie-1-demarrage-projet/08-implementer-fermer-chaque-gate.md) | 6 min | ⬜ | 0 | — |
| 09 | [Vérifier, récupérer et capitaliser](claude-code/13-projet-partie-1-demarrage-projet/09-verifier-recuperer-capitaliser.md) | 6 min | ⬜ | 0 | — |

### 14 — Compétences (Skills)

> 0/6 fiches · 97 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Situer les skills dans l’écosystème Claude Code](claude-code/14-competences-skills/01-situer-skills-ecosysteme-claude-code.md) | 14 min | ⬜ | 0 | — |
| 02 | [Présentation des skills embarqués](claude-code/14-competences-skills/02-presentation-skills-embarques.md) | 18 min | ⬜ | 0 | — |
| 03 | [Présentation de /simplify et /code-review](claude-code/14-competences-skills/03-presentation-simplify-code-review.md) | 19 min | ⬜ | 0 | — |
| 04 | [Analyse d’un skill personnalisé](claude-code/14-competences-skills/04-analyse-skill-personnalise.md) | 18 min | ⬜ | 0 | — |
| 05 | [Les différentes catégories de skills et les bonnes pratiques](claude-code/14-competences-skills/05-categories-skills-bonnes-pratiques.md) | 11 min | ⬜ | 0 | — |
| 06 | [Installer des skills et présentation de skills.sh](claude-code/14-competences-skills/06-installer-skills-skills-sh.md) | 17 min | ⬜ | 0 | — |

### 15 — MCP — Connecter Claude Code à des outils

> 0/6 fiches · 78 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre MCP dans Claude Code](claude-code/15-mcp-connecter-claude-code-outils/01-comprendre-mcp-claude-code.md) | 17 min | ⬜ | 0 | — |
| 02 | [Panorama des MCP courants et critères de choix](claude-code/15-mcp-connecter-claude-code-outils/02-panorama-mcp-criteres-choix.md) | 14 min | ⬜ | 0 | — |
| 03 | [Installer et gérer un premier serveur MCP](claude-code/15-mcp-connecter-claude-code-outils/03-installer-gerer-premier-serveur-mcp.md) | 13 min | ⬜ | 0 | — |
| 04 | [Tester le convertisseur avec Playwright MCP](claude-code/15-mcp-connecter-claude-code-outils/04-tester-convertisseur-playwright-mcp.md) | 11 min | ⬜ | 0 | — |
| 05 | [Connecter le dépôt avec GitHub MCP](claude-code/15-mcp-connecter-claude-code-outils/05-connecter-depot-github-mcp.md) | 11 min | ⬜ | 0 | — |
| 06 | [Configurer et sécuriser les MCP du projet](claude-code/15-mcp-connecter-claude-code-outils/06-configurer-securiser-mcp-projet.md) | 12 min | ⬜ | 0 | — |

### 16 — Projet (partie 2) — Skills et MCP

> 0/5 fiches · 77 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Présentation des fonctionnalités et mise en place du serveur MCP GitHub](claude-code/16-projet-partie-2-skills-mcp/01-fonctionnalites-serveur-mcp-github.md) | 15 min | ⬜ | 0 | — |
| 02 | [Création d’un skill permettant de créer des règles](claude-code/16-projet-partie-2-skills-mcp/02-creer-skill-creation-regles.md) | 21 min | ⬜ | 0 | — |
| 03 | [Création d’une nouvelle règle avec le skill new-rule](claude-code/16-projet-partie-2-skills-mcp/03-creer-regle-skill-new-rule.md) | 11 min | ⬜ | 0 | — |
| 04 | [Création d’une seconde règle](claude-code/16-projet-partie-2-skills-mcp/04-creer-seconde-regle.md) | 15 min | ⬜ | 0 | — |
| 05 | [Nouvelle fonctionnalité : scan d’un dépôt GitHub](claude-code/16-projet-partie-2-skills-mcp/05-scan-depot-github.md) | 15 min | ⬜ | 0 | — |

### 17 — Travail parallèle, sous-agents et équipes

> 0/8 fiches · 90 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Introduction au travail en parallèle](claude-code/17-travail-parallele-sous-agents-equipes/01-introduction-travail-parallele.md) | 12 min | ⬜ | 0 | — |
| 02 | [Fonctionnement des worktrees](claude-code/17-travail-parallele-sous-agents-equipes/02-fonctionnement-worktrees.md) | 14 min | ⬜ | 0 | — |
| 03 | [Sessions en parallèle et agent view](claude-code/17-travail-parallele-sous-agents-equipes/03-sessions-parallele-agent-view.md) | 13 min | ⬜ | 0 | — |
| 04 | [Présentation des commandes /advisor et /fork](claude-code/17-travail-parallele-sous-agents-equipes/04-commandes-advisor-fork.md) | 6 min | ⬜ | 0 | — |
| 05 | [Créer des profils d’agents](claude-code/17-travail-parallele-sous-agents-equipes/05-creer-profils-agents.md) | 16 min | ⬜ | 0 | — |
| 06 | [Utiliser un sous-agent](claude-code/17-travail-parallele-sous-agents-equipes/06-utiliser-sous-agent.md) | 11 min | ⬜ | 0 | — |
| 07 | [Les équipes d’agents](claude-code/17-travail-parallele-sous-agents-equipes/07-equipes-agents.md) | 11 min | ⬜ | 0 | — |
| 08 | [Équipe d’agents en pratique](claude-code/17-travail-parallele-sous-agents-equipes/08-equipe-agents-pratique.md) | 7 min | ⬜ | 0 | — |

### 18 — Boucles autonomes et planification

> 0/7 fiches · 76 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre les boucles autonomes](claude-code/18-boucles-autonomes-planification/01-comprendre-boucles-autonomes.md) | 11 min | ⬜ | 0 | — |
| 02 | [Piloter une boucle avec /goal](claude-code/18-boucles-autonomes-planification/02-piloter-boucle-goal.md) | 12 min | ⬜ | 0 | — |
| 03 | [Réexécuter un prompt avec /loop](claude-code/18-boucles-autonomes-planification/03-reexecuter-prompt-loop.md) | 15 min | ⬜ | 0 | — |
| 04 | [Planifier durablement avec /schedule et les routines](claude-code/18-boucles-autonomes-planification/04-planifier-schedule-routines.md) | 15 min | ⬜ | 0 | — |
| 05 | [Exemple d’utilisation des routines](claude-code/18-boucles-autonomes-planification/05-exemple-utilisation-routines.md) | 6 min | ⬜ | 0 | — |
| 06 | [Composer une boucle proactive](claude-code/18-boucles-autonomes-planification/06-composer-boucle-proactive.md) | 13 min | ⬜ | 0 | — |
| 07 | [Borner, observer et améliorer une boucle](claude-code/18-boucles-autonomes-planification/07-borner-observer-ameliorer-boucle.md) | 4 min | ⬜ | 0 | — |

### 19 — Workflows dynamiques

> 0/4 fiches · 90 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Comprendre les workflows dynamiques et choisir quand les utiliser](claude-code/19-workflows-dynamiques/01-comprendre-workflows-dynamiques.md) | 28 min | ⬜ | 0 | — |
| 02 | [Lancer un premier workflow avec /deep-research](claude-code/19-workflows-dynamiques/02-premier-workflow-deep-research.md) | 16 min | ⬜ | 0 | — |
| 03 | [Présentation de la commande /workflows et de l’interface](claude-code/19-workflows-dynamiques/03-commande-workflows-interface.md) | 20 min | ⬜ | 0 | — |
| 04 | [Créer un workflow personnalisé](claude-code/19-workflows-dynamiques/04-creer-workflow-personnalise.md) | 26 min | ⬜ | 0 | — |

### 20 — GitHub et Claude Code — Connexions et sessions cloud

> 0/4 fiches · 28 min

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Présentation des intégrations GitHub avec Claude Code](claude-code/20-github-claude-code-connexions-sessions-cloud/01-integrations-github-claude-code.md) | 28 min | ⬜ | 0 | — |
| 02 | [Installation de GitHub CLI (gh) et connexion OAuth](claude-code/20-github-claude-code-connexions-sessions-cloud/02-installation-github-cli-connexion-oauth.md) | — | ⬜ | 0 | — |
| 03 | [Lancement d’une session cloud](claude-code/20-github-claude-code-connexions-sessions-cloud/03-lancement-session-cloud.md) | — | ⬜ | 0 | — |
| 04 | [Code review dans le cloud](claude-code/20-github-claude-code-connexions-sessions-cloud/04-code-review-cloud.md) | — | ⬜ | 0 | — |

### 21 — GitHub et Claude Code — CI/CD et fonctionnalités natives

> 0/4 fiches

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [L’application GitHub de Claude](claude-code/21-github-claude-code-ci-cd-fonctionnalites-natives/01-application-github-claude.md) | — | ⬜ | 0 | — |
| 02 | [Surveiller et corriger une pull request avec /autofix-pr](claude-code/21-github-claude-code-ci-cd-fonctionnalites-natives/02-surveiller-corriger-pull-request-autofix-pr.md) | — | ⬜ | 0 | — |
| 03 | [GitHub Actions avec @claude](claude-code/21-github-claude-code-ci-cd-fonctionnalites-natives/03-github-actions-avec-claude.md) | — | ⬜ | 0 | — |
| 04 | [Mise en place d’une routine cloud](claude-code/21-github-claude-code-ci-cd-fonctionnalites-natives/04-mise-en-place-routine-cloud.md) | — | ⬜ | 0 | — |

### 22 — Hooks

> 0/4 fiches

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Présentation des hooks](claude-code/22-hooks/01-presentation-hooks.md) | — | ⬜ | 0 | — |
| 02 | [Mise en place d’un hook de type command](claude-code/22-hooks/02-hook-type-command.md) | — | ⬜ | 0 | — |
| 03 | [Utilisation d’un hook avec une requête HTTP](claude-code/22-hooks/03-hook-requete-http.md) | — | ⬜ | 0 | — |
| 04 | [Utilisation d’un prompt et d’un agent dans un hook](claude-code/22-hooks/04-prompt-agent-hook.md) | — | ⬜ | 0 | — |

### 23 — Plugins

> 0/4 fiches

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Qu’est-ce qu’un plugin ?](claude-code/23-plugins/01-qu-est-ce-qu-un-plugin.md) | — | ⬜ | 0 | — |
| 02 | [Les commandes dédiées aux plugins](claude-code/23-plugins/02-commandes-dediees-plugins.md) | — | ⬜ | 0 | — |
| 03 | [Installation d’un plugin](claude-code/23-plugins/03-installation-plugin.md) | — | ⬜ | 0 | — |
| 04 | [Création d’un plugin et d’une marketplace](claude-code/23-plugins/04-creation-plugin-marketplace.md) | — | ⬜ | 0 | — |

### 24 — Sécurité et revue de code

> 0/4 fiches

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Outils de sécurité de Claude Code](claude-code/24-securite-revue-code/01-outils-securite-claude-code.md) | — | ⬜ | 0 | — |
| 02 | [Plugin security-guidance](claude-code/24-securite-revue-code/02-plugin-security-guidance.md) | — | ⬜ | 0 | — |
| 03 | [Plugin claude-security](claude-code/24-securite-revue-code/03-plugin-claude-security.md) | — | ⬜ | 0 | — |
| 04 | [Vérifier la sécurité d’un diff non mergé avec /security-review](claude-code/24-securite-revue-code/04-verifier-securite-diff-non-merge.md) | — | ⬜ | 0 | — |

### 25 — Artefacts

> 0/3 fiches

| | Leçon | Durée | Fiche | Étape | Prochaine révision |
|---|---|---|---|---|---|
| 01 | [Présentation des artéfacts](claude-code/25-artefacts/01-presentation-artefacts.md) | — | ⬜ | 0 | — |
| 02 | [Création de trois artéfacts](claude-code/25-artefacts/02-creation-trois-artefacts.md) | — | ⬜ | 0 | — |
| 03 | [Gestion des artéfacts](claude-code/25-artefacts/03-gestion-artefacts.md) | — | ⬜ | 0 | — |

---

⚠️ = révision en retard au 2026-08-22.

*Notes personnelles. Le contenu du cours appartient à [Dyma](https://dyma.fr).*
