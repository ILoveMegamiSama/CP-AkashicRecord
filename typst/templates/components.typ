// Akashic Record - Competitive Programming C++14 Offline Library
// Monochrome Components: Callouts, Syntax Anatomy, and Terminology Boxes

// 1. Callout Box: Monochrome container with bold 2.5pt left border & 5% gray background
#let callout(
  kind: "theory",
  title: none,
  body: none,
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let k = named.at("kind", default: kind)
  let t = named.at("title", default: title)
  let b = if body != none {
    body
  } else if pos.len() == 1 {
    pos.at(0)
  } else if pos.len() == 2 {
    t = pos.at(0)
    pos.at(1)
  } else if pos.len() >= 3 {
    k = pos.at(0)
    t = pos.at(1)
    pos.at(2)
  } else {
    named.at("body", default: [])
  }

  let tag = if k == "theory" { "[LÝ THUYẾT]" }
    else if k == "memory" { "[MÔ HÌNH BỘ NHỚ]" }
    else if k == "syntax" { "[MỔ XẺ CÚ PHÁP]" }
    else if k == "trace" { "[CHẠY BÀN]" }
    else if k == "test" { "[THỬ THÁCH 10 TEST]" }
    else if k == "term" { "[THUẬT NGỮ]" }
    else if k == "warning" { "[LƯU Ý QUAN TRỌNG]" }
    else if k == "intuition" { "[TRỰC GIÁC HÌNH TƯỢNG]" }
    else { "[" + upper(str(k)) + "]" }

  block(
    width: 100%,
    fill: luma(248), // 5% gray
    stroke: (left: 2.5pt + black, rest: 0.5pt + luma(200)),
    inset: (x: 10pt, y: 9pt),
    radius: (right: 3pt),
    spacing: 1.2em,
    breakable: false,
    [
      #block(below: 6pt)[
        #text(weight: "bold", size: 9pt, font: ("JetBrainsMono NF", "DejaVu Sans Mono", "FreeMono"))[#tag]
        #if t != none and t != "" [
          #h(6pt)
          #text(weight: "bold", size: 10pt)[#t]
        ]
      ]
      #text(size: 9.8pt)[#b]
    ]
  )
}

// 2. Syntax Anatomy: 2-column breakdown of C++14 code tokens & semantic explanations
#let syntax-anatomy(
  code: none,
  explanations: (),
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let c = if code != none {
    code
  } else if pos.len() > 0 {
    pos.at(0)
  } else {
    named.at("code", default: "")
  }

  let expls = if explanations != () {
    explanations
  } else if pos.len() > 1 {
    pos.at(1)
  } else {
    named.at("explanations", default: ())
  }

  // Parse list of tuples or dicts into rows
  let rows = ()
  for item in expls {
    if type(item) == array and item.len() >= 2 {
      let token = item.at(0)
      let desc = item.at(1)
      let token-content = if type(token) == str { raw(token) } else { token }
      rows.push((token-content, desc))
    } else if type(item) == dictionary {
      let token = item.at("syntax", default: item.at("token", default: ""))
      let desc = item.at("desc", default: item.at("meaning", default: ""))
      let token-content = if type(token) == str { raw(token) } else { token }
      rows.push((token-content, desc))
    }
  }

  block(
    width: 100%,
    stroke: 0.8pt + black,
    radius: 3pt,
    clip: true,
    spacing: 1.2em,
    breakable: false,
    [
      // Top header banner
      #block(
        width: 100%,
        fill: luma(235),
        inset: (x: 10pt, y: 6pt),
        stroke: (bottom: 0.8pt + black),
        [
          #text(weight: "bold", size: 9pt, font: ("JetBrainsMono NF", "DejaVu Sans Mono", "FreeMono"))[[MỔ XẺ CÚ PHÁP C++14]]
        ]
      )

      // Code box
      #block(
        width: 100%,
        fill: luma(252),
        inset: (x: 10pt, y: 8pt),
        stroke: (bottom: 0.6pt + luma(160)),
        [
          #align(center)[
            #if type(c) == str {
              raw(c, lang: "cpp", block: true)
            } else {
              c
            }
          ]
        ]
      )

      // 2-column breakdown table
      #if rows.len() > 0 [
        #table(
          columns: (2.2fr, 3.8fr),
          stroke: 0.4pt + luma(180),
          fill: (col, row) => if row == 0 { luma(240) } else if calc.even(row) { luma(250) } else { white },
          align: (left + horizon, left + horizon),
          inset: (x: 8pt, y: 6pt),
          table.header(
            [*Thành phần cú pháp*],
            [*Cơ chế ngữ nghĩa & Mục đích*]
          ),
          ..rows.flatten().map(cell => [#cell])
        )
      ]
    ]
  )
}

// 3. Term Box: Scientific etymology & intuitive mental model explanation
#let term-box(
  term: none,
  origin: none,
  intuition: none,
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let t = if term != none {
    term
  } else if pos.len() > 0 {
    pos.at(0)
  } else {
    named.at("term", default: "")
  }

  let o = if origin != none {
    origin
  } else if pos.len() > 1 {
    pos.at(1)
  } else {
    named.at("origin", default: "")
  }

  let i = if intuition != none {
    intuition
  } else if pos.len() > 2 {
    pos.at(2)
  } else {
    named.at("intuition", default: "")
  }

  block(
    width: 100%,
    fill: luma(248),
    stroke: (left: 2.5pt + black, rest: 0.5pt + luma(180)),
    inset: (x: 10pt, y: 9pt),
    radius: (right: 3pt),
    spacing: 1.2em,
    breakable: false,
    [
      #block(below: 6pt)[
        #text(weight: "bold", size: 9pt, font: ("JetBrainsMono NF", "DejaVu Sans Mono", "FreeMono"))[[THUẬT NGỮ KHOA HỌC]]
        #h(6pt)
        #text(weight: "bold", size: 10.5pt)[#t]
      ]
      #v(2pt)
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        [*Từ nguyên học:*], [#text(style: "italic")[#o]],
        [*Mô hình trực giác:*], [#i],
      )
    ]
  )
}
