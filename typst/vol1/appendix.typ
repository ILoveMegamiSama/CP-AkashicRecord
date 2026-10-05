#import "../templates/components.typ": callout
#import "../templates/trace_table.typ": appendix-solution

= Phụ Lục: Đáp Án & Bảng Vết Thực Thi 10 Test Bàn Tay

#callout(kind: "theory", title: "Hướng Dẫn Đối Chiếu Lời Giải Bằng Bút Chì")[
  Phụ lục này cung cấp toàn bộ đáp án chính thức và bảng vết thực thi (Execution Trace) từng bước cho tất cả 10 bài test của từng chương. Sau khi đã tự giải và điền kết quả vào các ô trống bằng bút chì, các em hãy đối chiếu với bảng đáp án dưới đây để phát hiện chính xác bước tư duy nào bị nhầm lẫn.
]

== Lời Giải Chi Tiết Chương 1: Hoán Đổi Ô Nhớ RAM
#let ch01-tests = json("/code/vol1/ch01_ram_swap/tests.json")
#appendix-solution(problem_name: "Bài 1.1 - Hoán Đổi Ô Nhớ RAM", solutions: ch01-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 1)
#include "generated/ch01_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 2: Tích An Toàn & Ngưỡng Giới Hạn
#let ch02-tests = json("/code/vol1/ch02_overflow/tests.json")
#appendix-solution(problem_name: "Bài 2.1 - Tích An Toàn & Ngưỡng Giới Hạn", solutions: ch02-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 2)
#include "generated/ch02_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 3: Bảng Biến Thiên Dãy Collatz
#let ch03-tests = json("/code/vol1/ch03_loop_trace/tests.json")
#appendix-solution(problem_name: "Bài 3.1 - Bảng Biến Thiên Dãy Collatz", solutions: ch03-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 3)
#include "generated/ch03_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 4: Thống Kê Mảng & Chuỗi Đối Xứng
#let ch04-tests = json("/code/vol1/ch04_array_string/tests.json")
#appendix-solution(problem_name: "Bài 4.1 - Thống Kê Mảng & Chuỗi Đối Xứng", solutions: ch04-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 4)
#include "generated/ch04_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 5: Tìm Cực Trị Bằng Con Trỏ & Khoảng Cách Ô Nhớ
#let ch05-tests = json("/code/vol1/ch05_pointer/tests.json")
#appendix-solution(problem_name: "Bài 5.1 - Con Trỏ & Khoảng Cách Ô Nhớ", solutions: ch05-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 5)
#include "generated/ch05_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 6: Khung Ngăn Xếp Đệ Quy & Ước Số Chung Lớn Nhất
#let ch06-tests = json("/code/vol1/ch06_call_stack/tests.json")
#appendix-solution(problem_name: "Bài 6.1 - Call Stack & Đệ Quy Euclid", solutions: ch06-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 6)
#include "generated/ch06_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 7: Sắp Xếp Tọa Độ Điểm Bằng Struct
#let ch07-tests = json("/code/vol1/ch07_struct_cmp/tests.json")
#appendix-solution(problem_name: "Bài 7.1 - Sắp Xếp Tọa Độ Điểm", solutions: ch07-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 7)
#include "generated/ch07_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 8: Đếm Thao Tác Vòng Lặp & Đánh Giá Giới Hạn
#let ch08-tests = json("/code/vol1/ch08_complexity/tests.json")
#appendix-solution(problem_name: "Bài 8.1 - Đếm Thao Tác Vòng Lặp", solutions: ch08-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 8)
#include "generated/ch08_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Bài Tập Tích Hợp: Quản Lý Hồ Sơ Thí Sinh
#let integrated-tests = json("/code/vol1/integrated/tests.json")
#appendix-solution(problem_name: "Bài Tập Tích Hợp 1 - Quản Lý Hồ Sơ Thí Sinh", solutions: integrated-tests)

=== Bảng Vết Thực Thi Từng Bước (Bài Tập Tích Hợp)
#include "generated/integrated_trace.typ"
