Préparer deux gardiens complémentaires
Un sous-agent est utile pour une vérification spécialisée répétée. Nous créons deux profils en lecture seule :
1. `gardien-francais` : Vérifier que le vocabulaire du projet est en français.
2. `gardien-temperature` : Vérifier calculs, limites et tests du convertisseur.
Ils peuvent analyser le projet simultanément sans risque de collision (fichiers partagés mais pas d'écriture).

Vérifier l'état du projet
Le dépôt doit être propre : `git status --short`, `npm test`, `mkdir -p .claude/agents`.

Créer le gardien-francais
On crée le fichier `.claude/agents/gardien-francais.md` :
```yaml
---
name: gardien-francais
description: Vérifie que les identifiants... sont en français.
tools: Read, Grep, Glob
model: haiku
effort: medium
maxTurns: 8
background: true
color: blue
---
Tu es le gardien de la cohérence linguistique française.
Analyse : fonctions, variables...
Ne signale pas : mots-clés langage, API standards...
Ne modifie aucun fichier.
```
> Il utilise `haiku` (modèle léger) car son travail repose sur l'inventaire et la classification d'identifiants.

Créer le gardien-temperature
Fichier `.claude/agents/gardien-temperature.md` :
```yaml
---
name: gardien-temperature
description: Vérifie les formules, l'arrondi, les tests...
tools: Read, Grep, Glob, Bash
model: sonnet
effort: high
maxTurns: 10
background: true
color: orange
---
Tu es le gardien de la correction scientifique.
Vérifie : formules, cas -40 degrés, symétrie...
Exécute uniquement `npm test`.
Distingue défaut confirmé de test manquant.
Ne modifie aucun fichier.
```
> Il utilise `sonnet` (modèle plus capable) car il doit relier des formules, contrats et preuves.

Charger les profils
Les profils sur le disque sont chargés au démarrage d'une session (`claude`).
Vérifiez leur présence avec la commande `/agents` (onglet Library).

Préparer la permission du test
Le `gardien-temperature` tourne en arrière-plan (`background: true`) et possède l'outil `Bash`. Il ne peut pas attendre une permission humaine.
Ouvrez `/permissions` et ajoutez la règle exacte : `Bash(npm test)`.
> N'autorisez pas l'ensemble de Bash !

Lancer les deux gardiens en parallèle
Les formes d'invocation :
- Nom en langage naturel : Claude décide.
- Mention `@` : Garantit l'utilisation du profil.
- `claude --agent` : Remplace l'agent principal pour la session.

Dans la zone de texte : saisissez `@` et sélectionnez les deux profils.
> "Lance les deux analyses en parallèle.
> @gardien-francais Analyse tout le code...
> @gardien-temperature Analyse la logique et exécute npm test.
> Les deux agents restent en lecture seule. Attends leurs rapports avant de produire une synthèse."
Puisque les profils ont `background: true`, la conversation principale reste disponible.

Suivre l'exécution et examiner les résultats
Ouvrez `/tasks` : la liste doit contenir les deux travaux. (L'onglet Running de `/agents` permet aussi d'ouvrir/arrêter).
- Le `gardien-francais` doit distinguer les API standards (ex: `document.querySelector`) des variables du projet (`temperatureInput`).
- Le `gardien-temperature` va signaler des tests manquants (ex: pour -40°C), ce qui n'est pas forcément un défaut fonctionnel.

Faire synthétiser les rapports
Une fois les sous-agents terminés, demandez au parent :
> "Synthétise les deux rapports. Sépare les incohérences linguistiques, défauts scientifiques, tests manquants... Déduplique. Ne modifie aucun fichier."
La conversation principale reçoit et synthétise les conclusions **sans** avoir chargé toutes les recherches intermédiaires dans son propre contexte (économie de jetons et de clarté).

Vérifier l'absence de modification
`git status --short` : seuls les deux nouveaux fichiers Markdown dans `.claude/agents/` doivent apparaître !
