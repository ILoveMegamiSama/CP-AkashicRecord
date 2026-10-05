#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 9: Số Học Cơ Bản Cho CP

#term-box(
  term: "Số Học Đồng Dư & Phân Rã Nhị Phân",
  origin: "Các định lý số học kinh điển bắt nguồn từ Euclid (khoảng 300 TCN) và Carl Friedrich Gauss (1801, Disquisitiones Arithmeticae) đặt nền tảng cho mật mã học và khoa học máy tính hiện đại.",
  intuition: "Khi giải bài toán số học lớn trong lập trình thi đấu, ta không thể lưu trữ các con số hàng triệu chữ số trong biến số thông thường. Số học đồng dư (Modulo) biến không gian số vô hạn thành chiếc đồng hồ hữu hạn tuần hoàn, và phân rã nhị phân chia nhỏ số mũ khổng lồ thành O(log N) bước nhân đơn giản."
)

== 9.1 Phép Toán Đồng Dư (Modulo) & Tránh Tràn Số

Trong lập trình thi đấu, các bài toán đếm hoặc tính toán lũy thừa thường yêu cầu chia lấy dư cho một số nguyên tố lớn, phổ biến nhất là $M = 10^9 + 7$.

Các tính chất đồng dư căn bản:
- $(A + B) equiv ((A mod M) + (B mod M)) mod M$
- $(A - B) equiv ((A mod M) - (B mod M) + M) mod M$ (Lưu ý cộng thêm $M$ để tránh số âm trong C++)
- $(A times B) equiv ((A mod M) times (B mod M)) mod M$

#callout(kind: "danger", title: "Cảnh báo tràn số khi nhân hai số 32-bit")[
  Nếu $A, B < 10^9+7$, tích $A times B$ có thể đạt tới xấp xỉ $10^{18}$, vượt xa ngưỡng cực đại của kiểu `int` 32-bit ($approx 2 times 10^9$). Nếu viết `(a * b) % m`, CPU sẽ thực hiện phép nhân 32-bit dẫn đến tràn số trước khi lấy modulo. Bắt buộc phải ép kiểu 64-bit:
  ```cpp
  long long prod = (1LL * a * b) % m;
  ```
]

== 9.2 Thuật Toán Euclid: Ước Chung Lớn Nhất & Bội Chung Nhỏ Nhất

Thuật toán Euclid dựa trên bổ đề toán học:
$ gcd(a, b) = gcd(b, a mod b) quad "với" b > 0, quad "và" gcd(a, 0) = a $

Do $a mod b < a/2$ sau mỗi hai bước, thuật toán kết thúc sau tối đa $O(log(min(a, b)))$ bước chia dư.

Bội chung nhỏ nhất (LCM) được tính qua công thức:
$ "lcm"(a, b) = (a times b) / gcd(a, b) = (a / gcd(a, b)) times b $

#callout(kind: "tip", title: "Thực hiện phép chia trước để chống tràn số")[
  Luôn tính `(a / gcd(a, b)) * b` thay vì `(a * b) / gcd(a, b)`. Vì $gcd(a, b)$ là ước của $a$, phép chia luôn là phép chia hết và thương luôn nhỏ hơn hoặc bằng $a$.
]

== 9.3 Lũy Thừa Nhị Phân (Binary Exponentiation)

Để tính $A^B mod M$ với $B <= 10^{18}$, việc nhân lặp lại $B$ lần mất $O(B)$ thời gian (chắc chắn bị Time Limit Exceeded).
Thuật toán lũy thừa nhị phân phân tích $B$ theo hệ cơ số 2:
$ A^B = A^(sum b_i 2^i) = product_(b_i = 1) A^(2^i) $

Tại mỗi bước, cơ số được bình phương: $A arrow.l A^2 mod M$, và nếu bit cuối của số mũ là 1, ta nhân cơ số hiện tại vào kết quả tích lũy.

#syntax-anatomy(
  `long long res = 1; while (b > 0) { if (b & 1) res = (1LL * res * a) % m; a = (1LL * a * a) % m; b >>= 1; }`,
  (
    ("while (b > 0)", "Lặp chừng nào số mũ b vẫn còn bit 1 chưa duyệt."),
    ("if (b & 1)", "Kiểm tra bit có trọng số nhỏ nhất của b có bật hay không."),
    ("res = (1LL * res * a) % m;", "Nhân cơ số hiện tại vào tích lũy và lấy dư an toàn."),
    ("a = (1LL * a * a) % m;", "Bình phương cơ số chuẩn bị cho lũy thừa 2 kế tiếp."),
    ("b >>= 1;", "Dịch phải 1 bit (tương đương chia nguyên cho 2).")
  )
)

== 9.4 Sàng Số Nguyên Tố Eratosthenes

Để tìm mọi số nguyên tố nhỏ hơn hoặc bằng $N$, ta khởi tạo mảng đánh dấu `is_prime` toàn giá trị `true`. Duyệt $p$ từ 2: nếu $p$ là số nguyên tố, ta đánh dấu toàn bộ bội số của $p$ bắt đầu từ $p times p$ là hợp số (`false`).

Độ phức tạp tính toán là:
$ sum_(p <= N) N/p = O(N log log N) $

== 9.5 Bảng Chạy Bàn Trên Giấy: Tính $3^5 mod 7$

#trace-matrix(
  headers: ("Bước", "Số mũ b", "Bit chẵn/lẻ", "Cơ số a", "Biến tích lũy res"),
  rows: (
    ("Khởi tạo", "5 (101)", "-", "3", "1"),
    ("1", "5", "Lẻ (b & 1 = 1)", "3", "res = (1 * 3) % 7 = 3"),
    ("Bình phương", "2 (b >> 1)", "-", "a = (3 * 3) % 7 = 2", "3"),
    ("2", "2", "Chẵn (b & 1 = 0)", "2", "giữ nguyên res = 3"),
    ("Bình phương", "1 (b >> 1)", "-", "a = (2 * 2) % 7 = 4", "3"),
    ("3", "1", "Lẻ (b & 1 = 1)", "4", "res = (3 * 4) % 7 = 5"),
    ("Kết thúc", "0", "-", "a = (4 * 4) % 7 = 2", "*5*")
  )
)

== 9.6 Bài Tập Tiêu Chuẩn

#let ch09-tests = json("/code/vol2/ch09_number_theory/tests.json")

#hand-trace-problem(
  name: "Bài 9.1 - Số Học Cơ Bản Cho CP (Number Theory Fundamentals)",
  source: "Nền tảng C++14 - Số học thuật toán",
  problem_desc: [
    Cho ba số nguyên dương $A, B, M$ ($1 <= A, B <= 10^9, 2 <= M <= 10^9+7$) và số nguyên $K$ ($1 <= K <= 100$). Em hãy thực hiện tính toán:
    1. Ước chung lớn nhất $G = gcd(A, B)$ bằng thuật toán Euclid.
    2. Lũy thừa nhị phân $P = A^B mod M$.
    3. Đếm số lượng các số nguyên tố $S$ nhỏ hơn hoặc bằng $K$ bằng sàng Eratosthenes.

    *Đầu vào (Input):* Bốn số nguyên $A, B, M, K$ trên cùng một dòng. \
    *Đầu ra (Output):* In ra 3 số nguyên $G, P, S$ cách nhau một khoảng trắng.
  ],
  sample: (
    input: "3 5 7 10\n",
    output: "1 5 4\n"
  ),
  tests_10: ch09-tests
)
