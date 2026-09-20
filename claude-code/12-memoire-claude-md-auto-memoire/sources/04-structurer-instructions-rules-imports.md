Quand un projet grandit, le problème n’est plus seulement de savoir quoi écrire dans CLAUDE.md. Le problème devient : où placer chaque instruction pour qu’elle se charge au bon moment, sans gonfler inutilement le contexte.
Le rôle de CLAUDE.md, son initialisation avec /init et le choix des emplacements de mémoire sont acquis. Reste l’organisation interne des instructions : imports @path, règles modulaires dans .claude/rules/, règles limitées à certains chemins, notes de référence et déplacement des workflows longs vers des skills. L’objectif est de couvrir ces mécanismes sans transformer CLAUDE.md en fichier fourre-tout.
La règle éditoriale est simple. Le fichier principal doit rester court. Les instructions globales vont dans CLAUDE.md. Les instructions spécialisées vont dans .claude/rules/. Les documents longs restent dans des notes ou des fichiers de référence. Les procédures répétées deviennent des skills.

Pourquoi découper les instructions
Réduire le bruit de contexte
Les fichiers de mémoire sont chargés dans la fenêtre de contexte. Plus ils contiennent de texte, plus ils consomment de place avant même que la tâche commence. Des instructions concises sont préférables, et les règles limitées au chemin permettent de charger certaines consignes seulement lorsque Claude travaille avec des fichiers correspondants.
Découper n’a donc pas seulement un intérêt de rangement. C’est une manière de contrôler la surface d’instructions visible par Claude. Une règle de test frontend ne doit pas influencer une tâche backend. Une règle de sécurité API ne doit pas nécessairement se charger pour une correction de documentation.

Limiter les contradictions
Un gros CLAUDE.md tend à accumuler des règles anciennes, des exceptions locales et des consignes redondantes. Des instructions contradictoires peuvent conduire Claude à en choisir une arbitrairement ; il faut donc examiner régulièrement CLAUDE.md, les fichiers imbriqués et .claude/rules/.
Une instruction doit avoir un périmètre. Si elle est vraie partout, elle peut rester dans CLAUDE.md. Si elle est vraie seulement pour une zone, elle doit devenir une règle limitée à cette zone.

Utiliser @path pour organiser, pas pour économiser
Ce que fait un import @path
Un fichier CLAUDE.md peut importer un autre fichier avec la syntaxe @path/to/file. Les fichiers importés sont développés et chargés dans le contexte avec le fichier qui les référence. Les chemins relatifs se résolvent par rapport au fichier qui contient l’import, et non par rapport au répertoire de travail. Les imports peuvent être récursifs, avec une profondeur maximale de quatre sauts.

# Dans CLAUDE.md
@docs/claude/workflow-pr.md
@docs/claude/conventions-tests.md
## Instructions projet
Utilise les conventions importees ci-dessus pour les taches de PR et de test.

Cette syntaxe est utile pour éviter de copier le même texte dans plusieurs fichiers. Elle est aussi utile si vous avez déjà des instructions communes dans un fichier comme AGENTS.md et que vous voulez les rendre visibles à Claude Code sans duplication.

@AGENTS.md
## Specifique a Claude Code
Utilise le mode plan pour les changements dans src/billing.

Ce que @path ne fait pas
@path ne réduit pas le coût de contexte. Les fichiers importés se chargent au lancement avec le CLAUDE.md qui les référence. Si CLAUDE.md devient trop volumineux, les imports aident à organiser mais ne réduisent pas le contexte, contrairement aux règles spécifiques au chemin.
Un import est un mécanisme d’organisation, pas un mécanisme de chargement conditionnel. Si le fichier importé est long et rarement utile, il ne doit pas être importé. Il doit rester comme note consultable, règle conditionnelle ou skill.

Mentionner un chemin sans importer
Si vous voulez signaler un fichier sans le charger automatiquement, mettez le chemin entre backticks. Hors backticks, @README importe le fichier ; entre backticks, le chemin reste un texte littéral. Le parseur d’imports ignore d’ailleurs tout ce qui se trouve dans un bloc de code ou une portion de code en ligne.

Pour le contexte detaille de migration, consulter `docs/migration-api.md` seulement
Ne pas importer ce fichier dans CLAUDE.md : il est trop long pour etre charge a chaque session.

C’est le bon pattern pour les notes longues : faire pointer vers elles, sans les injecter dans chaque session.

Utiliser .claude/rules/ pour les instructions modulaires
Le rôle du dossier rules
Pour les projets plus grands, placez des fichiers Markdown dans .claude/rules/. Chaque fichier doit couvrir un sujet précis, avec un nom descriptif comme testing.md, api-design.md ou security.md. Tous les fichiers Markdown y sont découverts récursivement, ce qui permet d’organiser les règles en sous-dossiers.

project/
  .claude/
    CLAUDE.md
    rules/
      testing.md
      security.md
      api.md
      frontend/
        react.md
      backend/
        database.md

.claude/rules/ est adapté aux instructions de projet qui restent importantes, mais qui ne doivent pas toutes vivre dans le fichier principal. Ces fichiers de règles ne supportent pas la syntaxe d’import @path : chaque règle doit être autonome.

Une règle par sujet
Une règle doit être cohérente et limitée. Un fichier testing.md doit parler des tests. Un fichier api.md doit parler de l’API. Un fichier security.md doit parler des exigences de sécurité. Un fichier qui mélange test, architecture, release, style et sécurité devient un second CLAUDE.md trop large.

Bon decoupage :
.claude/rules/testing.md
.claude/rules/api.md
.claude/rules/security.md
Mauvais decoupage :
.claude/rules/misc.md
.claude/rules/toutes-les-regles.md
.claude/rules/a-lire.md

Règles globales et règles limitées au chemin
Règles sans paths
Les règles sans champ paths se chargent sans condition et s’appliquent globalement, avec la même priorité que .claude/CLAUDE.md. Elles conviennent aux consignes qui valent pour tout le projet : standards de test, politique générale de sécurité, conventions de PR ou règles transversales.

Fichier :
.claude/rules/testing.md
Contenu :
# Tests
- Pour un bug, ajouter ou adapter un test qui reproduit le probleme.
- Lancer le test cible avant de lancer une suite plus large.
- Ne pas conclure sans indiquer la commande executee et son resultat.

Ce type de règle est utile si elle doit influencer presque toutes les tâches de développement. Sinon, il faut la limiter.

Règles avec paths
Une règle peut être limitée à certains fichiers avec un champ paths dans ses métadonnées. Ces règles se déclenchent lorsque Claude travaille avec des fichiers correspondant aux globs indiqués. Une règle limitée au chemin ne s’applique pas à chaque appel d’outil ; elle se charge quand Claude lit ou travaille avec les fichiers correspondants.

Dans un vrai fichier, ces métadonnées figurent dans le bloc YAML de tête (frontmatter) ; elles sont présentées ici séparément du contenu pour la lisibilité. Un glob qui commence par { ou * doit être mis entre guillemets, comme l’exige la syntaxe YAML.

Fichier :
.claude/rules/api.md
Metadonnees :
paths:
  - "src/api/**/*.ts"
Contenu :
# Regles API
- Valider les entrees de tous les endpoints.
- Utiliser le format d'erreur standard.
- Ajouter ou adapter un test pour tout nouveau comportement public.

Règles limitées au chemin : un point de vigilance
Une règle avec paths se charge quand Claude lit un fichier correspondant, pas nécessairement quand il en crée un. Une règle censée imposer une convention au moment de la création peut donc ne pas être présente dans le contexte pendant l’écriture du nouveau fichier.

Contournements :
laisser la regle inconditionnelle (sans paths) si elle doit valoir a la creation ;
demander d'abord a Claude de lire un fichier existant similaire, puis de creer le nouveau ;
pour une exigence non negociable a la creation, utiliser un hook plutot qu'une regle.

Une règle limitée au chemin reste excellente pour les conventions qui comptent pendant l’édition de fichiers déjà lus. Pour ce qui doit absolument exister dès la création, elle n’est pas le bon outil seul.

Globs utiles
Les globs permettent de viser une extension, un répertoire ou une combinaison : une extension précise, tout un sous-arbre, les fichiers Markdown à la racine, ou plusieurs extensions via l’expansion d’accolades.

Motif | Usage
---|---
**/*.ts | Tous les fichiers TypeScript.
src/**/* | Tous les fichiers sous src.
*.md | Fichiers Markdown à la racine.
src/components/*.tsx | Composants React dans un répertoire précis.
src/**/*.{ts,tsx} | Fichiers TypeScript et TSX sous src.

Exemples de règles spécialisées

Règle backend
Fichier :
.claude/rules/backend/database.md
Metadonnees :
paths:
  - "src/server/**/*.ts"
  - "src/db/**/*.ts"
Contenu :
# Regles backend
- Ne pas ecrire de requete SQL brute dans les handlers.
- Passer par la couche repository existante.
- Pour tout changement de schema, indiquer la migration et le test associe.

Règle frontend
Fichier :
.claude/rules/frontend/react.md
Metadonnees :
paths:
  - "src/components/**/*.tsx"
  - "src/pages/**/*.tsx"
Contenu :
# Regles React
- Reutiliser les composants partages avant d'en creer de nouveaux.
- Ne pas dupliquer la logique de formatage des dates.
- Ajouter un test UI si le comportement visible change.

Règle documentation
Fichier :
.claude/rules/docs.md
Metadonnees :
paths:
  - "docs/**/*.md"
  - "*.md"
Contenu :
# Regles documentation
- Privilegier une structure courte.
- Ne pas documenter une API obsolete comme si elle etait recommandee.
- Quand une commande est mentionnee, indiquer le contexte dans lequel elle s'execute.

Ces règles évitent que toutes les conventions du projet soient chargées pour chaque tâche. Claude reçoit les règles pertinentes quand il travaille dans la zone concernée.

Règles fortement conditionnelles
Quand les utiliser
Une règle fortement conditionnelle est une règle qui ne doit s’appliquer que dans un contexte étroit : un sous-système, une migration, une extension de fichier, une zone legacy ou une famille de tests. Elle est utile quand une règle globale serait fausse ou trop intrusive.

Exemple de contexte etroit :
uniquement les fichiers de migration ;
uniquement les endpoints publics ;
uniquement les composants accessibles aux utilisateurs ;
uniquement les tests d'integration ;
uniquement le code encore en migration.

Pourquoi rester simple
Les règles conditionnelles deviennent vite difficiles à maintenir si elles combinent trop de critères. Une règle fondée sur un chemin clair est lisible. Une règle qui tente d’encoder trop d’exceptions devient fragile.
Le meilleur critère reste souvent le chemin. Si le chemin ne suffit pas à exprimer le périmètre, il faut peut-être écrire une skill, une note de tâche ou une instruction explicite dans la demande courante.

Notes de projet et documents longs
Ne pas tout importer
Un dossier de notes est utile lorsque l’information est longue, rare ou explicative. Par exemple : une analyse d’architecture, un historique de migration, une procédure de release complète, une décision de produit ou une documentation API interne. Ces contenus ne doivent pas entrer automatiquement dans chaque session.

docs/claude-notes/
  migration-api.md
  architecture-auth.md
  release-process.md
  incidents-connus.md

Le CLAUDE.md principal peut indiquer que ces notes existent, mais il doit éviter de les importer si elles sont longues.

## Notes disponibles
- Pour la migration API, consulter `docs/claude-notes/migration-api.md` seulement si demande.
- Pour l'architecture auth, consulter `docs/claude-notes/architecture-auth.md` seulement pour modification auth.
- Pour la release, consulter `docs/claude-notes/release-process.md` seulement lors d'une release.

Ce pattern fait pointer vers les notes utiles sans les coller dans le contexte de démarrage.

Quand importer malgré tout
Un import @path est acceptable si le fichier importé est court, stable et utile à presque toutes les sessions. Par exemple : un fichier de conventions d’équipe très compact, un ancien AGENTS.md déjà maintenu, ou un petit guide de workflow commun.

@AGENTS.md
@docs/claude/conventions-courtes.md

Si le fichier dépasse quelques dizaines de lignes et n’est utile que parfois, il vaut mieux le mentionner comme chemin littéral, le transformer en règle limitée au chemin, ou le déplacer vers une skill.

Quand déplacer vers une skill
Les procédures répétées
Une procédure longue, multi-étapes ou rarement utilisée ne doit pas grossir CLAUDE.md. Dans une skill, le fichier SKILL.md contient les instructions principales, les fichiers de support stockent références, exemples ou scripts, et le contenu complet ne se charge que lorsque la skill est invoquée ou jugée pertinente.
Une règle dit comment se comporter dans une zone. Une skill décrit comment exécuter un workflow.

Exemple de décision
A deplacer vers une skill :
revue de PR ;
audit securite ;
preparation de release ;
diagnostic de performance ;
migration guidee ;
generation de changelog ;
procedure de rollback.

Contenu | Destination correcte
---|---
Commande officielle de test | CLAUDE.md
Convention propre aux fichiers API | .claude/rules/api.md
Historique complet d'une migration | Note dans docs/claude-notes/
Procédure de release en dix étapes | Skill
Interdiction de lire les secrets | Permission ou hook, pas mémoire

Structure recommandée
Projet standard
project/
  CLAUDE.md
  .claude/
    rules/
      testing.md
      security.md
      api.md
  docs/
    claude-notes/
      migration-api.md
      architecture-auth.md

Dans cette structure, CLAUDE.md contient le noyau permanent. .claude/rules/ contient les règles spécialisées. docs/claude-notes/ contient les informations longues que Claude ne doit lire que sur demande.

Monorepo
repo/
  CLAUDE.md
  .claude/
    rules/
      monorepo.md
  packages/
    api/
      CLAUDE.md
      .claude/
        rules/
          api-security.md
    web/
      CLAUDE.md
      .claude/
        rules/
          react.md
    shared/
      CLAUDE.md

Le chargement par emplacement est déjà acquis. La règle à retenir ici est plus simple : ne mettez pas les règles api, web et shared dans un seul fichier racine si elles peuvent vivre dans les zones concernées.

Maintenance des règles
Nommer pour relire
Les fichiers de règles doivent être nommés pour être relus. Un nom comme security.md ou api-validation.md permet à un reviewer de comprendre immédiatement le périmètre. Un nom comme rules2.md ou important.md ne dit rien.

Noms utiles :
api-validation.md
testing.md
security.md
react-components.md
migration-new-client.md
Noms faibles :
misc.md
notes.md
important.md
rules-old.md

Supprimer les règles mortes
Une règle liée à une migration doit être supprimée ou réécrite quand la migration est terminée. Une règle qui compense une ancienne erreur doit être retirée si le code, les tests ou les permissions rendent l’erreur impossible. Supprimez les instructions obsolètes ou conflictuelles dans CLAUDE.md, les fichiers imbriqués et .claude/rules/.

A verifier lors d'un nettoyage :
regles de migration terminee ;
regles dupliquees entre CLAUDE.md et rules ;
regles contredites par le code actuel ;
regles devenues permissions ;
regles devenues skills ;
regles trop larges pour leur chemin.

Erreurs fréquentes
Utiliser @path pour réduire le contexte
C’est une erreur. Les imports se chargent avec le fichier qui les référence. Ils améliorent l’organisation, mais pas le coût de contexte.

Importer une documentation longue
Un gros guide de migration ou une documentation API complète ne doit pas être importé dans CLAUDE.md. Mentionnez le chemin littéralement et demandez à Claude de le lire seulement si la tâche l’exige.

Créer une règle globale pour un cas local
Une règle qui concerne seulement src/api ne doit pas s’appliquer à tout le dépôt. Utilisez paths.

Multiplier les règles conditionnelles complexes
Des règles trop conditionnelles deviennent difficiles à comprendre. Préférez un découpage par chemin, par sujet et par pile technique.

Transformer une procédure en règle
Une règle doit être courte. Si elle décrit une procédure de plusieurs étapes, une checklist ou un workflow récurrent, elle doit probablement devenir une skill.

Compter sur une règle paths pour la création de fichiers
Une règle limitée au chemin se charge à la lecture, pas forcément à la création. Pour une convention qui doit valoir dès la création d’un fichier, rendez la règle inconditionnelle ou utilisez un hook.
