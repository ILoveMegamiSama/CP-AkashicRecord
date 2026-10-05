#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 5: Địa Chỉ Ô Nhớ, Bản Chất Con Trỏ & Toán Tử &, \*

#term-box(
  term: "Con Trỏ (Pointer)",
  origin: "Được nhà khoa học máy tính Harold Lawson phát minh năm 1964 trong ngôn ngữ PL/I, đặt nền tảng cho việc quản lý bộ nhớ trực tiếp trong các ngôn ngữ hệ thống như C và C++.",
  intuition: "Hãy hình dung mỗi ngôi nhà trên phố có một 'Số nhà' (Địa chỉ ô nhớ) và bên trong chứa 'Đồ đạc' (Giá trị dữ liệu). Con trỏ không phải là ngôi nhà; con trỏ là một mẩu giấy ghi lại con số 'Số nhà' đó. Khi cầm mẩu giấy, bạn có thể đi đến ngôi nhà tương ứng để xem hoặc sửa đổi đồ đạc bên trong."
)

== 5.1 Toán Tử Lấy Địa Chỉ Ô Nhớ `&` (Address-Of)

Mọi biến số khai báo trong chương trình đều ngự trị tại một địa chỉ cụ thể trên dải ô nhớ RAM. Toán tử đơn phân `&` đặt trước tên biến cho phép chúng ta lấy ra tọa độ ô nhớ vật lý này:

```cpp
int x = 42;
// &x là địa chỉ của ô nhớ chứa giá trị 42 (ví dụ: 0x7ffd58)
```

== 5.2 Bản Chất Con Trỏ & Toán Tử Giải Tham Chiếu `*` (Dereferencing)

Con trỏ đơn thuần là một biến số có kích thước $8$ Bytes (trên hệ điều hành 64-bit), có nhiệm vụ duy nhất là *lưu trữ địa chỉ của một biến khác*:

#syntax-anatomy(
  `int* ptr = &x;  *ptr = 100;`,
  (
    ("int*", "Khai báo kiểu dữ liệu: `ptr` là một con trỏ có khả năng trỏ tới ô nhớ kiểu `int`."),
    ("= &x;", "Nạp địa chỉ của biến `x` vào ô nhớ của con trỏ `ptr`."),
    ("*ptr", "Toán tử giải tham chiếu (dereference): Đi theo địa chỉ đang lưu trong `ptr` để tiếp cận ô nhớ gốc `x`."),
    ("= 100;", "Ghi đè giá trị 100 thẳng vào ô nhớ `x`. Lúc này giá trị của `x` biến thành 100!")
  )
)

== 5.3 Số Học Con Trỏ & Đẳng Thức Nền Tảng $a[i] == *(a + i)$

Phép toán cộng trừ trên con trỏ không phải là cộng trừ byte thông thường, mà là nhảy theo *bước nhảy kích thước kiểu dữ liệu* ($text("sizeof")(T)$):
- Nếu `ptr` trỏ tới `int` tại địa chỉ `1000`, thì `ptr + 1` sẽ có địa chỉ `1004` (vì kiểu `int` chiếm 4 bytes).
- Nếu `ptr` trỏ tới `double` tại địa chỉ `1000`, thì `ptr + 1` sẽ có địa chỉ `1008`.

#callout(kind: "theory", title: "Bí mật đằng sau toán tử ngoặc vuông mảng [ ]")[
  Trong ngôn ngữ C/C++, tên của một mảng tĩnh `a` tự động suy biến thành con trỏ hằng trỏ vào phần tử đầu tiên:
  $ a equiv &a[0] $
  Do đó, cú pháp truy xuất phần tử `a[i]` thực chất chỉ là "đường tắt cú pháp" (syntactic sugar) cho phép giải tham chiếu sau khi dời con trỏ đi $i$ bước:
  $ a[i] equiv *(a + i) $
]

== 5.4 Chạy Bàn Mô Hình Con Trỏ Trên Giấy

Cho mảng `int a[3] = {10, 20, 30}` và con trỏ `ptr = a`:
#trace-matrix(
  headers: ("Biểu thức", "Địa chỉ ô nhớ giả định", "Giá trị đọc được", "Ý nghĩa thao tác"),
  rows: (
    ("ptr", "0x100", "0x100", "Con trỏ giữ địa chỉ phần tử đầu tiên"),
    ("*ptr", "0x100", "10", "Giải tham chiếu a[0]"),
    ("ptr + 1", "0x104", "0x104", "Dời con trỏ sang phần tử tiếp theo (+4 bytes)"),
    ("*(ptr + 1)", "0x104", "20", "Giải tham chiếu a[1]"),
    ("*(ptr + 2)", "0x108", "30", "Giải tham chiếu a[2]")
  )
)

== 5.5 Bài Tập Tiêu Chuẩn

#let ch05-tests = json("/code/vol1/ch05_pointer/tests.json")

#hand-trace-problem(
  name: "Bài 5.1 - Tìm Cực Trị Bằng Con Trỏ & Khoảng Cách Ô Nhớ (Pointer MinMax)",
  source: "Nền tảng C++14 - Thao tác Con trỏ thuần túy",
  problem_desc: [
    Cho một mảng số nguyên $A$ gồm $N$ phần tử ($1 \le N \le 8$).

    Sử dụng thuần túy con trỏ `int* ptr = a;` và phép số học con trỏ `*(ptr + i)` (không dùng cú pháp dấu ngoặc vuông `[]`), em hãy tìm:
    1. Giá trị nhỏ nhất (`min_val`) và vị trí xuất hiện đầu tiên của nó (`min_idx`).
    2. Giá trị lớn nhất (`max_val`) và vị trí xuất hiện đầu tiên của nó (`max_idx`).
    3. Tính khoảng cách vị trí ô nhớ giữa phần tử Max và Min: $"offset" = "max_idx" - "min_idx"$.

    *Đầu vào (Input):* Dòng 1 chứa $N$. Dòng 2 chứa $N$ số nguyên. \
    *Đầu ra (Output):* In ra 3 số nguyên `min_val max_val offset` cách nhau một khoảng trắng.
  ],
  sample: (
    input: "3\n10 20 30\n",
    output: "10 30 2\n"
  ),
  tests_10: ch05-tests
)
