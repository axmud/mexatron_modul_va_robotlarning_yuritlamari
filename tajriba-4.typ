// ============================================================
//  3-TAJRIBA MASHGʻULOTI  —  tashqi paketsiz (CeTZ kerak emas)
//  Kompilyatsiya:  typst compile tajriba-3.typ
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

#set document(title: "4-Tajriba Maşguloti: Pnevmoyuritma xarakteristikalariga havo bosimi taʼsirini tadqiq etiş")

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 4  // amaliyot raqami
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
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MAŞĞULOTI №4]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Pnevmoyuritma xarakteristikalariga havo bosimi taʼsirini tadqiq etiş
  ]

  #v(0.1cm)
  #text(size: 10pt)[(Mexatron modul va robotlarning pnevmoyuritmalarida)]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Işning maqsadi

- Mexatron modullar va sanoat robotlarida siqilgan havo taʼminot bosimining
  ($P_"tam"$) pnevmoyuritmaning statik va dinamik xarakteristikalariga
  taʼsirini tajribada örganiş.

- Taʼminot bosimi özgarişi bilan pnevmosilindr rivojlantiradigan kuç
  ($F = f(P)$), porşen harakat tezligi ($V = f(P)$) va havo sarfi
  ($Q = f(P)$) örtasidagi boğliqliklarni tadqiq etiş.

- Havo tayyorlaş blokidagi bosim reduktori (pressure regulator) va
  proporsional pnevmotaqsimlagiçlar yordamida bosimni aniq rostlaş hamda
  ölçov vositalari bilan iş olib boriş könikmalarini şakllantiriş.

= Qisqaça nazariy maʼlumotlar

Pnevmatik yuritmalarning asosiy energetik manbai siqilgan havo bosimi
hisoblanadi. Sanoat pnevmo-tizimlarida standart işçi bosim odatda
$P_"tam" = 4 dots 8 "bar"$ diapazonida özgaradi. Bosimning özgarişi
pnevmoyuritmaning barça asosiy xarakteristikalariga bevosita taʼsir
körsatadi.

== Bosim va Kuç Boğliqligi

Pnevmosilindr porşenining işçi yurişida rivojlantiriladigan nazariy kuç
taʼminot bosimi ($P_"tam"$) va porşen yuzasiga ($A_1$) töğri
mutanosibdir:

$ F_"naz" = P_"tam" dot A_1 = P_"tam" dot (pi D^2) / 4 $

Real şaroitda manjetlardagi işqalaniş kuçi ($f$) va aks bosim ($P_2$)
hisobga olinsa, amaldagi foydali kuç:

$ F_"taj" = P_1 A_1 - P_2 A_2 - f $

bunda $A_2 = A_1 - a_"ştok"$ --- ştok kamerasining effektiv yuzasi.

== Bosim va Tezlik (Havo Sarfi) Munosabati

Siqilgan havoning drossel va truboprovod teşiklaridan oqib ötiş sarfi ($Q$)
kiriş va çiqiş kameralaridagi bosimlar farqiga
($Delta P = P_"tam" - P_1$) boğliq bölib, quyidagi ifoda bilan aniqlanadi:

$ Q = mu dot f_0 dot sqrt(2 / rho Delta P) $

bunda $mu$ --- sarf koeffitsienti, $f_0$ --- drossel teşigi yuzasi,
$rho$ --- siqilgan havo ziçligi.

Silindr porşenining harakat tezligi esa havo sarfi $Q$ ga mutanosibdir
($V = Q \/ A_1$). Taʼminot bosimi $P_"tam"$ oşişi bilan kameralarga havo
töliş tezligi va massa sarfi ortadi, bu esa pnevmosilindrning tezlanişi va
maksimal harakat tezligini oşiradi.

= Kerakli jihozlar va stend elementlari

+ *Pnevmatik laboratoriya stendi:* Kompressor, resiver va aniq rostlanuvçi
  FRL bloki.
+ *Ijro organi:* Ikki taraflama taʼsir etuvçi pnevmosilindr
  ($D = 25 "mm"$, $S = 200 "mm"$).
+ *Boşqaruv apparati:* 5/2-yölli elektropnevmotaqsimlagiç hamda bosimni
  proporsional rostlaş klapani.
+ *Ölçov datçiklari:* Raqamli manometrlar ($P_1, P_2$), kuç datçigi
  (load cell), çiziqli köçiş va tezlik datçigi (LVDT / optik enkoder).

= Pnevmatik va Bosim Taʼsiri Sxemalari

== Bosim Taʼsirini Tadqiq Etiş Tajriba Stendi Sxemasi

#figure(
  sxema(xmin: -2.4, xmax: 7.4, ymin: -2.7, ymax: 5.3, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none, st: 1pt + black) = {
      (d.R)(a, b, fl: fl, st: st)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }

    // --- Pnevmosilindr ---
    (d.R)((0, 3.5), (3, 4.5), fl: gray.lighten(85%))
    (d.R)((1.0, 3.55), (1.3, 4.45), fl: blue.lighten(70%)) // porshen
    (d.R)((1.3, 3.9), (4.0, 4.1), fl: gray.lighten(50%), st: 1.5pt + black) // shtok
    (d.T)((1.5, 4.6), sb(9pt)[Pnevmosilindr ($D = 25$ mm)], at: center + bottom)

    // --- Kuch datchigi ---
    BX((3.95, 3.55), (5.15, 4.45), align(center, sb(7pt)[Kuç \ Datçigi]), fl: orange.lighten(70%))

    // --- Bosim datchiklari ---
    (d.L)((0.5, 3.5), (0.5, 3.1))
    BX((0.2, 2.7), (0.8, 3.1), sb(7pt)[$P_1$], fl: green.lighten(80%))
    (d.L)((2.5, 3.5), (2.5, 3.1))
    BX((2.2, 2.7), (2.8, 3.1), sb(7pt)[$P_2$], fl: green.lighten(80%))

    // --- Ulanish chiziqlari ---
    (d.L)((0.5, 2.7), (0.5, 1.4))
    (d.L)((2.5, 2.7), (2.5, 1.4))

    // --- 5/2 pnevmotaqsimlagich ---
    (d.R)((-0.2, 0.2), (3.2, 1.4), fl: blue.lighten(95%))
    (d.L)((1.5, 0.2), (1.5, 1.4), st: (paint: black, thickness: 1pt, dash: "dashed"))
    (d.T)((0.65, 0.8), align(center, sb(7pt)[Pozitsiya 1 \ P$->$A, B$->$R]))
    (d.T)((2.35, 0.8), align(center, sb(7pt)[Pozitsiya 2 \ P$->$B, A$->$S]))
    (d.T)((1.5, 1.48), box(fill: white, inset: 1pt, sb(9pt)[5/2 Elektropnevmotaqsimlagiç]), at: center + bottom)

    // --- Aniq rostlanuvchi bosim reduktori ---
    BX(
      (-0.3, -1.3),
      (3.3, -0.3),
      align(center, sb(8pt)[Aniq Bosim Reduktori \ $P_"tam" = 2 dots 8$ bar]),
      fl: yellow.lighten(70%),
    )
    (d.L)((1.5, -0.3), (1.5, 0.12))
    (d.A)((1.5, 0.2), "up")
    (d.T)((1.6, -0.05), sb(7pt)[$P_"tam"$], at: left + horizon)
    (d.L)((1.5, -2.0), (1.5, -1.38))
    (d.A)((1.5, -1.3), "up")
    (d.T)((1.5, -2.1), sb(9pt)[Kompressor Manbai], at: center + top)
  }),
  caption: [Bosim özgarişining pnevmoyuritmaga taʼsirini örganiş stendi],
)

== Bosim va Kuç/Tezlik Boğliqlik Grafiklari ($F = f(P)$ va $V = f(P)$)

#figure(
  sxema(xmin: -0.6, xmax: 8.6, ymin: -1.0, ymax: 5.3, ux: 1.2cm, uy: 1cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    // --- Toʻr ---
    (d.G)((0, 0), (5, 4))

    // --- Koordinata oʻqlari ---
    (d.L)((0, 0), (5.4, 0), st: 1pt + black)
    (d.A)((5.5, 0), "right")
    (d.T)((5.65, 0), sb(9pt)[Taʼminot bosimi $P_"tam"$ (bar)], at: left + horizon)
    (d.L)((0, 0), (0, 4.4), st: 1pt + black)
    (d.A)((0, 4.5), "up")
    (d.T)((0.05, 4.6), sb(9pt)[Kuç $F$ (N) / Tezlik $V$ (m/s)], at: left + bottom)

    // --- Kuch chizigʻi F = f(P): chiziqli ---
    (d.L)((0.5, 0.4), (4.8, 4.0), st: 1.8pt + blue.darken(20%))
    (d.T)((4.95, 1.5), box(fill: white, inset: 2pt, sb(9pt)[$F = f(P_"tam")$]), at: right + horizon)

    // --- Tezlik chizigʻi V = f(P): toʻyinuvchi, chiziqli emas ---
    (d.B)((0.5, 0.2), (2.0, 2.5), (3.5, 3.4), (4.8, 3.7), st: 1.8pt + red.darken(20%))
    (d.T)((3.3, 3.85), box(fill: white, inset: 2pt, sb(9pt)[$V = f(P_"tam")$]), at: center + bottom)

    // --- X oʻqi belgilari ---
    for (x, lbl) in ((1.0, "2"), (2.2, "4"), (3.4, "6"), (4.6, "8")) {
      (d.L)((x, 0), (x, -0.08))
      (d.T)((x, -0.12), sb(7pt)[#lbl], at: center + top)
    }
  }),
  caption: [
    Taʼminot bosimiga boğliq ravişda kuç hamda tezlikning özgariş
    grafiklari
  ],
)

= Tajribani bajariş va işni ötkaziş ketma-ketligi

#heading(level: 2, numbering: none, outlined: false)[1-bosqiç: Bosimning statik kuçga taʼsirini aniqlaş ($F = f(P)$)]

+ Bosim reduktori yordamida taʼminot bosimini ketma-ket
  $P_"tam" = 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0 "bar"$ qiymatlarga sozlang.
+ Har bir bosim qiymatida silindr ştokiga kuç datçigini (load cell) tirab,
  pnevmoyuritmaning maksimal statik kuçi $F_"taj"$ ni ölçang.
+ Nazariy kuç $F_"naz" = P_"tam" A_1$ ni hisoblang hamda FİK ($eta$)
  özgarişini aniqlang.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-bosqiç: Bosimning harakat tezligiga taʼsirini aniqlaş ($V = f(P)$)]

+ Drossel oçilişini 100% (töliq oçiq) holatda va özgarmas yuklamada
  ($M = 5 "kg"$) uşlang.
+ Taʼminot bosimini $P_"tam" = 2.0 dots 8.0 "bar"$ diapazonda özgartirib,
  porşenning töliq yuriş vaqti ($t$) va örtaça tezligini
  ($V = S \/ t$) ölçang.
+ Tajribani drossel oçilişi 50% bölgan holat uçun takrorlang va
  taqqoslang.

= Tajriba natijalari va hisoblaşlar jadvali

#figure(
  table(
    columns: 8,
    align: center + horizon,
    stroke: none,
    inset: (x: 5pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$P_"tam"$ (bar)*], [*$F_"taj"$ (N)*], [*$F_"naz"$ (N)*],
    [*$eta$ (%)*], [*$t$ (s)*], [*$V$ (m/s)*], [*$Q$ (l/min)*],
    table.hline(stroke: 0.5pt),
    [1], [2.0], [91.5], [98.1], [93.3%], [0.68], [0.294], [18.2],
    [2], [3.0], [139.2], [147.2], [94.6%], [0.49], [0.408], [26.5],
    [3], [4.0], [186.0], [196.3], [94.7%], [0.39], [0.512], [34.8],
    [4], [5.0], [233.5], [245.4], [95.1%], [0.33], [0.606], [42.1],
    [5], [6.0], [280.2], [294.5], [95.1%], [0.29], [0.689], [49.5],
    [6], [7.0], [327.0], [343.6], [95.2%], [0.26], [0.769], [56.2],
    [7], [8.0], [374.1], [392.7], [95.3%], [0.24], [0.833], [62.8],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Taʼminot bosimi taʼsirini tadqiq etiş tajriba natijalari
    ($D = 25 "mm"$, $S = 0.2 "m"$)
  ],
)

= Hisobot mazmuni va grafik tahlil

+ Ölçangan natijalar asosida $F = f(P_"tam")$, $V = f(P_"tam")$ hamda
  $Q = f(P_"tam")$ *grafiklarini quriş*.
+ Bosim ortişi bilan kuç va tezlikning özgariş xarakteridagi farqlarni
  (çiziqli va notöğri çiziqli ösiş) tuşuntiriş.
+ Sanoat robotlarining pnevmoyuritmalarida energiyani tejaş va maqbul işçi
  bosimni tanlaş böyiça tavsiyalar beriş.

= Nazorat savollari

+ Taʼminot bosimi $P_"tam"$ pnevmoyuritmaning rivojlantiradigan kuçiga va
  porşen tezligiga qanday taʼsir körsatadi?
+ Nima uçun bosim ortişi bilan kuç çiziqli ravişda, tezlik esa
  töyinuvçan, çiziqli bölmagan holda oşadi?
+ Pnevmatik tizimlarda bosim reduktori (pressure regulator) qanday işlaydi va
  uning vazifasi nimadan iborat?
+ Bosimning meʼyordan oşib ketişi pnevmoyuritma va manjetlarning xizmat
  muddatiga qanday taʼsir qiladi?
