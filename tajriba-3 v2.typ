// =====================================================================
//  TAJRIBA MASHGʻULOTI №2
//  Pnevmoyuritma yuklama xarakteristikasini aniqlash
//  Fan: Mexatron modul va robotlarning yuritmalari
// =====================================================================

#let headingblue = rgb("#1F4E79")

#set document(title: "Pnevmoyuritma yuklama xarakteristikasini aniqlaş")
#set page(paper: "a4", margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm))
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = "3 v2"  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (2fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Tajriba №#raqam],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================
#set text(size: 12pt, lang: "uz", font: info.font)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1.")
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): it => block(above: 1.4em, below: 0.8em, it)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")
#show figure.where(kind: table): set figure.caption(position: top)
#set math.equation(supplement: none)
#let d(s) = text(font: "New Computer Modern Math", s)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)
#show ref: it => {
  let el = it.element
  if el != none and el.func() == math.equation { [(#it)] } else { it }
}

// --- booktabs uslubidagi jadval ---
#let btable(columns: auto, header: (), ..rows) = table(
  columns: columns,
  stroke: none,
  align: center + horizon,
  inset: (x: 5pt, y: 4.5pt),
  table.hline(stroke: 1pt),
  table.header(..header.map(h => text(weight: "bold", h))),
  table.hline(stroke: 0.5pt),
  ..rows,
  table.hline(stroke: 1pt),
)

// =====================================================================
//  Chizma yordamchilari (faqat Typst ning oʻz vositalari, paketlarsiz)
//  Koordinatalar sm da, y oʻqi yuqoriga yoʻnalgan.
// =====================================================================
#let sxema(w, h, u: 1cm, items) = box(width: w * u, height: h * u, {
  for it in items { it(u, h) }
})
#let _p(p, u, h) = (p.at(0) * u, (h - p.at(1)) * u)
#let L(..pts, st: 0.8pt + black) = (u, h) => {
  let ps = pts.pos()
  place(top + left, curve(stroke: st, curve.move(_p(ps.at(0), u, h)), ..ps.slice(1).map(q => curve.line(_p(q, u, h)))))
}
#let R(x, y, w, hh, fill: none, st: 0.8pt + black, r: 0pt) = (u, h) => place(
  top + left,
  dx: x * u,
  dy: (h - y - hh) * u,
  rect(width: w * u, height: hh * u, fill: fill, stroke: st, radius: r),
)
#let Cc(x, y, r, fill: white, st: 0.8pt + black) = (u, h) => place(
  top + left,
  dx: (x - r) * u,
  dy: (h - y - r) * u,
  circle(radius: r * u, fill: fill, stroke: st),
)
#let T(x, y, body, a: "c", size: 9pt) = (u, h) => {
  let c = text(size: size, body)
  if a == "c" {
    place(top + left, dx: x * u - 4cm, dy: (h - y) * u - 1cm, box(width: 8cm, height: 2cm, align(center + horizon, c)))
  } else if a == "l" {
    place(top + left, dx: x * u, dy: (h - y) * u - 1cm, box(width: 8cm, height: 2cm, align(left + horizon, c)))
  } else if a == "r" {
    place(top + left, dx: x * u - 8cm, dy: (h - y) * u - 1cm, box(width: 8cm, height: 2cm, align(right + horizon, c)))
  } else if a == "b" {
    place(top + left, dx: x * u - 4cm, dy: (h - y) * u - 2cm, box(width: 8cm, height: 2cm, align(center + bottom, c)))
  } else { place(top + left, dx: x * u - 4cm, dy: (h - y) * u, box(width: 8cm, height: 2cm, align(center + top, c))) }
}
// Strelka: (x1,y1) → (x2,y2), uchida toʻldirilgan uchburchak
#let Ar(x1, y1, x2, y2, st: 0.8pt + black, col: black, s: 0.18) = (u, h) => {
  let ang = calc.atan2(x2 - x1, y2 - y1)
  let bx = x2 - s * calc.cos(ang)
  let by = y2 - s * calc.sin(ang)
  let nx = -calc.sin(ang) * s * 0.45
  let ny = calc.cos(ang) * s * 0.45
  place(top + left, curve(stroke: st, curve.move(_p((x1, y1), u, h)), curve.line(_p((bx, by), u, h))))
  place(top + left, polygon(fill: col, stroke: none, _p((x2, y2), u, h), _p((bx + nx, by + ny), u, h), _p(
    (bx - nx, by - ny),
    u,
    h,
  )))
}

// =====================================================================
//  Stend parametrlari va nazariy model (grafiklar shu qiymatlardan quriladi)
// =====================================================================
#let D = 0.025          // porshen diametri, m
#let dd = 0.010         // shtok diametri, m
#let A1 = calc.pi * D * D / 4
#let A2 = calc.pi * (D * D - dd * dd) / 4
#let Pa = 1.013e5       // atmosfera bosimi, Pa
#let P0 = 1.0e5         // ISO 6358 normal bosimi, Pa
#let bk = 0.30          // drosselning kritik bosim nisbati
#let Cd = 1.231e-9      // drossel oʻtkazuvchanligi, m³/(s·Pa) (tajribadan)
#let Ff = 15.0          // ishqalanish kuchi, N (1-topshiriqdan)

#let vth(F, ps) = {
  let p2 = (ps * A1 - F - Ff) / A2
  if p2 <= 0 { 0.0 } else {
    let r = Pa / (p2 + Pa)
    let phi = if r <= bk { 1.0 } else {
      calc.sqrt(calc.max(0.0, 1 - calc.pow((r - bk) / (1 - bk), 2)))
    }
    Cd * P0 * phi / A2
  }
}
#let Fmax(ps) = ps * A1 - Ff

// --- Tajriba maʼlumotlari (2- va 3-jadval) ---
#let F6 = (14.7, 63.8, 112.8, 161.9, 210.9, 235.4, 260.0, 274.7)
#let v6 = (0.300, 0.298, 0.302, 0.294, 0.298, 0.282, 0.221, 0.096)
#let F4 = (14.7, 39.2, 63.8, 88.3, 112.8, 137.3, 161.9, 176.6)
#let v4 = (0.293, 0.296, 0.303, 0.301, 0.298, 0.278, 0.224, 0.095)

// --- Grafik chizgich: x — kuch (N), y — ixtiyoriy kattalik ---
#let plot(xmax, ymax, xstep, ystep, xlab, ylab, curves: (), pts: (), legend: (), lpos: "top", w: 13, h: 7.5) = {
  let ox = 1.4
  let oy = 1.1
  let pw = w - ox - 0.4
  let ph = h - oy - 0.4
  let X(x) = ox + x / xmax * pw
  let Y(y) = oy + y / ymax * ph
  let items = ()
  // toʻr va belgilar
  let nx = int(calc.round(xmax / xstep))
  let ny = int(calc.round(ymax / ystep))
  for i in range(nx + 1) {
    let x = i * xstep
    items.push(L((X(x), oy), (X(x), oy + ph), st: 0.4pt + luma(200)))
    items.push(T(X(x), oy - 0.12, str(calc.round(x, digits: 2)).replace(".", ","), a: "t", size: 8pt))
  }
  for j in range(ny + 1) {
    let y = j * ystep
    items.push(L((ox, Y(y)), (ox + pw, Y(y)), st: 0.4pt + luma(200)))
    items.push(T(ox - 0.12, Y(y), str(calc.round(y, digits: 2)).replace(".", ","), a: "r", size: 8pt))
  }
  items.push(L((ox, oy), (ox + pw, oy), (ox + pw, oy + ph), (ox, oy + ph), (ox, oy), st: 0.8pt))
  items.push(T(ox + pw / 2, 0.3, xlab, size: 9pt))
  items.push(T(0.15, oy + ph / 2, rotate(-90deg, reflow: true, ylab), size: 9pt))
  for c in curves {
    let ps = c.pts.map(p => (X(p.at(0)), Y(p.at(1))))
    items.push(L(..ps, st: c.st))
  }
  for s in pts {
    for p in s.pts {
      items.push(Cc(X(p.at(0)), Y(p.at(1)), 0.08, fill: s.fill, st: 0.6pt + black))
    }
  }
  for (k, lg) in legend.enumerate() {
    let ly = if lpos == "top" { oy + ph - 0.35 - k * 0.45 } else { oy + 0.35 + (legend.len() - 1 - k) * 0.45 }
    items.push(L((ox + 0.3, ly), (ox + 0.9, ly), st: lg.st))
    if lg.at("fill", default: none) != none { items.push(Cc(ox + 0.6, ly, 0.08, fill: lg.fill, st: 0.6pt)) }
    items.push(T(ox + 1.05, ly, lg.label, a: "l", size: 8pt))
  }
  sxema(w, h, items)
}

#let sampleF(ps, n: 120) = range(n + 1).map(i => {
  let F = i / n * Fmax(ps)
  (F, vth(F, ps))
})

// =====================================================================
//                              HUJJAT
// =====================================================================

#align(center)[
  #text(size: 14pt, weight: "bold", fill: headingblue)[TAJRIBA MAŞĞULOTI №3]
  #v(0.4em)
  #text(size: 13pt, weight: "bold")[Mavzu: Pnevmoyuritma yuklama xarakteristikasini aniqlaş]
]
#v(1em)

= Işning maqsadi

Pnevmatik yuritma (pnevmosilindr) porşenining harakat tezligi bilan unga taʼsir
etuvçi taşqi yuklama orasidagi boğliqlikni --- yuklama xarakteristikasini
$v = f(F_"yuk")$ tajriba yöli bilan aniqlaş. Maşğulot davomida talaba:

- pnevmosilindrning statik (maksimal) kuçini, işqalaniş kuçini va mexanik
  FIK ini ölçaydi;
- çiqişni drossellaş ("meter-out") sxemasida ikki xil taʼminot bosimi uçun
  $v = f(F_"yuk")$ va $p_2 = f(F_"yuk")$ boğliqliklarini quradi;
- tajriba natijalaridan drossel ötkazuvçanligini aniqlab, ISO 6358 modeli
  asosidagi nazariy xarakteristika bilan soliştiradi;
- foydali quvvat $N = f(F_"yuk")$ böyiça yuritmaning optimal yuklaniş
  oraliğini baholaydi.

= Nazariy maʼlumot

== Yuklama xarakteristikasi tuşunçasi

Pnevmoyuritmaning *yuklama xarakteristikasi* deb taʼminot bosimi $p_s$ va
drossel sozlanişi özgarmas bölganda porşenning barqaror harakat tezligi $v$
ning taşqi yuklama kuçi $F_"yuk"$ ga boğliqligiga aytiladi. Elektr
yuritmalardagi mexanik xarakteristikaga öxşab, u yuritma qanday yuklamada
qanday tezlik berişini va qaysi yuklamada töxtab qolişini körsatadi.
Robotlarning uşlagiç va kötariş mexanizmlarini loyihalaşda aynan şu
xarakteristika böyiça silindr ölçami va drossel sozlanişi tanlanadi.

== Porşenning kuçlar muvozanati

Ikki tomonlama pnevmosilindrning porşen tomoni yuzasi $A_1$ va ştok tomonidagi
halqasimon yuzasi $A_2$:

#eq($ A_1 = (pi D^2) / 4, quad A_2 = (pi (D^2 - d^2)) / 4 $) <eq-area>

bunda $D$ --- porşen diametri, $d$ --- ştok diametri. Porşen barqaror
(tezlanişsiz) harakatlanganda unga taʼsir etuvçi kuçlar muvozanati
manometrik bosimlarda quyidagiça yoziladi:

#eq($ p_1 A_1 - p_2 A_2 = F_"yuk" + F_"işq" $) <eq-balance>

bunda $p_1$ --- işçi (porşen tomonidagi) kameradagi bosim, $p_2$ --- çiqiş
(ştok tomonidagi) kameradagi bosim, $F_"işq"$ --- ziçlagiçlar va
yönaltiruvçilardagi işqalaniş kuçi.

== Statik kuç va mexanik FIK

Ştok qözğalmas tösiqqa tiralganda çiqiş kamerasidagi havo töliq
çiqib ketadi ($p_2 = 0$), işçi kamerada esa taʼminot bosimi $p_s$
örnatiladi. Bunda silindr özining *maksimal (statik) kuçini* beradi:

#eq($ F_"st" = p_s A_1 - F_"işq" $) <eq-fst>

Nazariy kuç $F_"naz" = p_s A_1$ ga nisbatan mexanik FIK:

#eq($ eta_m = F_"st" / F_"naz" = F_"st" / (p_s A_1) $) <eq-etam>

Yuklama xarakteristikasida $F_"st"$ tezlik nolga teng böladigan nuqtaga mos
keladi, şu sababli uni $F_"max"$ deb ham belgilaymiz.

== Çiqişni drossellaşda porşen tezligi

Çiqişni drossellaş ("meter-out") sxemasida porşen tezligini ştok
tomonidagi kameradan atmosferaga çiqayotgan havo oqimi belgilaydi. ISO 6358
standarti böyiça drossel orqali ötuvçi massaviy sarf:

#eq($ q_m = C p_2^"abs" rho_0 sqrt(T_0 / T) dot phi $) <eq-iso>

bunda $C$ --- drosselning tovuş ötkazuvçanligi, m³/(s·Pa); $p_2^"abs" =
p_2 + p_a$ --- drosseldan oldingi absolyut bosim; $rho_0$, $T_0$ --- normal
şaroitdagi ziçlik va harorat ($P_0 = 100$ kPa, $T_0 = 293$ K); $phi$ ---
oqim rejimi koeffitsiyenti:

#eq(
  $
    phi = cases(
      1\, & "agar" p_a / p_2^"abs" <= b quad "(kritik rejim)",
      sqrt(1 - ((p_a \/ p_2^"abs" - b) / (1 - b))^2)\, & "agar" p_a / p_2^"abs" > b quad "(kritik bölmagan rejim)"
    )
  $,
) <eq-phi>

bunda $b$ --- kritik bosim nisbati (drossel pasportida beriladi, odatda
$b = #d("0,2") dots #d("0,5")$). Izotermik jarayon deb faraz qilsak, kameradan çiqayotgan
hajmiy sarf $Q_2 = q_m \/ rho_2 = C P_0 phi$ böladi va porşen tezligi:

#eq($ v = Q_2 / A_2 = (C P_0 phi) / A_2 $) <eq-v>

== Yuklama xarakteristikasining şakli

@eq-balance, @eq-phi va @eq-v dan quyidagi muhim xulosalar kelib çiqadi:

+ *Kritik rejimda* ($phi = 1$) tezlik yuklamaga ham, taʼminot bosimiga ham
  boğliq emas: $v_"max" = C P_0 \/ A_2$. Bu A. Parr kitobidagi "bosim tezlikka
  emas, faqat tezlanişga taʼsir qiladi" degan qoidaning miqdoriy ifodasidir.
+ Yuklama ortişi bilan $p_2$ kamayadi. $p_a \/ p_2^"abs" = b$ bölgan
  nuqtadan boşlab oqim kritik bölmagan rejimga ötadi va tezlik keskin
  pasaya boşlaydi. Bu nuqtaga mos *kritik yuklama*:
  #eq($ F_"kr" = p_s A_1 - (p_a / b - p_a) A_2 - F_"işq" $) <eq-fkr>
+ $F_"yuk" -> F_"max"$ da $p_2 -> 0$ va $v -> 0$: yuritma töxtaydi.
+ Kiçik yuklamalarda $p_2$ taʼminot bosimidan *katta* bölişi mumkin, çunki
  $A_2 < A_1$: @eq-balance da $F_"yuk" approx 0$ bölsa, $p_2 approx p_1 A_1 \/ A_2$.

@fig-theory da @eq-v böyiça qurilgan nazariy xarakteristikalar keltirilgan.
Ikkala bosimda ham tekis qism ("plato") bir xil tezlikka ega, lekin yuqori
bosimda u kattaroq yuklamagaça saqlanadi.

#figure(
  plot(
    300,
    0.35,
    50,
    0.05,
    [$F_"yuk"$, N],
    [$v$, m/s],
    lpos: "bottom",
    curves: (
      (pts: sampleF(6e5), st: 1.4pt + headingblue),
      (pts: sampleF(4e5), st: (paint: rgb("#C0504D"), thickness: 1.4pt, dash: "dashed")),
    ),
    legend: (
      (st: 1.4pt + headingblue, label: [$p_s = 6$ bar]),
      (st: (paint: rgb("#C0504D"), thickness: 1.4pt, dash: "dashed"), label: [$p_s = 4$ bar]),
    ),
  ),
  caption: [Çiqişni drossellaşda pnevmoyuritmaning nazariy yuklama
    xarakteristikalari ($D = 25$ mm, $d = 10$ mm, $b = #d("0,3")$)],
) <fig-theory>

== Foydali quvvat va yuklama koeffitsiyenti

Yuritmaning foydali mexanik quvvati va nisbiy yuklanişi:

#eq($ N = F_"yuk" dot v, quad chi = F_"yuk" / F_"max" $) <eq-power>

Kiçik yuklamada tezlik katta, lekin kuç kiçik; $F_"max"$ ga yaqinda esa
aksinça. Şu sababli $N$ maʼlum $chi$ da maksimumga erişadi. Amaliyotda
pnevmosilindrlar dinamik yuklamada $chi = #d("0,5") dots #d("0,8")$ oraliğida
işlatiladi: bunda tezlik barqaror va quvvat yuqori böladi.

= Kerakli jihozlar

+ *Pnevmatik laboratoriya stendi* --- ikki tomonlama pnevmosilindr
  ($D = 25$ mm, $d = 10$ mm, $S = 200$ mm), vertikal örnatilgan, ştok
  uçida yuk platformasi (harakatlanuvçi qismlar massasi $m_0 = #d("1,5")$ kg).
+ *FRL bloki* (filtr, bosim regulyatori, manometr 0--10 bar).
+ *5/2-yölli monostabil elektropnevmotaqsimlagiç* (Y1 ğaltagi).
+ *Bir tomonlama drossel* (drossel + teskari klapan) --- ştok tomonidagi
  liniyada, çiqişni drossellaş uçun.
+ *Ikkita bosim datçigi* P1, P2 (0--10 bar).
+ *Ikkita magnit-kontakt (gerkon) datçigi* B1, B2 --- yurişning örta
  qismida, oraliği $L_0 = 150$ mm.
+ *Elektron taymer yoki PLC* (vaqt ölçaş aniqligi 1 ms).
+ *Yuklar töplami* (2,5 kg li yuklar, jami 27,5 kg gaça).
+ *Dinamometr (kuç datçigi)* 0--500 N --- statik kuçni ölçaş uçun.
+ *Dasturiy muhit:* Python 3 (`numpy`, `matplotlib` kutubxonalari).

= Tajriba stendining sxemasi

#figure(
  sxema(15.5, 9.6, (
    // taʼminot va FRL
    R(0, 0.6, 2.2, 1.2, fill: luma(240)),
    T(1.1, 1.2, [Taʼminot\ (kompressor)]),
    R(3.0, 0.6, 2.2, 1.2, fill: luma(240)),
    T(4.1, 1.2, [FRL bloki\ (regulyator)]),
    Ar(2.2, 1.2, 3.0, 1.2),
    Cc(4.1, 2.25, 0.3),
    T(4.1, 2.25, [M], size: 8pt),
    L((4.1, 1.8), (4.1, 1.95)),
    T(4.6, 2.25, [$p_s$], a: "l"),
    // taqsimlagich
    R(5.9, 0.6, 2.6, 1.2, fill: luma(240)),
    T(7.2, 1.2, [5/2 taqsimlagiç\ (Y1)]),
    Ar(5.2, 1.2, 5.9, 1.2),
    // A1 liniyasi (porshen tomoni)
    L((7.9, 1.8), (7.9, 3.0), (10.0, 3.0), st: 1.2pt + headingblue),
    Cc(8.9, 3.0, 0.22, fill: white),
    T(8.9, 3.0, [P1], size: 7pt),
    // A2 liniyasi (shtok tomoni) — drossel bilan
    L((6.5, 1.8), (6.5, 4.0), st: 1.2pt + rgb("#C0504D")),
    R(6.05, 4.0, 0.9, 1.1, fill: white),
    L((6.25, 4.15), (6.75, 4.95), st: 0.8pt),
    Ar(6.15, 4.2, 6.9, 4.9, s: 0.15),
    T(5.95, 4.55, [Drossel\ (DT)], a: "r", size: 8pt),
    L((6.5, 5.1), (6.5, 6.7), (10.0, 6.7), st: 1.2pt + rgb("#C0504D")),
    Cc(8.9, 6.7, 0.22, fill: white),
    T(8.9, 6.7, [P2], size: 7pt),
    // silindr
    R(10.0, 2.6, 1.6, 4.5, st: 1pt + black),
    R(10.05, 4.0, 1.5, 0.3, fill: luma(150), st: 0.6pt),
    T(10.8, 3.35, [$A_1$], size: 9pt),
    T(10.33, 5.6, [$A_2$], size: 9pt),
    R(10.65, 4.3, 0.3, 4.0, fill: luma(200), st: 0.6pt),
    // platforma va yuk
    R(9.8, 8.3, 2.0, 0.25, fill: luma(120), st: 0.6pt),
    R(10.2, 8.55, 1.2, 0.7, fill: luma(225)),
    T(10.8, 8.9, [$m$], size: 10pt),
    Ar(12.4, 9.3, 12.4, 8.2, st: 1.2pt + black),
    T(12.55, 8.75, [$F_"yuk" = (m + m_0) g$], a: "l", size: 8pt),
    // gerkonlar
    R(11.6, 3.55, 0.45, 0.35, fill: white),
    T(12.15, 3.72, [B1], a: "l", size: 8pt),
    R(11.6, 5.85, 0.45, 0.35, fill: white),
    T(12.15, 6.02, [B2], a: "l", size: 8pt),
    L((12.9, 3.72), (13.3, 3.72), st: 0.5pt),
    L((12.9, 6.02), (13.3, 6.02), st: 0.5pt),
    L((13.1, 3.72), (13.1, 6.02), st: 0.5pt),
    T(13.2, 4.87, [$L_0 = 150$ mm], a: "l", size: 8pt),
    // taymer
    R(12.9, 0.6, 2.4, 1.3, fill: luma(240)),
    T(14.1, 1.25, [Taymer / PLC]),
    L((11.82, 3.55), (11.82, 2.3), (13.5, 2.3), (13.5, 1.9), st: (paint: black, thickness: 0.6pt, dash: "dashed")),
    L((11.82, 6.2), (11.82, 7.4), (15.1, 7.4), (15.1, 1.9), st: (paint: black, thickness: 0.6pt, dash: "dashed")),
  )),
  caption: [Tajriba stendining soddalaştirilgan sxemasi: kök liniya ---
    işçi kamera (P1), qizil liniya --- çiqiş kamerasi va drossel (P2)],
) <fig-stand>

Taqsimlagiç Y1 ğaltagiga kuçlaniş berilganda havo porşen tomoniga keladi,
ştok tomonidagi havo esa drossel DT orqali atmosferaga çiqadi. Porşen
yuqoriga harakatlanib, yukni kötaradi. Tezlik B1 va B2 datçiklari orasidagi
$L_0$ masofani bosib ötiş vaqti böyiça aniqlanadi: bu oraliq yurişning
örta qismida joylaşgani uçun tezlaniş va dempferlaş hududlari ölçovga
taʼsir qilmaydi.

= Xavfsizlik talablari

- Sxemani faqat bosim olib taşlangan holda (regulyator nolda, liniya
  böşatilgan) yiğiş va özgartiriş mumkin.
- Yuklarni platformaga faqat porşen pastki holatda va taqsimlagiç öçiq
  bölganda qöyiş kerak; harakat vaqtida qölni platforma ostiga tiqmang.
- Taʼminot bosimi 6 bar dan oşirilmaydi.

= Işni bajariş tartibi

== 1-topşiriq. Statik kuç va işqalanişni aniqlaş

+ Silindrni gorizontal tayançga mahkamlab, ştok uçini dinamometrga tiring.
+ Regulyator bilan $p_s = 4$ bar örnating, Y1 ni yoqing va dinamometr
  körsatkiçi barqarorlaşgaç $F_"st"$ ni yozib oling.
+ Ölçovni $p_s = 5$ va $6$ bar uçun takrorlang. Natijalarni 1-jadvalga
  kiriting.
+ @eq-fst va @eq-etam böyiça $F_"işq"$ va $eta_m$ ni hisoblang.

== 2-topşiriq. $p_s = 6$ bar da yuklama xarakteristikasi

+ Silindrni vertikal holatga qaytaring, $p_s = 6$ bar örnating.
+ Yuksiz platformada ($m = 0$) drossel DT ni porşen tezligi taxminan
  $#d("0,3")$ m/s böladigan qilib sozlang va drossel vintini *keyingi barça
  ölçovlar davomida özgartirmang*.
+ Y1 ni yoqib, porşenni kötaring; taymerdan B1→B2 vaqti $t$ ni, harakat
  davomida P1 va P2 körsatkiçlarini yozib oling. Har bir yuklamada
  ölçovni 3 marta takrorlab, örtaçasini oling.
+ Platformaga ketma-ket yuk qöşib (2-jadvaldagi $m$ qiymatlari), 3-bandni
  takrorlang. Yuklama $F_"max"$ ga yaqinlaşganda yukni kiçikroq qadam bilan
  oşiring.

== 3-topşiriq. $p_s = 4$ bar da yuklama xarakteristikasi

+ Drossel sozlanişini özgartirmasdan regulyatorda $p_s = 4$ bar örnating.
+ 2-topşiriqdagi ölçovlarni 3-jadvaldagi yuklamalar uçun takrorlang.

= Ölçov natijalari

Quyidagi jadvallarda namunaviy ölçov natijalari keltirilgan. Talaba öz
ölçovlarini xuddi şu şakldagi jadvallarga kiritadi.

#figure(
  btable(
    columns: 5,
    header: ([$p_s$, \ bar], [$F_"naz" = p_s A_1$, \ N], [$F_"st"$, \ N], [$F_"işq"$, \ N], [$eta_m$]),
    [4],
    [196,3],
    [181,4],
    [15,0],
    [0,924],
    [5],
    [245,4],
    [230,9],
    [14,6],
    [0,941],
    [6],
    [294,5],
    [279,1],
    [15,4],
    [0,948],
  ),
  caption: [Statik kuç va işqalanişni aniqlaş natijalari],
) <tab-static>

#let rowsdata(data) = data.map(r => r.map(x => [#x])).flatten()

#figure(
  btable(
    columns: 8,
    header: (
      [$m$, \ kg],
      [$F_"yuk"$, \ N],
      [$t$, \ s],
      [$v$, \ m/s],
      [$p_1$, \ bar],
      [$p_2$, \ bar],
      [$N$, \ W],
      [$chi$],
    ),
    ..rowsdata((
      ("0", "14,7", "0,500", "0,300", "5,81", "6,20", "4,4", "0,05"),
      ("5", "63,8", "0,503", "0,298", "5,80", "4,99", "19,0", "0,23"),
      ("10", "112,8", "0,497", "0,302", "5,80", "3,81", "34,0", "0,40"),
      ("15", "161,9", "0,511", "0,294", "5,82", "2,61", "47,5", "0,58"),
      ("20", "210,9", "0,503", "0,298", "5,80", "1,43", "62,9", "0,75"),
      ("22,5", "235,4", "0,531", "0,282", "5,82", "0,84", "66,5", "0,84"),
      ("25", "260,0", "0,679", "0,221", "5,86", "0,29", "57,4", "0,93"),
      ("26,5", "274,7", "1,566", "0,096", "5,94", "0,03", "26,3", "0,98"),
    )),
  ),
  caption: [Yuklama xarakteristikasi, $p_s = 6$ bar ($L_0 = 150$ mm, $m_0 = #d("1,5")$ kg)],
) <tab-p6>

#figure(
  btable(
    columns: 8,
    header: (
      [$m$, \ kg],
      [$F_"yuk"$, \ N],
      [$t$, \ s],
      [$v$, \ m/s],
      [$p_1$, \ bar],
      [$p_2$, \ bar],
      [$N$, \ W],
      [$chi$],
    ),
    ..rowsdata((
      ("0", "14,7", "0,512", "0,293", "3,79", "3,80", "4,3", "0,08"),
      ("2,5", "39,2", "0,507", "0,296", "3,79", "3,21", "11,6", "0,22"),
      ("5", "63,8", "0,495", "0,303", "3,80", "2,61", "19,3", "0,35"),
      ("7,5", "88,3", "0,498", "0,301", "3,81", "2,02", "26,6", "0,49"),
      ("10", "112,8", "0,504", "0,298", "3,81", "1,43", "33,6", "0,62"),
      ("12,5", "137,3", "0,539", "0,278", "3,82", "0,85", "38,2", "0,76"),
      ("15", "161,9", "0,670", "0,224", "3,84", "0,29", "36,2", "0,89"),
      ("16,5", "176,6", "1,571", "0,095", "3,92", "0,04", "16,9", "0,97"),
    )),
  ),
  caption: [Yuklama xarakteristikasi, $p_s = 4$ bar ($L_0 = 150$ mm, $m_0 = #d("1,5")$ kg)],
) <tab-p4>

= Natijalarni qayta işlaş (namunaviy hisob)

*1. Porşen yuzalari* --- @eq-area böyiça:
$
  A_1 = (pi dot #d("0,025")^2) / 4 = #d("4,909") dot 10^(-4) "m"^2, quad
  A_2 = (pi (#d("0,025")^2 - #d("0,010")^2)) / 4 = #d("4,123") dot 10^(-4) "m"^2
$

*2. Işqalaniş va mexanik FIK* --- @eq-fst va @eq-etam böyiça, $p_s = 6$ bar:
$
  F_"naz" & = 6 dot 10^5 dot #d("4,909") dot 10^(-4) = #d("294,5") "N", \
  F_"işq" & = #d("294,5") - #d("279,1") = #d("15,4") "N", quad
            eta_m = #d("279,1") / #d("294,5") = #d("0,948")
$
Uçta bosim böyiça örtaça işqalaniş kuçi
$F_"işq" = (#d("15,0") + #d("14,6") + #d("15,4")) \/ 3 = #d("15,0")$ N; demak, $p_s = 6$ bar da
$F_"max" = #d("294,5") - #d("15,0") = #d("279,5")$ N.

*3. Yuklama kuçi va tezlik* (2-jadval, $m = 20$ kg):
$
  F_"yuk" = (m + m_0) g = (20 + #d("1,5")) dot #d("9,81") = #d("210,9") "N", quad
  v = L_0 / t = #d("0,150") / #d("0,503") = #d("0,298") "m/s"
$

*4. Kuçlar muvozanatini tekşiriş* --- @eq-balance böyiça, $m = 20$ kg:
$
  p_2 = (p_1 A_1 - F_"yuk" - F_"işq") / A_2
  = (#d("5,80") dot 10^5 dot #d("4,909") dot 10^(-4) - #d("210,9") - #d("15,0")) / (#d("4,123") dot 10^(-4))
  = #d("1,43") dot 10^5 "Pa"
$
Hisoblangan qiymat P2 datçigi körsatkiçi (1,43 bar) bilan mos keladi.

*5. Drossel ötkazuvçanligini aniqlaş.* 2-jadvalning dastlabki tört nuqtasi
kritik rejimga ($phi = 1$) tegişli, ularning örtaça tezligi
$v_"max" = (#d("0,300") + #d("0,298") + #d("0,302") + #d("0,294")) \/ 4 = #d("0,2985")$ m/s. @eq-v dan:
$
  C = (v_"max" A_2) / P_0 = (#d("0,2985") dot #d("4,123") dot 10^(-4)) / 10^5
  = #d("1,231") dot 10^(-9) "m"^3 \/ ("s" dot "Pa")
$

*6. Kritik yuklama* --- @eq-fkr böyiça, $b = #d("0,3")$, $p_s = 6$ bar:
$
  F_"kr" = #d("294,5") - (#d("1,013") / #d("0,3") - #d("1,013")) dot 10^5 dot #d("4,123") dot 10^(-4) - #d("15,0")
  = #d("182,0") "N"
$
$p_s = 4$ bar da xuddi şunday $F_"kr" = #d("83,9")$ N, $F_"max" = #d("181,4")$ N.

*7. Foydali quvvat* --- @eq-power böyiça, $m = #d("22,5")$ kg:
$N = #d("235,4") dot #d("0,282") = #d("66,5")$ W, $chi = #d("235,4") \/ #d("279,5") = #d("0,84")$. Bu
$p_s = 6$ bar dagi eng katta quvvat; $p_s = 4$ bar da maksimal quvvat
$#d("38,2")$ W ($chi = #d("0,76")$).

#figure(
  plot(
    300,
    0.35,
    50,
    0.05,
    [$F_"yuk"$, N],
    [$v$, m/s],
    lpos: "bottom",
    curves: (
      (pts: sampleF(6e5), st: 1.2pt + headingblue),
      (pts: sampleF(4e5), st: (paint: rgb("#C0504D"), thickness: 1.2pt, dash: "dashed")),
    ),
    pts: (
      (pts: F6.zip(v6), fill: headingblue),
      (pts: F4.zip(v4), fill: rgb("#C0504D")),
    ),
    legend: (
      (st: 1.2pt + headingblue, fill: headingblue, label: [$p_s = 6$ bar: model va tajriba]),
      (
        st: (paint: rgb("#C0504D"), thickness: 1.2pt, dash: "dashed"),
        fill: rgb("#C0504D"),
        label: [$p_s = 4$ bar: model va tajriba],
      ),
    ),
  ),
  caption: [Yuklama xarakteristikalari: çiziqlar --- @eq-v böyiça model,
    nuqtalar --- 2- va 3-jadvallardagi tajriba natijalari],
) <fig-result>

@fig-result dan körinadiki, tekis qismda model va tajriba deyarli töliq mos
keladi. Töxtaş nuqtasi yaqinida tajriba tezligi modeldan biroz past: masalan,
$m = 25$ kg da model $v = #d("0,25")$ m/s beradi, ölçangani esa $#d("0,221")$ m/s. Buning
asosiy sababi --- harakat vaqtida taʼminot liniyasidagi bosim yöqotişi
($p_1 = #d("5,86")$ bar $< p_s = 6$ bar): $F_"max"$ yaqinida $p_2$ juda kiçik
bölgani uçun $p_1$ ning ozgina pasayişi ham tezlikka sezilarli taʼsir
qiladi.

#figure(
  plot(
    300,
    70,
    50,
    10,
    [$F_"yuk"$, N],
    [$N$, W],
    curves: (
      (pts: sampleF(6e5).map(p => (p.at(0), p.at(0) * p.at(1))), st: 1.2pt + headingblue),
      (
        pts: sampleF(4e5).map(p => (p.at(0), p.at(0) * p.at(1))),
        st: (paint: rgb("#C0504D"), thickness: 1.2pt, dash: "dashed"),
      ),
    ),
    pts: (
      (pts: F6.zip(v6).map(p => (p.at(0), p.at(0) * p.at(1))), fill: headingblue),
      (pts: F4.zip(v4).map(p => (p.at(0), p.at(0) * p.at(1))), fill: rgb("#C0504D")),
    ),
    legend: (
      (st: 1.2pt + headingblue, fill: headingblue, label: [$p_s = 6$ bar]),
      (st: (paint: rgb("#C0504D"), thickness: 1.2pt, dash: "dashed"), fill: rgb("#C0504D"), label: [$p_s = 4$ bar]),
    ),
  ),
  caption: [Foydali quvvatning yuklamaga boğliqligi $N = f(F_"yuk")$],
) <fig-power>

= Natijalarni Python yordamida qayta işlaş

Quyidagi dastur 2- va 3-jadval natijalari asosida drossel ötkazuvçanligini
aniqlaydi va tajriba nuqtalarini @eq-v modeli bilan bitta grafikda
soliştiradi. Talaba öz ölçov natijalarini massivlarga kiritadi.

```python
import numpy as np
import matplotlib.pyplot as plt

# --- Stend parametrlari ---
D, d = 0.025, 0.010                      # m
A1 = np.pi * D**2 / 4
A2 = np.pi * (D**2 - d**2) / 4
Pa, P0, b, Ff = 1.013e5, 1e5, 0.30, 15.0  # Pa, Pa, -, N

# --- Tajriba maʼlumotlari (2- va 3-jadval) ---
data = {
    6e5: (np.array([14.7, 63.8, 112.8, 161.9, 210.9, 235.4, 260.0, 274.7]),
          np.array([0.300, 0.298, 0.302, 0.294, 0.298, 0.282, 0.221, 0.096])),
    4e5: (np.array([14.7, 39.2, 63.8, 88.3, 112.8, 137.3, 161.9, 176.6]),
          np.array([0.293, 0.296, 0.303, 0.301, 0.298, 0.278, 0.224, 0.095])),
}

# --- Drossel oʻtkazuvchanligi (kritik rejimdagi nuqtalar) ---
v_max = data[6e5][1][:4].mean()
C = v_max * A2 / P0
print(f"v_max = {v_max:.4f} m/s,  C = {C:.3e} m3/(s*Pa)")

def v_model(F, ps):
    p2 = (ps * A1 - F - Ff) / A2               # manometrik, Pa
    p2 = np.clip(p2, 1e-6, None)
    r = Pa / (p2 + Pa)
    phi = np.where(r <= b, 1.0,
                   np.sqrt(np.clip(1 - ((r - b) / (1 - b))**2, 0, None)))
    return C * P0 * phi / A2

fig, ax = plt.subplots(1, 2, figsize=(11, 4))
for ps, mk in ((6e5, "o"), (4e5, "s")):
    F, v = data[ps]
    Fm = np.linspace(0, ps * A1 - Ff, 300)
    ax[0].plot(Fm, v_model(Fm, ps), label=f"model, {ps/1e5:.0f} bar")
    ax[0].plot(F, v, mk, label=f"tajriba, {ps/1e5:.0f} bar")
    ax[1].plot(F, F * v, mk + "-", label=f"{ps/1e5:.0f} bar")
    i = np.argmax(F * v)
    print(f"{ps/1e5:.0f} bar: N_max = {F[i]*v[i]:.1f} W, "
          f"chi = {F[i]/(ps*A1 - Ff):.2f}")
ax[0].set(xlabel="F_yuk, N", ylabel="v, m/s", title="v = f(F_yuk)")
ax[1].set(xlabel="F_yuk, N", ylabel="N, W", title="N = f(F_yuk)")
for a in ax:
    a.grid(True); a.legend()
plt.tight_layout(); plt.savefig("yuklama_xarakteristikasi.png", dpi=200)
```

= Hisobot mazmuni va grafik tahlil

+ 1-jadval asosida $F_"st" = f(p_s)$ grafigini quriş, uning nazariy
  $F_"naz" = p_s A_1$ töğri çiziği bilan farqini va $eta_m$ ning bosimga
  boğliqligini tuşuntiriş.
+ Ikkala bosim uçun $v = f(F_"yuk")$ yuklama xarakteristikalarini bitta
  koordinata tizimida quriş, tekis qism va keskin pasayiş hududlarini
  ajratiş, $F_"kr"$ va $F_"max"$ ning tajribaviy qiymatlarini @eq-fkr va
  @eq-fst bilan soliştiriş.
+ $p_2 = f(F_"yuk")$ grafigini quriş va kiçik yuklamalarda $p_2 > p_1$
  böliş sababini tuşuntiriş.
+ Drossel ötkazuvçanligi $C$ ni aniqlab, @eq-v modeli bilan tajriba
  orasidagi farqning sabablarini (liniyadagi bosim yöqotişi, işqalanişning
  tezlikka boğliqligi, issiqlik almaşinuvi) tahlil qiliş.
+ $N = f(F_"yuk")$ grafigi asosida yuritmaning optimal yuklaniş oraliğini
  aniqlaş va robot uşlagiçi yoki kötariş öqi uçun iş rejimi (bosim,
  yuklama, drossel sozlanişi) böyiça xulosa yoziş.

= Nazorat savollari

+ Pnevmoyuritmaning yuklama xarakteristikasi deb nimaga aytiladi va u elektr
  yuritmaning mexanik xarakteristikasidan nimasi bilan farq qiladi?
+ Nima uçun çiqişni drossellaşda kritik rejimda porşen tezligi yuklamaga
  ham, taʼminot bosimiga ham boğliq emas?
+ Kritik yuklama $F_"kr"$ qanday aniqlanadi va u taʼminot bosimiga qanday
  boğliq?
+ Kiçik yuklamalarda çiqiş kamerasidagi bosim taʼminot bosimidan yuqori
  bölişini qanday tuşuntirasiz?
+ Statik kuç tajribasida mexanik FIK nima uçun bosim ortişi bilan biroz
  oşadi?
+ Foydali quvvat nima uçun $F_"max"$ dan kiçik yuklamada maksimumga
  erişadi? Pnevmosilindrni qanday yuklaniş koeffitsiyentida işlatiş
  tavsiya etiladi?
+ Tezlik nima uçun B1--B2 datçiklari orasida, yurişning örta qismida
  ölçanadi?
