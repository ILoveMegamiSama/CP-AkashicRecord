#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 18: Bản Chất Quy Hoạch Động (Dynamic Programming)

#term-box(
  term: "Quy Hoạch Động & Không Gian Trạng Thái",
  origin: "Thuật ngữ Dynamic Programming được nhà toán học Richard Bellman đặt ra vào thập niên 1950 để mô tả quá trình ra quyết định đa giai đoạn tối ưu tuần tự.",
  intuition: "Quy hoạch động bản chất là phép đệ quy có ghi nhớ và triệt tiêu tính dư thừa. Khi một bài toán lớn có thể phân rã thành các bài toán con trùng lặp (Overlapping Subproblems) và nghiệm tối ưu của bài toán lớn được kiến tạo từ nghiệm tối ưu của các bài toán con (Optimal Substructure), ta lưu nghiệm của bài toán con vào một mảng trạng thái (State Table) để không bao giờ phải tính lại lần thứ hai."
)

== 18.1 Hai Điều Kiện Cốt Lõi Của Quy Hoạch Động

Một bài toán chỉ có thể giải bằng Quy hoạch động khi thỏa mãn đồng thời hai thuộc tính toán học:
1. *Cấu trúc con tối ưu (Optimal Substructure):* Lời giải tối ưu của bài toán kích thước $N$ chứa bên trong nó lời giải tối ưu của các bài toán con kích thước $k < N$.
2. *Các bài toán con gối nhau (Overlapping Subproblems):* Cây gọi đệ quy thuần túy sẽ lặp đi lặp lại việc tính toán cùng một trạng thái nhiều lần (dẫn tới độ phức tạp hàm mũ $O(2^N)$ nếu không ghi nhớ).

== 18.2 Top-Down (Memoization) Đối Đầu Bottom-Up (Tabulation)

Có hai trường phái cài đặt thuật toán quy hoạch động:

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[1. Top-Down (Đệ Quy Nhớ - Memoization)]
        - Đi từ bài toán lớn $N$ xuống các bài toán con nhỏ hơn $0, 1$.
        - Sử dụng mảng nhớ `memo[]` khởi tạo giá trị $-1$.
        - *Ưu điểm:* Chỉ tính các trạng thái thực sự cần thiết trên cây gọi.
        - *Nhược điểm:* Tốn chi phí khung ngăn xếp hàm (Call Stack Overhead), nguy cơ tràn bộ nhớ stack (Stack Overflow) nếu $N$ lớn.
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + luma(140),
      inset: 8pt,
      radius: 3pt,
      fill: luma(252),
      [
        #text(weight: "bold")[2. Bottom-Up (Lập Bảng - Tabulation)]
        - Đi từ bài toán con cơ sở ($0, 1$) tính dần lên bài toán lớn $N$.
        - Sử dụng vòng lặp tuần tự (`for i = 1 .. N`).
        - *Ưu điểm:* Tốc độ cực nhanh, không tốn stack, dễ tối ưu hóa bộ nhớ cuộn (Space Optimization).
        - *Nhược điểm:* Phải xác định thứ tự tô-pô tính toán các trạng thái trước khi viết vòng lặp.
      ]
    )
  ]
)

#callout(kind: "tip", title: "Quy tắc vàng trong Lập trình thi đấu")[
  Trong các kỳ thi CP, luôn ưu tiên phương pháp *Bottom-Up Tabulation* vì nó loại bỏ hoàn toàn nguy cơ Stack Overflow và tận dụng tối đa cơ chế nạp bộ nhớ đệm CPU Cache Lines (L1/L2 Cache) nhờ việc truy xuất mảng liên tục trên RAM.
]

== 18.3 Thiết Kế Bảng Trạng Thái & Công Thức Chuyển Trạng Thái

Để xây dựng một thuật toán DP Bottom-Up hoàn chỉnh, ta tuân thủ 4 bước nghiêm ngặt:
1. *Định nghĩa trạng thái:* Ý nghĩa rõ ràng của $"dp"[i]$ (ví dụ: chi phí nhỏ nhất để chạm tới bậc $i$).
2. *Trạng thái cơ sở (Base Cases):* Giá trị khởi tạo không cần tính toán (ví dụ: $"dp"[1] = C_1, "dp"[2] = C_2$).
3. *Công thức chuyển trạng thái (State Transition):* Mối quan hệ truy hồi giữa $"dp"[i]$ và các trạng thái trước nó.
$ "dp"[i] = C_i + min("dp"[i-1], "dp"[i-2]) $
4. *Thứ tự tính toán & Đáp án cuối cùng:* Vòng lặp tăng dần từ 3 đến $N$, đáp án là $"dp"[N]$.

#syntax-anatomy(
  `for (int i = 3; i <= n; ++i) { dp[i] = c[i] + std::min(dp[i-1], dp[i-2]); }`,
  (
    ("for (int i = 3; i <= n; ++i)", "Thứ tự tô-pô tuần tự đảm bảo dp[i-1] và dp[i-2] đã được tính tối ưu."),
    ("std::min(dp[i-1], dp[i-2])", "Lựa chọn quyết định tối ưu giữa bước 1 bậc hoặc bước 2 bậc."),
    ("c[i] +", "Cộng thêm chi phí dẫm lên bậc hiện tại."),
    ("dp[i] =", "Lưu kết quả tối ưu vào bảng trạng thái để phục vụ các bước tương lai.")
  )
)

== 18.4 Bảng Chạy Bàn Trên Giấy: Mảng Chi Phí $C = [10, 15, 20, 10]$ Với $N = 4$

#trace-matrix(
  headers: ("Bước", "Bậc i", "Chi phí C[i]", "Lựa chọn trước đó", "dp[i] (Chi phí min)", "ways[i]"),
  rows: (
    ("Cơ sở", "1", "10", "Khởi điểm tại 1", "10", "1"),
    ("Cơ sở", "2", "15", "Khởi điểm tại 2", "15", "1"),
    ("3", "3", "20", "min(dp[1]=10, dp[2]=15) -> chọn 1", "20 + 10 = 30", "ways[1] = 1"),
    ("4", "4", "10", "min(dp[2]=15, dp[3]=30) -> chọn 2", "10 + 15 = 25", "ways[2] = 1"),
    ("Kết thúc", "4", "-", "-", "*Chi phí tối thiểu = 25*", "*Số cách = 1*")
  )
)

== 18.5 Bài Tập Tiêu Chuẩn

#let ch18-tests = json("/code/vol3/ch18_dp_foundations/tests.json")

#hand-trace-problem(
  name: "Bài 18.1 - Bản Chất Quy Hoạch Động: Bậc Thang Chi Phí Tối Thiểu & Đếm Phương Án",
  source: "Nền tảng C++14 - Quy hoạch động căn bản",
  problem_desc: [
    Có một cầu thang gồm $N$ bậc ($1 <= N <= 30$). Chi phí khi dẫm lên bậc $i$ là $C_i$ ($1 <= C_i <= 1000$).
    Quy tắc di chuyển:
    - Em có thể chọn bắt đầu dẫm lên bậc 1 (chi phí khởi điểm là $C_1$) hoặc bắt đầu dẫm lên bậc 2 (chi phí khởi điểm là $C_2$).
    - Từ bậc $i$, mỗi bước có thể nhảy lên bậc $i+1$ hoặc bậc $i+2$.
    - Đích đến là phải kết thúc chính xác tại bậc $N$.

    Em hãy tính toán:
    1. Tổng chi phí nhỏ nhất để đạt tới bậc $N$ (`min_cost`).
    2. Số lượng phương án di chuyển khác nhau đạt được đúng chi phí nhỏ nhất đó (`ways`).

    *Đầu vào (Input):* Dòng 1 ghi số nguyên $N$. Dòng 2 ghi $N$ số nguyên dương $C_1, C_2, dots, C_N$. \
    *Đầu ra (Output):* In ra hai số nguyên `min_cost ways` cách nhau bởi khoảng trắng.
  ],
  sample: (
    input: "4\n10 15 20 10\n",
    output: "25 1\n"
  ),
  tests_10: ch18-tests
)
