// ============================================================
//  6-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_6.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robot elektr yuritmasining yuklama momenti va kuçini hisoblaş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 6  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (2fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Amaliyot №#raqam],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================
#set text(size: 12pt, lang: "uz", font: info.font)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)", supplement: none)
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №6]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Robot elektr yuritmasining yuklama momenti va kuçini hisoblaş]
  #v(0.2cm)
  #text(size: 10pt)[(Sanoat robotlari hamda mexatronik tizimlar yuritmalarini loyihalaş)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi va tizimli yondaşuv

Sanoat robotlari va mexatronik modullarning samarali, işonçli hamda yuqori aniqlikda işlaşini taʼminlaşda elektr yuritmaning yuklama körsatkiçlarini töğri hisoblaş hal qiluvçi ahamiyatga ega. Richard Crowder özining _Electric Drives and Electromechanical Systems_ asarida taʼkidlaganidek, *tizimli yondaşuv (Systems Approach)* tamoyiliga köra, har qanday murakkab raqamli boşqaruv algoritmi yoki sunʼiy intellekt dasturi notöğri tanlangan dvigatel hamda mexanik yuklama nomutanosibligini (_undersizing/oversizing_) qoplay olmaydi.

Robot elektr yuritmasini loyihalaşda asosiy maqsad --- robot manipulyatori böğinlariga harakat yönalişida tuşadigan statik va dinamik yuklama momentlarini ($tau_"yuk"$) va çiziqli kuçlarni ($F_"yuk"$) aniq hisoblaş, uşbu yuklamalarni uzatma mexanizmi hamda reduktor uzatiş nisbati ($n$) orqali dvigatel valiga keltiriş hamda dvigatelning nominal ($T_"nom"$) va maksimal pik ($T_"peak"$) momentlariga mosligini tekşirişdan iborat.

= Robot manipulyatori dinamikasi va yuklama tenglamalari

B. Siciliano va boşq. _Robotics: Modelling, Planning and Control_ darsligida körsatganlaridek, robot manipulyatorining köp böğinli mexanik tizim sifatidagi dinamikasi *Eyler–Lagranj (Euler–Lagrange)* tenglamasi orqali ifodalanadi:

$ M(q) dot.double(q) + C(q, dot(q)) dot(q) + F_v dot(q) + F_s "sgn"(dot(q)) + g(q) = tau $

bunda:

- $q, dot(q), dot.double(q)$ --- robot böğinlarining umumlaşgan koordinatalari (burçak yoki köçiş), tezliklari va tezlanişlari vektorlari;
- $M(q)$ --- manipulyatorning simmetrik va musbat aniqlangan inersiya matritsasi;
- $C(q, dot(q))$ --- Koriolis va markazdan qoçma (_centrifugal_) kuçlar matritsasi;
- $F_v, F_s$ --- viskoz va quruq (Kulon) işqalaniş koeffitsientlari;
- $g(q)$ --- oğirlik (gravitatsiya) kuçi momentlari vektori;
- $tau$ --- robot böğinlaridagi umumiy harakatlantiruvçi momentlar vektori.

== Gravitatsion yuklama momenti ($T_g$)

Robot böğiniga va uning uşlagiçida (gripper) joylaşgan foydali yukka oğirlik kuçi taʼsir qiladi. Gorizontal tekislikka nisbatan $theta$ burçak ostida oğgan $i$-böğin uçun gravitatsion yuklama momenti:

$ T_g (theta) = (m_i dot g dot r_(c,i) + m_L dot g dot L_i) dot cos(theta) $

bunda $m_i$ --- böğin massasi, $r_(c,i)$ --- böğin massa markazigaça bölgan masofa, $m_L$ --- uşlanayotgan yuk massasi, $L_i$ --- böğinning töliq uzunligi, $g = 9.81 "m/s"^2$.

Maksimal gravitatsion moment böğin töliq gorizontal holatda ($theta = 0 degree$) bölganda kuzatiladi:

$ T_(g,"max") = m_i g r_(c,i) + m_L g L_i $

== Inersion yuklama momenti ($T_"in"$)

Robot böğini $alpha = dot.double(theta)$ burçak tezlanişi bilan harakatlanganda inersiya qarşilik momenti yuzaga keladi. Böğin va yukning keltirilgan inersiya momenti $I_L$ bölganda:

$ T_"in" = I_L dot dot.double(theta) $

bunda $I_L = I_"böğin" + m_L dot L_i^2$ --- böğinning aylaniş öqiga nisbatan töliq inersiya momenti.

== Işqalaniş va qarşilik momentlari ($T_"frict"$)

Reduktor va podşipniklardagi işqalaniş momenti viskoz hamda quruq işqalaniş taşkil etuvçilaridan iborat:

$ T_"frict" = b_L dot dot(theta) + T_f dot "sgn"(dot(theta)) $

bunda $b_L$ --- viskoz işqalaniş koeffitsienti, $T_f$ --- quruq işqalaniş momenti.

== Dvigatel valiga keltirilgan töliq yuklama momenti ($T_m$)

Robot böğinidagi töliq yuklama momenti $tau_"yuk" = T_g + T_"in" + T_"frict" + T_"taşqi"$ reduktor orqali dvigatel valiga keltiriladi. Reduktor uzatiş nisbati $n = omega_m \/ omega_L$ va FIK $eta_"red"$ bölganda:

$
  T_m (t) = (T_g (theta) + T_"frict" + T_"taşqi") / (n dot eta_"red")
  + (I_m + I_L / (n^2 dot eta_"red")) dot.double(theta)_m
$

bunda $I_m$ --- dvigatel rotorining öz inersiya momenti, $dot.double(theta)_m = n dot dot.double(theta)$ --- dvigatel rotorining burçak tezlanişi.

= Çiziqli harakat tizimlarida kuç va moment hisobi

C.W. de Silva özining _Mechatronic Systems_ darsligida körsatganidek, çiziqli harakatlanuvçi robot modullarida (masalan, dekart robotlari yoki çiziqli uzatgiçlar) aylanma harakatni çiziqli harakatga aylantiriş uçun *şarikli-vintli uzatmalar (Ball-Screw Drives)* qöllaniladi. Çiziqli aksial yuklama kuçi $F_"yuk"$ bölganda, vint valida talab etiladigan harakatlantiruvçi moment $T_"vint"$:

$ T_"vint" = (F_"yuk" dot p) / (2 pi dot eta_"bs") + T_"pre" $

bunda:

- $F_"yuk" = m_"tot" (g dot sin phi + a_x) + F_"kesiş"$ --- töliq çiziqli kuç;
- $p$ --- şarikli vint qadami (_pitch_, masalan $p = 5 "mm/rev" = 0.005 "m"$);
- $eta_"bs"$ --- şarikli-vintli uzatmaning FIKi (odatda $eta_"bs" = 0.90 dots 0.95$);
- $T_"pre"$ --- vint gaykasining dastlabki tortiliş (_preload_) momenti.

Vint valining aylaniş burçak tezligi $omega_v$ va çiziqli tezlik $v_x$ örtasidagi boğliqlik:

$ omega_v = (2 pi dot v_x) / p $

= Grafiklar va çizmalar

== Robot manipulyatori böğinining kinematik va yuklama modeli

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *

    let small(body) = text(size: 7pt, weight: "bold", body)
    let arrow(col) = (end: "stealth", fill: col)

    // 30° ga burilgan koordinatalarni hisoblash
    let th = 30deg
    let rot(x, y) = (x * calc.cos(th) - y * calc.sin(th), x * calc.sin(th) + y * calc.cos(th))
    let rrect(x1, y1, x2, y2, ..style) = line(
      rot(x1, y1),
      rot(x2, y1),
      rot(x2, y2),
      rot(x1, y2),
      close: true,
      ..style,
    )

    // Asos va shtrixlash
    rect((-0.5, -0.5), (0.5, 0), fill: gray.lighten(70%), stroke: 1pt)
    line((-0.8, -0.5), (0.8, -0.5), stroke: 2pt)
    for x in (-0.7, -0.4, -0.1, 0.2, 0.5, 0.8) {
      line((x, -0.5), (x - 0.1, -0.7), stroke: 0.6pt)
    }

    // Gorizontal chiziq va θ burchagi
    line((0, 0), (4.5, 0), stroke: (thickness: 1pt, dash: "dashed"))
    arc((1.2, 0), start: 0deg, stop: 30deg, radius: 1.2, stroke: 1pt + blue.darken(30%), mark: arrow(blue.darken(30%)))
    content((1.3, 0.35), anchor: "west", text(size: 9pt, weight: "bold")[$theta(t)$])

    // Boʻgʻin (burilgan toʻrtburchak)
    rrect(0, -0.15, 4.0, 0.15, fill: blue.lighten(88%), stroke: 1.6pt)

    // Oʻlcham chizigʻi L_1
    line(rot(0, 0.45), rot(4.2, 0.45), stroke: 1pt + gray, mark: (start: "stealth", end: "stealth", fill: gray))
    content(rot(2.1, 0.65), angle: 30deg, small[Böğin uzunligi $L_1$])

    // Massa markazi va ogʻirlik kuchi (vertikal!)
    let cm = rot(2.0, 0)
    circle(cm, radius: 0.12, fill: red.lighten(55%), stroke: 1pt)
    line(cm, (cm.at(0), cm.at(1) - 1.2), stroke: 2pt + red.darken(20%), mark: arrow(red.darken(20%)))
    content((cm.at(0) + 0.1, cm.at(1) - 1.1), anchor: "west", small[$m_1 g$])
    content((cm.at(0) + 0.2, cm.at(1) - 0.35), anchor: "west", small[Massa markazi ($m_1, r_(c 1)$)])

    // Foydali yuk va ogʻirlik kuchi
    rrect(3.8, -0.3, 4.6, 0.3, fill: orange.lighten(50%), stroke: 1pt)
    content(rot(4.2, 0), small[Yuk \ $m_L$])
    let pl = rot(4.2, 0)
    line((pl.at(0), pl.at(1) - 0.3), (pl.at(0), pl.at(1) - 1.5), stroke: 2pt + red.darken(20%), mark: arrow(
      red.darken(20%),
    ))
    content((pl.at(0) + 0.1, pl.at(1) - 1.4), anchor: "west", small[$m_L g$])

    // Boʻgʻin oʻqi O
    circle((0, 0), radius: 0.3, fill: blue.lighten(80%), stroke: 1pt)
    content((0, 0), small[O])

    // Yuklama momenti
    arc(
      (calc.cos(60deg) * 0.6, calc.sin(60deg) * 0.6),
      start: 60deg,
      stop: 300deg,
      radius: 0.6,
      stroke: 2pt + purple,
      mark: arrow(purple),
    )
    content((-0.7, 0.35), anchor: "east", text(size: 9pt, weight: "bold", fill: purple)[$tau_"yuk"$])
  }),
  caption: [Robot manipulyatori böğiniga tuşadigan yuklama va oğirlik kuçlari modeli],
)

== Dvigatel, reduktor va yuklama tizimining kinematik zanjiri

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let boxed(a, b, fill, body) = {
      rect(a, b, fill: fill, stroke: 1pt)
      content(
        ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2),
        align(center, text(size: 9pt, weight: "bold", body)),
      )
    }

    boxed((0, 0), (2.5, 2.0), orange.lighten(80%))[Elektr \ dvigatel \ ($I_m, T_m, omega_m$)]
    rect((2.5, 0.8), (3.8, 1.2), fill: gray.lighten(40%), stroke: 1.6pt)
    boxed((3.8, -0.2), (5.8, 2.2), blue.lighten(80%))[Reduktor \ ($n, eta_"red"$)]
    rect((5.8, 0.7), (7.2, 1.3), fill: gray.lighten(40%), stroke: 1.6pt)
    boxed((7.2, -0.5), (10.0, 2.5), green.lighten(80%))[Robot böğini \ va yuklama \ ($I_L, tau_"yuk", omega_L$)]

    line((3.15, 1.5), (3.15, 2.1), stroke: 2pt + red.darken(20%), mark: (end: "stealth", fill: red.darken(20%)))
    content((3.15, 2.2), anchor: "south", text(size: 8pt, weight: "bold")[$T_m$])
    line((6.5, 1.6), (6.5, 2.2), stroke: 2pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((6.5, 2.3), anchor: "south", text(size: 8pt, weight: "bold")[$tau_"yuk"$])
  }),
  caption: [Dvigatel, reduktor hamda robot böğini yuklamasining quvvat uzatiş sxemasi],
)

== Trapetsiyasimon tezlik profili va dinamik yuklama momenti

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.9)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let red-c = red.darken(20%)
    let blue-c = blue.darken(20%)

    grid(
      (0, 0),
      (5.5, 4.0),
      step: 0.5,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    line((0, 0), (0, 4.5), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$ (s)])
    content((0, 4.6), anchor: "south", text(size: 9pt, weight: "bold")[Tezlik $omega(t)$ / Moment $T_m (t)$])

    // Tezlik profili (trapetsiya)
    line((0, 0), (1.2, 3.0), (3.8, 3.0), (5.0, 0), stroke: 2pt + red-c)
    content((4.5, 1.6), anchor: "west", text(fill: red-c, small[$omega_m (t)$]))

    // Moment profili (hisobga mos: T_acc > T_const > T_dec > 0)
    line((0, 3.6), (1.2, 3.6), (1.2, 2.3), (3.8, 2.3), (3.8, 1.05), (5.0, 1.05), (5.0, 0), stroke: 2pt + blue-c)

    // Vaqt belgilari
    for (x, lab) in ((0, $0$), (1.2, $t_a$), (3.8, $t_a + t_v$), (5.0, $t_"sikl"$)) {
      content((x, -0.1), anchor: "north", small(lab))
    }

    // Qiymat belgilari
    content((-0.1, 3.0), anchor: "east", text(fill: red-c, small[$omega_"max"$]))
    content((-0.1, 3.6), anchor: "east", text(fill: blue-c, small[$T_"acc"$ (tezlaniş)]))
    content((-0.1, 2.3), anchor: "east", text(fill: blue-c, small[$T_"const"$ (barqaror)]))
    content((-0.1, 1.05), anchor: "east", text(fill: blue-c, small[$T_"dec"$ (tormoz)]))
  }),
  caption: [Trapetsiyasimon tezlik grafigi şaroitida dvigatel validagi dinamik yuklama momenti grafigi],
)

= Amaliy hisoblaş misoli (sanoat roboti böğini hisobi)

== Boşlanğiç maʼlumotlar

Sanoat robotining 2-böğini (_Arm Joint_) uçun elektr yuritma va reduktor tanlaş hamda yuklama momentini hisoblaş talab etiladi:

- Robot böğini massasi: $m_1 = 8.0 "kg"$;
- Böğin uzunligi: $L_1 = 0.6 "m"$;
- Böğin massa markazi: $r_(c 1) = 0.3 "m"$;
- Böğinning öz inersiya momenti: $I_"böğin" = 0.32 "kg" dot "m"^2$;
- Uşlanayotgan foydali yuk massasi: $m_L = 5.0 "kg"$;
- Harakat diapazoni: $theta = 0 degree -> 90 degree$ (gorizontal holatdan vertikal holatga);
- Harakat vaqti: $t_"sikl" = 1.0 "s"$ (tezlaniş vaqti $t_a = 0.2 "s"$, barqaror harakat $t_v = 0.6 "s"$, tormozlaniş $t_d = 0.2 "s"$);
- Reduktor uzatiş nisbati: $n = 80$, FIK $eta_"red" = 0.85$.

== Hisoblaş bosqiçlari

#heading(level: 3, numbering: none)[a) Böğindagi töliq inersiya momentini hisoblaş ($I_L$)]

Yuk massasini hisobga olgan holda böğinning töliq inersiya momenti:

$ I_L = I_"böğin" + m_L dot L_1^2 = 0.32 + 5.0 dot (0.6)^2 = 0.32 + 1.80 = 2.12 "kg" dot "m"^2 $

#heading(level: 3, numbering: none)[b) Maksimal gravitatsion yuklama momenti ($T_(g,"max")$)]

Böğin gorizontal holatda ($theta = 0 degree$) bölganda oğirlik kuçi momenti maksimal böladi:

$ T_(g,"max") = m_1 dot g dot r_(c 1) + m_L dot g dot L_1 = 8.0 dot 9.81 dot 0.3 + 5.0 dot 9.81 dot 0.6 $

$ T_(g,"max") = 23.544 + 29.43 = 52.974 "Nm" $

#heading(level: 3, numbering: none)[c) Böğin burçak tezligi va tezlanişi]

Böğinning töliq buriliş burçagi $Delta theta = 90 degree = pi \/ 2 approx 1.5708 "rad"$. Trapetsiyasimon tezlik grafigi uçun maksimal burçak tezligi $omega_(L,"max")$:

$
  Delta theta = omega_(L,"max") dot (t_a + t_v) ==> 1.5708 = omega_(L,"max") dot (0.2 + 0.6)
  ==> omega_(L,"max") = 1.9635 "rad/s"
$

Böğinning burçak tezlanişi $alpha_L$:

$ alpha_L = omega_(L,"max") / t_a = 1.9635 / 0.2 = 9.8175 "rad/s"^2 $

Dvigatel rotorining maksimal burçak tezligi $omega_(m,"max")$ va tezlanişi $alpha_m$:

$ omega_(m,"max") = n dot omega_(L,"max") = 80 dot 1.9635 = 157.08 "rad/s" quad (n_m approx 1500 "rpm") $

$ alpha_m = n dot alpha_L = 80 dot 9.8175 = 785.4 "rad/s"^2 $

#heading(level: 3, numbering: none)[d) Dvigatel valiga keltirilgan momentlarni hisoblaş]

Tanlangan dvigatel rotorining inersiya momenti $I_m = 0.00015 "kg" dot "m"^2$ ($1.5 "kg" dot "cm"^2$) bölsin. Dvigatel valiga keltirilgan statik gravitatsion moment:

$ T_(m,g) = T_(g,"max") / (n dot eta_"red") = 52.974 / (80 dot 0.85) = 52.974 / 68 = 0.779 "Nm" $

Dvigatel valiga keltirilgan inersion dinamik moment:

$
  T_(m,"in") = (I_m + I_L / (n^2 dot eta_"red")) dot alpha_m
  = (0.00015 + 2.12 / (6400 dot 0.85)) dot 785.4
$

$ T_(m,"in") = (0.00015 + 0.0003897) dot 785.4 = 0.0005397 dot 785.4 = 0.424 "Nm" $

Harakat bosqiçlari böyiça dvigatel validagi töliq momentlar:

- *Tezlaniş bosqiçida ($t_a = 0.2 "s"$):*
  $ T_"acc" = T_(m,g) + T_(m,"in") = 0.779 + 0.424 = 1.203 "Nm" $
- *Barqaror harakat bosqiçida ($t_v = 0.6 "s"$):*
  $ T_"const" = T_(m,g) = 0.779 "Nm" $
- *Tormozlaniş bosqiçida ($t_d = 0.2 "s"$):*
  $ T_"dec" = T_(m,g) - T_(m,"in") = 0.779 - 0.424 = 0.355 "Nm" $

#heading(level: 3, numbering: none)[e) Örtaça kvadratik moment ($T_"rms"$) hisobi]

Dvigatelning issiqlik rejimiga çidamliligini baholaş uçun örtaça kvadratik moment $T_"rms"$ hisoblanadi:

$ T_"rms" = sqrt((T_"acc"^2 dot t_a + T_"const"^2 dot t_v + T_"dec"^2 dot t_d) / t_"sikl") $

$ T_"rms" = sqrt(((1.203)^2 dot 0.2 + (0.779)^2 dot 0.6 + (0.355)^2 dot 0.2) / 1.0) $

$ T_"rms" = sqrt(0.2894 + 0.3641 + 0.0252) = sqrt(0.6787) = 0.824 "Nm" $

= Natijalar va dvigatel tanlaş soliştirma jadvali

Ötkazilgan hisob-kitoblar natijasida robot böğini elektr yuritmasi uçun talab etiladigan nominal moment $T_"nom" >= 0.824 "Nm"$, maksimal pik moment $T_"peak" >= 1.203 "Nm"$ hamda nominal tezlik $n_m >= 1500 "rpm"$ ekanligi aniqlandi.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, auto),
      align: (left + horizon, center + horizon, center + horizon, center + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Parametr nomi*], [*Hisoblangan qiymat*], [*Tanlangan BLDC dvigatel*], [*Zaxira koeffitsienti*]),
      table.hline(stroke: 0.5pt),
      [Nominal moment ($T_"nom"$)], [$0.824 "Nm"$], [$1.10 "Nm"$], [$1.33$],
      [Maksimal pik moment ($T_"peak"$)], [$1.203 "Nm"$], [$3.30 "Nm"$], [$2.74$],
      [Nominal aylaniş tezligi ($n_m$)], [$1500 "rpm"$], [$3000 "rpm"$], [$2.00$],
      [Rotor inersiya momenti ($I_m$)], [$1.50 "kg" dot "cm"^2$], [$1.80 "kg" dot "cm"^2$], [---],
      [Dvigatel nominal quvvati ($P_"nom"$)], [$129.4 "W"$], [$345 "W"$], [$2.66$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot böğini elektr yuritmasining hisoblangan va katalogdan tanlangan körsatkiçlari],
)

= Hisobot mazmuni va nazorat savollari

== Hisobot mazmuni

+ Robot manipulyatorining berilgan kinematik sxemasi böyiça gravitatsion va inersion yuklama momentlarini hisoblaş.
+ Dvigatel valiga keltirilgan dinamik moment grafigini çiziş va $T_"rms"$ ni aniqlaş.
+ Katalogdan mos keluvçi BLDC servodvigatel hamda planetar reduktorni tanlaş.

== Nazorat savollari

+ Robot manipulyatori böğinlariga tuşadigan gravitatsion yuklama momenti $theta$ burçakka boğliq holda qanday özgaradi?
+ Inersiya moslaşuvi (_Inertia Matching_) nima va nima uçun $n^* = sqrt(I_L \/ I_m)$ şarti muhim hisoblanadi?
+ Örtaça kvadratik moment ($T_"rms"$) va maksimal pik moment ($T_"peak"$) dvigatel tanlaşda qanday rol öynaydi?
+ Şarikli-vintli uzatmalarda çiziqli kuç $F_"yuk"$ harakatlantiruvçi momentga qanday qayta hisoblanadi?
+ Reduktorning FIKi ($eta_"red"$) va ortga uzatiş qobiliyati (_back-drivability_) yuritma dinamikasiga qanday taʼsir qiladi?
