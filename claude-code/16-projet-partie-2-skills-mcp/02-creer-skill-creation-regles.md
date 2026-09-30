---
cours: Claude Code
chapitre: 16-projet-partie-2-skills-mcp
leçon: 02-creer-skill-creation-regles
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi orienter la fin du prompt d'analyse ?** | La phrase *"L'objectif de cette analyse est de préparer la mise en place d'une issue"* force l'IA à produire une **checklist ordonnée et actionnable** plutôt qu'une simple explication théorique. |
| **Doit-on toujours accepter un plan généré par Claude ?** | Non. On peut lancer un `/plan` ou demander un plan dans le prompt pour forcer Claude à comprendre le terrain, puis **refuser** l'exécution. On garde ainsi l'analyse sans altérer le code. |
| **Comment éviter que l'IA n'invente des spécifications ?** | En lui donnant la directive explicite : *"Pose-moi des questions, on n'invente rien"* lors de la demande de plan. |
| **Pourquoi créer une issue via MCP plutôt que de coder direct ?** | L'issue sert de point de vérité partagé. Elle documente l'intention et les critères d'acceptation, permettant de redémarrer le travail dans une session neuve (plus propre et moins coûteuse en contexte). |
| **Que se passe-t-il quand on push et crée une PR via l'API (MCP) ?** | L'API GitHub crée le commit côté serveur. Ce commit aura un SHA différent du commit local, même si le contenu est identique. Pour continuer à travailler en local, il faut faire un `git fetch` et se réaligner sur le `remote`. |

## Synthèse
Cette leçon démontre la puissance du processus "Analyse -> Issue -> Nouvelle session -> PR". Plutôt que de demander à Claude d'écrire une *skill* de zéro, on lui demande d'analyser le code existant (ex: `MEM002`) pour en déduire la procédure d'ajout. Une fois cette checklist obtenue, on **refuse l'exécution** (puisque l'on voulait seulement l'analyse) et on utilise GitHub MCP pour figer cette procédure dans une Issue. Le véritable développement démarre ensuite dans une **session neuve** (économisant le contexte) où Claude relit l'issue, pose des questions en cas d'ambiguïté ("*on n'invente rien*"), développe la *skill*, valide les tests localement, puis push et ouvre la Pull Request directement via MCP.

## Glossaire
- **Dogfooding** : Pratique consistant à utiliser son propre produit. Ici, tester les règles de lint sur le propre fichier `CLAUDE.md` du dépôt.
- **SHA différent** : Lorsque GitHub MCP valide et pousse du code via l'API, l'identifiant cryptographique (SHA) du commit distant diffère de ce que Git aurait généré localement, nécessitant un `git fetch` pour resynchroniser.
- **Verrou (Test)** : Test unitaire figé (ex: `rules.test.ts`) qui casse volontairement lors de l'ajout d'une nouvelle règle, agissant comme un pense-bête strict pour les développeurs.

## Questions d'auto-évaluation
1. Pourquoi est-il souvent judicieux de refuser un `/plan` après que Claude l'ait généré ?
2. Quelle phrase clé faut-il ajouter à un prompt d'analyse pour être sûr d'obtenir une liste d'étapes actionnables ?
3. Lors de la création d'une Pull Request via GitHub MCP, pourquoi votre historique git local ne correspond-il plus exactement à l'historique distant ?
4. Quel est l'intérêt de démarrer le développement de la *skill* dans une toute nouvelle session Claude Code ?

# Création d'un skill permettant de créer des règles

**Durée : 21 minutes**

## Objectif de la leçon
Automatiser la création de nouvelles règles de code en construisant une *skill* (`new-rule`). Apprendre à extraire une procédure depuis l'existant, la figer dans une issue GitHub via MCP, puis la développer dans une session isolée en forçant l'IA à poser des questions plutôt qu'à deviner les spécifications.

---

# 1. Extraire la procédure de l'existant

Plutôt que d'écrire la procédure vous-même, demandez à Claude d'analyser une règle existante. Le prompt suivant contient une directive de cadrage essentielle à la fin :

> **Prompt d'analyse :**
> "Examine une règle existante du projet, par exemple MEM002.
> Regarde le fichier d'implémentation et le fichier de test.
> Regarde comment les règles sont enregistrées. [...]
> Ensuite, liste-moi toutes les étapes pour l'ajout d'une nouvelle règle.
> **L'objectif de cette analyse est de préparer la mise en place d'une issue GitHub.**"

Cette dernière phrase est la clé : elle oblige Claude à sortir une **checklist ordonnée**.

---

# 2. Refuser le plan pour garder l'analyse

Lorsque l'analyse est terminée, Claude va souvent proposer un plan d'exécution et demander s'il doit le lancer.

> **Principe fondamental :** 
> Le mode plan produit deux choses distinctes : une compréhension du terrain et une proposition d’action. **Rien n’oblige à accepter la seconde pour garder la première.**

Refusez l'exécution ! Utilisez plutôt l'analyse générée pour dicter à Claude la création d'une issue GitHub (via MCP) contenant les critères d'acceptation précis.

---

# 3. La session neuve : "On n'invente rien"

Une fois l'issue créée sur GitHub, fermez Claude Code et rouvrez-le. Travailler dans une session neuve prouve que l'issue se suffit à elle-même et permet d'économiser des tokens de contexte.

Demandez-lui de lire l'issue et préparez-le à l'incertitude avec un cadrage strict :

> **Prompt de démarrage :**
> "Propose-moi un plan pour l'issue numéro 1 si jamais il y a des ambiguïtés dans le contenu de l'issue.
> **Pose-moi des questions, on n'invente rien.**"

*Résultat* : Claude s'arrête, liste les cas limites (ex: "Quelle convention de nommage ?") et attend vos directives au lieu de prendre de mauvaises décisions silencieuses.

---

# 4. Le Push et la création de PR via MCP

Une fois le développement de la skill terminé et vérifié par les tests locaux (`pnpm run test`), demandez l'envoi via MCP :

> **Prompt de livraison :**
> "valide et push
> et crée une pull request
> utilise le serveur MCP"

### Attention au décalage Git
L'action est réalisée via l'API GitHub, non pas par la ligne de commande git locale. Le dépôt distant va donc créer un commit dont le **SHA** (l'identifiant) diffère de votre état local.
Pour continuer à travailler proprement sur cette branche depuis votre ordinateur, vous devrez faire :
```bash
git fetch
# puis recréer/aligner la branche locale depuis origin/<branche>
```

---

# Les 5 points les plus importants

1. Orienter un prompt d'analyse avec sa finalité ("pour préparer une issue") modifie drastiquement la structure de la réponse de l'IA (vers de l'actionnable).
2. L'analyse est un livrable en soi : il est courant et sain de générer un plan pour forcer la réflexion de l'IA, puis de refuser son exécution.
3. Repartir d'une session neuve qui lit le ticket via MCP valide que le ticket est compréhensible et évite l'encombrement du contexte de l'IA.
4. L'instruction "Pose-moi des questions, on n'invente rien" est le bouclier ultime contre les hallucinations de spécifications.
5. Une PR poussée via MCP GitHub modifie l'historique distant (SHA différent) ; un `git fetch` est requis pour synchroniser le poste local.

---

# Carte mentale

```text
Création d'une Feature assistée
├── 1. Analyse de l'existant
│   ├── Prompt ciblé (MEM002)
│   ├── Orienté vers un livrable (Issue)
│   └── Refus de l'exécution du plan
├── 2. Figer la vérité (MCP)
│   └── Création de l'issue GitHub
├── 3. Session Neuve
│   ├── Lecture du ticket (MCP)
│   ├── Cadrage : "on n'invente rien"
│   └── Résolution des questions/ambiguïtés
└── 4. Livraison (MCP)
    ├── Tests locaux (exit 0)
    ├── Push et Pull Request (via API GitHub)
    └── Synchro locale (git fetch) nécessaire
```

---

# Mini fiche de révision

```text
Prompt d'analyse -> préciser "pour créer une issue" -> refuser l'exécution = Checklist obtenue.
Créer Issue via MCP -> Nouvelle session Claude -> Lire Issue via MCP.
Prompt d'exécution -> "Pose-moi des questions, on n'invente rien".
Push via MCP = SHA différent en local -> nécessitera un git fetch.
```

> **Phrase à retenir** : Le mode plan produit une compréhension du terrain et une proposition d'action ; rien ne vous oblige à accepter la seconde pour bénéficier de la première.
