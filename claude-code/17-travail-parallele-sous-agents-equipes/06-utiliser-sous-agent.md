---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 06-utiliser-sous-agent
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle différence de modèle LLM appliquer entre une tâche de classification sémantique et une tâche logique/mathématique ?** | Pour une tâche d'inventaire ou de classification de vocabulaire (ex: vérifier la langue des variables), un modèle léger comme **`haiku`** suffit amplement. Pour relier des formules complexes à des contrats de test, il faut un modèle plus capable, comme **`sonnet`**. |
| **Pourquoi est-il crucial de pré-approuver finement les commandes `Bash` pour un sous-agent en arrière-plan ?** | Car un sous-agent en `background` ne peut pas vous interrompre pour demander la permission d'exécuter une commande (sous peine de bloquer indéfiniment). Il faut donc utiliser `/permissions` et approuver la commande exacte, par exemple `Bash(npm test)`, **sans** autoriser `Bash` dans sa globalité. |
| **Quel est l'intérêt cognitif (jetons/clarté) pour l'agent principal de sous-traiter des revues de code complètes ?** | L'agent principal ne reçoit à la fin que les **rapports de synthèse**. Il n'a pas à charger tout le code, les fichiers intermédiaires et les logs de test explorés par les sous-agents dans son propre contexte (fenêtre de contexte préservée). |
| **Peut-on invoquer plusieurs profils d'un coup dans la même requête ?** | Oui, en utilisant les mentions garanties (`@profil-1`, `@profil-2`) au sein de la même invite. Si les profils sont configurés avec `background: true`, les analyses se lanceront en parallèle. |

## Synthèse
L'utilisation concrète de sous-agents personnalisés brille particulièrement dans le cadre d'audits ou de revues de code répétitives. En créant des fichiers Markdown de profil (placés dans `.claude/agents/`), on peut instancier des "gardiens" très ciblés. La configuration de ces gardiens doit s'adapter à leur tâche : un modèle rapide (`haiku`) pour de la relecture de nommage (Grep/Read simples), contre un modèle puissant (`sonnet`) si l'agent doit comprendre une logique mathématique, utiliser le terminal (`Bash`) et analyser des résultats de tests.
Pour que ces agents s'exécutent harmonieusement en parallèle (en tâche de fond via `background: true`), deux conditions de sécurité sont requises : 
1. Leur interdire formellement de modifier des fichiers ou de pousser du code.
2. Pré-approuver leurs commandes terminales critiques via l'interface `/permissions` (ex: autoriser uniquement `Bash(npm test)`). 
À l'arrivée, l'agent parent "chef d'orchestre" attend les rapports synthétiques pour produire un résumé humainement lisible, préservant ainsi la clarté de son propre contexte cognitif.

## Glossaire
- **`@mention`** : Syntaxe d'invocation stricte permettant d'obliger la conversation courante à déléguer une tâche spécifique au profil appelé (ex: `@gardien-francais`).
- **`haiku` vs `sonnet`** : Modèles d'Anthropic. `haiku` privilégie la vitesse et le faible coût pour des tâches textuelles simples. `sonnet` offre un raisonnement poussé pour la logique et le code complexe.
- **`Bash(npm test)`** : Règle d'autorisation (Whitelist) à enregistrer dans `/permissions` pour autoriser cette commande précise sans ouvrir un accès libre au shell.

## Questions d'auto-évaluation
1. Dans quel dossier devez-vous enregistrer vos profils personnalisés pour que Claude Code les charge automatiquement au démarrage du projet ?
2. Quelle commande tapez-vous pour lister les tâches (`background`) en cours d'exécution depuis la conversation principale ?
3. Que se passerait-il si vous oubliiez d'approuver `npm test` dans `/permissions` pour un sous-agent `background` nécessitant l'outil `Bash` ?

# Utiliser un sous-agent (Pratique)

**Durée : 11 minutes**

## Objectif de la leçon
Créer et invoquer deux sous-agents spécialisés (des "gardiens") en parallèle depuis la conversation principale. Configurer le modèle adapté à la complexité de chaque tâche et résoudre le problème des permissions `Bash` pour des agents asynchrones.

---

# 1. Scénario : Les deux Gardiens

Dans cette démonstration, on crée deux profils en lecture seule :
1. **`gardien-francais`** : Vérifie que tout le vocabulaire du projet (variables, fonctions) est en français, sans s'attaquer aux API standards (`document.querySelector`).
2. **`gardien-temperature`** : Exécute les tests, relit les formules de calcul et cherche les cas limites oubliés.

Ces profils sont enregistrés dans : `.claude/agents/`. *(Ils sont automatiquement chargés au prochain lancement de `claude`).*

---

# 2. Adapter le modèle à l'effort

Il ne faut pas gaspiller vos jetons (ou votre quota d'inférence) en utilisant `opus` ou `sonnet` pour vérifier des fautes de frappe.

### Gardien Français (Tâche sémantique et de recherche)
```yaml
model: haiku
tools: Read, Grep, Glob
effort: medium
background: true
```
> `haiku` est parfait ici car le travail repose uniquement sur de l'inventaire lexical et de la classification (reconnaître le français vs les API JS).

### Gardien Température (Tâche logique et dynamique)
```yaml
model: sonnet
tools: Read, Grep, Glob, Bash
effort: high
background: true
```
> `sonnet` est indispensable ici car le gardien doit non seulement lire du code, mais relier des contrats de calcul aux preuves dynamiques renvoyées par la console de test.

---

# 3. Le piège des permissions en arrière-plan

Le `gardien-temperature` tourne en arrière-plan (`background: true`). Son prompt lui demande de faire `npm test`. L'outil `Bash` est dans sa liste.
Cependant, l'outil `Bash` de Claude demande par défaut une **validation humaine** avant l'exécution.

> **Le problème :** Un agent en arrière-plan n'a pas le droit d'afficher un popup interactif. S'il tente d'exécuter la commande sans approbation préalable, il bloquera ou échouera en silence !

**La solution :**
1. Tapez `/permissions` dans le terminal interactif.
2. Ajoutez une règle d'autorisation **stricte**.
3. Saisissez : `Bash(npm test)`.
*(N'autorisez surtout pas l'outil `Bash` dans son intégralité !).*

---

# 4. Invoquer et synthétiser en parallèle

Une fois tout configuré, vous pouvez appeler vos agents dans le même prompt. L'utilisation du symbole `@` force l'invocation sans laisser Claude deviner.

> **Le Prompt Parent :**
> "Lance les deux analyses en parallèle. 
> `@gardien-francais` Analyse tout le code et relève les termes non français.
> `@gardien-temperature` Analyse la logique de conversion et exécute npm test.
> Attends leurs rapports avant de produire une synthèse de leurs conclusions."

### Suivi
Tapez `/tasks`. Vous verrez les deux processus de vos gardiens tourner indépendamment. Votre conversation principale reste libre pendant qu'ils travaillent.

### Synthèse (Le bénéfice cognitif)
Lorsque les deux agents terminent, la conversation principale reçoit les résumés. 
**Bénéfice :** La conversation principale rédige le rapport final *sans* avoir ingéré les milliers de lignes de code ou les logs de tests analysés en profondeur par les sous-agents. La fenêtre de contexte de l'agent maître reste incroyablement propre.

---

# Les 5 points les plus importants

1. Placez vos fichiers Markdown de profil dans `.claude/agents/` pour qu'ils fassent partie du projet et soient chargés automatiquement.
2. Adaptez le choix du modèle : `haiku` pour du traitement sémantique de masse, `sonnet` pour de la logique métier et l'exécution de tests.
3. Un sous-agent asynchrone (`background`) ne peut pas demander de permission en cours de route ; vous devez pré-approuver ses commandes `Bash` précises.
4. L'utilisation d'une mention `@nom-profil` dans le prompt garantit formellement la délégation, contrairement à une simple description en langage naturel.
5. Sous-traiter l'exploration préserve la fenêtre de contexte de la conversation parente, qui ne recevra que les conclusions épurées.

---

# Carte mentale

```text
Utilisation des Sous-agents
├── 1. Les Profils (.claude/agents/)
│   ├── Gardien Sémantique (haiku, Read)
│   └── Gardien Logique (sonnet, Bash)
├── 2. Prérequis de sécurité
│   ├── Lecture seule (pas d'écrasement)
│   └── /permissions -> Bash(npm test)
└── 3. Orchestration
    ├── Invocation forcée (@)
    ├── Suivi (commande /tasks)
    └── Synthèse propre (protection du contexte parent)
```

---

# Mini fiche de révision

```text
Dossier projet : .claude/agents/
haiku = tâches simples, rapides, peu coûteuses. sonnet = logique de code, tests.
Agents en bg = interdiction de bloquer sur un prompt humain = pré-approuver les commandes Bash exactes via /permissions.
Lancement simultané via @profil1 et @profil2 dans le même prompt.
L'agent parent préserve sa "santé mentale" (fenêtre de contexte) en ne lisant que les résumés finaux.
```

> **Phrase à retenir** : Ne donnez jamais un blanc-seing `Bash` complet à un sous-agent asynchrone ; autorisez la commande exacte (`Bash(npm test)`) via le panneau des permissions.
