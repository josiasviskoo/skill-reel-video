---
name: reel
description: Estúdio de vídeo vertical 9:16 (Reels, Shorts, Stories, Meta Ads) para quem grava a si mesmo falando. Três modos. ROTEIRO, para criar roteiros de anúncio/reel com o template validado "Espelho Local" (engenharia reversa de um anúncio vencedor; briefing, roteiro cronometrado, teleprompter, shot list, hooks, checklist) para profissionais e negócios locais de serviço. EDIÇÃO, que corta a fala bruta (silêncios, "éé", gaguejos, retomadas) com o motor de corte e edita no motor "VSL com interface animada" (FULL/SPLIT, peças que entram na palavra, legenda que segue a boca, vídeos sobrepostos/B-roll ancorados na fala, −14 LUFS) e entrega render/reel-v1.mp4 verificado. COMPLETO, que vai do roteiro à gravação e à edição na mesma pasta de projeto. Use SEMPRE que pedirem "edita esse reel", "corta e edita", "monta esse bruto", "faz o reel/anúncio desse vídeo", "tenho a fala e os sobrepostos", "cria um roteiro/criativo/script de anúncio", "hook", "texto de gravação", "criativo igual ao vencedor", ou passarem vídeos falados para virar reel ou anúncio, mesmo sem citar a skill. NÃO serve para vídeo longo do YouTube, showreel sem alguém falando, carrossel ou copy de texto puro.
---

# reel · roteiro + corte + edição

Uma skill, três modos, uma pasta de projeto por vídeo. **Nunca publique nem envie o vídeo** (R9). **Nenhum nome de
terceiro** no vídeo nem nos arquivos (R11). As **regras da casa** (`regras-da-casa.md`) valem por cima de tudo.

## Escolha o modo
| A pessoa… | Modo | Leia e siga |
|---|---|---|
| quer um roteiro, criativo, hook, texto de gravação ou briefing | **ROTEIRO** | `roteiro/ROTEIRO.md` |
| mandou vídeos gravados (fala, e talvez sobrepostos e fotos) para virar reel/anúncio | **EDIÇÃO** | `edicao/EDICAO.md` |
| quer o caminho todo: roteiro → ela grava → edição | **COMPLETO** | `roteiro/ROTEIRO.md`, depois `edicao/EDICAO.md` na mesma pasta, com `roteiro/framework/08-do-roteiro-a-edicao.md` |

Na dúvida entre reel **orgânico** e **anúncio** (muda a zona segura e o CTA), pergunte uma vez. Sem resposta: orgânico.

## O material que a pessoa grava
- **Fala**: ela falando para a câmera, num arquivo ou em várias partes → `brutos/fala/`.
- **Sobrepostos**: vídeos que cobrem a fala para ilustrar a cena (B-roll: mãos, equipamento, ambiente, tela) → `brutos/sobrepostos/`.
- **Fotos**: casos reais, antes/depois, prints, logos → `brutos/fotos/`.

A pasta de cada vídeo nasce com `bash $S/novo-projeto.sh <slug>` (`S=~/.claude/skills/reel`, ou `REEL_SKILL`):
`roteiro/ · brutos/{fala,sobrepostos,fotos}/ · corte/ · preparo/ · motor/ · assets/ · render/ · qa/ · entrega/`.
Os brutos nunca são apagados nem alterados; nada é escrito dentro da pasta da skill.

## Mapa da skill
```
SKILL.md                 este arquivo: escolhe o modo
regras-da-casa.md        R1–R11: rosto nunca coberto, SFX com parcimônia, material real, nenhuma palavra comida, −14 LUFS…
novo-projeto.sh          cria a pasta de um vídeo (roteiro, brutos, corte, motor, render…)
roteiro/                 MODO ROTEIRO · template "Espelho Local" (anúncio vencedor)
  ROTEIRO.md               o fluxo e as regras
  briefing/                questionário para o cliente preencher
  framework/               01 briefing · 02 estrutura 8 blocos · 03 template · 04 specs visuais · 05 saída
                           06 checklist · 07 exemplo aplicado · 08 do roteiro à edição
  scripts/                 checar-contaminacao.sh
  referencia-vencedor/     o anúncio original (SÓ ESTUDO: transcrição, decomposição, análise, frames)
edicao/                  MODO EDIÇÃO · corte + motor VSL
  EDICAO.md                o fluxo (corte → preparo → planta → render → entrega)
  ESTILO.md                a espec do motor VSL: layouts, movimento, legenda, peças, som, aceite, lições
  pele.json                os valores nativos (fontes, cinco cores, invariantes)
  corte/                   motor de corte: CORTE.md · references/EDICAO-BRUTA.md · scripts/ · exemplo/
  motor-vsl/               motor VSL: kit/ (intocado) · montar.mjs · sobrepostos.mjs · preparar.sh · ferramentas/ · exemplo/
  ferramentas/             juntar-falas.sh · preparar.py · rosto.py · ancoras.py · verificar.py · zona-segura.py
                           recortar.py · audio-final.sh · gerar-imagem.sh (Codex, quando falta material)
  anexos/                  quadros da referência e o antes × depois da cor
```

## Condução
- Diga em uma linha o modo e o que vai acontecer; avise antes de cada etapa lenta (transcrição, render).
- Dado de conteúdo que só a pessoa sabe (fato, preço, nome, técnica, autorização de foto) → pergunte; nunca invente.
- **Os motores não se reescrevem** (`edicao/motor-vsl/kit/`, `edicao/corte/scripts/`); **o template não vaza a
  referência** (`roteiro/referencia-vencedor/` é só leitura).
- Falhou a máquina (ffmpeg, whisper, node, Chrome)? `python3 $S/edicao/corte/scripts/0-checar.py` diagnostica.
