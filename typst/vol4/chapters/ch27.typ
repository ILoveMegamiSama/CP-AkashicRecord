#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 27: Tổ Tiên Chung Gần Nhất (Lowest Common Ancestor - LCA)

#term-box(
  term: "Tổ Tiên Chung Gần Nhất (LCA) Trên Cây",
  origin: "Bài toán LCA được Aho, Hopcroft và Ullman chính thức đặt ra năm 1973 và phát triển rực rỡ qua công trình của Harel & Tarjan (1984), Bender & Farach-Colton (2000).",
  intuition: "Trên một cái cây có gốc, khi hai người đứng ở hai đỉnh bất kỳ u và v cùng nhìn ngược lên cội nguồn (gốc cây), các nhánh cội nguồn của họ cuối cùng sẽ giao nhau tại một nhánh chung đầu tiên. Đỉnh giao nhau đó chính là Tổ tiên chung gần nhất LCA(u, v). LCA là 'ngã ba đường' phân định ranh giới giữa hai nhánh và là chìa khóa vàng để tính khoảng cách giữa mọi cặp đỉnh trên cây."
)

== 27.1 Cấu Trúc Bảng Tổ Tiên Nhị Phân `up[k][u]`

Cho cây $N$ đỉnh có gốc tại đỉnh 1.
- Mỗi đỉnh $u$ có độ sâu $"depth"[u]$ (quy ước gốc $"depth"[1] = 1$).
- Đỉnh cha trực tiếp của $u$ là $"parent"[u]$ (gốc 1 có $"parent"[1] = 1$).
- Bảng $"up"[k][u]$ lưu tổ tiên thứ $2^k$ của đỉnh $u$:
$ "up"[0][u] = "parent"[u] $
$ "up"[k][u] = "up"[k-1]["up"[k-1][u]] quad (k = 1, 2, dots, 19) $

Bảng này được tiền xử lý hoàn tất trong $O(N log N)$ sau đúng một lần duyệt DFS.

== 27.2 Thuật Toán Tìm LCA Qua Hai Giai Đoạn

Để tìm $"LCA"(u, v)$, giả sử không mất tính tổng quát rằng $"depth"[u] >= "depth"[v]$:

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[Giai đoạn 1: Cân bằng độ sâu]
        - Tính chênh lệch độ sâu: $Delta = "depth"[u] - "depth"[v]$.
        - Dùng kỹ thuật Binary Lifting nâng đỉnh $u$ lên $Delta$ bậc để đưa $u$ về cùng độ sâu với $v$.
        - *Nếu sau khi nâng mà $u == v$:* Ta kết luận ngay $"LCA"(u, v) = v$ (vì $v$ chính là tổ tiên trực tiếp của $u$).
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
        #text(weight: "bold")[Giai đoạn 2: Cùng nhảy lên ngã ba]
        - Duyệt số mũ $k$ giảm dần từ $log_2 N$ về 0.
        - Tại mỗi $k$, nếu $"up"[k][u] != "up"[k][v]$, ta cùng nâng cả hai: $u = "up"[k][u]$ và $v = "up"[k][v]$.
        - Khi dừng lại, $u$ và $v$ nằm ngay dưới ngã ba chung. Do đó:
        $ "LCA" = "up"[0][u] $
      ]
    )
  ]
)

== 27.3 Công Thức Tính Khoảng Cách Trên Cây

Đường đi ngắn nhất giữa hai đỉnh $u$ và $v$ trên cây luôn đi từ $u$ lên $"LCA"(u, v)$, rồi từ $"LCA"(u, v)$ đi xuống $v$.
Do đó, khoảng cách (số cạnh) giữa hai đỉnh được tính tức thời qua công thức:
$ "dist"(u, v) = "depth"[u] + "depth"[v] - 2 dot "depth"["LCA"(u, v)] $

#syntax-anatomy(
  `for (int k = MAX_LOG - 1; k >= 0; --k) { if (up[k][u] != up[k][v]) { u = up[k][u]; v = up[k][v]; } } return up[0][u];`,
  (
    ("for (int k = MAX_LOG - 1; k >= 0; --k)", "Duyệt bước nhảy giảm dần từ 2^19 xuống 2^0 theo nguyên lý tham lam nhị phân."),
    ("if (up[k][u] != up[k][v])", "Chỉ nhảy khi hai đỉnh chưa vượt qua đỉnh tổ tiên chung để không bị vượt ngã ba."),
    ("u = up[k][u]; v = up[k][v];", "Đồng thời nâng cả hai đỉnh lên độ cao mới bảo toàn sự cân bằng độ sâu."),
    ("return up[0][u];", "Sau vòng lặp, u và v đứng ngay dưới LCA, bước cha trực tiếp up[0][u] chính là kết quả.")
  )
)

== 27.4 Bảng Chạy Bàn Trên Giấy: Cây 5 Đỉnh Gốc 1

Cạnh: $(1, 2), (1, 3), (2, 4), (2, 5)$.
Độ sâu: $"depth"[1]=1, "depth"[2]=2, "depth"[3]=2, "depth"[4]=3, "depth"[5]=3$.

#trace-matrix(
  headers: ("Cặp truy vấn (u, v)", "depth[u], depth[v]", "Cân bằng độ sâu", "Nhảy đồng thời", "LCA", "Khoảng cách dist(u, v)"),
  rows: (
    ("(4, 5)", "3, 3", "Cùng depth = 3", "up[0][4] = 2 == up[0][5] = 2", "2", "3 + 3 - 2(2) = 2"),
    ("(4, 3)", "3, 2", "u = up[0][4] = 2", "up[0][2] = 1 == up[0][3] = 1", "1", "3 + 2 - 2(1) = 3"),
    ("(1, 5)", "1, 3", "v = up[1][5] = 1 == u", "Dừng ngay: u == v", "1", "1 + 3 - 2(1) = 2")
  )
)

== 27.5 Bài Tập Tiêu Chuẩn

#let ch27-tests = json("/code/vol4/ch27_lca/tests.json")

#hand-trace-problem(
  name: "Bài 27.1 - Tổ Tiên Chung Gần Nhất: LCA Trên Cây Qua Nhảy Nhị Phân",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho một đồ thị cây gồm $N$ đỉnh ($1 <= N <= 30$) có gốc tại đỉnh 1. Cây được cho bởi danh sách $N - 1$ cạnh vô hướng.
    Quy ước độ sâu của đỉnh gốc là $"depth"[1] = 1$.
    Các danh sách kề được sắp xếp theo thứ tự số hiệu đỉnh tăng dần trước khi duyệt DFS xây dựng bảng nhảy nhị phân `up[k][u]`.
    Cho truy vấn gồm cặp đỉnh $(u, v)$.

    Em hãy tính toán và in ra trên một dòng 3 số nguyên cách nhau bởi dấu cách:
    1. `lca`: Số hiệu đỉnh là tổ tiên chung gần nhất của $u$ và $v$.
    2. `dist`: Khoảng cách (số cạnh) giữa hai đỉnh $u$ và $v$ trên cây.
    3. `depth_lca`: Độ sâu của đỉnh `lca` tìm được.

    *Đầu vào (Input):*
    - Dòng 1: Ghi 3 số nguyên $N, u, v$.
    - $N - 1$ dòng tiếp theo: Mỗi dòng ghi 2 số nguyên $x, y$ mô tả một cạnh của cây.

    *Đầu ra (Output):* In ra 3 số nguyên `lca dist depth_lca` trên một dòng.
  ],
  sample: (
    input: "5 4 5\n1 2\n1 3\n2 4\n2 5\n",
    output: "2 2 2\n"
  ),
  tests_10: ch27-tests
)
