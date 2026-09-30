Comprendre le fonctionnement d'un sous-agent
Un sous-agent est une instance spécialisée. La conversation principale définit l'objectif (mission : ex. "Relis l'authentification"), et le profil du sous-agent définit sa manière de travailler (modèle, outils, permissions, instructions système).

Comprendre ce que reçoit le sous-agent
Un sous-agent normal commence avec un contexte "frais".
- **Il reçoit** : Prompt système du profil, mission formulée, dossier courant, outils/permissions résolus, instructions projet. *(Les profils personnalisés chargent normalement `CLAUDE.md` et l'état `Git`, contrairement à `Explore` et `Plan`)*.
- **Il NE reçoit PAS** : L'historique complet, les fichiers déjà lus par le parent, les résultats d'outils du parent, les skills déjà invoquées.
La qualité de la délégation est essentielle (donner les choix validés, les valeurs par défaut, les fichiers autorisés...).

Comprendre les restrictions d'un sous-agent
- Un sous-agent ne peut pas utiliser l'outil `Agent` (pas de sous-sous-agents).
- S'il s'exécute en arrière-plan, il ne peut pas bloquer la session principale avec `AskUserQuestion`. Donnez-lui le comportement en cas d'ambiguïté.

Distinguer l'objectif et le profil
- L'objectif : Spécifique à une exécution, contient les noms de fichiers/tickets, change à chaque invocation.
- Le profil : Réutilisable, décrit une spécialité (rôle durable), chargé depuis une config.

Comprendre le format d'un profil
Fichier `.md` contenant un frontmatter YAML (configuration) et un corps Markdown (prompt système du sous-agent).
```yaml
---
name: security-reviewer
description: Relit les changements touchant l'authentification.
model: inherit
tools: Read, Grep, Glob
color: red
---
Tu es un relecteur de sécurité...
```

Structurer l'identité
- `name` (minuscules et tirets).
- `description` : Indique quand déléguer. **Doit contenir le déclencheur**, pas juste la compétence.
- `color` : Identifie visuellement.

Configurer le modèle et l'effort
- `model` : `inherit`, `haiku`, `sonnet`, `opus`. (Sans modèle, utilise `inherit` du parent).
- `effort` : `low`, `medium`, `high`, `xhigh`, `max`.
- `maxTurns` : Entier positif.

Configurer les outils et permissions
- `tools` : Liste d'autorisation (`Read, Grep...`).
- `disallowedTools` : Retire du pool. (Appliqué en premier, puis `tools` résout les restants). *Ne listez pas `Agent` !*
- `permissionMode` : `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`, `auto`. (Le mode du parent peut primer, ex: s'il est en `acceptEdits`).

Ajouter des capacités
- `skills` : précharge le contenu de skills.
- `mcpServers` : ajoute des serveurs.
- `hooks` : automatismes.
- `memory` : active mémoire (`user`, `project`, `local`).
- `isolation` : `worktree` (copie isolée).
- `background` : `true` (impose arrière-plan).
*(Permissions, mcp et hooks sont ignorés si distribués via un plugin).*

Choisir la portée et la priorité
1. Organisation (Paramètres gérés)
2. `--agents` (Session courante)
3. `.claude/agents/` (Projet)
4. `~/.claude/agents/` (Utilisateur)
5. Dossier `agents/` d'un plugin
*Si même nom, la priorité la plus haute (1) l'emporte.*

Créer un profil
- Via `/agents` : Ouvre l'interface de gestion (onglet Library) pour créer/générer.
- Manuellement : Fichiers MD. Exemple d'agent isolé : `permissionMode: acceptEdits`, `isolation: worktree`, `background: true`.
- Définition temporaire (JSON) : `claude --agents '{"quick-reviewer": {"prompt": "...", "model": "haiku"}}'` (disparaît à la fin).
