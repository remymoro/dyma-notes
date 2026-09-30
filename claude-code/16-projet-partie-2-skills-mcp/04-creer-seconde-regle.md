---
cours: Claude Code
chapitre: 16-projet-partie-2-skills-mcp
leçon: 04-creer-seconde-regle
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi utiliser un *worktree* avec Claude Code ?** | Le worktree permet d'isoler la session de l'agent. Ses modifications de fichiers et ses exécutions de tests ne perturbent pas l'arbre principal. En cas d'échec total de l'IA, on peut simplement supprimer le répertoire sans affecter le dépôt. |
| **Peut-on extraire la même branche dans deux worktrees ?** | **Non**. C'est une contrainte stricte de Git : chaque worktree doit être associé à sa propre branche. |
| **Que fait la commande `git worktree prune` ?** | Elle nettoie les métadonnées de Git. Si vous supprimez le dossier d'un worktree "à la main" (via l'explorateur ou `rm`), Git continue de croire qu'il existe. `prune` efface cette référence fantôme. |
| **Si une *skill* ne se déclenche pas, d'où vient l'erreur ?** | Le plus souvent, l'erreur vient de la **description** de la skill, et non de son corps d'exécution. La description est le *déclencheur* utilisé par Claude pour faire la correspondance avec votre prompt. |
| **Qu'est-ce que la "capitalisation" en fin de leçon ?** | L'IA n'a pas réussi à déclencher la skill d'elle-même. Au lieu de corriger le problème plus tard, l'IA a inclus une **étape 9** dans son plan d'implémentation pour "mettre à jour la description de la skill". Le défaut est corrigé immédiatement, dans le même flux. |

## Synthèse
Cette leçon illustre la résilience et l'isolation du travail avec l'agent via les **Git Worktrees**. Un worktree permet à Claude de travailler dans un répertoire isolé, sans polluer l'historique ou l'arbre principal du développeur. Lorsque le travail est fusionné ou abandonné, le nettoyage s'effectue proprement via `git worktree remove` et `git worktree prune`.
L'autre enseignement majeur concerne le déclenchement des **skills**. Si une skill ne s'active pas lors d'une session, ce n'est pas un bug de Claude, mais une description trop stricte (ex: la skill dit "créer une règle" mais le prompt dit "planifie cette issue"). Corriger ce défaut de description dans le même cycle de développement ("capitalisation") garantit que l'outil s'améliore continuellement avec le projet.

## Glossaire
- **Worktree** : Fonctionnalité Git permettant de cloner l'arbre de travail d'un dépôt dans un autre dossier, partageant la même base de données `.git` mais travaillant sur une branche isolée.
- **`git worktree prune`** : Commande vitale pour effacer les entrées fantômes de worktrees qui auraient été supprimés sauvagement avec l'explorateur de fichiers.
- **Description (de skill)** : Le métadonnée textuelle d'une skill. Ce n'est pas un résumé de courtoisie, c'est le **déclencheur algorithmique** qui indique à Claude quand l'invoquer.
- **Capitalisation** : Pratique consistant à corriger immédiatement les outils de développement (comme l'enrichissement d'une skill) lors d'un cycle de développement fonctionnel, plutôt que de créer un ticket de dette technique.

## Questions d'auto-évaluation
1. Quelles sont les 4 étapes pour supprimer un *worktree* le plus proprement possible ?
2. Un *worktree* supprimé via Git supprime-t-il automatiquement la branche qui lui était associée ?
3. Lors de la génération d'un draft d'issue, pourquoi Claude a-t-il affiché spécifiquement des décisions qu'il nomme "amendables" ?
4. Si vous voulez être sûr que Claude utilise une *skill* sur un certain type de tâche qu'il ignorait jusqu'ici, que devez-vous modifier dans la *skill* ?

# Création d'une seconde règle

**Durée : 15 minutes**

## Objectif de la leçon
Apprendre à sécuriser les sessions de l'agent en utilisant les *Git Worktrees* pour isoler les expérimentations. Déboguer une *skill* qui ne se déclenche pas, comprendre le rôle clé de sa description, et appliquer le concept de capitalisation continue.

---

# 1. Isoler le travail de Claude (Les Worktrees)

Un **worktree** évite que Claude ne saccage votre branche `main` pendant que vous travaillez.

```text
 depot/
  ├── .git/                 <-- Base partagée (commits)
  ├── ...                   <-- Arbre principal (branche main)
  └── .claude/
       └── worktrees/
            └── session-1/  <-- Arbre lié, sa propre branche, ses propres fichiers
```

### Bénéfices :
- Les tests de la session 1 ne cassent pas la session 2.
- Pas besoin de faire des `git stash` en permanence.
- Une session qui "hallucine" gravement peut être abandonnée en jetant simplement le répertoire.

### Suppression propre (En 4 étapes)
Ne supprimez jamais un worktree via l'explorateur de fichiers. Utilisez Git :
1. `git -C <chemin> status --short` (Vérifier qu'il n'y a pas de travail en cours).
2. Pousser, fusionner ou faire une PR pour sauvegarder.
3. `git worktree remove <chemin>` (Git bloquera si des fichiers non commités y traînent).
4. `git worktree prune` (Pour nettoyer les entrées fantômes si une erreur a eu lieu).
*Attention : La branche reste vivante. Elle doit être supprimée séparément (`git branch -d`).*

---

# 2. Le rôle critique de la Description d'une Skill

Lors d'une nouvelle session, le prompt demandait de "traiter l'issue 5". Bien que l'issue décrive l'ajout d'une règle, **la skill `new-rule` ne s'est pas déclenchée automatiquement**.

Pourquoi ?
> La description de la skill disait : *"Ajouter une règle"*
> Le prompt disait : *"Planifier l'implémentation d'une issue"*
La correspondance n'était pas assez explicite pour le moteur de déclenchement.

**La leçon :** La description d'une skill **est son déclencheur**. Si elle ne s'invoque pas, c'est la description qu'il faut élargir (ex: ajouter *"utiliser pour la planification d'une issue décrivant une règle"*), pas le contenu de la skill.

---

# 3. La Capitalisation immédiate

Au lieu de faire une nouvelle Pull Request plus tard pour corriger la skill `new-rule`, Claude a suggéré d'intégrer cette réparation directement dans l'implémentation de la nouvelle règle (MEM005).

> **Plan obtenu (Extrait) :**
> `...`
> `8. Vérification finale`
> `9. Mettre à jour la description de la skill (Ajouter le déclencheur manquant)`

Un défaut rencontré une fois est encodé pour ne plus se reproduire, dans le même flux que la fonctionnalité.

---

# Tableau des commandes à retenir

| Commande Git | Rôle |
|---|---|
| `claude --worktree <nom>` | Lance une session Claude Code en créant et basculant directement dans un worktree isolé. |
| `git worktree remove <chemin>` | Supprime le répertoire de travail de manière sûre (refuse si le travail n'est pas commité). |
| `git worktree prune` | Nettoie les références mortes de worktrees supprimés manuellement hors de Git. |

# Les 5 points les plus importants

1. Deux worktrees rattachés au même dépôt ne peuvent **jamais** avoir la même branche extraite simultanément.
2. Un worktree permet à l'agent de travailler dans un bac à sable parfait, sans perturber votre arbre principal.
3. Une décision "amendable" annoncée explicitement par Claude dans un draft d'issue est une excellente chose : cela signifie qu'elle est visible avant le codage, et non cachée silencieusement dans le code.
4. Si une skill ne se déclenche pas toute seule, n'élargissez pas son code, élargissez sa **description** (son déclencheur).
5. La capitalisation implique de corriger vos outils de développement au sein même de vos itérations de travail.

---

# Carte mentale

```text
Sécurisation et Débogage
├── Les Git Worktrees
│   ├── Isoler le système de fichiers
│   ├── Gérer en parallèle sans stash
│   └── Nettoyage (remove + prune)
├── Le Draft d'Issue
│   ├── Trancher les cas limites en amont
│   └── Signaler les "choix amendables"
└── Débogage des Skills
    ├── Problème : Non déclenchement
    ├── Diagnostic : Description (déclencheur) trop stricte
    └── Solution : Capitalisation (Étape de correction intégrée)
```

---

# Mini fiche de révision

```text
Worktree = Arbre isolé + Branche propre. Évite les conflits de session Claude.
Suppression propre : Vérifier -> Mettre à l'abri -> `git worktree remove` -> `git worktree prune`.
Description de skill = Déclencheur IA. Si ça ne s'active pas, élargir la description.
Capitalisation = Améliorer ses outils de travail (skills) en même temps qu'on livre le produit.
```

> **Phrase à retenir** : La description d'une skill n'est pas un résumé de courtoisie, c'est son déclencheur algorithmique.
