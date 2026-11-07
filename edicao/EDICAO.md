# EDIÇÃO · corta e edita no motor VSL

Modo EDIÇÃO da skill `reel`. A pessoa manda as gravações; você corta com o **motor de corte** (`edicao/corte/`)
e edita com o **motor VSL** (`edicao/motor-vsl/`, o kit intocado que produziu a referência aprovada), seguindo
as **regras da casa** (`regras-da-casa.md`, na raiz, valem por cima de tudo) e o **`edicao/ESTILO.md`** (a espec
do motor). **Nunca publique nem envie o vídeo** (R9). **Nenhum nome de terceiro** no vídeo nem nos arquivos (R11).

Leia antes de começar (nesta ordem, inteiros): `regras-da-casa.md` → `edicao/corte/CORTE.md` → `edicao/ESTILO.md` →
`edicao/motor-vsl/README.md` → `edicao/motor-vsl/exemplo/LEIA.md`. Se o vídeo veio de um roteiro do modo ROTEIRO
(anúncio "Espelho Local"), leia também `roteiro/framework/08-do-roteiro-a-edicao.md`. Lição que paga a leitura:
**o padrão de qualidade é o exemplo, não um mínimo** (`edicao/motor-vsl/exemplo/beats-exemplo.js` é a régua).

`S=~/.claude/skills/reel` (ou `REEL_SKILL`) · `E=$S/edicao`. Variáveis de ambiente (R10): `WHISPER_MODEL`,
`VSL_PYTHON` (Python com mediapipe ou opencv), `FACE_MODEL`, `VSL_NODE_MODULES`, `CHROME`, `RVM_PYTHON` (só para
matte), `CODEX_BIN` / `CODEX_HOME` / `CODEX_MODEL` (só para gerar imagens, passo 3.3c).

## O material que a pessoa grava
| Tipo | O que é | Onde fica no projeto | Quem trata |
|---|---|---|---|
| **Fala** | ela falando para a câmera (um arquivo ou várias partes) | `brutos/fala/` | motor de corte → câmera do motor VSL |
| **Sobrepostos** | B-roll que cobre a fala: mãos, equipamento, ambiente, tela, processo | `brutos/sobrepostos/` | `motor/assets/sobrepostos.json` (passo 3.3a) |
| **Fotos** | casos reais, antes/depois, prints, logos | `brutos/fotos/` | `motor/assets/img/` + peças do kit (`K.fan`, `K.grid`, `K.beforeAfter`…) |

## Fluxo (ordem fixa)

### 0 · Projeto
1. **Uma pasta por vídeo:** `bash $S/novo-projeto.sh <slug>` ao lado dos brutos (ou use a pasta que o modo ROTEIRO
   já criou). Copie (não mova) as gravações para `brutos/fala/`, `brutos/sobrepostos/` e `brutos/fotos/`.
   Sem saber qual arquivo é fala e qual é sobreposto? Olhe a duração e um quadro de cada (`ffmpeg -ss 1 -frames:v 1`):
   fala tem a pessoa olhando para a lente e voz contínua; sobreposto não. Na dúvida, pergunte.
2. Primeira vez na máquina: `python3 $E/corte/scripts/0-checar.py` (ffmpeg, whisper-cli, numpy, modelo).
3. Diga em uma linha o que vai acontecer ("Cortando e editando no motor VSL; o v1 chega em alguns minutos")
   e avise antes de cada etapa lenta. Etapas longas rodam em segundo plano.

### 1 · Corte (motor de corte, `edicao/corte/CORTE.md` inteiro)
Fala em **várias partes**? Junte primeiro, na ordem do roteiro:
`bash $E/ferramentas/juntar-falas.sh brutos/fala corte/bruto-unico.mp4` (uma parte só = cópia). O bruto do corte
passa a ser `corte/bruto-unico.mp4`.

`B=$E/corte/scripts` · tudo em `corte/`:
```bash
python3 $B/1-tomadas.py "<bruto>" corte && cat corte/tomadas.txt      # LEIA inteiro antes de escolher
# escreva corte/keeps.json (regras dos keeps: a melhor tomada completa de cada frase; falsa largada fora)
python3 $B/2-vicios.py corte
python3 $B/3-corte.py "<bruto>" corte                                  # J/L de 4 quadros (o padrão do VSL)
python3 $B/4-conferir.py corte --prompt "<nomes próprios do vídeo>" && cat corte/conferencia.txt
```
Com roteiro (`roteiro/texto-de-gravacao.md`)? Use-o para escolher os keeps: fica a tomada que diz a frase do roteiro,
na ordem do roteiro, e o `--prompt` leva os nomes próprios dele (nome, cidade, bairro, técnicas).
Critério (R5): todos os blocos de `conferencia.txt` aprovados; **nenhuma palavra comida**; nenhuma pausa > 0,25 s.
Palavra comida → proteja o intervalo (`raw`/`force`) e corte de novo. Se a pessoa disser que o vídeo **já está
limpo**, pule: `cp "<vídeo>" corte/clean.mp4` e transcreva com `python3 $E/ferramentas/preparar.py corte/clean.mp4 preparo`.
Sai: `corte/clean.mp4`, `corte.wav`, `edl.json`, `cortepalavras.json`.

### 2 · Motor VSL · preparo
```bash
cp -R "$E/motor-vsl" motor && cd motor && bash preparar.sh
```
Faz a câmera 9:16 com a voz (`assets/clean.mp4`), o transcript no formato do kit, `npm install`, o rastreio da
boca e a 1ª montagem. Sem `pele-resolvida.json` a pele é a **nativa** (a da referência): não crie uma.

### 3 · Fase 1 · planta (`edicao/motor-vsl/README.md`)
1. **Transcript** (R6): corrija `assets/transcript.json` à mão (Cloud → Claude, A → IA, nomes como a marca
   escreve, palavra-código do CTA em CAIXA ALTA); o original fica em `transcript-whisper.json`.
2. **Enquadramento**: `python3 $E/ferramentas/rosto.py assets/clean.mp4 ../preparo --916` e meça num quadro
   com o punch aplicado → `vsl.json` (`punch`, `face`, `head`, `fullPos`, `splitPos`; cor e grade **não** mudam).
   Menos de ~300 px livres acima da cabeça → nada no alto em FULL: lettering, kicker e carimbo no peito (R1).
   **Anúncio** (pago)? A zona segura é outra (x 65–1015, y 270–1248). No `vsl.json`:
   `"safe": {"top": 270, "bottom": 1248, "left": 65, "right": 1015, "colX": 9999, "colY": 9999}` (a legenda que segue
   a boca respeita esta caixa) e `"capY": 1180`; peças no peito (`y` ≥ 1150) passam para 1000–1180 e o `K.cta` usa `{y: 1060}`.
3. **Material**, nesta ordem de preferência (R3):
   - **3a · Sobrepostos da própria pessoa** (`../brutos/sobrepostos/`). Assista cada um (folha de quadros:
     `ffmpeg -i x.mp4 -vf "fps=1,scale=270:-1,tile=6x2" -frames:v 1 qa/sob-x.png`) e escolha o trecho bom
     (`inicio`). Cada um entra ancorado na frase que ele ilustra, em `assets/sobrepostos.json`:
     ```json
     {"sobrepostos": [
       {"arquivo": "../brutos/sobrepostos/bandeja.mp4", "em": "aqui é usado", "ate": "agendando uma", "inicio": 1.2, "modo": "full"},
       {"arquivo": "../brutos/sobrepostos/mao-luva.mp4", "em": "pra cada tipo de", "dur": 2.4, "modo": "topo"}
     ]}
     ```
     `modo: "full"` cobre a câmera inteira (cena sem o apresentador, R1 opção 3); `"topo"` ocupa a metade de cima
     e **exige** `K.layout("split", K.at("<mesma frase>"))` no `beats.js` durante o trecho. O `montar.mjs` recorta
     cada trecho (mudo, 30 fps, no tamanho do lugar) e põe na camada `#broll`, acima da câmera e abaixo das peças
     e da legenda. Entram por `em` (frase, como `K.at`) ou `t`; saem por `ate` (frase) ou `dur`. Frase que não
     existe = erro (nunca chute tempo). Sobreposto curto demais congela no último quadro: o `montar.mjs` avisa.
     Sobreposto entre 1,5 e 4 s; não empilhe peça grande do kit em cima de sobreposto `full` (só pílula/lettering).
   - **3b · Fotos e prints reais** (`../brutos/fotos/`, prints e logos oficiais) em `assets/img/` + `../assets/SOURCES.md`
     (origem, licença, data); fato e preço com página oficial; tela sem print → ilustração declarada
     (`ferramentas/ilustracoes/`). Nunca invente logo, número ou print.
   - **3c · Sem material? Gere com o Codex.** Trecho da fala que pede imagem (cena, conceito, ambiente, objeto,
     metáfora visual) e não tem sobreposto, print, foto nem imagem livre → gere a imagem em vez de deixar a tela
     vazia ou repetir peça:
     ```bash
     bash $E/ferramentas/gerar-imagem.sh assets/img/gen-03-mesa-bagunçada.jpg 1080x1350 \
       "Top-down photo of a messy office desk with scattered papers, cold coffee and a laptop, soft daylight"
     ```
     - Prompt em inglês, concreto (assunto, enquadramento, luz, estilo: foto, 3D ou flat), coerente com a pele
       (fundo escuro combina; peça a cor de `destaque` no brilho quando fizer sentido). O script já proíbe
       texto, letras, logos e pessoas reais na imagem — o texto vem das peças do kit, por cima, nunca da IA.
     - Tamanho pelo lugar onde entra: topo do SPLIT `1080x600`; card/leque retrato `800x1000` (4:5);
       slide/tela `1280x720`; cena de fundo sem o apresentador `1080x1920`. O script recorta exato.
     - Nome `gen-NN-<assunto>.jpg`; o prompt fica em `<arquivo>.prompt.txt`. Confira cada imagem (abra e olhe):
       mãos, texto fantasma, objetos tortos → gere de novo com o prompt ajustado (no máximo 3 tentativas).
     - **Nunca** para: logo, print/tela de produto real, gráfico com número, rosto de pessoa real, resultado ou
       "antes × depois" que pareça prova. No anúncio Espelho Local, **nunca** no lugar de foto de caso, antes/depois
       ou B-roll de técnica: isso é sempre material real da pessoa.
     - Toda imagem gerada entra em `SOURCES.md` como "imagem gerada (Codex) — ilustrativa", com o prompt e a data,
       e é citada na entrega. Ela também obedece a R1 (nunca sobre o rosto) e R7 (zona segura).
     - Rode as gerações em segundo plano e em paralelo (2–3 por vez) enquanto escreve o mapa. Sem `codex`
       instalado/logado → diga em uma linha (`npm i -g @openai/codex && codex login`) e siga com ilustração HTML.
4. **Mapa → beats**: `assets/map.md` (tempo × fala × câmera × peça × sobreposto, como `exemplo/mapa.md`) e depois
   `src/beats.js`, uma chamada `K.*` por linha do mapa, tempos só por `K.at("frase exata")` (leia
   `exemplo/beats-exemplo.js` inteiro antes). Algo novo a cada 1,5–3 s (um sobreposto conta); FULL ≈ SPLIT;
   `K.hideMouth` em toda troca, em todo lettering e em todo sobreposto `full`; `K.mouthCaps` por último.
   Veio do roteiro? O mapa segue os 8 blocos (`roteiro/framework/08-do-roteiro-a-edicao.md`).
5. `node montar.mjs && npx hyperframes lint` (0 erros; snapshot vazio = âncora quebrada, leia o console).
6. `../entrega/planta.json` (n, layout, de, ate, fala, tela) e `node ferramentas/cards.mjs` → `entrega/cards/P01.png…`.

**Portão:** por padrão **vá direto para a fase 2** — a pessoa pediu rapidez. Pare e mostre o mapa ou os cards só
se ela pedir ("me mostra antes") ou se houver dúvida de conteúdo que só ela resolve (fato, preço, nome).

### 4 · Fase 2 · render (`edicao/motor-vsl/README.md`)
`PERFIL=reels` (orgânico) ou `PERFIL=anuncio` (pago; no `zona-segura-dom.mjs` o nome é `ads`).
```bash
npx hyperframes snapshot --at <cada troca, cada beat e cada sobreposto> -o snapshots   # rosto livre (R1), nada cortado/sobreposto
node ferramentas/zona-segura-dom.mjs . --strict [--profile ads]          # "zona segura OK"
npx hyperframes render -q high -o ../render/_reel-bruto.mp4
node montar.mjs --so-camera && npx hyperframes render -q high -o ../render/_camera-so.mp4 && node montar.mjs
bash ferramentas/audio-final-vsl.sh ../render/_reel-bruto.mp4 ../render/reel-v1.mp4   # −14 LUFS ±0,3 · pico ≤ −1 dBTP
node ferramentas/sons.mjs && bash ferramentas/folha.sh ../render/reel-v1.mp4 ../qa/folha-final.png
python3 "$E/ferramentas/verificar.py" .. --video render/reel-v1.mp4 --sfx ../sons.json --camera ../render/_camera-so.mp4 --perfil $PERFIL
```
Depois escreva `MINUTAGEM.md` (beat a beat: tempo, fala, o que aparece, layout, sobreposto, som) e `progresso.md` na
pasta do projeto. **Critique antes de mostrar:** `VERIFY.md` todo aprovado, folha de quadros, R1 (rosto), R2 (SFX ≤ 0,8/s
no modo enxuto), R6 (legenda), R7 (zona segura), R8 (áudio). Veio do roteiro? Confira também o checklist visual de
`roteiro/framework/06-checklist.md`. Até 2 rodadas de ajuste antes de entregar.

### 5 · Entrega e iteração
Responda com: caminho do `reel-v1.mp4`, duração (bruto → corte → final), LUFS e pico, número de telas, de
sobrepostos e de efeitos, o que ficou de fora no corte e o que foi protegido, correções de legenda, fontes dos fatos,
imagens geradas pelo Codex (quais e onde), pontos abertos. Ajuste pedido → `reel-v<N+1>.mp4` (versões anteriores
ficam em `render/`); mudança de corte → retranscreva e remapeie (`edicao/corte/scripts/remapear.py`), nunca
recronometre à mão (os sobrepostos ancorados por frase se ajustam sozinhos; os por `t` não).

## Regras de condução
- **Os motores não se reescrevem.** `edicao/motor-vsl/kit/` e `edicao/corte/scripts/` ficam intocados; cada vídeo
  escreve só `src/beats.js`, `vsl.json`, `assets/sobrepostos.json`, `keeps.json` e os ajustes. Um parâmetro do corte
  muda só pelo diagnóstico da seção 9 de `edicao/corte/references/EDICAO-BRUTA.md`, um de cada vez, registrado.
- **Uma versão por rodada**, completa e verificada.
- **Som enxuto** (`"sfxModo": "enxuto"`, o padrão do `vsl-padrao.json`): ≤ 0,8 efeito/s contando a digitação,
  digitação sempre contínua. O som exato da referência (`"referencia"`) só a pedido. Sobreposto entra sem som próprio.
- **Material real** sempre (sobreposto da pessoa > foto/print real > ilustração declarada > imagem gerada).
  **Rosto nunca coberto** por peça; sobreposto `full` substitui a cena inteira, nunca fica "meio sobre o rosto".
  **Zona segura** do perfil certo.
- **Você produz** nesta sessão. Se a pessoa pedir um agente ou um modelo específico, lance um agente
  general-purpose com este EDICAO.md + `edicao/ESTILO.md` + `edicao/motor-vsl/README.md` como brief e critique a entrega.
- Falhou algo (ffmpeg, whisper, modelo, npm, Chrome)? Diga em uma linha o que fazer; `edicao/corte/scripts/0-checar.py`
  diagnostica a máquina.
