---
title: "Configurer les règles avec /permissions et les fichiers settings"
description: "Définir les règles de permissions depuis le CLI et les fichiers de configuration."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - permissions
  - configuration
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 03-configurer-regles-permissions-settings
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **À quoi sert `/permissions` ?** | À observer la politique active, identifier la source des règles, et ajouter/retirer interactivement des règles sans toucher au JSON à la main. |
| **Quelles sont les 3 portées de configuration ?** | 1. `~/.claude/settings.json` (utilisateur, global).<br>2. `.claude/settings.json` (projet, partagé en équipe).<br>3. `.claude/settings.local.json` (projet local, non versionné). |
| **Comment les portées se combinent-elles ?** | Les tableaux `allow`/`ask`/`deny` sont concaténés. Un refus (`deny`) dans *n'importe quelle* portée bloque l'action pour tout le monde. |
| **Comment écrire une règle sur un outil ?** | `Tool` (tout l'outil) ou `Tool(specifier)` (usage précis). Il faut toujours utiliser le **nom canonique** de l'outil (ex: `TaskStop` et non `Stop Task`). |
| **Quels sont les pièges des chemins (`Read`/`Edit`) ?** | L'ancrage : `/path` = relatif au projet. `//path` = absolu système. `~/path` = dossier utilisateur. `./path` = relatif au dossier courant. |
| **Pourquoi bloquer `WebFetch` ne suffit pas toujours ?** | Parce que si `Bash` est autorisé, Claude peut lancer `curl` ou `wget`. Les deux surfaces doivent être contrôlées ensemble. |

## Synthèse
L'écriture des règles de permission (sous `permissions.allow/ask/deny`) transforme une décision de sécurité en configuration concrète. Il existe trois niveaux de portée : l'utilisateur (global), le projet (équipe), et le local (machine). Ces portées se fusionnent sans s'écraser, et un `deny` l'emporte toujours. La configuration doit être progressive : observez les commandes récurrentes avec `/permissions`, autorisez des commandes Bash exactes ou des familles bornées (pas de `Bash(*)`), et protégez les chemins sensibles en prêtant attention à l'ancrage (`/` vs `//`). Enfin, gardez à l'esprit que les permissions bloquent l'outil, mais un script arbitraire autorisé par le shell nécessite le sandbox pour être bloqué au niveau système.

## Glossaire
- **`/permissions`** : Commande CLI pour visualiser et gérer interactivement les règles.
- **Portée utilisateur** (`~/.claude/settings.json`) : Pour les préférences personnelles (ex: protéger `~/.ssh`).
- **Portée projet** (`.claude/settings.json`) : Pour l'équipe (ex: autoriser le lint).
- **Portée locale** (`.claude/settings.local.json`) : Exclue de Git, pour les tests ou fixtures locales.
- **`Tool(specifier)`** : Syntaxe de base d'une règle, utilisant obligatoirement le nom canonique.
- **Ancrage `/`** : Chemin relatif à la racine du projet (ex: `/src/**`).
- **Ancrage `//`** : Chemin absolu depuis la racine du système de fichiers.

## Questions d'auto-évaluation
1. Si le fichier projet autorise le linting, mais que mon fichier utilisateur global bloque Node.js, que se passe-t-il ?
2. `Bash(npm *)` est-elle une bonne règle pour commencer un projet ?
3. Le chemin `/Users/alice/secrets` cible-t-il le dossier utilisateur de la machine d'Alice ?
4. Si je bloque `WebFetch(domain:github.com)`, l'agent est-il techniquement incapable de lire une URL github ?

# Configurer les règles de permission

**Durée : 15 minutes**

## Objectif de la leçon
Savoir où placer ses règles (utilisateur, projet, local), maîtriser la syntaxe des outils (`Bash`, `Read`, `WebFetch`, `MCP`), et éviter les erreurs classiques (mauvais ancrage, wildcard trop large, contournement par le shell).

---

# 1. Les trois portées (Scopes) de configuration

Les fichiers `settings.json` peuvent vivre à trois endroits. Les règles de ces fichiers **se concatènent** (s'additionnent). Si un `deny` existe dans un fichier, il bloque l'action, même si un autre fichier l'autorise.

1. **Utilisateur (`~/.claude/settings.json`)** : Vous suit partout. Idéal pour interdire l'accès à vos propres secrets (`~/.ssh`, `~/.aws`).
2. **Projet (`.claude/settings.json`)** : Partagé avec l'équipe via Git. Idéal pour l'allowlist du projet (`npm run lint`, `pytest`).
3. **Local projet (`.claude/settings.local.json`)** : Ignoré par Git. Idéal pour vos exceptions temporaires (fixtures locales).

> [!TIP]
> **Utilisez `/permissions`**
> Plutôt que d'éditer le JSON à la main, lancez `/permissions` dans Claude Code. Vous verrez exactement quelle règle vient de quel fichier, et vous pourrez en ajouter/supprimer interactivement.

---

# 2. Syntaxe des règles : Outils et Spécificateurs

La structure d'une règle est : `Tool` (tout l'outil) ou `Tool(specifier)` (une action précise).
**Attention :** Vous devez utiliser le nom canonique de l'outil, pas le libellé affiché dans l'UI.

### Bash : Le piège de l'espace et du joker
- `Bash(git status)` : Commande exacte (très sûr).
- `Bash(npm run test *)` : Famille bornée (précis).
- `Bash(npm *)` : Trop large.

### Read / Edit : Le piège de l'ancrage
- **`/path`** : Relatif à la racine du projet (ex: `/src/**`).
- **`//path`** : Absolu sur le système (ex: `//Users/alice/file`).
- **`~/path`** : Répertoire de l'utilisateur (ex: `~/.ssh`).
- **`./path`** : Relatif au répertoire courant (là où vous avez lancé Claude).

### WebFetch : Le piège de Bash
- `WebFetch(domain:docs.example.com)` autorise un domaine précis.
- **Attention :** Interdire `WebFetch` ne suffit pas si `Bash` est autorisé. Claude pourrait juste utiliser `curl` ou `wget` dans le terminal. Il faut bloquer les deux.

---

# 3. Ce que ces règles ne font PAS

Ces règles contrôlent si Claude a le droit de *demander à Claude Code d'utiliser un outil*.
- Elles **ne contrôlent pas l'OS**. Si Claude lance un script Python via `Bash`, et que ce script lit un fichier secret, la règle `Read` ne le bloquera pas (car c'est Python qui lit, pas l'outil `Read`). C'est le rôle du `sandbox`.
- Elles **ne fixent pas la posture d'autonomie**. Ça, c'est le rôle des "Modes de permission" vus dans la leçon précédente.

---

# Cartes mentales

```text
               CONFIGURATION DES RÈGLES
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
    UTILISATEUR          PROJET            LOCAL PROJET
 (~/.claude/...)  (.claude/settings)   (.claude/settings.local)
        │                  │                  │
   secrets persos    règles d'équipe    tests persos (gitignore)
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ↓
                   CONCATÉNATION
                 Un seul DENY bloque tout !


                   SYNTAXE DES OUTILS
                           │
      ┌────────────┬───────┴─────┬────────────┐
      ↓            ↓             ↓            ↓
    Bash          Read       WebFetch        MCP
   (attention   (attention   (attention    (attention
    au joker)   à l'ancrage)   à curl)     au nom complet)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice de diagnostic d'une règle (Causes fréquentes)
1. La règle ne s'applique pas      → C'est sûrement le mauvais nom canonique de l'outil.
2. L'action reste bloquée          → Un "deny" est caché dans une autre portée.
3. Le fichier n'est pas ciblé      → Confusion entre / (projet) et // (absolu).
4. Le Web est lu malgré WebFetch   → Il a utilisé "curl" via Bash.
```

> **La phrase centrale de la leçon :**
> Une règle de permission n'est utile que si elle est précise, placée dans la bonne portée (projet ou utilisateur), et exempte de failles de contournement via le shell.
