#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

int n;
std::vector<std::vector<int>> adj;
std::vector<int> subtree_sz;
std::vector<int> depth;
std::vector<int> parent_node;
int farthest_node = 1;
int max_dist = 0;

void dfs_farthest(int u, int p, int d) {
    if (d > max_dist) {
        max_dist = d;
        farthest_node = u;
    }
    for (int v : adj[u]) {
        if (v != p) {
            dfs_farthest(v, u, d + 1);
        }
    }
}

void dfs_tree(int u, int p, int d) {
    depth[u] = d;
    parent_node[u] = p;
    subtree_sz[u] = 1;
    for (int v : adj[u]) {
        if (v != p) {
            dfs_tree(v, u, d + 1);
            subtree_sz[u] += subtree_sz[v];
        }
    }
}

int main() {
    if (!(std::cin >> n)) return 0;

    adj.assign(n + 1, std::vector<int>());
    subtree_sz.assign(n + 1, 0);
    depth.assign(n + 1, 0);
    parent_node.assign(n + 1, 0);

    for (int i = 0; i < n - 1; ++i) {
        int u, v;
        std::cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    TRACE_STEP(1, "Read inputs and tree adjacency list");
    TRACE_VAR("n", n);

    if (n == 1) {
        TRACE_STEP(2, "Single node tree");
        std::cout << "0 0 1 0\n";
        return 0;
    }

    // 1. Two-pass DFS for Diameter
    max_dist = -1;
    dfs_farthest(1, 0, 0);
    int node_a = farthest_node;
    TRACE_STEP(2, "First DFS finished");
    TRACE_VAR("node_a", node_a);

    max_dist = -1;
    dfs_farthest(node_a, 0, 0);
    int diameter = max_dist;
    int node_b = farthest_node;
    TRACE_STEP(3, "Second DFS finished");
    TRACE_VAR("node_b", node_b);
    TRACE_VAR("diameter", diameter);

    // 2. Rooted DFS from node 1
    dfs_tree(1, 0, 0);

    int max_depth_val = 0;
    int leaf_count = 0;
    for (int i = 1; i <= n; ++i) {
        max_depth_val = std::max(max_depth_val, depth[i]);
        // leaf is any node != 1 with degree 1
        if (adj[i].size() == 1 && i != 1) {
            leaf_count++;
        }
    }

    int max_child_sz = 0;
    for (int v : adj[1]) {
        max_child_sz = std::max(max_child_sz, subtree_sz[v]);
    }

    TRACE_STEP(4, "Tree metrics calculated");
    TRACE_VAR("diameter", diameter);
    TRACE_VAR("max_depth", max_depth_val);
    TRACE_VAR("leaf_count", leaf_count);
    TRACE_VAR("max_child_subtree_size", max_child_sz);

    std::cout << diameter << " " << max_depth_val << " " << leaf_count << " " << max_child_sz << "\n";
    return 0;
}
