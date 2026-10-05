#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 7: Struct & Mổ Xẻ Cú Pháp operator<

#term-box(
  term: "Cấu Trúc Tự Định Nghĩa (Struct)",
  origin: "Xuất phát từ từ 'Structure' trong tiếng Anh, được đưa vào ngôn ngữ C từ năm 1972 để biểu diễn các bản ghi dữ liệu phức hợp gồm nhiều trường thông tin.",
  intuition: "Một 'chiếc túi' gom nhóm nhiều món đồ có kiểu khác nhau (như số nguyên, chuỗi ký tự, số thực) lại thành một thực thể duy nhất có ý nghĩa trọn vẹn trong bài toán (ví dụ: một Cạnh đồ thị, một Tọa độ điểm, một Hồ sơ thí sinh)."
)

== 7.1 Đóng Gói Dữ Liệu Với `struct`

Trong lập trình thi đấu, thay vì quản lý nhiều mảng song song rời rạc (`x[i]`, `y[i]`, `id[i]`), ta gom chúng vào một `struct`:

```cpp
struct Point {
    int id;
    int x;
    int y;
};
```
Khi khai báo `Point p;`, bộ nhớ RAM sẽ cấp phát liên tiếp 3 biến `id`, `x`, `y` kề nhau ($3 times 4 = 12$ bytes).

== 7.2 Mổ Xẻ Tận Gốc Cú Pháp `bool operator<(const Edge& other) const`

Khi chúng ta muốn dùng hàm sắp xếp chuẩn `std::sort` trên một mảng các `struct`, trình biên dịch cần biết làm thế nào để so sánh giữa hai đối tượng. Ta nạp chồng toán tử `<`:

#syntax-anatomy(
  `bool operator<(const Edge& other) const { return weight < other.weight; }`,
  (
    ("bool", "Kiểu giá trị trả về: `true` nếu đối tượng hiện tại đứng trước đối tượng `other`, `false` nếu ngược lại."),
    ("operator<", "Tên hàm đặc biệt trong C++ tái định nghĩa hành vi so sánh nhỏ hơn."),
    ("const Edge&", "1. `Edge&`: Nhận địa chỉ tham chiếu tránh sao chép toàn bộ struct gây lãng phí thời gian và RAM.\n2. `const` đầu: Khóa đối tượng `other` ở chế độ chỉ đọc (Read-only), ngăn ngừa mọi hành vi vô tình sửa đổi dữ liệu của `other`."),
    ("const đuôi", "Khóa đối tượng gọi hàm (`*this`) ở chế độ chỉ đọc. ĐÂY LÀ ĐIỀU KIỆN BẮT BUỘC trong C++: các thuật toán STL như `std::sort`, `std::priority_queue`, `std::set` đều truyền phần tử dưới dạng hằng số (`const`). Nếu thiếu `const` ở đuôi, trình biên dịch sẽ từ chối biên dịch ngay lập tức!")
  )
)

== 7.3 Quy Trình So Sánh Đa Tiêu Chí Trên Giấy

Khi sắp xếp tọa độ điểm theo 3 tiêu chí:
1. Tiêu chí 1: Điểm có khoảng cách Manhattan $D = |x| + |y|$ nhỏ hơn đứng trước.
2. Tiêu chí 2: Nếu $D$ bằng nhau, điểm có hoành độ $x$ nhỏ hơn đứng trước.
3. Tiêu chí 3: Nếu cả $D$ và $x$ bằng nhau, điểm có mã số `id` nhỏ hơn đứng trước.

Bảng so sánh tay hai điểm $P_1(id=1, x=2, y=3)$ và $P_2(id=2, x=1, y=1)$:
#trace-matrix(
  headers: ("Đối tượng", "Manhattan D = |x|+|y|", "Hoành độ x", "Mã id", "Kết quả so sánh"),
  rows: (
    ("P1", "2 + 3 = 5", "2", "1", "D1 = 5"),
    ("P2", "1 + 1 = 2", "1", "2", "D2 = 2"),
    ("Kết luận", "-", "-", "-", "D2 < D1 => P2 đứng trước P1")
  )
)

== 7.4 Bài Tập Tiêu Chuẩn

#let ch07-tests = json("/code/vol1/ch07_struct_cmp/tests.json")

#hand-trace-problem(
  name: "Bài 7.1 - Sắp Xếp Tọa Độ Điểm (Point Struct Sort)",
  source: "Nền tảng C++14 - Struct & Nạp chồng operator<",
  problem_desc: [
    Cho $N$ điểm trên mặt phẳng tọa độ ($1 \le N \le 8$). Mỗi điểm gồm mã số `id`, hoành độ `x` và tung độ `y`.

    Em hãy cài đặt `struct Point` với phương thức so sánh `bool operator<(const Point& other) const` theo thứ tự ưu tiên:
    - Khoảng cách Manhattan $D = |x| + |y|$ nhỏ hơn đứng trước.
    - Nếu khoảng cách bằng nhau, hoành độ `x` nhỏ hơn đứng trước.
    - Nếu hoành độ vẫn bằng nhau, `id` nhỏ hơn đứng trước.

    *Đầu vào (Input):* Dòng 1 chứa số nguyên $N$. $N$ dòng tiếp theo, mỗi dòng chứa 3 số nguyên `id x y`. \
    *Đầu ra (Output):* Dãy mã số `id` của các điểm sau khi sắp xếp trên một dòng cách nhau dấu cách.
  ],
  sample: (
    input: "2\n1 2 3\n2 1 1\n",
    output: "2 1\n"
  ),
  tests_10: ch07-tests
)
