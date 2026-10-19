// ============================================================
//  6-7-TAJRIBA MASHGʻULOTI  —  tashqi paketsiz (CeTZ kerak emas)
//  Kompilyatsiya:  typst compile tajriba-6-7.typ
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

#set document(title: "6-7-Tajribalar: Sanoat robotlarining gidroyuritmalari qurilmalari va ishlash prinsiplari")

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = "6-7"  // amaliyot raqami
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

#set math.equation(numbering: "(1)")
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")
#show link: set text(fill: blue.darken(20%))
#set enum(indent: 0.5em, spacing: 0.8em)
#set list(indent: 0.5em, spacing: 0.8em)

// ============ Sarlavha ============
#align(center)[
  #text(size: 18pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTLARI №6 va №7]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[
    Mavzu: Sanoat robotlarining gidroyuritmalari qurilmalari va ishlash
    prinsiplari bilan tanishish
  ]

  #v(0.1cm)
  #text(size: 10pt)[(Kengaytirilgan 2 bosqichli tajriba mashgʻuloti koʻrsatmasi)]

  #v(0.3cm)
  #line(length: 100%, stroke: 1pt)
]

#v(0.3cm)

= Ishning maqsadi

- *1-bosqich (6-tajriba):* Sanoat robotlari hamda ogʻir yuk koʻtaruvchi
  mexatron modullarda qoʻllaniladigan gidravlik kuch stansiyasi (Power Pack),
  gidronasoslar, bosim saqlash klapanlari (pressure relief valves) va
  gidrotaqsimlagichlar tuzilishi hamda ishlash prinsiplarini oʻrganish.

- *2-bosqich (7-tajriba):* Elektrogidravlik servoyuritmalar
  (Electrohydraulic Servo Actuators --- EHA), servoklapanlar (servovalves)
  hamda yopiq zanjirli pozitsiya va kuch boshqaruv tizimlarining statik va
  dinamik xarakteristikalarini tadqiq etish.

- Suyuqlik siqilmasligi (incompressibility) hisobiga gidroyuritmada yuqori
  qattiqlik (stiffness) va aniq pozitsiyalash koʻnikmalarini shakllantirish
  hamda oʻlchov datchiklari orqali gidravlik parametrlarni ($P, Q, F, x$)
  qayd etish.

= Qisqacha nazariy maʼlumotlar

Sanoat robotlarida katta yuk koʻtarish qobiliyati (payload capacity) va yuqori
quvvat/massa nisbati talab etilganda gidroyuritmalar asosiy ijro organi
hisoblanadi. Pnevmoyuritmaga qaraganda gidroyuritmalarning bosh afzalligi ---
*ishchi suyuqlikning (gidravlik moyning) amalda siqilmasligidir* (suyuqlik
siqiluvchanlik koeffitsienti $gamma$ juda kichik). Bu gidroyuritmaga juda
yuqori dinamik qattiqlik (high stiffness) va pozitsiyalash aniqligini beradi.

== Gidravlik Tizimning Asosiy Tarkibiy Qismlari

Gidravlik yuritma kompleksi quyidagi asosiy bloklardan tashkil topadi:

+ *Gidravlik Quvvat Stansiyasi (Hydraulic Power Unit / Tank Block):*
  - *Gidrobak (Reservoir):* Ishchi suyuqlikni saqlash, sovutish va havo
    pufakchalarini ajratish uchun xizmat qiladi.
  - *Gidronasos (Hydraulic Pump):* Elektromotor orqali harakatga keltirilib,
    mexanik energiyani suyuqlikning gidravlik energiyasiga (bosim va sarfga)
    aylantiradi. Sanoat robotlarida hajmiy nasoslar (tishli/gear,
    plastinkali/vane, porshenli/piston pumps) qoʻllaniladi.
  - *Bosim saqlash klapani (Pressure Relief Valve):* Tizimda maksimal ruxsat
    etilgan bosimni ($P_"max"$) cheklaydi va ortiqcha suyuqlikni bakka
    yoʻnaltirib, avariyaning oldini oladi.
  - *Gidroakkumulyator (Accumulator):* Tizimda bosim tebranishlarini
    silliqlaydi va biror momentda piko-sarf talab etilganda gidravlik
    energiyani zaxiradan beradi.
  - *Filtrlar:* Suyuqlikdagi 10--20 mikrondan katta boʻlgan zarralarni tutib
    qolib, klapan va manjetlar eyilishining oldini oladi.

+ *Boshqaruv va Rostlash Apparaturasi:*
  - *Gidrotaqsimlagichlar (Directional Valves):* Suyuqlik oqim yoʻnalishini
    oʻzgartirib, gidrosilindr shtoki harakat yoʻnalishini (oldinga/ortga)
    boshqaradi.
  - *Elektrogidravlik Servoklapanlar (Servo / Proportional Valves):*
    Boshqaruv solenoidi yoki tork-motor (torque motor) orqali suyuqlik sarfi
    $Q$ va bosimini uzluksiz hamda yuqori aniqlikda (millisekundlar ichida)
    boshqaradi.

+ *Ijro Organlari (Actuators):* Gidrosilindrlar (chiziqli harakat) hamda
  gidromotorlar (cheksiz aylanish).

== Gidroyuritma Matematik va Dinamik Tenglamalari

Paskal qonuniga koʻra, gidravlik tizimda hosil boʻlgan bosim ($P$) barcha
yoʻnalishlarda bir xil uzatiladi. Gidrosilindr rivojlantiradigan kuch $F$:

$ F_"gidro" = P_1 A_1 - P_2 A_2 - f_"ishq" $

bunda $P_1, P_2$ --- silindr kameralaridagi bosimlar, $A_1, A_2$ ---
effektiv yuzalar, $f_"ishq"$ --- gidravlik zichlagichlardagi ishqalanish
kuchi.

Nasos beradigan nazariy suyuqlik sarfi $Q_"nasos"$:

$ Q_"nasos" = V_q dot n dot eta_v $

bunda $V_q$ --- nasosning ishchi hajmi ($"cm"^3\/"rev"$), $n$ --- val
aylanishlar soni (rpm), $eta_v$ --- hajmiy FİK.

Elektrogidravlik servoyuritmaning oʻtish jarayonidagi dinamik sarf-bosim
tenglamasi (Servovalve Flow Equation):

$ Q_L = K_q x_v - K_c P_L $

bunda $Q_L$ --- yuklama sarfi, $x_v$ --- servoklapan zolotnigi siljishi,
$K_q$ --- sarf uzatish koeffitsienti, $K_c$ --- bosim-sarf drossellash
koeffitsienti, $P_L = P_1 - P_2$ --- yuklama bosimlar farqi.

Gidrosilindr porshenining koʻchish dinamikasi ($x(t)$):

$ M (dif^2 x) / (dif t^2) + b (dif x) / (dif t) + F_"yuk" = A_1 P_L $

= Kerakli jihozlar va stend elementlari

+ *Gidravlik laboratoriya stendi:* Gidrobak (50 litr), uch fazali
  elektromotor va hajmiy porshenli/tishli nasos
  ($P_"max" = 100 "bar"$, $Q = 10$ l/min).
+ *Gidravlik ijro organlari:* Sanoat roboti boʻgʻinining gidrosilindri
  ($D = 40 "mm"$, $S = 300 "mm"$) va gidromotor.
+ *Boshqaruv apparatlari:* Direct-operated 4/3-yoʻlli gidrotaqsimlagich,
  proporsional klapan hamda flapper-nozzle tipidagi elektrogidravlik
  servoklapan.
+ *Himoya va rostlash moslamalari:* Sozlanuvchi bosim saqlash klapani (relief
  valve), qaytarma klapanlar, drossellar.
+ *Oʻlchov va qayd etish kompleksi:*
  - Manometrlar va yuqori bosim datchiklari
    (0--160 bar, $P_1, P_2, P_"nasos"$);
  - Gidravlik sarf oʻlchagich (Turbine flow meter $Q$);
  - Kuch datchigi (S-type load cell $F_"yuk"$);
  - LVDT pozitsiya datchigi ($x(t)$) hamda AChP (DAQ) maʼlumotlar yigʻish
    platasi.

= Gidravlik va Servoyuritma Sxemalari

== Sanoat Roboti Elektrogidravlik Yuritmasining Prinsipial Sxemasi (6-Tajriba)

#figure(
  sxema(xmin: -2.6, xmax: 6.8, ymin: -3.3, ymax: 6.0, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none, st: 1pt + black) = {
      (d.R)(a, b, fl: fl, st: st)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }

    // --- Gidrosilindr ---
    (d.R)((0, 4.0), (4.0, 5.2), fl: gray.lighten(80%), st: 1.5pt + black)
    (d.R)((1.2, 4.05), (1.6, 5.15), fl: blue.lighten(60%)) // porshen
    (d.R)((1.6, 4.45), (5.2, 4.75), fl: gray.lighten(40%), st: 1.5pt + black)
    (d.T)((2.0, 5.3), sb(9pt)[Robot Boʻgʻini Gidrosilindri ($D = 40$ mm)], at: center + bottom)

    // --- Bosim datchiklari ---
    (d.L)((0.6, 4.0), (0.6, 3.6))
    BX((0.2, 3.2), (1.0, 3.6), sb(7pt)[$P_1$], fl: green.lighten(75%))
    (d.L)((3.4, 4.0), (3.4, 3.6))
    BX((3.0, 3.2), (3.8, 3.6), sb(7pt)[$P_2$], fl: green.lighten(75%))
    (d.L)((0.6, 3.2), (0.6, 2.0))
    (d.L)((3.4, 3.2), (3.4, 2.0))

    // --- 4/3 servoklapan ---
    (d.R)((0.0, 0.8), (4.0, 2.0), fl: blue.lighten(95%))
    let dsh = (paint: black, thickness: 1pt, dash: "dashed")
    (d.L)((1.33, 0.8), (1.33, 2.0), st: dsh)
    (d.L)((2.66, 0.8), (2.66, 2.0), st: dsh)
    (d.T)((0.66, 1.4), align(center, sb(6.5pt)[A$->$T \ P$->$B]))
    (d.T)((2.0, 1.4), align(center, sb(6.5pt)[Yopiq \ (Closed)]))
    (d.T)((3.33, 1.4), align(center, sb(6.5pt)[P$->$A \ B$->$T]))
    (d.T)((2.0, 2.08), box(fill: white, inset: 1pt, sb(9pt)[4/3 Elektrogidravlik Servoklapan]), at: center + bottom)

    // --- Solenoidlar ---
    BX((-1.7, 1.0), (0.0, 1.8), sb(6.5pt)[Solenoid A], fl: orange.lighten(60%))
    BX((4.0, 1.0), (5.7, 1.8), sb(6.5pt)[Solenoid B], fl: orange.lighten(60%))

    // --- P va T liniyalari ---
    (d.L)((1.33, 0.8), (1.33, -0.2))
    (d.L)((2.66, 0.8), (2.66, -0.2))
    (d.T)((1.4, 0.35), sb(7pt)[P (Bosim)], at: left + horizon)
    (d.T)((2.73, 0.35), sb(7pt)[T (Drain/Bak)], at: left + horizon)

    // --- Bosim saqlash klapani ---
    (d.L)((1.33, -0.2), (-0.5, -0.2), (-0.5, -1.2))
    BX((-1.7, -1.8), (-0.3, -1.2), align(center, sb(6.5pt)[Saqlash \ Klapani]), fl: red.lighten(80%))
    (d.L)((-1.0, -1.8), (-1.0, -2.42))
    (d.A)((-1.0, -2.5), "down")
    (d.T)((-1.0, -2.6), sb(7pt)[Bakka (T)], at: center + top)

    // --- Gidronasos va elektromotor ---
    (d.C)((1.33, -1.2), 0.5, fl: yellow.lighten(70%))
    (d.T)((1.33, -1.2), sb(7pt)[Nasos])
    (d.L)((1.33, -0.7), (1.33, -0.28))
    (d.A)((1.33, -0.2), "up")
    (d.C)((2.95, -1.2), 0.55, fl: gray.lighten(70%))
    (d.T)((2.95, -1.2), sb(6.5pt)[Motor M])
    (d.L)((1.83, -1.2), (2.4, -1.2), st: 1.5pt + black)

    // --- Gidrobak ---
    (d.R)((0.5, -2.9), (3.4, -1.9), fl: blue.lighten(90%))
    (d.L)((1.33, -1.7), (1.33, -2.3))
    (d.T)((1.95, -2.5), sb(7pt)[Gidrobak (Moy)])
  }),
  caption: [Robot boʻgʻini elektrogidravlik yuritmasining prinsipial gidravlik sxemasi],
)

== Yopiq Zanjirli Pozitsiyalash Servoyuritma Boshqaruv Sxemasi (7-Tajriba)

#figure(
  sxema(xmin: -0.2, xmax: 15.9, ymin: 0.2, ymax: 4.0, d => {
    let sb(s, body) = text(size: s, weight: "bold", body)
    let BX(a, b, label, fl: none) = {
      (d.R)(a, b, fl: fl)
      (d.T)(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
    }
    // Oʻq bilan tugaydigan gorizontal ulanish
    let AR(x1, x2, y, lbl: none) = {
      (d.L)((x1, y), (x2 - 0.1, y))
      (d.A)((x2, y), "right")
      if lbl != none {
        (d.T)(((x1 + x2) / 2, y + 0.06), box(fill: white, inset: 1pt, sb(6.5pt)[#lbl]), at: center + bottom)
      }
    }

    // --- Bloklar ---
    BX((0.0, 2.55), (2.3, 3.45), sb(7.5pt)[Topshiriq $x_"ref"$], fl: blue.lighten(90%))
    (d.C)((3.1, 3.0), 0.28, fl: white)
    (d.T)((3.1, 3.0), sb(9pt)[$Sigma$])
    BX((4.3, 2.5), (6.1, 3.5), align(center, sb(7.5pt)[PI/PID \ Boshqarich]), fl: yellow.lighten(80%))
    BX((6.9, 2.5), (9.1, 3.5), align(center, sb(7.5pt)[Servodrayver \ (Servoadapter)]), fl: orange.lighten(80%))
    BX((9.9, 2.5), (12.2, 3.5), align(center, sb(7.5pt)[Servoklapan + \ Gidrosilindr]), fl: green.lighten(80%))

    // --- Toʻgʻri zanjir ---
    AR(2.3, 2.82, 3.0)
    AR(3.38, 4.3, 3.0, lbl: [Xato $e$])
    AR(6.1, 6.9, 3.0, lbl: [$u(t)$])
    AR(9.1, 9.9, 3.0, lbl: [$i_v$])
    AR(12.2, 13.3, 3.0)
    (d.T)((13.4, 3.0), sb(7.5pt)[Koʻchish $x(t)$], at: left + horizon)

    // --- Qayta aloqa (LVDT) ---
    BX((6.2, 0.5), (10.9, 1.4), sb(7.5pt)[Pozitsiya Datchigi (LVDT / Enkoder)], fl: gray.lighten(80%))
    (d.L)((12.7, 3.0), (12.7, 0.95), (11.0, 0.95))
    (d.A)((10.9, 0.95), "left")
    (d.L)((6.2, 0.95), (3.1, 0.95), (3.1, 2.64))
    (d.A)((3.1, 2.72), "up")
    (d.T)((2.98, 2.35), sb(9pt)[$-$], at: right + horizon)
  }),
  caption: [
    Elektrogidravlik servoyuritmaning yopiq zanjirli pozitsiya boshqaruv
    blok-sxemasi
  ],
)

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[1-bosqich (6-tajriba): Gidravlik quvvat stansiyasi va nasos xarakteristikasini olish]

+ Elektromotorni yoqib, gidronasosni ishga tushiring. Tizimdagi bosimni
  saqlash klapani (relief valve) orqali
  $P_"tam" = 20, 40, 60, 80, 100 "bar"$ qiymatlarga bosqichma-bosqich
  sozlang.
+ Har bir bosim qiymatida sarf oʻlchagich orqali nasos uzatayotgan suyuqlik
  sarfi $Q$ ni hamda elektromotor isteʼmol qilayotgan quvvatni oʻlchang.
+ Nasosning hajmiy FİK ($eta_v = Q_"real" \/ Q_"naz"$) va umumiy energetik
  FİK qiymatlarini hisoblang.

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-bosqich (7-tajriba): Servoklapan va gidrosilindr pozitsiya xarakteristikasini tadqiq etish]

+ Servodrayverga 0--10 V yoki 4--20 mA analog boshqaruv signalini uzating.
+ Yopiq zanjirli boshqaruv rejimida $x_"ref"$ topshiriq signalini
  pogʻonasimon (step input) oʻzgartirib, LVDT datchigi va osillograf orqali
  porshenning oʻtish jarayoni grafiklarini ($x(t)$) qayd eting.
+ Har xil tashqi yuklamalarda ($F_"yuk" = 0 dots 5000 "N"$) pozitsiyalash
  aniqligi (position error $Delta x$) va kechikish vaqtini oʻlchang.

= Tajriba natijalari va hisoblashlar jadvallari

#heading(level: 2, numbering: none, outlined: false)[1-Jadval: Nasos va Saqlash Klapani Xarakteristikalari (6-Tajriba)]

#figure(
  table(
    columns: 7,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*$P_"tam"$ (bar)*], [*$Q_"real"$ \ (l/min)*],
    [*$Q_"naz"$ \ (l/min)*], [*$eta_v$ (%)*], [*Quvvat $N$ (kW)*],
    [*Suyuqlik $T$ (°C)*],
    table.hline(stroke: 0.5pt),
    [1], [20.0], [9.85], [10.0], [98.5%], [0.42], [32],
    [2], [40.0], [9.68], [10.0], [96.8%], [0.78], [35],
    [3], [60.0], [9.45], [10.0], [94.5%], [1.15], [38],
    [4], [80.0], [9.20], [10.0], [92.0%], [1.52], [42],
    [5], [100.0], [8.92], [10.0], [89.2%], [1.95], [46],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Gidravlik manba va nasos xarakteristikasi tajriba natijalari
    ($n = 1450$ rpm)
  ],
)

#heading(
  level: 2,
  numbering: none,
  outlined: false,
)[2-Jadval: Elektrogidravlik Servoyuritma Pozitsiyalash Natijalari (7-Tajriba)]

#figure(
  table(
    columns: 7,
    align: center + horizon,
    stroke: none,
    inset: (x: 4pt, y: 6pt),
    table.hline(stroke: 1pt),
    [*T/r*], [*Signal $u$ (V)*], [*$x_"ref"$ (mm)*], [*$x_"real"$ (mm)*],
    [*Xato $Delta x$ (mm)*], [*$t_"soz"$ (ms)*], [*$F_"yuk"$ (N)*],
    table.hline(stroke: 0.5pt),
    [1], [2.0], [40.0], [39.95], [0.10], [42], [500],
    [2], [4.0], [80.0], [79.91], [0.09], [45], [1500],
    [3], [6.0], [120.0], [119.88], [0.12], [48], [3000],
    [4], [8.0], [160.0], [159.82], [0.18], [52], [4500],
    table.hline(stroke: 1pt),
  ),
  caption: [
    Elektrogidravlik servoyuritma pozitsiyalash va dinamika natijalari
    ($P_"tam" = 80 "bar"$)
  ],
)

= Hisobot mazmuni va grafik tahlil

+ Nasosning volumetrik xarakteristikasi $Q = f(P)$ va FİK
  $eta_v = f(P)$ *grafiklarini qurish*.
+ Elektrogidravlik servoyuritmaning oʻtish jarayoni $x(t)$ osillogrammasini
  tahlil qilish, qayta tartiblash (overshoot) va sozlanish vaqti
  ($t_"soz"$) ni aniqlash.
+ Gidroyuritmalarning pnevmoyuritmalar bilan solishtirganda yuqori qattiqligi
  va yuklama ostida pozitsiyalash ustunliklarini xulosalash.

= Nazorat savollari

+ Gidroyuritmalarning pnevmoyuritmaga nisbatan qanday asosiy afzalliklari va
  kamchiliklari mavjud?
+ Suyuqlik siqilmasligi (incompressibility) gidroyuritmaning qattiqligi va
  pozitsiyalash aniqligiga qanday taʼsir koʻrsatadi?
+ Gidravlik bosim saqlash klapani (pressure relief valve) va servoklapan
  (servovalve) ning ishlash prinsiplarini tushuntiring.
+ Elektrogidravlik servoyuritmada yopiq zanjirli qayta aloqa (feedback)
  qanday amalga oshiriladi?
