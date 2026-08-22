# Portée de la configuration

*Claude : fondations → 8. Personnalisation et configuration de l'interface → 1. Portée de la configuration*

## Idée principale

Configurer Claude Code ne consiste pas seulement à choisir une option.

Il faut surtout déterminer :

- **où** le réglage s'applique ;
- **qui** est concerné ;
- **si** le réglage doit être partagé ;
- **si** le réglage peut être contourné.

La question principale à se poser est donc :

> **Qui doit être affecté par ce réglage, et avec quel niveau d'autorité ?**

---

## 1. Configuration ≠ Prompt

Un **prompt** donne une instruction ponctuelle à Claude.

```text
Analyse mon projet et cherche les erreurs TypeScript.
```

La **configuration** définit l'environnement dans lequel Claude Code travaille.

```json
{
  "theme": "dark",
  "permissions": {
    "deny": ["Read(./.env)"]
  }
}
```

Elle peut contrôler l'interface, le modèle, les permissions, les hooks, les plugins, les variables d'environnement, le sandbox, les outils, la mémoire et le comportement de la session.

```text
CONFIGURATION
     ↓
Définit les règles de l'environnement
     ↓
CLAUDE CODE
     ↓
Prompt utilisateur
     ↓
Travail de Claude
```

---

## 2. Les 5 portées principales

| Portée | Emplacement | Concerne |
|---|---|---|
| Managed | `managed-settings.json` | Toute l'organisation |
| CLI | `--settings` | Une seule exécution |
| Local | `.claude/settings.local.json` | Moi dans ce projet |
| Project | `.claude/settings.json` | Toute l'équipe |
| User | `~/.claude/settings.json` | Moi dans tous mes projets |

```text
Moi partout
→ ~/.claude/settings.json

Toute l'équipe sur ce projet
→ .claude/settings.json

Moi uniquement sur ce projet
→ .claude/settings.local.json

Toute l'organisation
→ Managed settings

Une seule exécution
→ CLI / --settings
```

---

## 3. Portée utilisateur — `~/.claude/settings.json`

Ce fichier contient les préférences personnelles qui doivent s'appliquer dans tous les projets.

Sous Windows :

```text
%USERPROFILE%\.claude\settings.json
```

Exemple :

```json
{
  "theme": "dark",
  "editorMode": "vim",
  "verbose": false
}
```

On peut notamment y placer le thème, le mode d'édition, le modèle préféré, la ligne d'état, certaines variables d'environnement et des préférences de plugins.

**À retenir :**

```text
~/.claude/settings.json
= Moi + tous mes projets
```

---

## 4. `settings.json` et `.claude.json`

Il ne faut pas confondre :

- `~/.claude/settings.json` : paramètres configurables (`permissions`,
`hooks`, `env`, `theme`, `verbose`, etc.).
- `~/.claude.json` : état interne de Claude Code (OAuth, confiance des
projets, certains MCP, outils approuvés, caches, etc.).

```text
Configuration utilisateur
→ ~/.claude/settings.json

État interne de Claude Code
→ ~/.claude.json
```

---

## 5. Portée projet — `.claude/settings.json`

Ce fichier se trouve dans le dépôt et contient la configuration commune à toute l'équipe. Il doit généralement être versionné avec Git.

```text
mon-projet/
├── src/
├── package.json
└── .claude/
    └── settings.json
```

Exemple :

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)"
    ],
    "deny": [
      "Read(./.env)"
    ]
  }
}
```

On peut y placer les permissions communes, hooks partagés, plugins nécessaires, commandes autorisées et restrictions de lecture.

**À retenir :**

```text
.claude/settings.json
= Toute l'équipe + ce projet
```

---

## 6. Répertoire de démarrage

Les paramètres projet de `.claude/settings.json` sont liés au répertoire depuis lequel Claude Code est lancé.

```text
monorepo/
├── .claude/
│   └── settings.json
├── frontend/
└── backend/
```

Cette logique diffère de celle de `CLAUDE.md`, qui peut être chargé selon une logique d'ancêtres et de sous-répertoires.

**À retenir :**

```text
settings.json
→ configuration attachée au point de lancement
```

---

## 7. Portée locale — `.claude/settings.local.json`

Ce fichier contient les réglages personnels d'un développeur pour un projet précis.

Exemple :

```json
{
  "enabledPlugins": {
    "experimental-reviewer@team-tools": false
  }
}
```

Il peut servir à désactiver localement un plugin, ajouter un chemin propre à la machine, tester un hook ou adapter Claude Code à son environnement.

Ce fichier ne doit normalement **pas être versionné** et doit être ignoré par Git.

**À retenir :**

```text
.claude/settings.local.json
= Moi + ce projet uniquement
```

---

## 8. Paramètres gérés — Managed settings

Les paramètres gérés correspondent à une politique d'organisation.

Ils servent notamment à imposer des règles de sécurité, des restrictions d'outils, un sandbox, des MCP autorisés, des restrictions de plugins ou des permissions non contournables.

```json
{
  "permissions": {
    "deny": [
      "Read(**/.env*)",
      "Bash(rm -rf *)"
    ]
  }
}
```

**À retenir :**

```text
Managed settings
= Politique de l'organisation
```

Une politique gérée n'est pas une préférence : elle est destinée à ne pas pouvoir être contournée par les couches inférieures.

---

## 9. Emplacements des paramètres gérés

### Linux / WSL

```text
/etc/claude-code/managed-settings.json
```

### macOS

```text
/Library/Application Support/ClaudeCode/managed-settings.json
```

### Windows

```text
C:\Program Files\ClaudeCode\managed-settings.json
```

Windows peut également utiliser des politiques dans le registre.

---

## 10. `managed-settings.d`

Les organisations peuvent séparer leurs politiques dans plusieurs fichiers :

```text
managed-settings.d/
├── 10-security.json
├── 20-sandbox.json
└── 30-telemetry.json
```

Les fichiers sont triés alphabétiquement puis fusionnés.

Cela permet de séparer les domaines de responsabilité : sécurité, sandbox, télémétrie, etc.

---

## 11. Configuration CLI

Une configuration peut être appliquée temporairement pour une seule exécution.

```bash
claude --settings '{"verbose":true}'
```

```text
Besoin temporaire
→ CLI

Besoin permanent
→ fichier de configuration
```

---

## 12. Ordre de priorité

C'est l'un des points les plus importants du cours.

```text
PLUS PRIORITAIRE

1. Managed settings
        ↓
2. CLI
        ↓
3. .claude/settings.local.json
        ↓
4. .claude/settings.json
        ↓
5. ~/.claude/settings.json

MOINS PRIORITAIRE
```

À mémoriser :

```text
Managed > CLI > Local > Project > User
```

---

## 13. Exemple de priorité

Utilisateur :

```json
{
  "verbose": false
}
```

Projet :

```json
{
  "verbose": true
}
```

Le projet étant plus prioritaire que l'utilisateur :

```text
verbose = true
```

Si le fichier local définit ensuite :

```json
{
  "verbose": false
}
```

alors le local l'emporte sur le projet :

```text
verbose = false
```

---

## 14. Fusion et remplacement

### Valeurs simples

Les valeurs scalaires comme `theme`, `verbose`, `viewMode` ou `model` sont généralement remplacées par la valeur provenant de la couche la plus prioritaire.

### Tableaux

Certaines listes, notamment des permissions, sont concaténées et dédupliquées entre plusieurs couches.

```text
User : règle A
+
Project : règle B
=
A + B
```

---

## 15. `deny` est prioritaire sur `allow`

Pour les permissions :

> **Un refus l'emporte sur une autorisation.**

```json
{
  "permissions": {
    "deny": [
      "Read(./secrets/**)"
    ],
    "allow": [
      "Read(./secrets/example.txt)"
    ]
  }
}
```

Il ne faut pas compter sur `allow` pour contourner un `deny`.

```text
DENY > ALLOW
```

---

## 16. Ce que la configuration peut contrôler

### Interface et rendu

La configuration peut agir sur :

- le thème ;
- l'affichage ;
- la verbosité ;
- le terminal ;
- le défilement ;
- le mode d'édition ;
- la barre de progression ;
- la ligne d'état.

### Comportement de session

Elle peut également agir sur :

- le modèle ;
- le modèle de secours ;
- la mémoire ;
- la compaction automatique ;
- les checkpoints ;
- le nettoyage des sessions ;
- les notifications ;
- le contrôle à distance.

### Outils et automatisations

Elle peut contrôler :

- les permissions ;
- les hooks ;
- les plugins ;
- les variables d'environnement ;
- le sandbox ;
- certains accès aux outils.

---

## 17. `CLAUDE.md` ≠ `settings.json`

### `CLAUDE.md`

Contient les instructions expliquant **comment Claude doit travailler**.

```text
Utilise TypeScript strict.
Respecte l'architecture hexagonale.
Explique les changements importants.
```

### `settings.json`

Configure **dans quelles règles et quel environnement Claude Code travaille**.

```json
{
  "permissions": {
    "deny": ["Read(./.env)"]
  }
}
```

Résumé :

```text
CLAUDE.md
→ Instructions

settings.json
→ Configuration et contrôle
```

---

## 18. Validation avec `$schema`

Il est recommandé d'ajouter :

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
```

Cela permet notamment l'autocomplétion et la validation dans les éditeurs compatibles.

Les fichiers utilisateur, projet et locaux sont stricts : une erreur de validation peut faire rejeter le fichier. Les paramètres gérés sont plus tolérants et peuvent ignorer une entrée invalide tout en conservant les autres politiques valides.

---

## 19. Commandes de diagnostic

```text
/config
/status
/permissions
/mcp
```

Et :

```bash
claude doctor
```

- `/config` : afficher ou modifier certaines options.
- `/status` : voir les sources de configuration actives.
- `/permissions` : inspecter les permissions et leur origine.
- `/mcp` : inspecter les serveurs MCP.
- `claude doctor` : diagnostiquer les problèmes de configuration.

---

## 20. `CLAUDE_CONFIG_DIR`

La variable `CLAUDE_CONFIG_DIR` permet de déplacer le répertoire normalement situé dans `~/.claude`.

```bash
CLAUDE_CONFIG_DIR=/opt/claude-user-config claude
```

Elle peut être utile pour les tests, conteneurs, environnements isolés ou profils de configuration séparés.

---

## 21. WSL

Sous WSL, les paramètres gérés basés sur fichier sont normalement lus depuis :

```text
/etc/claude-code/managed-settings.json
```

Les politiques Windows ne sont pas forcément héritées automatiquement.

Le paramètre géré suivant permet l'héritage :

```json
{
  "wslInheritsWindowsSettings": true
}
```

---

## 22. Structure correcte d'un projet

```text
mon-projet/
│
├── CLAUDE.md
├── .mcp.json
│
└── .claude/
    ├── settings.json
    ├── settings.local.json
    ├── skills/
    ├── agents/
    ├── commands/
    └── rules/
```

Rôles :

```text
CLAUDE.md
→ instructions du projet

.mcp.json
→ serveurs MCP du projet

.claude/settings.json
→ configuration partagée avec l'équipe

.claude/settings.local.json
→ configuration personnelle locale

skills/
→ compétences

agents/
→ agents spécialisés

commands/
→ commandes

rules/
→ règles
```

---

## 23. Règle de décision

### Moi, dans tous mes projets

```text
~/.claude/settings.json
```

### Toute l'équipe, dans ce projet

```text
.claude/settings.json
```

### Moi uniquement, dans ce projet

```text
.claude/settings.local.json
```

### Toute l'organisation, sans contournement

```text
Managed settings
```

### Une seule exécution

```text
--settings
```

---

## Fiche de révision

| Besoin | Emplacement |
|---|---|
| Mes préférences partout | `~/.claude/settings.json` |
| Configuration commune du projet | `.claude/settings.json` |
| Mes préférences sur un seul projet | `.claude/settings.local.json` |
| Politique d'entreprise | Managed settings |
| Réglage temporaire | CLI / `--settings` |

### Pyramide de priorité

```text
              MANAGED
          priorité maximale
                 │
                 ▼
                CLI
                 │
                 ▼
               LOCAL
                 │
                 ▼
              PROJECT
                 │
                 ▼
                USER
          priorité minimale
```

```text
Managed > CLI > Local > Project > User
```

---

## Résumé final

Claude Code utilise un **système de configuration hiérarchique**.

Le plus important n'est pas uniquement de connaître les clés JSON, mais de savoir **où les placer**.

La question à toujours se poser est :

> **Qui doit être concerné par ce réglage, et avec quel niveau d'autorité ?**

```text
Moi partout
→ User

Toute l'équipe
→ Project

Moi dans ce projet
→ Local

Toute l'organisation
→ Managed

Une seule session
→ CLI
```

Pour les permissions :

```text
DENY > ALLOW
```

C'est le principe essentiel à retenir pour comprendre la portée de configuration de Claude Code.
