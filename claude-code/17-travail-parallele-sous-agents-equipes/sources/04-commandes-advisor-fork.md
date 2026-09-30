Comprendre les deux commandes
`/advisor` et `/fork` permettent d'obtenir un autre point de vue.
- `/advisor` : Le modèle principal consulte ponctuellement un second modèle. Le conseil revient au modèle principal. (1 conversation, 1 exécuteur, 1 modèle consulté).
- `/fork` : La conversation est copiée dans une nouvelle session d'arrière-plan. Deux conversations indépendantes continuent à partir du même historique.

Activer /advisor
La commande sans argument ouvre le sélecteur. On peut aussi utiliser `/advisor opus`, `/advisor sonnet`, `off`.
*(Fable n'est pas proposé. L'outil fonctionne uniquement avec une connexion directe Anthropic, pas Bedrock/GCP).*

Le rôle du conseiller
Le modèle conseiller reçoit automatiquement le transcript complet (demande, prompt système, historique, outils, résultats).
Il ne peut **pas** : lire de nouveau fichier, exécuter une commande, modifier le projet.
Il produit une recommandation stratégique, mais l'exécuteur garde le contrôle.

Savoir quand utiliser /advisor
Utile aux moments où une mauvaise décision contaminerait toute la suite (choix d'architecture, approche qui ne converge pas).
Moins utile pour : question simple, tâche mécanique, ou quand la tâche exige déjà le modèle le plus puissant (chaque consultation coûte une inférence supplémentaire).

Tester /advisor sur le mini-projet
> `/advisor opus`
> Nous voulons rendre les messages... Analyse d'abord... Compare ensuite deux architectures : 1. paramètre local 2. catalogue. Évalue simplicité, couplage... Ne modifie aucun fichier.
À la fin, désactivez avec : `/advisor off`.

Limites de `/advisor` :
Le conseiller voit le même historique que l'exécuteur, il peut donc subir le même **biais de cadrage**. Ce n'est pas un contexte "frais". S'il faut un contexte frais pour relire, utilisez un sous-agent normal.

Copier la conversation avec /fork
> `/fork <mission>`
Copie tout l'historique actuel dans une nouvelle session d'arrière-plan. La session principale reste ouverte.
Le fork hérite de : conversation complète, instructions système, modèle, outils, contexte projet.
Les deux sessions ne se synchronisent plus.

Comparer les commandes proches
| Commande | Destination | Retour du résultat |
|---|---|---|
| `/fork` | Nouvelle session dans `agent view`. | Consulté dans la nouvelle session. |
| `/branch` | Nouvelle branche de conv dans laquelle vous basculez. | Vous continuez directement dans la copie. |
| `/subtask` | Sous-agent forké en arrière-plan. | Le rapport revient dans la conversation actuelle. |
| `/btw` | Question éphémère sans outil. | Réponse affichée sans entrer dans l'historique. |

Explorer deux approches en parallèle
- `/fork Explore uniquement l'approche avec un paramètre local... Ne modifie aucun fichier.`
- `/fork Explore uniquement l'approche avec catalogue... Ne modifie aucun fichier.`
Dans la session principale, on prépare une grille de comparaison.
Dans `agent view` (`claude agents`), on lit les résultats des forks.
> Contrairement à `/subtask`, les rapports des forks ne sont pas automatiquement injectés dans la conversation d'origine. Vous restez responsable de la comparaison.

Modifications de fichiers
Un fork est une session d'arrière-plan. S'il commence à écrire, l'isolation automatique de `agent view` peut le déplacer dans un `worktree`. Pour de l'exploration d'architecture, il faut demander explicitement de rester en lecture seule pour éviter des implémentations concurrentes.
