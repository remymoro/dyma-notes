---
cours: Claude Code
chapitre: 15-mcp-connecter-claude-code-outils
leçon: 03-installer-gerer-premier-serveur-mcp
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Les deux modes de transport MCP ?** | 1. **HTTP** : Le serveur est distant (URL), idéal pour les services en ligne. 2. **stdio** : Le serveur est local (ex: via `npx`), idéal pour l'accès aux fichiers ou au navigateur de la machine. *(SSE est déprécié).* |
| **Comment ajouter un serveur ?** | Via `claude mcp add` depuis le terminal. Ex: `claude mcp add --transport http claude-code-docs https://...` |
| **Portée par défaut ?** | Sans préciser, l'ajout se fait en portée **local** (réglages stockés dans l'utilisateur, spécifiques à ce projet courant, et ignorés par git, contrairement à `.mcp.json`). |
| **Le message "Added" suffit-il ?** | **Non**. "Added" signifie juste "configuration enregistrée". Il faut vérifier si la connexion est réussie (`✓ Connected`) avec `claude mcp list`. |
| **Quelle différence entre `/mcp` et `claude mcp list` ?** | `claude mcp list` se lance dans le **terminal** pour gérer la configuration. `/mcp` s'utilise dans une **session active** de Claude Code pour voir l'état, valider OAuth, etc. |
| **Le cycle de vie complet ?** | Ajouter ➔ Vérifier (`list` / `get`) ➔ Utiliser ➔ Conserver ou Supprimer (`remove`). Ne jamais accumuler les serveurs morts. |

## Synthèse
L'installation d'un serveur MCP dans Claude Code suit un cycle précis : ajout, vérification, utilisation, suppression. Un serveur peut communiquer soit via une URL distante (`http`), soit via un processus local (`stdio`). L'erreur la plus commune est de croire que le message d'ajout garantit la connexion : il faut toujours valider avec `claude mcp list` depuis le terminal, ou via le panneau `/mcp` durant une session. Enfin, privilégier la portée `local` lors des premiers essais évite de polluer le dépôt Git de l'équipe (le fichier `.mcp.json` n'est alors pas créé).

## Glossaire
- **Transport HTTP** : Mode de connexion où Claude Code interroge une adresse web distante pour communiquer avec le serveur MCP.
- **Transport stdio** : Mode de connexion local où Claude exécute directement un programme (ex. `npx`) et discute avec lui via l'entrée/sortie standard de la console.
- **Portée `local`** : Mode d'installation par défaut limitant le MCP à l'utilisateur actuel et au dossier courant, sans altérer les fichiers versionnés.

## Questions d'auto-évaluation
1. Quelles sont les deux grandes méthodes de transport (connexion) pour un serveur MCP ?
2. Quelle commande du terminal permet d'obtenir des détails (erreurs, URL, statut) sur un serveur spécifique ?
3. Pourquoi une vérification `git status` après l'ajout d'un MCP local ne montre-t-elle aucune modification ?
4. Quelle est la différence d'usage entre la commande terminal `claude mcp list` et la commande interne `/mcp` ?

# Installer et gérer un premier serveur MCP

**Durée : 13 minutes**

## Objectif de la leçon
Apprendre le cycle de vie de gestion d'un serveur MCP (ajout, vérification, suppression) en utilisant le serveur officiel de documentation Claude Code. Différencier l'installation via le terminal et la gestion en cours de session.

---

# 1. Les types de serveurs

Il existe deux manières de transporter l'information entre Claude Code et le serveur MCP :

1. **HTTP** : Claude Code se connecte à une URL (ex. Serveur documentaire, Sentry). C'est le transport standard pour le distant.
2. **stdio** : Claude Code lance un sous-programme localement (ex. via `npx` pour Playwright). C'est le standard pour interagir avec votre propre machine.

---

# 2. Cycle de vie : Ajouter et Vérifier

### Ajout depuis le terminal (hors session)
```bash
claude mcp add --transport http claude-code-docs https://code.claude.com/docs/mcp
```
Le serveur est ajouté avec une portée `local` par défaut (rien n'est ajouté au `git`).

### Vérification impérative
L'apparition du mot "Added" ne veut pas dire "Connecté". Il faut lancer :
```bash
claude mcp list
```
On doit chercher le statut **`✓ Connected`**.
En cas de problème (ex. `✗ Connection error` ou `! Needs authentication`), on affine le diagnostic avec :
```bash
claude mcp get claude-code-docs
```

---

# 3. Utilisation et Panneau /mcp

Une fois le serveur ajouté, on lance `claude`. On peut explicitement demander à Claude de l'utiliser : *"Utilise le serveur claude-code-docs pour..."*. 
*Lors du premier appel, Claude demandera une validation de sécurité à l'utilisateur.*

Pendant la session, pour voir ce qui est branché :
👉 Saisissez la commande slash **`/mcp`**
Ce panneau interactif permet de relancer des connexions, faire des validations OAuth ou repérer un serveur tombé en erreur en plein milieu d'une session.

---

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `claude mcp list` | Affiche l'état de tous les serveurs MCP configurés (à lancer depuis le terminal). |
| `claude mcp add ...` | Enregistre un nouveau serveur. |
| `claude mcp get [nom]` | Affiche les détails d'un serveur (URL, statut, erreurs) pour diagnostiquer. |
| `claude mcp remove [nom]` | Supprime l'intégration d'un serveur devenu inutile. |
| `/mcp` | Ouvre le panneau de contrôle au sein d'une session `claude` active. |

# Les 5 points les plus importants

1. Il existe deux transports majeurs : **HTTP** (distant) et **stdio** (local).
2. Ajouter un MCP sans paramètre l'installe en portée **`local`**, ce qui protège le dépôt Git de toute pollution.
3. Le message de succès de `mcp add` confirme l'enregistrement, pas la connexion. Toujours vérifier avec `mcp list`.
4. La commande `/mcp` permet de gérer les serveurs "à chaud", c'est-à-dire depuis l'intérieur d'une session.
5. Il ne faut jamais accumuler des serveurs inactifs : tout serveur inutile doit être supprimé avec `remove`.

---

# Carte mentale

```text
Gestion d'un MCP
├── 1. Ajout (claude mcp add)
│   ├── Transport (HTTP ou stdio)
│   └── Portée (local par défaut, invisible pour git)
├── 2. Vérification
│   ├── claude mcp list (Doit afficher ✓ Connected)
│   └── claude mcp get (Pour analyser les erreurs)
├── 3. Session Active
│   ├── Demander à Claude d'utiliser le serveur
│   ├── Accepter l'autorisation de premier appel
│   └── Gérer via /mcp
└── 4. Nettoyage
    └── claude mcp remove (Éviter les serveurs fantômes)
```

---

# Mini fiche de révision

```text
Transports : HTTP (distant) ou stdio (processus local).
Portée par défaut = local (pas de fichier .mcp.json créé).
"Added" ≠ Connecté. Toujours lancer `claude mcp list`.
Panneau /mcp = Gestion à l'intérieur de la session.
Cycle : Add -> List -> Get (si erreur) -> Utilisation -> Remove (si inutile).
```

> **Phrase à retenir** : Le message "Added" n'est pas une preuve de connexion, c'est `claude mcp list` qui garantit le bon fonctionnement du serveur.
