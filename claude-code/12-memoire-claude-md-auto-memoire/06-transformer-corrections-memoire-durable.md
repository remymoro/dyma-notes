---
title: "Transformer les corrections en mémoire durable"
description: "Le principe de compounding engineering : transformer une erreur récurrente en règle de mémoire."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - memoire
  - capitalisation
categories:
  - "Chapitre 12"
cours: Claude Code
chapitre: 12-memoire-claude-md-auto-memoire
leçon: 06-transformer-corrections-memoire-durable
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-10-02
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Qu'est-ce que le *compounding engineering* ?** | C'est le fait d'accumuler de petites règles durables (issues d'erreurs) qui réduisent le taux d'erreur futur. L'amélioration du système de travail s'additionne avec le temps. |
| **Quand faut-il capitaliser une erreur en règle ?** | Uniquement si l'erreur est **stable, répétitive, et non évidente** dans le code. Un accident de session isolé ne mérite pas une règle. |
| **Pourquoi la revue de Pull Request est-elle clé ?** | Si un reviewer humain fait plusieurs fois la même remarque sur des PRs générées par Claude, c'est le signal fort qu'il manque une règle dans la mémoire du projet pour prévenir l'erreur. |
| **Quel est le protocole en 5 étapes pour convertir une erreur en règle ?** | 1. **Formuler** (demander à Claude d'expliquer son erreur et la règle).<br>2. **Choisir la destination** (global, rule, hook).<br>3. **Écrire petit** (max 5 lignes, actionnable).<br>4. **Tester** (lui demander de simuler son comportement).<br>5. **Faire relire** (revue d'équipe). |
| **Comment gérer l'intégration GitHub et les PRs ?** | Dans GitHub, le déclencheur est `@claude`. Pour ne pas qu'il reproduise des erreurs, configurez ses critères de revue dans `CLAUDE.md` et utilisez le paramètre `prompt` du workflow. |
| **Quel est le plus grand danger de la capitalisation ?** | **Les règles de migration immortelles**. Une règle transitoire qui survit à sa migration devient fausse et pollue les futures sessions. Toujours lui donner une condition de suppression (via un commentaire HTML). |

## Synthèse
Corriger une erreur de Claude de manière ponctuelle ne règle le problème que pour la session en cours. Le véritable levier réside dans le *compounding engineering* : transformer une erreur récurrente (notamment celles repérées lors des revues de PR) en une consigne permanente et ciblée dans `CLAUDE.md` ou `.claude/rules/`. Cependant, toute erreur ne mérite pas d'être mémorisée. Il faut capitaliser sur des *patterns* (choix d'architecture, commandes spécifiques), pas sur des accidents. Lorsqu'une erreur justifie une règle, celle-ci doit être courte, actionnable, placée au bon endroit (portée), et surtout testée. Enfin, l'obsolescence est le grand piège de ce processus : une règle de migration doit impérativement être accompagnée d'une condition d'expiration (via un commentaire HTML) pour être supprimée une fois la transition achevée.

## Glossaire
- **Compounding engineering** : Mécanisme d'amélioration continue où chaque correction transformée en mémoire durable réduit la probabilité globale d'erreur.
- **Règle durable** : Consigne courte et testable ajoutée au contexte (`CLAUDE.md` ou `rules/`) pour empêcher la reproduction d'une erreur.
- **Règle de migration immortelle** : Règle transitoire oubliée dans le contexte alors que la migration est finie (anti-pattern majeur).
- **`@claude`** : Le mot-clé déclencheur officiel de l'agent dans l'intégration GitHub (différent de la syntaxe de dossier `.claude`).

## Questions d'auto-évaluation
1. L'agent vient de foirer une commande git complexe que j'utilise une fois par an. Dois-je créer une règle dans `CLAUDE.md` ?
2. Un collègue commente "N'oublie pas de typer tes retours d'API" sur 3 PRs générées par Claude. Que faire ?
3. Quelle est l'étape 1 du protocole de conversion d'erreur ? (Dois-je écrire la règle moi-même immédiatement ?)
4. J'ai ajouté une règle : "Ne plus utiliser Moment.js, on migre vers Date-fns". Quel est le danger si je m'arrête là ?

# Capitaliser les retours d'expérience : transformer les corrections en mémoire durable

**Durée : 8 minutes**

## Objectif de la leçon
Passer d'une correction réactive (corriger l'agent ponctuellement) à une correction proactive (corriger l'environnement de l'agent pour le futur) grâce au processus de capitalisation.

---

# 1. Corriger la cause, pas seulement la sortie

Quand Claude fait une erreur, votre premier réflexe est de lui dire : *"Non, n'utilise pas l'ancien client API"*.
C'est une **correction locale**. Le problème disparaît de la session, mais réapparaîtra demain.

La **correction durable** consiste à traiter la cause racine : l'absence d'une consigne claire dans l'environnement.
👉 *"Mets à jour le `CLAUDE.md` : tout nouveau code réseau utilise `src/lib/api-client.ts`."*

C'est ce qu'on appelle le **compounding engineering** : chaque petite règle ciblée s'accumule et rend le projet progressivement plus facile à piloter par l'IA.

---

# 2. Quand capitaliser (et quand s'abstenir)

**NE PAS CAPITALISER** (Ne pas créer de règle) :
- Une erreur isolée ou un bug unique.
- Une préférence personnelle temporaire.
- Une piste de debugging infructueuse.

**CAPITALISER** (Créer une règle) :
- Une erreur stable et répétitive.
- Une convention impossible à deviner en lisant le code.
- **Une remarque de revue de Pull Request qui revient souvent.** *(C'est le signal d'alarme n°1 !)*

> [!WARNING]
> **Le piège de la PR**
> Une préférence de style très personnelle d'un *reviewer* ne doit pas devenir une règle globale imposée à tous. Validez avec l'équipe avant de graver une remarque de PR dans le `CLAUDE.md`.

---

# 3. Le Protocole de conversion en 5 étapes

Ne rédigez pas la règle à chaud. Suivez ce protocole :

1. **Formuler l'erreur avec l'agent** : Demandez à Claude d'expliquer lui-même son erreur, la cause probable, et la règle qui l'aurait évitée. *(Cela évite de créer une règle trop large).*
2. **Choisir la destination** : Règle transversale (`CLAUDE.md`), ciblée (`.claude/rules/`), skill, ou hook ?
3. **Écrire petit** : La règle doit faire **moins de 5 lignes**. Aucun historique, aucune justification narrative. Juste un comportement à suivre et un comportement à éviter.
4. **Tester** : Demandez à Claude ce qu'il ferait dans la même situation maintenant que la règle existe.
5. **Faire relire** : La modification d'une mémoire partagée est une modification de code. Elle doit passer en PR (ou être au moins validée).

---

# 4. Faire expirer les règles : Le piège des migrations

Les règles issues d'erreurs ne sont pas éternelles !
Le cas le plus dangereux est la **règle de migration**.

Si vous écrivez : *"Ne plus utiliser `src/legacy/request.ts`"*, cette règle est utile aujourd'hui. Mais dans 6 mois, quand le fichier `request.ts` aura été supprimé, cette règle restera dans le contexte de chaque session pour interdire l'utilisation d'un fichier qui n'existe plus !

**La solution :** Les commentaires HTML.
```markdown
<!-- Note mainteneur : Supprimer cette règle quand le dossier src/legacy sera vide -->
Ne pas utiliser le client legacy, privilégier api-client.ts.
```

---

# Cartes mentales

```text
               TRANSFORMER UNE ERREUR EN RÈGLE
                           │
           ┌───────────────┼───────────────┐
           ↓               ↓               ↓
      EST-CE RÉPÉTITIF ?   EST-CE UTILE ?   QUELLE DESTINATION ?
    (Non = ignorer)    (Oui = écrire petit)  (CLAUDE.md, rules/)
           │               │               │
           └───────────────┬───────────────┘
                           ↓
                   DANGER MAJEUR :
                L'obsolescence (Migrations)
           (Toujours prévoir une date d'expiration)
```

---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Prompt magique pour l'Étape 1 (Formulation) :
"Explique l'erreur que tu viens de faire. Réponds uniquement avec :
- erreur produite
- cause probable
- règle durable qui l'aurait évitée
- emplacement recommandé
- risque si on ajoute cette règle trop largement."
```

> **La phrase centrale de la leçon :**
> Le but n'est pas d'écrire plus de mémoire, mais une mémoire qui réduit le taux d'erreur futur. Chaque règle ajoutée doit être courte, testée, et posséder une condition d'expiration pour ne pas se transformer en dette contextuelle.
