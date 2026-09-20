---
title: "Workflow de création de projet à l'ère de l'IA"
description: "Comprendre comment l'IA déplace le goulot d'étranglement du développement de l'implémentation vers le cadrage et la validation."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - workflow
  - architecture
  - design-doc
categories:
  - "Chapitre 13"
cours: Claude Code
chapitre: 13-projet-partie-1-demarrage-projet
leçon: 01-workflow-creation-projet-ere-ia
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Comment l'IA déplace-t-elle le goulot d'étranglement ?** | Avant : le goulot était *l'implémentation* (écrire le code). Avec l'IA : l'implémentation est rapide, le goulot se déplace aux extrémités : **en amont** (Cadrage / *Framing*) et **en aval** (Validation / Revue). |
| **Qu'est-ce qu'un Design Doc ?** | Un document de cadrage (souvent utilisé chez Google) rédigé *avant* le code. Il décrit le problème, les objectifs, les non-objectifs, les choix d'architecture, et les preuves de succès attendues. C'est le "contrat" passé avec l'agent. |
| **Qu'est-ce que le *Walking Skeleton* ?** | Une implémentation minuscule mais fonctionnelle de bout-en-bout. Elle valide que le compilateur, les tests, et la CI fonctionnent avant d'ajouter la moindre logique métier. |
| **Pourquoi utiliser un second agent pour la revue ?** | L'agent qui a codé connaît son propre raisonnement et reproduira ses angles morts. Un agent "indépendant", lancé dans un contexte neuf (avec seulement le Design Doc et le Diff), aura une distribution d'erreurs différente. |
| **Quel est le risque de la modification des tests par l'IA ?** | Un agent peut modifier un test non pas pour le corriger, mais pour *l'adapter à une régression* qu'il vient de créer. La modification des tests exige une vigilance humaine accrue. |
| **Quel est le nouveau rôle du développeur ?** | Il n'est plus un "typiste de code", mais un **ingénieur système** : cadreur de problème, concepteur d'environnement, évaluateur, et reviewer responsable. |

## Synthèse
L'avènement des agents de développement comme Claude Code transforme radicalement le workflow de l'ingénierie logicielle. La frappe manuelle du code, qui fut longtemps la ressource la plus rare et le goulot d'étranglement des équipes, est désormais automatisée. En conséquence, les goulots se déplacent : produire du code ne suffit plus si ce code résout le mauvais problème ou s'accumule en attente de revue. La valeur du développeur se recentre sur le **Cadrage (Framing)** via des *Design Docs* solides, et la **Validation**. Pour que l'agent soit efficace, il faut lui fournir un environnement reproductible (un "socle" ou *Walking skeleton*) et des critères de succès stricts (*Quality gates*). La validation devient un système multi-niveaux, impliquant des agents indépendants pour la revue de code, tout en gardant l'humain comme ultime responsable opérationnel lors de la fusion et du déploiement.

## Glossaire
- **Framing (Cadrage)** : Transformer une demande vague en un contrat d'ingénierie strict (Problème, Objectifs, Non-objectifs, Contraintes).
- **Design Doc** : Document d'architecture écrit *avant* d'implémenter, servant d'interface et de contrat entre l'intention humaine et l'agent.
- **Walking Skeleton** : Squelette applicatif minimal qui traverse toutes les couches du système de bout-en-bout (compilation, CI, tests) sans logique métier.
- **Tranche verticale** : Développer un cas d'usage complet de l'interface jusqu'à la base de données, plutôt que de développer horizontalement (toute la BDD, puis toute l'API).
- **Quality Gates** : Conditions observables et déterministes qui doivent être satisfaites avant de passer à l'étape suivante du flux.

## Questions d'auto-évaluation
1. Si mon équipe utilise des agents IA et produit 3 fois plus de Pull Requests par jour, que risque-t-il de se passer au niveau du flux de travail ?
2. Quelle information cruciale trouve-t-on dans la section "Non-objectifs" d'un Design Doc ?
3. Pourquoi une Pull Request qui modifie à la fois le code source et les tests unitaires existants doit-elle vous alerter particulièrement ?
4. Comment utiliser l'IA de manière optimale pour revoir une PR générée par une autre IA ?

# Workflow de création de projet à l'ère de l'IA

**Durée : 25 minutes**

## Objectif de la leçon
Comprendre le changement de paradigme fondamental apporté par les agents IA : la valeur n'est plus dans l'écriture du code, mais dans la définition du problème, l'architecture du système, et la validation rigoureuse des preuves.

---

# 1. Le déplacement du goulot d'étranglement

Historiquement, le code était difficile et lent à écrire. Le **Backlog** s'allongeait car l'implémentation (le centre du flux) bloquait tout.
Avec des agents comme Claude Code, la capacité de production de code explose. Mais produire plus vite ne livre pas la valeur plus vite. 

Le goulot d'étranglement se déplace aux extrémités :
- **En amont** : La capacité humaine à cadrer le besoin (*Framing*).
- **En aval** : La capacité humaine à valider, tester et déployer avec confiance.

> [!WARNING]
> **La surproduction sans livraison**
> Lancer 10 agents en parallèle pour générer du code ne sert à rien si votre équipe humaine n'a la capacité de revoir et valider que 2 Pull Requests par jour. Limitez le travail en cours !

---

# 2. Le Framing et le Design Doc

Une demande comme *"Ajoute l'authentification"* est catastrophique pour un agent. Il vous faut un contrat d'ingénierie : le **Design Doc**.

Le Design Doc est l'interface entre l'intention humaine et l'exécution agentique. Il doit définir :
- **Le Contexte et le Problème**
- **Les Objectifs et Non-objectifs** (Ce qu'on ne fait *pas* maintenant).
- **Les Contraintes** (Sécurité, performance, rétrocompatibilité).
- **Les Critères d'acceptation et de Validation** (Comment l'agent saura qu'il a réussi).

*Le code indique **ce que** le système fait. Le Design Doc préserve **pourquoi** il le fait de cette manière.*

---

# 3. Construire le socle et le "Walking Skeleton"

Ne lancez pas un agent sur la construction de fonctionnalités complexes si la base n'est pas solide. Vous devez d'abord fournir :
1. **Un environnement reproductible** (gestion des dépendances).
2. **Des commandes de validation stables** (`pnpm lint`, `pnpm test`).
3. Un **Walking Skeleton** : une application "vide" mais qui compile, possède une CI, et passe les tests. 

Cela donne à l'agent un **cadre déterministe** : chaque modification qu'il fait peut être immédiatement sanctionnée par un échec du compilateur ou de la CI.

> [!TIP]
> **Travaillez en tranches verticales**
> Au lieu de faire coder toute la base de données, puis toute l'API, demandez à l'agent de coder un seul comportement minimal de bout-en-bout (de l'interface à la DB). Cela permet une validation comportementale complète très tôt.

---

# 4. Le nouveau système de Validation

L'agent ne doit pas seulement dire *"J'ai fini"*. Il doit **fournir des preuves** que les *Quality Gates* (barrières de qualité) sont respectées.

### Le double agent (Revue de PR)
L'agent qui a écrit le code est biaisé. Pour la revue, lancez un **second agent** avec un contexte neuf. Donnez-lui uniquement le Design Doc et le *Diff* du code, avec un prompt strict :
*"Agis comme un reviewer indépendant. Recherche uniquement : les exigences absentes, les cas limites ignorés, les régressions, et les violations d'architecture. Ne signale pas les préférences stylistiques."*

### Le danger des tests modifiés
Si l'agent modifie le code source **ET** le test unitaire en même temps, il y a un risque critique : il a peut-être cassé le code et modifié le test pour qu'il passe avec la nouvelle erreur (régression masquée). Demandez-vous toujours : *Pourquoi l'ancien comportement du test était-il incorrect ?*

---

# Cartes mentales

```text
             LE NOUVEAU FLUX DE DÉVELOPPEMENT
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
        AMONT           CENTRE            AVAL
      (Cadrage)      (Implémentation)   (Validation)
           │               │               │
     Le goulot n°1     Très rapide     Le goulot n°2
     (Design Doc)    (Agents IA)     (Revue, CI, Prod)
           │               │               │
      L'humain         L'IA           L'humain
     conçoit le        code           prend le
      système                         risque
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Le rôle de l'Ingénieur à l'ère de l'IA :
1. Cadreur de problèmes : Identifie le "vrai" problème, rédige le Design Doc.
2. Concepteur de systèmes : Définit l'architecture et les interdictions.
3. Concepteur d'environnement : Met en place les tests, la CI et le Walking Skeleton.
4. Évaluateur : Fixe les critères de succès déterministes (Quality Gates).
5. Opérateur : Assure la responsabilité de la fusion (merge) et observe la production.
```

> **La phrase centrale de la leçon :**
> La valeur de l'ingénieur ne réside plus dans sa vitesse de frappe sur un clavier, mais dans sa capacité à encadrer le problème par des spécifications strictes, et à auditer les preuves générées par la machine.
