---
cours: Claude Code
chapitre: 15-mcp-connecter-claude-code-outils
leçon: 04-tester-convertisseur-playwright-mcp
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre Playwright MCP et `npm test` ?** | `npm test` vérifie la logique JS isolée (déterministe). Playwright MCP simule un utilisateur : il clique sur un bouton, vérifie l'affichage de l'erreur dans le DOM et observe la console. |
| **Comment installer Playwright MCP ?** | Mode `stdio` (local) : `claude mcp add playwright -- npx -y @playwright/mcp@latest --isolated` |
| **À quoi sert le `--isolated` ?** | À ne pas polluer l'historique : le navigateur se lance sans conserver de cookies ou de stockage de session précédente. C'est essentiel pour la reproductibilité. |
| **Quels outils l'agent utilise-t-il sous le capot ?** | `browser_navigate` (ouvrir URL), `browser_snapshot` (lire l'arbre d'accessibilité du DOM), `browser_type` (taper), `browser_click` (cliquer). |
| **Comment Claude "voit"-il la page ?** | Il ne regarde pas les pixels, il lit une représentation textuelle structurée (l'arbre d'accessibilité) générée par `browser_snapshot`. On peut demander `browser_take_screenshot` pour une preuve visuelle en bonus. |
| **Quelle différence entre Playwright MCP et `/verify` ?** | Playwright MCP apporte les **capacités techniques** du navigateur (le muscle). `/verify` organise la **procédure** (le cerveau/workflow) et peut s'appuyer sur Playwright. |

## Synthèse
L'intégration de Playwright via MCP donne des yeux et des mains à Claude Code pour tester les applications web comme le ferait un vrai utilisateur (tests E2E exploratoires). Contrairement aux tests unitaires, l'IA ouvre le serveur de développement local (`http://localhost...`), lit l'arbre d'accessibilité pour identifier les champs, tape du texte, clique, et vérifie la console du navigateur. L'installation se fait en mode `stdio` (exécution d'un processus `npx` local) avec l'option `--isolated` pour garantir que chaque test part d'un état vierge. En cas d'erreur de clic ou d'identification, le réflexe est de demander à Claude de reprendre un nouveau snapshot de la page pour actualiser sa vision du DOM.

## Glossaire
- **Playwright MCP** : Serveur MCP de type `stdio` exposant les fonctionnalités de Playwright (contrôle de navigateur) à une IA.
- **Arbre d'accessibilité** : Représentation structurée de l'interface graphique permettant à Claude d'identifier sémantiquement les boutons, champs et textes (via `browser_snapshot`).
- **`--isolated`** : Drapeau essentiel à passer lors du démarrage de Playwright MCP pour assurer que le navigateur ne conserve ni cookies ni stockage local entre les sessions.

## Questions d'auto-évaluation
1. Pourquoi utilise-t-on le séparateur `--` dans la commande d'ajout de Playwright MCP ?
2. Quel outil spécifique est appelé par Claude pour vérifier s'il n'y a pas d'erreurs JS cachées dans le navigateur ?
3. Quelle est la première chose à faire pour déboguer si le serveur Playwright MCP n'apparaît pas comme `Connected` ?
4. Si Claude clique systématiquement au mauvais endroit, quelle instruction lui donner pour corriger sa visée ?

# Tester le convertisseur avec Playwright MCP

**Durée : 11 minutes**

## Objectif de la leçon
Apprendre à installer et configurer un serveur MCP local de type `stdio` (Playwright) et comprendre comment formuler des requêtes pour que Claude Code exécute des tests fonctionnels de bout en bout sur l'interface de développement.

---

# 1. Tests unitaires vs Tests Playwright MCP

Les deux sont complémentaires. 

```text
 ┌───────────────────────┐      ┌─────────────────────────┐
 │ npm test (Unitaires)  │      │ Playwright MCP (E2E)    │
 │                       │      │                         │
 │ - Vérifie la logique  │      │ - Vérifie le DOM        │
 │ - Déterministe        │ ◄──► │ - Simule clics / frappes│
 │ - Rapide              │      │ - Lit la console du web │
 └───────────────────────┘      └─────────────────────────┘
```

Playwright MCP est un serveur **local** (`stdio`). Il est piloté depuis l'ordinateur de l'utilisateur via une commande `npx`.

---

# 2. Installation de Playwright MCP

**Prérequis** : Node.js 18+ (`node --version`) et l'application locale qui tourne (ex. `npm run dev`).

**Commande d'installation** :
```bash
claude mcp add playwright \
  -- npx -y @playwright/mcp@latest --isolated
```

*Décryptage de la commande :*
- `claude mcp add playwright` : Enregistre le serveur sous le nom "playwright".
- `--` : Sépare les options de Claude Code de celles de l'outil sous-jacent.
- `npx -y` : Télécharge et exécute automatiquement sans prompt de confirmation.
- `--isolated` : Lance le navigateur sans historique ni cookies. Indispensable pour des tests fiables.

---

# 3. Le déroulement d'une inspection E2E

Claude ne regarde pas les pixels, il utilise l'arbre d'accessibilité. 
Les appels techniques (`tools`) générés sous le capot sont :
1. `browser_navigate` : va sur `http://localhost:5173`.
2. `browser_snapshot` : lit l'arbre des éléments pour savoir où sont les inputs.
3. `browser_type` : remplit le champ.
4. `browser_click` : appuie sur le bouton.
5. `browser_console_messages` : vérifie qu'aucune erreur JS n'a explosé.

*Remarque* : L'outil `browser_take_screenshot` existe pour fournir une **preuve visuelle** (image), mais l'IA utilise d'abord le **snapshot textuel** pour la navigation.

---

# 4. Diagnostiquer les problèmes

| Problème | Solution |
|---|---|
| Le serveur ne démarre pas (Erreur dans `/mcp`) | Lancez `npx -y @playwright/mcp@latest --isolated` directement dans un terminal normal pour lire les logs d'erreurs Node.js. |
| Le navigateur charge un ancien état | Vérifiez que vous avez bien mis le flag `--isolated` dans la configuration. |
| Claude s'obstine à cliquer au mauvais endroit | Demandez-lui : *"Prends un nouveau snapshot de la page pour ré-identifier le bouton avant de poursuivre"*. |

---

# Tableau des commandes à retenir

| Commande / Outil | Rôle |
|---|---|
| `claude mcp add [nom] -- [cmd]` | Ajoute un serveur local (stdio) en séparant les arguments du sous-processus. |
| `browser_snapshot` | Outil MCP : Extrait l'arbre d'accessibilité DOM pour Claude. |
| `browser_take_screenshot` | Outil MCP : Prend une photo réelle de la page. |

# Les 5 points les plus importants

1. Playwright MCP est un serveur **local** (`stdio`) qui permet de valider le comportement visuel et interactif d'une app web.
2. Toujours séparer les arguments du processus local par un `--` lors de l'ajout du MCP.
3. L'option `--isolated` est vitale pour ne pas polluer les tests avec les cookies des sessions précédentes.
4. Claude s'appuie sur la structure d'accessibilité (le DOM sémantique) pour agir, pas sur l'analyse de pixels purs.
5. Si le serveur MCP ne répond pas, le meilleur diagnostic est de lancer sa commande `npx` dans un terminal classique pour voir l'erreur brute.

---

# Carte mentale

```text
Playwright MCP
├── Type de serveur
│   └── Local (stdio) via npx
├── Rôle
│   ├── Simuler l'utilisateur
│   └── Vérifier DOM et Console
├── Commande clé
│   └── add playwright -- npx -y ... --isolated
├── Outils exposés
│   ├── Navigation (navigate, close)
│   ├── Interaction (type, click)
│   └── Lecture (snapshot, take_screenshot)
└── Résolution des bugs
    ├── npx dans terminal pour logs
    └── Demander un nouveau snapshot si Claude est perdu
```

---

# Mini fiche de révision

```text
Playwright MCP = Serveur local (stdio) pour l'automatisation UI.
Installation : claude mcp add playwright -- npx -y @playwright/mcp@latest --isolated
--isolated = pas de conservation d'état (cookies effacés).
Le robot lit un arbre textuel (browser_snapshot) et non des images.
Si ça bloque : exécuter la commande npx seul dans un terminal.
```

> **Phrase à retenir** : Playwright MCP apporte les outils musculaires du navigateur, tandis qu'une skill (comme /verify) apporte l'organisation du workflow.
