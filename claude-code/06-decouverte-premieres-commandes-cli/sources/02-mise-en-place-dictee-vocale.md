# Utiliser la dictée vocale pour écrire de meilleurs prompts

Dans cette leçon, vous allez utiliser la dictée vocale dans Claude Code. Jusqu'ici, vous avez configuré le terminal, le rendu plein écran, la barre de statut, les couleurs de session, les raccourcis clavier et le mode d'édition. La dictée vocale complète cette configuration : elle permet de produire des prompts plus longs, plus naturels et plus riches en contexte.

L'intérêt de la voix n'est pas de remplacer l'écriture. L'intérêt est de donner plus facilement du contexte. Quand vous parlez, vous pouvez expliquer plus naturellement un bug, une règle métier, une contrainte historique, un cas limite ou une intuition technique. Un prompt vocal bien relu peut donc être plus utile qu'un prompt tapé trop vite.

La commande centrale de cette leçon est `/voice`. Elle permet d'activer ou de configurer la dictée vocale dans le CLI. Vous allez voir les modes `hold`, `tap` et `off`, le réglage de la langue, le remapping du raccourci vocal, les limites de confidentialité, les environnements non compatibles et les bons usages pour produire des prompts détaillés.

## Identifier les commandes utilisées dans la leçon

Cette leçon utilise principalement les commandes suivantes :

`/voice` active ou désactive la dictée vocale selon l'état courant. `/voice hold` active le mode maintien. `/voice tap` active le mode appui. `/voice off` désactive la dictée.

`/config` sert notamment à régler la langue. `/keybindings` sert à modifier le raccourci de dictée dans `~/.claude/keybindings.json`, en utilisant l'action `voice:pushToTalk`. Enfin, `/doctor` permet de vérifier la configuration après modification.

## Comprendre le rôle de /voice

`/voice` permet de parler au lieu de tout taper au clavier. Votre voix est transcrite dans l'invite de Claude Code. Vous pouvez donc mélanger saisie clavier et dictée dans le même message.

```text
/voice
/voice hold
/voice tap
/voice off
/config
/keybindings
/doctor
```

La dictée ne modifie pas directement le projet. Elle produit du texte dans votre prompt. Vous devez ensuite relire ce texte, corriger les noms de fichiers, vérifier les contraintes, puis envoyer le message quand il est correct.

La dictée vocale est utile pour dicter un prompt long, expliquer un bug, décrire un flux métier, donner des contraintes, raconter un historique technique, préparer une analyse de codebase ou compléter un prompt déjà écrit au clavier.

Elle ne remplace jamais la validation. Même si le prompt est dicté, vous devez toujours regarder le diff, demander une preuve d'exécution et vérifier les résultats avant de valider une modification.

## Activer la dictée vocale

Pour activer la dictée vocale dans Claude Code, lancez la commande suivante :

```text
/voice
```

Lors de la première activation, Claude Code peut vérifier l'accès au microphone. Sur certains systèmes, notamment macOS, le terminal peut demander une autorisation d'accès au microphone. Vous devez accepter cette autorisation si vous voulez utiliser la dictée.

Après activation, le pied de page peut afficher une indication du type suivant :

```text
hold Space to speak
```

Cette indication signifie que la touche de dictée est active. Par défaut, la touche utilisée est souvent `Space`, mais elle peut être modifiée avec `/keybindings`.

## Choisir le bon mode de dictée

### Utiliser le mode maintien avec /voice hold

Le mode maintien est le mode le plus contrôlé. Vous maintenez la touche de dictée pendant que vous parlez, puis vous relâchez pour insérer la transcription dans l'invite.

```text
/voice hold
```

En mode maintien, le fonctionnement est simple : vous maintenez la touche de dictée, vous parlez, vous relâchez la touche, vous relisez la transcription, vous corrigez si nécessaire, puis vous appuyez sur Entrée pour envoyer.

Ce mode est adapté aux tâches sensibles, car il garde une étape de relecture avant l'envoi. Pour les premières sessions, utilisez ce mode.

Exemple de prompt dicté en mode maintien :

```text
Ne modifie aucun fichier.
Explique le projet convertisseur-temperature comme si je le découvrais pour la première fois.
Fais une réponse courte :
1. rôle du projet ;
2. fichiers principaux ;
3. commande de test ;
4. une limite actuelle.
```

Après la dictée, relisez la transcription. Vérifiez surtout les noms de fichiers comme `src/main.js`, `src/conversion.js`, `package.json` ou `README.md`. Ces noms peuvent être mal transcrits si vous parlez vite ou si le bruit ambiant est élevé.

### Utiliser le mode appui avec /voice tap

Le mode appui est plus rapide. Vous appuyez une fois pour commencer l'enregistrement, vous parlez, puis vous appuyez à nouveau pour arrêter. Il n'est pas nécessaire de maintenir la touche.

Ce mode est pratique pour dicter des demandes longues sans garder une touche enfoncée. Il est moins prudent pour les tâches sensibles, car l'envoi peut être plus rapide selon la configuration et le contexte.

Utilisez `/voice tap` lorsque la tâche est en lecture seule, lorsque vous dictez un prompt long, lorsque vous voulez parler sans maintenir une touche et lorsque vous êtes à l'aise avec une relecture rapide.

Pour une première utilisation, testez le mode appui avec une demande qui interdit explicitement les modifications :

```text
/voice tap
```

```text
Ne modifie aucun fichier.
Je veux préparer une future amélioration du mini-projet.
Analyse src/main.js et src/conversion.js.
Dis-moi quels cas limites sont visibles dans l'interface.
Classe-les par priorité.
Ne propose pas encore de correction.
```

### Désactiver la dictée avec /voice off

Quand vous n'utilisez plus la dictée, désactivez-la avec la commande suivante :

```text
/voice off
```

C'est utile si vous partagez votre écran, si vous êtes dans un environnement bruyant, si vous travaillez sur un projet sensible ou si vous voulez éviter un déclenchement accidentel.

Utilisez `/voice off` lorsque vous êtes en réunion, lorsque vous travaillez dans un espace bruyant, lorsque vous ne voulez pas que `Space` déclenche la voix ou lorsque la session de dictée est terminée.

### Comparer les modes hold, tap et off

Les trois modes répondent à des besoins différents. Le mode `hold` est le plus contrôlé. Le mode `tap` est le plus confortable pour les prompts longs. Le mode `off` est le plus sûr quand la dictée n'est plus nécessaire.

Pour les premières sessions, commencez avec `/voice hold`. Passez à `/voice tap` seulement quand vous avez confiance dans votre environnement, votre microphone, la langue de dictée et votre méthode de relecture.

```text
/voice hold
# Meilleur choix pour garder une étape de relecture avant envoi.

/voice tap
# Meilleur choix pour dicter longtemps sans maintenir une touche.

/voice off
# Meilleur choix quand la voix n'est plus nécessaire.
```

## Configurer la langue et les préférences vocales

### Régler la langue de dictée

La dictée utilise le réglage de langue de Claude Code. Si vous dictez en français, vérifiez que la langue est correctement configurée.

Dans les paramètres, cherchez le réglage de langue et choisissez `fr` ou `français` selon l'interface disponible.

```text
/config
```

Vous pouvez aussi définir la langue dans vos settings personnels :

```json
{
  "language": "fr"
}
```

Cette configuration est généralement personnelle. Elle doit aller dans `~/.claude/settings.json` ou dans `.claude/settings.local.json`, pas dans `.claude/settings.json`, sauf si toute l'équipe travaille dans la même langue.

Si la langue n'est pas prise en charge ou si elle est mal configurée, la dictée peut revenir à l'anglais. Les réponses écrites de Claude peuvent rester dans une autre langue, mais la transcription vocale risque d'être moins fiable.

### Configurer la voix dans les settings

Vous pouvez activer la voix directement dans vos settings personnels :

```json
{
  "voice": {
    "enabled": true,
    "mode": "hold"
  }
}
```

Pour utiliser le mode appui par défaut :

```json
{
  "voice": {
    "enabled": true,
    "mode": "tap"
  }
}
```

Pour désactiver la voix dans les settings :

```json
{
  "voice": {
    "enabled": false
  }
}
```

Gardez ces réglages personnels. Le choix de la voix dépend de votre machine, de votre microphone, de votre environnement sonore et de vos habitudes.

### Éviter l'envoi automatique sur les tâches sensibles

La configuration vocale peut inclure une option d'envoi automatique. Cette option peut être pratique pour des demandes simples, mais elle est risquée si vous dictez des instructions qui autorisent des modifications.

```json
{
  "voice": {
    "enabled": true,
    "mode": "hold",
    "autoSubmit": false
  }
}
```

Pour les sessions de développement, gardez `autoSubmit` désactivé au début. Relire avant envoi est une sécurité simple.

La règle recommandée est la suivante : pour une lecture seule, `tap` est possible ; pour une analyse longue, `tap` est possible ; pour une modification de code, `hold` est préférable ; pour une tâche sensible, utilisez `hold` avec relecture obligatoire ; pour des secrets ou des données confidentielles, ne dictez pas.

## Remapper la touche de dictée

Par défaut, la dictée utilise souvent `Space` comme touche de push-to-talk. Ce choix peut être pratique, mais il peut aussi gêner la saisie. Vous pouvez remapper l'action `voice:pushToTalk` avec `/keybindings`.

```text
/keybindings
```

Dans `~/.claude/keybindings.json`, ajoutez une liaison dans le contexte `Chat` :

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/fr/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "meta+k": "voice:pushToTalk",
        "space": null
      }
    }
  ]
}
```

Cette configuration utilise `Meta+K` comme touche de dictée et désactive explicitement `Space`. La ligne `"space": null` rend l'intention claire, même si le nouveau raccourci peut déjà remplacer le comportement par défaut selon la version.

### Choisir un raccourci fiable

Un bon raccourci vocal doit être facile à déclencher volontairement, mais difficile à déclencher par accident. Évitez les lettres simples en mode maintien, car elles peuvent apparaître dans l'invite pendant le préchauffage.

Les bons candidats sont par exemple `meta+k`, `ctrl+k ctrl+v` ou `alt+space` si votre terminal transmet correctement cette combinaison.

Évitez les lettres simples comme `v`, `Caps Lock`, les raccourcis déjà utilisés par `tmux`, les raccourcis interceptés par l'IDE et les combinaisons difficiles à taper sur votre clavier.

Après modification, lancez `/doctor` pour vérifier la configuration :

```text
/doctor
```

Si `/doctor` signale un conflit ou une touche non prise en charge, choisissez une autre combinaison.

## Utiliser la voix pour enrichir les prompts

### Donner plus de contexte sur un bug

La voix devient utile quand l'écriture ralentit votre explication. Pour un bug, il est souvent plus facile de raconter ce que vous avez observé que de tout taper.

```text
Ne modifie aucun fichier.
Je vais te donner le contexte d'un bug.
Le projet convertit des températures.
Le problème est que certains comportements de l'interface ne sont pas cohérents.
Je veux que tu reformules le problème, que tu identifies les causes possibles.
Ne propose pas encore de modification.
```

Ce prompt vocal contient un contexte, une observation, une limite et une demande claire. Il reste en lecture seule. C'est un bon type de demande pour tester la dictée sans prendre de risque sur le projet.

### Expliquer une règle métier

La voix est particulièrement utile quand le contexte métier est plus long que le code. Vous pouvez expliquer une règle en langage naturel avant de demander une analyse.

```text
Ne modifie aucun fichier.
Je veux expliquer une règle métier hypothétique pour cette interface.
Si une température est vide, l'interface ne doit pas calculer de résultat.
Elle doit dire clairement à l'utilisateur de saisir une valeur.
Si la valeur est invalide, elle doit dire que la température n'est pas reconnue.
Si la valeur est valide, elle doit conserver le comportement actuel.
À partir de cette règle, indique quels fichiers seraient concernés.
```

Cette demande montre pourquoi la voix est utile : elle permet de donner une règle complète sans la réduire à une demande vague comme « corrige l'entrée vide ». Plus le contexte est clair, moins Claude Code doit deviner.

### Transformer une dictée brute en demande précise

Vous pouvez dicter une première version approximative, puis demander à Claude de la transformer en demande précise.

```text
Ne modifie aucun fichier.
Transforme ce que je viens de dicter en demande précise.
La demande finale doit inclure :
1. fichier ciblé ;
2. problème ;
3. contraintes ;
4. vérification ;
5. définition de terminé ;
6. ce qu'il ne faut pas modifier.
Ne réalise pas la modification.
Rédige seulement la demande finale.
```

Cette méthode est efficace. Vous utilisez la voix pour donner le contexte brut, puis vous demandez à Claude de produire un prompt structuré. Vous pouvez ensuite relire ce prompt avant de l'envoyer dans une prochaine session.

## Sécuriser les prompts dictés

### Relire la transcription avant l'envoi

La relecture est obligatoire avant une tâche qui peut modifier le code. La transcription peut se tromper sur un nom de fichier, une option de commande, une négation ou un mot technique.

Avant l'envoi, relisez les noms de fichiers, les noms de fonctions, les commandes, les négations, les contraintes, l'autorisation ou l'interdiction de modifier, la définition de terminé et la présence éventuelle de secrets.

Une erreur comme « modifie le fichier » au lieu de « ne modifie pas le fichier » change complètement la session. La voix accélère la saisie, mais elle impose une relecture plus attentive.

### Demander une vérification du prompt

Après une dictée longue, vous pouvez demander à Claude de vérifier que votre prompt est clair avant toute action.

```text
Avant de répondre à la demande précédente, vérifie d'abord que tu as bien compris ma demande.
Réponds avec :
1. ce que tu as compris ;
2. les fichiers concernés ;
3. les actions autorisées ;
4. les actions interdites ;
5. la preuve attendue ;
6. les ambiguïtés éventuelles.
Ne modifie aucun fichier tant que je n'ai pas confirmé.
```

Cette technique est utile quand une transcription a pu déformer une contrainte. Elle ajoute une étape de sécurité avant l'exécution.

## Gérer les cas particuliers sous Linux et WSL

Sur Linux, si aucun outil d'enregistrement audio n'est disponible, `/voice` peut afficher une commande d'installation. Selon la distribution, vous devrez installer SoX ou les outils audio nécessaires.

```bash
# Exemple courant sur Debian ou Ubuntu.
sudo apt-get install sox
```

Si vous êtes dans WSL et que l'audio passe par PulseAudio, il peut être nécessaire d'ajouter le backend PulseAudio de SoX.

```bash
# Exemple pour WSL avec PulseAudio.
sudo apt install sox libsox-fmt-pulse
```

Si la capture audio ne fonctionne toujours pas dans WSL, utilisez Claude Code dans Windows natif pour la dictée, ou vérifiez que WSLg est disponible.
