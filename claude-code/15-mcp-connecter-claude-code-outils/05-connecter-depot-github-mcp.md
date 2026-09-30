---
cours: Claude Code
chapitre: 15-mcp-connecter-claude-code-outils
leçon: 05-connecter-depot-github-mcp
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi GitHub MCP si Git est déjà installé ?** | Git local (`git diff`, `git status`) ne voit que les fichiers de la machine. GitHub MCP apporte les données hébergées distantes (Issues, Pull Requests, workflows). |
| **Comment protéger l'authentification ?** | Utiliser un Personal Access Token (PAT) à permissions fines. Il doit être stocké dans une variable d'environnement (ex. `GITHUB_PAT`), JAMAIS en dur dans la configuration versionnée. |
| **Comment configurer le MCP pour un projet ?** | Via un fichier `.mcp.json` à la racine. Claude lira les identifiants d'environnement (`${GITHUB_PAT}`). |
| **Comment forcer la lecture seule ?** | Dans le `.mcp.json`, ajouter les en-têtes `"X-MCP-Readonly": "true"` et filtrer via `"X-MCP-Toolsets": "repos,issues"`. Ainsi, les outils d'écriture ne sont techniquement même pas exposés à l'IA. |
| **Sécurité des dépôts clonés ?** | Quand Claude voit un nouveau serveur dans le `.mcp.json` du projet, il se met en statut `Pending approval`. Il faut l'approuver manuellement dans `/mcp` (évite l'exfiltration silencieuse). |
| **Différence Token vs Toolset ?** | Le **token** (côté GitHub) détermine ce que GitHub *autorise*. Le **toolset** (côté MCP) détermine ce que le serveur *expose* à Claude. Les deux doivent s'aligner. |

## Synthèse
Connecter Claude Code à GitHub permet de combler l'écart entre le code local (git) et les données distantes (issues, PRs). Cette intégration passe par un fichier `.mcp.json` placé à la racine du projet, qui déclare un serveur MCP HTTP. Pour des raisons évidentes de sécurité, le secret d'authentification n'y est jamais écrit en dur mais récupéré via une variable d'environnement (`${GITHUB_PAT}`). De plus, l'application du moindre privilège se fait à deux niveaux : le token GitHub doit avoir des droits très fins (lecture seule), et le serveur MCP doit être contraint via des en-têtes (`X-MCP-Readonly`) pour ne même pas exposer les outils de modification au modèle d'IA.

## Glossaire
- **`.mcp.json`** : Fichier de configuration de serveurs MCP spécifiques à un projet. Peut être versionné (si aucun secret en dur).
- **`X-MCP-Toolsets`** : En-tête permettant de regrouper et filtrer grossièrement les capacités exposées par le serveur GitHub MCP (ex: `repos,issues`).
- **`X-MCP-Readonly`** : En-tête de sécurité qui ampute le serveur MCP de tous ses outils permettant d'altérer des données distantes.
- **Pending approval** : Statut d'un serveur configuré dans le projet qui attend d'être explicitement autorisé par l'utilisateur via le panneau `/mcp`.

## Questions d'auto-évaluation
1. Si l'on souhaite juste lire les issues, pourquoi `git pull` ou `git status` ne suffisent-ils pas ?
2. Quelle précaution indispensable faut-il prendre pour l'en-tête `Authorization` dans le fichier `.mcp.json` ?
3. Quelle est la différence de rôle entre les permissions du Token GitHub et le paramètre `X-MCP-Toolsets` ?
4. Si un serveur reste bloqué, pourquoi la première chose à faire est-elle d'ouvrir `/mcp` ?

# Connecter le dépôt avec GitHub MCP

**Durée : 11 minutes**

## Objectif de la leçon
Apprendre à configurer un serveur distant (HTTP) nécessitant une authentification, via un fichier `.mcp.json` partagé. Mettre en pratique le principe du moindre privilège en couplant un token à permissions fines et la restriction technique des capacités du serveur (lecture seule).

---

# 1. Le duo Git local et GitHub MCP

```text
 ┌───────────────────────┐      ┌─────────────────────────┐
 │ Outils locaux (Git)   │      │ GitHub MCP              │
 │                       │      │                         │
 │ - Fichiers locaux     │      │ - Issues ouvertes       │
 │ - Changements (diff)  │ ◄──► │ - Pull Requests         │
 │ - Branche courante    │      │ - Actions / Workflows   │
 └───────────────────────┘      └─────────────────────────┘
```
MCP **ne remplace pas** Git, il ajoute l'accès à la plateforme web. On peut très bien croiser les deux dans un prompt ("Compare ce diff local avec l'issue GitHub n°12").

---

# 2. Sécuriser et Configurer

La sécurité s'applique en entonnoir :

1. **Le Token (GitHub)** : PAT restreint au dépôt concerné, expirant rapidement, avec accès *Contents* et *Issues* en *Read-only*.
2. **L'Environnement (OS)** : `export GITHUB_PAT="votre_token"`. Jamais dans le code.
3. **Le Serveur (MCP)** : Fichier `.mcp.json` dans le projet :
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PAT}",
        "X-MCP-Toolsets": "repos,issues",
        "X-MCP-Readonly": "true"
      }
    }
  }
}
```

*Résultat* : Même si Claude hallucine et veut créer une issue, l'outil `create_issue` n'existe techniquement plus pour lui (grâce à `X-MCP-Readonly`).

---

# 3. L'approbation de sécurité

Lorsqu'on lance la commande `claude` dans un dossier contenant un `.mcp.json` pour la première fois, le serveur est détecté mais mis en pause (`Pending approval`). 

👉 Il faut l'approuver manuellement via l'interface **`/mcp`**.
C'est un filet de sécurité pour éviter qu'un script malveillant téléchargé n'exfiltre vos données sur un serveur inconnu.

---

# 4. Diagnostic : qui bloque l'accès ?

Si Claude n'arrive pas à utiliser GitHub MCP, remontez la chaîne :

| Symptôme | Cause probable |
|---|---|
| Erreur d'authentification | Variable d'environnement non exportée avant de lancer Claude, ou token expiré. |
| Dépôt inaccessible | Le token a été généré sans la permission d'accès à **ce dépôt** précis. |
| Outils "Issues" invisibles | Manque le droit "Issues" dans le token, ou oubli de "issues" dans `X-MCP-Toolsets`. |
| Le serveur ne fait rien | Il est en `Pending approval`. Ouvrez `/mcp`. |

---

# Tableau des commandes à retenir

| Commande / Fichier | Rôle |
|---|---|
| `export GITHUB_PAT="..."` | Place le secret dans l'environnement de votre terminal de façon éphémère. |
| `.mcp.json` | Fichier de configuration du projet. Peut être commité (si pas de secrets). |
| `test -n "$GITHUB_PAT" ...` | Astuce bash pour vérifier si la variable est bien chargée sans afficher le token. |

# Les 5 points les plus importants

1. GitHub MCP complète Git en fournissant l'accès aux tickets (issues) et au contexte distant hébergé par GitHub.
2. L'authentification se fait via variable d'environnement (`${GITHUB_PAT}`) remplacée à la volée par Claude.
3. Brider le serveur en lui retirant les outils d'écriture (`X-MCP-Readonly`) est plus robuste que de dire à l'IA "ne modifie rien".
4. Un nouveau serveur MCP défini dans un projet nécessite toujours une approbation manuelle via `/mcp` pour démarrer.
5. Si un outil manque, vérifier à la fois les droits du token (ce que GitHub autorise) et les `Toolsets` (ce que le serveur expose).

---

# Carte mentale

```text
Connecter GitHub MCP
├── Configuration (.mcp.json)
│   ├── Serveur HTTP distant
│   └── Authentification via ${GITHUB_PAT}
├── Politique de Sécurité
│   ├── Token GitHub limité (Lecture, Dépôt précis)
│   ├── Toolsets restreints (repos, issues)
│   └── X-MCP-Readonly = true
├── Mise en service
│   ├── 1. Exporter l'environnement
│   ├── 2. Démarrer claude
│   └── 3. Approuver dans /mcp
└── Diagnostic d'erreurs
    ├── Env var absente = Auth Fail
    ├── Token mal scopé = Dépôt invisible
    └── Pending = Validation oubliée
```

---

# Mini fiche de révision

```text
GitHub MCP apporte l'historique et les issues, complétant le `git diff` local.
Configuration dans `.mcp.json` : remplace les secrets via environnement (${VAR}).
Moindre privilège : Token en lecture + X-MCP-Toolsets + X-MCP-Readonly: true.
Sécurité : Les serveurs importés par le projet nécessitent une validation via /mcp.
Règle : "Ne crée rien" est faible. Retirer l'outil d'écriture est fort.
```

> **Phrase à retenir** : Le token détermine ce que GitHub autorise, mais la configuration MCP détermine ce qui est réellement exposé à Claude.
