// ============================================================
//  2-TAJRIBA MASHGʻULOTI  —  tashqi paketsiz (CeTZ kerak emas)
//  Kompilyatsiya:  typst compile tajriba-2.typ
// ============================================================

// ---------- Chizma yordamchisi (mini-CeTZ) ----------
// Foydalanuvchi koordinatalari (cm), y yuqoriga qarab oʻsadi — TikZ kabi.
// ux / uy — TikZʼdagi x=..., y=... masshtablari.
#let sxema(
  xmin: 0,
  xmax: 10,
  ymin: 0,
  ymax: 10,
  ux: 1cm,
  uy: 1cm,
  draw,
) = {
  let px(x) = (x - xmin) * ux
  let py(y) = (ymax - y) * uy

  let d = (
    // Toʻrtburchak
    R: (a, b, fl: none, st: 1pt + black) => place(
      dx: px(calc.min(a.at(0), b.at(0))),
      dy: py(calc.max(a.at(1), b.at(1))),
      rect(
        width: calc.abs(b.at(0) - a.at(0)) * ux,
        height: calc.abs(b.at(1) - a.at(1)) * uy,
        fill: fl,
        stroke: st,
      ),
    ),
    // Siniq chiziq
    L: (..pts, st: 1pt + black) => {
      let p = pts.pos()
      for i in range(p.len() - 1) {
        place(line(
          start: (px(p.at(i).at(0)), py(p.at(i).at(1))),
          end: (px(p.at(i + 1).at(0)), py(p.at(i + 1).at(1))),
          stroke: st,
        ))
      }
    },
    // Kubik Bezye egri chizigʻi (TikZ: .. controls c1 and c2 ..)
    B: (p0, c1, c2, p1, st: 1pt + black) => place(curve(
      stroke: st,
      curve.move((px(p0.at(0)), py(p0.at(1)))),
      curve.cubic(
        (px(c1.at(0)), py(c1.at(1))),
        (px(c2.at(0)), py(c2.at(1))),
        (px(p1.at(0)), py(p1.at(1))),
      ),
    )),
    // Matn. at: center+bottom -> nuqta ustida, center+top -> ostida,
    //          right+horizon -> chapida,  left+horizon -> oʻngida
    T: (p, body, at: center + horizon) => {
      let W = 8cm
      let H = 2cm
      let dx = if at.x == left { px(p.at(0)) } else if at.x == right {
        px(p.at(0)) - W
      } else { px(p.at(0)) - W / 2 }
      let dy = if at.y == top { py(p.at(1)) } else if at.y == bottom {
        py(p.at(1)) - H
      } else { py(p.at(1)) - H / 2 }
      place(dx: dx, dy: dy, box(width: W, height: H, align(at, body)))
    },
    // Doira (radius foydalanuvchi birligida)
    C: (p, r, fl: white, st: 1pt + black) => place(
      dx: px(p.at(0)) - r * ux,
      dy: py(p.at(1)) - r * uy,
      ellipse(width: 2 * r * ux, height: 2 * r * uy, fill: fl, stroke: st),
    ),
    // Nuqta (radius ptʼda)
    P: (p, r, fl: black) => place(
      dx: px(p.at(0)) - r,
      dy: py(p.at(1)) - r,
      circle(radius: r, fill: fl, stroke: none),
    ),
    // Strelka uchi: "up" | "down" | "left" | "right"
    A: (p, dir, fl: black) => {
      let s = 4pt
      let x = px(p.at(0))
      let y = py(p.at(1))
      if dir == "up" {
        place(dx: x - s, dy: y, polygon(fill: fl, stroke: none, (s, 0pt), (0pt, 2 * s), (2 * s, 2 * s)))
      } else if dir == "down" {
        place(dx: x - s, dy: y - 2 * s, polygon(fill: fl, stroke: none, (0pt, 0pt), (2 * s, 0pt), (s, 2 * s)))
      } else if dir == "right" {
        place(dx: x - 2 * s, dy: y - s, polygon(fill: fl, stroke: none, (0pt, 0pt), (0pt, 2 * s), (2 * s, s)))
      } else {
        place(dx: x, dy: y - s, polygon(fill: fl, stroke: none, (0pt, s), (2 * s, 0pt), (2 * s, 2 * s)))
      }
    },
    // Toʻr (grid)
    G: (a, b, step: 0.5, st: 0.4pt + gray.lighten(35%)) => {
      let x = a.at(0)
      while x <= b.at(0) + 0.001 {
        place(line(start: (px(x), py(a.at(1))), end: (px(x), py(b.at(1))), stroke: st))
        x = x + step
      }
      let y = a.at(1)
      while y <= b.at(1) + 0.001 {
        place(line(start: (px(a.at(0)), py(y)), end: (px(b.at(0)), py(y)), stroke: st))
        y = y + step
      }
    },
  )

  block(
    width: (xmax - xmin) * ux,
    height: (ymax - ymin) * uy,
    draw(d),
  )
}

// ============ Hujjat sozlamalari ============
#let headingblue = rgb(20, 50, 120)

#set document(title: "3-Tajriba Mashguloti: Pnevmoyuritma yuklama xarakteristikasini aniqlash")

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 3  // amaliyot raqami
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
#set text(size: 12pt, lang: "uz")
#set par(justify: true, leading: 0.75em)
#set heading(numbering: "1.1.")
#show heading: it => block(above: 1.2em, below: 0.7em)[
  #text(fill: headingblue, weight: "bold")[#it]
]

#set math.equation(numbering: "(1)")
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")
#show link: set text(fill: blue.darken(20%))
#set enum(indent: 0.5em, spacing: 0.8em)
#set list(indent: 0.5em, spacing: 0.8em)

// ============ Sarlavha ============
#align(center)[
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTI №3]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Pnevmoyuritma yuklama xarakteristikasini aniqlash
  ]

  #v(0.1cm)
  #text(size: 10pt)[(Mexatron modul va robotlarning pnevmoyuritmalarida)]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Ishning maqsadi

- Mexatronik tizimlar va sanoat robotlarining pnevmoyuritmalarida mexanik
  yuklama ($F_"yuk"$) va qarshilik kuchlarining yuritma xarakteristikalariga
  taʼsirini tajriba yoʻli bilan tadqiq etish.

- Yuklama ortishi bilan pnevmosilindr harakat tezligi ($V = f(F_"yuk")$),
  ishchi kameralardagi bosimlar ($P_1, P_2$) va foydali ish koeffitsienti
  ($eta$) oʻzgarishini aniqlash.

- Pnevmoyuritmaning maksimal yuklama koʻtarish qobiliyati (toʻxtash/stall
  holati) hamda "Meter-out" drossellash usulida yuklama ostida harakat
  barqarorligini baholash.

= Qisqacha nazariy maʼlumotlar

Sanoat robotlarining manipulatsiyalash va ushlash (gripper) mexanizmlarida
pnevmoyuritmalar doimiy oʻzgaruvchan tashqi yuklama ostida ishlaydi.
Pnevmoyuritmaning *yuklama xarakteristikasi* deb, oʻzgarmas taʼminot bosimi
($P_"tam"$) va drossel ochilishida porshen harakat tezligi ($V$) hamda
rivojlantiriladigan foydali kuch ($F_"foydali"$) oʻrtasidagi bogʻliqlikka
aytiladi.

== Yuklama Muvozanati va Dinamik Tenglama

Pnevmosilindr porsheniga taʼsir etuvchi kuchlar muvozanati Nyutonning ikkinchi
qonuniga koʻra quyidagicha ifodalanadi:

$ F_a = P_1 A_1 - P_2 A_2 - F_"yuk" - f = M dot a $

bunda:

- $P_1$ va $A_1$ --- porshen kamerasidagi bosim va yuza;
- $P_2$ va $A_2$ --- shtok kamerasidagi aks bosim (back pressure) va effektiv
  yuza ($A_2 = A_1 - a_"shtok"$);
- $F_"yuk"$ --- pnevmoyuritmaga tushayotgan tashqi mexanik yuklama kuchi;
- $f$ --- manjet va yoʻnaltiruvchilardagi ishqalanish kuchi;
- $M$ --- keltirilgan yuklama massasi;
- $a$ --- porshen tezlanishi.

Barqaror harakat rejimida ($a = 0$), pnevmosilindr kamerasida talab etiladigan
ishchi bosim $P_1$:

$ P_1 = (F_"yuk" + f + P_2 A_2) / A_1 $

== Toʻxtash (Stall Condition) va FIK

Tashqi yuklama kuchi $F_"yuk"$ oshib borib, pnevmoyuritma rivojlantira
oladigan maksimal kuchga tenglashganda ($F_"yuk" = P_"tam" A_1 - f$), porshen
harakati toʻxtaydi ($V = 0$). Bu holat *toʻxtash rejimi (stall condition)* deb
ataladi.

Pnevmoyuritmaning yuklama ostidagi foydali ish koeffitsienti (FİK) amaldagi
yuklama kuchi ($F_"yuk"$) va nazariy maksimal kuch ($F_"naz" = P_"tam" A_1$)
nisbati bilan aniqlanadi:

$ eta = F_"yuk" / (P_"tam" A_1) dot 100% $

Havoning siqiluvchanligi sababli, yuklama keskin ortganda pnevmatizimdagi havo
hajmi siqilib, yuritma qattiqligi (stiffness) kamayadi. Buni bartaraf etish
uchun chiqish liniyasida aks bosim ($P_2$) hosil qiluvchi "Meter-out"
drossellash qoʻllaniladi.

= Kerakli jihozlar va stend elementlari

+ *Pnevmatik stend:* Kompressor, havo resiveri va FRL (filtr, reduktor,
  moylagich) bloki.
+ *Ijro organi:* Ikki taraflama taʼsir etuvchi pnevmosilindr
  ($D = 25 "mm"$, $S = 200 "mm"$).
+ *Yuklama mexanizmi:* Sozlanuvchi yuk massalari ($M = 2 dots 20 "kg"$) yoki
  yuklama hosil qiluvchi tormozlovchi pnevmotsilindr / dinamometr.
+ *Boshqaruv va rostlash apparaturasi:* 5/2-yoʻlli elektropnevmotaqsimlagich,
  teskari klapanli drossellar.
+ *Oʻlchov tizimi:* Raqamli bosim datchiklari ($P_1, P_2$), kuch datchigi
  (S-type load cell), koʻchish hamda tezlik datchigi (LVDT / optik enkoder).

= Pnevmatik va Yuklama Sxemalari

== Yuklama Xarakteristikasini Aniqlash Stendi Sxemasi

#figure(
  sxema(xmin: -2.4, xmax: 7.8, ymin: -0.9, ymax: 5.5, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none, st: 1pt + black) = {
      (d.R)(a, b, fl: fl, st: st)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }

    // --- Pnevmosilindr ---
    (d.R)((0, 3.5), (3, 4.5), fl: gray.lighten(85%))
    (d.R)((0.8, 3.55), (1.1, 4.45), fl: blue.lighten(70%)) // porshen
    (d.R)((1.1, 3.9), (4.0, 4.1), fl: gray.lighten(50%), st: 1.5pt + black) // shtok
    (d.T)((1.5, 4.6), sb(9pt)[Pnevmosilindr ($D = 25$ mm)], at: center + bottom)

    // --- Kuch datchigi (load cell) ---
    BX((3.95, 3.55), (5.15, 4.45), align(center, sb(7pt)[Kuch \ Datchigi]), fl: orange.lighten(70%))

    // --- Blok-rolik va yuk ---
    (d.L)((5.15, 4.0), (5.8, 4.0))
    (d.C)((5.8, 4.0), 0.3, fl: gray.lighten(60%))
    (d.L)((5.8, 3.7), (5.8, 2.0))
    BX((5.3, 1.2), (6.3, 2.0), sb(9pt)[Yuk $M$], fl: red.lighten(70%))
    (d.L)((5.8, 1.2), (5.8, 0.48), st: 1.5pt + red.darken(20%))
    (d.A)((5.8, 0.4), "down", fl: red.darken(20%))
    (d.T)((5.95, 0.4), sb(9pt)[$F_"yuk" = M g$], at: left + horizon)

    // --- Bosim datchiklari ---
    (d.L)((0.5, 3.5), (0.5, 3.1))
    BX((0.2, 2.7), (0.8, 3.1), sb(7pt)[$P_1$], fl: green.lighten(80%))
    (d.L)((2.5, 3.5), (2.5, 3.1))
    BX((2.2, 2.7), (2.8, 3.1), sb(7pt)[$P_2$], fl: green.lighten(80%))
    (d.L)((0.5, 2.7), (0.5, 2.4))
    (d.L)((2.5, 2.7), (2.5, 2.4))

    // --- Drossellar (Meter-out) ---
    BX((-0.25, 2.0), (1.25, 2.4), sb(7pt)[Drossel 1], fl: yellow.lighten(80%))
    BX((1.75, 2.0), (3.25, 2.4), sb(7pt)[Drossel 2], fl: yellow.lighten(80%))
    (d.L)((0.5, 2.0), (0.5, 1.4))
    (d.L)((2.5, 2.0), (2.5, 1.4))

    // --- 5/2 pnevmotaqsimlagich ---
    (d.R)((-0.2, 0.2), (3.2, 1.4), fl: blue.lighten(95%))
    (d.L)((1.5, 0.2), (1.5, 1.4), st: (paint: black, thickness: 1pt, dash: "dashed"))
    (d.T)((0.65, 0.8), align(center, sb(7pt)[Pozitsiya 1 \ P$->$A, B$->$R]))
    (d.T)((2.35, 0.8), align(center, sb(7pt)[Pozitsiya 2 \ P$->$B, A$->$S]))
    (d.T)((1.5, 1.48), box(fill: white, inset: 1pt, sb(9pt)[5/2 Elektropnevmotaqsimlagich]), at: center + bottom)

    // --- Taʼminot liniyasi ---
    (d.L)((1.5, -0.6), (1.5, 0.12))
    (d.A)((1.5, 0.2), "up")
    (d.T)((1.6, -0.2), sb(9pt)[P ($P_"tam" = 6$ bar)], at: left + horizon)
  }),
  caption: [Pnevmoyuritma yuklama xarakteristikasini aniqlash tajriba stendi],
)

== Yuklama Xarakteristikasi Grafiklari ($V = f(F_"yuk")$ va $P = f(F_"yuk")$)

#figure(
  sxema(xmin: -0.9, xmax: 8.6, ymin: -0.9, ymax: 5.3, ux: 1.2cm, uy: 1cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    // --- Toʻr ---
    (d.G)((0, 0), (5, 4))

    // --- Koordinata oʻqlari ---
    (d.L)((0, 0), (5.4, 0), st: 1pt + black)
    (d.A)((5.5, 0), "right")
    (d.T)((5.65, 0), sb(9pt)[Yuklama kuchi $F_"yuk"$ (N)], at: left + horizon)
    (d.L)((0, 0), (0, 4.4), st: 1pt + black)
    (d.A)((0, 4.5), "up")
    (d.T)((0.05, 4.6), sb(9pt)[Tezlik $V$ (m/s) / Bosim $P_1$ (bar)], at: left + bottom)

    // --- Tezlik egri chizigʻi V = f(F_yuk) ---
    (d.B)((0, 3.8), (1.5, 3.5), (3.5, 2.0), (4.8, 0), st: 1.8pt + red.darken(20%))
    (d.T)((1.0, 3.5), box(fill: white, inset: 2pt, sb(9pt)[$V = f(F_"yuk")$]), at: left + bottom)

    // --- Bosim chizigʻi P1 = f(F_yuk) ---
    (d.L)((0, 0.8), (4.8, 3.8), st: 1.8pt + blue.darken(20%))
    (d.T)((4.75, 3.35), box(fill: white, inset: 2pt, sb(9pt)[$P_1 = f(F_"yuk")$]), at: right + bottom)

    // --- Xarakterli nuqtalar ---
    (d.P)((0, 3.8), 2pt)
    (d.T)((-0.1, 3.8), sb(7pt)[$V_"max"$ (Salt ishlash)], at: right + horizon)
    (d.P)((4.8, 0), 2pt)
    (d.T)((4.8, -0.3), sb(7pt)[$F_"stall"$ (Toʻxtash kuchi)], at: center + top)

    // --- Izohlar ---
    (d.L)((4.8, 0), (4.8, 3.8), st: (paint: gray, thickness: 1pt, dash: "dashed"))
    (d.T)((2.5, 0.4), box(fill: white, inset: 2pt, sb(7pt)[Ishchi zona]))
    (d.T)((4.5, 1.2), box(fill: white, inset: 2pt, align(center, sb(7pt)[Kritik yuklama \ (Stall zone)])))
  }),
  caption: [Pnevmoyuritmaning tezlik va bosim yuklama xarakteristikalari],
)

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(level: 2, numbering: none, outlined: false)[1-bosqich: Oʻzgarmas bosimda yuklama xarakteristikasini olish]

+ Havo tayyorlash bloki (FRL) orqali taʼminot bosimini $P_"tam" = 6 "bar"$ ga
  sozlang.
+ Pnevmosilindr shtokiga yuklamasiz ($F_"yuk" = 0$) holatda taqsimlagichni
  yoqing va salt ishlash tezligi $V_0$ hamda kameralardagi $P_1, P_2$
  bosimlarni oʻlchang.
+ Shtokga ketma-ket $M = 2, 5, 10, 15, 20 "kg"$ yuk massalarini ulagan holda
  porshen harakat vaqti ($t$), oʻrtacha tezlik ($V = S \/ t$), ishchi bosim
  $P_1$ va aks bosim $P_2$ ni qayd eting.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-bosqich: Har xil bosimlarda maksimal yuk koʻtarish qobiliyatini aniqlash]

+ Taʼminot bosimini $P_"tam" = 4 "bar"$, $6 "bar"$ va $8 "bar"$ qiymatlarga
  oʻzgartiring.
+ Har bir bosim qiymatida pnevmoyuritmani toʻxtatuvchi kritik yuklama
  ($F_"stall"$) qiymatini kuch datchigi orqali aniqlang.
+ FİK qiymatlarini formula (3) boʻyicha hisoblang.

= Tajriba natijalari va hisoblashlar jadvali

#figure(
  table(
    columns: 9,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$M$ (kg)*], [*$F_"yuk"$ (N)*], [*$t$ (s)*], [*$V$ (m/s)*],
    [*$P_1$ (bar)*], [*$P_2$ (bar)*], [*$F_"naz"$ (N)*], [*$eta$ (%)*],
    table.hline(stroke: 0.5pt),
    [1], [0.0], [0], [0.32], [0.625], [1.2], [1.1], [294.5], [0.0%],
    [2], [2.5], [24.5], [0.36], [0.555], [2.1], [1.2], [294.5], [8.3%],
    [3], [5.0], [49.0], [0.42], [0.476], [2.8], [1.2], [294.5], [16.6%],
    [4], [10.0], [98.1], [0.58], [0.344], [4.1], [1.3], [294.5], [33.3%],
    [5], [15.0], [147.15], [0.85], [0.235], [5.2], [1.3], [294.5], [50.0%],
    [6], [22.0], [215.8], [$infinity$], [0.000], [5.8], [1.0], [294.5],
    [73.2% \ (Stall)],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Pnevmoyuritma yuklama xarakteristikasi tajriba natijalari
    ($P_"tam" = 6 "bar"$, $S = 0.2 "m"$)
  ],
)

= Hisobot mazmuni va grafik tahlil

+ Jadval natijalari asosida $V = f(F_"yuk")$, $P_1 = f(F_"yuk")$ hamda
  $eta = f(F_"yuk")$ *grafiklarini qurish*.
+ Yuklama ortishi bilan yuritma tezligining pasayish sabablarini havoning
  siqiluvchanligi va drosseldagi havo sarfi cheklanishi nuqtai nazaridan
  tushuntirish.
+ Sanoat robotlari tutqichlarida pnevmoyuritmaga yuklama tanlashda zaxira
  koeffitsientini baholash.

= Nazorat savollari

+ Pnevmoyuritmaning yuklama xarakteristikasi deb nimaga aytiladi va u qanday
  grafik koʻrinishga ega?
+ Yuklama kuchi oshganda pnevmosilindr ishchi kamerasidagi bosim $P_1$ va
  harakat tezligi $V$ qanday oʻzgaradi?
+ Pnevmoyuritmaning toʻxtash rejimi (stall condition) nima va u qaysi shartda
  yuzaga keladi?
+ Pnevmoyuritma va gidroyuritmalarning yuklama ostida ishlash barqarorligi va
  qattiqligi (stiffness) oʻrtasidagi asosiy farqlar nimada?
