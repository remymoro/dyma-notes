# Les commandes de cette leçon

Cette leçon utilise les commandes suivantes : `/release-notes`, `/upgrade`, `/privacy-settings`, `/passes`, `/stickers`, `/feedback`, `/bug` et `/logout`.

- `/release-notes` permet de consulter les notes de version depuis une session Claude Code.
- `/upgrade` ouvre la page permettant de passer à un plan supérieur.
- `/privacy-settings` permet d’afficher et de modifier les réglages de confidentialité disponibles pour le compte.
- `/passes` permet de partager une semaine gratuite de Claude Code si le compte est éligible.
- `/stickers` permet de commander des stickers Claude Code.
- `/feedback` permet d’envoyer un retour produit, de signaler un bug ou de partager le contexte d’une conversation. `/bug` est son alias.
- `/logout` permet de se déconnecter du compte Anthropic. Cette commande ne sert pas à quitter simplement le CLI : pour cela, vous avez déjà vu `/exit` et `/quit`.

## Revenir au projet du chapitre

Revenez dans le dossier du mini-projet.

```bash
cd convertisseur-temperature
```

Vérifiez l’état du dépôt.

```bash
git status
```

Si vous avez conservé la modification de la leçon précédente, le dépôt doit être soit propre après commit, soit contenir uniquement le changement attendu dans `src/main.js`. Ne commencez pas cette leçon avec un état inconnu.

Vous pouvez relancer les tests pour repartir d’un état vérifié.

```bash
npm test
```

Ouvrez ensuite Claude Code depuis la racine du projet.

```bash
claude
```

Dans cette leçon, les commandes principales ne vont pas modifier le code métier. Elles concernent la veille, le compte, le feedback produit et la standardisation des workflows.

## Consulter les nouveautés avec /release-notes

Claude Code évolue rapidement. Une commande disponible aujourd’hui peut être enrichie demain, et une bonne pratique peut changer après l’ajout d’un nouveau mode, d’une nouvelle intégration ou d’une nouvelle commande. La commande `/release-notes` sert à consulter les notes de version directement depuis la session.

```bash
/release-notes
```

Cette commande ouvre un sélecteur de versions ou une vue des notes disponibles. Elle permet de voir les ajouts, les corrections, les changements de comportement et les nouvelles capacités.

Après avoir ouvert les notes, vous pouvez demander à Claude de vous aider à les interpréter pour le projet courant.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande d'interprétation des notes de version :**

*« Lis les notes de version visibles et résume uniquement ce qui change notre usage quotidien.*

*Classe les éléments en trois catégories :*
*1. à utiliser tout de suite ;*
*2. à tester plus tard ;*
*3. à ignorer pour ce mini-projet.*

*Ne modifie aucun fichier. »*

</div>

Cette demande transforme la veille en décision pratique. Vous ne cherchez pas à mémoriser toutes les nouveautés. Vous cherchez à savoir si une nouveauté change votre workflow réel.

## Installer une routine de veille

La veille ne doit pas être faite une seule fois. Claude Code change assez souvent pour justifier une routine courte. Avant de commencer une nouvelle série de sessions, vous pouvez vérifier la version installée et consulter les notes récentes.

```bash
claude --version
```

Dans la session interactive, vous pouvez ensuite ouvrir les notes.

```bash
/release-notes
```

Une bonne routine reste courte.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple de routine courte :**

*« À partir des notes de version récentes, donne-moi seulement :*
*1. les nouvelles commandes utiles pour un premier workflow ;*
*2. les changements qui peuvent affecter les permissions ;*
*3. les changements liés aux sessions distantes ;*
*4. les nouveautés que je peux ignorer pour ce projet. »*

</div>

Cette routine évite deux erreurs. La première erreur consiste à utiliser Claude Code comme un outil figé. La deuxième consiste à lire toutes les nouveautés sans les relier à votre usage réel. Une bonne veille doit produire une décision : utiliser, tester plus tard ou ignorer.

## Gérer le plan avec /upgrade

La commande `/upgrade` ouvre la page permettant de passer à un plan supérieur lorsque cette commande est disponible pour votre compte.

```bash
/upgrade
```

Cette commande n’a pas de rapport direct avec le dépôt. Elle ne lit pas le code, ne modifie pas les fichiers et ne lance pas de test. Elle appartient à la gestion du compte et du plan.

Dans une formation ou une équipe, il faut séparer clairement les commandes de développement et les commandes de compte. `/upgrade` peut être utile si vous atteignez une limite ou si certaines capacités ne sont pas disponibles, mais elle ne doit pas être mélangée avec une demande de correction de code.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Éviter de confondre un problème de code avec un problème de plan :**

*« Avant de parler d’upgrade, résume ce qui bloque réellement notre tâche en cours.*

*Réponds avec :*
*1. limite de plan ;*
*2. problème d’installation ;*
*3. problème de configuration ;*
*4. problème de prompt ;*
*5. problème du projet lui-même.*

*Ne propose pas d’upgrade si le problème vient du projet ou de la demande. »*

</div>

Cette demande évite une confusion fréquente : tout problème de session n’est pas un problème de plan. Si `/doctor` signale un problème de configuration, il faut d’abord corriger la configuration. Si le prompt est trop vague, il faut d’abord clarifier la demande. Si les tests échouent déjà avant Claude, il faut d’abord comprendre l’état du projet.

## Vérifier les réglages de confidentialité avec /privacy-settings

La commande `/privacy-settings` permet d’afficher et de modifier les réglages de confidentialité disponibles pour le compte.

```bash
/privacy-settings
```

Cette commande est particulièrement importante avant d’utiliser Claude Code sur un dépôt réel, un dépôt professionnel ou un projet contenant du code sensible. Le mini-projet `convertisseur-temperature` ne contient rien de confidentiel, mais le réflexe doit être installé dès maintenant.

Avant de travailler sur un dépôt sérieux, posez-vous au moins ces questions :

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Questions à vérifier avant un vrai projet :**

*1. Est-ce que le dépôt contient du code privé ?*
*2. Est-ce que le dépôt contient des secrets ?*
*3. Est-ce que des fichiers de configuration exposent des clés API ?*
*4. Est-ce que le projet appartient à une entreprise qui impose des règles ?*
*5. Est-ce que le compte utilisé correspond au bon cadre (personnel ou pro) ?*
*6. Est-ce que les réglages de confidentialité sont configurés pour ce cadre ?*

</div>

`/privacy-settings` ne remplace pas une politique interne. La commande vous donne accès aux réglages disponibles dans Claude Code, mais vous devez aussi respecter les règles de votre organisation, les contraintes contractuelles et les bonnes pratiques de sécurité.

## Utiliser /passes si le compte est éligible

La commande `/passes` permet de partager une semaine gratuite de Claude Code avec d’autres personnes lorsque le compte est éligible.

```bash
/passes
```

Cette commande n’a pas d’effet sur le projet. Elle sert à la découverte et au partage d’accès. Si elle n’apparaît pas dans votre session, cela peut simplement signifier que votre compte n’est pas éligible ou que la commande n’est pas disponible dans votre contexte.

Dans une équipe, `/passes` peut être utile pour faire tester Claude Code à un collègue sur un projet non sensible. Mais cela ne remplace pas une vraie stratégie d’adoption : règles de confidentialité, choix des dépôts autorisés, bonnes pratiques de prompts, lecture des diffs et validation humaine.

## Commander des stickers avec /stickers

La commande `/stickers` permet de commander des stickers Claude Code.

```bash
/stickers
```

Cette commande est périphérique. Elle ne concerne ni le code, ni le compte de production, ni la vérification. Il faut donc la présenter pour être complet, mais ne pas lui donner le même poids que `/doctor`, `/status`, `/release-notes`, `/feedback` ou les commandes de session.

La bonne classification est simple :

**Commandes de travail :**
- `/status`
- `/doctor`
- `/help`
- `/copy`
- `/export`
- `/release-notes`

**Commandes de surfaces :**
- `/ide`
- `/desktop`
- `/mobile`
- `/chrome`
- `/remote-control`
- `/remote-env`

**Commandes de compte ou périphériques :**
- `/upgrade`
- `/privacy-settings`
- `/passes`
- `/stickers`
- `/logout`
- `/feedback`

Cette classification aide à comprendre le CLI comme un ensemble de familles de commandes, et pas comme une liste plate à mémoriser.

## Signaler un problème avec /feedback

La commande `/feedback` permet d’envoyer un retour produit, de signaler un bug ou de partager le contexte de la conversation.

Vous pouvez aussi écrire directement le retour après la commande.

```bash
/feedback
```

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple d'utilisation de /feedback :**

*« /feedback La commande /doctor signale un problème de permission qui n'existe pas. »*

</div>

`/feedback` doit être utilisé pour un problème produit, une friction du CLI, un comportement inattendu ou un retour sur l’expérience. Il ne doit pas être utilisé pour demander à Claude de corriger votre code. Si le problème vient du projet, formulez une demande normale dans la conversation.

## Utiliser l’alias /bug

`/bug` est l’alias de `/feedback`. Il sert au même usage, mais il rend l’intention plus directe quand vous signalez un problème.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Exemple d'utilisation de /bug :**

*« /bug La commande /chrome se configure correctement, mais le navigateur ne s'ouvre pas. »*

</div>

Un bon rapport de bug doit être court, concret et reproductible. Il doit contenir le contexte, l’action réalisée, le résultat attendu et le résultat observé.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Structure d'un bon rapport de bug :**

*« /bug*
*Contexte : projet JavaScript minimal lancé avec npm run dev.*
*Action : j’utilise /chrome pour vérifier http://localhost:5173.*
*Résultat attendu : Claude observe la page et teste le scénario.*
*Résultat observé : la session indique une erreur de port.*
*Version : voir /status. »*

</div>

Cette forme est plus utile qu’un message vague comme “ça ne marche pas”. Plus le signalement est précis, plus il peut être exploité.

## Se déconnecter avec /logout

La commande `/logout` permet de se déconnecter du compte Anthropic.

```bash
/logout
```

Cette commande ne doit pas être utilisée à la place de `/exit`. Si vous voulez seulement fermer le CLI sur votre machine personnelle, utilisez `/exit` ou `/quit`. Si vous travaillez sur une machine partagée, temporaire, empruntée ou mal contrôlée, `/logout` devient pertinent.

La différence est simple :

```text
/exit
# Ferme la session CLI ou détache la session selon le paramètre.

/quit
# Alias de /exit.

/logout
# Déconnecte le compte Anthropic.
```

Avant de lancer `/logout`, vérifiez que vous n’avez pas besoin de continuer la session, que les changements du dépôt sont compris et que vous avez exporté ce que vous voulez conserver.

<div style="background-color: #f3f4f6; border-radius: 12px; padding: 20px; margin: 15px 0;">

**Demande avant de se déconnecter :**

*« Avant de me déconnecter, résume l’état final de cette session.*

*Format :*
*1. projet ouvert ;*
*2. fichiers modifiés ;*
*3. tests exécutés ;*
*4. résultat connu ;*
*5. éléments exportés ou copiés ;*
*6. prochaine action recommandée. »*

</div>

Ensuite seulement, utilisez la commande de déconnexion si le contexte le justifie.
