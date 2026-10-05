#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 4: Mảng 1D, 2D & Chuỗi Ký Tự Cơ Bản

#term-box(
  term: "Chỉ Số 0-Based (Zero-based Indexing)",
  origin: "Xuất hiện từ ngôn ngữ lập trình BCPL và C vào thập niên 1960-1970 do nhà khoa học máy tính Martin Richards và Dennis Ritchie phát triển.",
  intuition: "Chỉ số $i$ của mảng không đại diện cho 'thứ tự phần tử' theo cách đếm thông thường của con người, mà đại diện cho 'độ dời khoảng cách' (offset) tính từ vị trí ô nhớ đầu tiên của mảng trên thanh RAM. Phần tử đầu tiên có khoảng cách dời bằng 0, do đó có chỉ số là 0."
)

== 4.1 Bản Chất Ô Nhớ Liên Tiếp Của Mảng 1D

Khi khai báo `int a[5]`, hệ thống cấp phát chính xác $5 times 4 = 20$ bytes nằm liền kề nhau trên RAM:
$ text("Địa chỉ của ") a[i] = text("Địa chỉ cơ sở (base)") + i times text("sizeof")(text("int")) $

#callout(kind: "memory", title: "Mô hình lát cắt bộ nhớ của Mảng 1D")[
  Giả sử mảng `a` được cấp phát bắt đầu từ địa chỉ `0x100`:
  - `a[0]`: Chiếm các byte `0x100 .. 0x103` (Giá trị phần tử đầu tiên)
  - `a[1]`: Chiếm các byte `0x104 .. 0x107` (Giá trị phần tử thứ hai)
  - `a[2]`: Chiếm các byte `0x108 .. 0x10B` (Giá trị phần tử thứ ba)
  Nhờ cấu trúc liên tiếp này, CPU có thể truy xuất bất kỳ phần tử `a[i]` nào trong thời gian tức thì $O(1)$ chỉ bằng một phép tính số học đơn giản!
]

== 4.2 Mảng 2 Chiều & Quy Ước Thứ Tự Dòng-Trước (Row-Major Order)

Bộ nhớ RAM là một đường thẳng $1$ chiều. Do đó, ma trận $R times C$ được trải phẳng lần lượt từng hàng:
$ text("Địa chỉ của ") a[i][j] = text("base") + (i times C + j) times text("sizeof")(text("kiểu dữ liệu")) $

== 4.3 Chuỗi Ký Tự `std::string` & Bảng Mã ASCII

Mỗi ký tự `char` thực chất là một số nguyên 8-bit trong bảng mã ASCII:
- Ký tự chữ số `'0'` đến `'9'`: Có mã $48 dots 57$. Chuyển đổi: `digit = c - '0'`.
- Chữ hoa `'A'` đến `'Z'`: Mã $65 dots 90$.
- Chữ thường `'a'` đến `'z'`: Mã $97 dots 122$.
- Khoảng cách giữa chữ thường và chữ hoa: `'a' - 'A' = 32`.

#syntax-anatomy(
  `for (int i = 0; i < len / 2; ++i) { if (s[i] != s[len - 1 - i]) return false; }`,
  (
    ("int i = 0; i < len / 2;", "Chỉ cần duyệt nửa đầu chuỗi vì mỗi ký tự sẽ được so khớp với ký tự đối xứng ở nửa sau."),
    ("s[i]", "Ký tự thứ `i` tính từ đầu chuỗi (bên trái)."),
    ("s[len - 1 - i]", "Ký tự đối xứng tương ứng tính từ cuối chuỗi (bên phải)."),
    ("return false;", "Nếu phát hiện bất kỳ cặp ký tự đối xứng nào khác nhau, chuỗi lập tức không phải Palindrome.")
  )
)

== 4.4 Quy Trình Kiểm Tra Đối Xứng (Palindrome) Trên Giấy

Với chuỗi $S = "radar"$ có độ dài $"len" = 5$:
#trace-matrix(
  headers: ("Bước", "Chỉ số i", "s[i]", "Chỉ số đối xứng (4 - i)", "s[4 - i]", "So khớp"),
  rows: (
    ("1", "0", "'r'", "4", "'r'", "Bằng nhau ('r' == 'r')"),
    ("2", "1", "'a'", "3", "'a'", "Bằng nhau ('a' == 'a')"),
    ("Kết luận", "-", "-", "-", "-", "Chuỗi đối xứng (YES)")
  )
)

== 4.5 Bài Tập Tiêu Chuẩn

#let ch04-tests = json("/code/vol1/ch04_array_string/tests.json")

#hand-trace-problem(
  name: "Bài 4.1 - Thống Kê Mảng & Chuỗi Đối Xứng (Array Stats & Palindrome)",
  source: "Nền tảng C++14 - Mảng 1D & Xử lý Chuỗi",
  problem_desc: [
    Cho một mảng $A$ gồm $N$ số nguyên ($1 \le N \le 8$) và một chuỗi ký tự $S$ gồm các chữ cái tiếng Anh in thường.

    Em hãy thực hiện:
    1. Tính giá trị trung bình cộng số học $"avg" = sum A / N$ (theo giá trị thực chính xác). Đếm số lượng phần tử trong mảng $A$ có giá trị lớn hơn $"avg"$.
    2. Kiểm tra xem chuỗi $S$ có phải là chuỗi đối xứng (Palindrome) hay không (chuỗi đọc xuôi hay đọc ngược đều giống nhau).

    *Đầu vào (Input):* \
    - Dòng 1: Số nguyên $N$. \
    - Dòng 2: $N$ số nguyên của mảng $A$. \
    - Dòng 3: Chuỗi ký tự $S$. \
    *Đầu ra (Output):* Số lượng phần tử lớn hơn trung bình cộng và nhãn `YES` (nếu đối xứng) hoặc `NO` (nếu không đối xứng) cách nhau dấu cách.
  ],
  sample: (
    input: "3\n1 2 3\naba\n",
    output: "1 YES\n"
  ),
  tests_10: ch04-tests
)
