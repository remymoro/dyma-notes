---
title: "Choisir le bon emplacement pour chaque mémoire"
description: "Choisir entre les mémoires de projet, locales et globales selon la portée souhaitée."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - configuration
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 03-choisir-emplacement-memoire
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Où placer les règles d'équipe vs préférences personnelles ?** | Règles d'équipe : `./CLAUDE.md` (versionné).<br>Préférences perso pour *ce* projet : `./CLAUDE.local.md` (dans le `.gitignore`).<br>Préférences perso globales : `~/.claude/CLAUDE.md`. |
| **Dans quel ordre sont chargés les fichiers `CLAUDE.md` ?** | En remontant l'arborescence. Les fichiers sont *concaténés*, pas remplacés. Le fichier le plus spécifique (le plus proche du dossier d'exécution) est lu en dernier et a donc plus de poids. Les fichiers `CLAUDE.local.md` sont toujours lus *après* les `CLAUDE.md` du même dossier. |
| **Quand les `CLAUDE.md` des sous-dossiers sont-ils chargés ?** | À la demande ! Si on lance l'agent depuis la racine, les fichiers `packages/*/CLAUDE.md` ne sont chargés que lorsque Claude lit un fichier à l'intérieur de ces dossiers. C'est idéal pour éviter de polluer le contexte. |
| **Pourquoi le répertoire de lancement est-il si important dans un monorepo ?** | C'est un choix de *cadrage*. Lancer depuis la racine charge les règles globales et nécessite un chargement à la demande pour les packages. Lancer depuis `packages/web` charge le contexte local + les règles globales immédiatement, ce qui est parfait pour une tâche confinée au frontend. |
| **Comment exclure un `CLAUDE.md` obsolète ou d'une autre équipe ?** | En utilisant `claudeMdExcludes` dans le fichier `settings.json`, mais cela doit être réservé aux zones *durablement* non pertinentes, pas utilisé comme un commutateur temporaire (où changer de dossier de lancement est plus propre). |
| **Les commentaires HTML consomment-ils des tokens ?** | Non. `<!-- commentaire -->` au niveau bloc est supprimé avant d'être envoyé à Claude. Parfait pour laisser des instructions aux mainteneurs humains. |

## Synthèse
L'emplacement d'un fichier `CLAUDE.md` détermine non seulement *qui* reçoit la règle, mais aussi *quand* elle est chargée en contexte. Pour un projet simple, un fichier `./CLAUDE.md` à la racine suffit. Mais dans un monorepo ou un environnement complexe, il faut superposer les mémoires. Les règles transversales (ex: comment lancer les tests d'intégration) restent à la racine, tandis que les conventions locales (ex: "utilise Vitest") sont poussées dans les `CLAUDE.md` de chaque package. Ainsi, les fichiers des sous-dossiers ne sont chargés *à la demande* que lorsque l'agent y entre, ce qui protège la fenêtre de contexte. Il faut également strictement séparer la mémoire d'équipe (versionnée) de la mémoire personnelle (placée dans `~/.claude/CLAUDE.md` ou dans un `./CLAUDE.local.md` ignoré par Git).

## Glossaire
- **`./CLAUDE.md`** : Mémoire projet partagée et versionnée.
- **`./CLAUDE.local.md`** : Mémoire projet personnelle. Idéale pour indiquer le port de son serveur de dev ou ses fixtures locales. (Ignorée par Git).
- **`~/.claude/CLAUDE.md`** : Mémoire utilisateur. Préférences globales (style de réponse, habitudes) qui s'appliquent à tous vos projets.
- **Mémoire gérée (`/etc/...`)** : Règles imposées par l'organisation à tous les employés, prioritaires.
- **`claudeMdExcludes`** : Paramètre pour ignorer complètement la lecture des `CLAUDE.md` dans certains chemins d'un grand monorepo.
- **`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD`** : Flag pour forcer le chargement de la mémoire d'un dépôt "frère" auquel on a donné accès.

## Questions d'auto-évaluation
1. J'aime que Claude finisse toujours ses réponses par un résumé emoji. Dans quel fichier mettre ça ?
2. Mon équipe travaille sur un monorepo. La consigne "Les composants partagés sont dans `src/components`" doit-elle aller à la racine ou dans le `CLAUDE.md` du frontend ?
3. J'ajoute un dossier externe avec `/add-dir ../autre-repo`. Est-ce que le `CLAUDE.md` de `autre-repo` est automatiquement chargé ?
4. Je suis à la racine d'un dépôt, l'agent n'a encore touché à rien. Le fichier `packages/api/CLAUDE.md` est-il déjà dans la fenêtre de contexte ?

# Choisir le bon emplacement pour chaque mémoire

**Durée : 13 minutes**

## Objectif de la leçon
Comprendre la hiérarchie et la portée des fichiers de mémoire (`CLAUDE.md`, `.local.md`, `~/.claude/`) pour organiser l'information intelligemment, particulièrement dans les gros projets (monorepos), et éviter de noyer l'agent sous des règles hors sujet.

---

# 1. Les 4 portées principales

La règle fondamentale est : **"Ne versionnez pas vos préférences, n'imposez pas votre style à l'équipe."**

| Portée | Emplacement | Usage | Partage |
|---|---|---|---|
| **Organisation** | `/etc/claude-code/...` | Règles de conformité, sécurité absolue. | Tous les employés |
| **Utilisateur** | `~/.claude/CLAUDE.md` | "Réponds court", "J'aime utiliser pnpm". | Vous seul |
| **Projet** | `./CLAUDE.md` | Architecture, commandes CI, migrations en cours. | Équipe (Git) |
| **Projet Local** | `./CLAUDE.local.md` | Port local (ex: 4011), notes privées. | Vous seul (.gitignore) |

---

# 2. La magie de la superposition (L'ordre de chargement)

Au lancement, Claude Code va chercher les fichiers `CLAUDE.md` et `CLAUDE.local.md` en remontant l'arborescence depuis le dossier où vous l'avez lancé.

**Ils sont concaténés, pas écrasés.**
L'ordre de lecture se fait de la racine vers le dossier local. Le fichier le plus profond (le vôtre) est lu en dernier, il a donc le dernier mot en cas de contradiction contextuelle. Dans un même dossier, `CLAUDE.local.md` est toujours lu *après* `CLAUDE.md`.

---

# 3. La stratégie Monorepo : Chargement à la demande

Si vous avez 50 packages dans votre monorepo, vous ne voulez pas charger 50 `CLAUDE.md` au démarrage.

**C'est pour cela que les sous-dossiers sont intelligents :**
- Les `CLAUDE.md` situés *au-dessus* de votre dossier de lancement sont chargés au démarrage.
- Les `CLAUDE.md` situés *en dessous* de votre dossier de lancement sont **chargés à la demande**, uniquement si Claude décide d'aller fouiller dans ce sous-dossier !

### L'importance du répertoire de lancement
Le choix de l'endroit où vous tapez `claude` est un choix de cadrage :
- Tâche transversale ? Lancez depuis la `racine`. L'agent ira chercher les mémoires des packages quand il y entrera.
- Tâche purement frontend ? Lancez depuis `packages/web`. Claude aura immédiatement tout le contexte frontend, et ne polluera pas sa mémoire avec les règles de l'API.

---

# 4. Le secret des mainteneurs : Les commentaires HTML

Les fichiers `CLAUDE.md` partagés peuvent devenir cryptiques pour les nouveaux développeurs. Mais si vous y mettez une longue explication, vous gâchez des tokens.

**La solution :** Les commentaires HTML de bloc `<!-- ... -->` sont supprimés *avant* d'être envoyés à Claude !

```markdown
<!-- Note mainteneur :
  Ce pattern est temporaire. À supprimer quand la PR #456 sera mergée.
-->
## Base de données
Ne pas utiliser le repository direct, utiliser les managers.
```

---

# Cartes mentales

```text
               OÙ PLACER MON INSTRUCTION ?
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
      MON STYLE         CE PROJET      CE PROJET, POUR MOI
  (Pour tous les repos)  (Pour tous)       (Local / Dev)
           │               │               │
  ~/.claude/CLAUDE.md  ./CLAUDE.md   ./CLAUDE.local.md
  ("Réponds en FR")   ("pnpm test")  ("Port local 8080")
           │               │               │
       Non-versionné   Versionné (Git)   Non-versionné
```

```text
               MONOREPO : GESTION DU BRUIT
                           │
           ┌───────────────┴───────────────┐
           ↓                               ↓
       RACINE DU DÉPÔT                 SOUS-DOSSIERS
    (Règles transversales)           (Règles spécifiques)
           │                               │
    "C'est un monorepo"              "Utilise Vitest ici"
 "Scripts npm à la racine"     "N'utilise pas de SQL brut ici"
           │                               │
   Chargé au démarrage           Chargé À LA DEMANDE
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les règles d'exclusion
1. Claude lit un dossier externe (via /add-dir) → Sa mémoire N'EST PAS chargée (sauf flag).
2. Un dossier entier n'est plus à vous (code legacy, équipe B) → Utilisez claudeMdExcludes.
3. Un fichier local s'applique sur plusieurs worktrees → Utilisez @~/.claude/mon-fichier.md comme import dans CLAUDE.local.md.

■ Audit :
Tapez `/memory` pour vérifier exactement qui est chargé, qui est local, et débusquer les conflits !
```

> **La phrase centrale de la leçon :**
> Lancer Claude depuis la racine d'un monorepo charge les invariants globaux et permet un chargement intelligent "à la demande" des règles des sous-packages. Les préférences personnelles, elles, doivent rester dans `CLAUDE.local.md` ignorés par Git.
