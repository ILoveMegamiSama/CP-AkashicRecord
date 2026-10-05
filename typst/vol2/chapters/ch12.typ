#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 12: Sắp Xếp & Tìm Kiếm Nhị Phân, Chặt Nhị Phân Kết Quả

#term-box(
  term: "Không Gian Nghiệm Đơn Điệu & Chặt Nhị Phân Kết Quả",
  origin: "Tìm kiếm nhị phân xuất hiện từ thời Babylon cổ đại trong thuật toán xấp xỉ nghiệm và được chuẩn hóa trong khoa học máy tính bởi John Mauchly (1946).",
  intuition: "Khi gặp bài toán 'tìm giá trị nhỏ nhất thỏa mãn điều kiện X' mà việc giải trực tiếp quá khó, nhưng nếu cho trước một giá trị nghiệm mid cụ thể thì ta lại kiểm tra được dễ dàng trong O(N). Nếu hàm kiểm tra có tính chất đơn điệu (False False ... True True), ta có thể chặt đôi không gian nghiệm qua mỗi bước log2(Range), biến bài toán tối ưu thành bài toán kiểm tra tính khả thi."
)

== 12.1 `std::sort` Trong C++14 & Quy Tắc Strict Weak Ordering

Thuật toán `std::sort` trong Thư viện Tiêu chuẩn C++ được cài đặt bằng kỹ thuật Introsort (kết hợp QuickSort, HeapSort và InsertionSort), đảm bảo thời gian chạy $O(N log N)$ trong mọi trường hợp xấu nhất.

#callout(kind: "danger", title: "Cạm bẫy sống còn: Strict Weak Ordering")[
  Hàm so sánh (comparator) truyền vào `std::sort` bắt buộc phải tuân thủ tiên đề *Strict Weak Ordering*.
  Quy tắc quan trọng nhất: Khi hai phần tử bằng nhau ($a == b$), hàm so sánh *bắt buộc phải trả về false*!
  Nếu viết `return a <= b;`, `std::sort` có thể rơi vào vòng lặp vô tận hoặc truy xuất vượt biên bộ nhớ (Segmentation Fault).
]

== 12.2 C++14 Generic Lambdas Làm Hàm So Sánh

C++14 cho phép sử dụng `auto` trong danh sách tham số của hàm ẩn danh (lambda), giúp cú pháp so sánh ngắn gọn và uyển chuyển:
```cpp
std::sort(pts.begin(), pts.end(), [](const auto& a, const auto& b) {
    if (a.first != b.first) return a.first < b.first;
    return a.second > b.second; // Tung độ giảm dần nếu hoành độ bằng nhau
});
```

== 12.3 Tìm Kiếm Nhị Phân: `lower_bound` vs `upper_bound`

Trên một mảng hoặc vector đã được sắp xếp tăng dần:
- `std::lower_bound(first, last, val)`: Trả về con trỏ/iterator tới phần tử đầu tiên có giá trị *lớn hơn hoặc bằng* $x$ ($>= x$).
- `std::upper_bound(first, last, val)`: Trả về con trỏ/iterator tới phần tử đầu tiên có giá trị *lớn hơn hẳn* $x$ ($> x$).
Số lượng phần tử có giá trị bằng $x$ chính là khoảng cách `upper_bound - lower_bound`.

== 12.4 Chặt Nhị Phân Kết Quả (Binary Search on Answer)

Giả sử cần tìm giá trị nhỏ nhất $X$ sao cho hàm khả thi $"check"(X) == "true"$.
- Xác định cận dưới chắc chắn không thỏa mãn hoặc cận cực tiểu: $L = max(A)$.
- Xác định cận trên chắc chắn thỏa mãn: $R = sum A$.
- Tính điểm giữa: $M = L + (R - L) / 2$. (Cách viết chống tràn số).

#syntax-anatomy(
  `long long low = max_val, high = sum_val, ans = high; while (low <= high) { long long mid = low + (high - low) / 2; if (check(mid)) { ans = mid; high = mid - 1; } else { low = mid + 1; } }`,
  (
    ("while (low <= high)", "Vòng lặp thu hẹp không gian tìm kiếm chừng nào khoảng còn hợp lệ."),
    ("mid = low + (high - low) / 2;", "Tính giá trị thử nghiệm chính giữa tránh tràn số nguyên."),
    ("if (check(mid))", "Kiểm tra nghiệm mid có thỏa mãn chia công việc thành <= K đoạn không."),
    ("ans = mid; high = mid - 1;", "Nếu khả thi, ghi nhận đáp án tốt hơn và tìm tiếp ở nửa bên trái."),
    ("else { low = mid + 1; }", "Nếu không khả thi, bắt buộc phải tăng tải trọng ở nửa bên phải.")
  )
)

== 12.5 Bảng Chạy Bàn Trên Giấy: Mảng $[2, 4, 7, 1, 6]$ Với $K = 3$

Khoảng tìm kiếm ban đầu: $L = max(A) = 7, R = sum A = 20$.

#trace-matrix(
  headers: ("Lần lặp", "low", "high", "mid", "check(mid)", "Hành động cập nhật"),
  rows: (
    ("1", "7", "20", "13", "True (2 đoạn <= 3)", "ans = 13, high = 13 - 1 = 12"),
    ("2", "7", "12", "9", "True (3 đoạn <= 3)", "ans = 9, high = 9 - 1 = 8"),
    ("3", "7", "8", "7", "True (3 đoạn <= 3)", "ans = 7, high = 7 - 1 = 6"),
    ("Kết thúc", "7", "6", "-", "-", "*Đáp án tối ưu = 7, Số lần check = 3*")
  )
)

== 12.6 Bài Tập Tiêu Chuẩn

#let ch12-tests = json("/code/vol2/ch12_sort_binary_search/tests.json")

#hand-trace-problem(
  name: "Bài 12.1 - Chặt Nhị Phân Phân Đoạn Công Việc (Workload Partitioning)",
  source: "Nền tảng C++14 - Chặt nhị phân kết quả",
  problem_desc: [
    Cho dãy $N$ công việc với thời gian hoàn thành $A_1, A_2, dots, A_N$ và $K$ công nhân.
    Cần phân chia dãy công việc liên tiếp này cho $K$ công nhân sao cho thời gian làm việc của công nhân làm nhiều nhất là nhỏ nhất có thể. Mỗi công nhân nhận một đoạn con liên tiếp các công việc.

    Em hãy tìm:
    1. Giá trị tải trọng tối thiểu khả thi `ans`.
    2. Số lần hàm `check(mid)` được gọi trong quá trình chặt nhị phân `check_count`.

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, K$ ($1 <= N <= 20, 1 <= K <= N$). Dòng 2 ghi $N$ số nguyên dương $A_1, A_2, dots, A_N$. \
    *Đầu ra (Output):* In ra hai số nguyên `ans check_count` cách nhau một khoảng trắng.
  ],
  sample: (
    input: "5 3\n2 4 7 1 6\n",
    output: "7 3\n"
  ),
  tests_10: ch12-tests
)
