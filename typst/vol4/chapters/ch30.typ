#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 30: Thao Tác Bit & Quy Hoạch Động Mặt Nạ (Bitmask DP)

#term-box(
  term: "Thao Tác Bit & Quy Hoạch Động Trạng Thái Mặt Nạ (Bitmask DP)",
  origin: "Được Michael Held và Richard Karp phát triển năm 1962 trong thuật toán Bellman-Held-Karp giải bài toán Người du lịch TSP thời gian hàm mũ O(2^N * N^2).",
  intuition: "Một tập hợp con các phần tử có thể được mã hóa hoàn hảo thành một chuỗi nhị phân (Mặt nạ - Bitmask): bit thứ i bằng 1 nghĩa là phần tử i có mặt trong tập, bằng 0 nghĩa là vắng mặt. Bằng cách dùng một số nguyên biểu diễn trạng thái tập hợp, ta có thể áp dụng Quy hoạch động để duyệt qua toàn bộ 2^N tập con với tốc độ phần cứng của thanh ghi CPU."
)

== 30.1 Bảng Cứu Kẹt Các Phép Toán Bit Cốt Lõi

Cho một mặt nạ `mask` và phần tử thứ $i$ ($0$-indexed):

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
        #text(weight: "bold")[Thao tác cơ bản trên bit]
        - *Kiểm tra bit:* `(mask >> i) & 1` (trả về 1 nếu phần tử $i$ thuộc tập).
        - *Bật bit:* `mask | (1 << i)` (thêm phần tử $i$ vào tập).
        - *Tắt bit:* `mask & ~(1 << i)` (loại phần tử $i$ khỏi tập).
        - *Đảo bit:* `mask ^ (1 << i)` (đổi trạng thái có mặt/vắng mặt).
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
        #text(weight: "bold")[Hàm nội tại GCC & Duyệt tập con]
        - `__builtin_popcount(mask)`: Đếm số lượng phần tử trong tập (số bit 1).
        - `__builtin_ctz(mask)`: Đếm số bit 0 ở cuối (vị trí phần tử nhỏ nhất).
        - Duyệt toàn bộ tập con thực sự của `mask`:
        ```cpp
        for (int s = mask; s > 0; s = (s - 1) & mask)
        ```
      ]
    )
  ]
)

== 30.2 Bài Toán Người Du Lịch (TSP) & Thiết Kế Trạng Thái DP

Cho đồ thị có hướng $N$ đỉnh với ma trận chi phí $C[u][v]$ ($0 <= u, v < N$).
- Không gian trạng thái: $"dp"["mask"][u]$ là chi phí nhỏ nhất để xuất phát từ đỉnh 0, đi qua tất cả các đỉnh có bit 1 trong `"mask"`, và hiện đang dừng tại đỉnh $u$.
- Trạng thái cơ sở: $"dp"[1][0] = 0$ (tập đỉnh chỉ gồm đỉnh 0, đang đứng ở 0), các ô khác khởi tạo bằng $+infinity$.
- Công thức chuyển trạng thái: Với mỗi đỉnh $v$ chưa được thăm trong `"mask"` (`!((mask >> v) & 1)`):
$ "dp"["mask" | (1 << v)][v] = min("dp"["mask" | (1 << v)][v], "dp"["mask"][u] + C[u][v]) $
- Chi phí đường đi Hamilton mở qua tất cả $N$ đỉnh:
$ "min_path" = min_(u=0)^(N-1) "dp"[(1 << N) - 1][u] $
- Chi phí chu trình Hamilton TSP đóng quay về đỉnh 0:
$ "min_tsp" = min_(u=0)^(N-1) ("dp"[(1 << N) - 1][u] + C[u][0]) $

#syntax-anatomy(
  `int next_mask = mask | (1 << v); dp[next_mask][v] = std::min(dp[next_mask][v], dp[mask][u] + cost[u][v]);`,
  (
    ("mask | (1 << v)", "Bật bit thứ v để ghi nhận đỉnh v đã được bổ sung vào hành trình."),
    ("dp[next_mask][v]", "Trạng thái mới: tập đỉnh đã thăm là next_mask và đang đứng tại đỉnh v."),
    ("dp[mask][u] + cost[u][v]", "Chi phí tích lũy tại u cộng thêm chi phí di chuyển cung cạnh (u, v)."),
    ("std::min(...)", "Lựa chọn quyết định tối ưu trong nguyên lý Bellman.")
  )
)

== 30.3 Bảng Chạy Bàn Trên Giấy: Đồ Thị 3 Đỉnh $N = 3$

Ma trận chi phí:
$C = mat(0, 10, 20; 10, 0, 15; 20, 15, 0)$.

#trace-matrix(
  headers: ("mask", "Các đỉnh đã thăm", "Đỉnh hiện tại u", "dp[mask][u]", "Chuyển tiếp khả dĩ sang v"),
  rows: (
    ("1 (001)", "{0}", "0", "0 (Cơ sở)", "v=1: dp[3][1] = 0+10 = 10; v=2: dp[5][2] = 0+20 = 20"),
    ("3 (011)", "{0, 1}", "1", "10", "v=2: dp[7][2] = min(inf, 10+15) = 25"),
    ("5 (101)", "{0, 2}", "2", "20", "v=1: dp[7][1] = min(inf, 20+15) = 35"),
    ("7 (111)", "{0, 1, 2}", "1", "35", "Đường đi: 0 -> 2 -> 1, quay về 0: 35 + 10 = 45"),
    ("7 (111)", "{0, 1, 2}", "2", "25", "*Đường đi: 0 -> 1 -> 2 (min_path = 25)*, về 0: 25 + 20 = 45")
  )
)

Kết quả: $"min_path" = 25$, $"min_tsp" = 45$.

== 30.4 Bài Tập Tiêu Chuẩn

#let ch30-tests = json("/code/vol4/ch30_bitmask_dp/tests.json")

#hand-trace-problem(
  name: "Bài 30.1 - Thao Tác Bit & Quy Hoạch Động Trạng Thái Mặt Nạ: Bài Toán TSP",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho một đồ thị có hướng gồm $N$ đỉnh ($2 <= N <= 8$), các đỉnh được đánh số từ 0 đến $N - 1$.
    Ma trận chi phí hai chiều $C[N][N]$ cho biết chi phí di chuyển $C[u][v]$ từ đỉnh $u$ đến đỉnh $v$ ($0 <= C[u][v] <= 100$, $C[u][u] = 0$).
    Sử dụng kỹ thuật Quy hoạch động mặt nạ trạng thái Bitmask DP, em hãy tìm:
    1. `min_path`: Chi phí nhỏ nhất của đường đi Hamilton mở xuất phát từ đỉnh 0, đi qua tất cả $N$ đỉnh đúng một lần và kết thúc ở bất kỳ đỉnh nào.
    2. `min_tsp`: Chi phí nhỏ nhất của chu trình Hamilton TSP xuất phát từ đỉnh 0, đi qua tất cả $N$ đỉnh đúng một lần và quay trở về đỉnh 0.

    *Đầu vào (Input):*
    - Dòng 1: Ghi số nguyên $N$.
    - $N$ dòng tiếp theo: Mỗi dòng ghi $N$ số nguyên mô tả hàng thứ $u$ của ma trận chi phí $C[u][v]$.

    *Đầu ra (Output):* In ra 2 số nguyên `min_path min_tsp` cách nhau bởi dấu cách trên một dòng.
  ],
  sample: (
    input: "3\n0 10 20\n10 0 15\n20 15 0\n",
    output: "25 45\n"
  ),
  tests_10: ch30-tests
)
