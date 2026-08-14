# Fonctionnement d'un LLM

*Claude : fondations → 2. Comprendre l'intelligence artificielle générative → 1. Fonctionnement d'un LLM*

## Architecture Transformer : qu'est-ce que c'est ?

Le Transformer est l'architecture de réseau de neurones sous-jacente à la quasi-totalité des grands modèles de langage (LLM) modernes.

### 1. L'idée générale

Le traitement d'un texte par un Transformer suit un flux linéaire :
1. **Texte d'entrée** : Par exemple, `"Le chat dort"`.
2. **Tokens** : Le texte est découpé en morceaux appelés tokens (ex: `Le`, `chat`, `dort`).
3. **Embeddings** : Chaque token est converti en un vecteur numérique (espace vectoriel) qui capture sa signification initiale.
4. **Blocs Transformer** : Le modèle traite la séquence de tokens et utilise le contexte global pour calculer une représentation riche et contextualisée de chaque token.
5. **Sortie** : Le modèle produit une distribution de probabilité pour prédire le mot (ou token) suivant le plus probable (ex: `profondément`).

> **Idée clé** : Le mot "transformer" signifie que le modèle transforme progressivement les représentations des tokens grâce au mécanisme d'attention et à des couches successives.

### 2. Ce qu'il y a dans un bloc Transformer

Un LLM est constitué d'un empilage de plusieurs blocs Transformer (Bloc 1, Bloc 2, ..., Bloc N). À l'intérieur de chaque bloc, le signal passe par plusieurs étapes :
1. **Entrée** : Vecteurs des tokens provenant de la couche précédente.
2. **Self-attention (Auto-attention)** : Chaque token "regarde" les autres tokens du contexte pour comprendre ses relations avec eux.
3. **Connexion résiduelle + Normalisation** : Stabilise l'apprentissage et évite la dégradation du signal.
4. **Feed-forward** : Un petit réseau de neurones indépendant appliqué à chaque token.
5. **Connexion résiduelle + Normalisation** : Nouvelle stabilisation avant la sortie.
6. **Sortie du bloc** : Vecteurs contextualisés envoyés au bloc suivant.

### 3. Zoom sur l'attention

Le mécanisme d'attention permet de lier les mots entre eux au sein du contexte :
- Dans la phrase `"Le chat dort"`, le mot `dort` va envoyer une **attention forte** vers `chat` (pour savoir qui dort) et une **attention faible** vers `Le`.
- L'attention attribue ainsi un poids aux autres tokens du contexte, indiquant quelles informations sont les plus utiles.
- **Résultat** : On obtient un vecteur contextualisé. Par exemple, le mot `"chat"` seul est projeté dans l'espace vectoriel vers une représentation combinée `"chat + contexte"`. Le contexte déplace la représentation du mot.

### 4. Pourquoi c'est important pour les LLM

- **Parallélisation** : Contrairement aux anciens réseaux récurrents (RNN) qui traitaient les mots un par un, le Transformer traite tous les tokens d'une séquence simultanément, ce qui accélère massivement l'entraînement.
- **Contexte** : Grâce à l'attention, il capture efficacement les relations entre des mots proches ou très éloignés dans le texte.
- **Base des LLM** : Les grands modèles de langage modernes sont généralement des Transformers, souvent dans une version *decoder-only* (orientée génération).

> **Résumé** : Une architecture Transformer est un empilement de blocs qui utilisent l'attention, la normalisation et des réseaux feed-forward pour transformer les tokens en représentations contextualisées, puis produire une prédiction.
