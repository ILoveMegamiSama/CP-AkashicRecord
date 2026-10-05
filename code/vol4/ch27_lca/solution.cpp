#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

static const int MAX_LOG = 20;
static std::vector<std::vector<int>> adj;
static std::vector<int> depth;
static std::vector<std::vector<int>> up;

void dfs(int u, int p, int d) {
    depth[u] = d;
    up[0][u] = p;
    for (int v : adj[u]) {
        if (v != p) {
            dfs(v, u, d + 1);
        }
    }
}

int get_lca(int u, int v) {
    if (depth[u] < depth[v]) std::swap(u, v);
    int diff = depth[u] - depth[v];
    for (int k = 0; k < MAX_LOG; ++k) {
        if ((diff >> k) & 1) {
            u = up[k][u];
        }
    }
    if (u == v) return u;
    for (int k = MAX_LOG - 1; k >= 0; --k) {
        if (up[k][u] != up[k][v]) {
            u = up[k][u];
            v = up[k][v];
        }
    }
    return up[0][u];
}

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int n, q_u, q_v;
    if (!(std::cin >> n >> q_u >> q_v)) return 0;

    adj.assign(n + 1, std::vector<int>());
    for (int i = 0; i < n - 1; ++i) {
        int u, v;
        std::cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    for (int i = 1; i <= n; ++i) {
        std::sort(adj[i].begin(), adj[i].end());
    }

    depth.assign(n + 1, 0);
    up.assign(MAX_LOG, std::vector<int>(n + 1, 1));

    TRACE_STEP(1, "Read inputs and graph");
    TRACE_VAR("n", n);
    TRACE_VAR("q_u", q_u);
    TRACE_VAR("q_v", q_v);

    dfs(1, 1, 1);

    for (int j = 1; j < MAX_LOG; ++j) {
        for (int i = 1; i <= n; ++i) {
            up[j][i] = up[j - 1][up[j - 1][i]];
        }
    }

    TRACE_STEP(2, "DFS completed and binary lifting table built");
    TRACE_ARRAY("depth", depth, n + 1);

    int lca_node = get_lca(q_u, q_v);
    int dist = depth[q_u] + depth[q_v] - 2 * depth[lca_node];
    int depth_lca = depth[lca_node];

    TRACE_STEP(3, "LCA computed");
    TRACE_VAR("lca", lca_node);
    TRACE_VAR("dist", dist);
    TRACE_VAR("depth_lca", depth_lca);

    std::cout << lca_node << " " << dist << " " << depth_lca << "\n";
    return 0;
}
