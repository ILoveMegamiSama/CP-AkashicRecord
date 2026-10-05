#import "../../templates/components.typ": callout, syntax-anatomy, term-box
#import "../../templates/trace_table.typ": hand-trace-problem, trace-matrix

= Chương 29: Thuật Toán Băm Xâu (Polynomial Rolling Hashing)

#term-box(
  term: "Thuật Toán Băm Xâu Đa Thức (Polynomial Rolling Hash)",
  origin: "Được Michael Rabin và Richard Karp công bố năm 1987, kỹ thuật băm xâu lăn (Rolling Hash) đã đưa bài toán tìm kiếm mẫu chuỗi về các phép số học modulo kỳ diệu.",
  intuition: "Một chuỗi ký tự bản chất là một số nguyên cực lớn được viết trong hệ cơ số BASE. Bằng cách lấy đồng dư với một số nguyên tố MOD đủ lớn, ta thu gọn chuỗi có độ dài tùy ý thành một số nguyên duy nhất (mã băm). Nhờ nguyên lý tiền tố, mã băm của bất kỳ đoạn con [L, R] nào cũng được tính trong O(1) bằng đúng một phép trừ và nhân lũy thừa, mở ra khả năng so sánh chuỗi tương đương tốc độ của phép so sánh số nguyên."
)

== 29.1 Định Nghĩa Hàm Băm Đa Thức Tiền Tố

Cho chuỗi ký tự $S$ có độ dài $N$, các ký tự được chuẩn hóa thành số nguyên từ 1 đến 26 ($c - 'a' + 1$).
Chọn cơ số $"BASE" = 31$ (hoặc 311) lớn hơn kích thước bảng chữ cái và modulo nguyên tố $"MOD" = 10^9 + 7$.
Mảng băm tiền tố $H$ (1-indexed) được xây dựng theo quy tắc nhân cuộn:
$ H[0] = 0 $
$ H[i] = (H[i-1] dot "BASE" + S[i]) mod "MOD" $

Mảng lũy thừa $"power"[k] = "BASE"^k mod "MOD"$ được tiền xử lý trước.

== 29.2 Trích Xuất Mã Băm Đoạn Con $[L, R]$ Trong $O(1)$

Mã băm của đoạn con $S[L dots R]$ tương ứng với việc dịch chuyển đoạn đó về cuối và loại bỏ phần tiền tố thừa $S[1 dots L-1]$:
$ "hash"(L, R) = (H[R] - H[L-1] dot "BASE"^(R - L + 1)) mod "MOD" $
Để xử lý kết quả âm trong C++, ta luôn cộng thêm $"MOD"$ trước khi lấy dư:
$ "hash"(L, R) = ((H[R] - H[L-1] dot "power"[R - L + 1]) mod "MOD" + "MOD") mod "MOD" $

== 29.3 Ứng Dụng Thuật Toán Rabin-Karp & Kiểm Tra Palindrome

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
        #text(weight: "bold")[1. Thuật toán Rabin-Karp]
        - Tính trước mã băm của xâu mẫu $P$: $"hash_P" = "hash"(P)$.
        - Trượt một cửa sổ có độ dài $|P|$ trên chuỗi $S$.
        - Với mỗi vị trí bắt đầu $i$, so sánh mã băm $"hash"(i, i + |P| - 1)$ với $"hash_P"$ trong $O(1)$.
        - Tổng thời gian quét tìm kiếm: $O(|S| + |P|)$.
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
        #text(weight: "bold")[2. Kiểm Tra Đối Xứng (Palindrome)]
        - Xây dựng mảng băm tiền tố xuôi $H$ của xâu $S$ và mảng băm tiền tố ngược $"RH"$ của xâu đảo $"rev"_S$.
        - Đoạn con $S[L dots R]$ là đối xứng khi và chỉ khi:
        $ "hash_xuôi"(L, R) == "hash_ngược"(L, R) $
        - Thao tác kiểm tra tính đối xứng của bất kỳ đoạn con nào chỉ mất $O(1)$ thời gian.
      ]
    )
  ]
)

#syntax-anatomy(
  `long long res = (h[r] - h[l - 1] * power[r - l + 1]) % MOD; if (res < 0) res += MOD;`,
  (
    ("h[r] -", "Lấy mã băm tiền tố từ đầu đến r."),
    ("h[l - 1] * power[r - l + 1]", "Nhân dời cơ số để căn bằng bậc lũy thừa với tiền tố l-1."),
    ("% MOD;", "Phép chia lấy dư bảo toàn tính số học trong phạm vi nguyên."),
    ("if (res < 0) res += MOD;", "Bù lại phần dư âm do phép trừ trong C++.")
  )
)

== 29.4 Bảng Chạy Bàn Trên Giấy: Chuỗi $S = "abacaba"$, Mẫu $P = "aba"$

Độ dài $N = 7, M = 3$. Các ký tự: $a=1, b=2, c=3$.
Hàm băm với $"BASE"=31, "MOD"=10^9+7$:
$"hash"(P) = (1 dot 31^2 + 2 dot 31 + 1) = 961 + 62 + 1 = 1024$.

#trace-matrix(
  headers: ("Vị trí i", "Đoạn con S[i..i+2]", "Mã băm trích xuất hash(i, i+2)", "So khớp với hash(P) = 1024", "Kết luận"),
  rows: (
    ("1", "aba", "1024", "1024 == 1024 (Khớp)", "Xuất hiện lần 1 tại pos = 1"),
    ("2", "bac", "1986", "1986 != 1024", "Không khớp"),
    ("3", "aca", "1055", "1055 != 1024", "Không khớp"),
    ("4", "cab", "2947", "2947 != 1024", "Không khớp"),
    ("5", "aba", "1024", "1024 == 1024 (Khớp)", "*Xuất hiện lần 2 tại pos = 5*")
  )
)

Đoạn $[1, 7]$ là chuỗi $"abacaba"$ có mã băm xuôi trùng với mã băm ngược $arrow.r$ là Palindrome!

== 29.5 Bài Tập Tiêu Chuẩn

#let ch29-tests = json("/code/vol4/ch29_string_hashing/tests.json")

#hand-trace-problem(
  name: "Bài 29.1 - Băm Chuỗi Đa Thức: Tiền Tố Băm, Rabin-Karp & Kiểm Tra Palindrome",
  source: "Chuyên khảo CP C++14 - Cấu trúc dữ liệu nâng cao",
  problem_desc: [
    Cho chuỗi ký tự $S$ và chuỗi mẫu $P$ gồm các ký tự tiếng Anh in thường (`'a'` - `'z'`).
    Sử dụng hàm băm đa thức 1-indexed với cơ số $"BASE" = 31$ và modulo $"MOD" = 10^9 + 7$:
    - Chuẩn hóa ký tự: giá trị bằng $c - 'a' + 1$.
    - Xây dựng mảng băm tiền tố $H$ và mảng lũy thừa $"power"$.
    - Xây dựng mảng băm ngược $"RH"$ trên chuỗi đảo ngược của $S$ để hỗ trợ truy vấn đối xứng.
    Cho truy vấn kiểm tra đoạn con $S[L dots R]$ (1-indexed).

    Em hãy tính toán và in ra trên một dòng 3 giá trị cách nhau bởi dấu cách:
    1. `occ_count`: Số lần chuỗi mẫu $P$ xuất hiện trong chuỗi văn bản $S$.
    2. `first_pos`: Vị trí 1-indexed đầu tiên mà $P$ xuất hiện trong $S$ (in `-1` nếu $P$ không xuất hiện).
    3. `is_pal`: Bằng `1` nếu đoạn con $S[L dots R]$ là một chuỗi đối xứng (Palindrome), ngược lại in `0`.

    *Đầu vào (Input):*
    - Dòng 1: Ghi chuỗi văn bản $S$.
    - Dòng 2: Ghi chuỗi mẫu $P$.
    - Dòng 3: Ghi 2 số nguyên $L, R$.

    *Đầu ra (Output):* In ra 3 số `occ_count first_pos is_pal` trên một dòng.
  ],
  sample: (
    input: "abacaba\naba\n1 7\n",
    output: "2 1 1\n"
  ),
  tests_10: ch29-tests
)
