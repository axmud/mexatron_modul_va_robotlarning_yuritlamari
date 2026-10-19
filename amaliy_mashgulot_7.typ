// ============================================================
//  7-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_7.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Elektr yuritmaning yuklama quvvatini hisoblash")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №7]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Elektr yuritmaning yuklama quvvatini hisoblash]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatronik tizimlar va sanoat robotlari elektr yuritmalarida)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi va tizimli yondashuv

Mexatron modullar va sanoat robotlarining samarali hamda ishonchli ishlashini taʼminlashda elektr yuritmaning yuklama quvvatini aniq hisoblash hal qiluvchi ahamiyatga ega. Richard Crowder oʻzining _Electric Drives and Electromechanical Systems_ asarida taʼkidlaganidek, elektromexanik tizimlarni loyihalashda *tizimli yondashuv (Systems Approach)* asosiy tamoyil hisoblanadi. Murakkab raqamli boshqaruv algoritmlari yoki sunʼiy intellekt dasturlari notoʻgʻri va yetarsiz quvvatli qilib tanlangan dvigatelning kamchiliklarini oʻrnini bosa olmaydi.

Dvigatel quvvatini notoʻgʻri hisoblash ikkita jiddiy salbiy oqibatga olib keladi:

+ *Quvvatning yetarsizligi (_Undersizing_):* dvigatel va quvvat drayveri (invertor) amaliyotdagi yuklama momentini va tezlanish ehtiyojlarini qondira olmaydi. Natijada chulgʻamlar haddan tashqari qizib ketadi (_overheating_), issiqlik himoyasi tizimni oʻchiradi yoki dvigatelning xizmat muddati keskin qisqaradi.
+ *Haddan ortiqcha quvvat tanlash (_Oversizing_):* dvigatel va invertorning gabarit oʻlchamlari, massasi hamda narxi asossiz ravishda oshib ketadi. Bu holat, ayniqsa, mobil robotlar hamda manipulyatorlarning harakatlanuvchi boʻgʻinlarida xususiy inersiya momentining ortishiga va tizim dinamikasining yomonlashishiga olib keladi.

== Energetik balans va quvvat oqimi

Elektr yuritma tizimida manbadan olinadigan elektr quvvati ($P_"in"$) va ijro organiga uzatiladigan mexanik quvvat ($P_"mech"$) oʻrtasidagi energetik balans quyidagi tenglama bilan ifodalanadi:

$ P_"in" = P_"mech" + P_"loss" $

bunda $P_"loss"$ --- elektr yuritma va uzatma mexanizmidagi toʻliq quvvat yoʻqotishlari boʻlib, u elektr (mis yoʻqotishlari $P_"Cu"$), magnit (poʻlat yoʻqotishlari $P_"Fe"$), yarimoʻtkazgichli kalitlardagi yoʻqotishlar ($P_"sw"$) hamda mexanik ishqalanish yoʻqotishlaridan ($P_"frict"$) tashkil topadi.

Elektr yuritmaning umumiy foydali ish koeffitsiyenti (FIK, $eta_"tot"$):

$ eta_"tot" = P_"mech" / P_"in" = eta_"inv" dot eta_"mot" dot eta_"red" $

bunda $eta_"inv"$ --- invertor FIKi (0.95--0.98), $eta_"mot"$ --- elektr dvigatel FIKi (0.82--0.94), $eta_"red"$ --- mexanik reduktor FIKi (0.85--0.98).

= Mexanik yuklama quvvati va harakat rejimlari hisobi

== Aylanma va chiziqli harakatdagi quvvat

Aylanma harakat qiluvchi mexatronik boʻgʻin uchun talab etiladigan mexanik quvvat ($P_"rot"$) yuklama momenti $T_L$ (Nm) hamda burchak tezligi $omega_m$ (rad/s) yoki val aylanishlar soni $n_m$ (rpm) orqali aniqlanadi:

$ P_"rot" = T_L dot omega_m = (T_L dot n_m) / 9550 quad ["kW"] $

Chiziqli harakatlanuvchi mexanizmlar (masalan, konveyer, chiziqli modul yoki gidro/pnevmosilindr oʻrniga qoʻllaniluvchi sharikli-vintli uzatmalar) uchun talab etiladigan mexanik quvvat ($P_"lin"$):

$ P_"lin" = F_"yuk" dot v_"lin" quad ["W"] $

bunda $F_"yuk"$ --- chiziqli yoʻnalishdagi toʻliq yuklama kuchi (N), $v_"lin"$ --- chiziqli koʻchish tezligi (m/s).

== Tezlanish va dinamik pik quvvat

Sanoat robotlari hamda tezkor mexatronik modullar uzluksiz pozitsiyalash rejimida ishlaydi. Trapetsiyasimon tezlik profili sharoitida tezlanish bosqichida dvigatel nafaqat texnologik yuklama momentini ($T_L$), balki tizimning toʻliq inersiyasini ($I_"tot"$) yengish uchun dinamik tezlanish momentini ($T_"acc"$) ham rivojlantirishi shart:

$ T_"acc" = I_"tot" dot alpha_m + T_L = (I_m + I_L / (n^2 dot eta_"red")) alpha_m + T_L $

bunda $I_m$ --- dvigatel rotorining inersiya momenti, $I_L$ --- yuklamaning inersiya momenti, $n$ --- reduktor uzatish nisbati, $alpha_m$ --- dvigatel valining burchak tezlanishi (rad/s#super[2]).

Tezlanish bosqichining oxirida dvigatel maksimal burchak tezligiga ($omega_"max"$) erishganda *maksimal pik quvvat (Peak Power)* talab etiladi:

$ P_"peak" = T_"acc" dot omega_"max" quad ["W"] $

== IEC 60034-1 standarti boʻyicha ish rejimlarining (Duty Cycles) tasnifi

Elektr dvigatelining qizish rejimini va yuklama quvvatini toʻgʻri baholash uchun xalqaro IEC 60034-1 standarti boʻyicha ish rejimlarini (S1--S8) eʼtiborga olish zarur:

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
      table.header([*Rejim*], [*Nomi*], [*Tavsifi va qizish sharoiti*]),
      table.hline(stroke: 0.5pt),
      [*S1*], [Uzluksiz rejim \ (_Continuous duty_)],
      [Dvigatel oʻzgarmas yuklama quvvatida issiqlik muvozanat haroratiga ($Delta T_"max"$) yetguncha uzoq vaqt ishlaydi.],
      [*S2*], [Qisqa muddatli rejim \ (_Short-time duty_)],
      [Dvigatel maʼlum vaqt (10, 30, 60 min) ishlaydi, soʻngra toʻliq sovuguncha toʻxtab turadi.],
      [*S3*], [Davriy takrorlanuvchi rejim \ (_Intermittent periodic duty_)],
      [Ishlash va pauza vaqtlari takrorlanadi. Ish davomiyligi nisbati: $"DC" = t_i / (t_i + t_p) dot 100%$.],
      [*S4--S8*], [Dinamik va reversiv rejimlar],
      [Tezlanish, tormozlanish va tezlikni oʻzgartirish bosqichlari yuqori issiqlik ajralishi bilan kechadigan murakkab rejimlar.],
      table.hline(stroke: 1pt),
    )
  },
  caption: [IEC 60034-1 standarti boʻyicha elektr dvigatellarining asosiy ish rejimlari tavsifi],
)

= Oʻrtacha kvadratik quvvat (RMS Power) va issiqlik rejimi hisobi

Davriy va dinamik takrorlanuvchi yuklamalarda (S3--S8 rejimlarida) dvigatel quvvati faqat pik quvvat boʻyicha emas, balki *oʻrtacha kvadratik quvvat (RMS Power)* hamda chulgʻamlar haroratining ruxsat etilgan chegaradan oshmasligi mezonidan kelib chiqib hisoblanadi.

== Oʻrtacha kvadratik moment va quvvat formulalari

Bir toʻliq sikl ($t_"sikl" = t_a + t_v + t_d + t_p$) davomida dvigatel chulgʻamlarida ajraladigan issiqlik miqdori oʻrtacha kvadratik moment ($T_"rms"$) kvadratiga mutanosibdir:

$ T_"rms" = sqrt((T_"acc"^2 dot t_a + T_"const"^2 dot t_v + T_"dec"^2 dot t_d + T_"pauza"^2 dot t_p) / t_"sikl") $

Ushbu momentga mos keluvchi nominal ekvivalent *RMS quvvat ($P_"rms"$)*:

$ P_"rms" = T_"rms" dot omega_"nom" = (T_"rms" dot n_"nom") / 9550 quad ["kW"] $ <eq-prms>

== Dvigatel nominal quvvatini tanlash sharti

Dvigatel chulgʻamlari issiqlikdan shikastlanmasligi va xizmat muddatini saqlashi uchun quyidagi 3 ta asosiy shart bir vaqtda bajarilishi shart:

+ *Uzluksiz issiqlik sharti:* dvigatelning nominal quvvati zaxira koeffitsiyenti ($K_z = 1.15 dots 1.30$) bilan RMS quvvatdan katta yoki teng boʻlishi kerak:
  $ P_"nom" >= K_z dot P_"rms" $
+ *Pik moment sharti:* dvigatel va invertorning maksimal ruxsat etilgan pik momenti tezlanish momentidan katta boʻlishi shart:
  $ T_"peak" >= T_"acc" $
+ *Tezlik sharti:* maksimal ishchi tezlik dvigatelning salt ishlash tezligidan oshmasligi kerak (kuchlanish zaxirasi $20%$ bilan):
  $ n_"max" <= 0.80 dot n_"no-load" $

= Grafik va sxematik tasvirlar

== Elektr yuritmadagi quvvat oqimi va yoʻqotishlar balansi

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

      node((1, 1), text(fill: loss, b[Invertor yoʻqotishi \ $P_"sw"$ (kalitlar)]), stroke: none),
      node((2, 1), text(fill: loss, b[Dvigatel yoʻqotishi \ $P_"Cu" + P_"Fe"$ (issiqlik)]), stroke: none),
      node((3, 1), text(fill: loss, b[Mexanik yoʻqotish \ $P_"frict"$ (ishqalanish)]), stroke: none),
      ..range(1, 4).map(i => edge((i, 0), (i, 1), "-|>", stroke: 1pt + loss)),
    )
  },
  caption: [Elektr yuritma tizimidagi quvvat oqimi va yoʻqotishlar balansi diagrammasi],
)

== Ish sikli davomida yuklama momenti va tezligining oʻzgarish profili

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
    content((6.05, 1.14), anchor: "west", text(fill: grn-c, small[$T_"rms"$ (oʻrtacha kvadratik moment)]))

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
    content((0.5, 3.4), text(fill: red-c, small[$T_"acc"$ (tezlanish)]))
    content((2.25, 0.62), text(fill: red-c, small[$T_"const"$ (statik)]))
    content((4.0, -1.25), text(fill: red-c, small[$T_"dec"$ (tormoz)]))
  }),
  caption: [Dinamik ish siklida tezlik, moment va oʻrtacha kvadratik momentning ($T_"rms"$) vaqt boʻyicha oʻzgarishi],
)

== IEC S1 va S3 ish rejimlarining qizish diagrammasi

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
  caption: [Uzluksiz (S1) va davriy takrorlanuvchi (S3) rejimlarda chulgʻamlar qizish haroratining oʻzgarishi],
)

= Amaliy hisoblash misoli (sanoat konveyer yuritmasi)

== Masalaning qoʻyilishi

Sanoat roboti liniyasida detallarni uzatuvchi konveyer lentasi va uning elektr yuritmasining yuklama quvvatini hisoblash talab etiladi.

- Konveyer lentasidagi toʻliq harakatlanuvchi massa: $m = 120 "kg"$;
- Lenta harakat tezligi: $v = 1.2 "m/s"$;
- Sirpanish ishqalanish koeffitsiyenti: $mu = 0.15$;
- Baraban diametri: $D_"baraban" = 0.2 "m"$ (radiusi $r = 0.1 "m"$);
- Reduktor uzatish nisbati: $n = 10$, reduktor FIKi: $eta_"red" = 0.88$;
- Ish rejimi vaqtlari (S3): tezlanish vaqti $t_a = 0.3 "s"$, oʻzgarmas tezlik vaqti $t_v = 2.0 "s"$, tormozlanish vaqti $t_d = 0.3 "s"$, pauza vaqti $t_p = 1.4 "s"$ (toʻliq sikl $t_"sikl" = 4.0 "s"$, ish davomiyligi $"DC" = 2.6 \/ 4.0 = 65%$).

== Qadamma-qadam hisoblash bosqichlari

*1-bosqich: statik va dinamik kuchlarni hisoblash*

- Statik ishqalanish kuchi:
  $ F_"frict" = mu dot m dot g = 0.15 dot 120 dot 9.81 = 176.58 quad ["N"] $
- Tezlanish:
  $ a = v / t_a = 1.2 / 0.3 = 4.0 quad ["m/s"^2] $
- Dinamik inersion kuch:
  $ F_"acc" = m dot a = 120 dot 4.0 = 480.0 quad ["N"] $

*2-bosqich: dvigatel validagi momentlarni hisoblash*

- Tezlanish bosqichidagi moment ($T_"acc"$):
  $
    T_"acc" = ((F_"frict" + F_"acc") dot r) / (n dot eta_"red")
    = ((176.58 + 480.0) dot 0.1) / (10 dot 0.88) = 65.658 / 8.8 = 7.461 quad ["Nm"]
  $
- Barqaror harakat bosqichidagi moment ($T_"const"$):
  $ T_"const" = (F_"frict" dot r) / (n dot eta_"red") = (176.58 dot 0.1) / 8.8 = 17.658 / 8.8 = 2.007 quad ["Nm"] $
- Tormozlanish bosqichidagi moment ($T_"dec"$):
  $
    T_"dec" = ((F_"frict" - F_"acc") dot r) / (n dot eta_"red")
    = ((176.58 - 480.0) dot 0.1) / 8.8 = -30.342 / 8.8 = -3.448 quad ["Nm"]
  $

*3-bosqich: dvigatel burchak tezligi va RMS quvvatni hisoblash*

- Baraban burchak tezligi: $omega_"baraban" = v \/ r = 1.2 \/ 0.1 = 12.0 "rad/s"$.
- Dvigatel valining burchak tezligi:
  $
    omega_m = omega_"baraban" dot n = 12.0 dot 10 = 120.0 quad ["rad/s"]
    quad ==> \ quad n_m = (120 dot 60) / (2 pi) = 1145.9 quad ["rpm"]
  $
- Oʻrtacha kvadratik moment ($T_"rms"$), pauzada $T_"pauza" = 0$:
  $
    T_"rms" = sqrt((7.461^2 dot 0.3 + 2.007^2 dot 2.0 + (-3.448)^2 dot 0.3) / 4.0)
    = \ sqrt((16.700 + 8.056 + 3.567) / 4.0) = 2.661 quad ["Nm"]
  $
- Ekvivalent RMS quvvat (@eq-prms formula, $n_m = 1145.9 "rpm"$ boʻlgani uchun nominal tezligi $n_"nom" = 1500 "rpm"$, $omega_"nom" = 157.08 "rad/s"$ boʻlgan dvigatel koʻzda tutiladi):
  $ P_"rms" = T_"rms" dot omega_"nom" = 2.661 dot 157.08 = 418.0 quad ["W"] = 0.418 quad ["kW"] $

*4-bosqich: dvigatel nominal quvvatini tanlash*

Zaxira koeffitsiyenti $K_z = 1.25$ eʼtiborga olinganda talab etiladigan nominal quvvat:

$ P_"nom, talab" >= 1.25 dot 0.418 = 0.5225 quad ["kW"] = 522.5 quad ["W"] $

Katalogdan eng yaqin standart quvvat qatori boʻyicha *0.55 kW, 1500 rpm* servodvigatel tanlanadi. Uning nominal momenti $T_"nom" = P_"nom" \/ omega_"nom" = 550 \/ 157.08 = 3.50 "Nm"$; pik momenti odatda $approx 3 T_"nom" = 10.5 "Nm"$ (aniq qiymat tanlangan model katalogidan tekshiriladi).

= Hisoblash natijalari va solishtirma jadval

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
      [Nominal moment ($T_"nom"$)], [2.661 Nm], [*3.50 Nm*], [+31.5% (toʻliq mos)],
      [Maksimal pik moment ($T_"peak"$)], [7.461 Nm], [*$approx$ 10.5 Nm*], [+40.7% (dinamik mos)],
      [Nominal tezlik ($n_"nom"$)], [1145.9 rpm], [*1500 rpm*], [+30.9% (tezlik zaxirasi)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Konveyer elektr yuritmasining hisoblangan va katalogdan tanlangan dvigatel koʻrsatkichlari],
)

= Nazorat savollari

+ Elektr yuritmaning yuklama quvvatini hisoblashda _oversizing_ (ortiqcha quvvat) va _undersizing_ (kam quvvat) tanlashning qanday texnik va iqtisodiy salbiy oqibatlari bor?
+ Uzluksiz rejim (S1) va davriy takrorlanuvchi rejimda (S3) elektr dvigatelining quvvatini hisoblash usullari oʻrtasidagi asosiy farqlar nimada?
+ Oʻrtacha kvadratik moment ($T_"rms"$) va RMS quvvat ($P_"rms"$) dvigatel chulgʻamlarining issiqlik rejimiga qanday bogʻlangan?
+ Dinamik tezlanish bosqichida pik quvvat ($P_"peak"$) qanday omillarga bogʻliq va u invertor quvvatini tanlashga qanday taʼsir qiladi?
+ Elektr yuritma tizimining toʻliq FIKi ($eta_"tot"$) tarkibiy qismlari (invertor, dvigatel, reduktor) boʻyicha qanday aniqlanadi?
