#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 19: Các Bài Toán Quy Hoạch Động Kinh Điển

#term-box(
  term: "Khuôn Mẫu DP Kinh Điển & Kỹ Thuật Nén Không Gian Trạng Thái",
  origin: "Các bài toán như Knapsack, LIS, LCS được nghiên cứu sâu rộng từ thập niên 1960-1970 trong lý thuyết tối ưu hóa tổ hợp và tin sinh học (thuật toán Needleman-Wunsch).",
  intuition: "Quy hoạch động trong lập trình thi đấu thường xoay quanh 4 mẫu hình nền tảng: Dãy con tăng dài nhất (LIS), Chuỗi con chung dài nhất (LCS), Bài toán Cái túi (Knapsack), và Lưới tọa độ 2D (Grid DP). Nắm vững 4 khuôn mẫu này giúp ta phân loại và ánh xạ hầu hết các đề thi HSG/VNOI về dạng bài toán cốt lõi."
)

== 19.1 Bốn Khuôn Mẫu Quy Hoạch Động Nền Tảng

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 7pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[1. LIS (Longest Increasing Subsequence)]
        - $"dp"[i]$: Độ dài LIS kết thúc tại phần tử $A[i]$.
        - Công thức: $"dp"[i] = 1 + max_(j < i, A[j] < A[i]) "dp"[j]$.
        - Độ phức tạp: $O(N^2)$.
        - Nâng cấp $O(N log N)$ bằng mảng `tail[]` và `std::lower_bound`.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 7pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[2. LCS (Longest Common Subsequence)]
        - $"dp"[i][j]$: Độ dài LCS của tiền tố $S[1..i]$ và $T[1..j]$.
        - Nếu $S[i] == T[j]$: $"dp"[i][j] = "dp"[i-1][j-1] + 1$.
        - Nếu $S[i] != T[j]$: $"dp"[i][j] = max("dp"[i-1][j], "dp"[i][j-1])$.
        - Độ phức tạp: $O(|S| times |T|)$.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 7pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[3. Knapsack 0/1 & Unbounded]
        - $"dp"[w]$: Giá trị cực đại khi sức chứa balo là $w$.
        - *0/1 Knapsack:* Duyệt $w$ từ $W$ ngược về $w_i$ (mỗi vật chọn tối đa 1 lần).
        - *Unbounded Knapsack:* Duyệt $w$ từ $w_i$ xuôi đến $W$ (mỗi vật chọn vô hạn lần).
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 7pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[4. Grid DP (Lưới 2D)]
        - $"dp"[r][c]$: Số cách hoặc chi phí tối ưu từ ô $(1, 1)$ đến ô $(r, c)$.
        - Chỉ di chuyển sang phải hoặc xuống dưới:
        $ "dp"[r][c] = "cost"[r][c] + min("dp"[r-1][c], "dp"[r][c-1]) $
      ]
    )
  ]
)

== 19.2 Chi Tiết Bài Toán Balo 0/1 (0/1 Knapsack)

Cho $N$ vật phẩm, vật $i$ có trọng lượng $w_i$ và giá trị $v_i$. Balo có sức chứa tối đa $W$.
Bảng trạng thái 2D: $"dp"[i][w]$ là giá trị lớn nhất khi xét $i$ vật đầu tiên với sức chứa $w$.

Công thức chuyển trạng thái:
$ "dp"[i][w] = cases(
  "dp"[i-1][w] & "nếu" w < w_i,
  max("dp"[i-1][w], "dp"[i-1][w - w_i] + v_i) & "nếu" w >= w_i
) $

#syntax-anatomy(
  `for (int cap = W; cap >= w[i]; --cap) { dp[cap] = std::max(dp[cap], dp[cap - w[i]] + v[i]); }`,
  (
    ("for (int cap = W; cap >= w[i]; --cap)", "Duyệt ngược từ W về w[i] ngăn không cho một vật phẩm bị dùng 2 lần trong cùng một vòng lặp."),
    ("dp[cap - w[i]]", "Truy xuất trạng thái của vòng lặp i-1 trước đó khi dung lượng còn lại là cap - w[i]."),
    ("+ v[i]", "Cộng thêm giá trị của vật phẩm i khi quyết định đưa vào balo."),
    ("std::max(dp[cap], ...)", "So sánh giữa quyết định không chọn vật i và quyết định chọn vật i.")
  )
)

#callout(kind: "danger", title: "Cạm bẫy duyệt xuôi trong 0/1 Knapsack")[
  Nếu viết `for (int cap = w[i]; cap <= W; ++cap)`, giá trị `dp[cap - w[i]]` đã bị cập nhật bởi chính vật phẩm $i$ ở các bước trước đó trong cùng vòng lặp. Điều này biến bài toán 0/1 thành bài toán Unbounded Knapsack (cho phép chọn một vật nhiều lần)!
]

== 19.3 Bảng Chạy Bàn Trên Giấy: Balo $W = 7$ Với 4 Vật Phẩm

Các vật phẩm: $1: (w=2, v=3), 2: (w=3, v=4), 3: (w=4, v=5), 4: (w=5, v=6)$.

#trace-matrix(
  headers: ("Xét vật i", "Trọng lượng w", "Giá trị v", "Dung lượng cap = 2..4", "Dung lượng cap = 5..7", "Quyết định tối ưu"),
  rows: (
    ("Khởi tạo", "-", "-", "0, 0, 0", "0, 0, 0", "Mọi dp[w] = 0"),
    ("Vật 1", "2", "3", "dp[2..3]=3, dp[4]=3", "dp[5..7] = 3", "Chọn vật 1 nếu cap >= 2"),
    ("Vật 2", "3", "4", "dp[2]=3, dp[3..4]=4", "dp[5]=7 (1+2), dp[6..7]=7", "Chọn kết hợp 1 và 2 đạt 7"),
    ("Vật 3", "4", "5", "dp[2]=3, dp[3]=4, dp[4]=5", "dp[6]=8 (1+3), dp[7]=9 (2+3)", "Cập nhật cap 7 lên 9"),
    ("Vật 4", "5", "6", "Giữ nguyên", "dp[7] = max(9, dp[2]+6=9)", "*V_max = 9, W_used = 7*")
  )
)

== 19.4 Bài Tập Tiêu Chuẩn

#let ch19-tests = json("/code/vol3/ch19_classic_dp/tests.json")

#hand-trace-problem(
  name: "Bài 19.1 - Các Bài Toán DP Kinh Điển: Balo 0/1 & Tối Ưu Hóa Giá Trị",
  source: "Nền tảng C++14 - Quy hoạch động kinh điển",
  problem_desc: [
    Cho $N$ đồ vật ($1 <= N <= 15$) và một chiếc balo có sức chứa trọng lượng tối đa là $W$ ($1 <= W <= 100$).
    Mỗi đồ vật $i$ có trọng lượng $w_i$ và giá trị $v_i$ ($1 <= w_i <= 100, 1 <= v_i <= 1000$).
    Mỗi đồ vật chỉ được chọn nhiều nhất 1 lần (hoặc chọn, hoặc không chọn).

    Em hãy tính toán:
    1. Tổng giá trị lớn nhất $V_"max"$ có thể xếp vào balo mà tổng trọng lượng không vượt quá $W$.
    2. Tổng trọng lượng thực tế nhỏ nhất $W_"used"$ của các đồ vật được chọn để đạt được đúng giá trị cực đại $V_"max"$ đó.

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, W$. $N$ dòng tiếp theo, mỗi dòng ghi hai số nguyên $w_i, v_i$. \
    *Đầu ra (Output):* In ra hai số nguyên `V_max W_used` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "4 7\n2 3\n3 4\n4 5\n5 6\n",
    output: "9 7\n"
  ),
  tests_10: ch19-tests
)
