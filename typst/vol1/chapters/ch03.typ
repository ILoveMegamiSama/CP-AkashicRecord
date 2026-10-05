#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 3: Biến, Biểu Thức, Ép Kiểu & Luồng Điều Khiển

#term-box(
  term: "Bất Biến Vòng Lặp (Loop Invariant)",
  origin: "Được nhà khoa học máy tính Tony Hoare đề xuất năm 1969 trong hệ logic Hoare chứng minh tính đúng đắn của chương trình.",
  intuition: "Một khẳng định logic về trạng thái của các biến luôn luôn ĐÚNG trước khi bắt đầu vòng lặp, được duy trì ĐÚNG sau mỗi bước lặp, và đảm bảo tính đúng đắn của kết quả khi vòng lặp kết thúc."
)

== 3.1 Toán Tử Số Học & Phép Chia Nguyên Trong C++14

Trong C++14, các phép toán số học cơ bản tuân thủ quy tắc chặt chẽ:
- Phép chia hai số nguyên $A / B$ là phép chia cắt cụt về phía số $0$ (truncation towards zero):
  $ 7 / 2 = 3, quad -7 / 2 = -3 $
- Phép chia dư $A \% B$:
  $ A = (A / B) times B + (A \% B) $
  Dấu của kết quả phép dư trong C++ luôn cùng dấu với số bị chia $A$:
  $ 7 \% 3 = 1, quad -7 \% 3 = -1 $

== 3.2 Ép Kiểu Tường Minh `static_cast`

C++14 cung cấp cơ chế ép kiểu an toàn tại thời điểm biên dịch:
```cpp
double avg = static_cast<double>(sum) / n;
```
Trình biên dịch sẽ kiểm tra xem kiểu nguồn có thể chuyển đổi hợp lệ sang kiểu đích hay không, loại trừ hoàn toàn các lỗi ép kiểu con trỏ nguy hiểm của cú pháp C-style cổ điển `(double)sum`.

== 3.3 Cấu Trúc Vòng Lặp & Bảng Biến Thiên Trên Giấy

#syntax-anatomy(
  `for (int i = 1; i <= n; ++i) { sum += i; }`,
  (
    ("int i = 1;", "Khởi tạo biến đếm `i`, chỉ thực thi duy nhất 1 lần khi bắt đầu vòng lặp."),
    ("i <= n;", "Điều kiện tiếp tục lặp, được đánh giá TRƯỚC mỗi lần thực thi thân vòng lặp."),
    ("++i", "Bước nhảy, thực thi SAU KHI thân vòng lặp hoàn thành mỗi bước."),
    ("{ sum += i; }", "Thân vòng lặp thực hiện công việc tính toán chính.")
  )
)

== 3.4 Kỹ Thuật Vẽ Bảng Biến Thiên Vòng Lặp Collatz

Dãy Collatz (còn gọi là giả thuyết $3N + 1$) bắt đầu từ một số nguyên dương $N$:
- Nếu $N$ chẵn: $N arrow.r N / 2$
- Nếu $N$ lẻ: $N arrow.r 3N + 1$

Hãy theo dõi bảng biến thiên trên giấy khi khởi đầu với $N = 3$:
#trace-matrix(
  headers: ("Bước", "N hiện tại", "Điều kiện chẵn/lẻ", "Phép biến đổi", "N kế tiếp", "Max đạt được"),
  rows: (
    ("0", "3", "Lẻ", "3 * 3 + 1", "10", "10"),
    ("1", "10", "Chẵn", "10 / 2", "5", "10"),
    ("2", "5", "Lẻ", "3 * 5 + 1", "16", "16"),
    ("3", "16", "Chẵn", "16 / 2", "8", "16"),
    ("4", "8", "Chẵn", "8 / 2", "4", "16"),
    ("5", "4", "Chẵn", "4 / 2", "2", "16"),
    ("6", "2", "Chẵn", "2 / 2", "1", "16"),
    ("7", "1", "Dừng", "Chạm N = 1", "1", "16")
  )
)

== 3.5 Bài Tập Tiêu Chuẩn

#let ch03-tests = json("/code/vol1/ch03_loop_trace/tests.json")

#hand-trace-problem(
  name: "Bài 3.1 - Bảng Biến Thiên Dãy Collatz (Collatz Sequence Trace)",
  source: "Nền tảng C++14 - Vòng lặp & Bảng biến thiên",
  problem_desc: [
    Cho một số nguyên dương $N$. Em hãy thực hiện mô phỏng thuật toán Collatz trên giấy:
    - Nếu $N > 1$: tăng số bước lặp `steps`. Nếu $N$ chẵn, gán $N = N / 2$; nếu $N$ lẻ, gán $N = 3N + 1$.
    - Luôn duy trì và cập nhật giá trị cực đại `max_val` mà biến $N$ đạt được trong suốt quá trình.
    - Quá trình dừng lại ngay khi $N = 1$. (Quy ước nếu ban đầu $N = 1$, số bước là $0$ và max là $1$).

    *Đầu vào (Input):* Một số nguyên dương $N$ ($1 \le N \le 30$). \
    *Đầu ra (Output):* Hai số nguyên `steps` và `max_val` cách nhau dấu cách.
  ],
  sample: (
    input: "3\n",
    output: "7 16\n"
  ),
  tests_10: ch03-tests
)
