#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include "trace_logger.hpp"

const long long INF = 1e18;

struct Edge {
    int to;
    long long weight;
};

int main() {
    int n, m;
    if (!(std::cin >> n >> m)) return 0;

    std::vector<std::vector<Edge>> adj(n + 1);
    for (int i = 0; i < m; ++i) {
        int u, v;
        long long w;
        std::cin >> u >> v >> w;
        adj[u].push_back({v, w});
    }

    TRACE_STEP(1, "Read inputs and graph");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);

    std::vector<long long> dist(n + 1, INF);
    std::vector<int> parent(n + 1, -1);
    std::vector<int> edge_cnt(n + 1, 0);

    // Min-heap storing pair<distance, vertex>
    std::priority_queue<std::pair<long long, int>, 
                        std::vector<std::pair<long long, int>>, 
                        std::greater<std::pair<long long, int>>> pq;

    dist[1] = 0;
    pq.push({0, 1});

#ifdef ENABLE_TRACE
    int step_num = 0;
#endif
    while (!pq.empty()) {
        auto top = pq.top();
        pq.pop();
        long long d = top.first;
        int u = top.second;

        if (d > dist[u]) continue;

#ifdef ENABLE_TRACE
        step_num++;
#endif
        TRACE_STEP(10 + step_num, "Extract min vertex u");
        TRACE_VAR("u", u);
        TRACE_VAR("d", d);

        for (const auto& edge : adj[u]) {
            int v = edge.to;
            long long w = edge.weight;
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                parent[v] = u;
                edge_cnt[v] = edge_cnt[u] + 1;
                pq.push({dist[v], v});

                TRACE_STEP(100 + step_num, "Relax edge u -> v");
                TRACE_VAR("v", v);
                TRACE_VAR("new_dist", dist[v]);
                TRACE_VAR("parent", parent[v]);
            }
        }
    }

    if (dist[n] == INF) {
        TRACE_STEP(999, "Destination unreachable");
        std::cout << "-1\n";
    } else {
        TRACE_STEP(999, "Shortest path to n found");
        TRACE_VAR("shortest_dist", dist[n]);
        TRACE_VAR("edge_count", edge_cnt[n]);
        TRACE_VAR("parent_n", parent[n]);
        std::cout << dist[n] << " " << edge_cnt[n] << " " << parent[n] << "\n";
    }

    return 0;
}
