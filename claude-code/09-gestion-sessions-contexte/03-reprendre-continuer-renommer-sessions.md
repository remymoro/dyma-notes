---
title: "Reprendre, continuer et renommer les sessions (/resume, /continue, /rename, /recap)"
description: "Retrouver, poursuivre, récapituler et renommer une session Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - sessions
  - commandes
categories:
  - "Chapitre 9"
cours: Claude Code
chapitre: 09-gestion-sessions-contexte
leçon: 03-reprendre-continuer-renommer-sessions
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Session vs Contexte ?** | La **session** est la trajectoire de travail persistante, stockée sur disque en `JSONL` dans `~/.claude/projects/`. Le **contexte** est la fenêtre active limitée (la mémoire volatile du modèle à un instant T). |
| **`/continue` (`claude -c`) ?** | Reprend immédiatement la dernière session active du répertoire courant. *Piège : Ne l'utilisez pas par réflexe si vous changez de tâche, cela importerait un historique inutile.* |
| **`/resume` (`claude -r`) ?** | Ouvre le sélecteur interactif pour choisir une session existante (par nom, ou par ID). Dans le sélecteur, on peut utiliser `Espace` pour prévisualiser ou `Ctrl+R` pour renommer. |
| **Pourquoi nommer les sessions ?** | Donnez un nom par "flux de travail" (comme une branche Git : `auth-refactor` plutôt que `test`). Utilisez `/rename <nom>` dans le CLI ou `claude -n <nom>` au lancement. |
| **La reprise restaure-t-elle tout ?** | **NON**. Elle restaure les messages et certains objectifs actifs, mais recalcule toutes les permissions (pour la sécurité). Claude redemandera certaines autorisations. |
| **Comment faire une reprise "sûre" ?** | Ne reprenez jamais à l'aveugle après une pause ! Demandez toujours à Claude de vérifier la branche et le `/diff` avant de relancer des modifications. |

## Synthèse
Dans Claude Code, une session est une conversation persistée sur le disque sous forme de transcription `JSONL`. Reprendre une session (`/resume` ou `claude -r`) ne relance pas une nouvelle tâche, mais permet de poursuivre l'historique d'une conversation existante, même après un redémarrage. La continuation automatique (`claude -c`) est très pratique mais dangereuse si l'on change d'objectif (pollution de contexte garantie). Pour ne pas se perdre, il est vital d'utiliser `/rename` afin de donner des noms clairs à ses sessions (à traiter comme des branches Git). Attention : la reprise restaure la trajectoire de discussion mais recalcule les permissions de sécurité et doit *toujours* être accompagnée d'une vérification de l'état du projet (la branche ou le code ayant pu évoluer en votre absence).

## Glossaire
- **Session** : L'unité de travail persistante (fichiers `JSONL` dans `~/.claude/projects/`) contenant les messages, outils et métadonnées.
- **`/resume` (`claude -r`)** : Commande pour reprendre une session spécifique (par son nom ou ID) ou ouvrir le sélecteur.
- **`/continue` (`claude -c`)** : Reprend automatiquement la session la plus récente du dossier courant sans passer par le sélecteur.
- **`/rename`** : Attribue un nom descriptif à la session courante pour faciliter la gestion et les futures reprises.

## Questions d'auto-évaluation
1. Dans quel type de fichier et à quel endroit sont stockées physiquement les sessions Claude Code par défaut ?
2. Pourquoi est-il déconseillé d'utiliser `claude -c` par réflexe le lundi matin après un week-end ?
3. Les permissions "Always allow" accordées le vendredi sont-elles restaurées à la reprise de session le lundi ?
4. Quelle touche clavier permet de renommer une conversation dans le sélecteur interactif (`/resume`) sans l'ouvrir ?

# Reprendre, continuer et renommer les sessions

**Durée : 9 minutes**

## Objectif de la leçon
Comprendre le fonctionnement persistant des sessions, maîtriser les raccourcis de navigation, nommer ses espaces de travail, et apprendre à reprendre proprement une session sans perdre le contexte (recalage).

---

# 1. Le Workflow de Pause / Reprise

```text
  [ AVANT D'ARRÊTER (VENDREDI) ]
  /rename auth-refactor
  Prompt: "Fais un point de reprise (fichiers touchés, état)"
         │
  (Pause / Week-end / Autres commits sur le dépôt)
         │
  [ À LA REPRISE (LUNDI) ]
  claude -r "auth-refactor"
  Prompt: "Rappelle-moi où nous en étions et vérifie le /diff actuel"
         │
  [ SESSION RESTAURÉE ]
  (Les permissions sont recalculées par sécurité)
```

---

# Tableau des commandes à retenir

| Commande | Équivalent Terminal | Rôle |
|---|---|---|
| `/resume` | `claude -r` | Ouvre le sélecteur de sessions (flèches, Espace, Entrée). |
| `/resume <nom>` | `claude -r <nom>` | Reprend directement la session nommée. |
| `/continue` | `claude -c` | Reprend la **dernière** session du répertoire courant (sans menu). |
| `/rename <nom>` | `claude -n <nom>` | Renomme la session courante (ou lance une nouvelle session nommée). |
| *Sélecteur* | `Ctrl+R` | Renomme la session sélectionnée sans l'ouvrir. |
| *Sélecteur* | `Espace` | Prévisualise la session sélectionnée sans l'ouvrir. |

# Les 5 points les plus importants

1. **Session ≠ Contexte** : La session est un historique persistant enregistré sur votre disque (`JSONL`) ; le contexte est la mémoire active de l'agent qui, elle, reste limitée.
2. Traitez les sessions **comme des branches Git** : donnez-leur des noms clairs et spécifiques (`stripe-migration`, pas `test`).
3. La reprise n'est pas "magique" concernant la sécurité : **les permissions sont recalculées** ; Claude vous redemandera probablement des autorisations.
4. Ne reprenez jamais une session longue sans **recalage**. Demandez toujours à Claude de vérifier la branche et le `/diff` avant toute nouvelle action.
5. Utilisez le **sélecteur de sessions** (`/resume`) pour faire le ménage : `Espace` pour prévisualiser, `Ctrl+R` pour renommer les sessions mal nommées.

---

# Cartes mentales

## 1. Mécanismes de session

```text
                           SESSION CLAUDE CODE
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
     CONTINUER          REPRENDRE           NOMMER
        │                  │                  │
   claude -c            /resume           /rename
   dernière             /continue         claude -n
   session              claude -r
                           │
                 ┌─────────┼─────────┐
                 │         │         │
                nom        ID        PR
                                   --from-pr

                           │
                     APRÈS REPRISE
                           │
                      vérifier
                     /diff
                     /context
                           │
                       continuer
```

## 2. Cycle de vie et sélecteur

```text
                           SESSIONS CLAUDE CODE
                           │
          ┌────────────────┼────────────────┐
          │                │                │
       CRÉER            REPRENDRE        RENOMMER
          │                │                │
   claude -n "nom"   claude -c          /rename
                     dernière session    Ctrl+R
                          │
                     claude -r "nom"
                     session précise
                          │
                       /resume
                     sélecteur
                          │
             ┌────────────┼────────────┐
             │            │            │
          Espace        Ctrl+W       Ctrl+B
        prévisualiser   worktrees    branche

                           │
                        REPRISE
                           │
                         /diff
                           +
                        /context
                           │
                        continuer
```

---

# Mini fiche de révision

```text
■ claude -n / claude -r / /rename

claude -n "nom"
→ NOUVELLE session nommée

claude -r "nom"
→ REPRENDRE une session existante

/rename nom
→ RENOMMER la session déjà ouverte

Formule mnémotechnique :
-n → nouvelle
-r → reprise
/rename → renommage

■ /resume vs claude -c

claude -c
→ dernière session automatiquement

/resume
→ retrouver / choisir une session

■ Raccourcis du sélecteur

Espace  → prévisualiser
Entrée  → reprendre
Ctrl+R  → Rename
Ctrl+W  → Worktrees
Ctrl+B  → Branch
Ctrl+A  → All projects

■ Concept global

Session
→ trajectoire persistante

Contexte
→ partie actuellement exploitable

Reprendre
→ retrouver la trajectoire

Vérifier
→ confirmer l'état réel du projet

Puis
→ continuer
```


