// sobrepostos.mjs — vídeos sobrepostos (B-roll) por cima da fala, sem tocar no kit/.
// Lido pelo montar.mjs. Sem assets/sobrepostos.json, nada muda (o exemplo continua idêntico à referência).
//
// assets/sobrepostos.json:
// {"sobrepostos": [
//   {"arquivo": "../brutos/sobrepostos/bandeja.mp4",  // relativo à pasta do motor (<projeto>/motor) ou absoluto
//    "em": "resina",            // frase exata da fala onde o sobreposto ENTRA (como K.at); ou "t": 31.4
//    "n": 1,                    // (opcional) N-ésima ocorrência da frase
//    "ate": "agendando uma",    // (opcional) frase onde ele SAI; ou "dur": 3.2 (segundos); padrão 2.5 s
//    "inicio": 1.5,             // (opcional) de onde começa dentro do arquivo, em segundos (padrão 0)
//    "modo": "full",            // "full" = tela cheia sobre o apresentador · "topo" = metade de cima (use com K.layout("split"))
//    "pos": "50% 50%"}          // (opcional) enquadramento do recorte (object-position)
// ]}
//
// O que faz: recorta cada trecho com ffmpeg em assets/sobrepostos/NN.mp4 (mudo, 30 fps, já no tamanho do lugar,
// com cache por especificação), põe um <video> por trecho na camada #broll (acima da câmera, abaixo das peças
// e da legenda) e liga/desliga a opacidade na timeline (seek-safe). O áudio é sempre o da fala.
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { isAbsolute, resolve } from "node:path";

const GEO = {
  full: { w: 1080, h: 1920, css: "left:0;top:0;width:1080px;height:1920px" },
  topo: { w: 976, h: 880, css: "left:52px;top:90px;width:976px;height:880px;border-radius:22px;box-shadow:0 30px 80px rgba(0,0,0,.55)" },
};
const norm = (s) => s.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/[^a-z0-9%$ ]+/g, " ").trim();

export function sobrepostos(words, dur) {
  const arq = "assets/sobrepostos.json";
  if (!existsSync(arq)) return null;
  const lista = (JSON.parse(readFileSync(arq, "utf8")).sobrepostos || []);
  if (!lista.length) return null;

  const WN = words.map((w) => ({ n: norm(w.text), s: w.start, e: w.end })).filter((w) => w.n);
  const at = (frase, nth = 1, after = 0) => {
    const p = norm(frase).split(/\s+/);
    let hit = 0;
    for (let i = 0; i <= WN.length - p.length; i++) {
      if (WN[i].s < after) continue;
      let ok = true;
      for (let j = 0; j < p.length; j++) if (WN[i + j].n.replace(/ /g, "") !== p[j]) { ok = false; break; }
      if (ok && ++hit === nth) return WN[i].s;
    }
    throw new Error(`sobrepostos.json: frase não encontrada no transcript: "${frase}" (#${nth}) — nunca chute tempo`);
  };

  mkdirSync("assets/sobrepostos", { recursive: true });
  const fmt = (x) => +x.toFixed(3);
  let html = "", js = "\n// ---- sobrepostos (gerado por sobrepostos.mjs a partir de assets/sobrepostos.json) ----\n";
  const usados = [];
  lista.forEach((s, i) => {
    const modo = GEO[s.modo] ? s.modo : "full";
    const g = GEO[modo];
    const t0 = s.t != null ? +s.t : at(s.em, s.n || 1);
    const t1 = s.ate ? at(s.ate, 1, t0 + 0.05) : t0 + (s.dur || 2.5);
    if (!(t1 > t0)) throw new Error(`sobrepostos.json #${i + 1}: o fim (${t1}) não vem depois do início (${t0})`);
    if (t1 > dur + 0.01) throw new Error(`sobrepostos.json #${i + 1}: passa do fim do vídeo (${t1.toFixed(2)} > ${dur})`);
    const fonte = isAbsolute(s.arquivo) ? s.arquivo : resolve(s.arquivo);
    if (!existsSync(fonte)) throw new Error(`sobrepostos.json #${i + 1}: arquivo não existe: ${fonte}`);
    const d = fmt(t1 - t0), ini = +(s.inicio || 0), pos = s.pos || "50% 50%";
    const nome = `assets/sobrepostos/${String(i + 1).padStart(2, "0")}.mp4`;
    const chave = JSON.stringify({ fonte, ini, d, modo, pos });
    if (!existsSync(nome) || !existsSync(nome + ".key") || readFileSync(nome + ".key", "utf8") !== chave) {
      const [px, py] = pos.split(" ").map((v) => parseFloat(v) / 100);
      const vf = `scale=${g.w}:${g.h}:force_original_aspect_ratio=increase,crop=${g.w}:${g.h}:(iw-${g.w})*${px}:(ih-${g.h})*${py},fps=30,format=yuv420p`;
      const r = spawnSync("ffmpeg", ["-y", "-v", "error", "-ss", String(ini), "-i", fonte, "-t", String(d), "-an", "-vf", vf,
        "-c:v", "libx264", "-preset", "veryfast", "-crf", "16", "-movflags", "+faststart", nome], { stdio: "inherit" });
      if (r.status !== 0) throw new Error(`ffmpeg falhou no sobreposto #${i + 1} (${fonte})`);
      const real = spawnSync("ffprobe", ["-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", nome], { encoding: "utf8" });
      if (parseFloat(real.stdout) < d - 0.1) console.warn(`AVISO: sobreposto #${i + 1} tem só ${(+real.stdout).toFixed(2)} s de material para ${d} s de fala (o último quadro congela)`);
      writeFileSync(nome + ".key", chave);
    }
    const id = `br${i + 1}`;
    html += `<div class="broll" id="${id}" style="position:absolute;${g.css};overflow:hidden;opacity:0"><video id="${id}v" src="${nome}" data-start="${fmt(t0)}" data-duration="${d}" data-track-index="${10 + i}" muted playsinline style="width:100%;height:100%;object-fit:cover"></video></div>`;
    js += `tl.set("#${id}", { opacity: 1 }, ${fmt(t0)}); tl.set("#${id}", { opacity: 0 }, ${fmt(t1)});\n`;
    usados.push(`${id} ${modo} ${t0.toFixed(2)}–${t1.toFixed(2)}s`);
  });
  writeFileSync("assets/sobrepostos/resumo.json", JSON.stringify(usados, null, 1));
  return { html: `<div id="broll" style="position:absolute;inset:0;pointer-events:none">${html}</div>\n  `, js, nota: `${usados.length} (${usados.join(" · ")})` };
}
