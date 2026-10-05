#import "../templates/book_theme.typ": book-setup
#import "../templates/components.typ": syntax-anatomy, callout, term-box
#import "../templates/trace_table.typ": hand-trace-problem, trace-matrix, appendix-solution, appendix-trace

#show: book-setup.with(
  title: "Lập Trình Thi Đấu C++14",
  volume: "Tập 1: Nền Tảng",
  author: "Akashic Record",
)

= Chương 1: Kiểm Thử Bản Mẫu

== Mục 1.1: Khái Niệm Cơ Bản

#callout(kind: "theory", title: "Khái niệm", [Văn bản thử nghiệm đơn sắc.])

#callout(kind: "memory", title: "Mô hình bộ nhớ", [Bộ nhớ RAM được đánh số tuần tự từ 0.])

#term-box(
  term: "Amortized Time",
  origin: "Từ tiếng Latin 'admortire' (làm tiêu hao dần)",
  intuition: "Chi phí trung bình được san sẻ đều qua một chuỗi các thao tác liên tiếp."
)

#syntax-anatomy(
  `bool operator<(const Edge& other) const`,
  (
    ("const Edge&", "Tham chiếu hằng tránh sao chép"),
    ("const đuôi", "Không thay đổi thuộc tính đối tượng gọi")
  )
)

== Mục 1.2: Bài Tập Chạy Bàn

#hand-trace-problem(
  name: "Tính Tổng Dãy Số",
  source: "Codeforces 100A",
  problem_desc: [Cho số nguyên dương $N$. Tính $S = sum_(i=1)^N i$.],
  sample: (input: "5", output: "15"),
  tests_10: (
    (id: 1, group: "Cơ bản", input: "1", expected: "1"),
    (id: 2, group: "Cơ bản", input: "2", expected: "3"),
    (id: 3, group: "Cơ bản", input: "3", expected: "6"),
    (id: 4, group: "Cơ bản", input: "4", expected: "10"),
    (id: 5, group: "Biên", input: "0", expected: "0"),
    (id: 6, group: "Biên", input: "5", expected: "15"),
    (id: 7, group: "Bẫy tư duy", input: "10", expected: "55"),
    (id: 8, group: "Bẫy tư duy", input: "7", expected: "28"),
    (id: 9, group: "Thử thách tính nhẩm", input: "8", expected: "36"),
    (id: 10, group: "Thử thách tính nhẩm", input: "9", expected: "45"),
  )
)

== Mục 1.3: Ma Trận Chạy Bàn

#trace-matrix(
  headers: ("Bước", "Dòng lệnh", "Biến số", "Ngăn xếp", "Điều kiện"),
  rows: (
    ("1", "sum = 0", "sum=0, i=1", "main()", "i <= 5 (true)"),
    ("2", "sum += i", "sum=1, i=2", "main()", "i <= 5 (true)"),
    ("3", "sum += i", "sum=3, i=3", "main()", "i <= 5 (true)"),
  )
)

== Phụ Lục: Lời Giải & Vết Trace

#appendix-solution(
  problem_name: "Tính Tổng Dãy Số",
  solutions: (
    (id: 1, input: "1", expected: "1", note: "N=1 -> 1"),
    (id: 2, input: "2", expected: "3", note: "1+2=3"),
    (id: 3, input: "3", expected: "6", note: "1+2+3=6"),
    (id: 4, input: "4", expected: "10", note: "1+2+3+4=10"),
    (id: 5, input: "0", expected: "0", note: "N=0 -> 0"),
    (id: 6, input: "5", expected: "15", note: "15"),
    (id: 7, input: "10", expected: "55", note: "10*11/2=55"),
    (id: 8, input: "7", expected: "28", note: "7*8/2=28"),
    (id: 9, input: "8", expected: "36", note: "8*9/2=36"),
    (id: 10, input: "9", expected: "45", note: "9*10/2=45"),
  )
)

#appendix-trace(
  problem_name: "Tính Tổng Dãy Số (Test 1)",
  tests_traces: (
    (
      id: 1,
      traces: (
        (type: "step", step: 1, msg: "Khởi tạo tổng"),
        (type: "var", name: "sum", val: 0),
        (type: "step", step: 2, msg: "Cộng dồn i=1"),
        (type: "var", name: "sum", val: 1),
      )
    ),
  )
)
