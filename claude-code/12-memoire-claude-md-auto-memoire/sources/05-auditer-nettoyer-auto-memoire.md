Le chapitre a couvert l’écriture de CLAUDE.md, son initialisation, le choix des emplacements et l’organisation des grandes instructions. Reste l’entretien : auditer la mémoire effectivement chargée, inspecter l’auto-mémoire, corriger ce qui est obsolète et supprimer ce qui pollue les sessions futures.
Une mémoire utile n’est pas seulement bien écrite ; c’est une mémoire entretenue. Une règle exacte aujourd’hui peut devenir fausse après une migration. Une préférence temporaire peut survivre trop longtemps. Une note de debugging peut devenir une hypothèse morte. /memory rend cette couche visible avant qu’elle ne devienne une dette contextuelle. La commande liste les fichiers CLAUDE.md, CLAUDE.local.md et rules chargés dans la session, permet de les ouvrir dans l’éditeur, bascule la mémoire automatique et donne accès au dossier où Claude stocke ses souvenirs automatiques.

Inspecter et ouvrir la mémoire chargée
Voir la mémoire réellement active
/memory n’affiche pas ce que Claude devrait voir, mais ce qui est réellement chargé dans la session. C’est la différence entre une mémoire présente sur le disque et une mémoire qui influence la conversation courante. Un fichier absent de /memory n’agit pas : ce point a déjà servi pour les emplacements, et il faut le revérifier après un changement de répertoire ou un /cd, surtout dans un monorepo où les fichiers de sous-dossiers se chargent à la lecture.

Ouvrir et corriger un fichier
L’apport propre à l’audit est l’édition. /memory permet de sélectionner un fichier de mémoire et de l’ouvrir dans l’éditeur, pour corriger immédiatement une règle vague, supprimer une instruction morte, déplacer une note locale ou nettoyer une entrée d’auto-mémoire devenue inutile.
L’audit part de la mémoire chargée, pas d’une supposition. Avant de corriger un comportement de Claude, vérifiez si l’instruction existe, si elle est chargée, si elle est claire et si elle n’est pas contredite ailleurs. Les deux défauts déjà signalés ailleurs, contradictions et longueur excessive, se repèrent ici sur la mémoire effectivement active : deux fichiers chargés ensemble peuvent donner des consignes incompatibles, et un fichier trop long dilue l’attention portée à chaque règle.

Inspecter l’auto-mémoire
Ce qu’elle enregistre
La mémoire automatique, écrite par Claude, accumule des apprentissages d’une session à l’autre : commandes de build, insights de debugging, notes d’architecture, préférences de style, habitudes de workflow. Claude ne sauvegarde pas systématiquement ; il décide si une information paraît utile pour une conversation future.
Cette autonomie est utile, mais elle doit être surveillée. Une note écrite automatiquement peut être trop locale, trop ancienne, trop dépendante d’une erreur passée, ou mal généralisée. Elle peut aider une future session comme lui donner une hypothèse dépassée.

Où elle vit
Chaque projet possède un répertoire de mémoire automatique sous ~/.claude/projects/<project>/memory/. Le chemin <project> dérive du dépôt Git, donc tous les worktrees et sous-répertoires d’un même dépôt partagent un seul répertoire de mémoire ; hors d’un dépôt Git, c’est la racine du projet qui sert. Cette mémoire est locale à la machine et n’est pas partagée entre machines ni avec les environnements cloud.

~/.claude/projects/<project>/memory/
  MEMORY.md
  debugging.md
  api-conventions.md
  autres-fichiers-de-sujet.md

Cette portée est importante. L’auto-mémoire ne doit pas être traitée comme une mémoire d’équipe fiable. Une information qui doit être partagée doit être déplacée vers un fichier versionné approprié, typiquement CLAUDE.md. Un coéquipier sur une autre machine a son propre dossier, avec ses propres notes.

Comprendre MEMORY.md
MEMORY.md agit comme index. Les 200 premières lignes ou les premiers 25 KB de MEMORY.md, selon ce qui vient en premier, sont chargés au début de chaque conversation ; le contenu au-delà n’est pas chargé au démarrage. Les fichiers de sujet ne sont pas chargés au démarrage ; Claude les lit à la demande quand il en a besoin.
MEMORY.md doit donc rester un index, pas une archive. Les détails longs vivent dans des fichiers de sujet ; l’index indique seulement quelles connaissances existent et où les retrouver. Un index laissé grossir au-delà du seuil perd silencieusement sa fin : ce qu’on croyait actif se retrouve sous la ligne de flottaison, sans effet.

Activer, désactiver ou déplacer l’auto-mémoire
Basculer depuis /memory ou les paramètres
La mémoire automatique nécessite Claude Code v2.1.59 ou ultérieur et est active par défaut. Elle se bascule depuis /memory ou via le paramètre autoMemoryEnabled.

{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "autoMemoryEnabled": false
}

Désactivez-la dans les dépôts où les apprentissages automatiques risquent d’être trompeurs, dans les environnements jetables, dans les projets à données sensibles, ou lorsque vous voulez contrôler exclusivement la mémoire écrite par l’équipe.

Désactiver par variable d’environnement
Une variable d’environnement désactive l’auto-mémoire pour une session, un shell, un conteneur ou un environnement de formation. Elle a la priorité sur le paramètre : CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 l’emporte sur autoMemoryEnabled, et la valeur 0 force la réactivation même quand un paramètre la désactiverait.

CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude

Ce réglage évite que Claude mémorise des conventions artificielles, des chemins de démonstration ou des préférences propres à un atelier.

Déplacer le répertoire d’auto-mémoire
Le chemin de mémoire automatique peut être modifié avec autoMemoryDirectory. La valeur doit être absolue ou commencer par ~/. Ce paramètre n’est lu que depuis les portées utilisateur, locale ou gérée, pas depuis les paramètres projet : un dépôt cloné pourrait sinon rediriger l’écriture de mémoire vers un emplacement sensible.

{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "autoMemoryDirectory": "~/memoire-claude-code/projet-api"
}

Ce réglage doit rester rare. Déplacer la mémoire peut aider dans un environnement contrôlé, mais peut aussi compliquer l’audit si l’équipe ne sait plus où les notes sont stockées.

Nettoyer la mémoire
Supprimer l’obsolète et fusionner les doublons
Une règle devient obsolète quand elle décrit une architecture ancienne, une commande supprimée, une migration terminée, un bug déjà corrigé ou une contrainte liée à une ancienne version d’outil. Une mémoire obsolète est dangereuse parce qu’elle agit tôt dans la session, avant même que le code actuel soit relu. Les doublons sont rarement identiques : ils disent la même chose avec de petites différences, ce qui fait que Claude perçoit deux consignes proches mais non équivalentes. Choisissez la formulation la plus précise, supprimez les variantes faibles, gardez une seule règle par décision.

Retirer les souvenirs trop locaux
C’est le nettoyage propre à l’auto-mémoire. Elle peut enregistrer une information utile sur le moment mais trop locale pour devenir une vérité durable : une commande lancée pour un bug précis, un état temporaire de base de données, un chemin de machine, une décision expérimentale ou une contrainte d’un worktree temporaire.

A retirer de l'auto-memoire :
notes liees a une seule branche ;
hypotheses non confirmees ;
resultats de debugging perimes ;
chemins propres a une machine ;
decisions experimentales non adoptees ;
informations qui devraient vivre dans un ticket.

La mémoire automatique doit conserver des patterns, pas des accidents de session. Elle n’a pas de mécanisme intégré pour vieillir, dédupliquer ou résoudre les contradictions : c’est la relecture qui joue ce rôle.

Déplacer au lieu de supprimer
Un contenu peut être mauvais au mauvais endroit mais utile ailleurs. Les destinations vues au chapitre précédent s’appliquent ici sans changement : une procédure longue devient une skill, une convention propre à un dossier devient une règle limitée au chemin, une note d’architecture longue reste une note consultable, une interdiction critique devient une permission ou un hook. L’ajout propre à l’audit est la sixième ligne : un souvenir automatique faux ou périmé se supprime de l’auto-mémoire.

Consolider l’auto-mémoire
MEMORY.md comme index vivant
Claude garde MEMORY.md concis en déplaçant les notes détaillées vers des fichiers de sujet séparés. Cette organisation fonctionne comme une consolidation pratique : l’index reste chargé au démarrage, les détails restent consultables à la demande. Elle devient problématique si MEMORY.md pointe vers files de sujet inutiles, anciens ou contradictoires.

Auditer les fichiers de sujet
Les fichiers de sujet doivent être relus périodiquement. Un debugging.md peut contenir des observations vraies une semaine puis fausses après une correction. Un api-conventions.md peut documenter une convention avant qu’elle soit remplacée.

Audit des fichiers de sujet :
ouvrir le dossier via /memory ;
relire MEMORY.md ;
ouvrir chaque fichier reference ;
supprimer les notes perimees ;
deplacer les regles durables vers le fichier approprie ;
garder MEMORY.md comme index court.

Ne laissez pas l’auto-mémoire devenir une documentation parallèle non revue. Une note durable et partagée doit probablement quitter l’auto-mémoire locale pour un fichier versionné.

Diagnostiquer une instruction non suivie
Fichier absent ou fichier présent
Le diagnostic se fait en deux temps. Si le fichier n’apparaît pas dans /memory, le problème vient du chargement, traité avec les emplacements : répertoire de lancement, sous-dossier non encore lu, fichier mal placé, exclusion, ou mémoire locale absente. Relancer depuis le bon répertoire suffit souvent.
Si le fichier est listé mais que Claude ne suit pas l’instruction, le problème vient plus probablement de la qualité de l’instruction : trop vague, trop longue, contradictoire, noyée dans un fichier trop volumineux, ou mal adaptée au mécanisme. Une règle qui doit être garantie n’a pas sa place dans la seule mémoire : elle relève d’une permission ou d’un hook.

Demande de diagnostic :
cette instruction est chargee mais mal suivie.
Explique si elle est :
trop vague ;
contradictoire ;
trop eloignee du point de decision ;
mieux adaptee a une permission ;
mieux adaptee a un hook ;
mieux adaptee a une skill.

Protocoles recommandés
Audit au début d’une session sensible
/memory
/context
Demande :
liste les memoires chargees ;
signale les instructions locales ;
signale les regles liees a la tache ;
signale les souvenirs automatiques recents ;
ne modifie aucun fichier.

Ce protocole convient avant une migration, une revue de sécurité ou une modification d’infrastructure, où une ancienne instruction pourrait orienter la session dans une mauvaise direction.

Nettoyage de l’auto-mémoire
/memory
Actions :
ouvrir le dossier de memoire automatique ;
relire MEMORY.md ;
supprimer les hypotheses perimees ;
garder seulement les patterns verifies ;
deplacer les regles partagees vers CLAUDE.md ;
garder les details longs dans les fichiers de sujet.

Ce protocole est nécessaire après une longue série de debugging, une migration ou un changement d’outils. Ces périodes produisent beaucoup d’informations temporaires qui ne doivent pas toutes survivre.

Désactivation pour une formation ou un atelier
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "autoMemoryEnabled": false
}

Dans un atelier, un dépôt d’exercice ou une démonstration, désactiver l’auto-mémoire évite que Claude conserve des conventions artificielles, des chemins de cours ou des erreurs volontairement introduites.

Erreurs fréquentes
Considérer /memory comme une preuve de conformité
/memory prouve qu’un fichier est chargé, pas que Claude suivra parfaitement chaque instruction. Les fichiers de mémoire sont du contexte : ils guident le modèle, ils ne remplacent pas une permission, un hook ou un test.

Laisser l’auto-mémoire accumuler sans relecture
La mémoire automatique est lisible et modifiable. Ne pas la relire revient à laisser une couche de contexte locale évoluer sans revue, avec le risque d’hypothèses périmées rechargées à chaque session.

Confondre mémoire locale et mémoire d’équipe
Une note dans ~/.claude/projects/<project>/memory/ n’est pas partagée automatiquement avec les autres machines ou le cloud. Si l’équipe doit l’utiliser, elle doit être déplacée dans un fichier versionné.

Garder des hypothèses de debugging
Une hypothèse utile pendant une enquête peut devenir fausse après correction. Les souvenirs automatiques doivent conserver les conclusions vérifiées, pas toutes les pistes explorées.

Laisser MEMORY.md devenir trop long
Seule la partie initiale de MEMORY.md se charge au démarrage. Si l’index devient trop long, des informations importantes se retrouvent au-delà du seuil chargé. Remplacez un détail qui dépasse par un pointeur d’une ligne vers un fichier de sujet.

Table de décision

Problème observé | Diagnostic avec /memory | Action correcte
---|---|---
Claude ignore une convention projet | Vérifier si le fichier de mémoire est chargé. | Corriger l’emplacement ou rendre l’instruction plus spécifique.
Claude reprend une ancienne hypothèse | Inspecter l’auto-mémoire et les fichiers de sujet. | Supprimer la note périmée ou écrire la conclusion correcte.
Une règle doit être partagée | Vérifier si elle est seulement en local ou en auto-mémoire. | Déplacer vers une mémoire projet versionnée.
Une règle doit être garantie | Vérifier si elle est seulement dans un fichier mémoire. | Créer une permission, un hook ou une politique gérée.
Un souvenir est faux | Ouvrir le dossier d’auto-mémoire depuis /memory. | Modifier ou supprimer le fichier Markdown concerné.
