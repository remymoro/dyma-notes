---
title: "Première modification de code et boucle de vérification"
description: "Réaliser une première modification de code et mettre en place une boucle de vérification."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - code
  - verification
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-decouverte-premieres-commandes-cli
leçon: 04-premiere-modification-code-boucle-verification
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-22
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Pourquoi `npm test` qui passe ne suffit-il pas à valider cette modification ? | Les tests existants couvrent uniquement `src/conversion.js` (logique pure). La modification touche `src/main.js` (le DOM), qui n'est couvert par aucun test. `npm test` vert prouve seulement que la logique existante n'est pas cassée — rien sur le nouveau comportement. |
| Pourquoi exiger explicitement "ce qui n'a pas été vérifié" dans la preuve finale ? | Pour contrer le biais d'omission : sans cette exigence, tout ce qui n'a pas été vérifié reste invisible par défaut. La question inverse force à déclarer activement les angles morts plutôt que de les laisser masqués par une liste positive. |
| Pourquoi `/chrome` (ou le navigateur) complète les tests sans les remplacer ? | Les tests sont automatiques et répétables : ils protègent la logique dans le temps, sans effort humain. `/chrome` observe une fois, à un instant T, ce que les tests ne voient jamais ici (le DOM) — mais cette observation ne se répète pas toute seule. Les deux protègent des choses différentes. |
| Pourquoi "l'annulation n'est pas un échec" ? | Si on la vit comme un échec, on est tenté d'accepter un diff imparfait plutôt que d'annuler — ce qui sape toute la boucle de vérification. Comme le dépôt part d'un état Git propre, revenir en arrière est gratuit et sans risque : ça permet d'appliquer les critères d'acceptation avec rigueur. |
| Que doit contenir la demande d'implémentation ? | Fichier ciblé, problème, objectif, contraintes (fichiers interdits, pas de dépendance, changement minimal), vérification (`npm test` + manuelle), définition de terminé (message clair, tests passent, diff résumé, limites indiquées). |
| Quel est le réflexe le plus important de la leçon ? | Regarder le diff soi-même (`git diff`) — c'est la source de vérité, même si Claude explique bien son travail. |
| Quels sont les 6 critères d'acceptation de la modification ? | Seul `src/main.js` modifié, comportement vide/invalide plus clair, conversion normale toujours fonctionnelle, `npm test` passe, vérification navigateur cohérente, diff court et lisible. |
| Comment annuler une modification non commitée ? | `git checkout -- src/main.js` ou `git restore src/main.js`. |
| À quoi servent `/copy` et `/export` ici ? | `/copy` récupère un résumé court (5 lignes) pour le coller ailleurs (issue, PR, message). `/export` conserve la trace complète de la session pour documentation ou archivage. |

## Synthèse
La première vraie modification avec Claude Code boucle tout ce qui a été appris : une demande cadrée (fichier, contraintes, vérification, définition de terminé), suivie d'une vérification en plusieurs couches — le diff regardé soi-même, les tests automatisés (avec conscience de leurs limites), la vérification frontend (manuelle ou via `/chrome`), et une preuve finale qui déclare explicitement ce qui n'a pas été vérifié. La décision de garder ou d'annuler la modification n'est jamais automatique, et annuler via Git n'est pas un échec — c'est le fonctionnement normal d'une boucle de vérification prise au sérieux.

## Glossaire
- **Boucle de vérification** : cycle demander → modifier → tester → vérifier → prouver → décider, qui referme une tâche de manière contrôlée.
- **Diff** (`git diff`) : source de vérité montrant exactement ce qui a changé, à regarder soi-même avant toute validation.
- **`/chrome`** : commande configurant l'intégration Claude in Chrome, pour une vérification frontend par observation.
- **`/copy`** : commande copiant la dernière réponse (ou un résumé demandé) dans le presse-papiers.
- **`/export`** : commande exportant la conversation complète en texte, pour archivage ou documentation.
- **Preuve finale** : synthèse obligatoire listant fichiers modifiés, commandes exécutées, résultats, vérification frontend, et surtout ce qui n'a pas été vérifié.
- **Définition de terminé** : critères explicites qui closent une tâche — sans elle, Claude peut croire le travail fini après avoir simplement écrit du code.
- **Recadrage de périmètre** : instruction demandant à Claude d'expliquer ou de réduire un diff qui dépasse les fichiers autorisés.
- **Annulation** (`git checkout --` / `git restore`) : retour à l'état précédent d'un fichier non commité — un outcome normal, pas un échec.

## Questions d'auto-évaluation
1. Pourquoi vérifier `git status` et `npm test` avant même d'ouvrir Claude Code pour cette leçon ?
2. Que doit faire Claude si on lui demande de rappeler le contexte avant la modification ?
3. Que contient une demande d'implémentation précise pour cette correction ?
4. Pourquoi le diff doit-il rester limité à un seul fichier ici ?
5. Que faire si Claude a modifié plus de fichiers que prévu ?
6. Que prouve `npm test` dans ce projet, et que ne prouve-t-il pas ?
7. Pourquoi la vérification frontend est-elle nécessaire en complément des tests ?
8. Que fait `/chrome`, et pourquoi ne remplace-t-il pas les tests automatisés ?
9. Que doit contenir une "preuve finale" ?
10. Pourquoi le diff doit-il être regardé une seconde fois après la preuve finale ?
11. À quoi sert `/copy` par rapport à `/export` ?
12. Quels sont les 6 critères d'acceptation d'une modification dans cette leçon ?
13. Comment annuler une modification non commitée dans `src/main.js` ?
14. Pourquoi l'annulation n'est-elle pas considérée comme un échec ?
15. Que montre cette première modification sur l'utilité de Claude Code quand une tâche est cadrée ?

# Première modification de code et boucle de vérification

**Durée : 20 minutes**

**Commandes :** `/chrome`, `/copy` et `/export`

## Objectif de la leçon

Cette leçon ferme la boucle complète : demander une modification cadrée, la regarder se faire, la vérifier à plusieurs niveaux (diff, tests, frontend), exiger une preuve honnête (y compris ses limites), puis décider — garder ou annuler — sans jamais valider par confort. Le principe central : une modification n'est pas terminée parce qu'elle semble correcte, elle est terminée quand elle a été prouvée.

---

# 1. Repartir d'un état propre et connu

```text
cd convertisseur-temperature
git status     → dépôt propre ?
npm test       → tests déjà verts avant toute modification ?
        │
        ▼
claude          (depuis la racine)
        │
        ▼
/status  /doctor   (si doute sur l'environnement)
```

Si les tests échouent déjà **avant** la modification, impossible de savoir ensuite si Claude a cassé quelque chose ou si le projet était déjà en tort. Le point de départ doit être connu et propre.

---

# 2. Rappeler le contexte avant d'autoriser l'écriture

Une nouvelle conversation ne connaît pas automatiquement les décisions de la leçon précédente. On les fait rappeler, en court :

```text
Rappelle le contexte en 5 lignes : fichier ciblé,
problème, fichiers à ne pas modifier,
commande de test, vérification manuelle.
```

Si Claude propose déjà de toucher plusieurs fichiers à ce stade — avant même la vraie demande — on recadre immédiatement.

---

# 3. La demande d'implémentation

```text
Fichier ciblé        → src/main.js UNIQUEMENT
Problème              → champ vide/invalide mal géré
Objectif               → message clair au lieu d'un résultat incorrect
Contraintes             → pas de dépendance, pas de nouveau fichier,
                          pas de refactorisation opportuniste,
                          changement le plus petit possible
Vérification            → npm test + vérification manuelle
Définition de terminé   → message clair, tests OK, diff résumé,
                          limites indiquées, vérifié vs non-vérifié
```

Chaque élément existe pour fermer une porte que Claude aurait pu ouvrir seul : sans "fichier ciblé", il pourrait toucher `src/conversion.js` ; sans "définition de terminé", il pourrait s'arrêter après avoir juste écrit du code.

---

# 4. Regarder le diff soi-même — le réflexe le plus important

```bash
git diff
```

```text
Diff limité à src/main.js
        │
        ▼
   ✅ conforme au périmètre

Diff touche d'autres fichiers
        │
        ▼
   ⛔ STOP — "Explique pourquoi chaque fichier
             a été modifié. Ne fais aucune
             nouvelle modification."
```

Même si Claude explique bien son travail dans le résumé, **le diff est la source de vérité**. Un résumé peut être plausible ; le diff, non — il montre exactement ce qui a changé.

---

# 5. Les tests automatisés : ce qu'ils prouvent, ce qu'ils ne prouvent pas

```text
test/conversion.test.js
        │
        ▼
   teste src/conversion.js (logique pure)
        │
        ▼
   npm test vert
        │
        ▼
"la logique de conversion n'est pas cassée"
        │
        ▼
   ≠ "le nouveau message d'erreur fonctionne"
     (src/main.js n'est couvert par AUCUN test)
```

`npm test` répond à une seule question : la logique déjà existante est-elle intacte ? Il ne dit rien sur le comportement qu'on vient d'ajouter dans l'interface.

---

# 6. Vérifier le frontend : manuellement ou via /chrome

```bash
npm run dev
```
```text
http://localhost:5173

Cas 1 : champ vide           → message demande une saisie
Cas 2 : valeur valide (20)   → "20 °C correspondent à 68 °F"
Cas 3 : valeur invalide       → message d'erreur explicite
```

`/chrome` automatise cette observation via l'extension Claude in Chrome :

```text
Tests automatisés          Vérification frontend (/chrome)
        │                              │
        ▼                              ▼
répétable, automatique      observation ponctuelle, à l'instant T
protège la logique          valide le comportement visible
dans le temps                (ce que les tests ne voient pas ici)
        │                              │
        └──────────── se complètent ───┘
              (ni l'un ni l'autre ne remplace l'autre)
```

Sans cette étape, le nouveau comportement resterait entièrement non prouvé — même avec des tests tout verts.

---

# 7. La preuve finale : déclarer aussi ce qui n'a PAS été vérifié

```text
Résumé de confiance                Preuve finale exigée
"Tout fonctionne."          vs      1. Fichiers modifiés
                                     2. Résumé du diff
                                     3. Commandes exécutées
                                     4. Résultat exact
                                     5. Vérification frontend
                                     6. Cas testés
                                     7. Ce qui N'A PAS été vérifié
                                     8. Risque restant éventuel
```

Le point 7 est le plus important : sans lui, tout ce qui n'a pas été vérifié reste invisible par défaut. En le forçant, les angles morts doivent être **déclarés activement**, pas simplement absents de la liste positive.

---

# 8. Décider : garder ou annuler, jamais par défaut

```text
Modification acceptable si TOUS ces points sont vrais :
1. seul src/main.js a été modifié ;
2. comportement vide/invalide plus clair ;
3. conversion normale toujours fonctionnelle ;
4. npm test passe ;
5. vérification navigateur cohérente ;
6. diff court et lisible.
        │
        ▼
Un seul point échoue ?
        │
        ▼
   NE PAS valider — corriger ou annuler
```

```bash
# Annuler (aucun échec — juste un outcome normal)
git checkout -- src/main.js
# ou selon la version de Git
git restore src/main.js

# Garder
git status
git diff
git add src/main.js
git commit -m "Gère les saisies invalides dans le convertisseur"
```

Le dépôt part d'un état Git propre : annuler est donc gratuit et sans risque. Traiter l'annulation comme un échec pousserait à valider par confort plutôt que par preuve — exactement ce que toute la boucle de cette leçon cherche à éviter.

---

# 9. /copy et /export : sortir la trace de la session

```text
/copy    → résumé court (5 lignes) pour une note, une issue, une PR
/export  → conversation complète, pour documenter ou archiver
```

Le bon réflexe est de demander une version compacte avant `/copy` (5 lignes structurées valent mieux qu'un historique entier), et de demander un résumé final avant `/export` si l'objectif est de documenter la décision prise.

---

# 10. Ancrage sur ta stack (web front/back JS-TS)

Cette boucle se transpose telle quelle sur un vrai projet :

- avant toute correction touchant l'UI (un composant React, un formulaire), vérifie explicitement si les tests existants couvrent le DOM ou seulement la logique métier — la plupart du temps, comme ici, ils ne couvrent pas le DOM ;
- utilise `/chrome` (ou une vérification manuelle) systématiquement pour toute tâche frontend, jamais seulement les tests unitaires ;
- exige toujours "ce qui n'a pas été vérifié" dans les résumés de Claude sur du code de production — c'est ce qui évite de découvrir un angle mort en review ou, pire, en prod ;
- garde le réflexe d'annulation gratuite : un commit de référence avant chaque session Claude Code permet de rejeter sans hésitation un diff qui ne remplit pas les critères, même sur un vrai projet d'équipe.

---

# Résumé & Schéma global

```text
État propre       Demande         Modification      Vérification         Décision
(git status   →   précise     →   (diff limité   →  multicouche      →  (garder si
npm test)         (fichier,       à src/main.js)     (diff, npm test,      6/6 critères,
                  contraintes,                        frontend,             sinon annuler
                  vérif,                               preuve finale)        via git)
                  terminé)
```

# Tableau des commandes à retenir

| Commande | Rôle |
|---|---|
| `git status` / `npm test` | Vérifier l'état propre du dépôt avant toute modification |
| `git diff` | Regarder soi-même ce qui a réellement changé — source de vérité |
| `npm run dev` | Lancer le serveur pour la vérification frontend manuelle |
| `/chrome` | Configurer et déclencher une vérification frontend observée |
| `/copy` | Copier un résumé court dans le presse-papiers |
| `/export` | Exporter la conversation complète en texte |
| `git checkout -- <fichier>` / `git restore <fichier>` | Annuler une modification non commitée |
| `git add` / `git commit` | Valider et créer un point de repère une fois la modification acceptée |

# Les 5 points les plus importants

## 1. Une modification n'est pas terminée parce qu'elle semble correcte
Elle est terminée quand le diff a été regardé, la preuve demandée, la preuve vérifiée, et le résultat validé.

## 2. `npm test` vert ne prouve que ce qu'il couvre
Ici, il protège la logique de `src/conversion.js`, pas le comportement DOM ajouté dans `src/main.js`.

## 3. Tests automatisés et vérification frontend se complètent, ne se remplacent jamais
L'un protège la logique dans le temps de façon répétable ; l'autre valide le comportement visible à un instant donné.

## 4. La preuve finale doit déclarer ce qui n'a PAS été vérifié
Sans cette exigence, les angles morts restent invisibles par défaut derrière une liste positive.

## 5. Annuler n'est pas un échec
Le dépôt part d'un état propre : rejeter un diff imparfait est gratuit, et c'est le fonctionnement normal d'une boucle de vérification prise au sérieux.

---

# Carte mentale

```text
Première modification + boucle de vérification
│
├── Avant
│   ├── git status / npm test (état propre)
│   ├── claude (racine)
│   └── rappel de contexte
│
├── Demande d'implémentation
│   ├── fichier ciblé
│   ├── contraintes
│   ├── vérification
│   └── définition de terminé
│
├── Vérification multicouche
│   ├── git diff (réflexe n°1)
│   ├── npm test (limite : ne couvre pas le DOM)
│   ├── frontend manuel / /chrome (complète, ne remplace pas)
│   └── preuve finale (+ ce qui n'a PAS été vérifié)
│
├── Décision
│   ├── 6 critères d'acceptation
│   ├── annuler → git checkout / restore (pas un échec)
│   └── garder → git add / commit
│
└── Sortie de session
    ├── /copy (résumé court)
    └── /export (trace complète)
```

---

# Mini fiche de révision

```text
AVANT   → git status / npm test (état propre et connu)
DEMANDE → fichier + contraintes + vérification + définition de terminé
DIFF    → git diff (réflexe n°1, source de vérité)
TESTS   → npm test = logique seulement, PAS le DOM ici
FRONTEND→ manuel / /chrome = complément, jamais un remplacement
PREUVE  → vérifié ET non-vérifié (pas juste le positif)
DÉCISION→ 6/6 critères sinon annuler (git checkout / restore)
ANNULER ≠ ÉCHEC
/copy   → résumé court   /export → trace complète
```

## Phrase à retenir

> Une modification n'est jamais terminée parce qu'elle semble correcte — elle est terminée quand elle a été prouvée, angles morts compris.
