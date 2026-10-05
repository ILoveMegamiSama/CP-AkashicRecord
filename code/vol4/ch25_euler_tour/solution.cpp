#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

static int timer_cnt = 0;
static std::vector<int> tin, tout;
static std::vector<std::vector<int>> adj;

void dfs(int u, int p) {
    tin[u] = ++timer_cnt;
    for (int v : adj[u]) {
        if (v != p) {
            dfs(v, u);
        }
    }
    tout[u] = timer_cnt;
}

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int n, u1, u2, v2;
    if (!(std::cin >> n >> u1 >> u2 >> v2)) return 0;

    std::vector<long long> w(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> w[i];
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
    timer_cnt = 0;

    TRACE_STEP(1, "Read inputs and graph");
    TRACE_VAR("n", n);
    TRACE_VAR("u1", u1);
    TRACE_VAR("u2", u2);
    TRACE_VAR("v2", v2);

    dfs(1, 0);

    TRACE_STEP(2, "Euler tour completed");
    TRACE_ARRAY("tin", tin, n + 1);
    TRACE_ARRAY("tout", tout, n + 1);

    std::vector<long long> flat_val(n + 1, 0);
    for (int i = 1; i <= n; ++i) {
        flat_val[tin[i]] = w[i];
    }

    std::vector<long long> pref(n + 1, 0);
    for (int i = 1; i <= n; ++i) {
        pref[i] = pref[i - 1] + flat_val[i];
    }

    long long sum_u1 = pref[tout[u1]] - pref[tin[u1] - 1];
    int is_anc = (tin[u2] <= tin[v2] && tout[u2] >= tout[v2]) ? 1 : 0;

    TRACE_STEP(3, "Subtree sum and ancestor query");
    TRACE_VAR("sum_u1", sum_u1);
    TRACE_VAR("is_anc", is_anc);

    std::cout << tin[u1] << " " << tout[u1] << " " << sum_u1 << " " << is_anc << "\n";
    return 0;
}
