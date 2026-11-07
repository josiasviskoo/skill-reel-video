#!/usr/bin/env bash
# novo-projeto.sh — cria a pasta de UM vídeo (reel orgânico ou anúncio), com lugar para o roteiro, os brutos e a edição.
# Uso: bash <skill>/novo-projeto.sh <slug> [pasta-mãe, padrão = diretório atual]
#   Ex.: bash ~/.claude/skills/reel/novo-projeto.sh campinas-dra-ana-dor-lombar-2026-11-07
set -euo pipefail
SLUG="${1:?slug do projeto (minúsculas, sem acento, hífens)}"; MAE="${2:-.}"
P="$MAE/$SLUG"
[[ -e "$P" ]] && { echo "já existe: $P (uma pasta por vídeo; nunca reaproveite outra edição)" >&2; exit 1; }
mkdir -p "$P"/{roteiro,brutos/fala,brutos/sobrepostos,brutos/fotos,corte,preparo,assets/img,render,qa,entrega}
cat > "$P/LEIA.md" <<EOF
# $SLUG

| Pasta | O que vai nela | Quem escreve |
|---|---|---|
| \`roteiro/\` | roteiro.md, texto-de-gravacao.md, shot-list.md, checklist.md (modo ROTEIRO) | a skill |
| \`brutos/fala/\` | os vídeos de FALA (você falando para a câmera), na ordem: 01-…, 02-… | você |
| \`brutos/sobrepostos/\` | os vídeos SOBREPOSTOS (B-roll: mãos, equipamento, ambiente, tela) que cobrem a fala | você |
| \`brutos/fotos/\` | fotos reais (casos, antes/depois, prints, logos), com autorização quando for de cliente | você |
| \`corte/\` | motor de corte: tomadas, keeps, clean.mp4 | a skill |
| \`preparo/\` · \`motor/\` | transcrição e a composição do motor VSL (beats.js, vsl.json, sobrepostos.json) | a skill |
| \`assets/\` | SOURCES.md (origem de cada imagem/fato) e material do projeto | a skill |
| \`render/\` | reel-v1.mp4, reel-v2.mp4… (as versões ficam todas) | a skill |
| \`qa/\` · \`entrega/\` | folha de quadros, zona segura, VERIFY, cards da planta | a skill |

Os brutos nunca são apagados nem alterados.
EOF
echo "$P"
