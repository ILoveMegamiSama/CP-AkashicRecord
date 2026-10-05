#import "../templates/components.typ": callout
#import "../templates/trace_table.typ": appendix-solution

= Phụ Lục: Đáp Án & Bảng Vết Thực Thi 10 Test Bàn Tay

#callout(kind: "theory", title: "Hướng Dẫn Đối Chiếu Lời Giải Bằng Bút Chì")[
  Phụ lục này cung cấp toàn bộ đáp án chính thức và bảng vết thực thi (Execution Trace) từng bước cho tất cả 10 bài test của từng chương trong Tập 3. Sau khi đã tự giải và điền kết quả vào các ô trống bằng bút chì, các em hãy đối chiếu với bảng đáp án dưới đây để phát hiện chính xác bước tư duy nào bị nhầm lẫn.
]

== Lời Giải Chi Tiết Chương 18: Bản Chất Quy Hoạch Động
#let ch18-tests = json("/code/vol3/ch18_dp_foundations/tests.json")
#appendix-solution(problem_name: "Bài 18.1 - Bản Chất Quy Hoạch Động: Bậc Thang Chi Phí Tối Thiểu & Đếm Phương Án", solutions: ch18-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 18)
#include "generated/ch18_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 19: Các Bài Toán DP Kinh Điển
#let ch19-tests = json("/code/vol3/ch19_classic_dp/tests.json")
#appendix-solution(problem_name: "Bài 19.1 - Các Bài Toán DP Kinh Điển: Balo 0/1 & Tối Ưu Hóa Giá Trị", solutions: ch19-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 19)
#include "generated/ch19_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 20: Lý Thuyết Đồ Thị & Cách Biểu Diễn
#let ch20-tests = json("/code/vol3/ch20_graph_representation/tests.json")
#appendix-solution(problem_name: "Bài 20.1 - Biểu Diễn Đồ Thị & Phân Tích Bậc Đỉnh", solutions: ch20-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 20)
#include "generated/ch20_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 21: Duyệt Đồ Thị Cơ Bản BFS & DFS
#let ch21-tests = json("/code/vol3/ch21_bfs_dfs/tests.json")
#appendix-solution(problem_name: "Bài 21.1 - Duyệt Đồ Thị Cơ Bản: Thành Phần Liên Thông & Đồ Thị Hai Phía", solutions: ch21-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 21)
#include "generated/ch21_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 22: Đồ Thị Không Chu Trình (DAG) & Sắp Xếp Tô-pô
#let ch22-tests = json("/code/vol3/ch22_dag_toposort/tests.json")
#appendix-solution(problem_name: "Bài 22.1 - Đồ Thị Không Chu Trình (DAG): Sắp Xếp Tô-pô & Đường Đi Dài Nhất", solutions: ch22-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 22)
#include "generated/ch22_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 23: Cây (Trees) & Các Thuộc Tính Đặc Biệt
#let ch23-tests = json("/code/vol3/ch23_trees/tests.json")
#appendix-solution(problem_name: "Bài 23.1 - Cây & Thuộc Tính Cốt Lõi: Chiều Cao, Đường Kính & Cây Con", solutions: ch23-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 23)
#include "generated/ch23_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Chương 24: Đường Đi Ngắn Nhất Với Thuật Toán Dijkstra
#let ch24-tests = json("/code/vol3/ch24_dijkstra/tests.json")
#appendix-solution(problem_name: "Bài 24.1 - Thuật Toán Dijkstra Chuẩn Mực & Phục Hồi Đường Đi", solutions: ch24-tests)

=== Bảng Vết Thực Thi Từng Bước (Chương 24)
#include "generated/ch24_trace.typ"

#pagebreak()

== Lời Giải Chi Tiết Bài Tập Tích Hợp: Đồ Thị, Dijkstra & Quy Hoạch Động Trên DAG
#let integrated-tests = json("/code/vol3/integrated/tests.json")
#appendix-solution(problem_name: "Bài Tập Tích Hợp 3 - Lộ Trình Tối Ưu: Dijkstra & Quy Hoạch Động Trên Shortest Path DAG", solutions: integrated-tests)

=== Bảng Vết Thực Thi Từng Bước (Bài Tập Tích Hợp)
#include "generated/integrated_trace.typ"
