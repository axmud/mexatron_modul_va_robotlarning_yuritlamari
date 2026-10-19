// ============================================================
//  1-2-TAJRIBA MASHGʻULOTI (2-QISM)  —  tashqi paketsiz
//  Kompilyatsiya:  typst compile tajriba-1-2-qism2.typ
// ============================================================

// ---------- Chizma yordamchisi (mini-CeTZ) ----------
// Foydalanuvchi koordinatalari (cm), y yuqoriga qarab oʻsadi — TikZ kabi.
// ux / uy — TikZʼdagi x=..., y=... masshtablari.
#let sxema(
  xmin: 0,
  xmax: 10,
  ymin: 0,
  ymax: 10,
  ux: 1cm,
  uy: 1cm,
  draw,
) = {
  let px(x) = (x - xmin) * ux
  let py(y) = (ymax - y) * uy

  let d = (
    // Toʻrtburchak
    R: (a, b, fl: none, st: 1pt + black) => place(
      dx: px(calc.min(a.at(0), b.at(0))),
      dy: py(calc.max(a.at(1), b.at(1))),
      rect(
        width: calc.abs(b.at(0) - a.at(0)) * ux,
        height: calc.abs(b.at(1) - a.at(1)) * uy,
        fill: fl,
        stroke: st,
      ),
    ),
    // Siniq chiziq
    L: (..pts, st: 1pt + black) => {
      let p = pts.pos()
      for i in range(p.len() - 1) {
        place(line(
          start: (px(p.at(i).at(0)), py(p.at(i).at(1))),
          end: (px(p.at(i + 1).at(0)), py(p.at(i + 1).at(1))),
          stroke: st,
        ))
      }
    },
    // Kubik Bezye egri chizigʻi (TikZ: .. controls c1 and c2 ..)
    B: (p0, c1, c2, p1, st: 1pt + black) => place(curve(
      stroke: st,
      curve.move((px(p0.at(0)), py(p0.at(1)))),
      curve.cubic(
        (px(c1.at(0)), py(c1.at(1))),
        (px(c2.at(0)), py(c2.at(1))),
        (px(p1.at(0)), py(p1.at(1))),
      ),
    )),
    // Matn. at: center+bottom -> nuqta ustida, center+top -> ostida,
    //          right+horizon -> chapida,  left+horizon -> oʻngida
    T: (p, body, at: center + horizon) => {
      let W = 8cm
      let H = 2cm
      let dx = if at.x == left { px(p.at(0)) } else if at.x == right {
        px(p.at(0)) - W
      } else { px(p.at(0)) - W / 2 }
      let dy = if at.y == top { py(p.at(1)) } else if at.y == bottom {
        py(p.at(1)) - H
      } else { py(p.at(1)) - H / 2 }
      place(dx: dx, dy: dy, box(width: W, height: H, align(at, body)))
    },
    // Doira (radius foydalanuvchi birligida)
    C: (p, r, fl: white, st: 1pt + black) => place(
      dx: px(p.at(0)) - r * ux,
      dy: py(p.at(1)) - r * uy,
      ellipse(width: 2 * r * ux, height: 2 * r * uy, fill: fl, stroke: st),
    ),
    // Nuqta (radius ptʼda)
    P: (p, r, fl: black) => place(
      dx: px(p.at(0)) - r,
      dy: py(p.at(1)) - r,
      circle(radius: r, fill: fl, stroke: none),
    ),
    // Strelka uchi: "up" | "down" | "left" | "right"
    A: (p, dir, fl: black) => {
      let s = 4pt
      let x = px(p.at(0))
      let y = py(p.at(1))
      if dir == "up" {
        place(dx: x - s, dy: y, polygon(fill: fl, stroke: none, (s, 0pt), (0pt, 2 * s), (2 * s, 2 * s)))
      } else if dir == "down" {
        place(dx: x - s, dy: y - 2 * s, polygon(fill: fl, stroke: none, (0pt, 0pt), (2 * s, 0pt), (s, 2 * s)))
      } else if dir == "right" {
        place(dx: x - 2 * s, dy: y - s, polygon(fill: fl, stroke: none, (0pt, 0pt), (0pt, 2 * s), (2 * s, s)))
      } else {
        place(dx: x, dy: y - s, polygon(fill: fl, stroke: none, (0pt, s), (2 * s, 0pt), (2 * s, 2 * s)))
      }
    },
    // Toʻr (grid)
    G: (a, b, step: 0.5, st: 0.4pt + gray.lighten(35%)) => {
      let x = a.at(0)
      while x <= b.at(0) + 0.001 {
        place(line(start: (px(x), py(a.at(1))), end: (px(x), py(b.at(1))), stroke: st))
        x = x + step
      }
      let y = a.at(1)
      while y <= b.at(1) + 0.001 {
        place(line(start: (px(a.at(0)), py(y)), end: (px(b.at(0)), py(y)), stroke: st))
        y = y + step
      }
    },
  )

  block(
    width: (xmax - xmin) * ux,
    height: (ymax - ymin) * uy,
    draw(d),
  )
}



// ============ Hujjat sozlamalari ============
#let headingblue = rgb(20, 50, 120)

#set document(
  title: "1-2-Tajribalar (2-qism): Pnevmoyuritmaning dinamik xarakteristikalari, pnevmatik qattiqligi va PLC asosida sikl boshqaruvi",
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = "1-2 v2"  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (2fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Tajriba №#raqam],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================
#set text(size: 12pt, lang: "uz")
#set par(justify: true, leading: 0.75em)
#set heading(numbering: "1.1.")
#show heading: it => block(above: 1.2em, below: 0.7em)[
  #text(fill: headingblue, weight: "bold")[#it]
]

#set math.equation(numbering: "(1)", supplement: none)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")
#show link: set text(fill: blue.darken(20%))
#set enum(indent: 0.5em, spacing: 0.8em)
#set list(indent: 0.5em, spacing: 0.8em)
#show raw.where(block: true): set block(
  fill: luma(245),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
)
#show raw: set text(size: 9pt)

// ============ Sarlavha ============
#align(center)[
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTLARI №1 va №2]

  #v(0.1cm)
  #text(size: 14pt, weight: "bold", fill: headingblue)[2-QISM]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Pnevmoyuritmaning dinamik xarakteristikalari, pnevmatik qattiqligi
    va PLC asosida avtomatlashtirilgan ish siklini tadqiq etish
  ]

  #v(0.1cm)
  #text(size: 10pt)[
    (1-qismning davomi: ikkinchi mashgʻulot uchun uslubiy koʻrsatma)
  ]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Ishning maqsadi

- 1-qismda olingan statik va yuklama xarakteristikalariga tayangan holda
  pnevmoyuritmaning *dinamik (oʻtkinchi) jarayonlarini* --- harakatga kirishish
  kechikishi, tezlanish, barqaror harakat va toʻxtash bosqichlarini --- tajribada
  oʻrganish.

- "Meter-in" va "Meter-out" drossellash usullarini tashqi yuklama ostida
  taqqoslash, harakat silliqligi hamda "stick-slip" (sakrashli harakat)
  hodisasining yuzaga kelish shartlarini aniqlash.

- Siqilgan havoning siqiluvchanligi tufayli yuzaga keladigan *pnevmatik
  qattiqlik* ($k_p$) va yuritmaning xususiy chastotasi ($f_0$) ning porshen
  holatiga bogʻliqligini hisoblash va tajribada tekshirish.

- PLC kontroller yordamida avtomatik koʻp siklli ish rejimini (A+ / A−)
  dasturlash, sikl vaqti, havo sarfi va energetik samaradorlikni baholash.

- Tajriba natijalarini Python dasturlash tilida qayta ishlash va grafiklarini
  qurish koʻnikmalarini shakllantirish.

= Qisqacha nazariy maʼlumotlar

== Pnevmoyuritma ish siklining vaqt tarkibi

Elektropnevmotaqsimlagichga boshqaruv signali berilgandan soʻng porshen darhol
harakatlanmaydi. Toʻliq sikl vaqti quyidagi tashkil etuvchilardan iborat:

$ t_"sikl" = t_"kech" + t_"harakat" + t_"qayt.kech" + t_"qaytish" $ <eq-sikl>

bunda $t_"kech"$ --- *harakatga kirishish kechikishi*: taqsimlagich
zolotnigining qayta ulanish vaqti va ishchi kamerada bosim porshenni
qoʻzgʻatishga yetarli boʻlgan qiymatgacha koʻtarilishi uchun ketadigan vaqt.
Porshen harakatga kelishi uchun kamera bosimi quyidagi minimal qiymatga
yetishi kerak:

$ P_(1,min) = (F_"yuk" + f_"ishq" + P_2 A_2) / A_1 $ <eq-pmin>

Demak, tashqi yuklama $F_"yuk"$ va aks bosim $P_2$ qanchalik katta boʻlsa,
kechikish vaqti shunchalik uzayadi.

== Kameralardagi bosim dinamikasi

Kameralardagi havo holati adiabatik ($kappa = 1.4$) deb qabul qilinsa, bosim
oʻzgarishi massa sarfi balansi tenglamalari bilan ifodalanadi:

$
  (dif P_1) / (dif t) = (kappa R T) / (V_(01) + A_1 x) G_1
  - (kappa P_1 A_1) / (V_(01) + A_1 x) dot (dif x) / (dif t)
$ <eq-p1>

$
  (dif P_2) / (dif t) = - (kappa R T) / (V_(02) + A_2 (S - x)) G_2
  + (kappa P_2 A_2) / (V_(02) + A_2 (S - x)) dot (dif x) / (dif t)
$ <eq-p2>

bunda $V_(01), V_(02)$ --- kameralar va ulanish quvurlarining "oʻlik" hajmlari,
$R = 287 "J/(kg·K)"$ --- havoning gaz doimiysi, $T$ --- havo harorati,
$G_1, G_2$ --- kameralarga kiruvchi va chiquvchi havoning massa sarfi.

Drossel (yoki taqsimlagich kanali) orqali oʻtuvchi massa sarfi ISO 6358
standartiga koʻra aniqlanadi:

$
  G = cases(
    C rho_0 P_"kir" & "agar" P_"chiq" / P_"kir" <= b "(kritik oqim)",
    C rho_0 P_"kir" sqrt(1 - ((P_"chiq" \/ P_"kir" - b) / (1 - b))^2) & "agar" P_"chiq" / P_"kir" > b,
  )
$ <eq-iso>

bunda $C$ --- tovush oʻtkazuvchanligi (sonic conductance), $b$ --- kritik
bosimlar nisbati, $rho_0$ --- normal sharoitdagi havo zichligi.
(@eq-p1), (@eq-p2), (@eq-iso) tenglamalar 1-qismdagi harakat tenglamasi bilan
birgalikda pnevmoyuritmaning toʻliq nochiziqli matematik modelini tashkil etadi.

== Pnevmatik qattiqlik va xususiy chastota

Porshen muvozanat holatidan kichik $Delta x$ ga siljiganda bir kamerada havo
siqiladi, ikkinchisida kengayadi, natijada tiklovchi kuch hosil boʻladi.
Ushbu "havo prujinasi"ning qattiqligi:

$
  k_p = kappa (P_1 A_1^2 / (V_(01) + A_1 x)
    + P_2 A_2^2 / (V_(02) + A_2 (S - x)))
$ <eq-kp>

bunda $P_1, P_2$ --- *absolyut* bosimlar. Yuritmaning xususiy (tebranish)
chastotasi:

$ omega_0 = sqrt(k_p / M), quad f_0 = omega_0 / (2 pi) $ <eq-f0>

(@eq-kp) dan koʻrinib turibdiki, qattiqlik porshen holatiga bogʻliq: porshen
yurishning chetki nuqtalarida eng katta, oʻrta qismida esa eng kichik
qiymatga ega boʻladi. Pnevmoyuritmaning eng "yumshoq" va tebranishga moyil
holati aynan shu minimal qattiqlik nuqtasidir. Shu sababli pozitsion
pnevmoyuritmalarni loyihalashda $f_0$ ning minimal qiymati boʻyicha hisob
olib boriladi.

== "Meter-in" va "Meter-out" usullarining dinamik farqi

- *"Meter-out"* usulida ikkala kamera ham bosim ostida boʻladi, shu sababli
  (@eq-kp) dagi ikkala qoʻshiluvchi ham qattiqlikka hissa qoʻshadi. Harakat
  silliq, tashqi yuklama oʻzgarishiga sezgirlik past. Kamchiligi --- chiqish
  kamerasi dastlab toʻliq bosim ostida boʻlgani uchun harakatga kirishish
  kechikishi ($t_"kech"$) kattaroq.
- *"Meter-in"* usulida chiqish kamerasi atmosferaga deyarli erkin ochiq
  ($P_2 approx P_a$), qattiqlik asosan bitta kamera hisobiga hosil boʻladi.
  Past tezliklarda statik va dinamik ishqalanish farqi tufayli porshen
  "sakrab" harakatlanadi (stick-slip). Yuklama harakat yoʻnalishida taʼsir
  etganda (tortuvchi yuklama) porshen boshqaruvdan chiqib "qochib" ketishi
  mumkin.

== Havo sarfi va energetik samaradorlik

Bir toʻliq siklda (A+ va A−) sarflanadigan erkin (atmosfera sharoitiga
keltirilgan) havo hajmi:

$ V_"erkin" = (A_1 + A_2) S dot (P_"tam" + P_a) / P_a $ <eq-verkin>

Minutiga $n$ ta sikl bajarilganda oʻrtacha havo sarfi
$Q_"oʻrt" = V_"erkin" dot n$ ga teng. Ushbu havoni izotermik siqish uchun
kompressor sarflaydigan minimal ish:

$ W_"siq" = P_a V_"erkin" ln ((P_"tam" + P_a) / P_a) $ <eq-wsiq>

Pnevmoyuritmaning energetik FIK i foydali mexanik ishning siqish ishiga
nisbati sifatida baholanadi:

$ eta_E = (F_"yuk" dot S) / W_"siq" dot 100% $ <eq-etae>

Amalda oʻlik hajmlar, quvurlar va sizib chiqishlar hisobiga haqiqiy havo sarfi
(@eq-verkin) boʻyicha hisoblangan qiymatdan 10–25% ga koʻp boʻladi.

= Kerakli jihozlar (1-qism stendiga qoʻshimcha)

+ 1-qismda foydalanilgan pnevmatik laboratoriya stendi toʻliq tarkibda
  ($D = 25 "mm"$, $d = 10 "mm"$, $S = 200 "mm"$).
+ *5/3-yoʻlli yopiq markazli elektropnevmotaqsimlagich* (porshenni yurishning
  ixtiyoriy nuqtasida toʻxtatib, ikkala kamerani bosim ostida qulflash uchun).
+ *Tez taʼsir etuvchi bosim datchiklari* (0–10 bar, 4–20 mA) --- PLC ning AI1,
  AI2 analog kirishlariga ulanadi.
+ *Havo sarfi oʻlchagichi* (raqamli flowmeter, 0–200 l/min) --- FRL blokidan
  keyin oʻrnatiladi, AI3 kirishiga ulanadi.
+ *Stop tugmasi* (NC kontakt) --- PLC ning I0.3 kirishiga ulanadi.
+ *Maʼlumot yigʻish tizimi:* PLC trace funksiyasi yoki USB-osillograf
  (namuna olish chastotasi $>= 1 "kHz"$).
+ *Dasturiy muhit:* PLC dasturlash muhiti (TIA Portal / GX Works), Python 3
  (`numpy`, `pandas`, `matplotlib` kutubxonalari).

= Sxemalar va diagrammalar

== Pnevmosilindr ish siklining vaqt diagrammasi

#figure(
  sxema(xmin: -1.6, xmax: 8.4, ymin: -1.5, ymax: 5.3, ux: 1.45cm, uy: 1cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    // --- Oʻqlar ---
    (d.L)((0, 0), (6.6, 0))
    (d.A)((6.7, 0), "right")
    (d.T)((6.8, 0), sb(9pt)[$t$ (s)], at: left + horizon)
    (d.L)((0, 0), (0, 4.6))
    (d.A)((0, 4.7), "up")

    // --- Boshqaruv signali Y1 ---
    let dash = (paint: gray.darken(30%), thickness: 1pt, dash: "dashed")
    (d.L)((0, 0.02), (0.5, 0.02), (0.5, 4.3), (6.4, 4.3), st: dash)
    (d.T)((0.6, 4.4), sb(8pt)[Y1 signali (Q0.0)], at: left + bottom)

    // --- P1 (ishchi kamera) ---
    let c1 = 1.6pt + blue.darken(20%)
    (d.L)((0, 0.05), (0.5, 0.05), st: c1)
    (d.B)((0.5, 0.05), (0.7, 1.6), (0.9, 2.3), (1.2, 2.4), st: c1)
    (d.L)((1.2, 2.4), (4.0, 2.5), st: c1)
    (d.B)((4.0, 2.5), (4.2, 3.4), (4.5, 3.6), (5.0, 3.6), st: c1)
    (d.L)((5.0, 3.6), (6.4, 3.6), st: c1)
    (d.T)((5.3, 3.75), sb(9pt)[$P_1 (t)$], at: left + bottom)

    // --- P2 (chiqish kamerasi) ---
    let c2 = 1.6pt + green.darken(30%)
    (d.L)((0, 3.6), (0.5, 3.6), st: c2)
    (d.B)((0.5, 3.6), (0.7, 2.6), (0.9, 2.1), (1.2, 2.0), st: c2)
    (d.L)((1.2, 2.0), (4.0, 1.9), st: c2)
    (d.B)((4.0, 1.9), (4.3, 0.6), (4.6, 0.15), (5.2, 0.1), st: c2)
    (d.L)((5.2, 0.1), (6.4, 0.1), st: c2)
    (d.T)((-0.1, 3.6), sb(9pt)[$P_2 (t)$], at: right + horizon)

    // --- x(t) (porshen holati) ---
    let c3 = 1.8pt + red.darken(20%)
    (d.L)((0, 0.0), (1.2, 0.0), st: c3)
    (d.B)((1.2, 0.0), (2.0, 0.1), (3.2, 2.9), (4.0, 3.0), st: c3)
    (d.L)((4.0, 3.0), (6.4, 3.0), st: c3)
    (d.T)((2.65, 1.45), box(fill: white, inset: 2pt, sb(9pt)[$x(t)$]), at: left + horizon)
    (d.T)((6.45, 3.0), sb(8pt)[$S$ (LS2)], at: left + horizon)

    // --- Vaqt oraliqlari ---
    let gd = (paint: gray, thickness: 0.6pt, dash: "dotted")
    for t in (0.5, 1.2, 4.0) { (d.L)((t, -0.95), (t, 4.3), st: gd) }
    (d.L)((0.56, -0.6), (1.14, -0.6), st: 0.8pt + black)
    (d.A)((0.5, -0.6), "left")
    (d.A)((1.2, -0.6), "right")
    (d.T)((0.85, -0.7), sb(8pt)[$t_"kech"$], at: center + top)
    (d.L)((1.26, -0.6), (3.94, -0.6), st: 0.8pt + black)
    (d.A)((1.2, -0.6), "left")
    (d.A)((4.0, -0.6), "right")
    (d.T)((2.6, -0.7), sb(8pt)[$t_"harakat"$], at: center + top)
    (d.T)((0.5, -1.1), sb(7pt)[signal], at: center + top)
  }),
  caption: [
    "Meter-out" drossellashda porshen holati $x(t)$ hamda kamera bosimlari
    $P_1 (t)$, $P_2 (t)$ ning vaqt diagrammasi (sifat koʻrinishi)
  ],
) <fig-vaqt>

== Pnevmatik qattiqlik va xususiy chastotaning porshen holatiga bogʻliqligi

#figure(
  sxema(xmin: -1.0, xmax: 7.6, ymin: -1.0, ymax: 5.3, ux: 1.6cm, uy: 0.9cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)

    (d.G)((0, 0), (5, 4.5))
    (d.L)((0, 0), (5.4, 0))
    (d.A)((5.5, 0), "right")
    (d.T)((5.6, 0), sb(9pt)[$x$ (mm)], at: left + horizon)
    (d.L)((0, 0), (0, 4.8))
    (d.A)((0, 4.9), "up")
    (d.T)((0.05, 5.0), sb(9pt)[$f_0$ (Hz)], at: left + bottom)

    // --- Oʻq belgilari ---
    for i in range(6) {
      (d.T)((i, -0.15), text(size: 8pt)[#(i * 40)], at: center + top)
    }
    for j in range(5) {
      (d.T)((-0.1, j), text(size: 8pt)[#(j * 2)], at: right + horizon)
    }

    // --- f0(x) egri chizigʻi (M = 10 kg, P = 7 bar abs) ---
    (d.L)(
      (0.250, 4.044),
      (0.500, 3.380),
      (0.750, 2.998),
      (1.000, 2.749),
      (1.250, 2.577),
      (1.500, 2.454),
      (1.750, 2.366),
      (2.000, 2.305),
      (2.250, 2.266),
      (2.500, 2.247),
      (2.750, 2.245),
      (3.000, 2.262),
      (3.250, 2.300),
      (3.500, 2.361),
      (3.750, 2.454),
      (4.000, 2.588),
      (4.250, 2.787),
      (4.500, 3.093),
      (4.750, 3.618),
      st: 1.8pt + blue.darken(20%),
    )
    (d.T)((3.6, 3.2), box(fill: white, inset: 2pt, sb(8pt)[nazariy, (@eq-f0)]), at: left + horizon)

    // --- Tajriba nuqtalari ---
    for p in ((0.5, 3.2), (1.25, 2.45), (2.5, 2.15), (3.75, 2.35), (4.5, 2.95)) {
      (d.P)(p, 2.8pt, fl: red.darken(20%))
    }
    (d.P)((0.35, 0.75), 2.8pt, fl: red.darken(20%))
    (d.T)((0.5, 0.75), box(fill: white, inset: 2pt, sb(8pt)[tajriba natijalari]), at: left + horizon)

    // --- Minimum ---
    (d.L)((2.75, 0), (2.75, 2.245), st: (paint: gray, thickness: 0.8pt, dash: "dashed"))
    (d.T)((2.75, 1.4), box(fill: white, inset: 2pt, align(center, sb(7pt)[minimal \ qattiqlik zonasi])))
  }),
  caption: [
    Xususiy chastota $f_0$ ning porshen holati $x$ ga bogʻliqligi
    ($M = 10 "kg"$, $P_1 = P_2 = 7 "bar"$ abs., $V_(01) = V_(02) = 5 "sm"^3$)
  ],
) <fig-f0>

== Avtomatik sikl uchun PLC narvon (Ladder) diagrammasi

#figure(
  sxema(xmin: -0.8, xmax: 11.0, ymin: 0.0, ymax: 6.9, ux: 1.35cm, uy: 1cm, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let w = 0.8pt + black

    // NO kontakt: x — chap plastina
    let NO(x, y, lt, lb) = {
      (d.L)((x, y - 0.25), (x, y + 0.25), st: w)
      (d.L)((x + 0.3, y - 0.25), (x + 0.3, y + 0.25), st: w)
      (d.T)((x + 0.15, y + 0.3), sb(7pt)[#lt], at: center + bottom)
      (d.T)((x + 0.15, y - 0.3), text(size: 6.5pt)[#lb], at: center + top)
    }
    // NC kontakt
    let NC(x, y, lt, lb) = {
      NO(x, y, lt, lb)
      (d.L)((x - 0.05, y - 0.25), (x + 0.35, y + 0.25), st: w)
    }
    // Gʻaltak (coil)
    let CO(x, y, lbl, inner) = {
      (d.C)((x + 0.25, y), 0.25, st: w)
      (d.T)((x + 0.25, y), sb(7pt)[#inner])
      (d.T)((x + 0.25, y + 0.3), sb(7pt)[#lbl], at: center + bottom)
    }

    // --- Shinalar ---
    (d.L)((0, 0.3), (0, 6.6), st: 2pt + black)
    (d.L)((10.2, 0.3), (10.2, 6.6), st: 2pt + black)

    // --- 1-zanjir: sikl ruxsati M0.0 ---
    let y = 6.0
    (d.L)((0, y), (1.0, y), st: w)
    NO(1.0, y, [I0.0], [Start])
    (d.L)((1.3, y), (3.5, y), st: w)
    NC(3.5, y, [I0.3], [Stop])
    (d.L)((3.8, y), (5.5, y), st: w)
    NC(5.5, y, [C1], [10 sikl])
    (d.L)((5.8, y), (9.0, y), st: w)
    CO(9.0, y, [M0.0], [ ])
    (d.L)((9.5, y), (10.2, y), st: w)
    // parallel oʻzini ushlash
    (d.L)((0.5, y), (0.5, 4.9), (1.0, 4.9), st: w)
    NO(1.0, 4.9, [M0.0], [oʻzini ushlash])
    (d.L)((1.3, 4.9), (2.0, 4.9), (2.0, y), st: w)

    // --- 2-zanjir: oldinga yurish (Set) ---
    let y = 3.7
    (d.L)((0, y), (1.0, y), st: w)
    NO(1.0, y, [M0.0], [ruxsat])
    (d.L)((1.3, y), (3.5, y), st: w)
    NO(3.5, y, [I0.1], [LS1])
    (d.L)((3.8, y), (9.0, y), st: w)
    CO(9.0, y, [Q0.0], [S])
    (d.L)((9.5, y), (10.2, y), st: w)

    // --- 3-zanjir: ortga qaytish (Reset) ---
    let y = 2.4
    (d.L)((0, y), (1.0, y), st: w)
    NO(1.0, y, [I0.2], [LS2])
    (d.L)((1.3, y), (9.0, y), st: w)
    CO(9.0, y, [Q0.0], [R])
    (d.L)((9.5, y), (10.2, y), st: w)

    // --- 4-zanjir: sikllar hisoblagichi ---
    let y = 1.0
    (d.L)((0, y), (1.0, y), st: w)
    NO(1.0, y, [I0.2], [LS2 (P)])
    (d.L)((1.3, y), (7.6, y), st: w)
    (d.R)((7.6, y - 0.45), (9.8, y + 0.45), fl: orange.lighten(85%), st: w)
    (d.T)((8.7, y), align(center, sb(7pt)[CTU C1 \ PV = 10, R: I0.0]))
    (d.L)((9.8, y), (10.2, y), st: w)
  }),
  caption: [
    Pnevmosilindrni 10 marta avtomatik A+ / A− siklida ishlatish uchun PLC
    narvon diagrammasi
  ],
) <fig-ladder>

Dastur ishlash mantigʻi: "Start" tugmasi bosilganda M0.0 bayrogʻi oʻzini ushlab
qoladi. Porshen boshlangʻich holatda (LS1) turganda Q0.0 chiqishi oʻrnatiladi
(Set) va solenoid Y1 porshenni oldinga suradi. Porshen LS2 ga yetganda Q0.0
tiklanadi (Reset) va prujina taqsimlagichni qaytarib, porshen ortga qaytadi.
LS1 ga qaytishi bilan sikl takrorlanadi. C1 hisoblagich 10 ta siklni sanab
boʻlgach, M0.0 ni oʻchiradi va yuritma boshlangʻich holatda toʻxtaydi.

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[4-bosqich: Dinamik (oʻtkinchi) jarayonlarni qayd etish]

+ Taʼminot bosimini $P_"tam" = 6 "bar"$, chiqish drosselini 50% ochiq holatga
  sozlang.
+ PLC trace funksiyasi (yoki osillograf) yordamida Y1 signali, $P_1 (t)$,
  $P_2 (t)$ va LVDT dan olingan $x(t)$ signallarini bir vaqtda yozib oling.
+ Olingan oscillogrammalardan $t_"kech"$ va $t_"harakat"$ ni aniqlang hamda
  ularni @fig-vaqt dagi diagramma bilan solishtiring.
+ Tajribani $M = 0, 5, 10, 15, 20 "kg"$ yuklamalarda takrorlang.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[5-bosqich: "Meter-in" va "Meter-out" usullarini taqqoslash]

+ 4-bosqichdagi oʻlchovlarni "Meter-out" sxemasi uchun 3-jadvalga kiriting.
+ Drossellarning teskari klapanlarini burab (yoki drossellarni almashtirib)
  sxemani "Meter-in" holatiga oʻtkazing. Kirish drosselini 50% ochiq holatga
  sozlang.
+ Xuddi shu yuklamalarda $t_"kech"$, $t$, $P_1$, $P_2$ ni oʻlchang va harakat
  xarakterini (silliq / sakrashli) vizual hamda $x(t)$ grafigi boʻyicha
  baholang.
+ Ikkala usul uchun $V = f(F_"yuk")$ bogʻliqliklarini bitta grafikda quring.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[6-bosqich: Pnevmatik qattiqlik va xususiy chastotani aniqlash]

+ Stendga 5/3-yoʻlli yopiq markazli taqsimlagichni ulang, yuk massasini
  $M = 10 "kg"$ ga oʻrnating.
+ Porshenni $x = 20, 50, 100, 150, 180 "mm"$ holatlariga keltirib,
  taqsimlagichni markaziy (yopiq) holatga oʻtkazing.
+ Yukka qisqa zarba berib, LVDT signalidagi soʻnuvchi tebranishlarni yozib
  oling. Tebranishlar davri $T_"teb"$ boʻyicha $f_"taj" = 1 \/ T_"teb"$ ni
  aniqlang.
+ Har bir holat uchun (@eq-kp) va (@eq-f0) boʻyicha $k_p$ va $f_0$ ni hisoblang
  hamda tajriba natijasi bilan solishtiring (4-jadval, @fig-f0).

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[7-bosqich: Avtomatik sikl, havo sarfi va energetik samaradorlik]

+ @fig-ladder dagi dasturni PLC ga yuklang va 10 siklli avtomatik rejimni
  ishga tushiring.
+ $P_"tam" = 4 "bar"$ va $6 "bar"$ da 10 sikl uchun umumiy vaqtni hamda havo
  sarfi oʻlchagichi koʻrsatkichini qayd eting.
+ (@eq-verkin), (@eq-wsiq), (@eq-etae) boʻyicha bir sikldagi nazariy havo sarfi,
  siqish ishi va energetik FIK ni hisoblang ($M = 10 "kg"$ uchun).

= Tajriba natijalari va hisoblashlar jadvallari

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[3-Jadval: "Meter-out" va "Meter-in" usullarini taqqoslash (drossel 50%)]

#figure(
  table(
    columns: 9,
    align: center + horizon,
    stroke: none,
    inset: (x: 3.5pt, y: 5pt),
    table.hline(stroke: 1pt),
    [*Usul*], [*$M$ \ (kg)*], [*$F_"yuk"$ \ (N)*], [*$t_"kech"$ \ (s)*],
    [*$t$ \ (s)*], [*$V$ \ (m/s)*], [*$P_1$ \ (bar)*], [*$P_2$ \ (bar)*],
    [*Harakat \ xarakteri*],
    table.hline(stroke: 0.5pt),
    table.cell(rowspan: 5)[Meter- \ out],
    [0], [0.0], [0.08], [0.52], [0.385], [5.6], [6.3], [silliq],
    [5], [49.1], [0.09], [0.58], [0.347], [5.6], [5.1], [silliq],
    [10], [98.1], [0.10], [0.66], [0.304], [5.6], [3.9], [silliq],
    [15], [147.2], [0.12], [0.79], [0.254], [5.6], [2.7], [silliq],
    [20], [196.2], [0.15], [1.05], [0.191], [5.6], [1.5], [silliq],
    table.hline(stroke: 0.5pt),
    table.cell(rowspan: 5)[Meter- \ in],
    [0], [0.0], [0.05], [0.50], [0.400], [0.5], [0.2], [silliq],
    [5], [49.1], [0.06], [0.55], [0.362], [1.5], [0.2], [silliq],
    [10], [98.1], [0.07], [0.63], [0.320], [2.5], [0.2], [kam tebranish],
    [15], [147.2], [0.09], [0.74], [0.271], [3.5], [0.2], [sakrashli],
    [20], [196.2], [0.11], [0.95], [0.210], [4.5], [0.2], [sakrashli],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Drossellash usullarining yuklama ostidagi dinamik koʻrsatkichlari
    ($P_"tam" = 6 "bar"$, $S = 0.2 "m"$)
  ],
)

_Izoh:_ "Meter-out" rejimida salt ishlashda $P_2 > P_"tam"$ boʻlishi
xatolik emas: $A_1 > A_2$ boʻlgani uchun porshen chiqish kamerasidagi havoni
taʼminot bosimidan yuqori bosimgacha siqadi (bosim multiplikatsiyasi effekti).

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[4-Jadval: Pnevmatik qattiqlik va xususiy chastota natijalari]

#figure(
  table(
    columns: 7,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$x$ \ (mm)*], [*$V_1$ \ ($"sm"^3$)*], [*$V_2$ \ ($"sm"^3$)*],
    [*$k_p$ \ (N/mm)*], [*$f_0$ nazariy \ (Hz)*], [*$f_"taj"$ \ (Hz)*],
    table.hline(stroke: 0.5pt),
    [1], [20], [14.8], [79.2], [18.04], [6.76], [6.4],
    [2], [50], [29.5], [66.9], [10.49], [5.15], [4.9],
    [3], [100], [54.1], [46.2], [7.97], [4.49], [4.3],
    [4], [150], [78.6], [25.6], [9.51], [4.91], [4.7],
    [5], [180], [93.4], [13.2], [15.11], [6.19], [5.9],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Porshen holatiga qarab pnevmatik qattiqlik va xususiy chastota \
    ($M = 10 "kg"$, $P_1 = P_2 = 7 "bar"$ abs., $kappa = 1.4$)
  ],
)

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[5-Jadval: Avtomatik sikl, havo sarfi va energetik samaradorlik]

#figure(
  table(
    columns: 8,
    align: center + horizon,
    stroke: none,
    inset: (x: 3.5pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*$P_"tam"$ \ (bar)*], [*$t_(10 "sikl")$ \ (s)*], [*$t_"sikl"$ \ (s)*],
    [*$V_"erkin"$ naz. \ (l/sikl)*], [*$V_"erkin"$ taj. \ (l/sikl)*],
    [*Farq \ (%)*], [*$W_"siq"$ \ (J)*], [*$eta_E$ \ (%)*],
    table.hline(stroke: 0.5pt),
    [4.0], [18.6], [1.86], [0.894], [1.02], [14.1], [144.8], [13.5],
    [6.0], [13.2], [1.32], [1.251], [1.43], [14.3], [245.1], [8.0],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Havo sarfi va energetik samaradorlik ($M = 10 "kg"$, $S = 0.2 "m"$,
    $P_a = 1.013 "bar"$)
  ],
)

= Natijalarni Python yordamida qayta ishlash

Quyidagi dastur 3- va 4-jadval maʼlumotlari asosida $V = f(F_"yuk")$
grafiklarini hamda nazariy $f_0 (x)$ egri chizigʻini tajriba nuqtalari bilan
birga quradi. Talaba oʻz oʻlchov natijalarini massivlarga kiritib, grafiklarni
hisobotga qoʻshishi mumkin.

```python
import numpy as np
import matplotlib.pyplot as plt

# --- Silindr parametrlari ---
D, d, S = 0.025, 0.010, 0.2               # m
A1 = np.pi * D**2 / 4
A2 = np.pi * (D**2 - d**2) / 4
kappa, P, V0, M = 1.4, 7e5, 5e-6, 10.0    # -, Pa (abs), m^3, kg

# --- 3-jadval: yuklama xarakteristikasi ---
F = np.array([0, 49.1, 98.1, 147.2, 196.2])          # N
V_out = np.array([0.385, 0.347, 0.304, 0.254, 0.191])  # m/s
V_in = np.array([0.400, 0.362, 0.320, 0.271, 0.210])   # m/s

# --- 4-jadval: pnevmatik qattiqlik ---
x = np.linspace(0.01, 0.19, 200)
kp = kappa * (P * A1**2 / (V0 + A1 * x) + P * A2**2 / (V0 + A2 * (S - x)))
f0 = np.sqrt(kp / M) / (2 * np.pi)
x_exp = np.array([20, 50, 100, 150, 180]) * 1e-3
f_exp = np.array([6.4, 4.9, 4.3, 4.7, 5.9])

fig, ax = plt.subplots(1, 2, figsize=(11, 4))
ax[0].plot(F, V_out, "o-", label="Meter-out")
ax[0].plot(F, V_in, "s--", label="Meter-in")
ax[0].set(xlabel="F_yuk, N", ylabel="V, m/s", title="V = f(F_yuk)")
ax[1].plot(x * 1e3, f0, label="nazariy")
ax[1].plot(x_exp * 1e3, f_exp, "ro", label="tajriba")
ax[1].set(xlabel="x, mm", ylabel="f0, Hz", title="f0 = f(x)")
for a in ax:
    a.grid(True); a.legend()
print(f"Minimal f0 = {f0.min():.2f} Hz, x = {x[f0.argmin()]*1e3:.0f} mm")
plt.tight_layout(); plt.savefig("natijalar.png", dpi=200)
```

= Hisobot mazmuni va grafik tahlil

+ Yozib olingan oscillogrammalar asosida $x(t)$, $P_1 (t)$, $P_2 (t)$
  grafiklarini qurish, $t_"kech"$ va $t_"harakat"$ ni aniqlash hamda
  (@eq-pmin) boʻyicha $t_"kech"$ ning yuklamaga bogʻliqligini tushuntirish.
+ "Meter-in" va "Meter-out" usullari uchun $V = f(F_"yuk")$ hamda
  $P_2 = f(F_"yuk")$ grafiklarini bitta koordinata tizimida qurish va harakat
  barqarorligi boʻyicha xulosa chiqarish.
+ $f_0 = f(x)$ ning nazariy va tajriba grafiklarini solishtirish, farqning
  sabablarini (ishqalanish, oʻlik hajmlar, issiqlik almashinuvi) tahlil qilish.
+ Havo sarfining nazariy va tajribaviy qiymatlari orasidagi farqni hamda
  taʼminot bosimini kamaytirish orqali energiya tejash imkoniyatlarini
  baholash.
+ 1-qism natijalari bilan birgalikda sanoat roboti ushlash mexanizmi uchun
  pnevmoyuritmaning optimal ish rejimi (bosim, drossellash usuli, tezlik)
  boʻyicha umumiy xulosa yozish.

= Nazorat savollari

+ Pnevmoyuritma ish sikli qanday vaqt tashkil etuvchilardan iborat va
  harakatga kirishish kechikishi qaysi omillarga bogʻliq?
+ Pnevmatik qattiqlik nima uchun porshen holatiga bogʻliq va uning minimal
  qiymati qayerda kuzatiladi?
+ Nima uchun "Meter-in" usulida past tezliklarda "stick-slip" hodisasi yuzaga
  keladi?
+ "Meter-out" rejimida chiqish kamerasidagi bosim taʼminot bosimidan yuqori
  boʻlishi mumkinligini qanday tushuntirasiz?
+ ISO 6358 boʻyicha kritik va kritik boʻlmagan oqim rejimlari bir-biridan
  qanday farq qiladi?
+ Pnevmoyuritmaning energetik FIK ini oshirish uchun qanday konstruktiv va
  boshqaruv choralari koʻriladi?
+ Narvon diagrammasidagi Set/Reset gʻaltaklari va oʻzini ushlash zanjirining
  vazifasi nimadan iborat?
