#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 14: Thuật Toán Quay Lui & Nhánh Cận

#term-box(
  term: "Quay Lui & Nhánh Cận (Backtracking & Branch-and-Bound)",
  origin: "D. H. Lehmer đưa ra thuật ngữ Backtracking vào những năm 1950, và A. H. Land cùng A. G. Doig (1960) đề xuất phương pháp Branch-and-Bound trong tối ưu hóa tổ hợp rời rạc.",
  intuition: "Hãy tưởng tượng bạn đang thám hiểm một mê cung nhiều ngã rẽ. Bạn đi theo một con đường; nếu gặp ngõ cụt hoặc biển báo 'đường cụt chắc chắn' (tỉa nhánh), bạn quay lui lại ngã ba gần nhất và thử lối đi tiếp theo. Thuật toán quay lui duyệt toàn bộ cây không gian trạng thái theo chiều sâu nhưng biết dừng lại kịp thời để không lãng phí thời gian vào những nhánh vô vọng."
)

== 14.1 Bản Chất Của Bộ Ba Thao Tác Quay Lui

Khung sườn của mọi bài toán quay lui luôn tuân thủ chu trình 4 pha:
1. *Kiểm tra hoàn tất:* Nếu đã chọn đủ $N$ thành phần nghiệm, ghi nhận lời giải.
2. *Thử các khả năng:* Duyệt qua mọi ứng viên hợp lệ cho bước hiện tại.
3. *Đánh dấu & Gọi đệ quy:* Ghi nhận ứng viên đã dùng (nạp trạng thái), rồi gọi đệ quy bước $i + 1$.
4. *Hoàn tác (Backtrack):* Khi lời gọi con kết thúc, *hủy bỏ đánh dấu* (trả trạng thái về như cũ) để các nhánh sau sử dụng lại.

== 14.2 Kỹ Thuật Tỉa Nhánh $O(1)$ Trong Bài Toán Xếp Hậu (N-Queens)

Xét bàn cờ $N times N$. Đặt lần lượt từng quân hậu vào các hàng $0, 1, dots, N - 1$.
Để đảm bảo hai quân hậu không ăn nhau trong $O(1)$:
- *Cùng cột:* Mảng đánh dấu `used_col[c]`.
- *Cùng đường chéo chính (hướng $arrow.br$):* Các ô có cùng giá trị $(r - c)$. Để tránh chỉ số âm, ta đánh số $(r - c + N)$: mảng `diag2[r - c + n]`.
- *Cùng đường chéo phụ (hướng $arrow.bl$):* Các ô có cùng tổng $(r + c)$: mảng `diag1[r + c]`.

#syntax-anatomy(
  `for (int c = 0; c < n; ++c) { int d1 = r + c, d2 = r - c + n; if (!used[c] && !diag1[d1] && !diag2[d2]) { used[c] = diag1[d1] = diag2[d2] = true; backtrack(r + 1); used[c] = diag1[d1] = diag2[d2] = false; } }`,
  (
    ("int d1 = r + c, d2 = r - c + n;", "Tính chỉ số đường chéo chính và đường chéo phụ độc nhất."),
    ("if (!used[c] && !diag1[d1] && !diag2[d2])", "Tỉa nhánh cận O(1): chỉ duyệt nếu ô không bị chiếu tướng."),
    ("used[c] = diag1[d1] = diag2[d2] = true;", "Nạp trạng thái: phong tỏa cột và 2 đường chéo."),
    ("backtrack(r + 1);", "Đệ quy đặt quân hậu cho hàng tiếp theo r + 1."),
    ("used[c] = diag1[d1] = diag2[d2] = false;", "HOÀN TÁC: dỡ bỏ phong tỏa cho các nhánh thử nghiệm kế tiếp.")
  )
)

== 14.3 Bảng Chạy Bàn Trên Giấy: Tìm Nghiệm Đầu Tiên Cho Bàn Cờ $4 times 4$

#trace-matrix(
  headers: ("Hàng r", "Cột c thử", "Kiểm tra chiếu tướng", "Hành động", "Trạng thái cột đã đặt"),
  rows: (
    ("Hàng 0", "c=0 (ô 0,0)", "Hợp lệ", "Đặt hậu tại c=0, xuống hàng 1", "[0, -, -, -]"),
    ("Hàng 1", "c=0, 1", "Bị chiếu", "Bỏ qua", "-"),
    ("Hàng 1", "c=2 (ô 1,2)", "Hợp lệ", "Đặt hậu tại c=2, xuống hàng 2", "[0, 2, -, -]"),
    ("Hàng 2", "c=0, 1, 2, 3", "Mọi ô đều bị chiếu!", "Ngõ cụt! Quay lui hàng 1", "-"),
    ("Hàng 0", "c=1 (ô 0,1)", "Hợp lệ", "Đặt hậu tại c=1, xuống hàng 1", "[1, -, -, -]"),
    ("Hàng 1", "c=3 (ô 1,3)", "Hợp lệ", "Đặt hậu tại c=3, xuống hàng 2", "[1, 3, -, -]"),
    ("Hàng 2", "c=0 (ô 2,0)", "Hợp lệ", "Đặt hậu tại c=0, xuống hàng 3", "[1, 3, 0, -]"),
    ("Hàng 3", "c=2 (ô 3,2)", "Hợp lệ", "Đặt hậu tại c=2 -> *Hoàn tất!*", "*Nghiệm: 2 4 1 3*")
  )
)

== 14.4 Bài Tập Tiêu Chuẩn

#let ch14-tests = json("/code/vol2/ch14_backtracking/tests.json")

#hand-trace-problem(
  name: "Bài 14.1 - Quay Lui Nhánh Cận: Bài Toán Xếp Hậu Trên Bàn Cờ N x N",
  source: "Nền tảng C++14 - Thuật toán quay lui",
  problem_desc: [
    Cho số nguyên $N$ ($1 <= N <= 8$). Hãy tìm số cách đặt $N$ quân hậu trên bàn cờ vua $N times N$ sao cho không có hai quân hậu nào ăn nhau.
    Đồng thời, in ra cấu hình nghiệm đầu tiên tìm được (theo thứ tự duyệt cột tăng dần từ hàng $1$ đến hàng $N$, chỉ số cột từ 1 đến $N$).
    Nếu không có cách xếp nào thỏa mãn (như trường hợp $N = 2, 3$), in ra `0 NONE`.

    *Đầu vào (Input):* Một số nguyên duy nhất $N$ trên một dòng. \
    *Đầu ra (Output):* In ra số lượng nghiệm `solution_count` kèm theo cấu hình nghiệm đầu tiên trên cùng một dòng.
  ],
  sample: (
    input: "4\n",
    output: "2 2 4 1 3\n"
  ),
  tests_10: ch14-tests
)
