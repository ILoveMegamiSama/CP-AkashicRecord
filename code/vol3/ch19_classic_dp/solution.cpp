#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n, W;
    if (!(std::cin >> n >> W)) return 0;

    std::vector<int> w(n + 1);
    std::vector<int> v(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> w[i] >> v[i];
    }

    TRACE_STEP(1, "Read inputs n, W and items");
    TRACE_VAR("n", n);
    TRACE_VAR("W", W);

    std::vector<std::vector<int>> dp(n + 1, std::vector<int>(W + 1, 0));

    for (int i = 1; i <= n; ++i) {
        TRACE_STEP(10 + i, "Process item i");
        TRACE_VAR("item_idx", i);
        TRACE_VAR("weight", w[i]);
        TRACE_VAR("value", v[i]);

        for (int cap = 0; cap <= W; ++cap) {
            dp[i][cap] = dp[i - 1][cap];
            if (cap >= w[i]) {
                dp[i][cap] = std::max(dp[i][cap], dp[i - 1][cap - w[i]] + v[i]);
            }
        }
        TRACE_ARRAY("dp_row", dp[i], W + 1);
    }

    int max_val = dp[n][W];
    int min_weight_used = 0;
    for (int cap = 0; cap <= W; ++cap) {
        if (dp[n][cap] == max_val) {
            min_weight_used = cap;
            break;
        }
    }

    TRACE_STEP(99, "Found optimal Knapsack solution");
    TRACE_VAR("max_value", max_val);
    TRACE_VAR("weight_used", min_weight_used);

    std::cout << max_val << " " << min_weight_used << "\n";
    return 0;
}
