---
title: "Auditer et nettoyer l'auto-mémoire"
description: "Comment inspecter, nettoyer et gérer la mémoire automatique générée par Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - nettoyage
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 05-auditer-nettoyer-auto-memoire
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **À quoi sert la commande `/memory` ?** | Elle affiche les mémoires *effectivement chargées* dans la session courante, permet de les ouvrir dans un éditeur, et donne accès à la gestion de la mémoire automatique. |
| **Où est stockée la mémoire automatique ?** | Dans `~/.claude/projects/<project>/memory/`. Elle est **strictement locale** à votre machine et ne sera jamais partagée avec l'équipe ou synchronisée sur Git. |
| **Comment fonctionne le fichier `MEMORY.md` ?** | Il agit comme un **index**. Seules les 200 premières lignes (ou 25 KB) sont chargées au démarrage. Si des détails sont trop longs, Claude crée des "fichiers de sujet" (ex: `debugging.md`) qui sont lus à la demande. |
| **Pourquoi faut-il auditer et nettoyer l'auto-mémoire ?** | Parce que Claude n'a aucun mécanisme intégré pour "vieillir" ses notes. Une hypothèse de debugging d'hier peut devenir une erreur aujourd'hui. L'auto-mémoire doit stocker des *patterns*, pas des accidents de session. |
| **Quand faut-il désactiver l'auto-mémoire ?** | Dans les environnements jetables, lors de formations/démos (pour ne pas mémoriser de fausses conventions), ou dans des dépôts ultra-sensibles. (Via `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` ou `autoMemoryEnabled: false`). |
| **Que faire d'une note auto-générée qui est utile pour tout le monde ?** | Il faut la *déplacer* de la mémoire automatique locale vers le fichier d'équipe versionné (`CLAUDE.md`). |

## Synthèse
La mémoire automatique permet à Claude d'apprendre de ses erreurs et de s'adapter à votre workflow local (sauvegardé dans `~/.claude/projects/<project>/memory/`). Cependant, cette autonomie crée rapidement de la "dette contextuelle" si elle n'est pas surveillée. Le fichier `MEMORY.md` sert d'index et est limité aux 200 premières lignes au chargement ; il ne doit pas devenir une archive fourre-tout. La commande `/memory` est essentielle : elle permet d'auditer ce qui est *réellement* chargé dans la session et d'ouvrir les fichiers pour les nettoyer. Un bon nettoyage consiste à supprimer les hypothèses périmées liées à des sessions de debug passées, et à transférer les règles universellement utiles vers le `CLAUDE.md` partagé par l'équipe. Enfin, n'oubliez pas que `/memory` vérifie le chargement, mais ne garantit pas que Claude respectera l'instruction si elle est mal formulée (dans ce cas, il faut la transformer en permission ou en hook).

## Glossaire
- **Auto-mémoire** : Notes prises automatiquement par Claude d'une session à l'autre, basées sur ses erreurs et vos corrections. Locale à la machine.
- **`MEMORY.md`** : L'index de l'auto-mémoire. Ses 200 premières lignes sont chargées à chaque session.
- **Fichiers de sujet** : Fichiers créés par Claude dans le dossier d'auto-mémoire (ex: `api-conventions.md`) pour désengorger l'index. Lus à la demande.
- **Dette contextuelle** : Accumulation de règles obsolètes, contradictoires ou de fausses pistes de debugging qui induisent l'agent en erreur au démarrage de la session.
- **`CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`** : Variable d'environnement pour désactiver la mémoire automatique (utile en CI ou en atelier de formation).

## Questions d'auto-évaluation
1. Je suis sur une branche temporaire `fix-bug-123` et Claude a mémorisé un comportement spécifique à cette branche. Que dois-je faire après le merge ?
2. Le fichier `MEMORY.md` fait 500 lignes. Que se passe-t-il au démarrage d'une session ?
3. Je tape `/memory` et je vois bien ma règle de sécurité listée. Pourtant, Claude a quand même fait l'action interdite. Pourquoi ?
4. Je suis formateur et je fais une démonstration de Claude Code avec des erreurs volontaires. Comment éviter qu'il n'apprenne ces erreurs ?

# Auditer et nettoyer l'auto-mémoire

**Durée : 15 minutes**

## Objectif de la leçon
Comprendre le fonctionnement du dossier d'auto-mémoire local (`MEMORY.md` et fichiers de sujets), et adopter des routines de nettoyage pour empêcher l'agent de s'intoxiquer avec des hypothèses de debugging périmées.

---

# 1. Le fonctionnement de l'auto-mémoire

L'auto-mémoire permet à Claude de ne pas refaire deux fois la même erreur le lendemain.
Elle est stockée sur votre machine, sous `~/.claude/projects/<votre-projet>/memory/`. **Elle ne va jamais sur Git.**

### La règle des 200 lignes
Dans ce dossier, le fichier central est `MEMORY.md`. 
**Attention : Seules les 200 premières lignes (ou 25 KB) de ce fichier sont chargées au démarrage.** 
Si le fichier grossit trop, tout ce qui est en dessous de la ligne 200 tombe sous la ligne de flottaison et devient invisible.

Pour éviter cela, Claude crée des **fichiers de sujet** (ex: `debugging.md`). `MEMORY.md` doit rester un *index* qui pointe vers ces fichiers, qui ne seront lus que si la tâche l'exige.

---

# 2. Le rôle central de `/memory`

La commande `/memory` ne liste pas ce que Claude *devrait* voir, mais **ce qui est réellement chargé** dans la fenêtre de contexte de la session en cours.

### Pourquoi utiliser `/memory` ?
- Pour vérifier qu'un `CLAUDE.md` de sous-dossier a bien été chargé.
- Pour **ouvrir l'éditeur** directement sur l'auto-mémoire et la corriger.
- Pour désactiver temporairement l'apprentissage automatique.

> [!WARNING]
> **Le piège de la fausse garantie**
> Ce n'est pas parce qu'une règle apparaît dans `/memory` que Claude la respectera à 100%. Si l'instruction est trop longue, trop vague ou noyée, il l'ignorera. Si la règle doit être absolue (interdiction), elle doit devenir une `permission` (deny) ou un `hook`.

---

# 3. La dette contextuelle et le nettoyage

Claude est très bon pour prendre des notes, mais il ne sait pas les effacer. 
Si vous passez 3 jours à débugger un problème obscur de base de données, Claude va se remplir de certitudes sur ce problème. Une fois le bug corrigé, ces certitudes deviennent fausses et dangereuses.

### Ce qu'il faut supprimer (La routine d'audit)
Tapez `/memory`, ouvrez le dossier de mémoire automatique, et supprimez :
1. Les pistes de debugging qui n'ont rien donné.
2. Les notes liées à une branche Git temporaire.
3. Les informations de chemins propres à votre machine (qui n'aideront personne d'autre).
4. Les commandes obsolètes ou les règles devenues inutiles suite à une mise à jour.

### Ce qu'il faut déplacer
Si Claude a noté une astuce géniale dans `MEMORY.md` ("Pour lancer Redis, il faut utiliser la commande `docker-compose up -d redis`"), **ce n'est plus de la mémoire locale : c'est une règle d'équipe.**
👉 Déplacez-la dans le fichier `./CLAUDE.md` versionné pour que vos collègues en profitent !

---

# 4. Quand désactiver l'auto-mémoire ?

Dans certains cas, il est préférable que Claude n'apprenne *rien*.

**Utilisez `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude` :**
- Pendant un atelier de formation (pour éviter qu'il mémorise des chemins fictifs ou des fausses erreurs).
- Dans des environnements jetables ou de CI.
- Dans des dépôts avec des données extrêmement sensibles.

---

# Cartes mentales

```text
               L'ÉCOSYSTÈME DE L'AUTO-MÉMOIRE
                           │
           ┌───────────────┼───────────────┐
           ↓                               ↓
       MEMORY.md                   Fichiers de Sujet
      (L'Index)                  (ex: debugging.md)
           │                               │
 Chargé au démarrage              Chargés À LA DEMANDE
 (Max 200 lignes !)                (Détails et logs)
           │                               │
           └───────────────┬───────────────┘
                           ↓
                   ROUTINE DE NETTOYAGE
        1. Supprimer l'obsolète (pistes de debug mortes)
        2. Raccourcir MEMORY.md
        3. Promouvoir les bonnes règles vers CLAUDE.md
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Matrice de diagnostic d'une instruction ignorée
1. Absent de /memory ? → C'est un problème d'emplacement ou de chargement.
2. Présent dans /memory mais ignoré ? → La règle est trop vague ou contradictoire.
3. C'est une interdiction ignorée ? → Erreur de casting : il fallait un deny (permission).
4. La règle est fausse ? → Ouvrir /memory et nettoyer l'auto-mémoire.
```

> **La phrase centrale de la leçon :**
> L'auto-mémoire stocke des accidents de parcours. C'est à vous de la purger régulièrement pour ne garder que les patterns vérifiés, et de promouvoir les bonnes trouvailles vers la mémoire de projet partagée (`CLAUDE.md`).
