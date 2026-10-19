// ============================================================
//  4-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_4.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Mexatron modul va robotlarning elektr yuritmalarini hisoblash")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 4  // amaliyot raqami
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

// Raqamlanmagan formula (LaTeX'dagi equation*)
#let eq(body) = math.equation(block: true, numbering: none, body)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №4]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Mexatron modul va robotlarning elektr yuritmalarini hisoblash]
  #v(0.2cm)
  #text(size: 10pt)[(Elektromexanik tizimlar, BLDC va servodvigatellarni hisoblash hamda tanlash)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

- Mexatronik modullar va sanoat robotlarining boʻgʻinlarida qoʻllaniladigan elektr yuritmalarni (BLDC, PMSM, qadamli va servo dvigatellar) tizimli yondashuv (_systems approach_) asosida hisoblash hamda tanlash metodologiyasini oʻrganish.
- Dvigatel valiga keltirilgan inersiya momenti ($I_"tot"$), optimal uzatish nisbati ($n^*$), trapetsiyasimon tezlik profili va oʻrtacha kvadratik moment ($T_"rms"$) koʻrsatkichlarini hisoblash koʻnikmalarini shakllantirish.
- Richard Crowder (_Electric Drives and Electromechanical Systems_) hamda Siciliano (_Robotics: Modelling, Planning and Control_) ilmiy-uslubiy manbalariga tayanib, elektr dvigatelining moment–tezlik ($T - omega$) xarakteristikasi boʻyicha dinamik va issiqlik rejimlarini tahlil qilish.

= Qisqacha nazariy maʼlumotlar

Mexatronik tizimlar va robototexnika majmualarida elektr yuritmalar eng keng tarqalgan va moslashuvchan ijro organi hisoblanadi. Richard Crowder oʻzining _Electric Drives and Electromechanical Systems_ asarida taʼkidlaganidek, *tizimli yondashuv (systems approach)* elektr yuritmani loyihalashning asosiy tayanchi hisoblanadi: hech qanday mukammal dasturiy taʼminot yoki mikrokontrollerli boshqaruv algoritmi notoʻgʻri tanlangan elektr dvigatel va reduktorning kamchiliklarini yopib keta olmaydi.

== Elektr dvigatellarining turlari va solishtirma tahlili

Sanoat robotlari hamda mexatronik modullarda quyidagi asosiy elektr dvigatellari qoʻllaniladi:

+ *Choʻtkali oʻzgarmas tok dvigatellari (Brushed DC Motors):* konstruksiyasi oddiy, lekin kollektor-choʻtka tugunidagi ishqalanish va uchqunlanish sababli xizmat muddati cheklangan.
+ *Choʻtkasiz oʻzgarmas tok dvigatellari (BLDC va PMSM):* yuqori quvvat zichligi (_power density_), uzoq xizmat muddati hamda ajoyib dinamik koʻrsatkichlarga ega. Zamonaviy robotlarda eng keng qoʻllaniladigan yuritma turidir.
+ *Qadamli dvigatellar (Stepper Motors):* ochiq zanjirli (_open-loop_) pozitsiyalash imkonini beradi, lekin yuqori tezlikda moment pasayadi va qadam yoʻqotish (_stall_) xavfi mavjud.
+ *Asinxron elektr dvigatellari (Induction Motors):* yuqori quvvatli sanoat qurilmalarida qoʻllaniladi, lekin robot boʻgʻinlarida BLDC ga nisbatan rotor inersiyasi yuqoriroq.

== Keltirilgan inersiya momenti va optimal uzatish nisbati

Robot boʻgʻinida dvigatel valining burchak tezligi $omega_m$ reduktor orqali yuklama burchak tezligiga ($omega_L$) oʻzgartiriladi. Uzatish nisbati $n$:

$ n = omega_m / omega_L = theta_m / theta_L $

Yuklamaning inersiya momenti $I_L$ va dvigatel rotorining inersiya momenti $I_m$ boʻlganda, dvigatel valiga keltirilgan toʻliq inersiya momenti $I_"tot"$ quyidagicha ifodalanadi:

$ I_"tot" = I_m + I_L / (n^2 dot eta_"red") $

bunda $eta_"red"$ --- reduktorning mexanik FIK koʻrsatkichi (koʻpincha $eta_"red" = 0.85 dots 0.95$).

Dvigatelning maksimal burchak tezlanishini ($alpha_m = n dot alpha_L$) taʼminlash uchun inersiya moslashuvi (_inertia matching_) amalga oshiriladi. Dvigatel va yuklama inersiya momentlari oʻrtasidagi *optimal uzatish nisbati ($n^*$)* quyidagi shartdan topiladi:

$ n^* = sqrt(I_L / I_m) $

Ushbu shart bajarilganda dvigatel berilgan moment bilan yuklamaga eng yuqori burchak tezlanishini beradi.

== Dinamik momentlar va trapetsiyasimon tezlik profili

Robot boʻgʻinining harakati odatda trapetsiyasimon tezlik profili boʻyicha rejalashtiriladi. Harakat 3 faza va toʻxtash fazasidan iborat:

- *Tezlanish fazasi ($t_a$):* dvigatel yuklama inersiyasi hamda qarshilik momentini yengishi kerak.
- *Barqaror tezlik fazasi ($t_v$):* tezlanish nolga teng ($alpha_L = 0$), faqat statik yuklama va ishqalanish momenti yengiladi.
- *Tormozlanish fazasi ($t_d$):* dvigatel rekuperativ tormozlanish rejimida ishlaydi.
- *Toʻxtash/pauza fazasi ($t_s$):* dvigatel toʻxtab turadi yoki ushlab turuvchi moment beradi.

Dvigatel valida hosil boʻladigan dinamik momentlar:

$ T_"acc" = (I_m + I_L / (n^2 eta_"red")) dot alpha_m + T_L / (n dot eta_"red") + T_"ishq" $ <eq-acc>

$ T_"const" = T_L / (n dot eta_"red") + T_"ishq" $ <eq-const>

$ T_"dec" = (I_m + I_L / (n^2 eta_"red")) dot (-alpha_m) + T_L / (n dot eta_"red") + T_"ishq" $ <eq-dec>

== Oʻrtacha kvadratik moment (RMS) va issiqlik hisobi

Dvigatel chulgʻamlarining qizib ketmasligini taʼminlash uchun toʻliq sikl davomida oʻrtacha kvadratik moment ($T_"rms"$) hisoblanadi:

$
  T_"rms" = sqrt(
    (T_"acc"^2 dot t_a + T_"const"^2 dot t_v + T_"dec"^2 dot t_d + T_"pauza"^2 dot t_s)
    / (t_a + t_v + t_d + t_s)
  )
$ <eq-rms>

*Dvigatelni tanlashning 3 ta oltin qoidasi:*

+ *Nominal moment sharti:* $T_"rms" <= T_"nom"$ (dvigatel chulgʻami ruxsat etilgan issiqlik meʼyorida ishlaydi).
+ *Maksimal pik moment sharti:* $T_"acc" <= T_"peak"$ (dvigatel magnitlari magnitsizlanmaydi va drayver tokni ushlaydi).
+ *Maksimal tezlik sharti:* $omega_(m,"max") = n dot omega_(L,"max") <= omega_"nom"$ (yoki $omega_"max"$).

= Kerakli jihozlar va stend elementlari

+ *Elektr yuritma stendi:* BLDC va PMSM servodvigatellari, enkoderli rekuperativ tormoz bloki.
+ *Reduktorlar:* garmonik (_Harmonic Drive_) hamda planetar reduktorlar ($n = 10 dots 100$).
+ *Boshqaruv drayveri:* tok va tezlik konturiga ega boʻlgan raqamli servo drayver (Panasonic / Maxon / Siemens Servo Drive).
+ *Oʻlchov va qayd etish kompleksi:*
  - optik/magnit absolyut va inkremental enkoderlar (1024--4096 CPR);
  - tok datchigi (Hall effect current sensor);
  - raqamli ossillograf va maʼlumotlar yigʻish platasi (DAQ).

= Elektr yuritma va boshqaruv sxemalari

== Robot boʻgʻini elektr yuritmasining kinematik va boshqaruv sxemasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let boxed(a, b, fill, body, size: 8pt) = {
      rect(a, b, fill: fill, stroke: 1pt)
      content(
        ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2),
        align(center, text(size: size, weight: "bold", body)),
      )
    }
    let small(body) = text(size: 6.5pt, weight: "bold", body)

    // Dvigatel, val, reduktor, chiqish vali, yuklama
    boxed((0, 1.0), (2.5, 3.0), blue.lighten(85%))[BLDC / PMSM \ dvigatel \ ($I_m, T_"nom"$)]
    rect((2.5, 1.9), (3.5, 2.1), fill: gray.lighten(40%), stroke: 1.4pt)
    boxed((3.5, 0.8), (5.2, 3.2), orange.lighten(80%))[Reduktor \ ($n, eta_"red"$)]
    rect((5.2, 1.85), (6.5, 2.15), fill: gray.lighten(20%), stroke: 1.4pt)
    boxed((6.5, 0.5), (8.0, 3.5), red.lighten(75%))[Robot \ boʻgʻini \ ($I_L, T_L$)]

    // Enkoder (dvigatel ortida)
    boxed((-1.2, 1.3), (0, 2.7), green.lighten(75%), size: 6.5pt)[Enkoder \ (Feedback)]
    line((-1.2, 2.0), (-1.8, 2.0), (-1.8, -0.5), stroke: 1pt)

    // Servo drayver
    boxed((0.5, -1.5), (4.5, -0.3), yellow.lighten(75%), size: 7.5pt)[
      Raqamli servo drayver \ (tok + tezlik + pozitsiya konturi)
    ]

    // Signal chiziqlari
    let red-s = (paint: red.darken(20%), thickness: 1pt)
    let grn-s = (paint: green.darken(40%), thickness: 1pt)
    let blu-s = (paint: blue.darken(20%), thickness: 1pt)
    line((2.5, -0.3), (1.25, 1.0), stroke: red-s, mark: (end: "stealth", fill: red.darken(20%)))
    content((1.8, 0.35), anchor: "east", text(fill: red.darken(20%), small[3-fazali PWM]))
    line((-1.8, -0.5), (0.5, -0.5), stroke: grn-s, mark: (end: "stealth", fill: green.darken(40%)))
    content((-0.65, -0.4), anchor: "south", text(fill: green.darken(40%), small[Enkoder signali]))
    line((6.5, -0.9), (4.5, -0.9), stroke: blu-s, mark: (end: "stealth", fill: blue.darken(20%)))
    content((6.6, -0.9), anchor: "west", align(left, text(fill: blue.darken(20%), small[
      Topshiriq $theta_"ref"$ \ (CANopen / EtherCAT)
    ])))
  }),
  caption: [Robot boʻgʻini elektr yuritmasining tuzilish va boshqaruv sxemasi],
)

== Dvigatelning moment–tezlik ($T - omega$) xarakteristikasi va ishchi zonasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 1.0)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let dashed = (thickness: 1pt, dash: "dashed")

    grid(
      (0, 0),
      (5.5, 4.2),
      step: 0.5,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    // Uzluksiz ish zonasi
    line(
      (0, 0),
      (0, 2.2),
      (3.5, 2.2),
      (4.2, 0),
      close: true,
      fill: blue.lighten(80%).transparentize(20%),
      stroke: 0.6pt,
    )
    content((1.8, 1.1), align(center, text(fill: blue.darken(30%), small[
      Uzluksiz ish zonasi \ (Continuous Duty Zone) \ $T_"rms" <= T_"nom"$
    ])))

    // Vaqtinchalik pik zona
    line(
      (0, 2.2),
      (0, 4.0),
      (2.5, 4.0),
      (3.5, 2.2),
      close: true,
      fill: red.lighten(80%).transparentize(40%),
      stroke: 0.6pt,
    )
    content((1.4, 3.1), align(center, text(fill: red.darken(30%), small[
      Pik moment zonasi \ (Intermittent Duty Zone) \ $T_"acc" <= T_"peak"$
    ])))

    // Belgilashlar
    line((0, 2.2), (3.5, 2.2), stroke: dashed)
    line((0, 4.0), (2.5, 4.0), stroke: dashed)
    line((3.5, 0), (3.5, 2.2), stroke: dashed)
    line((4.2, 0), (4.2, 0.8), stroke: dashed)
    content((-0.1, 2.2), anchor: "east", small[$T_"nom"$])
    content((-0.1, 4.0), anchor: "east", small[$T_"peak"$])
    content((3.5, -0.1), anchor: "north", small[$omega_"nom"$])
    content((4.2, -0.1), anchor: "north", small[$omega_"max"$])

    // Oʻqlar
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    line((0, 0), (0, 4.8), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Tezlik $omega_m$ (rpm)])
    content((0, 4.9), anchor: "south", text(size: 9pt, weight: "bold")[Moment $T_m$ (Nm)])
  }),
  caption: [BLDC/servodvigatelning $T - omega$ xarakteristikasi va ishchi zonalari],
)

== Trapetsiyasimon tezlik profili va dinamik moment diagrammasi

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.8)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let thin-dash = (thickness: 0.6pt, dash: "dashed")

    // ---- Tezlik grafigi ----
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    line((0, 0), (0, 3.2), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", small[Vaqt $t$ (s)])
    content((0, 3.3), anchor: "south", small[Tezlik $omega_L (t)$])

    line((0, 0), (1.2, 2.5), (3.2, 2.5), (4.4, 0), (5.5, 0), stroke: (paint: blue.darken(30%), thickness: 2pt))
    content((-0.1, 2.5), anchor: "east", small[$omega_(L,"max")$])
    line((0, 2.5), (1.2, 2.5), stroke: thin-dash)
    line((1.2, 0), (1.2, 2.5), stroke: thin-dash)
    line((3.2, 0), (3.2, 2.5), stroke: thin-dash)
    for (x, lab) in ((0.6, $t_a$), (2.2, $t_v$), (3.8, $t_d$), (4.95, $t_s$)) {
      content((x, -0.1), anchor: "north", small(lab))
    }

    // ---- Moment grafigi ----
    group({
      translate((0, -5.5))
      let red-s = (paint: red.darken(20%), thickness: 2pt)
      let red-d = (paint: red.darken(20%), thickness: 1pt, dash: "dashed")

      line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
      line((0, -2.0), (0, 2.8), stroke: 1pt, mark: arrow)
      content((6.1, 0), anchor: "west", small[Vaqt $t$ (s)])
      content((0, 2.9), anchor: "south", small[Moment $T_m (t)$])

      line((0, 2.2), (1.2, 2.2), stroke: red-s)
      line((1.2, 0.8), (3.2, 0.8), stroke: red-s)
      line((3.2, -1.4), (4.4, -1.4), stroke: red-s)
      line((4.4, 0), (5.5, 0), stroke: red-s)
      line((1.2, 2.2), (1.2, 0.8), stroke: red-d)
      line((3.2, 0.8), (3.2, -1.4), stroke: red-d)
      line((4.4, -1.4), (4.4, 0), stroke: red-d)

      content((-0.1, 2.2), anchor: "east", small[$T_"acc"$])
      content((-0.1, 0.8), anchor: "east", small[$T_"const"$])
      content((-0.1, -1.4), anchor: "east", small[$T_"dec"$])
    })
  }),
  caption: [Trapetsiyasimon tezlik profili va unga mos keluvchi dinamik moment grafigi],
)

= Tajribani bajarish va hisoblash ketma-ketligi

#heading(level: 2, numbering: none)[1-bosqich: kinematik va dinamik parametrlarni aniqlash]

+ Robot boʻgʻinining harakat burchagi $theta_L$, toʻliq harakat vaqti $t_"harakat"$ hamda yuklama inersiyasi $I_L$ va statik momenti $T_L$ aniqlanadi.
+ Trapetsiyasimon tezlik profili uchun tezlanish vaqti $t_a$, barqaror tezlik vaqti $t_v$ hamda tormozlanish vaqti $t_d$ belgilanadi (odatda $t_a = t_d = 0.2 dot t_"harakat"$).
+ Yuklamaning maksimal burchak tezligi $omega_(L,"max")$ va burchak tezlanishi $alpha_L$ hisoblanadi:
  $ omega_(L,"max") = theta_L / (t_"harakat" - t_a), quad alpha_L = omega_(L,"max") / t_a $

#heading(level: 2, numbering: none)[2-bosqich: reduktor uzatish nisbatini va momentlarni hisoblash]

+ Taxminiy dvigatel inersiyasi $I_m$ uchun optimal uzatish nisbati $n^* = sqrt(I_L \/ I_m)$ hisoblanadi va standart reduktor katalogidan eng yaqin $n$ tanlanadi.
+ Dvigatel valiga keltirilgan momentlar $T_"acc", T_"const", T_"dec"$ @eq-acc–@eq-dec formulalar boʻyicha hisoblanadi.
+ Toʻliq sikl uchun oʻrtacha kvadratik moment $T_"rms"$ @eq-rms formula boʻyicha hisoblanadi.

#heading(level: 2, numbering: none)[3-bosqich: katalogdan elektr dvigatelini tanlash]

+ Maxon / Panasonic / Siemens kataloglaridan $T_"nom" >= T_"rms"$, $T_"peak" >= T_"acc"$ hamda $omega_"nom" >= n dot omega_(L,"max")$ shartlarini qanoatlantiruvchi BLDC/PMSM dvigateli tanlanadi.

= Amaliy hisoblash misoli (sanoat roboti boʻgʻini yuritmasi)

#heading(level: 2, numbering: none)[Berilgan maʼlumotlar]

- Robot boʻgʻini yuklama inersiya momenti: $I_L = 0.8 "kg" dot "m"^2$;
- Yuklama qarshilik kuchi va ogʻirlik momenti: $T_L = 15 "Nm"$;
- Boʻgʻin burilish burchagi: $theta_L = 180 degree = pi "rad" approx 3.1416 "rad"$;
- Toʻliq harakat vaqti: $t_"harakat" = 1.0 "s"$ ($t_a = 0.2 "s"$, $t_v = 0.6 "s"$, $t_d = 0.2 "s"$, $t_s = 0.5 "s"$);
- Reduktor FIK koʻrsatkichi: $eta_"red" = 0.88$.

#heading(level: 2, numbering: none)[Bosqichma-bosqich hisoblash]

*1. Kinematik hisob-kitob:*

#eq($ omega_(L,"max") = pi / (1.0 - 0.2) = 3.1416 / 0.8 = 3.927 "rad/s" quad (37.5 "rpm") $)

#eq($ alpha_L = 3.927 / 0.2 = 19.635 "rad/s"^2 $)

*2. Dvigatel va reduktor hisobi:*

Dastlabki taxmin uchun $I_m = 2.0 times 10^(-4) "kg" dot "m"^2$ deb olamiz. Optimal uzatish nisbati:

#eq($ n^* = sqrt(0.8 / (2.0 times 10^(-4))) = sqrt(4000) approx 63.25 $)

Standart planetar reduktordan $n = 50$ uzatish nisbatini tanlaymiz.

*3. Dvigatel valiga keltirilgan momentlar:*

Dvigatel valiga keltirilgan toʻliq inersiya:

#eq(
  $
    I_"tot" & = 2.0 times 10^(-4) + 0.8 / (50^2 times 0.88) = 2.0 times 10^(-4) + 0.8 / 2200 \
            & = 2.0 times 10^(-4) + 3.636 times 10^(-4) = 5.636 times 10^(-4) "kg" dot "m"^2
  $,
)

Dvigatel valining burchak tezlanishi: $alpha_m = n dot alpha_L = 50 times 19.635 = 981.75 "rad/s"^2$.

- *Tezlanish momenti ($T_"acc"$):*
  #eq($ T_"acc" = (5.636 times 10^(-4)) times 981.75 + 15 / (50 times 0.88) = 0.553 + 0.341 = 0.894 "Nm" $)
- *Barqaror tezlik momenti ($T_"const"$):*
  #eq($ T_"const" = 15 / (50 times 0.88) = 0.341 "Nm" $)
- *Tormozlanish momenti ($T_"dec"$):*
  #eq($ T_"dec" = -0.553 + 0.341 = -0.212 "Nm" $)

*4. Oʻrtacha kvadratik moment ($T_"rms"$) hisobi:*

Toʻliq sikl vaqti $t_"sikl" = 0.2 + 0.6 + 0.2 + 0.5 = 1.5 "s"$.

#eq($ T_"rms" = sqrt(((0.894)^2 times 0.2 + (0.341)^2 times 0.6 + (-0.212)^2 times 0.2 + 0) / 1.5) $)

#eq($ T_"rms" = sqrt((0.1598 + 0.0698 + 0.0090) / 1.5) = sqrt(0.2386 / 1.5) = sqrt(0.1591) = 0.399 "Nm" $)

Dvigatelning maksimal tezligi:

#eq($ omega_(m,"max") = 50 times 3.927 = 196.35 "rad/s" quad (1875 "rpm") $)

*5. Katalogdan dvigatel tanlash:*

Hisoblangan koʻrsatkichlar ($T_"rms" = 0.40 "Nm"$, $T_"acc" = 0.89 "Nm"$, $omega_m = 1875 "rpm"$) boʻyicha Maxon EC-45 Flange choʻtkasiz servodvigateli tanlandi:

- Nominal moment: $T_"nom" = 0.52 "Nm" > 0.40 "Nm"$ (qanoatlantiradi);
- Maksimal pik moment: $T_"peak" = 1.45 "Nm" > 0.89 "Nm"$ (qanoatlantiradi);
- Nominal tezlik: $n_"nom" = 3000 "rpm" > 1875 "rpm"$ (qanoatlantiradi);
- Rotor inersiyasi: $I_m = 1.95 times 10^(-4) "kg" dot "m"^2 approx 2.0 times 10^(-4)$ (dastlabki taxminga mos).

= Hisoblash natijalari va solishtirma jadvallar

#heading(level: 2, numbering: none)[1-jadval: dvigatellarning parametrik solishtirma xarakteristikasi]

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Dvigatel turi*], [*Quvvat zichligi*], [*Dinamik aniqlik*], [*Xizmat muddati*], [*Boshqaruv murakkabligi*]
      ),
      table.hline(stroke: 0.5pt),
      [Brushed DC], [Oʻrta], [Oʻrta], [Past (choʻtkali)], [Juda oddiy],
      [BLDC / PMSM], [Juda yuqori], [Yuqori], [Juda yuqori], [Murakkab (PWM/FOC)],
      [Qadamli (Stepper)], [Yuqori], [Oʻrta (ochiq zanjir)], [Yuqori], [Oddiy],
      [Asinxron (AC)], [Oʻrta], [Oʻrta], [Yuqori], [Oʻrta (VFD)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robotlar va mexatron modullarda qoʻllaniladigan elektr dvigatellari solishtirmasi],
)

#heading(level: 2, numbering: none)[2-jadval: amaliy hisoblangan va katalogdan tanlangan dvigatel koʻrsatkichlari]

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      align: (left + horizon, center + horizon, center + horizon, center + horizon),
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Parametr nomi*], [*Hisoblangan qiymat*], [*Tanlangan dvigatel (Maxon EC-45)*], [*Zaxira koeffitsienti*]
      ),
      table.hline(stroke: 0.5pt),
      [Nominal moment $T_"nom"$], [$0.40 "Nm"$], [$0.52 "Nm"$], [$1.30$ ($30%$)],
      [Pik moment $T_"peak"$], [$0.89 "Nm"$], [$1.45 "Nm"$], [$1.62$ ($62%$)],
      [Maksimal tezlik $n_"max"$], [$1875 "rpm"$], [$3000 "rpm"$], [$1.60$ ($60%$)],
      [Rotor inersiyasi $I_m$],
      [$2.00 times 10^(-4) "kg" dot "m"^2$],
      [$1.95 times 10^(-4) "kg" dot "m"^2$],
      [Mos keladi],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot boʻgʻini elektr yuritmasining hisobiy va nominal parametrlari],
)

= Hisobot mazmuni va grafik tahlil

+ Hisoblangan trapetsiyasimon tezlik va moment grafiklarini ($omega(t), T(t)$) qurish va tahlil qilish.
+ Uzatish nisbati $n$ oʻzgarishining dvigatel validagi $T_"rms"$ momentiga taʼsirini tahlil qilish hamda minimal moment beruvchi uzatish nisbatini asoslash.
+ Tanlangan BLDC dvigatelining issiqlik zaxirasi hamda rekuperativ tormozlanish rejimida energiya qaytarish samaradorligini baholash.

= Nazorat savollari

+ R. Crowder tomonidan ilgari surilgan tizimli yondashuv (_systems approach_) nima va dvigatel tanlashda u nima uchun muhim?
+ Dvigatel va yuklama inersiya momentlarini moslashtirishda (_inertia matching_) optimal uzatish nisbati $n^*$ qanday aniqlanadi?
+ Dvigatelning nominal moment sharti ($T_"rms" <= T_"nom"$) va pik moment sharti ($T_"acc" <= T_"peak"$) oʻrtasidagi farq nimada?
+ Trapetsiyasimon tezlik profilida tezlanish vaqti $t_a$ qisqartirilsa, dvigatelning $T_"acc"$ va $T_"rms"$ momentlari qanday oʻzgaradi?
+ BLDC va PMSM elektr dvigatellarining robototexnika va mexatronikada keng qoʻllanilishiga sabab boʻlgan asosiy ustunliklari nimada?
