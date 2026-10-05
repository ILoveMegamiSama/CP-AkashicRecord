#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 21: Duyệt Đồ Thị Cơ Bản BFS & DFS

#term-box(
  term: "Duyệt Đồ Thị, Liên Thông & Đồ Thị Hai Phía",
  origin: "Duyệt theo chiều sâu (DFS) và duyệt theo chiều rộng (BFS) được phát triển vào thế kỷ 19 để giải mê cung (thuật toán Trémaux) và chính thức hóa bởi Edward F. Moore (1959) trong bài toán tìm đường ngắn nhất.",
  intuition: "Duyệt đồ thị là hành vi khám phá toàn bộ không gian đỉnh và cạnh một cách có hệ thống. DFS sử dụng cơ chế Ngăn xếp (Stack/Recursion) để đi sâu nhất có thể dọc theo một nhánh trước khi quay lui. BFS sử dụng Hàng đợi (Queue) để lan truyền đồng tâm theo từng tầng sóng, đảm bảo tìm ra đường đi có ít cạnh nhất trên đồ thị không trọng số."
)

== 21.1 So Sánh Bản Chất: DFS Đối Đầu BFS

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
        #text(weight: "bold")[1. DFS (Depth-First Search)]
        - *Cấu trúc:* Call Stack hoặc `std::stack`.
        - *Cơ chế:* Thăm sâu đến tận cùng rồi Backtrack.
        - *Bộ nhớ:* $O(V)$ phụ thuộc vào độ sâu cây DFS.
        - *Ứng dụng:* Đếm thành phần liên thông, tìm chu trình, khớp/cầu, topo-sort, tô màu 2 phía.
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
        #text(weight: "bold")[2. BFS (Breadth-First Search)]
        - *Cấu trúc:* Hàng đợi `std::queue`.
        - *Cơ chế:* Lan tỏa theo từng mức khoảng cách (Layer by Layer).
        - *Bộ nhớ:* $O(V)$ lưu trữ biên sóng duyệt.
        - *Ứng dụng:* Đường đi ngắn nhất không trọng số, tìm thành phần liên thông, đồ thị hai phía.
      ]
    )
  ]
)

== 21.2 Tìm Thành Phần Liên Thông (Connected Components)

Trong đồ thị vô hướng, một thành phần liên thông là một đồ thị con tối đại mà giữa hai đỉnh bất kỳ luôn tồn tại đường đi.
- Thuật toán: Dùng mảng `visited[]` đánh dấu các đỉnh đã thăm.
- Duyệt qua tất cả các đỉnh $i = 1 .. N$. Nếu đỉnh $i$ chưa được thăm (`!visited[i]`), ta khởi động một lượt duyệt BFS/DFS mới, tăng biến đếm số thành phần liên thông lên 1, và đếm tổng số đỉnh thuộc thành phần đó.

== 21.3 Đồ Thị Hai Phía (Bipartite Graph) & Tô 2 Màu

Một đồ thị là hai phía nếu tập đỉnh có thể chia thành hai tập rời rạc $V_1, V_2$ sao cho mọi cạnh chỉ nối giữa một đỉnh thuộc $V_1$ và một đỉnh thuộc $V_2$.

*Định lý König:* Một đồ thị là đồ thị hai phía khi và chỉ khi *không chứa chu trình có độ dài lẻ*.

#syntax-anatomy(
  `if (color[v] == -1) { color[v] = 1 - color[u]; q.push(v); } else if (color[v] == color[u]) { is_bipartite = false; }`,
  (
    ("if (color[v] == -1)", "Đỉnh v chưa được tô màu: gán màu đối nghịch với đỉnh u."),
    ("color[v] = 1 - color[u];", "Công thức đảo màu tinh tế: 0 biến thành 1, 1 biến thành 0."),
    ("else if (color[v] == color[u])", "Đỉnh kề đã được tô nhưng có cùng màu với đỉnh hiện tại."),
    ("is_bipartite = false;", "Phát hiện xung đột màu: đồ thị chứa chu trình lẻ, không thể là đồ thị hai phía.")
  )
)

== 21.4 Bảng Chạy Bàn Trên Giấy: Đồ Thị 6 Đỉnh 2 Thành Phần

Đồ thị gồm các cạnh $(1, 2), (2, 3), (3, 1)$ (thành phần 1) và $(4, 5), (5, 6)$ (thành phần 2).

#trace-matrix(
  headers: ("Bước", "Đỉnh u", "Hành động / Màu", "Hàng đợi queue", "Trạng thái Bipartite"),
  rows: (
    ("1", "1", "Khởi tạo thành phần 1, color[1]=0", "[1]", "Khởi đầu hợp lệ"),
    ("2", "1", "Pop 1 -> duyệt 2 (color=1), 3 (color=1)", "[2, 3]", "Tô màu đối nghịch"),
    ("3", "2", "Pop 2 -> duyệt 3: color[3]==color[2]==1!", "[3]", "*Xung đột màu: Chu trình lẻ C3!*"),
    ("4", "4", "Khởi tạo thành phần 2, color[4]=0", "[4]", "is_bipartite = false"),
    ("5", "4", "Pop 4 -> duyệt 5 (color=1)", "[5]", "-"),
    ("6", "5", "Pop 5 -> duyệt 6 (color=0)", "[6]", "-"),
    ("Kết thúc", "-", "2 thành phần, max_size = 3", "rỗng", "*is_bipartite = 0 (Không phải hai phía)*")
  )
)

== 21.5 Bài Tập Tiêu Chuẩn

#let ch21-tests = json("/code/vol3/ch21_bfs_dfs/tests.json")

#hand-trace-problem(
  name: "Bài 21.1 - Duyệt Đồ Thị Cơ Bản: Thành Phần Liên Thông & Đồ Thị Hai Phía",
  source: "Nền tảng C++14 - Duyệt đồ thị cơ bản",
  problem_desc: [
    Cho một đồ thị vô hướng gồm $N$ đỉnh (được đánh số từ $1$ đến $N$) và $M$ cạnh ($1 <= N <= 30, 0 <= M <= 100$).
    Đồ thị có thể không liên thông và có thể chứa nhiều thành phần độc lập.

    Em hãy sử dụng thuật toán duyệt đồ thị (BFS hoặc DFS) để tính toán:
    1. Tổng số lượng thành phần liên thông của đồ thị (`comp_count`).
    2. Kích thước (số lượng đỉnh) của thành phần liên thông lớn nhất (`max_comp_size`).
    3. Kiểm tra xem toàn bộ đồ thị có phải là đồ thị hai phía (Bipartite Graph) hay không (`is_bipartite`: in ra 1 nếu là đồ thị hai phía, 0 nếu không).

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, M$. $M$ dòng tiếp theo, mỗi dòng ghi hai số nguyên $u, v$. \
    *Đầu ra (Output):* In ra 3 số nguyên `comp_count max_comp_size is_bipartite` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "6 5\n1 2\n2 3\n3 1\n4 5\n5 6\n",
    output: "2 3 0\n"
  ),
  tests_10: ch21-tests
)
