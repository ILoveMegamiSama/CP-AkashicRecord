#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 22: Đồ Thị Không Chu Trình (DAG) & Sắp Xếp Tô-pô

#term-box(
  term: "Đồ Thị DAG & Thứ Tự Tuyến Tính Hóa Tô-pô",
  origin: "Sắp xếp tô-pô xuất phát từ phương pháp sơ đồ mạng PERT (Program Evaluation and Review Technique) trong công nghệ quản lý dự án những năm 1950, và thuật toán Arthur Kahn công bố năm 1962.",
  intuition: "DAG (Directed Acyclic Graph) mô hình hóa mối quan hệ phụ thuộc nhân quả không hồi quy (ví dụ: môn học tiên quyết, quy trình biên dịch phần mềm). Sắp xếp tô-pô duỗi thẳng các đỉnh của DAG thành một hàng ngang sao cho mọi mũi tên đều chỉ từ trái sang phải. Thứ tự này mở ra cánh cửa cho Quy hoạch động trên đồ thị: giải quyết bài toán đường đi dài nhất hoặc đếm số cách đi mà không bao giờ sợ bị lặp vô tận."
)

== 22.1 Định Nghĩa DAG & Sắp Xếp Tô-pô (Topological Sort)

- *DAG:* Đồ thị có hướng không chứa bất kỳ chu trình có hướng nào.
- *Thứ tự tô-pô:* Một hoán vị các đỉnh $(v_1, v_2, dots, v_N)$ sao cho với mọi cung có hướng $u arrow.r v$, đỉnh $u$ luôn xuất hiện trước đỉnh $v$ trong dãy hoán vị ($"pos"(u) < "pos"(v)$).
- Đồ thị có thứ tự tô-pô khi và chỉ khi nó là một DAG.

== 22.2 Thuật Toán Kahn: Xóa Đỉnh Có Bán Bậc Vào Bằng 0

Thuật toán Kahn mô phỏng trực giác con người:
1. Tính bán bậc vào `in_degree[v]` cho mọi đỉnh $v$.
2. Đưa các đỉnh có `in_degree[v] == 0` vào hàng đợi (dùng `std::priority_queue` nếu cần thứ tự từ điển nhỏ nhất).
3. Lặp lại: Lấy đỉnh $u$ ra khỏi hàng đợi, đưa vào kết quả; với mỗi cung $u arrow.r v$, giảm `in_degree[v]--`. Nếu `in_degree[v] == 0`, đẩy $v$ vào hàng đợi.
4. *Kiểm tra chu trình:* Nếu số đỉnh lấy ra nhỏ hơn $N$, đồ thị chứa chu trình có hướng!

#syntax-anatomy(
  `while (!pq.empty()) { int u = pq.top(); pq.pop(); for (int v : adj[u]) { if (--in_degree[v] == 0) pq.push(v); } }`,
  (
    ("while (!pq.empty())", "Lặp chừng nào vẫn còn đỉnh không bị ràng buộc bởi bất kỳ đỉnh nào khác."),
    ("int u = pq.top(); pq.pop();", "Trích xuất đỉnh có chỉ số nhỏ nhất (đảm bảo thứ tự từ điển tối ưu)."),
    ("for (int v : adj[u])", "Duyệt qua các đỉnh phụ thuộc nhận mũi tên từ u."),
    ("if (--in_degree[v] == 0) pq.push(v);", "Triệt tiêu sự phụ thuộc u; nếu v không còn phụ thuộc nào, đẩy vào hàng đợi.")
  )
)

== 22.3 Quy Hoạch Động Trên DAG (DP on DAG)

Do mọi cung đều đi theo chiều tiến của thứ tự tô-pô, DAG không có chu trình nên ta có thể áp dụng Quy hoạch động trực tiếp theo thứ tự tô-pô.
*Bài toán tìm đường đi dài nhất (Longest Path):*
$ "dp"[v] = max_((u, v) in E) ("dp"[u] + 1) $
Khởi tạo $"dp"[v] = 0$ cho mọi đỉnh. Độ dài đường đi dài nhất trong toàn bộ DAG là $max_(v in V) "dp"[v]$.

== 22.4 Bảng Chạy Bàn Trên Giấy: Đồ Thị 4 Đỉnh $(1 arrow.r 2), (1 arrow.r 3), (2 arrow.r 4), (3 arrow.r 4)$

#trace-matrix(
  headers: ("Lượt", "Đỉnh u lấy ra", "Cập nhật bán bậc vào", "Cập nhật dp[v] (Đường đi)", "Hàng đợi pq"),
  rows: (
    ("Khởi tạo", "-", "in_deg: [-, 0, 1, 1, 2]", "dp: [-, 0, 0, 0, 0]", "[1]"),
    ("1", "1", "in_deg[2]=0, in_deg[3]=0", "dp[2]=1, dp[3]=1", "[2, 3]"),
    ("2", "2", "in_deg[4] = 1", "dp[4] = max(0, dp[2]+1=2) = 2", "[3]"),
    ("3", "3", "in_deg[4] = 0 (Đẩy 4 vào pq)", "dp[4] = max(2, dp[3]+1=2) = 2", "[4]"),
    ("4", "4", "Không còn đỉnh phụ thuộc", "-", "rỗng"),
    ("Kết thúc", "-", "Thứ tự tô-pô: [1, 2, 3, 4]", "*Đường đi dài nhất = 2*", "*Hợp lệ (DAG)*")
  )
)

== 22.5 Bài Tập Tiêu Chuẩn

#let ch22-tests = json("/code/vol3/ch22_dag_toposort/tests.json")

#hand-trace-problem(
  name: "Bài 22.1 - Đồ Thị Không Chu Trình (DAG): Sắp Xếp Tô-pô & Đường Đi Dài Nhất",
  source: "Nền tảng C++14 - Đồ thị DAG & Sắp xếp Tô-pô",
  problem_desc: [
    Cho một đồ thị có hướng gồm $N$ đỉnh (được đánh số từ $1$ đến $N$) và $M$ cung có hướng ($1 <= N <= 30, 0 <= M <= 100$).

    Em hãy thực hiện:
    1. Kiểm tra xem đồ thị có chứa chu trình có hướng hay không. Nếu có chu trình (không phải DAG), in ra `-1`.
    2. Nếu đồ thị là DAG:
       - Tìm thứ tự tô-pô có thứ tự từ điển nhỏ nhất bằng thuật toán Kahn kết hợp min-heap (`std::priority_queue`).
       - Tìm độ dài đường đi dài nhất (tính theo số cạnh) trong toàn bộ DAG bằng Quy hoạch động trên thứ tự tô-pô.

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, M$. $M$ dòng tiếp theo, mỗi dòng ghi hai số nguyên $u, v$ mô tả cung từ $u$ tới $v$. \
    *Đầu ra (Output):* Nếu có chu trình, in ra `-1`. Nếu là DAG, in ra độ dài đường đi dài nhất `longest_path`, tiếp theo là $N$ đỉnh theo thứ tự tô-pô từ điển nhỏ nhất trên cùng một dòng.
  ],
  sample: (
    input: "4 4\n1 2\n1 3\n2 4\n3 4\n",
    output: "2 1 2 3 4\n"
  ),
  tests_10: ch22-tests
)
