---
cours: Claude Code
chapitre: 16-projet-partie-2-skills-mcp
leçon: 03-creer-regle-skill-new-rule
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi construire le prompt de création d'issue "en deux temps" ?** | Pour forcer l'IA à d'abord proposer et valider les spécifications (cadrage) avant de déclencher l'action irréversible d'ouverture de l'issue via MCP sur GitHub. |
| **Que fait Claude si un cas limite n'est pas précisé dans l'issue ?** | Il le tranchera "en silence" pendant l'implémentation. Résultat : vous découvrirez des règles arbitraires (ex: ignorer les titres vides) uniquement lors de la revue de code. Mieux vaut forcer les questions avant ! |
| **Pourquoi l'IA ne pose-t-elle aucune question sur la "procédure" ?** | Car le prompt initial ordonne de charger la skill `new-rule`. L'IA comprend la convention du projet (fichiers à créer, `index.ts`, `vitest`). Les questions se portent donc uniquement sur le comportement métier de la règle. |
| **Quel est le grand danger de la commande `vitest run -u` ?** | Elle regénère les snapshots et **accepte silencieusement toutes les régressions**, même sur des règles qui ne devaient pas être touchées. Il faut TOUJOURS relire le diff ligne par ligne après exécution. |
| **Pourquoi utiliser des cases à cocher `[ ]` pour les critères d'acceptation ?** | Cela inscrit la procédure extraite directement dans le corps de l'issue, ce qui rend le livrable vérifiable pas à pas par le relecteur (ou par Claude lors de la session d'exécution). |

## Synthèse
L'automatisation d'une tâche de code commence par une rédaction d'issue irréprochable. Cette leçon insiste sur un prompt "en deux temps" : d'abord, Claude prépare les spécifications en analysant le besoin et en chargeant la skill du projet pour comprendre les conventions. Ensuite, après avoir posé des questions sur les cas limites (titres vides, triple occurrence, sensibilité à la casse) et obtenu votre validation, l'issue est réellement créée sur GitHub via MCP. Cette démarche garantit qu'aucune décision métier n'est prise silencieusement pendant le développement. L'issue générée sert alors de cahier des charges absolu, contenant même la checklist d'implémentation, prête à être traitée par une session neuve sans nécessiter d'instructions supplémentaires.

## Glossaire
- **Snapshot (vitest -u)** : Instantané d'un résultat (ex: sortie console) sauvegardé dans un fichier. Lors de mises à jour de tests (via `-u`), les régressions sont silencieusement acceptées.
- **Fixture partagée** : Fichier de test utilisé par plusieurs règles en même temps. Toute modification d'une fixture peut provoquer des effets de bord sur d'autres tests.
- **Cas limite (Edge case)** : Scénario inattendu ou extrême (ex: fichier vide, titre sans texte). Si non spécifié, l'IA l'implémentera avec son propre jugement.

## Questions d'auto-évaluation
1. Quel morceau de phrase dans le prompt initial empêche Claude de créer l'issue de manière hâtive ?
2. Pourquoi modifier la fixture `avertissements/CLAUDE.md` nécessite-t-il obligatoirement une relecture de tous les snapshots CLI du projet ?
3. Quelle est la différence entre une question sur le "comportement" et une question sur la "procédure" ?
4. Si vous laissez Claude "deviner" ce qu'il doit faire avec les en-têtes situés dans des blocs de code (fences), que risquez-vous de découvrir lors de la Pull Request ?

# Création d'une nouvelle règle avec le skill new-rule

**Durée : 11 minutes**

## Objectif de la leçon
Maîtriser l'ingénierie de prompt en "deux temps" pour spécifier un besoin complexe. Apprendre à sécuriser le développement en forçant l'IA à trancher explicitement tous les cas limites et à rédiger des critères d'acceptation actionnables sous forme de checklist avant de générer l'issue officielle via MCP.

---

# 1. Le Prompt en deux temps (Le Cadrage)

La clé pour éviter qu'une IA ne fasse n'importe quoi est de scinder l'analyse de l'exécution.

> **Extrait du prompt d'amorçage :**
> "Cette session a pour tâche, dans un premier temps, de préparer les spécifications [...]. Dans un second temps, il faudra créer l'issue.
> [...]
> Prends la skill en compte et dis-moi s'il y a des ambiguïtés. Si ce n'est pas le cas, rédige les specs.
> **Je validerai au préalable, avant que tu crées l'issue.**"

### Avantages :
1. **Zéro question de plomberie** : Grâce à la skill, Claude sait déjà quels fichiers modifier.
2. **Focus métier** : L'IA concentre ses questions sur les règles métier (Casse ? Accents ? Répétitions multiples ?).
3. **Contrôle total** : Vous validez le plan textuel avant d'envoyer l'appel API à GitHub.

---

# 2. Les cas limites (Edge cases)

C'est la section vitale d'une bonne issue. Si vous ne décidez pas, Claude décidera à votre place, "en silence", au milieu de son code.

**Cas à identifier et trancher avant codage :**
- Que fait-on avec les en-têtes sans texte (`## `) ?
- Que fait-on avec les en-têtes dans des blocs de code ?
- Que fait-on si un fichier est totalement vide ?
- Comment gère-t-on trois occurrences du même titre ? (2 avertissements ou 1 global ?)

*Résultat dans l'issue : "Les en-têtes sans texte sont ignorés", "La première occurrence n'est jamais signalée".*

---

# 3. Le Danger des Fixtures Partagées et Snapshots

Dans un projet structuré, un fichier de test (fixture) comme `fautif/CLAUDE.md` est souvent scanné par de multiples règles de linting en même temps.

1. Ajouter une erreur dans cette fixture pour déclencher votre nouvelle règle (`MEM004`) va changer les numéros de ligne du fichier.
2. **Effet de bord** : Les règles existantes (ex: `MEM001`) vont potentiellement remonter des erreurs sur de nouvelles lignes.
3. Le snapshot (l'instantané textuel) de la CLI va changer.

> **Instruction impérative dans la procédure :**
> "Régénérer via `vitest run -u`, **puis relire le diff ligne par ligne**."
> Ne jamais laisser l'IA lancer `vitest -u` sans contrôle strict, car cette commande accepte les régressions.

---

# 4. Exécution depuis une session neuve

Une fois l'issue créée, on referme Claude et on rouvre une session pure :

> **Prompt d'exécution :**
> "Récupère-moi la liste des issues ouvertes.
> Oui, commence à traiter l'issue et génère-moi un plan."

Grâce aux critères d'acceptation rédigés sous forme de cases à cocher `[ ]` dans l'issue, l'IA possède un guide d'exécution strict. Le plan affiché ne fera que refléter les choix tranchés à l'étape 2. Il n'y a plus rien à réinventer, c'est le signe d'une issue parfaite.

---

# Tableau des bonnes pratiques (Checklist vs Erreurs)

| 🟢 Bonne pratique | 🔴 Erreur commune |
|---|---|
| Rédiger l'issue avec la procédure de la skill incluse sous forme de cases à cocher. | Rédiger l'issue sans consulter la procédure existante (oubli des tests transverses). |
| Valider les spécifications générées par Claude avant l'appel MCP GitHub. | Donner l'ordre direct de créer l'issue sans brouillon. |
| Forcer l'explication des cas limites dans le prompt initial. | Laisser l'IA improviser le comportement face à un fichier vide. |
| Relire attentivement le diff après un `vitest -u`. | Régénérer les snapshots silencieusement. |

# Les 5 points les plus importants

1. Annoncer "Je validerai au préalable avant que tu crées l'issue" est le garde-fou numéro 1.
2. Le chargement explicite d'une skill en amont évite à l'IA de poser des questions d'architecture logicielle.
3. Les cas limites non documentés dans une issue se transformeront inévitablement en comportements arbitraires ou en bugs insidieux.
4. Les critères d'acceptation doivent être structurés (ex: `[ ]`) pour forcer le suivi séquentiel de l'implémentation.
5. Une modification sur une fixture partagée impacte toutes les autres règles : la relecture minutieuse du snapshot généré est non négociable.

---

# Carte mentale

```text
Préparation et Spécification (Issue)
├── 1. Le Prompt (2 Temps)
│   ├── Charger la Skill (Conventions)
│   ├── Exiger les specs d'abord
│   └── Verrou : "Je valide avant MCP"
├── 2. Cas Limites (Tranchés)
│   ├── Casse / Accents
│   ├── Blocs de code (fences)
│   └── Multi-occurrences
├── 3. Sécurité Tests Transverses
│   ├── Fixtures partagées = Effets de bord
│   └── vitest -u = Danger (Relecture obligatoire)
└── 4. Exécution pure
    ├── Liste des critères en [ ]
    └── Démarrage sur une session neuve
```

---

# Mini fiche de révision

```text
Prompt en 2 temps : Spec d'abord, création GitHub MCP après validation.
Toujours trancher les cas limites (fichier vide, casse, accents).
Une fixture modifiée impacte les autres tests : relire obligatoirement le diff de vitest -u.
Critères d'acceptation en format checklist [ ] = plan d'exécution sans improvisation pour l'IA.
Erreur fatale : Laisser l'IA deviner un comportement métier "en silence".
```

> **Phrase à retenir** : Une issue bien écrite déplace la discussion (et les questions d'incertitude) vers le seul endroit où elle a de la valeur : avant que la moindre ligne de code ne soit écrite.
