#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

static const int MAX_LOG = 20;
static int timer_cnt = 0;
static std::vector<std::vector<int>> adj;
static std::vector<int> tin, tout, depth;
static std::vector<std::vector<int>> up;

struct FenwickTree {
    int n;
    std::vector<long long> tree;
    FenwickTree(int n) : n(n), tree(n + 1, 0) {}

    void add(int idx, long long delta) {
        for (; idx <= n; idx += idx & (-idx)) {
            tree[idx] += delta;
        }
    }

    long long query(int idx) {
        long long res = 0;
        for (; idx > 0; idx -= idx & (-idx)) {
            res += tree[idx];
        }
        return res;
    }

    long long range_sum(int l, int r) {
        if (l > r) return 0;
        return query(r) - query(l - 1);
    }
};

void dfs(int u, int p, int d) {
    depth[u] = d;
    up[0][u] = p;
    tin[u] = ++timer_cnt;
    for (int v : adj[u]) {
        if (v != p) {
            dfs(v, u, d + 1);
        }
    }
    tout[u] = timer_cnt;
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

    int n, p;
    long long x;
    int q, u_query, v_query;
    if (!(std::cin >> n >> p >> x >> q >> u_query >> v_query)) return 0;

    std::vector<long long> val(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> val[i];
    }

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

    tin.assign(n + 1, 0);
    tout.assign(n + 1, 0);
    depth.assign(n + 1, 0);
    up.assign(MAX_LOG, std::vector<int>(n + 1, 1));
    timer_cnt = 0;

    TRACE_STEP(1, "Read inputs and tree structure");
    TRACE_VAR("n", n);
    TRACE_VAR("p", p);
    TRACE_VAR("x", x);
    TRACE_VAR("q", q);
    TRACE_VAR("u_query", u_query);
    TRACE_VAR("v_query", v_query);

    dfs(1, 1, 1);

    for (int j = 1; j < MAX_LOG; ++j) {
        for (int i = 1; i <= n; ++i) {
            up[j][i] = up[j - 1][up[j - 1][i]];
        }
    }

    TRACE_STEP(2, "Euler tour and binary lifting table constructed");
    TRACE_ARRAY("tin", tin, n + 1);
    TRACE_ARRAY("tout", tout, n + 1);

    FenwickTree bit(n);
    for (int i = 1; i <= n; ++i) {
        bit.add(tin[i], val[i]);
    }

    // Point update: add x to node p
    bit.add(tin[p], x);

    long long s_root = bit.range_sum(tin[1], tout[1]);
    long long s_q = bit.range_sum(tin[q], tout[q]);

    int lca_node = get_lca(u_query, v_query);
    int dist_uv = depth[u_query] + depth[v_query] - 2 * depth[lca_node];

    TRACE_STEP(3, "Subtree sums and LCA query computed");
    TRACE_VAR("s_root", s_root);
    TRACE_VAR("s_q", s_q);
    TRACE_VAR("lca_node", lca_node);
    TRACE_VAR("dist_uv", dist_uv);

    std::cout << s_root << " " << s_q << " " << lca_node << " " << dist_uv << "\n";
    return 0;
}
