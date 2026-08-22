---
title: "Glossaire et carte mentale des commandes — Chapitre 6"
description: "Référence rapide : toutes les commandes et tous les termes vus dans le chapitre 6, organisés pour une recherche rapide."
date: 2026-08-21
draft: true
tags:
  - claude-code
  - cli
  - commandes
  - glossaire
  - reference
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-decouverte-premieres-commandes-cli
leçon: 07-glossaire-carte-mentale-commandes
statut: référence
etape_revision: 0
prochaine_revision:
---

# Glossaire et carte mentale — Chapitre 6

## À quoi sert cette fiche

Le chapitre 6 (leçons 01 à 06) introduit une trentaine de commandes CLI éparpillées sur plusieurs sujets (session, dictée vocale, cadrage de demande, vérification, surfaces de travail, compte/veille). Cette fiche ne réexplique rien : elle **consolide** tout ce qui a déjà été vu, dans deux formats complémentaires :

1. **Glossaire alphabétique** (commandes puis concepts) → pour chercher un terme précis en un coup d'œil (`Ctrl+F`).
2. **Carte mentale par familles** → pour retrouver une commande quand on ne se souvient que de son domaine ("c'était un truc lié aux surfaces...").

Chaque entrée renvoie à la leçon d'origine (`L1` à `L6`) où elle est expliquée en détail — cette fiche est un index, pas un remplacement des fiches leçon.

| Leçon | Fichier | Sujet |
|---|---|---|
| L1 | `01-entrer-cli-verifier-session.md` | Entrer dans le CLI, vérifier la session |
| L2 | `02-mise-en-place-dictee-vocale.md` | Dictée vocale |
| L3 | `03-premieres-demandes-exploration-vague-demande-precise.md` | Demande vague vs demande précise |
| L4 | `04-premiere-modification-code-boucle-verification.md` | Modification + boucle de vérification |
| L5 | `05-continuer-session-bons-environnements.md` | Surfaces de travail (IDE, Desktop, Mobile, Remote) |
| L6 | `06-veille-feedback-compte-commandes-personnalisees.md` | Veille, compte, confidentialité, feedback |

---

## Carte mentale complète (par famille)

```text
Chapitre 6 — Commandes du CLI Claude Code
│
├── 1. Session & diagnostic (L1)
│   ├── /login          → se connecter au compte
│   ├── /status          → état de la session (version, compte, modèle, connectivité)
│   ├── /doctor          → diagnostic install / config / connectivité (1er réflexe si bug)
│   ├── /help            → aide à jour, dans la session réelle
│   ├── /powerup         → visite guidée des capacités (modes, MCP, skills, hooks...)
│   └── claude update    → mettre à jour le CLI (hors session)
│
├── 2. Dictée vocale (L2)
│   ├── /voice           → activer/désactiver selon l'état courant
│   │   ├── hold          → maintien, relecture forcée (par défaut, tâches sensibles)
│   │   ├── tap           → appui, rapide (lecture seule, confiance)
│   │   └── off           → désactivée (bruit, réunion, prudence max)
│   ├── /config           → langue de dictée
│   └── /keybindings       → remapper voice:pushToTalk (défaut : Space)
│
├── 3. Cadrer une demande & prouver un travail (L3, L4)
│   ├── /btw              → question latérale SEULEMENT (jamais élargir le périmètre)
│   ├── /chrome            → vérification frontend observée (complète les tests, ne les remplace pas)
│   ├── /copy              → résumé court → presse-papiers
│   └── /export             → conversation complète → archivage
│
├── 4. Surfaces de travail (L5)
│   ├── /ide                → intégration éditeur (lecture, diff)
│   ├── /desktop (/app)      → app Desktop, plus visuel
│   ├── /mobile (/ios, /android) → accès mobile via QR code
│   ├── /remote-control (/rc) → piloter une session LOCALE à distance
│   └── /remote-env           → environnement par défaut des AGENTS CLOUD
│
├── 5. Compte, veille & feedback (L6)
│   ├── /release-notes      → notes de version → décider (utiliser / tester / ignorer)
│   ├── /upgrade             → changer de plan
│   ├── /privacy-settings    → réglages de confidentialité du compte
│   ├── /passes               → partager un accès temporaire (si éligible)
│   ├── /stickers              → périphérique, sans lien avec le dev
│   └── /feedback (/bug)       → signaler un problème PRODUIT (pas un bug de ton code)
│
├── 6. Fermer / se déconnecter (L1, L5, L6)
│   ├── /exit (/quit)       → fermer le CLI (compte reste connecté)
│   └── /logout              → déconnecter le compte (machine partagée/temporaire)
│
└── 7. Terminal / Git / npm — hors session Claude (L1, L3, L4, L6)
    ├── claude, claude --version   → lancer le CLI / connaître sa version
    ├── npm test, npm run dev      → preuve minimale + serveur local
    └── git status/diff/init/add/commit/checkout --/restore
                                    → état propre, source de vérité, annulation gratuite
```

---

## Glossaire alphabétique — Commandes

| Commande | Rôle | Leçon |
|---|---|---|
| `/android` | Alias de `/mobile`, orienté Android. | L5 |
| `/app` | Alias de `/desktop`. | L5 |
| `/btw` | Question courte et latérale à partir du contexte déjà présent ; ne doit **jamais** servir à changer le périmètre d'une tâche. | L3 |
| `/bug` | Alias de `/feedback`. | L6 |
| `/chrome` | Configure l'intégration Claude in Chrome ; vérification frontend par observation, en complément des tests automatisés. | L4 |
| `/config` | Réglages de session ; sert notamment à fixer la langue de dictée. | L2 |
| `claude` | Lance le CLI — toujours depuis la racine du dépôt. | L1 |
| `claude --version` | Affiche la version du CLI installée. | L6 |
| `claude update` | Met à jour le CLI Claude Code (hors session interactive). | L1 |
| `/copy` | Copie un résumé (souvent demandé en 5 lignes) dans le presse-papiers. | L4 |
| `/desktop` | Continue la session dans l'application Desktop, plus visuelle. | L5 |
| `/doctor` | Diagnostique installation, paramètres, connectivité ; réflexe n°1 en cas de comportement étrange, avant de retoucher le prompt. | L1, L2 |
| `/exit` | Ferme proprement la session CLI interactive, sans déconnecter le compte. | L5, L6 |
| `/export` | Exporte la conversation complète en texte, pour archivage ou documentation. | L4 |
| `/feedback` | Envoie un retour produit ou signale un comportement problématique de Claude Code lui-même (pas un bug de ton code). | L6 |
| `git add` / `git commit` | Valide et crée un point de repère une fois une modification acceptée. | L1, L4 |
| `git checkout -- <fichier>` / `git restore <fichier>` | Annule une modification non commitée — un outcome normal, pas un échec. | L4 |
| `git diff` | Montre exactement ce qui a changé — source de vérité, à regarder soi-même avant toute validation. | L4 |
| `git init` | Crée un état de référence versionné avant d'ouvrir Claude Code. | L1 |
| `git status` | Vérifie l'état du dépôt (propre ou non) avant/après une session. | L1, L3, L4 |
| `/help` | Affiche l'aide et les commandes disponibles **dans la session réelle** — liste évolutive, jamais figée. | L1 |
| `/ide` | Gère l'intégration avec l'éditeur ; facilite lecture multi-fichiers et inspection de diff. | L5 |
| `/ios` | Alias de `/mobile`, orienté iOS. | L5 |
| `/keybindings` | Remappe un raccourci clavier, ex. `voice:pushToTalk`, dans `~/.claude/keybindings.json`. | L2 |
| `/login` | Se connecte au compte utilisé par Claude Code ; ne modifie jamais le projet. | L1 |
| `/logout` | Déconnecte le compte Anthropic — utile sur machine partagée, temporaire ou peu contrôlée. | L1, L5, L6 |
| `/mobile` | Prépare l'accès depuis une application mobile (souvent via QR code). | L5 |
| `npm run dev` | Lance le serveur de développement local (vérification manuelle). | L1, L4 |
| `npm test` | Vérifie la logique du projet — preuve minimale avant toute session, puis avant/après modification. | L1, L4 |
| `/passes` | Partage une période gratuite de Claude Code, si le compte est éligible. | L6 |
| `/powerup` | Parcours interactif de découverte des capacités (modes, rewind, MCP, skills, hooks, sous-agents...) ; ne modifie rien. | L1 |
| `/privacy-settings` | Consulte et modifie les réglages de confidentialité du compte ; ne remplace pas une politique de sécurité d'entreprise. | L6 |
| `/quit` | Alias de `/exit`. | L5, L6 |
| `/rc` | Alias de `/remote-control`. | L5 |
| `/release-notes` | Consulte les notes de version de Claude Code, pour transformer la veille en décision. | L6 |
| `/remote-control` | Rend une session **locale** accessible/pilotable depuis un navigateur ou un mobile ; l'exécution reste sur la machine locale. | L5 |
| `/remote-env` | Choisit l'environnement par défaut utilisé par les **agents cloud** (≠ `/remote-control`). | L5 |
| `/status` | Affiche l'état de la session : version, compte, modèle, connectivité. Réflexe de début de session. | L1 |
| `/stickers` | Commande de commande de stickers Claude Code — périphérique, sans lien avec le développement. | L6 |
| `/upgrade` | Ouvre la page de changement de plan, quand l'option est disponible. | L6 |
| `/voice` | Active ou désactive la dictée vocale selon l'état courant de la session. | L2 |
| `/voice hold` | Mode maintien — presser/parler/relâcher ; le plus contrôlé (relecture forcée). | L2 |
| `/voice off` | Désactive complètement la dictée. | L2 |
| `/voice tap` | Mode appui — une pression démarre, une seconde arrête ; le plus rapide, moins de garde-fou. | L2 |

### Table des alias

| Alias | Commande complète |
|---|---|
| `/app` | `/desktop` |
| `/ios`, `/android` | `/mobile` |
| `/rc` | `/remote-control` |
| `/bug` | `/feedback` |
| `/quit` | `/exit` |

---

## Glossaire alphabétique — Concepts et vocabulaire

| Terme | Définition | Leçon |
|---|---|---|
| Agent cloud | Agent exécuté dans un environnement distant plutôt que sur la machine locale. | L5 |
| Ambiguïté (de formulation) | Flou qui existe aussi à l'écrit (ex. "le fichier JSON" quand il y en a plusieurs) — à distinguer d'une erreur de transcription. | L2 |
| `autoSubmit` | Option de configuration qui envoie automatiquement un prompt dicté sans confirmation ; à garder désactivée en développement. | L2 |
| Boucle de vérification | Cycle demander → modifier → tester → vérifier → prouver → décider, qui referme une tâche de manière contrôlée. | L4 |
| Carte du dépôt | Synthèse structurée (rôle, pile technique, fichiers principaux, commandes, risques) produite après une lecture progressive. | L3 |
| CLI | Interface en ligne de commande à travers laquelle on interagit avec Claude Code. | L1 |
| Commande slash | Commande de session commençant par `/`, gérée par le CLI (pas par le raisonnement du modèle) ; ne touche jamais le projet. | L1 |
| Confidentialité | Ensemble des règles liées à l'utilisation, la conservation et l'exposition des données du compte. | L6 |
| Définition de terminé | Liste explicite des critères qui font qu'une tâche est réellement achevée (comportement, tests, diff, limites). | L3, L4 |
| Demande précise | Demande qui indique le fichier, le problème, les contraintes, la vérification et la définition de terminé. | L3 |
| Demande vague dangereuse | Demande ouverte qui n'interdit rien — peut déclencher une écriture non cadrée. | L3 |
| Demande vague utile | Demande ouverte qui interdit explicitement toute modification — sert à explorer sans risque. | L3 |
| Diff | Ce que montre `git diff` : la source de vérité de ce qui a réellement changé. | L4 |
| Erreur de transcription | Mauvaise interprétation de la voix par le moteur de dictée (négation avalée, nom de fichier déformé) — spécifique à la dictée. | L2 |
| Faits / hypothèses / recommandations | Trois niveaux à séparer dans une analyse de dépôt : observé / déduit / proposé. | L3 |
| Fichier critique | Fichier dont une mauvaise modification aurait un impact disproportionné (logique métier, tests, scripts). | L3 |
| Fil rouge du chapitre | Le mini-projet `convertisseur-temperature`, support de toutes les leçons du chapitre 6. | L1 |
| Note de version | Document décrivant nouveautés, corrections et changements de comportement d'une version. | L6 |
| Périmètre | Ensemble des fichiers et zones qu'une tâche est autorisée à toucher. | L3 |
| Piste | Proposition d'action identifiée pendant l'exploration, pas encore une tâche formalisée. | L3 |
| Plan | Séquence de 2-3 étapes proposée avant toute écriture — point de contrôle bon marché. | L3 |
| Preuve / preuve finale | Élément vérifiable (commande exécutée, résultat, diff, **ce qui n'a pas été vérifié**) — distinct d'un résumé de confiance. | L3, L4 |
| Prompt en lecture seule | Demande explicitement limitée à la lecture, sans autorisation de modifier, pour valider le contexte avant une tâche réelle. | L1, L3 |
| Rapport de bug | Description structurée (contexte, action, résultat attendu, résultat observé, version) d'un comportement incorrect. | L6 |
| Recadrage de périmètre | Instruction demandant à Claude d'expliquer ou de réduire un diff qui dépasse les fichiers autorisés. | L4 |
| Résumé de reprise | Synthèse de l'état courant (projet, modification, vérifications, prochaine action) avant de changer de surface. | L5 |
| Session | Instance active de travail avec Claude Code : compte, modèle, version, état de connectivité. | L1 |
| Settings partagés | `.claude/settings.json`, généralement commité et appliqué à toute l'équipe. | L2 |
| Settings personnels | `~/.claude/settings.json` (global) ou `.claude/settings.local.json` (projet, non partagé). | L2 |
| Surface de travail | Interface depuis laquelle on interagit avec Claude Code (terminal, IDE, Desktop, mobile, remote control, cloud). | L5 |
| `voice:pushToTalk` | Action de raccourci clavier associée à la dictée, remappable via `/keybindings`. | L2 |

---

## Repères pour la recherche rapide

```text
Je cherche...                              → Aller à

une commande de connexion/déconnexion      → Session & diagnostic / Fermer-déconnecter
une commande liée au micro                 → Dictée vocale
une commande pour vérifier sans modifier   → /doctor, /status, prompt lecture seule
comment éviter qu'une IA élargisse une tâche → /btw (glossaire concepts : Périmètre)
comment changer d'écran / d'appareil       → Surfaces de travail
une commande liée au compte ou au plan     → Compte, veille & feedback
comment annuler une modification           → git checkout --/git restore (concepts : Diff)
comment prouver qu'une tâche est faite     → Définition de terminé / Preuve finale
```

## Phrase à retenir

> Une commande slash pilote le compte ou la session ; le langage naturel pilote le projet — et dans les deux cas, la preuve prime toujours sur le résumé de confiance.
