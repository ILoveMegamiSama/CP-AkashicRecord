#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include "trace_logger.hpp"

const long long INF = 1e18;
const long long MOD = 1e9 + 7;

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

    TRACE_STEP(1, "Read inputs n, m and graph");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);

    // Phase 1: Dijkstra from node 1
    std::vector<long long> dist(n + 1, INF);
    std::priority_queue<std::pair<long long, int>, 
                        std::vector<std::pair<long long, int>>, 
                        std::greater<std::pair<long long, int>>> pq;

    dist[1] = 0;
    pq.push({0, 1});

    while (!pq.empty()) {
        auto top = pq.top();
        pq.pop();
        long long d = top.first;
        int u = top.second;

        if (d > dist[u]) continue;

        for (const auto& edge : adj[u]) {
            int v = edge.to;
            long long w = edge.weight;
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.push({dist[v], v});
            }
        }
    }

    TRACE_STEP(2, "Dijkstra phase completed");
    TRACE_VAR("dist_n", dist[n]);

    if (dist[n] == INF) {
        TRACE_STEP(999, "Node n unreachable");
        std::cout << "-1\n";
        return 0;
    }

    // Phase 2: Topological DP on Shortest Path DAG
    std::vector<int> reachable_nodes;
    for (int i = 1; i <= n; ++i) {
        if (dist[i] != INF) {
            reachable_nodes.push_back(i);
        }
    }

    std::sort(reachable_nodes.begin(), reachable_nodes.end(), [&](int a, int b) {
        return dist[a] < dist[b];
    });

    std::vector<long long> ways(n + 1, 0);
    std::vector<long long> min_edges(n + 1, INF);
    std::vector<long long> max_edges(n + 1, -INF);

    ways[1] = 1;
    min_edges[1] = 0;
    max_edges[1] = 0;

    int topo_step = 0;
    for (int u : reachable_nodes) {
        topo_step++;
        TRACE_STEP(10 + topo_step, "Process node u in DAG DP");
        TRACE_VAR("u", u);
        TRACE_VAR("dist_u", dist[u]);
        TRACE_VAR("ways_u", ways[u]);

        for (const auto& edge : adj[u]) {
            int v = edge.to;
            long long w = edge.weight;
            if (dist[u] + w == dist[v]) {
                ways[v] = (ways[v] + ways[u]) % MOD;
                min_edges[v] = std::min(min_edges[v], min_edges[u] + 1);
                max_edges[v] = std::max(max_edges[v], max_edges[u] + 1);
            }
        }
    }

    TRACE_STEP(100, "Integrated solution computed");
    TRACE_VAR("min_dist", dist[n]);
    TRACE_VAR("ways", ways[n]);
    TRACE_VAR("min_edges", min_edges[n]);
    TRACE_VAR("max_edges", max_edges[n]);

    std::cout << dist[n] << " " << ways[n] << " " << min_edges[n] << " " << max_edges[n] << "\n";
    return 0;
}
