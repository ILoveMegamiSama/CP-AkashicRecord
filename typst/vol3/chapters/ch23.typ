#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 23: Cây (Trees) & Các Thuộc Tính Đặc Biệt

#term-box(
  term: "Cấu Trúc Cây & Thuật Toán 2 Lần DFS Tìm Đường Kính",
  origin: "Khái niệm cây được Arthur Cayley đưa ra năm 1857 khi nghiên cứu các đồng phân hóa học hữu cơ phân nhánh, trở thành cấu trúc dữ liệu nền tảng nhất của khoa học máy tính.",
  intuition: "Một cái cây là một đồ thị liên thông nhưng tối giản đến mức thanh khiết: nó có N đỉnh và đúng N - 1 cạnh, không có chu trình. Giữa hai đỉnh bất kỳ trên cây chỉ tồn tại duy nhất một đường đi đơn. Mọi nhánh cây khi cắt bỏ một cạnh lập tức bị chia tách thành hai thành phần độc lập, mở ra các tính chất quy nạp tuyệt đẹp về kích thước cây con và đường kính cực đại."
)

== 23.1 Định Nghĩa & Các Thuộc Tính Toán Học Của Cây

Cho đồ thị vô hướng $G = (V, E)$ có $N$ đỉnh. Các mệnh đề sau tương đương:
1. $G$ là một cây (liên thông và không có chu trình).
2. $G$ liên thông và có đúng $N - 1$ cạnh.
3. $G$ không có chu trình và có đúng $N - 1$ cạnh.
4. Giữa hai đỉnh bất kỳ trên cây tồn tại duy nhất một đường đi đơn.

== 23.2 Cây Có Gốc (Rooted Tree) & Kích Thước Cây Con

Khi chọn đỉnh 1 làm gốc (Root):
- Quan hệ cha - con: Mọi đỉnh $u != 1$ có duy nhất một nút cha $p = "parent"[u]$.
- Chiều sâu (Depth): $"depth"[1] = 0$, $"depth"[v] = "depth"[u] + 1$ với $v$ là con của $u$.
- Nút lá (Leaves): Nút không có con nào (bậc bằng 1 khi khác gốc).
- Kích thước cây con (Subtree Size):
$ "subtree_size"[u] = 1 + sum_(v in "children"(u)) "subtree_size"[v] $

== 23.3 Đường Kính Của Cây (Tree Diameter) & Thuật Toán 2 Lần DFS

Đường kính cây $D$ là khoảng cách lớn nhất giữa hai đỉnh bất kỳ trên cây:
$ D = max_(u, v in V) "dist"(u, v) $

Thuật toán 2 lần DFS (Double DFS Algorithm):
1. *DFS lần 1:* Xuất phát từ một đỉnh bất kỳ (thường là đỉnh 1), tìm đỉnh $A$ có khoảng cách xa nhất.
2. *DFS lần 2:* Xuất phát từ đỉnh $A$, tìm đỉnh $B$ có khoảng cách xa nhất.
*Kết luận:* Khoảng cách $"dist"(A, B)$ chính là đường kính của cây!

#callout(kind: "tip", title: "Chứng minh tính đúng đắn trên giấy của 2 lần DFS")[
  Giả sử đường kính thực sự của cây nối giữa hai đỉnh $U$ và $V$. Khi ta xuất phát từ đỉnh 1 bất kỳ, đỉnh $A$ xa nhất tìm được *chắc chắn phải là một trong hai đầu mút $U$ hoặc $V$* (bởi nếu không, đường đi từ 1 đến $A$ kết hợp với đường kính sẽ tạo ra một đường đi đơn dài hơn $"dist"(U, V)$, mâu thuẫn với giả thiết $"dist"(U, V)$ là đường kính lớn nhất).
]

#syntax-anatomy(
  `void dfs(int u, int p, int d) { if (d > max_dist) { max_dist = d; farthest = u; } for (int v : adj[u]) if (v != p) dfs(v, u, d + 1); }`,
  (
    ("void dfs(int u, int p, int d)", "Hàm DFS nhận đỉnh hiện tại u, đỉnh cha p để chống đi ngược, và khoảng cách d."),
    ("if (d > max_dist)", "Kiểm tra và cập nhật đỉnh xa nhất từng ghi nhận."),
    ("for (int v : adj[u])", "Duyệt qua mọi đỉnh kề của u."),
    ("if (v != p)", "Ngăn đệ quy quay lại đỉnh cha, bảo toàn tính chất cây không chu trình.")
  )
)

== 23.4 Bảng Chạy Bàn Trên Giấy: Cây 5 Đỉnh Gốc 1 Với Cạnh $(1, 2), (1, 3), (2, 4), (2, 5)$

#trace-matrix(
  headers: ("Lần DFS", "Đỉnh xuất phát", "Đỉnh xa nhất tìm được", "Khoảng cách max", "Ý nghĩa hình học"),
  rows: (
    ("DFS 1", "1", "4 (hoặc 5)", "2", "Tìm được một đầu mút của đường kính: A = 4"),
    ("DFS 2", "4", "3 (qua 4 -> 2 -> 1 -> 3)", "3", "*Tìm được đầu mút đối diện: B = 3*"),
    ("Gốc 1", "Duyệt cây con", "subtree_size[2] = 3", "subtree_size[3] = 1", "max_child_subtree_size = 3"),
    ("Tổng kết", "-", "max_depth = 2 (tới 4, 5)", "Số lá: 3 (3, 4, 5)", "*Đường kính D = 3*")
  )
)

== 23.5 Bài Tập Tiêu Chuẩn

#let ch23-tests = json("/code/vol3/ch23_trees/tests.json")

#hand-trace-problem(
  name: "Bài 23.1 - Cây & Thuộc Tính Cốt Lõi: Chiều Cao, Đường Kính & Cây Con",
  source: "Nền tảng C++14 - Lý thuyết cây & DFS",
  problem_desc: [
    Cho một cây gồm $N$ đỉnh ($1 <= N <= 30$) và $N - 1$ cạnh, các đỉnh được đánh số từ $1$ đến $N$.
    Cây được coi là có gốc tại đỉnh 1.

    Em hãy tính toán:
    1. Đường kính của cây (`diameter`): Khoảng cách lớn nhất giữa hai đỉnh bất kỳ trên cây (sử dụng thuật toán 2 lần DFS).
    2. Chiều cao lớn nhất của cây (`max_depth`): Khoảng cách lớn nhất từ đỉnh gốc 1 đến một đỉnh bất kỳ trên cây ($"depth"[1] = 0$).
    3. Số lượng nút lá của cây (`leaf_count`): Số lượng nút trong cây không có con nào khi coi 1 là gốc.
    4. Kích thước cây con lớn nhất trong số các cây con của các con trực tiếp của gốc 1 (`max_child_subtree_size`). Nếu $N = 1$, giá trị này là 0.

    *Đầu vào (Input):* Dòng 1 ghi số nguyên $N$. $N-1$ dòng tiếp theo, mỗi dòng ghi hai số nguyên $u, v$ mô tả một cạnh. \
    *Đầu ra (Output):* In ra 4 số nguyên `diameter max_depth leaf_count max_child_subtree_size` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "5\n1 2\n1 3\n2 4\n2 5\n",
    output: "3 2 3 3\n"
  ),
  tests_10: ch23-tests
)
