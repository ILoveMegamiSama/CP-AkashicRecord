#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 28: Cây Chỉ Số Nhị Phân (Fenwick Tree / BIT)

#term-box(
  term: "Cây Chỉ Số Nhị Phân (Binary Indexed Tree / Fenwick Tree)",
  origin: "Được Peter Fenwick công bố năm 1994 nhằm mục đích nén dữ liệu, cấu trúc cây chỉ số nhị phân nhanh chóng trở thành một trong những cấu trúc dữ liệu tinh giản và hiệu quả nhất của lập trình thi đấu.",
  intuition: "Thay vì lưu toàn bộ tổng cộng dồn (chỉ truy vấn nhanh O(1) nhưng cập nhật cực chậm O(N)), hoặc lưu mảng thô (cập nhật O(1) nhưng tính tổng O(N)), Cây Fenwick phân chia mảng thành các đoạn lũy thừa của 2. Mỗi ô nhớ i chịu trách nhiệm quản lý đúng một đoạn có độ dài bằng bit 1 nhỏ nhất của i (lowbit(i) = i & -i). Cả thao tác cập nhật điểm lẫn tính tổng đoạn đều đạt tốc độ kinh ngạc O(log N) với chỉ 3 dòng mã."
)

== 28.1 Phép Toán Lowbit Thần Thánh: `i & (-i)`

Dưới hệ biểu diễn số bù 2 (Two's Complement), số đối $-i$ được tạo thành bằng cách đảo toàn bộ các bit của $i$ rồi cộng thêm 1:
- Phép phủ định bit `~i` biến bit 1 thấp nhất của $i$ thành 0, và biến toàn bộ các bit 0 bên phải nó thành 1.
- Khi cộng thêm 1, các bit 1 này bật thành 0 và bit tại vị trí bit 1 thấp nhất lại bật thành 1.
- Do đó, phép toán logic `i & (-i)` cô lập chính xác lũy thừa của 2 tương ứng với bit 1 nhỏ nhất của $i$:
$ "lowbit"(i) = i and (-i) $

#callout(kind: "tip", title: "Ví dụ giá trị lowbit")[
  - $i = 6 = 110_2 arrow.r "lowbit"(6) = 2 = 010_2$.
  - $i = 12 = 1100_2 arrow.r "lowbit"(12) = 4 = 0100_2$.
  - $i = 8 = 1000_2 arrow.r "lowbit"(8) = 8 = 1000_2$.
]

== 28.2 Trách Nhiệm Của Nút & Hai Thao Tác Cơ Bản

Mỗi phần tử $"tree"[i]$ trong mảng Fenwick (1-indexed) lưu tổng của đúng $"lowbit"(i)$ phần tử kết thúc tại $i$:
$ "tree"[i] = sum_(k = i - "lowbit"(i) + 1)^i A[k] $

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
        #text(weight: "bold")[1. Cập nhật điểm: add(i, delta)]
        - Khi giá trị tại vị trí $i$ tăng thêm $Delta$, ta phải cộng $Delta$ vào tất cả các ô $"tree"[k]$ chịu trách nhiệm bao trùm $i$.
        - Các chỉ số $k$ này được duyệt bằng cách nhảy tiến:
        $ k arrow.r k + "lowbit"(k) $
        - Độ phức tạp: $O(log N)$.
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
        #text(weight: "bold")[2. Truy vấn tiền tố: query(i)]
        - Để tính tổng tiền tố $sum_(k=1)^i A[k]$, ta cộng dồn giá trị tại $"tree"[i]$, rồi nhảy lùi về phần tử trước đoạn trách nhiệm:
        $ k arrow.r k - "lowbit"(k) $
        - Lặp lại cho đến khi $k = 0$.
        - Tổng đoạn $[L, R] = "query"(R) - "query"(L - 1)$.
        - Độ phức tạp: $O(log N)$.
      ]
    )
  ]
)

== 28.3 Ứng Dụng Đếm Số Cặp Nghịch Thế (Inversions)

Một cặp nghịch thế là cặp chỉ số $(i, j)$ sao cho $i < j$ nhưng $A[i] > A[j]$.
Thuật toán đếm nghịch thế bằng Fenwick Tree:
1. Rời rạc hóa giá trị của mảng $A$ về khoảng thứ hạng $[1, K]$ ($K <= N$).
2. Khởi tạo một Cây Fenwick rỗng biểu diễn tần số xuất hiện.
3. Duyệt lần lượt từng phần tử $A[i]$ từ trái sang phải:
   - Số phần tử đã xuất hiện trước đó nhưng lớn hơn $A[i]$ chính là:
   $ "inv" += "query"(K) - "query"("rank"(A[i])) $
   - Thêm phần tử hiện tại vào cây tần số: `"add"("rank"(A[i]), 1)`.

#syntax-anatomy(
  `for (; idx <= n; idx += idx & (-idx)) tree[idx] += delta;`,
  (
    ("for (; idx <= n;", "Duyệt tiến qua các nút tổ tiên trong cây Fenwick cho tới biên kích thước n."),
    ("idx += idx & (-idx)", "Cộng thêm lowbit(idx) để nhảy tới nút cha bao trùm đoạn trách nhiệm tiếp theo."),
    ("tree[idx] += delta;", "Cập nhật giá trị dồn tích lũy vào nút tương ứng.")
  )
)

== 28.4 Bảng Chạy Bàn Trên Giấy: Mảng $A = [3, 1, 2, 5, 4]$ Với $N = 5$

#trace-matrix(
  headers: ("Phần tử A[i]", "Rank", "Số phần tử lớn hơn đã gặp", "Tổng nghịch thế dồn", "Cập nhật Fenwick"),
  rows: (
    ("A[1] = 3", "3", "query(5) - query(3) = 0 - 0 = 0", "0", "add(3, 1)"),
    ("A[2] = 1", "1", "query(5) - query(1) = 1 - 0 = 1", "1 (cặp (3, 1))", "add(1, 1)"),
    ("A[3] = 2", "2", "query(5) - query(2) = 2 - 1 = 1", "2 (thêm (3, 2))", "add(2, 1)"),
    ("A[4] = 5", "5", "query(5) - query(5) = 3 - 3 = 0", "2", "add(5, 1)"),
    ("A[5] = 4", "4", "query(5) - query(4) = 4 - 3 = 1", "*3 (thêm (5, 4))*", "add(4, 1)")
  )
)

Tổng số cặp nghịch thế là 3: $(3, 1), (3, 2), (5, 4)$.
Mảng ban đầu có tổng đoạn $[2, 4]$ là $A[2]+A[3]+A[4] = 1 + 2 + 5 = 8$.

== 28.5 Bài Tập Tiêu Chuẩn

#let ch28-tests = json("/code/vol4/ch28_fenwick_tree/tests.json")

#hand-trace-problem(
  name: "Bài 28.1 - Cây Chỉ Số Nhị Phân: Cập Nhật Điểm, Truy Vấn Đoạn & Đếm Nghịch Thế",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho một dãy gồm $N$ số nguyên dương $A_1, A_2, dots, A_N$ ($1 <= N <= 30$, $1 <= A_i <= 100$).
    Sử dụng cấu trúc Cây Fenwick (BIT), em hãy thực hiện các công việc sau:
    1. Đếm tổng số cặp nghịch thế trong dãy ban đầu: số cặp $(i, j)$ thỏa mãn $1 <= i < j <= N$ và $A_i > A_j$.
    2. Xây dựng Cây Fenwick lưu trữ mảng ban đầu, tính tổng các phần tử trong đoạn $[L, R]$:
    $ S_1 = sum_(i = L)^R A_i $
    3. Thực hiện thao tác cập nhật điểm: cộng thêm giá trị $V$ vào vị trí $P$ ($A_P arrow.r A_P + V$).
    4. Tính lại tổng đoạn $[L, R]$ sau khi đã cập nhật:
    $ S_2 = sum_(i = L)^R A_i $

    *Đầu vào (Input):*
    - Dòng 1: Ghi 5 số nguyên $N, P, V, L, R$.
    - Dòng 2: Ghi $N$ số nguyên $A_1, A_2, dots, A_N$.

    *Đầu ra (Output):* In ra 3 số nguyên `inv S1 S2` cách nhau bởi dấu cách trên một dòng.
  ],
  sample: (
    input: "5 3 5 2 4\n3 1 2 5 4\n",
    output: "3 8 13\n"
  ),
  tests_10: ch28-tests
)
