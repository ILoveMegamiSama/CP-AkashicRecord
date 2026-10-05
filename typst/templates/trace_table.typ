// Akashic Record - Competitive Programming C++14 Offline Library
// Monochrome Hand-trace Tables, Problem Layouts, and Appendix Solution Matrices

// Helper to format values
#let format-val(v) = {
  if type(v) == str { v } else { repr(v) }
}

// 1. Hand-Trace Problem Layout with 10 Blank Answer Slots for Pencil Dry-run
#let hand-trace-problem(
  name: "",
  source: "",
  problem_desc: [],
  sample: none,
  tests_10: (),
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let p-name = if name != "" { name } else if pos.len() > 0 { pos.at(0) } else { named.at("name", default: "") }
  let p-source = if source != "" { source } else if pos.len() > 1 { pos.at(1) } else { named.at("source", default: "") }
  let p-desc = if problem_desc != [] { problem_desc } else if pos.len() > 2 { pos.at(2) } else { named.at("problem_desc", default: []) }
  let p-sample = if sample != none { sample } else if pos.len() > 3 { pos.at(3) } else { named.at("sample", default: none) }
  let p-tests = if tests_10 != () { tests_10 } else if pos.len() > 4 { pos.at(4) } else { named.at("tests_10", default: ()) }

  block(
    width: 100%,
    stroke: 0.8pt + black,
    radius: 3pt,
    clip: true,
    spacing: 1.1em,
    breakable: true,
    [
      // Problem title header
      #block(
        width: 100%,
        fill: luma(235),
        inset: (x: 8pt, y: 5pt),
        stroke: (bottom: 0.8pt + black),
        [
          #grid(
            columns: (1fr, auto),
            align: (left + horizon, right + horizon),
            [#text(weight: "bold", size: 10.5pt)[Bài toán: #p-name]],
            [#if p-source != "" [#text(size: 8.5pt, style: "italic", fill: luma(60))[(Nguồn: #p-source)]]],
          )
        ]
      )

      // Problem description statement
      #block(
        width: 100%,
        inset: (x: 8pt, y: 6pt),
        [
          #p-desc
        ]
      )

      // Sample I/O if provided
      #if p-sample != none [
        #block(
          width: 100%,
          inset: (x: 10pt, y: 6pt),
          stroke: (top: 0.5pt + luma(180), bottom: 0.5pt + luma(180)),
          fill: luma(252),
          [
            #text(weight: "bold", size: 9pt)[Ví dụ mẫu:]
            #v(2pt)
            #grid(
              columns: (1fr, 1fr),
              gutter: 12pt,
              [
                #text(size: 8.5pt, weight: "bold")[Đầu vào (Input):]
                #block(
                  width: 100%,
                  fill: white,
                  inset: 5pt,
                  stroke: 0.4pt + luma(160),
                  radius: 2pt,
                  raw(if type(p-sample) == dictionary { p-sample.at("input", default: "") } else { str(p-sample) })
                )
              ],
              [
                #text(size: 8.5pt, weight: "bold")[Đầu ra (Output):]
                #block(
                  width: 100%,
                  fill: white,
                  inset: 5pt,
                  stroke: 0.4pt + luma(160),
                  radius: 2pt,
                  raw(if type(p-sample) == dictionary { p-sample.at("output", default: "") } else { "" })
                )
              ]
            )
          ]
        )
      ]

      // 10 Hand-trace test cases banner
      #block(
        width: 100%,
        fill: luma(242),
        inset: (x: 10pt, y: 6pt),
        stroke: (bottom: 0.6pt + luma(160)),
        [
          #text(weight: "bold", size: 9.5pt)[Thử thách 10 Test Bàn Tay (Tính nhẩm & Điền bằng bút chì):]
          #h(8pt)
          #text(size: 8.5pt, style: "italic", fill: luma(80))[Đáp án đối chiếu xem tại Phụ lục cuối sách]
        ]
      )

      // 10 Test Cases Table with blank pencil slots [ .................... ]
      #if p-tests.len() > 0 [
        #let rows = ()
        #for (idx, t) in p-tests.enumerate() {
          let tid = if type(t) == dictionary { t.at("id", default: idx + 1) } else { idx + 1 }
          let grp = if type(t) == dictionary { t.at("group", default: "-") } else { "-" }
          let inp = if type(t) == dictionary { t.at("input", default: "-") } else { format-val(t) }
          
          let tid-cell = align(center)[#strong(str(tid))]
          let grp-cell = text(size: 8.5pt)[#grp]
          let inp-cell = raw(str(inp))
          // Pencil answer slot with explicit [ .................... ] requirement
          let slot-cell = align(center)[
            #rect(
              width: 90%,
              stroke: stroke(paint: luma(100), thickness: 0.5pt, dash: "dashed"),
              fill: white,
              inset: (x: 4pt, y: 3pt),
              radius: 2pt,
              [#text(size: 9pt, fill: luma(120))[ [ .................... ] ]]
            )
          ]
          rows.push((tid-cell, grp-cell, inp-cell, slot-cell))
        }

        #table(
          columns: (1.2cm, 3.2cm, 3fr, 2.5fr),
          stroke: 0.4pt + luma(180),
          fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
          align: (center + horizon, left + horizon, left + horizon, center + horizon),
          inset: (x: 6pt, y: 3.5pt),
          table.header(
            [*Test*],
            [*Phân loại*],
            [*Dữ liệu vào (Input)*],
            [*Đáp án của bạn (Bút chì)*]
          ),
          ..rows.flatten().map(cell => [#cell])
        )
      ]
    ]
  )
}

// 2. Step-by-step Trace Matrix: Columns for Step, Line, Variables, Stack, Condition
#let trace-matrix(
  headers: ("Bước", "Dòng lệnh", "Biến số", "Ngăn xếp", "Điều kiện"),
  rows: (),
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let hdrs = if headers != () { headers } else if pos.len() > 0 { pos.at(0) } else { named.at("headers", default: ()) }
  let rws = if rows != () { rows } else if pos.len() > 1 { pos.at(1) } else { named.at("rows", default: ()) }

  let col-count = hdrs.len()
  let cols = if col-count == 5 {
    (1.4cm, 2.2fr, 2.5fr, 1.8fr, 2.2fr)
  } else {
    (1.4cm, ..range(col-count - 1).map(_ => 1fr))
  }

  block(
    width: 100%,
    stroke: 0.8pt + black,
    radius: 3pt,
    clip: true,
    spacing: 1.2em,
    breakable: true,
    [
      #table(
        columns: cols,
        stroke: 0.4pt + luma(160),
        fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
        align: (col, row) => if row == 0 { center + horizon } else if col == 0 { center + horizon } else { left + horizon },
        inset: (x: 6pt, y: 5.5pt),
        table.header(..hdrs.map(h => [*#h*])),
        ..rws.flatten().map(cell => [
          #if type(cell) == str and (cell.contains("=") or cell.contains("<=") or cell.contains("==")) {
            raw(cell)
          } else {
            cell
          }
        ])
      )
    ]
  )
}

// 3. Execution Trace Table (Format compatible with run_verifier.py)
#let trace-table(
  test-id: none,
  status: "AC",
  traces: (),
) = {
  let rows = ()
  for t in traces {
    if t.at("type", default: "") == "step" {
      rows.push((format-val(t.at("step", default: "-")), t.at("msg", default: ""), "-"))
    } else if t.at("type", default: "") == "var" {
      rows.push(("-", t.at("name", default: ""), format-val(t.at("val", default: ""))))
    } else if t.at("type", default: "") == "array" {
      rows.push(("-", t.at("name", default: ""), format-val(t.at("values", default: ()))))
    }
  }

  block(
    width: 100%,
    stroke: 0.5pt + luma(140),
    radius: 2pt,
    clip: true,
    spacing: 1em,
    breakable: true,
    [
      #if test-id != none [
        #block(
          width: 100%,
          fill: luma(240),
          inset: (x: 8pt, y: 4pt),
          stroke: (bottom: 0.5pt + luma(160)),
          [
            #grid(
              columns: (1fr, auto),
              [#text(weight: "bold", size: 8.5pt)[Vết thực thi Test #test-id]],
              [#text(weight: "bold", size: 8.5pt)[Trạng thái: #status]],
            )
          ]
        )
      ]
      #table(
        columns: (1.6cm, 2.8fr, 2.6fr),
        align: (center + horizon, left + horizon, left + horizon),
        stroke: 0.4pt + luma(180),
        fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
        inset: (x: 6pt, y: 5pt),
        table.header([*Bước*], [*Mô tả / Biến*], [*Giá trị*]),
        ..rows.flatten().map(x => [#x])
      )
    ]
  )
}

// 4. Appendix Solution Table for 10 Hand-trace Tests
#let appendix-solution(
  problem_name: "",
  solutions: (),
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let p-name = if problem_name != "" { problem_name } else if pos.len() > 0 { pos.at(0) } else { named.at("problem_name", default: "") }
  let sols = if solutions != () { solutions } else if pos.len() > 1 { pos.at(1) } else { named.at("solutions", default: ()) }

  block(
    width: 100%,
    stroke: 0.8pt + black,
    radius: 3pt,
    clip: true,
    spacing: 1.2em,
    breakable: true,
    [
      #block(
        width: 100%,
        fill: luma(235),
        inset: (x: 10pt, y: 6pt),
        stroke: (bottom: 0.8pt + black),
        [
          #text(weight: "bold", size: 10.5pt)[Lời giải & Đáp án: #p-name]
        ]
      )

      #if sols.len() > 0 [
        #let rows = ()
        #for (idx, s) in sols.enumerate() {
          let sid = if type(s) == dictionary { s.at("id", default: idx + 1) } else { idx + 1 }
          let inp = if type(s) == dictionary { s.at("input", default: "-") } else { "-" }
          let exp = if type(s) == dictionary { s.at("expected", default: "-") } else { format-val(s) }
          let note = if type(s) == dictionary { s.at("note", default: s.at("desc", default: "")) } else { "" }

          rows.push((
            align(center)[#strong(str(sid))],
            raw(str(inp)),
            raw(str(exp)),
            text(size: 8.5pt)[#note]
          ))
        }

        #table(
          columns: (1.2cm, 2fr, 2fr, 3fr),
          stroke: 0.4pt + luma(180),
          fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
          align: (center + horizon, left + horizon, left + horizon, left + horizon),
          inset: (x: 6pt, y: 3.5pt),
          table.header(
            [*Test*],
            [*Đầu vào (Input)*],
            [*Đáp án chính thức*],
            [*Ghi chú / Phương pháp*]
          ),
          ..rows.flatten().map(cell => [#cell])
        )
      ]
    ]
  )
}

// 5. Appendix Detailed Trace Matrix Walkthrough
#let appendix-trace(
  problem_name: "",
  tests_traces: (),
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()

  let p-name = if problem_name != "" { problem_name } else if pos.len() > 0 { pos.at(0) } else { named.at("problem_name", default: "") }
  let traces = if tests_traces != () { tests_traces } else if pos.len() > 1 { pos.at(1) } else { named.at("tests_traces", default: ()) }

  block(
    width: 100%,
    spacing: 1.2em,
    breakable: true,
    [
      #text(weight: "bold", size: 11pt)[Bảng Chạy Bàn Chi Tiết: #p-name]
      #v(6pt)
      #for t in traces {
        let tid = if type(t) == dictionary { t.at("id", default: none) } else { none }
        let tr = if type(t) == dictionary { t.at("traces", default: ()) } else { t }
        trace-table(test-id: tid, status: "AC", traces: tr)
      }
    ]
  )
}
