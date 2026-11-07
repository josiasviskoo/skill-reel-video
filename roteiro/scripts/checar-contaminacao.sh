#!/usr/bin/env bash
# Procura placeholders não preenchidos e termos do anúncio original num criativo gerado.
# Uso: bash checar-contaminacao.sh <pasta-do-criativo>
set -u
DIR="${1:-.}"
PADRAO='thain|rodrigues|s[aã]o carlos|santa fel|podol|unha|manicure|15 dias|fotopolimeriz|fio de a[cç]o|curvatura|\[[A-ZÀ-Ú_0-9/]+\]'

if grep -rniE "$PADRAO" "$DIR"; then
  echo
  echo "ATENÇÃO: ocorrências acima. Remova, ou justifique no checklist.md se forem do briefing novo."
  exit 1
else
  echo "OK: sem contaminação nem placeholders."
fi
