# Kế Hoạch Triển Khai Hệ Thống Thư Viện Lập Trình Thi Đấu C++14 (Bản Sách In A4 & Web Starlight)

> **Dành cho kỹ sư / Subagent:** KỸ NĂNG PHỤ BẮT BUỘC: Sử dụng `superpowers:subagent-driven-development` (khuyến nghị) hoặc `superpowers:executing-plans` để triển khai kế hoạch này theo từng tác vụ. Các bước sử dụng cú pháp checkbox (`- [ ]`) để theo dõi tiến độ.

**Mục tiêu:** Xây dựng toàn bộ hệ thống thư viện tài liệu Lập trình thi đấu C++14 bao gồm bộ sách in A4 chuẩn đen trắng (4 Tập, 30 chương, 100% không dùng máy tính, kèm 10 test nhỏ và bảng trace phụ lục), trang web tài liệu Astro Starlight với công cụ kiểm tra test tương tác, và pipeline Python kiểm chứng tính đúng của toàn bộ testcase.

**Kiến trúc:** 
Mô hình đơn nguồn kiểm chứng (Single Source of Truth with Verification Pipeline):
1. Mã nguồn tham chiếu C++14 chuẩn (`code/vol{1..4}/`) kết hợp thư viện `trace_logger.hpp` để sinh vết trạng thái chính xác.
2. Công cụ kiểm chứng Python (`tools/verifier/`) biên dịch `g++ -std=c++14`, chạy qua 10 bộ test nhỏ, sinh bảng trace chuẩn sang định dạng Typst (`typst/`) và dữ liệu JSON cho Web (`web/`).
3. Bộ sách in 4 Tập trên Typst theo khuôn mẫu A4 đơn sắc (high-contrast monochrome), phân cấp khoa học và lề ghi chú rộng.
4. Cổng tài liệu Astro Starlight hiển thị nội dung trực tuyến, tích hợp component `InteractiveChecker` cho 10 test case và cung cấp nút tải PDF bản in A4 của từng tập sách.

**Công nghệ sử dụng:** 
- Ngôn ngữ: C++14 (`g++ -std=c++14 -O2 -Wall`), Python 3.10+, TypeScript / Astro / Starlight.
- Định dạng xuất bản in: Typst CLI ($\ge 0.11$).
- Frontend Web: Astro Starlight, KaTeX, Tailwind/CSS monochrome.

**Tài liệu Đặc tả (Spec):** [docs/superpowers/specs/2026-10-05-cp-cpp14-offline-library-design.md](file:///run/media/paust/windows-data/03_work/tutoring/Education/Herrscher/AkashicRecord/docs/superpowers/specs/2026-10-05-cp-cpp14-offline-library-design.md)

---

## Ràng Buộc Toàn Cục (Global Constraints)

- **Tiêu chuẩn C++:** Nghiêm ngặt $C++ \ge 14$, không sử dụng tính năng chỉ có từ C++17/C++20 (như `std::string_view`, cấu trúc binding `auto [u, v]`, `std::ranges`).
- **Quy chuẩn in ấn:** Khổ giấy A4 ($210 \times 297\text{ mm}$), lề gáy $28\text{ mm}$, lề ngoài $22\text{ mm}$, hai mặt (two-sided).
- **Thuần Đen - Trắng (Monochrome):** Toàn bộ đồ thị, cây, bảng biểu và hộp văn bản chỉ dùng sắc độ đen, trắng, xám nhạt (5% - 20%), nét đứt, nét liền, không phụ thuộc vào màu sắc.
- **Trình tự tuyến tính nghiêm ngặt (Strict DAG):** Tuyệt đối không dùng khái niệm chưa học ở các chương trước; con trỏ học trước hàm/tham chiếu; Binary Lifting học trước LCA on Tree.
- **Quy chuẩn 10 Test Bàn Tay:** Mỗi bài toán bắt buộc có 10 test nhỏ chia 4 nhóm (Cơ bản, Biên, Bẫy, Thử thách tính nhẩm) kèm ô trống điền kết quả; toàn bộ đáp án và bảng trace nằm ở Phụ lục cuối tập sách.
- **Mổ xẻ cú pháp & Thuật ngữ:** Mọi cấu trúc phức tạp (`operator<`, `const`, `&`) đều có khung giải thích chi tiết; mọi thuật ngữ khoa học có hộp giải nghĩa trực giác.

---

## Tiêu Điểm Đánh Giá & Kiểm Thử Biên (Review Focus)

1. **Tràn số nguyên trung gian (Integer Overflow):** Các phép toán như `a * b` hoặc `mid = (l + r) / 2` phải được phân tích nguy cơ tràn `int` 32-bit và hướng dẫn dùng `static_cast<long long>` hoặc `l + (r - l) / 2`.
2. **Cạm bẫy tham chiếu hằng (`const &`):** Tránh sao chép bộ nhớ khi truyền struct/vector lớn và đảm bảo giải thích cặn kẽ tại sao hàm so sánh cần `const` ở đuôi để không gây lỗi biên dịch với `std::sort` / `std::priority_queue`.
3. **Hiện tượng lặp vô tận trong Tìm kiếm nhị phân & Hai con trỏ:** Kiểm tra các trường hợp $l = r - 1$, tránh trường hợp chia đôi `mid` làm thuật toán treo khi chạy tay.
4. **Trường hợp biên của Cây & Đồ thị:** Đồ thị rời rạc, cây chỉ có 1 đỉnh ($N=1$), cây dạng đường thẳng (degenerate tree), đồ thị có trọng số $0$.
5. **Kích thước tính nhẩm của 10 test bàn tay:** Dữ liệu của 10 test phải đủ nhỏ ($N \le 8$, giá trị số $\le 100$) để học sinh hoàn toàn có thể tính nhẩm trên giấy trong vòng $1 \dots 3$ phút/test mà không bị nản chí.

---

### Nhiệm Vụ 1: Xây Dựng Bộ Công Cụ Kiểm Chứng & Thư Viện Ghi Vết Trace (`tools/verifier/`)

**Tệp tin:**
- Tạo mới: `tools/verifier/trace_logger.hpp`
- Tạo mới: `tools/verifier/run_verifier.py`
- Tạo mới: `tools/verifier/test_verifier.py`

**Giao diện:**
- Cung cấp:
  - C++ header: `trace_logger.hpp` cung cấp macro `TRACE_STEP(step_num, msg)`, `TRACE_VAR(name, val)`, `TRACE_ARRAY(name, arr, size)`.
  - Python CLI: `python run_verifier.py --src <source.cpp> --tests <tests.json> --out-typst <out.typ> --out-web <out.json>`
  - Return: Exit code 0 nếu tất cả test đúng; sinh file Typst table và file Web JSON.

- [ ] **Bước 1: Viết bài test kiểm thử thất bại (failing test) cho Python Verifier**

Tạo `tools/verifier/test_verifier.py` kiểm thử việc biên dịch một chương trình C++ mẫu, chạy qua 10 bộ test và xuất file bảng Typst cùng file JSON:

```python
import os
import subprocess
import json
import pytest

def test_verifier_pipeline(tmp_path):
    # Test file that will fail initially because run_verifier.py and trace_logger.hpp don't exist yet
    src_cpp = tmp_path / "solution.cpp"
    src_cpp.write_text("""
#include <iostream>
#include <vector>
#include "trace_logger.hpp"
int main() {
    int n; if (!(std::cin >> n)) return 0;
    long long sum = 0;
    for (int i = 1; i <= n; ++i) {
        sum += i;
        TRACE_STEP(i, "Add i to sum");
        TRACE_VAR("sum", sum);
    }
    std::cout << sum << "\\n";
    return 0;
}
""")
    tests_json = tmp_path / "tests.json"
    tests_data = [{"id": i, "input": f"{i}\\n", "expected": f"{i*(i+1)//2}\\n"} for i in range(1, 11)]
    tests_json.write_text(json.dumps(tests_data))

    out_typst = tmp_path / "table.typ"
    out_web = tmp_path / "web.json"

    res = subprocess.run([
        "python3", "tools/verifier/run_verifier.py",
        "--src", str(src_cpp),
        "--tests", str(tests_json),
        "--out-typst", str(out_typst),
        "--out-web", str(out_web)
    ], capture_output=True, text=True)

    assert res.returncode == 0
    assert out_typst.exists()
    assert out_web.exists()
    web_data = json.loads(out_web.read_text())
    assert len(web_data) == 10
    assert web_data[0]["status"] == "AC"
```

- [ ] **Bước 2: Chạy bài test để xác nhận thất bại**

Chạy lệnh: `pytest tools/verifier/test_verifier.py`  
Kỳ vọng: Thất bại do chưa tồn tại `run_verifier.py` và `trace_logger.hpp`.

- [ ] **Bước 3: Cài đặt `tools/verifier/trace_logger.hpp` và `tools/verifier/run_verifier.py`**

- `trace_logger.hpp`: Hỗ trợ cờ `-DENABLE_TRACE` để ghi các bước và biến ra `std::cerr` theo định dạng `[TRACE_JSON]: {...}`. Khi không bật cờ, macro là no-op rỗng không ảnh hưởng tốc độ code.
- `run_verifier.py`: Biên dịch mã nguồn C++ với `g++ -std=c++14 -O2 -Wall`, nạp danh sách 10 test từ JSON, chạy từng test, so khớp kết quả thực tế với `expected`, phân tích log trace từ `stderr` để sinh ra khối bảng Typst `#trace-table(...)` và file JSON cho Web.

- [ ] **Bước 4: Chạy lại bài test để xác nhận thành công**

Chạy lệnh: `pytest tools/verifier/test_verifier.py`  
Kỳ vọng: PASS 100%.

- [ ] **Bước 5: Commit thay đổi**

```bash
git add tools/verifier/
git commit -m "feat(verifier): add C++14 trace logger and python automated verification engine"
```

---

### Nhiệm Vụ 2: Xây Dựng Theme Xuất Bản Sách In Typst Khổ A4 Đơn Sắc (`typst/templates/`)

**Tệp tin:**
- Tạo mới: `typst/templates/book_theme.typ`
- Tạo mới: `typst/templates/components.typ`
- Tạo mới: `typst/templates/trace_table.typ`
- Tạo mới: `typst/tests/test_book_scaffold.typ`

**Giao diện:**
- Cung cấp:
  - `book-setup(title, volume, author, body)`: Khởi tạo trang khổ A4 hai mặt, lề $28\text{ mm} / 22\text{ mm}$, header/footer so le chẵn lẻ, phông chữ serif đen trắng độ tương phản cao.
  - `syntax-anatomy(code, explanations)`: Khung bóc tách cú pháp C++ với giải thích từng thành phần.
  - `callout(kind, title, body)`: Hộp ghi chú đen trắng (Lý thuyết, Mô hình bộ nhớ, Thuật ngữ).
  - `hand-trace-problem(name, source, problem_desc, sample, tests_10)`: Macro dàn trang đề bài và lưới 10 ô trống điền kết quả.
  - `appendix-trace(problem_name, tests_traces)`: Macro sinh phụ lục lời giải và bảng trace chi tiết.

- [ ] **Bước 1: Viết bài test kiểm thử thất bại cho Typst template**

Tạo `typst/tests/test_book_scaffold.typ` chứa một trang sách thử nghiệm sử dụng đầy đủ các component trên:

```typst
#import "../templates/book_theme.typ": book-setup
#import "../templates/components.typ": syntax-anatomy, callout
#import "../templates/trace_table.typ": hand-trace-problem, appendix-solution

#show: book-setup.with(
  title: "Lập Trình Thi Đấu C++14",
  volume: "Tập 1: Nền Tảng",
  author: "Akashic Record",
)

= Chương 1: Kiểm Thử Bản Mẫu

#callout(kind: "theory", title: "Khái niệm", [Văn bản thử nghiệm đơn sắc.])

#syntax-anatomy(
  `bool operator<(const Edge& other) const`,
  (
    ("const Edge&", "Tham chiếu hằng tránh sao chép"),
    ("const đuôi", "Không thay đổi thuộc tính đối tượng gọi")
  )
)
```

- [ ] **Bước 2: Chạy lệnh biên dịch để xác nhận thất bại**

Chạy lệnh: `typst compile typst/tests/test_book_scaffold.typ typst/tests/test_output.pdf`  
Kỳ vọng: Thất bại do chưa có các file template trong `typst/templates/`.

- [ ] **Bước 3: Cài đặt các file template trong `typst/templates/`**

- `book_theme.typ`: Thiết lập khổ A4, margins `(inside: 28mm, outside: 22mm, top: 22mm, bottom: 22mm)`, cấu hình số trang đối xứng, font Serif độ tương phản cao, định dạng tiêu đề chương/mục.
- `components.typ`: Tạo macro `callout` viền đen thanh đậm $2.5\text{pt}$ bên trái, nền xám $5\%$; macro `syntax-anatomy` với bảng chia 2 cột (cú pháp và phân tích ngữ nghĩa); macro `term-box` giải nghĩa từ nguyên khoa học.
- `trace_table.typ`: Macro tạo bảng 10 test case với hàng ô trống `[ .................... ]` để học sinh điền kết quả bằng bút chì; macro `trace-matrix` tạo bảng chạy bàn từng bước với các cột: Bước, Dòng lệnh, Biến số, Ngăn xếp, Điều kiện.

- [ ] **Bước 4: Chạy biên dịch Typst để xác nhận thành công**

Chạy lệnh: `typst compile typst/tests/test_book_scaffold.typ typst/tests/test_output.pdf`  
Kỳ vọng: Biên dịch thành công ra file `test_output.pdf` không có cảnh báo nào. Kiểm tra file PDF đảm bảo đúng khổ A4 và hoàn toàn chuẩn đen trắng.

- [ ] **Bước 5: Commit thay đổi**

```bash
git add typst/
git commit -m "feat(typst): add A4 monochrome print book template, callout components, and trace tables"
```

---

### Nhiệm Vụ 3: Khởi Tạo Web Portal Astro Starlight & Component Kiểm Tra Test Tương Tác (`web/`)

**Tệp tin:**
- Tạo mới: `web/package.json`
- Tạo mới: `web/astro.config.mjs`
- Tạo mới: `web/src/components/InteractiveChecker.astro`
- Tạo mới: `web/src/content/docs/index.mdx`
- Tạo mới: `web/src/styles/custom.css`

**Giao diện:**
- Cung cấp:
  - Cấu hình Starlight 4 Tập trong Sidebar (`vol1`, `vol2`, `vol3`, `vol4`).
  - Hỗ trợ công thức toán $\KaTeX$.
  - Component `<InteractiveChecker tests={testsData} />` nhận danh sách 10 test, hiển thị 10 ô nhập, nút "Kiểm tra", báo trạng thái Đúng/Sai và nút mở bảng trace chi tiết.

- [ ] **Bước 1: Viết bài test kiểm thử thất bại cho Web build**

Tạo script test hoặc kiểm tra package trong `web/`:
Chạy thử: `cd web && npm run build`  
Kỳ vọng: Thất bại do chưa khởi tạo project Astro.

- [ ] **Bước 2: Khởi tạo dự án Astro Starlight trong thư mục `web/`**

- Cài đặt `astro`, `@astrojs/starlight`, `remark-math`, `rehype-katex`, `katex`.
- Cấu hình `astro.config.mjs` thiết lập tiêu đề "Akashic Record - CP C++14", sidebar 4 tập, tích hợp KaTeX.
- Cấu hình CSS đơn sắc tinh tế trong `web/src/styles/custom.css`.

- [ ] **Bước 3: Cài đặt `<InteractiveChecker.astro>`**

Xây dựng component:
- Render bảng 10 dòng: STT, Input tóm tắt, Ô input gõ câu trả lời, Nhãn trạng thái (Trống / Đúng / Sai).
- Xử lý JavaScript client-side: Khi nhấn "Kiểm tra kết quả", chuẩn hóa chuỗi (trim khoảng trắng) và so khớp với đáp án đúng trong JSON.
- Nút "Xem Bảng Trace Chi Tiết" hiển thị bảng chạy bàn tương ứng khi người dùng muốn xem lời giải.

- [ ] **Bước 4: Chạy lệnh build kiểm thử trang web**

Chạy lệnh: `cd web && npm run build`  
Kỳ vọng: Quá trình build hoàn tất thành công, sinh ra thư mục `web/dist/`.

- [ ] **Bước 5: Commit thay đổi**

```bash
git add web/
git commit -m "feat(web): initialize Astro Starlight documentation portal with InteractiveChecker component"
```

---

### Nhiệm Vụ 4: Biên Soạn Trọn Vẹn Tập 1 - C++14 & Tư Duy Thuật Toán Cơ Bản (Chương 1 - 8 & Bài Tập Tích Hợp)

**Tệp tin:**
- Mã nguồn C++ & Tests: `code/vol1/` (Chương 1 đến 8 và Bài tập tích hợp)
- Mã nguồn Typst: `typst/vol1/main.typ`, `typst/vol1/chapters/ch01_to_ch08.typ`, `typst/vol1/appendix.typ`
- Nội dung Web: `web/src/content/docs/vol1/ch01.mdx` đến `ch08.mdx`, `integrated.mdx`

**Nội dung chi tiết từng chương theo Strict DAG:**
- **Chương 1:** Máy tính, Bộ nhớ RAM, CPU & Bản chất Thuật toán (Mô hình dải ô nhớ đánh số từ $0$, khái niệm biến là nhãn dán ô nhớ).
- **Chương 2:** Cấu trúc Chương trình C++14 & Biểu diễn Dữ liệu (Primitive Types, Hai bù Two's complement, Tràn số nguyên `int` vs `long long`).
- **Chương 3:** Biến, Biểu thức, Ép kiểu `static_cast` & Luồng Điều khiển (If/Else, Vòng lặp For/While, Bảng biến thiên biến số).
- **Chương 4:** Mảng 1D, 2D & Chuỗi `std::string` Cơ bản (Ô nhớ liên tiếp, ASCII, chỉ số $0$-based).
- **Chương 5:** Địa chỉ Ô nhớ, Bản chất Con trỏ & Toán tử `&`, `*` (Giải nghĩa `address-of`, con trỏ trỏ ô nhớ, tương đương `*(a + i) == a[i]`).
- **Chương 6:** Hàm, Tham chiếu (`&`), Tham trị & Ngăn Xếp Gọi Hàm (Call Stack) (Bản chất toán tử `&` tạo bí danh, vẽ Khung ngăn xếp Stack Frames trên giấy).
- **Chương 7:** Kiểu Dữ liệu Tự định nghĩa (`struct`) & Mổ xẻ Cú pháp `operator<` (Giải nghĩa chi tiết `bool operator<(const Edge& other) const`).
- **Chương 8:** Phân tích Độ phức tạp Thuật toán trên Giấy ($O(1), O(N), O(\log N), O(N^2)$, Quy tắc 1 giây $\approx 10^8$ phép tính).
- **Bài tập Tích hợp Tập 1:** Bài toán quản lý học sinh / tọa độ kết hợp Mảng + Con trỏ + Struct + Phân tích độ phức tạp.

- [ ] **Bước 1: Cài đặt mã nguồn C++ tham chiếu & 10 test cho từng bài tập Tập 1 trong `code/vol1/`**
- [ ] **Bước 2: Chạy `run_verifier.py` để xác nhận 100% test pass và xuất dữ liệu trace cho Tập 1**
- [ ] **Bước 3: Soạn thảo nội dung Typst hoàn chỉnh cho Tập 1 (`typst/vol1/`) và biên dịch ra `vol1.pdf`**
- [ ] **Bước 4: Đồng bộ nội dung sang Web Starlight (`web/src/content/docs/vol1/`) kèm component `InteractiveChecker`**
- [ ] **Bước 5: Commit thay đổi**

```bash
git add code/vol1/ typst/vol1/ web/src/content/docs/vol1/
git commit -m "feat(vol1): complete Volume 1 C++14 fundamentals book, problems, 10-test suites, and web docs"
```

---

### Nhiệm Vụ 5: Biên Soạn Trọn Vẹn Tập 2 - Cấu Trúc Dữ Liệu STL & Kỹ Thuật Cốt Lõi (Chương 9 - 17 & Bài Tập Tích Hợp)

**Tệp tin:**
- Mã nguồn C++ & Tests: `code/vol2/` (Chương 9 đến 17 và Bài tập tích hợp)
- Mã nguồn Typst: `typst/vol2/main.typ`, `typst/vol2/chapters/ch09_to_ch17.typ`, `typst/vol2/appendix.typ`
- Nội dung Web: `web/src/content/docs/vol2/ch09.mdx` đến `ch17.mdx`, `integrated.mdx`

**Nội dung chi tiết từng chương theo Strict DAG:**
- **Chương 9:** Số học Cơ bản cho CP (Sàng Eratosthenes, Euclid GCD/LCM, Lũy thừa nhị phân $O(\log N)$, Modulo).
- **Chương 10:** Cấu trúc Dữ liệu Tuần tự STL (`vector`, `pair`, `tuple`, phân tích thời gian khấu hao Amortized $O(1)$).
- **Chương 11:** Kỹ thuật Hai Con Trỏ & Cửa Sổ Trượt (Two Pointers & Sliding Window trên mảng).
- **Chương 12:** Sắp xếp (`std::sort`, hàm so sánh, C++14 lambda) & Tìm kiếm Nhị phân, Chặt nhị phân kết quả (`check(mid)`).
- **Chương 13:** Đệ quy Sơ cấp & Cây Gọi Đệ quy (Base case, Recursion tree trên giấy).
- **Chương 14:** Thuật toán Quay lui & Nhánh cận (Sinh nhị phân/hoán vị, N-Queens, tỉa nhánh).
- **Chương 15:** Thuật toán Tham lam (Greedy) & Phương pháp Chứng minh trên Giấy (Đổi chỗ, quy nạp).
- **Chương 16:** Ngăn xếp & Hàng đợi STL (`stack`, `queue`, `deque`, `priority_queue`, Monotonic Stack/Queue cơ bản).
- **Chương 17:** Tập hợp & Ánh xạ STL (`set`, `multiset`, `map` Red-Black tree vs `unordered_*` Hash table).
- **Bài tập Tích hợp Tập 2:** Bài toán phối hợp Chặt nhị phân + Hai con trỏ + STL Map/Set.

- [ ] **Bước 1: Cài đặt mã nguồn C++ tham chiếu & 10 test cho từng bài tập Tập 2 trong `code/vol2/`**
- [ ] **Bước 2: Chạy `run_verifier.py` xác nhận 100% test pass và xuất dữ liệu trace cho Tập 2**
- [ ] **Bước 3: Soạn thảo nội dung Typst hoàn chỉnh cho Tập 2 (`typst/vol2/`) và biên dịch ra `vol2.pdf`**
- [ ] **Bước 4: Đồng bộ nội dung sang Web Starlight (`web/src/content/docs/vol2/`)**
- [ ] **Bước 5: Commit thay đổi**

```bash
git add code/vol2/ typst/vol2/ web/src/content/docs/vol2/
git commit -m "feat(vol2): complete Volume 2 STL and core algorithmic techniques book, problems, and web docs"
```

---

### Nhiệm Vụ 6: Biên Soạn Trọn Vẹn Tập 3 - Quy Hoạch Động Nền Tảng & Đồ Thị Cơ Bản (Chương 18 - 24 & Bài Tập Tích Hợp)

**Tệp tin:**
- Mã nguồn C++ & Tests: `code/vol3/` (Chương 18 đến 24 và Bài tập tích hợp)
- Mã nguồn Typst: `typst/vol3/main.typ`, `typst/vol3/chapters/ch18_to_ch24.typ`, `typst/vol3/appendix.typ`
- Nội dung Web: `web/src/content/docs/vol3/ch18.mdx` đến `ch24.mdx`, `integrated.mdx`

**Nội dung chi tiết từng chương theo Strict DAG:**
- **Chương 18:** Bản chất Quy hoạch Động (Từ Memoization Top-down sang Tabulation Bottom-up, Bảng trạng thái).
- **Chương 19:** Các Bài toán DP Kinh điển (LIS $O(N^2)$ & $O(N\log N)$, LCS, Knapsack 0/1 & Unbounded, Grid DP).
- **Chương 20:** Lý thuyết Đồ thị & Cách Biểu diễn (Ma trận kề, Danh sách cạnh, Danh sách kề `vector<int> adj[]`).
- **Chương 21:** Duyệt Đồ thị Cơ bản BFS & DFS (Thành phần liên thông, Đồ thị hai phía Bipartite).
- **Chương 22:** Đồ thị Không Chu trình (DAG) & Sắp xếp Tô-pô (Thuật toán Kahn, DFS, Quy hoạch động trên DAG).
- **Chương 23:** Cây (Trees) & Các Thuộc tính Đặc biệt (Subtree size, Chiều cao, Đường kính cây với 2 lần DFS).
- **Chương 24:** Đường đi Ngắn nhất với Thuật toán Dijkstra (Cài đặt chuẩn với `priority_queue`, Bảng khoảng cách chạy bàn).
- **Bài tập Tích hợp Tập 3:** Bài toán phối hợp Đồ thị + DP trên DAG + Dijkstra.

- [ ] **Bước 1: Cài đặt mã nguồn C++ tham chiếu & 10 test cho từng bài tập Tập 3 trong `code/vol3/`**
- [ ] **Bước 2: Chạy `run_verifier.py` xác nhận 100% test pass và xuất dữ liệu trace cho Tập 3**
- [ ] **Bước 3: Soạn thảo nội dung Typst hoàn chỉnh cho Tập 3 (`typst/vol3/`) và biên dịch ra `vol3.pdf`**
- [ ] **Bước 4: Đồng bộ nội dung sang Web Starlight (`web/src/content/docs/vol3/`)**
- [ ] **Bước 5: Commit thay đổi**

```bash
git add code/vol3/ typst/vol3/ web/src/content/docs/vol3/
git commit -m "feat(vol3): complete Volume 3 Dynamic Programming and Graph foundations book, problems, and web docs"
```

---

### Nhiệm Vụ 7: Biên Soạn Trọn Vẹn Tập 4 - Cấu Trúc Dữ Liệu & Thuật Toán Nâng Cao V1 (Chương 25 - 30 & Bài Tập Tích Hợp)

**Tệp tin:**
- Mã nguồn C++ & Tests: `code/vol4/` (Chương 25 đến 30 và Bài tập tích hợp)
- Mã nguồn Typst: `typst/vol4/main.typ`, `typst/vol4/chapters/ch25_to_ch30.typ`, `typst/vol4/appendix.typ`
- Nội dung Web: `web/src/content/docs/vol4/ch25.mdx` đến `ch30.mdx`, `integrated.mdx`

**Nội dung chi tiết từng chương theo Strict DAG:**
- **Chương 25:** Kỹ thuật Trải phẳng Cây (Euler Tour on Tree: `tin[u]`, `tout[u]`, chuyển cây con thành đoạn liên tiếp).
- **Chương 26:** Kỹ thuật Nhảy Nhị Phân (Binary Lifting trên dãy số và hàm $f(x)$ tìm $f^{(K)}(x)$ trong $O(\log K)$).
- **Chương 27:** Tổ tiên Chung Gần nhất (LCA on Tree qua Binary Lifting, tính khoảng cách giữa 2 đỉnh).
- **Chương 28:** Cây Chỉ số Nhị phân (Fenwick Tree / BIT: Thao tác Lowbit `i & (-i)`, Point Update Range Sum, Range Update Point Query, Đếm nghịch thế, kết hợp Euler Tour cập nhật cây con).
- **Chương 29:** Thuật toán Băm Xâu (Polynomial Rolling Hashing: Cơ số, Modulo, Double Hashing, Tiền tố băm $O(1)$, Rabin-Karp, Palindrome).
- **Chương 30:** Thao tác Bit & Quy hoạch Động Trạng thái Mặt nạ (Bitmask DP: Phép toán bit, popcount, duyệt tập con, Bài toán TSP, Ghép cặp/Phân nhóm).
- **Bài tập Tích hợp Toàn diện V1:** Các bài toán nâng cao phối hợp Euler Tour + Fenwick Tree, Hashing + Binary Search, Bitmask DP + Dijkstra.

- [ ] **Bước 1: Cài đặt mã nguồn C++ tham chiếu & 10 test cho từng bài tập Tập 4 trong `code/vol4/`**
- [ ] **Bước 2: Chạy `run_verifier.py` xác nhận 100% test pass và xuất dữ liệu trace cho Tập 4**
- [ ] **Bước 3: Soạn thảo nội dung Typst hoàn chỉnh cho Tập 4 (`typst/vol4/`) và biên dịch ra `vol4.pdf`**
- [ ] **Bước 4: Đồng bộ nội dung sang Web Starlight (`web/src/content/docs/vol4/`)**
- [ ] **Bước 5: Commit thay đổi**

```bash
git add code/vol4/ typst/vol4/ web/src/content/docs/vol4/
git commit -m "feat(vol4): complete Volume 4 advanced data structures and algorithms book, problems, and web docs"
```

---

### Nhiệm Vụ 8: Tự Động Hóa Build Hệ Thống & Kiểm Tra Toàn Diện (CI & End-to-End Build)

**Tệp tin:**
- Tạo mới: `Makefile`
- Tạo mới: `tools/build_all.sh`
- Tạo mới: `README.md`

**Giao diện:**
- Cung cấp:
  - `make test`: Chạy toàn bộ bộ test kiểm chứng của 4 Tập với `run_verifier.py`.
  - `make pdf`: Biên dịch toàn bộ 4 file PDF A4 (`vol1.pdf` đến `vol4.pdf`) và sao chép vào `web/public/pdf/`.
  - `make web`: Build phiên bản web Astro Starlight ra thư mục `web/dist/`.
  - `make all`: Chạy tuần tự `make test` $\to$ `make pdf` $\to$ `make web`.

- [ ] **Bước 1: Viết script `tools/build_all.sh` và `Makefile`**
- [ ] **Bước 2: Chạy `make test` để xác minh mọi giải pháp C++14 và bộ test đều đạt kết quả AC**
- [ ] **Bước 3: Chạy `make pdf` để biên dịch đầy đủ 4 tập sách PDF A4**
- [ ] **Bước 4: Chạy `make web` để kiểm tra bản build trang web hoàn chỉnh**
- [ ] **Bước 5: Soạn thảo `README.md` hướng dẫn sử dụng, tra cứu, in ấn sách và phát triển dự án**
- [ ] **Bước 6: Commit thay đổi hoàn thiện**

```bash
git add Makefile tools/build_all.sh README.md
git commit -m "feat(build): add unified build pipeline, Makefile, and project README documentation"
```
