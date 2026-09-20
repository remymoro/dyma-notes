Claude Code 14. Les compétences (skills) 6. Installer des skills et présentation de skills.sh

Jusqu’à présent, nous avons créé une skill directement dans le projet. Il est également possible d’installer des skills publiées par Anthropic, Vercel, Microsoft ou d’autres développeurs.

Comprendre le rôle de skills.sh
skills.sh est un annuaire public de skills pour agents d’intelligence artificielle. Il est exploité par Vercel et s’appuie sur le projet open source skills.

Le site indexe les skills publiques installées avec le CLI, puis les classe à partir de statistiques d’installation anonymisées. Il ne s’agit pas d’un catalogue exclusivement réservé à Claude Code : les mêmes skills peuvent être proposées à Claude Code, Codex, Cursor, GitHub Copilot, Windsurf et de nombreux autres agents.

Cette portabilité est possible parce que Claude Code suit le standard ouvert Agent Skills. Une skill repose principalement sur un dossier contenant un fichier SKILL.md, éventuellement complété par des scripts, des références et des exemples. Claude Code ajoute ensuite ses propres fonctionnalités, comme le déclenchement automatique, les restrictions d’outils ou l’exécution dans un sous-agent.

Parcourir une fiche de skill
Chaque fiche de skills.sh présente les informations utiles avant une installation.

Information | Utilité
---|---
Nom et description | Comprendre la responsabilité de la skill.
Commande d’installation | Installer la skill depuis son dépôt source.
Contenu de SKILL.md | Examiner les instructions données à l’agent.
Dépôt GitHub | Identifier l’auteur et consulter les fichiers sources.
Nombre d’installations | Mesurer l’adoption de la skill.
Agents compatibles | Vérifier qu’elle peut être installée dans Claude Code.
Audits de sécurité | Consulter les résultats des analyses automatisées disponibles.

Le site propose également des classements globaux, des tendances récentes, des catégories et un filtre pour afficher les skills provenant de sources officielles.

Inspecter une skill avant de l’installer
Une skill externe doit être considérée comme du code tiers. Elle peut contenir des instructions, des scripts et des commandes que Claude sera susceptible d’exécuter.

Avant l’installation, vérifiez au minimum :
le propriétaire du dépôt ;
le contenu de SKILL.md ;
les scripts et dépendances inclus ;
le périmètre des outils demandés ;
les audits de sécurité disponibles ;
la pertinence réelle de la skill pour le projet.

Les audits présents sur skills.sh constituent un signal supplémentaire, mais pas une garantie. Le site recommande explicitement de relire une skill avant son installation.

Rechercher une skill
La recherche peut être effectuée directement sur skills.sh ou depuis le terminal avec le CLI.

npx skills find testing

Il est également possible de rechercher une expression plus précise :

npx skills find "web application testing"

Le CLI possède aussi une skill nommée find-skills. Elle permet à l’agent de rechercher lui-même une capacité adaptée lorsqu’un utilisateur demande une fonctionnalité spécialisée.

npx skills add https://github.com/vercel-labs/skills \
--skill find-skills \
--agent claude-code

find-skills privilégie notamment la réputation de la source, le nombre d’installations et les options populaires déjà présentes dans l’annuaire.

Choisir une skill pour le convertisseur
Le projet contient une petite application web locale. Une skill adaptée est donc webapp-testing, publiée dans le dépôt officiel anthropics/skills.

Cette skill utilise des scripts Python basés sur Playwright pour tester des applications web locales. Elle fournit notamment un script chargé de démarrer un ou plusieurs serveurs pendant les tests, puis de les arrêter une fois la vérification terminée.

Elle recommande une approche en deux étapes :
1. ouvrir l’application et inspecter le DOM rendu ;
2. identifier les sélecteurs avant d’effectuer les interactions.

Elle peut également capturer les erreurs de la console du navigateur. Ces capacités sont adaptées au convertisseur, dont le serveur est lancé avec npm run dev.

Choisir la portée de l’installation
Le CLI permet d’installer une skill dans le projet courant ou dans le dossier personnel de l’utilisateur.

Portée | Option | Emplacement Claude Code | Usage
---|---|---|---
Projet | Par défaut | .claude/skills/ | Disponible uniquement dans le dépôt et partageable avec l’équipe.
Personnelle | --global ou -g | ~/.claude/skills/ | Disponible dans tous les projets de l’utilisateur.

Pour une skill découverte récemment, il est préférable de commencer par une installation projet. Son comportement reste ainsi limité au convertisseur et peut être inspecté dans le dépôt avant une éventuelle installation globale.

Lister les skills d’un dépôt distant
Le dépôt anthropics/skills contient plusieurs skills. Avant d’en installer une, affichez la liste disponible :

npx skills add https://github.com/anthropics/skills --list

L’option --list inspecte le dépôt sans installer toutes ses skills. Il est préférable de sélectionner uniquement les capacités réellement nécessaires plutôt que d’ajouter une collection complète au projet.

Installer webapp-testing
Depuis la racine du convertisseur, lancez :

npx skills add https://github.com/anthropics/skills \
--skill webapp-testing \
--agent claude-code

Les différentes parties de la commande sont les suivantes :

Partie | Rôle
---|---
npx skills add | Lance le gestionnaire de skills sans installation globale du CLI.
https://github.com/anthropics/skills | Indique le dépôt source.
--skill webapp-testing | Sélectionne uniquement la skill souhaitée.
--agent claude-code | Cible explicitement Claude Code.

Le CLI peut proposer une installation par lien symbolique ou par copie. Le lien symbolique maintient une source unique lorsqu’une skill est partagée entre plusieurs agents. La copie crée au contraire une version indépendante dans chaque dossier d’agent.

Vérifier l’installation
Listez les skills installées pour Claude Code :

npx skills list --agent claude-code

Vérifiez ensuite la liste depuis Claude Code :
/skills

La structure du projet doit maintenant contenir les skills créées ou installées :

.claude/
skills/
techdebt/
SKILL.md
webapp-testing/
SKILL.md
examples/
scripts/

Selon la méthode d’installation sélectionnée, webapp-testing peut être un dossier copié ou un lien symbolique vers la copie gérée par le CLI.

Contrôlez enfin les modifications du dépôt :

git status --short
git diff -- .claude

Cette vérification permet de connaître précisément les fichiers ou liens ajoutés avant de les conserver dans le projet.

Utiliser la skill dans le convertisseur
La skill peut être appelée directement avec sa commande :

/webapp-testing Lance le convertisseur avec npm run dev.
Vérifie les scénarios suivants :
- la valeur 20 affiche 68 °F ;
- une saisie vide n'affiche pas NaN ;
- la valeur abc n'affiche pas NaN ;
- aucune erreur inattendue n'apparaît dans la console.
Ne modifie aucun fichier.
Présente les résultats observés pour chaque scénario.

Claude peut alors utiliser les instructions et les scripts fournis par la skill pour démarrer le serveur, ouvrir l’application et interagir avec le formulaire.

La skill utilise Playwright avec Python. Si les dépendances nécessaires ne sont pas disponibles, Claude peut demander l’autorisation de les installer ou indiquer les prérequis manquants. Une installation de skill n’installe pas nécessairement toutes les dépendances système dont ses scripts peuvent avoir besoin.

Utiliser une skill sans l’installer
Le CLI permet aussi d’utiliser temporairement une skill sans l’ajouter au projet :

npx skills use https://github.com/anthropics/skills \
--skill webapp-testing \
--agent claude-code

Le CLI télécharge alors la skill dans un dossier temporaire et lance l’agent avec les instructions correspondantes. Cette approche est utile pour une évaluation ponctuelle avant une installation permanente.

Mettre à jour ou supprimer une skill
Les skills installées ne sont pas nécessairement figées. Leur dépôt source peut évoluer.

Pour mettre à jour une skill :
npx skills update webapp-testing

Pour mettre à jour toutes les skills du projet :
npx skills update --project

Pour supprimer la skill :
npx skills remove webapp-testing

Une mise à jour doit être relue comme une nouvelle dépendance. Le contenu de SKILL.md, les scripts et les permissions peuvent avoir changé depuis l’installation précédente.

Comprendre la télémétrie
Le CLI transmet par défaut des données anonymisées utilisées pour construire les classements de skills.sh. La documentation indique que cette télémétrie concerne notamment la skill installée et la date de l’installation, sans contenu de session ni information personnelle.

Pour la désactiver :

DISABLE_TELEMETRY=1 npx skills add \
https://github.com/anthropics/skills \
--skill webapp-testing \
--agent claude-code

Le comportement exact de la télémétrie et son option de désactivation sont documentés par le projet skills.

Ne pas confondre skills.sh et les plugins Claude Code
skills.sh est un écosystème ouvert et multi-agent. Il utilise le CLI npx skills pour installer des dossiers de skills dans les emplacements reconnus par chaque agent.

Claude Code possède également son propre système de plugins et de marketplaces. Le dépôt officiel anthropics/skills peut, par exemple, être ajouté comme marketplace Claude Code avec /plugin marketplace add. Cette autre méthode permet d’installer des ensembles pouvant inclure des skills, des agents, des hooks ou des serveurs MCP.

Pour installer une skill précise dans plusieurs agents, skills.sh et son CLI sont adaptés. Pour distribuer un ensemble complet propre à Claude Code, un plugin peut être plus approprié.

Bonnes pratiques d’installation
Commencez par rechercher une skill spécialisée plutôt que d’installer une collection entière.
Privilégiez les dépôts officiels ou les auteurs identifiés.
Lisez SKILL.md et les scripts avant l’installation.
Consultez les audits sans les considérer comme une garantie absolue.
Installez d’abord la skill au niveau du projet.
Vérifiez les modifications avec Git.
Testez la skill sur une tâche bornée.
Relisez les mises à jour avant de les accepter.
Supprimez les skills devenues inutiles.

Anthropic recommande de commencer avec des skills courtes, ciblées et réellement utiles, puis de les améliorer à partir des problèmes observés. Une bibliothèque trop large ou redondante augmente le contexte disponible et rend le déclenchement des bonnes instructions plus difficile.
