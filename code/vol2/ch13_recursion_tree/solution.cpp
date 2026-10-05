#include <iostream>
#include <algorithm>
#include "trace_logger.hpp"

long long total_calls = 0;
int max_depth = 0;

long long solve_f(int n, int depth) {
    total_calls++;
    max_depth = std::max(max_depth, depth);

    TRACE_STEP(total_calls, "Enter recursive call");
    TRACE_VAR("n", n);
    TRACE_VAR("depth", depth);

    if (n <= 1) {
        TRACE_STEP(1000 + total_calls, "Base case reached: n <= 1");
        return 1;
    }

    long long left_val = solve_f(n - 1, depth + 1);
    long long right_val = solve_f(n / 2, depth + 1);
    long long res = left_val + right_val + n;

    TRACE_STEP(2000 + total_calls, "Return from recursive step");
    TRACE_VAR("n", n);
    TRACE_VAR("res", res);

    return res;
}

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    total_calls = 0;
    max_depth = 0;

    TRACE_STEP(1, "Read input n");
    TRACE_VAR("n", n);

    long long val = solve_f(n, 0);

    TRACE_STEP(999, "Recursion completed");
    TRACE_VAR("val", val);
    TRACE_VAR("total_calls", total_calls);
    TRACE_VAR("max_depth", max_depth);

    std::cout << val << " " << total_calls << " " << max_depth << "\n";
    return 0;
}
