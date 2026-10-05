# Hệ Thống Tài Liệu Lập Trình Thi Đấu C++14: Sách In Vật Lý & Web Portal

> **Tài liệu Thiết kế Đặc tả (Design Specification)**  
> **Ngày lập:** 05/10/2026  
> **Trạng thái:** Bản thiết kế đã phê duyệt (Approved Design)

---

## 1. Mục Tiêu & Tầm Nhìn Dự Án

Dự án nhằm xây dựng một thư viện tài liệu toàn diện, chuẩn mực và tự lực về **Lập trình thi đấu (Competitive Programming - CP)** sử dụng ngôn ngữ **C++ (tương thích các phiên bản C++ $\ge$ 14)**, đáp ứng các tiêu chí then chốt:

1. **Khả năng in ấn vật lý hoàn hảo (Physical Print-First):**
   - Định dạng in: **Khổ A4 tiêu chuẩn** ($210 \times 297\text{ mm}$), có lề trang rộng rãi cho học sinh viết nháp và đóng gáy sách.
   - Thiết kế đồ họa: **Thuần Đen - Trắng (Monochrome / High-Contrast Grayscale)**. Không sử dụng màu sắc để biểu thị dữ liệu; sử dụng nét vẽ (đậm, nhạt, nét đứt, gạch chéo) để phân biệt các thành phần trên cây/đồ thị/bảng ô nhớ.
   - Không giới hạn số trang, ưu tiên tính mạch lạc, khoa học, phân cấp rõ ràng và dễ tra cứu.

2. **Tách biệt hoàn toàn khỏi máy tính (100% Unplugged Traceability):**
   - Mọi khái niệm C++, câu lệnh, cơ chế bộ nhớ, cấu trúc dữ liệu và giải thuật đều có phương pháp **chạy bàn (dry-run / hand-trace)** trên giấy.
   - Học sinh không cần máy tính vẫn có thể tự kiểm chứng, tự mô phỏng thuật toán và tự chấm bài tập của mình.

3. **Mổ xẻ cú pháp C++14 tận gốc & giải thích thuật ngữ khoa học:**
   - Mọi cấu trúc câu lệnh phức tạp (ví dụ: `bool operator<(const Edge& other) const`, hàm generic lambda, tham chiếu `&`) đều được giải thích tường tận: tại sao lại viết như vậy, tại sao chỗ này có `const`, chỗ kia không có `const`.
   - Mọi thuật ngữ khoa học (như *Amortized time*, *Loop invariant*, *Optimal substructure*, *Euler Tour*, *Collision*, *Bipartite*) đều có mục giải thích từ nguyên ngữ và hình tượng trực quan trước khi đi vào định nghĩa toán học.

4. **Trình tự kiến thức tuyến tính nghiêm ngặt (Strict DAG Curriculum):**
   - Không bao giờ xảy ra tình trạng kiến thức dùng ở bài này lại chưa được dạy ở các bài trước.
   - Sắp xếp logic đảm bảo: Hiểu phần cứng máy tính/RAM $\to$ C++ cơ bản $\to$ Con trỏ & Địa chỉ ô nhớ $\to$ Hàm & Tham chiếu / Call Stack $\to$ STL $\to$ Thuật toán cơ bản $\to$ Nâng cao.

5. **Bộ bài tập chuẩn hóa với 10 Test Bàn Tay (10 Hand-trace Tests):**
   - Mỗi chủ đề có bài tập kèm đề bài, ràng buộc, ví dụ mẫu và **chính xác 10 bộ test nhỏ**.
   - Dưới mỗi bài tập trong sách có bảng ô trống để học sinh tự điền kết quả sau khi tính nhẩm.
   - Toàn bộ Đáp án và Bảng chạy tay chi tiết (Trace Table) từng bước cho 10 test được đặt ở **Phụ lục Lời giải (Appendix)** ở cuối mỗi tập sách.
   - Xen kẽ các bài tập đơn lẻ là các **Bài tập Tích hợp liên chương (Integrated Problems)** đòi hỏi kết hợp nhiều kiến thức đã học.

6. **Phiên bản Web hiện đại (Astro Starlight):**
   - Đồng bộ nội dung với sách in, hỗ trợ giao diện đọc sách tối ưu, công thức toán $\KaTeX$.
   - Tích hợp **Interactive Test Checker** (cho phép học sinh nhập kết quả nhẩm bằng tay để kiểm tra đúng/sai và xem bảng trace lời giải).
   - Nút tải bản in PDF khổ A4 cho từng tập sách.

7. **Bộ công cụ Kiểm chứng Tự động (Python Verifier Pipeline):**
   - Đảm bảo 100% test case và bảng trace trong sách in và trên web đều được đối soát qua mã nguồn C++14 thực tế, loại trừ hoàn toàn sai sót tính nhẩm của con người.

---

## 2. Kiến Trúc Hệ Thống & Cấu Trúc Mã Nguồn

Dự án được tổ chức theo cấu trúc đa mô-đun (Monorepo) trong thư mục gốc:

```
AkashicRecord/
├── docs/
│   └── superpowers/
│       ├── specs/
│       │   └── 2026-10-05-cp-cpp14-offline-library-design.md
│       └── plans/
├── typst/                         # Nguồn biên soạn sách in vật lý A4
│   ├── templates/                 # Giao diện & Macro dùng chung
│   │   ├── book-theme.typ         # Cấu hình khổ A4, lề, header/footer, font Serif/Mono
│   │   ├── components.typ         # Macro: Callout, Syntax Anatomy, Terminology Box
│   │   └── trace-table.typ        # Macro sinh bảng chạy bàn, ô trống điền kết quả
│   ├── vol1/                      # Tập 1: C++14 & Tư duy Thuật toán Cơ bản
│   │   ├── main.typ
│   │   ├── chapters/
│   │   └── appendix.typ
│   ├── vol2/                      # Tập 2: Cấu trúc Dữ liệu STL & Kỹ thuật Cốt lõi
│   │   ├── main.typ
│   │   ├── chapters/
│   │   └── appendix.typ
│   ├── vol3/                      # Tập 3: Quy hoạch Động Nền tảng & Đồ thị Cơ bản
│   │   ├── main.typ
│   │   ├── chapters/
│   │   └── appendix.typ
│   └── vol4/                      # Tập 4: Cấu trúc Dữ liệu & Thuật toán Nâng cao V1
│       ├── main.typ
│       ├── chapters/
│       └── appendix.typ
├── web/                           # Web Portal tài liệu (Astro Starlight)
│   ├── package.json
│   ├── astro.config.mjs
│   ├── src/
│   │   ├── content/
│   │   │   └── docs/              # Nội dung Markdown/MDX đồng bộ với Typst
│   │   │       ├── vol1/
│   │   │       ├── vol2/
│   │   │       ├── vol3/
│   │   │       └── vol4/
│   │   └── components/
│   │       ├── InteractiveChecker.astro   # Ô điền kết quả & kiểm tra 10 test
│   │       └── TraceView.astro            # Xem bảng trace từng bước
│   └── public/
│       └── pdf/                   # Chứa các file PDF A4 xuất từ Typst để tải về
├── code/                          # Mã nguồn C++14 tham chiếu cho từng bài toán
│   ├── vol1/
│   ├── vol2/
│   ├── vol3/
│   └── vol4/
└── tools/                         # Pipeline tự động hóa
    └── verifier/
        ├── run_verifier.py        # Biên dịch g++ -std=c++14, chạy sinh 10 test
        ├── trace_logger.hpp       # Thư viện header C++ hỗ trợ xuất trace ra JSON
        └── export_typst.py        # Chuyển đổi JSON trace sang bảng Typst / Web MDX
```

---

## 3. Quy Chuẩn Sư Phạm Cho Một Bài Học "Không Máy Tính"

Mỗi chương học trong cả 4 Tập đều áp dụng cấu trúc 5 phần chuẩn mực:

### Phần 1: Khung "Thuật Ngữ & Trực Giác" (Terminology & Intuition)
- Giải nghĩa gốc rễ từ ngữ khoa học.
- Đặt vấn đề bằng tình huống thực tế hoặc trò chơi trên giấy.
- Vẽ mô hình tư duy (Mental Model): Ô nhớ RAM, dòng chảy thông tin, biểu đồ khối đen-trắng.

### Phần 2: Khung "Mổ Xẻ Cú Pháp C++14" (Syntax & Mechanics Anatomy)
- Trích đoạn cú pháp chuẩn.
- Bóc tách từng từ khóa và biểu tượng.
  - *Ví dụ mẫu:* Đối với nạp chồng toán tử so sánh:
    ```cpp
    bool operator<(const Edge& other) const {
        return weight < other.weight;
    }
    ```
    - `bool`: Kiểu giá trị trả về (`true` nếu đối tượng hiện tại nhỏ hơn `other`, `false` nếu ngược lại).
    - `operator<`: Tên hàm đặc biệt trong C++ định nghĩa hành vi của dấu `<`.
    - `const Edge& other`: 
      - `Edge&`: Nhận địa chỉ tham chiếu của đối tượng truyền vào để tránh sao chép toàn bộ struct gây chậm bộ nhớ.
      - `const` (trước): Khóa đối tượng `other`, cam kết hàm này chỉ đọc dữ liệu của `other`, không bao giờ được sửa đổi thuộc tính của nó.
    - `const` (cuối hàm): Khóa đối tượng gọi hàm (`*this`), cam kết rằng việc so sánh sẽ không làm biến đổi bất kỳ giá trị nào của đối tượng đang đứng trước dấu `<`.

### Phần 3: Kỹ Thuật Chạy Bàn Trên Giấy (Hand-trace Walkthrough)
- Đưa ra một đoạn mã C++14 hoàn chỉnh và một bộ dữ liệu đầu vào cụ thể.
- Hướng dẫn kẻ **Bảng Chạy Bàn (Trace Table)**:
  - Cột 1: Thứ tự bước / Dòng lệnh thực thi.
  - Cột 2: Giá trị các biến hiện tại.
  - Cột 3: Trạng thái bộ nhớ / Ngăn xếp (Stack Frame) / Mảng.
  - Cột 4: Điều kiện kiểm tra (`true`/`false`) và Giải thích tư duy.

### Phần 4: Bộ Bài Tập Tiêu Chuẩn & 10 Test Bàn Tay
- **Thông tin bài toán:** Tên bài, nguồn bài tham khảo (Codeforces, VNOJ, AtCoder...), phát biểu đề bài mạch lạc, ràng buộc thời gian/bộ nhớ, định dạng Input/Output.
- **Test ví dụ:** Kèm hình vẽ và giải thích luồng tính toán.
- **Bảng 10 Test Bàn Tay:** Gồm 10 bộ test nhỏ được chia thành 4 nhóm (Cơ bản, Biên, Bẫy tư duy, Thử thách tính nhẩm).
- Bên cạnh mỗi test là khung điền kết quả:
  $$\text{Test } k: \quad \text{Input: } [\dots] \quad \implies \quad \text{Đáp án của bạn: } [ \quad\quad\quad\quad ]$$

### Phần 5: Phụ Lục Lời Giải (Cuối Sách)
- Đáp án chính thức cho cả 10 bộ test.
- Bảng Trace Table mẫu chi tiết từng bước cho các test then chốt và các test bẫy, giúp học sinh tìm ra chính xác lỗi sai trong suy luận của mình.

---

## 4. Cây Phả Hệ Kiến Thức Tuyến Tính (Strict DAG Curriculum Chi Tiết)

### TẬP 1: C++14 & Tư Duy Thuật Toán Cơ Bản (Cơ Chế Không Máy Tính)
* **Chương 1: Máy tính, Bộ nhớ RAM, CPU & Bản chất Thuật toán:**
  - Khái niệm về thuật toán và chương trình máy tính.
  - Cấu tạo logic: CPU thực thi chỉ thị tuần tự, bộ nhớ RAM như một dải ô nhớ có địa chỉ đánh số từ $0$.
  - Khái niệm biến như một "nhãn dán" lên một hoặc nhiều ô nhớ liên tiếp.
* **Chương 2: Cấu trúc Chương trình C++14 & Biểu diễn Dữ liệu:**
  - Cấu trúc chương trình C++, hàm `main`, dấu chấm phẩy, khối lệnh `{ }`.
  - Kiểu dữ liệu nguyên thủy: `int` (32-bit), `long long` (64-bit), `double`, `char`, `bool`.
  - Biểu diễn nhị phân bù 2 (Two's complement), dải giá trị và hiện tượng tràn số nguyên (Integer Overflow) trên giấy.
* **Chương 3: Biến, Biểu thức, Ép kiểu & Luồng Điều khiển:**
  - Toán tử số học, phép chia nguyên `/`, phép chia dư `%`.
  - Ép kiểu tường minh `static_cast<long long>(a) * b` để tránh tràn số trung gian.
  - Câu lệnh rẽ nhánh: `if - else`, `switch - case`.
  - Vòng lặp: `for`, `while`, `do - while`, lệnh nhảy `break`, `continue`.
  - *Chạy bàn:* Bảng biến thiên giá trị biến qua từng vòng lặp.
* **Chương 4: Mảng & Chuỗi Ký tự Cơ bản:**
  - Mảng tĩnh 1 chiều, 2 chiều: Các phần tử nằm kề nhau trên dải ô nhớ.
  - Chuỗi ký tự `std::string`: Bảng mã ASCII, chỉ số $0$-based, phép nối chuỗi và duyệt ký tự.
* **Chương 5: Địa chỉ Ô nhớ, Bản chất Con trỏ & Toán tử `&`, `*`:**
  - Khái niệm địa chỉ bộ nhớ (`address-of` toán tử `&`).
  - Con trỏ (`pointer` toán tử `*`): Biến lưu trữ địa chỉ ô nhớ khác.
  - Bản chất tương đương giữa con trỏ và mảng: `a[i] == *(a + i)`.
* **Chương 6: Hàm, Tham chiếu (`&`), Tham trị & Ngăn Xếp Gọi Hàm (Call Stack):**
  - Cấu trúc hàm, tham số hình thức, giá trị trả về.
  - Phân biệt triệt để: Truyền giá trị (`Pass-by-value`) vs Truyền tham chiếu (`Pass-by-reference` `&`).
  - Bản chất toán tử `&` trong khai báo tham số: Tạo bí danh (alias) trỏ thẳng vào địa chỉ ô nhớ gốc.
  - *Chạy bàn:* Kỹ thuật vẽ Khung ngăn xếp (Stack Frames) mô phỏng đẩy và giải phóng bộ nhớ khi gọi hàm.
* **Chương 7: Kiểu Dữ liệu Tự định nghĩa (`struct`):**
  - Khái niệm đóng gói dữ liệu với `struct`.
  - Mổ xẻ chi tiết cú pháp nạp chồng toán tử so sánh `operator<` (tại sao dùng `const Edge&`, tại sao hàm có đuôi `const`).
* **Chương 8: Phân tích Độ phức tạp Thuật toán trên Giấy:**
  - Ký hiệu Big-$O$: Bản chất toán học của cận trên thời gian và không gian bộ nhớ.
  - Phân tích $O(1), O(N), O(\log N), O(N^2), O(2^N)$.
  - Quy tắc ngón tay cái trong CP: Ước lượng thời gian $1\text{s} \approx 10^8$ phép tính để chọn thuật toán phù hợp với ràng buộc đề bài.
* **Bài tập Tích hợp Tập 1:** Luyện tập kết hợp Mảng + Con trỏ + Struct + Phân tích độ phức tạp.

---

### TẬP 2: Cấu Trúc Dữ Liệu STL & Kỹ Thuật Cốt Lõi
* **Chương 9: Số học Cơ bản cho Lập trình Thi đấu:**
  - Tính chia hết, ước số, số nguyên tố.
  - Sàng nguyên tố Eratosthenes (thuật toán và bảng sàng số bằng tay).
  - Thuật toán Euclid tìm GCD/LCM (bảng trace chia dư Euclid).
  - Lũy thừa nhị phân ($O(\log N)$) và quy tắc số học Modulo ($+ - \times \pmod M$).
* **Chương 10: Cấu trúc Dữ liệu Tuần tự STL (`std::vector`, `std::pair`, `std::tuple`):**
  - Cơ chế mở rộng dung lượng gấp đôi của `vector`, phân tích thời gian khấu hao (Amortized $O(1)$) trên giấy.
  - Gom nhóm dữ liệu nhẹ với `pair` và `tuple`.
* **Chương 11: Kỹ thuật Hai Con Trỏ (Two Pointers) & Cửa Sổ Trượt (Sliding Window):**
  - Khái niệm tính đơn điệu của hai con trỏ. Hai con trỏ ngược chiều và cùng chiều.
  - Cửa sổ trượt cố định và co giãn: Duyệt và duy trì thông tin trong $O(N)$.
* **Chương 12: Sắp xếp & Tìm kiếm Nhị phân:**
  - Thuật toán sắp xếp `std::sort`, hàm so sánh tùy biến và Lambda C++14.
  - Tìm kiếm nhị phân trên mảng đã sắp xếp: Cài đặt chặt chẽ không bị lặp vô tận (bẫy tính `mid`).
  - Hàm `std::lower_bound`, `std::upper_bound`.
  - Chặt nhị phân kết quả (Binary Search on Answer) và hàm kiểm tra `check(mid)`.
* **Chương 13: Đệ quy Sơ cấp & Cây Gọi Đệ quy:**
  - Cấu trúc đệ quy: Điểm dừng (Base case), bước chuyển.
  - Nguy cơ tràn ngăn xếp (Stack Overflow).
  - *Chạy bàn:* Vẽ Cây gọi đệ quy (Recursion Tree) và thứ tự thực thi.
* **Chương 14: Thuật toán Quay lui & Nhánh cận (Backtracking):**
  - Cây không gian trạng thái. Sinh nhị phân, sinh hoán vị, sinh tổ hợp.
  - Bài toán kinh điển: $N$ quân hậu (N-Queens), Bài toán chia tập con / Sudoku.
  - Kỹ thuật tỉa nhánh (Pruning) để giảm độ phức tạp.
* **Chương 15: Thuật toán Tham lam (Greedy Algorithms):**
  - Định nghĩa lựa chọn tối ưu cục bộ dẫn đến tối ưu toàn cục.
  - Phương pháp chứng minh tính đúng đắn trên giấy: Đổi chỗ (Exchange argument) và Quy nạp toán học.
  - Bài toán chọn khoảng không giao nhau (Interval Scheduling), bài toán đổi tiền.
* **Chương 16: Ngăn xếp & Hàng đợi STL (`std::stack`, `std::queue`, `std::deque`, `std::priority_queue`):**
  - Cơ chế LIFO, FIFO.
  - Phân tích sâu `std::deque`: Cấu trúc mảng phân khối (chunked array) cho phép chèn/xóa 2 đầu $O(1)$.
  - Hàng đợi ưu tiên `priority_queue` (Max-heap / Min-heap với `std::greater`).
  - Ứng dụng: Dãy ngoặc hợp lệ, Monotonic Stack & Monotonic Deque tìm phần tử lớn nhất trên cửa sổ trượt.
* **Chương 17: Tập hợp & Ánh xạ STL (`std::set`, `std::multiset`, `std::map`, `unordered_*`):**
  - Bản chất cây nhị phân tìm kiếm tự cân bằng Đỏ - Đen ($O(\log N)$): `set`, `map`.
  - Bảng băm $O(1)$ trung bình: `unordered_set`, `unordered_map`. Các tình huống xấu nhất $O(N)$ do va chạm băm và cách phòng ngừa.
* **Bài tập Tích hợp Tập 2:** Bài toán kết hợp Binary Search + Two Pointers + STL Set/Map.

---

### TẬP 3: Quy Hoạch Động Nền Tảng & Đồ Thị Cơ Bản
* **Chương 18: Bản chất Quy hoạch Động (Dynamic Programming Fundamentals):**
  - Nhận diện 2 tính chất cốt lõi: Cấu trúc con tối ưu (Optimal Substructure) và Bài toán con gối nhau (Overlapping Subproblems).
  - Chuyển hóa từ Đệ quy có nhớ (Memoization / Top-down) sang Khử đệ quy điền bảng (Tabulation / Bottom-up).
  - Thứ tự tính toán trạng thái (State Ordering) trên giấy.
* **Chương 19: Các Bài toán Quy hoạch Động Kinh điển:**
  - Dãy con tăng dài nhất (LIS: cách $O(N^2)$ và cải tiến $O(N \log N)$ bằng binary search).
  - Xâu con chung dài nhất (LCS).
  - Bài toán Ba lô 0/1 (0-1 Knapsack) và Ba lô vô hạn (Unbounded Knapsack) kèm kỹ thuật tối ưu không gian mảng 1 chiều.
  - Quy hoạch động trên lưới ô vuông (Grid Path DP).
* **Chương 20: Lý thuyết Đồ thị & Cách Biểu diễn:**
  - Đỉnh, cạnh, bậc, hướng, trọng số.
  - 3 cách biểu diễn đồ thị: Ma trận kề, Danh sách cạnh, Danh sách kề (`std::vector<int> adj[]`). So sánh ưu nhược điểm bộ nhớ và tốc độ.
* **Chương 21: Duyệt Đồ thị Cơ bản (BFS & DFS):**
  - Thuật toán BFS (sử dụng `std::queue`): Tìm đường đi ngắn nhất trên đồ thị không trọng số.
  - Thuật toán DFS (sử dụng ngăn xếp/đệ quy): Tìm thành phần liên thông, chu trình, kiểm tra đồ thị hai phía (Bipartite Graph).
* **Chương 22: Đồ thị Không Chu trình (DAG) & Sắp xếp Tô-pô (Topological Sort):**
  - Định nghĩa DAG.
  - Thuật toán Kahn (BFS dựa trên bán bậc vào `in_degree`) và thuật toán DFS Post-order.
  - Quy hoạch động trên DAG (đường đi dài nhất, đếm số đường đi).
* **Chương 23: Cây (Trees) & Các Thuộc tính Đặc biệt:**
  - Định nghĩa cây: Đồ thị vô hướng liên thông có $N$ đỉnh và $N-1$ cạnh.
  - Duyệt DFS trên cây: Tính kích thước cây con (`subtree size`), chiều cao, khoảng cách giữa các đỉnh.
  - Đường kính của cây (Tree Diameter): Thuật toán 2 lần DFS.
* **Chương 24: Đường đi Ngắn nhất với Thuật toán Dijkstra:**
  - Điều kiện đồ thị có trọng số không âm.
  - Cài đặt chuẩn mực với `std::priority_queue<pair<long long, int>, vector<...>, greater<...>>`.
  - Phân tích độ phức tạp $O((V + E) \log V)$.
  - *Chạy bàn:* Bảng khoảng cách `dist[]` và tập đỉnh cố định qua từng bước trích xuất heap.
* **Bài tập Tích hợp Tập 3:** Bài toán phối hợp Đồ thị + DP + Priority Queue.

---

### TẬP 4: Cấu Trúc Dữ Liệu & Thuật Toán Nâng Cao V1
* **Chương 25: Kỹ thuật Trải phẳng Cây (Euler Tour on Tree):**
  - Bản chất thứ tự duyệt DFS: Thời điểm vào `tin[u]` và thời điểm ra `tout[u]`.
  - Ánh xạ toàn bộ cây con của đỉnh $u$ thành một đoạn liên tiếp `[tin[u], tout[u]]` trên mảng 1 chiều.
  - Chuyển đổi bài toán truy vấn/cập nhật cây con về bài toán trên đoạn mảng.
* **Chương 26: Kỹ thuật Nhảy Nhị Phân (Binary Lifting):**
  - Khái niệm lũy thừa của $2$: Bất kỳ số nguyên nào cũng phân tích được thành tổng các lũy thừa của $2$.
  - Ứng dụng trên hàm rời rạc $f(x)$ và đồ thị hàm: Tìm $f^{(K)}(x)$ sau $K$ bước trong thời gian $O(\log K)$ với bảng tiền xử lý $O(N \log K)$.
* **Chương 27: Tổ tiên Chung Gần nhất (LCA on Tree qua Binary Lifting):**
  - Khái niệm LCA và ý nghĩa trong các bài toán truy vấn đường đi trên cây.
  - Xây dựng mảng `up[u][i]` lưu tổ tiên bậc $2^i$ của đỉnh $u$.
  - Thuật toán đưa hai đỉnh về cùng độ sâu và cùng nhảy lên tổ tiên chung trong $O(\log N)$.
  - Tính khoảng cách giữa hai đỉnh trên cây: $\text{dist}(u, v) = \text{depth}[u] + \text{depth}[v] - 2 \cdot \text{depth}[\text{lca}(u, v)]$.
* **Chương 28: Cây Chỉ số Nhị phân (Fenwick Tree / Binary Indexed Tree - BIT):**
  - Thao tác bit Lowbit: `i & (-i)`. Cấu trúc phân tầng quản lý đoạn.
  - Hai bài toán cốt lõi:
    1. Cập nhật 1 điểm, tính tổng đoạn (Point Update, Range Sum Query - $O(\log N)$).
    2. Cập nhật đoạn, truy vấn 1 điểm (Range Update, Point Query qua Mảng hiệu Difference Array).
  - Ứng dụng: Đếm số cặp nghịch thế (Inversion Count), kết hợp với Euler Tour để giải quyết truy vấn cập nhật giá trị cây con.
* **Chương 29: Thuật toán Băm Xâu (Polynomial Rolling Hashing):**
  - Công thức băm đa thức: Chọn cơ số $B$ và modulo số nguyên tố lớn $M$.
  - Kỹ thuật Băm kép (Double Hashing) triệt tiêu nguy cơ sinh test va chạm.
  - Mảng lũy thừa `pow[i]` và mảng tiền tố `hash[i]` để trích xuất mã băm của mọi xâu con trong $O(1)$.
  - Ứng dụng: So sánh 2 xâu con trong $O(1)$, thuật toán Rabin-Karp tìm xâu con, kiểm tra tính đối xứng (Palindrome).
* **Chương 30: Thao tác Bit & Quy hoạch Động Trạng thái Mặt nạ (Bitmask DP):**
  - Các phép toán bitwise: `&`, `|`, `^`, `~`, `<<`, `>>`.
  - Các hàm nội tại C++14: `__builtin_popcount`, `__builtin_ctz`.
  - Duyệt toàn bộ tập con của một mặt nạ: `for (int sub = mask; sub; sub = (sub - 1) & mask)`.
  - Quy hoạch động Bitmask với không gian trạng thái $O(2^N)$ ($N \le 20$):
    - Bài toán Người du lịch (TSP - Traveling Salesperson Problem $O(N^2 \cdot 2^N)$).
    - Bài toán Ghép cặp trọng số cực đại / Phân nhóm.
  - *Chạy bàn:* Mô phỏng bảng trạng thái lấp đầy từng bit trên giấy.
* **Bài tập Tích hợp Toàn diện V1:** Các bài toán thi đấu cấp quốc gia đòi hỏi phối hợp: Euler Tour + Fenwick Tree, Hashing + Binary Search, Bitmask DP + Dijkstra.

---

## 5. Quy Chuẩn Xuất Bản Sách In Vật Lý A4 (Typst Theme)

### 1. Bố cục Trang (Page Geometry)
- **Khổ giấy:** A4 ($210\text{ mm} \times 297\text{ mm}$).
- **Lề trang:**
  - Lề trong (đóng gáy): $28\text{ mm}$.
  - Lề ngoài: $22\text{ mm}$ (dành khoảng trống để học sinh ghi chú/nháp).
  - Lề trên / dưới: $22\text{ mm}$.
- **Chế độ in:** Hai mặt (Two-sided printing) với số trang so le, header hiển thị Tên Chương ở trang chẵn và Tên Mục ở trang lẻ.

### 2. Thiết kế Đồ họa Đen - Trắng (High-Contrast Monochrome)
- **Kiểu chữ (Typography):**
  - Tiêu đề & Văn bản chính: Serif (Linux Libertine hoặc tương đương) tạo cảm giác trang trọng, dễ đọc lâu không mỏi mắt.
  - Mã nguồn C++: Monospace (Fira Code hoặc JetBrains Mono) rõ ràng, phân biệt tuyệt đối giữa số 0 và chữ O, số 1 và chữ l.
- **Biểu đồ Cây & Đồ thị:**
  - Đỉnh: Hình tròn viền đen $1\text{pt}$, nền trắng hoặc nền xám nhạt ($15\%$).
  - Cạnh: Đường liền nét (Solid), đường nét đứt (Dashed), hoặc mũi tên rõ ràng. Không dùng đường màu.
  - Trọng số cạnh: Đặt trong ô chữ nhật nhỏ nền trắng đè lên cạnh.
- **Hộp Thông tin (Callout Boxes):**
  - Đường viền đơn sắc $0.8\text{pt}$ hoặc thanh dọc bên trái $3\text{pt}$ màu đen, nền xám siêu nhạt ($5\%$).
  - Biểu tượng nhận diện trực quan: `[LÝ THUYẾT]`, `[MÔ HÌNH BỘ NHỚ]`, `[MỔ XẺ CÚ PHÁP]`, `[CHẠY BÀN]`, `[THỬ THÁCH 10 TEST]`.

---

## 6. Thiết Kế Web Portal (Astro Starlight)

### 1. Cấu hình & Giao diện
- Dựa trên framework **Astro** kết hợp giao diện chuyên dụng cho tài liệu **Starlight**.
- Phân mục Sidebar rõ ràng theo 4 Tập.
- Hỗ trợ công thức toán học $\KaTeX$ mượt mà.
- Theme hỗ trợ chế độ tương phản cao, tối ưu cho việc đọc nội dung kỹ thuật.

### 2. Thành phần Tương tác: Interactive Test Checker
- Dưới mỗi bài tập trên web, bảng 10 test case được gắn kèm component:
  - 10 ô nhập liệu `input` tương ứng với 10 test case.
  - Nút **"Kiểm tra kết quả"**: So khớp với mảng kết quả JSON đã được tính toán sẵn.
  - Báo trạng thái: `ĐÚNG` (tích xanh) hoặc `SAI` (dấu X).
  - Khi làm sai hoặc muốn xem chi tiết, có nút **"Xem Bảng Trace Từng Bước"** để bung ra toàn bộ bảng chạy bàn của test đó.

### 3. Tải về Bản in PDF
- Ở đầu mỗi Tập và mỗi Chương có nút bấm nổi bật: **"Tải Bản In Sách A4 (PDF)"** dẫn thẳng tới tệp PDF đã biên dịch từ Typst trong thư mục `public/pdf/`.

---

## 7. Bộ Công Cụ Kiểm Chứng & Tự Động Hóa (`tools/verifier/`)

Nhằm đạt tiêu chuẩn xuất bản không lỗi (Zero-defect), toàn bộ test case và bảng trace được điều khiển bởi mã nguồn:

1. **Thư viện Ghi Vết (`trace_logger.hpp`):**
   - Một thư viện C++14 header-only cực nhẹ được nhúng vào các chương trình giải mẫu trong `code/`.
   - Có các macro `LOG_STATE(step, var_map)` để ghi lại trạng thái các biến và mảng tại từng bước lặp.
2. **Bộ Sinh & Kiểm Tra Test (`run_verifier.py`):**
   - Biên dịch tệp C++ với lệnh: `g++ -std=c++14 -O2 -Wall solution.cpp -o solution`.
   - Chạy qua 10 bộ test nhỏ được định nghĩa trong file cấu hình.
   - Xuất dữ liệu kiểm chứng ra 2 định dạng:
     - `typst_tables.typ`: Mã Typst chứa các bảng trace để nhúng trực tiếp vào Phụ lục sách in.
     - `web_tests.json`: Dữ liệu cho component `InteractiveChecker` trên Astro Starlight.

---

## 8. Đánh Giá Khả Thi & Kiểm Tra Tự Thân (Self-Review Checklist)

1. **Phủ kín yêu cầu (Spec Coverage):**
   - [x] In sách vật lý A4, thuần đen trắng, không giới hạn dung lượng.
   - [x] 100% không dùng máy tính, học sinh tự kiểm chứng và tự làm bài tập bằng tay.
   - [x] Trình tự kiến thức nghiêm ngặt DAG: Không có vòng lặp, đẩy con trỏ lên trước hàm/tham chiếu, thêm chương mở đầu máy tính/RAM.
   - [x] Đầy đủ 10 test nhỏ cho mỗi bài tập, có ô trống tự điền, lời giải và bảng trace ở phụ lục.
   - [x] Giới hạn V1 đạt đúng tầm: DP Bitmask, Dijkstra, Euler Tour, Fenwick Tree, Hashing.
   - [x] Web Starlight tương tác kiểm tra 10 test, tải PDF, không có popup/callout phức tạp thừa thãi.
2. **Tính nhất quán cú pháp & thuật ngữ:**
   - [x] Quy chuẩn C++ $\ge$ 14 xuyên suốt.
   - [x] Phân tích ngữ nghĩa chi tiết từng từ khóa (`const`, `&`).
   - [x] Hộp giải thích thuật ngữ khoa học trước mọi khái niệm mới.
3. **Phân rã thực thi:**
   - Tài liệu đã chia rõ 4 tập sách độc lập và hệ thống công cụ kiểm chứng, sẵn sàng cho việc lập kế hoạch triển khai (Implementation Plan) theo từng nhiệm vụ cụ thể.
