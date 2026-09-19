---
title: "Socle Claude Code — chapitres 01 à 12"
description: "Référence transversale : toutes les grandes notions des chapitres 1 à 12, regroupées par thème pour une révision rapide et une recherche ciblée."
date: 2026-09-19
draft: true
tags:
  - claude-code
  - synthese
  - reference
  - revision
categories:
  - "Transversal"
cours: Claude Code
chapitre: transversal
leçon: revision-socle-01-12
statut: référence
etape_revision: 0
prochaine_revision:
---

# Socle Claude Code — chapitres 01 à 12

## À quoi sert cette fiche

Cette fiche n'est pas une leçon : c'est la **synthèse transversale** des 63 fiches rédigées des chapitres 01 à 12. Elle sert à deux usages :

- **Réviser large** — relire les fils rouges et les idées maîtresses avant une session de travail, sans rouvrir douze fichiers.
- **Retrouver vite** — chercher une notion ou une commande (`Ctrl+F`) quand on ne se souvient plus de quel chapitre elle vient.

Elle ne remplace pas les fiches : elle ne contient ni schémas ASCII, ni questions d'auto-évaluation, ni détail d'exécution. En cas de doute sur une notion, c'est la fiche de la leçon qui fait foi.

Version interactive (filtre + mode révision) : <https://claude.ai/artifact/22DyCuV2Qxqc5AQEwPPQj7>

---

## Les 7 fils rouges

Les idées qui traversent plusieurs chapitres. Si on ne devait retenir que sept choses, ce serait celles-là.

| # | Fil rouge | Ce que ça veut dire | Chapitres |
|---|---|---|---|
| 1 | **Le modèle propose, le harness exécute** | Claude n'écrit jamais un fichier lui-même : il émet une demande d'outil. Le harness, les permissions et le sandbox décident de ce qui se produit réellement. | 03, 05, 11 |
| 2 | **Le contexte est un budget, pas une mémoire** | Tout ce qui entre dans la fenêtre est refacturé à chaque tour et dilue l'attention. Le nettoyer est un geste de qualité autant que de coût. | 02, 09, 10, 12 |
| 3 | **Une instruction n'est pas une barrière** | `CLAUDE.md` oriente le raisonnement ; seul le système de permissions bloque. Confondre les deux, c'est croire être protégé. | 11, 12 |
| 4 | **Rien n'est terminé sans preuve** | Un résumé plausible n'est pas un résumé vrai. Diff lu soi-même, tests exécutés, et mention explicite de ce qui n'a *pas* été vérifié. | 03, 06 |
| 5 | **Un réglage est d'abord une question de portée** | Avant « quelle option ? », la vraie question est « qui est concerné, et est-ce que ça doit pouvoir être contourné ? ». | 08, 11, 12 |
| 6 | **Capacité ≠ profondeur** | Le modèle fixe ce dont Claude est capable, l'effort fixe combien il y réfléchit. Deux réglages distincts, deux coûts distincts. | 03, 10 |
| 7 | **Git reste la seule source de vérité** | Checkpoints, `/rewind` et `/branch` protègent la conversation, pas le disque. Annuler via Git n'est pas un échec. | 06, 09 |

---

## 01 — Introduction à Anthropic et Claude Code

> 4 leçons · 38 min

**Idée maîtresse.** Anthropic naît en 2021 d'une scission avec OpenAI sur les priorités d'alignement. Statut de **Public Benefit Corporation**, positionnement B2B, et une signature technique : la **Constitutional AI**. Claude Code est l'aboutissement d'une expérimentation — faire passer Claude du chat à l'action, directement dans le terminal.

### Anthropic

| Notion | À retenir |
|---|---|
| Constitutional AI | Entraînement où le modèle auto-évalue et corrige ses réponses selon une constitution de principes explicites. |
| PBC (Public Benefit Corporation) | Statut juridique américain imposant de concilier profit et mission d'intérêt public. |
| Orientabilité | Capacité du modèle à respecter strictement consignes, règles métier et limites définies par l'utilisateur. |
| Zero Data Retention | Engagement contractuel : les données de l'API ne sont ni stockées ni réutilisées pour le ré-entraînement. |

### L'écosystème

| Notion | À retenir |
|---|---|
| Les 3 strates | Les **modèles** (Opus, Sonnet, Haiku) alimentent les **produits** (Claude, Code, Cowork, Design, Security), qui s'étendent via Skills, MCP et plugins. |
| MCP (Model Context Protocol) | Protocole ouvert d'Anthropic connectant les modèles à des outils et bases de données locales ou cloud. |
| Skill | Instruction technique ou procédure réutilisable enseignée à l'agent. |
| Plugin | Bundle complet combinant plusieurs Skills et connecteurs métier prêts à l'emploi. |
| GA (General Availability) | Statut de maturité indiquant qu'un logiciel est stable pour la production. |

### Claude Code

| Notion | À retenir |
|---|---|
| Action agentique | Planifier des étapes, utiliser des outils locaux (compilateur, git, tests) et corriger ses propres erreurs. |
| Limited Research Preview | Phase de test public restreinte — celle de Claude Code, en février 2025. |
| Sandbox | Environnement d'exécution isolé empêchant l'agent d'agir destructivement sur la machine hôte. |

---

## 02 — Comprendre l'intelligence artificielle générative

> 6 leçons · 111 min

**Idée maîtresse.** Un LLM ne pense pas : c'est un **prédicteur statistique de tokens**. Il vectorise, calcule des relations par attention, et tire le mot suivant le plus probable. Tout le reste — entraînement, raisonnement, contexte, facturation — découle de cette mécanique.

### Comment un LLM génère

| Notion | À retenir |
|---|---|
| Embedding | Vectorisation mathématique représentant le sens d'un token dans un espace multidimensionnel. |
| Positional Encoding | Injection de l'ordre et de la position des mots dans les vecteurs d'embeddings. |
| Logits | Scores numériques bruts produits pour chaque token du vocabulaire, avant conversion probabiliste. |
| Softmax | Fonction convertissant les logits en distribution de probabilités dont la somme vaut 100 %. |
| Sampling | Tirage du token suivant dans cette distribution — la source de la variabilité des réponses. |

### Les phases d'entraînement

| Notion | À retenir |
|---|---|
| Pretraining | Apprentissage brut de la prédiction du mot suivant sur des données nettoyées et dédupliquées. |
| SFT (Supervised Fine-Tuning) | Étape supervisée qui apprend au modèle à se comporter en assistant obéissant aux instructions. |
| Alignement (RLHF / DPO) | Ajustement sur les préférences humaines, après le SFT. |
| Backpropagation | Calcul rétrograde de l'erreur identifiant les poids à ajuster dans le réseau. |
| Gradient Descent | Algorithme réduisant progressivement la fonction de perte (loss). |
| Inférence | Phase d'utilisation : les poids sont **figés**, le modèle n'apprend plus. |

### Les LRM et l'effort

| Notion | À retenir |
|---|---|
| LRM (Large Reasoning Model) | Modèle spécialisé dans la délibération et le raisonnement pas-à-pas. |
| Test-time compute | Temps et puissance de calcul consacrés à la réflexion **au moment** de la requête. |
| PRM (Process Reward Model) | Système récompensant chaque étape intermédiaire valide d'un raisonnement, pas seulement la réponse finale. |
| Backtracking | Abandonner une piste logique infructueuse et revenir à une étape antérieure. |

### Le contexte

| Notion | À retenir |
|---|---|
| Fenêtre de contexte | La mémoire de travail (la « RAM ») du modèle : capacité maximale en tokens lus et écrits en une fois. |
| Taux utile | Remplissage réel du contexte, **réponse estimée incluse**. |
| Saturation | Dilution de l'attention, latence accrue et surcoût — les trois symptômes d'un contexte trop plein. |
| Compaction | Résumer l'historique de session pour libérer des tokens. |
| RAG (Retrieval-Augmented Generation) | Injection dynamique des seuls passages de documents pertinents. |

### La Constitution IA

| Notion | À retenir |
|---|---|
| RLAIF | Apprentissage par renforcement où c'est un modèle d'IA, et non un humain, qui attribue les récompenses d'alignement. |
| Hiérarchie 2026 | Quatre niveaux stricts : **Sûreté > Éthique > Conformité > Utilité**. |
| Hard constraints | Interdictions absolues, non contournables, inscrites dans le noyau de sécurité. |
| Sycophantie | Tendance à donner raison à l'utilisateur même quand il a tort — explicitement combattue. |

### L'économie des tokens

| Notion | À retenir |
|---|---|
| Input vs Output | L'output est nettement plus cher : il exige un calcul de génération pas-à-pas, token par token. |
| Prompt Caching | Mise en cache serveur d'un segment stable du prompt : **jusqu'à −90 %** sur l'entrée répétée. |
| Batch Processing | Traitements de masse asynchrones sous 24 h : **−50 %**. |

---

## 03 — Fonctionnalités, limites et bonnes pratiques

> 6 leçons · 98 min

**Idée maîtresse.** Choisir un modèle est un arbitrage **qualité / latence / coût**. Un LLM produit du texte plausible, pas de la vérité — d'où des prompts denses, des outils pour sortir du texte, une boucle agentique pour agir, et le code comme terrain privilégié parce qu'il est vérifiable de façon déterministe.

### Les gammes de modèles

| Notion | À retenir |
|---|---|
| Haiku | Rapide et économique — tâches simples, volume. |
| Sonnet | L'étalon-or du développement et de Claude Code. |
| Opus | Raisonnement complexe, architecture, analyse profonde. |
| Dense vs MoE | Dense : 100 % des paramètres sollicités par token. MoE : seule une fraction (les « experts ») s'active. |
| Paramètre (weight) | Coefficient ajusté à l'entraînement, où se stockent les connaissances du modèle. |

### Les limites

| Notion | À retenir |
|---|---|
| Hallucination | Information fausse ou inventée, générée avec assurance. |
| Knowledge cutoff | Date de gel des données d'entraînement — tout ce qui suit est inconnu du modèle. |
| Sycophantie | Approuver les choix de l'utilisateur même lorsqu'ils sont erronés. |
| Validation humaine | Contrôle systématique des sorties par un expert métier. Non négociable. |

### Bonnes pratiques de prompt

| Notion | À retenir |
|---|---|
| Prompt universel | La structure standard : **Contexte + Tâche + Contraintes + Format**. |
| Densité informationnelle | Un maximum de consignes claires par token — chaque mot compte, aucun bruit. |
| Few-shot prompting | Insérer un ou deux exemples de sorties modèles dans le prompt. |
| Chaînage de prompts | Découper un processus complexe en une suite d'instructions, une tâche unique par étape. |

### Outils et agents

| Notion | À retenir |
|---|---|
| Function calling | Le modèle n'exécute rien : il émet une **intention d'appel en JSON** que l'hôte exécute avant de lui rendre le résultat. |
| JSON Schema | Description du nom et du type des paramètres qu'un outil exige. |
| Tool call / response | La paire de messages : l'intention émise par l'IA, la réponse brute de l'outil. |
| Boucle agentique | Plan → Action → Observation → Décision, jusqu'à l'objectif. |
| Critère d'arrêt | Garde-fou interrompant la boucle si l'objectif n'est pas atteint après un quota. |
| Human-in-the-loop | Point de validation humaine avant toute action critique. |
| RPA | Automatisation déterministe à règles Si/Alors — rigide, là où l'agent s'adapte. |

### Pourquoi le code

| Notion | À retenir |
|---|---|
| Vérifiabilité déterministe | Un test passe ou échoue : le code se valide en binaire, ce que le texte libre ne permet pas. |
| Feedback loop | L'agent capture l'erreur d'un linter ou d'un test et corrige lui-même son code. |
| Hallucination d'API | Une méthode ou signature fictive, plausible mais inexistante, qui échoue à l'exécution. |
| Idiomatique | Code conforme aux conventions et pratiques reconnues du langage. |

---

## 04 — Installation et présentation des clients

> 5 leçons · 61 min

**Idée maîtresse.** Une même intelligence, quatre surfaces et **trois topologies d'exécution**. Ce qui change n'est pas le modèle mais **où le code est modifié** : sur votre machine, piloté à distance sur votre machine, ou dans une sandbox cloud.

### Les trois topologies

| Notion | À retenir |
|---|---|
| Local | L'agent tourne sur votre machine : accès direct aux fichiers, au dépôt et aux serveurs MCP locaux. |
| Remote Control (`rc`) | La session **reste** sur votre PC, vous la pilotez depuis un navigateur ou un mobile. |
| Cloud (`--remote`) | Exécution autonome dans une sandbox isolée liée à GitHub. |
| `--teleport` | Rapatrie la branche Git et l'historique d'une session cloud vers le terminal local. |
| `claude.ai/code` | Interface web centralisée pour piloter les sessions distantes ou cloud. |

### Le CLI

| Notion | À retenir |
|---|---|
| Installation native | Binaire autonome via `curl` / `irm`, sans Node.js ni gestionnaire externe — mises à jour automatiques. |
| `claude doctor` | Diagnostic : santé de l'installation, réseau, clés API. |
| `claude -p` | Prompt passif : une requête unique en ligne de commande, qui se termine immédiatement. |

### Desktop et VS Code

| Notion | À retenir |
|---|---|
| Desktop | Unifie Chat, Cowork et Code. Windows et macOS — **pas de version Linux**. Onglets, diff graphique, sessions SSH. |
| Claude Cowork | Module d'exécution d'agents asynchrones dans le cloud pour les tâches de fond. |
| `Alt+K` / `Option+K` | Injecte le bloc de code sélectionné comme contexte dans le prompt (VS Code). |
| @-mention | Ciblage précis d'un extrait : `@fichier.ts#L10-L40`. |
| Checkpoint | Point de restauration local créé à chaque passe d'édition, sans polluer l'historique Git. |
| Diff inline / interactif | Relecture ligne à ligne des propositions de l'agent, éditable avant validation. |

---

## 05 — Fonctionnement des agents de code et de Claude Code

> 5 leçons · 88 min

**Idée maîtresse.** Le cœur de Claude Code : une **boucle** qui transforme une demande en trajectoire contrôlée. Le modèle décide, mais c'est le **harness** qui exécute — et chaque résultat revient dans la boucle pour confirmer, corriger ou arrêter.

### La boucle agentique

| Notion | À retenir |
|---|---|
| Agent Loop | La boucle centrale : décision → action → observation → nouvelle décision. |
| Harness | La couche d'orchestration qui transforme une sortie du modèle en opération système contrôlée. |
| Tour agentique | La trajectoire complète déclenchée par une demande utilisateur. |
| Itération | Un passage interne : préparation du contexte, appel du modèle, traitement de la sortie, observation. |
| Tool request | Demande structurée produite par le modèle pour solliciter un outil. |
| Observation | Le résultat externe renvoyé dans la boucle après une action — ou une tentative d'action refusée. |
| Context Assembly | L'assemblage des informations transmises au modèle pour la décision suivante. |
| Condition d'arrêt | Ce qui clôt, suspend ou interrompt la boucle. |

### Les outils

| Outil | Rôle |
|---|---|
| `Read` | Lire le contenu d'un fichier. |
| `Glob` | Rechercher des fichiers par motif de chemin. |
| `Grep` | Rechercher du contenu textuel dans les fichiers. |
| `LSP` | Comprendre symboles, types et références via un serveur de langage. |
| `Edit` / `Write` | Modification ciblée / création ou remplacement complet d'un fichier. |
| `Bash` | Exécuter une commande shell. |
| `WebSearch` / `WebFetch` | Chercher sur le web / récupérer le contenu d'une URL. |
| Pool d'outils | L'ensemble des outils **réellement** disponibles dans une session donnée. |

### Les 7 points d'extension

| Extension | Rôle |
|---|---|
| `CLAUDE.md` | Contexte persistant : instructions et informations de projet chargées au démarrage. |
| `.claude/rules/` | Règles appliquées à certaines zones ou certains fichiers du projet. |
| Skill | Procédure ou expertise réutilisable, chargée seulement lorsqu'elle est utile. |
| MCP | Accès externe : outils, données et services tiers. |
| Subagent | Agent secondaire à contexte propre, pour isoler une tâche déléguée. |
| Agent team | Plusieurs sessions agentiques travaillant et se coordonnant en parallèle. |
| Hook | Action déclenchée automatiquement sur un événement du cycle de vie — **déterministe**. |
| Plugin / marketplace | Unité installable regroupant plusieurs extensions, et son canal de distribution. |

### Les prompts

| Notion | À retenir |
|---|---|
| Le bon prompt | Il décrit le **résultat attendu**, le périmètre, les contraintes et la vérification — pas chaque geste de l'agent. |
| Micro-direction | Imposer trop précisément les étapes internes : le principal anti-pattern. |
| Contexte source | Fichiers, logs, captures, tickets fournis comme références. |
| Condition d'arrêt | Le critère qui permet de considérer la tâche comme réellement terminée. |

### Ce que Claude peut voir

| Notion | À retenir |
|---|---|
| Espace de travail | Claude ne charge **pas** tout le projet : il construit sa compréhension à partir de ce qu'il consulte réellement. |
| `/add-dir` / `--add-dir` | Ajouter un dossier supplémentaire à la session (en cours, ou au lancement). |
| `/cd` | Changer le dossier principal de la session. |
| Worktree | Espace Git séparé permettant de travailler sur une autre branche en parallèle. |

---

## 06 — Découverte et premières commandes CLI

> 7 leçons

**Idée maîtresse.** Avant de laisser Claude toucher au projet, prouver que le projet **fonctionne seul** (tests + build) et que la session est saine. Puis : lecture seule d'abord, plan ensuite, écriture en dernier — et jamais de validation sans preuve.

### Session et compte

| Commande | Rôle |
|---|---|
| `/login` · `/logout` | Connexion / déconnexion du compte. Ne touchent jamais au projet. |
| `/status` | État de la session : version, compte, modèle, connectivité. |
| `/doctor` | Diagnostic installation, paramètres, connectivité. **Le réflexe n°1** avant de retoucher un prompt. |
| `/help` | L'aide de la session réelle — liste évolutive, jamais figée. |
| `/powerup` | Parcours interactif de découverte des capacités. |
| `claude update` · `claude --version` | Mise à jour et version du CLI, hors session interactive. |
| Commande slash | Gérée par le CLI lui-même, pas par le raisonnement du modèle — et sans effet sur les fichiers. |

### La méthode de travail

| Notion | À retenir |
|---|---|
| Prompt en lecture seule | Première demande réelle volontairement limitée à la lecture : vérifier que l'agent a compris le bon projet. |
| Carte du dépôt | Synthèse structurée — rôle, pile, fichiers principaux, commandes, risques — produite après lecture progressive. |
| Demande vague **utile** | Ouverte, mais qui **interdit explicitement** toute écriture. Sûre. |
| Demande vague **dangereuse** | Ouverte et qui n'interdit rien. Peut déclencher une écriture non cadrée. |
| Plan | 2-3 étapes proposées avant toute écriture : le point de contrôle qui rend une mauvaise interprétation peu coûteuse. |
| Demande précise | Fichier + problème + contraintes + vérification + définition de terminé. |
| Définition de terminé | Sans elle, Claude peut croire le travail fini dès qu'il a écrit du code. |
| Faits / hypothèses / recommandations | Les trois niveaux à séparer dans une analyse : observé, déduit, proposé. |

### La boucle de vérification

| Notion | À retenir |
|---|---|
| Le cycle | Demander → modifier → tester → vérifier → prouver → décider. |
| `git diff` | La source de vérité, à regarder **soi-même** avant toute validation. |
| `/chrome` | Intégration Claude in Chrome : vérification frontend par observation, en complément des tests. |
| Preuve finale | Fichiers modifiés, commandes exécutées, résultats — et surtout **ce qui n'a pas été vérifié**. |
| Recadrage de périmètre | Demander à Claude d'expliquer ou réduire un diff qui dépasse les fichiers autorisés. |
| `git restore` / `checkout --` | Annuler une modification non commitée : un outcome normal, pas un échec. |
| `/copy` · `/export` | Copier un résumé dans le presse-papiers / exporter la conversation complète. |

### Dictée vocale

| Notion | À retenir |
|---|---|
| `/voice` | Transcription vocale dans l'invite, mélangeable avec la saisie clavier. |
| Mode `hold` | On tient la touche pendant qu'on parle — le plus contrôlé, force la relecture. |
| Mode `tap` | Une pression démarre, une seconde arrête — rapide, moins prudent. |
| Mode `off` | Désactivé : le plus sûr en environnement bruyant ou sensible. |
| `autoSubmit` | Envoie automatiquement un prompt dicté. **À garder désactivé** en développement. |
| Erreur de transcription | Négation avalée, nom de fichier déformé — une erreur qui peut inverser l'intention. Relecture obligatoire. |

### Changer de surface

| Commande | Rôle |
|---|---|
| `/ide` | Gérer l'intégration avec l'éditeur : lecture multi-fichiers, inspection de diff. |
| `/desktop` (`/app`) | Continuer la session dans l'application Desktop, plus visuelle. |
| `/mobile` (`/ios`, `/android`) | Préparer l'accès depuis l'application mobile. |
| `/remote-control` (`/rc`) | Piloter une session locale depuis un autre appareil. |
| `/remote-env` | Choisir l'environnement utilisé par les agents cloud. |
| Résumé de reprise | Synthèse de l'état courant pour continuer une tâche dans de bonnes conditions. |

### Veille et feedback

| Commande | Rôle |
|---|---|
| `/release-notes` | Notes de version de Claude Code — la veille fait partie du métier. |
| `/upgrade` | Options de changement de plan. Distinguer problème de plan et problème technique. |
| `/privacy-settings` | Réglages de confidentialité disponibles. |
| `/feedback` (`/bug`) | Signaler un comportement de Claude Code lui-même — pas un bug de votre code. |
| `/exit` (`/quit`) | Quitter la session sans déconnecter le compte — à ne pas confondre avec `/logout`. |

---

## 07 — Raccourcis clavier et optimisations du CLI

> 4 leçons

**Idée maîtresse.** Les raccourcis servent surtout à **reprendre le contrôle** : interrompre, corriger un prompt, inspecter l'exécution. Règle d'or : un raccourci dépend de la **zone** où on l'utilise, et le terminal hôte peut l'intercepter avant Claude.

### Pilotage de session

| Raccourci / commande | Rôle |
|---|---|
| Contexte de raccourci | La zone de l'interface dans laquelle une touche a un comportement donné. Même touche, effets différents. |
| Shell mode `!` | Préfixe permettant d'exécuter directement une commande shell. |
| `Ctrl+R` | Recherche inversée dans l'historique des prompts. |
| `Ctrl+O` | Ouvrir / fermer la transcription détaillée : outils et étapes d'exécution. |
| `/diff` | Visionneuse interactive des changements. |
| `/tasks` | Gestion des tâches lancées en arrière-plan. |
| `/terminal-setup` | Aide le terminal (surtout dans les IDE) à transmettre correctement les séquences de touches. |
| tmux | Multiplexeur qui intercepte certains raccourcis et possède son propre défilement. |

### Rendu plein écran (TUI)

| Notion | À retenir |
|---|---|
| `/tui fullscreen` · `/tui default` | Activer le rendu plein écran / revenir au rendu classique. |
| Rendu classique | Utilise le **scrollback natif** du terminal : la recherche du terminal suffit. |
| Rendu plein écran | Claude contrôle une surface dédiée (tampon d'écran alternatif) : sessions longues plus stables. |
| `/focus` | Réduit les informations intermédiaires affichées. Ne change **ni** le raisonnement, **ni** les permissions. |
| `CLAUDE_CODE_NO_FLICKER` | Variable activant un rendu visant à réduire le scintillement. |
| `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN` | Désactive l'usage du tampon d'écran alternatif. |
| `CLAUDE_CODE_SCROLL_SPEED` | Ajuste la vitesse de défilement (voir aussi `/scroll-speed`). |

### Navigation en transcription

| Touche | Rôle |
|---|---|
| `/` · `n` · `N` | Ouvrir la recherche, occurrence suivante, occurrence précédente. |
| `j` · `k` | Défiler vers le bas / vers le haut. |
| `Ctrl+D` · `Ctrl+U` | Descendre / remonter d'une demi-page. |
| `g` · `G` | Aller au début / à la fin. |
| `$EDITOR` / `$VISUAL` | Variables déterminant l'éditeur ouvert depuis la transcription. |

### Édition du prompt

| Touche | Rôle |
|---|---|
| `Ctrl+A` · `Ctrl+E` | Début / fin de ligne. |
| `Ctrl+K` · `Ctrl+U` | Supprimer jusqu'à la fin / jusqu'au début de la ligne. |
| `Ctrl+W` | Supprimer le mot précédant le curseur. |
| `Ctrl+Y` · `Alt+Y` | Récupérer le dernier texte supprimé, puis parcourir les suppressions précédentes. |
| `Alt+B` · `Alt+F` | Déplacer le curseur d'un mot en arrière / en avant. |
| Touche Meta | Souvent `Option` sur macOS — à activer comme « Meta » dans le terminal. |

---

## 08 — Personnalisation et configuration de l'interface

> 6 leçons

**Idée maîtresse.** Configurer, ce n'est pas choisir une option : c'est choisir **à quel étage la poser**. Cinq portées se superposent et se résolvent dans un ordre fixe — le **managed écrase tout**, l'utilisateur cède devant tout le monde. Un réglage trop bas devient une préférence qu'un collègue écrase ; trop haut, une contrainte que personne ne peut lever.

### Les portées

| Notion | À retenir |
|---|---|
| La bonne question | Qui est concerné — et est-ce que ça doit pouvoir être contourné ? |
| Managed settings | Politique d'organisation déposée hors du dépôt par l'administrateur. Conçue pour être **non contournable**. |
| `managed-settings.d/` | Éclate la politique en fichiers triés alphabétiquement puis fusionnés (`10-security.json`, `20-sandbox.json`…). |
| `.claude.json` | État **interne** de Claude Code (OAuth, confiance des projets, outils approuvés, caches). Ce n'est pas un fichier de configuration. |
| `$schema` | Clé pointant vers le schéma JSON public : active autocomplétion et validation dans l'éditeur. |
| `CLAUDE_CONFIG_DIR` | Déplace le répertoire habituellement en `~/.claude` — tests, conteneurs, profils séparés. |

### Réglages notables

| Réglage | Rôle |
|---|---|
| `/config` | La commande interactive principale pour explorer et basculer les réglages. |
| `autoCompactEnabled` | Résume et compresse l'historique pour éviter la saturation du contexte. |
| `fileCheckpointingEnabled` | Sauvegarde l'état d'un fichier avant modification, pour pouvoir revenir en arrière. |
| Dynamic Workflows | Orchestration par sous-agents pour les tâches vastes et complexes. |
| `useAutoModeDuringPlan` | Applique la fluidité du mode auto pendant la phase de planification. |
| `respectGitignore` | Contrôle si la navigation respecte les exclusions Git. |
| `outputStyle` | Influence la posture rédactionnelle et le niveau de détail des réponses. |

### Terminal, thème, notifications

| Notion | À retenir |
|---|---|
| Retour à la ligne | `Entrée` soumet. `Shift+Enter` dépend du terminal ; `Ctrl+J` est le repli **garanti**. |
| `/terminal-setup` | Corrige les réglages du terminal — ne configure **pas** le comportement interne du CLI. |
| macOS et Option | Activer « Use Option as Meta Key » pour que les raccourcis passent. |
| `/theme` vs `/color` | `/theme` = confort visuel global. `/color` = distinguer plusieurs sessions simultanées. |
| `preferredNotifChannel` | Canal de notification (iterm2, kitty, terminal_bell). Signale la fin de tâche, **pas son succès**. |
| tmux | Bloque notifications et touches complexes : activer `allow-passthrough` et `extended-keys`. |

### Barre de statut et raccourcis

| Notion | À retenir |
|---|---|
| `/statusline` | Configure la ligne d'état : dossier, modèle, usage du contexte — l'état **objectif** de la session. |
| Script de statut | Il s'exécute localement : outils rapides (`jq`), **aucune commande bloquante**. |
| `refreshInterval` | Force la réexécution du script de statut toutes les N secondes. |
| `/keybindings` | Ouvre le fichier de raccourcis personnels (`~/.claude/keybindings.json`). |
| Accords de touches | Séquence successive (`ctrl+k ctrl+e`) : limite les déclenchements accidentels sur les actions rares. |
| Contextes | Périmètres d'interface (`Chat`, `Task`, `Scroll`) — cibler plutôt que remapper globalement. |
| À ne pas remapper | `Ctrl+C`, `Ctrl+D`. Et vérifier l'intégrité via `/doctor`. |

---

## 09 — Gestion des sessions et du contexte

> 5 leçons

**Idée maîtresse.** Le contexte ne se limite pas à vos messages : sources **passives** chargées au démarrage et sources **actives** ajoutées en cours de route. Une session est une conversation persistée en `JSONL` — qu'on peut reprendre, renommer, brancher et rembobiner, mais qui ne protège jamais le disque.

### Les sources de contexte

| Notion | À retenir |
|---|---|
| Sources passives | Chargées au démarrage : `CLAUDE.md`, mémoire automatique, règles. |
| Sources actives | Ajoutées pendant la session : fichiers lus, sorties de commandes, retours d'outils. |
| `/context` | Surveiller l'état de remplissage de la fenêtre. |
| Pollution / context rot | Encombrement par des données inutiles ou obsolètes : les réponses se dégradent. |
| Le réflexe | Commandes ciblées, sous-agents pour les tâches lourdes, surveillance avec `/context`. |

### Nettoyer ou compacter

| Notion | À retenir |
|---|---|
| `/clear` (`/new`, `/reset`) | Purge et repart d'un contexte vierge. À faire à **chaque nouvelle tâche**, et après deux échecs successifs. |
| `/compact` | Résume l'historique pour regagner du budget. Seuil d'alerte vers **40-60 %**. |
| Guider la compaction | Une compaction n'est jamais neutre : préciser ce qui doit être conservé, par ex. via une section `## Compaction` dans `CLAUDE.md`. |
| `/btw` | Question courte et latérale sans encombrer la session. Ne doit **jamais** servir à élargir un périmètre. |
| `/recap` | Mini-résumé d'une ligne de la direction de la session. |

### Reprendre une session

| Notion | À retenir |
|---|---|
| Session | Unité persistante : fichiers `JSONL` dans `~/.claude/projects/`. |
| `/resume` (`claude -r`) | Reprendre une session précise, par nom ou ID, ou via le sélecteur. |
| `/continue` (`claude -c`) | Reprend la session la plus récente du dossier. Pratique — **dangereux si l'objectif change**. |
| `/rename` | Nommer ses sessions comme des branches Git. Vital pour s'y retrouver. |
| Le piège de la reprise | La trajectoire est restaurée mais les **permissions sont recalculées** — et le code a pu évoluer. Vérifier l'état du projet. |

### Brancher et rembobiner

| Notion | À retenir |
|---|---|
| `/branch <nom>` | Clone la trajectoire conversationnelle pour tester une variante sans polluer l'originale. |
| **Le piège majeur** | `/branch` ne protège **pas** les fichiers sur le disque : les modifications s'appliquent au répertoire de travail. |
| `--fork-session` | Lancer directement sur une branche : `claude -r <nom> --fork-session`. |
| `/fork` | Déléguer une tâche secondaire à un sous-agent, sans brancher l'interface interactive. |
| `Esc` | Stopper immédiatement une trajectoire qui déraille, sans perdre l'historique. |
| `/rewind` (`/checkpoint`) | Menu de retour à un état antérieur : code seul, conversation seule, ou les deux. |
| Résumer à partir d'ici / jusqu'ici | Conserver le détail ancien et résumer la suite — ou l'inverse. |
| **Limite des checkpoints** | Ni les modifications manuelles, ni les commandes bash (`rm`, `mv`, `cp`) ne sont suivies. **Git reste la seule vérité durable.** |

---

## 10 — Modèles, coûts et usage

> 5 leçons

**Idée maîtresse.** Le **modèle** définit la capacité, l'**effort** définit la profondeur du raisonnement. Deux réglages distincts, deux coûts. Et un coût qui dérape vient presque toujours d'un contexte non nettoyé, refacturé à chaque tour.

### Effort et raisonnement

| Commande | Rôle |
|---|---|
| `/model` | Choisir le modèle — la capacité de base. |
| `/effort low` | Tâches simples, rapides, faible coût. |
| `/effort medium` | Analyse modérée, compromis coût / capacité. |
| `/effort high` | Développement standard. |
| `/effort xhigh` | Debugging, architecture, analyse complexe. |
| `/effort max` | Raisonnement exceptionnellement profond. |
| `/effort auto` | Retour à la valeur par défaut du modèle. |
| `effortLevel` | Préférence persistante dans les settings. |
| `CLAUDE_CODE_EFFORT_LEVEL` | Impose l'effort via l'environnement, avec **priorité élevée**. |
| `ultrathink` | Mot-clé forçant un raisonnement profond sur **un seul tour**. |
| `ultracode` | `xhigh` + workflow dynamique à sous-agents. Pour la phase lourde seulement, puis retour à un effort adapté. |

### Mode rapide

| Notion | À retenir |
|---|---|
| `/fast on` | Réduit la latence d'Opus. Ce n'est **pas** un mode économique : c'est plus cher. |
| Bon usage | Debugging interactif en direct, itération rapide, tâche simple urgente. |
| Mauvais usage | Longs traitements autonomes. Et une activation tardive dans une longue conversation coûte cher. |
| **Le piège** | `/fast off` ne vous **ramène pas** au modèle précédent : vous restez sur Opus jusqu'à un `/model` explicite. |
| `fastMode` · `fastModePerSessionOptIn` | Mémoriser la préférence / forcer une décision à chaque session. |
| `availableModels` | Si l'organisation interdit Opus, elle interdit indirectement `/fast`. |

### Suivre les coûts

| Commande | Rôle |
|---|---|
| `/usage` | Coûts estimés, état des limites du plan, statistiques de session. « Combien et où ? » |
| `/cost` · `/stats` | Ouvrent directement l'onglet correspondant de `/usage`. |
| `/insights` | Rapport **qualitatif** sur vos habitudes de travail. « Pourquoi je travaille ainsi ? » |
| `/usage-credits` | Configurer les crédits en cas de limite atteinte. |
| `/usage` vs `/context` | `/usage` = ce qui est consommé. `/context` = ce qui remplit la fenêtre. |
| `/mcp` | Désactiver les serveurs inutiles — un MCP activé pour rien est facturé à chaque tour. |

### Workflows longs

| Notion | À retenir |
|---|---|
| La trajectoire multiplie | Le coût dépend du nombre de tours **et** du contexte accumulé : les deux se multiplient. |
| Le budget d'orchestration | À définir **avant** de lancer : périmètre limité, outils bridés, nombre d'agents encadré, condition d'arrêt. |
| Sous-agents | Ils protègent le contexte parent, mais génèrent leur propre coût. |
| Si ça dérape | Ajouter des crédits ne règle rien : nettoyer le contexte (`/clear`) ou couper les outils superflus. |
| `disableWorkflows` vs `workflowKeywordTriggerEnabled` | Désactivation complète vs désactivation du seul déclenchement par mot-clé. |
| Périmètre d'audit | Besoin de sortir du périmètre → arrêt et validation, jamais d'élargissement silencieux. |

---

## 11 — Permissions, contrôle et sécurité

> 7 leçons

**Idée maîtresse.** La frontière entre ce que Claude **pense** et ce qu'il **exécute**. Trois décisions, un ordre inflexible : `deny` > `ask` > `allow`. Et une distinction à ne jamais confondre : une **permission** autorise, un **sandbox** isole.

### Le modèle de permissions

| Notion | À retenir |
|---|---|
| `deny` | Protéger strictement. L'emporte **toujours** — une règle `allow` précise ne contournera jamais un `deny` plus large. |
| `ask` | Conserver l'arbitrage humain sur les actions ambiguës. |
| `allow` | Fluidifier le répétitif et le sûr, pour éviter la fatigue de validation. |
| Réorienter, pas seulement bloquer | Une permission bien calibrée pousse l'agent vers une stratégie autorisée au lieu d'arrêter la session. |
| Hook `PreToolUse` | Un code de sortie **2** = arrêt immédiat, **avant** l'évaluation des permissions. Ce n'est pas un `ask`. |
| Permission vs Sandbox | Permission = **autorisation** d'agir. Sandbox = **isolation** des effets pendant l'exécution. |
| `CLAUDE.md` | Ce sont des instructions, pas des barrières techniques. Elles orientent, elles ne bloquent pas. |

### Les modes de permission

| Mode | Posture | Piège |
|---|---|---|
| `default` | **Découvrir.** Dépôt inconnu ou sensible. | Ce n'est pas pour un environnement jetable. |
| `plan` | **Comprendre.** « Je dois d'abord savoir comment agir. » | La bonne réponse à une tâche floue — pas `auto`. |
| `acceptEdits` | **Implémenter.** « Je sais déjà comment agir » : on code, on vérifie après coup. | — |
| `auto` | **Réduire les interruptions.** Seulement sur une tâche claire et bien cadrée. | — |
| `dontAsk` | **Automatiser.** Aucune interaction. | Ce n'est **pas** permissif — ce qui n'est pas préautorisé est refusé. |
| `bypassPermissions` | **Contourner.** Environnements isolés et sacrifiables uniquement. | À bannir sur un vrai dépôt avec secrets ou accès prod. |

### Écrire les règles

| Notion | À retenir |
|---|---|
| `/permissions` | Visualiser et gérer les règles interactivement. Observer d'abord les commandes récurrentes. |
| Portée utilisateur | `~/.claude/settings.json` — préférences personnelles (protéger `~/.ssh`). |
| Portée projet | `.claude/settings.json` — l'équipe (autoriser le lint). |
| Portée locale | `.claude/settings.local.json` — hors Git, tests et fixtures. |
| Fusion des portées | Elles se **fusionnent** sans s'écraser, et un `deny` l'emporte toujours. |
| `Tool(specifier)` | La syntaxe de base, avec le nom **canonique** de l'outil. |
| Ancrage `/` vs `//` | `/src/**` est relatif à la racine du projet ; `//` part de la racine du système. |
| **Jamais `Bash(*)`** | Autoriser des commandes exactes ou des familles bornées, pas le shell entier. |
| La limite | Les permissions bloquent l'**outil** ; un script arbitraire autorisé par le shell ne se bloque qu'au niveau système, via le sandbox. |

### Isoler l'exécution

| Notion | À retenir |
|---|---|
| `/sandbox` | Isolation Bash intégrée (Seatbelt sur macOS, bubblewrap sur Linux). |
| **Sa limite stricte** | Il ne couvre **que** les commandes `Bash` — et par défaut, il lit tout l'ordinateur. |
| Mode `auto-allow` | Accepte les commandes Bash silencieusement **tant qu'elles respectent les limites du sandbox**. À ne pas confondre avec le mode `auto`. |
| `sandbox.credentials` | Bloquer explicitement l'accès aux identifiants (fichiers ou variables d'environnement). |
| Runtime Sandbox | Isole l'**intégralité** du processus : Bash + MCP + hooks + fichiers. |
| Devcontainer | Conteneur Docker défini par `.devcontainer/` pour standardiser l'environnement d'équipe. |
| Principe de minimisation | Données fictives, mocks, jetons courts. Isoler ne sert à rien si le réseau reste ouvert ou si les secrets sont montés. |

### Répertoires et chemins

| Notion | À retenir |
|---|---|
| Proportionnalité | Ne donner que les accès strictement nécessaires à la tâche. |
| `/cd` | Relocalise la racine du projet — change le contexte **et** les settings. |
| `/add-dir` | Élargit la surface de lecture/écriture sans changer la racine. Attention : le `CLAUDE.md` du dossier ajouté n'est **pas** chargé. |
| `additionalDirectories` | Rendre des `/add-dir` persistants. |
| Chemins protégés | `.git`, `.claude`, `.vscode`, `.npmrc`, configs shell — jamais modifiables automatiquement. |
| `Cd(path)` | Liste blanche ou noire limitant où `/cd` peut emmener la session. |
| Avant d'ouvrir un dossier externe | Poser des règles `Read` en `deny` pour les secrets et les `.env`. |

### Sessions non interactives

| Notion | À retenir |
|---|---|
| Mode headless `claude -p` | Exécute de bout en bout sans terminal interactif. Aucun humain pour rattraper une dérive. |
| `allowedTools` | Pré-approuve les outils listés — **mais ne bloque pas les autres**. |
| `disallowedTools` | Bloque explicitement (`Bash`, `mcp__*`). L'emporte sur tous les modes. |
| `dontAsk` en non-interactif | Transforme toute demande de validation en refus immédiat. Le bon garde-fou. |
| `maxTurns` · `maxBudgetUsd` | Coupe-circuits contre la boucle infinie et le compte vidé. |
| `strictMcpConfig` | Ignore les serveurs MCP personnels pour garantir une exécution reproductible. |
| `allowManagedMcpServersOnly` | N'autorise que les serveurs MCP validés par l'organisation. |
| **Le piège MCP** | L'option `tools` ne filtre **pas** les outils MCP : ils exigent leur propre gouvernance. |

### Des habitudes aux politiques

| Notion | À retenir |
|---|---|
| Le principe | Ce qu'on répète doit devenir une politique codée, pas une consigne à réécrire. |
| La bonne couche | `CLAUDE.md` guide les **procédures** ; les barrières d'exécution vivent dans `allow`/`deny`. |
| Hooks | Scripts déclenchés sur événement : `PreToolUse`, `PostToolUse`, `PermissionRequest`. |
| Hook ≠ refus dur | Ils travaillent de concert : le `deny` bloque, le hook journalise ou formate. |
| `/fewer-permission-prompts` | Audite l'historique des sessions et propose une allowlist. Excellent point de départ. |
| Paramètres gérés | Règles et hooks injectés au niveau de l'organisation (MDM, registres) — non contournables localement. |

---

## 12 — Mémoire, CLAUDE.md et auto-mémoire

> 6 leçons · **3 fiches rédigées sur 6**

**Idée maîtresse.** `CLAUDE.md` est la mémoire de projet : commandes spécifiques, conventions d'équipe, pièges connus. Mais ce n'est **que du contexte injecté** — jamais une règle de sécurité. Et sa qualité tient à une discipline : court, spécifique, actuel.

### Comprendre CLAUDE.md

| Notion | À retenir |
|---|---|
| `CLAUDE.md` | Mémoire explicite de l'équipe : fichier Markdown versionné, lu au démarrage de la session. |
| `CLAUDE.local.md` | Mémoire personnelle non versionnée (dans `.gitignore`) : ses propres commandes, son port de dev. |
| La limite à tenir | Court, spécifique, actuel — **idéalement sous 200 lignes**. L'encyclopédie est l'erreur la plus fréquente. |
| Adhérence des instructions | Une règle diluée dans 1000 lignes a une adhérence très faible. La longueur détruit l'obéissance. |
| Ce qu'il n'est pas | Il ne remplace **pas** les règles `allow`/`deny`. Il oriente, il ne bloque pas. |
| Mémoire automatique | Claude note ses propres apprentissages (erreurs, chemins fréquents) dans des fichiers locaux. |
| `/memory` | Vérifier l'état de la mémoire, lister les `CLAUDE.md` chargés, activer/désactiver l'auto-mémoire. |

### Générer avec /init

| Étape | À retenir |
|---|---|
| `/init` | Scanne le dépôt et génère un `CLAUDE.md`. C'est un **brouillon**, pas un livrable. |
| 1 · Supprimer | L'étape la plus oubliée : retirer le bruit — descriptions fichier par fichier, copier-coller du README. |
| 2 · Préciser | Remplacer les règles vagues : « teste bien » devient `pnpm test:unit`. |
| 3 · Compléter | Ce que l'IA ne peut pas deviner : migrations en cours, gotchas d'équipe. |
| Migration partielle | Un dépôt contenant l'ancien **et** le nouveau pattern : un danger majeur, à documenter explicitement. |
| Le traiter comme du code | Relu en PR, nettoyé de sa dette, gardé court et actionnable. |
| `CLAUDE_CODE_NEW_INIT=1` | Active un processus d'initialisation interactif avec un sous-agent. |

### Choisir l'emplacement

| Emplacement | Portée |
|---|---|
| Le vrai enjeu | L'emplacement détermine **qui** reçoit la règle **et quand** elle est chargée en contexte. |
| `./CLAUDE.md` | Mémoire projet partagée et versionnée. Suffit pour un projet simple. |
| `./CLAUDE.local.md` | Mémoire projet personnelle, ignorée par Git. |
| `~/.claude/CLAUDE.md` | Mémoire utilisateur : préférences globales valables sur tous vos projets. |
| Mémoire gérée | Règles imposées par l'organisation, prioritaires. |
| Stratégie monorepo | Transversal à la racine ; conventions locales dans le `CLAUDE.md` de chaque package — chargé **à la demande**, ce qui protège la fenêtre. |
| `claudeMdExcludes` | Ignorer complètement la lecture des `CLAUDE.md` sur certains chemins d'un grand monorepo. |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Force le chargement de la mémoire d'un dépôt « frère » auquel on a donné accès. |

---

## Ce qui reste à couvrir

Cette fiche s'arrête à la leçon **12/03**. Les trois leçons suivantes du chapitre 12 ne sont pas encore rédigées, et ne figurent donc pas ci-dessus :

| Leçon | Sujet | Durée |
|---|---|---|
| 12/04 | Structurer les instructions avec `.claude/rules/` et les imports `@path` | 25 min |
| 12/05 | Auditer, nettoyer et maîtriser l'auto-mémoire avec `/memory` | 9 min |
| 12/06 | Capitaliser les retours d'expérience : transformer les corrections en mémoire durable | 8 min |

Au-delà, les chapitres 13 à 25 (71 leçons, 12 h 29) restent entièrement à travailler.

**À mettre à jour** : chaque fois qu'un chapitre est terminé, ajouter ici son idée maîtresse et ses notions, et vérifier si un nouveau fil rouge se dégage.
