#!/usr/bin/env bash
# juntar-falas.sh — junta vários vídeos de FALA (gravados em partes) num bruto só, na ordem do nome, para o motor de corte.
# Uso: bash juntar-falas.sh <pasta com os vídeos de fala> <saída .mp4> [LxA, padrão = o tamanho do 1º vídeo]
#   Ex.: bash $S/edicao/ferramentas/juntar-falas.sh brutos/fala corte/bruto-unico.mp4
# Nomeie as partes na ordem do roteiro (01-hook.mp4, 02-autoridade.mp4…). Reencoda tudo no mesmo tamanho, 30 fps,
# áudio 48 kHz mono; o corte vem depois (silêncios e tomadas ruins saem no motor de corte, não aqui).
set -euo pipefail
DIR="${1:?pasta dos vídeos de fala}"; OUT="${2:?arquivo de saída}"; TAM="${3:-}"
mapfile -t ARQ < <(find "$DIR" -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.m4v' -o -iname '*.mkv' \) | sort)
(( ${#ARQ[@]} )) || { echo "nenhum vídeo em $DIR" >&2; exit 1; }
if (( ${#ARQ[@]} == 1 )); then mkdir -p "$(dirname "$OUT")"; cp "${ARQ[0]}" "$OUT"; echo "$OUT (1 arquivo, copiado)"; exit 0; fi
if [[ -z "$TAM" ]]; then
  TAM=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height:stream_side_data=rotation -of csv=p=0:s=x "${ARQ[0]}" | head -1 | cut -d x -f1,2)
fi
W=${TAM%x*}; H=${TAM#*x}
IN=(); F=""
for i in "${!ARQ[@]}"; do
  IN+=(-i "${ARQ[$i]}")
  F+="[$i:v]scale=$W:$H:force_original_aspect_ratio=decrease,pad=$W:$H:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30,format=yuv420p[v$i];"
  F+="[$i:a]aresample=48000,aformat=channel_layouts=mono[a$i];"
done
for i in "${!ARQ[@]}"; do F+="[v$i][a$i]"; done
F+="concat=n=${#ARQ[@]}:v=1:a=1[v][a]"
mkdir -p "$(dirname "$OUT")"
ffmpeg -v error -y "${IN[@]}" -filter_complex "$F" -map "[v]" -map "[a]" -c:v libx264 -crf 16 -preset medium -c:a aac -b:a 192k "$OUT"
printf '%s\n' "${ARQ[@]}" > "${OUT%.*}.partes.txt"
echo "$OUT (${#ARQ[@]} partes, ${W}x${H}; ordem em ${OUT%.*}.partes.txt)"
