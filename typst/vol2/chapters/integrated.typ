#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Bài Tập Tích Hợp Tập 2: Phân Đoạn & Ghép Cặp Tài Nguyên Tối Ưu

#term-box(
  term: "Hệ Thống Phối Hợp Giải Thuật Đa Tầng",
  origin: "Trong các kỳ thi HSG Quốc gia, Olympic Tin học và các kỳ thi Competitive Programming quốc tế (ICPC, Codeforces Div 1/2), bài toán hiếm khi đứng độc lập dưới một thuật toán đơn lẻ. Sức mạnh thực sự nằm ở năng lực kết hợp nhịp nhàng giữa Cấu trúc Dữ liệu STL, Kỹ thuật Hai Con Trỏ và Thuật toán Chặt Nhị Phân.",
  intuition: "Một bài toán hoàn chỉnh được giải quyết qua 3 tầng: Tầng 1 thu thập thống kê cấu trúc bằng Set & Map, Tầng 2 khai thác tính đơn điệu để đếm cặp bằng Hai Con Trỏ, và Tầng 3 tìm ngưỡng tối ưu toàn cục bằng Chặt nhị phân kết quả."
)

== Kiến Trúc 3 Công Đoạn Giải Thuật

1. *Công đoạn 1 (Lọc Dữ Liệu & Tần Suất Bằng STL Set & Map):*
   - `std::set<long long>` loại bỏ các giá trị trùng lặp và xác định số phần tử độc nhất `unique_count`.
   - `std::map<long long, int>` đếm số lần xuất hiện của từng phần tử để tìm `max_freq_val` (giá trị có tần suất cao nhất, ưu tiên giá trị nhỏ hơn khi hòa).

2. *Công đoạn 2 (Đếm Cặp Bằng Hai Con Trỏ Trên Mảng Sắp Xếp):*
   - Sắp xếp một bản sao mảng $B$ tăng dần.
   - Đặt hai con trỏ $L = 0$ và $R = N - 1$.
   - Nếu $B[L] + B[R] <= S$, thì $B[L]$ kết hợp với mọi phần tử $B[j]$ với $j in [L + 1, R]$ đều có tổng $<= S$. Ta cộng ngay $(R - L)$ cặp và tăng $L++$.
   - Nếu $B[L] + B[R] > S$, giảm $R--$.

3. *Công đoạn 3 (Chặt Nhị Phân Kết Quả Phân Đoạn Công Bằng):*
   - Chia mảng ban đầu $A$ (giữ nguyên thứ tự tuần tự) cho $K$ cụm máy sao cho tải trọng cực đại của một cụm là nhỏ nhất có thể.
   - Không gian tìm kiếm: $L = max(A), R = sum A$. Hàm `check(mid)` đếm số đoạn con liên tiếp có tổng $<= M$.

== Bảng Chạy Bàn Tổng Hợp Cho Test Mẫu $[3, 1, 4, 1, 5]$ Với $S = 7, K = 2$

#trace-matrix(
  headers: ("Công đoạn", "Phương pháp", "Dữ liệu xử lý", "Trạng thái", "Kết quả đầu ra"),
  rows: (
    ("Tầng 1", "STL Set & Map", "[3, 1, 4, 1, 5]", "Set={1, 3, 4, 5}; Freq={1:2, 3:1, 4:1, 5:1}", "Uniq = 4, Best = 1"),
    ("Tầng 2", "Hai Con Trỏ", "B=[1, 1, 3, 4, 5], S=7", "L=0 (+4), L=1 (+3), L=2 (+1)", "Pair count = 8"),
    ("Tầng 3", "Chặt Nhị Phân", "A=[3, 1, 4, 1, 5], K=2", "mid=8: [3, 1, 4] và [1, 5] (2 đoạn <= 2)", "Min max workload = 8"),
    ("Kết quả tổng", "Ghép nối 3 tầng", "-", "-", "*4 1 8 8*")
  )
)

== Đề Bài Chi Tiết

#let integrated-tests = json("/code/vol2/integrated/tests.json")

#hand-trace-problem(
  name: "Bài Tập Tích Hợp 2 - Phân Đoạn & Ghép Cặp Tài Nguyên Tối Ưu",
  source: "Chuyên khảo CP C++14 - Tích hợp STL & Kỹ thuật Cốt lõi",
  problem_desc: [
    Một trung tâm điện toán đám mây nhận được danh sách $N$ gói tài nguyên có kích thước $A_1, A_2, dots, A_N$.
    Hệ thống cần thực hiện 3 công đoạn tối ưu hóa:
    1. Đếm số loại kích thước duy nhất `unique_count` và tìm kích thước có tần suất lớn nhất `max_freq_val` (nếu hòa tần suất, chọn kích thước nhỏ hơn).
    2. Sau khi sắp xếp dãy kích thước theo thứ tự tăng dần, sử dụng thuật toán Hai Con Trỏ để đếm số cặp $(i, j)$ ($i < j$) sao cho tổng kích thước $A_i + A_j <= S$ (`pair_count`).
    3. Chia $N$ gói tài nguyên theo thứ tự ban đầu cho $K$ cụm máy chủ sao cho tải trọng lớn nhất của một cụm là nhỏ nhất có thể (`min_max_workload`).

    *Đầu vào (Input):* Dòng 1 ghi ba số nguyên $N, S, K$ ($1 <= N <= 15, 1 <= S <= 10^9, 1 <= K <= N$). Dòng 2 ghi $N$ số nguyên dương $A_1, A_2, dots, A_N$ ($1 <= A_i <= 10^9$). \
    *Đầu ra (Output):* In ra trên một dòng 4 số nguyên cách nhau một khoảng trắng: `unique_count max_freq_val pair_count min_max_workload`.
  ],
  sample: (
    input: "5 7 2\n3 1 4 1 5\n",
    output: "4 1 8 8\n"
  ),
  tests_10: integrated-tests
)
