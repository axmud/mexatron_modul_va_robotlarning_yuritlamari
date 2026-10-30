// ============================================================
//  3-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_3.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Mexatron modul va robotlarning gidravlik yuritmalarini hisoblaş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 3  // amaliyot raqami
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

// Raqamlanmagan (LaTeX'dagi \[ \]) formula
#let eq(body) = math.equation(block: true, numbering: none, body)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №3]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Mexatron modul va robotlarning gidravlik yuritmalarini hisoblaş]
  #v(0.2cm)
  #text(size: 10pt)[(Manbalar asosida tuzilgan çuqurlaştirilgan öquv-amaliy körsatma)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi va tizimli yondaşuv

Sanoat robotlari hamda oğir yuk kötaruvçi mexatron modullarda gidravlik yuritmalar (_Hydraulic Drives_) eng muhim kuç beruvçi ijroçi tizimlar hisoblanadi. Gidravlik yuritmalarning asosiy afzalligi --- işçi suyuqlikning (gidravlik moyning) amalda siqilmasligi hamda yuqori işçi bosimda ($10 dots 30 "MPa"$ / $100 dots 300 "bar"$) işlaşi sababli *öta yuqori quvvat ziçligi (power density)* hamda *yuqori mexanik qattiqlik (high stiffness)* berişidir.

Uşbu amaliyot maşğulotining asosiy maqsadi:

- Mexatron modullar va robot böğinlarining dinamik yuklamalariga mos ravişda gidravlik ijro organlari (gidrosilindr va gidromotorlar) parametrlarini hisoblaş;
- Gidravlik quvvat stansiyasi, gidronasos unumdorligi (_flow rate_), işçi bosim hamda elektromotor quvvatini tanlaş va hisoblaş usullarini egallaş;
- Elektrogidravlik servoyuritmalar (_Electrohydraulic Servo Actuators_ --- EHA) va servotaqsimlagiçlarning (_servovalves_) dinamik ötiş jarayonlari hamda uzatiş funksiyalarini matematik modellaş;
- Gidravlik tizimning hajmiy hamda umumiy energetik *FIK*ini baholaş könikmalarini şakllantiriş.*

= Qisqaça nazariy maʼlumotlar va hisoblaş prinsiplari

Gidravlik yuritmalarni loyihalaş va hisoblaşda suyuqliklar gidromexanikasi, termodinamika va boşqariş nazariyasi qonuniyatlariga tayaniladi. _Electric Drives and Electromechanical Systems_ hamda _Robotics: Modelling, Planning and Control_ manbalarida taʼkidlanganidek, mexatronik tizimda drayver va ijroçi organni töğri hisoblaş tizimning barqarorligi va aniqligini taʼminlovçi poydevordir.

== Paskal qonuni va mexanik afzallik

Gidravlik tizimning işlaş prinsipi Paskal qonuniga asoslanadi: yopiq hajmda siqilmas suyuqlikka berilgan bosim ($P$) barça yönalişlarda özgarmas holda uzatiladi. Kiçik porşenga ($a$) berilgan $f$ kuçi orqali katta porşenda ($A$) $F$ kuçini hosil qiliş mumkin:

$ P = f / a = F / A quad ==> quad F = f dot A / a $

Bu prinsip gidravlik yuritmalarga ulkan mexanik afzallik (_mechanical advantage_) beradi.

== Gidrosilindr parametrlarini hisoblaş

Sanoat robotlarining çiziqli köçiş böğinlarida ikki taraflama taʼsir etuvçi gidrosilindrlar qöllaniladi. Porşenning oldinga surilişida (_extend stroke_) rivojlantiriladigan statik kuç $F_c$:

$ F_c = P_1 A_1 - P_2 A_2 - f_"işq" $

bunda:

- $P_1, P_2$ --- porşen va ştok kameralaridagi işçi va aks bosimlar (Pa yoki bar);
- $A_1 = (pi D^2) / 4$ --- porşenning töliq yuzasi ($D$ --- porşen diametri);
- $A_2 = (pi (D^2 - d^2)) / 4$ --- ştok kamerasining effektiv yuzasi ($d$ --- ştok diametri);
- $f_"işq"$ --- manjet va ziçlagiçlardagi işqalaniş kuçi ($f_"işq" approx (0.05 dots 0.1) dot F_"talab"$).

Porşenning ortga qaytişida (_retract stroke_) rivojlantiriladigan kuç $F_r$:

$ F_r = P_2 A_2 - P_1 A_1 - f_"işq" $

Tizim uçun talab etiladigan porşen diametri $D$ quyidagi formuladan aniqlanadi:

$ D = sqrt((4 dot F_"talab" dot K_z) / (pi dot P_w dot eta_m)) $

bunda $P_w$ --- tizimning işçi bosimi, $K_z = 1.2 dots 1.4$ --- zaxira koeffitsienti, $eta_m = 0.85 dots 0.95$ --- mexanik FIK. Ştok diametri $d$ esa böylama egilişga (_buckling_) va mustahkamlikka hisoblanib, odatda $d approx (0.5 dots 0.7) D$ oraliğida tanlanadi.

== Gidronasos va elektromotor quvvatini hisoblaş

Gidrosilindr porşenining harakat tezligi $V$ unga uzatilayotgan suyuqlik sarfiga ($Q$) boğliq ($V = Q \/ A_1$). Robotning barça böğinlari bir vaqtda harakatlanganda talab etiladigan maksimal suyuqlik sarfi $Q_"max"$:

$ Q_"max" = sum_(i=1)^m A_(1,i) dot V_(i,"max") dot K_"oqiş" $

bunda $K_"oqiş" approx 1.05 dots 1.1$ --- içki va taşqi oqişlarni hisobga oluvçi koeffitsient.

Gidronasosning işçi hajmi (_displacement volume_ $V_q$) va unumdorligi:

$ Q_"nasos" = V_q dot n dot eta_v dot 10^(-3) quad ["l/min"] $

bunda $n$ --- elektromotor valining aylanişlar soni (rpm), $eta_v = 0.90 dots 0.96$ --- nasosning hajmiy FIKi.

Gidravlik manba hosil qiladigan gidravlik quvvat $P_"gidro"$ va uni harakatga keltiruvçi elektromotor quvvati $P_"el"$:

$ P_"gidro" = (P_w dot Q_"nasos") / 600 quad ["kW"] $

$ P_"el" = P_"gidro" / eta_"tot" = (P_w dot Q_"nasos") / (600 dot eta_"tot") quad ["kW"] $

bunda $P_w$ --- bar, $Q_"nasos"$ --- l/min, $eta_"tot" = eta_v dot eta_m dot eta_g$ --- gidrotizimning umumiy FIKi ($eta_"tot" approx 0.75 dots 0.85$).

== Elektrogidravlik servoyuritmaning dinamik matematik modeli

_Robotics: Modelling, Planning and Control_ (Siciliano va boşq.) manbasiga muvofiq, servotaqsimlagiç va gidromotor/gidrosilindr kompleksi quyidagi dinamik muvozanat tenglamalari bilan ifodalanadi. Suyuqlik sarfi balansi:

$ Q = Q_m + Q_l + Q_c $

bunda:

- $Q_m = k_q dot Omega_m$ --- motorni harakatlantiruvçi foydali sarf ($k_q$ --- sarf koeffitsienti, $Omega_m$ --- burçak tezlik);
- $Q_l = k_l dot P$ --- içki va taşqi oqiş sarfi ($k_l$ --- oqiş koeffitsienti);
- $Q_c = gamma V (d P) / (d t)$ --- suyuqlik siqiluvçanligi hisobiga sarf ($gamma$ --- siqiluvçanlik koeffitsienti, $V$ --- kameradagi suyuqlik hajmi).

Servotaqsimlagiçning çiziqlaştirilgan sarf-bosim tenglamasi:

$ P = k_x X - k_r Q $

bunda $X$ --- servotaqsimlagiç zolotnigining siljişi, $k_x$ --- kuçaytiriş koeffitsienti, $k_r$ --- drossellaş qarşiligi.

Dinamik tenglamalarni Laplas almaştirişi orqali kompleks çastota sohasiga ötkazilsa, gidroyuritmaning uzatiş funksiyasi $W(s) = Theta_m (s) \/ X(s)$ ikkinçi tartibli tebranma böğin (va integrator) körinişida ifodalanadi.

= Gidravlik va servoyuritma sxemalari

== Mexatron modul elektrogidravlik yuritmasining prinsipial sxemasi

#figure(
  cetz.canvas(length: 1.05cm, {
    import cetz.draw: *

    let boxed(a, b, fill, body, size: 6.5pt) = {
      rect(a, b, fill: fill, stroke: 1pt)
      content(
        ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2),
        align(center, text(size: size, weight: "bold", body)),
      )
    }
    let small(body) = text(size: 6.5pt, weight: "bold", body)
    let arrow = (end: "stealth", fill: black)

    // Gidrosilindr
    rect((0, 4.0), (4.2, 5.2), fill: gray.lighten(85%), stroke: 1.6pt)
    rect((1.3, 4.05), (1.7, 5.15), fill: blue.lighten(60%), stroke: 1pt)
    rect((1.7, 4.45), (5.5, 4.75), fill: gray.lighten(40%), stroke: 1.6pt)
    content((2.1, 5.3), anchor: "south", text(size: 9pt, weight: "bold")[Robot böğini gidrosilindri ($D = 63 "mm"$)])

    // Ulanish chiziqlari (datchiklar ostida)
    line((0.7, 4.0), (0.7, 2.0), stroke: 1pt)
    line((3.5, 4.0), (3.5, 2.0), stroke: 1pt)

    // Bosim datchiklari
    boxed((0.3, 3.2), (1.1, 3.6), green.lighten(75%))[$P_1$]
    boxed((3.1, 3.2), (3.9, 3.6), green.lighten(75%))[$P_2$]

    // 4/3 servotaqsimlagich
    rect((0.0, 0.8), (4.2, 2.0), fill: blue.lighten(95%), stroke: 1pt)
    line((1.4, 0.8), (1.4, 2.0), stroke: (thickness: 1pt, dash: "dashed"))
    line((2.8, 0.8), (2.8, 2.0), stroke: (thickness: 1pt, dash: "dashed"))
    content((0.7, 1.4), align(center, small[P$->$B \ A$->$T]))
    content((2.1, 1.4), align(center, small[Yopiq \ (Closed)]))
    content((3.5, 1.4), align(center, small[P$->$A \ B$->$T]))
    content((4.3, 2.05), anchor: "south-west", text(
      size: 8pt,
      weight: "bold",
    )[4/3 elektrogidravlik \ servotaqsimlagiç])

    // Solenoidlar
    boxed((-1.1, 1.0), (0.0, 1.8), orange.lighten(55%))[Solenoid \ A]
    boxed((4.2, 1.0), (5.3, 1.8), orange.lighten(55%))[Solenoid \ B]

    // P va T liniyalari
    line((1.4, 0.8), (1.4, -0.2), stroke: 1pt)
    line((2.8, 0.8), (2.8, -0.2), (3.9, -0.2), (3.9, -2.15), (3.4, -2.15), stroke: 1pt, mark: arrow)
    content((1.5, 0.3), anchor: "west", small[P (bosim)])
    content((2.9, 0.3), anchor: "west", small[T (bak)])

    // Bosim saqlash klapani
    line((1.4, -0.2), (-0.5, -0.2), (-0.5, -1.2), stroke: 1pt)
    boxed((-1.0, -1.8), (0.0, -1.2), red.lighten(75%))[Saqlaş \ klapani]
    line((-0.5, -1.8), (-0.5, -2.5), stroke: 1pt, mark: arrow)
    content((-0.5, -2.6), anchor: "north", small[Bakka (T)])

    // Gidrobak
    rect((0.8, -2.5), (3.4, -1.8), fill: blue.lighten(88%), stroke: 1pt)
    line((1.4, -1.7), (1.4, -2.2), stroke: 1pt)
    content((2.3, -2.15), small[Gidrobak (moy)])

    // Gidronasos va elektromotor
    circle((1.4, -1.2), radius: 0.5, fill: yellow.lighten(65%), stroke: 1pt)
    content((1.4, -1.2), small[Nasos])
    line((1.4, -0.7), (1.4, -0.2), stroke: 1pt, mark: arrow)
    line((1.9, -1.2), (2.5, -1.2), stroke: 2pt)
    circle((2.9, -1.2), radius: 0.4, fill: gray.lighten(70%), stroke: 1pt)
    content((2.9, -1.2), align(center, small[Motor \ M]))
  }),
  caption: [Mexatron modul elektrogidravlik yuritmasining prinsipial sxemasi],
)

== Elektrogidravlik servoyuritmaning dinamik matematik blok-sxemasi

#figure(
  {
    set text(size: 7.5pt)
    let blk(body, sub) = align(center)[#body \ #text(size: 6pt, weight: "bold", sub)]
    diagram(
      node-stroke: 0.8pt,
      edge-stroke: 0.9pt,
      spacing: (5mm, 7mm),
      node-inset: 4pt,

      node((0, 0), $X(s)$, stroke: none),
      node((1, 0), $Sigma$, shape: circle, inset: 2pt),
      node((2, 0), blk($k_x / k_r$)[Sarf kuçayt.], fill: yellow.lighten(70%)),
      node((3, 0), $Sigma$, shape: circle, inset: 2pt),
      node((4, 0), blk($1 / (s k_c)$)[Siqiluvçanlik], fill: orange.lighten(70%)),
      node((5, 0), blk($k_t$)[Moment], fill: green.lighten(75%)),
      node((6, 0), $Sigma$, shape: circle, inset: 2pt),
      node((7, 0), blk($1 / (s I_m + F_m)$)[Inersiya], fill: blue.lighten(75%)),
      node((8, 0), blk($1 / s$)[Integrator], fill: gray.lighten(70%)),
      node((9, 0), $Theta_m (s)$, stroke: none),

      // Toʻgʻri zanjir
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>", label: $Q$),
      edge((3, 0), (4, 0), "-|>", label: $Q_c$),
      edge((4, 0), (5, 0), "-|>", label: $P$),
      edge((5, 0), (6, 0), "-|>", label: $C_m$),
      edge((6, 0), (7, 0), "-|>"),
      edge((7, 0), (8, 0), "-|>", label: $Omega_m$),
      edge((8, 0), (9, 0), "-|>"),

      // Tashqi yuklama momenti
      edge((6, 1), (6, 0), "-|>", label: $-C_l$, label-side: right, label-pos: 0.2),

      // Qayta aloqalar
      edge((4.5, 0), (4.5, 1), (3, 1), (3, 0), "-|>", label: $-k_l$, label-pos: 0.5, label-side: left),
      edge((4.5, 0), (4.5, 2), (1, 2), (1, 0), "-|>", label: $-1 \/ k_x$, label-pos: 0.5, label-side: left),
      edge((7.5, 0), (7.5, -1), (3, -1), (3, 0), "-|>", label: $-k_q$, label-pos: 0.5, label-side: right),
    )
  },
  caption: [Elektrogidravlik servoyuritmaning dinamik blok-sxemasi (Siciliano va boşq. modeli). $C_l$ --- taşqi yuklama momenti],
)

= Amaliy hisoblaş misoli (sanoat roboti böğinini hisoblaş)

== Bosqiçma-bosqiç hisoblaş topşiriği

Sanoat roboti oğir detalni ($M_L = 2500 "kg"$) vertikal tekislikda kötaruvçi gidrosilindr va gidravlik manbani hisoblaş talab etiladi.

*Boşlanğiç berilgan maʼlumotlar:*

- Yuklama massasi: $M_L = 2500 "kg"$;
- Porşenning köçiş masofasi (stroke): $S = 0.5 "m"$;
- Kötariş vaqti: $t = 2.5 "s" ==>$ harakat tezligi $V = S \/ t = 0.2 "m/s"$;
- Tizimning nominal işçi bosimi: $P_w = 150 "bar" = 15 dot 10^6 "Pa"$;
- Aks bosim: $P_2 = 10 "bar" = 1.0 dot 10^6 "Pa"$;
- Mexanik FIK: $eta_m = 0.90$, hajmiy FIK: $eta_v = 0.92$, tizim FIK: $eta_"tot" = 0.82$.

== Hisoblaş bosqiçlari va natijalari

*1-bosqiç: statik va dinamik kötariş kuçini aniqlaş.*

Kötariş vaqtidagi oğirlik kuçi:

#eq($ F_"oğirlik" = M_L dot g = 2500 dot 9.81 = 24525 "N" = 24.525 "kN" $)

Dinamik tezlaniş kuçi ($a_p = 0.5 "m/s"^2$ deb olinsa):

#eq($ F_"din" = M_L dot a_p = 2500 dot 0.5 = 1250 "N" = 1.25 "kN" $)

Manjetlardagi işqalaniş kuçi ($f_"işq" approx 0.08 dot F_"oğirlik"$):

#eq($ f_"işq" = 0.08 dot 24525 = 1962 "N" $)

Jami talab etiladigan keltirilgan kuç:

#eq($ F_"talab" = F_"oğirlik" + F_"din" + f_"işq" = 24525 + 1250 + 1962 = 27737 "N" = 27.737 "kN" $)

*2-bosqiç: gidrosilindr porşeni va ştok diametrini aniqlaş.*

Zaxira koeffitsienti $K_z = 1.25$ deb olib, porşen yuzasini hisoblaymiz:

#eq(
  $
    A_1 = (F_"talab" dot K_z) / (P_w dot eta_m) = (27737 dot 1.25) / (15 dot 10^6 dot 0.90)
    = 2.568 dot 10^(-3) "m"^2 = 25.68 "cm"^2
  $,
)

Porşen diametri $D$:

#eq($ D = sqrt((4 A_1) / pi) = sqrt((4 dot 2.568 dot 10^(-3)) / 3.14159) = 0.05718 "m" = 57.18 "mm" $)

ISO 6020 standartiga köra, eng yaqin kattaroq standart porşen diametri *$D = 63 "mm"$* ($0.063 "m"$) deb tanlanadi. Standart porşen yuzasi:

#eq($ A_(1,"st") = (pi dot 0.063^2) / 4 = 3.117 dot 10^(-3) "m"^2 = 31.17 "cm"^2 $)

Ştok diametri $d approx 0.6 dot D = 0.6 dot 63 = 37.8 "mm" ==>$ standart *$d = 36 "mm"$* deb tanlanadi. Ştok yuzasi:

#eq($ A_s = (pi dot 0.036^2) / 4 = 1.018 dot 10^(-3) "m"^2 $)

Ştok kamerasining effektiv yuzasi:

#eq($ A_2 = A_1 - A_s = (3.117 - 1.018) dot 10^(-3) = 2.099 dot 10^(-3) "m"^2 $)

*3-bosqiç: suyuqlik sarfi va gidronasosni tanlaş.*

Gidrosilindr kötarilişida talab etiladigan suyuqlik sarfi $Q_"silindr"$:

#eq($ Q_"silindr" = A_(1,"st") dot V = 3.117 dot 10^(-3) "m"^2 dot 0.2 "m/s" = 6.234 dot 10^(-4) "m"^3"/s" $)

Daqiqalik sarf:

#eq($ Q_"silindr" = 6.234 dot 10^(-4) dot 60000 = 37.40 "l/min" $)

Oqişlar koeffitsienti $K_"oqiş" = 1.1$ va nasosning hajmiy FIKi $eta_v = 0.92$ hisobga olinsa, gidronasos unumdorligi $Q_"nasos"$:

#eq($ Q_"nasos" = (Q_"silindr" dot K_"oqiş") / eta_v = (37.40 dot 1.1) / 0.92 = 44.72 "l/min" $)

Elektromotor aylanişlar soni $n = 1450 "rpm"$ bölganda, nasosning işçi hajmi $V_q$:

#eq($ V_q = (Q_"nasos" dot 1000) / n = (44.72 dot 1000) / 1450 = 30.84 "cm"^3"/rev" $)

Katalogdan standart *$V_q = 32 "cm"^3"/rev"$* porşenli/tişli gidronasos tanlanadi.

*4-bosqiç: elektromotor quvvatini hisoblaş.*

Gidravlik manba hosil qiladigan quvvat $P_"gidro"$:

#eq($ P_"gidro" = (P_w dot Q_"nasos") / 600 = (150 dot 44.72) / 600 = 11.18 "kW" $)

Tizimning umumiy FIKi $eta_"tot" = 0.82$ bölganda, elektromotor quvvati $P_"el"$:

#eq($ P_"el" = P_"gidro" / eta_"tot" = 11.18 / 0.82 = 13.63 "kW" $)

Katalogdan nominal quvvati *$P_"nom" = 15.0 "kW"$* bölgan uç fazali asinxron elektromotor tanlanadi.

= Hisoblaş natijalari va qiyosiy jadvallar

#heading(level: 2, numbering: none)[1-jadval: sanoat roboti gidroyuritmasini hisoblaş natijalari]

#figure(
  {
    set text(size: 10pt)
    table(
      columns: 4,
      align: (left, center, center, center),
      stroke: none,
      inset: (x: 6pt, y: 4pt),
      table.hline(stroke: 1pt),
      table.header([*Parametr nomi*], [*Belgilanişi*], [*Hisoblangan qiymat*], [*Standart tanlangan*]),
      table.hline(stroke: 0.5pt),
      [Porşen diametri], [$D$], [$57.18 "mm"$], [$63.0 "mm"$],
      [Ştok diametri], [$d$], [$37.80 "mm"$], [$36.0 "mm"$],
      [Porşen yuzasi], [$A_1$], [$25.68 "cm"^2$], [$31.17 "cm"^2$],
      [Suyuqlik sarfi], [$Q_"silindr"$], [$37.40 "l/min"$], [$37.40 "l/min"$],
      [Nasos unumdorligi], [$Q_"nasos"$], [$44.72 "l/min"$], [$46.40 "l/min"$],
      [Nasos işçi hajmi], [$V_q$], [$30.84 "cm"^3"/rev"$], [$32.0 "cm"^3"/rev"$],
      [Elektromotor quvvati], [$P_"el"$], [$13.63 "kW"$], [$15.0 "kW"$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Gidrosilindr va gidronasosning hisoblangan standart parametrlari],
)

#heading(level: 2, numbering: none)[2-jadval: robot yuritmalari turlarining qiyosiy texnik körsatkiçlari]

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (3.6cm, 1fr, 1fr, 1fr),
      align: (left + horizon, center + horizon, center + horizon, center + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Texnik körsatkiç*], [*Elektr yuritma*], [*Gidravlik yuritma*], [*Pnevmatik yuritma*]),
      table.hline(stroke: 0.5pt),
      [Quvvat/massa nisbati],
      [Örta \ ($0.5 dots 1.5 "kW/kg"$)], [Yuqori \ ($5 dots 10 "kW/kg"$)], [Past \ ($0.2 dots 0.5 "kW/kg"$)],
      [Maksimal işçi bosim],
      [---], [$10 dots 30 "MPa"$ \ ($100 dots 300 "bar"$)], [$0.4 dots 0.8 "MPa"$ \ ($4 dots 8 "bar"$)],
      [Tizim qattiqligi],
      [Yuqori (reduktorli)], [Juda yuqori (siqilmas)], [Past (gaz siqiluvçan)],
      [Pozitsiyalaş aniqligi],
      [$plus.minus 0.01 "mm"$], [$plus.minus 0.05 "mm"$], [$plus.minus 1 dots 2 "mm"$],
      [Ötkaziş polosasi (bandwidth)],
      [Yuqori \ ($100 dots 500 "Hz"$)], [Örta \ ($50 dots 150 "Hz"$)], [Past \ ($10 dots 30 "Hz"$)],
      [Tizimning umumiy FIKi],
      [$80 dots 90%$], [$70 dots 82%$], [$30 dots 45%$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Elektr, gidravlik va pnevmatik yuritmalarning soliştirma tahlili],
)

= Hisobot mazmuni va nazorat savollari

Amaliyot maşğuloti hisobotida talabalar hisoblaş bosqiçlarini töliq bayon etişlari, hisoblangan va standart tanlangan parametrlarni asoslab berişlari hamda quyidagi nazorat savollariga javob berişlari lozim:

+ Gidravlik yuritmalarning pnevmatik va elektr yuritmalarga nisbatan oğir yuk kötaruvçi robotlarda qöllanişining asosiy sabablari va afzalliklari nimada?
+ Paskal qonuni gidravlik yuritmalarda mexanik afzallikni (_mechanical advantage_) qanday taʼminlaydi?
+ Gidrosilindr porşen ($D$) va ştok ($d$) diametrlari qaysi mezonlarga köra hisoblanadi va zaxira koeffitsienti ($K_z$) nimani anglatadi?
+ Elektrogidravlik servoyuritmaning sarf-bosim dinamik tenglamasida suyuqlik siqiluvçanligi ($Q_c$) va oqişlar ($Q_l$) qanday hisobga olinadi?
+ Gidronasos unumdorligi ($Q_"nasos"$) hamda elektromotor quvvatini ($P_"el"$) hisoblaş formulalarini va FIK koeffitsientlarining taʼsirini tuşuntiring.
