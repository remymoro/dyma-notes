---
cours: Claude Code
chapitre: 16-projet-partie-2-skills-mcp
leçon: 01-fonctionnalites-serveur-mcp-github
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quel est le parcours de travail (workflow) cible du projet ?** | 1. Lire le ticket de spec (via MCP). 2. Coder en étant guidé (via la skill). 3. Valider en local. 4. Ouvrir la PR (via MCP). |
| **Quelles permissions exactes donner au token GitHub ?** | Scope restreint à un seul dépôt. Droits : Metadata (Read), Contents (Read), Issues (Read & Write), Pull Requests (Read & Write). Durée courte (ex: 30j). |
| **Comment déclarer proprement le jeton sans le fuiter ?** | Le `.mcp.json` (versionné) référence la variable : `"Authorization": "Bearer ${GITHUB_PAT}"`. La valeur réelle vit soit dans le shell (`export`), soit dans `.claude/settings.local.json` (strictement ignoré par git). |
| **Le fichier `.claude/settings.local.json` gère-t-il l'expansion de variables ?** | **Non**. Les valeurs y sont inscrites en clair (littérales). Conséquence : il ne faut jamais l'ouvrir en stream/démo, et il doit être dans le `.gitignore` dès le premier commit. |
| **Comment vérifier de façon sûre que la connexion marche ?** | Le fichier `.mcp.json` n'est pas une preuve. La vraie preuve est dans `/mcp` ou en demandant à Claude : "Vérifie que tu es connecté sans rien modifier et donne le compte associé". |
| **Comment encadrer les outils GitHub MCP ?** | Dans `.claude/settings.json`, on ajoute le bloc `"permissions": { "ask": [ "mcp__github" ] }`. Cela force Claude à demander votre permission avant chaque appel, évitant la création sauvage de branches. |

## Synthèse
Cette leçon pose les fondations du parcours complet du développeur assisté par Claude Code : lire un ticket (via MCP), implémenter la feature (via une skill), et créer une Pull Request (via MCP). Pour que la communication avec GitHub fonctionne de manière sécurisée, on génère un jeton à accès très fin (uniquement lecture de code, et écriture pour issues/PR). Ce jeton n'est jamais écrit dans le `.mcp.json` (qui utilise l'expansion `${GITHUB_PAT}`), mais soit injecté par le shell, soit inscrit en clair dans un fichier de configuration locale (`.claude/settings.local.json`) impérativement ignoré par Git. Enfin, une politique de permissions en mode `ask` sur les outils GitHub garantit que Claude ne prendra pas d'initiatives non désirées sur le dépôt distant.

## Glossaire
- **Fine-grained token (PAT)** : Jeton d'accès personnel GitHub qui permet de cibler précisément un seul dépôt et des droits spécifiques, contrairement aux anciens tokens globaux.
- **`.claude/settings.local.json`** : Fichier de configuration propre à la machine locale, destiné à stocker les variables d'environnement en clair. Doit être systématiquement ignoré dans `.gitignore`.
- **Expansion de variable** : Remplacement à la volée de la syntaxe `${VAR}` par sa valeur réelle, fonctionnant dans `.mcp.json` mais **pas** dans les fichiers de configuration de Claude Code.

## Questions d'auto-évaluation
1. Quelles sont les 4 étapes du "parcours cible" que nous voulons automatiser avec Claude Code ?
2. Pourquoi faut-il cocher "Read and Write" sur les permissions *Issues* et *Pull Requests* du token GitHub ?
3. Quelle est la principale différence de comportement concernant les variables entre `.mcp.json` et `.claude/settings.local.json` ?
4. Comment obliger Claude à demander la permission avant de créer une Pull Request ?

# Présentation des fonctionnalités et mise en place du serveur MCP GitHub

**Durée : 15 minutes**

## Objectif de la leçon
Brancher et sécuriser le serveur MCP GitHub avec des droits d'écriture limités pour accomplir un cycle de développement complet (de l'issue à la Pull Request), tout en isolant le secret d'authentification en dehors du gestionnaire de version.

---

# 1. Le parcours cible (Workflow)

```text
 1. TICKET (Specs)   ──►  GitHub MCP lit le ticket
         │
         ▼
 2. DÉVELOPPEMENT    ──►  Une Skill guide la rédaction du code
         │
         ▼
 3. VALIDATION       ──►  Tests et exécution locale (Outils intégrés)
         │
         ▼
 4. PULL REQUEST     ──►  GitHub MCP crée la PR avec les modifications
```
*Le ticket devient le véritable point de vérité partagé, remplaçant la longue description lachée dans le prompt.*

---

# 2. Sécuriser l'accès avec un Token ciblé

L'objectif est d'autoriser la lecture du code et l'écriture des tickets/PRs, mais uniquement sur le dépôt du projet.

**Génération (GitHub > Developer Settings > Fine-grained tokens)** :
- **Expiration** : 30 jours (courte)
- **Repository access** : `Only select repositories` (ex: `claudoscope`)
- **Permissions** :
  - *Metadata* : Read-only
  - *Contents* : Read
  - *Issues* : Read and write
  - *Pull requests* : Read and write

---

# 3. Isolation du Secret

Le fichier partagé avec l'équipe (`.mcp.json`) contient la plomberie mais pas l'eau (le secret).

**1. Dans `.mcp.json` (Versionné)** :
On utilise l'expansion de variable. Claude s'occupera de la résolution.
```json
"Authorization": "Bearer ${GITHUB_PAT}"
```

**2. Dans `.claude/settings.local.json` (Privé / Ignoré par Git)** :
Ce fichier injecte les variables dans l'environnement de Claude Code.
*Attention : les valeurs ici sont strictement littérales, pas d'expansion.*
```json
{
  "env": {
    "GITHUB_PAT": "ghp_mOn_Vrai_ToK3n_S3crEt"
  }
}
```
⚠️ **Règle d'or** : Le fichier `settings.local.json` doit être dans le `.gitignore` avant même le premier commit.

---

# 4. Cadrage des permissions

Même avec le meilleur token, Claude pourrait essayer de créer 15 branches par erreur. 
Dans `.claude/settings.json` (le fichier global du projet), on impose une validation humaine (`ask`) sur les outils du serveur GitHub.

```json
{
  "permissions": {
    "ask": [
      "mcp__github"
    ]
  }
}
```
Commencer par un filet de sécurité large (`ask`) permet d'observer le comportement de l'IA pendant les premières sessions et d'éviter les catastrophes sur le dépôt distant.

---

# Tableau des commandes à retenir

| Instruction / Prompt | Rôle |
|---|---|
| `${VAR:-defaut}` | Syntaxe de variable avec valeur de repli utilisable dans `.mcp.json`. |
| *"Ne modifie rien. Vérifie que le serveur GitHub est connecté. Indique le compte associé."* | Prompt de test très sûr pour valider que toute la chaîne d'authentification MCP fonctionne sans risque. |

# Les 5 points les plus importants

1. Le parcours idéal délègue la lecture des specs et la création de PR au serveur GitHub MCP.
2. Le token doit être chirurgical : restreint à un seul dépôt, avec des droits d'écriture isolés sur les Issues et les PRs.
3. Le fichier `.mcp.json` supporte l'expansion de variables (`${VAR}`), ce qui permet de le versionner proprement.
4. Les fichiers internes comme `.claude/settings.local.json` prennent les valeurs au sens propre (en clair) et ne doivent jamais être versionnés ou affichés en live.
5. On sécurise les initiatives de Claude avec une politique `ask` pour tout appel au serveur `mcp__github`.

---

# Carte mentale

```text
Mise en place de GitHub MCP (Écriture)
├── Workflow visé
│   └── Ticket -> Dev par Skill -> Tests -> PR
├── Le Token (PAT Fine-grained)
│   ├── Restreint au Dépôt
│   └── Droits : Code(R) / Issues(RW) / PR(RW)
├── Isolation du secret
│   ├── .mcp.json (Git = OUI) : ${GITHUB_PAT}
│   └── settings.local.json (Git = NON) : "valeur_en_clair"
└── Cadrage des Outils
    └── settings.json : "ask": ["mcp__github"]
```

---

# Mini fiche de révision

```text
Parcours : Lire ticket MCP -> Skill -> Validation -> PR MCP.
Sécurité Token : Dépôt unique, Code en lecture, Issues/PR en écriture.
Sécurité Fichiers :
  - .mcp.json (Partagé) : variables autorisées (${VAR}).
  - settings.local.json (Privé) : secret en clair, à .gitignorer d'urgence.
Sécurité Exécution : Mettre "ask" sur "mcp__github" pour confirmer chaque PR ou ticket.
```

> **Phrase à retenir** : Le fichier partagé contient la variable (`${VAR}`), le fichier local contient le secret en clair ; on versionne l'un, on cache l'autre.
