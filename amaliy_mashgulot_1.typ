// ============================================================
//  1-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_1.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(
  title: "Mexatron modullar va robotlarning yuritmalariga qoʻyiladigan talablarni aniqlash",
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
#set text(size: 12pt, lang: "uz")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №1]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: Mexatron modullar va robotlarning yuritmalariga qoʻyiladigan talablarni aniqlash
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

- Mexatronik tizimlar va sanoat robotlarining ijro organlarida qoʻllaniladigan elektr, gidravlik hamda pnevmatik yuritmalar va ularga qoʻyiladigan asosiy texnik, kinetik va dinamik talablarni tahlil qilish.
- Yuritmalarning quvvat zichligi, tezkorligi, oʻtish jarayonlari, moment tebranishlari va pozitsiyalash aniqligini baholash mezonlarini oʻrganish.
- Berilgan yuklama va tezlik grafiklari asosida dvigatel hamda uzatish mexanizmi parametrlarini maqbullashtirish (_motor-drive sizing_) koʻnikmalarini shakllantirish.

= Qisqacha nazariy maʼlumotlar va tizimli yondashuv

Mexatron modullar va robotlarda yuritma tizimi (_actuation system_) axborot-boshqaruv signallarini mexanik harakat hamda foydali kuch/momentga aylantirib beruvchi asosiy energetik boʻgʻin hisoblanadi. Zamonaviy mexatronikada yuritmaga nisbatan *tizimli yondashuv (Systems Approach)* qoʻllaniladi: yuritma faqat dvigatelning oʻzidan emas, balki quvvat oʻzgartirgichi (drayver), uzatish mexanizmi (reduktor), datchiklar va qayta aloqali boshqaruv algoritmidan iborat yagona yaxlit kompleks sifatida qaraladi.

== Yuritmalarga qoʻyiladigan asosiy texnik va dinamik talablar

Sanoat robotlari va mexatronik qurilmalarda yuritmalarga quyidagi asosiy talablar qoʻyiladi:

+ *Yuqori quvvat va moment zichligi (Power-to-Weight Ratio & Torque Density):* robot boʻgʻinlarida massani kamaytirish uchun minimal oʻlcham va ogʻirlikda maksimal moment ($T$) hamda quvvat ($P$) berish talab etiladi.
+ *Yuqori tezkorlik va keng oʻtkazish polosasi (High Bandwidth):* yuritma kirish signalidagi oʻzgarishlarga tezkor javob berishi hamda kichik elektromexanik vaqt doimiyligiga ($tau_e, tau_m$) ega boʻlishi kerak.
+ *Toʻrt kvadrantli reversiv harakat (4-Quadrant Operation):* dvigatel har ikki yoʻnalishda tezlanish, oʻzgarmas tezlik hamda rekuperativ tormozlanish rejimlarida barqaror ishlashi lozim.
+ *Yuqori pozitsiyalash aniqligi va kichik lyuft (Low Backlash):* yuqori aniqlikdagi reduktorlar (Harmonic Drive, Cycloidal) va yuqori ajratish qobiliyatiga ega enkoderlarni qoʻllash orqali taʼminlanadi.
+ *Minimal moment tebranishlari (Low Torque Ripple):* dvigatelning past tezliklarda bir maromda silliq harakatlanishini taʼminlash.

= Yuritmalar turlarining qiyosiy tahlili

== Elektr yuritmalar

Mexatronika va robototexnikada eng keng tarqalgan yuritma turi hisoblanadi. Asosiy turlari:

- *BLDC va PMSM (Brushless DC / Permanent Magnet Synchronous Motors):* yuqori FIK ($> 90%$), katta moment zichligi hamda uzoq xizmat muddati sababli manipulyatorlarda asosiy yuritma hisoblanadi.
- *Qadamli dvigatellar (Stepper Motors):* ochiq zanjirli (_open-loop_) tizimlarda aniq va arzon pozitsiyalash imkonini beradi.

== Gidravlik va pnevmatik yuritmalar

- *Gidravlik yuritmalar:* suyuqlikning siqilmasligi sababli oʻta yuqori kuch/moment va mexanik qattiqlik beradi. Ogʻir yuk koʻtaruvchi robotlarda qoʻllaniladi.
- *Pnevmatik yuritmalar:* siqilgan havo hisobiga moslashuvchan (_compliant_) va tezkor harakat beradi, biroq havoning siqiluvchanligi sababli aniq pozitsiyalash murakkab.

= Yuritmalar mexanikasi va oʻlchamlarni hisoblash (Sizing Procedure)

== Keltirilgan inersiya momenti va optimal uzatish nisbati

Reduktorli yuritma tizimida dvigatel valiga keltirilgan umumiy inersiya momenti ($I_"tot"$):

$ I_"tot" = I_d + I_L / n^2 $

bunda $I_d$ --- dvigatel rotorining inersiya momenti, $I_L$ --- yuklama va reduktor chiqish valining inersiya momenti, $n$ --- reduktor uzatish nisbati.

Maksimal burchak tezlanishiga erishish uchun optimal uzatish nisbati ($n^*$):

$ n^* = sqrt(I_L / I_d) $

== Trapetsiyasimon tezlik profili va oʻrtacha kvadratik moment ($T_"rms"$)

Robot boʻgʻinining harakat sikli trapetsiyasimon tezlik grafigi orqali modellashtiriladi. Har bir bosqichdagi momentlar:

$
  T_"acc" = I_"tot" dot alpha_d + T_L, quad
  T_"const" = T_L, quad
  T_"dec" = -I_"tot" dot alpha_d + T_L
$

Dvigatel qizib ketmasligi uchun oʻrtacha kvadratik moment ($T_"rms"$) dvigatelning nominal momentidan ($T_"nom"$) kichik boʻlishi shart:

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

      node((0, 0), align(center)[*Topshiriq* \ $x_"ref"$], fill: blue.lighten(85%)),
      node((1, 0), $Sigma$, shape: circle, inset: 4pt),
      node((2, 0), align(center)[*Boshqaruvchi* \ (DSP / PLC)], fill: yellow.lighten(70%)),
      node((3, 0), align(center)[*Quvvat drayveri* \ (Invertor / PWM)], fill: orange.lighten(70%)),
      node((4, 0), align(center)[*Dvigatel +* \ *Reduktor*], fill: red.lighten(75%)),
      node((5.3, 0), align(center)[*Yuklama* \ (Robot)], stroke: none),
      node((3, 1), [*Datchik* (Enkoder / LVDT)], fill: gray.lighten(65%)),

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

== Toʻrt kvadrantli (4-Quadrant) ish rejimlari diagrammasi

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

    lbl((1.25, 1.25))[I-kvadrant \ Oʻngga harakat \ (Motor rejimi) \ $T > 0, space omega > 0$]
    lbl((-1.25, 1.25))[II-kvadrant \ Oʻngga harakatda \ tormozlanish \ (Generator rejimi) \ $T < 0, space omega > 0$]
    lbl((-1.25, -1.25))[III-kvadrant \ Chapga harakat \ (Motor rejimi) \ $T < 0, space omega < 0$]
    lbl((1.25, -1.25))[IV-kvadrant \ Chapga harakatda \ tormozlanish \ (Generator rejimi) \ $T > 0, space omega < 0$]

    // Oʻqlar
    line((-3, 0), (3, 0), stroke: 1.6pt, mark: (end: "stealth", fill: black))
    line((0, -3), (0, 3), stroke: 1.6pt, mark: (end: "stealth", fill: black))
    content((3.1, 0), anchor: "west", text(size: 10pt, weight: "bold")[Moment $T$])
    content((0, 3.1), anchor: "south", text(size: 10pt, weight: "bold")[Tezlik $omega$])
  }),
  caption: [Dvigatelning toʻrt kvadrantli ish rejimlari],
)

= Amaliy hisoblash va dvigatel tanlash ketma-ketligi

== Masala sharti

Sanoat robotining boʻgʻini $M_L = 12 "kg"$ massaga ega boʻlib, $R = 0.4 "m"$ radiusda joylashgan ($I_L = M_L R^2 = 1.92 "kg" dot "m"^2$). Boʻgʻinni $t_a = 0.2 "s"$ ichida $omega_L = 3.14 "rad/s"$ ($30 "rpm"$) tezlikka tezlatish talab etiladi. Tanlangan BLDC dvigatelining rotor inersiyasi $I_d = 0.0002 "kg" dot "m"^2$.

== Hisoblash bosqichlari

+ Optimal uzatish nisbatini aniqlash:
  $ n^* = sqrt(1.92 / 0.0002) = sqrt(9600) approx 98 $

+ Reduktor uzatish nisbati $n = 100$ deb qabul qilinadi.

+ Keltirilgan umumiy inersiya momenti:
  $ I_"tot" = 0.0002 + 1.92 / 100^2 = 0.000392 "kg" dot "m"^2 $

+ Dvigatel valining burchak tezlanishi:
  $ alpha_d = (omega_L dot n) / t_a = (3.14 dot 100) / 0.2 = 1570 "rad/s"^2 $

+ Tezlanish vaqtidagi talab etiladigan pik moment ($T_"peak"$):
  $ T_"peak" = I_"tot" dot alpha_d = 0.000392 dot 1570 approx 0.615 "N" dot "m" $

= Nazorat savollari

+ Mexatron modullarda yuritmaga nisbatan tizimli yondashuv (Systems Approach) nimani anglatadi?
+ Optimal uzatish nisbati ($n^* = sqrt(I_L \/ I_d)$) qanday fizik maʼnoga ega?
+ Nima uchun dvigatel tanlashda faqat pik moment emas, balki $T_"rms"$ moment ham hisobga olinadi?
+ Toʻrt kvadrantli harakat rejimlari sanoat robotlarida qanday afzalliklar beradi?
