---
title: "Histoire d'Anthropic et de Claude"
description: "Découverte de l'histoire d'Anthropic et de la création de Claude."
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
prochaine_revision: 2026-08-15
---

| Indices / questions clés | Notes détaillées |
|---|---|
| Fondation & origine | Fondée en **2021** par Dario Amodei, Daniela Amodei et plusieurs ex-OpenAI. Départ motivé par un désaccord sur la vitesse de déploiement et la place de la sécurité dans le développement des modèles. |
| Chiffres clés (mars 2026) | ARR ~30 Md$ · Valorisation ~380 Md$ · Croissance ~x10/an sur plusieurs années consécutives |
| Dario Amodei | Physique (Caltech/Stanford) → Biophysique (Princeton) → Google Brain → VP Research OpenAI (GPT-2, GPT-3, scaling laws) → CEO Anthropic 2021 |
| Daniela Amodei | Rôle opérationnel : recrutement, partenariats, sécurité, développement commercial. Transforme un labo de recherche en entreprise B2B à grande échelle. |
| Pourquoi Anthropic existe | La sécurité doit être **intégrée dès la conception**, pas ajoutée comme un filtre à la fin. Disagreement de fond avec OpenAI sur ce principe. |
| Mission en 3 mots | **Fiable** (réduire les erreurs graves et les comportements imprévisibles) · **Interprétable** (comprendre ce qui se passe à l'intérieur du modèle) · **Orientable** (guider et contraindre le modèle selon des règles définies) |
| Qu'est-ce qu'"orientable" concrètement ? | Une entreprise peut donner à Claude une politique interne, lui interdire de traiter certaines données, lui imposer une validation humaine avant une action sensible. C'est ça, l'orientabilité. |
| Constitutional AI | Au lieu de seulement faire noter les réponses par des humains, on donne au modèle une **constitution** (ensemble de principes). Il compare ses propres réponses à ces principes et les corrige. → Explique la prudence parfois supérieure de Claude vs autres modèles. |
| Statut juridique | **PBC** (Public Benefit Corporation) : les dirigeants doivent tenir compte d'une mission d'intérêt public, pas seulement du profit. + **Long-Term Benefit Trust** : protège cette mission contre les pressions financières des investisseurs. |
| Positionnement commercial | **B2B ~80 %** · 300 000+ clients entreprise · 8/10 Fortune 10 · 1 000+ clients à >1 M$/an · Conformité : SOC 2 Type II, HIPAA/BAA, GDPR, Zero Data Retention, Data residency |
| Investisseurs | Cloud/infra : Amazon, Google, Microsoft, Nvidia · Fonds souverains : GIC, Qatar IA, Temasek · VC : Sequoia, Coatue, Founders Fund · Gestion d'actifs : BlackRock, Fidelity |
| 4 différenciateurs Claude | 1. **Sécurité plus stricte** (refus, demandes de contexte) · 2. **Qualité rédactionnelle** (ton cohérent, longs contextes) · 3. **Agents** (MCP, Computer Use, Claude Code, Cowork) · 4. **Enterprise** (conformité, audit, intégrations métier) |
| Concurrence IA générative | OpenAI (ChatGPT, GPT) · Google (Gemini) · Meta (Llama) · Anthropic se différencie par l'orientation B2B et la priorité sécurité/conformité |

## Synthèse

Anthropic est née d'un désaccord sur **comment** développer l'IA, pas sur **si** la développer. Ses fondateurs ex-OpenAI ont voulu intégrer la sécurité au cœur du processus d'entraînement plutôt que de l'ajouter en surface. Cela se traduit directement dans Claude : ses refus, ses précautions et son orientation enterprise ne sont pas des limitations arbitraires, mais le reflet d'une philosophie de conception. Comprendre ça, c'est comprendre pourquoi Claude se comporte différemment des autres modèles.

## Glossaire

- **LLM** (Large Language Model) : modèle d'IA entraîné sur de grands volumes de textes, capable de produire du texte, raisonner, coder, analyser
- **ARR** (Annual Recurring Revenue) : revenu annualisé — projection du revenu mensuel sur 12 mois
- **Valorisation post-money** : valeur estimée d'une entreprise après un tour de financement (≠ argent en banque)
- **PBC** (Public Benefit Corporation) : forme juridique américaine imposant de tenir compte d'une mission d'intérêt public en plus du profit
- **B2B** (Business to Business) : vente à des entreprises (vs B2C : vente aux particuliers)
- **Constitutional AI** : méthode d'entraînement où le modèle évalue et corrige ses réponses selon un ensemble de principes (une "constitution")
- **Interprétabilité** : recherche visant à comprendre le fonctionnement interne d'un modèle (pourquoi telle réponse, quel mécanisme)
- **Scaling laws** : lois empiriques liant la taille du modèle, les données et la puissance de calcul aux performances obtenues
- **MCP** (Model Context Protocol) : protocole permettant de connecter Claude à des outils, fichiers ou services externes
- **SOC 2 Type II** : certification d'audit vérifiant la protection des données clients sur une période (pas juste un instant T)
- **HIPAA/BAA** : loi US sur la protection des données de santé ; BAA = contrat d'engagement du fournisseur
- **GDPR** : règlement européen sur la protection des données personnelles (RGPD en français)
- **Zero Data Retention** : le fournisseur ne conserve pas les entrées/sorties au-delà du traitement immédiat
- **API** (Application Programming Interface) : interface permettant à un logiciel d'utiliser les fonctions d'un autre

## Questions d'auto-évaluation

1. Quel désaccord précis a conduit les fondateurs à quitter OpenAI pour créer Anthropic ?
2. La mission d'Anthropic tient en 3 mots. Lequel est le moins évident à expliquer, et qu'est-ce qu'il signifie concrètement pour une équipe qui déploie Claude en interne ?
3. Qu'est-ce que Constitutional AI change par rapport à un simple filtre de sécurité ajouté après entraînement ?
4. Pourquoi le statut PBC + Long-Term Benefit Trust est-il cohérent avec la raison d'être d'Anthropic ?
5. Claude refuse parfois une demande qu'un autre modèle accepterait. D'où vient ce comportement, et comment le contourner légitimement ?
