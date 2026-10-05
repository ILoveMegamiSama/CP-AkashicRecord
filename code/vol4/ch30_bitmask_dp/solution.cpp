#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

static const long long INF = 1e15;

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<std::vector<long long>> cost(n, std::vector<long long>(n));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            std::cin >> cost[i][j];
        }
    }

    TRACE_STEP(1, "Read input matrix N");
    TRACE_VAR("n", n);

    int total_masks = 1 << n;
    std::vector<std::vector<long long>> dp(total_masks, std::vector<long long>(n, INF));

    dp[1][0] = 0; // mask = 1 (vertex 0 visited), current node 0

    for (int mask = 1; mask < total_masks; ++mask) {
        for (int u = 0; u < n; ++u) {
            if (dp[mask][u] >= INF) continue;

            for (int v = 0; v < n; ++v) {
                if (!((mask >> v) & 1)) {
                    int next_mask = mask | (1 << v);
                    long long next_cost = dp[mask][u] + cost[u][v];
                    if (next_cost < dp[next_mask][v]) {
                        dp[next_mask][v] = next_cost;
                    }
                }
            }
        }
    }

    int all_mask = total_masks - 1;
    long long min_path = INF;
    long long min_tsp = INF;

    for (int u = 0; u < n; ++u) {
        if (dp[all_mask][u] < min_path) {
            min_path = dp[all_mask][u];
        }
        if (dp[all_mask][u] + cost[u][0] < min_tsp) {
            min_tsp = dp[all_mask][u] + cost[u][0];
        }
    }

    TRACE_STEP(2, "Bitmask DP completed");
    TRACE_VAR("min_path", min_path);
    TRACE_VAR("min_tsp", min_tsp);

    std::cout << min_path << " " << min_tsp << "\n";
    return 0;
}
