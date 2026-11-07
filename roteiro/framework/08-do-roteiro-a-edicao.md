# 08 · Do roteiro à edição (Espelho Local × motor VSL)

O roteiro (blocos 1–8) diz **o que** é falado e mostrado; o motor VSL (`edicao/`) diz **como** aparece. Este arquivo
liga os dois: o que gravar em cada tipo de material e qual layout/peça do kit faz cada bloco. Vale para a `shot-list.md`
(modo ROTEIRO) e para o `assets/map.md` + `src/beats.js` (modo EDIÇÃO). As regras da casa (R1–R11) valem por cima.

## Os três tipos de material
| Tipo | Pasta no projeto | No roteiro (`shot-list.md`) | Na edição |
|---|---|---|---|
| **Fala** | `brutos/fala/` | talking heads de cada bloco, olhando na lente, peito pra cima, gesto indicado. Pode ser um arquivo ou uma parte por bloco (`01-hook.mp4`…) | `juntar-falas.sh` → motor de corte → câmera do motor VSL (FULL/SPLIT) |
| **Sobrepostos** | `brutos/sobrepostos/` | B-roll real: materiais e equipamentos com a mão mostrando (bloco 6), sala/fachada (bloco 3), processo da avaliação (bloco 7). 5–10 s cada, sem fala, celular na vertical | `motor/assets/sobrepostos.json` (`modo: "full"` ou `"topo"`), ancorado na frase |
| **Fotos** | `brutos/fotos/` | `FOTO_1..3` (gravidade crescente), `DEPOIS_HOOK`, `AD_1`, `AD_2` (antes/depois, mesmo ângulo/luz), logo | `motor/assets/img/` + `K.grid` / `K.pill` (receitas abaixo) |

Nunca troque material real por imagem gerada nos blocos 1, 2, 6 e 8: foto de caso, antes/depois e técnica são
prova (R3). Imagem gerada (Codex) só para conceito/ambiente que não é prova, e declarada.

## Bloco a bloco
| # | Bloco | Layout no motor | Material | Peça do kit (receita, sempre por `K.at`) |
|---|---|---|---|---|
| 1 | HOOK ESPELHO 0–6 s | `K.layout("split", 0, 0)` desde o início; o apresentador aponta para cima, para a foto | fotos `FOTO_1..3` | uma foto por dêitico: `K.grid([{img:"assets/img/foto-1.jpg", label:"", badge:["1/3"], t:K.at("esse daqui")}], {cols:1, w:900, h:760, top:150, until:K.at("ou até mesmo")})`, depois `2/3`, `3/3` em "ou até mesmo", "ou essa". Troca seca, sem whoosh entre fotos |
| 2 | RETENÇÃO 6–8 s | continua `split` | foto `DEPOIS_HOOK` | mesma receita com `badge:["DEPOIS"]` + `K.pill("DEPOIS", t, {kind:"solid", y:820, sm:true})` na palavra "fica" |
| 3 | AUTORIDADE 8–12 s | `K.layout("full", K.at("meu nome"))` (troca animada, `K.hideMouth` na troca) | fala; opcional sobreposto `full` da fachada/sala (≤ 1,5 s, no "atendo no") | lower-third no peito: `K.pill("[NOME]", K.at("meu nome"), {y:1180, kind:"dark", icon:false})` + `K.pill("[PROFISSÃO] EM [CIDADE]", K.at("sou"), {y:1250, sm:true, kind:"solid", icon:false})` |
| 4 | DOR + INIMIGO + OBJEÇÃO 12–20 s | `full`, punch-in alternando (`K.punch`) a cada 2–4 s | fala | lettering no peito na palavra emocional: `K.pill("REFÉM", K.at("refém"), {kind:"strike"})`; frequência como pílula em "a cada" |
| 5 | VIRADA + DIFERENCIAÇÃO 20–31 s | `full` → `split` na regra de três | fala (mãos abertas) | regra de três: `K.stack` ou três `K.pill` empilhadas, uma em cada "pra cada tipo de" |
| 6 | MECANISMO 31–36 s | **sobreposto `full`** dos materiais (B-roll real), um por técnica se houver | sobrepostos | `sobrepostos.json`: `{"em":"[TÉCNICA_1]","ate":"[TÉCNICA_2]","modo":"full"}`… + `K.pill("[TÉCNICA_N]", K.at("[TÉCNICA_N]"), {y:1180})` com o nome técnico. `K.hideMouth` no trecho |
| 7 | PROCESSO 36–52 s | `full` ↔ `split` | fala (contando nos dedos); opcional sobreposto `topo` do atendimento | perguntas da avaliação como `K.chain`/`K.stack` (uma por pergunta, na palavra) |
| 8 | CAUSA REAL + PROVA + CTA 52–64 s | `K.layout("hidden", K.at("esse tipo de resultado"))` para os antes/depois; depois `full` no CTA | fotos `AD_1`, `AD_2` | prova: `K.grid([{img:ad1antes,label:"ANTES",t}, {img:ad1depois,label:"DEPOIS",t:t+0.4}], {cols:1, w:900, h:620, top:300, until:t2})`, e o `AD_2` em seguida. CTA: `K.cta("AGENDE PELO [CANAL]", K.at("clica no botão"), {y:1060})` (anúncio) — seta/chevrons já vêm no `K.cta` |

Observações:
- **Alvo de ritmo do roteiro** (jump cut / algo novo a cada 2–4 s) e do motor (1,5–3 s) se encontram: punch, pílula,
  sobreposto e troca de layout contam como "algo novo".
- **Legenda**: o motor já faz legenda palavra a palavra que segue a boca (`K.mouthCaps`), com as palavras-chave em
  destaque — cumpre o "1–3 palavras, sincronizada" de `04-specs-visuais.md`. Não desenhe outra legenda por cima.
- **Cores**: a pele nativa do motor é roxa. Para anúncio de cliente, crie `<projeto>/pele-resolvida.json` com as
  cores da marca (`"cores": {"origem": "marca", "fundo", "texto", "destaque", "apoio", "acento2"}`); o `K.cta` usa a
  cor de destaque — se a marca pedir o verde do WhatsApp (#25D366) no botão, use-o como `destaque`. A pele do rosto
  não muda (R4).
- **Zona segura**: anúncio pago → perfil `anuncio` (veja o passo 3.2 de `edicao/EDICAO.md`: `safe` e `capY` no
  `vsl.json`, `--profile ads`, `--perfil anuncio`). Reel orgânico → perfil `reels` (padrão).
- **Gesto × peça**: a foto troca no instante em que a pessoa aponta e fala "esse daqui"; se o corte deslocou o
  gesto, a âncora é a fala (`K.at`), nunca o gesto.
- **Antes/depois**: confirme as regras do conselho do nicho antes de montar o bloco 8 (`06-checklist.md`, compliance).
  Sem antes/depois permitido → depoimento em print ou demonstração do processo em sobreposto.

As receitas acima usam peças que existem em `edicao/motor-vsl/kit/kit.js` (veja a assinatura no comentário de cada
`K.*`). Confira cada uma no snapshot (R1: nada sobre o rosto; R7: zona segura) e ajuste `y`/`top` pelo enquadramento
medido do vídeo.
