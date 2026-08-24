---
title: "Liste des configurations — partie 2"
description: "Approfondir les réglages disponibles dans Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - configuration
categories:
  - "Chapitre 8"
cours: Claude Code
chapitre: 08-personnalisation-configuration-interface
leçon: 03-liste-configurations-partie-2
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **useAutoModeDuringPlan ?** | Permet au mode plan d'utiliser la sémantique du mode auto si disponible. Cela réduit la friction et fluidifie l'autorisation, mais ne remplace pas les règles de sécurité `deny`. |
| **respectGitignore ?** | Le sélecteur de fichiers (via `@`) ignore les fichiers du `.gitignore`. Utile pour réduire le bruit (builds, dépendances) mais ce n'est pas une règle de sécurité stricte (accès toujours possible si forcé). |
| **Sélecteur de copie (`/copy`) ?** | L'option *Skip the /copy picker* désactive le choix interactif pour accélérer la copie complète de la réponse, selon les préférences d'ergonomie. |
| **Notifications locales vs push ?** | Locales (`preferredNotifChannel`) = cloche ou terminal. Push (`inputNeededNotifEnabled`, `agentPushNotifEnabled`) = via mobile, ce qui nécessite une session Remote Control active. |
| **Remote Control ?** | `remoteControlAtStartup` connecte la session locale pour être pilotée à distance depuis le web/mobile. Attention : l'exécution reste toujours à 100% sur la machine locale. |
| **Styles et Langue ?** | `outputStyle` modifie la posture et le formatage des réponses (via l'invite système). `language` influence la dictée vocale et les réponses de Claude, sans changer l'interface. |

## Synthèse
La seconde partie des configurations aborde des réglages fonctionnels plus avancés. Elle permet d'ajuster le comportement de planification (`useAutoModeDuringPlan`), la navigation (`respectGitignore`, vue agents) et l'intégration (Remote control, IDE, Chrome). Ces réglages permettent d'adapter l'ergonomie et l'observabilité (notifications, diff) au flux de travail de l'utilisateur sans modifier fondamentalement les capacités d'exécution locales du modèle.

## Glossaire
- **Remote Control** : Fonctionnalité permettant de piloter une session locale d'agent depuis une interface web ou mobile.
- **`useAutoModeDuringPlan`** : Réglage permettant d'appliquer la fluidité d'autorisation du mode auto pendant la phase de planification.
- **`outputStyle`** : Configuration influençant la posture rédactionnelle et le niveau de détail des réponses de Claude.

## Questions d'auto-évaluation
1. Activer le Remote Control déplace-t-il l'exécution du code et des outils dans le cloud ?
2. Quelle est la différence entre les notifications locales et les notifications push ?
3. Le réglage `respectGitignore` peut-il remplacer une politique de permission `deny` stricte pour sécuriser un dossier ?

# Liste des configurations — partie 2

**Durée : 19 minutes**

## Objectif de la leçon
Apprendre à configurer les outils périphériques et d'intégration de Claude Code (Remote Control, éditeurs, notifications) pour fluidifier le flux de travail et l'observation de l'agent sans compromettre la sécurité.

---

# 1. Planification et Navigation

```text
  Flux de planification et sélection
  ┌────────────────┐      ┌─────────────────────────┐
  │ Mode Plan      │ ───> │ useAutoModeDuringPlan   │ (Fluidité accrue)
  └────────────────┘      └─────────────────────────┘
  ┌────────────────┐      ┌─────────────────────────┐
  │ Sélecteur '@'  │ ───> │ respectGitignore        │ (Réduction du bruit)
  └────────────────┘      └─────────────────────────┘
```

---

# 2. Intégrations et Notifications

```text
  Écosystème de Notification
  Terminal Local ────> preferredNotifChannel (auto, iTerm2, cloche)
  Remote Control ────> inputNeededNotifEnabled (Attente action)
                 ────> agentPushNotifEnabled (Fin de tâche longue)
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| `/copy` | Copie la dernière réponse de l'assistant (avec ou sans sélecteur). |
| `/agents` | Gère les agents en parallèle et affiche la vue des agents. |
| `/remote-control` | Configure l'accès à la session depuis web/mobile. |
| `/model` | Change le modèle pour la session ou par défaut. |
| `/diff` | Ouvre un visualiseur interactif des modifications non validées. |
| `/chrome` | Configure l'intégration de Claude dans le navigateur Chrome. |

# Les 5 points les plus importants

1. `useAutoModeDuringPlan` assouplit la planification sans ignorer pour autant les règles de sécurité.
2. `respectGitignore` purifie les suggestions de fichiers du bruit ambiant mais ne sécurise pas le dépôt.
3. Le **Remote Control** pilote l'agent à distance, mais l'exécution et les outils MCP restent strictement **locaux**.
4. Le canal de mise à jour (`autoUpdatesChannel`) arbitre entre nouveautés (`latest`) et stabilité absolue (`stable`).
5. Les configurations comme l'extension IDE ou le mode éditeur externe s'enregistrent souvent au niveau utilisateur (`~/.claude.json`).

---

# Carte mentale

```text
Configurations Partie 2
├── Planification
│   └── useAutoModeDuringPlan
├── Navigation & Ergonomie
│   ├── respectGitignore (Sélecteur @)
│   ├── Skip /copy picker
│   └── Open agents view (←)
├── Apparence & Langue
│   ├── theme, language, outputStyle
│   └── Editor mode
├── Observabilité
│   ├── Notifications locales (terminal)
│   └── Push mobiles (Remote Control requis)
└── Intégrations
    ├── Remote Control (pilotage distant)
    ├── Diff tool (/diff interactif)
    └── IDE / Chrome (auto-install)
```

---

# Mini fiche de révision

```text
Réglages avancés :
- Planification : `useAutoModeDuringPlan` (plus fluide).
- Sélecteur : `respectGitignore` (moins de bruit).
- Accès distant : Remote Control (exécution locale maintenue).
- Visuels & confort : Thème, langue, style de sortie, /diff, IDE.
```

> **Phrase à retenir** : Les intégrations et réglages d'interface fluidifient le travail, mais l'exécution de l'agent reste toujours ancrée localement.
