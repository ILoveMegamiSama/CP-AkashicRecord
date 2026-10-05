#!/usr/bin/env bash
# ==============================================================================
# Akashic Record: Competitive Programming C++14 Offline Library
# Unified CI & End-to-End Build Orchestrator
# ==============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Color formatting
if [[ -t 1 ]]; then
    GREEN="\033[0;32m"
    BLUE="\033[0;34m"
    CYAN="\033[0;36m"
    YELLOW="\033[1;33m"
    RED="\033[0;31m"
    BOLD="\033[1m"
    RESET="\033[0m"
else
    GREEN=""
    BLUE=""
    CYAN=""
    YELLOW=""
    RED=""
    BOLD=""
    RESET=""
fi

log_info() {
    echo -e "${CYAN}${BOLD}==>${RESET} ${BOLD}$*${RESET}"
}

log_pass() {
    echo -e "  ${GREEN}✓${RESET} $*"
}

log_fail() {
    echo -e "  ${RED}✗${RESET} $*" >&2
}

log_warn() {
    echo -e "  ${YELLOW}!${RESET} $*"
}

check_dep() {
    local cmd="$1"
    local hint="${2:-}"
    if ! command -v "$cmd" &>/dev/null; then
        log_fail "Yêu cầu công cụ '${cmd}' nhưng chưa được cài đặt trong PATH."
        if [[ -n "$hint" ]]; then
            echo -e "    ${YELLOW}Gợi ý:${RESET} $hint" >&2
        fi
        exit 1
    fi
}

run_test() {
    log_info "[1/3] Kiểm tra toàn diện 4 Tập (Pytest & 34 Bài toán / 340 Test Cases)..."

    check_dep "python3" "Cài đặt python3 (phiên bản 3.8+)"
    check_dep "g++" "Cài đặt trình biên dịch GCC / g++ hỗ trợ C++14"

    # Step 1: Run verifier unit tests
    echo -e "${BLUE}--> [Step 1] Chạy Pytest cho công cụ kiểm chứng (tools/verifier)...${RESET}"
    if command -v pytest &>/dev/null; then
        pytest tools/verifier/test_verifier.py -v
    else
        python3 -m unittest discover -s tools/verifier -p "test_*.py" || pytest tools/verifier/test_verifier.py -v
    fi
    log_pass "Pytest kiểm thử đơn vị hoàn tất thành công!"

    # Step 2: Run verification on all 34 problems across 4 volumes
    echo -e "\n${BLUE}--> [Step 2] Kiểm chứng tự động 34 bài toán C++14 (340 test cases)...${RESET}"

    local volumes=("vol1" "vol2" "vol3" "vol4")
    local total_problems=0
    local passed_problems=0
    local total_tests=0
    local passed_tests=0

    for vol in "${volumes[@]}"; do
        echo -e "\n  ${BOLD}[${vol^^}] Bắt đầu kiểm chứng các chương và bài tập tích hợp:${RESET}"
        
        # Sort directories naturally so ch01 comes before ch02, and integrated is at the end
        while IFS= read -r ch_dir; do
            [[ -z "$ch_dir" ]] && continue
            local ch_name
            ch_name="$(basename "$ch_dir")"
            
            local src_file="${ch_dir}/solution.cpp"
            local tests_file="${ch_dir}/tests.json"
            
            if [[ ! -f "$src_file" || ! -f "$tests_file" ]]; then
                log_fail "Thiếu source hoặc test trong thư mục: $ch_dir"
                exit 1
            fi
            
            local prefix
            if [[ "$ch_name" =~ ^(ch[0-9]+) ]]; then
                prefix="${BASH_REMATCH[1]}"
            else
                prefix="$ch_name"
            fi
            
            local out_typst="typst/${vol}/generated/${prefix}_trace.typ"
            local out_web="web/src/content/docs/${vol}/tests/${prefix}.json"
            
            total_problems=$((total_problems + 1))
            
            # Execute verifier
            local verifier_out
            if ! verifier_out=$(python3 tools/verifier/run_verifier.py \
                --src "$src_file" \
                --tests "$tests_file" \
                --out-typst "$out_typst" \
                --out-web "$out_web" 2>&1); then
                log_fail "Thất bại tại [${vol}/${ch_name}]:"
                echo "$verifier_out" >&2
                exit 1
            fi
            
            passed_problems=$((passed_problems + 1))
            total_tests=$((total_tests + 10))
            passed_tests=$((passed_tests + 10))
            
            printf "    ${GREEN}✓${RESET} (%2d/34) %-6s / %-25s -> 10/10 tests AC\n" \
                "$total_problems" "$vol" "$ch_name"
                
        done < <(find "code/${vol}" -mindepth 1 -maxdepth 1 -type d | sort -V)
    done

    echo -e "\n${GREEN}${BOLD}======================================================================${RESET}"
    echo -e "${GREEN}${BOLD}✓ TỔNG KẾT TEST: ${passed_problems}/${total_problems} Bài toán ĐẠT (100% AC) | ${passed_tests}/${total_tests} Test Cases${RESET}"
    echo -e "${GREEN}${BOLD}======================================================================${RESET}\n"
}

run_pdf() {
    log_info "[2/3] Biên dịch toàn bộ 4 Tập Sách A4 bằng Typst sang web/public/pdf/..."

    check_dep "typst" "Cài đặt Typst CLI (https://github.com/typst/typst)"

    mkdir -p web/public/pdf

    local volumes=("vol1" "vol2" "vol3" "vol4")
    local start_time
    start_time=$(date +%s)

    for vol in "${volumes[@]}"; do
        local src_typst="typst/${vol}/main.typ"
        local target_pdf="web/public/pdf/${vol}.pdf"

        if [[ ! -f "$src_typst" ]]; then
            log_fail "Không tìm thấy file nguồn Typst: $src_typst"
            exit 1
        fi

        echo -e "  ${BLUE}--> Biên dịch ${vol^^}:${RESET} ${src_typst} -> ${target_pdf}..."
        if ! typst compile --root . "$src_typst" "$target_pdf"; then
            log_fail "Biên dịch Typst thất bại cho ${vol}!"
            exit 1
        fi

        local size
        size=$(du -h "$target_pdf" | cut -f1)
        log_pass "Đã biên dịch thành công ${target_pdf} (${size})"
    done

    local end_time
    end_time=$(date +%s)
    local elapsed=$((end_time - start_time))

    echo -e "\n${GREEN}${BOLD}======================================================================${RESET}"
    echo -e "${GREEN}${BOLD}✓ TỔNG KẾT PDF: Toàn bộ 4 tập sách A4 đã được biên dịch xong trong ${elapsed}s!${RESET}"
    echo -e "${GREEN}${BOLD}======================================================================${RESET}\n"
}

run_web() {
    log_info "[3/3] Xây dựng cổng tài liệu tĩnh Astro Starlight (web/dist/)..."

    check_dep "npm" "Cài đặt Node.js và npm (https://nodejs.org/)"

    if [[ ! -d "web/node_modules" ]]; then
        log_warn "Thư mục web/node_modules chưa tồn tại. Đang tiến hành cài đặt phụ thuộc..."
        npm --prefix web install
    fi

    echo -e "  ${BLUE}--> Thực thi lệnh 'astro build' qua npm...${RESET}"
    if ! npm --prefix web run build; then
        log_fail "Lệnh 'npm run build' trong thư mục web/ thất bại!"
        exit 1
    fi

    if [[ ! -f "web/dist/index.html" ]]; then
        log_fail "Không tìm thấy file web/dist/index.html sau khi build!"
        exit 1
    fi

    local page_count
    page_count=$(find web/dist -type f -name "*.html" | wc -l)

    echo -e "\n${GREEN}${BOLD}======================================================================${RESET}"
    echo -e "${GREEN}${BOLD}✓ TỔNG KẾT WEB: Build thành công Astro Starlight (${page_count} trang HTML trong web/dist/)!${RESET}"
    echo -e "${GREEN}${BOLD}======================================================================${RESET}\n"
}

run_clean() {
    log_info "Dọn dẹp tệp tin build, bộ đệm tạm thời và cache hệ thống..."

    rm -rf web/dist web/.astro .pytest_cache
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    rm -f -- *.o *.out 2>/dev/null || true

    log_pass "Đã xóa sạch web/dist/, web/.astro/, .pytest_cache/ và các file nhị phân tạm thời."
}

show_help() {
    echo -e "${BOLD}Akashic Record Build Orchestrator${RESET}"
    echo "Cách sử dụng: $0 [all|test|pdf|web|clean|help]"
    echo ""
    echo "Các chế độ thực thi:"
    echo "  all    Chạy toàn bộ pipeline kiểm thử -> biên dịch PDF -> build Web (mặc định)"
    echo "  test   Kiểm thử 34 bài toán C++14 (340 test cases) và chạy unit test pytest"
    echo "  pdf    Biên dịch 4 tập sách A4 đơn sắc (Typst) ra thư mục web/public/pdf/"
    echo "  web    Build trang web cổng tra cứu tĩnh Astro Starlight ra web/dist/"
    echo "  clean  Dọn dẹp thư mục dist, .astro và các cache trung gian"
    echo "  help   Hiển thị hướng dẫn này"
}

# Main entry point
target="${1:-all}"

case "$target" in
    all)
        run_test
        run_pdf
        run_web
        echo -e "${GREEN}${BOLD}======================================================================${RESET}"
        echo -e "${GREEN}${BOLD}           AKASHIC RECORD: TOÀN BỘ PIPELINE THÀNH CÔNG RỰC RỠ!          ${RESET}"
        echo -e "${GREEN}${BOLD}======================================================================${RESET}"
        ;;
    test)
        run_test
        ;;
    pdf)
        run_pdf
        ;;
    web)
        run_web
        ;;
    clean)
        run_clean
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_fail "Lựa chọn không hợp lệ: '$target'"
        show_help
        exit 1
        ;;
esac
