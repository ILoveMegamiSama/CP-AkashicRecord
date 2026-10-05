#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 6: Hàm, Tham Chiếu, Tham Trị & Ngăn Xếp Gọi Hàm (Call Stack)

#term-box(
  term: "Ngăn Xếp Gọi Hàm (Call Stack)",
  origin: "Được nhà khoa học máy tính người Đức Klaus Samelson và Friedrich L. Bauer đề xuất năm 1957 trong việc biên dịch biểu thức số học.",
  intuition: "Một chồng đĩa trong quán ăn. Mỗi khi bạn gọi một hàm mới, bạn đặt thêm một chiếc đĩa (Stack Frame) lên đỉnh chồng đĩa. Mọi biến cục bộ của hàm nằm gọn trong chiếc đĩa đó. Khi hàm hoàn thành công việc và trả về kết quả, chiếc đĩa được nhấc ra khỏi đỉnh để quay lại chiếc đĩa bên dưới."
)

== 6.1 Phân Biệt Triệt Để: Tham Trị (Pass-by-Value) & Tham Chiếu (Pass-by-Reference)

Trong C++, cách chúng ta truyền biến vào hàm quyết định việc ô nhớ mới có được tạo ra hay không:

#table(
  columns: (3cm, 3.5cm, 3.5fr),
  stroke: 0.4pt + luma(180),
  fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
  align: (center + horizon, left + horizon, left + horizon),
  inset: 6.5pt,
  table.header([*Phương thức*], [*Cú pháp hàm*], [*Bản chất ô nhớ*]),
  [Truyền Giá Trị\ (Pass-by-Value)],
  [`void func(int x)`],
  [Hệ thống sao chép giá trị sang một ô nhớ hoàn toàn mới trong Stack Frame của `func`. Mọi thay đổi đối với `x` không hề ảnh hưởng đến biến gốc ở hàm gọi.],
  [Truyền Tham Chiếu\ (Pass-by-Reference)],
  [`void func(int& x)`],
  [Dấu `&` ở đây KHÔNG PHẢI toán tử lấy địa chỉ, mà là cú pháp khai báo *Bí danh (Alias)*. Biến `x` bên trong hàm dùng chung địa chỉ với biến gốc. Mọi thay đổi với `x` sẽ làm thay đổi trực tiếp biến gốc!]
)

#syntax-anatomy(
  `void swap(int& a, int& b) { int temp = a; a = b; b = temp; }`,
  (
    ("int& a, int& b", "Nhận bí danh tham chiếu của 2 biến truyền vào. Không tạo ô nhớ sao chép mới."),
    ("int temp = a;", "Lưu giá trị của biến gốc thứ nhất vào biến tạm thời cục bộ `temp`."),
    ("a = b;", "Ghi đè giá trị biến gốc thứ hai vào biến gốc thứ nhất."),
    ("b = temp;", "Hoàn tất hoán đổi hai biến gốc bên ngoài phạm vi hàm!")
  )
)

== 6.2 Mô Hình Khung Ngăn Xếp (Stack Frame) & Đệ Quy Euclid

Khi một hàm đệ quy tự gọi chính nó, mỗi lần gọi sẽ tạo ra một *Khung ngăn xếp (Stack Frame)* riêng biệt xếp chồng lên nhau. 

Giả sử ta gọi hàm tính ước chung lớn nhất $gcd(12, 8)$:
- *Bước 1 (Đáy Stack):* `gcd(12, 8)` với $"depth" = 1$. Vì $b = 8 != 0$, gọi tiếp `gcd(8, 4)`.
- *Bước 2 (Chồng thêm):* `gcd(8, 4)` với $"depth" = 2$. Vì $b = 4 != 0$, gọi tiếp `gcd(4, 0)`.
- *Bước 3 (Đỉnh Stack):* `gcd(4, 0)` với $"depth" = 3$. Chạm điều kiện dừng (Base case) $b = 0$, trả về $a = 4$.
- *Bước 4 (Giải phóng):* Lần lượt các khung ngăn xếp được pop ra khỏi đỉnh và trả giá trị về `main()`.

#callout(kind: "warning", title: "Nguy cơ Tràn Ngăn Xếp (Stack Overflow)")[
  Bộ nhớ dành cho Call Stack là hữu hạn (thường khoảng 8MB trên Linux hoặc máy chấm thi). Nếu bạn viết hàm đệ quy thiếu điều kiện dừng hoặc đệ quy quá sâu ($"depth" > 10^5$), Call Stack sẽ tràn qua vùng nhớ khác và chương trình bị hệ điều hành tiêu diệt ngay lập tức với mã lỗi `RTE (Runtime Error / Segmentation fault)`!
]

== 6.3 Chạy Bàn Khung Ngăn Xếp Trên Giấy

Theo dõi trạng thái đỉnh Stack khi tìm $gcd(12, 8)$:
#trace-matrix(
  headers: ("Bước", "Khung ngăn xếp đỉnh", "Tham số a", "Tham số b", "Độ sâu depth", "Hành động"),
  rows: (
    ("1", "gcd(12, 8)", "12", "8", "1", "Push khung 1, gọi tiếp"),
    ("2", "gcd(8, 4)", "8", "4", "2", "Push khung 2, gọi tiếp"),
    ("3", "gcd(4, 0)", "4", "0", "3", "Push khung 3, chạm Base Case!"),
    ("4", "Pop khung 3", "4", "0", "3", "Return 4 về khung 2"),
    ("5", "Pop khung 2", "8", "4", "2", "Return 4 về khung 1"),
    ("6", "Pop khung 1", "12", "8", "1", "Return 4 về hàm main()")
  )
)

== 6.4 Bài Tập Tiêu Chuẩn

#let ch06-tests = json("/code/vol1/ch06_call_stack/tests.json")

#hand-trace-problem(
  name: "Bài 6.1 - Khung Ngăn Xếp Đệ Quy & Ước Số Chung Lớn Nhất (Call Stack & GCD)",
  source: "Nền tảng C++14 - Tham chiếu & Call Stack",
  problem_desc: [
    Cài đặt hàm tìm ước chung lớn nhất Euclid theo mô hình đệ quy:
    `int gcd(int a, int b, int depth, int& max_depth)`
    - Tham số `depth`: truyền theo tham trị để ghi nhận độ sâu của khung ngăn xếp hiện tại (bắt đầu từ $1$).
    - Tham số `max_depth`: truyền theo tham chiếu `int&` để cập nhật độ sâu lớn nhất mà Call Stack đạt được trong toàn bộ chu kỳ sống.
    - Tại mỗi khung, nếu `depth > max_depth`, gán `max_depth = depth`.
    - Nếu $b = 0$, trả về $a$; ngược lại gọi đệ quy `gcd(b, a % b, depth + 1, max_depth)`.

    *Đầu vào (Input):* Hai số nguyên $A, B$ ($1 \le A, B \le 100$). \
    *Đầu ra (Output):* Hai số nguyên `gcd_result max_depth` cách nhau dấu cách.
  ],
  sample: (
    input: "12 8\n",
    output: "4 3\n"
  ),
  tests_10: ch06-tests
)
