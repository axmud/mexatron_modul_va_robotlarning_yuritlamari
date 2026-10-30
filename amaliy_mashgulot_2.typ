// ============================================================
//  2-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_2.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robotlarning pnevmoyuritmasini hisoblaş prinsipi")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 2  // amaliyot raqami
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
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №2]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Robotlarning pnevmoyuritmasini hisoblaş prinsipi]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatron modullar va sanoat robotlarining pnevmatik tizimlarini loyihalaş hamda hisoblaş)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

- Sanoat robotlari hamda mexatronik manipulyatorlarning pnevmoyuritmalarini loyihalaş va hisoblaşning nazariy hamda amaliy tamoyillarini egallaş.
- Pnevmosilindrlarning statik va dinamik kuçlarini, porşen diametrini ($D$), ştok diametrini ($d$), harakat tezligini ($v$) hamda siqilgan havo sarfini ($Q$) hisoblaş usullarini örganiş.
- Boşqaruv pnevmoapparatlari (taqsimlagiç, drossel, FRL bloki), siqilgan havo resiveri va magistral quvurlar ölçamlarini töğri tanlaş könikmalarini şakllantiriş.

= Robotlar pnevmoyuritmalariga qöyiladigan talablar va uning tuzilişi

Sanoat robotlarining uşlaş mexanizmlari (gripper), buyumlarni uzatiş hamda pozitsiyalaş modullarida pnevmoyuritmalar harakatlanuvçi qismlarining kiçik massasi, ixçam tuzilişi va yuqori kuç beriş imkoniyati tufayli keng qöllaniladi. Pnevmoyuritmalar elektr va gidravlik yuritmalar bilan soliştirilganda past oğirlik hamda yuqori quvvat/massa nisbatiga ega.

Biroq, siqilgan havoning siqiluvçanligi (_compressibility_) va harorat özgarişlariga taʼsirçanligi tufayli pnevmoyuritmalar past mexanik qattiqlikka (_stiffness_) ega. Şu sababli, robotlarning pnevmoyuritmalarini hisoblaşda statik kuçlar bilan birga dinamik ötiş jarayonlari, keçikiş vaqti (_dead time_) va havo sarfi aniq hisobga olinişi lozim.

Pnevmatik yuritma tizimi quyidagi asosiy unsurlardan taşkil topadi:

+ *Siqilgan havo manbai va tayyorlaş bloki (FRL):* kompressor, resiver hamda filtr, bosim reduktori (_pressure regulator_) va moylagiçdan (_lubricator_) iborat FRL bloki.
+ *Boşqaruv va rostlaş apparaturasi:* yönaltiruvçi pnevmotaqsimlagiç (_directional control valve_ --- 5/2 yoki 3/2-yölli), teskari klapanli drossellar.
+ *Ijro organlari:* ikki taraflama yoki bir taraflama taʼsir etuvçi pnevmosilindrlar, pnevmatik buriş dvigatellari va pnevmo-muskullar.

= Pnevmosilindrning statik va dinamik kuç hisob-kitoblari

== Statik kuç hisobi (porşen va ştok diametrlarini aniqlaş)

Pnevmosilindr porşenining oldinga surilişida (_extend_) rivojlantiriladigan nazariy statik kuç ($F_c$) Paskal qonuniga köra işçi havo bosimi ($P_w$) va porşen yuzasiga ($A$) boğliq:

$ F_c = P_w dot A = P_w dot (pi D^2) / 4 $

Porşenning ortga qaytişida (_retract_) ştok egallagan yuza hisobiga effektiv yuza kamayadi ($A_a = A - a$), natijada ortga qaytiş kuçi ($F_r$) quyidagiça aniqlanadi:

$ F_r = P_w dot A_a = P_w dot (pi (D^2 - d^2)) / 4 $

bunda $D$ --- pnevmosilindr porşenining diametri, $d$ --- ştok diametri. Odatiy pnevmosilindrlarda $d approx (0.3 dots 0.4) D$ nisbatda olinadi.

Real iş şaroitida manjetlardagi va yönaltiruvçilardagi işqalaniş kuçlari hamda yuklama tebranişlarini hisobga oliş uçun zaxira koeffitsienti ($K_z = 1.25 dots 1.5$) kiritiladi. Robot uşlaş mexanizmi yoki yuritmasi talab qiladigan zaruriy kuç $F_"talab"$ bölganda, porşenning effektiv yuzasi $A$ quyidagiça hisoblanadi:

$
  A >= (K_z dot F_"talab") / P_w quad ==> quad
  D >= sqrt((4 dot K_z dot F_"talab") / (pi dot P_w))
$

Pnevmoyuritmaning mexanik foydali iş koeffitsienti (FIK):

$ eta = F_"amaldagi" / F_"nazariy" dot 100% $

Sanoat pnevmosilindrlarida mexanik FIK qiymati odatda $eta = 85 dots 95%$ oraliğida böladi.

== Pnevmosilindr dinamikasi va harakat tenglamasi

Robot böğinini yoki yukni harakatlantirişda Nyutonning ikkinçi qonuniga muvofiq dinamik kuçlar muvozanati tenglamasi quyidagiça yoziladi:

$ M dot a_p = P_1 A_1 - P_2 A_2 - F_"yuk" - f_"işq" $

bunda:

- $M$ --- harakatlanuvçi qismlarning keltirilgan töliq massasi ($M = M_"porşen" + M_"ştok" + M_"yuk"$);
- $a_p = (d^2 x) / (d t^2)$ --- porşenning çiziqli tezlanişi;
- $P_1, P_2$ --- mos ravişda kiriş va çiqiş kameralaridagi vaqtga boğliq bosimlar;
- $F_"yuk"$ --- taşqi mexanik yuklama kuçi (vertikal kötarişda $F_"yuk" = M g$);
- $f_"işq"$ --- manjetlar va yönaltiruvçilardagi quruq va yopişqoq işqalaniş kuçi.

Pnevmoyuritma harakatining töliq siklida uçta asosiy dinamik bosqiç kuzatiladi:

+ *Keçikiş vaqti ($t_d$ --- Dead Time):* taqsimlagiç solenoidiga signal berilgandan söng, kiriş kamerasidagi bosim $P_1$ yuklama va işqalaniş kuçlarini yengiş uçun yetarli darajaga yetgunça hamda çiqiş kamerasidagi bosim $P_2$ kamaygunça ketgan vaqt.
+ *Tezlaniş bosqiçi ($t_a$):* porşen harakatlana boşlab, maksimal tezlikka ($v_"max"$) erişgunça bölgan vaqt oraliği.
+ *Barqaror harakat bosqiçi ($t_v$):* drossellaş orqali havo sarfi çeklangan holda porşenning özgarmas tezlikda ($v$) harakatlaniş bosqiçi.

= Havo sarfi va kompressor unumdorligini hisoblaş

Pnevmosilindr bir marta töliq borganda va qaytganda (bir töliq siklda) sarflanadigan siqilgan havo hajmi Boyl–Mariott qonuniga köra standart atmosfera şaroitiga (STP --- _Standard Temperature and Pressure_, $P_a = 1.013 "bar"$) keltirib hisoblanadi:

$ V_"sikl" = S dot (A_1 + A_2) dot (P_a + P_w) / P_a $

bunda $S$ --- pnevmosilindrning töliq yuriş masofasi (_stroke_), $P_w$ --- manometrik işçi bosim (bar).

Robot pnevmoyuritmasi minutiga $n$ marta töliq siklni bajarsa, örtaça daqiqalik havo sarfi ($Q_"ört"$) quyidagiça aniqlanadi:

$
  Q_"ört" = n dot V_"sikl" = n dot S dot (A_1 + A_2) dot (P_a + P_w) / P_a
  quad ["litr/min" "yoki" "m"^3"/min"]
$

Kompressorning talab etiladigan samarali unumdorligi ($Q_"kompressor"$) tizimdagi mumkin bölgan havo sizib çiqişlarini (_leakage_) hisobga olgan holda zaxira koeffitsienti ($K_"siz" = 1.15 dots 1.25$) bilan hisoblanadi:

$ Q_"kompressor" >= K_"siz" dot sum Q_"ört" $

= Pnevmatizim elementlarini tanlaş va hisoblaş

== Pnevmotaqsimlagiç va drossellarni tanlaş (sarf koeffitsienti $C_v$)

Pnevmotaqsimlagiç va tezlikni drossellaş klapanlaridan ötayotgan havo sarfi klapanning şartli ötiş teşigi diametri ($d_n$) hamda sarf koeffitsientiga ($C_v$) boğliq. Subsonik oqim uçun ($P_2 > 0.53 P_1$) taxminiy ifoda:

$ Q_N approx 400 dot C_v dot sqrt(Delta P dot P_2) quad ["Nl/min"] $

bunda $Delta P = P_1 - P_2$ --- klapandagi bosim tuşişi (bar), $P_2$ --- klapan çiqişidagi absolyut bosim (bar). Pnevmotaqsimlagiç pnevmosilindrga havo yetkazib berişda ortiqça bosim tuşişiga olib kelmasligi uçun uning ötiş yuzasi quvur yuzasidan kiçik bölmasligi lozim.

== Siqilgan havo resiveri hajmini hisoblaş

Resiver siqilgan havo bosimi tebranişlarini silliqlaydi va kompressor töxtab turganda energiya zaxirasini taʼminlaydi. Resiverning minimal hajmi ($V_"resiver"$) Boyl–Mariott tenglamasiga köra quyidagiça aniqlanadi:

$ V_"resiver" = (Q_"kompressor" dot P_a dot T_"sikl") / (Delta P_"ruxsat") $

bunda $Delta P_"ruxsat" = P_"max" - P_"min"$ --- resiverda ruxsat etilgan bosim tebranişi diapazoni ($0.5 dots 1.0 "bar"$), $T_"sikl"$ --- kompressorning yoqiliş/öçiş sikli vaqti.

= Pnevmatik va hisoblaş sxemalari

== Sanoat roboti pnevmoyuritmasining prinsipial pnevmatik sxemasi

#figure(
  cetz.canvas(length: 1.1cm, {
    import cetz.draw: *

    // Toʻrtburchak + markazdagi yozuv
    let boxed(a, b, fill, body, size: 7pt) = {
      rect(a, b, fill: fill, stroke: 1pt)
      content(
        ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2),
        align(center, text(size: size, weight: "bold", body)),
      )
    }
    let arrow = (end: "stealth", fill: black)

    // Pnevmosilindr korpusi, porshen, shtok
    rect((0, 3.5), (3.5, 4.5), fill: gray.lighten(88%), stroke: 1pt)
    rect((1.0, 3.55), (1.3, 4.45), fill: blue.lighten(65%), stroke: 1pt)
    rect((1.3, 3.9), (4.6, 4.1), fill: gray.lighten(45%), stroke: 1.2pt)
    content((1.75, 4.55), anchor: "south", text(size: 9pt, weight: "bold")[Pnevmosilindr ($D, d, S$)])

    // Robot ushlagichi / yuk
    boxed((4.6, 3.5), (5.6, 4.5), red.lighten(65%))[Robot \ Yuk $M$]

    // Kameralarga ulanish
    line((0.6, 3.5), (0.6, 2.5), stroke: 1pt)
    line((2.9, 3.5), (2.9, 2.5), stroke: 1pt)
    content((0.5, 3.0), anchor: "east", text(size: 8pt, weight: "bold")[A ($A_1$)])
    content((3.0, 3.0), anchor: "west", text(size: 8pt, weight: "bold")[B ($A_2$)])

    // Drossellar (meter-out)
    boxed((0.1, 2.1), (1.1, 2.5), yellow.lighten(75%), size: 6pt)[Drossel 1]
    boxed((2.4, 2.1), (3.4, 2.5), yellow.lighten(75%), size: 6pt)[Drossel 2]
    line((0.6, 2.1), (0.6, 1.5), stroke: 1pt)
    line((2.9, 2.1), (2.9, 1.5), stroke: 1pt)

    // 5/2 pnevmotaqsimlagich
    rect((0.0, 0.3), (3.5, 1.5), fill: blue.lighten(95%), stroke: 1pt)
    line((1.75, 0.3), (1.75, 1.5), stroke: (thickness: 1pt, dash: "dashed"))
    content((0.875, 0.9), align(center, text(size: 6.5pt, weight: "bold")[
      Pozitsiya 1 \ P$->$A, B$->$S
    ]))
    content((2.625, 0.9), align(center, text(size: 6.5pt, weight: "bold")[
      Pozitsiya 2 \ P$->$B, A$->$R
    ]))
    content((3.6, 1.55), anchor: "south-west", text(size: 8pt, weight: "bold")[5/2 Pnevmotaqsimlagiç])

    // Solenoid va prujina
    boxed((-1.0, 0.5), (0.0, 1.3), orange.lighten(55%), size: 6.5pt)[Solenoid \ Y1]
    let zig = range(0, 8).map(i => (
      3.5 + 0.7 * i / 7,
      if calc.even(i) { 0.9 } else if calc.rem(i, 4) == 1 { 1.05 } else { 0.75 },
    ))
    line(..zig, stroke: 1pt)
    content((4.3, 0.9), anchor: "west", text(size: 7pt, weight: "bold")[Prujina])

    // Taʼminot va FRL
    line((1.75, -0.6), (1.75, 0.3), stroke: 1pt, mark: arrow)
    content((1.85, -0.15), anchor: "west", text(size: 7pt, weight: "bold")[P ($P_w$)])
    boxed((0.2, -1.5), (3.3, -0.6), green.lighten(75%), size: 7.5pt)[
      FRL bloki \ (Filtr–Reduktor–Moylagiç)
    ]
    line((1.75, -2.2), (1.75, -1.5), stroke: 1pt, mark: arrow)
    content((1.75, -2.3), anchor: "north", text(size: 8pt, weight: "bold")[Resiver va kompressor ($P_"komp"$)])
  }),
  caption: [Robot pnevmoyuritmasining hisoblaş va boşqaruv pnevmatik sxemasi],
)

== Pnevmosilindr dinamik ötiş jarayoni va vaqt diagrammasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.2, y: 0.9)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)

    // Toʻr (grid)
    grid(
      (0, 0),
      (5.5, 4.0),
      step: 0.5,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    // Oʻqlar
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    line((0, 0), (0, 4.5), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$ (s)])
    content((0, 4.6), anchor: "south", text(size: 9pt, weight: "bold")[Bosim $P$ (bar) / Tezlik $v$ (m/s)])

    // Kechikish sohasi
    line((1.2, 0), (1.2, 4.0), stroke: (paint: red, thickness: 1pt, dash: "dashed"))
    content((1.0, 2.0), angle: 90deg, text(fill: red, size: 7pt, weight: "bold")[Keçikiş $t_d$])

    // P1(t) — kirish kamerasi
    let p1 = (paint: green.darken(35%), thickness: 2pt)
    line((0, 0), (0.3, 0.3), stroke: p1)
    bezier((0.3, 0.3), (1.2, 3.2), (0.6, 3.8), stroke: p1)
    line((1.2, 3.2), (2.0, 3.6), (5.0, 3.6), stroke: p1)
    content((5.05, 3.6), anchor: "west", small[$P_1(t)$ (kiriş bosimi)])

    // P2(t) — chiqish kamerasi (aks bosim)
    let p2 = (paint: orange.darken(25%), thickness: 2pt)
    line((0, 3.6), (1.2, 2.0), stroke: p2)
    bezier((1.2, 2.0), (5.0, 0.6), (2.0, 0.8), stroke: p2)
    content((5.05, 0.6), anchor: "west", small[$P_2(t)$ (aks bosim)])

    // v(t) — porshen tezligi
    line((0, 0), (1.2, 0), (2.2, 2.5), (4.2, 2.5), (4.8, 0), (5.5, 0), stroke: (
      paint: blue.darken(30%),
      thickness: 2pt,
    ))
    content((4.3, 2.6), anchor: "south-west", small[$v(t)$ (tezlik)])

    // X oʻqi belgilari
    for (x, lab) in ((0, $0$), (1.2, $t_d$), (2.2, $t_a$), (4.2, $t_v$), (4.8, $t_"töliq"$)) {
      content((x, -0.1), anchor: "north", small(lab))
    }
  }),
  caption: [Pnevmosilindr kameralaridagi bosimlar va porşen tezligining vaqt böyiça ötiş diagrammasi],
)

= Amaliy hisoblaş misoli (sanoat roboti uşlagiçi yuritmasi)

== Masalaning qöyilişi

Sanoat roboti uşlaş mexanizmi (gripper) vertikal yönalişda $M = 15 "kg"$ massali detalni $S = 250 "mm" = 0.25 "m"$ masofaga $t_"harakat" = 0.5 "s"$ vaqt içida kötarişi lozim.

- Işçi manometrik bosim: $P_w = 6 "bar" = 6 dot 10^5 "Pa"$;
- Zaxira koeffitsienti: $K_z = 1.35$;
- Robot minutiga $n = 12$ marta kötariş-tuşiriş siklini bajaradi;
- Atmosfera bosimi: $P_a = 1.0 "bar"$.

== Hisoblaş bosqiçlari

*1-qadam: talab etiladigan kuçni aniqlaş*

Detalni vertikal kötarişda oğirlik kuçi:

$ F_"oğirlik" = M dot g = 15 "kg" dot 9.81 "m/s"^2 = 147.15 "N" $

Zaxira koeffitsientini hisobga olgan holda pnevmosilindr rivojlantirişi lozim bölgan minimal kuç:

$ F_"talab" = K_z dot F_"oğirlik" = 1.35 dot 147.15 "N" = 198.65 "N" $

*2-qadam: pnevmosilindr porşeni va ştogi diametrlarini aniqlaş*

Porşenning zaruriy effektiv yuzasi $A_1$:

$
  A_1 = F_"talab" / P_w = (198.65 "N") / (6 dot 10^5 "N/m"^2)
  = 3.31 dot 10^(-4) "m"^2 = 3.31 "cm"^2
$

Porşen diametri $D$:

$ D = sqrt((4 dot A_1) / pi) = sqrt((4 dot 3.31 dot 10^(-4)) / 3.1416) = 0.0205 "m" = 20.5 "mm" $

Standart ISO pnevmosilindrlar katalogidan eng yaqin yuqori standart diametr tanlanadi: $bold(D = 25 "mm" = 2.5 "cm")$. Standart ştok diametri: $bold(d = 10 "mm" = 1.0 "cm")$.

Qayta hisoblangan amaldagi yuzalar:

$ A_1 = (pi dot 2.5^2) / 4 = 4.91 "cm"^2 = 4.91 dot 10^(-4) "m"^2 $

$ A_2 = (pi dot (2.5^2 - 1.0^2)) / 4 = 4.12 "cm"^2 = 4.12 dot 10^(-4) "m"^2 $

Amaldagi maksimal kötariş kuçi:

$ F_"amaldagi" = P_w dot A_1 = 6 dot 10^5 "Pa" dot 4.91 dot 10^(-4) "m"^2 = 294.6 "N" $

*3-qadam: porşen harakat tezligi va havo sarfini hisoblaş*

Porşenning örtaça harakat tezligi:

$ v_"ört" = S / t_"harakat" = (0.25 "m") / (0.5 "s") = 0.50 "m/s" $

Bir töliq kötariş-tuşiriş siklida sarflanadigan havoning atmosfera hajmiga keltirilgan qiymati:

$
  V_"sikl" & = S dot (A_1 + A_2) dot (P_a + P_w) / P_a
             = 0.25 dot (4.91 + 4.12) dot 10^(-4) dot (1.0 + 6.0) / 1.0 \
           & = 1.58 dot 10^(-3) "m"^3 = 1.58 "litr"
$

Robot minutiga $n = 12$ marta işlaganda umumiy daqiqalik havo sarfi:

$ Q_"ört" = n dot V_"sikl" = 12 dot 1.58 "litr" = 18.96 "litr/min" = 0.01896 "m"^3"/min" $

= Hisoblaş natijalari va loyihalaş jadvali

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto, auto, auto, auto),
      align: (left, center, center, center),
      stroke: none,
      inset: (x: 5pt, y: 4pt),
      table.hline(stroke: 1pt),
      table.header([*Körsatkiç nomi*], [*Belgilanişi*], [*Hisoblangan qiymat*], [*Tanlangan standart qiymat*]),
      table.hline(stroke: 0.5pt),
      [Işçi havo bosimi], [$P_w$], [$6.0 "bar"$], [$6.0 "bar"$ (FRL)],
      [Yuklama kuçi], [$F_"oğirlik"$], [$147.15 "N"$], [---],
      [Zaruriy kuç (zaxira bilan)], [$F_"talab"$], [$198.65 "N"$], [---],
      [Porşen diametri], [$D$], [$20.5 "mm"$], [*$25.0 "mm"$ (ISO 6432)*],
      [Ştok diametri], [$d$], [$8.2 "mm"$], [*$10.0 "mm"$*],
      [Silindr yuriş masofasi], [$S$], [$250 "mm"$], [*$250 "mm"$*],
      [Amaldagi maksimal kuç], [$F_"amaldagi"$], [$294.6 "N"$], [$294.6 "N"$],
      [Örtaça harakat tezligi], [$v_"ört"$], [$0.50 "m/s"$], [$0.50 "m/s"$ (drossel)],
      [Bir sikldagi havo sarfi], [$V_"sikl"$], [$1.58 "litr/sikl"$], [---],
      [Daqiqalik havo sarfi], [$Q_"ört"$], [$18.96 "l/min"$], [*Kompressor $>= 25 "l/min"$*],
      [Pnevmotaqsimlagiç], [---], [5/2 solenoidli], [*G 1/8″* ($C_v >= 0.25$)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot pnevmoyuritmasini hisoblaş va tanlaş natijalari],
)

= Hisobot mazmuni va loyihalaş xulosasi

+ Hisoblaş natijalari böyiça pnevmosilindr diametri $D$, havo sarfi $Q$ hamda pnevmotaqsimlagiç parametri $C_v$ töğri tanlanganligini asoslaş.
+ Pnevmoyuritma dinamikasida keçikiş vaqtini ($t_d$) kamaytiriş uçun tezkor havo böşatuvçi klapanlardan (_quick exhaust valves_) va meter-out drossellaşdan foydalaniş samaradorligini tahlil qiliş.
+ Sanoat robotlari uşlaş mexanizmlarida havo bosimi tebranişlarining pozitsiyalaş aniqligiga taʼsirini baholaş.

= Nazorat savollari

+ Pnevmosilindr porşeni ($D$) va ştogi ($d$) diametrlarini hisoblaşda zaxira koeffitsienti ($K_z$) nima uçun kiritiladi?
+ Pnevmosilindrning bir töliq siklidagi siqilgan havo sarfi ($V_"sikl"$) atmosfera şaroitiga (STP) qanday keltirib hisoblanadi?
+ Pnevmoyuritma dinamikasida keçikiş vaqti ($t_d$ --- dead time) qaysi fizik omillarga boğliq va uni qanday kamaytiriş mumkin?
+ Pnevmotaqsimlagiç va drossellarning sarf koeffitsienti ($C_v$) pnevmosilindr harakat tezligiga qanday taʼsir körsatadi?
+ Resiver va FRL blokining pnevmatik tizim barqaror işlaşidagi asosiy vazifalari nimadan iborat?
