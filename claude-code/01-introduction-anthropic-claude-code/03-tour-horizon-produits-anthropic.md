---
title: "Tour d’horizon des produits Anthropic"
description: "Présentation des principaux produits proposés par Anthropic."
date: 2026-08-14
draft: true
tags:
  - anthropic
  - produits
categories:
  - "Chapitre 1"
cours: Claude Code
chapitre: 01-introduction-anthropic-claude-code
leçon: 03-tour-horizon-produits-anthropic
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Différence produit / intégration / compétence / connecteur ? | **Produit** : Où je travaille (ex: Claude, Claude Code).<br>**Intégration** : Dans quelle interface tierce j'utilise Claude (ex: Slack, Chrome).<br>**Compétence (Skill)** : Quelle méthode spécialisée j'active.<br>**Connecteur** : À quelles données/apps externes Claude est relié. |
| Quels sont les 5 produits principaux d'Anthropic ? | Claude (généraliste), Claude Code (dev), Claude Cowork (tâches longues/agentiques), Claude Design (visuels), Claude Security (cybersécurité). |
| Qu'est-ce qu'un Plugin ? | Un pack métier installable (regroupant skills, connecteurs, workflows). |
| À quoi sert Claude Platform ? | C'est la plateforme développeur (API, SDK) pour intégrer Claude dans ses propres systèmes. |
| Que signifient GA, Public beta et Research preview ? | **GA** : Stable/Disponibilité générale.<br>**Public beta** : Évolutif.<br>**Research preview** : Expérimental/Limité. |
| Pourquoi cette distinction compte ? (Risques & Gouvernance) | Utiliser le bon outil évite les risques (ex: limiter Claude for Chrome pour la sécu web). Permet une meilleure gouvernance (qui a accès à quoi, qui installe un plugin ou connecteur). |

## Synthèse
L'écosystème Anthropic se déploie sur plusieurs niveaux : des modèles (Opus, Sonnet, Haiku) qui motorisent cinq produits principaux (Claude, Code, Cowork, Design, Security). Ces produits peuvent s'intégrer dans des outils tiers (Chrome, MS 365, Slack) et être enrichis via un répertoire de Compétences (Skills), Connecteurs et Plugins métiers. Enfin, la Claude Platform et les solutions verticales permettent d'intégrer l'IA dans n'importe quel système en respectant gouvernance et sécurité.

## Glossaire
- **API** : Interface permettant à un logiciel d'utiliser les capacités d'un autre logiciel.
- **Connecteur** : Lien permettant à Claude d'accéder à des données ou applications externes (souvent via MCP).
- **IDE** : Environnement de développement intégré (ex: VS Code).
- **MCP (Model Context Protocol)** : Protocole standardisé pour connecter un modèle à des outils, données et services.
- **Plugin** : Pack installable regroupant plusieurs compétences et connecteurs pour un workflow ou métier précis.
- **Skill (Compétence)** : Méthode de travail spécialisée, préparée à l'avance et réutilisable.
- **Solutions verticales** : Offres adaptées à des secteurs spécifiques (Légal, Finance, Sécurité) avec des règles et connecteurs métiers.

## Questions d'auto-évaluation
1. Si je dois réaliser un livrable complexe en manipulant plusieurs fichiers locaux de manière autonome, quel produit Anthropic dois-je utiliser ?
2. Quelle est la différence fondamentale entre une *Skill* et un *Plugin* ?
3. Quel produit utiliseriez-vous pour détecter des failles dans une grande base de code d'entreprise ?
4. Pourquoi doit-on être particulièrement vigilant (gouvernance/permissions) avant d'activer un Connecteur ?

# Tour d’horizon des produits Anthropic

**Durée : 20 minutes**

## Notes

### Les 5 produits principaux d'Anthropic
```mermaid
flowchart LR
    A[Les 5 Produits] --> B(Claude)
    A --> C(Claude Code)
    A --> D(Claude Cowork)
    A --> E(Claude Design)
    A --> F(Claude Security)
    
    B -.-> B1[Généraliste : discuter, rédiger, analyser]
    C -.-> C1[Développement : coder, corriger, refactorer]
    D -.-> D1[Agentique : déléguer tâche longue/complexe]
    E -.-> E1[Création visuelle : maquettes, prototypes]
    F -.-> F1[Cybersécurité : scanner, détecter failles]
    
    style B fill:#f9f,stroke:#333
    style C fill:#bbf,stroke:#333
    style D fill:#bfb,stroke:#333
    style E fill:#fbf,stroke:#333
    style F fill:#fbb,stroke:#333
```

### L'Écosystème d'intégration (Le Répertoire)
```mermaid
flowchart LR
    Claude((🤖 CLAUDE))
    
    subgraph Plugin [📦 PLUGIN : Caisse à outils métier]
        direction TB
        S1[🛠️ SKILL : Méthode]
        C1[🔌 CONNECTEUR : Accès BDD/Web]
        A[🤖 SOUS-AGENTS]
    end
    
    S2[🛠️ SKILL : Méthode<br/>Ex: Appliquer une structure]
    C2[🔌 CONNECTEUR : Accès<br/>Ex: Lire Google Drive]
    
    Claude ====>|Embarque le tout| Plugin
    Claude -->|Utilisé isolément| S2
    Claude -->|Utilisé isolément| C2
    
    style Plugin fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px,stroke-dasharray: 5 5
    style S1 fill:#e8f5e9,stroke:#2e7d32
    style C1 fill:#e3f2fd,stroke:#1565c0
    style S2 fill:#e8f5e9,stroke:#2e7d32
    style C2 fill:#e3f2fd,stroke:#1565c0
    style A fill:#fff3e0,stroke:#e65100
    style Claude fill:#ffcc80,stroke:#e65100,stroke-width:3px
```

### La Pyramide à 6 Niveaux
```mermaid
flowchart BT
    L1[1. Le Cœur<br/>Claude, Opus, Sonnet, Haiku]
    L2[2. Les Produits Principaux<br/>Claude, Code, Cowork, Design, Security]
    L3[3. Les Intégrations d'Interface<br/>Chrome, MS 365, Xcode, Slack]
    L4[4. Le Répertoire<br/>Compétences, Connecteurs, Plugins]
    L5[5. La Plateforme Développeur<br/>Claude Platform, AWS]
    L6[6. Les Solutions Verticales<br/>Legal, Security, Finance, etc.]
    
    L1 --> L2 --> L3 --> L4 --> L5 --> L6
    
    style L1 fill:#ffe5b4,stroke:#333
    style L2 fill:#ffd180,stroke:#333
    style L3 fill:#ffab40,stroke:#333
    style L4 fill:#ff9100,stroke:#333
    style L5 fill:#ff6d00,stroke:#333
    style L6 fill:#dd2c00,stroke:#333,color:#fff
```

## Points clés

- Anthropic propose un écosystème en couches : modèles de base (le moteur), produits principaux (surfaces), intégrations tierces, et un répertoire d'extensions.
- Il y a 5 produits distincts : **Claude**, **Claude Code**, **Claude Cowork**, **Claude Design**, et **Claude Security**.
- Le répertoire contient 3 grandes familles : **Skills** (méthodes), **Connecteurs** (données) et **Plugins** (workflows).
- La distinction est vitale pour la **gouvernance et la sécurité** : chaque intégration (API, MCP, Slack, Chrome) expose les données différemment et nécessite des droits spécifiques.
- **Règle d'or** (les 6 questions) : Où est-ce que je travaille ? Dans quelle interface externe ? Avec quel moteur ? Avec quelles compétences ? Avec quelles connexions ? Avec quelles permissions ?
