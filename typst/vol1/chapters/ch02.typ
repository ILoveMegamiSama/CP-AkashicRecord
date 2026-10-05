#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 2: Cấu Trúc Chương Trình C++14 & Biểu Diễn Dữ Liệu

#term-box(
  term: "Bù Hai (Two's Complement)",
  origin: "Được nhà toán học John von Neumann đề xuất năm 1945 trong tài liệu EDVAC để đơn giản hóa phần cứng số học trong máy tính điện tử.",
  intuition: "Một quy ước biểu diễn số nguyên có dấu bằng hệ nhị phân, trong đó bit có trọng số lớn nhất (MSB) đóng vai trò là bit dấu mang trọng số âm $-2^{k-1}$. Quy ước này cho phép mạch cộng xử lý phép trừ $A - B$ hệt như phép cộng $A + (-B)$."
)

== 2.1 Cấu Trúc Chương Trình C++14 Chuẩn Mực

Một chương trình C++14 bắt đầu với hàm `main()` - điểm khởi đầu thực thi của hệ điều hành:

```cpp
#include <iostream>

int main() {
    // Thân chương trình đặt trong cặp ngoặc nhọn
    std::cout << "Akashic Record C++14\n";
    return 0; // Trả về mã lỗi 0 báo hiệu chương trình kết thúc thành công
}
```

== 2.2 Các Kiểu Dữ Liệu Nguyên Thủy & Kích Thước Ô Nhớ

#table(
  columns: (2cm, 1.8cm, 3.2cm, 3fr),
  stroke: 0.4pt + luma(180),
  fill: (col, row) => if row == 0 { luma(235) } else if calc.even(row) { luma(250) } else { white },
  align: (center + horizon, center + horizon, left + horizon, left + horizon),
  inset: 6pt,
  table.header([*Kiểu dữ liệu*], [*Kích thước*], [*Dải giá trị*], [*Ứng dụng trong Lập trình thi đấu*]),
  [`bool`], [1 Byte], [$0$ (`false`) hoặc $1$ (`true`)], [Lưu cờ trạng thái, kiểm tra điều kiện],
  [`char`], [1 Byte], [$-128 dots 127$ (ASCII $0 dots 127$)], [Lưu ký tự chữ số, ký tự văn bản],
  [`int`], [4 Bytes], [$-2^{31} dots 2^{31}-1 approx plus.minus 2 times 10^9$], [Chỉ số mảng, đếm, tính toán số học thông thường],
  [`long long`], [8 Bytes], [$-2^{63} dots 2^{63}-1 approx plus.minus 9 times 10^{18}$], [Tổng tích lớn, số lượng cấu hình tổ hợp],
  [`double`], [8 Bytes], [Độ chính xác $approx 15-17$ chữ số thập phân], [Số thực, hình học giải tích, xác suất]
)

== 2.3 Cơ Chế Bù Hai & Vòng Tròn Tràn Số Nguyên (Integer Overflow)

Để lấy số đối của một số nhị phân trong hệ bù hai, ta đảo tất cả các bit ($0 arrow.r 1, 1 arrow.r 0$) rồi cộng thêm $1$:
$ -x = (tilde x) + 1 $

#callout(kind: "warning", title: "Cạm bẫy tràn số nguyên nguy hiểm nhất")[
  Trong kiểu số nguyên 32-bit có dấu `int`, giá trị lớn nhất có thể lưu được là:
  $ 2^{31} - 1 = 2\,147\,483\,647 $
  Nếu bạn thực hiện phép tính $2\,147\,483\,647 + 1$, phần cứng CPU sẽ cộng bit và bật bit dấu MSB lên $1$, biến kết quả thành con số âm cực đại:
  $ 2\,147\,483\,647 + 1 = -2\,147\,483\,648 $
  Hiện tượng này gọi là *Tràn số nguyên (Integer Overflow)*. Trong thi đấu, một phép nhân giữa hai số $A, B approx 10^5$ sẽ tạo ra tích $10^{10} > 2 times 10^9$, dẫn đến kết quả sai hoàn toàn (Wrong Answer) nếu không ép kiểu!
]

#syntax-anatomy(
  `long long prod = static_cast<long long>(a) * b;`,
  (
    ("static_cast<long long>(a)", "Ép kiểu tường minh biến 32-bit `a` lên kiểu 64-bit `long long` TRƯỚC KHI thực hiện phép nhân."),
    ("* b", "Do một toán hạng là `long long`, toán hạng `b` tự động được thăng cấp lên `long long`, phép nhân thực hiện an toàn trong thanh ghi 64-bit."),
    ("long long prod =", "Ghi kết quả chính xác không bao giờ tràn vào biến 64-bit `prod`.")
  )
)

== 2.4 Mô Phỏng Vòng Tròn Tràn Số 4-Bit Trên Giấy

Hệ 4-bit bù hai biểu diễn các số từ $-8$ đến $+7$:
#trace-matrix(
  headers: ("Mã nhị phân 4-bit", "Giá trị có dấu (Bù 2)", "Giá trị không dấu", "Ghi chú"),
  rows: (
    ("0110", "+6", "6", "Số dương"),
    ("0111", "+7", "7", "Giá trị dương cực đại của 4-bit"),
    ("1000", "-8", "8", "Tràn số: +7 + 1 lộn vòng sang -8"),
    ("1001", "-7", "9", "-8 + 1 = -7"),
    ("1111", "-1", "15", "Tất cả các bit đều là 1")
  )
)

== 2.5 Bài Tập Tiêu Chuẩn

#let ch02-tests = json("/code/vol1/ch02_overflow/tests.json")

#hand-trace-problem(
  name: "Bài 2.1 - Tích An Toàn & Ngưỡng Giới Hạn (Safe Product)",
  source: "Nền tảng C++14 - Biểu diễn dữ liệu & Tràn số",
  problem_desc: [
    Cho hai số nguyên $A, B$ và một ngưỡng kiểm soát $M$. Em hãy tính tích $P = A times B$ bằng phép toán ép kiểu an toàn `static_cast<long long>(a) * b`.

    Nếu độ lớn tuyệt đối của tích vượt quá ngưỡng $M$ ($|P| > M$), hãy in ra nhãn `OVERFLOW` kèm theo giá trị $P$. Ngược lại nếu $|P| \le M$, in ra nhãn `SAFE` kèm theo giá trị $P$.

    *Đầu vào (Input):* Ba số nguyên $A, B, M$ trên cùng một dòng. \
    *Đầu ra (Output):* Chuỗi kết quả gồm nhãn (`SAFE` hoặc `OVERFLOW`) và giá trị tích $P$ cách nhau dấu cách.
  ],
  sample: (
    input: "3 4 50\n",
    output: "SAFE 12\n"
  ),
  tests_10: ch02-tests
)
