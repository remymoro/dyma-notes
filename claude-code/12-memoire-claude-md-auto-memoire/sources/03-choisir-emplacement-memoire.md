Une mémoire utile ne dépend pas seulement de son contenu. Elle dépend aussi de son emplacement. Dans Claude Code, le même texte n’a pas la même portée selon qu’il se trouve dans une mémoire utilisateur, dans un fichier projet, dans un fichier local, dans un fichier géré par l’organisation ou dans un sous-dossier de monorepo.
Choisir l’emplacement d’une mémoire revient à choisir qui doit recevoir cette instruction, quand elle doit se charger et combien de contexte elle doit consommer. Une convention commune doit être partagée avec l’équipe. Une préférence personnelle ne doit pas être versionnée. Une politique d’organisation ne doit pas dépendre d’un dépôt. Une règle propre à un sous-dossier ne doit pas gonfler le fichier racine.
Les fichiers CLAUDE.md ont plusieurs portées : politique gérée, instructions utilisateur, instructions projet et instructions locales. Les fichiers situés au-dessus du répertoire de travail se chargent au lancement, tandis que les fichiers situés dans les sous-répertoires se chargent à la demande lorsque Claude lit des fichiers dans ces sous-répertoires.

Les quatre portées principales
Mémoire gérée par l’organisation
La mémoire gérée sert aux instructions qui doivent s’appliquer à tous les utilisateurs d’une organisation. Elle est déployée par l’équipe informatique, DevOps ou plateforme. Elle convient aux consignes générales de qualité, de conformité, de traitement des données ou de style d’ingénierie.

macOS :
/Library/Application Support/ClaudeCode/CLAUDE.md
Linux et WSL :
/etc/claude-code/CLAUDE.md
Windows :
C:\Program Files\ClaudeCode\CLAUDE.md

Cette portée est très large. Elle ne doit pas contenir des détails propres à un dépôt particulier. Pour une règle spécifique à un projet, utilisez un CLAUDE.md de projet. Pour une règle qui doit bloquer techniquement une action, utilisez des paramètres gérés, des permissions ou des hooks plutôt qu’une simple instruction de mémoire. Du contenu géré peut aussi être fourni directement via les paramètres gérés de l’organisation, avec la même portée qu’un CLAUDE.md géré.

Mémoire utilisateur
La mémoire utilisateur se trouve dans ~/.claude/CLAUDE.md. Elle contient vos préférences personnelles pour tous les projets : style de réponse, habitudes de travail, raccourcis d’outils personnels, préférences de terminal, préférences de revue ou consignes qui vous concernent vous seul.

~/.claude/CLAUDE.md

Cette mémoire ne doit pas imposer une convention d’équipe. Elle est globale à votre environnement. Si vous y placez une instruction trop spécifique, elle risque d’influencer des projets où elle n’est pas pertinente.

A placer dans la memoire utilisateur :
utilise des reponses courtes pour les rappels ;
prefere pnpm quand le projet ne precise rien ;
demande avant de proposer une migration large ;
resume toujours les commandes executees en fin de tache.

La mémoire utilisateur doit décrire votre manière de travailler, pas la vérité d’un dépôt.

Mémoire projet
La mémoire projet est partagée avec l’équipe. Elle peut se trouver à la racine du dépôt dans ./CLAUDE.md, ou dans ./.claude/CLAUDE.md. Elle doit être versionnée si elle décrit des conventions communes au projet. Ces emplacements sont destinés aux instructions partagées par l’équipe : architecture, normes de codage, commandes de test, décisions techniques et workflows courants.

./CLAUDE.md
./.claude/CLAUDE.md

Cette mémoire doit rester sobre. Elle doit contenir ce que tout contributeur, humain ou agent, doit savoir en arrivant dans le projet.

A placer dans la memoire projet :
commande officielle de test ;
commande officielle de typecheck ;
structure du depot ;
workflow de pull request ;
patterns a suivre ;
patterns obsoletes a eviter ;
gotchas communs a l'equipe.

Si l’instruction concerne toute l’équipe et tout le dépôt, elle appartient à la mémoire projet. Si elle ne concerne qu’un package, un sous-système ou une pile technique locale, elle doit plutôt être placée dans un CLAUDE.md de sous-dossier ou dans une règle conditionnelle.

Mémoire locale projet
./CLAUDE.local.md contient vos préférences personnelles pour un projet précis. Il doit être ajouté à .gitignore. C’est l’emplacement adapté aux URL de sandbox personnelles, données de test préférées, notes locales ou informations propres à votre machine.

./CLAUDE.local.md

Ce fichier se charge à côté de CLAUDE.md, mais ne doit pas être partagé avec l’équipe.

A placer dans CLAUDE.local.md :
mon service local tourne sur le port 4011 ;
mes fixtures locales sont dans ../fixtures-locales ;
pour mes tests manuels, utiliser l'utilisateur de sandbox xyz ;
ne pas supposer que ces chemins existent chez les autres.

Une règle locale ne doit jamais devenir une dépendance implicite du projet. Si les autres développeurs ont besoin de l’instruction, elle doit migrer vers ./CLAUDE.md ou ./.claude/CLAUDE.md.

Table de choix
Choisir selon la portée

Emplacement | Portée | Usage correct | Partage
---|---|---|---
/etc/claude-code/CLAUDE.md ou équivalent système | Organisation | Consignes globales de qualité, conformité, sécurité ou style. | Tous les utilisateurs de l’organisation.
~/.claude/CLAUDE.md | Utilisateur | Préférences personnelles valables dans plusieurs projets. | Vous seul.
./CLAUDE.md ou ./.claude/CLAUDE.md | Projet | Instructions projet rangées avec les autres fichiers Claude. | Équipe, via le contrôle de version.
./CLAUDE.local.md | Projet local | Notes privées propres à votre machine ou à votre sandbox. | Vous seul, fichier ignoré par Git.

La décision doit être stricte. Une règle d’équipe dans CLAUDE.local.md ne sera pas disponible aux autres. Une préférence personnelle dans ./CLAUDE.md imposera votre style à toute l’équipe. Une règle de sécurité dans CLAUDE.md restera une instruction, pas un contrôle imposé.

Ordre de chargement
La hiérarchie au-dessus du répertoire courant
Au lancement, Claude Code remonte l’arborescence depuis le répertoire de travail actuel et charge les fichiers CLAUDE.md et CLAUDE.local.md trouvés dans chaque répertoire de cette hiérarchie. Les fichiers sont concaténés, pas remplacés, et lus de la racine vers le répertoire courant, donc le fichier le plus spécifique est lu en dernier et reçoit plus d’attention dans le contexte.

Exemple :
repo/
  CLAUDE.md
  packages/
    api/
      CLAUDE.md
      CLAUDE.local.md

Lancement depuis :
repo/packages/api
Memoire chargee au demarrage :
repo/CLAUDE.md
repo/packages/api/CLAUDE.md
repo/packages/api/CLAUDE.local.md

Dans chaque répertoire, CLAUDE.local.md est ajouté après CLAUDE.md : vos notes locales sont lues après les instructions partagées du même niveau. La liste des fichiers découverts est mémorisée pour toute la durée de la conversation ; /memory force un rechargement si vous modifiez ces fichiers en dehors de Claude.

Les fichiers descendants se chargent à la demande
Les fichiers CLAUDE.md situés sous le répertoire de travail ne se chargent pas tous au démarrage. Ils se chargent lorsque Claude lit des fichiers dans les sous-répertoires correspondants. Cette logique est essentielle dans les monorepos, car elle évite de charger les conventions de tous les packages avant que Claude sache lesquels sont pertinents.

Exemple :
repo/
  CLAUDE.md
  packages/
    api/
      CLAUDE.md
    web/
      CLAUDE.md
    shared/
      CLAUDE.md

Lancement depuis :
repo
Charge au demarrage :
repo/CLAUDE.md
Charge plus tard :
packages/api/CLAUDE.md si Claude lit packages/api
packages/web/CLAUDE.md si Claude lit packages/web
packages/shared/CLAUDE.md si Claude lit packages/shared

Le contexte de mémoire peut donc évoluer pendant la session. Claude peut commencer avec les instructions racine, puis charger des instructions plus spécifiques lorsqu’il entre dans une zone du dépôt.

Démarrer Claude au bon endroit
Le répertoire de lancement définit le centre de travail
Dans un grand dépôt, l’endroit où vous lancez claude détermine quels fichiers sont accessibles par défaut, quels fichiers CLAUDE.md se chargent au démarrage et quels paramètres de projet s’appliquent. Choisissez ce point de départ en fonction de la tâche : racine du dépôt pour les tâches transversales, sous-répertoire pour un travail limité à un package ou sous-système.

Depuis la racine du depot :
utile pour une tache qui traverse plusieurs packages.
Depuis packages/api :
utile pour une tache limitee au serveur API.
Depuis packages/web :
utile pour une tache limitee au frontend.

Le choix du point de départ est un acte de cadrage. Démarrer trop haut peut charger trop de contexte. Démarrer trop bas peut cacher des conventions utiles situées ailleurs.

Racine ou sous-dossier

Point de départ | Effet mémoire | À utiliser quand
---|---|---
Racine du dépôt | Le CLAUDE.md racine se charge au démarrage ; les sous-dossiers se chargent à la demande. | La tâche traverse plusieurs packages ou concerne l’architecture globale.
Sous-répertoire | Le CLAUDE.md local et les ancêtres se chargent au démarrage. | Le travail est limité à un package, une application ou un sous-système.

Dans un monorepo, démarrer depuis packages/api charge les instructions de ce package et les instructions racine, mais pas les instructions du frontend tant que Claude ne lit pas ce sous-dossier. C’est souvent le meilleur compromis pour éviter de polluer le contexte avec des conventions non pertinentes.

Monorepo : superposer les mémoires
Un fichier racine pour les invariants
Dans un monorepo, le CLAUDE.md racine doit contenir les règles qui s’appliquent partout : structure générale, conventions de commit, commandes globales, politiques de migration et règles transversales.

repo/CLAUDE.md
Contenu recommande :
ce depot est un monorepo ;
packages/api contient le serveur ;
packages/web contient le frontend ;
packages/shared contient les utilitaires partages ;
executer les commandes depuis le package concerne ;
ne pas lancer tous les tests du monorepo sans demande explicite.

Ce fichier ne doit pas contenir les détails de chaque package. Il doit orienter Claude vers la bonne zone, pas documenter toute l’organisation interne.

Un fichier par package pour les conventions locales
Les CLAUDE.md de sous-dossiers doivent contenir les règles propres à leur pile technique : commandes, structure, pièges, migrations locales et tests spécifiques. Cette superposition évite qu’un seul fichier racine couvre tous les sous-systèmes et consomme du contexte avec des instructions sans rapport avec la tâche actuelle.

repo/packages/api/CLAUDE.md
Contenu recommande :
ce package est le serveur API ;
les routes sont dans src/routes ;
les tests API utilisent Vitest ;
la base locale doit etre migree avant les tests d'integration ;
ne pas ecrire de SQL brut dans les handlers.

repo/packages/web/CLAUDE.md
Contenu recommande :
ce package est le frontend ;
les composants partages sont dans src/components ;
utiliser les hooks existants sous src/hooks ;
les tests UI sont lances depuis ce package.

Un fichier par zone réduit le bruit. Claude reçoit les conventions du package seulement quand la tâche les rend pertinentes.

Éviter les mémoires non pertinentes
claudeMdExcludes
Dans un grand monorepo, certains CLAUDE.md peuvent appartenir à d’autres équipes, à du code hérité ou à des packages hors périmètre. Le paramètre claudeMdExcludes permet d’ignorer des fichiers ou dossiers de mémoire par chemin ou glob. Ces exclusions peuvent être définies à plusieurs portées, les tableaux fusionnent entre les couches, et les fichiers de politique gérée ne peuvent pas être exclus.

{
  "$schema": "https://json.schemastore.org/claude-code-settings",
  "claudeMdExcludes": [
    "**/packages/admin-dashboard/**",
    "**/packages/legacy-*/**"
  ]
}

Cette configuration doit être utilisée avec prudence, car elle est statique. Si vous travaillez aujourd’hui sur packages/api et demain sur packages/web, il vaut mieux démarrer Claude depuis le bon répertoire que modifier constamment les exclusions. Mieux vaut choisir le répertoire de lancement plutôt que d’utiliser les exclusions comme commutateur par tâche.

Quand exclure
Excluez une mémoire seulement si elle est durablement non pertinente pour votre travail ou si elle appartient à une zone que vous ne voulez pas charger accidentellement.

Cas raisonnables :
packages d'une autre equipe ;
code herite rarement modifie ;
sous-arbre vendu ;
experimentations anciennes ;
instructions incompatibles avec votre perimetre.

Ne masquez pas une mémoire simplement parce qu’elle contredit une autre. Si deux instructions de projet se contredisent, le problème doit être corrigé dans le dépôt.

Répertoires supplémentaires
Accès aux fichiers et mémoire chargée ne sont pas identiques
Ajouter un répertoire supplémentaire donne accès à ses fichiers, mais ne charge pas automatiquement ses fichiers CLAUDE.md. Les fichiers de mémoire des répertoires ajoutés ne se chargent que si la variable CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD est définie. Dans ce cas, Claude charge notamment CLAUDE.md, .claude/CLAUDE.md, .claude/rules/*.md et CLAUDE.local.md depuis le répertoire ajouté.

CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1

Ne confondez pas accès et instruction. Donner accès à un dépôt frère permet de lire ou modifier ses fichiers. Charger sa mémoire ajoute aussi ses consignes au contexte. Ce second choix doit être volontaire.

Quand charger la mémoire d’un répertoire ajouté
Chargez la mémoire du répertoire ajouté si le travail doit vraiment respecter ses conventions internes. Ne la chargez pas si vous devez seulement lire un fichier, comparer une API ou consulter une définition.

Besoin | Choix
---|---
Lire une interface dans un dépôt partagé | Ajouter le répertoire sans charger sa mémoire.
Modifier un package frère selon ses conventions | Ajouter le répertoire et charger sa mémoire si disponible.
Faire une correction transversale multi packages | Charger les mémoires pertinentes, puis contrôler le contexte avec /memory.
Comparer deux projets sans modifier | Limiter l’accès et éviter de charger des instructions inutiles.

CLAUDE.local.md et worktrees
Un fichier local ne suit pas automatiquement tous les worktrees
Un CLAUDE.local.md ignoré par Git existe seulement dans le worktree où vous l’avez créé. Pour partager des instructions personnelles entre plusieurs worktrees d’un même référentiel, importez un fichier situé dans votre répertoire personnel plutôt que de dupliquer le fichier local dans chaque worktree.

Dans un CLAUDE.local.md :
@~/.claude/mes-instructions-personnelles-projet.md

Cette approche garde vos instructions personnelles hors du dépôt tout en les rendant réutilisables entre worktrees. La première fois que Claude rencontre un import externe dans un projet, une boîte de dialogue d’approbation s’affiche ; refuser désactive cet import de façon permanente pour ce projet.

Ne pas utiliser local pour contourner le projet
CLAUDE.local.md sert à ajouter des détails personnels, pas à contredire silencieusement la mémoire projet. Si votre fichier local désactive mentalement une règle d’équipe, la prochaine personne qui travaille sur la même tâche ne verra pas cette exception. Une mémoire locale doit rester compatible avec la mémoire partagée.

Mémoire gérée et paramètres gérés
Deux couches différentes
Un CLAUDE.md géré fournit des instructions comportementales à l’échelle de l’organisation. Les paramètres gérés appliquent des contrôles techniques : permissions, sandbox, variables d’environnement, authentification et routage fournisseur. Ces usages sont distincts : directives de style ou de conformité dans le CLAUDE.md géré, blocage d’outils ou de chemins dans les paramètres gérés.

Besoin | Emplacement adapté
---|---
Rappeler les standards de qualité de l’organisation | CLAUDE.md géré.
Bloquer la lecture de chemins sensibles | Paramètres gérés avec permissions.
Imposer le sandbox | Paramètres gérés.
Rappeler une politique de traitement des données | CLAUDE.md géré, éventuellement complété par contrôles techniques.

Une mémoire gérée influence le comportement. Un paramètre géré impose le comportement du client. Les deux peuvent coexister, mais ils ne répondent pas au même besoin.

Vérifier ce qui est chargé
Utiliser /memory comme audit d’emplacement
/memory liste les fichiers CLAUDE.md, CLAUDE.local.md et les règles chargées dans la session actuelle. Utilisez-le pour vérifier qu’un fichier attendu est bien visible ; si un fichier n’est pas listé, Claude ne peut pas le suivre. Ici, /memory sert surtout à valider le chargement des emplacements.

/memory
Demande utile apres /memory :
liste les fichiers de memoire charges ;
indique leur portee probable ;
signale les fichiers locaux ;
signale les instructions qui pourraient se contredire ;
ne modifie rien.

Vérifier après changement de répertoire
Après un changement de répertoire de travail ou un lancement depuis un autre sous-dossier, relancez /memory. Les fichiers chargés peuvent changer, surtout dans un monorepo.

Depuis la racine :
/memory
Depuis packages/api :
/memory
Comparer :
quels fichiers sont communs ;
quels fichiers se chargent seulement dans le package ;
quelles instructions locales apparaissent ;
quelles regles ne sont plus visibles.

Une instruction absente de /memory n’est pas une instruction active.

Commentaires et notes de maintenance
Commentaires HTML dans CLAUDE.md
Les commentaires HTML au niveau des blocs sont supprimés avant injection dans le contexte de Claude. Ils peuvent donc servir à laisser des notes aux responsables humains sans consommer de tokens de contexte. Les commentaires à l’intérieur des blocs de code sont conservés, et tous restent visibles si vous ouvrez le fichier avec l’outil Read.

<!-- Note mainteneur :
supprimer cette section quand la migration API sera term
-->
## Migration API
Pour tout nouveau code, utiliser src/lib/api-client.ts.

Cette pratique est utile pour les mémoires partagées. Elle permet d’expliquer pourquoi une règle existe sans charger cette justification dans le contexte de Claude.

Protocoles recommandés
Projet simple
Emplacement recommande :
./CLAUDE.md
Contenu :
commandes officielles ;
structure courte ;
patterns a suivre ;
gotchas ;
workflow de verification.
Audit :
/memory

Préférences personnelles globales
Emplacement recommande :
~/.claude/CLAUDE.md
Contenu :
preferences personnelles ;
habitudes de reponse ;
preferences de workflow ;
rappels personnels non lies a un depot.

Monorepo
Structure recommandee :
repo/CLAUDE.md
repo/packages/api/CLAUDE.md
repo/packages/web/CLAUDE.md
repo/packages/shared/CLAUDE.md
Principe :
racine pour les regles transversales ;
package pour les conventions locales ;
exclusions seulement pour les zones durablement non pertinentes.

Projet avec notes personnelles
Emplacement recommande :
./CLAUDE.local.md
A faire :
ajouter a .gitignore ;
ne pas y placer de regle d'equipe ;
ne pas y mettre de secret ;
verifier avec /memory.

Erreurs fréquentes
Mettre une règle d’équipe dans CLAUDE.local.md
Une règle locale ne sera pas partagée. Si elle est nécessaire au projet, placez-la dans ./CLAUDE.md ou ./.claude/CLAUDE.md.

Mettre une préférence personnelle dans ./CLAUDE.md
Le fichier projet appartient à l’équipe. Les préférences individuelles doivent rester dans ~/.claude/CLAUDE.md ou ./CLAUDE.local.md.

Lancer Claude depuis la racine par réflexe
Dans un monorepo, lancer Claude depuis la racine peut élargir inutilement le contexte. Pour une tâche limitée à un package, démarrez depuis ce package.

Confondre sous-dossier et chargement au démarrage
Un CLAUDE.md descendant n’est pas forcément chargé au lancement. Il se charge quand Claude lit des fichiers de ce sous-dossier.

Charger la mémoire d’un répertoire ajouté sans besoin
Accéder à un répertoire ne signifie pas que ses instructions doivent entrer dans le contexte. Chargez sa mémoire seulement si ses conventions sont nécessaires à la tâche.

Utiliser claudeMdExcludes pour éviter de nettoyer une contradiction
Une exclusion est utile pour ignorer une zone non pertinente. Elle ne doit pas masquer un conflit réel dans la mémoire du projet.
