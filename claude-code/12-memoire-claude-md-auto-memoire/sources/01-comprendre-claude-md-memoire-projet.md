CLAUDE.md est le fichier dans lequel un projet donne à Claude Code des instructions persistantes. Il sert à transmettre ce que l’équipe ne veut pas répéter à chaque session : contexte du projet, commandes utiles, conventions propres à la base de code, contraintes de workflow, décisions architecturales et pièges connus.
CLAUDE.md est une mémoire explicite. Il est écrit par les humains, stocké en Markdown, lisible dans le dépôt, modifiable en revue de code et versionnable avec le reste du projet. Avec la mémoire automatique, ce sont les deux mécanismes qui transportent des connaissances d’une session à l’autre : le premier est écrit par vous, le second est écrit par Claude à partir de vos corrections et préférences.
Cette mémoire n’est pas une base de données opaque. C’est une mémoire transparente basée sur des fichiers : vous pouvez lire, éditer, supprimer et versionner les instructions que l’agent voit. Cette transparence est un compromis assumé : moins sophistiqué qu’un système de recherche vectorielle, mais beaucoup plus auditable pour une équipe de développement.

Ce que CLAUDE.md change dans une session
Une session ne repart pas sans mémoire de projet
Chaque session commence avec une nouvelle fenêtre de contexte, mais elle peut recevoir des connaissances persistantes. Les fichiers CLAUDE.md applicables, la mémoire automatique, certains noms d’outils, les descriptions de skills et d’autres éléments de configuration peuvent entrer dans le contexte avant même que l’utilisateur ne pose sa première question.
Cela signifie que Claude Code ne dépend pas seulement de ce que vous tapez dans le prompt courant. Il dépend aussi de ce qui est déjà chargé comme contexte de projet. Un bon CLAUDE.md améliore donc les premières décisions de la session : quelles commandes utiliser, quels fichiers éviter, quel style respecter, quels patterns suivre, quelles erreurs récurrentes ne pas reproduire.

Un fichier de contexte, pas une règle mécanique
CLAUDE.md est chargé dans la fenêtre de contexte, sous forme de message fourni après le prompt système. Il influence le comportement de Claude, mais il ne constitue pas une configuration imposée. CLAUDE.md et la mémoire automatique sont traités comme du contexte ; pour bloquer une action indépendamment de ce que Claude décide, il faut une couche de contrôle comme les permissions ou un hook PreToolUse.
Cette distinction doit rester claire. Écrire dans CLAUDE.md « ne lis jamais les fichiers .env » aide Claude à se comporter correctement, mais ne bloque pas techniquement la lecture. Pour une interdiction déterministe, il faut une règle de permission, un hook ou un sandbox. CLAUDE.md guide ; les permissions contrôlent.

La fonction exacte de CLAUDE.md
Réduire la répétition
Le premier rôle de CLAUDE.md est de supprimer les explications répétées. Si vous devez rappeler à Claude les mêmes commandes, les mêmes conventions ou les mêmes limites à chaque session, cette information appartient probablement à une mémoire de projet.

A mettre dans CLAUDE.md :
commande de test officielle ;
commande de typecheck ;
convention de nommage propre au projet ;
structure reelle du depot ;
workflow de pull request ;
piege recurrent ;
pattern nouveau a preferer ;
ancien pattern a ne plus copier.

Ajoutez une information à CLAUDE.md lorsque Claude refait la même erreur, lorsqu’une revue de code signale une chose qu’il aurait dû savoir, lorsque vous retapez la même clarification que dans une session précédente, ou lorsqu’un nouveau coéquipier aurait besoin du même contexte pour être productif.

Stabiliser les conventions propres au projet
Un projet contient souvent des conventions que Claude ne peut pas déduire avec certitude à partir du code. Par exemple : la commande de test réellement utilisée en CI, la manière de lancer Redis localement, une convention de migration, une règle de compatibilité, une préférence d’équipe sur les PR, ou une zone du dépôt partiellement migrée.
La mémoire est particulièrement utile quand le code contient plusieurs patterns concurrents. Une base partiellement migrée est dangereuse pour un agent : Claude peut voir l’ancien pattern dans certains fichiers et le reproduire au lieu d’utiliser le nouveau. CLAUDE.md doit alors rendre l’état de transition explicite.

Le projet est en migration progressive.
Ancien pattern :
ne plus creer de nouveaux services avec l'ancien client
Nouveau pattern :
utiliser le client dans src/lib/http-client.ts.
Etat actuel :
les modules billing et auth sont migres.
les modules admin et reports contiennent encore l'ancien

Créer une mémoire partagée par l’équipe
Un CLAUDE.md de projet peut être placé à la racine du projet ou dans .claude/CLAUDE.md. Ces fichiers contiennent les instructions partagées par l’équipe, par exemple les commandes de compilation, les instructions de test, les normes de codage, les décisions architecturales et les workflows courants.
Cette mémoire doit être traitée comme une partie du projet. Elle doit être revue, nettoyée et ajustée quand le code change. Une instruction obsolète dans CLAUDE.md peut être aussi nuisible qu’une documentation obsolète : elle oriente Claude vers un comportement qui n’est plus correct.

CLAUDE.md et fenêtre de contexte
La mémoire consomme du contexte
Les fichiers CLAUDE.md sont chargés dans la fenêtre de contexte et consomment des tokens avec le reste de la conversation. Gardez-les spécifiques, concis et structurés, avec une cible inférieure à 200 lignes par fichier, parce que les fichiers trop longs consomment davantage de contexte et réduisent l’adhérence des instructions.
Un bon CLAUDE.md n’est pas exhaustif. Il ne doit pas devenir un manuel complet du projet. Il doit contenir les informations qui changent réellement les décisions de Claude.

Le contexte de démarrage doit rester utile
Un fichier trop long a deux effets négatifs. D’abord, il occupe une partie de la fenêtre de contexte avant même que la tâche commence. Ensuite, il dilue les instructions importantes dans un bruit documentaire. Claude peut mieux suivre une règle courte, concrète et vérifiable qu’une longue section vague ou redondante.

Instruction faible :
respecte le style du projet.
Instruction utile :
utilise pnpm, pas npm.
lance pnpm test:unit pour les tests unitaires.
les nouveaux endpoints doivent passer par src/api/router
ne cree pas de nouvelle abstraction sans test cible.

La mémoire doit être suffisamment courte pour être lue, suffisamment précise pour être suivie, et suffisamment stable pour mériter d’être chargée à chaque session.

CLAUDE.md et mémoire automatique
Deux mémoires complémentaires
CLAUDE.md et la mémoire automatique ne remplissent pas le même rôle. CLAUDE.md est écrit par les humains et sert aux instructions explicites. La mémoire automatique est écrite par Claude lorsqu’il juge qu’une correction, une préférence ou une observation peut être utile dans une conversation future. Elle accumule des apprentissages découverts pendant le travail : commandes de build, observations de débogage, notes d’architecture, préférences de style, habitudes de workflow. La mémoire automatique nécessite Claude Code v2.1.59 ou ultérieur et est active par défaut.

Mécanisme | Qui écrit | Usage principal
---|---|---
CLAUDE.md | Humain ou équipe | Instructions durables, conventions, contexte projet.
Mémoire automatique | Claude | Apprentissages issus des corrections, préférences et habitudes observées.

La mémoire automatique reste à surveiller
La mémoire automatique peut être utile, mais elle ne doit pas devenir une couche invisible que personne ne relit. Les fichiers de mémoire automatique sont du Markdown brut, lisible, modifiable et supprimable, et /memory permet de parcourir les fichiers chargés et d’ouvrir le dossier de mémoire automatique.
Il faut retenir que CLAUDE.md est la mémoire explicite de l’équipe, tandis que la mémoire automatique est une mémoire locale, propre à vous et au projet, qui demande une relecture régulière.

Ce qui appartient à CLAUDE.md
Information non évidente
CLAUDE.md doit contenir ce que Claude ne peut pas inférer de manière fiable en lisant quelques fichiers. Une règle qui est déjà évidente dans le code ne mérite pas forcément d’être répétée. Une contrainte qui ne se voit pas dans le code, elle, doit être écrite.

À mettre | Pourquoi
---|---
Commandes de build, test et typecheck | Claude ne sait pas toujours quelle commande est officielle.
Conventions PR et revue | Elles vivent souvent hors du code.
Architecture spécifique | Elle donne une carte de décision rapide.
Gotchas d’environnement | Ils évitent les erreurs répétées.
Patterns en migration | Ils empêchent Claude de recopier un ancien style.

Information trop longue ou trop locale
Déplacez une procédure multi-étapes ou une instruction qui ne concerne qu’une partie de la base de code vers une skill ou une règle limitée au chemin, plutôt que de grossir CLAUDE.md. Les skills se chargent seulement quand elles sont utilisées, ce qui rend les longs workflows moins coûteux qu’un gros fichier de mémoire chargé à chaque session.

A eviter dans le CLAUDE.md principal :
documentation API complete ;
tutoriel interne complet ;
description fichier par fichier ;
longue checklist de release ;
historique de decisions anciennes ;
copie de README deja disponible ;
instructions propres a un seul dossier.

Le fichier principal doit rester un noyau de mémoire, pas une archive. Les contenus longs doivent être déplacés vers des fichiers dédiés, des règles conditionnelles, des notes de projet ou des skills.

Ce que CLAUDE.md n’est pas
Ce n’est pas une permission
CLAUDE.md ne doit pas servir à remplacer les règles de permissions. Pour bloquer un outil, une commande ou un chemin, utilisez une configuration de permissions, des hooks ou des paramètres gérés plutôt que de compter uniquement sur les instructions.

Ce n’est pas une documentation exhaustive
Un fichier qui tente de tout expliquer devient vite contre-productif. Claude peut lire les fichiers, chercher dans le dépôt et utiliser les outils disponibles. CLAUDE.md doit donc donner les informations de cadrage, pas recopier ce que les outils peuvent obtenir au moment utile.

Ce n’est pas une mémoire personnelle d’équipe
Un CLAUDE.md partagé ne doit pas contenir les préférences d’un seul développeur. Les préférences personnelles appartiennent à la mémoire utilisateur (~/.claude/CLAUDE.md) ou à un fichier local. Le fichier local CLAUDE.local.md est automatiquement ajouté au .gitignore et convient aux notes privées qui n’ont pas à être partagées.

Qualité d’un bon CLAUDE.md
Court
Un bon CLAUDE.md est court parce qu’il est chargé souvent. Il doit pouvoir être lu rapidement par un humain en revue de code. Si personne ne veut le relire, il deviendra obsolète.

Spécifique
Une bonne instruction doit être vérifiable. « Suis les bonnes pratiques » n’est pas une règle exploitable. « Utilise pnpm, lance pnpm test:unit, et ne crée pas de migration sans fichier de test associé » est beaucoup plus utile.

Actuel
La mémoire doit évoluer avec le projet. Une règle écrite pour compenser une limitation d’un ancien modèle ou une ancienne architecture peut devenir inutile. Réexaminez les fichiers CLAUDE.md, les fichiers imbriqués et les règles pour supprimer les instructions obsolètes ou conflictuelles : si deux fichiers donnent des consignes différentes pour le même comportement, Claude peut en choisir une arbitrairement.

Testé par le comportement réel
Une instruction n’est utile que si elle modifie effectivement le comportement de Claude. Si Claude continue à refaire la même erreur, la règle est peut-être trop vague, trop enfouie, contradictoire, mal placée, ou mieux adaptée à une permission, un hook ou une skill.

Premier protocole de travail
Créer une mémoire minimale

Commencer avec un CLAUDE.md court.
Inclure :
commandes de test ;
commande de typecheck ;
structure du projet ;
patterns a suivre ;
patterns a eviter ;
contraintes de PR ;
pieges connus.
Exclure :
documentation longue ;
descriptions evidentes ;
tutoriels ;
historique ancien ;
regles propres a un seul dossier.

Auditer au démarrage
/memory
Verifier :
quels fichiers CLAUDE.md sont charges ;
si la memoire automatique est active ;
si des fichiers locaux influencent la session ;
si une regle attendue est absente.

/memory liste les fichiers CLAUDE.md, CLAUDE.local.md et les règles chargés dans la session, permet de basculer la mémoire automatique et fournit un accès au dossier de mémoire automatique. C’est aussi la commande pour vérifier quels fichiers de mémoire se sont chargés au démarrage, et pour ouvrir l’un d’eux directement dans votre éditeur.

Erreurs fréquentes
Mettre trop d’informations
Un CLAUDE.md trop long augmente le coût de contexte et réduit la lisibilité. Si une section devient une procédure détaillée, elle doit probablement devenir une skill ou une règle conditionnelle.

Écrire des règles vagues
Les instructions générales produisent une adhérence faible. Remplacez les intentions vagues par des actions concrètes, des chemins précis et des commandes réelles.

Utiliser CLAUDE.md pour interdire
Une interdiction critique doit être déplacée vers les permissions, les hooks, le sandbox ou une politique gérée. CLAUDE.md peut rappeler la règle, mais ne doit pas être la seule barrière.

Ne jamais nettoyer
Une mémoire qui ne se nettoie pas devient une dette contextuelle. Les règles obsolètes, les doublons et les compensations d’anciens modèles doivent être supprimés.

Ignorer les migrations partielles
Quand un projet contient un ancien et un nouveau pattern, Claude peut reprendre l’ancien s’il est encore visible dans le code. CLAUDE.md doit indiquer explicitement quel pattern est désormais préféré.
