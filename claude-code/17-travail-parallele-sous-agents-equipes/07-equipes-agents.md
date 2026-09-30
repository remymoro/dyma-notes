---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 07-equipes-agents
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la principale différence architecturale entre de multiples sous-agents classiques et une *Agent Team* ?** | Des sous-agents ne communiquent qu'avec leur parent (résultats en étoile). Une *Agent Team* ajoute une liste de tâches partagée et une **messagerie directe** (`Mailbox`) permettant aux agents de se coordonner et de se contester entre eux, le parent devenant un superviseur (`Team lead`). |
| **Pourquoi est-il crucial d'attribuer des fichiers distincts aux *teammates* d'une équipe ?** | Contrairement aux sessions d'arrière-plan (`/bg`) qui utilisent des *worktrees* pour s'isoler physiquement, les équipes d'agents **ne créent pas de worktrees**. S'ils travaillent sur le même fichier, ils écraseront mutuellement leurs modifications. |
| **Si un *teammate* est lancé en mode `plan` (demande d'approbation avant écriture), qui validera son plan ?** | C'est le **Team lead** (l'agent principal) qui approuvera ou refusera le plan de manière autonome, selon les critères que vous lui avez fixés. Ce n'est pas l'utilisateur humain qui est sollicité. |
| **Que se passe-t-il si un *teammate* a besoin d'exécuter une commande `Bash` non autorisée ?** | La demande de permission apparaîtra dans le terminal du `Team lead` (donc chez vous). Le *teammate* ne peut pas forcer la validation ni s'auto-autoriser. Il faut toujours pré-autoriser les commandes critiques avant de lancer l'équipe. |
| **Qu'est-ce que le mode d'affichage `in-process` ?** | C'est le mode par défaut de l'interface des équipes. Tous les agents apparaissent dans le même terminal principal. Vous pouvez naviguer entre eux avec les flèches haut/bas, ouvrir leur *transcript* avec `Entrée` et voir la liste des tâches partagées avec `Ctrl+T`. |

## Synthèse
Les équipes d'agents (fonctionnalité expérimentale) transforment votre session Claude Code en un véritable studio de développement auto-géré. Votre agent principal devient un `Team lead` capable de déléguer des tâches à une escouade de `teammates`. L'atout majeur de cette organisation est la communication "horizontale" : les sous-agents discutent entre eux via une messagerie interne et tirent leurs tâches d'une *Task List* gérant les dépendances. 
Cependant, ce pouvoir s'accompagne de risques majeurs : un coût en jetons démultiplié, et un risque élevé de conflit de code. En effet, l'équipe travaille dans le **même répertoire physique** sans *worktree*. Le rôle de l'humain devient alors celui d'un architecte : il doit formuler un prompt initial parfait pour assigner des responsabilités strictes (Agent A sur le dossier *src*, Agent B sur le dossier *test*) et pré-approuver les commandes pour que l'équipe ne bloque pas en cours de route. Le `Team lead` gèrera le reste de manière surprenante, allant jusqu'à approuver lui-même les "plans d'exécution" de ses coéquipiers !

## Glossaire
- **`Agent Teams`** : Fonctionnalité expérimentale (activable via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) permettant de lancer une grappe d'agents interconnectés.
- **`Team lead`** : La session principale qui chapeaute l'équipe, lance les agents, arbitre les désaccords et synthétise le résultat final.
- **`Teammate`** : Sous-agent membre de l'équipe, doté de sa propre fenêtre de contexte, agissant en autonomie.
- **`in-process`** : Interface TUI par défaut regroupant les *teammates* dans le même terminal. (S'oppose à `split panes` qui requiert `tmux`).

## Questions d'auto-évaluation
1. Dans un prompt d'équipe, faut-il utiliser une phrase comme "Travaillez tous ensemble sur la refonte de app.js" ?
2. Un *teammate* peut-il invoquer une sous-équipe d'agents pour l'aider dans sa propre tâche ?
3. Le *Team lead* peut-il conclure le travail avant que l'agent en charge des tests n'ait fini ? Si oui, comment l'éviter ?
4. Si un agent tourne avec un profil `test-reviewer` chargé depuis vos fichiers, l'équipe importera-t-elle les serveurs MCP spécifiques définis dans ce profil ?

# Les équipes d’agents (Concept)

**Durée : 11 minutes**

## Objectif de la leçon
Comprendre l'architecture de la fonctionnalité expérimentale des "Agent Teams", qui permet à plusieurs IA de s'auto-coordonner via une liste de tâches partagée et une messagerie interne. Identifier les cas d'usage pertinents et maîtriser les dangers inhérents à l'absence d'isolation physique (pas de worktree).

---

# 1. Le changement de paradigme : Auto-coordination

Contrairement à des sous-agents classiques où toutes les informations remontent vers le parent (organisation en étoile), une Équipe d'agents instaure une communication transversale.

**L'architecture de l'Équipe :**
1. **Team lead** : L'agent principal (Vous parlez à lui).
2. **Teammates** : Les sessions indépendantes (Ils exécutent).
3. **Task List** : Une liste de tâches commune gérant les dépendances (ex: "Tâche 2 est bloquée tant que Tâche 1 n'est pas finie").
4. **Mailbox** : Une messagerie permettant aux membres de se contester ou de partager leurs découvertes sans surcharger l'humain.

> **Activer la fonctionnalité (Expérimentale) :**
> Dans `.claude/settings.json`, ajoutez `"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"`.

---

# 2. Cas d'usage : Quand utiliser une équipe ?

Les équipes coûtent **très cher** en jetons (chaque membre est une session complète). Il ne faut pas les utiliser pour de la simple exécution séquentielle.

**🟢 Oui : L'équipe est utile pour :**
- Une revue de code parallèle sous de multiples angles (sécurité, archi, style).
- Une investigation avec plusieurs hypothèses complexes.
- Un refactoring impliquant des contrats complexes entre deux dossiers distincts (A modifie le moteur, B modifie l'interface).

**🔴 Non : L'équipe est inutile pour :**
- Une tâche strictement séquentielle (A doit finir avant B, B avant C). L'équipe attendrait pour rien.
- Une modification du **même fichier**.

---

# 3. Le DANGER n°1 : Les conflits de fichiers !

C'est la règle la plus importante de cette leçon :
> **Les équipes d'agents ne créent pas de worktrees isolés.**

Tous les membres écrivent dans votre dossier local. Si l'Agent A modifie la ligne 10 de `app.js` et que l'Agent B modifie la ligne 20 de `app.js` en même temps, **ils vont s'écraser**.

**La solution réside dans votre prompt de lancement :**
Attribuez des "territoires" stricts :
`Teammate A : Ne modifie que le dossier src/`
`Teammate B : Ne modifie que le dossier test/`

---

# 4. Le DANGER n°2 : Les blocages d'exécution

### Approbation de Plan autonome !
Si vous lancez un agent en mode `plan` (pour sécuriser une modification), la demande de validation ne s'affichera pas à vous, mais au `Team lead` ! **C'est l'IA chef d'équipe qui approuvera ou refusera le plan de son collègue** selon les critères que vous lui avez donnés.

### Les permissions Bash (Le point de blocage)
Les membres ont les permissions du parent. Si un *teammate* a besoin d'exécuter `npm test` mais que ce n'est pas autorisé, le *popup* de demande va s'afficher chez vous (le `Team lead`). Le *teammate* ne peut pas s'auto-autoriser. **Pré-autorisez toujours vos outils avec `/permissions` avant de lancer l'équipe.**

### La conclusion prématurée
Le chef d'équipe peut décider que le travail global est terminé alors qu'un pauvre agent est encore en train de ramer. Pour éviter cela, forcez le trait dans le prompt du chef :
*"Attends que tous les teammates aient le statut "completed" avant de produire la synthèse."*

---

# 5. Interface et Arrêt (`in-process`)

Par défaut, l'équipe s'affiche dans votre terminal classique (`in-process`).

- `↑` et `↓` pour naviguer entre les membres.
- `Ctrl+T` pour afficher la fameuse **liste des tâches**.
- `Entrée` pour plonger dans le "cerveau" (le transcript) d'un agent spécifique et lui parler directement.
- `x` pour arrêter un agent qui aurait déraillé.

Pour arrêter proprement un agent sans tuer le processus violemment, demandez au chef de s'en occuper : *"Demande au teammate tests de s'arrêter proprement."* Le membre pourra terminer de sauvegarder un fichier critique avant de quitter.

---

# Les 5 points les plus importants

1. Les équipes d'agents gèrent leur propre messagerie interne et une liste de tâches commune ; le chef n'a pas besoin de les "poller" (interroger).
2. Elles ne créent **aucune isolation de fichiers** (*worktree*). Vous devez formellement partitionner les fichiers dans votre prompt initial.
3. Le *Team lead* (chef d'équipe) est capable d'approuver de manière autonome le plan d'action de ses *teammates*.
4. Les profils réutilisés au sein d'une équipe héritent du modèle/prompt, mais ne reprennent ni les `skills` ni les serveurs `MCP` spécifiques au profil.
5. Indiquez explicitement au chef d'équipe de patienter jusqu'à la fin de la tâche de chaque agent, sous peine de le voir clôturer le projet prématurément.

---

# Carte mentale

```text
Équipes d'Agents (Experimental)
├── Architecture
│   ├── Team Lead (Arbitre, Synthétise, Approuve)
│   ├── Teammates (Indépendants, contexte isolé)
│   └── Outils de comm (Mailbox, Task list)
├── Dangers Majeurs
│   ├── Conflits d'édition (PAS de worktree) -> Partitionner !
│   ├── Coût financier (1 jeton x N agents)
│   └── Fin prématurée du chef
└── Interface (in-process)
    ├── Ctrl+T : Voir la Task list
    ├── Entrée : Parler à un membre
    └── x : Arrêt forcé (ou arrêt poli via le chef)
```

---

# Mini fiche de révision

```text
Activation : CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1.
Différence avec sous-agent normal : Communication horizontale (entre eux) + Task list partagée.
Règle d'or absolue : Séparer les territoires (Dossier A pour Agent A). L'équipe partage le MÊME clavier physique (pas de worktree).
Délégation risquée : Le "Team lead" approuvera LUI-MÊME les demandes de mode "plan" de ses subordonnés.
Interface : in-process. Ctrl+T affiche le tableau de bord des tâches.
```

> **Phrase à retenir** : Dans une équipe d'agents, les esprits sont indépendants mais les mains sont sur le même clavier ; attribuez un dossier précis à chacun.
