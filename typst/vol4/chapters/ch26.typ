#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 26: Kỹ Thuật Nhảy Nhị Phân (Binary Lifting)

#term-box(
  term: "Kỹ Thuật Nhảy Nhị Phân & Đồ Thị Hàm",
  origin: "Kỹ thuật nhân đôi khoảng cách (Doubling) bắt nguồn từ các thuật toán tính lũy thừa ma trận và tìm kiếm nhị phân, sau đó được tổng quát hóa thành Binary Lifting để duyệt cấu trúc đồ thị hàm và cây.",
  intuition: "Thay vì bước từng bước đơn lẻ O(K) lặp đi lặp lại rất chậm chạp, ta chuẩn bị sẵn các bước nhảy có kích thước là lũy thừa của 2: bước 1, bước 2, bước 4, bước 8, bước 16... Do mọi số nguyên K đều có thể phân tích duy nhất thành tổng các lũy thừa của 2 dưới hệ nhị phân, ta chỉ cần tối đa log2(K) cú nhảy để chạm tới đích chính xác tuyệt đối."
)

== 26.1 Đồ Thị Hàm (Functional Graphs) & Phép Hợp Hàm $f^{(K)}(x)$

Trong một đồ thị hàm có $N$ đỉnh $\{1, 2, dots, N\}$, mỗi đỉnh $x$ có đúng một cung đi ra trỏ tới $f(x) = "nxt"[x]$.
Nếu xuất phát từ đỉnh ban đầu $S$ và di chuyển liên tiếp $K$ bước theo quy tắc $x arrow.r f(x)$, ta muốn tìm đỉnh đích:
$ "dest" = f^((K))(S) = underbrace(f(f(dots f(S)dots)), K text(" lần")) $
Khi $K$ lên tới $10^9$ hoặc $10^(18)$, mô phỏng vòng lặp tuần tự sẽ dẫn đến TLE ngay lập tức. Kỹ thuật Binary Lifting cho phép giải quyết bài toán chỉ trong $O(log K)$ phép tính.

== 26.2 Xây Dựng Bảng Nhảy Nhị Phân (Sparse Table of Jumps)

Ta định nghĩa bảng nhảy hai chiều `up[j][x]`:
- $"up"[0][x] = f(x) = "nxt"[x]$: Đỉnh đến được sau khi nhảy $2^0 = 1$ bước từ $x$.
- $"up"[j][x]$: Đỉnh đến được sau khi nhảy $2^j$ bước từ $x$.

*Công thức truy hồi nhân đôi (Doubling Recurrence):*
Vì $2^j = 2^(j-1) + 2^(j-1)$, nên để nhảy $2^j$ bước từ $x$, ta chỉ cần:
1. Nhảy $2^(j-1)$ bước từ $x$ đến đỉnh trung gian $y = "up"[j-1][x]$.
2. Từ $y$, tiếp tục nhảy thêm $2^(j-1)$ bước nữa để đến $"up"[j-1][y]$.

$ "up"[j][x] = "up"[j-1]["up"[j-1][x]] $

Chi phí tiền xử lý toàn bộ bảng $"up"[0 dots 29][1 dots N]$ chỉ mất $O(N log K)$ thời gian và bộ nhớ.

== 26.3 Thuật Toán Nhảy Nhị Phân Trong $O(log K)$

Mọi số nguyên $K$ đều biểu diễn được dưới dạng nhị phân: $K = sum_(j=0)^M b_j dot 2^j$ với $b_j in {0, 1}$.
Để thực hiện $K$ bước nhảy từ đỉnh $S$:
```text
cur = S
for j từ 0 đến M:
    nếu bit thứ j của K bật (tức (K >> j) & 1 == 1):
        cur = up[j][cur]
```

#callout(kind: "theory", title: "Trực giác nhị phân")[
  Ví dụ $K = 13 = 1101_2 = 2^3 + 2^2 + 2^0 = 8 + 4 + 1$.
  Từ $S$, ta chỉ cần thực hiện 3 cú nhảy:
  $S limits(arrow.r)^(2^0=1) x_1 limits(arrow.r)^(2^2=4) x_2 limits(arrow.r)^(2^3=8) x_3 = "đích"$.
]

#syntax-anatomy(
  `for (int j = 0; j < 30; ++j) { if ((k >> j) & 1) cur = up[j][cur]; }`,
  (
    ("int j = 0; j < 30; ++j", "Duyệt qua các trọng số lũy thừa 2 từ 2^0 đến 2^29 (vượt quá 10^9)."),
    ("(k >> j) & 1", "Trích xuất giá trị bit thứ j trong biểu diễn nhị phân của số bước nhảy K."),
    ("cur = up[j][cur];", "Cú nhảy nhị phân kích thước 2^j đưa con trỏ tức thời tới đỉnh mới trong O(1).")
  )
)

== 26.4 Bảng Chạy Bàn Trên Giấy: Đồ Thị 4 Đỉnh Với $f = [2, 3, 4, 1]$

Mảng $f = [2, 3, 4, 1]$ là một chu trình 4 đỉnh $1 arrow.r 2 arrow.r 3 arrow.r 4 arrow.r 1$.
Ta xây dựng bảng $"up"[j][x]$ cho các lũy thừa $2^0=1, 2^1=2, 2^2=4$:

#trace-matrix(
  headers: ("Lũy thừa 2^j", "Độ dài bước", "x = 1", "x = 2", "x = 3", "x = 4", "Công thức truy hồi"),
  rows: (
    ("j = 0", "1 bước", "f(1) = 2", "f(2) = 3", "f(3) = 4", "f(4) = 1", "up[0][x] = f(x)"),
    ("j = 1", "2 bước", "up[0][2] = 3", "up[0][3] = 4", "up[0][4] = 1", "up[0][1] = 2", "up[1][x] = up[0][up[0][x]]"),
    ("j = 2", "4 bước", "up[1][3] = 1", "up[1][4] = 2", "up[1][1] = 3", "up[1][2] = 4", "up[2][x] = up[1][up[1][x]]")
  )
)

Nếu muốn tìm $f^{(5)}(1)$ với $K = 5 = 2^2 + 2^0 = 4 + 1$:
- Bit 0 bật ($2^0=1$): $"cur" = "up"[0][1] = 2$.
- Bit 1 tắt ($2^1=2$): bỏ qua.
- Bit 2 bật ($2^2=4$): $"cur" = "up"[2][2] = 2$.
Kết quả: sau 5 bước từ đỉnh 1 ta dừng tại đỉnh 2!

== 26.5 Bài Tập Tiêu Chuẩn

#let ch26-tests = json("/code/vol4/ch26_binary_lifting/tests.json")

#hand-trace-problem(
  name: "Bài 26.1 - Kỹ Thuật Nhảy Nhị Phân: Nhảy Trên Đồ Thị Hàm",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho một đồ thị hàm gồm $N$ đỉnh ($1 <= N <= 30$). Mỗi đỉnh $i$ ($1 <= i <= N$) có một con trỏ trỏ tới đỉnh tiếp theo $"nxt"[i]$ ($1 <= "nxt"[i] <= N$) và mang giá trị trọng số $A[i]$ ($1 <= A[i] <= 1000$).
    Cho đỉnh xuất phát $S$ ($1 <= S <= N$) và số bước nhảy $K$ ($0 <= K <= 10^9$).
    Sử dụng bảng nhảy nhị phân `up[j][x]`, hãy xác định:
    1. Đỉnh dừng lại sau đúng $K$ bước nhảy: $"dest" = f^((K))(S)$.
    2. Đỉnh dừng lại ở mốc nửa chặng đường: $"mid" = f^(floor(K / 2))(S)$.
    3. Trọng số của đỉnh đích: $A["dest"]$.

    *Đầu vào (Input):*
    - Dòng 1: Ghi 3 số nguyên $N, S, K$.
    - Dòng 2: Ghi $N$ số nguyên $"nxt"_1, "nxt"_2, dots, "nxt"_N$.
    - Dòng 3: Ghi $N$ số nguyên $A_1, A_2, dots, A_N$.

    *Đầu ra (Output):* In ra 3 số nguyên `dest mid A[dest]` cách nhau bởi dấu cách trên một dòng.
  ],
  sample: (
    input: "4 1 5\n2 3 4 1\n10 20 30 40\n",
    output: "2 3 20\n"
  ),
  tests_10: ch26-tests
)
