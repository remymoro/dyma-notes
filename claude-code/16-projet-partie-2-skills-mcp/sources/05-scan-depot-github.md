Interdire la production pendant la découverte

Le prompt
Le but est de créer une issue pour une nouvelle fonctionnalité (scan d'un dépôt GitHub distant).
> N'écris rien pour le moment, ne crée pas l'issue. Pour l'instant on est sur une phase de découverte. S'il y a des ambiguïtés ou des choses incomplètes, il faudra que tu me poses des questions pour bien cerner l'objectif.
> Le besoin : auditer un dépôt distant via `claudoscope scan owner/repo`.
> Hors périmètre : dépôts privés, choix de branche, récursif.

Pourquoi cette interdiction change la réponse ?
Sans la phrase qui interdit d'écrire, une demande détaillée déclenche une production immédiate. Les zones floues seraient comblées par des choix invisibles.
Avec elle, la session explore le code et pose des questions :
> Phase de découverte, je ne crée rien pour l'instant. Je regarde d'abord la structure actuelle.

Les questions de découverte
- Comment distinguer distant d'un chemin local ? (`owner/repo` est valide localement) -> Décision : Reconnaître une URL GitHub.
- Quel mécanisme de récupération ? -> Décision : API GitHub avec `fetch` natif.
- Quel chemin afficher dans les findings ? -> `owner/repo/CLAUDE.md`.

La question qui corrige la conception
La première question signale une erreur (ambiguïté de `owner/repo`). Une URL `https://github.com/...` lève l'ambiguïté à coût nul avant l'écriture.

Le choix de l'API plutôt que du contenu brut
L'API permet de distinguer un dépôt inaccessible d'un fichier absent, ce qui est nécessaire car les deux ont des codes de sortie différents.

Le contour proposé
- Détection : si URL, mode distant. Sinon, mode local.
- Cible : uniquement `CLAUDE.md` à la racine.
- Traitement : identique au local (contenu passé en mémoire).

Le tableau des cas d'erreur
Attache un code de sortie à chaque situation :
- Dépôt inexistant ou privé : sortie 2.
- Fichier absent : sortie 0 (aligné sur local).
- Erreur réseau : sortie 2.
*Rappel : la sortie 1 est réservée aux findings.*

Les contraintes d'architecture
> Le cœur reste intouché : aucune entrée-sortie ni appel réseau dans le moteur. La frontière ne bouge pas.

Créer l'issue après validation
Le contour est validé, l'issue est créée.

Le plan dans une session neuve
> Récupère l'issue numéro 7 et prépare-moi un plan d'implémentation. S'il y a des ambiguïtés, pose des questions. N'invente rien.

Une contradiction détectée dans l'issue
La session trouve une contradiction : l'issue dit "sortie silencieuse" ET "aligné sur le comportement local", or le local n'est pas silencieux (il affiche "aucun fichier traité"). Décision retenue : s'aligner sur le local (afficher le message). Une issue peut paraître précise mais contredire le produit réel.

La décision sur les tests
Décision : simuler l'appel réseau (`substitut`).
> Conséquence assumée : pas de cas distant dans les tests de bout en bout (e2e).
Cela délimite ce que les tests couvrent et justifie l'essai manuel à la fin.

Le principe directeur du plan
La lecture du code montre que le moteur n'a pas besoin de changer. Seule la logique de récupération change.

Le résultat livré
- Nouveau module distant (API).
- Module de scan modifié.
- 27 nouveaux cas de tests (avec requête simulée).

La vérification
Les tests E2E locaux passent (preuve que la voie locale n'est pas déviée). S'ajoute l'essai manuel contre l'API réelle (car la simulation ne le couvrait pas).

Point de vigilance sur la skill
Au démarrage, la session annonce vouloir charger la procédure pour les nouvelles règles (la skill `new-rule`), alors qu'on fait une feature CLI.
C'est le symptôme inverse de la leçon précédente : on a trop élargi la description de la skill.
> Le bon réglage nomme le domaine, pas seulement l'action. Ici : une règle du catalogue, et non toute demande d'implémentation d'issue.

Erreurs à éviter
- Laisser la session produire pendant la découverte.
- Figer une syntaxe d'usage sans vérifier son ambiguïté (`owner/repo`).
- Choisir un mécanisme technique (fetch URL brut) avant de vérifier le comportement attendu (distinguer repo privé vs fichier absent).
- Réutiliser la sortie 1 pour une erreur réseau.
- Ne pas signaler ce que les tests simulent.
