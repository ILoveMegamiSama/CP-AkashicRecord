#include <iostream>
#include <vector>
#include "trace_logger.hpp"

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int n, s;
    long long k;
    if (!(std::cin >> n >> s >> k)) return 0;

    std::vector<int> nxt(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> nxt[i];
    }

    std::vector<long long> a(n + 1);
    for (int i = 1; i <= n; ++i) {
        std::cin >> a[i];
    }

    TRACE_STEP(1, "Read inputs n, s, k");
    TRACE_VAR("n", n);
    TRACE_VAR("s", s);
    TRACE_VAR("k", k);

    const int MAX_LOG = 30;
    std::vector<std::vector<int>> up(MAX_LOG, std::vector<int>(n + 1));
    for (int i = 1; i <= n; ++i) {
        up[0][i] = nxt[i];
    }
    for (int j = 1; j < MAX_LOG; ++j) {
        for (int i = 1; i <= n; ++i) {
            up[j][i] = up[j - 1][up[j - 1][i]];
        }
    }

    TRACE_STEP(2, "Construct binary lifting table");

    auto jump = [&](int start_node, long long steps) -> int {
        int cur = start_node;
        for (int j = 0; j < MAX_LOG; ++j) {
            if ((steps >> j) & 1) {
                cur = up[j][cur];
            }
        }
        return cur;
    };

    int dest = jump(s, k);
    int mid = jump(s, k / 2);

    TRACE_STEP(3, "Binary lifting jumps completed");
    TRACE_VAR("dest", dest);
    TRACE_VAR("mid", mid);
    TRACE_VAR("a_dest", a[dest]);

    std::cout << dest << " " << mid << " " << a[dest] << "\n";
    return 0;
}
