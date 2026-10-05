#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 10: Cấu Trúc Dữ Liệu Tuần Tự STL

#term-box(
  term: "Chi Phí Khấu Hao (Amortized Time) & Vector Bộ Nhớ Động",
  origin: "Được Robert Tarjan giới thiệu năm 1985 trong phân tích cấu trúc dữ liệu, kỹ thuật phân tích khấu hao đánh giá tổng chi phí của một chuỗi thao tác thay vì chỉ nhìn vào một thao tác đơn lẻ trong trường hợp xấu nhất.",
  intuition: "Hãy tưởng tượng bạn mua một cuốn sổ ghi chép. Bạn viết từng dòng rất nhanh tốn 1 giây ($O(1)$). Khi hết trang, bạn phải đi mua cuốn sổ to gấp đôi và chép lại toàn bộ ($O(N)$). Dù thỉnh thoảng có một lần đi mua sổ tốn kém, nhưng trung bình mỗi dòng bạn viết vẫn chỉ tốn vài giây. Đó chính là bản chất Amortized $O(1)$ của std::vector."
)

== 10.1 Bản Chất Phần Cứng Của `std::vector`

`std::vector` là một mảng động tự co giãn được lưu trữ trong vùng nhớ Heap liên tục. Về mặt phần cứng và bộ nhớ, một đối tượng `vector` thường chỉ chiếm 24 bytes trên kiến trúc 64-bit, bao gồm đúng 3 con trỏ:
- `_M_start`: Trỏ tới phần tử đầu tiên của mảng.
- `_M_finish`: Trỏ tới vị trí liền kề sau phần tử cuối cùng hiện hữu. (Do đó, `size() = _M_finish - _M_start`).
- `_M_end_of_storage`: Trỏ tới giới hạn ô nhớ đã cấp phát của khối nhớ. (Do đó, `capacity() = _M_end_of_storage - _M_start`).

#callout(kind: "intuition", title: "Phân biệt rạch ròi giữa size() và capacity()")[
  - *Size (Kích thước thực tế):* Số lượng phần tử hiện đang được chương trình lưu giữ và sử dụng.
  - *Capacity (Dung lượng đệm):* Tổng số ô nhớ liên tiếp đã được hệ điều hành cấp phát sẵn. Chỉ khi `size() == capacity()`, việc chèn thêm một phần tử mới kích hoạt việc cấp phát lại (reallocation).
]

== 10.2 Chiến Lược Nhân Đôi Dung Lượng & Chứng Minh Amortized $O(1)$

Khi ta gọi `push_back()` vào một vector đã đầy (`size == capacity`):
1. Vector xin hệ điều hành cấp phát một vùng nhớ mới có dung lượng gấp đôi ($2 times "capacity"$).
2. Sao chép toàn bộ $N$ phần tử cũ từ vùng nhớ cũ sang vùng nhớ mới.
3. Giải phóng vùng nhớ cũ.
4. Thêm phần tử mới vào cuối.

*Chứng minh bằng Phương pháp Thế năng (Potential Method):*
Đặt thế năng $Phi = 2 times "size" - "capacity"$.
- Khi vector vừa được nhân đôi dung lượng ($"capacity" = 2N, "size" = N$): $Phi = 2N - 2N = 0$.
- Trong mỗi thao tác `push_back` bình thường không cấp phát lại: chi phí thực tế là $1$, `size` tăng 1, do đó $Phi$ tăng thêm 2. Chi phí khấu hao $c_i' = c_i + Delta Phi = 1 + 2 = 3 = O(1)$.
- Khi vector đầy ($"size" = 2N, "capacity" = 2N$): $Phi = 4N - 2N = 2N$.
- Thao tác thứ $2N+1$ gây ra cấp phát lại: chi phí thực tế là $2N + 1$ (sao chép $2N$ phần tử và chèn 1 phần tử mới). Dung lượng mới là $4N$, kích thước mới là $2N+1$. Thế năng mới $Phi' = 2(2N+1) - 4N = 2$.
  Độ biến thiên thế năng $Delta Phi = 2 - 2N$.
  Chi phí khấu hao: $c' = (2N + 1) + (2 - 2N) = 3 = O(1)$.

Như vậy, chi phí khấu hao cho mọi thao tác `push_back` luôn được chặn trên bởi hằng số $O(1)$.

== 10.3 Cặp Giá Trị `std::pair` & Bộ Ba `std::tuple`

Để lưu trữ các bộ dữ liệu đi liền nhau trong CP mà không cần khai báo `struct` dài dòng, ta sử dụng:
- `std::pair<T1, T2>`: Lưu cặp hai phần tử truy xuất qua `.first` và `.second`.
- `std::tuple<T1, T2, T3>`: Lưu bộ nhiều phần tử truy xuất qua `std::get<index>(t)`.

#syntax-anatomy(
  `std::pair<int, int> p = {3, 5}; auto t = std::make_tuple(1, 2, 3); int x, y, z; std::tie(x, y, z) = t;`,
  (
    ("std::pair<int, int> p = {3, 5};", "Khởi tạo cặp giá trị với first=3, second=5."),
    ("auto t = std::make_tuple(1, 2, 3);", "Tạo tuple gồm 3 giá trị nguyên."),
    ("std::tie(x, y, z) = t;", "Giải nén (unpack) tuple vào các biến x, y, z bằng std::tie.")
  )
)

== 10.4 Bảng Chạy Bàn Trên Giấy: Theo Dõi Bộ Đệm Vector

#trace-matrix(
  headers: ("Bước", "Thao tác", "Dữ liệu", "Size", "Capacity"),
  rows: (
    ("0", "Khởi tạo vector rỗng", "[]", "0", "0"),
    ("1", "push_back({1, 2})", "[{1,2}]", "1", "1 (cấp phát ban đầu)"),
    ("2", "push_back({3, 4})", "[{1,2}, {3,4}]", "2", "2 (nhân đôi)"),
    ("3", "pop_back()", "[{1,2}]", "1", "2 (capacity giữ nguyên)"),
    ("4", "push_back({2, 1})", "[{1,2}, {2,1}]", "2", "2 (dùng lại slot trống)")
  )
)

== 10.5 Bài Tập Tiêu Chuẩn

#let ch10-tests = json("/code/vol2/ch10_stl_sequential/tests.json")

#hand-trace-problem(
  name: "Bài 10.1 - Điểm Tọa Độ Vector & Chi Phí Khấu Hao",
  source: "Nền tảng C++14 - Cấu trúc dữ liệu STL",
  problem_desc: [
    Một hệ thống quản lý danh sách các điểm 2D lưu trong `std::vector<std::pair<int, int>>`. Ban đầu vector rỗng.
    Cho số nguyên $N$ ($1 <= N <= 20$). Dòng tiếp theo gồm $N$ điểm $(x_i, y_i)$.
    Với mỗi điểm:
    - Nếu tổng tọa độ $x_i + y_i >= 0$, thực hiện nạp điểm vào cuối vector (`push_back`).
    - Nếu tổng tọa độ $x_i + y_i < 0$, thực hiện loại bỏ điểm gần nhất vừa thêm vào (`pop_back`) nếu vector không rỗng.
    Sau khi xử lý hết $N$ điểm, in ra trên một dòng: số phần tử còn lại trong vector `size`, hoành độ nhỏ nhất `min_x` và tung độ lớn nhất `max_y` trong các điểm còn lại. (Nếu vector rỗng in `0 0 0`).

    *Đầu vào (Input):* Dòng 1 ghi $N$. $N$ dòng tiếp theo mỗi dòng ghi hai số nguyên $x_i, y_i$. \
    *Đầu ra (Output):* In ra 3 số nguyên `size min_x max_y` trên một dòng.
  ],
  sample: (
    input: "4\n1 2\n3 4\n-5 -2\n2 1\n",
    output: "2 1 2\n"
  ),
  tests_10: ch10-tests
)
