#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<long long> c(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> c[i];
    }

    TRACE_STEP(1, "Read inputs n and cost array c");
    TRACE_VAR("n", n);
    TRACE_ARRAY("c", c, n + 1);

    if (n == 1) {
        TRACE_STEP(2, "Base case n = 1");
        TRACE_VAR("min_cost", c[1]);
        TRACE_VAR("ways", 1);
        std::cout << c[1] << " 1\n";
        return 0;
    }

    std::vector<long long> dp(n + 1, 0);
    std::vector<long long> ways(n + 1, 0);

    dp[1] = c[1];
    ways[1] = 1;
    dp[2] = c[2];
    ways[2] = 1;

    TRACE_STEP(2, "Initialize base cases dp[1] and dp[2]");
    TRACE_VAR("dp[1]", dp[1]);
    TRACE_VAR("ways[1]", ways[1]);
    TRACE_VAR("dp[2]", dp[2]);
    TRACE_VAR("ways[2]", ways[2]);

    for (int i = 3; i <= n; ++i) {
        TRACE_STEP(10 + i, "Transition for step i");
        TRACE_VAR("i", i);
        TRACE_VAR("c[i]", c[i]);
        TRACE_VAR("dp[i-1]", dp[i - 1]);
        TRACE_VAR("dp[i-2]", dp[i - 2]);

        if (dp[i - 1] < dp[i - 2]) {
            dp[i] = c[i] + dp[i - 1];
            ways[i] = ways[i - 1];
        } else if (dp[i - 2] < dp[i - 1]) {
            dp[i] = c[i] + dp[i - 2];
            ways[i] = ways[i - 2];
        } else {
            dp[i] = c[i] + dp[i - 1];
            ways[i] = ways[i - 1] + ways[i - 2];
        }

        TRACE_VAR("dp[i]", dp[i]);
        TRACE_VAR("ways[i]", ways[i]);
    }

    TRACE_STEP(99, "Optimal answer reached");
    TRACE_VAR("min_cost", dp[n]);
    TRACE_VAR("ways", ways[n]);

    std::cout << dp[n] << " " << ways[n] << "\n";
    return 0;
}
