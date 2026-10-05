#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n, m;
    if (!(std::cin >> n >> m)) return 0;

    std::vector<std::vector<int>> adj(n + 1);
    std::vector<int> in_degree(n + 1, 0);

    for (int i = 0; i < m; ++i) {
        int u, v;
        std::cin >> u >> v;
        adj[u].push_back(v);
        in_degree[v]++;
    }

    TRACE_STEP(1, "Read inputs n, m and constructed DAG in-degrees");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);
    TRACE_ARRAY("in_degree", in_degree, n + 1);

    std::priority_queue<int, std::vector<int>, std::greater<int>> pq;
    for (int i = 1; i <= n; ++i) {
        if (in_degree[i] == 0) {
            pq.push(i);
        }
    }

    std::vector<int> topo_order;
    std::vector<int> dp(n + 1, 0);

    int step_cnt = 0;
    while (!pq.empty()) {
        int u = pq.top();
        pq.pop();
        topo_order.push_back(u);
        step_cnt++;

        TRACE_STEP(10 + step_cnt, "Pop vertex in Kahn algorithm");
        TRACE_VAR("popped_vertex", u);

        for (int v : adj[u]) {
            dp[v] = std::max(dp[v], dp[u] + 1);
            in_degree[v]--;
            if (in_degree[v] == 0) {
                pq.push(v);
            }
        }
    }

    if (static_cast<int>(topo_order.size()) < n) {
        TRACE_STEP(999, "Cycle detected, not a DAG");
        std::cout << "-1\n";
        return 0;
    }

    int longest_path = 0;
    for (int i = 1; i <= n; ++i) {
        longest_path = std::max(longest_path, dp[i]);
    }

    TRACE_STEP(100, "Topological sort & DP complete");
    TRACE_VAR("longest_path", longest_path);
    TRACE_ARRAY("topo_order", topo_order, n);

    std::cout << longest_path;
    for (int u : topo_order) {
        std::cout << " " << u;
    }
    std::cout << "\n";
    return 0;
}
