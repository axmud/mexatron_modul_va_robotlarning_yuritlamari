// ============================================================
//  1-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_1.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(
  title: "Mexatron modullar va robotlarning yuritmalariga qöyiladigan talablarni aniqlaş",
)
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 1  // amaliyot raqami
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
#set math.equation(numbering: "(1)")
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №1]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: Mexatron modullar va robotlarning yuritmalariga qöyiladigan talablarni aniqlaş
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

- Mexatronik tizimlar va sanoat robotlarining ijro organlarida qöllaniladigan elektr, gidravlik hamda pnevmatik yuritmalar va ularga qöyiladigan asosiy texnik, kinetik va dinamik talablarni tahlil qiliş.
- Yuritmalarning quvvat ziçligi, tezkorligi, ötiş jarayonlari, moment tebranişlari va pozitsiyalaş aniqligini baholaş mezonlarini örganiş.
- Berilgan yuklama va tezlik grafiklari asosida dvigatel hamda uzatiş mexanizmi parametrlarini maqbullaştiriş (_motor-drive sizing_) könikmalarini şakllantiriş.

= Qisqaça nazariy maʼlumotlar va tizimli yondaşuv

Mexatron modullar va robotlarda yuritma tizimi (_actuation system_) axborot-boşqaruv signallarini mexanik harakat hamda foydali kuç/momentga aylantirib beruvçi asosiy energetik böğin hisoblanadi. Zamonaviy mexatronikada yuritmaga nisbatan *tizimli yondaşuv (Systems Approach)* qöllaniladi: yuritma faqat dvigatelning özidan emas, balki quvvat özgartirgiçi (drayver), uzatiş mexanizmi (reduktor), datçiklar va qayta aloqali boşqaruv algoritmidan iborat yagona yaxlit kompleks sifatida qaraladi.

== Yuritmalarga qöyiladigan asosiy texnik va dinamik talablar

Sanoat robotlari va mexatronik qurilmalarda yuritmalarga quyidagi asosiy talablar qöyiladi:

+ *Yuqori quvvat va moment ziçligi (Power-to-Weight Ratio & Torque Density):* robot böğinlarida massani kamaytiriş uçun minimal ölçam va oğirlikda maksimal moment ($T$) hamda quvvat ($P$) beriş talab etiladi.
+ *Yuqori tezkorlik va keng ötkaziş polosasi (High Bandwidth):* yuritma kiriş signalidagi özgarişlarga tezkor javob berişi hamda kiçik elektromexanik vaqt doimiyligiga ($tau_e, tau_m$) ega bölişi kerak.
+ *Tört kvadrantli reversiv harakat (4-Quadrant Operation):* dvigatel har ikki yönalişda tezlaniş, özgarmas tezlik hamda rekuperativ tormozlaniş rejimlarida barqaror işlaşi lozim.
+ *Yuqori pozitsiyalaş aniqligi va kiçik lyuft (Low Backlash):* yuqori aniqlikdagi reduktorlar (Harmonic Drive, Cycloidal) va yuqori ajratiş qobiliyatiga ega enkoderlarni qöllaş orqali taʼminlanadi.
+ *Minimal moment tebranişlari (Low Torque Ripple):* dvigatelning past tezliklarda bir maromda silliq harakatlanişini taʼminlaş.

= Yuritmalar turlarining qiyosiy tahlili

== Elektr yuritmalar

Mexatronika va robototexnikada eng keng tarqalgan yuritma turi hisoblanadi. Asosiy turlari:

- *BLDC va PMSM (Brushless DC / Permanent Magnet Synchronous Motors):* yuqori FIK ($> 90%$), katta moment ziçligi hamda uzoq xizmat muddati sababli manipulyatorlarda asosiy yuritma hisoblanadi.
- *Qadamli dvigatellar (Stepper Motors):* oçiq zanjirli (_open-loop_) tizimlarda aniq va arzon pozitsiyalaş imkonini beradi.

== Gidravlik va pnevmatik yuritmalar

- *Gidravlik yuritmalar:* suyuqlikning siqilmasligi sababli öta yuqori kuç/moment va mexanik qattiqlik beradi. Oğir yuk kötaruvçi robotlarda qöllaniladi.
- *Pnevmatik yuritmalar:* siqilgan havo hisobiga moslaşuvçan (_compliant_) va tezkor harakat beradi, biroq havoning siqiluvçanligi sababli aniq pozitsiyalaş murakkab.

= Yuritmalar mexanikasi va ölçamlarni hisoblaş (Sizing Procedure)

== Keltirilgan inersiya momenti va optimal uzatiş nisbati

Reduktorli yuritma tizimida dvigatel valiga keltirilgan umumiy inersiya momenti ($I_"tot"$):

$ I_"tot" = I_d + I_L / n^2 $

bunda $I_d$ --- dvigatel rotorining inersiya momenti, $I_L$ --- yuklama va reduktor çiqiş valining inersiya momenti, $n$ --- reduktor uzatiş nisbati.

Maksimal burçak tezlanişiga erişiş uçun optimal uzatiş nisbati ($n^*$):

$ n^* = sqrt(I_L / I_d) $

== Trapetsiyasimon tezlik profili va örtaça kvadratik moment ($T_"rms"$)

Robot böğinining harakat sikli trapetsiyasimon tezlik grafigi orqali modellaştiriladi. Har bir bosqiçdagi momentlar:

$
  T_"acc" = I_"tot" dot alpha_d + T_L, quad
  T_"const" = T_L, quad
  T_"dec" = -I_"tot" dot alpha_d + T_L
$

Dvigatel qizib ketmasligi uçun örtaça kvadratik moment ($T_"rms"$) dvigatelning nominal momentidan ($T_"nom"$) kiçik bölişi şart:

$ T_"rms" = sqrt((T_"acc"^2 dot t_a + T_"const"^2 dot t_v + T_"dec"^2 dot t_d) / t_"total") <= T_"nom" $

= Mexatronik yuritma va rejimlar sxemalari

== Mexatronik yuritma tizimining strukturaviy sxemasi

#figure(
  {
    set text(size: 9pt)
    diagram(
      node-stroke: 0.8pt,
      edge-stroke: 1pt,
      spacing: (7mm, 12mm),
      node-inset: 6pt,

      node((0, 0), align(center)[*Topşiriq* \ $x_"ref"$], fill: blue.lighten(85%)),
      node((1, 0), $Sigma$, shape: circle, inset: 4pt),
      node((2, 0), align(center)[*Boşqaruvçi* \ (DSP / PLC)], fill: yellow.lighten(70%)),
      node((3, 0), align(center)[*Quvvat drayveri* \ (Invertor / PWM)], fill: orange.lighten(70%)),
      node((4, 0), align(center)[*Dvigatel +* \ *Reduktor*], fill: red.lighten(75%)),
      node((5.3, 0), align(center)[*Yuklama* \ (Robot)], stroke: none),
      node((3, 1), [*Datçik* (Enkoder / LVDT)], fill: gray.lighten(65%)),

      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>", label: $u(t)$),
      edge((3, 0), (4, 0), "-|>", label: $i(t)$),
      edge((4, 0), (5.3, 0), "-|>"),
      // Qayta aloqa zanjiri
      edge((4.6, 0), (4.6, 1), (3, 1), "-|>"),
      edge((3, 1), (1, 1), (1, 0), "-|>", label: $-$, label-pos: 0.93, label-side: right),
    )
  },
  caption: [Qayta aloqali yopiq zanjirli mexatronik yuritma tizimi],
)

== Tört kvadrantli (4-Quadrant) iş rejimlari diagrammasi

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *

    let lbl(pos, body) = content(
      pos,
      align(center, text(size: 7.5pt, weight: "bold", body)),
    )

    // Kvadrantlar (T — gorizontal, ω — vertikal)
    rect((0, 0), (2.5, 2.5), fill: blue.lighten(88%), stroke: 0.4pt)
    rect((0, 0), (-2.5, 2.5), fill: yellow.lighten(80%), stroke: 0.4pt)
    rect((0, 0), (-2.5, -2.5), fill: blue.lighten(88%), stroke: 0.4pt)
    rect((0, 0), (2.5, -2.5), fill: yellow.lighten(80%), stroke: 0.4pt)

    lbl((1.25, 1.25))[I-kvadrant \ Öngga harakat \ (Motor rejimi) \ $T > 0, space omega > 0$]
    lbl((-1.25, 1.25))[II-kvadrant \ Öngga harakatda \ tormozlaniş \ (Generator rejimi) \ $T < 0, space omega > 0$]
    lbl((-1.25, -1.25))[III-kvadrant \ Çapga harakat \ (Motor rejimi) \ $T < 0, space omega < 0$]
    lbl((1.25, -1.25))[IV-kvadrant \ Çapga harakatda \ tormozlaniş \ (Generator rejimi) \ $T > 0, space omega < 0$]

    // Oʻqlar
    line((-3, 0), (3, 0), stroke: 1.6pt, mark: (end: "stealth", fill: black))
    line((0, -3), (0, 3), stroke: 1.6pt, mark: (end: "stealth", fill: black))
    content((3.1, 0), anchor: "west", text(size: 10pt, weight: "bold")[Moment $T$])
    content((0, 3.1), anchor: "south", text(size: 10pt, weight: "bold")[Tezlik $omega$])
  }),
  caption: [Dvigatelning tört kvadrantli iş rejimlari],
)

= Amaliy hisoblaş va dvigatel tanlaş ketma-ketligi

== Masala şarti

Sanoat robotining böğini $M_L = 12 "kg"$ massaga ega bölib, $R = 0.4 "m"$ radiusda joylaşgan ($I_L = M_L R^2 = 1.92 "kg" dot "m"^2$). Böğinni $t_a = 0.2 "s"$ içida $omega_L = 3.14 "rad/s"$ ($30 "rpm"$) tezlikka tezlatiş talab etiladi. Tanlangan BLDC dvigatelining rotor inersiyasi $I_d = 0.0002 "kg" dot "m"^2$.

== Hisoblaş bosqiçlari

+ Optimal uzatiş nisbatini aniqlaş:
  $ n^* = sqrt(1.92 / 0.0002) = sqrt(9600) approx 98 $

+ Reduktor uzatiş nisbati $n = 100$ deb qabul qilinadi.

+ Keltirilgan umumiy inersiya momenti:
  $ I_"tot" = 0.0002 + 1.92 / 100^2 = 0.000392 "kg" dot "m"^2 $

+ Dvigatel valining burçak tezlanişi:
  $ alpha_d = (omega_L dot n) / t_a = (3.14 dot 100) / 0.2 = 1570 "rad/s"^2 $

+ Tezlaniş vaqtidagi talab etiladigan pik moment ($T_"peak"$):
  $ T_"peak" = I_"tot" dot alpha_d = 0.000392 dot 1570 approx 0.615 "N" dot "m" $

= Nazorat savollari

+ Mexatron modullarda yuritmaga nisbatan tizimli yondaşuv (Systems Approach) nimani anglatadi?
+ Optimal uzatiş nisbati ($n^* = sqrt(I_L \/ I_d)$) qanday fizik maʼnoga ega?
+ Nima uçun dvigatel tanlaşda faqat pik moment emas, balki $T_"rms"$ moment ham hisobga olinadi?
+ Tört kvadrantli harakat rejimlari sanoat robotlarida qanday afzalliklar beradi?
