#import "../templates/components.typ": callout
#import "../templates/trace_table.typ": appendix-solution

= Phụ Lục: Đáp Án & Bảng Vết Thực Thi 10 Test Bàn Tay

#callout(kind: "theory", title: "Hướng Dẫn Đối Chiếu Lời Giải Bằng Bút Chì")[
  Phụ lục này cung cấp toàn bộ đáp án chính thức và bảng vết thực thi (Execution Trace) từng bước cho tất cả 10 bài test của từng chương trong Tập 4. Sau khi đã tự giải và điền kết quả vào các ô trống bằng bút chì, các em hãy đối chiếu với bảng đáp án dưới đây để phát hiện chính xác bước tư duy nào bị nhầm lẫn.
]

== Lời Giải Chi Tiết Chương 25: Kỹ Thuật Trải Phẳng Cây (Euler Tour on Tree)
#let ch25-tests = json("/code/vol4/ch25_euler_tour/tests.json")
#appendix-solution(problem_name: "Bài 25.1 - Kỹ Thuật Trải Phẳng Cây: Thứ Tự Duyệt Euler Tour & Tổng Cây Con", solutions: ch25-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 25)
#include "generated/ch25_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 26: Kỹ Thuật Nhảy Nhị Phân (Binary Lifting)
#let ch26-tests = json("/code/vol4/ch26_binary_lifting/tests.json")
#appendix-solution(problem_name: "Bài 26.1 - Kỹ Thuật Nhảy Nhị Phân: Nhảy Trên Đồ Thị Hàm", solutions: ch26-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 26)
#include "generated/ch26_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 27: Tổ Tiên Chung Gần Nhất (LCA on Tree)
#let ch27-tests = json("/code/vol4/ch27_lca/tests.json")
#appendix-solution(problem_name: "Bài 27.1 - Tổ Tiên Chung Gần Nhất: LCA Trên Cây Qua Nhảy Nhị Phân", solutions: ch27-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 27)
#include "generated/ch27_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 28: Cây Chỉ Số Nhị Phân (Fenwick Tree / BIT)
#let ch28-tests = json("/code/vol4/ch28_fenwick_tree/tests.json")
#appendix-solution(problem_name: "Bài 28.1 - Cây Chỉ Số Nhị Phân: Cập Nhật Điểm, Truy Vấn Đoạn & Đếm Nghịch Thế", solutions: ch28-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 28)
#include "generated/ch28_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 29: Thuật Toán Băm Xâu (Polynomial Rolling Hashing)
#let ch29-tests = json("/code/vol4/ch29_string_hashing/tests.json")
#appendix-solution(problem_name: "Bài 29.1 - Băm Chuỗi Đa Thức: Tiền Tố Băm, Rabin-Karp & Kiểm Tra Palindrome", solutions: ch29-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 29)
#include "generated/ch29_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 30: Thao Tác Bit & Quy Hoạch Động Trạng Thái Mặt Nạ (Bitmask DP)
#let ch30-tests = json("/code/vol4/ch30_bitmask_dp/tests.json")
#appendix-solution(problem_name: "Bài 30.1 - Thao Tác Bit & Quy Hoạch Động Trạng Thái Mặt Nạ: Bài Toán TSP", solutions: ch30-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 30)
#include "generated/ch30_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Bài Tập Tích Hợp Toàn Diện V1
#let integrated-tests = json("/code/vol4/integrated/tests.json")
#appendix-solution(problem_name: "Bài Tập Tích Hợp 4 - Hệ Thống Cây Vương Quốc: Cập Nhật Cây Con Euler Tour + Fenwick Tree & Khoảng Cách LCA", solutions: integrated-tests)

=== Bảng Vết Thực Thi Từng Bước (Bài Tập Tích Hợp)
#include "generated/integrated_trace.typ"
