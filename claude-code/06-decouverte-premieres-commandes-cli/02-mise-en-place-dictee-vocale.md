---
title: "Mise en place de la dictée vocale"
description: "Configurer et utiliser la dictée vocale dans Claude Code."
date: 2026-08-14
draft: true
tags:
  - claude-code
  - cli
  - voix
categories:
  - "Chapitre 6"
cours: Claude Code
chapitre: 06-decouverte-premieres-commandes-cli
leçon: 02-mise-en-place-dictee-vocale
statut: à revoir
etape_revision: 1
prochaine_revision: 2026-08-22
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Pourquoi utiliser la dictée vocale ? | Pas pour remplacer l'écriture, mais pour donner plus facilement du contexte riche : bug, règle métier, cas limite, intuition technique. |
| Pourquoi `hold` est-il recommandé en premier, alors que `tap` est plus rapide ? | `hold` impose un geste physique (presser/parler/relâcher) qui crée un point de pause naturel pour la relecture. `tap` réduit cette friction, donc le garde-fou, ce qui est risqué tant qu'on ne maîtrise pas encore son micro, son environnement et sa méthode de relecture. |
| Ambiguïté vs erreur de transcription : quelle différence ? | L'ambiguïté (ex: "le fichier JSON" quand il y en a plusieurs) existe même à l'écrit — ce n'est pas propre à la voix. L'erreur de transcription est spécifique à la dictée : la machine comprend mal ce qui a été dit, typiquement une négation avalée ("modifie" au lieu de "ne modifie pas") ou un nom de fichier déformé. |
| Où configurer la langue de dictée, et pourquoi l'emplacement compte ? | Dans `~/.claude/settings.json` (perso, toute machine) ou `.claude/settings.local.json` (perso, ce projet). Jamais dans `.claude/settings.json`, qui est partagé avec toute l'équipe et imposerait la langue à tout le monde. |
| Pourquoi "dicter en vrac puis demander une reformulation précise" est-il efficace ? | Ça sépare deux tâches : la voix capture le contexte librement (sans structure à retenir en parlant), puis Claude structure rigoureusement la demande (fichier, contraintes, vérification...) — sans sacrifier ni la fluidité ni la rigueur. |
| Que fait `/voice` ? | Active ou désactive la dictée selon l'état courant de la session. |
| Que fait `/voice hold` ? | Active le mode maintien : on tient la touche pendant qu'on parle, relâche pour insérer la transcription. |
| Que fait `/voice tap` ? | Active le mode appui : une pression démarre l'enregistrement, une seconde l'arrête. |
| Que fait `/voice off` ? | Désactive complètement la dictée. |
| Que fait `/config` ? | Sert notamment à régler la langue de dictée. |
| Que fait `/keybindings` ? | Permet de remapper le raccourci vocal (`voice:pushToTalk`) dans `~/.claude/keybindings.json`. |
| Que fait `/doctor` ici ? | Vérifie la configuration après une modification (langue, raccourci, environnement audio). |

## Synthèse
La dictée vocale (`/voice`) sert à donner du contexte plus riche à Claude Code, pas à remplacer la saisie. Le mode `hold` est le plus sûr car il force une relecture avant envoi ; le mode `tap` est plus rapide mais moins prudent ; le mode `off` coupe tout risque de déclenchement accidentel. La configuration (langue, raccourci) doit rester personnelle et ne jamais être imposée à toute une équipe via les settings partagés. Quelle que soit la méthode, la relecture avant envoi reste non négociable — en particulier sur les négations et les noms de fichiers, où une erreur de transcription peut inverser complètement l'intention du prompt.

## Glossaire
- **Dictée vocale (`/voice`)** : transcription de la voix dans l'invite de Claude Code, mélangeable avec la saisie clavier.
- **Mode `hold`** : mode maintien — on tient la touche pendant qu'on parle ; le plus contrôlé.
- **Mode `tap`** : mode appui — une pression démarre, une seconde arrête ; le plus rapide.
- **Mode `off`** : dictée désactivée ; le plus sûr en environnement bruyant ou sensible.
- **`voice:pushToTalk`** : action de raccourci clavier associée à la dictée, remappable via `/keybindings`.
- **`autoSubmit`** : option de configuration qui envoie automatiquement un prompt dicté sans confirmation manuelle — à garder désactivée sur les tâches de développement.
- **Settings personnels** : `~/.claude/settings.json` (global) ou `.claude/settings.local.json` (projet, non partagé).
- **Settings partagés** : `.claude/settings.json`, généralement commité et appliqué à toute l'équipe.
- **Erreur de transcription** : mauvaise interprétation de la voix par le moteur de dictée (ex: négation avalée, nom de fichier déformé) — distincte d'une simple ambiguïté de formulation.
- **Dictée brute → demande précise** : technique consistant à dicter le contexte librement puis demander à Claude de le restructurer en prompt rigoureux, sans encore exécuter la tâche.

## Questions d'auto-évaluation
1. Pourquoi la dictée vocale ne remplace-t-elle pas l'écriture ?
2. Pourquoi le mode `hold` est-il recommandé pour les premières sessions ?
3. Dans quel cas privilégier `/voice tap` plutôt que `/voice hold` ?
4. Quand utiliser `/voice off` ?
5. Quelle est la différence entre une ambiguïté de formulation et une erreur de transcription ?
6. Pourquoi une négation avalée par la dictée est-elle particulièrement dangereuse ?
7. Où faut-il configurer la langue de dictée, et pourquoi pas dans `.claude/settings.json` ?
8. Que permet l'option `autoSubmit`, et pourquoi la garder désactivée au début ?
9. Comment remapper la touche de dictée par défaut (`Space`) ?
10. Que vérifie `/doctor` après une modification de raccourci vocal ?
11. Quels critères définissent un bon raccourci de dictée ?
12. Pourquoi dicter une règle métier peut-il être plus efficace que la taper ?
13. En quoi la technique "dicter en vrac puis reformuler" est-elle plus efficace qu'une dictée directement structurée ?
14. Que doit-on toujours relire avant d'envoyer un prompt dicté ?
15. Quels outils faut-il installer pour la dictée sous Linux ou WSL ?

# Mise en place de la dictée vocale

**Durée : 15 minutes**

**Commande :** `/voice`

## Objectif de la leçon

La dictée vocale n'est pas un gadget de confort : c'est un moyen de donner à Claude Code un contexte plus riche et plus naturel qu'un prompt tapé à la va-vite. Cette leçon installe trois réflexes : choisir le bon mode (`hold`/`tap`/`off`) selon le niveau de risque de la tâche, configurer la voix à la bonne échelle (personnelle, jamais partagée par défaut), et surtout **toujours relire** avant d'envoyer — la voix accélère la saisie, jamais la vigilance.

---

# 1. Pourquoi dicter plutôt que taper

L'intérêt de la voix n'est pas la vitesse de frappe. C'est la capacité à **expliquer** plus naturellement ce qui est difficile à taper rapidement : un bug observé, une règle métier, un historique technique, une intuition.

```text
Écrit trop vite
        ↓
"corrige l'entrée vide"          → vague, Claude doit deviner

Dicté et relu
        ↓
"si le champ est vide, afficher
 un message explicite, sinon
 conserver le comportement"      → contexte complet
```

La dictée produit du texte dans le prompt — rien de plus. Elle ne touche jamais directement le projet. C'est toujours la relecture, puis l'envoi, qui déclenchent une vraie interaction avec Claude.

---

# 2. Les commandes de la leçon

```text
/voice           → active/désactive selon l'état courant
/voice hold       → mode maintien
/voice tap        → mode appui
/voice off        → désactive la dictée
/config           → régler la langue
/keybindings      → remapper le raccourci vocal
/doctor           → vérifier la configuration après modification
```

---

# 3. Choisir le bon mode : hold, tap ou off

```text
Tâche sensible / modification de code / première session
        │
        ▼
      hold        → geste physique (presser/parler/relâcher)
                     = point de pause forcé pour la relecture


Lecture seule / analyse longue / environnement de confiance
        │
        ▼
       tap         → rapide, pas de touche à maintenir
                     moins de garde-fou avant envoi


Réunion / bruit / projet sensible / dictée non nécessaire
        │
        ▼
       off         → aucun déclenchement accidentel
```

Après activation (`/voice`), le pied de page affiche une indication du type `hold Space to speak`. Sur macOS notamment, la première activation peut demander une autorisation d'accès au microphone.

---

# 4. Configurer la langue et la portée des réglages

La dictée suit le réglage de langue de Claude Code (`/config`, ou directement `"language": "fr"` dans un fichier de settings). Mais **où** on place ce réglage n'est pas neutre :

```text
~/.claude/settings.json         → global, PERSONNEL, toutes tes machines/projets
.claude/settings.local.json     → ce projet, PERSONNEL, non partagé (gitignored)
.claude/settings.json           → ce projet, PARTAGÉ, committé pour toute l'équipe
```

```text
"language": "fr" / voice.enabled / voice.mode
        │
        ▼
   c'est un choix PERSONNEL
        │
        ▼
   → ~/.claude/settings.json ou .claude/settings.local.json
   → JAMAIS .claude/settings.json (sauf convention d'équipe explicite)
```

Mettre la langue de dictée dans les settings partagés imposerait ta langue à tous tes coéquipiers dès qu'ils ouvrent le dépôt — même logique que `CLAUDE.md` vs `.claude/rules/` : bien choisir l'échelle évite de casser l'expérience des autres.

L'option `autoSubmit` mérite la même prudence :

```json
{
  "voice": {
    "enabled": true,
    "mode": "hold",
    "autoSubmit": false
  }
}
```

`autoSubmit: false` garde une relecture obligatoire — à conserver par défaut sur toute tâche de développement.

---

# 5. Remapper la touche de dictée

Par défaut, `Space` déclenche la dictée — pratique, mais parfois gênant pour la saisie normale. On peut remapper l'action `voice:pushToTalk` avec `/keybindings`, dans `~/.claude/keybindings.json` :

```json
{
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

Un bon raccourci est facile à déclencher volontairement, difficile à déclencher par accident : `meta+k`, `ctrl+k ctrl+v`. À éviter : lettres simples, `Caps Lock`, raccourcis déjà pris par `tmux` ou l'IDE. Après modification, `/doctor` vérifie qu'il n'y a pas de conflit.

---

# 6. Erreur de transcription vs ambiguïté — la distinction qui compte

```text
AMBIGUÏTÉ (existe aussi à l'écrit)
"regarde le fichier JSON"
        │
        ▼
plusieurs fichiers JSON dans le projet
        │
        ▼
Claude peut choisir le mauvais → problème de PRÉCISION, pas de dictée


ERREUR DE TRANSCRIPTION (spécifique à la voix)
Tu dis : "Ne modifie pas server.js"
        │
        ▼ (bruit, débit rapide, accent...)
Transcrit : "Modifie server.js"
        │
        ▼
Claude reçoit l'INVERSE exact de ton intention
```

Les deux risques exigent une relecture, mais pour des raisons différentes : l'un demande plus de précision dans le fond, l'autre demande de vérifier que la forme dictée correspond bien à ce qui a été dit — négations et noms de fichiers en tête.

---

# 7. Utiliser la voix pour enrichir les prompts

La voix est particulièrement utile pour :

```text
Expliquer un bug
→ contexte + observation + limite + demande claire, en lecture seule

Décrire une règle métier
→ plusieurs cas (vide / invalide / valide) racontés naturellement

Compléter un prompt déjà écrit
→ mélange saisie clavier + dictée dans le même message
```

### Technique : dicter en vrac, puis demander une reformulation précise

```text
Dicter en vrac (voix)
   → contexte fluide, rapide, aucune structure à retenir en parlant
        │
        ▼
"Transforme ce que je viens de dicter
 en demande précise. Ne réalise pas
 la modification. Rédige seulement
 la demande finale."
        │
        ▼
Claude structure :
  fichier ciblé · problème · contraintes
  vérification · définition de terminé
  ce qu'il ne faut pas modifier
        │
        ▼
Tu relis la demande structurée
        │
        ▼
Tu l'envoies (ou tu la corriges) dans une prochaine étape
```

Cette technique sépare deux tâches cognitives : la voix capture le contexte librement, Claude applique la rigueur de structuration — sans sacrifier ni la fluidité ni la précision.

---

# 8. Sécuriser les prompts dictés

La relecture est obligatoire avant toute tâche pouvant modifier le code. À vérifier systématiquement : noms de fichiers, noms de fonctions, commandes, **négations**, contraintes, autorisation/interdiction de modifier, définition de terminé, présence éventuelle de secrets.

On peut aussi demander à Claude une vérification explicite avant action :

```text
Avant de répondre à la demande précédente,
vérifie d'abord que tu as bien compris ma demande.
Réponds avec : ce que tu as compris, les fichiers
concernés, les actions autorisées/interdites, la
preuve attendue, les ambiguïtés éventuelles.
Ne modifie aucun fichier tant que je n'ai pas confirmé.
```

---

# 9. Cas particuliers Linux et WSL

```text
Linux  → si aucun outil audio disponible : installer SoX
         (ex: sudo apt-get install sox)

WSL    → audio via PulseAudio : ajouter le backend PulseAudio de SoX
         (ex: sudo apt install sox libsox-fmt-pulse)
         si ça ne marche toujours pas → Claude Code en Windows natif,
         ou vérifier que WSLg est disponible
```

---

# 10. Ancrage sur ta stack (web front/back JS-TS)

Sur un vrai projet front/back JS-TS, la dictée devient surtout utile pour :

- expliquer un bug d'intégration (ex: un état React qui ne se met pas à jour) — plus facile à raconter qu'à taper précisément ;
- décrire une règle métier avant de demander une implémentation (validations de formulaire, règles d'autorisation API) ;
- garder `hold` par défaut pour toute session touchant à du code partagé en équipe, et réserver `tap` aux explorations en lecture seule (ex: "explique-moi ce module") ;
- placer ta langue de dictée dans `~/.claude/settings.json` — jamais dans `.claude/settings.json` du dépôt, qui serait commité et imposé à toute l'équipe.

---

# Résumé & Schéma global

```text
/voice            Choisir le mode         Configurer          Dicter             Relire
(activer)     →   hold / tap / off    →   langue + portée  →  (contexte      →   (négations,
                  selon le risque         perso vs équipe      riche, fluide)     fichiers)
                                                                                      │
                                                                                      ▼
                                                                                   Envoyer
```

# Tableau des commandes à retenir

| Commande / réglage | Rôle |
|---|---|
| `/voice` | Active ou désactive la dictée selon l'état courant |
| `/voice hold` | Mode maintien — contrôlé, relecture forcée avant envoi |
| `/voice tap` | Mode appui — rapide, sans maintenir de touche |
| `/voice off` | Désactive la dictée |
| `/config` | Régler la langue de dictée |
| `/keybindings` | Remapper `voice:pushToTalk` dans `~/.claude/keybindings.json` |
| `/doctor` | Vérifier la configuration après modification (langue, raccourci, audio) |
| `"language": "fr"` | Réglage de langue — dans les settings **personnels** uniquement |
| `voice.autoSubmit: false` | Empêche l'envoi automatique d'un prompt dicté |

# Les 5 points les plus importants

## 1. La voix donne du contexte, elle ne remplace pas l'écriture
Elle est utile pour expliquer un bug, une règle métier ou un historique — pas pour aller plus vite sans réfléchir.

## 2. hold = contrôlé, tap = rapide, off = sûr
Le choix du mode dépend du niveau de risque de la tâche, pas seulement du confort.

## 3. Erreur de transcription ≠ ambiguïté de formulation
La première est spécifique à la voix (négations avalées, noms déformés) ; la seconde existe aussi à l'écrit.

## 4. La configuration de la voix est personnelle
Langue et préférences vont dans les settings perso (`~/.claude` ou `.local`), jamais dans les settings partagés de l'équipe.

## 5. Dicter en vrac puis reformuler sépare deux forces complémentaires
La fluidité de la voix pour capturer le contexte, la rigueur de Claude pour structurer la demande — sans sacrifier la relecture.

---

# Carte mentale

```text
Dictée vocale (/voice)
│
├── Modes
│   ├── hold   → contrôlé, relecture avant envoi
│   ├── tap    → rapide, moins de friction
│   └── off    → aucun déclenchement accidentel
│
├── Configuration
│   ├── /config           → langue de dictée
│   ├── settings.json      → voice.enabled / mode / autoSubmit
│   └── portée : perso (~/.claude, .local) vs équipe (.claude/settings.json)
│
├── Raccourci
│   ├── /keybindings        → voice:pushToTalk
│   ├── défaut : Space
│   └── alternative : meta+k, ctrl+k ctrl+v...
│
├── Usages
│   ├── expliquer un bug
│   ├── décrire une règle métier
│   └── dicter en vrac → demander une reformulation précise
│
├── Sécurité
│   ├── relire avant envoi (négations, noms de fichiers)
│   ├── demander une vérification du prompt à Claude
│   └── autoSubmit: false par défaut
│
└── Environnements
    ├── macOS   → autorisation micro
    ├── Linux   → installer SoX
    └── WSL     → backend PulseAudio de SoX
```

---

# Mini fiche de révision

```text
/voice             → activer/désactiver selon l'état
/voice hold         → contrôlé (1res sessions, tâches sensibles)
/voice tap          → rapide (lecture seule, prompts longs)
/voice off          → réunion / bruit / fin de session
/config             → langue de dictée
/keybindings        → remapper voice:pushToTalk
/doctor             → vérifier après toute modification
RELIRE toujours     → négations + noms de fichiers
autoSubmit: false   → sécurité par défaut
langue de dictée    → settings PERSO, jamais settings d'équipe
```

## Phrase à retenir

> La voix donne du contexte plus vite que le clavier, mais jamais plus vite que la relecture qui doit précéder l'envoi.
