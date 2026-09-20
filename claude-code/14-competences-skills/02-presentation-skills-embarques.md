---
title: "Présentation des skills embarquées"
description: "Découvrir le catalogue natif de Claude Code (/run, /verify, /doctor, /debug, /loop...) et comprendre quand les utiliser dans un projet."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - skills
  - commandes-natives
categories:
  - "Chapitre 14"
cours: Claude Code
chapitre: 14-competences-skills
leçon: 02-presentation-skills-embarques
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-04
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Comment lister les skills disponibles ?** | La commande `/skills` affiche la liste consolidée. Cette liste dépend de l'environnement, mais inclut toujours les skills natives (embarquées), les skills projet (`.claude/skills/`), les skills personnelles (`~/.claude/skills/`) et les plugins. |
| **Quelle est la différence entre `/run` et `/verify` ?** | `/run` démarre l'application pour que Claude puisse interagir avec (il devine la commande de lancement via `package.json` ou `Makefile`). `/verify` va plus loin : il construit, lance, et *prouve* qu'un scénario précis fonctionne (ex: "Vérifie que la saisie vide affiche une erreur"). |
| **Que faire si Claude n'arrive pas à lancer mon projet avec `/run` ?** | Utiliser `/run-skill-generator`. Ce skill va explorer votre dépôt, tâtonner pour trouver la bonne façon d'installer, construire et lancer le projet, puis sauvegardera cette "recette" dans une skill locale pour les prochaines fois. |
| **Comment diagnostiquer un problème de Claude Code lui-même ?** | `/doctor` audite l'environnement (PATH, doublons, configuration cassée). `/debug` analyse le fichier de log de la session courante pour comprendre pourquoi une commande interne a échoué. **Attention** : aucun de ces deux skills ne sert à déboguer *votre code métier*. |
| **À quoi sert `/fewer-permission-prompts` ?** | C'est un utilitaire qui analyse votre historique pour repérer les commandes Bash/MCP que vous autorisez manuellement en permanence. Il vous propose alors un bloc JSON à ajouter dans vos `.claude/settings.json` pour pré-approuver ces actions. |
| **Comment surveiller le résultat d'une CI ou d'un déploiement ?** | Avec `/loop [intervalle] [condition]`. Ex: `/loop 5m Vérifie si le déploiement est terminé.` Claude exécutera la vérification en boucle tant que la session reste ouverte. |

## Synthèse
Claude Code est livré avec un éventail de `skills` embarquées (natives) pour accélérer le workflow de développement quotidien. Elles s'utilisent toutes avec le préfixe `/`.
Les plus utiles au quotidien sont `/run` (pour démarrer le serveur local) et `/verify` (pour tester concrètement une fonctionnalité dans le navigateur, au-delà de ce que couvrent les tests unitaires). Si votre projet est complexe à démarrer, `/run-skill-generator` créera un script sur mesure.
D'autres skills servent à diagnostiquer l'agent lui-même (`/doctor` pour l'environnement, `/debug` pour lire ses propres logs d'erreur), à réduire le bruit (`/fewer-permission-prompts` pour automatiser les pré-approbations de permissions répétitives), ou à surveiller une tâche asynchrone (`/loop`). 
Enfin, il existe des skills de niche, souvent chargées automatiquement par l'agent quand il détecte un cas d'usage : `/claude-api` (s'il voit que vous codez avec le SDK Anthropic), `/dataviz` (s'il doit créer des graphiques) ou `/design-sync` (pour synchroniser un Design System React).

## Glossaire
- **Skill embarquée** : Compétence (workflow) pré-programmée et distribuée nativement avec le CLI Claude Code.
- **`/verify`** : Skill native permettant de tester des scénarios d'usage réels (UI, E2E) plutôt que de simples tests unitaires.
- **`/doctor`** : Skill de diagnostic de l'environnement de développement (chemin, versions, configs cassées).
- **`/loop`** : Skill permettant d'exécuter un prompt en boucle à intervalles réguliers (ex: polling d'un log de déploiement).

## Questions d'auto-évaluation
1. Si je veux que Claude teste manuellement le fait que taper "abc" dans mon champ de texte affiche bien une erreur "NaN", quelle skill native dois-je utiliser ?
2. Vrai ou Faux : `/debug` est le meilleur outil pour trouver pourquoi ma fonction JavaScript renvoie `undefined`.
3. Que se passe-t-il si je tape `/skills` ?
4. Mon projet nécessite de lancer Docker, puis de compiler du Rust, puis de lancer un serveur Node. Claude n'y arrive pas avec `/run`. Quelle skill peut m'aider à automatiser ce lancement ?

# Présentation des skills embarquées

**Durée : 15 minutes**

## Objectif de la leçon
Connaître le couteau suisse natif de Claude Code pour éviter de recréer soi-même des workflows qui existent déjà.

---

# 1. Le Workflow de Développement (`/run` et `/verify`)

### `/run`
C'est la commande de base pour démarrer votre produit. Claude inspecte `package.json`, `README.md` ou `Makefile` pour deviner comment lancer le projet (ex: `npm run dev`). L'intérêt est qu'une fois lancé, Claude peut "regarder" l'application tourner.

### `/verify`
C'est l'étape d'après. Les tests unitaires (`npm test`) c'est bien, mais ça ne teste pas le navigateur. `/verify` permet de formuler des scénarios concrets de test E2E.
```text
/verify Vérifie les comportements suivants :
- la valeur 20 affiche 68 °F
- une saisie vide affiche une erreur
```

### `/run-skill-generator`
Si votre projet est trop tordu pour `/run` (ex: variables d'environnement complexes, plusieurs services à démarrer), lancez cette skill. Claude va chercher la bonne méthode, et une fois qu'il l'aura trouvée, il générera une skill locale propre à votre projet pour que les prochains lancements soient instantanés.

---

# 2. Le Diagnostic de Claude Code (`/doctor` et `/debug`)

> [!WARNING]
> Ces skills ne servent **pas** à débugger votre code JavaScript ou Python. Elles servent à réparer Claude Code.

- **`/doctor`** : Scanne votre installation (Vous avez deux versions du CLI installées ? Votre PATH est cassé ? Des hooks sont trop lents ?).
- **`/debug`** : Si Claude fait une erreur interne (ex: un appel réseau API échoue, l'agent boucle), cette skill lui demande de lire ses propres logs de session pour comprendre ce qui cloche.

---

# 3. Améliorer l'expérience utilisateur

### `/fewer-permission-prompts`
Vous en avez marre que Claude vous demande toujours la permission pour faire `ls` ou lire un fichier `.env` ? 
Lancez cette skill. Elle analysera votre historique, trouvera les commandes "read-only" que vous acceptez tout le temps, et vous générera le JSON à copier-coller dans `.claude/settings.json` pour les pré-approuver.

### `/loop`
Pratique pour le polling (surveiller un événement en boucle).
Exemple : `/loop 2m Regarde si la CI Github Actions a terminé de tourner`. (La session reste ouverte et vérifie toutes les 2 minutes).

---

# 4. Les Skills "Invisibles" (De contexte)

Certaines skills n'ont pas vocation à être lancées manuellement, elles se déclenchent (Lazy Load) si Claude détecte que vous travaillez sur ces sujets :
- **`/claude-api`** : Si vous importez le SDK `@anthropic-ai/sdk`, Claude charge cette skill pour connaître la doc de l'API à jour.
- **`/dataviz`** : Si vous lui demandez de faire un dashboard, il chargera cette skill pour connaître les meilleures pratiques d'accessibilité et de contraste.
- **`/design-sync`** : Analyse un design system React pour le synchroniser avec les outils internes.

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Workflow standard avec les skills natives :
1. `/run` -> Démarre l'appli.
2. `/verify ...` -> Constate que le comportement est buggé.
3. Utilisateur : "Corrige la gestion des saisies" -> Claude code.
4. `npm test` -> Tests unitaires OK.
5. `/verify ...` -> Comportement réel OK.
6. `/code-review` -> Cherche d'éventuels edge-cases oubliés.
7. `/simplify` -> Nettoie le code pour qu'il soit propre.
```

> **La phrase centrale de la leçon :**
> Ne réinventez pas la roue : utilisez `/run` pour lancer, `/verify` pour prouver le comportement UI, et `/fewer-permission-prompts` pour rendre votre quotidien avec l'agent moins verbeux.
