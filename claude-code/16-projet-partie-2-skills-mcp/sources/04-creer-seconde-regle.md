Rappel : les worktrees
Un worktree est un répertoire de travail rattaché au même dépôt Git. Contrairement à un clone, il ne duplique pas la base de données : il partage l'historique et n'ajoute que les fichiers de travail. Chaque worktree a sa propre branche et son répertoire.
Contrainte : deux worktrees ne peuvent pas avoir la même branche extraite en même temps.

Pourquoi c'est utile avec Claude Code ?
La session est isolée.
> Bénéfices concrets :
> - plusieurs sessions en parallèle sans conflit d'écriture ;
> - l'arbre principal reste propre et disponible ;
> - pas de remisage ni de changement de branche à chaque interruption ;
> - une session ratée s'abandonne en supprimant son répertoire.

Comment un worktree est créé ?
- Lancement : `claude --worktree <nom>`
- En cours : Demander à Claude d'en créer un et d'y basculer.
- Automatique (selon réglages).
Basculer dans un worktree déplace le répertoire courant et emporte la configuration du projet (`CLAUDE.md`).
`claude/worktrees` est l'exception de la protection en écriture de `.claude/`.

Sortir d'un worktree
Si interactif, Claude vérifie ce que la suppression détruirait.
> Sortie sans aucun changement : le worktree et sa branche sont supprimés automatiquement.
> Sortie avec des changements : Claude demande s'il faut conserver ou supprimer. Conserver garde le répertoire, Supprimer détruit tout (y compris commits non poussés).

Reprendre une session
Si le worktree existe, la reprise ramène la session dedans. S'il n'existe plus, la session reprend dans le répertoire de lancement (le contexte de travail, lui, est perdu).

Supprimer un worktree proprement
1. Vérifier : `git -C <chemin-du-worktree> status --short`
2. Mettre à l'abri : pousser, PR ou fusionner.
3. Supprimer avec Git : `git worktree remove <chemin>`. La commande refuse s'il reste du travail non commité.
4. Nettoyer les références : `git worktree prune` (efface les entrées fantômes). Attention, supprimer le worktree ne supprime pas sa branche.

Préparer l'issue de la règle MEM005
Le prompt décrit la règle (détecter sauts descendants incohérents de titres, ex: `#` vers `###`), tranche d'avance plusieurs cas (remontée autorisée, titre niveau 3 au début autorisé, warn) et demande un draft d'issue via la skill `new-rule`.
Le draft proposé tranche des cas limites :
- Fichier vide : 0 finding.
- Fences : ignorés.
- Après remontée : comparaison repart du titre précédent immédiat.
- Plusieurs sauts invalides : un finding par titre fautif.

Les décisions de conception
Deux points signalés comme amendables dans le draft :
> - le finding est rattaché à la ligne du titre fautif
> - après une remontée, la comparaison se fait toujours avec le titre précédent immédiat, et non avec la pile des ancêtres.
Une décision annoncée peut être renversée, une décision silencieuse se découvre en lisant le code.

Demander le plan dans une session neuve
> Récupère l'issue numéro 5 et propose-moi un plan d'implémentation. À la moindre ambiguïté, pose-moi des questions.

La skill ne s'est pas déclenchée. Le plan se construit sans que `new-rule` soit invoquée. Claude pose la question de pourquoi la skill ne s'est pas lancée.
Diagnostic : la description de la skill parlait "d'ajouter une règle", pas de "traiter une issue décrivant une règle".
> Correction : élargir la description de la skill, pas le corps.

Questions posées par la skill :
- Titres sans texte ? -> Les inclure (diverge de MEM004, mais c'est décidé et écrit).
- Inclure la mise à jour de la description de la skill ? -> Oui.

Le plan obtenu et la capitalisation
L'étape 9 du plan prévoit de mettre à jour la description de la skill.
> Ajouter le déclencheur manquant : utiliser aussi la skill quand la demande porte sur le traitement, la planification ou l'implémentation d'une issue décrivant une règle.
C'est de la capitalisation : un défaut rencontré est corrigé dans le même flux que la fonctionnalité pour ne plus se reproduire.

Livraison
Vérification de bout en bout : tests unitaires, agrégation, fixtures, dogfooding au vert. 
Le plan est exécuté, commandes passent, PR ouverte et fusionnée. Le worktree peut être supprimé.
