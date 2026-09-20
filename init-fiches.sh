#!/usr/bin/env bash
# Pré-remplit ou complète le frontmatter et le squelette de la fiche hybride.
# Idempotent : préserve les métadonnées, le titre, la durée et le contenu rédigé.
#
# Ne traite que les fiches de leçon `NN-*.md` situées directement dans un
# chapitre : les archives `sources/` et les fichiers annexes sont ignorés.
#
# Usage : ./init-fiches.sh [chemin-du-cours]
# Par défaut, cherche dans ./claude-code (à lancer depuis dyma-notes/)

set -euo pipefail

ROOT="${1:-claude-code}"
COURS_NOM="Claude Code"

if [ ! -d "$ROOT" ]; then
  echo "Dossier introuvable : $ROOT" >&2
  exit 1
fi

count_rempli=0
count_skip=0
count_garde=0

# Squelette complet de la fiche hybride.
# $1 = titre de la leçon, $2 = ligne de durée (peut être vide)
fiche_skeleton() {
  local titre="$1" duree="$2"
  cat <<'EOF'

| Indices / questions clés | Notes détaillées |
|---|---|
| ... | ... |

## Synthèse
(2-3 phrases dans mes propres mots, écrites sans regarder la colonne "Notes")

## Glossaire
- terme : définition

## Questions d'auto-évaluation
1. ...
EOF
  printf '\n# %s\n' "$titre"
  [ -n "$duree" ] && printf '\n%s\n' "$duree"
  cat <<'EOF'

## Objectif de la leçon
(Ce que la leçon enseigne concrètement, la friction qu'elle évite, le lien avec le fil rouge)

---

# 1. Première section thématique

```text
Schéma ASCII : mécanisme, comparaison ou architecture
```

---

# Résumé & Schéma global

```text
Vue synthétique des flux
```

# Tableau des commandes à retenir

| Commande / raccourci | Rôle |
|---|---|
| ... | ... |

# Les 5 points les plus importants

1. ...
2. ...
3. ...
4. ...
5. ...

---

# Carte mentale

```text
Racine
├── Branche 1
└── Branche 2
```

---

# Mini fiche de révision

```text
Aide-mémoire express, aligné sur →
```

> **Phrase à retenir** : la règle d'or de la leçon.
EOF
}

# Vrai si le corps du fichier (frontmatter exclu) est vide, ou exactement le
# squelette que fiche_skeleton produirait pour ce titre et cette durée.
corps_est_squelette() {
  local file="$1" titre="$2" duree="$3" debut=1 fin corps
  [ -s "$file" ] || return 0
  if head -n 1 "$file" | grep -q '^---$'; then
    fin=$(awk 'NR > 1 && /^---$/ { print NR; exit }' "$file")
    [ -n "$fin" ] || return 1
    debut=$((fin + 1))
  fi
  corps=$(tail -n +"$debut" "$file")
  [ -z "$(printf '%s' "$corps" | tr -d '[:space:]')" ] && return 0
  diff -q <(fiche_skeleton "$titre" "$duree") <(printf '%s\n' "$corps") >/dev/null 2>&1
}

# Titre lisible dérivé du slug, si le fichier n'a pas encore de H1.
titre_depuis_slug() {
  echo "$1" | sed -E 's/^[0-9]+-//; s/-/ /g'
}

while IFS= read -r -d '' file; do
  chapitre=$(basename "$(dirname "$file")")
  lecon=$(basename "$file" .md)

  # Titre et durée déjà présents : on ne les perd jamais.
  titre=$(grep -m1 '^# ' "$file" 2>/dev/null | sed 's/^# //' || true)
  [ -z "$titre" ] && titre=$(titre_depuis_slug "$lecon")
  duree=$(grep -m1 '^\*\*Durée' "$file" 2>/dev/null || true)

  # Le squelette du corps n'est (re)généré que si le corps EST encore le
  # squelette. Tout le reste est du travail rédigé et se préserve, quel que
  # soit le style des titres — c'est la seule façon de ne pas perdre de vue
  # les fiches dont la mise en forme a évolué.
  has_fiche=true
  corps_est_squelette "$file" "$titre" "$duree" && has_fiche=false
  $has_fiche && count_garde=$((count_garde + 1))

  if [ -s "$file" ] && head -n 1 "$file" | grep -q '^---$'; then
    frontmatter_end=$(awk 'NR > 1 && /^---$/ { print NR; exit }' "$file")
    if [ -z "$frontmatter_end" ]; then
      echo "Erreur (frontmatter non fermé) : $file" >&2
      exit 1
    fi

    frontmatter=$(sed -n "2,$((frontmatter_end - 1))p" "$file")
    has_cours=false;     grep -q '^cours:' <<<"$frontmatter" && has_cours=true
    has_chapitre=false;  grep -q '^chapitre:' <<<"$frontmatter" && has_chapitre=true
    has_lecon=false;     grep -q '^leçon:' <<<"$frontmatter" && has_lecon=true
    has_statut=false;    grep -q '^statut:' <<<"$frontmatter" && has_statut=true
    has_etape=false;     grep -q '^etape_revision:' <<<"$frontmatter" && has_etape=true
    has_prochaine=false; grep -q '^prochaine_revision:' <<<"$frontmatter" && has_prochaine=true

    # `chapitre` et `leçon` se déduisent du chemin : une valeur qui le
    # contredit est une scorie de renommage, pas une métadonnée à préserver.
    chemin_a_corriger=false
    $has_chapitre && [ "$(sed -n 's/^chapitre: *//p' <<<"$frontmatter" | head -n1)" != "$chapitre" ] \
      && chemin_a_corriger=true
    $has_lecon && [ "$(sed -n 's/^leçon: *//p' <<<"$frontmatter" | head -n1)" != "$lecon" ] \
      && chemin_a_corriger=true

    # La réparation du frontmatter ne dépend plus de l'état du corps : une
    # fiche rédigée y a droit comme un squelette.
    if $has_cours && $has_chapitre && $has_lecon && $has_statut && \
       $has_etape && $has_prochaine && ! $chemin_a_corriger; then
      echo "Skip (déjà à jour) : $file"
      count_skip=$((count_skip + 1))
      continue
    fi

    tmp=$(mktemp)
    head -n $((frontmatter_end - 1)) "$file" \
      | sed -e "s|^chapitre: .*|chapitre: $chapitre|" -e "s|^leçon: .*|leçon: $lecon|" > "$tmp"
    $has_cours || echo "cours: $COURS_NOM" >> "$tmp"
    $has_chapitre || echo "chapitre: $chapitre" >> "$tmp"
    $has_lecon || echo "leçon: $lecon" >> "$tmp"
    $has_statut || echo "statut: à revoir" >> "$tmp"
    $has_etape || echo "etape_revision: 0" >> "$tmp"
    $has_prochaine || echo "prochaine_revision:" >> "$tmp"
    echo '---' >> "$tmp"

    if $has_fiche; then
      # Fiche déjà rédigée : on ne retouche que le frontmatter.
      tail -n +$((frontmatter_end + 1)) "$file" >> "$tmp"
    else
      fiche_skeleton "$titre" "$duree" >> "$tmp"
    fi

    mv "$tmp" "$file"
    echo "Mis à jour : $file"
    count_rempli=$((count_rempli + 1))
    continue
  fi

  tmp=$(mktemp)
  cat > "$tmp" <<EOF
---
cours: $COURS_NOM
chapitre: $chapitre
leçon: $lecon
date:
statut: à revoir
etape_revision: 0
prochaine_revision:
---
EOF

  fiche_skeleton "$titre" "$duree" >> "$tmp"
  mv "$tmp" "$file"
  echo "Rempli : $file"
  count_rempli=$((count_rempli + 1))
done < <(find "$ROOT" -mindepth 2 -maxdepth 2 -type f -name '[0-9][0-9]-*.md' -print0 | sort -z)

echo "Terminé. $count_rempli mise(s) à jour, $count_skip déjà à jour, $count_garde fiche(s) rédigée(s) préservée(s)."
