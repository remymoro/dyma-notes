---
title: "Histoire d'Anthropic et de Claude"
description: "Découverte de l'histoire d'Anthropic, de ses fondateurs et de la création de la gamme de modèles Claude."
date: 2026-08-14
draft: true
tags:
  - anthropic
  - claude
categories:
  - "Chapitre 1"
cours: Claude Code
chapitre: 01-introduction-anthropic-claude-code
leçon: 02-histoire-anthropic-et-claude
statut: à revoir
etape_revision: 0
prochaine_revision: 2026-08-23
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Fondation & origine | Fondée en **2021** par Dario Amodei, Daniela Amodei et plusieurs ex-OpenAI. Départ motivé par un désaccord sur la vitesse de déploiement et la place de la sécurité dans le développement des modèles. |
| Chiffres clés (mars 2026) | ARR ~30 Md$ · Valorisation ~380 Md$ · Croissance ~x10/an sur plusieurs années consécutives |
| Dario Amodei | Physique (Caltech/Stanford) → Biophysique (Princeton) → Google Brain → VP Research OpenAI (GPT-2, GPT-3, scaling laws) → CEO Anthropic 2021 |
| Daniela Amodei | Rôle opérationnel : recrutement, partenariats, sécurité, développement commercial. Transforme un labo de recherche en entreprise B2B à grande échelle. |
| Pourquoi Anthropic existe | La sécurité doit être **intégrée dès la conception**, pas ajoutée comme un filtre à la fin. Disagreement de fond avec OpenAI sur ce principe. |
| Mission en 3 mots | **Fiable** (réduire les erreurs graves) · **Interprétable** (comprendre le fonctionnement interne) · **Orientable** (guider et contraindre selon des règles métier) |
| Constitutional AI | Alignement guidé par une **constitution** de principes explicites que le modèle utilise pour corriger ses propres réponses. |
| Statut juridique | **PBC** (Public Benefit Corporation) + **Long-Term Benefit Trust** : protège la mission d'intérêt public contre les pressions purement financières. |
| Positionnement commercial | **B2B ~80 %** · 300 000+ clients entreprise · Conformité : SOC 2 Type II, HIPAA/BAA, GDPR, Zero Data Retention. |
| 4 différenciateurs Claude | 1. Sécurité stricte · 2. Qualité rédactionnelle & raisonnement · 3. Écosystème agentique (MCP, Claude Code) · 4. Conformité Enterprise |

## Synthèse
Anthropic est née en 2021 d'une scission avec OpenAI sur les priorités d'alignement et de sécurité de l'IA. Dirigée par Dario et Daniela Amodei, l'entreprise s'est structurée comme une Public Benefit Corporation (PBC) axée sur le marché B2B. L'innovation majeure réside dans la *Constitutional AI*, un mode d'entraînement qui donne à Claude une éthique native et une grande orientabilité pour les entreprises.

## Glossaire
- **Constitutional AI** : Méthode d'entraînement où le modèle auto-évalue et corrige ses réponses selon une constitution de principes explicites.
- **PBC (Public Benefit Corporation)** : Statut juridique américain imposant de concilier la recherche de profit avec une mission d'intérêt public.
- **Orientabilité** : Capacité d'un modèle à respecter strictement des consignes, règles métiers et limites définies par l'utilisateur.
- **Zero Data Retention** : Engagement contractuel garantissant que les données transmises à l'API ne sont ni stockées ni utilisées pour le ré-entraînement.

## Questions d'auto-évaluation
1. Quel désaccord majeur a provoqué le départ des fondateurs d'OpenAI pour créer Anthropic en 2021 ?
2. En quoi la *Constitutional AI* se distingue-t-elle des méthodes de modération classiques par filtres externes ?
3. Pourquoi le statut de *Public Benefit Corporation* (PBC) est-il stratégique pour les clients entreprise d'Anthropic ?
4. Quels sont les 3 mots-clés qui résument la mission technique d'Anthropic ?

# Histoire d'Anthropic et de Claude

## Objectif de la leçon
Comprendre l'origine d'Anthropic, la philosophie de conception de la famille Claude, et les choix d'architecture éthique et juridique qui façonnent le comportement des modèles.

---

# 1. Genèse et Fondateurs

Anthropic a été créée en 2021 par un groupe d'anciens dirigeants de recherche d'OpenAI :

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                          ORIGINE D'ANTHROPIC                            │
│                                                                         │
│   Dario Amodei (ex-VP Research OpenAI)  ──┐                             │
│                                           ├──> Fondation d'Anthropic (2021)
│   Daniela Amodei (ex-VP Ops OpenAI)    ──┘    Objectif : Sécurité native│
└─────────────────────────────────────────────────────────────────────────┘
```

Les fondateurs estimaient que la course au scaling sans garanties de sécurité suffisantes exposait les entreprises et la société à des risques majeurs.

---

# 2. La philosophie "Constitutional AI"

Contrairement aux approches traditionnelles où des filtres sont ajoutés *après* l'entraînement (RLHF classique), Anthropic intègre une **Constitution** lors du processus d'apprentissage :

1. Le modèle génère une réponse initiale.
2. Il évalue sa réponse par rapport à un ensemble de principes constitutionnels.
3. Il réécrit sa réponse pour la rendre conforme avant la publication.

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                      CONSTITUTIONAL AI IN A NUTSHELL                    │
│                                                                         │
│   [Prompt] ──> [Réponse brute] ──> [Évaluation vs Constitution]         │
│                                                   │                     │
│   [Réponse finale conforme] <── [Auto-correction] ┘                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

# 3. Structure d'Entreprise et Positionnement B2B

Anthropic s'est constituée en **PBC** (*Public Benefit Corporation*) épaulée par le *Long-Term Benefit Trust*. Ce montage juridique empêche les investisseurs de forcer l'entreprise à compromettre la sécurité au profit d'un gain financier rapide.

* **Revenus B2B** : Plus de 80% de l'activité cible les grands comptes.
* **Garanties** : Certification SOC 2 Type II, zéro rétention de données (Zero Data Retention) et conformité GDPR/HIPAA.

---

# Résumé & Schéma global

```text
                   ÉCOSYSTÈME & FONDATIONS ANTHROPIC
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼                          ▼                          ▼
 Fondateurs (2021)        Constitutional AI          Structure PBC & B2B
(Dario & Daniela Amodei)  (Sécurité par design)     (Sécurité juridique)
```

# Tableau des faits clés

| Élément | Détail |
|---|---|
| **Création** | 2021 par les frères/sœurs Amodei (ex-OpenAI). |
| **Méthode d'alignement** | Constitutional AI (principes explicites d'auto-correction). |
| **Modèle économique** | Priorité B2B (SOC 2, GDPR, Zero Data Retention). |
| **Gouvernance** | Public Benefit Corporation (PBC) + Trust de contrôle. |

# Les 5 points les plus importants

1. **Anthropic est née d'une scission d'OpenAI** centrée sur la priorité accordée à la sécurité.
2. **Dario et Daniela Amodei** pilotent la vision scientifique et opérationnelle de l'entreprise.
3. **La Constitutional AI** permet au modèle de s'auto-évaluer selon des règles morales et techniques.
4. **La structure PBC** protège juridiquement la mission d'alignement contre les pressions boursières.
5. **Le positionnement B2B** garantit la confidentialité stricte des données utilisateurs.

---

# Carte mentale

```text
Histoire d'Anthropic & Claude
│
├── Origine (2021)
│   ├── Dario & Daniela Amodei
│   └── Scission OpenAI sur la sécurité
│
├── Innovation Technique
│   ├── Constitutional AI
│   └── Mission : Fiable, Interprétable, Orientable
│
└── Modèle d'Entreprise
    ├── Statut PBC & Trust
    └── Orientation B2B & Conformité
```

---

# Mini fiche de révision

```text
2021              → Création d'Anthropic
Constitutional AI → Auto-correction par principes
PBC               → Entreprise à mission d'intérêt public
B2B               → Focus entreprise (Zero Data Retention)
```

> **Phrase à retenir** : Chez Anthropic, la sécurité de l'IA n'est pas un filtre ajouté à la fin, mais la constitution même qui régit le modèle dès son entraînement.
