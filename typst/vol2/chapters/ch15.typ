#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 15: Thuật Toán Tham Lam & Phương Pháp Chứng Minh Trên Giấy

#term-box(
  term: "Thuật Toán Tham Lam & Luận Điểm Đổi Chỗ (Exchange Argument)",
  origin: "Xuất hiện trong các nghiên cứu kinh điển về cấu trúc Matroid của Hassler Whitney (1935) và bài toán tìm cây khung nhỏ nhất của Kruskal (1956) và Prim (1957).",
  intuition: "Một thuật toán tham lam luôn đưa ra lựa chọn có vẻ tốt nhất ở thời điểm hiện tại (cực trị cục bộ) với hy vọng dẫn tới nghiệm tối ưu toàn cục. Tuy nhiên, sự khác biệt giữa một thuật toán tham lam thiên tài và một thuật toán sai lầm nằm ở chứng minh toán học: ta phải chứng minh được rằng việc chọn phần tử tham lam không bao giờ ngăn cản ta đạt được kết quả tối ưu."
)

== 15.1 Khi Nào Tham Lam Đúng & Khi Nào Tham Lam Thất Bại?

Một bài toán có thể giải bằng thuật toán Tham lam nếu thỏa mãn hai tính chất:
1. *Tính chất lựa chọn tham lam (Greedy-choice Property):* Nghiệm tối ưu toàn cục có thể được xây dựng bằng cách đưa ra các lựa chọn tối ưu cục bộ tuần tự mà không cần quay lui hay xét lại quá khứ.
2. *Cấu trúc con tối ưu (Optimal Substructure):* Sau khi thực hiện lựa chọn tham lam, bài toán còn lại vẫn là bài toán con cùng dạng và nghiệm tối ưu của bài toán con kết hợp với lựa chọn tham lam tạo thành nghiệm tối ưu bài toán ban đầu.

#callout(kind: "danger", title: "Cảnh báo: Tham lam mù quáng")[
  Bài toán Đổi tiền xu: Nếu hệ mệnh giá là $\{1, 5, 10, 20, 50\}$, thuật toán tham lam luôn đúng. Nhưng nếu hệ mệnh giá là $\{1, 3, 4\}$ và cần đổi số tiền là 6:
  - Tham lam: chọn 4, còn 2 -> chọn hai đồng 1 -> Tổng cộng 3 đồng xu ($4 + 1 + 1$).
  - Tối ưu thực tế: chọn hai đồng 3 -> Chỉ mất 2 đồng xu ($3 + 3$).
  Do đó, khi không có chứng minh toán học, tham lam rất dễ trở thành sai lầm chết người trong phòng thi!
]

== 15.2 Phương Pháp Chứng Minh Bằng Luận Điểm Đổi Chỗ (Exchange Argument)

Để chứng minh chiến lược tham lam $S = (s_1, s_2, dots, s_k)$ là tối ưu trên giấy:
1. Giả sử tồn tại một nghiệm tối ưu $"OPT" = (o_1, o_2, dots, o_m)$ khác với $S$.
2. Tìm phần tử đầu tiên mà $"OPT"$ khác với $S$ (giả sử tại bước $i$, $s_i != o_i$).
3. Thay thế $o_i$ bằng $s_i$ trong $"OPT"$ để tạo ra một nghiệm mới $"OPT"'$.
4. Chứng minh rằng $"OPT"'$ vẫn là một nghiệm hợp lệ và chất lượng của $"OPT"'$ không hề kém hơn $"OPT"$ ($|"OPT"'| >= |"OPT"|$).
5. Lặp lại lập luận bằng quy nạp toán học cho đến khi biến đổi hoàn toàn $"OPT"$ thành $S$. Suy ra $S$ cũng là một nghiệm tối ưu!

== 15.3 Bài Toán Lựa Chọn Hoạt Động (Interval Scheduling)

Cho $N$ cuộc họp với thời gian bắt đầu $S_i$ và kết thúc $E_i$. Ta cần chọn nhiều cuộc họp nhất không giao nhau.
*Chiến lược tối ưu:* Luôn chọn cuộc họp có *thời điểm kết thúc sớm nhất* ($E_i$ nhỏ nhất) tương thích với các cuộc họp trước đó.

#syntax-anatomy(
  `std::sort(a.begin(), a.end(), [](const auto& u, const auto& v) { return u.e < v.e; }); for (const auto& item : a) { if (item.s >= last_end) { count++; last_end = item.e; } }`,
  (
    ("return u.e < v.e;", "Sắp xếp danh sách cuộc họp tăng dần theo thời điểm kết thúc."),
    ("for (const auto& item : a)", "Duyệt tuần tự theo thứ tự tham lam."),
    ("if (item.s >= last_end)", "Kiểm tra cuộc họp có xung đột thời gian với cuộc họp trước không."),
    ("last_end = item.e;", "Cập nhật thời điểm kết thúc phòng họp bận rộn.")
  )
)

== 15.4 Bảng Chạy Bàn Trên Giấy: 4 Cuộc Họp $[(1, 3), (2, 5), (3, 9), (6, 8)]$

Sắp xếp theo thời gian kết thúc:
1. (1, 3) kết thúc lúc 3
2. (2, 5) kết thúc lúc 5
3. (6, 8) kết thúc lúc 8
4. (3, 9) kết thúc lúc 9

#trace-matrix(
  headers: ("Cuộc họp", "Khung giờ [S, E]", "last_end hiện tại", "Xung đột?", "Quyết định"),
  rows: (
    ("1", "[1, 3]", "-1", "Không (1 >= -1)", "CHỌN (last_end = 3, dur += 2)"),
    ("2", "[2, 5]", "3", "Có (2 < 3)", "LOẠI (trùng giờ)"),
    ("3", "[6, 8]", "3", "Không (6 >= 3)", "CHỌN (last_end = 8, dur += 2)"),
    ("4", "[3, 9]", "8", "Có (3 < 8)", "LOẠI (trùng giờ)"),
    ("Kết quả", "-", "-", "-", "*Chọn 2 cuộc họp, Tổng thời gian = 4*")
  )
)

== 15.5 Bài Tập Tiêu Chuẩn

#let ch15-tests = json("/code/vol2/ch15_greedy/tests.json")

#hand-trace-problem(
  name: "Bài 15.1 - Thuật Toán Tham Lam: Lựa Chọn Hoạt Động Tối Đa (Activity Selection)",
  source: "Nền tảng C++14 - Thuật toán tham lam",
  problem_desc: [
    Cho $N$ cuộc họp, cuộc họp thứ $i$ bắt đầu tại thời điểm $S_i$ và kết thúc tại thời điểm $E_i$ ($S_i < E_i$).
    Phòng hội thảo chỉ có thể tổ chức một cuộc họp tại một thời điểm (hai cuộc họp có thể nối tiếp nhau nếu $E_i <= S_j$).

    Sử dụng chiến lược Tham lam sắp xếp theo thời gian kết thúc tăng dần, hãy tìm:
    1. Số lượng cuộc họp tối đa `max_meetings` có thể sắp xếp được.
    2. Tổng thời gian hoạt động `total_duration` của các cuộc họp được chọn.

    *Đầu vào (Input):* Dòng 1 ghi số nguyên $N$ ($1 <= N <= 15$). $N$ dòng tiếp theo mỗi dòng ghi hai số nguyên $S_i, E_i$. \
    *Đầu ra (Output):* In ra hai số nguyên `max_meetings total_duration` cách nhau một khoảng trắng.
  ],
  sample: (
    input: "4\n1 3\n2 5\n3 9\n6 8\n",
    output: "2 4\n"
  ),
  tests_10: ch15-tests
)
