#!/usr/bin/env bash
# Pré-remplit ou complète le frontmatter et le squelette Cornell des fiches.
# Idempotent : préserve les métadonnées et le contenu déjà présents.
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

cornell_skeleton() {
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
}

while IFS= read -r -d '' file; do
  chapitre=$(basename "$(dirname "$file")")
  lecon=$(basename "$file" .md)

  has_cornell=false
  if grep -Fq '| Indices / questions clés | Notes détaillées |' "$file"; then
    has_cornell=true
  fi

  if [ -s "$file" ] && head -n 1 "$file" | grep -q '^---$'; then
    frontmatter_end=$(awk 'NR > 1 && /^---$/ { print NR; exit }' "$file")
    if [ -z "$frontmatter_end" ]; then
      echo "Erreur (frontmatter non fermé) : $file" >&2
      exit 1
    fi

    frontmatter=$(sed -n "2,$((frontmatter_end - 1))p" "$file")
    has_cours=false
    has_chapitre=false
    has_lecon=false
    has_statut=false
    has_etape=false
    has_prochaine=false
    grep -q '^cours:' <<<"$frontmatter" && has_cours=true
    grep -q '^chapitre:' <<<"$frontmatter" && has_chapitre=true
    grep -q '^leçon:' <<<"$frontmatter" && has_lecon=true
    grep -q '^statut:' <<<"$frontmatter" && has_statut=true
    grep -q '^etape_revision:' <<<"$frontmatter" && has_etape=true
    grep -q '^prochaine_revision:' <<<"$frontmatter" && has_prochaine=true

    if $has_cours && $has_chapitre && $has_lecon && $has_statut && \
       $has_etape && $has_prochaine && $has_cornell; then
      echo "Skip (déjà à jour) : $file"
      count_skip=$((count_skip + 1))
      continue
    fi

    tmp=$(mktemp)
    head -n $((frontmatter_end - 1)) "$file" > "$tmp"
    $has_cours || echo "cours: $COURS_NOM" >> "$tmp"
    $has_chapitre || echo "chapitre: $chapitre" >> "$tmp"
    $has_lecon || echo "leçon: $lecon" >> "$tmp"
    $has_statut || echo "statut: à revoir" >> "$tmp"
    $has_etape || echo "etape_revision: 0" >> "$tmp"
    $has_prochaine || echo "prochaine_revision:" >> "$tmp"
    echo '---' >> "$tmp"

    if ! $has_cornell; then
      cornell_skeleton >> "$tmp"
    fi

    tail -n +$((frontmatter_end + 1)) "$file" >> "$tmp"
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

  cornell_skeleton >> "$tmp"

  # Garde le contenu existant du fichier (s'il n'était pas vraiment vide).
  if [ -s "$file" ]; then
    echo "" >> "$tmp"
    cat "$file" >> "$tmp"
  fi

  mv "$tmp" "$file"
  echo "Rempli : $file"
  count_rempli=$((count_rempli + 1))
done < <(find "$ROOT" -type f -name "*.md" -print0 | sort -z)

echo "Terminé. $count_rempli fiche(s) mise(s) à jour, $count_skip déjà à jour."
