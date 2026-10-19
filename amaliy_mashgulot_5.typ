// ============================================================
//  5-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_mashgulot_5.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Elektr yuritmaning energetik hisobi")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 5  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №5]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Elektr yuritmaning energetik hisobi]
  #v(0.2cm)
  #text(
    size: 10pt,
  )[(Mexatron modullar va robotlarning elektr yuritmalarida energiyadan foydalanish samaradorligi va issiqlik rejimlarini hisoblash)]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

- Mexatron modullar hamda sanoat robotlarining elektr yuritmalarida quvvat balansi, energiyaning sarflanishi va isroflari (yoʻqotishlari) qonuniyatlarini oʻrganish.
- Elektr dvigatelidagi mis (stator va rotordagi aktiv qarshilik), poʻlat (histerezis va Fuko toklari) hamda mexanik ishqalanish yoʻqotishlarini matematik modellashtirish va umumiy FIK (foydali ish koeffitsiyenti) koʻrsatkichini aniqlash.
- Rekuperativ tormozlanish (_regenerative braking_) rejimida mexanik kinetik energiyaning elektr energiyasiga aylanish jarayonlarini hisoblash, manba shinasidagi (_DC bus_) kuchlanish sakrashlarini bartaraf etuvchi kondensator sigʻimi hamda tormozlovchi rezistor ($R_"brake"$) parametrlarini tanlash.
- Dvigatellarning issiqlik rejimini va oʻrtacha kvadratik quvvat/moment ($P_"rms", T_"rms"$) koʻrsatkichlarini baholash koʻnikmalarini shakllantirish.

= Qisqacha nazariy maʼlumotlar

Zamonaviy mexatronik tizimlar va robototexnika majmualarida elektr yuritmalarining energiyadan foydalanish samaradorligi eng muhim mezonlardan biridir. Richard Crowder va L. Sciavicco taʼkidlaganidek, yuritma tizimini loyihalashda faqat dinamik aniqlik emas, balki energetik samaradorlik, yoʻqotilayotgan quvvat ($P_"loss"$) va dvigateldan ajralayotgan issiqlik rejimlarini toʻgʻri hisoblash ham hal qiluvchi ahamiyatga ega.

== Elektr yuritmaning energetik balansi va oqim diagrammasi

Elektr yuritmasi tarmogʻidan olinadigan umumiy elektr quvvati ($P_"in"$) mexanik foydali quvvat ($P_"mech"$) hamda tizimning turli boʻgʻinlaridagi yoʻqotishlar ($P_"loss"$) yigʻindisidan iborat:

$ P_"in" = P_"mech" + sum P_"loss" $

Tizimdagi toʻliq FIK ($eta_"tot"$) quyidagicha ifodalanadi:

$ eta_"tot" = P_"mech" / P_"in" = eta_"inv" dot eta_"mot" dot eta_"red" $

bunda $eta_"inv"$ --- yarimoʻtkazgichli inverter/drayver FIKi, $eta_"mot"$ --- elektr dvigateli FIKi, $eta_"red"$ --- mexanik reduktor yoki uzatma mexanizmi FIKi.

== Elektr dvigatelidagi yoʻqotishlar turlari

Dvigatelda elektr energiyasining mexanik energiyaga aylanishida quyidagi asosiy yoʻqotishlar yuzaga keladi:

+ *Mis (elektr) yoʻqotishlari ($P_"Cu"$):* dvigatel chulgʻamlarining aktiv qarshiligidan oʻtayotgan tok hisobiga Joul–Lens qonuni boʻyicha ajraladigan issiqlik quvvati:
  $
    P_"Cu" = I_a^2 R_a quad "(oʻzgarmas tok motorida)" quad "yoki" \ quad
    P_"Cu" = 3 I_s^2 R_s quad "(uch fazali motorlarda)"
  $

+ *Poʻlat (magnit) yoʻqotishlari ($P_"Fe"$):* stator va rotor oʻzaklaridagi magnit qayta qutblanishi (histerezis) hamda Fuko (uyurmaviy) toklari hisobiga yuzaga keladi:
  $ P_"Fe" = P_h + P_e = k_h f B_"max"^2 + k_e f^2 B_"max"^2 $

+ *Mexanik yoʻqotishlar ($P_"ishq"$):* podshipniklardagi ishqalanish, kollektor-choʻtka kontaktlari hamda rotorning havo qarshiligi (_windage_) yoʻqotishlari:
  $ P_"ishq" = b dot omega_m^2 $
  bunda $b$ --- viskoz ishqalanish koeffitsiyenti, $omega_m$ --- rotor burchak tezligi.

== Rekuperativ tormozlanish va rekuperatsiya energiyasi

Sanoat robotlari va tezkor pozitsiyalash modullari tormozlanganda yoki yuklama taʼsirida ortga harakatlanganda, dvigatel generator rejimiga oʻtadi. Ushbu jarayonda tizimning kinetik energiyasi ($E_k = 1/2 I_"tot" omega_"int"^2$) elektr energiyasiga aylanadi.

Tormozlanish vaqtida dvigateldan drayverga qaytadigan rekuperatsiya energiyasi ($E_r$) quyidagi integral bilan aniqlanadi:

$ E_r = integral_0^(t_z) v_m (t) dot i_a (t) dif t $ <eq-er-int>

Tormozlanish toki $I_r$ oʻzgarmas ushlab turilganda (tezlik $omega_"int"$ dan nolgacha chiziqli kamayadi, $t_z = I_"tot" omega_"int" \/ (K_t |I_r|)$), qaytariladigan rekuperatsiya energiyasi:

$ |E_r| = (I_"tot" omega_"int") / K_t [ (K_e omega_"int") / 2 - |I_r| R_a ] $ <eq-er>

Qaytarilgan energiya DC shina kuchlanishini ($V_"bus"$) oshirib yubormasligi uchun manba shinasiga sigʻimli kondensator ($C_"bus"$) va shuntlovchi tormoz rezistori ($R_"brake"$) oʻrnatiladi:

$ C_"bus" >= (2 |E_r|) / (V_"max"^2 - V_"norm"^2) $ <eq-cbus>

$ R_"brake" <= V_"max" / (|I_r|) $ <eq-rbrake>

$ P_"resistor" = (|E_r|) / t_"sikl" $ <eq-pres>

== Dvigatelning issiqlik rejimi va RMS parametrlari

Dvigatel chulgʻamlarining ruxsat etilgan maksimal haroratdan ($Delta T_"max"$) oshib ketmasligini taʼminlash uchun siklik ish rejimida oʻrtacha quvvat yoʻqotishi va moment hisoblanadi:

$ P_"loss, rms" = 1 / t_"sikl" integral_0^(t_"sikl") P_"loss" (t) dif t $

$ Delta T = P_"loss, rms" dot R_"th" <= Delta T_"max" $

bunda $R_"th"$ --- dvigatel chulgʻamining atrof-muhitga nisbatan issiqlik qarshiligi ($degree"C/W"$).

= Kerakli jihozlar va stend elementlari

+ *Elektr yuritma laboratoriya stendi:* choʻtkasiz (BLDC) yoki PMSM servodvigateli hamda raqamli PWM drayver.
+ *Yuklama va tormozlash qurilmasi:* kukunli/elektromagnit tormoz hamda inersion maxovik disk.
+ *Oʻlchov asboblari va datchiklar:*
  - raqamli tok va kuchlanish datchiklari ($V_"bus", I_a$);
  - moment va tezlik datchigi (torque sensor & enkoder, $1024 "ppr"$);
  - DC shina kuchlanishini qayd etuvchi ossillograf / DAQ plata;
  - dvigatel korpusi haroratini oʻlchovchi pirometr / termopara datchigi.

= Energetik zanjir va model sxemalari

== Elektr yuritma tizimidagi energetik oqim va yoʻqotishlar balansi

#figure(
  {
    set text(size: 7.5pt)
    let loss = red.darken(20%)
    let b(body) = align(center, strong(body))
    diagram(
      node-stroke: 0.8pt,
      node-inset: 5pt,
      spacing: (6mm, 9mm),
      edge-stroke: 1.8pt,

      node((0, 0), b[Elektr manbai \ (AC/DC tarmoq)], fill: blue.lighten(85%), width: 2cm, height: 1.1cm),
      node((1, 0), b[Toʻgʻrilagich / \ Power Supply], fill: gray.lighten(80%), width: 2cm, height: 1.1cm),
      node((2, 0), b[DC shina + \ $C_"bus"$], fill: yellow.lighten(75%), width: 2cm, height: 1.1cm),
      node((3, 0), b[PWM inverter \ drayver], fill: orange.lighten(75%), width: 2cm, height: 1.1cm),
      node((4, 0), b[Elektr dvigatel \ (BLDC/PMSM)], fill: green.lighten(75%), width: 2cm, height: 1.1cm),
      node((5, 0), b[Robot boʻgʻini \ va yuklama], fill: red.lighten(80%), width: 2cm, height: 1.1cm),

      // Toʻgʻri quvvat oqimi
      edge((0, 0), (1, 0), "-|>", label: $P_"grid"$),
      edge((1, 0), (2, 0), "-|>", label: $P_"dc"$),
      edge((2, 0), (3, 0), "<|-|>", label: $P_"inv"$),
      edge((3, 0), (4, 0), "<|-|>", label: $P_"el"$),
      edge((4, 0), (5, 0), "-|>", label: $P_"mech"$),

      // Yoʻqotishlar
      node((1, 1), text(fill: loss, b[Toʻgʻrilagich \ yoʻqotishlari]), stroke: none),
      node((2, 1), text(fill: loss, b[Tormoz rezistori \ $P_"resistor"$]), stroke: none),
      node((3, 1), text(fill: loss, b[Inverter kalit \ yoʻqotishlari]), stroke: none),
      node((4, 1), text(fill: loss, b[Mis ($I^2 R$) va \ poʻlat yoʻqotish.]), stroke: none),
      node((5, 1), text(fill: loss, b[Mexanik ishqalanish \ $b omega^2$]), stroke: none),
      ..range(1, 6).map(i => edge((i, 0), (i, 1), "-|>", stroke: 1pt + loss)),

      // Rekuperatsiya
      edge(
        (5, 0),
        (5, -1),
        (2, -1),
        (2, 0),
        "-|>",
        stroke: (paint: blue.darken(20%), thickness: 1.6pt, dash: "dashed"),
        label: text(fill: blue.darken(20%), strong[Rekuperativ kinetik energiya $E_r$]),
        label-pos: 0.5,
        label-side: left,
      ),
    )
  },
  caption: [Elektr yuritma tizimidagi energiya oqimlari va yoʻqotishlar balansi diagrammasi],
)

== Dvigatelning ekvivalent elektr va issiqlik almashtirish modeli

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.2, y: 1.0)

    let small(body) = text(size: 7pt, weight: "bold", body)
    let boxed(a, b, fill, body) = {
      rect(a, b, fill: fill, stroke: 1pt)
      content(
        ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2),
        align(center, small(body)),
      )
    }

    // ---- Elektr sxemasi ----
    circle((0, 3), radius: 0.06, fill: white, stroke: 1pt)
    circle((0, 0), radius: 0.06, fill: white, stroke: 1pt)
    content((-0.15, 3), anchor: "east", text(size: 9pt, weight: "bold")[$+V_a$])
    content((-0.15, 0), anchor: "east", text(size: 9pt, weight: "bold")[$-V_a$])
    content((0.55, 3.1), anchor: "south", small[$I_a ->$])

    line((0.06, 3), (1.2, 3), stroke: 1pt)
    boxed((1.2, 2.7), (2.2, 3.3), white)[$R_a$]
    line((2.2, 3), (3.0, 3), stroke: 1pt)

    // Induktivlik L_a (4 ta yarim halqa)
    for i in range(4) {
      arc((3.0 + 0.3 * i, 3), start: 180deg, stop: 0deg, radius: 0.15, stroke: 1pt)
    }
    content((3.6, 3.25), anchor: "south", small[$L_a$])
    line((4.2, 3), (4.6, 3), stroke: 1pt)

    // Teskari EYuK E_m
    circle((5.2, 3), radius: 0.6, fill: blue.lighten(90%), stroke: 1pt)
    content((5.2, 3), text(size: 9pt, weight: "bold")[$E_m$])
    line((5.8, 3), (6.5, 3), (6.5, 0), stroke: 1pt)
    line((0.06, 0), (6.5, 0), stroke: 1pt)
    content((6.6, 0), anchor: "west", text(size: 9pt, weight: "bold")[GND])

    // ---- Issiqlik modeli ----
    rect((-0.5, -0.8), (7.0, -2.8), stroke: (paint: gray.darken(30%), thickness: 1pt, dash: "dashed"))
    content((-0.4, -1.1), anchor: "west", text(
      size: 9pt,
      weight: "bold",
      fill: headingblue,
    )[Issiqlik almashtirish modeli (Thermal Model)])

    boxed((0.4, -2.3), (1.9, -1.45), orange.lighten(65%))[Issiqlik manbai \ $P_"loss" = I_a^2 R_a$]
    line((1.9, -1.85), (2.8, -1.85), stroke: 2pt + red, mark: (end: "stealth", fill: red))
    content((2.35, -1.75), anchor: "south", small[$Q_"heat"$])
    boxed((2.8, -2.3), (4.2, -1.45), gray.lighten(75%))[Chulgʻam issiqlik \ sigʻimi $C_"th"$]
    line((4.2, -1.85), (5.1, -1.85), stroke: 2pt + orange, mark: (end: "stealth", fill: orange))
    content((4.65, -1.75), anchor: "south", small[$R_"th"$])
    boxed((5.1, -2.3), (6.6, -1.45), blue.lighten(80%))[Atrof-muhit \ $T_"amb"$]
  }),
  caption: [Dvigatelning ekvivalent elektromexanik va issiqlik almashtirish sxemasi],
)

== Rekuperativ tormozlanish vaqtidagi dinamik diagramma

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    scale(x: 1.1, y: 0.8)

    let arrow = (end: "stealth", fill: black)
    let small(body) = text(size: 7pt, weight: "bold", body)
    let gray-d = (paint: gray, thickness: 0.8pt, dash: "dashed")

    grid(
      (0, -2),
      (5.5, 3),
      step: 0.5,
      stroke: gray.lighten(80%) + 0.3pt,
    )

    // Oʻqlar
    line((0, 0), (6.0, 0), stroke: 1pt, mark: arrow)
    line((0, -2.5), (0, 3.5), stroke: 1pt, mark: arrow)
    content((6.1, 0), anchor: "west", text(size: 9pt, weight: "bold")[Vaqt $t$ (ms)])
    content((0, 3.6), anchor: "south", text(size: 9pt, weight: "bold")[Parametrlar])

    // Tezlik ω_m(t)
    let blue-s = (paint: blue.darken(30%), thickness: 2pt)
    line((0, 2.8), (1.0, 2.8), (4.0, 0), (5.5, 0), stroke: blue-s)
    content((3.2, 0.95), anchor: "south-west", text(fill: blue.darken(30%), small[Tezlik $omega_m (t)$]))

    // Tok I_a(t)
    let red-s = (paint: red.darken(25%), thickness: 2pt)
    line((0, 1.0), (1.0, 1.0), (1.0, -1.8), (4.0, -1.8), (4.0, 0), (5.5, 0), stroke: red-s)
    content((2.5, -1.9), anchor: "north", text(fill: red.darken(25%), small[Tok $I_a (t)$ (rekuperatsiya)]))

    // DC shina kuchlanishi V_bus(t)
    let grn-s = (paint: green.darken(40%), thickness: 2pt)
    line((0, 1.8), (1.0, 1.8), stroke: grn-s)
    bezier((1.0, 1.8), (4.0, 1.8), (2.0, 2.9), (3.0, 2.9), stroke: grn-s)
    line((4.0, 1.8), (5.5, 1.8), stroke: grn-s)
    content((5.6, 1.8), anchor: "west", text(fill: green.darken(40%), small[$V_"bus" (t)$ (kuchlanish sakrashi)]))

    // Shtrix chiziqlar
    line((1.0, -2.2), (1.0, 3.0), stroke: gray-d)
    line((4.0, -2.2), (4.0, 3.0), stroke: gray-d)
    content((1.0, 3.05), anchor: "south", small[$t_"tormoz boshi"$])
    content((4.0, 3.05), anchor: "south", small[$t_"stop"$])
  }),
  caption: [Rekuperativ tormozlanish rejimida tezlik, tok va DC shina kuchlanishining oʻzgarish dinamikasi],
)

= Tajribani bajarish va ishni oʻtkazish ketma-ketligi

#heading(level: 2, numbering: none)[1-bosqich: dvigatel yoʻqotishlari va FIK koʻrsatkichini aniqlash]

+ Stendni yoqib, BLDC dvigatelini $n = 1000, 2000, 3000 "rpm"$ tezliklarda yuklamasiz (salt ishlash) va nominal yuklamada ($T_"nom"$) ishlating.
+ Har bir rejimda manba kuchlanishi $V_"bus"$, zanjir toki $I_a$, chiqish validagi moment $T_m$ hamda burchak tezligini ($omega_m$) qayd eting.
+ Mis yoʻqotishlari $P_"Cu" = I_a^2 R_a$, foydali quvvat $P_"mech" = T_m omega_m$ hamda dvigatel FIKini ($eta_"mot"$) hisoblang.

#heading(level: 2, numbering: none)[2-bosqich: rekuperatsiya energiyasi va $C_"bus"$, $R_"brake"$ hisobi]

+ Maksimal tezlikdan ($omega_"int" = 300 "rad/s"$) tezkor rekuperativ tormozlanish rejimini ($t_z = 200 "ms"$) yoqing.
+ Ossillograf yordamida DC shinadagi kuchlanish sakrashini ($Delta V_"bus"$) qayd eting.
+ @eq-er–@eq-rbrake formulalar yordamida rekuperatsiya energiyasi $E_r$, ruxsat etilgan maksimal kuchlanishni $V_"max"$ ushlab turuvchi $C_"bus"$ va $R_"brake"$ qiymatlarini hisoblang hamda tajriba natijalari bilan solishtiring.

= Tajriba natijalari va hisoblashlar jadvallari

#heading(level: 2, numbering: none)[1-jadval: dvigatel yoʻqotishlari va FIK hisobi ($R_a = 0.8 thin Omega$)]

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: 8,
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 4pt),
      table.hline(stroke: 1pt),
      table.header(
        [*T/r*],
        [*Tezlik* \ *$n$ (rpm)*],
        [*Moment* \ *$T$ (Nm)*],
        [*Tok* \ *$I_a$ (A)*],
        [*$P_"in"$* \ *(W)*],
        [*$P_"mech"$* \ *(W)*],
        [*$P_"Cu"$* \ *(W)*],
        [*FIK* \ *$eta$ (%)*],
      ),
      table.hline(stroke: 0.5pt),
      [1], [1000], [0.20], [0.65], [24.0], [20.9], [0.34], [87.1],
      [2], [2000], [0.45], [1.35], [102.0], [94.2], [1.46], [92.3],
      [3], [3000], [0.80], [2.40], [272.0], [251.3], [4.61], [92.4],
      [4], [3000 (pik)], [1.50], [4.80], [520.0], [471.2], [18.43], [90.6],
      table.hline(stroke: 1pt),
    )
  },
  caption: [BLDC dvigatelining har xil yuklamalardagi energetik koʻrsatkichlari],
)

#heading(level: 2, numbering: none)[2-jadval: rekuperativ tormozlanish va energiya balansi]

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: 7,
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 4pt),
      table.hline(stroke: 1pt),
      table.header(
        [*T/r*],
        [*$omega_"int"$* \ *(rad/s)*],
        [*Tormoz toki* \ *$I_r$ (A)*],
        [*$t_z$* \ *(ms)*],
        [*Energiya* \ *$E_r$ (J)*],
        [*$V_"max"$* \ *(V)*],
        [*$R_"brake"$* \ *($Omega$)*],
      ),
      table.hline(stroke: 0.5pt),
      [1], [100], [$-3.0$], [65], [$-0.85$], [51.2], [17.0],
      [2], [200], [$-6.0$], [95], [$-3.62$], [54.8], [9.1],
      [3], [300], [$-10.0$], [130], [$-8.45$], [58.5], [5.8],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Rekuperativ tormozlanish tajribasi natijalari ($I_"tot" = 0.002 "kg" dot "m"^2$)],
)

= Amaliy hisoblash misoli (sanoat roboti yuritmasi)

#heading(level: 2, numbering: none)[Masala sharti]

Sanoat roboti boʻgʻini BLDC elektr yuritmasi bilan harakatlantiriladi. Tizimning keltirilgan inersiya momenti $I_"tot" = 0.0025 "kg" dot "m"^2$, boshlangʻich burchak tezligi $omega_"int" = 300 "rad/s"$ ($approx 2865 "rpm"$). Dvigatel qarshiligi $R_a = 0.8 thin Omega$, moment konstantasi $K_t = 0.45 "Nm/A"$, teskari EYuK konstantasi $K_e = 0.45 "V" dot "s/rad"$. Tizim $t_z = 0.15 "s"$ ($150 "ms"$) ichida toʻliq rekuperativ tormozlanadi. DC shinaning nominal kuchlanishi $V_"norm" = 48 "V"$, ruxsat etilgan maksimal kuchlanish $V_"max" = 60 "V"$. Sikl vaqti $t_"sikl" = 4.0 "s"$.

#heading(level: 2, numbering: none)[Hisoblash bosqichlari]

+ *Tormozlanish momenti va toki hisobi:*
  $ T_d = I_"tot" dot omega_"int" / t_z = 0.0025 dot 300 / 0.15 = 5.0 "Nm" $
  $ I_r = T_d / K_t = 5.0 / 0.45 = 11.11 "A" $

+ *Rekuperatsiya energiyasini ($E_r$) hisoblash:*
  $
    |E_r| = (I_"tot" omega_"int"^2) / 2 - integral_0^(t_z) I_r^2 R_a dif t
    = (0.0025 dot 300^2) / 2 - (11.11^2 dot 0.8 dot 0.15)
  $
  $ |E_r| = 112.5 "J" - 14.81 "J" = 97.69 "J" $

+ *DC shina kondensatori ($C_"bus"$) sigʻimini aniqlash:*
  $
    C_"bus" >= (2 dot 97.69) / (60^2 - 48^2) = 195.38 / (3600 - 2304) = 195.38 / 1296
    = 0.15075 "F" = 150.75 "mF"
  $
  _Standart tanlov:_ *$C_"bus" = 160 "mF"$* (yoki energiya qaytarish moduli).

+ *Tormoz rezistori ($R_"brake"$) va uning sochish quvvati ($P_"resistor"$):*
  $
    R_"brake" <= V_"max" / I_r = 60 / 11.11 = 5.40 thin Omega
    quad ==> quad "Standart:" bold(R_"brake" = 5.1 thin Omega)
  $
  $
    P_"resistor" = (|E_r|) / t_"sikl" = 97.69 / 4.0 = 24.42 "W"
    quad ==> quad "Standart:" bold(P_"nom" = 50 "W") "(nixrom / wirewound)"
  $

= Hisobot mazmuni va grafik tahlil

+ Tajriba natijalari boʻyicha dvigatel FIKining tezlik hamda momentga bogʻliqlik $eta = f(T, n)$ grafiklarini qurish.
+ Rekuperatsiya rejimida drayver va dvigateldagi issiqlik yoʻqotishlari balansini tahlil qilish.
+ Sanoat robotlarining koʻp oʻqli yuritmalarida rekuperatsiya qilingan energiyadan qayta foydalanish (_Common DC Bus architecture_) samaradorligini baholash.

= Nazorat savollari

+ Elektr yuritmasining energetik balansi tenglamasi va unga kiruvchi yoʻqotishlar turlarini tushuntiring.
+ Mis ($I^2 R$) va poʻlat (magnit) yoʻqotishlari dvigatelning qaysi ish rejimlarida ustunlik qiladi?
+ Rekuperativ tormozlanish nima va rekuperatsiya energiyasi $E_r$ qanday aniqlanadi?
+ DC shina kondensatori ($C_"bus"$) va tormoz rezistori ($R_"brake"$) qanday vazifalarni bajaradi hamda ularning parametrlari qanday hisoblanadi?
+ Dvigatelning issiqlik rejimi va oʻrtacha kvadratik quvvat ($P_"rms"$) hisobi dvigatelning xizmat muddatiga qanday taʼsir qiladi?
