# Les bonnes pratiques d'utilisation des LLM

*Claude : fondations → 3. Fonctionnalités, limites et bonnes pratiques → 3. Les bonnes pratiques d'utilisation des LLM*

Un LLM donne de meilleurs résultats lorsque la demande est claire, dense et limitée à une tâche précise. La qualité de la réponse ne dépend pas seulement du modèle utilisé. Elle dépend aussi fortement de la manière dont le contexte, la tâche, les contraintes et le format de sortie sont formulés.

Trois principes de base sont particulièrement importants :
1. **Augmenter la densité informationnelle**.
2. **Fournir un contexte pur**.
3. **Demander une seule tâche principale**.

---

## 1. La densité informationnelle

La **densité informationnelle** désigne la quantité d’informations utiles par rapport au volume total du prompt. Un bon prompt ne doit pas forcément être long, il doit surtout contenir les informations qui influencent réellement la réponse du modèle.
- **Prompt peu dense** : Contient beaucoup de texte vague, mais peu d'éléments exploitables.
- **Prompt dense** : Regroupe les objectifs, les contraintes, les critères de réussite, le public cible, les données utiles et le format attendu.

### Comparaison d'exemples
* **Prompt peu dense (vague) :**
  > *"Fais-moi un bon résumé de ce texte."*
  *(Le modèle ignore ce que signifie "bon" : longueur, ton, public cible, thèmes prioritaires...)*
* **Prompt dense (précis) :**
  > *"Résume ce texte pour un directeur commercial. Garde uniquement les informations liées aux risques client, aux opportunités de vente et aux prochaines actions. Réponds en trois sections : Points clés, Risques, Actions recommandées. Maximum 250 mots."*

### Éléments à inclure dans un prompt dense
- **L’objectif** : Ce que le modèle doit produire.
- **Le public cible** : La personne ou le groupe qui utilisera le livrable.
- **Le contexte utile** : Uniquement les données requises pour la tâche.
- **Les contraintes** : Longueur, ton, niveau de détail, exclusions de mots/sujets.
- **Le format attendu** : Tableau, liste, plan, e-mail, JSON, code, etc.
- **Les critères de qualité** : Précision, concision, prudence, actionnabilité.

---

## 2. Le contexte pur

Un **contexte pur** contient uniquement les informations fiables et utiles à la tâche. Il faut éviter de mélanger des données obsolètes, des notes contradictoires, des brouillons non triés ou des apartés. Si le contexte est bruité, le modèle risque d'accorder de l'importance à des éléments secondaires.

### Comparaison d'exemples
* **Contexte impur (bruité) :**
  > *"Voici plusieurs notes, certaines ne sont peut-être plus à jour. Il y a aussi des idées que j'avais notées rapidement. Résume-moi tout ça et dis-moi quoi faire."*
* **Contexte pur (propre) :**
  > *"Contexte fiable à utiliser : Notre offre coûte 49 € par mois, s’adresse aux indépendants, inclut le support e-mail et ne propose pas d’essai gratuit.*
  > *Objectif : Rédiger une réponse à un prospect qui demande si un essai gratuit est disponible.*
  > *Contraintes : Ton professionnel, réponse courte, proposer une alternative."*

### Bonnes pratiques pour un contexte pur
- Supprimer les doublons et données inutiles avant l'envoi.
- Séparer visuellement le contexte, la tâche et les contraintes.
- Indiquer explicitement quelles sources ou fichiers font foi.
- Signaler au modèle les informations incertaines ou à ignorer.

---

## 3. Une seule tâche principale par demande

Un LLM est plus fiable lorsqu'il se concentre sur **une seule action principale** bien définie. Multiplier les requêtes disparates dans un seul prompt (analyser, résumer, critiquer, traduire et rédiger un e-mail en même temps) augmente le taux d'oubli de contraintes ou produit une réponse superficielle.

Si les tâches exigent des modes de réponse différents, il convient de **découper la demande** (chaînage de prompts) :
1. *Prompt 1* : Analyser les documents.
2. *Prompt 2* : Formuler des hypothèses et décider d'après l'analyse.
3. *Prompt 3* : Rédiger le livrable (e-mail, rapport).
4. *Prompt 4* : Formater la sortie (tableau, JSON).

---

## Modèle de prompt universel

Pour réduire l'ambiguïté, structurez vos prompts en quatre blocs clairs :

$$\text{Prompt} = \text{Contexte pur} + \text{Tâche unique} + \text{Contraintes explicites} + \text{Format attendu}$$

```markdown
Contexte : [Uniquement les informations utiles, fiables et triées]

Tâche : [Une action principale claire]

Contraintes : [Ton, longueur, public cible, exclusions, niveau de prudence]

Format attendu : [Structure, tableau, liste, JSON, e-mail]
```

---

## Techniques d'optimisation avancées

### Signaler les incertitudes
Pour les sujets sensibles, demandez explicitement au modèle de distinguer les niveaux de certitude dans sa réponse.

*Exemple de consigne :*
> *"Analyse ce dossier. Sépare ta réponse en trois parties : Faits établis, Hypothèses raisonnables, et Points à vérifier. Ne conclus pas si les données sont insuffisantes."*

### Fournir des exemples (Few-Shot Prompting)
Lorsque le format de sortie doit respecter une structure stricte ou un style précis, donner un ou deux exemples est plus efficace que de longues descriptions abstraites.

*Exemple :*
```markdown
Risque | Pourquoi c'est important | Action recommandée
--- | --- | ---
Exemple de risque | Explication courte | Action concrète
```

### Adapter le modèle à la tâche
- **Modèles légers** : Pour reformuler, corriger, classer ou extraire des données courtes (rapides et économiques).
- **Modèles puissants / de raisonnement** : Pour analyser des contrats, corriger du code multi-fichiers, auditer des données financières ou chercher des contradictions.
