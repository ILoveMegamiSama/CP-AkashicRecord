#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Bài Tập Tích Hợp Toàn Diện V1

#term-box(
  term: "Hệ Thống Phối Hợp Kỹ Thuật Nâng Cao V1",
  origin: "Đỉnh cao của lập trình thi đấu hiện đại là khả năng kết hợp nhuần nhuyễn nhiều cấu trúc dữ liệu và giải thuật trong cùng một hệ thống thống nhất.",
  intuition: "Một bài toán cây phức tạp với cập nhật động tài nguyên và truy vấn đường đi không thể giải quyết bằng một kỹ thuật đơn lẻ. Bằng cách kết hợp Euler Tour (để tuyến tính hóa không gian cây con), Cây Fenwick (để cập nhật điểm và truy vấn tổng đoạn trong O(log N)), cùng với Binary Lifting LCA (để định tuyến ngã ba và đo khoảng cách đường đi trong O(log N)), ta kiến tạo một hệ thống vận hành với độ phức tạp tối ưu tuyệt đối."
)

== Kiến Trúc Hệ Thống: Cây Con Động & Nhảy Tổ Tiên

Quy trình giải thuật tích hợp gồm 3 tầng kiến trúc độc lập nhưng kết nối chặt chẽ:

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[Tầng 1: Tuyến Tính Hóa]
        - Duyệt DFS từ gốc 1.
        - Ghi nhận $"tin"[u], "tout"[u]$ và độ sâu $"depth"[u]$.
        - Cây con $u$ trở thành đoạn $["tin"[u], "tout"[u]]$.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[Tầng 2: Quản Lý Động BIT]
        - Mảng trải phẳng $F["tin"[u]] = V_u$.
        - Nạp vào Fenwick Tree.
        - Cập nhật điểm $P$: `add(tin[P], X)`.
        - Tổng cây con $Q$: `range_sum(tin[Q], tout[Q])`.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[Tầng 3: Nhảy Nhị Phân LCA]
        - Bảng $"up"[k][u]$ xây từ DFS.
        - Cân bằng độ sâu và nhảy đồng thời tìm $"LCA"(U, V)$.
        - Khoảng cách hành quân:
        $"depth"[U] + "depth"[V] - 2 dot "depth"["LCA"]$.
      ]
    )
  ]
)

#syntax-anatomy(
  `bit.add(tin[p], x); long long s_q = bit.range_sum(tin[q], tout[q]); int lca_node = get_lca(u, v);`,
  (
    ("bit.add(tin[p], x);", "Dùng thời điểm vào tin[p] làm chỉ số để cập nhật tài nguyên thành phố P trên Cây Fenwick."),
    ("bit.range_sum(tin[q], tout[q]);", "Truy vấn tổng tài nguyên của cây con thành phố Q nhờ đoạn liên tục [tin, tout]."),
    ("get_lca(u, v);", "Tìm điểm giao lộ ngã ba chung của hành trình quân sự giữa hai thành phố U và V.")
  )
)

== Bảng Chạy Bàn Trên Giấy: Cây 5 Đỉnh Gốc 1

Cây: $(1, 2), (1, 3), (2, 4), (2, 5)$. Giá trị ban đầu: $V = [10, 20, 30, 40, 50]$.
Truy vấn: Tiếp tế $X = 10$ cho thành phố $P = 3$; tính tổng cây con $Q = 2$; tìm LCA và khoảng cách giữa $U = 4$ và $V = 5$.

#trace-matrix(
  headers: ("Thao tác", "Dữ liệu liên quan", "Công thức tính toán", "Kết quả"),
  rows: (
    ("DFS Euler Tour", "Gốc 1", "tin: 1->1, 2->2, 4->3, 5->4, 3->5; tout: 2->4, 1->5", "Đoạn cây con Q=2: [2, 4]"),
    ("Cập nhật Fenwick", "P = 3, X = +10", "bit.add(tin[3]=5, 10) -> V[3] thành 40", "Tổng toàn cây = 150 + 10 = 160"),
    ("Truy vấn cây con Q", "Q = 2 (đoạn [2, 4])", "V[2] + V[4] + V[5] = 20 + 40 + 50", "*S_Q = 110*"),
    ("LCA & Khoảng cách", "U = 4, V = 5", "depth[4]=3, depth[5]=3, LCA(4, 5) = 2", "*LCA = 2, dist = 3 + 3 - 2(2) = 2*")
  )
)

Kết quả cuối cùng: `160 110 2 2`.

== Bài Tập Tiêu Chuẩn

#let integrated-tests = json("/code/vol4/integrated/tests.json")

#hand-trace-problem(
  name: "Bài Tập Tích Hợp 4 - Hệ Thống Cây Vương Quốc: Cập Nhật Cây Con Euler Tour + Fenwick Tree & Khoảng Cách LCA",
  source: "Chuyên khảo CP C++14 - Tích hợp cấu trúc dữ liệu nâng cao V1",
  problem_desc: [
    Một vương quốc gồm $N$ thành phố ($1 <= N <= 30$) liên kết dạng cây có gốc tại thủ đô 1.
    Mỗi thành phố $u$ ban đầu có lượng lương thực tích trữ là $V_u$ ($1 <= V_u <= 1000$).
    Các cạnh vô hướng được cho trong danh sách $N - 1$ cặp đỉnh (các đỉnh kề sắp xếp tăng dần khi DFS).
    Hệ thống nhận lệnh điều phối tổng hợp gồm:
    - Tiếp tế thêm $X$ đơn vị lương thực cho thành phố $P$ ($V_P arrow.r V_P + X$).
    - Kiểm tra tổng lương thực của toàn bộ vương quốc ($S_"root"$).
    - Kiểm tra tổng lương thực trong phân nhánh cây con do thành phố $Q$ chỉ huy ($S_Q$).
    - Tìm thành phố ngã ba trung chuyển $L = "LCA"(U, V)$ và khoảng cách hành quân $"dist"(U, V)$ giữa hai đơn vị quân đóng tại $U$ và $V$.

    Em hãy tính toán và in ra trên một dòng 4 số nguyên cách nhau bởi dấu cách:
    `S_root S_Q LCA_UV dist_UV`

    *Đầu vào (Input):*
    - Dòng 1: Ghi 6 số nguyên $N, P, X, Q, U, V$.
    - Dòng 2: Ghi $N$ số nguyên $V_1, V_2, dots, V_N$.
    - $N - 1$ dòng tiếp theo: Mỗi dòng ghi 2 số $u, v$ mô tả một cạnh cây.

    *Đầu ra (Output):* In ra 4 số nguyên `S_root S_Q LCA_UV dist_UV` trên một dòng.
  ],
  sample: (
    input: "5 3 10 2 4 5\n10 20 30 40 50\n1 2\n1 3\n2 4\n2 5\n",
    output: "160 110 2 2\n"
  ),
  tests_10: integrated-tests
)
