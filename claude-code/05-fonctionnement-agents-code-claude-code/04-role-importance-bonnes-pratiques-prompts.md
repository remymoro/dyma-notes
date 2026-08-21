---
title: "Les prompts dans Claude Code"
description: "Comprendre comment formuler des prompts efficaces pour guider la boucle agentique de Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - prompts
  - boucle-agentique
categories:
  - "Chapitre 5"
cours: Claude Code
chapitre: 05-fonctionnement-agents-code-claude-code
leçon: 04-prompts-claude-code
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés                               | Notes détaillées                                                                                                                          |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Quel est le rôle d’un prompt dans Claude Code ?        | Il définit la tâche et oriente la trajectoire agentique : objectif, périmètre, contraintes, références, vérification et résultat attendu. |
| Un prompt doit-il décrire toutes les étapes ?          | Non. Il doit surtout définir le résultat attendu et les contraintes, puis laisser Claude Code explorer et choisir les moyens adaptés.     |
| Quelle différence entre direction et micro-direction ? | La direction précise ce qui doit être vrai à la fin. La micro-direction impose chaque action intermédiaire.                               |
| Que doit contenir le prompt immédiat ?                 | Ce qui est spécifique à la tâche actuelle : objectif, périmètre, contraintes, artefacts, format de sortie et vérification.                |
| Où placer les règles permanentes ?                     | Dans `CLAUDE.md` ou dans les mécanismes persistants appropriés, pas dans chaque prompt.                                                   |
| Quand utiliser une Skill ?                             | Lorsqu’une procédure ou une expertise spécialisée doit être réutilisée sans être chargée dans toutes les sessions.                        |
| Comment rédiger un prompt de subagent ?                | Il doit être suffisamment autonome pour que le subagent puisse comprendre la tâche sans dépendre de toute la conversation parent.         |
| Pourquoi préciser une condition de réussite ?          | Parce qu’elle fournit à la boucle un critère de vérification et une condition d’arrêt.                                                    |
| Quels éléments composent un bon prompt ?               | Objectif, contexte source, contraintes, référence de cohérence, vérification et format de sortie.                                         |
| Pourquoi fournir les artefacts réels ?                 | Parce qu’un fichier, un log ou une erreur réelle donne à Claude Code une observation plus fiable qu’une paraphrase.                       |
| Pourquoi séparer exploration et modification ?         | Pour éviter des changements prématurés et pouvoir valider l’analyse avant de toucher au code.                                             |
| Quand corriger une trajectoire ?                       | Le plus tôt possible, dès que Claude Code s’éloigne du bon objectif ou du bon périmètre.                                                  |
| Que faire après plusieurs corrections infructueuses ?  | Reformuler le prompt avec les informations apprises et repartir avec un contexte plus propre.                                             |
| Comment rédiger un prompt non interactif ?             | De manière plus contractuelle : entrées, sorties, outils autorisés, erreurs attendues et format stable.                                   |
| Quelles sont les erreurs fréquentes ?                  | Prompt trop vague, trop procédural, absence de vérification, `CLAUDE.md` surchargé et confusion entre instruction et contrainte.          |

## Synthèse

Un bon prompt dans Claude Code ne décrit pas chaque geste de l’agent. Il définit clairement le résultat attendu, le périmètre, les contraintes et la manière de vérifier que la tâche est réellement terminée.

## Glossaire

* prompt : instruction envoyée à Claude Code pour définir une tâche.
* trajectoire agentique : suite de décisions, outils et vérifications effectuées pour atteindre un objectif.
* objectif : état final attendu après l’exécution de la tâche.
* périmètre : zone du projet ou ensemble d’éléments concernés par la tâche.
* contrainte : règle qui limite les solutions acceptables.
* contexte source : fichiers, logs, captures, tickets ou ressources utilisés comme références.
* artefact : élément concret fourni à Claude Code, comme un fichier, un log ou une capture.
* vérification : mécanisme permettant de démontrer que le résultat est correct.
* condition d’arrêt : critère permettant de considérer la tâche comme terminée.
* micro-direction : fait d’imposer trop précisément les étapes internes d’exécution.
* `CLAUDE.md` : fichier contenant des instructions persistantes pour un projet.
* Skill : instruction ou procédure spécialisée chargée lorsqu’elle est utile.
* subagent : agent secondaire possédant son propre contexte.
* prompt immédiat : prompt envoyé pour la tâche actuellement exécutée.
* prompt non interactif : prompt exécuté sans dialogue continu avec l’utilisateur, par exemple avec `claude -p`.

## Questions d'auto-évaluation

1. Pourquoi le prompt est-il plus qu’une simple question dans Claude Code ?
2. Quelle différence existe-t-il entre définir un résultat et micro-diriger Claude Code ?
3. Quelles informations doivent rester dans le prompt immédiat ?
4. Pourquoi ne faut-il pas mettre toutes les conventions du projet dans chaque prompt ?
5. Quel est le rôle de `CLAUDE.md` ?
6. Quelle différence existe-t-il entre `CLAUDE.md` et une Skill ?
7. Pourquoi un prompt de subagent doit-il être autonome ?
8. Pourquoi un prompt vague peut-il conduire Claude Code dans une mauvaise direction ?
9. Pourquoi un critère de vérification est-il important ?
10. Quels sont les principaux éléments d’un prompt efficace ?
11. Pourquoi faut-il préférer un fichier ou un log réel à une paraphrase ?
12. Pourquoi faut-il décrire le résultat plutôt que toutes les étapes internes ?
13. Dans quels cas faut-il être plus directif ?
14. Pourquoi séparer parfois exploration et implémentation ?
15. Quand faut-il corriger la trajectoire pendant une session ?
16. Pourquoi peut-il être préférable de réécrire le prompt plutôt que d’accumuler les corrections ?
17. Quelles contraintes supplémentaires s’appliquent à un prompt non interactif ?
18. Quelles sont les principales erreurs de prompting dans Claude Code ?
19. Quelle différence existe-t-il entre une instruction et une contrainte garantie ?
20. Pourquoi un résultat plausible ne suffit-il pas toujours ?

# Les prompts dans Claude Code

**Durée : 20 minutes**

## Notes

Dans Claude Code, un prompt n’est pas simplement une question envoyée à un modèle.

Il constitue le **point de départ d’une trajectoire agentique**.

Le prompt peut définir :

* l’objectif ;
* le périmètre ;
* les contraintes ;
* les références à consulter ;
* le niveau d’autonomie ;
* les critères de vérification ;
* le format de sortie attendu.

Une représentation simple est :

```text
Prompt
  ↓
Contexte
  ↓
Décision du modèle
  ↓
Outils / actions
  ↓
Résultats
  ↓
Nouvelles décisions
  ↓
Vérification
  ↓
Fin de la tâche
```

Le prompt influence donc toute la boucle.

Il ne détermine pas uniquement la première réponse.

Il peut influencer :

* les fichiers lus ;
* les outils utilisés ;
* les modifications réalisées ;
* les tests exécutés ;
* les permissions demandées ;
* la condition d’arrêt.

Un bon prompt cherche principalement à **réduire l’ambiguïté opératoire**.

Un prompt court peut être très efficace s’il précise clairement :

```text
Objectif
+
Contraintes
+
Vérification
```

À l’inverse, un prompt très long peut être mauvais s’il contient :

* des informations inutiles ;
* des règles contradictoires ;
* des préférences secondaires ;
* trop de détails non pertinents.

Le prompt doit donc être précis, mais pas nécessairement long.

Une règle importante consiste à ne pas **micro-diriger** Claude Code.

Par exemple :

```text
Mauvaise approche

1. Ouvre fichier A
2. Cherche fonction B
3. Ouvre fichier C
4. Modifie ligne 42
5. Lance telle commande
```

Cette approche impose une stratégie avant même que Claude ait exploré le projet.

Une meilleure formulation consiste à préciser :

```text
Objectif :
corriger le problème X

Contraintes :
- ne pas modifier l'API publique
- ne pas ajouter de dépendance

Vérification :
- tests ciblés
- typecheck
```

Claude Code peut ensuite déterminer lui-même les fichiers et outils nécessaires.

Il faut distinguer :

```text
Direction
→ ce qui doit être vrai à la fin

Micro-direction
→ chaque étape imposée à l'agent
```

Le prompt doit généralement être **directif sur les invariants** et **souple sur les moyens**.

Le prompt immédiat concerne la tâche actuelle.

Il peut contenir :

* objectif ;
* périmètre ;
* contraintes ;
* fichiers de référence ;
* erreurs ;
* format de sortie ;
* vérification.

Il ne doit pas contenir toute la politique permanente du projet.

Les informations persistantes doivent plutôt vivre dans :

```text
CLAUDE.md
```

Par exemple :

```text
CLAUDE.md

- commandes de test
- conventions d'architecture
- règles de style
- conventions de branche
- informations stables sur le dépôt
```

`CLAUDE.md` doit rester concis.

Chaque règle persistante consomme du contexte.

Une règle utile doit donc être :

* stable ;
* générale ;
* discriminante ;
* réellement utile.

Les procédures spécialisées peuvent être déplacées dans des **Skills**.

On obtient alors :

```text
CLAUDE.md
→ contexte permanent

Skill
→ contexte spécialisé chargé au besoin

Prompt
→ tâche actuelle
```

Une Skill permet par exemple d’encapsuler :

* une revue de sécurité ;
* une procédure de migration ;
* une méthode de documentation ;
* une procédure de correction de ticket.

Les prompts de **subagents** ont une particularité importante.

Un subagent possède son propre contexte.

Son prompt doit donc contenir suffisamment d’informations pour qu’il puisse travailler de manière autonome.

Par exemple :

```text
Tâche :
analyser le module d'authentification

Périmètre :
src/auth/

Objectif :
identifier les causes possibles du bug

Retour attendu :
- fichiers concernés
- cause probable
- risques
```

Il ne faut pas supposer que le subagent connaît automatiquement toute la conversation principale.

Le prompt est important parce qu’il traduit une **intention humaine** en **problème exploitable par l’agent**.

L’utilisateur pense par exemple :

```text
"Mon système de connexion ne fonctionne pas."
```

Claude Code doit travailler à partir d’une représentation plus précise :

```text
Quel comportement est incorrect ?
Quel fichier ou endpoint ?
Quelle erreur ?
Quel résultat attendu ?
Comment vérifier la correction ?
```

Une demande ambiguë force l’agent à faire davantage d’hypothèses.

Plus il fait d’hypothèses, plus il risque de résoudre le mauvais problème.

Un bon prompt réduit également le **coût de correction**.

Une mauvaise trajectoire peut accumuler :

```text
fichiers inutiles
+
hypothèses incorrectes
+
commandes inutiles
+
modifications hors périmètre
+
corrections successives
```

Tout cela consomme du contexte.

Un bon cadrage initial limite cette accumulation.

Le prompt doit également définir une **condition d’arrêt**.

Par exemple :

```text
Tâche terminée si :

✓ tests ciblés passent
✓ typecheck passe
✓ aucune modification hors périmètre
```

Sans critère de réussite, Claude Code doit décider seul quand son travail est terminé.

Cela peut provoquer une conclusion prématurée.

La structure d’un prompt efficace peut être représentée ainsi :

```text
Objectif
    ↓
Contexte source
    ↓
Contraintes
    ↓
Référence de cohérence
    ↓
Vérification
    ↓
Format de sortie
```

### Objectif

L’objectif décrit l’état final attendu.

Une formulation faible serait :

```text
Refactorise ce module.
```

Une formulation plus exploitable serait :

```text
Réduis la duplication entre les adaptateurs
sans modifier leur API publique.
```

La seconde décrit davantage ce qui doit être vrai une fois le travail terminé.

### Contexte source

Il faut fournir les éléments réellement utiles :

* fichier ;
* dossier ;
* log ;
* stack trace ;
* sortie de test ;
* capture ;
* documentation ;
* ticket ;
* ressource externe.

Il vaut généralement mieux donner :

```text
@build.log
```

que reformuler soi-même l’erreur.

L’artefact réel contient souvent des détails que l’utilisateur pourrait oublier dans sa description.

### Contraintes

Les contraintes indiquent les solutions interdites ou les invariants à préserver.

Exemples :

```text
- ne pas modifier l'API publique
- ne pas ajouter de dépendance runtime
- conserver la compatibilité Node 20
- ne pas modifier le schéma de base de données
```

Une contrainte doit être concrète.

Une phrase comme :

```text
Faire du code propre
```

est trop vague.

### Référence de cohérence

Lorsque Claude Code doit ajouter quelque chose dans un projet existant, il peut être utile de lui donner un exemple déjà présent.

Par exemple :

```text
Utilise @existing-service.ts
comme référence d'organisation.
```

Un exemple interne permet souvent de mieux respecter les conventions réelles qu’une description abstraite.

### Vérification

Toute tâche importante doit disposer d’un signal de réussite.

Pour du code :

```text
tests
typecheck
lint
build
```

Pour une interface :

```text
capture de référence
états visuels attendus
```

Pour de la documentation :

```text
structure attendue
public cible
niveau de détail
```

La vérification transforme le prompt en **contrat vérifiable**.

### Format de sortie

Il faut également préciser la forme du résultat lorsqu’elle est importante.

Exemples :

* revue de code ;
* plan ;
* checklist ;
* JSON ;
* liste de fichiers ;
* résumé ;
* `OK / FAIL`.

Le format est particulièrement important dans les workflows automatisés.

Une autre règle importante est :

```text
Décrire le résultat
plutôt que les étapes internes
```

Claude Code dispose déjà d’outils pour explorer.

Il peut :

* trouver les fichiers ;
* rechercher des symboles ;
* suivre les références ;
* lire les tests ;
* exécuter les commandes appropriées.

L’utilisateur doit donc contrôler principalement :

```text
Résultat
Contraintes
Périmètre
Vérification
```

et laisser davantage de liberté sur :

```text
Exploration
Choix des fichiers
Ordre des lectures
Implémentation interne
```

Il existe cependant des cas où il faut être plus directif.

Par exemple lorsqu’il existe :

* une contrainte de sécurité ;
* une exigence réglementaire ;
* une compatibilité obligatoire ;
* une API à préserver ;
* une dépendance interdite ;
* un format contractuel.

Dans ces cas, les invariants doivent être explicitement écrits.

Pour fournir le bon contexte, les références directes sont utiles.

Par exemple :

```text
Analyse @src/auth/session.ts
et @src/auth/session.spec.ts
```

Pour le débogage, il faut également fournir les erreurs réelles.

```text
Stack trace
Sortie de build
Logs CI
Erreur TypeScript
Test échoué
```

Une erreur paraphrasée oblige Claude Code à reconstruire une partie du problème.

Une erreur brute fournit directement une observation.

Le contexte reste cependant une ressource limitée.

Il contient notamment :

* conversation ;
* fichiers lus ;
* résultats d’outils ;
* instructions ;
* `CLAUDE.md` ;
* Skills chargées ;
* mémoire de session.

Ajouter plus d’informations n’est donc pas toujours bénéfique.

Le but est de fournir **les informations discriminantes**, pas tout ce qui existe.

Lorsqu’une session devient très longue et accumule plusieurs tentatives échouées, il peut être préférable de :

```text
Extraire ce qui a été appris
        ↓
Reformuler le prompt
        ↓
Repartir avec un contexte propre
```

Cela peut être plus efficace que de continuer à ajouter des corrections dans une trajectoire déjà polluée.

La vérification permet également d’éviter le **piège de la plausibilité**.

Une réponse peut sembler correcte sans l’être réellement.

Il faut donc privilégier les observations externes :

```text
tests
build
lint
diff
capture
commande de reproduction
validation indépendante
```

Plus la tâche est autonome, plus la vérification doit être forte.

Pour les tâches complexes, il peut également être utile de séparer :

```text
Exploration
    ↓
Plan
    ↓
Validation humaine
    ↓
Implémentation
```

Un premier prompt peut demander :

```text
Explore le système.
Ne modifie rien.
Identifie les fichiers, risques et options.
```

Puis un deuxième prompt peut autoriser l’implémentation.

Cette séparation réduit les modifications prématurées.

Pendant une session, Claude Code peut également être corrigé.

Il vaut mieux corriger une mauvaise trajectoire **rapidement**.

Par exemple :

```text
Stop.
Ne touche pas à la base de données.
Le problème concerne uniquement le frontend.
Reprends ton analyse avec ce périmètre.
```

Plus la correction arrive tard, plus le contexte inutile s’accumule.

Après plusieurs corrections infructueuses, il peut être préférable de réécrire complètement le prompt.

```text
Ancienne session
→ bruit
→ hypothèses dépassées
→ corrections

Nouvelle session
→ apprentissage condensé
→ prompt précis
→ contexte propre
```

En mode non interactif, les exigences sont encore plus strictes.

Avec :

```text
claude -p
```

l’utilisateur n’est pas nécessairement présent pour réorienter l’agent.

Le prompt doit donc spécifier davantage :

* entrées ;
* sorties ;
* outils autorisés ;
* format ;
* erreurs ;
* critères de validation.

Une sortie structurée peut être préférable :

```json
{
  "status": "OK",
  "files": [],
  "issues": []
}
```

Les principales erreurs de prompting sont finalement :

```text
Prompt trop vague
        ↓
Claude doit trop deviner

Prompt trop procédural
        ↓
Claude est enfermé dans une stratégie

Pas de vérification
        ↓
Claude conclut sur plausibilité

CLAUDE.md surchargé
        ↓
trop de bruit permanent

Instruction confondue avec contrainte
        ↓
absence de garantie réelle
```

Une instruction adressée au modèle n’est pas nécessairement une garantie.

Par exemple :

```text
Ne jamais modifier .env
```

guide Claude.

Mais si cette règle doit être absolument garantie, il faut utiliser un mécanisme plus fort :

```text
permission
hook
test
CI
sandbox
règle de revue
```

Le prompt guide donc la trajectoire agentique, tandis que les mécanismes déterministes garantissent les invariants qui ne doivent jamais dépendre uniquement du raisonnement du modèle.

## Points clés

* Un prompt définit une tâche, pas seulement une question.
* Dans Claude Code, le prompt déclenche une trajectoire agentique.
* Un bon prompt réduit l’ambiguïté opératoire.
* La longueur du prompt n’est pas un indicateur de qualité.
* Il faut décrire le résultat attendu plutôt que toutes les étapes internes.
* Le prompt doit être directif sur les invariants et plus libre sur les moyens.
* Le prompt immédiat contient les informations propres à la tâche actuelle.
* Les règles permanentes doivent plutôt vivre dans `CLAUDE.md`.
* Les procédures spécialisées peuvent être déplacées dans des Skills.
* Un prompt de subagent doit être suffisamment autonome.
* Un bon prompt réduit le coût de correction et de contexte.
* Une tâche doit posséder une condition de réussite claire.
* Un bon prompt contient généralement un objectif, un contexte source, des contraintes, une référence, une vérification et un format de sortie.
* Les artefacts réels sont préférables aux paraphrases.
* Les contraintes doivent être concrètes et discriminantes.
* La vérification évite de confondre résultat plausible et résultat démontré.
* Pour les tâches complexes, exploration et modification peuvent être séparées.
* Une mauvaise trajectoire doit être corrigée le plus tôt possible.
* Après plusieurs échecs, reformuler dans un contexte propre peut être plus efficace.
* Les prompts non interactifs doivent être plus contractuels.
* Un prompt trop vague délègue trop de décisions importantes.
* Un prompt trop procédural peut empêcher une bonne exploration.
* Une instruction guide le modèle mais ne garantit pas nécessairement un comportement.
* Les règles absolues doivent être soutenues par des mécanismes déterministes.
