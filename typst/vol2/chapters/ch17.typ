#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 17: Tập Hợp & Ánh Xạ STL

#term-box(
  term: "Cây Đỏ-Đen (Red-Black Tree) vs Bảng Băm (Hash Table)",
  origin: "Cây Đỏ-Đen do Rudolf Bayer phát minh năm 1972 dưới tên Cây B-nhị phân đối xứng và được hoàn thiện bởi Leonidas Guibas và Robert Sedgewick năm 1978.",
  intuition: "std::set và std::map duy trì các phần tử luôn được sắp xếp theo thứ tự nghiêm ngặt nhờ cây nhị phân tự cân bằng, đảm bảo mọi thao tác tìm kiếm, chèn, xóa đều chạy trong O(log N). Ngược lại, std::unordered_set và std::unordered_map phân tán dữ liệu vào các bucket thông qua hàm băm, đạt tốc độ O(1) trung bình nhưng tiềm ẩn nguy cơ bị tấn công va chạm băm dẫn đến O(N) trong thi đấu."
)

== 17.1 So Sánh Chi Tiết Giữa Hai Họ Cấu Trúc Dữ Liệu

#table(
  columns: (2.8cm, 3.2cm, 3.2cm),
  stroke: 0.5pt + luma(160),
  fill: (col, row) => if row == 0 { luma(235) } else { white },
  table.header([*Đặc tính*], [`std::set` / `std::map`], [`std::unordered_set` / `std::unordered_map`]),
  [Cấu trúc dữ liệu], [Cây Đỏ-Đen (Red-Black Tree)], [Bảng băm (Hash Table)],
  [Độ phức tạp (TB)], [$O(log N)$], [$O(1)$],
  [Trường hợp xấu nhất], [$O(log N)$], [$O(N)$ (Khi bị va chạm băm)],
  [Thứ tự phần tử], [Luôn được sắp xếp tăng dần], [Không có thứ tự xác định],
  [Truy vấn khoảng], [Hỗ trợ `lower_bound`, `upper_bound`], [Không hỗ trợ],
  [Mức độ an toàn trong CP], [Tuyệt đối an toàn trước mọi test hiểm], [Dễ bị hack test đối kháng (anti-hash tests)]
)

== 17.2 Cạm Bẫy Sống Còn: `std::multiset::erase()`

#callout(kind: "danger", title: "Phân biệt xóa giá trị vs xóa con trỏ trong multiset")[
  Nếu tập hợp `std::multiset<int> ms` chứa 5 phần tử có cùng giá trị 10:
  - Lệnh `ms.erase(10);` sẽ *xóa sạch toàn bộ cả 5 phần tử số 10*!
  - Để chỉ xóa duy nhất *1 phần tử số 10*, bắt buộc phải tìm iterator của nó rồi xóa qua iterator:
    ```cpp
    auto it = ms.find(10);
    if (it != ms.end()) ms.erase(it);
    ```
]

== 17.3 Mổ Xẻ Cú Pháp `lower_bound` Trên `std::set`

#syntax-anatomy(
  `std::set<int> s; auto it = s.lower_bound(x); if (it != s.end()) { int val = *it; }`,
  (
    ("s.lower_bound(x);", "LƯU Ý: Gọi phương thức thành viên s.lower_bound() O(log N). ĐỪNG BAO GIỜ gọi std::lower_bound(s.begin(), s.end(), x) vì sẽ mất O(N)!"),
    ("it != s.end()", "Kiểm tra xem trong tập hợp có tồn tại phần tử nào >= x hay không."),
    ("int val = *it;", "Giải tham chiếu con trỏ iterator để lấy giá trị phần tử tìm được.")
  )
)

== 17.4 Bảng Chạy Bàn Trên Giấy: Chuỗi Truy Vấn Trên Cây Đỏ-Đen

Chuỗi thao tác: Chèn 10, Chèn 20, Chèn 10, Hỏi lower_bound(15), Hỏi lower_bound(25).

#trace-matrix(
  headers: ("Truy vấn", "Loại", "Tập hợp Set", "Bảng đếm Map", "Kết quả in ra"),
  rows: (
    ("1 10", "Chèn 10", "{10}", "{10: 1}", "-"),
    ("1 20", "Chèn 20", "{10, 20}", "{10: 1, 20: 1}", "-"),
    ("1 10", "Chèn 10", "{10, 20}", "{10: 2, 20: 1}", "-"),
    ("2 15", "lower_bound(15)", "{10, 20}", "-", "20 (phần tử nhỏ nhất >= 15)"),
    ("2 25", "lower_bound(25)", "{10, 20}", "-", "-1 (không có phần tử >= 25)"),
    ("Thống kê cuối", "-", "3 phần tử", "Max freq: 10 (2 lần)", "*Set size = 3, Max freq = 10*")
  )
)

== 17.5 Bài Tập Tiêu Chuẩn

#let ch17-tests = json("/code/vol2/ch17_set_map/tests.json")

#hand-trace-problem(
  name: "Bài 17.1 - Tập Hợp & Ánh Xạ: Thống Kê Tần Suất & Truy Vấn Ngưỡng Cận",
  source: "Nền tảng C++14 - Cấu trúc dữ liệu STL Map & Set",
  problem_desc: [
    Cho $N$ truy vấn thuộc 2 loại:
    - Loại 1: `1 X` - Chèn giá trị nguyên $X$ vào hệ thống (lưu trong `std::map<int, int>` đếm tần suất và `std::set<int>` lưu giá trị duy nhất).
    - Loại 2: `2 X` - Tìm phần tử nhỏ nhất trong tập hợp có giá trị $>= X$ (`lower_bound`). Nếu không có phần tử nào $>= X$, in ra `-1`.

    Sau khi kết thúc toàn bộ $N$ truy vấn, in thêm trên dòng cuối: số lượng phần tử khác nhau duy nhất trong tập hợp `set_size` và phần tử có tần suất xuất hiện nhiều nhất `max_freq_val` (nếu hòa lấy phần tử nhỏ hơn).

    *Đầu vào (Input):* Dòng 1 ghi $N$ ($1 <= N <= 20$). $N$ dòng tiếp theo mỗi dòng ghi một truy vấn dạng `1 X` hoặc `2 X`. \
    *Đầu ra (Output):* In kết quả từng truy vấn loại 2, và dòng cuối in `set_size max_freq_val`.
  ],
  sample: (
    input: "6\n1 10\n1 20\n1 10\n2 15\n2 25\n1 30\n",
    output: "20\n-1\n3 10\n"
  ),
  tests_10: ch17-tests
)
