#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 8: Phân Tích Độ Phức Tạp Thuật Toán Trên Giấy

#term-box(
  term: "Ký Hiệu Big-O (Asymptotic Notation)",
  origin: "Được nhà toán học người Đức Paul Bachmann giới thiệu năm 1894 và được Donald Knuth phổ biến trong khoa học máy tính vào năm 1976.",
  intuition: "Một 'chiếc thước đo tốc độ' phản ánh xu hướng bùng nổ thời gian thực thi của thuật toán khi kích thước dữ liệu $N$ tăng lên vô tận. Big-O bỏ qua các hệ số nhân và hằng số nhỏ để tập trung vào bậc tăng trưởng cao nhất."
)

== 8.1 Định Nghĩa Toán Học Về Tiệm Cận Chặn Trên

Hàm số $f(N)$ được gọi là $O(g(N))$ nếu tồn tại hai hằng số dương $c > 0$ và $N_0 > 0$ sao cho:
$ f(N) <= c times g(N) quad forall N >= N_0 $

Trong lập trình thi đấu, ta luôn phân tích trường hợp xấu nhất (Worst-case time complexity) để đảm bảo thuật toán không bị quá thời gian (TLE - Time Limit Exceeded) trước bất kỳ bộ test hiểm hóc nào của ban giám khảo.

== 8.2 Quy Tắc Ngón Tay Cái $1 text{s} approx 10^8$ Phép Tính

Hầu hết các hệ thống chấm thi tự động (Codeforces, VNOJ, ICPC, HSG Quốc Gia) đều sử dụng CPU có tốc độ thực hiện khoảng $10^8$ phép tính cơ bản trong $1$ giây:

#table(
  columns: (2.5cm, 3cm, 4.5fr),
  stroke: 0.4pt + luma(180),
  fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
  align: (center + horizon, center + horizon, left + horizon),
  inset: 6.5pt,
  table.header([*Giới hạn $N$ đề bài*], [*Độ phức tạp mục tiêu*], [*Thuật toán phù hợp*]),
  [$N <= 10$], [$O(N!)$], [Duyệt toàn bộ hoán vị, quay lui đầy đủ],
  [$N <= 20$], [$O(2^N)$], [Duyệt tập con, quay lui nhị phân, DP bitmask],
  [$N <= 500$], [$O(N^3)$], [Floyd-Warshall, nhân ma trận],
  [$N <= 5\,000$], [$O(N^2)$], [Hai vòng lặp lồng nhau, quy hoạch động 2 chiều cơ bản],
  [$N <= 10^5 dots 10^6$], [$O(N log N) text(" hoặc ") O(N)$], [Sắp xếp, Tìm kiếm nhị phân, Hai con trỏ, Cây phân đoạn],
  [$N <= 10^{18}$], [$O(log N) text(" hoặc ") O(1)$], [Lũy thừa nhị phân, Euclid GCD, Công thức toán học]
)

== 8.3 Kỹ Thuật Đếm Thao Tác Hai Vòng Lặp Lồng Nhau

Xét đoạn mã kiểm tra toàn bộ các cặp chỉ số phân biệt $(i, j)$ với $0 <= i < j < N$:

```cpp
int ops = 0;
for (int i = 0; i < N; ++i) {
    for (int j = i + 1; j < N; ++j) {
        ops++;
    }
}
```

Tổng số lần thực thi thân vòng lặp trong là:
$ T(N) = sum_(i=0)^(N-1) (N - 1 - i) = (N - 1) + (N - 2) + dots + 1 + 0 = frac{N(N - 1)}{2} = frac{N^2}{2} - frac{N}{2} in O(N^2) $

#callout(kind: "trace", title: "Ước lượng thời gian chạy trên giấy khi mở rộng N = 100,000")[
  Nếu đề bài cho $N = 100\,000 = 10^5$:
  $ T(10^5) = frac{10^5 times (10^5 - 1)}{2} approx 5 times 10^9 text(" phép tính") $
  Với tốc độ $10^8$ phép tính/giây của CPU:
  $ text("Thời gian thực thi") approx frac{5 times 10^9}{10^8} = 50 text(" giây!") $
  Thời gian này vượt xa giới hạn $1.0$ giây của máy chấm, chương trình sẽ lập tức bị TLE. Phân tích này cho ta biết ngay trên giấy rằng thuật toán $O(N^2)$ không đạt yêu cầu mà phải tìm thuật toán $O(N log N)$!
]

== 8.4 Bài Tập Tiêu Chuẩn

#let ch08-tests = json("/code/vol1/ch08_complexity/tests.json")

#hand-trace-problem(
  name: "Bài 8.1 - Đếm Thao Tác Vòng Lặp & Đánh Giá Giới Hạn (Loop Operation Counter)",
  source: "Nền tảng C++14 - Phân tích Big-O & Ước lượng 10^8",
  problem_desc: [
    Cho mảng số nguyên $A$ gồm $N$ phần tử ($1 \le N \le 8$).

    Xét đoạn thuật toán duyệt hai vòng lặp lồng nhau:
    - Với mỗi cặp $(i, j)$ thỏa mãn $0 \le i < j < N$: tăng biến đếm thao tác `ops`. Nếu $A[i] > A[j]$, tăng biến đếm số lượng cặp nghịch thế `inv`.
    - Dựa vào kết quả lý thuyết, với $N' = 10^5$, thuật toán $O(N^2)$ này sẽ mất xấp xỉ bao nhiêu giây theo quy tắc $10^8$ phép tính/giây? (Quy ước hằng số lý thuyết làm tròn là $50$ giây).

    *Đầu vào (Input):* Dòng 1 chứa số nguyên $N$. Dòng 2 chứa $N$ số nguyên. \
    *Đầu ra (Output):* In ra 3 số nguyên `ops inv 50` cách nhau dấu cách.
  ],
  sample: (
    input: "3\n3 2 1\n",
    output: "3 3 50\n"
  ),
  tests_10: ch08-tests
)
