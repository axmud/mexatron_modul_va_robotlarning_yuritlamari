// ============================================================
//  5-TAJRIBA MASHGʻULOTI  —  tashqi paketsiz (CeTZ kerak emas)
//  Kompilyatsiya:  typst compile tajriba-5.typ
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

#set document(title: "Pnevmoyuritma dinamik xarakteristikalarini tadqiq etish")

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 5  // amaliyot raqami
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
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTI №5]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Pnevmoyuritma dinamik xarakteristikalarini tadqiq etish
  ]

  #v(0.1cm)
  #text(size: 10pt)[(Mexatron modul va robotlarning pnevmoyuritmalarida)]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Ishning maqsadi

- Mexatronik tizimlar va sanoat robotlarining pnevmoyuritmalarida oʻtish
  jarayonlari (transient response), kechikish vaqti
  ($t_"kechikish"$ / dead time) hamda dinamik harakat koʻrsatkichlarini
  tajriba yoʻli bilan tadqiq etish.

- Pnevmotaqsimlagichga signal berilgan momentdan porshen harakatlana
  boshlagungacha boʻlgan vaqt diapazonlarini va ishchi kameralardagi bosim
  sakrashlarini (pressure spikes) oʻrganish.

- Yuqori tezlikdagi bosim va koʻchish datchiklari hamda analog-raqamli
  oʻzgartirgichlar (AChP/ADC) yordamida dinamik xarakteristikalarni
  ($x(t), V(t), P_1(t), P_2(t)$) qayd etish koʻnikmalarini shakllantirish.

= Qisqacha nazariy maʼlumotlar

Pnevmoyuritmalar dinamikasi siqilgan havoning termodinamik xossalari, ishchi
kameralarning toʻlish/boʻshalish tezligi hamda porshen inertsiya massasiga
bogʻliq boʻlgan murakkab nochiziqli jarayondir.

== Dinamik Harakat Tenglamasi

Pnevmosilindr porshenining vaqt oʻtishi bilan harakati Nyutonning ikkinchi
qonuni asosida quyidagi differensial tenglama bilan ifodalanadi:

$
  M (dif^2 x) / (dif t^2) + b (dif x) / (dif t) + F_"yuk"
  = P_1 (t) A_1 - P_2 (t) A_2 - f_"ishq" dot "sgn" ((dif x) / (dif t))
$

bunda:

- $M$ --- keltirilgan harakatlanuvchi massa (porshen, shtok va yuklama);
- $x(t)$, $(dif x) / (dif t)$, $(dif^2 x) / (dif t^2)$ --- porshenning
  koʻchishi, tezligi va tezlanishi;
- $b$ --- viskoz ishqalanish koeffitsienti;
- $P_1 (t)$, $P_2 (t)$ --- porshen va shtok kameralaridagi vaqtga bogʻliq
  dinamik bosimlar;
- $f_"ishq"$ --- quruq (Kulon) ishqalanish kuchi.

== Dinamik Oʻtish Jarayoni Bosqichlari

Pnevmoyuritmaning toʻliq dinamik sikli 4 ta asosiy bosqichdan iborat:

+ *Kechikish vaqti ($t_d$ --- Dead Time):* Taqsimlagich solenoidiga elektr
  signal berilgandan soʻng, porshen kamerasidagi bosim $P_1$ ishqalanish va
  yuklama kuchlarini yengish uchun yetarli darajaga yetguncha ketgan vaqt.
+ *Tezlanish bosqichi ($t_a$ --- Acceleration Phase):* Porshen harakatlana
  boshlab, maksimal belgilangan tezlikka erishguncha boʻlgan vaqt oraligʻi.
+ *Barqaror harakat bosqichi ($t_v$ --- Steady Velocity Phase):* Porshen
  drossel orqali belgilangan oʻzgarmas tezlikda harakatlanadigan bosqich.
+ *Tormozlanish va toʻxtash ($t_(s t)$ --- Cushioning / Stop Phase):* Silindr
  chetki pozitsiyaga yetganda va dempferlash (cushioning) tizimi ishga
  tushgandagi tormozlanish jarayoni.

= Kerakli jihozlar va stend elementlari

+ *Pnevmatik stend:* Kompressor, resiver, FRL bloki.
+ *Ijro organi:* Dempferli ikki taraflama pnevmosilindr
  ($D = 25 "mm"$, $S = 200 "mm"$).
+ *Boshqaruv apparati:* Aniq va tezkor harakatlanuvchi 5/2
  elektropnevmotaqsimlagich (solenoidli).
+ *Datchiklar va oʻlchov kompleksi:*
  - Yuqori tezlikdagi piezoelektrik / pyezoqarshilik bosim datchiklari
    ($P_1, P_2$);
  - Chiziqli optik enkoder yoki LVDT pozitsiya datchigi ($x(t)$);
  - AChP maʼlumotlar yigʻish platasi (Data Acquisition Board --- DAQ /
    Osillograf);
  - Kompyuter dasturiy taʼminoti (LabVIEW / MATLAB Simulink).

= Pnevmatik va Dinamik Taʼsir Sxemalari

== Dinamik Xarakteristikalarni Oʻlchash Stendi Sxemasi

#figure(
  sxema(xmin: -1.2, xmax: 9.6, ymin: -1.1, ymax: 6.0, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none, st: 1pt + black) = {
      (d.R)(a, b, fl: fl, st: st)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }

    // --- Pnevmosilindr ---
    (d.R)((0, 3.5), (3.5, 4.5), fl: gray.lighten(85%))
    (d.R)((1.0, 3.55), (1.3, 4.45), fl: blue.lighten(70%)) // porshen
    (d.R)((1.3, 3.9), (4.5, 4.1), fl: gray.lighten(50%), st: 1.5pt + black) // shtok
    (d.T)((1.75, 4.55), sb(9pt)[Pnevmosilindr ($D = 25$ mm)], at: center + bottom)

    // --- Chiziqli koʻchish datchigi ---
    BX(
      (0.0, 4.95),
      (4.5, 5.6),
      align(center, sb(6.5pt)[Chiziqli Koʻchish Datchigi \ LVDT / Enkoder $x(t)$]),
      fl: yellow.lighten(70%),
    )
    (d.L)((4.5, 4.1), (4.5, 4.95), st: (paint: red, thickness: 1pt, dash: "dashed"))

    // --- Yuqori tezlikdagi bosim datchiklari ---
    (d.L)((0.6, 3.5), (0.6, 3.1))
    BX((-0.1, 2.7), (1.3, 3.1), sb(6.5pt)[Datchik $P_1$], fl: green.lighten(75%))
    (d.L)((2.9, 3.5), (2.9, 3.1))
    BX((2.3, 2.7), (3.7, 3.1), sb(6.5pt)[Datchik $P_2$], fl: green.lighten(75%))

    // --- Ulanish chiziqlari ---
    (d.L)((0.6, 2.7), (0.6, 1.4))
    (d.L)((2.9, 2.7), (2.9, 1.4))

    // --- 5/2 pnevmotaqsimlagich ---
    (d.R)((0.0, 0.2), (3.5, 1.4), fl: blue.lighten(95%))
    (d.L)((1.75, 0.2), (1.75, 1.4), st: (paint: black, thickness: 1pt, dash: "dashed"))
    (d.T)((0.85, 0.8), align(center, sb(7pt)[Pozitsiya 1 \ P$->$A, B$->$R]))
    (d.T)((2.65, 0.8), align(center, sb(7pt)[Pozitsiya 2 \ P$->$B, A$->$S]))

    // --- DAQ bloki ---
    BX(
      (5.5, 1.5),
      (7.8, 4.5),
      align(center, sb(8pt)[DAQ Bloki / \ AChP Plata \ (Data Acquisition)]),
      fl: orange.lighten(75%),
    )

    // --- Signal oʻtkazgichlar ---
    let sig = c => (paint: c, thickness: 1pt, dash: "dashed")
    (d.L)((4.5, 5.27), (5.5, 5.27), (5.5, 4.1), st: sig(red.darken(20%)))
    (d.A)((5.5, 4.0), "down", fl: red.darken(20%))
    (d.T)((5.0, 5.32), sb(6.5pt)[$x(t)$ signal], at: center + bottom)

    (d.L)((1.3, 2.9), (5.4, 2.9), st: sig(green.darken(30%)))
    (d.A)((5.5, 2.9), "right", fl: green.darken(30%))
    (d.T)((1.95, 2.95), sb(6.5pt)[$P_1 (t)$], at: center + bottom)

    (d.L)((3.7, 2.9), (5.42, 2.32), st: sig(green.darken(30%)))
    (d.A)((5.5, 2.3), "right", fl: green.darken(30%))
    (d.T)((4.2, 2.5), sb(6.5pt)[$P_2 (t)$], at: center + top)

    // --- Taʼminot ---
    (d.L)((1.75, -0.6), (1.75, 0.12))
    (d.A)((1.75, 0.2), "up")
    (d.T)((1.85, -0.25), sb(9pt)[P ($P_"tam" = 6$ bar)], at: left + horizon)
  }),
  caption: [Dinamik oʻtish jarayonlarini qayd etish oʻlchov kompleksi sxemasi],
)

== Dinamik Oʻtish Jarayonlari Grafiklari ($x(t)$, $V(t)$, $P_1 (t)$)

#figure(
  sxema(xmin: -0.7, xmax: 8.4, ymin: -1.1, ymax: 6.0, ux: 1.2cm, uy: 0.9cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    // --- Toʻr ---
    (d.G)((0, 0), (5.5, 4.5))

    // --- Koordinata oʻqlari ---
    (d.L)((0, 0), (5.9, 0), st: 1pt + black)
    (d.A)((6.0, 0), "right")
    (d.T)((6.15, 0), sb(9pt)[Vaqt $t$ (ms)], at: left + horizon)
    (d.L)((0, 0), (0, 4.9), st: 1pt + black)
    (d.A)((0, 5.0), "up")
    (d.T)((0.05, 5.1), sb(9pt)[Amplituda ($x, V, P_1$)], at: left + bottom)

    // --- Kechikish liniyasi ---
    (d.L)((1.2, 0), (1.2, 4.5), st: (paint: red, thickness: 1pt, dash: "dashed"))
    (d.T)((0.95, 2.5), rotate(-90deg, reflow: false, text(size: 6.5pt, weight: "bold", fill: red)[Kechikish $t_d$]))

    // --- P1(t): bosim sakrashi bilan ---
    let gcol = 1.8pt + green.darken(30%)
    (d.L)((0, 0), (0.3, 0.2), st: gcol)
    (d.B)((0.3, 0.2), (0.6, 3.8), (1.0, 4.2), (1.2, 3.2), st: gcol)
    (d.L)((1.2, 3.2), (2.0, 3.5), st: gcol)
    (d.B)((2.0, 3.5), (3.5, 3.4), (3.5, 3.4), (5.0, 3.5), st: gcol)
    (d.T)((5.1, 3.5), sb(7pt)[$P_1 (t)$ (Bosim)], at: left + horizon)

    // --- x(t): S-simon koʻchish egri chizigʻi ---
    let bcol = 1.8pt + blue.darken(20%)
    (d.L)((0, 0), (1.2, 0), st: bcol)
    (d.B)((1.2, 0), (2.0, 0.5), (3.0, 3.0), (4.5, 4.0), st: bcol)
    (d.L)((4.5, 4.0), (5.5, 4.0), st: bcol)
    (d.T)((5.6, 4.0), sb(7pt)[$x(t)$ (Koʻchish)], at: left + horizon)

    // --- V(t): trapetsiyasimon tezlik ---
    (d.L)((0, 0), (1.2, 0), (2.2, 2.8), (3.8, 2.8), (4.5, 0), (5.5, 0), st: 1.8pt + red.darken(20%))
    (d.T)((3.0, 2.9), box(fill: white, inset: 2pt, sb(7pt)[$V(t)$ (Tezlik)]), at: center + bottom)

    // --- Vaqt belgilari ---
    for (x, lbl) in ((0, $0$), (1.2, $t_d$), (2.2, $t_a$), (3.8, $t_v$), (4.5, $t_(s t)$)) {
      (d.T)((x, -0.12), sb(7pt)[#lbl], at: center + top)
    }
  }),
  caption: [
    Pnevmosilindr oʻtish jarayonlarining dinamik vaqtinchalik
    xarakteristikalari
  ],
)

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(level: 2, numbering: none, outlined: false)[1-bosqich: Kechikish vaqti ($t_d$) va tezlanish vaqtini oʻlchash]

+ Pnevmatizimga $P_"tam" = 6 "bar"$ taʼminot bosimini berib, DAQ kompleksi va
  osillografni ishga tushiring.
+ Pnevmotaqsimlagich solenoidiga elektr signal uzating va signal berilgan
  ondan porshen siljiy boshlaguncha oʻtgan kechikish vaqtini ($t_d$)
  osillogrammada aniqlang.
+ Porshenning maksimal tezlikka chiqish vaqti ($t_a$) hamda toʻliq yurish
  vaqti ($t_"toʻliq"$) ni qayd eting.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-bosqich: Har xil yuklamalarda dinamik bosim sakrashlarini ($P_"spike"$) tadqiq etish]

+ Silindr shtokiga ketma-ket $M = 0, 5, 10, 15 "kg"$ yuk massalarini ulagan
  holda tajribani takrorlang.
+ Harakat boshidagi va toʻxtash momentidagi pik bosim qiymatlari
  ($P_"max"$) hamda aks bosim ($P_2$) oʻzgarishlarini yozib oling.

= Tajriba natijalari va hisoblashlar jadvali

#figure(
  table(
    columns: 8,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$M$ (kg)*], [*$t_d$ (ms)*], [*$t_a$ (ms)*],
    [*$t_"toʻliq"$ (ms)*], [*$V_"max"$ (m/s)*], [*$P_(1,"max")$ (bar)*],
    [*$P_(2,"aks")$ (bar)*],
    table.hline(stroke: 0.5pt),
    [1], [0.0], [28], [45], [310], [0.72], [6.2], [1.1],
    [2], [5.0], [42], [78], [430], [0.54], [6.6], [1.3],
    [3], [10.0], [65], [120], [610], [0.38], [7.1], [1.5],
    [4], [15.0], [98], [185], [890], [0.25], [7.5], [1.6],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Pnevmoyuritma dinamik xarakteristikalari tajriba natijalari
    ($P_"tam" = 6 "bar"$, $S = 0.2 "m"$)
  ],
)

= Hisobot mazmuni va grafik tahlil

+ Tajriba osillogrammalari asosida $x(t)$, $V(t)$, $P_1 (t)$ va $P_2 (t)$
  dinamik grafiklarini chizish.
+ Yuklama massasi $M$ ortishi bilan kechikish vaqti $t_d$ va bosim sakrashi
  $P_"max"$ ortish sabablarini tahlil qilish.
+ Sanoat robotlarining yuqori tezlikda ishlovchi mexanizmlarida dinamik zarba
  va tebranishlarni kamaytirish usullarini koʻrsatish.

= Nazorat savollari

+ Pnevmoyuritmaning dinamik xarakteristikasi deb nimaga aytiladi va u statik
  xarakteristikadan nimasi bilan farq qiladi?
+ Kechikish vaqti (dead time) nima va u qaysi omillar (bosim, havo hajmi,
  ishqalanish) hisobiga yuzaga keladi?
+ Harakat boshida va oxirida yuzaga keladigan bosim sakrashlari (pressure
  spikes) va dinamik zarbalarning sababi nimada?
+ Sanoat robotlari pnevmoyuritmalarida dinamik tebranishlarni silliqlash uchun
  qanday dempferlash qurilmalari qoʻllaniladi?
