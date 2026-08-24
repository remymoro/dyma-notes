---
title: "Isoler l’exécution avec /sandbox, Docker, devcontainers et données fictives"
description: "Protéger l’environnement de travail en isolant l’exécution de Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - sandbox
  - docker
  - securite
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 04-isoler-execution-sandbox-docker-devcontainers
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence entre permission et isolation ?** | L'autorisation décide *si* une action peut être tentée. L'isolation définit *dans quel environnement* (et avec quelles limites) elle s'exécute physiquement. |
| **Que couvre le `/sandbox` intégré à Claude Code ?** | Il isole **uniquement** les commandes `Bash` et leurs processus enfants. Il ne bloque pas les outils de fichiers natifs, `WebFetch`, les hooks ou les serveurs MCP. |
| **Le sandbox Bash bloque-t-il la lecture par défaut ?** | Non. Par défaut, il peut lire l'ensemble du système (y compris `~/.ssh`). Il faut **explicitement** lui interdire la lecture des dossiers personnels via `denyRead`. |
| **Pourquoi le mode "auto-allow" du sandbox est-il utile ?** | Il approuve automatiquement les commandes Bash contenues par la limite système, ce qui réduit la fatigue de validation sans passer par le mode `auto` global de Claude Code. |
| **Comment isoler tout le processus Claude Code (pas juste Bash) ?** | En utilisant le **Runtime Sandbox**, un conteneur Docker, un Devcontainer, ou une Machine Virtuelle dédiée. |
| **Pourquoi monter `~/.ssh` dans un devcontainer est une mauvaise idée ?** | Un conteneur n'est pas "magique". Si un secret y est monté, un agent compromis peut le lire et l'exfiltrer sur le réseau. Il vaut mieux utiliser des jetons jetables. |

## Synthèse
L'isolation complète le système de permissions : alors qu'une permission donne le droit de lancer une commande, l'isolation (sandbox) garantit que cette commande ne pourra pas s'échapper de son périmètre sur le système d'exploitation. Le `/sandbox` intégré à Claude Code est très pratique mais a une limite stricte : il ne couvre que les commandes `Bash` (et par défaut, il lit tout l'ordinateur !). Pour les travaux exigeant une forte autonomie ou l'exécution de code non fiable, il faut passer à des niveaux d'isolation supérieurs (Runtime Sandbox, Devcontainer, VM) et surtout, minimiser les données réelles en utilisant des données fictives. N'oubliez jamais : isoler l'exécution ne sert à rien si vous laissez le réseau grand ouvert ou si vous montez tous vos secrets personnels dans le conteneur.

## Glossaire
- **`/sandbox`** : Commande CLI pour configurer l'isolation Bash intégrée (repose sur Seatbelt/macOS ou bubblewrap/Linux).
- **Mode `auto-allow` (sandbox)** : Accepte les commandes Bash silencieusement *tant qu'elles respectent les limites du sandbox*. (À ne pas confondre avec le mode `auto` de Claude Code).
- **`sandbox.credentials`** : Configuration pour bloquer explicitement l'accès aux identifiants (fichiers ou variables d'environnement) dans le sandbox Bash.
- **Runtime Sandbox** : Option d'isolation qui englobe *l'intégralité* du processus Claude Code (Bash + MCP + Hooks + Fichiers).
- **Devcontainer** : Conteneur Docker défini par un `.devcontainer/` pour standardiser l'environnement d'une équipe.
- **Principe de minimisation** : Ne pas exposer de vrais secrets. Préférer les données fictives, les mocks et les jetons à durée de vie courte.

## Questions d'auto-évaluation
1. Si une commande `Bash(npm run test *)` est approuvée par les règles de permission, peut-elle écrire dans le dossier `/etc/` si le `/sandbox` est actif ?
2. Le `/sandbox` empêche-t-il un outil MCP de lire un fichier secret ?
3. Le paramètre `failIfUnavailable: true` permet-il d'exécuter Claude Code si le sandbox plante ?
4. Quelle est la méthode la plus sûre pour tester un dépôt non fiable (ex: un projet open source inconnu) ?

# Isoler l’exécution avec `/sandbox`, Docker et Devcontainers

**Durée : 15 minutes**

## Objectif de la leçon
Comprendre les différentes couches d'isolation physique. Savoir configurer le `/sandbox` Bash intégré pour le travail local, et savoir quand basculer vers un Devcontainer ou une VM pour du code non fiable.

---

# 1. Permission vs Isolation

- **Permission :** L'agent a-t-il le droit de lancer le script de test ? (Oui/Non)
- **Isolation :** Que va faire ce script de test sur mon disque dur une fois lancé ?

Le nom de la commande ne décrit pas ce que feront ses processus enfants. C'est pour cela qu'il faut un **sandbox** : il applique des règles au niveau du système d'exploitation.

---

# 2. Le `/sandbox` intégré (Limites et configuration)

La commande `/sandbox` active l'isolation pour le travail local.

> [!WARNING]
> **Ce que le `/sandbox` NE couvre PAS**
> Il n'isole **que les commandes Bash**. Il ne bloque ni `WebFetch`, ni les outils `Read`/`Edit` natifs de Claude Code, ni les serveurs `MCP`.

### Les failles courantes à combler :
1. **La lecture globale :** Par défaut, le sandbox Bash *peut lire* tout votre ordinateur. Vous devez explicitement configurer `denyRead: ["~/"]` puis `allowRead: ["."]`.
2. **L'héritage des secrets :** Les processus enfants héritent de votre environnement. Utilisez `sandbox.credentials` pour bloquer la lecture de `~/.aws/credentials` ou purger les variables d'environnement `GITHUB_TOKEN`.
3. **Le réseau grand ouvert :** Ne corrigez jamais un problème de build en ouvrant tout le réseau. Préautorisez uniquement les domaines strictement nécessaires (ex: `registry.npmjs.org`).

---

# 3. L'escalade de l'isolation

Le choix du niveau d'isolation dépend de la confiance que vous accordez au code (Modèle de menace).

| Niveau d'isolation | Outil | Usage type |
|---|---|---|
| **Basique** | `/sandbox` Bash | Dépôt de confiance, travail local quotidien. |
| **Intermédiaire** | Runtime Sandbox | Isoler aussi les Hooks et MCP, sans utiliser Docker. |
| **Fort** | Devcontainer / Docker | Travail en équipe, environnement reproductible, ou tâche hautement autonome. |
| **Paranoïaque** | Machine Virtuelle / Cloud isolé | Code inconnu/non fiable, séparation totale au niveau du noyau. |

---

# 4. Le principe de minimisation (Données fictives)

**La meilleure donnée sensible est celle qui n’est jamais présente.**
Mettre vos secrets SSH dans un conteneur ultra-sécurisé ne sert à rien si le conteneur lui-même est compromis et a accès au réseau.
- Privilégiez systématiquement les données fictives (mocks, fixtures).
- Utilisez des comptes de développement (pas de production).
- Utilisez des tokens à courte durée de vie.

---

# Cartes mentales

```text
                  MODÈLES DE MENACE ET ISOLATION
                               │
            ┌──────────────────┼──────────────────┐
            ↓                  ↓                  ↓
     Code de confiance    Besoin d'équipe    Code non fiable
    (Travail quotidien)   (Standardisation) (Projet open source)
            │                  │                  │
        /sandbox          Devcontainer       VM dédiée ou
      (Isole Bash)         (Isole tout)       Cloud isolé
            │                  │                  │
        Attention:         Attention:         Attention:
     ne bloque pas        ne pas monter      au réseau et
       MCP / Hooks         les secrets       aux exfiltrations
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice de décision de l'isolation
1. Dépôt de confiance local   → /sandbox
2. Hooks ou MCP à isoler      → Runtime Sandbox ou Conteneur
3. Environnement standardisé  → Devcontainer
4. Code non fiable / Autonome → VM dédiée ou Cloud isolé

■ Check-list avant une tâche risquée :
[ ] Secrets réels absents (ou non montés).
[ ] Données client remplacées par des données fictives.
[ ] Réseau restreint aux domaines stricts.
[ ] État Git propre.
```

> **La phrase centrale de la leçon :**
> L’isolation ne remplace pas les permissions : l'une autorise l'intention, l'autre enferme l'exécution. Mais aucune isolation ne protège un secret que vous avez volontairement monté dans l'environnement !
