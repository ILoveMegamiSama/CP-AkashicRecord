# ==============================================================================
# Akashic Record: Competitive Programming C++14 Offline Library
# Unified Automation Makefile
# ==============================================================================

SHELL := /usr/bin/env bash
BUILD_SCRIPT := ./tools/build_all.sh

.PHONY: all test pdf web clean help

# Default target: Run test verification -> Typst PDFs -> Astro Web portal
all:
	@$(BUILD_SCRIPT) all

# Run pytest unit tests and verify all 34 C++14 problems (340/340 test cases)
test:
	@$(BUILD_SCRIPT) test

# Compile all 4 Volumes to monochrome A4 PDFs via Typst into web/public/pdf/
pdf:
	@$(BUILD_SCRIPT) pdf

# Build the Astro Starlight static documentation site into web/dist/
web:
	@$(BUILD_SCRIPT) web

# Clean temporary files, caches, and build artifacts
clean:
	@$(BUILD_SCRIPT) clean

# Display available Makefile targets
help:
	@echo "Akashic Record - Hệ Thống Lệnh Makefile:"
	@echo "  make all    - Thực thi toàn bộ pipeline (test -> pdf -> web)"
	@echo "  make test   - Chạy Pytest & kiểm chứng 34 bài toán (340 test cases)"
	@echo "  make pdf    - Biên dịch 4 tập sách PDF A4 đơn sắc (web/public/pdf/)"
	@echo "  make web    - Xây dựng website cổng tra cứu tĩnh Astro (web/dist/)"
	@echo "  make clean  - Dọn dẹp cache và sản phẩm build trung gian"
	@echo "  make help   - Hiển thị hướng dẫn này"
