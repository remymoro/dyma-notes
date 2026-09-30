Comprendre l’isolation apportée par un worktree
Deux sessions Claude Code peuvent posséder des conversations indépendantes tout en modifiant le même dossier. Les contextes sont séparés, mais les fichiers restent partagés. Deux sessions qui modifient simultanément `src/app.js` peuvent écraser leurs changements ou travailler sur un contenu devenu obsolète.
Un worktree Git ajoute un répertoire de travail et une branche distincts.

```text
Dépôt Git
 |
 +-- dossier principal (branche main)
 |
 +-- worktree normalize (branche worktree-normalize)
```

Chaque worktree possède ses propres fichiers, son propre index Git et ses modifications locales. L'historique des commits et les remotes restent partagés.
> Un worktree isole les écritures. Il ne distribue pas les tâches et ne fusionne pas les résultats.

Comparer une branche et un worktree
- **Branche seule** : Le dossier courant change avec `git switch`. Une seule version des fichiers est visible. Adaptée au travail séquentiel.
- **Branche avec worktree** : Chaque branche reste ouverte dans son propre dossier. Plusieurs versions sont disponibles simultanément. Adapté aux sessions parallèles.

Préparer les fichiers locaux
Les nouveaux worktrees sont des checkouts propres. Les fichiers ignorés ou non suivis ne sont pas présents automatiquement.
Ajoutez `.worktreeinclude` pour copier le fichier `.env` dans chaque nouveau worktree :
```text
.env
```
Seuls les fichiers correspondant à `.worktreeinclude` et ignorés par Git sont copiés. N'y ajoutez pas un dossier volumineux comme `node_modules`.

Approuver le dossier
Avant la première utilisation de `--worktree`, lancez Claude Code une fois depuis le projet et acceptez la boîte de confiance. Quittez ensuite (`/exit`).

Créer deux sessions isolées
Dans un premier terminal :
> `claude --worktree normalize`
Claude Code crée normalement :
Dossier : `.claude/worktrees/normalize/`
Branche : `worktree-normalize`
Attribuez la première mission :
> Dans ce worktree uniquement : crée src/normalize-name.js [...] Ne crée aucun commit. Ne pousse rien. N'ouvre aucune pull request.

Dans un second terminal ouvert depuis le dossier principal :
> `claude --worktree farewell`
Attribuez une mission indépendante (ex: `farewell.js`).

Observer l’isolation
Dans un troisième terminal, depuis le dossier principal :
> `git worktree list`
Vérifiez les branches :
> `git -C .claude/worktrees/normalize branch --show-current`
Comparez les modifications :
> `git -C .claude/worktrees/normalize status --short`
Le dossier principal reste propre. Chaque session possède ses propres modifications.

Comprendre la base du worktree
Par défaut, Claude Code crée le nouveau worktree depuis `origin/HEAD`. Il obtient donc un état propre correspondant à la branche principale distante.
Sans remote disponible, Claude Code utilise le `HEAD` local.
Pour toujours partir du `HEAD` local, configurez `.claude/settings.json` :
```json
{
  "worktree": {
    "baseRef": "head"
  }
}
```
*`fresh` : Part de la branche principale distante. `head` : Part du HEAD local et inclut les commits non poussés.*
Les modifications non committées ne sont copiées dans aucun des deux cas.

Conserver puis committer le travail
Quittez les deux sessions avec `/exit`. Comme les worktrees contiennent des changements, Claude Code propose de les conserver ou de les supprimer.
Choisissez de les conserver, puis créez les commits depuis le dossier principal :
> `git -C .claude/worktrees/normalize add .`
> `git -C .claude/worktrees/normalize commit -m "Ajouter la normalisation"`

Fusionner les branches
> `git switch main`
> `git merge --no-ff worktree-normalize -m "Fusionner la normalisation"`
Les worktrees ont empêché les écrasements directs. Ils n'empêchent pas un conflit de fusion si deux branches modifient les mêmes lignes.

Nettoyer les worktrees
> `git worktree remove .claude/worktrees/normalize`
> `git branch -d worktree-normalize`

**État à la sortie / Nettoyage** :
- *Aucun changement, fichier ou nouveau commit* : Suppression automatique possible.
- *Travail présent* : Claude Code propose de conserver ou supprimer.
- *Exécution avec -p* : Nettoyage manuel avec `git worktree remove`.

Autres utilisations
Claude Code peut générer automatiquement un nom : `claude --worktree`
Une session existante peut entrer dans un nouveau worktree avec l'outil `EnterWorktree`.
Pour travailler depuis une pull request : `claude --worktree "#1234"`
Un sous-agent peut aussi utiliser : `isolation: worktree` (Son worktree est supprimé automatiquement lorsqu'il termine sans produire de changement).
