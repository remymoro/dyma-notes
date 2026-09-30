---
cours: Claude Code
chapitre: 17-travail-parallele-sous-agents-equipes
leçon: 04-commandes-advisor-fork
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la différence fondamentale entre `/advisor` et `/fork` ?** | `/advisor` demande un conseil ponctuel à un second modèle qui le retourne à la session actuelle (1 conversation, 1 exécuteur). `/fork` clone l'historique complet dans une nouvelle session asynchrone (2 conversations indépendantes). |
| **Pourquoi `/advisor` ne fournit-il pas un "contexte frais" ?** | Parce qu'il reçoit l'intégralité du *transcript* (historique de la session). Il subit donc les mêmes "biais de cadrage" que le modèle principal. Pour un avis totalement neutre ou "frais", il vaut mieux lancer un sous-agent normal avec un prompt neutre. |
| **Le modèle consulté via `/advisor` peut-il exécuter du code ou modifier des fichiers ?** | **Non**. Le conseiller produit uniquement une recommandation stratégique. C'est le modèle principal (l'exécuteur) qui lit le conseil et décide ou non de l'appliquer via ses propres outils. |
| **Quelle différence entre `/fork` et `/subtask` ?** | Avec `/subtask`, le sous-agent forké renvoie automatiquement son rapport dans la conversation actuelle. Avec `/fork`, la session clonée reste indépendante dans `agent view` : c'est à vous (l'humain) d'aller lire le résultat et de faire la synthèse. |
| **Comment désactiver le conseiller après l'avoir activé (ex: `/advisor opus`) ?** | En utilisant la commande `/advisor off`. |

## Synthèse
Les commandes `/advisor` et `/fork` sont deux moyens d'obtenir un "second souffle" lors d'une session complexe, mais avec des approches différentes. La commande `/advisor` agit comme un consultant interne : elle met le modèle principal en pause, soumet tout l'historique à un modèle secondaire (souvent plus puissant comme `opus`) pour obtenir un arbitrage architectural, puis rend la main à l'exécuteur. Cela a un coût (inférence supplémentaire) et ne casse pas le biais de cadrage, mais c'est idéal avant de s'engager dans un refactoring lourd.
La commande `/fork`, quant à elle, agit comme un clonage (`git branch` asynchrone). Elle duplique l'état actuel de votre cerveau (historique, outils) dans une nouvelle session d'arrière-plan visible dans `agent view`. C'est l'outil parfait pour explorer plusieurs pistes en parallèle (ex: implémentation A dans un fork, implémentation B dans un autre), tout en gardant votre session principale propre pour, par exemple, y préparer une grille de comparaison.

## Glossaire
- **`/advisor`** : Commande permettant au modèle actuel de consulter stratégiquement un autre modèle LLM sur la suite des opérations, sans lui donner de pouvoir d'écriture.
- **`/fork`** : Duplique la conversation courante dans une nouvelle session asynchrone (`agent view`), héritant de tout l'historique, mais qui évoluera de manière 100% indépendante.
- **`/subtask`** : Comme un `/fork`, mais qui est conçu pour s'exécuter en fond et *réinjecter* sa conclusion dans la conversation parente.
- **Biais de cadrage** : Phénomène où un LLM est influencé par ses propres erreurs ou hypothèses passées s'il relit un historique de chat trop long.

## Questions d'auto-évaluation
1. Si vous activez `/advisor`, le conseiller a-t-il la possibilité de faire un `git commit` ?
2. Quelle commande taper pour demander l'avis du modèle `opus` ?
3. Pourquoi est-il déconseillé d'activer `/advisor` en permanence pour de petites tâches mécaniques ?
4. Vous avez lancé deux `/fork` pour explorer deux architectures. Leurs rapports vont-ils apparaître automatiquement dans votre session principale ?

# Présentation des commandes `/advisor` et `/fork`

**Durée : 6 minutes**

## Objectif de la leçon
Comprendre comment solliciter un second modèle pour des décisions stratégiques sans modifier le code (`/advisor`) et comment créer des branches de travail indépendantes asynchrones (`/fork`) pour tester plusieurs approches en parallèle.

---

# 1. Le Conseiller (`/advisor`)

La commande `/advisor` permet à votre modèle principal de consulter ponctuellement un autre modèle (généralement plus puissant). 

- **Activation** : `/advisor opus` (ou `sonnet`). `off` pour désactiver.
- **Comment ça marche** : L'outil transmet la totalité du transcript (historique, outils, résultats). Le conseiller lit, émet une recommandation stratégique, et le modèle principal décide de l'appliquer.
- **Limites** : Le conseiller **ne peut pas** écrire de fichiers, exécuter de commande, ni prendre le contrôle.

> **Quand l'utiliser ?**
> Avant une décision lourde (choix d'architecture), quand une erreur boucle, ou avant un grand refactoring. Ne l'utilisez *pas* pour du code mécanique, car chaque appel double le coût d'inférence !

### Attention au "Biais de Cadrage"
Le conseiller lit le même historique que l'exécuteur. Il est donc souvent d'accord avec lui ! Il ne constitue **pas** un contexte "frais". Pour un avis réellement neutre, il faut utiliser un sous-agent classique.

---

# 2. Le Clonage Asynchrone (`/fork`)

Alors que `/advisor` reste dans la même session, `/fork` la divise en deux.

- **La commande** : `/fork <mission>`
- **Comportement** : Crée une nouvelle session d'arrière-plan (visible dans `agent view`). Cette nouvelle session hérite de tout : historique, *system prompt*, outils.
- **Indépendance** : À la seconde où le fork est créé, les deux sessions vivent leur vie. Elles ne se synchronisent plus.

---

# 3. Le grand comparatif des commandes parallèles

Pour ne plus confondre les outils de bifurcation de Claude Code :

| Commande | Où va la copie ? | Retour du résultat |
|---|---|---|
| **`/fork`** | Nouvelle session asynchrone (dans `agent view`). | Vous devez aller lire le résultat vous-même. |
| **`/subtask`** | Sous-agent asynchrone "forké". | Le rapport est **réinjecté** dans la conversation actuelle. |
| **`/branch`** | Nouvelle branche interactive. | Vous basculez dedans avec votre terminal (synchrone). |
| **`/btw`** | Réponse éphémère. | Sans entrer dans l'historique de la session. |

---

# 4. Cas d'usage : Explorer deux approches en parallèle

Vous hésitez entre deux architectures pour de l'internationalisation ? 
Restez dans votre session principale et lancez deux *forks* en lecture seule :

1. `/fork Explore uniquement l'approche "paramètre local". Ne modifie aucun fichier.`
2. `/fork Explore uniquement l'approche "catalogue centralisé". Ne modifie aucun fichier.`

Pendant ce temps, dans votre session principale, vous pouvez dire : *"Prépare une grille de comparaison vide"*.
Allez ensuite dans `claude agents`, lisez les conclusions des deux *forks* (touche `Espace`), et remplissez votre grille !

> **Avertissement de sécurité** : Un `/fork` est une session en arrière-plan. S'il commence à écrire du code, il pourrait être déplacé par Claude dans un *worktree*. C'est pourquoi, lors d'une exploration pure (A/B testing conceptuel), il faut lui interdire explicitement d'écrire !

---

# Les 5 points les plus importants

1. `/advisor` permet d'obtenir un conseil stratégique d'un autre modèle au sein de la même conversation, sans lui donner les droits d'écriture.
2. Le conseiller lit tout votre historique, il peut donc souffrir du même biais de cadrage que votre agent principal.
3. `/fork` clone intégralement l'état actuel de votre agent dans une session d'arrière-plan indépendante.
4. Contrairement à `/subtask`, le résultat d'un `/fork` ne remonte jamais automatiquement dans la session parente ; la synthèse reste à la charge de l'humain.
5. Les sessions *forkées* peuvent s'isoler automatiquement dans des *worktrees* si elles commencent à coder. Pour de la pure R&D, imposez-leur de rester en lecture seule.

---

# Carte mentale

```text
/advisor vs /fork
├── /advisor (Consultant interne)
│   ├── Modèle d'arbitrage (ex: Opus)
│   ├── Pas d'accès en écriture
│   └── Limite : Biais de cadrage (lit tout l'historique)
└── /fork (Clonage asynchrone)
    ├── Hérite de tout l'historique
    ├── Ne réinjecte PAS son rapport (≠ /subtask)
    └── S'isole en worktree si écriture
```

---

# Mini fiche de révision

```text
/advisor = Le modèle actuel demande conseil à un modèle tiers (lecture seule, même conversation).
/advisor off = Désactive le conseiller pour éviter la double facturation.
/fork = Duplique le contexte dans un agent d'arrière-plan.
Différence clé : /subtask vous rend un rapport automatiquement, /fork travaille en silence dans `agent view`.
```

> **Phrase à retenir** : Utilisez `/advisor` pour éviter de coder la mauvaise solution, et `/fork` pour coder les deux solutions en parallèle et garder la meilleure.
