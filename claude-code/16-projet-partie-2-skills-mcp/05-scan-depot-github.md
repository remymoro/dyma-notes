---
cours: Claude Code
chapitre: 16-projet-partie-2-skills-mcp
leçon: 05-scan-depot-github
date: 2026-09-30
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Pourquoi interdire la production ("N'écris rien") au début du prompt ?** | Sans cette consigne, Claude cherche à satisfaire la requête en comblant silencieusement les zones de flou. L'interdiction de produire force l'agent à entrer dans une "phase de découverte" où il explore le code et pose des questions cruciales (ex: lever l'ambiguïté sur la syntaxe). |
| **Pourquoi préférer une URL `https://github...` plutôt que le format `owner/repo` ?** | Le format `owner/repo` est ambigu car il constitue également un chemin local de dossier valide. Utiliser une URL lève immédiatement toute confusion. |
| **Pourquoi utiliser l'API GitHub plutôt que de récupérer le contenu "brut" du fichier ?** | Récupérer le contenu brut via une simple requête HTTP ne permet pas de différencier un *dépôt inexistant/privé* d'un *fichier CLAUDE.md manquant*. L'API GitHub fournit des métadonnées permettant de distinguer ces deux cas (qui ont des codes de sortie différents). |
| **Pourquoi est-il dangereux de réutiliser le code d'erreur `1` pour un problème réseau ?** | Dans le monde du linting, la sortie `1` est conventionnellement réservée pour signaler la présence de *findings* (des erreurs dans le code analysé). Une erreur système (réseau, crash) doit utiliser le code `2` (ou supérieur) pour ne pas rendre l'intégration continue inexploitable. |
| **Que signifie l'avertissement "Ne pas signaler ce que les tests ne couvrent pas" ?** | Dans notre implémentation, nous mockons (simulons) l'API GitHub pour les tests automatisés. Les tests E2E ne testeront donc jamais le "vrai réseau". Il est vital de l'écrire explicitement dans l'issue pour forcer l'ajout d'une étape de **validation manuelle**. |

## Synthèse
Cette dernière leçon du projet illustre comment concevoir une fonctionnalité de A à Z (un scan distant via GitHub API) en maîtrisant les ardeurs de l'agent. Le prompt initial pose un cadre strict : "Phase de découverte, ne produis rien, pose-moi des questions". Cette retenue volontaire permet de révéler des failles de conception très en amont, comme l'ambiguïté de la syntaxe `owner/repo` ou le besoin d'utiliser l'API plutôt qu'une URL brute pour gérer correctement les codes d'erreur.
Par la suite, lorsque l'issue est soumise à une session neuve, on demande à nouveau un plan ("N'invente rien"). Claude détecte alors de lui-même des contradictions dans nos spécifications. Enfin, la leçon conclut sur une mise en garde concernant la portée des `skills` : une description de skill trop large (modifiée à la leçon 4) peut se déclencher inopinément. Il faut toujours cibler un domaine précis et non une action globale.

## Glossaire
- **Phase de découverte** : Étape initiale d'ingénierie logicielle avec Claude où on lui interdit d'écrire du code ou des livrables afin de le forcer à analyser l'existant et à poser des questions d'architecture.
- **Mock / Substitut** : Technique de test unitaire consistant à remplacer un appel système réel (ici, la requête réseau vers GitHub) par une fausse fonction qui renvoie un résultat prédictible.
- **Codes de sortie (Exit codes)** : En CLI, `0` = succès, `1` = violation de règle (findings), `2` (ou +) = erreur d'exécution grave (crash, erreur réseau).

## Questions d'auto-évaluation
1. Quel impact a eu l'ajout de la phrase "N'écris rien pour le moment" sur la réponse de Claude ?
2. Quelle contradiction Claude a-t-il détecté de lui-même en lisant l'issue préparée pour cette fonctionnalité ?
3. Pourquoi la *skill* `new-rule` a-t-elle failli se déclencher toute seule au début de l'implémentation alors qu'on ne développait pas une règle ?
4. Si les tests unitaires et E2E simulent le réseau, comment valide-t-on que la récupération distante fonctionne réellement ?

# Nouvelle fonctionnalité : scan d'un dépôt GitHub

**Durée : 15 minutes**

## Objectif de la leçon
Gérer le cycle de vie de la création d'une fonctionnalité complexe (appel API réseau), en utilisant le mode "découverte" de Claude pour lever les ambiguïtés techniques, structurer proprement les tests (Mocks), et régler la précision du déclenchement des Skills.

---

# 1. Interdire la production pour forcer la réflexion

Si vous donnez une grosse description de feature à Claude, il l'implémentera immédiatement, prenant des décisions d'architecture silencieuses. Forcez-le à réfléchir avec ce prompt :

> **Prompt :**
> "Le but de cette session va être de créer une issue sur le dépôt. [...]
> **N'écris rien pour le moment, ne crée pas l'issue.** Pour l'instant on est sur une phase de découverte. S'il y a des ambiguïtés [...], pose-moi des questions."

Grâce à ce garde-fou, Claude explore d'abord le code et pose des questions fondamentales.
**Exemple de retour sur investissement :** Le prompt demandait d'utiliser la syntaxe `scan owner/repo`. Claude signale que c'est indiscernable d'un chemin de fichier local. La solution (utiliser une URL `https://...`) est corrigée à coût nul.

---

# 2. Séparer Mécanisme et Comportement

Le choix d'utiliser l'API native GitHub (`fetch`) n'est pas une simple préférence technique, c'est une contrainte de **comportement attendu**.

| Scénario distant | Code retour attendu | Raison |
|---|---|---|
| Fichier inexistant | **Sortie 0** | Comportement identique au local ("Fichier manquant, rien à linter, tout va bien"). |
| Dépôt inexistant / privé | **Sortie 2** | Le contexte est injoignable, c'est une erreur d'exécution. |

*Récupérer le fichier brut (Raw URL) ne permettait pas de distinguer ces deux cas. L'API, si.*
*(Note : La sortie 1 est strictement réservée à la présence de findings).*

---

# 3. La détection des contradictions

Lorsque vous demandez un plan dans la session d'exécution (`Récupère l'issue 7 et prépare le plan`), Claude peut sauver votre architecture :

> **Contradiction détectée par Claude :**
> L'issue dit : *"sortie silencieuse"* ET *"aligné sur le comportement local"*.
> Or, le comportement local actuel n'est **pas** silencieux (il affiche "Aucun fichier traité").

Décision : On s'aligne sur le local et on affiche le message. Une issue peut être précise en apparence mais contredire la base de code réelle. Le mode plan permet de l'identifier avant le codage.

---

# 4. Gérer les tests et leurs limites

On impose une architecture où le cœur du moteur de lint reste *pur* (aucune I/O, aucun réseau). Toute la plomberie réseau vit dans la CLI.
Dans les tests unitaires, l'appel réseau est **substitué** (Mock).

> **Conséquence assumée à écrire dans l'issue :**
> Il n'y aura aucun cas distant dans les tests "de bout en bout" (End-to-End), car un test E2E exécute le vrai binaire qui chercherait à requêter le vrai réseau (limites d'API, instabilité).

Cela justifie l'ajout d'une **étape manuelle** à la fin du plan de l'agent :
`Essai manuel contre l'API réelle sur 3 dépôts publics pour valider l'intégration.`

---

# 5. Point de vigilance : le déréglage de la Skill

Au lancement du plan, la session a annoncé : *"Je vais charger la skill `new-rule`"*.
Or, nous développons une feature CLI, pas une règle de lint !

**Que s'est-il passé ?**
Lors de la leçon précédente, nous avions élargi la description de la skill pour qu'elle s'active lors de la création d'issue, mais nous avons été *trop vagues*.
> *Trop étroit* : La skill reste muette sur des cas qu'elle couvre.
> *Trop large* : La skill s'invite sur des travaux qui ne sont pas les siens.

**Solution :** Le réglage d'une skill doit nommer **le domaine**, pas seulement l'action.
*(Ex: "Création d'issue d'une règle du catalogue", et non "Toute demande d'implémentation issue d'une issue").*

---

# Les 5 erreurs fatales évitées dans cette leçon

1. **Laisser produire pendant la découverte :** Vous perdez la chance de voir l'IA poser les bonnes questions conceptuelles.
2. **Figer une syntaxe d'usage sans test d'ambiguïté :** `owner/repo` entre en collision avec un chemin de dossier local.
3. **Choisir la technique avant le comportement :** Choisir l'URL brute empêchait de distinguer "Dépôt privé" de "Fichier absent".
4. **Réutiliser un mauvais code de sortie :** Renvoyer `exit 1` pour un crash réseau détruit l'utilité de la CI.
5. **Croire une issue cohérente juste parce qu'elle est précise :** Ne dispense pas l'agent de relire le code source pendant la phase de plan.

---

# Carte mentale

```text
Feature de Scan Distant
├── 1. Cadrage du besoin
│   ├── "Phase découverte, n'écris rien"
│   ├── Clarification de la syntaxe (URL)
│   └── Codes d'erreur (0, 1, 2)
├── 2. Architecture et Tests
│   ├── Cœur intouché (Frontière saine)
│   ├── Mocks réseau (Tests rapides)
│   └── Essai Manuel (Véritable E2E)
└── 3. Détection et Diagnostic
    ├── Issue vs Code (Contradiction local/distant)
    └── Faux Positif de Skill (Description trop large)
```

---

# Mini fiche de révision

```text
Prompt initial parfait : "Ne crée rien, pose des questions de découverte".
Le format URL lève l'ambiguïté des chemins locaux.
Codes de sortie : 0 = succès (même si fichier absent), 1 = erreur de lint (findings), 2 = erreur système (réseau/auth).
Tests réseau : Simulation (mock) dans la suite automatisée + Essai manuel final annoncé.
Skill déclenchée à tort : La description (le déclencheur) était trop générique. Toujours cibler un domaine précis.
```

> **Phrase à retenir** : Choisir un mécanisme technique avant de définir le comportement attendu rend souvent ce comportement impossible à implémenter.
