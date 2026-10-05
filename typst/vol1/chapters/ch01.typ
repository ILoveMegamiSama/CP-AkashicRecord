#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 1: Máy Tính, Bộ Nhớ RAM, CPU & Bản Chất Thuật Toán

#term-box(
  term: "Thuật Toán (Algorithm)",
  origin: "Bắt nguồn từ tên nhà toán học Ba Tư thế kỷ 9 Muhammad ibn Musa al-Khwarizmi, người tiên phong trong việc chuẩn hóa các quy tắc tính toán số học.",
  intuition: "Một chuỗi hữu hạn các chỉ thị logic rõ ràng, tất định và có thể thực thi từng bước trên giấy mà không cần phỏng đoán, nhằm biến đổi dữ liệu đầu vào (Input) thành đầu ra (Output) mong muốn."
)

== 1.1 Kiến Trúc Máy Tính & Chu Trình CPU

Mọi máy tính hiện đại đều vận hành dựa trên kiến trúc Von Neumann với hai thành phần cốt lõi:
1. *Bộ xử lý trung tâm (CPU - Central Processing Unit):* Đóng vai trò là "bộ não" thực thi các chỉ thị số học và logic cơ bản (+, -, so sánh, nhảy có điều kiện). CPU chứa các ngăn chứa dữ liệu siêu tốc độ gọi là *thanh ghi (registers)*.
2. *Bộ nhớ truy xuất ngẫu nhiên (RAM - Random Access Memory):* Là một kho chứa khổng lồ các ô nhớ nhị phân lưu trữ chỉ thị chương trình và dữ liệu đang được xử lý.

CPU vận hành tuần tự theo chu kỳ ba pha liên tục:
#align(center)[
  *Fetch (Nạp chỉ thị)* $arrow.r$ *Decode (Giải mã)* $arrow.r$ *Execute (Thực thi & Ghi nhận kết quả)*
]

#callout(kind: "intuition", title: "Mô hình dải băng giấy của RAM")[
  Hãy tưởng tượng bộ nhớ RAM như một thước dây dài vô tận được chia thành các ô vuông liên tiếp. Mỗi ô vuông tương ứng với một *Byte* (gồm 8 bit nhị phân). Mỗi Byte được định danh duy nhất bằng một con số nguyên gọi là *Địa chỉ ô nhớ (Memory Address)*, bắt đầu từ chỉ số $0, 1, 2, 3, dots$. Khi CPU cần đọc hoặc ghi vào ô nhớ nào, nó chỉ cần phát tín hiệu địa chỉ đó lên bus hệ thống.
]

== 1.2 Biến Số Là Gì? Bản Chất "Nhãn Dán" Lên Ô Nhớ

Khi chúng ta viết trong mã nguồn:
```cpp
int a = 5;
```
Trình biên dịch thực chất làm hai việc:
- Xin hệ điều hành cấp phát một khoảng ô nhớ liên tiếp trong RAM (đối với kiểu `int` 32-bit là 4 bytes).
- Gắn nhãn tên `a` vào địa chỉ đầu tiên của vùng nhớ đó.

Do đó, *biến không phải là một chiếc hộp thần kỳ*. Biến đơn thuần là một cái tên thân thiện với con người giúp lập trình viên không phải nhớ những con số địa chỉ phần cứng trần trụi như `0x7ffee4`.

#syntax-anatomy(
  `int a = 5; int b = 7; int temp = a; a = b; b = temp;`,
  (
    ("int a = 5;", "Cấp phát 4 bytes cho biến a và nạp giá trị nhị phân của 5 vào vùng nhớ."),
    ("int b = 7;", "Cấp phát 4 bytes tiếp theo cho biến b và nạp giá trị 7."),
    ("int temp = a;", "Đọc giá trị từ ô nhớ a (5) và ghi vào ô nhớ tạm thời temp."),
    ("a = b;", "Đọc giá trị từ ô nhớ b (7) và ghi đè vào ô nhớ a (giá trị cũ 5 bị xóa sổ)."),
    ("b = temp;", "Đọc giá trị từ ô nhớ temp (5) và ghi đè vào ô nhớ b hoàn tất hoán đổi.")
  )
)

== 1.3 Quy Trình Chạy Bàn (Hand-trace) Trạng Thái Ô Nhớ Trên Giấy

Khi học lập trình thi đấu không cần máy tính, công cụ mạnh nhất của bạn chính là một mẩu giấy nháp và chiếc bút chì. Hãy vẽ một bảng theo dõi trạng thái các ô nhớ qua từng dòng lệnh:

#trace-matrix(
  headers: ("Bước", "Dòng lệnh", "Ô nhớ a", "Ô nhớ b", "Ô nhớ temp"),
  rows: (
    ("0", "Khởi tạo ban đầu", "3", "5", "[chưa tạo]"),
    ("1", "int temp = a;", "3", "5", "3"),
    ("2", "a = b;", "5", "5", "3"),
    ("3", "b = temp;", "5", "3", "3"),
    ("Kết quả", "Hoàn tất hoán đổi", "5", "3", "3")
  )
)

== 1.4 Bài Tập Tiêu Chuẩn

#let ch01-tests = json("/code/vol1/ch01_ram_swap/tests.json")

#hand-trace-problem(
  name: "Bài 1.1 - Hoán Đổi Ô Nhớ RAM (RAM Memory Swap)",
  source: "Nền tảng C++14 - Thao tác bộ nhớ",
  problem_desc: [
    Cho hai số nguyên $A$ và $B$ nạp vào hai biến ban đầu `a` và `b`. Em hãy thực hiện thuật toán hoán đổi giá trị của `a` và `b` thông qua biến trung gian `temp`, đồng thời tính tổng $S = A + B$.

    *Đầu vào (Input):* Hai số nguyên $A, B$ trên cùng một dòng ($-100 \le A, B \le 100$). \
    *Đầu ra (Output):* In ra 3 số nguyên $A', B', S$ cách nhau một khoảng trắng, trong đó $A', B'$ là giá trị của `a` và `b` sau khi hoán đổi.
  ],
  sample: (
    input: "3 5\n",
    output: "5 3 8\n"
  ),
  tests_10: ch01-tests
)
