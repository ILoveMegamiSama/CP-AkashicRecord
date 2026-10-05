#import "../templates/components.typ": callout
#import "../templates/trace_table.typ": appendix-solution

= Phụ Lục: Đáp Án & Bảng Vết Thực Thi 10 Test Bàn Tay

#callout(kind: "theory", title: "Hướng Dẫn Đối Chiếu Lời Giải Bằng Bút Chì")[
  Phụ lục này cung cấp toàn bộ đáp án chính thức và bảng vết thực thi (Execution Trace) từng bước cho tất cả 10 bài test của từng chương trong Tập 2. Sau khi đã tự giải và điền kết quả vào các ô trống bằng bút chì, các em hãy đối chiếu với bảng đáp án dưới đây để phát hiện chính xác bước tư duy nào bị nhầm lẫn.
]

== Lời Giải Chi Tiết Chương 9: Số Học Cơ Bản Cho CP
#let ch09-tests = json("/code/vol2/ch09_number_theory/tests.json")
#appendix-solution(problem_name: "Bài 9.1 - Số Học Cơ Bản Cho CP", solutions: ch09-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 9)
#include "generated/ch09_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 10: Cấu Trúc Dữ Liệu Tuần Tự STL
#let ch10-tests = json("/code/vol2/ch10_stl_sequential/tests.json")
#appendix-solution(problem_name: "Bài 10.1 - Điểm Tọa Độ Vector & Chi Phí Khấu Hao", solutions: ch10-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 10)
#include "generated/ch10_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 11: Kỹ Thuật Hai Con Trỏ & Cửa Sổ Trượt
#let ch11-tests = json("/code/vol2/ch11_two_pointers/tests.json")
#appendix-solution(problem_name: "Bài 11.1 - Cửa Sổ Trượt: Đoạn Con Liên Tiếp Có Tổng Không Vượt Quá S", solutions: ch11-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 11)
#include "generated/ch11_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 12: Sắp Xếp & Tìm Kiếm Nhị Phân, Chặt Nhị Phân Kết Quả
#let ch12-tests = json("/code/vol2/ch12_sort_binary_search/tests.json")
#appendix-solution(problem_name: "Bài 12.1 - Chặt Nhị Phân Phân Đoạn Công Việc", solutions: ch12-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 12)
#include "generated/ch12_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 13: Đệ Quy Sơ Cấp & Cây Gọi Đệ Quy
#let ch13-tests = json("/code/vol2/ch13_recursion_tree/tests.json")
#appendix-solution(problem_name: "Bài 13.1 - Cây Gọi Đệ Quy: Phân Hoạch & Đếm Nút", solutions: ch13-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 13)
#include "generated/ch13_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 14: Thuật Toán Quay Lui & Nhánh Cận
#let ch14-tests = json("/code/vol2/ch14_backtracking/tests.json")
#appendix-solution(problem_name: "Bài 14.1 - Quay Lui Nhánh Cận: Bài Toán Xếp Hậu Trên Bàn Cờ N x N", solutions: ch14-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 14)
#include "generated/ch14_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 15: Thuật Toán Tham Lam & Phương Pháp Chứng Minh Trên Giấy
#let ch15-tests = json("/code/vol2/ch15_greedy/tests.json")
#appendix-solution(problem_name: "Bài 15.1 - Thuật Toán Tham Lam: Lựa Chọn Hoạt Động Tối Đa", solutions: ch15-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 15)
#include "generated/ch15_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 16: Ngăn Xếp & Hàng Đợi STL
#let ch16-tests = json("/code/vol2/ch16_stack_queue/tests.json")
#appendix-solution(problem_name: "Bài 16.1 - Ngăn Xếp Đơn Điệu: Phần Tử Lớn Hơn Đầu Tiên Bên Phải", solutions: ch16-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 16)
#include "generated/ch16_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 17: Tập Hợp & Ánh Xạ STL
#let ch17-tests = json("/code/vol2/ch17_set_map/tests.json")
#appendix-solution(problem_name: "Bài 17.1 - Tập Hợp & Ánh Xạ: Thống Kê Tần Suất & Truy Vấn Ngưỡng Cận", solutions: ch17-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 17)
#include "generated/ch17_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Bài Tập Tích Hợp: Phân Đoạn & Ghép Cặp Tài Nguyên Tối Ưu
#let integrated-tests = json("/code/vol2/integrated/tests.json")
#appendix-solution(problem_name: "Bài Tập Tích Hợp 2 - Phân Đoạn & Ghép Cặp Tài Nguyên Tối Ưu", solutions: integrated-tests)

=== Bảng Vết Thực Thi Từng Bước (Bài Tập Tích Hợp)
#include "generated/integrated_trace.typ"
