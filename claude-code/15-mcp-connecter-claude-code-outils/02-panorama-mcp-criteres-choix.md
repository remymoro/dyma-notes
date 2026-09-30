---
cours: Claude Code
chapitre: 15-mcp-connecter-claude-code-outils
leçon: 02-panorama-mcp-criteres-choix
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la règle d'or d'installation ?** | Ne pas installer un MCP "au cas où" ou parce qu'il est populaire. Installer uniquement s'il supprime une friction (ex: copier/coller répétitif). |
| **Quelles sont les 8 grandes familles de MCP ?** | 1. Dépôts/gestion (GitHub, Linear), 2. Navigateurs (Playwright), 3. Documentation (Notion), 4. Observabilité (Sentry), 5. BDD/Backend (Supabase), 6. Design (Figma), 7. Services métiers (Stripe), 8. Cloud/Infra (AWS). |
| **Pourquoi utiliser le mode "Lecture seule" ?** | Réduit drastiquement le risque. Un MCP peut introduire du code malveillant ou modifier des données. GitHub MCP, par exemple, permet de désactiver les outils d'écriture. |
| **Quels sont les 3 MCP retenus pour le projet du cours ?** | 1. **Documentation Claude Code** (recherche d'infos à jour). 2. **Playwright MCP** (inspection et manipulation du convertisseur dans le navigateur). 3. **GitHub MCP** (accès aux issues et commits). |
| **Quels critères de sécurité évaluer ?** | Le serveur est-il officiel ? Quelles données seront accessibles ? Y a-t-il une authentification stricte (OAuth, clé restreinte) ? L'action est-elle facilement réversible ? |

## Synthèse
L'écosystème MCP regorge d'outils, mais il est contre-productif de tous les connecter. Un serveur ne doit être ajouté que pour supprimer une friction manuelle claire (comme copier des issues ou naviguer dans une maquette Figma). Parmi les nombreuses catégories (code, design, bases de données, paiements), il est primordial de toujours appliquer un principe de sécurité : vérifier la source, utiliser des clés restreintes, privilégier le mode lecture seule au départ, et limiter l'étendue des données accessibles. 

## Glossaire
- **Playwright MCP** : Serveur d'automatisation de navigateur permettant à Claude d'inspecter ou d'interagir avec une application web (utile pour tester des flux réels).
- **GitHub MCP** : Serveur permettant l'interaction avec le dépôt distant (issues, commits). Il peut être configuré de manière modulaire (seulement lecture, seulement certains groupes d'outils).
- **Friction réelle** : Tâche manuelle et répétitive (ex. faire des copier-coller) justifiant l'installation d'un outil ou MCP pour la supprimer.

## Questions d'auto-évaluation
1. Pourquoi est-il déconseillé d'installer un MCP Stripe "pour tester" dans un petit projet ?
2. Quels sont les trois serveurs MCP qui seront utilisés pour le projet de convertisseur ?
3. Que permet de faire un serveur comme Playwright MCP par rapport à un outil de test natif (`npm test`) ?
4. Quelles sont les 4 étapes logiques pour intégrer un MCP (de l'identification du besoin à la validation) ?

# Panorama des MCP courants et critères de choix

**Durée : 14 minutes**

## Objectif de la leçon
Savoir identifier les cas d'usage pertinents pour l'installation d'un MCP. Découvrir les grandes familles existantes et surtout, adopter la bonne méthodologie et les critères de sécurité (lecture seule, restriction des outils) avant d'ajouter un accès externe à Claude.

---

# 1. Les 8 grandes familles de MCP

```text
       ┌── Dépôts & Tâches (GitHub, Linear)
       ├── Navigateurs (Playwright)
       ├── Documentation & Wiki (Notion)
MCP ───┼── Supervision & Logs (Sentry)
       ├── Bases de données & Backend (Supabase, Postgres)
       ├── Design & Interfaces (Figma)
       ├── Services métiers & Paiement (Stripe, CRM)
       └── Cloud & Infrastructure (AWS, Azure)
```

Chaque intégration a son niveau de risque. Par exemple, un accès *Stripe* ou *Postgres* (écriture) implique des conséquences réelles et doit être confiné, contrairement à un accès à une documentation publique.

---

# 2. La logique d'installation : 4 étapes clés

Ne **jamais** installer un MCP parce qu'il existe ou qu'il est "stylé". Toujours suivre cette approche :

1. **Besoin identifié** : "Je fais des copier-coller d'issues GitHub en boucle."
2. **Serveur de confiance** : "J'utilise le MCP officiel de GitHub."
3. **Accès minimal (Lecture seule)** : "Je limite l'intégration aux outils `repos` et `issues`, sans droits d'écriture."
4. **Validation sur tâche bornée** : "Je teste l'intégration sur une issue spécifique pour vérifier son comportement."

---

# 3. Les MCP retenus pour le projet du cours

Pour le "convertisseur de température", seuls trois MCP ont un véritable intérêt :

| Serveur | Rôle dans le projet | Motif d'inclusion |
|---|---|---|
| **Doc Claude Code** | Chercher infos sur config/commandes. | Éviter d'avoir des hallucinations sur l'usage de Claude. |
| **Playwright MCP** | Ouvrir / manipuler l'app dans le navigateur. | Faire des tests d'interface exploratoires. |
| **GitHub MCP** | Consulter l'historique et les issues. | Remplacer la copie des cahiers des charges. |

*Sentry, Figma ou Stripe ne sont pas retenus car l'application locale n'a ni log de prod, ni maquette de référence, ni système de paiement.*

---

# Les 5 points les plus importants

1. Un MCP n'est utile que s'il supprime une friction manuelle répétitive.
2. Un MCP de navigateur (comme Playwright) est parfait pour compléter des tests unitaires par des tests exploratoires d'UI.
3. Toujours poser des critères stricts : le serveur est-il officiel ? Quelles sont les conséquences en cas d'erreur ?
4. Le mode **lecture seule** est la meilleure option par défaut lors de la configuration d'un MCP.
5. Il est souvent possible de ne charger que **certaines capacités** (ex: activer uniquement la lecture des *issues* sur GitHub MCP).

---

# Carte mentale

```text
Sélection d'un MCP
├── Critères de choix
│   ├── Besoin réel (supprimer une friction)
│   ├── Officialité et sécurité (Source)
│   └── Granularité (Possibilité de limiter à la lecture seule)
├── Familles existantes
│   ├── Code & Orga (GitHub, Notion)
│   ├── Tests & Débogage (Playwright, Sentry)
│   └── Métier & Infra (Stripe, AWS, BDD)
└── Sélection pour le projet
    ├── 1. Serveur documentaire Claude Code
    ├── 2. Playwright MCP
    └── 3. GitHub MCP
```

---

# Mini fiche de révision

```text
Règle d'or : Ne pas installer "au cas où". Installer pour régler un besoin.
Méthode : Besoin -> Serveur officiel -> Accès minimal -> Lecture seule si possible.
Les 3 élus du projet : GitHub MCP, Playwright MCP, Documentation Claude.
```

> **Phrase à retenir** : Le bon serveur n'est pas celui qui expose le plus d'outils, c'est celui qui répond à un besoin concret avec le périmètre le plus réduit possible.
