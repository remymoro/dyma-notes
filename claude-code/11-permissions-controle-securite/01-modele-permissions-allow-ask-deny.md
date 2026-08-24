---
title: "Le modèle de permissions"
description: "Comprendre le fonctionnement et la priorité des permissions allow, ask et deny."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - securite
  - permissions
categories:
  - "Chapitre 11"
cours: Claude Code
chapitre: 11-permissions-controle-securite
leçon: 01-modele-permissions-allow-ask-deny
statut: à revoir
etape_revision: 0
prochaine_revision:
---

| Indices / questions clés | Notes détaillées |
|---|---|
| **Quelle est la frontière entre Claude et le système ?** | Le modèle produit une *demande d'outil* (une intention). C'est le *harness* (Claude Code) qui vérifie les permissions et exécute. |
| **Quels sont les trois niveaux de décision ?** | `allow` (préautorisation pour actions sûres/fréquentes), `ask` (validation humaine pour actions contextuelles), `deny` (blocage par principe pour actions dangereuses). |
| **Dans quel ordre les permissions sont-elles évaluées ?** | L'ordre est strict : **1. deny, 2. ask, 3. allow**. Un refus l'emporte toujours, même si une autorisation plus spécifique existe. |
| **Les instructions du prompt remplacent-elles les permissions ?** | Non. `CLAUDE.md` conseille, les permissions *contrôlent*. Une interdiction dans un prompt n'est pas une barrière déterministe. |
| **Pourquoi ne pas tout mettre en `ask` ?** | Pour éviter la "fatigue de validation". L'humain finit par dire oui par réflexe. Il faut placer la friction (le blocage) au bon endroit. |
| **Que se passe-t-il après un `deny` ?** | La boucle ne s'arrête pas forcément. Le refus revient comme une *observation* pour Claude, qui peut alors proposer une autre trajectoire compatible (ex: utiliser un mock au lieu de lire un secret). |

## Synthèse
Le modèle de sécurité de Claude Code sépare la réflexion du modèle de l'exécution système via un mécanisme de permissions basé sur les outils. Trois décisions structurent cette frontière : `deny` pour protéger strictement, `ask` pour conserver l'arbitrage humain sur des actions ambiguës, et `allow` pour fluidifier les actions répétitives et sûres (afin d'éviter la fatigue de validation). L'ordre d'évaluation est inflexible (`deny` l'emporte toujours sur `allow`). Surtout, une permission bien calibrée n'est pas qu'un blocage : c'est un moyen de réorienter la réflexion de l'agent vers une stratégie autorisée, sans stopper brutalement la session.

## Fiche finale — Distinctions et pièges (À revoir)

| Notion | Distinction / Piège à éviter |
|---|---|
| **Priorité des permissions** | La catégorie de décision l'emporte toujours : `deny > ask > allow`. Une règle `allow` précise ne contournera jamais une règle `deny` plus large. |
| **Hook `PreToolUse`** | Un code de sortie `2` signifie **arrêt immédiat** (avant même l'évaluation des permissions), cela ne veut pas dire `ask`. |
| **Permission vs Sandbox** | Permission = **autorisation** d'agir. Sandbox = **isolation** des effets d'une action en cours d'exécution. |
| **`Read` vs `WebFetch`** | `Read` concerne les fichiers locaux, `WebFetch` concerne les ressources Web externes. |
| **`CLAUDE.md`** | Ce sont des instructions, pas des barrières techniques. Elles orientent, elles ne bloquent pas. |

## Questions d'auto-évaluation
1. Si une règle `deny` globale bloque tous les accès AWS, une règle `allow` spécifique pour `aws s3 ls` peut-elle passer ?
2. Une règle écrite dans `CLAUDE.md` suffit-elle pour bloquer l'accès à un fichier de secrets ?
3. Le sandbox et les permissions font-ils la même chose ?
4. Que fait le modèle lorsqu'il rencontre un refus d'exécution sur un outil ?

# Le modèle de permissions (allow, ask, deny)

**Durée : 10 minutes**

## Objectif de la leçon
Comprendre que Claude ne touche pas directement au système, assimiler la logique implacable de l'ordre d'évaluation des permissions, et apprendre à placer la friction (les blocages) au bon endroit pour éviter la dangereuse "fatigue de validation".

---

# 1. Le modèle : une séparation fondamentale

**Le modèle (Claude) ne touche pas directement au système.**
Il génère uniquement des intentions (demandes d'outils). C'est le *harness* de Claude Code qui intercepte, vérifie les règles, exécute et renvoie le résultat.

Les permissions ne sont donc pas des préférences d'affichage, ce sont des **frontières d'exécution**.

---

# 2. Les trois décisions fondamentales

Le modèle de sécurité repose sur trois piliers, qui ont chacun un rôle très précis :

1. **`allow` (La Fluidité)**
   - **Rôle :** Préautorisation pour des actions sûres et prévisibles (ex: lancer un lint, lire des fichiers).
   - **Piège :** Ne jamais l'utiliser comme confiance globale pour rendre la session "silencieuse".
2. **`ask` (L'Arbitrage)**
   - **Rôle :** Validation humaine pour les actions utiles mais contextuelles (ex: faire un commit, modifier la config).
   - **Piège :** Le mettre partout provoque la "fatigue de validation".
3. **`deny` (La Protection Forte)**
   - **Rôle :** Blocage par principe pour les secrets ou actions destructrices.
   - **Piège :** Un refus trop large peut paralyser l'agent.

> [!IMPORTANT]
> **L'ordre d'évaluation est implacable**
> L'ordre d'évaluation est TOUJOURS : `deny` > `ask` > `allow`.
> Un refus l'emporte toujours, même si une règle `allow` située plus bas semble plus spécifique. **Un refus large ne se contourne pas par une autorisation étroite.**

---

# 3. Instruction n'est pas Permission

- **Les instructions (`CLAUDE.md`) conseillent.** Elles orientent l'intention du modèle ("ne lis pas les secrets").
- **Les permissions contrôlent.** Elles garantissent physiquement le blocage.

Si une action doit être impossible, l'écrire dans un prompt ne suffit pas : il faut une règle de permission (ou un hook/sandbox).

---

# 4. Le refus comme observation

Un `deny` n'est pas un crash.
Dans la boucle agentique, quand une action est refusée, le refus est renvoyé à Claude comme une *observation*. Un refus bien formulé (indiquant pourquoi) permet à Claude de comprendre et de proposer une autre trajectoire (ex: "Je ne peux pas lire la base de prod, je vais demander à l'utilisateur de me créer un mock local").

---

# 5. Permissions vs Sandbox

- **Les permissions** vérifient si Claude a le droit de *demander* l'utilisation d'un outil.
- **Le sandbox** isole les conséquences de l'outil *pendant son exécution* au niveau du système d'exploitation.

Les deux sont complémentaires. Une action peut être autorisée par les permissions, mais bloquée par le sandbox.

---

# Carte mentale finale

```text
                    PERMISSIONS
                         │
        frontière entre intention et exécution
                         │
          ┌──────────────┼──────────────┐
          │              │              │
        ALLOW           ASK            DENY
          │              │              │
    préautoriser      validation       bloquer
                         │
              PRIORITÉ DES RÈGLES
                         │
                deny > ask > allow
                         │
                  SURFACE D'OUTILS
                         │
      ┌────────┬─────────┼──────────┬────────┐
     Read     Edit      Bash     WebFetch   MCP
      │        │          │          │
   lecture modification commandes    Web
                         │
                       Agent
                         │
                    sous-agents
```
CLAUDE.md
→ instructions
→ guide Claude
→ ne constitue pas une barrière technique

Modes de permission
→ autonomie générale de la session

Hooks
→ contrôles programmables
→ PreToolUse exit 2 = blocage avant permissions

Sandbox
→ isolation de l'exécution

/permissions
→ observer et gérer la politique active
---

# Le Workflow à retenir (Mini fiche de révision)

```text
■ Les couches de sécurité
- CLAUDE.md → instructions qui orientent, pas de blocage technique.
- Modes de permission → autonomie générale de la session.
- Hooks → contrôles programmables (PreToolUse exit 2 = blocage avant permissions).
- Sandbox → isolation de l'exécution au niveau système.
- /permissions → observer et gérer la politique active.
```

> **Les phrases centrales de la leçon :**
> - *Claude propose → Claude Code autorise → l’outil exécute.*
> - *allow = préautoriser · ask = demander · deny = bloquer.*
