#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

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

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int n, p;
    long long v;
    int l, r;
    if (!(std::cin >> n >> p >> v >> l >> r)) return 0;

    std::vector<long long> a(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> a[i];
    }

    TRACE_STEP(1, "Read inputs n, p, v, l, r and array a");
    TRACE_VAR("n", n);
    TRACE_VAR("p", p);
    TRACE_VAR("v", v);
    TRACE_VAR("l", l);
    TRACE_VAR("r", r);

    // Step 1: Count inversions using Fenwick Tree
    std::vector<long long> sorted_vals;
    for (int i = 1; i <= n; ++i) {
        sorted_vals.push_back(a[i]);
    }
    std::sort(sorted_vals.begin(), sorted_vals.end());
    sorted_vals.erase(std::unique(sorted_vals.begin(), sorted_vals.end()), sorted_vals.end());

    auto get_rank = [&](long long val) -> int {
        return (int)(std::lower_bound(sorted_vals.begin(), sorted_vals.end(), val) - sorted_vals.begin()) + 1;
    };

    int max_rank = (int)sorted_vals.size();
    FenwickTree bit_inv(max_rank);
    long long inv_count = 0;

    for (int i = 1; i <= n; ++i) {
        int rk = get_rank(a[i]);
        inv_count += bit_inv.query(max_rank) - bit_inv.query(rk);
        bit_inv.add(rk, 1);
    }

    TRACE_STEP(2, "Count inversions completed");
    TRACE_VAR("inv_count", inv_count);

    // Step 2: Build Fenwick Tree for Range Sum
    FenwickTree bit_sum(n);
    for (int i = 1; i <= n; ++i) {
        bit_sum.add(i, a[i]);
    }

    long long s1 = bit_sum.range_sum(l, r);

    TRACE_STEP(3, "Initial range sum query S1");
    TRACE_VAR("s1", s1);

    // Step 3: Point Update
    bit_sum.add(p, v);

    long long s2 = bit_sum.range_sum(l, r);

    TRACE_STEP(4, "Range sum after point update S2");
    TRACE_VAR("s2", s2);

    std::cout << inv_count << " " << s1 << " " << s2 << "\n";
    return 0;
}
