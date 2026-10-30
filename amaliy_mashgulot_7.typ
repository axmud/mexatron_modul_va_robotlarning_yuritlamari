// ============================================================
//  7-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_7.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Elektr yuritmaning yuklama quvvatini hisoblaş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 7  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №7]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Elektr yuritmaning yuklama quvvatini hisoblaş]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatronik tizimlar va sanoat robotlari elektr yuritmalarida)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi va tizimli yondaşuv

Mexatron modullar va sanoat robotlarining samarali hamda işonçli işlaşini taʼminlaşda elektr yuritmaning yuklama quvvatini aniq hisoblaş hal qiluvçi ahamiyatga ega. Richard Crowder özining _Electric Drives and Electromechanical Systems_ asarida taʼkidlaganidek, elektromexanik tizimlarni loyihalaşda *tizimli yondaşuv (Systems Approach)* asosiy tamoyil hisoblanadi. Murakkab raqamli boşqaruv algoritmlari yoki sunʼiy intellekt dasturlari notöğri va yetarsiz quvvatli qilib tanlangan dvigatelning kamçiliklarini örnini bosa olmaydi.

Dvigatel quvvatini notöğri hisoblaş ikkita jiddiy salbiy oqibatga olib keladi:

+ *Quvvatning yetarsizligi (_Undersizing_):* dvigatel va quvvat drayveri (invertor) amaliyotdagi yuklama momentini va tezlaniş ehtiyojlarini qondira olmaydi. Natijada çulğamlar haddan taşqari qizib ketadi (_overheating_), issiqlik himoyasi tizimni öçiradi yoki dvigatelning xizmat muddati keskin qisqaradi.
+ *Haddan ortiqça quvvat tanlaş (_Oversizing_):* dvigatel va invertorning gabarit ölçamlari, massasi hamda narxi asossiz ravişda oşib ketadi. Bu holat, ayniqsa, mobil robotlar hamda manipulyatorlarning harakatlanuvçi böğinlarida xususiy inersiya momentining ortişiga va tizim dinamikasining yomonlaşişiga olib keladi.

== Energetik balans va quvvat oqimi

Elektr yuritma tizimida manbadan olinadigan elektr quvvati ($P_"in"$) va ijro organiga uzatiladigan mexanik quvvat ($P_"mech"$) örtasidagi energetik balans quyidagi tenglama bilan ifodalanadi:

$ P_"in" = P_"mech" + P_"loss" $

bunda $P_"loss"$ --- elektr yuritma va uzatma mexanizmidagi töliq quvvat yöqotişlari bölib, u elektr (mis yöqotişlari $P_"Cu"$), magnit (pölat yöqotişlari $P_"Fe"$), yarimötkazgiçli kalitlardagi yöqotişlar ($P_"sw"$) hamda mexanik işqalaniş yöqotişlaridan ($P_"frict"$) taşkil topadi.

Elektr yuritmaning umumiy foydali iş koeffitsiyenti (FIK, $eta_"tot"$):

$ eta_"tot" = P_"mech" / P_"in" = eta_"inv" dot eta_"mot" dot eta_"red" $

bunda $eta_"inv"$ --- invertor FIKi (0.95--0.98), $eta_"mot"$ --- elektr dvigatel FIKi (0.82--0.94), $eta_"red"$ --- mexanik reduktor FIKi (0.85--0.98).

= Mexanik yuklama quvvati va harakat rejimlari hisobi

== Aylanma va çiziqli harakatdagi quvvat

Aylanma harakat qiluvçi mexatronik böğin uçun talab etiladigan mexanik quvvat ($P_"rot"$) yuklama momenti $T_L$ (Nm) hamda burçak tezligi $omega_m$ (rad/s) yoki val aylanişlar soni $n_m$ (rpm) orqali aniqlanadi:

$ P_"rot" = T_L dot omega_m = (T_L dot n_m) / 9550 quad ["kW"] $

Çiziqli harakatlanuvçi mexanizmlar (masalan, konveyer, çiziqli modul yoki gidro/pnevmosilindr örniga qöllaniluvçi şarikli-vintli uzatmalar) uçun talab etiladigan mexanik quvvat ($P_"lin"$):

$ P_"lin" = F_"yuk" dot v_"lin" quad ["W"] $

bunda $F_"yuk"$ --- çiziqli yönalişdagi töliq yuklama kuçi (N), $v_"lin"$ --- çiziqli köçiş tezligi (m/s).

== Tezlaniş va dinamik pik quvvat

Sanoat robotlari hamda tezkor mexatronik modullar uzluksiz pozitsiyalaş rejimida işlaydi. Trapetsiyasimon tezlik profili şaroitida tezlaniş bosqiçida dvigatel nafaqat texnologik yuklama momentini ($T_L$), balki tizimning töliq inersiyasini ($I_"tot"$) yengiş uçun dinamik tezlaniş momentini ($T_"acc"$) ham rivojlantirişi şart:

$ T_"acc" = I_"tot" dot alpha_m + T_L = (I_m + I_L / (n^2 dot eta_"red")) alpha_m + T_L $

bunda $I_m$ --- dvigatel rotorining inersiya momenti, $I_L$ --- yuklamaning inersiya momenti, $n$ --- reduktor uzatiş nisbati, $alpha_m$ --- dvigatel valining burçak tezlanişi (rad/s#super[2]).

Tezlaniş bosqiçining oxirida dvigatel maksimal burçak tezligiga ($omega_"max"$) erişganda *maksimal pik quvvat (Peak Power)* talab etiladi:

$ P_"peak" = T_"acc" dot omega_"max" quad ["W"] $

== IEC 60034-1 standarti böyiça iş rejimlarining (Duty Cycles) tasnifi

Elektr dvigatelining qiziş rejimini va yuklama quvvatini töğri baholaş uçun xalqaro IEC 60034-1 standarti böyiça iş rejimlarini (S1--S8) eʼtiborga oliş zarur:

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: (auto, 3.8cm, 1fr),
      align: (center + horizon, left + horizon, left + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Rejim*], [*Nomi*], [*Tavsifi va qiziş şaroiti*]),
      table.hline(stroke: 0.5pt),
      [*S1*], [Uzluksiz rejim \ (_Continuous duty_)],
      [Dvigatel özgarmas yuklama quvvatida issiqlik muvozanat haroratiga ($Delta T_"max"$) yetgunça uzoq vaqt işlaydi.],
      [*S2*], [Qisqa muddatli rejim \ (_Short-time duty_)],
      [Dvigatel maʼlum vaqt (10, 30, 60 min) işlaydi, söngra töliq sovugunça töxtab turadi.],
      [*S3*], [Davriy takrorlanuvçi rejim \ (_Intermittent periodic duty_)],
      [Işlaş va pauza vaqtlari takrorlanadi. Iş davomiyligi nisbati: $"DC" = t_i / (t_i + t_p) dot 100%$.],
      [*S4--S8*], [Dinamik va reversiv rejimlar],
      [Tezlaniş, tormozlaniş va tezlikni özgartiriş bosqiçlari yuqori issiqlik ajralişi bilan keçadigan murakkab rejimlar.],
      table.hline(stroke: 1pt),
    )
  },
  caption: [IEC 60034-1 standarti böyiça elektr dvigatellarining asosiy iş rejimlari tavsifi],
)

= Örtaça kvadratik quvvat (RMS Power) va issiqlik rejimi hisobi

Davriy va dinamik takrorlanuvçi yuklamalarda (S3--S8 rejimlarida) dvigatel quvvati faqat pik quvvat böyiça emas, balki *örtaça kvadratik quvvat (RMS Power)* hamda çulğamlar haroratining ruxsat etilgan çegaradan oşmasligi mezonidan kelib çiqib hisoblanadi.

== Örtaça kvadratik moment va quvvat formulalari

Bir töliq sikl ($t_"sikl" = t_a + t_v + t_d + t_p$) davomida dvigatel çulğamlarida ajraladigan issiqlik miqdori örtaça kvadratik moment ($T_"rms"$) kvadratiga mutanosibdir:

$ T_"rms" = sqrt((T_"acc"^2 dot t_a + T_"const"^2 dot t_v + T_"dec"^2 dot t_d + T_"pauza"^2 dot t_p) / t_"sikl") $

Uşbu momentga mos keluvçi nominal ekvivalent *RMS quvvat ($P_"rms"$)*:

$ P_"rms" = T_"rms" dot omega_"nom" = (T_"rms" dot n_"nom") / 9550 quad ["kW"] $ <eq-prms>

== Dvigatel nominal quvvatini tanlaş şarti

Dvigatel çulğamlari issiqlikdan şikastlanmasligi va xizmat muddatini saqlaşi uçun quyidagi 3 ta asosiy şart bir vaqtda bajarilişi şart:

+ *Uzluksiz issiqlik şarti:* dvigatelning nominal quvvati zaxira koeffitsiyenti ($K_z = 1.15 dots 1.30$) bilan RMS quvvatdan katta yoki teng bölişi kerak:
  $ P_"nom" >= K_z dot P_"rms" $
+ *Pik moment şarti:* dvigatel va invertorning maksimal ruxsat etilgan pik momenti tezlaniş momentidan katta bölişi şart:
  $ T_"peak" >= T_"acc" $
+ *Tezlik şarti:* maksimal işçi tezlik dvigatelning salt işlaş tezligidan oşmasligi kerak (kuçlaniş zaxirasi $20%$ bilan):
  $ n_"max" <= 0.80 dot n_"no-load" $

= Grafik va sxematik tasvirlar

== Elektr yuritmadagi quvvat oqimi va yöqotişlar balansi

#figure(
  {
    set text(size: 8pt)
    let loss = red.darken(20%)
    let b(body) = align(center, strong(body))
    diagram(
      node-stroke: 0.8pt,
      node-inset: 5pt,
      spacing: (9mm, 9mm),
      edge-stroke: 1.8pt,

      node((0, 0), b[Elektr tarmoq \ manbai ($P_"in"$)], fill: blue.lighten(85%), width: 2.2cm, height: 1.1cm),
      node((1, 0), b[Invertor / \ drayver], fill: orange.lighten(80%), width: 2.2cm, height: 1.1cm),
      node((2, 0), b[Elektr \ dvigatel], fill: yellow.lighten(75%), width: 2.2cm, height: 1.1cm),
      node((3, 0), b[Reduktor / \ uzatma], fill: green.lighten(80%), width: 2.2cm, height: 1.1cm),
      node((4, 0), b[Mexanik \ yuklama ($P_"mech"$)], fill: gray.lighten(75%), width: 2.2cm, height: 1.1cm),

      edge((0, 0), (1, 0), "-|>", label: $P_"elektr"$),
      edge((1, 0), (2, 0), "-|>", label: $P_"inv"$),
      edge((2, 0), (3, 0), "-|>", label: $P_"val"$),
      edge((3, 0), (4, 0), "-|>", label: $P_"foydali"$),

      node((1, 1), text(fill: loss, b[Invertor yöqotişi \ $P_"sw"$ (kalitlar)]), stroke: none),
      node((2, 1), text(fill: loss, b[Dvigatel yöqotişi \ $P_"Cu" + P_"Fe"$ (issiqlik)]), stroke: none),
      node((3, 1), text(fill: loss, b[Mexanik yöqotiş \ $P_"frict"$ (işqalaniş)]), stroke: none),
      ..range(1, 4).map(i => edge((i, 0), (i, 1), "-|>", stroke: 1pt + loss)),
    )
  },
  caption: [Elektr yuritma tizimidagi quvvat oqimi va yöqotişlar balansi diagrammasi],
)

== Iş sikli davomida yuklama momenti va tezligining özgariş profili

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.2, y: 1.0)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let red-c = red.darken(20%)
    let blue-c = blue.darken(20%)
    let grn-c = green.darken(40%)

    grid(
      (0, -1.5),
      (6.5, 3.5),
      step: 0.5,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    line((0, 0), (7.0, 0), stroke: 1pt, mark: arrow)
    line((0, -1.5), (0, 4.0), stroke: 1pt, mark: arrow)
    content((7.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$ (s)])
    content((0, 4.1), anchor: "south", text(size: 9pt, weight: "bold")[Moment $T$ (Nm) / Tezlik $omega$ (rad/s)])

    // Tezlik profili
    line((0, 0), (1.0, 3.0), (3.5, 3.0), (4.5, 0), (6.0, 0), stroke: 2pt + blue-c)
    content((2.25, 3.05), anchor: "south", text(fill: blue-c, small[Tezlik $omega(t)$]))

    // Moment profili (hisobga mos nisbatda)
    line(
      (0, 3.2),
      (1.0, 3.2),
      (1.0, 0.86),
      (3.5, 0.86),
      (3.5, -1.48),
      (4.5, -1.48),
      (4.5, 0),
      (6.0, 0),
      stroke: 2pt + red-c,
    )

    // T_rms chizigʻi
    line((0, 1.14), (6.0, 1.14), stroke: (paint: grn-c, thickness: 1.6pt, dash: "dashed"))
    content((6.05, 1.14), anchor: "west", text(fill: grn-c, small[$T_"rms"$ (örtaça kvadratik moment)]))

    // Vaqt belgilari
    for (x, lab) in (
      (0, [0]),
      (1.0, $t_a$),
      (3.5, $t_a + t_v$),
      (4.5, $t_"harakat"$),
      (6.0, [$t_"sikl"$ (pauza bilan)]),
    ) {
      content((x, -1.55), anchor: "north", small(lab))
      line((x, -0.05), (x, 0.05), stroke: 0.6pt)
    }

    // Izohlar
    content((0.5, 3.4), text(fill: red-c, small[$T_"acc"$ (tezlaniş)]))
    content((2.25, 0.62), text(fill: red-c, small[$T_"const"$ (statik)]))
    content((4.0, -1.25), text(fill: red-c, small[$T_"dec"$ (tormoz)]))
  }),
  caption: [Dinamik iş siklida tezlik, moment va örtaça kvadratik momentning ($T_"rms"$) vaqt böyiça özgarişi],
)

== IEC S1 va S3 iş rejimlarining qiziş diagrammasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.9)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let red-c = red.darken(20%)
    let blue-c = blue.darken(20%)

    line((0, 0), (6.5, 0), stroke: 1pt, mark: arrow)
    line((0, 0), (0, 3.5), stroke: 1pt, mark: arrow)
    content((6.6, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$])
    content((0, 3.6), anchor: "south", text(size: 9pt, weight: "bold")[Harorat $Delta T$ ($degree"C"$)])

    // Ruxsat etilgan chegara
    line((0, 3.0), (6.0, 3.0), stroke: (thickness: 1pt, dash: "dashed"))
    content((5.9, 3.08), anchor: "south-east", small[Ruxsat etilgan maksimal harorat ($T_"limit"$)])

    // S1 egri chizigʻi
    bezier((0, 0), (6.0, 3.0), (1.5, 2.5), (3.0, 2.9), stroke: 2pt + red-c)
    content((6.05, 2.8), anchor: "west", text(fill: red-c, small[S1 rejim ($Delta T_"max"$ ga yetadi)]))

    // S3 egri chizigʻi (ish — pauza)
    let s3 = 1.2pt + blue-c
    bezier((0, 0), (1.0, 1.8), (0.5, 1.5), stroke: s3)
    line((1.0, 1.8), (1.0, 1.2), stroke: s3)
    bezier((1.0, 1.2), (2.0, 2.3), (1.5, 2.2), stroke: s3)
    line((2.0, 2.3), (2.0, 1.6), stroke: s3)
    bezier((2.0, 1.6), (3.0, 2.5), (2.5, 2.5), stroke: s3)
    line((3.0, 2.5), (3.0, 1.8), stroke: s3)
    bezier((3.0, 1.8), (4.0, 2.5), (3.5, 2.5), stroke: s3)
    content((4.1, 2.35), anchor: "north-west", text(fill: blue-c, small[S3 rejim (pauza bilan)]))
  }),
  caption: [Uzluksiz (S1) va davriy takrorlanuvçi (S3) rejimlarda çulğamlar qiziş haroratining özgarişi],
)

= Amaliy hisoblaş misoli (sanoat konveyer yuritmasi)

== Masalaning qöyilişi

Sanoat roboti liniyasida detallarni uzatuvçi konveyer lentasi va uning elektr yuritmasining yuklama quvvatini hisoblaş talab etiladi.

- Konveyer lentasidagi töliq harakatlanuvçi massa: $m = 120 "kg"$;
- Lenta harakat tezligi: $v = 1.2 "m/s"$;
- Sirpaniş işqalaniş koeffitsiyenti: $mu = 0.15$;
- Baraban diametri: $D_"baraban" = 0.2 "m"$ (radiusi $r = 0.1 "m"$);
- Reduktor uzatiş nisbati: $n = 10$, reduktor FIKi: $eta_"red" = 0.88$;
- Iş rejimi vaqtlari (S3): tezlaniş vaqti $t_a = 0.3 "s"$, özgarmas tezlik vaqti $t_v = 2.0 "s"$, tormozlaniş vaqti $t_d = 0.3 "s"$, pauza vaqti $t_p = 1.4 "s"$ (töliq sikl $t_"sikl" = 4.0 "s"$, iş davomiyligi $"DC" = 2.6 \/ 4.0 = 65%$).

== Qadamma-qadam hisoblaş bosqiçlari

*1-bosqiç: statik va dinamik kuçlarni hisoblaş*

- Statik işqalaniş kuçi:
  $ F_"frict" = mu dot m dot g = 0.15 dot 120 dot 9.81 = 176.58 quad ["N"] $
- Tezlaniş:
  $ a = v / t_a = 1.2 / 0.3 = 4.0 quad ["m/s"^2] $
- Dinamik inersion kuç:
  $ F_"acc" = m dot a = 120 dot 4.0 = 480.0 quad ["N"] $

*2-bosqiç: dvigatel validagi momentlarni hisoblaş*

- Tezlaniş bosqiçidagi moment ($T_"acc"$):
  $
    T_"acc" = ((F_"frict" + F_"acc") dot r) / (n dot eta_"red")
    = ((176.58 + 480.0) dot 0.1) / (10 dot 0.88) = 65.658 / 8.8 = 7.461 quad ["Nm"]
  $
- Barqaror harakat bosqiçidagi moment ($T_"const"$):
  $ T_"const" = (F_"frict" dot r) / (n dot eta_"red") = (176.58 dot 0.1) / 8.8 = 17.658 / 8.8 = 2.007 quad ["Nm"] $
- Tormozlaniş bosqiçidagi moment ($T_"dec"$):
  $
    T_"dec" = ((F_"frict" - F_"acc") dot r) / (n dot eta_"red")
    = ((176.58 - 480.0) dot 0.1) / 8.8 = -30.342 / 8.8 = -3.448 quad ["Nm"]
  $

*3-bosqiç: dvigatel burçak tezligi va RMS quvvatni hisoblaş*

- Baraban burçak tezligi: $omega_"baraban" = v \/ r = 1.2 \/ 0.1 = 12.0 "rad/s"$.
- Dvigatel valining burçak tezligi:
  $
    omega_m = omega_"baraban" dot n = 12.0 dot 10 = 120.0 quad ["rad/s"]
    quad ==> \ quad n_m = (120 dot 60) / (2 pi) = 1145.9 quad ["rpm"]
  $
- Örtaça kvadratik moment ($T_"rms"$), pauzada $T_"pauza" = 0$:
  $
    T_"rms" = sqrt((7.461^2 dot 0.3 + 2.007^2 dot 2.0 + (-3.448)^2 dot 0.3) / 4.0)
    = \ sqrt((16.700 + 8.056 + 3.567) / 4.0) = 2.661 quad ["Nm"]
  $
- Ekvivalent RMS quvvat (@eq-prms formula, $n_m = 1145.9 "rpm"$ bölgani uçun nominal tezligi $n_"nom" = 1500 "rpm"$, $omega_"nom" = 157.08 "rad/s"$ bölgan dvigatel közda tutiladi):
  $ P_"rms" = T_"rms" dot omega_"nom" = 2.661 dot 157.08 = 418.0 quad ["W"] = 0.418 quad ["kW"] $

*4-bosqiç: dvigatel nominal quvvatini tanlaş*

Zaxira koeffitsiyenti $K_z = 1.25$ eʼtiborga olinganda talab etiladigan nominal quvvat:

$ P_"nom, talab" >= 1.25 dot 0.418 = 0.5225 quad ["kW"] = 522.5 quad ["W"] $

Katalogdan eng yaqin standart quvvat qatori böyiça *0.55 kW, 1500 rpm* servodvigatel tanlanadi. Uning nominal momenti $T_"nom" = P_"nom" \/ omega_"nom" = 550 \/ 157.08 = 3.50 "Nm"$; pik momenti odatda $approx 3 T_"nom" = 10.5 "Nm"$ (aniq qiymat tanlangan model katalogidan tekşiriladi).

= Hisoblaş natijalari va soliştirma jadval

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
      table.header([*Parametr nomi*], [*Hisoblangan qiymat*], [*Tanlangan dvigatel*], [*Zaxira*]),
      table.hline(stroke: 0.5pt),
      [Nominal quvvat ($P_"nom"$)], [0.523 kW], [*0.550 kW*], [+5.3% (yetarli)],
      [Nominal moment ($T_"nom"$)], [2.661 Nm], [*3.50 Nm*], [+31.5% (töliq mos)],
      [Maksimal pik moment ($T_"peak"$)], [7.461 Nm], [*$approx$ 10.5 Nm*], [+40.7% (dinamik mos)],
      [Nominal tezlik ($n_"nom"$)], [1145.9 rpm], [*1500 rpm*], [+30.9% (tezlik zaxirasi)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Konveyer elektr yuritmasining hisoblangan va katalogdan tanlangan dvigatel körsatkiçlari],
)

= Nazorat savollari

+ Elektr yuritmaning yuklama quvvatini hisoblaşda _oversizing_ (ortiqça quvvat) va _undersizing_ (kam quvvat) tanlaşning qanday texnik va iqtisodiy salbiy oqibatlari bor?
+ Uzluksiz rejim (S1) va davriy takrorlanuvçi rejimda (S3) elektr dvigatelining quvvatini hisoblaş usullari örtasidagi asosiy farqlar nimada?
+ Örtaça kvadratik moment ($T_"rms"$) va RMS quvvat ($P_"rms"$) dvigatel çulğamlarining issiqlik rejimiga qanday boğlangan?
+ Dinamik tezlaniş bosqiçida pik quvvat ($P_"peak"$) qanday omillarga boğliq va u invertor quvvatini tanlaşga qanday taʼsir qiladi?
+ Elektr yuritma tizimining töliq FIKi ($eta_"tot"$) tarkibiy qismlari (invertor, dvigatel, reduktor) böyiça qanday aniqlanadi?
