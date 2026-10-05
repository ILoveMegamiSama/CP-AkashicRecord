#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Bài Tập Tích Hợp Tập 3: Đồ Thị, Dijkstra & Quy Hoạch Động Trên DAG

#term-box(
  term: "Hợp Nhất Đồ Thị & Quy Hoạch Động: Shortest Path DAG",
  origin: "Mô hình quy hoạch động trên đồ thị đường đi ngắn nhất là dạng bài toán thượng thừa thường xuất hiện trong các kỳ thi VOI, ICPC Regional, và các nền tảng thi đấu như CSES/Codeforces.",
  intuition: "Khi giải bài toán 'Đếm số lượng đường đi ngắn nhất' hoặc 'Tìm đường đi ngắn nhất có số cạnh ít nhất/nhiều nhất', việc chạy thuật toán Dijkstra đơn thuần chỉ cho ta một đường đi duy nhất. Bằng cách giữ lại toàn bộ các cạnh thỏa mãn điều kiện dist[u] + w == dist[v], ta thu được một Đồ thị con không chu trình (Shortest Path DAG). Trên DAG này, ta áp dụng trọn vẹn sức mạnh của Quy hoạch động theo thứ tự khoảng cách tăng dần để đếm và tối ưu hóa mọi thuộc tính của mạng lưới."
)

== 1. Kiến Trúc Giải Pháp 2 Giai Đoạn

Quy trình giải quyết gồm 2 pha độc lập và chuẩn mực:

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
        #text(weight: "bold")[Giai Đoạn 1: Dijkstra Nguồn Đơn]
        - Chạy Dijkstra từ đỉnh nguồn 1 với Min-Heap `std::priority_queue`.
        - Tính toán mảng khoảng cách tối ưu $"dist"[u]$ tới mọi đỉnh $u in [1, N]$.
        - Xác định tập các đỉnh có thể tiếp cận ($"dist"[u] != "INF"$).
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
        #text(weight: "bold")[Giai Đoạn 2: DP Trên Shortest Path DAG]
        - Do trọng số cạnh $w >= 1$, thứ tự tăng dần của $"dist"[u]$ chính là một *thứ tự tô-pô* tự nhiên!
        - Sắp xếp các đỉnh tiếp cận theo $"dist"[u]$.
        - Duyệt từng đỉnh $u$, chuyển trạng thái cho các cạnh tối ưu: $"dist"[u] + w == "dist"[v]$.
      ]
    )
  ]
)

== 2. Công Thức Chuyển Trạng Thái Quy Hoạch Động

Với mỗi cung $u arrow.r v$ có trọng số $w$ thỏa mãn $"dist"[u] + w == "dist"[v]$:
1. *Đếm số đường đi ngắn nhất:*
$ "ways"[v] = ("ways"[v] + "ways"[u]) mod (10^9 + 7) $
2. *Số cạnh ít nhất:*
$ "min_edges"[v] = min("min_edges"[v], "min_edges"[u] + 1) $
3. *Số cạnh nhiều nhất:*
$ "max_edges"[v] = max("max_edges"[v], "max_edges"[u] + 1) $

#syntax-anatomy(
  `if (dist[u] + w == dist[v]) { ways[v] = (ways[v] + ways[u]) % MOD; min_e[v] = min(min_e[v], min_e[u] + 1); max_e[v] = max(max_e[v], max_e[u] + 1); }`,
  (
    ("dist[u] + w == dist[v]", "Điều kiện tiên quyết xác nhận cạnh u->v thuộc Shortest Path DAG."),
    ("ways[v] = (ways[v] + ways[u]) % MOD;", "Cộng dồn số lượng phương án đến từ u vào v."),
    ("min_e[v] = min(..., min_e[u] + 1);", "Cập nhật lộ trình có ít nút trung gian nhất."),
    ("max_e[v] = max(..., max_e[u] + 1);", "Cập nhật lộ trình ghé thăm nhiều trạm nhất.")
  )
)

== 3. Bảng Chạy Bàn Trên Giấy: Mạng Lưới 4 Đỉnh, 5 Cạnh

Các cạnh: $(1 arrow.r 2, 2), (1 arrow.r 3, 3), (2 arrow.r 4, 3), (3 arrow.r 4, 2), (1 arrow.r 4, 5)$.

#trace-matrix(
  headers: ("Đỉnh u", "dist[u]", "ways[u]", "min_edges[u]", "max_edges[u]", "Ghi chú lan truyền"),
  rows: (
    ("1", "0", "1", "0", "0", "Khởi tạo gốc nguồn"),
    ("2", "2", "1", "1", "1", "Nhận từ 1 qua cạnh (1->2) w=2"),
    ("3", "3", "1", "1", "1", "Nhận từ 1 qua cạnh (1->3) w=3"),
    ("4", "5", "3", "1", "2", "*Nhận từ 1 (e=1), từ 2 (e=2), từ 3 (e=2)*"),
    ("Kết quả", "min_dist = 5", "ways = 3", "min_edges = 1", "max_edges = 2", "*Đáp án: 5 3 1 2*")
  )
)

== 4. Đề Bài Bài Tập Tích Hợp

#let integrated-tests = json("/code/vol3/integrated/tests.json")

#hand-trace-problem(
  name: "Bài Tập Tích Hợp 3 - Lộ Trình Tối Ưu: Dijkstra & Quy Hoạch Động Trên Shortest Path DAG",
  source: "Tổng hợp Tập 3 - Đồ thị nâng cao & DP",
  problem_desc: [
    Cho mạng lưới giao thông gồm $N$ nút giao ($1 <= N <= 30$) và $M$ tuyến đường một chiều ($1 <= M <= 100$), mỗi tuyến đường từ $u$ đến $v$ có độ dài nguyên dương $w$ ($1 <= w <= 1000$).
    Em hãy khảo sát toàn diện hành trình di chuyển từ nút $1$ đến nút $N$:
    1. Khoảng cách ngắn nhất từ nút 1 đến nút $N$ (`min_dist`).
    2. Số lượng đường đi ngắn nhất khác nhau từ nút 1 đến nút $N$ (`ways_count`, chia lấy dư cho $10^9+7$).
    3. Số tuyến đường (số cạnh) ít nhất của một đường đi ngắn nhất từ nút 1 đến nút $N$ (`min_edges`).
    4. Số tuyến đường (số cạnh) nhiều nhất của một đường đi ngắn nhất từ nút 1 đến nút $N$ (`max_edges`).

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, M$. $M$ dòng tiếp theo, mỗi dòng ghi ba số nguyên $u, v, w$. \
    *Đầu ra (Output):* Nếu không có đường đi từ 1 đến $N$, in ra `-1`. Nếu có đường đi, in ra 4 số nguyên `min_dist ways_count min_edges max_edges` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "4 5\n1 2 2\n1 3 3\n2 4 3\n3 4 2\n1 4 5\n",
    output: "5 3 1 2\n"
  ),
  tests_10: integrated-tests
)
