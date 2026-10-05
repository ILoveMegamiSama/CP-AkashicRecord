#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 24: Đường Đi Ngắn Nhất Với Thuật Toán Dijkstra

#term-box(
  term: "Thuật Toán Dijkstra & Hàng Đợi Ưu Tiên Min-Heap",
  origin: "Được nhà khoa học máy tính người Hà Lan Edsger W. Dijkstra phát minh năm 1956 chỉ trong 20 phút khi uống cà phê cùng vị hôn thê, và công bố năm 1959.",
  intuition: "Dijkstra là sự kết hợp hoàn hảo giữa Thuật toán Tham lam (Greedy) và Quy hoạch động. Xuất phát từ đỉnh nguồn, tại mỗi bước thuật toán luôn 'chốt hạ' khoảng cách ngắn nhất của đỉnh chưa thăm có nhãn khoảng cách nhỏ nhất. Sau đó, nó dùng đỉnh này để thư giãn (Relaxation) khoảng cách tới các đỉnh kề. Bằng cách sử dụng Min-Heap (priority_queue), thời gian trích xuất đỉnh tối ưu giảm từ O(V) xuống O(log V)."
)

== 24.1 Bài Toán Đường Đi Ngắn Nhất Nguồn Đơn (SSSP)

Cho đồ thị $G = (V, E)$ có trọng số cạnh không âm $w(e) >= 0$. Cần tìm độ dài đường đi ngắn nhất từ một đỉnh nguồn $S$ tới tất cả các đỉnh còn lại trong đồ thị.

#callout(kind: "danger", title: "Điều kiện tiên quyết: Trọng số không âm")[
  Thuật toán Dijkstra *hoàn toàn thất bại* nếu đồ thị xuất hiện cạnh có trọng số âm ($w(e) < 0$).
  *Phản ví dụ:* Xét đồ thị có đỉnh $S arrow.r A$ (chi phí 2), $S arrow.r B$ (chi phí 5), và $B arrow.r A$ (chi phí -4). Dijkstra sẽ chốt hạ $"dist"[A] = 2$ ngay từ đầu, trong khi đường đi thực tế $S arrow.r B arrow.r A$ có chi phí $5 + (-4) = 1 < 2$. Để xử lý cạnh âm, bắt buộc phải dùng thuật toán Bellman-Ford hoặc SPFA.
]

== 24.2 Cài Đặt Chuẩn C++14 Với `std::priority_queue`

Cú pháp khai báo Min-Heap trong C++14:
```cpp
std::priority_queue<std::pair<long long, int>,
                    std::vector<std::pair<long long, int>>,
                    std::greater<std::pair<long long, int>>> pq;
```
Heap lưu trữ các cặp `(khoảng cách d, đỉnh u)`. Toán tử `std::greater` đảm bảo phần tử có khoảng cách nhỏ nhất luôn nằm ở đỉnh heap (`pq.top()`).

#syntax-anatomy(
  `if (d > dist[u]) continue; for (auto& e : adj[u]) { if (dist[u] + e.w < dist[e.to]) { dist[e.to] = dist[u] + e.w; pq.push({dist[e.to], e.to}); } }`,
  (
    ("if (d > dist[u]) continue;", "Kỹ thuật Lazy Deletion: Bỏ qua các bản ghi lỗi thời đã có đường đi tốt hơn được xử lý trước đó."),
    ("for (auto& e : adj[u])", "Duyệt qua các cạnh đi ra từ đỉnh u vừa được chốt hạ."),
    ("dist[u] + e.w < dist[e.to]", "Phép thử thư giãn (Edge Relaxation): Kiểm tra đi qua u có tốt hơn không."),
    ("pq.push({dist[e.to], e.to});", "Đẩy nhãn khoảng cách mới vào heap để tiếp tục lan tỏa sóng.")
  )
)

== 24.3 Bảng Chạy Bàn Trên Giấy: Đồ Thị 4 Đỉnh Với $S = 1$ Đến $T = 4$

Các cạnh: $(1 arrow.r 2, 2), (1 arrow.r 3, 5), (2 arrow.r 4, 4), (3 arrow.r 4, 1)$.

#trace-matrix(
  headers: ("Bước", "Pop (d, u)", "Mảng dist[]", "Thư giãn các cạnh", "Nội dung Min-Heap"),
  rows: (
    ("Khởi tạo", "-", "[0, INF, INF, INF]", "dist[1] = 0", "[(0, 1)]"),
    ("1", "(0, 1)", "[0, 2, 5, INF]", "1->2: dist[2]=2; 1->3: dist[3]=5", "[(2, 2), (5, 3)]"),
    ("2", "(2, 2)", "[0, 2, 5, 6]", "2->4: dist[4] = 2 + 4 = 6", "[(5, 3), (6, 4)]"),
    ("3", "(5, 3)", "[0, 2, 5, 6]", "3->4: 5 + 1 = 6 (Không nhỏ hơn 6)", "[(6, 4)]"),
    ("4", "(6, 4)", "[0, 2, 5, 6]", "Đích đến 4 được chốt hạ", "rỗng"),
    ("Kết thúc", "-", "*dist[4] = 6*", "*Truy vết parent[4] = 2, parent[2] = 1*", "*Đường đi: 1 -> 2 -> 4*")
  )
)

== 24.4 Bài Tập Tiêu Chuẩn

#let ch24-tests = json("/code/vol3/ch24_dijkstra/tests.json")

#hand-trace-problem(
  name: "Bài 24.1 - Thuật Toán Dijkstra Chuẩn Mực & Phục Hồi Đường Đi",
  source: "Nền tảng C++14 - Đường đi ngắn nhất Dijkstra",
  problem_desc: [
    Cho một đồ thị có hướng gồm $N$ đỉnh (được đánh số từ $1$ đến $N$) và $M$ cung có trọng số không âm ($1 <= N <= 30, 1 <= M <= 100$).
    Em hãy tìm đường đi ngắn nhất từ đỉnh nguồn $S = 1$ đến đỉnh đích $T = N$.

    Nếu không tồn tại đường đi từ 1 đến $N$, in ra `-1`.
    Nếu tồn tại đường đi:
    1. In ra độ dài đường đi ngắn nhất `dist[N]`.
    2. In ra số lượng cạnh trên đường đi ngắn nhất đó `edge_count`.
    3. In ra đỉnh trung gian nằm ngay trước đỉnh $N$ trên đường đi ngắn nhất (`parent[N]`).

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, M$. $M$ dòng tiếp theo, mỗi dòng ghi ba số nguyên $u, v, w$ mô tả cung từ $u$ tới $v$ có trọng số $w$. \
    *Đầu ra (Output):* Nếu không có đường đi, in ra `-1`. Nếu có đường đi, in ra 3 số nguyên `dist[N] edge_count parent[N]` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "4 4\n1 2 2\n1 3 5\n2 4 4\n3 4 1\n",
    output: "6 2 2\n"
  ),
  tests_10: ch24-tests
)
