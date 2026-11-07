#!/usr/bin/env bash
# gerar-imagem.sh — gera uma imagem ilustrativa com o Codex (gerador de imagens nativo do Codex CLI)
# para cobrir a fala quando não há vídeo, print ou foto real para o trecho.
#
# Uso:
#   bash gerar-imagem.sh <saida.jpg|png> <LxA> "<prompt em inglês>"
#   ex.: bash $S/edicao/ferramentas/gerar-imagem.sh assets/img/gen-01-cafe.jpg 1080x1350 \
#          "Close-up photo of a barista pouring latte art, warm morning light, shallow depth of field"
#
# O que faz: chama `codex exec` com o recurso image_generation ligado, pega o PNG que o Codex
# salvou em $CODEX_HOME/generated_images/ depois do início da chamada, recorta/escala para <LxA>
# (cover, centro) e grava em <saida>. Ao lado grava <saida>.prompt.txt (o prompt exato).
#
# Variáveis (R10): CODEX_BIN (padrão: codex), CODEX_HOME (padrão: ~/.codex), CODEX_MODEL (opcional),
# GEN_TIMEOUT (segundos, padrão 300).
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "uso: $0 <saida.jpg|png> <LxA> \"<prompt>\"" >&2; exit 2
fi
SAIDA="$1"; TAM="$2"; PROMPT="$3"
W="${TAM%x*}"; H="${TAM#*x}"
CODEX_BIN="${CODEX_BIN:-codex}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
GEN_DIR="$CODEX_HOME/generated_images"
TIMEOUT="${GEN_TIMEOUT:-300}"

command -v "$CODEX_BIN" >/dev/null || { echo "codex não encontrado (instale: npm i -g @openai/codex e faça codex login)" >&2; exit 3; }
command -v ffmpeg >/dev/null || { echo "ffmpeg não encontrado" >&2; exit 3; }

# proporção pedida ao gerador: retrato, paisagem ou quadrado (o recorte final fica exato no ffmpeg)
if   [ "$H" -gt "$W" ]; then ASPECTO="vertical (portrait, taller than wide)"
elif [ "$W" -gt "$H" ]; then ASPECTO="horizontal (landscape, wider than tall)"
else ASPECTO="square"; fi

mkdir -p "$(dirname "$SAIDA")" "$GEN_DIR"
MARCA="$(mktemp)"; touch "$MARCA"
trap 'rm -f "$MARCA"' EXIT

INSTRUCAO="Use your image generation tool to create exactly ONE image. Do not write code, do not edit files, do not run shell commands.
Aspect: $ASPECTO. Final use: a background/illustration in a vertical 9:16 Instagram reel, shown at ${W}x${H}.
Hard rules: no text, no letters, no numbers, no logos, no brand names, no watermarks, no UI with readable words, no real identifiable people or celebrities.
Image: $PROMPT"

ARGS=(exec --skip-git-repo-check --enable image_generation -s read-only)
[ -n "${CODEX_MODEL:-}" ] && ARGS+=(-m "$CODEX_MODEL")

echo "gerando imagem com o Codex ($TAM)…" >&2
timeout "$TIMEOUT" "$CODEX_BIN" "${ARGS[@]}" "$INSTRUCAO" </dev/null >"$SAIDA.codex.log" 2>&1 || {
  echo "codex falhou ou passou de ${TIMEOUT}s — veja $SAIDA.codex.log" >&2; exit 4; }

GERADA="$(find "$GEN_DIR" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.webp' \) -newer "$MARCA" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)"
[ -n "$GERADA" ] || { echo "o Codex não salvou imagem em $GEN_DIR — veja $SAIDA.codex.log" >&2; exit 5; }

ffmpeg -v error -y -i "$GERADA" \
  -vf "scale=${W}:${H}:force_original_aspect_ratio=increase:flags=lanczos,crop=${W}:${H}" \
  -q:v 2 "$SAIDA"

{ echo "gerador: Codex CLI (image_generation) — $("$CODEX_BIN" --version 2>/dev/null)"
  echo "original: $GERADA"
  echo "tamanho: $TAM"
  echo "data: $(date -I)"
  echo "prompt: $PROMPT"; } > "$SAIDA.prompt.txt"
rm -f "$SAIDA.codex.log"
echo "$SAIDA"
