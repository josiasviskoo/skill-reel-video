# 05 · Formato de saída

## Onde salvar
`<projeto>/roteiro/` — a pasta do projeto do vídeo, criada por `bash <skill>/novo-projeto.sh <cidade>-<profissional>-<problema>-<AAAA-MM-DD>` no diretório de trabalho do usuário (slug em minúsculas, sem acento, hífens). Assim o roteiro, os brutos gravados e a edição ficam juntos.
**Nunca** dentro da pasta da skill.

## Arquivos a gerar
1. `roteiro.md`
   - **Briefing usado**: tabela com o valor de cada placeholder.
   - **Roteiro em tabela**: tempo | bloco | fala exata | legenda on-screen (chunks de 1–3 palavras, separados por " / ") | layout/cena | overlay/selo/gesto.
   - **Contagem**: nº de palavras e duração estimada (~200 palavras/min).
   - **3 variações de hook** (H1–H3 preenchidas) + sugestão de teste A/B.
2. `texto-de-gravacao.md` (teleprompter)
   - Fala corrida, sem marcações técnicas, dividida por bloco (uma linha em branco entre blocos = ponto de corte).
   - Indicação curta de gesto entre parênteses só onde importa: (aponta pra cima), (mãos abertas), (conta nos dedos).
3. `shot-list.md` (o que gravar), separado pelos três tipos de material da edição (`08-do-roteiro-a-edicao.md`):
   - **Fala** → `brutos/fala/`: talking heads por bloco (com gesto e enquadramento); pode ser uma parte por bloco
     (`01-hook.mp4`, `02-retencao.mp4`…), na ordem do roteiro.
   - **Sobrepostos** → `brutos/sobrepostos/`: B-roll de materiais/equipamentos (lista de objetos e ação da mão),
     sala/fachada, processo; 5–10 s cada, vertical, sem fala. Para cada um, a frase do roteiro que ele cobre.
   - **Fotos** → `brutos/fotos/`: `FOTO_1..3`, `DEPOIS_HOOK`, `AD_1`, `AD_2` (o que cada uma deve mostrar, ângulo, luz, recorte).
   - Checklist de set: logo na parede, luz de fundo na cor da marca, roupa, lapela, celular vertical.
4. `checklist.md`: `06-checklist.md` preenchido (✅/❌ por item) + saída do `scripts/checar-contaminacao.sh`.

No chat, responda com um resumo curto, os alertas de compliance (se houver) e os caminhos dos arquivos.
