#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n, m;
    if (!(std::cin >> n >> m)) return 0;

    std::vector<std::vector<int>> adj(n + 1);
    for (int i = 0; i < m; ++i) {
        int u, v;
        std::cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    TRACE_STEP(1, "Read inputs n, m and adjacency list");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);

    std::vector<int> color(n + 1, -1);
    int comp_count = 0;
    int max_comp_size = 0;
    bool is_bipartite = true;

    for (int start = 1; start <= n; ++start) {
        if (color[start] == -1) {
            comp_count++;
            int current_size = 0;
            color[start] = 0;

            std::queue<int> q;
            q.push(start);

            TRACE_STEP(10 + comp_count, "Start new component BFS");
            TRACE_VAR("start_vertex", start);

            while (!q.empty()) {
                int u = q.front();
                q.pop();
                current_size++;

                for (int v : adj[u]) {
                    if (color[v] == -1) {
                        color[v] = 1 - color[u];
                        q.push(v);
                        TRACE_VAR("colored_vertex", v);
                        TRACE_VAR("assigned_color", color[v]);
                    } else if (color[v] == color[u]) {
                        is_bipartite = false;
                        TRACE_STEP(999, "Conflict found: odd cycle detected");
                        TRACE_VAR("conflict_u", u);
                        TRACE_VAR("conflict_v", v);
                    }
                }
            }

            max_comp_size = std::max(max_comp_size, current_size);
            TRACE_VAR("current_component_size", current_size);
        }
    }

    int bipartite_flag = is_bipartite ? 1 : 0;

    TRACE_STEP(100, "Graph analysis complete");
    TRACE_VAR("comp_count", comp_count);
    TRACE_VAR("max_comp_size", max_comp_size);
    TRACE_VAR("is_bipartite", bipartite_flag);

    std::cout << comp_count << " " << max_comp_size << " " << bipartite_flag << "\n";
    return 0;
}
