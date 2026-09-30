---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 02-fonctionnement-worktrees
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la limite des sessions parallèles sans *worktree* ?** | Les contextes cognitifs des IA sont séparés, mais les fichiers modifiés sont **partagés**. Si les deux agents modifient le même dossier, ils écraseront leurs changements respectifs ou travailleront sur du contenu devenu obsolète. |
| **En quoi un *worktree* diffère-t-il d'un simple changement de branche (`git switch`) ?** | Un `git switch` modifie le dossier courant, n'offrant qu'une version des fichiers à la fois. Un *worktree* crée un **nouveau répertoire physique** (avec sa propre branche) tout en partageant la base de données Git. Les deux versions sont disponibles en même temps dans deux dossiers différents. |
| **Comment faire pour que Claude crée toujours le worktree depuis l'état local (et non depuis le serveur distant) ?** | En ajoutant dans `.claude/settings.json` : `"worktree": { "baseRef": "head" }`. Par défaut, il part de `origin/HEAD` (`fresh`) pour avoir un état garanti propre, ignorant les commits locaux non poussés. |
| **Le fichier `.env` (ignoré par Git) est-il copié dans le nouveau worktree ?** | **Non**, par défaut, les worktrees sont des *checkouts* propres (sans fichiers ignorés/non suivis). Pour le copier, il faut créer un fichier `.worktreeinclude` à la racine et y lister `.env`. |
| **La fusion de deux branches créées via *worktrees* empêche-t-elle les conflits ?** | Non. Les worktrees empêchent les **écrasements directs** pendant l'édition simultanée. Mais au moment du `git merge` dans le dossier principal, si les deux branches ont modifié la même ligne, Git signalera un conflit de fusion classique. |

## Synthèse
Pour permettre à plusieurs sessions Claude Code de travailler en parallèle sur le même projet sans se marcher sur les pieds, l'outil idéal est le **Git Worktree**. Contrairement à un clone complet, le worktree partage la base de données Git (`.git`) mais extrait une branche dédiée dans un répertoire séparé (généralement sous `.claude/worktrees/`). Chaque session peut ainsi modifier ses fichiers et lancer ses tests (`npm test`) en isolation parfaite. En revanche, les fichiers ignorés par Git (comme le `.env`) ne sont pas copiés, sauf s'ils sont explicitement listés dans un fichier `.worktreeinclude`. À la fin du travail, on referme la session (`/exit`), on choisit de "conserver" le travail, puis on effectue un *commit* et un *merge* depuis le dossier principal, avant de nettoyer le répertoire du worktree (`git worktree remove`) et de supprimer la branche temporaire.

## Glossaire
- **`git worktree`** : Fonctionnalité de Git permettant d'attacher plusieurs répertoires de travail (et branches) simultanés à un seul dépôt local.
- **`.worktreeinclude`** : Fichier de configuration spécifique à Claude Code listant les fichiers non suivis par Git (ex: secrets, config locale) qui doivent obligatoirement être copiés dans chaque nouveau worktree.
- **`origin/HEAD` (fresh)** : Référence distante utilisée par défaut par Claude pour créer un worktree, garantissant que le nouveau travail part d'une base commune propre, ignorant le travail local non poussé.
- **`baseRef: "head"`** : Option de configuration pour forcer la création d'un worktree à partir du dernier commit local (`HEAD`), incluant ainsi les commits locaux non encore envoyés sur le serveur.

## Questions d'auto-évaluation
1. Si vous supprimez un worktree avec la commande `git worktree remove`, la branche associée est-elle également supprimée ?
2. Quelle commande Git taper dans un autre terminal pour lister tous les worktrees actuellement actifs sur votre dépôt ?
3. Pourquoi ne faut-il jamais ajouter `node_modules` dans le fichier `.worktreeinclude` ?
4. Que se passe-t-il automatiquement si un sous-agent utilise l'isolation en *worktree* mais se termine sans avoir modifié le moindre fichier ?

# Fonctionnement des worktrees

**Durée : 14 minutes**

## Objectif de la leçon
Comprendre la mécanique des *Git Worktrees* et les manipuler manuellement depuis le terminal. Apprendre à configurer l'inclusion de fichiers locaux (`.worktreeinclude`) et la base de référence (`baseRef`), puis valider l'isolation totale des écritures lors de sessions parallèles.

---

# 1. Le problème de l'édition parallèle

Imaginons deux sessions Claude Code (A et B) lancées dans deux terminaux normaux sur le même projet.
- Leurs **contextes cognitifs** (la fenêtre de chat) sont séparés.
- Leurs **fichiers** sont partagés (le même dossier).
*Si A modifie `src/app.js` et que B fait de même 2 secondes plus tard, ils écrasent leurs modifications respectives sans le savoir.*

La solution Git classique est la branche (`git switch`), mais elle change le dossier pour tout le monde en même temps (séquentiel). 
**La solution pour le parallèle est le Worktree.**

---

# 2. Qu'est-ce qu'un Worktree ?

C'est un dossier supplémentaire, rattaché au même dépôt Git, mais possédant **sa propre branche** et ses propres fichiers de travail.

```text
 Dépôt Git (Base de données partagée)
  │
  ├── dossier principal/       (branche: main)
  │
  ├── .claude/worktrees/feat1/ (branche: worktree-feat1)
  │
  └── .claude/worktrees/feat2/ (branche: worktree-feat2)
```

**Règle d'or :** Un worktree isole les **écritures**. Il ne fusionne pas les résultats à votre place, c'est à vous de le faire à la fin.

---

# 3. Lancement et cycle de vie d'un worktree

### A. Lancer la session isolée
```bash
claude --worktree normalize
```
Claude crée le dossier `.claude/worktrees/normalize/`, la branche `worktree-normalize` et y bascule la session. 
Vous donnez vos instructions (ex: *crée le fichier `normalize.js` et teste*).
Dans un autre terminal, vous pouvez faire la même chose : `claude --worktree farewell`. Les deux travaillent en même temps sans conflit !

### B. Conserver le travail
À la fin, vous tapez `/exit` dans chaque session.
Claude Code détecte que le dossier contient du travail non commité et vous demande : **Conserver ou Supprimer ?** Choisissez *Conserver*.

### C. Commiter, Fusionner et Nettoyer
Tout se fait depuis votre **dossier principal** !
```bash
# 1. On commit le travail depuis le dossier racine (avec le flag -C)
git -C .claude/worktrees/normalize add .
git -C .claude/worktrees/normalize commit -m "Ajout normalisation"

# 2. On fusionne la branche dans notre main
git switch main
git merge --no-ff worktree-normalize -m "Fusion"

# 3. On nettoie proprement
git worktree remove .claude/worktrees/normalize
git branch -d worktree-normalize
```

---

# 4. Configurer la création des Worktrees

### Les fichiers ignorés (Le piège du `.env`)
Un worktree est un checkout *propre*. Git ne copie pas les fichiers ignorés (comme `.env`). Votre code va donc crasher s'il a besoin du `.env` !
**Solution :** Créez un fichier `.worktreeinclude` à la racine de votre projet.
```text
# Contenu du fichier .worktreeinclude
.env
```
*(Ne mettez JAMAIS `node_modules` dedans, cela copierait des milliers de fichiers pour rien, `npm install` est fait pour ça, ou on se contente du module commun si node permet la remontée).*

### La base de création (Le piège des commits locaux)
Par défaut, Claude crée le worktree depuis `origin/HEAD` (le serveur distant). Si vous aviez des commits locaux non poussés, ils seront absents du worktree !
**Solution :** Forcer le départ depuis le `HEAD` local via `.claude/settings.json`.
```json
{
  "worktree": {
    "baseRef": "head"
  }
}
```

---

# Les 5 points les plus importants

1. Changer de branche modifie le dossier courant, tandis qu'un worktree ouvre la branche dans un dossier physiquement séparé.
2. Un worktree partage l'historique `.git` du dépôt principal, mais possède son propre index et ses propres fichiers de travail.
3. Les fichiers non suivis par Git (ex: config locale) ne sont copiés dans le worktree que s'ils sont listés dans `.worktreeinclude`.
4. Claude Code crée ses worktrees à partir de la branche distante (`origin/HEAD`) par défaut pour garantir un état propre, ignorant les commits locaux non poussés.
5. Après fusion, la commande `git worktree remove` supprime le dossier de travail, mais il faut toujours supprimer manuellement la branche avec `git branch -d`.

---

# Carte mentale

```text
Git Worktrees et Claude Code
├── Concept
│   ├── Partage de la BDD Git (.git)
│   ├── Dossier physique séparé
│   └── Branche exclusive
├── Lancement et Configuration
│   ├── claude --worktree <nom>
│   ├── baseRef: "head" (vs "fresh" par défaut)
│   └── .worktreeinclude (copie du .env)
└── Cycle de livraison
    ├── /exit -> Conserver le travail
    ├── git -C <chemin> commit
    ├── git merge (depuis main)
    └── Nettoyage (remove + branch -d)
```

---

# Mini fiche de révision

```text
Worktree = isolation physique des écritures sans cloner tout le repo.
claude --worktree = création auto dans .claude/worktrees/ avec une branche dédiée.
Fichiers ignorés non copiés par défaut : utiliser .worktreeinclude.
Départ depuis branche distante par défaut : configurer "baseRef": "head" si besoin des commits locaux.
Nettoyage = git worktree remove (le dossier) + git branch -d (la branche).
```

> **Phrase à retenir** : Les *worktrees* empêchent les écrasements directs pendant le développement parallèle, mais ils n'empêchent pas les conflits de fusion à la fin !
