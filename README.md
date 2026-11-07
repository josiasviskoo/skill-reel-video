# skill reel · roteiro + corte + edição

Skill de Claude Code para quem grava a si mesmo falando e quer **reels orgânicos ou anúncios** 9:16 prontos.
Três modos, uma pasta de projeto por vídeo:

| Modo | O que faz |
|---|---|
| **ROTEIRO** (`roteiro/`) | cria o roteiro com o template validado **"Espelho Local"**, engenharia reversa de um anúncio vencedor: briefing, roteiro cronometrado em 8 blocos, teleprompter, shot list (fala · sobrepostos · fotos), variações de hook e checklist com anticontaminação e compliance |
| **EDIÇÃO** (`edicao/`) | **corta** a fala bruta (silêncios, respirações, "éé", gaguejos, retomadas, com conferência de cada emenda) e **edita** no motor **VSL com interface animada**: FULL com punch-in ↔ SPLIT, cada palavra-chave vira uma peça que entra na palavra, legenda que segue a boca, **vídeos sobrepostos (B-roll) ancorados na fala**, SFX enxutos, −14 LUFS. Entrega `render/reel-v1.mp4` verificado e itera a pedido |
| **COMPLETO** | roteiro → a pessoa grava → edição, tudo na mesma pasta, com o mapa bloco a bloco de `roteiro/framework/08-do-roteiro-a-edicao.md` |

## Instalar
```bash
git clone https://github.com/josiasviskoo/skill-reel-video.git ~/.claude/skills/reel
```
No Claude Code: "cria um roteiro de anúncio para…", "edita esse reel" (passando os vídeos) ou `/reel`.

## Como organizar as gravações
```bash
bash ~/.claude/skills/reel/novo-projeto.sh meu-video      # cria meu-video/ com a estrutura abaixo
```
```
meu-video/
├── roteiro/               roteiro.md · texto-de-gravacao.md · shot-list.md · checklist.md
├── brutos/
│   ├── fala/              você falando para a câmera (uma ou várias partes: 01-…, 02-…)
│   ├── sobrepostos/       B-roll que cobre a fala (mãos, equipamento, ambiente, tela)
│   └── fotos/             casos reais, antes/depois, prints, logos
├── corte/ preparo/ motor/ assets/      trabalho da skill
└── render/ qa/ entrega/                reel-v1.mp4, verificação, cards
```
Os sobrepostos entram por `motor/assets/sobrepostos.json`, cada um ancorado na frase que ilustra
(`"em": "frase exata"`), em tela cheia (`"full"`) ou na metade de cima do SPLIT (`"topo"`).

## Estrutura do repositório
```
SKILL.md              porta de entrada: escolhe o modo
regras-da-casa.md     R1–R11 (rosto nunca coberto, SFX com parcimônia, material real, nenhuma palavra comida, −14 LUFS…)
novo-projeto.sh       cria a pasta de um vídeo
roteiro/              ROTEIRO.md · briefing/ · framework/ (01–08) · scripts/ · referencia-vencedor/ (só estudo)
edicao/               EDICAO.md · ESTILO.md · pele.json
  corte/              motor de corte: CORTE.md · references/EDICAO-BRUTA.md · scripts/ · exemplo/ (gabarito aprovado)
  motor-vsl/          motor VSL: kit/ (intocado) · montar.mjs · sobrepostos.mjs · preparar.sh · ferramentas/ · exemplo/
  ferramentas/        juntar-falas.sh · preparar.py · rosto.py · ancoras.py · verificar.py · zona-segura.py · recortar.py
                      audio-final.sh · gerar-imagem.sh
  anexos/             quadros da referência e o antes × depois da cor
```

## O que a máquina precisa (só para o modo EDIÇÃO)
| Para | Ferramenta |
|---|---|
| corte e transcrição | `ffmpeg`, `whisper-cli` (whisper.cpp) + modelo `ggml-large-v3-turbo.bin` em `~/.cache/whisper-cpp/` (ou `WHISPER_MODEL`), Python 3 com `numpy` |
| enquadramento, zona segura, legenda que segue a boca | `opencv-python-headless` (e, para o rastreio fino, `mediapipe` num Python apontado por `VSL_PYTHON`) |
| imagens para trechos sem material (opcional) | Codex CLI logado (`npm i -g @openai/codex && codex login`), com o recurso `image_generation` |
| composição e render | Node 20+ (o `preparar.sh` instala `hyperframes` 0.7.109, `gsap` 3.14.2 e `playwright`), Google Chrome (ou `CHROME=<executável>`) |

`python3 edicao/corte/scripts/0-checar.py` diz o que falta e como instalar. Mac: `brew install ffmpeg whisper-cpp`.

## Licenças do material embutido
Fontes Anybody, Plus Jakarta Sans e JetBrains Mono sob OFL (arquivos `OFL-*.txt` em `edicao/motor-vsl/kit/fonts/`); os
efeitos sonoros de `edicao/motor-vsl/kit/sfx/` são procedurais (gerados por `edicao/motor-vsl/ferramentas/gerar-sfx.mjs`);
GSAP e HyperFrames vêm pelo `npm`. Os logos do exemplo vêm do Wikimedia Commons e estão listados em
`edicao/motor-vsl/exemplo/SOURCES.md`. O material de `roteiro/referencia-vencedor/` é só para estudo do template.
