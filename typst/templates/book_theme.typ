// Akashic Record - Competitive Programming C++14 Offline Library
// Pure Monochrome Physical Publishing Theme for A4 Print Books
// Standard: A4 (210mm x 297mm), Two-sided, Inside: 28mm, Outside: 22mm, Top: 22mm, Bottom: 22mm

#let book-setup(
  title: "Lập Trình Thi Đấu C++14",
  volume: "Tập 1: Nền Tảng",
  author: "Akashic Record",
  body,
) = {
  // Document metadata
  set document(title: title + " - " + volume, author: author)

  // Typography - High-contrast pure monochrome / grayscale
  let font-serif = ("Libertinus Serif", "Noto Serif", "FreeSerif", "Nimbus Roman")
  let font-mono = ("JetBrainsMono NF", "DejaVu Sans Mono", "FreeMono")

  set text(
    font: font-serif,
    size: 10.5pt,
    lang: "vi",
    fill: black,
  )

  // Paragraph & spacing settings
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.5em,
  )

  // Headings
  show heading: set text(fill: black, font: font-serif)

  show heading.where(level: 1): it => block(width: 100%, breakable: false)[
    #v(1.8em)
    #text(size: 18pt, weight: "bold")[#it.body]
    #v(0.35em)
    #line(length: 100%, stroke: 1.5pt + black)
    #v(1.2em)
  ]

  show heading.where(level: 2): it => block(width: 100%, breakable: false)[
    #v(1.3em)
    #text(size: 13pt, weight: "bold")[#it.body]
    #v(0.25em)
    #line(length: 100%, stroke: 0.6pt + luma(80))
    #v(0.7em)
  ]

  show heading.where(level: 3): it => block(width: 100%, breakable: false)[
    #v(1.0em)
    #text(size: 11pt, weight: "bold")[#it.body]
    #v(0.5em)
  ]

  // Code / Monospace styling
  show raw: set text(font: font-mono, size: 9pt)
  show raw.where(block: true): it => block(
    fill: luma(248),
    stroke: 0.5pt + luma(140),
    inset: 8pt,
    radius: 3pt,
    width: 100%,
    clip: true,
    it
  )
  show raw.where(block: false): it => box(
    fill: luma(245),
    inset: (x: 3pt, y: 1.5pt),
    baseline: 0%,
    radius: 2pt,
    stroke: 0.4pt + luma(180),
    it
  )

  // Two-sided A4 page geometry with alternating headers
  set page(
    paper: "a4",
    margin: (
      inside: 28mm,
      outside: 22mm,
      top: 22mm,
      bottom: 22mm,
    ),
    header: context {
      let page-num = counter(page).get().first()
      let chapters = query(selector(heading.where(level: 1)).before(here()))
      let ch-title = if chapters.len() > 0 { chapters.last().body } else { title }
      let sections = query(selector(heading.where(level: 2)).before(here()))
      let sec-title = if sections.len() > 0 { sections.last().body } else { ch-title }

      set text(size: 8.5pt, font: font-serif, fill: luma(60))

      if calc.even(page-num) {
        // Even page (Left/Verso): Page number on outside (left), Chapter title on inside (right)
        grid(
          columns: (auto, 1fr),
          align: (left + bottom, right + bottom),
          [#strong(str(page-num))],
          [#ch-title],
        )
        v(-4pt)
        line(length: 100%, stroke: 0.5pt + luma(120))
      } else {
        // Odd page (Right/Recto): Section title on inside (left), Page number on outside (right)
        grid(
          columns: (1fr, auto),
          align: (left + bottom, right + bottom),
          [#sec-title],
          [#strong(str(page-num))],
        )
        v(-4pt)
        line(length: 100%, stroke: 0.5pt + luma(120))
      }
    },
    footer: none,
  )

  body
}
