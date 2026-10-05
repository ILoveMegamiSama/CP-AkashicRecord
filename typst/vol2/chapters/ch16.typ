#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 16: Ngăn Xếp & Hàng Đợi STL

#term-box(
  term: "Cấu Trúc LIFO, FIFO & Ngăn Xếp Đơn Điệu (Monotonic Stack)",
  origin: "Alan Turing giới thiệu khái niệm ngăn xếp (Stack) năm 1946 với lệnh 'bury' và 'unbury' để lưu vết địa chỉ quay về của chương trình con.",
  intuition: "Ngăn xếp (Stack) giống như một chồng đĩa: chiếc đĩa đặt vào sau cùng sẽ được lấy ra đầu tiên (LIFO - Last In First Out). Ngăn xếp Đơn điệu là kỹ thuật duy trì các phần tử trong ngăn xếp luôn tăng dần hoặc giảm dần bằng cách loại bỏ các phần tử bị vi phạm tính đơn điệu, giải quyết các bài toán tìm cực trị kế cận trong thời gian tuyến tính O(N)."
)

== 16.1 Toàn Cảnh Các Cấu Trúc Hàng Đợi Trong C++ STL

#table(
  columns: (2.2cm, 2.5cm, 3.5cm, 2fr),
  stroke: 0.5pt + luma(160),
  fill: (col, row) => if row == 0 { luma(235) } else { white },
  table.header([*Container*], [*Cơ chế*], [*Thao tác chính*], [*Đặc tính nổi bật*]),
  [`std::stack`], [LIFO], [`push()`, `pop()`, `top()`], [Truy xuất đỉnh $O(1)$, đóng gói quanh `deque`/`vector`],
  [`std::queue`], [FIFO], [`push()`, `pop()`, `front()`], [Vào trước ra trước, dùng trong BFS đồ thị],
  [`std::deque`], [Hai đầu], [`push_front()`, `push_back()`], [Chèn/xóa ở cả 2 đầu $O(1)$, chia thành nhiều chunk bộ nhớ],
  [`std::priority_queue`], [Heap], [`push()`, `pop()`, `top()`], [Cây vun đống nhị phân, lấy cực trị $O(1)$, chèn/xóa $O(log N)$]
)

== 16.2 Kỹ Thuật Ngăn Xếp Đơn Điệu (Monotonic Stack)

Xét bài toán kinh điển: *Next Greater Element (NGE)* - Với mỗi phần tử $A[i]$, tìm phần tử đầu tiên bên phải có giá trị lớn hơn $A[i]$.

*Thuật toán ngây thơ:* Với mỗi $i$, duyệt $j$ từ $i + 1$ đến $N - 1$. Chi phí $O(N^2)$.
*Thuật toán Ngăn Xếp Đơn Điệu:*
Duyệt mảng từ phải qua trái ($i = N - 1$ lùi về $0$):
1. Chừng nào ngăn xếp không rỗng và phần tử đỉnh ngăn xếp nhỏ hơn hoặc bằng $A[i]$: loại bỏ đỉnh (`pop()`). Vì $A[i]$ đứng trước và lớn hơn, đỉnh cũ sẽ không bao giờ có thể là NGE của bất kỳ phần tử nào đứng bên trái $A[i]$.
2. Nếu ngăn xếp còn phần tử: đỉnh ngăn xếp chính là NGE của $A[i]$. Ngược lại, $A[i]$ không có NGE (ghi nhận $-1$).
3. Đẩy $A[i]$ vào ngăn xếp.

Mỗi phần tử được `push` đúng 1 lần và `pop` tối đa 1 lần, tổng độ phức tạp toàn bộ mảng là $O(N)$!

#syntax-anatomy(
  `for (int i = n - 1; i >= 0; --i) { while (!st.empty() && st.top() <= a[i]) st.pop(); nge[i] = st.empty() ? -1 : st.top(); st.push(a[i]); }`,
  (
    ("for (int i = n - 1; i >= 0; --i)", "Duyệt ngược từ phải sang trái để tích lũy các ứng viên bên phải."),
    ("while (!st.empty() && st.top() <= a[i]) st.pop();", "Loại bỏ các phần tử bị che khuất bởi a[i] (duy trì đơn điệu giảm dần)."),
    ("nge[i] = st.empty() ? -1 : st.top();", "Nếu ngăn xếp còn phần tử, đỉnh chính là phần tử lớn hơn đầu tiên."),
    ("st.push(a[i]);", "Đẩy a[i] vào làm ứng viên tiềm năng cho các phần tử bên trái nó.")
  )
)

== 16.3 Bảng Chạy Bàn Trên Giấy: Mảng $[4, 5, 2, 25]$

#trace-matrix(
  headers: ("Bước i", "Giá trị a[i]", "Thao tác trên Stack", "Stack sau bước", "Kết quả nge[i]"),
  rows: (
    ("Khởi tạo", "-", "Stack rỗng", "[]", "-"),
    ("i=3", "a[3]=25", "Stack rỗng -> không pop", "[25]", "-1"),
    ("i=2", "a[2]=2", "top=25 > 2 -> giữ nguyên", "[25, 2]", "25"),
    ("i=1", "a[1]=5", "top=2 <= 5 -> pop(2); top=25 > 5", "[25, 5]", "25"),
    ("i=0", "a[0]=4", "top=5 > 4 -> giữ nguyên", "[25, 5, 4]", "5"),
    ("Kết quả", "-", "-", "-", "*5 25 25 -1*")
  )
)

== 16.4 Bài Tập Tiêu Chuẩn

#let ch16-tests = json("/code/vol2/ch16_stack_queue/tests.json")

#hand-trace-problem(
  name: "Bài 16.1 - Ngăn Xếp Đơn Điệu: Phần Tử Lớn Hơn Đầu Tiên Bên Phải (Next Greater Element)",
  source: "Nền tảng C++14 - Ngăn xếp đơn điệu",
  problem_desc: [
    Cho dãy $N$ số nguyên dương $A_1, A_2, dots, A_N$ ($1 <= N <= 15$).
    Với mỗi vị trí $i$ ($1 <= i <= N$), hãy tìm phần tử đầu tiên nằm bên phải $A[i]$ có giá trị lớn hơn hẳn $A[i]$. Nếu không tồn tại phần tử nào lớn hơn, quy ước giá trị là $-1$.

    *Đầu vào (Input):* Dòng 1 ghi số nguyên $N$. Dòng 2 ghi $N$ số nguyên $A_1, A_2, dots, A_N$. \
    *Đầu ra (Output):* In ra $N$ số nguyên là kết quả Next Greater Element tương ứng, cách nhau một khoảng trắng.
  ],
  sample: (
    input: "4\n4 5 2 25\n",
    output: "5 25 25 -1\n"
  ),
  tests_10: ch16-tests
)
