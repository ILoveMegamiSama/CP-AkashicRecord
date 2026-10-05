#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Bài Tập Tích Hợp Tập 1: Quản Lý Hồ Sơ Thí Sinh

#term-box(
  term: "Sắp Xếp Con Trỏ (Pointer-based Sorting)",
  origin: "Kỹ thuật tối ưu hóa quản lý bộ nhớ kinh điển trong lập trình hệ thống C/C++.",
  intuition: "Thay vì di chuyển những chiếc tủ nặng nề (sao chép toàn bộ khối dữ liệu struct lớn), ta chỉ sắp xếp lại những chiếc nhãn dán ghi số phòng (hoán đổi con trỏ địa chỉ 8-byte). Dữ liệu gốc vẫn nằm yên tại chỗ trên thanh RAM, nhưng thứ tự truy xuất đã được sắp xếp hoàn hảo."
)

== 1. Bối Cảnh Thực Tế & Kiến Trúc Tích Hợp

Một hệ thống quản lý kỳ thi Olympic cần xử lý danh sách $N$ thí sinh ($1 \le N \le 8$). Mỗi thí sinh được định nghĩa bởi một `struct Student`:
```cpp
struct Student {
    int id;    // Mã số báo danh
    int score; // Điểm số bài thi
    int age;   // Tuổi của thí sinh
};
```

Hệ thống tích hợp toàn bộ các kỹ thuật đã học trong Tập 1:
1. *Mảng Tĩnh (Chương 4):* Dữ liệu được lưu trong mảng `Student arr[16]`.
2. *Con Trỏ & Địa Chỉ (Chương 5):* Tạo mảng con trỏ `Student* ptrs[16]` và gán `ptrs[i] = &arr[i]`.
3. *So Sánh Đa Tiêu Chí (Chương 7):* 
   - Ưu tiên 1: Thí sinh có điểm số (`score`) cao hơn xếp trước.
   - Ưu tiên 2: Nếu bằng điểm, thí sinh ít tuổi hơn (`age` nhỏ hơn) xếp trước.
   - Ưu tiên 3: Nếu bằng cả điểm lẫn tuổi, thí sinh có mã số `id` nhỏ hơn xếp trước.
4. *Thuật Toán Chọn Trực Tiếp & Phân Tích Độ Phức Tạp (Chương 8):*
   - Sắp xếp mảng con trỏ bằng thuật toán Selection Sort.
   - Tổng số phép so sánh thực hiện giữa các con trỏ luôn bằng:
     $ C(N) = frac{N(N - 1)}{2} in O(N^2) $

#syntax-anatomy(
  `Student* temp = ptrs[i]; ptrs[i] = ptrs[best]; ptrs[best] = temp;`,
  (
    ("Student* temp = ptrs[i];", "Lưu trữ con trỏ thứ `i` (chỉ chiếm 8 bytes trên RAM) vào con trỏ tạm."),
    ("ptrs[i] = ptrs[best];", "Trỏ con trỏ vị trí `i` sang đối tượng tối ưu nhất."),
    ("ptrs[best] = temp;", "Hoàn tất hoán đổi 2 con trỏ mà KHÔNG CẦN copy bất kỳ byte dữ liệu nào của `Student`!")
  )
)

== 2. Bảng Theo Dõi Chạy Bàn Trên Giấy

Với $N = 3$ thí sinh:
- Thí sinh 1 ($S_1$): `id = 1, score = 70, age = 16`
- Thí sinh 2 ($S_2$): `id = 2, score = 95, age = 15`
- Thí sinh 3 ($S_3$): `id = 3, score = 85, age = 17`

#trace-matrix(
  headers: ("Vòng lặp i", "Phép so sánh thực hiện", "Con trỏ tốt nhất (best)", "Mảng con trỏ sau bước i"),
  rows: (
    ("i = 0", "(ptrs[1], ptrs[0]): 95 > 70 => best=1\n(ptrs[2], ptrs[1]): 85 < 95", "best = 1 (id=2)", "[id=2, id=1, id=3]"),
    ("i = 1", "(ptrs[2], ptrs[1]): 85 > 70 => best=2", "best = 2 (id=3)", "[id=2, id=3, id=1]"),
    ("Tổng kết", "Tổng số phép so sánh: 2 + 1 = 3", "Top: id=2 (95đ)", "[2, 3, 1]")
  )
)

== 3. Bài Tập Tích Hợp Tiêu Chuẩn

#let integrated-tests = json("/code/vol1/integrated/tests.json")

#hand-trace-problem(
  name: "Bài Tập Tích Hợp 1 - Quản Lý Hồ Sơ Thí Sinh (Student Records)",
  source: "Chuyên khảo CP C++14 - Tích hợp Toàn diện Tập 1",
  problem_desc: [
    Cho danh sách $N$ thí sinh ($1 \le N \le 8$). Mỗi thí sinh gồm 3 thông tin `id score age`.

    Em hãy thực hiện:
    1. Đọc dữ liệu vào mảng `Student arr[N]` và khởi tạo mảng con trỏ `Student* ptrs[N]`.
    2. Sắp xếp mảng con trỏ theo tiêu chí: Điểm cao xếp trước; cùng điểm thì ít tuổi hơn xếp trước; cùng tuổi thì `id` nhỏ hơn xếp trước. Đếm tổng số phép so sánh cặp thí sinh đã thực hiện trong thuật toán Selection Sort.
    3. In ra danh sách `id` sau khi sắp xếp trên dòng 1. Dòng 2 in: `top_id top_score total_comparisons`.

    *Đầu vào (Input):* Dòng 1 chứa $N$. $N$ dòng tiếp theo, mỗi dòng chứa 3 số nguyên `id score age`. \
    *Đầu ra (Output):* Dòng 1 gồm $N$ mã số `id`. Dòng 2 gồm 3 số nguyên `top_id top_score total_comparisons`.
  ],
  sample: (
    input: "3\n1 70 16\n2 95 15\n3 85 17\n",
    output: "2 3 1\n2 95 3\n"
  ),
  tests_10: integrated-tests
)
