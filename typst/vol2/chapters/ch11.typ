#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 11: Kỹ Thuật Hai Con Trỏ & Cửa Sổ Trượt

#term-box(
  term: "Hai Con Trỏ & Tính Đơn Điệu (Monotonicity)",
  origin: "Xuất hiện như một phương pháp tư duy tối ưu cơ bản trong các thuật toán sắp xếp và tìm kiếm từ thập niên 1970, kỹ thuật Hai Con Trỏ khai thác triệt để tính chất đơn điệu của dãy số hoặc hàm mục tiêu.",
  intuition: "Thay vì duyệt hai vòng lặp lồng nhau $O(N^2)$ thử mọi cặp đoạn con, ta duy trì hai chỉ số $L$ và $R$. Khi biên phải $R$ dịch chuyển về phía trước làm tăng chi phí, biên trái $L$ cũng chỉ dịch chuyển một chiều theo sau để thiết lập lại điều kiện hợp lệ. Nhờ đó mỗi phần tử chỉ được thăm tối đa hai lần, biến thuật toán từ $O(N^2)$ thành $O(N)$."
)

== 11.1 Hai Mô Hình Hai Con Trỏ Cốt Lõi

1. *Hai Con Trỏ Chạy Ngược Chiều (Opposite Direction / Converging Pointers):*
   Áp dụng trên mảng đã được sắp xếp tăng dần. Một con trỏ xuất phát từ đầu mảng ($L = 0$), một con trỏ xuất phát từ cuối mảng ($R = N - 1$).
   - Nếu tổng $A[L] + A[R] < S$: muốn tăng tổng, bắt buộc phải tăng $L$ ($L++$).
   - Nếu tổng $A[L] + A[R] > S$: muốn giảm tổng, bắt buộc phải giảm $R$ ($R--$).
   - Nếu $A[L] + A[R] == S$: ghi nhận nghiệm.

2. *Cửa Sổ Trượt Cùng Chiều (Sliding Window / Same Direction):*
   Áp dụng khi tìm đoạn con liên tiếp $[L, R]$ thỏa mãn một ràng buộc đơn điệu (chẳng hạn tổng các phần tử dương $<= S$, hoặc không quá $K$ phần tử phân biệt).
   Biên phải $R$ mở rộng cửa sổ từng bước. Khi tổng vượt ngưỡng, biên trái $L$ co hẹp lại.

#callout(kind: "theory", title: "Bất biến vòng lặp (Loop Invariant) của Cửa Sổ Trượt")[
  Tại cuối mỗi bước lặp của $R$:
  - Đoạn $[L, R]$ luôn là đoạn con dài nhất kết thúc tại vị trí $R$ có tổng không vượt quá $S$.
  - Mọi đoạn con bắt đầu từ $i in [L, R]$ và kết thúc tại $R$ đều có tổng $<= S$. Do đó, số lượng đoạn con hợp lệ kết thúc tại $R$ chính xác bằng $(R - L + 1)$.
]

== 11.2 Mổ Xẻ Cú Pháp Cửa Sổ Trượt C++14

#syntax-anatomy(
  `for (int R = 0; R < n; ++R) { sum += a[R]; while (sum > s && L <= R) { sum -= a[L++]; } total += (R - L + 1); }`,
  (
    ("for (int R = 0; R < n; ++R)", "Duyệt biên phải R tuần tự từ đầu đến cuối mảng."),
    ("sum += a[R];", "Hấp thụ phần tử mới vào cửa sổ hiện tại."),
    ("while (sum > s && L <= R)", "Kiểm tra điều kiện vi phạm ngưỡng tổng S."),
    ("sum -= a[L++];", "Thu hẹp biên trái L và cập nhật lại biến tổng tích lũy."),
    ("total += (R - L + 1);", "Cộng số lượng đoạn con hợp lệ kết thúc tại R vào tổng số nghiệm.")
  )
)

== 11.3 Bảng Chạy Bàn Trên Giấy: Mảng $[2, 1, 3, 4, 1]$ Với Ngưỡng $S = 7$

#trace-matrix(
  headers: ("Bước R", "Phần tử thêm", "Thao tác L", "Cửa sổ [L, R]", "Tổng sum", "Đoạn con kết thúc tại R"),
  rows: (
    ("R=0", "a[0]=2", "L=0 giữ nguyên", "[0, 0] = [2]", "2 <= 7", "1: [2]"),
    ("R=1", "a[1]=1", "L=0 giữ nguyên", "[0, 1] = [2, 1]", "3 <= 7", "2: [1], [2, 1]"),
    ("R=2", "a[2]=3", "L=0 giữ nguyên", "[0, 2] = [2, 1, 3]", "6 <= 7", "3: [3], [1, 3], [2, 1, 3]"),
    ("R=3", "a[3]=4", "L tăng: 0 -> 1 -> 2", "[2, 3] = [3, 4]", "7 <= 7", "2: [4], [3, 4]"),
    ("R=4", "a[4]=1", "L tăng: 2 -> 3", "[3, 4] = [4, 1]", "5 <= 7", "2: [1], [4, 1]"),
    ("Tổng kết", "-", "-", "Max len = 3", "-", "*Tổng = 1 + 2 + 3 + 2 + 2 = 10*")
  )
)

== 11.4 Bài Tập Tiêu Chuẩn

#let ch11-tests = json("/code/vol2/ch11_two_pointers/tests.json")

#hand-trace-problem(
  name: "Bài 11.1 - Cửa Sổ Trượt: Đoạn Con Liên Tiếp Có Tổng Không Vượt Quá S",
  source: "Nền tảng C++14 - Kỹ thuật Hai Con Trỏ",
  problem_desc: [
    Cho dãy $N$ số nguyên dương $A_1, A_2, dots, A_N$ và một số nguyên dương $S$.
    Sử dụng kỹ thuật Cửa Sổ Trượt (Hai Con Trỏ $L, R$ cùng chiều), hãy tìm:
    1. Độ dài lớn nhất của một đoạn con liên tiếp có tổng các phần tử $<= S$.
    2. Tổng số lượng đoạn con liên tiếp có tổng $<= S$.

    Nếu không có đoạn con nào thỏa mãn (mọi phần tử $> S$), in ra `0 0`.

    *Đầu vào (Input):* Dòng 1 ghi hai số nguyên $N, S$ ($1 <= N <= 20, 1 <= S <= 10^9$). Dòng 2 ghi $N$ số nguyên $A_1, A_2, dots, A_N$ ($A_i >= 1$). \
    *Đầu ra (Output):* In ra hai số nguyên `max_len total_count` trên một dòng.
  ],
  sample: (
    input: "5 7\n2 1 3 4 1\n",
    output: "3 10\n"
  ),
  tests_10: ch11-tests
)
