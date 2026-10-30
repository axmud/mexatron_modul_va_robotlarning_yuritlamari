// ============================================================
//  8-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_8.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robot ijro mexanizmining yuklama diagrammasini quriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 8  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №8]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Robot ijro mexanizmining yuklama diagrammasini quriş]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatronik tizimlar va sanoat robotlarini loyihalaş va hisoblaş)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

- Mexatron modullar va sanoat robotlarining ijro mexanizmlari hamda böğinlariga tuşadigan statik, dinamik va taşqi yuklamalarni tahlil qiliş könikmalarini şakllantiriş.
- Robot kinematik trayektoriyasi va trapetsiyasimon tezlik profili ($omega(t)$) böyiça böğindagi töliq yuklama momenti ($T_L (t)$) hamda quvvatining ($P_L (t)$) vaqtga boğliqlik *yuklama diagrammasini (Load Profile / Duty Cycle)* quriş.
- Qurilgan yuklama diagrammasi asosida elektr/gidravlik yuritmaning pik momenti ($T_"peak"$), örtaça kvadratik momenti ($T_"rms"$) va nominal quvvatini ($P_"nom"$) hisoblaş hamda yuritmani $T - omega$ xarakteristika tekisligida töğri tanlaş usullarini egallaş.

= Qisqaça nazariy maʼlumotlar va tizimli yondaşuv

Sanoat robotlari hamda mexatronik tizimlarni loyihalaşda eng masʼuliyatli va muhim bosqiçlardan biri bu ijro mexanizmining *yuklama diagrammasini (Load Diagram / Duty Cycle)* töğri qurişdir. R. Crowder (_Electric Drives and Electromechanical Systems_) taʼkidlaganidek, eng mukammal mikroprotsessorli boşqaruv va zamonaviy raqamli algoritmlar ham notöğri tanlangan yuritmani va yetarsiz dinamik quvvatni kompensatsiya qila olmaydi (_Systems Approach_).

== Robot manipulyatori dinamikasi va yuklama momenti

B. Siciliano va boşq. (_Robotics: Modelling, Planning and Control_) böyiça $n$-böğinli robot manipulyatorining dinamik tenglamasi Eyler–Lagranj (_Euler–Lagrange_) usulida quyidagiça ifodalanadi:

$ M(q) dot.double(q) + C(q, dot(q)) dot(q) + F_v dot(q) + F_s "sgn"(dot(q)) + g(q) = tau_"böğin" $

bunda:

- $M(q)$ --- manipulyator böğinlarining simmetrik musbat aniqlangan inersiya matritsasi;
- $C(q, dot(q)) dot(q)$ --- Koriolis va markazdan qoçma kuçlar momenti vektori;
- $F_v dot(q) + F_s "sgn"(dot(q))$ --- yopişqoq (_viscous_) va quruq (_Coulomb_) işqalaniş momentlari;
- $g(q)$ --- gravitatsiya (oğirlik kuçi) momentlari vektori;
- $tau_"böğin"$ --- böğinga keltirilgan töliq yuklama momenti vektori.

Bir erkinlik darajali robot böğini yoki alohida ijro mexanizmi uçun umumiy yuklama momenti $T_L (t)$ quyidagi törtta asosiy taşkil etuvçining yiğindisidan iborat böladi:

$ T_L (t) = T_"in" (t) + T_g (theta) + T_"frict" (dot(theta)) + T_"ext" (t) $

=== Dinamik inersiya momenti ($T_"in"$)

Harakatlanuvçi böğin va yukning tezlanişi natijasida yuzaga keladi:

$ T_"in" (t) = I_"tot" dot alpha(t) = I_"tot" dot (d omega) / (d t) $

bunda $I_"tot" = I_"böğin" + I_"yuk" + I_"red"$ --- böğinga keltirilgan töliq inersiya momenti, $alpha(t)$ --- burçak tezlanişi.

=== Gravitatsion yuklama momenti ($T_g$)

Böğin oğiş burçagi $theta(t)$ ga boğliq ravişda özgaruvçi oğirlik kuçi momenti:

$ T_g (theta) = (m_"böğin" dot r_c + m_"yuk" dot L) dot g dot cos(theta) $

bunda $r_c$ --- böğin oğirlik markazigaça masofa, $L$ --- böğin uzunligi, $g = 9.81 "m/s"^2$.

=== Işqalaniş momenti ($T_"frict"$)

Uzatma mexanizmi va podşipniklardagi quruq va yopişqoq işqalanişlar:

$ T_"frict" (omega) = T_c dot "sgn"(omega) + b dot omega $

=== Taşqi işçi kuçlar momenti ($T_"ext"$)

Robot uşlagiçi (gripper) orqali texnologik jarayonda bajariladigan taşqi kuçlar (payvandlaş, kesiş, bosiş) momenti.

== Kinematik profil va trapetsiyasimon tezlik grafigi

Yuklama diagrammasini quriş uçun avvalo robot böğinining harakat kinematikasi berilişi lozim. Sanoat robotlarida eng keng tarqalgan kinematik profil bu *trapetsiyasimon tezlik grafigi* hisoblanadi. U törtta davrdan iborat:

+ *Tezlaniş davri ($t_a$):* burçak tezligi $omega(t)$ 0 dan $omega_"max"$ gaça çiziqli ösadi ($alpha = alpha_"max"$).
+ *Barqaror harakat davri ($t_v$):* burçak tezligi özgarmas uşlab turiladi ($omega = omega_"max"$, $alpha = 0$).
+ *Tormozlaniş davri ($t_d$):* burçak tezligi $omega_"max"$ dan 0 gaça çiziqli kamayadi ($alpha = -alpha_"max"$).
+ *Pauza / uşlab turiş davri ($t_p$):* dvigatel töxtab turadi ($omega = 0$), lekin gravitatsion momentni uşlab turişi lozim.

Töliq sikl vaqti: $t_"sikl" = t_a + t_v + t_d + t_p$.

== Yuklama diagrammasi asosida yuritmani tanlaş mezonlari

Yuklama diagrammasi $T_L (t)$ qurilgaç, yuritma dvigateli quyidagi uçta kritik şart böyiça tekşiriladi:

+ *Pik moment şarti (Peak Torque Requirement):*
  $ T_"peak" = max_(0 <= t <= t_"sikl") |T_L (t)| <= T_"max, motor" $

+ *Örtaça kvadratik moment şarti (RMS Torque --- Thermal Limit):* dvigatel çulğamlarining ruxsat etilgan haroratdan oşib ketmasligini taʼminlovçi ekvivalent moment:
  $ T_"rms" = sqrt(1 / t_"sikl" integral_0^(t_"sikl") T_L^2 (t) dif t) <= T_"nom, motor" $
  Diskret şaklda (trapetsiyasimon bölaklar uçun):
  $ T_"rms" = sqrt((T_(a,"rms")^2 dot t_a + T_v^2 dot t_v + T_(d,"rms")^2 dot t_d + T_p^2 dot t_p) / t_"sikl") $

+ *$T - omega$ tekisligidagi işçi nuqtalar trayektoriyasi (Operating Point Trajectory):* yuklama diagrammasi nuqtalari dvigatelning $T - omega$ xarakteristikasidagi uzluksiz (_Continuous Duty Zone --- S1_) hamda vaqtinçalik (_Intermittent Zone --- S3_) zonalariga töliq tuşişi şart.

= Kerakli jihozlar va dasturiy vositalar

+ *Dasturiy vositalar:* MATLAB / Simulink (Simscape Multibody), Python (Matplotlib / NumPy) yoki C.W. de Silva metodikasi böyiça hisoblaş jadvallari.
+ *Ölçov va tajriba stendi:* sanoat roboti böğini, moment datçigi (_torque sensor_), LVDT va enkoderlar.

= Robot ijro mexanizmi va yuklama diagrammasi sxemalari

== Robot böğinining kinematik va kuç modeli

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *

    let small(body) = text(size: 7pt, weight: "bold", body)
    let arrow(col) = (end: "stealth", fill: col)
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

    // Gorizontal chiziq va θ burchagi
    line((0, 0), (4, 0), stroke: (thickness: 1pt, dash: "dashed"))
    arc((1.2, 0), start: 0deg, stop: 30deg, radius: 1.2, stroke: 1pt + headingblue, mark: arrow(headingblue))
    content((1.5, 0.3), text(size: 9pt, weight: "bold", fill: headingblue)[$theta(t)$])

    // Boʻgʻin va foydali yuk
    rrect(0, -0.15, 4, 0.15, fill: blue.lighten(85%), stroke: 1pt)
    rrect(3.7, -0.3, 4.3, 0.3, fill: orange.lighten(60%), stroke: 1pt)

    // Aylanish oʻqi
    circle((0, 0), radius: 0.4, fill: gray.lighten(70%), stroke: 1pt)
    circle((0, 0), radius: 0.08, fill: black, stroke: none)
    content((-0.2, -0.45), anchor: "north-east", text(size: 8pt, weight: "bold")[Böğin markazi (Joint 1)])

    // Massa markazi va ogʻirlik kuchi
    circle((1.732, 1.0), radius: 0.08, fill: red.darken(20%), stroke: none)
    line((1.732, 1.0), (1.732, -0.2), stroke: 2pt + red.darken(20%), mark: arrow(red.darken(20%)))
    content((1.8, -0.1), anchor: "west", small[$F_(g,"böğin") = m_1 g$])

    // Foydali yuk ogʻirlik kuchi
    content((3.4, 2.25), anchor: "south", small[Foydali yuk $m_L$])
    line((3.464, 2.0), (3.464, 0.6), stroke: 2pt + orange.darken(30%), mark: arrow(orange.darken(30%)))
    content((3.53, 0.7), anchor: "west", small[$F_(g,"yuk") = m_L g$])

    // Yuklama momenti
    let tc = green.darken(40%)
    arc((0.6, -0.5), start: -40deg, stop: 60deg, radius: 0.7, stroke: 2pt + tc, mark: arrow(tc))
    content((0.9, 0.75), text(size: 9pt, weight: "bold", fill: tc)[$T_L (t)$])
  }),
  caption: [Sanoat roboti böğinining kinematik hamda gravitatsion yuklama kuçi modeli],
)

== Yuklama diagrammasi profili ($omega(t), alpha(t), T_L (t)$)

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.8)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let blue-c = blue.darken(25%)
    let red-c = red.darken(20%)
    let grn-c = green.darken(45%)

    grid(
      (0, -2),
      (9, 4),
      step: 1,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    line((0, 0), (9.5, 0), stroke: 1pt, mark: arrow)
    line((0, -2.5), (0, 4.5), stroke: 1pt, mark: arrow)
    content((9.6, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$ (s)])
    content((0, 4.6), anchor: "south", text(size: 9pt, weight: "bold")[Amplituda ($omega, alpha, T_L$)])

    // Burchak tezligi ω(t)
    line((0, 0), (2, 2), (5, 2), (7, 0), (9, 0), stroke: 2pt + blue-c)
    content((3.5, 2.3), text(fill: blue-c, small[Burçak tezligi $omega(t)$]))

    // Tezlanish α(t)
    line((0, 1.2), (2, 1.2), (2, 0), (5, 0), (5, -1.2), (7, -1.2), (7, 0), (9, 0), stroke: (
      paint: red-c,
      thickness: 1pt,
      dash: "dashed",
    ))
    content((1.0, 1.5), text(fill: red-c, small[Tezlaniş $alpha(t)$]))

    // Yuklama momenti T_L(t) — cos θ taʼsirida barqaror davrda kamayadi
    line((0, 3.8), (2, 3.73), (2, 3.10), (5, 0.79), (5, 0.16), (7, -0.48), (7, 0.14), (9, 0.14), stroke: 2pt + grn-c)
    content((1.0, 4.1), text(fill: grn-c, text(size: 8pt, weight: "bold")[$T_L (t)$ (yuklama diagrammasi)]))

    // RMS chizigʻi
    line((0, 1.89), (9, 1.89), stroke: (paint: orange, thickness: 2pt, dash: "dotted"))
    content((8.0, 1.95), anchor: "south", text(fill: orange.darken(20%), small[$T_"rms"$ (RMS moment)]))

    // Vaqt belgilari
    for (x, lab) in ((0, $0$), (2, $t_a$), (5, $t_a + t_v$), (7, $t_a + t_v + t_d$), (9, $t_"sikl"$)) {
      content((x, -2.05), anchor: "north", small(lab))
    }
  }),
  caption: [Robot ijro mexanizmining töliq dinamik yuklama diagrammasi profili],
)

== Dvigatel $T - omega$ tekisligidagi işçi nuqtalar trayektoriyasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.9)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)

    // Uzluksiz zona (S1)
    line((0, 0), (0, 2.2), (3.5, 2.2), (4.8, 0), close: true, fill: green.lighten(85%), stroke: 1pt + green.darken(40%))
    content((2.6, 1.1), align(center, text(fill: green.darken(40%), small[
      Uzluksiz iş zonasi \ (Continuous Duty Zone --- S1)
    ])))

    // Vaqtinchalik zona (S3)
    line((0, 2.2), (0, 4.2), (2.5, 4.2), (3.5, 2.2), close: true, fill: orange.lighten(90%), stroke: (
      paint: orange.darken(20%),
      thickness: 1pt,
      dash: "dashed",
    ))
    content((1.3, 3.75), align(center, text(fill: orange.darken(20%), small[
      Vaqtinçalik pik zonasi \ (Intermittent Zone --- S3)
    ])))

    // Oʻqlar
    line((0, -1.0), (0, 5.0), stroke: 1pt, mark: arrow)
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Burçak tezligi $omega$ (rad/s)])
    content((0, 5.1), anchor: "south", text(size: 9pt, weight: "bold")[Moment $T$ (Nm)])

    // Ishchi trayektoriya: pauza → tezlanish → barqaror → tormozlanish → pauza
    let rc = red.darken(10%)
    line((0, 0.12), (0, 3.2), (1.8, 3.2), (1.8, 1.9), (1.8, 0.16), (0, -0.45), (0, 0.12), stroke: 1.2pt + rc, mark: (
      end: "stealth",
      fill: rc,
    ))
    for p in ((0, 0.12), (1.8, 3.2), (1.8, 1.9), (0, -0.45)) {
      circle(p, radius: 0.07, fill: rc, stroke: none)
    }
    content((0.1, 0.3), anchor: "west", text(fill: rc, small[1: $T_"hold"$ (pauza)]))
    content((1.9, 3.3), anchor: "south-west", text(fill: rc, small[2: $T_"acc, max"$ (tezlaniş)]))
    content((1.9, 1.9), anchor: "west", text(fill: rc, small[3: $T_"const"$ (barqaror)]))
    content((0.15, -0.55), anchor: "north-west", text(fill: rc, small[4: $T_"dec"$ (tormozlaniş)]))
  }),
  caption: [Yuklama diagrammasining dvigatel $T - omega$ xarakteristikasidagi işçi trayektoriyasi],
)

= Tajribani bajariş va hisoblaş ketma-ketligi

Yuklama diagrammasini quriş va yuritma quvvatini hisoblaş quyidagi tartibda amalga oşiriladi:

+ *Boşlanğiç maʼlumotlarni yiğiş:* böğin massasi $m_1$, uzunligi $L$, oğirlik markazi $r_c$, foydali yuk massasi $m_L$, buriliş burçagi $theta_"max"$ va harakat vaqti $t_"sikl"$.

+ *Kinematik hisob:* trapetsiyasimon profil uçun $t_a, t_v, t_d$ vaqtlari böyiça maksimal burçak tezligi $omega_"max"$ va tezlaniş $alpha_"max"$ ni aniqlaş:
  $ omega_"max" = theta_"max" / (t_v + (t_a + t_d) \/ 2), quad alpha_"max" = omega_"max" / t_a $

+ *Statik va dinamik momentlarni bölaklar böyiça hisoblaş:*
  - *Tezlaniş davri ($0 <= t <= t_a$):*
    $ T_a (t) = I_"tot" dot alpha_"max" + (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Barqaror harakat davri ($t_a <= t <= t_a + t_v$):*
    $ T_v (t) = (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Tormozlaniş davri ($t_a + t_v <= t <= t_a + t_v + t_d$):*
    $ T_d (t) = -I_"tot" dot alpha_"max" + (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Pauza davri ($t_a + t_v + t_d <= t <= t_"sikl"$):*
    $ T_p = (m_1 r_c + m_L L) g cos(theta_"max") $

+ *Yuklama diagrammasini ($T_L (t)$ va $P_L (t) = T_L (t) dot omega(t)$) grafik körinişda quriş.*

+ *$T_"peak"$ va $T_"rms"$ körsatkiçlarini hisoblab, katalogdan yuritma dvigateli va reduktorni tanlaş.*

= Amaliy hisoblaş misoli (sanoat roboti böğini)

== Boşlanğiç maʼlumotlar

Sanoat roboti 2-böğini vertikal tekislikda $theta = 0 degree$ (gorizontal) dan $theta = 90 degree$ (vertikal) gaça buriladi.

- Böğin massasi: $m_1 = 10.0 "kg"$, uzunligi: $L = 0.5 "m"$, oğirlik markazi: $r_c = 0.25 "m"$.
- Böğinning aylaniş öqiga nisbatan inersiya momenti (bir uçidan aylanuvçi sterjen): $I_"böğin" = 1/3 m_1 L^2 = 1/3 dot 10.0 dot 0.5^2 = 0.8333 "kg" dot "m"^2$.
- Foydali yuk massasi: $m_L = 6.0 "kg"$ ($I_"yuk" = m_L L^2 = 1.500 "kg" dot "m"^2$).
- Töliq inersiya momenti: $I_"tot" = 0.8333 + 1.500 = 2.3333 "kg" dot "m"^2$.
- Buriliş burçagi: $theta_"max" = 90 degree = 1.5708 "rad"$.
- Sikl vaqtlari: $t_a = 0.3 "s"$, $t_v = 0.8 "s"$, $t_d = 0.3 "s"$, $t_p = 1.0 "s"$ ($t_"sikl" = 2.4 "s"$).
- Reduktor uzatiş nisbati: $n = 50$, FIK: $eta_"red" = 0.85$. Işqalaniş momenti: $T_"frict" = 2.5 "Nm"$.

== Kinematik va momentlar hisobi

Maksimal burçak tezligi va tezlanişi:

$ omega_"max" = 1.5708 / (0.8 + (0.3 + 0.3) \/ 2) = 1.5708 / 1.1 = 1.428 "rad/s" quad (n_L = 13.64 "rpm") $

$ alpha_"max" = 1.428 / 0.3 = 4.760 "rad/s"^2 $

Böğin validagi momentlar:

- Maksimal gravitatsion moment ($theta = 0 degree$):
  $ T_(g,"max") = (10.0 dot 0.25 + 6.0 dot 0.5) dot 9.81 = (2.5 + 3.0) dot 9.81 = 53.955 "Nm" $
- Dinamik inersiya momenti:
  $ T_"in" = I_"tot" dot alpha_"max" = 2.3333 dot 4.760 = 11.107 "Nm" $

Dvigatel validagi momentlar ($T_m = T_L \/ (n dot eta_"red")$):

+ *Tezlaniş davri ($t_a = 0.3 "s"$):*
  $ T_"acc, max" = (11.107 + 53.955 + 2.5) / (50 dot 0.85) = 67.562 / 42.5 = 1.590 "Nm" $
+ *Barqaror harakat davri ($t_v = 0.8 "s"$ --- örtaça $theta = 45 degree$, $cos 45 degree = 0.707$):*
  $ T_"const" = (53.955 dot 0.707 + 2.5) / 42.5 = (38.146 + 2.5) / 42.5 = 0.956 "Nm" $
+ *Tormozlaniş davri ($t_d = 0.3 "s"$ --- $theta approx 80 degree$, $cos 80 degree = 0.174$):*
  $ T_"dec" = (-11.107 + 53.955 dot 0.174 + 2.5) / 42.5 = \ (-11.107 + 9.388 + 2.5) / 42.5 = 0.018 "Nm" $
+ *Pauza davri ($t_p = 1.0 "s"$ --- vertikal holat $theta = 90 degree$, $cos 90 degree = 0$):*
  $ T_"hold" = (0 + 2.5) / 42.5 = 0.059 "Nm" $

== RMS moment va dvigatel tanlaş

Örtaça kvadratik moment (RMS):

$ T_"rms" = sqrt(((1.590)^2 dot 0.3 + (0.956)^2 dot 0.8 + (0.018)^2 dot 0.3 + (0.059)^2 dot 1.0) / 2.4) $

$ T_"rms" = sqrt((0.7584 + 0.7311 + 0.0001 + 0.0035) / 2.4) = \ sqrt(1.4931 / 2.4) = sqrt(0.6221) = 0.789 "Nm" $

Maksimal dvigatel tezligi:

$ n_m = n dot n_L = 50 dot 13.64 = 682 "rpm" quad (omega_m = 71.4 "rad/s") $

Maksimal pik quvvat:

$ P_"peak" = T_"acc, max" dot omega_m = 1.590 dot 71.4 = 113.5 "W" $

= Hisoblaş natijalari va soliştirma jadvallar

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, auto, 1fr, 1fr, 1fr),
      align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Harakat davri*],
        [*Vaqt* \ *$t$ (s)*],
        [*Tezlik* \ *$omega_m$ (rad/s)*],
        [*Böğin momenti (Nm)*],
        [*Dvigatel momenti (Nm)*],
      ),
      table.hline(stroke: 0.5pt),
      [Tezlaniş ($t_a$)], [0.3], [$0 -> 71.4$], [67.56], [1.590 ($T_"peak"$)],
      [Barqaror ($t_v$)], [0.8], [71.4], [40.65], [0.956],
      [Tormozlaniş ($t_d$)], [0.3], [$71.4 -> 0$], [0.78], [0.018],
      [Pauza ($t_p$)], [1.0], [0], [2.50], [0.059],
      table.hline(stroke: 0.5pt),
      [*Sikl körsatkiçlari*],
      [*$t_"sikl" = 2.4 "s"$*],
      [*$n_"max" = 682 "rpm"$*],
      [*$T_"rms" = 0.789 "Nm"$*],
      [*$P_"peak" = 113.5 "W"$*],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot ijro mexanizmining yuklama diagrammasi hisoblaş körsatkiçlari],
)

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
      table.header([*Parametr*], [*Hisoblangan qiymat*], [*Tanlangan dvigatel*], [*Zaxira koeffitsienti ($K_z$)*]),
      table.hline(stroke: 0.5pt),
      [Nominal moment ($T_"nom"$)], [0.789 Nm], [1.10 Nm], [1.39 (39% zaxira)],
      [Pik moment ($T_"peak"$)], [1.590 Nm], [3.30 Nm], [2.08 (108% zaxira)],
      [Nominal tezlik ($n_"nom"$)], [682 rpm], [3000 rpm], [4.40 (tezlik zaxirasi)],
      [Quvvat ($P_"peak"$ / $P_"nom"$)], [113.5 W], [350 W], [3.08 (quvvat zaxirasi)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Katalogdan tanlangan BLDC servodvigatel xarakteristikalari va zaxira körsatkiçlari],
)

= Hisobot mazmuni va xulosalar

+ Robot ijro mexanizmining töliq kinematik va dinamik tenglamalari asosida $T_L (t)$ hamda $P_L (t)$ yuklama diagrammalari çizildi.
+ Trapetsiyasimon tezlik profilida tezlaniş davri $t_a$ va gravitatsion moment $T_g (theta)$ pik momentni belgilaşi körsatildi.
+ Hisoblangan $T_"rms" = 0.789 "Nm"$ va $T_"peak" = 1.590 "Nm"$ körsatkiçlari böyiça tanlangan 350 W BLDC servodvigateli issiqlik hamda dinamik qayta yuklaniş rejimlarida töliq xavfsiz işlaşi tasdiqlandi.

= Nazorat savollari

+ Robot ijro mexanizmining yuklama diagrammasi deb nimaga aytiladi va u qanday asosiy bölimlardan taşkil topadi?
+ Yuklama diagrammasida inersiya momenti ($T_"in"$) va gravitatsion moment ($T_g$) vaqt böyiça qanday özgaradi?
+ Nima uçun dvigatel nominal quvvatini tanlaşda örtaça kvadratik moment ($T_"rms"$) körsatkiçidan foydalaniladi?
+ Dvigatelning moment–tezlik ($T - omega$) xarakteristikasidagi S1 (uzluksiz) va S3 (vaqtinçalik) zonalarining farqi nimada?
+ Inersiya moslaşuvi (_Inertia Matching_) şarti ($n^* = sqrt(I_L \/ I_m)$) yuklama diagrammasiga qanday taʼsir körsatadi?
