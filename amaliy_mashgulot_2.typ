// ============================================================
//  2-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_2.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robotlarning pnevmoyuritmasini hisoblash prinsipi")
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
#set text(size: 12pt, lang: "uz")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №2]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Robotlarning pnevmoyuritmasini hisoblash prinsipi]
  #v(0.2cm)
  #text(size: 10pt)[(Mexatron modullar va sanoat robotlarining pnevmatik tizimlarini loyihalash hamda hisoblash)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

- Sanoat robotlari hamda mexatronik manipulyatorlarning pnevmoyuritmalarini loyihalash va hisoblashning nazariy hamda amaliy tamoyillarini egallash.
- Pnevmosilindrlarning statik va dinamik kuchlarini, porshen diametrini ($D$), shtok diametrini ($d$), harakat tezligini ($v$) hamda siqilgan havo sarfini ($Q$) hisoblash usullarini oʻrganish.
- Boshqaruv pnevmoapparatlari (taqsimlagich, drossel, FRL bloki), siqilgan havo resiveri va magistral quvurlar oʻlchamlarini toʻgʻri tanlash koʻnikmalarini shakllantirish.

= Robotlar pnevmoyuritmalariga qoʻyiladigan talablar va uning tuzilishi

Sanoat robotlarining ushlash mexanizmlari (gripper), buyumlarni uzatish hamda pozitsiyalash modullarida pnevmoyuritmalar harakatlanuvchi qismlarining kichik massasi, ixcham tuzilishi va yuqori kuch berish imkoniyati tufayli keng qoʻllaniladi. Pnevmoyuritmalar elektr va gidravlik yuritmalar bilan solishtirilganda past ogʻirlik hamda yuqori quvvat/massa nisbatiga ega.

Biroq, siqilgan havoning siqiluvchanligi (_compressibility_) va harorat oʻzgarishlariga taʼsirchanligi tufayli pnevmoyuritmalar past mexanik qattiqlikka (_stiffness_) ega. Shu sababli, robotlarning pnevmoyuritmalarini hisoblashda statik kuchlar bilan birga dinamik oʻtish jarayonlari, kechikish vaqti (_dead time_) va havo sarfi aniq hisobga olinishi lozim.

Pnevmatik yuritma tizimi quyidagi asosiy unsurlardan tashkil topadi:

+ *Siqilgan havo manbai va tayyorlash bloki (FRL):* kompressor, resiver hamda filtr, bosim reduktori (_pressure regulator_) va moylagichdan (_lubricator_) iborat FRL bloki.
+ *Boshqaruv va rostlash apparaturasi:* yoʻnaltiruvchi pnevmotaqsimlagich (_directional control valve_ --- 5/2 yoki 3/2-yoʻlli), teskari klapanli drossellar.
+ *Ijro organlari:* ikki taraflama yoki bir taraflama taʼsir etuvchi pnevmosilindrlar, pnevmatik burish dvigatellari va pnevmo-muskullar.

= Pnevmosilindrning statik va dinamik kuch hisob-kitoblari

== Statik kuch hisobi (porshen va shtok diametrlarini aniqlash)

Pnevmosilindr porshenining oldinga surilishida (_extend_) rivojlantiriladigan nazariy statik kuch ($F_c$) Paskal qonuniga koʻra ishchi havo bosimi ($P_w$) va porshen yuzasiga ($A$) bogʻliq:

$ F_c = P_w dot A = P_w dot (pi D^2) / 4 $

Porshenning ortga qaytishida (_retract_) shtok egallagan yuza hisobiga effektiv yuza kamayadi ($A_a = A - a$), natijada ortga qaytish kuchi ($F_r$) quyidagicha aniqlanadi:

$ F_r = P_w dot A_a = P_w dot (pi (D^2 - d^2)) / 4 $

bunda $D$ --- pnevmosilindr porshenining diametri, $d$ --- shtok diametri. Odatiy pnevmosilindrlarda $d approx (0.3 dots 0.4) D$ nisbatda olinadi.

Real ish sharoitida manjetlardagi va yoʻnaltiruvchilardagi ishqalanish kuchlari hamda yuklama tebranishlarini hisobga olish uchun zaxira koeffitsienti ($K_z = 1.25 dots 1.5$) kiritiladi. Robot ushlash mexanizmi yoki yuritmasi talab qiladigan zaruriy kuch $F_"talab"$ boʻlganda, porshenning effektiv yuzasi $A$ quyidagicha hisoblanadi:

$
  A >= (K_z dot F_"talab") / P_w quad ==> quad
  D >= sqrt((4 dot K_z dot F_"talab") / (pi dot P_w))
$

Pnevmoyuritmaning mexanik foydali ish koeffitsienti (FIK):

$ eta = F_"amaldagi" / F_"nazariy" dot 100% $

Sanoat pnevmosilindrlarida mexanik FIK qiymati odatda $eta = 85 dots 95%$ oraligʻida boʻladi.

== Pnevmosilindr dinamikasi va harakat tenglamasi

Robot boʻgʻinini yoki yukni harakatlantirishda Nyutonning ikkinchi qonuniga muvofiq dinamik kuchlar muvozanati tenglamasi quyidagicha yoziladi:

$ M dot a_p = P_1 A_1 - P_2 A_2 - F_"yuk" - f_"ishq" $

bunda:

- $M$ --- harakatlanuvchi qismlarning keltirilgan toʻliq massasi ($M = M_"porshen" + M_"shtok" + M_"yuk"$);
- $a_p = (d^2 x) / (d t^2)$ --- porshenning chiziqli tezlanishi;
- $P_1, P_2$ --- mos ravishda kirish va chiqish kameralaridagi vaqtga bogʻliq bosimlar;
- $F_"yuk"$ --- tashqi mexanik yuklama kuchi (vertikal koʻtarishda $F_"yuk" = M g$);
- $f_"ishq"$ --- manjetlar va yoʻnaltiruvchilardagi quruq va yopishqoq ishqalanish kuchi.

Pnevmoyuritma harakatining toʻliq siklida uchta asosiy dinamik bosqich kuzatiladi:

+ *Kechikish vaqti ($t_d$ --- Dead Time):* taqsimlagich solenoidiga signal berilgandan soʻng, kirish kamerasidagi bosim $P_1$ yuklama va ishqalanish kuchlarini yengish uchun yetarli darajaga yetguncha hamda chiqish kamerasidagi bosim $P_2$ kamayguncha ketgan vaqt.
+ *Tezlanish bosqichi ($t_a$):* porshen harakatlana boshlab, maksimal tezlikka ($v_"max"$) erishguncha boʻlgan vaqt oraligʻi.
+ *Barqaror harakat bosqichi ($t_v$):* drossellash orqali havo sarfi cheklangan holda porshenning oʻzgarmas tezlikda ($v$) harakatlanish bosqichi.

= Havo sarfi va kompressor unumdorligini hisoblash

Pnevmosilindr bir marta toʻliq borganda va qaytganda (bir toʻliq siklda) sarflanadigan siqilgan havo hajmi Boyl–Mariott qonuniga koʻra standart atmosfera sharoitiga (STP --- _Standard Temperature and Pressure_, $P_a = 1.013 "bar"$) keltirib hisoblanadi:

$ V_"sikl" = S dot (A_1 + A_2) dot (P_a + P_w) / P_a $

bunda $S$ --- pnevmosilindrning toʻliq yurish masofasi (_stroke_), $P_w$ --- manometrik ishchi bosim (bar).

Robot pnevmoyuritmasi minutiga $n$ marta toʻliq siklni bajarsa, oʻrtacha daqiqalik havo sarfi ($Q_"oʻrt"$) quyidagicha aniqlanadi:

$
  Q_"oʻrt" = n dot V_"sikl" = n dot S dot (A_1 + A_2) dot (P_a + P_w) / P_a
  quad ["litr/min" "yoki" "m"^3"/min"]
$

Kompressorning talab etiladigan samarali unumdorligi ($Q_"kompressor"$) tizimdagi mumkin boʻlgan havo sizib chiqishlarini (_leakage_) hisobga olgan holda zaxira koeffitsienti ($K_"siz" = 1.15 dots 1.25$) bilan hisoblanadi:

$ Q_"kompressor" >= K_"siz" dot sum Q_"oʻrt" $

= Pnevmatizim elementlarini tanlash va hisoblash

== Pnevmotaqsimlagich va drossellarni tanlash (sarf koeffitsienti $C_v$)

Pnevmotaqsimlagich va tezlikni drossellash klapanlaridan oʻtayotgan havo sarfi klapanning shartli oʻtish teshigi diametri ($d_n$) hamda sarf koeffitsientiga ($C_v$) bogʻliq. Subsonik oqim uchun ($P_2 > 0.53 P_1$) taxminiy ifoda:

$ Q_N approx 400 dot C_v dot sqrt(Delta P dot P_2) quad ["Nl/min"] $

bunda $Delta P = P_1 - P_2$ --- klapandagi bosim tushishi (bar), $P_2$ --- klapan chiqishidagi absolyut bosim (bar). Pnevmotaqsimlagich pnevmosilindrga havo yetkazib berishda ortiqcha bosim tushishiga olib kelmasligi uchun uning oʻtish yuzasi quvur yuzasidan kichik boʻlmasligi lozim.

== Siqilgan havo resiveri hajmini hisoblash

Resiver siqilgan havo bosimi tebranishlarini silliqlaydi va kompressor toʻxtab turganda energiya zaxirasini taʼminlaydi. Resiverning minimal hajmi ($V_"resiver"$) Boyl–Mariott tenglamasiga koʻra quyidagicha aniqlanadi:

$ V_"resiver" = (Q_"kompressor" dot P_a dot T_"sikl") / (Delta P_"ruxsat") $

bunda $Delta P_"ruxsat" = P_"max" - P_"min"$ --- resiverda ruxsat etilgan bosim tebranishi diapazoni ($0.5 dots 1.0 "bar"$), $T_"sikl"$ --- kompressorning yoqilish/oʻchish sikli vaqti.

= Pnevmatik va hisoblash sxemalari

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
    content((3.6, 1.55), anchor: "south-west", text(size: 8pt, weight: "bold")[5/2 Pnevmotaqsimlagich])

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
      FRL bloki \ (Filtr–Reduktor–Moylagich)
    ]
    line((1.75, -2.2), (1.75, -1.5), stroke: 1pt, mark: arrow)
    content((1.75, -2.3), anchor: "north", text(size: 8pt, weight: "bold")[Resiver va kompressor ($P_"komp"$)])
  }),
  caption: [Robot pnevmoyuritmasining hisoblash va boshqaruv pnevmatik sxemasi],
)

== Pnevmosilindr dinamik oʻtish jarayoni va vaqt diagrammasi

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
    content((1.0, 2.0), angle: 90deg, text(fill: red, size: 7pt, weight: "bold")[Kechikish $t_d$])

    // P1(t) — kirish kamerasi
    let p1 = (paint: green.darken(35%), thickness: 2pt)
    line((0, 0), (0.3, 0.3), stroke: p1)
    bezier((0.3, 0.3), (1.2, 3.2), (0.6, 3.8), stroke: p1)
    line((1.2, 3.2), (2.0, 3.6), (5.0, 3.6), stroke: p1)
    content((5.05, 3.6), anchor: "west", small[$P_1(t)$ (kirish bosimi)])

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
    for (x, lab) in ((0, $0$), (1.2, $t_d$), (2.2, $t_a$), (4.2, $t_v$), (4.8, $t_"toʻliq"$)) {
      content((x, -0.1), anchor: "north", small(lab))
    }
  }),
  caption: [Pnevmosilindr kameralaridagi bosimlar va porshen tezligining vaqt boʻyicha oʻtish diagrammasi],
)

= Amaliy hisoblash misoli (sanoat roboti ushlagichi yuritmasi)

== Masalaning qoʻyilishi

Sanoat roboti ushlash mexanizmi (gripper) vertikal yoʻnalishda $M = 15 "kg"$ massali detalni $S = 250 "mm" = 0.25 "m"$ masofaga $t_"harakat" = 0.5 "s"$ vaqt ichida koʻtarishi lozim.

- Ishchi manometrik bosim: $P_w = 6 "bar" = 6 dot 10^5 "Pa"$;
- Zaxira koeffitsienti: $K_z = 1.35$;
- Robot minutiga $n = 12$ marta koʻtarish-tushirish siklini bajaradi;
- Atmosfera bosimi: $P_a = 1.0 "bar"$.

== Hisoblash bosqichlari

*1-qadam: talab etiladigan kuchni aniqlash*

Detalni vertikal koʻtarishda ogʻirlik kuchi:

$ F_"ogʻirlik" = M dot g = 15 "kg" dot 9.81 "m/s"^2 = 147.15 "N" $

Zaxira koeffitsientini hisobga olgan holda pnevmosilindr rivojlantirishi lozim boʻlgan minimal kuch:

$ F_"talab" = K_z dot F_"ogʻirlik" = 1.35 dot 147.15 "N" = 198.65 "N" $

*2-qadam: pnevmosilindr porsheni va shtogi diametrlarini aniqlash*

Porshenning zaruriy effektiv yuzasi $A_1$:

$
  A_1 = F_"talab" / P_w = (198.65 "N") / (6 dot 10^5 "N/m"^2)
  = 3.31 dot 10^(-4) "m"^2 = 3.31 "cm"^2
$

Porshen diametri $D$:

$ D = sqrt((4 dot A_1) / pi) = sqrt((4 dot 3.31 dot 10^(-4)) / 3.1416) = 0.0205 "m" = 20.5 "mm" $

Standart ISO pnevmosilindrlar katalogidan eng yaqin yuqori standart diametr tanlanadi: $bold(D = 25 "mm" = 2.5 "cm")$. Standart shtok diametri: $bold(d = 10 "mm" = 1.0 "cm")$.

Qayta hisoblangan amaldagi yuzalar:

$ A_1 = (pi dot 2.5^2) / 4 = 4.91 "cm"^2 = 4.91 dot 10^(-4) "m"^2 $

$ A_2 = (pi dot (2.5^2 - 1.0^2)) / 4 = 4.12 "cm"^2 = 4.12 dot 10^(-4) "m"^2 $

Amaldagi maksimal koʻtarish kuchi:

$ F_"amaldagi" = P_w dot A_1 = 6 dot 10^5 "Pa" dot 4.91 dot 10^(-4) "m"^2 = 294.6 "N" $

*3-qadam: porshen harakat tezligi va havo sarfini hisoblash*

Porshenning oʻrtacha harakat tezligi:

$ v_"oʻrt" = S / t_"harakat" = (0.25 "m") / (0.5 "s") = 0.50 "m/s" $

Bir toʻliq koʻtarish-tushirish siklida sarflanadigan havoning atmosfera hajmiga keltirilgan qiymati:

$
  V_"sikl" & = S dot (A_1 + A_2) dot (P_a + P_w) / P_a
             = 0.25 dot (4.91 + 4.12) dot 10^(-4) dot (1.0 + 6.0) / 1.0 \
           & = 1.58 dot 10^(-3) "m"^3 = 1.58 "litr"
$

Robot minutiga $n = 12$ marta ishlaganda umumiy daqiqalik havo sarfi:

$ Q_"oʻrt" = n dot V_"sikl" = 12 dot 1.58 "litr" = 18.96 "litr/min" = 0.01896 "m"^3"/min" $

= Hisoblash natijalari va loyihalash jadvali

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto, auto, auto, auto),
      align: (left, center, center, center),
      stroke: none,
      inset: (x: 5pt, y: 4pt),
      table.hline(stroke: 1pt),
      table.header([*Koʻrsatkich nomi*], [*Belgilanishi*], [*Hisoblangan qiymat*], [*Tanlangan standart qiymat*]),
      table.hline(stroke: 0.5pt),
      [Ishchi havo bosimi], [$P_w$], [$6.0 "bar"$], [$6.0 "bar"$ (FRL)],
      [Yuklama kuchi], [$F_"ogʻirlik"$], [$147.15 "N"$], [---],
      [Zaruriy kuch (zaxira bilan)], [$F_"talab"$], [$198.65 "N"$], [---],
      [Porshen diametri], [$D$], [$20.5 "mm"$], [*$25.0 "mm"$ (ISO 6432)*],
      [Shtok diametri], [$d$], [$8.2 "mm"$], [*$10.0 "mm"$*],
      [Silindr yurish masofasi], [$S$], [$250 "mm"$], [*$250 "mm"$*],
      [Amaldagi maksimal kuch], [$F_"amaldagi"$], [$294.6 "N"$], [$294.6 "N"$],
      [Oʻrtacha harakat tezligi], [$v_"oʻrt"$], [$0.50 "m/s"$], [$0.50 "m/s"$ (drossel)],
      [Bir sikldagi havo sarfi], [$V_"sikl"$], [$1.58 "litr/sikl"$], [---],
      [Daqiqalik havo sarfi], [$Q_"oʻrt"$], [$18.96 "l/min"$], [*Kompressor $>= 25 "l/min"$*],
      [Pnevmotaqsimlagich], [---], [5/2 solenoidli], [*G 1/8″* ($C_v >= 0.25$)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot pnevmoyuritmasini hisoblash va tanlash natijalari],
)

= Hisobot mazmuni va loyihalash xulosasi

+ Hisoblash natijalari boʻyicha pnevmosilindr diametri $D$, havo sarfi $Q$ hamda pnevmotaqsimlagich parametri $C_v$ toʻgʻri tanlanganligini asoslash.
+ Pnevmoyuritma dinamikasida kechikish vaqtini ($t_d$) kamaytirish uchun tezkor havo boʻshatuvchi klapanlardan (_quick exhaust valves_) va meter-out drossellashdan foydalanish samaradorligini tahlil qilish.
+ Sanoat robotlari ushlash mexanizmlarida havo bosimi tebranishlarining pozitsiyalash aniqligiga taʼsirini baholash.

= Nazorat savollari

+ Pnevmosilindr porsheni ($D$) va shtogi ($d$) diametrlarini hisoblashda zaxira koeffitsienti ($K_z$) nima uchun kiritiladi?
+ Pnevmosilindrning bir toʻliq siklidagi siqilgan havo sarfi ($V_"sikl"$) atmosfera sharoitiga (STP) qanday keltirib hisoblanadi?
+ Pnevmoyuritma dinamikasida kechikish vaqti ($t_d$ --- dead time) qaysi fizik omillarga bogʻliq va uni qanday kamaytirish mumkin?
+ Pnevmotaqsimlagich va drossellarning sarf koeffitsienti ($C_v$) pnevmosilindr harakat tezligiga qanday taʼsir koʻrsatadi?
+ Resiver va FRL blokining pnevmatik tizim barqaror ishlashidagi asosiy vazifalari nimadan iborat?
