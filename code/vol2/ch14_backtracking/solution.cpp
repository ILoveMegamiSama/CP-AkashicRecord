#include <iostream>
#include <vector>
#include <string>
#include "trace_logger.hpp"

int n;
int solution_count = 0;
std::vector<int> first_solution;
std::vector<int> current_board;
std::vector<bool> used_col;
std::vector<bool> diag1; // row + col
std::vector<bool> diag2; // row - col + n

void backtrack(int row) {
    if (row == n) {
        solution_count++;
        if (first_solution.empty()) {
            first_solution = current_board;
        }
        TRACE_STEP(1000 + solution_count, "Found valid queen placement");
        return;
    }

    for (int col = 0; col < n; ++col) {
        int d1 = row + col;
        int d2 = row - col + n;

        if (!used_col[col] && !diag1[d1] && !diag2[d2]) {
            used_col[col] = diag1[d1] = diag2[d2] = true;
            current_board[row] = col + 1; // 1-based index

            TRACE_STEP(10 + row * 10 + col, "Place queen at (row, col)");
            TRACE_VAR("row", row + 1);
            TRACE_VAR("col", col + 1);

            backtrack(row + 1);

            used_col[col] = diag1[d1] = diag2[d2] = false;
            TRACE_STEP(500 + row * 10 + col, "Backtrack: remove queen from (row, col)");
        }
    }
}

int main() {
    if (!(std::cin >> n)) return 0;

    TRACE_STEP(1, "Read board size n");
    TRACE_VAR("n", n);

    solution_count = 0;
    first_solution.clear();
    current_board.assign(n, 0);
    used_col.assign(n, false);
    diag1.assign(2 * n, false);
    diag2.assign(2 * n, false);

    backtrack(0);

    TRACE_STEP(999, "Finished backtracking search");
    TRACE_VAR("solution_count", solution_count);

    if (solution_count == 0) {
        std::cout << "0 NONE\n";
    } else {
        std::cout << solution_count;
        for (int c : first_solution) {
            std::cout << " " << c;
        }
        std::cout << "\n";
    }

    return 0;
}
