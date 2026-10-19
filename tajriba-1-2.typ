// ============================================================
//  1-2-TAJRIBA MASHGʻULOTI  —  tashqi paketsiz (CeTZ kerak emas)
//  Kompilyatsiya:  typst compile tajriba-1-2.typ
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

#set document(
  title: "1-2-Tajribalar: Mexatron modul va robotlarning pnevmoyuritmalari hamda yuklama xarakteristikalari",
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = "1-2"  // amaliyot raqami
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
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTLARI №1 va №2]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Mexatron modul va robotlarning pnevmoyuritmalari hamda yuklama
    xarakteristikalarini tekshirish va tadqiq etish
  ]

  #v(0.1cm)
  #text(size: 10pt)[
    (1 va 2-tajriba mashgʻulotlari uchun kengaytirilgan birlashgan uslubiy
    koʻrsatma)
  ]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Ishning maqsadi

- Mexatronik tizimlar, sanoat robotlarining ushlash mexanizmlari (gripper) va
  manipulyatorlarida qoʻllaniladigan pnevmoyuritmalar hamda pnevmosilindrlarning
  *statik, kinematik, dinamik va yuklama xarakteristikalarini* tajribada chuqur
  oʻrganish.

- Ishchi havo bosimi ($P_"tam"$), drossellash darajasi hamda tashqi mexanik
  yuklama kuchi ($F_"yuk"$) ning pnevmosilindr porshen harakat tezligi ($V$),
  rivojlantiriladigan kuch ($F$), kameralardagi bosimlar ($P_1, P_2$) hamda
  FİK ($eta$) ga taʼsirini tadqiq etish.

- Pnevmatizimda "Meter-out" va "Meter-in" drossellash usullari orqali aks
  bosim ($P_2$) hosil qilish va pnevmoyuritma harakat barqarorligini hamda
  qattiqligini (stiffness) taʼminlash koʻnikmalarini shakllantirish.

- Dasturlanuvchi mantiqiy kontrollerlar (PLC), elektropnevmotaqsimlagichlar
  hamda raqamli/analog datchiklar (Load cell, LVDT, bosim datchigi) yordamida
  pnevmoyuritmani avtomatlashtirilgan boshqarish va oʻlchov ishlarini olib
  borish.

= Qisqacha nazariy maʼlumotlar

Sanoat robotlari va mexatron modullarda pnevmoyuritmalar yuqori solishtirma
quvvati (power-to-weight ratio), tuzilishining soddaligi va ekologik tozaligi
tufayli keng qoʻllaniladi. Biroq, ishchi muhit boʻlmish siqilgan havoning
*siqiluvchanligi (compressibility)* hamda truboprovodlardagi aerodinamik
qarshiliklar sababli pnevmoyuritma harakati nochiziqli xarakterga ega.

== Statik Kuch va FIK Hisobi

Ikki taraflama taʼsir etuvchi pnevmosilindr porshenining oldinga surilishida
(extension) rivojlantiriladigan nazariy kuch taʼminot bosimi ($P_"tam"$) hamda
porshen yuzasiga ($A_1$) toʻgʻri mutanosibdir:

$ F_"nazariy" = P_"tam" dot A_1 = P_"tam" dot (pi dot D^2) / 4 $

Porshenning ortga qaytishida (retraction) shtok egallagan yuza ($a$) hisobiga
effektiv yuza kamayadi ($A_2 = A_1 - a$), natijada ortga qaytish kuchi
nisbatan kichikroq boʻladi:

$ F_"qaytish" = P_"tam" dot A_2 = P_"tam" dot (pi (D^2 - d^2)) / 4 $

bunda $D$ --- porshen diametri, $d$ --- shtok diametri.

Manjetlardagi ishqalanish kuchi ($f_"ishq"$) va aks bosim ($P_2$) sababli
amaldagi foydali kuch ($F_"tajriba"$) nazariy qiymatdan kamroq boʻladi.
Foydali ish koeffitsienti (FIK) quyidagicha aniqlanadi:

$ eta = F_"tajriba" / F_"nazariy" dot 100% $

== Dinamik Tenglama va Yuklama Xarakteristikasi

Pnevmosilindr porsheniga taʼsir etuvchi kuchlar muvozanati Nyutonning ikkinchi
qonuniga koʻra quyidagi differensial tenglama bilan ifodalanadi:

$
  M (dif^2 x) / (dif t^2) + b (dif x) / (dif t) + F_"yuk"
  = P_1 (t) A_1 - P_2 (t) A_2 - f_"ishq" dot "sgn" ((dif x) / (dif t))
$

bunda $M$ --- porshen, shtok va yuklamaning keltirilgan massasi, $b$ ---
viskoz ishqalanish koeffitsienti, $F_"yuk"$ --- tashqi mexanik yuklama kuchi,
$P_1, P_2$ --- ishchi va chiqish kameralaridagi bosimlar.

Pnevmoyuritmaning *yuklama xarakteristikasi* deb, oʻzgarmas taʼminot bosimida
($P_"tam"$) porshen harakat tezligi ($V$) hamda tashqi yuklama kuchi
($F_"yuk"$) oʻrtasidagi $V = f(F_"yuk")$ bogʻliqlikka aytiladi. Tashqi yuklama
ortib borgan sari porshen tezligi pasayadi. Yuklama kuchi maksimal
rivojlantiriladigan kuchga tenglashganda ($F_"yuk" = F_"stall"$), porshen
harakati toʻxtaydi ($V = 0$). Bu holat *toʻxtash rejimi (stall condition)* deb
ataladi.

== Drossellash Usullari va Havo Sarfi

Pnevmosilindr harakat tezligini bir maromda boshqarish uchun teskari klapanli
drossellar ishlatiladi. Pnevmotizimlarda drossellashning 2 xil sxemasi
mavjud:

+ *"Meter-out" (Chiqishdagi drossellash):* Ishlatilgan havo silindrdan
  chiquvchi liniyada drossellanadi. Bu chiqish kamerasida aks bosim ($P_2$)
  hosil qilib, siqilgan havoning pnevmo-prujina effektini va tebranishlarni
  silliqlaydi. Sanoat robotlarida eng koʻp qoʻllaniladigan usuldir.
+ *"Meter-in" (Kirishdagi drossellash):* Ishchi kameraga kiruvchi havo
  drossellanadi. Ushbu usul faqat bir tomonlama oʻzgarmas yuklamalarda
  qoʻllaniladi.

Drossel teshigidan oqib oʻtuvchi havo sarfi ($Q$) kirish va chiqish
kameralaridagi bosimlar farqiga ($Delta P = P_1 - P_2$) bogʻliq:

$ Q = mu dot f_0 dot sqrt(2 / rho Delta P) $

bunda $mu$ --- sarf koeffitsienti, $f_0$ --- drossel teshigi yuzasi,
$rho$ --- siqilgan havo zichligi.

= Kerakli jihozlar va stend elementlari

+ *Pnevmatik laboratoriya stendi:* Kompressor, resiver va FRL bloki (filtr,
  reduktor, moylagich).
+ *Ijro organi:* Ikki taraflama taʼsir etuvchi pnevmosilindr
  ($D = 25 "mm"$, $S = 200 "mm"$).
+ *Boshqaruv apparati:* 5/2-yoʻlli elektropnevmotaqsimlagich (24V DC solenoid
  va prujinali qaytish).
+ *Rostlash elementlari:* Teskari klapanli drossellar (Flow control valves).
+ *Yuklama mexanizmi:* Sozlanuvchi yuk massalari ($M = 2 dots 20 "kg"$) va
  tormozlovchi mexanizm.
+ *Oʻlchov va boshqaruv kompleksi:*
  - Raqamli va analog manometrlar ($P_1, P_2$);
  - Kuch datchigi (S-type Load Cell $F_"yuk"$);
  - Chiziqli koʻchish hamda tezlik datchigi (LVDT / optik enkoder);
  - Chekli kalitlar (Limit switches LS1, LS2);
  - PLC kontroller (Siemens S7-1200 / Mitsubishi FX) va sekundomer.

= Pnevmatik, Elektr va Yuklama Sxemalari

== Prinsipial Pnevmatik va Yuklama Sxemasi (1 va 2-Tajribalar Birlashgan Stendi)

#figure(
  sxema(xmin: -2.6, xmax: 8.0, ymin: -2.8, ymax: 5.6, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none, st: 1pt + black) = {
      (d.R)(a, b, fl: fl, st: st)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }

    // --- Pnevmosilindr ---
    (d.R)((0, 3.5), (3.2, 4.5), fl: gray.lighten(85%))
    (d.R)((1.0, 3.55), (1.3, 4.45), fl: blue.lighten(70%)) // porshen
    (d.R)((1.3, 3.9), (4.2, 4.1), fl: gray.lighten(50%), st: 1.5pt + black)
    (d.T)((1.6, 5.2), sb(9pt)[Pnevmosilindr ($D = 25$ mm)], at: center + bottom)

    // --- Chekli kalitlar ---
    BX((0.2, 4.7), (0.8, 5.1), sb(7pt)[LS1], fl: red.lighten(80%), st: 1pt + red.darken(20%))
    BX((2.6, 4.7), (3.2, 5.1), sb(7pt)[LS2], fl: red.lighten(80%), st: 1pt + red.darken(20%))

    // --- Kuch datchigi (Load Cell) ---
    BX((4.2, 3.55), (5.4, 4.45), align(center, sb(7pt)[Load \ Cell]), fl: orange.lighten(70%))

    // --- Blok-rolik va yuk ---
    (d.L)((5.4, 4.0), (6.0, 4.0))
    (d.C)((6.0, 4.0), 0.3, fl: gray.lighten(60%))
    (d.L)((6.0, 3.7), (6.0, 2.2))
    BX((5.5, 1.4), (6.5, 2.2), sb(9pt)[Yuk $M$], fl: red.lighten(70%))
    (d.L)((6.0, 1.4), (6.0, 0.68), st: 1.5pt + red.darken(20%))
    (d.A)((6.0, 0.6), "down", fl: red.darken(20%))
    (d.T)((6.15, 0.6), sb(9pt)[$F_"yuk" = M g$], at: left + horizon)

    // --- Bosim datchiklari ---
    (d.L)((0.5, 3.5), (0.5, 3.1))
    BX((0.2, 2.7), (0.8, 3.1), sb(7pt)[$P_1$], fl: green.lighten(80%))
    (d.L)((2.7, 3.5), (2.7, 3.1))
    BX((2.4, 2.7), (3.0, 3.1), sb(7pt)[$P_2$], fl: green.lighten(80%))
    (d.L)((0.5, 2.7), (0.5, 2.4))
    (d.L)((2.7, 2.7), (2.7, 2.4))

    // --- Drossellar (Meter-out) ---
    BX((-0.25, 2.0), (1.25, 2.4), sb(7pt)[Drossel 1], fl: yellow.lighten(80%))
    BX((1.95, 2.0), (3.45, 2.4), sb(7pt)[Drossel 2], fl: yellow.lighten(80%))
    (d.L)((0.5, 2.0), (0.5, 1.4))
    (d.L)((2.7, 2.0), (2.7, 1.4))

    // --- 5/2 pnevmotaqsimlagich ---
    (d.R)((-0.2, 0.2), (3.4, 1.4), fl: blue.lighten(95%))
    (d.L)((1.6, 0.2), (1.6, 1.4), st: (paint: black, thickness: 1pt, dash: "dashed"))
    (d.T)((0.7, 0.8), align(center, sb(7pt)[Pozitsiya 1 \ P$->$A, B$->$R]))
    (d.T)((2.5, 0.8), align(center, sb(7pt)[Pozitsiya 2 \ P$->$B, A$->$S]))
    (d.T)((1.6, 1.48), box(fill: white, inset: 1pt, sb(9pt)[5/2 Elektropnevmotaqsimlagich]), at: center + bottom)

    // --- Solenoid va prujina ---
    BX((-1.7, 0.4), (-0.2, 1.2), align(center, sb(7pt)[Solenoid \ Y1]), fl: orange.lighten(60%))
    (d.L)((3.4, 0.8), (3.5, 0.8), (3.6, 1.05), (3.7, 0.55), (3.8, 1.05), (3.9, 0.55), (4.0, 0.8), (4.1, 0.8))
    (d.T)((4.15, 0.8), sb(7pt)[Prujina], at: left + horizon)

    // --- Taʼminot va FRL ---
    (d.L)((1.6, -0.6), (1.6, 0.12))
    (d.A)((1.6, 0.2), "up")
    (d.T)((1.7, -0.25), sb(9pt)[P ($P_"tam" = 6$ bar)], at: left + horizon)
    BX(
      (-0.3, -1.6),
      (3.5, -0.6),
      align(center, sb(8pt)[FRL Bloki \ (Filtr-Reduktor-Moylagich)]),
      fl: green.lighten(85%),
    )
    (d.L)((1.6, -2.1), (1.6, -1.68))
    (d.A)((1.6, -1.6), "up")
    (d.T)((1.6, -2.2), sb(9pt)[Kompressor Manbai], at: center + top)
  }),
  caption: [
    Mexatron modul pnevmoyuritmasining prinsipial pnevmatik va yuklama stendi
    sxemasi
  ],
)

== PLC Boshqaruv va Datchiklar Elektr Ulanish Sxemasi

#figure(
  sxema(xmin: -6.2, xmax: 7.2, ymin: -3.5, ymax: 3.2, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    // --- PLC bloki ---
    (d.R)((-3.5, -1.5), (3.5, 1.5), fl: gray.lighten(85%))
    (d.T)((0, 0.2), sb(11pt)[PLC Kontroller (Siemens S7-1200 / CPU)])

    // --- Kirish klemmalari ---
    (d.T)((0, 0.95), sb(8pt)[KIRISHLAR (DIGITAL & ANALOG INPUTS)])
    for (x, nm) in ((-2.5, "I0.0 (Start)"), (-1.0, "I0.1 (LS1)"), (0.5, "I0.2 (LS2)"), (2.2, "AI0 (Load Cell)")) {
      (d.C)((x, 1.5), 0.1)
      (d.T)((x, 1.36), sb(6.5pt)[#nm], at: center + top)
    }

    // --- Chiqish klemmasi ---
    (d.T)((0, -0.95), sb(8pt)[CHIQISHLAR (DIGITAL OUTPUTS)])
    (d.C)((0, -1.5), 0.1)
    (d.T)((0, -1.36), sb(6.5pt)[Q0.0 (Solenoid Y1)], at: center + bottom)

    // --- Quvvat shinalari ---
    (d.L)((-4.8, 2.8), (4.8, 2.8), st: 2pt + red.darken(20%))
    (d.T)((4.9, 2.8), sb(9pt)[+24V DC], at: left + horizon)
    (d.L)((-4.8, -3.0), (4.8, -3.0), st: 2pt + blue.darken(20%))
    (d.T)((4.9, -3.0), sb(9pt)[0V (GND)], at: left + horizon)

    // --- Start tugmasi ---
    (d.L)((-2.5, 2.8), (-2.5, 2.3))
    (d.L)((-2.7, 2.3), (-2.3, 2.3))
    (d.L)((-2.5, 2.3), (-2.5, 1.73))
    (d.A)((-2.5, 1.65), "down")
    (d.T)((-2.65, 2.15), sb(6.5pt)[Start PB], at: right + horizon)

    // --- LS1 ---
    (d.L)((-1.0, 2.8), (-1.0, 2.3))
    (d.L)((-1.15, 2.3), (-0.85, 2.0))
    (d.L)((-1.0, 2.0), (-1.0, 1.73))
    (d.A)((-1.0, 1.65), "down")

    // --- LS2 ---
    (d.L)((0.5, 2.8), (0.5, 2.3))
    (d.L)((0.35, 2.3), (0.65, 2.0))
    (d.L)((0.5, 2.0), (0.5, 1.73))
    (d.A)((0.5, 1.65), "down")

    // --- Load Cell kuchaytirgichi ---
    (d.L)((2.2, 2.8), (2.2, 2.4))
    (d.R)((1.55, 1.95), (2.85, 2.4), fl: orange.lighten(80%))
    (d.T)((2.2, 2.175), sb(6.5pt)[LoadCell Amp])
    (d.L)((2.2, 1.95), (2.2, 1.73))
    (d.A)((2.2, 1.65), "down")

    // --- Chiqish: Solenoid Y1 ---
    (d.L)((0, -1.6), (0, -2.0))
    (d.R)((-0.8, -2.5), (0.8, -2.0), fl: orange.lighten(70%))
    (d.T)((0, -2.25), sb(6.5pt)[Solenoid Y1])
    (d.L)((0, -2.5), (0, -3.0))
  }),
  caption: [PLC kontrollerning datchiklar va solenoidlar bilan elektr ulanish sxemasi],
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

    // --- Tezlik egri chizigʻi ---
    (d.B)((0, 3.8), (1.5, 3.5), (3.5, 2.0), (4.8, 0), st: 1.8pt + red.darken(20%))
    (d.T)((1.0, 3.5), box(fill: white, inset: 2pt, sb(9pt)[$V = f(F_"yuk")$]), at: left + bottom)

    // --- Bosim chizigʻi ---
    (d.L)((0, 0.8), (4.8, 3.8), st: 1.8pt + blue.darken(20%))
    (d.T)((4.75, 3.35), box(fill: white, inset: 2pt, sb(9pt)[$P_1 = f(F_"yuk")$]), at: right + bottom)

    // --- Xarakterli nuqtalar ---
    (d.P)((0, 3.8), 2pt)
    (d.T)((-0.1, 3.8), sb(7pt)[$V_0$ (Salt ishlash)], at: right + horizon)
    (d.P)((4.8, 0), 2pt)
    (d.T)((4.8, -0.3), sb(7pt)[$F_"stall"$ (Toʻxtash kuchi)], at: center + top)

    // --- Izohlar ---
    (d.L)((4.8, 0), (4.8, 3.8), st: (paint: gray, thickness: 1pt, dash: "dashed"))
    (d.T)((2.2, 0.4), box(fill: white, inset: 2pt, sb(7pt)[Ishchi zona]))
    (d.T)((4.3, 1.2), box(fill: white, inset: 2pt, align(center, sb(7pt)[Kritik yuklama \ (Stall condition)])))
  }),
  caption: [Pnevmoyuritmaning tezlik va bosim yuklama xarakteristikalari],
)

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[1-bosqich: Taʼminot bosimining statik kuchga taʼsirini aniqlash (1-Tajriba)]

+ Havo tayyorlash bloki (FRL) reduktori orqali bosimni ketma-ket
  $P_"tam" = 2, 4, 6, 8 "bar"$ qiymatlarga sozlang.
+ Pnevmosilindr shtokiga kuch datchigini (load cell) tirab, har bir bosimda
  maksimal rivojlantiriladigan statik kuch $F_"tajriba"$ ni oʻlchang.
+ Formula (1) va (3) boʻyicha $F_"nazariy"$ hamda FİK ($eta$) qiymatlarini
  hisoblang.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-bosqich: Drossellash usullarining porshen tezligiga taʼsirini aniqlash]

+ Taʼminot bosimini $P_"tam" = 6 "bar"$ oʻzgarmas holatda saqlang.
+ Chiqish drosseli ("Meter-out") ochilishini 25%, 50%, 75% va 100% ga
  oʻzgartirib, toʻliq yurish masofasi ($S = 0.2 "m"$) boʻyicha harakat vaqti
  ($t$) va oʻrtacha tezlikni ($V = S \/ t$) aniqlang.
+ Har bir drossellash rejimida chiqish kamerasidagi aks bosim $P_2$ ni qayd
  eting.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[3-bosqich: Pnevmoyuritma yuklama xarakteristikasini olish (2-Tajriba)]

+ Taʼminot bosimini $P_"tam" = 6 "bar"$ va drossel ochilishini 100% holatda
  ushlang.
+ Pnevmosilindr shtokiga blok-rolik orqali ketma-ket
  $M = 0, 2.5, 5.0, 10.0, 15.0, 20.0 "kg"$ yuk massalarini osib, yuklama kuchi
  $F_"yuk" = M g$ ni hosil qiling.
+ Har bir yuklama qiymatida porshen harakat tezligi $V$, kirish kamerasidagi
  ishchi bosim $P_1$ hamda aks bosim $P_2$ ni oʻlchang.
+ Porshen harakati toʻliq toʻxtaydigan kritik toʻxtash yuklamasini
  ($F_"stall"$) aniqlang.

= Tajriba natijalari va hisoblashlar jadvallari

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[1-Jadval: Taʼminot bosimi va Drossellash Taʼsiri Natijalari (1-Tajriba)]

#figure(
  table(
    columns: 8,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$P_"tam"$ (bar)*], [*Drossel (%)*], [*$t$ (s)*],
    [*$F_"taj"$ (N)*], [*$F_"naz"$ (N)*], [*$eta$ (%)*], [*$V$ (m/s)*],
    table.hline(stroke: 0.5pt),
    [1], [2.0], [100%], [0.65], [91.5], [98.1], [93.3%], [0.308],
    [2], [4.0], [100%], [0.38], [186.0], [196.3], [94.7%], [0.526],
    [3], [6.0], [100%], [0.29], [280.2], [294.5], [95.1%], [0.689],
    [4], [6.0], [50%], [0.52], [280.0], [294.5], [95.1%], [0.385],
    [5], [6.0], [25%], [0.98], [279.8], [294.5], [95.0%], [0.204],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Statik kuch va drossellash boʻyicha tajriba natijalari ($S = 0.2 "m"$)
  ],
)

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-Jadval: Pnevmoyuritma Yuklama Xarakteristikasi Natijalari (2-Tajriba)]

#figure(
  table(
    columns: 9,
    align: center + horizon,
    stroke: none,
    inset: (x: 3.5pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$M$ (kg)*], [*$F_"yuk"$ (N)*], [*$t$ (s)*], [*$V$ (m/s)*],
    [*$P_1$ (bar)*], [*$P_2$ (bar)*], [*$F_"naz"$ (N)*], [*$eta$ (%)*],
    table.hline(stroke: 0.5pt),
    [1], [0.0], [0.0], [0.29], [0.689], [1.2], [1.1], [294.5], [0.0%],
    [2], [2.5], [24.5], [0.34], [0.588], [2.1], [1.2], [294.5], [8.3%],
    [3], [5.0], [49.0], [0.41], [0.488], [2.8], [1.2], [294.5], [16.6%],
    [4], [10.0], [98.1], [0.58], [0.345], [4.1], [1.3], [294.5], [33.3%],
    [5], [15.0], [147.1], [0.85], [0.235], [5.2], [1.3], [294.5], [50.0%],
    [6], [22.5], [220.7], [$infinity$], [0.000], [5.8], [1.0], [294.5],
    [74.9% \ (Stall)],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Yuklama xarakteristikasi tajriba natijalari
    ($P_"tam" = 6 "bar"$, $S = 0.2 "m"$)
  ],
)

= Hisobot mazmuni va grafik tahlil

+ Tajriba natijalari boʻyicha $F_"taj" = f(P_"tam")$, $V = f(Q)$ hamda
  $V = f(F_"yuk")$, $P_1 = f(F_"yuk")$ *grafiklarini qurish*.
+ "Meter-out" drossellash usulida aks bosim $P_2$ ning pnevmosilindr silliq va
  tebranishlarsiz harakatlanishidagi rolini tushuntirish.
+ Tashqi yuklama $F_"yuk"$ ortishi bilan harakat tezligi pasayishining
  termodinamik va aerodinamik sabablarini asoslash.
+ Sanoat robotlari ushlash mexanizmlarida pnevmoyuritmani loyihalashda yuklama
  boʻyicha zaxira koeffitsientini ($K_"zaxira" = 1.3 dots 1.5$) tanlash
  boʻyicha tavsiyalar berish.

= Nazorat savollari

+ Pnevmoyuritmada porshen harakat tezligi va rivojlantiriladigan statik kuch
  qaysi parametrlar bilan boshqariladi?
+ Nima uchun pnevmoyuritmalarda "Meter-out" (chiqishdagi drossellash) usuli
  "Meter-in" usuliga qaraganda koʻproq qoʻllaniladi?
+ Pnevmoyuritmaning yuklama xarakteristikasi $V = f(F_"yuk")$ qanday
  koʻrinishga ega va uning toʻxtash nuqtasi ($F_"stall"$) nima bilan
  belgilanadi?
+ Pnevmatik va gidravlik yuritmalarning yuklama ostida ishlash qattiqligi
  (stiffness) hamda barqarorligi oʻrtasidagi asosiy farqlar nimada?
+ PLC kontroller va elektropnevmotaqsimlagichlar yordamida pnevmoyuritmada
  avtomatlashtirilgan sikl qanday tashkil etiladi?
