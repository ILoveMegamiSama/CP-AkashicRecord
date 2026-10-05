#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 20: Lý Thuyết Đồ Thị & Cách Biểu Diễn

#term-box(
  term: "Cấu Trúc Đồ Thị & Biểu Diễn Danh Sách Kề",
  origin: "Lý thuyết đồ thị ra đời năm 1736 khi Leonhard Euler giải quyết bài toán nổi tiếng 7 cây cầu ở Königsberg, khởi đầu cho ngành topo học và mạng lưới rời rạc.",
  intuition: "Đồ thị G = (V, E) là mô hình trừu tượng hóa mối quan hệ giữa các thực thể: mỗi thực thể là một đỉnh (Vertex), và mỗi quan hệ/kết nối là một cạnh (Edge). Lựa chọn cấu trúc dữ liệu để biểu diễn đồ thị trong bộ nhớ máy tính quyết định trực tiếp đến tính khả thi về thời gian và không gian của mọi thuật toán tìm kiếm đường đi."
)

== 20.1 Các Khái Niệm Cơ Bản Trong Lý Thuyết Đồ Thị

- *Đỉnh ($V$) và Cạnh ($E$):* Đồ thị gồm tập đỉnh $V$ và tập cạnh $E$.
- *Đồ thị có hướng vs vô hướng:* Cạnh có hướng là cặp có thứ tự $(u, v)$; cạnh vô hướng là tập $\{u, v\}$.
- *Bậc của đỉnh ($"deg"(v)$):*
  - Trong đồ thị vô hướng: số lượng cạnh gắn vào đỉnh $v$.
  - Trong đồ thị có hướng: bán bậc vào $"deg"^-(v)$ (số cung đi vào) và bán bậc ra $"deg"^+(v)$ (số cung đi ra).
- *Bổ đề bắt tay (Handshaking Lemma):* Tổng bậc của tất cả các đỉnh bằng hai lần số cạnh:
$ sum_(v in V) "deg"(v) = 2 |E| $
Hệ quả: Số lượng đỉnh có bậc lẻ luôn là một số chẵn!

== 20.2 So Sánh 3 Cấu Trúc Biểu Diễn Đồ Thị Trong C++14

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 6pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[1. Ma Trận Kề]
        - Mảng 2D `matrix[u][v]`.
        - Bộ nhớ: $O(V^2)$.
        - Kiểm tra $(u, v) in E$: $O(1)$.
        - Duyệt đỉnh kề: $O(V)$.
        - *Phù hợp:* Đồ thị dày ($E approx V^2$), $V <= 1000$.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 6pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[2. Danh Sách Cạnh]
        - `vector<pair<int, int>>`.
        - Bộ nhớ: $O(E)$.
        - Kiểm tra $(u, v)$: $O(E)$.
        - Duyệt đỉnh kề: $O(E)$.
        - *Phù hợp:* Thuật toán Kruskal (MST), Bellman-Ford.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 6pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[3. Danh Sách Kề]
        - `vector<int> adj[N]`.
        - Bộ nhớ: $O(V + E)$.
        - Kiểm tra $(u, v)$: $O("deg"(u))$.
        - Duyệt đỉnh kề: $O("deg"(u))$.
        - *Chuẩn mực CP:* BFS, DFS, Dijkstra, TopoSort.
      ]
    )
  ]
)

#callout(kind: "warning", title: "Cảnh báo kích thước bộ nhớ ma trận kề")[
  Nếu $V = 10^5$, một ma trận kề kiểu `bool matrix[V][V]` đòi hỏi xấp xỉ $10^{10}$ bytes ($approx 10$ GB RAM), lập tức bị lỗi Memory Limit Exceeded (MLE). Danh sách kề `vector<int> adj[V]` chỉ tiêu tốn $O(V + E)$, với $V, E <= 2 times 10^5$ chỉ mất khoảng 15 MB RAM.
]

== 20.3 Cài Đặt Danh Sách Kề Chuẩn Mực Trong C++14

#syntax-anatomy(
  `std::vector<std::vector<int>> adj(n + 1); adj[u].push_back(v); adj[v].push_back(u);`,
  (
    ("std::vector<std::vector<int>> adj(n + 1);", "Khởi tạo vector chứa n+1 danh sách kề (đánh số 1-indexed an toàn)."),
    ("adj[u].push_back(v);", "Thêm đỉnh v vào danh sách lân cận của đỉnh u."),
    ("adj[v].push_back(u);", "Với đồ thị vô hướng, cạnh đối xứng bắt buộc phải thêm ngược lại u vào adj[v].")
  )
)

== 20.4 Bảng Chạy Bàn Trên Giấy: Đồ Thị 4 Đỉnh Với Các Cạnh $(1, 2), (2, 3), (3, 4)$

#trace-matrix(
  headers: ("Đỉnh v", "Danh sách kề adj[v]", "Bậc deg(v)", "Phân loại đỉnh", "Kiểm tra đơn đồ thị"),
  rows: (
    ("1", "[2]", "1", "Đỉnh treo (lá)", "Không có khuyên"),
    ("2", "[1, 3]", "2", "Đỉnh trung gian", "Không có cạnh lặp"),
    ("3", "[2, 4]", "2", "Đỉnh trung gian", "Không có cạnh lặp"),
    ("4", "[3]", "1", "Đỉnh treo (lá)", "Không có khuyên"),
    ("Tổng kết", "-", "max_deg = 2 (Đỉnh 2)", "0 đỉnh cô lập", "*Đơn đồ thị: 1 (Hợp lệ)*")
  )
)

== 20.5 Bài Tập Tiêu Chuẩn

#let ch20-tests = json("/code/vol3/ch20_graph_representation/tests.json")

#hand-trace-problem(
  name: "Bài 20.1 - Biểu Diễn Đồ Thị & Phân Tích Bậc Đỉnh",
  source: "Nền tảng C++14 - Lý thuyết đồ thị cơ bản",
  problem_desc: [
    Cho một đồ thị vô hướng gồm $N$ đỉnh (được đánh số từ $1$ đến $N$) và $M$ cạnh ($1 <= N <= 30, 0 <= M <= 100$).
    Các cạnh được cho dưới dạng danh sách cặp đỉnh $(u_i, v_i)$.

    Em hãy xây dựng biểu diễn đồ thị bằng danh sách kề và tính toán:
    1. Bậc lớn nhất của một đỉnh trong đồ thị (`max_deg`).
    2. Đỉnh có bậc lớn nhất (`best_vertex`). Nếu có nhiều đỉnh cùng đạt bậc lớn nhất, chọn đỉnh có chỉ số nhỏ nhất.
    3. Số lượng đỉnh cô lập trong đồ thị (`isolated_count`), tức các đỉnh có bậc bằng 0.
    4. Kiểm tra xem đồ thị có phải là đơn đồ thị (Simple Graph) hay không (`is_simple`: in ra 1 nếu là đơn đồ thị, 0 nếu chứa cạnh khuyên hoặc đa cạnh song song).

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, M$. $M$ dòng tiếp theo, mỗi dòng ghi hai số nguyên $u, v$. \
    *Đầu ra (Output):* In ra 4 số nguyên `max_deg best_vertex isolated_count is_simple` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "4 3\n1 2\n2 3\n3 4\n",
    output: "2 2 0 1\n"
  ),
  tests_10: ch20-tests
)
