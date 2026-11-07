# ROTEIRO · template "Espelho Local" (criativo validado)

Modo ROTEIRO da skill `reel`. Cria roteiros completos de vídeo vertical 9:16 (50–70 s) com o framework extraído
de um **anúncio vencedor em alta performance** (64 s, talking head + split com fotos reais de casos → CTA WhatsApp).
Feito para profissionais e negócios locais de serviço (podologia, estética, odontologia, fisioterapia, dermatologia,
clínicas, salões, oficinas…); serve para **anúncio** (Meta Ads, Stories) e, com o CTA adaptado, para **reel orgânico**.

**Fórmula:** "Você é de [CIDADE] e seu [PROBLEMA] se parece com ESSE? (3 fotos) → fica que eu te ajudo → quem sou e
onde atendo → você é refém de [X] ou já tentou de tudo? → aqui é diferente (personalizado + técnicas com nome) →
como é a avaliação → só sabendo a causa real dá esse resultado (antes/depois) → se está disposto, clica no botão e
me chama no WhatsApp."

## Mapa da pasta
```
roteiro/
├── ROTEIRO.md                       ← este arquivo: fluxo e regras do modo ROTEIRO
├── briefing/
│   └── perguntas-para-responder.md  ← questionário para o cliente/apresentador preencher
├── framework/                       ← O QUE USAR para criar
│   ├── 01-briefing.md               ← campos/placeholders e como converter respostas
│   ├── 02-estrutura-8-blocos.md     ← blocos, tempos, funções, regras de copy, gatilhos
│   ├── 03-roteiro-template.md       ← roteiro preenchível + variações de hook e testes
│   ├── 04-specs-visuais.md          ← split-screen, legendas, selos, gestos, edição
│   ├── 05-formato-de-saida.md       ← o que entregar e onde salvar
│   ├── 06-checklist.md              ← validação final + anticontaminação + compliance
│   ├── 07-exemplo-aplicado.md       ← exemplo fictício em outro nicho (calibração)
│   └── 08-do-roteiro-a-edicao.md    ← como o roteiro vira edição no motor VSL (fala, sobrepostos, fotos)
├── scripts/
│   └── checar-contaminacao.sh       ← procura placeholders e termos do original
└── referencia-vencedor/             ← SÓ ESTUDO: o anúncio original (não copiar conteúdo)
    ├── LEIA-ME.md · transcricao.txt · decomposicao-original.md · analise-ads-vencedor.html
    └── frames/tSS-Ds.jpg            ← frames-chave (nome = tempo, ex.: t05-0s = 5,0 s)
```
`S=~/.claude/skills/reel` · `R=$S/roteiro`.

## Fluxo
1. **Projeto.** `bash $S/novo-projeto.sh <cidade>-<profissional>-<problema>-<AAAA-MM-DD>` no diretório de trabalho
   (ou use a pasta de projeto que já existe). Tudo deste modo vai para `<projeto>/roteiro/`.
2. **Briefing.**
   - Sem os dados do cliente: copie `$R/briefing/perguntas-para-responder.md` para `<projeto>/roteiro/briefing.md`
     e entregue para ser preenchido.
   - Com respostas (preenchidas ou no chat): converta nos placeholders de `framework/01-briefing.md`. Pergunte só
     o que faltar e não der para inferir.
3. Ler `framework/02-estrutura-8-blocos.md` e `framework/04-specs-visuais.md`.
4. Para calibrar ritmo e tom: `framework/07-exemplo-aplicado.md` e, se necessário,
   `referencia-vencedor/decomposicao-original.md` e os frames (só leitura).
5. Preencher `framework/03-roteiro-template.md` com os dados do NOVO cliente. Ajustar concordância
   (seu/sua, esse/essa, do/da) e deixar a fala natural, sem perder a estrutura.
6. Montar a entrega conforme `framework/05-formato-de-saida.md`. A `shot-list.md` separa o que gravar em **fala**
   (`brutos/fala/`), **sobrepostos** (`brutos/sobrepostos/`) e **fotos** (`brutos/fotos/`), como em
   `framework/08-do-roteiro-a-edicao.md`.
7. Validar com `framework/06-checklist.md` e rodar `bash $R/scripts/checar-contaminacao.sh <projeto>/roteiro`.
   Reportar o resultado.
8. Quando a pessoa voltar com as gravações, siga o modo EDIÇÃO (`edicao/EDICAO.md`) na mesma pasta de projeto,
   com o mapa do `framework/08-do-roteiro-a-edicao.md`.

## Reel orgânico (sem anúncio)
A estrutura dos 8 blocos fica igual. Mudam só: o CTA do bloco 8 (de "clica no botão aqui embaixo e me chama no
WhatsApp" para "comenta `PALAVRA` que eu te mando no direct" ou "me chama no direct", palavra-código em CAIXA ALTA)
e a zona segura da edição (perfil `reels`). Não invente outro framework: se o vídeo não é de serviço local
(ex.: conteúdo educativo), diga que o template não se aplica e pergunte o que a pessoa quer.

## Regras obrigatórias
1. **`framework/` é a fonte para criar.** Todo roteiro nasce do template preenchido com o briefing do NOVO cliente.
2. **`referencia-vencedor/` é só leitura**, para entender ritmo, tom, layout. Nunca copie dela nomes, cidade,
   bairro, nicho, problema, técnicas, frequências ou frases específicas.
3. **Nunca grave nada dentro da pasta da skill.** Roteiros vão para `<projeto>/roteiro/`.
4. **Termos do original proibidos** num roteiro de outro cliente (salvo se o novo briefing for de fato igual):
   `Thainá`, `Rodrigues`, `São Carlos`, `Santa Felícia`, `podóloga/podologia`, `unha`, `manicure`, `15 dias`,
   `fotopolimerizável`, `fio de aço`, `curvatura`.
5. **Dado faltando → pergunte.** Nunca preencha com o exemplo da referência nem invente técnica, número ou resultado.
6. **Não remova nem reordene os blocos 1, 2, 4 e 8.** O bloco 7 pode encolher (versão ~50 s).

## Ética / compliance
Só fotos reais de casos do próprio profissional, com autorização escrita do paciente/cliente. Não prometa cura nem
prazo. Antes/depois tem restrições em alguns conselhos (ex.: CFO, CFM, COFFITO) e nas políticas de anúncios da Meta
para saúde. Escassez/urgência só se for verdade. Alerte o usuário quando o nicho for sensível. As regras da casa
(`regras-da-casa.md`, R3 e R11) valem também aqui.
