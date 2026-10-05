#include <iostream>
#include <vector>
#include <algorithm>
#include <set>
#include "trace_logger.hpp"

int main() {
    int n, m;
    if (!(std::cin >> n >> m)) return 0;

    std::vector<int> deg(n + 1, 0);
    std::vector<std::vector<int>> adj(n + 1);
    bool has_self_loop = false;
    bool has_multi_edge = false;
    std::set<std::pair<int, int>> edge_set;

    TRACE_STEP(1, "Read inputs n, m");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);

    for (int i = 0; i < m; ++i) {
        int u, v;
        std::cin >> u >> v;

        if (u == v) {
            has_self_loop = true;
            deg[u] += 2;
        } else {
            deg[u]++;
            deg[v]++;
            adj[u].push_back(v);
            adj[v].push_back(u);

            int su = std::min(u, v);
            int sv = std::max(u, v);
            if (edge_set.count({su, sv})) {
                has_multi_edge = true;
            } else {
                edge_set.insert({su, sv});
            }
        }
    }

    int max_deg = -1;
    int best_vertex = 1;
    int isolated_count = 0;

    for (int i = 1; i <= n; ++i) {
        if (deg[i] > max_deg) {
            max_deg = deg[i];
            best_vertex = i;
        }
        if (deg[i] == 0) {
            isolated_count++;
        }
    }

    int is_simple = (!has_self_loop && !has_multi_edge) ? 1 : 0;

    TRACE_STEP(2, "Degrees analyzed");
    TRACE_VAR("max_deg", max_deg);
    TRACE_VAR("best_vertex", best_vertex);
    TRACE_VAR("isolated_count", isolated_count);
    TRACE_VAR("is_simple", is_simple);

    std::cout << max_deg << " " << best_vertex << " " << isolated_count << " " << is_simple << "\n";
    return 0;
}
