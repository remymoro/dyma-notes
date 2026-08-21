# Étendre les capacités de Claude Code

Étendre Claude Code ne signifie pas seulement lui ajouter des commandes ou des intégrations. Cela consiste à modifier la manière dont il connaît un projet, dont il accède aux systèmes externes, dont il automatise certains événements, dont il délègue le travail et dont il réutilise des procédures spécialisées.

Claude Code dispose déjà d’outils intégrés pour lire, rechercher, modifier, exécuter des commandes et accéder au web. La couche d’extension intervient lorsque ces outils génériques ne suffisent plus : lorsque le projet possède des conventions stables, lorsqu’une procédure revient souvent, lorsqu’un service externe doit être interrogé, lorsqu’une tâche secondaire doit être isolée, ou lorsqu’une règle doit s’appliquer de manière déterministe.

Une extension n’est donc pas un ajout décoratif. C’est une modification de la surface opérationnelle de Claude Code. Elle change ce que le système voit, ce qu’il peut appeler, ce qu’il peut automatiser, ce qu’il peut déléguer ou ce qu’il peut distribuer à d’autres projets.

La question centrale n’est pas : « comment ajouter le plus de fonctionnalités possible ? » La question correcte est : à quel endroit de la boucle faut-il intervenir ? Certaines extensions agissent sur le contexte, d’autres sur les outils, d’autres sur le cycle de vie, d’autres sur l’isolation du travail, d’autres encore sur la distribution et la réutilisation en équipe.

## L’extension comme couche au-dessus des outils intégrés

### Les outils intégrés couvrent le socle

Les outils intégrés de Claude Code couvrent les opérations fondamentales : lire un fichier, chercher dans un dépôt, éditer, écrire, exécuter une commande, interroger une URL, rechercher sur le web, inspecter le code avec un serveur de langage, ou déléguer à un agent. Ce socle permet déjà de traiter une grande partie des tâches de développement.

La couche d’extension ne remplace pas ce socle. Elle l’oriente, le spécialise ou l’augmente. Un `CLAUDE.md` peut indiquer comment utiliser les outils dans ce projet. Une skill peut encapsuler une procédure réutilisable. Un serveur MCP peut ajouter de nouveaux outils. Un hook peut imposer une vérification après usage d’un outil. Un subagent peut utiliser les outils dans un contexte isolé. Un plugin peut empaqueter tout cela pour plusieurs projets.

L’extension est donc une couche de spécialisation, pas une seconde architecture parallèle. Elle se connecte à la boucle existante et modifie certains de ses points d’entrée : contexte, outils, événements, délégation ou packaging.

### Le bon mécanisme dépend du point d’injection

Chaque mécanisme d’extension répond à une question différente. Si Claude doit toujours connaître une convention, on utilise un fichier d’instructions persistant. S’il doit parfois charger une procédure longue, on utilise une skill. S’il doit accéder à un système externe, on utilise MCP. S’il faut exécuter quelque chose à chaque événement, on utilise un hook. S’il faut préserver le contexte principal, on utilise un subagent. S’il faut partager une configuration complète, on utilise un plugin.

<div style="border: 2px solid #6366f1; border-radius: 12px; padding: 20px; background-color: #eef2ff; color: #3730a3; font-size: 0.95em;">
  <ul style="list-style-type: none; padding-left: 0; margin: 0; line-height: 1.8;">
    <li><strong>Convention permanente</strong> &rarr; <code>CLAUDE.md</code> ou <code>.claude/rules/</code></li>
    <li><strong>Procédure réutilisable</strong> &rarr; <code>Skill</code></li>
    <li><strong>Système externe</strong> &rarr; <code>MCP</code></li>
    <li><strong>Navigation sémantique code</strong> &rarr; <code>Code intelligence</code></li>
    <li><strong>Travail isolé</strong> &rarr; <code>Subagent</code></li>
    <li><strong>Travail multi-session</strong> &rarr; <code>Agent team</code></li>
    <li><strong>Automatisation déterministe</strong> &rarr; <code>Hook</code></li>
    <li><strong>Distribution réutilisable</strong> &rarr; <code>Plugin</code> ou <code>marketplace</code></li>
  </ul>
</div>

