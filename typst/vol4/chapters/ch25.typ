#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 25: Kỹ Thuật Trải Phẳng Cây (Euler Tour on Tree)

#term-box(
  term: "Kỹ Thuật Trải Phẳng Cây & Thứ Tự Euler Tour",
  origin: "Xuất phát từ chu trình Euler trên đồ thị, kỹ thuật Euler Tour trên cây được Robert Tarjan và các nhà khoa học máy tính ứng dụng để chuyển đổi cấu trúc phân cấp phức tạp thành mảng tuyến tính một chiều.",
  intuition: "Cây là cấu trúc dữ liệu phân nhánh 2D khó xử lý đồng thời nhiều nút con. Khi áp dụng phép duyệt DFS và ghi nhận thời điểm bước vào tin[u] cùng thời điểm rời khỏi tout[u], toàn bộ cây con của đỉnh u sẽ được 'gói gọn' hoàn hảo vào một đoạn chỉ số liên tiếp [tin[u], tout[u]]. Mọi thao tác trên cây con lập tức quy về thao tác trên đoạn của mảng 1D."
)

== 25.1 Cốt Lõi Thuật Toán: Mảng Thời Gian `tin` và `tout`

Khi duyệt DFS cây có gốc (mặc định gốc 1), ta duy trì một bộ đếm thời gian toàn cục `timer = 0`:
1. *Thời điểm vào (`tin[u]`):* Ngay khi hàm DFS bắt đầu thăm đỉnh $u$, ta tăng `timer` lên 1 và lưu `tin[u] = ++timer`.
2. *Duyệt con:* Lần lượt gọi đệ quy DFS thăm tất cả các đỉnh con trực tiếp $v$ của $u$ (bỏ qua đỉnh cha $p$).
3. *Thời điểm ra (`tout[u]`):* Sau khi toàn bộ các nhánh con của $u$ đã được duyệt xong xuôi, ta chốt mốc thời gian `tout[u] = timer`.

#callout(kind: "tip", title: "Tính chất vàng của đoạn [tin[u], tout[u]]")[
  Mọi đỉnh $v$ nằm trong cây con của đỉnh $u$ đều được duyệt *sau khi vào $u$* và *trước khi rời khỏi $u$*. Do đó, tập hợp các đỉnh trong cây con của $u$ có chỉ số thời điểm vào nằm trọn trong đoạn liên tục $["tin"[u], "tout"[u]]$.
  Đặc biệt, kích thước cây con của $u$ chính bằng:
  $ "subtree_size"[u] = "tout"[u] - "tin"[u] + 1 $
]

== 25.2 Kiểm Tra Quan Hệ Tổ Tiên - Con Cháu Trong $O(1)$

Cho hai đỉnh bất kỳ $u$ và $v$. Đỉnh $u$ là tổ tiên của đỉnh $v$ (kể cả trường hợp $u = v$) khi và chỉ khi khoảng thời gian sống của $v$ nằm trọn trong khoảng thời gian sống của $u$:
$ "tin"[u] <= "tin"[v] quad text("và") quad "tout"[u] >= "tout"[v] $

Nhờ tính chất này, ta có thể trả lời câu hỏi "Đỉnh $u$ có phải là tổ tiên của $v$ không?" chỉ trong một phép so sánh $O(1)$ mà không cần duyệt ngược lên gốc!

== 25.3 Trải Phẳng Trọng Số & Truy Vấn Tổng Cây Con Tĩnh

Nếu mỗi đỉnh $u$ mang trọng số $W_u$, ta tạo mảng trải phẳng $F$ kích thước $N$:
$ F["tin"[u]] = W_u $
Khi đó, tổng trọng số các đỉnh trong cây con gốc $u$ chính là tổng của mảng $F$ trên đoạn $["tin"[u], "tout"[u]]$:
$ sum_(v in "subtree"(u)) W_v = sum_(i = "tin"[u])^("tout"[u]) F[i] $
Dùng mảng cộng dồn tiền tố $"pref"[i] = "pref"[i-1] + F[i]$, truy vấn tổng cây con được tính trong $O(1)$:
$ "subtree_sum"(u) = "pref"["tout"[u]] - "pref"["tin"[u] - 1] $

#syntax-anatomy(
  `void dfs(int u, int p) { tin[u] = ++timer_cnt; for (int v : adj[u]) if (v != p) dfs(v, u); tout[u] = timer_cnt; }`,
  (
    ("tin[u] = ++timer_cnt;", "Ghi nhận mốc thời gian bắt đầu bước vào cây con của u."),
    ("for (int v : adj[u])", "Duyệt qua các đỉnh kề của u theo thứ tự xác định."),
    ("if (v != p) dfs(v, u);", "Ngăn chặn quay ngược lên cha, đệ quy xuống từng nhánh con."),
    ("tout[u] = timer_cnt;", "Chốt mốc thời gian rời khỏi u sau khi tất cả các con đã hoàn tất.")
  )
)

== 25.4 Bảng Chạy Bàn Trên Giấy: Cây 4 Đỉnh Với Cạnh $(1, 2), (1, 3), (2, 4)$

Trọng số $W = [10, 20, 30, 40]$. Cây có gốc tại 1.

#trace-matrix(
  headers: ("Đỉnh u", "tin[u]", "tout[u]", "Đoạn [tin, tout]", "Cây con gồm", "Tổng trọng số cây con"),
  rows: (
    ("1", "1", "4", "[1, 4]", "{1, 2, 4, 3}", "10 + 20 + 40 + 30 = 100"),
    ("2", "2", "3", "[2, 3]", "{2, 4}", "20 + 40 = 60"),
    ("4", "3", "3", "[3, 3]", "{4}", "40"),
    ("3", "4", "4", "[4, 4]", "{3}", "30")
  )
)

Mảng trải phẳng: $F = [W_1=10, W_2=20, W_4=40, W_3=30]$.
Cây con của đỉnh 2 nằm trên đoạn $[2, 3]$, tổng là $F[2] + F[3] = 20 + 40 = 60$.

== 25.5 Bài Tập Tiêu Chuẩn

#let ch25-tests = json("/code/vol4/ch25_euler_tour/tests.json")

#hand-trace-problem(
  name: "Bài 25.1 - Kỹ Thuật Trải Phẳng Cây: Thứ Tự Duyệt Euler Tour & Tổng Cây Con",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho một đồ thị cây gồm $N$ đỉnh ($1 <= N <= 30$) có gốc tại đỉnh 1. Mỗi đỉnh $u$ có trọng số $W_u$ ($1 <= W_u <= 1000$).
    Các cạnh vô hướng được cho dưới dạng danh sách $N - 1$ cặp đỉnh $(u, v)$.
    Để thứ tự duyệt Euler Tour là tiền định và thống nhất khi tính toán trên giấy:
    - Tại mỗi đỉnh, danh sách các đỉnh kề được duyệt theo thứ tự số hiệu đỉnh tăng dần.
    - Duyệt DFS từ gốc 1 với biến đếm thời gian `timer` khởi tạo bằng 0: gán `tin[u] = ++timer` khi vào, duyệt con, và gán `tout[u] = timer` khi kết thúc.
    - Mảng trải phẳng $F["tin"[u]] = W_u$.
    - Cho đỉnh truy vấn $u_1$ và cặp đỉnh $(u_2, v_2)$.

    Em hãy tính toán và in ra trên một dòng 4 số nguyên cách nhau bởi dấu cách:
    1. `tin[u1]`: Mốc thời gian vào của đỉnh $u_1$.
    2. `tout[u1]`: Mốc thời gian ra của đỉnh $u_1$.
    3. `sum_u1`: Tổng trọng số của tất cả các đỉnh thuộc cây con gốc $u_1$.
    4. `is_anc`: Bằng `1` nếu $u_2$ là tổ tiên của $v_2$ ($"tin"[u_2] <= "tin"[v_2] and "tout"[u_2] >= "tout"[v_2]$), ngược lại in `0`.

    *Đầu vào (Input):*
    - Dòng 1: Ghi 4 số nguyên $N, u_1, u_2, v_2$.
    - Dòng 2: Ghi $N$ số nguyên dương $W_1, W_2, dots, W_N$.
    - $N - 1$ dòng tiếp theo: Mỗi dòng ghi 2 số $u, v$ mô tả một cạnh của cây.

    *Đầu ra (Output):* In ra 4 số nguyên `tin[u1] tout[u1] sum_u1 is_anc` trên một dòng.
  ],
  sample: (
    input: "4 2 1 4\n10 20 30 40\n1 2\n1 3\n2 4\n",
    output: "2 3 60 1\n"
  ),
  tests_10: ch25-tests
)
