#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 13: Đệ Quy Sơ Cấp & Cây Gọi Đệ Quy

#term-box(
  term: "Đệ Quy & Cây Gọi Đệ Quy (Recursion Tree)",
  origin: "Khái niệm hàm đệ quy được phát triển trong logic toán học bởi Thoralf Skolem (1923) và Kurt Gödel (1931), trước khi trở thành hòn đá tảng của khoa học máy tính thông qua phép chia để trị và quy hoạch động.",
  intuition: "Một bài toán đệ quy giống như việc giải một câu đố bằng cách phân rã nó thành các câu đố nhỏ hơn có cùng cấu trúc, cho đến khi chạm tới câu đố nhỏ nhất mà câu trả lời là hiển nhiên (Base Case). Khi vẽ trên giấy, toàn bộ tiến trình này nở rộng thành một Cây gọi đệ quy phân nhánh."
)

== 13.1 Hai Trụ Cột Sinh Tử Của Hàm Đệ Quy

Mọi hàm đệ quy đúng đắn bắt buộc phải có hai thành phần:
1. *Điểm dừng cơ sở (Base Case):* Điều kiện quy mô bài toán đủ nhỏ để trả về kết quả ngay lập tức mà không gọi thêm hàm đệ quy nào khác.
2. *Bước đệ quy (Recursive Step):* Lời gọi hàm chính nó với tham số tiến dần về điểm dừng cơ sở.

#callout(kind: "danger", title: "Thảm họa tràn ngăn xếp (Stack Overflow)")[
  Nếu một hàm đệ quy không có điểm dừng, hoặc tham số truyền vào không tiến về điểm dừng cơ sở, CPU sẽ liên tục nạp các khung ngăn xếp (stack frames) mới vào vùng nhớ Stack của hệ điều hành cho tới khi cạn kiệt bộ nhớ ($approx 8$MB trên Linux). Chương trình sẽ bị hủy diệt ngay lập tức bằng lỗi Crash / RTE.
]

== 13.2 Mô Hình Cây Gọi Đệ Quy Trên Giấy

Khi chạy bàn một hàm đệ quy trên giấy không có máy tính:
- Mỗi nút tròn đại diện cho một lần gọi hàm với tham số cụ thể, ví dụ $f(3)$.
- Nhánh từ nút cha xuống nút con biểu thị lời gọi hàm con được kích hoạt từ thân hàm cha.
- Thứ tự duyệt trên cây: CPU thực thi theo chiều sâu (Depth-First Search): đi hết nhánh con bên trái (Pre-order), thu nhận giá trị trả về (Post-order), rồi mới chuyển sang nhánh con bên phải.

== 13.3 Mổ Xẻ Cú Pháp Hàm Đệ Quy Phân Hoạch

Xét hàm $f(n) = f(n - 1) + f(n / 2) + n$ với $f(n) = 1$ khi $n <= 1$:

#syntax-anatomy(
  `long long solve_f(int n) { if (n <= 1) return 1; return solve_f(n - 1) + solve_f(n / 2) + n; }`,
  (
    ("if (n <= 1) return 1;", "Điểm dừng cơ sở: khi n=0 hoặc n=1, trả về 1 ngay lập tức."),
    ("solve_f(n - 1)", "Nhánh trái: đệ quy giải bài toán quy mô n - 1."),
    ("solve_f(n / 2)", "Nhánh phải: đệ quy giải bài toán quy mô thu nhỏ phân nửa n / 2."),
    ("+ n;", "Tổng hợp kết quả bài toán con cộng với chi phí gộp của bài toán hiện tại.")
  )
)

== 13.4 Bảng Chạy Bàn Trên Giấy: Cây Đệ Quy Cho $N = 3$

Lời gọi gốc $f(3)$:
- $f(3)$ gọi $f(2)$ và $f(1)$
  - $f(2)$ gọi $f(1)$ và $f(1)$
    - $f(1)$ là base case, trả về $1$ (lời gọi 1)
    - $f(1)$ là base case, trả về $1$ (lời gọi 2)
    - $f(2) = 1 + 1 + 2 = 4$
  - $f(1)$ là base case, trả về $1$ (lời gọi 3)
- $f(3) = 4 + 1 + 3 = 8$

#trace-matrix(
  headers: ("Thứ tự gọi", "Hàm f(n)", "Độ sâu", "Hành động", "Giá trị trả về"),
  rows: (
    ("1", "f(3)", "0", "Gọi con f(2) và f(1)", "Chờ nhánh con"),
    ("2", "f(2)", "1", "Gọi con f(1) và f(1)", "Chờ nhánh con"),
    ("3", "f(1)", "2", "Base case n <= 1", "1"),
    ("4", "f(1)", "2", "Base case n <= 1", "1"),
    ("Thu nhận f(2)", "f(2)", "1", "1 + 1 + 2", "4"),
    ("5", "f(1)", "1", "Base case n <= 1", "1"),
    ("Thu nhận f(3)", "f(3)", "0", "4 + 1 + 3", "*8*")
  )
)

== 13.5 Bài Tập Tiêu Chuẩn

#let ch13-tests = json("/code/vol2/ch13_recursion_tree/tests.json")

#hand-trace-problem(
  name: "Bài 13.1 - Cây Gọi Đệ Quy: Phân Hoạch & Đếm Nút (Recursion Tree Node Counting)",
  source: "Nền tảng C++14 - Đệ quy cơ bản",
  problem_desc: [
    Xét hàm đệ quy $f(n)$ được định nghĩa như sau:
    - Nếu $n <= 1$: $f(n) = 1$.
    - Nếu $n > 1$: $f(n) = f(n - 1) + f(n / 2) + n$ (với phép chia nguyên `/`).

    Cho số nguyên $N$ ($0 <= N <= 15$). Em hãy tính nhẩm trên giấy:
    1. Giá trị $f(N)$.
    2. Tổng số lời gọi hàm đệ quy (tổng số nút trong cây đệ quy) được tạo ra `total_calls`.
    3. Chiều sâu tối đa của cây đệ quy `max_depth` (gốc có độ sâu 0).

    *Đầu vào (Input):* Một số nguyên duy nhất $N$ trên một dòng. \
    *Đầu ra (Output):* In ra 3 số nguyên `val total_calls max_depth` cách nhau một khoảng trắng.
  ],
  sample: (
    input: "3\n",
    output: "8 5 2\n"
  ),
  tests_10: ch13-tests
)
