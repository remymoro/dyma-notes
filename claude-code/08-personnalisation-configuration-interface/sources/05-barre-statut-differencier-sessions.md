# Construire une barre de statut utile et différencier les sessions

Dans cette leçon, vous allez configurer deux éléments qui réduisent fortement les erreurs de contexte dans Claude Code : la barre de statut et la couleur de session. La barre de statut permet d’afficher en permanence des informations utiles comme le modèle, le répertoire courant, la branche Git, le worktree, l’usage du contexte, le coût estimé, la durée de session ou le style de sortie. La couleur de session permet de distinguer visuellement plusieurs sessions ouvertes en même temps.

Ces réglages deviennent importants dès que vous travaillez sur plusieurs branches, plusieurs worktrees, plusieurs onglets de terminal ou plusieurs tâches en parallèle. Une session peut être en lecture seule, une autre en correction, une autre en revue, une autre en refactorisation. Sans repère visuel, il devient facile d’écrire dans le mauvais terminal ou de demander une modification dans le mauvais dépôt.

Le fil rouge reste le mini-projet `convertisseur-temperature`. Vous allez configurer l’interface sans modifier la logique du projet. Les seules modifications possibles concernent des fichiers de configuration ou des scripts de barre de statut, pas le code applicatif.

## Les commandes de cette leçon

Cette leçon utilise deux commandes principales :

*   `/statusline` configure la ligne de statut de Claude Code. Vous pouvez lui décrire en langage naturel ce que vous voulez afficher, ou créer manuellement un script local qui lit les données de session et imprime une ligne de statut.
*   `/color` change la couleur de la barre d’invite pour la session actuelle. Elle ne change pas le thème complet de Claude Code. Elle sert seulement à marquer visuellement une session.

## Comprendre le rôle de la barre de statut

La barre de statut est une ligne affichée en bas de l’interface. Elle sert à garder visibles les informations qui évitent les erreurs : modèle actif, dossier courant, branche Git, usage du contexte, coût, durée, worktree, nom de session ou style de sortie.

Elle est particulièrement utile dans quatre situations :
1. vous travaillez sur plusieurs sessions Claude Code ;
2. vous utilisez plusieurs branches Git ;
3. vous utilisez plusieurs worktrees ;
4. vous voulez surveiller le contexte, le coût ou la durée d’une session.

La barre de statut n’est pas une preuve de validation. Elle donne des repères. Pour valider une modification, il faut toujours regarder le diff, vérifier les tests et demander la preuve finale.

## Configurer rapidement avec /statusline

La manière la plus simple de créer une barre de statut consiste à utiliser `/statusline` avec une demande en langage naturel.
Claude Code peut générer automatiquement un script dans votre dossier `~/.claude/` et mettre à jour vos paramètres. C’est la méthode la plus simple pour commencer.

```bash
/statusline crée une barre courte qui affiche le modèle, le dossier courant, la branche Git et le pourcentage de contexte.
```
Vous pouvez demander une version un peu plus complète :
```bash
/statusline affiche le modèle, le dossier, la branche Git, le worktree si présent, le contexte utilisé, le coût estimé et la session.
```

Gardez la barre courte au début. Une barre de statut trop chargée devient illisible. Elle doit servir à voir l’essentiel en un coup d’œil.

## Ce qu’une bonne barre de statut doit afficher

Pour une première configuration, affichez seulement les informations qui réduisent les erreurs réelles.

**Barre de statut minimale :**
- modèle actif ;
- dossier courant ;
- branche Git ;
- pourcentage de contexte utilisé.

Dans le mini-projet, une barre minimale suffit. Dans un vrai dépôt, la branche et le worktree deviennent beaucoup plus importants. Une modification faite sur la mauvaise branche peut coûter plus cher qu’une barre de statut légèrement plus longue.

**Barre de statut plus complète :**
- modèle actif ;
- dossier courant ;
- branche Git ;
- worktree ;
- contexte utilisé ;
- coût estimé ;
- durée ;
- session ;
- style de sortie.

### Demander une barre adaptée au mini-projet

Pour le projet `convertisseur-temperature`, vous pouvez demander une barre simple. Après la configuration, envoyez une petite demande pour déclencher la mise à jour de la barre.

```text
Ne modifie aucun fichier.
Dis-moi seulement si la barre de statut affiche maintenant :
1. le modèle ;
2. le dossier ;
3. la branche ;
4. le contexte.
```
La barre peut ne pas se mettre à jour immédiatement tant qu’aucune nouvelle interaction n’a eu lieu. Si vous modifiez un script de barre de statut, envoyez un message court pour déclencher le rafraîchissement.

## Comprendre le fonctionnement interne

La barre de statut fonctionne avec un script shell. Claude Code envoie les données de session au script sous forme de JSON via `stdin`. Le script lit ce JSON, extrait les champs nécessaires, puis imprime du texte sur `stdout`. Tout ce que le script imprime devient la barre de statut.

Le script s’exécute localement. Il ne consomme pas de jetons API. Il doit donc rester rapide, prévisible et sans effet de bord.

Flux de fonctionnement :
1. Claude Code prépare les données de session.
2. Les données sont envoyées au script via stdin.
3. Le script lit le JSON.
4. Le script extrait les champs utiles.
5. Le script imprime une ou plusieurs lignes.
6. Claude Code affiche cette sortie en bas de l’interface.

## Créer une barre de statut manuellement

Vous pouvez aussi créer vous-même le script. Cette méthode est plus explicite et permet de comprendre exactement ce qui s’affiche.

Créez d’abord le dossier si nécessaire :
```bash
mkdir -p ~/.claude
```

Créez ensuite un script de barre de statut :
```bash
cat > ~/.claude/statusline-convertisseur.sh <<'EOF'
#!/usr/bin/env bash
# Lire les données JSON envoyées par Claude Code.
donnees="$(cat)"
# Extraire les champs utiles avec jq.
modele="$(echo "$donnees" | jq -r '.model.display_name // "modèle inconnu"')"
dossier="$(echo "$donnees" | jq -r '.workspace.current_dir // .cwd // ""')"
contexte="$(echo "$donnees" | jq -r '.context_window.used_percentage // 0')"
cout="$(echo "$donnees" | jq -r '.cost.total_cost_usd // 0')"
session="$(echo "$donnees" | jq -r '.session_name // .session_id // "session"')"

# Réduire le chemin au nom du dossier courant.
nom_dossier="${dossier##*/}"
# Récupérer la branche Git si le dossier est dans un dépôt.
branche="$(git -C "$dossier" branch --show-current 2>/dev/null || true)"
if [ -z "$branche" ]; then
 branche="sans branche"
fi

# Afficher une ligne courte et lisible.
printf "[%s] %s | %s | %s%% contexte | $%s | %s\n" \
 "$modele" \
 "$nom_dossier" \
 "$branche" \
 "$contexte" \
 "$cout" \
 "$session"
EOF
```

Rendez le script exécutable :
```bash
chmod +x ~/.claude/statusline-convertisseur.sh
```

### Configurer le script dans les settings personnels

Pour utiliser ce script comme barre de statut personnelle, ajoutez la configuration dans `~/.claude/settings.json`.

```json
{
 "statusLine": {
 "type": "command",
 "command": "~/.claude/statusline-convertisseur.sh"
 }
}
```
Ce réglage est personnel. Il dépend de votre script local, de votre terminal et de vos préférences d’affichage. Il doit donc rester dans votre dossier utilisateur, sauf si l’équipe décide explicitement de partager une barre de statut commune.

## Surveiller l’usage du contexte

La fenêtre de contexte peut devenir un sujet important dans les sessions longues. Une barre de statut peut afficher le pourcentage de contexte utilisé ou restant.

```bash
cat > ~/.claude/statusline-contexte.sh <<'EOF'
#!/usr/bin/env bash
# Lire les données JSON envoyées par Claude Code.
donnees="$(cat)"
modele="$(echo "$donnees" | jq -r '.model.display_name // "modèle"')"
utilise="$(echo "$donnees" | jq -r '.context_window.used_percentage // 0')"
restant="$(echo "$donnees" | jq -r '.context_window.remaining_percentage // 100')"
printf "[%s] contexte %s%% utilisé | %s%% restant\n" "$modele" "$utilise" "$restant"
EOF
chmod +x ~/.claude/statusline-contexte.sh
```

Cette information aide à savoir quand une session devient longue, quand il faut envisager une compaction ou quand il devient préférable de repartir dans une session plus propre. Il ne faut pas interpréter le pourcentage de contexte comme une mesure de qualité. Le contexte utilisé est un signal de capacité, pas une preuve de compréhension.

## Surveiller le coût et la durée

La barre de statut peut aussi afficher le coût estimé et la durée de session. Cela devient utile quand une tâche dure longtemps, quand plusieurs sessions sont ouvertes ou quand vous voulez suivre l’impact d’un workflow.

Le coût affiché est une estimation côté client. Il peut aider à suivre une session, mais il ne doit pas être traité comme une facture exacte.

```bash
cat > ~/.claude/statusline-cout.sh <<'EOF'
#!/usr/bin/env bash
# Lire les données JSON envoyées par Claude Code.
donnees="$(cat)"
cout="$(echo "$donnees" | jq -r '.cost.total_cost_usd // 0')"
duree_ms="$(echo "$donnees" | jq -r '.cost.total_duration_ms // 0')"
# Convertir la durée de millisecondes en minutes approximatives.
duree_min=$((duree_ms / 60000))
printf "coût estimé $%s | durée %s min\n" "$cout" "$duree_min"
EOF
chmod +x ~/.claude/statusline-cout.sh
```

## Créer une barre de statut complète mais lisible

Vous pouvez combiner plusieurs informations dans une seule ligne. Gardez cependant une limite : la barre de statut doit rester lisible sur la largeur de votre terminal.

```bash
cat > ~/.claude/statusline-complete.sh <<'EOF'
#!/usr/bin/env bash
# Lire les données JSON envoyées par Claude Code.
donnees="$(cat)"
modele="$(echo "$donnees" | jq -r '.model.display_name // "modèle"')"
dossier="$(echo "$donnees" | jq -r '.workspace.current_dir // .cwd // ""')"
nom_dossier="${dossier##*/}"
contexte="$(echo "$donnees" | jq -r '.context_window.used_percentage // 0')"
cout="$(echo "$donnees" | jq -r '.cost.total_cost_usd // 0')"
style="$(echo "$donnees" | jq -r '.output_style.name // "default"')"
session="$(echo "$donnees" | jq -r '.session_name // "session"')"
branche="$(git -C "$dossier" branch --show-current 2>/dev/null || true)"
worktree="$(echo "$donnees" | jq -r '.workspace.git_worktree // .worktree // ""')"

if [ -z "$branche" ]; then
 branche="sans branche"
fi

if [ -n "$worktree" ]; then
 cible="$branche/$worktree"
else
 cible="$branche"
fi

printf "[%s] %s | %s | %s%% ctx | $%s | %s | %s\n" \
 "$modele" \
 "$nom_dossier" \
 "$cible" \
 "$contexte" \
 "$cout" \
 "$style" \
 "$session"
EOF
chmod +x ~/.claude/statusline-complete.sh
```

Configurez-la ensuite :
```json
{
 "statusLine": {
 "type": "command",
 "command": "~/.claude/statusline-complete.sh"
 }
}
```

## Utiliser plusieurs lignes ou de la couleur

Une barre de statut peut afficher plusieurs lignes si le script imprime plusieurs lignes. Cela peut être utile pour séparer les informations de contexte et les informations de coût.
Votre script peut aussi utiliser des codes ANSI pour colorer certains éléments (ex: la branche en vert quand le dépôt est propre, jaune sinon).

```bash
cat > ~/.claude/statusline-git-couleur.sh <<'EOF'
#!/usr/bin/env bash
# Lire les données JSON envoyées par Claude Code.
donnees="$(cat)"
dossier="$(echo "$donnees" | jq -r '.workspace.current_dir // .cwd // ""')"
nom_dossier="${dossier##*/}"
branche="$(git -C "$dossier" branch --show-current 2>/dev/null || true)"
etat="$(git -C "$dossier" status --short 2>/dev/null || true)"

if [ -z "$branche" ]; then
 branche="sans branche"
fi

vert="\033[32m"
jaune="\033[33m"
reset="\033[0m"

if [ -n "$etat" ]; then
 printf "%s | %b%s%b | modifications en cours\n" "$nom_dossier" "$jaune" "$branche" "$reset"
else
 printf "%s | %b%s%b | propre\n" "$nom_dossier" "$vert" "$branche" "$reset"
fi
EOF
chmod +x ~/.claude/statusline-git-couleur.sh
```

## Éviter les scripts lents

La barre de statut se met à jour régulièrement. Un script trop lent rend l’interface moins agréable. Évitez les commandes coûteuses :
- npm test ;
- npm run build ;
- requête réseau ;
- appel API ;
- analyse complète du dépôt ;
- recherche récursive lourde ;
- commande qui peut attendre une entrée utilisateur.

## Désactiver la barre de statut

Si la barre devient gênante, supprimez-la avec `/statusline` :
```bash
/statusline clear
# ou
/statusline delete
# ou
/statusline remove it
```
Vous pouvez aussi supprimer manuellement le champ `statusLine` de votre fichier `settings.json`.

## Comprendre /color

`/color` sert à changer la couleur de la barre d’invite pour la session actuelle. Cette couleur est un repère visuel. Elle ne modifie pas le thème général, ne change pas le modèle, ne change pas les permissions et ne garantit pas la sécurité d’une tâche.

Les couleurs disponibles sont : `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `default`.
`default` réinitialise la couleur de la session.

```bash
/color green
/color cyan
/color yellow
/color purple
/color red
/color default
```

## Créer une convention de couleurs

La couleur devient utile si vous utilisez une convention stable. Sans convention, elle devient seulement décorative. Vous pouvez adapter cette convention :

- `green` : Session de lecture seule.
- `cyan` : Session de correction limitée.
- `yellow` : Session d’exploration ou de planification.
- `purple` : Session de refactorisation.
- `red` : Session risquée ou zone sensible.

Ces couleurs sont de purs repères visuels pour l'utilisateur. La couleur verte ne force pas techniquement la lecture seule, c'est votre prompt et vos validations qui le font.

## Utiliser /color avec plusieurs worktrees

Les worktrees permettent d’avoir plusieurs copies de travail du même dépôt sur des branches différentes. Dans ce cas, `/color` et `/statusline` se complètent.
Exemple de convention :
- worktree lecture → `/color green`
- worktree bugfix → `/color cyan`
- worktree refactor → `/color purple`

La barre de statut doit afficher le worktree ou la branche. La couleur doit donner un repère rapide. Les deux ensemble réduisent les erreurs de session.

## Créer une barre de statut d’équipe

Si toute l’équipe veut la même barre de statut, vous pouvez placer la configuration dans `.claude/settings.json`. Le script peut aussi être versionné dans le dépôt, par exemple dans `.claude/statusline.sh`.

```bash
mkdir -p .claude
cat > .claude/statusline.sh <<'EOF'
...
EOF
chmod +x .claude/statusline.sh
```

```json
{
 "statusLine": {
 "type": "command",
 "command": ".claude/statusline.sh"
 }
}
```

## Dépanner une barre de statut

Si la barre ne s’affiche pas, vérifiez :
1. `jq` n’est pas installé ;
2. le script n’est pas exécutable ;
3. le chemin dans `settings.json` est incorrect ;
4. le JSON ne contient pas le champ attendu ;
5. la commande Git échoue hors dépôt.

Test manuel (très utile) :
```bash
echo '{
 "model": { "display_name": "Sonnet" },
 "workspace": { "current_dir": "'"$PWD"'" },
 "context_window": { "used_percentage": 12 },
 "cost": { "total_cost_usd": 0.01 },
 "session_name": "test"
}' | ~/.claude/statusline-convertisseur.sh
```

## Utiliser refreshInterval avec prudence

La configuration `statusLine` peut inclure un intervalle de rafraîchissement (`refreshInterval`).
```json
{
 "statusLine": {
 "type": "command",
 "command": "~/.claude/statusline-complete.sh",
 "refreshInterval": 5
 }
}
```
Ce réglage réexécute la commande toutes les N secondes. Utile pour une horloge, mais à éviter sans besoin réel car la barre doit rester très rapide.

## Afficher le mode Vim, le style de sortie, le nom de session

Si vous utilisez Vim, vous pouvez extraire `.vim.mode`.
Pour le style de sortie : `.output_style.name`.
Pour le nom de session : `.session_name // .session_id`.

## Exemple complet de session

Dans Claude Code :
```bash
claude --name convertisseur-lecture
/color green
```
Puis dans une autre :
```bash
claude --name convertisseur-interface
/color cyan
```

## Ne pas surcharger la barre de statut

Signes d’une barre surchargée :
1. elle dépasse la largeur du terminal ;
2. elle contient des informations que vous ne regardez jamais ;
3. elle rend les sessions visuellement bruyantes ;
4. elle exige trop de maintenance ;
5. elle ralentit l’interface.

Retirez tout ce qui ne sert pas à prendre une décision.

![Tableau de configuration de la barre de statut](../assets/status-table.png)
![Aperçu de la barre de statut](../assets/status-preview.png)
