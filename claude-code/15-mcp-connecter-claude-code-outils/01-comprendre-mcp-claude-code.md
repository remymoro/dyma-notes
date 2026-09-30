---
cours: Claude Code
chapitre: 15-mcp-connecter-claude-code-outils
leçon: 01-comprendre-mcp-claude-code
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Qu'est-ce que MCP ?** | Model Context Protocol. Un standard ouvert permettant à une IA d'interagir avec des outils/données externes (API, DB, Github, navigateur). |
| **Pourquoi utiliser MCP ?** | Évite le copier-coller manuel. Claude peut agir ou lire des données réelles directement depuis la source. |
| **Architecture (3 parties) ?** | 1. **Client** (Claude Code) : utilise les capacités. 2. **Serveur** (GitHub MCP) : expose les capacités au format standardisé. 3. **Service externe** (GitHub) : fournit la donnée/action. |
| **Les 3 capacités exposées ?** | 1. **Tools** (opérations exécutables par Claude). 2. **Resources** (données en lecture seule, appelables via `@`). 3. **Prompts** (modèles de requêtes déclenchés par l'utilisateur). |
| **Différence Tool / Skill / MCP ?** | **Outil intégré** = local (lire fichier). **Skill** = workflow (procédure interne). **MCP** = système externe (GitHub, DB). *Note : une skill peut utiliser MCP pour s'exécuter.* |
| **Vérification et sécurité ?** | Lister avec `claude mcp list` (terminal) ou `/mcp`. Les permissions restent vitales car un MCP peut modifier des services et introduire du code malveillant. |

## Synthèse
Le protocole MCP (Model Context Protocol) est un pont standardisé qui permet à Claude Code de se connecter à des services externes comme GitHub ou un navigateur sans avoir à recourir à des copier-coller manuels. Il fonctionne via une architecture à trois tiers (client, serveur MCP, service distant) et expose trois grands types de capacités : les *tools* (actions), les *resources* (données) et les *prompts* (modèles). La sécurité et la limitation du périmètre d'action de ces serveurs restent des priorités absolues.

## Glossaire
- **MCP (Model Context Protocol)** : Standard ouvert pour connecter l'IA à des sources de données et outils externes.
- **Serveur MCP** : Programme intermédiaire exposant de manière standardisée et sécurisée certaines capacités d'un service distant.
- **Resource (MCP)** : Donnée en lecture seule ajoutée comme contexte, souvent identifiée par une URI et utilisable via l'autocomplétion `@`.
- **Tool (MCP)** : Fonction déclenchable par Claude Code pour exécuter une opération externe.

## Questions d'auto-évaluation
1. Quelles sont les 3 parties de l'architecture d'une intégration MCP ?
2. Quelle est la différence entre une `resource` et un `tool` dans le contexte MCP ?
3. Comment affiche-t-on les serveurs MCP configurés depuis l'interface de Claude Code ?
4. Une *skill* et un serveur *MCP* ont-ils le même but ?

# Comprendre MCP dans Claude Code

**Durée : 17 minutes**

## Objectif de la leçon
Comprendre le fonctionnement et l'utilité du protocole MCP pour briser l'isolation locale de Claude Code. Savoir distinguer les trois types de capacités offertes (tools, resources, prompts) et faire la différence avec les outils natifs et les skills.

---

# 1. Architecture du Model Context Protocol (MCP)

```text
 ┌──────────────┐          ┌─────────────┐          ┌─────────────────┐
 │ CLIENT       │          │ SERVEUR MCP │          │ SERVICE EXTERNE │
 │ (Claude Code)│ ───────► │ (ex: GitHub)│ ───────► │ (Base de données│
 │              │ protocole│             │ API      │  ou navigateur) │
 └──────────────┘   MCP    └─────────────┘          └─────────────────┘
```

Claude Code n’accède pas librement à tout le service externe : il ne voit **que** ce que le serveur MCP choisit d'exposer via une interface standardisée. 

---

# 2. Les trois grandes capacités exposées

1. **Tools** : Fonctions exécutables par Claude (ex: ouvrir une issue). Le modèle décide seul de les appeler, bien qu'une confirmation utilisateur puisse être requise.
2. **Resources** : Données en lecture seule, appelables avec `@` (ex: `@github:issue://123`).
3. **Prompts** : Modèles de commandes réutilisables, déclenchés explicitement par l'utilisateur via une commande slash (ex: `/mcp__github__list_prs`).

---

# 3. Ce qui nécessite (ou non) MCP

Il ne faut pas tout déporter dans MCP. Le dépôt local est géré nativement.
* **Outils intégrés** : lire un fichier local, éditer, exécuter `npm test` dans le terminal.
* **Skills** : Dicter une méthode de travail (ex: workflow de revue de dette technique).
* **MCP** : Actions hors-dépôt (manipuler un navigateur Playwright, interroger PostgreSQL, lire une issue GitHub).

> **En résumé** : La *skill* décrit **la procédure**. Le *serveur MCP* fournit **le moyen technique externe** pour l'accomplir.

---

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `claude mcp list` | Affiche l'état et la liste des serveurs MCP depuis le terminal classique. |
| `/mcp` | Ouvre le panneau de contrôle MCP à l'intérieur d'une session Claude Code. |

# Les 5 points les plus importants

1. MCP évite les copier-coller manuels depuis des applications tierces vers la session IA.
2. L'architecture repose sur un Client (Claude), un Serveur MCP (l'intermédiaire), et le Service Externe.
3. Les serveurs limitent et filtrent finement les droits d'accès à l'API du service externe.
4. Les capacités sont divisées en `tools` (actions), `resources` (données lues via `@`) et `prompts`.
5. La sécurité est cruciale : un MCP externe peut injecter du code malveillant, il faut donc valider les outils sensibles.

---

# Carte mentale

```text
MCP dans Claude Code
├── Utilité
│   ├── Automatiser l'accès externe
│   └── Remplacer le copier-coller
├── Architecture
│   ├── Client (Claude Code)
│   ├── Serveur MCP (Filtre / Standard)
│   └── Service Externe (Navigateur, API)
├── Capacités
│   ├── Tools (Actions exécutées par le modèle)
│   ├── Resources (Données en lecture seule via @)
│   └── Prompts (Modèles via commandes /slash)
└── Complémentarité
    ├── Outil local = Fichiers et Terminal
    ├── Skill = Workflow et procédures
    └── MCP = Extension vers l'extérieur
```

---

# Mini fiche de révision

```text
MCP (Model Context Protocol) connecte l'IA au monde extérieur.
Client -> Serveur MCP -> Service Externe.
Offre 3 choses : Tools (actions), Resources (données @), Prompts (templates /).
Différence : Outil = Local | Skill = Procédure | MCP = Externe.
Commandes : claude mcp list ou /mcp.
```

> **Phrase à retenir** : La skill définit la procédure, le serveur MCP fournit le moyen technique externe pour l'exécuter.
