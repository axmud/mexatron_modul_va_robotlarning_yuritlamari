// ============================================================
//  8-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_8.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robot ijro mexanizmining yuklama diagrammasini qurish")
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
#set text(size: 12pt, lang: "uz")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №8]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Robot ijro mexanizmining yuklama diagrammasini qurish]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatronik tizimlar va sanoat robotlarini loyihalash va hisoblash)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

- Mexatron modullar va sanoat robotlarining ijro mexanizmlari hamda boʻgʻinlariga tushadigan statik, dinamik va tashqi yuklamalarni tahlil qilish koʻnikmalarini shakllantirish.
- Robot kinematik trayektoriyasi va trapetsiyasimon tezlik profili ($omega(t)$) boʻyicha boʻgʻindagi toʻliq yuklama momenti ($T_L (t)$) hamda quvvatining ($P_L (t)$) vaqtga bogʻliqlik *yuklama diagrammasini (Load Profile / Duty Cycle)* qurish.
- Qurilgan yuklama diagrammasi asosida elektr/gidravlik yuritmaning pik momenti ($T_"peak"$), oʻrtacha kvadratik momenti ($T_"rms"$) va nominal quvvatini ($P_"nom"$) hisoblash hamda yuritmani $T - omega$ xarakteristika tekisligida toʻgʻri tanlash usullarini egallash.

= Qisqacha nazariy maʼlumotlar va tizimli yondashuv

Sanoat robotlari hamda mexatronik tizimlarni loyihalashda eng masʼuliyatli va muhim bosqichlardan biri bu ijro mexanizmining *yuklama diagrammasini (Load Diagram / Duty Cycle)* toʻgʻri qurishdir. R. Crowder (_Electric Drives and Electromechanical Systems_) taʼkidlaganidek, eng mukammal mikroprotsessorli boshqaruv va zamonaviy raqamli algoritmlar ham notoʻgʻri tanlangan yuritmani va yetarsiz dinamik quvvatni kompensatsiya qila olmaydi (_Systems Approach_).

== Robot manipulyatori dinamikasi va yuklama momenti

B. Siciliano va boshq. (_Robotics: Modelling, Planning and Control_) boʻyicha $n$-boʻgʻinli robot manipulyatorining dinamik tenglamasi Eyler–Lagranj (_Euler–Lagrange_) usulida quyidagicha ifodalanadi:

$ M(q) dot.double(q) + C(q, dot(q)) dot(q) + F_v dot(q) + F_s "sgn"(dot(q)) + g(q) = tau_"boʻgʻin" $

bunda:

- $M(q)$ --- manipulyator boʻgʻinlarining simmetrik musbat aniqlangan inersiya matritsasi;
- $C(q, dot(q)) dot(q)$ --- Koriolis va markazdan qochma kuchlar momenti vektori;
- $F_v dot(q) + F_s "sgn"(dot(q))$ --- yopishqoq (_viscous_) va quruq (_Coulomb_) ishqalanish momentlari;
- $g(q)$ --- gravitatsiya (ogʻirlik kuchi) momentlari vektori;
- $tau_"boʻgʻin"$ --- boʻgʻinga keltirilgan toʻliq yuklama momenti vektori.

Bir erkinlik darajali robot boʻgʻini yoki alohida ijro mexanizmi uchun umumiy yuklama momenti $T_L (t)$ quyidagi toʻrtta asosiy tashkil etuvchining yigʻindisidan iborat boʻladi:

$ T_L (t) = T_"in" (t) + T_g (theta) + T_"frict" (dot(theta)) + T_"ext" (t) $

=== Dinamik inersiya momenti ($T_"in"$)

Harakatlanuvchi boʻgʻin va yukning tezlanishi natijasida yuzaga keladi:

$ T_"in" (t) = I_"tot" dot alpha(t) = I_"tot" dot (d omega) / (d t) $

bunda $I_"tot" = I_"boʻgʻin" + I_"yuk" + I_"red"$ --- boʻgʻinga keltirilgan toʻliq inersiya momenti, $alpha(t)$ --- burchak tezlanishi.

=== Gravitatsion yuklama momenti ($T_g$)

Boʻgʻin ogʻish burchagi $theta(t)$ ga bogʻliq ravishda oʻzgaruvchi ogʻirlik kuchi momenti:

$ T_g (theta) = (m_"boʻgʻin" dot r_c + m_"yuk" dot L) dot g dot cos(theta) $

bunda $r_c$ --- boʻgʻin ogʻirlik markazigacha masofa, $L$ --- boʻgʻin uzunligi, $g = 9.81 "m/s"^2$.

=== Ishqalanish momenti ($T_"frict"$)

Uzatma mexanizmi va podshipniklardagi quruq va yopishqoq ishqalanishlar:

$ T_"frict" (omega) = T_c dot "sgn"(omega) + b dot omega $

=== Tashqi ishchi kuchlar momenti ($T_"ext"$)

Robot ushlagichi (gripper) orqali texnologik jarayonda bajariladigan tashqi kuchlar (payvandlash, kesish, bosish) momenti.

== Kinematik profil va trapetsiyasimon tezlik grafigi

Yuklama diagrammasini qurish uchun avvalo robot boʻgʻinining harakat kinematikasi berilishi lozim. Sanoat robotlarida eng keng tarqalgan kinematik profil bu *trapetsiyasimon tezlik grafigi* hisoblanadi. U toʻrtta davrdan iborat:

+ *Tezlanish davri ($t_a$):* burchak tezligi $omega(t)$ 0 dan $omega_"max"$ gacha chiziqli oʻsadi ($alpha = alpha_"max"$).
+ *Barqaror harakat davri ($t_v$):* burchak tezligi oʻzgarmas ushlab turiladi ($omega = omega_"max"$, $alpha = 0$).
+ *Tormozlanish davri ($t_d$):* burchak tezligi $omega_"max"$ dan 0 gacha chiziqli kamayadi ($alpha = -alpha_"max"$).
+ *Pauza / ushlab turish davri ($t_p$):* dvigatel toʻxtab turadi ($omega = 0$), lekin gravitatsion momentni ushlab turishi lozim.

Toʻliq sikl vaqti: $t_"sikl" = t_a + t_v + t_d + t_p$.

== Yuklama diagrammasi asosida yuritmani tanlash mezonlari

Yuklama diagrammasi $T_L (t)$ qurilgach, yuritma dvigateli quyidagi uchta kritik shart boʻyicha tekshiriladi:

+ *Pik moment sharti (Peak Torque Requirement):*
  $ T_"peak" = max_(0 <= t <= t_"sikl") |T_L (t)| <= T_"max, motor" $

+ *Oʻrtacha kvadratik moment sharti (RMS Torque --- Thermal Limit):* dvigatel chulgʻamlarining ruxsat etilgan haroratdan oshib ketmasligini taʼminlovchi ekvivalent moment:
  $ T_"rms" = sqrt(1 / t_"sikl" integral_0^(t_"sikl") T_L^2 (t) dif t) <= T_"nom, motor" $
  Diskret shaklda (trapetsiyasimon boʻlaklar uchun):
  $ T_"rms" = sqrt((T_(a,"rms")^2 dot t_a + T_v^2 dot t_v + T_(d,"rms")^2 dot t_d + T_p^2 dot t_p) / t_"sikl") $

+ *$T - omega$ tekisligidagi ishchi nuqtalar trayektoriyasi (Operating Point Trajectory):* yuklama diagrammasi nuqtalari dvigatelning $T - omega$ xarakteristikasidagi uzluksiz (_Continuous Duty Zone --- S1_) hamda vaqtinchalik (_Intermittent Zone --- S3_) zonalariga toʻliq tushishi shart.

= Kerakli jihozlar va dasturiy vositalar

+ *Dasturiy vositalar:* MATLAB / Simulink (Simscape Multibody), Python (Matplotlib / NumPy) yoki C.W. de Silva metodikasi boʻyicha hisoblash jadvallari.
+ *Oʻlchov va tajriba stendi:* sanoat roboti boʻgʻini, moment datchigi (_torque sensor_), LVDT va enkoderlar.

= Robot ijro mexanizmi va yuklama diagrammasi sxemalari

== Robot boʻgʻinining kinematik va kuch modeli

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
    content((-0.2, -0.45), anchor: "north-east", text(size: 8pt, weight: "bold")[Boʻgʻin markazi (Joint 1)])

    // Massa markazi va ogʻirlik kuchi
    circle((1.732, 1.0), radius: 0.08, fill: red.darken(20%), stroke: none)
    line((1.732, 1.0), (1.732, -0.2), stroke: 2pt + red.darken(20%), mark: arrow(red.darken(20%)))
    content((1.8, -0.1), anchor: "west", small[$F_(g,"boʻgʻin") = m_1 g$])

    // Foydali yuk ogʻirlik kuchi
    content((3.4, 2.25), anchor: "south", small[Foydali yuk $m_L$])
    line((3.464, 2.0), (3.464, 0.6), stroke: 2pt + orange.darken(30%), mark: arrow(orange.darken(30%)))
    content((3.53, 0.7), anchor: "west", small[$F_(g,"yuk") = m_L g$])

    // Yuklama momenti
    let tc = green.darken(40%)
    arc((0.6, -0.5), start: -40deg, stop: 60deg, radius: 0.7, stroke: 2pt + tc, mark: arrow(tc))
    content((0.9, 0.75), text(size: 9pt, weight: "bold", fill: tc)[$T_L (t)$])
  }),
  caption: [Sanoat roboti boʻgʻinining kinematik hamda gravitatsion yuklama kuchi modeli],
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
    content((3.5, 2.3), text(fill: blue-c, small[Burchak tezligi $omega(t)$]))

    // Tezlanish α(t)
    line((0, 1.2), (2, 1.2), (2, 0), (5, 0), (5, -1.2), (7, -1.2), (7, 0), (9, 0), stroke: (
      paint: red-c,
      thickness: 1pt,
      dash: "dashed",
    ))
    content((1.0, 1.5), text(fill: red-c, small[Tezlanish $alpha(t)$]))

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
  caption: [Robot ijro mexanizmining toʻliq dinamik yuklama diagrammasi profili],
)

== Dvigatel $T - omega$ tekisligidagi ishchi nuqtalar trayektoriyasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.9)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)

    // Uzluksiz zona (S1)
    line((0, 0), (0, 2.2), (3.5, 2.2), (4.8, 0), close: true, fill: green.lighten(85%), stroke: 1pt + green.darken(40%))
    content((2.6, 1.1), align(center, text(fill: green.darken(40%), small[
      Uzluksiz ish zonasi \ (Continuous Duty Zone --- S1)
    ])))

    // Vaqtinchalik zona (S3)
    line((0, 2.2), (0, 4.2), (2.5, 4.2), (3.5, 2.2), close: true, fill: orange.lighten(90%), stroke: (
      paint: orange.darken(20%),
      thickness: 1pt,
      dash: "dashed",
    ))
    content((1.3, 3.75), align(center, text(fill: orange.darken(20%), small[
      Vaqtinchalik pik zonasi \ (Intermittent Zone --- S3)
    ])))

    // Oʻqlar
    line((0, -1.0), (0, 5.0), stroke: 1pt, mark: arrow)
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Burchak tezligi $omega$ (rad/s)])
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
    content((1.9, 3.3), anchor: "south-west", text(fill: rc, small[2: $T_"acc, max"$ (tezlanish)]))
    content((1.9, 1.9), anchor: "west", text(fill: rc, small[3: $T_"const"$ (barqaror)]))
    content((0.15, -0.55), anchor: "north-west", text(fill: rc, small[4: $T_"dec"$ (tormozlanish)]))
  }),
  caption: [Yuklama diagrammasining dvigatel $T - omega$ xarakteristikasidagi ishchi trayektoriyasi],
)

= Tajribani bajarish va hisoblash ketma-ketligi

Yuklama diagrammasini qurish va yuritma quvvatini hisoblash quyidagi tartibda amalga oshiriladi:

+ *Boshlangʻich maʼlumotlarni yigʻish:* boʻgʻin massasi $m_1$, uzunligi $L$, ogʻirlik markazi $r_c$, foydali yuk massasi $m_L$, burilish burchagi $theta_"max"$ va harakat vaqti $t_"sikl"$.

+ *Kinematik hisob:* trapetsiyasimon profil uchun $t_a, t_v, t_d$ vaqtlari boʻyicha maksimal burchak tezligi $omega_"max"$ va tezlanish $alpha_"max"$ ni aniqlash:
  $ omega_"max" = theta_"max" / (t_v + (t_a + t_d) \/ 2), quad alpha_"max" = omega_"max" / t_a $

+ *Statik va dinamik momentlarni boʻlaklar boʻyicha hisoblash:*
  - *Tezlanish davri ($0 <= t <= t_a$):*
    $ T_a (t) = I_"tot" dot alpha_"max" + (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Barqaror harakat davri ($t_a <= t <= t_a + t_v$):*
    $ T_v (t) = (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Tormozlanish davri ($t_a + t_v <= t <= t_a + t_v + t_d$):*
    $ T_d (t) = -I_"tot" dot alpha_"max" + (m_1 r_c + m_L L) g cos(theta(t)) + T_"frict" $
  - *Pauza davri ($t_a + t_v + t_d <= t <= t_"sikl"$):*
    $ T_p = (m_1 r_c + m_L L) g cos(theta_"max") $

+ *Yuklama diagrammasini ($T_L (t)$ va $P_L (t) = T_L (t) dot omega(t)$) grafik koʻrinishda qurish.*

+ *$T_"peak"$ va $T_"rms"$ koʻrsatkichlarini hisoblab, katalogdan yuritma dvigateli va reduktorni tanlash.*

= Amaliy hisoblash misoli (sanoat roboti boʻgʻini)

== Boshlangʻich maʼlumotlar

Sanoat roboti 2-boʻgʻini vertikal tekislikda $theta = 0 degree$ (gorizontal) dan $theta = 90 degree$ (vertikal) gacha buriladi.

- Boʻgʻin massasi: $m_1 = 10.0 "kg"$, uzunligi: $L = 0.5 "m"$, ogʻirlik markazi: $r_c = 0.25 "m"$.
- Boʻgʻinning aylanish oʻqiga nisbatan inersiya momenti (bir uchidan aylanuvchi sterjen): $I_"boʻgʻin" = 1/3 m_1 L^2 = 1/3 dot 10.0 dot 0.5^2 = 0.8333 "kg" dot "m"^2$.
- Foydali yuk massasi: $m_L = 6.0 "kg"$ ($I_"yuk" = m_L L^2 = 1.500 "kg" dot "m"^2$).
- Toʻliq inersiya momenti: $I_"tot" = 0.8333 + 1.500 = 2.3333 "kg" dot "m"^2$.
- Burilish burchagi: $theta_"max" = 90 degree = 1.5708 "rad"$.
- Sikl vaqtlari: $t_a = 0.3 "s"$, $t_v = 0.8 "s"$, $t_d = 0.3 "s"$, $t_p = 1.0 "s"$ ($t_"sikl" = 2.4 "s"$).
- Reduktor uzatish nisbati: $n = 50$, FIK: $eta_"red" = 0.85$. Ishqalanish momenti: $T_"frict" = 2.5 "Nm"$.

== Kinematik va momentlar hisobi

Maksimal burchak tezligi va tezlanishi:

$ omega_"max" = 1.5708 / (0.8 + (0.3 + 0.3) \/ 2) = 1.5708 / 1.1 = 1.428 "rad/s" quad (n_L = 13.64 "rpm") $

$ alpha_"max" = 1.428 / 0.3 = 4.760 "rad/s"^2 $

Boʻgʻin validagi momentlar:

- Maksimal gravitatsion moment ($theta = 0 degree$):
  $ T_(g,"max") = (10.0 dot 0.25 + 6.0 dot 0.5) dot 9.81 = (2.5 + 3.0) dot 9.81 = 53.955 "Nm" $
- Dinamik inersiya momenti:
  $ T_"in" = I_"tot" dot alpha_"max" = 2.3333 dot 4.760 = 11.107 "Nm" $

Dvigatel validagi momentlar ($T_m = T_L \/ (n dot eta_"red")$):

+ *Tezlanish davri ($t_a = 0.3 "s"$):*
  $ T_"acc, max" = (11.107 + 53.955 + 2.5) / (50 dot 0.85) = 67.562 / 42.5 = 1.590 "Nm" $
+ *Barqaror harakat davri ($t_v = 0.8 "s"$ --- oʻrtacha $theta = 45 degree$, $cos 45 degree = 0.707$):*
  $ T_"const" = (53.955 dot 0.707 + 2.5) / 42.5 = (38.146 + 2.5) / 42.5 = 0.956 "Nm" $
+ *Tormozlanish davri ($t_d = 0.3 "s"$ --- $theta approx 80 degree$, $cos 80 degree = 0.174$):*
  $ T_"dec" = (-11.107 + 53.955 dot 0.174 + 2.5) / 42.5 = \ (-11.107 + 9.388 + 2.5) / 42.5 = 0.018 "Nm" $
+ *Pauza davri ($t_p = 1.0 "s"$ --- vertikal holat $theta = 90 degree$, $cos 90 degree = 0$):*
  $ T_"hold" = (0 + 2.5) / 42.5 = 0.059 "Nm" $

== RMS moment va dvigatel tanlash

Oʻrtacha kvadratik moment (RMS):

$ T_"rms" = sqrt(((1.590)^2 dot 0.3 + (0.956)^2 dot 0.8 + (0.018)^2 dot 0.3 + (0.059)^2 dot 1.0) / 2.4) $

$ T_"rms" = sqrt((0.7584 + 0.7311 + 0.0001 + 0.0035) / 2.4) = \ sqrt(1.4931 / 2.4) = sqrt(0.6221) = 0.789 "Nm" $

Maksimal dvigatel tezligi:

$ n_m = n dot n_L = 50 dot 13.64 = 682 "rpm" quad (omega_m = 71.4 "rad/s") $

Maksimal pik quvvat:

$ P_"peak" = T_"acc, max" dot omega_m = 1.590 dot 71.4 = 113.5 "W" $

= Hisoblash natijalari va solishtirma jadvallar

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
        [*Boʻgʻin momenti (Nm)*],
        [*Dvigatel momenti (Nm)*],
      ),
      table.hline(stroke: 0.5pt),
      [Tezlanish ($t_a$)], [0.3], [$0 -> 71.4$], [67.56], [1.590 ($T_"peak"$)],
      [Barqaror ($t_v$)], [0.8], [71.4], [40.65], [0.956],
      [Tormozlanish ($t_d$)], [0.3], [$71.4 -> 0$], [0.78], [0.018],
      [Pauza ($t_p$)], [1.0], [0], [2.50], [0.059],
      table.hline(stroke: 0.5pt),
      [*Sikl koʻrsatkichlari*],
      [*$t_"sikl" = 2.4 "s"$*],
      [*$n_"max" = 682 "rpm"$*],
      [*$T_"rms" = 0.789 "Nm"$*],
      [*$P_"peak" = 113.5 "W"$*],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot ijro mexanizmining yuklama diagrammasi hisoblash koʻrsatkichlari],
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
  caption: [Katalogdan tanlangan BLDC servodvigatel xarakteristikalari va zaxira koʻrsatkichlari],
)

= Hisobot mazmuni va xulosalar

+ Robot ijro mexanizmining toʻliq kinematik va dinamik tenglamalari asosida $T_L (t)$ hamda $P_L (t)$ yuklama diagrammalari chizildi.
+ Trapetsiyasimon tezlik profilida tezlanish davri $t_a$ va gravitatsion moment $T_g (theta)$ pik momentni belgilashi koʻrsatildi.
+ Hisoblangan $T_"rms" = 0.789 "Nm"$ va $T_"peak" = 1.590 "Nm"$ koʻrsatkichlari boʻyicha tanlangan 350 W BLDC servodvigateli issiqlik hamda dinamik qayta yuklanish rejimlarida toʻliq xavfsiz ishlashi tasdiqlandi.

= Nazorat savollari

+ Robot ijro mexanizmining yuklama diagrammasi deb nimaga aytiladi va u qanday asosiy boʻlimlardan tashkil topadi?
+ Yuklama diagrammasida inersiya momenti ($T_"in"$) va gravitatsion moment ($T_g$) vaqt boʻyicha qanday oʻzgaradi?
+ Nima uchun dvigatel nominal quvvatini tanlashda oʻrtacha kvadratik moment ($T_"rms"$) koʻrsatkichidan foydalaniladi?
+ Dvigatelning moment–tezlik ($T - omega$) xarakteristikasidagi S1 (uzluksiz) va S3 (vaqtinchalik) zonalarining farqi nimada?
+ Inersiya moslashuvi (_Inertia Matching_) sharti ($n^* = sqrt(I_L \/ I_m)$) yuklama diagrammasiga qanday taʼsir koʻrsatadi?
