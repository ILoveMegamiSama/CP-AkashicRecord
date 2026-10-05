#include <iostream>
#include <set>
#include <map>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::set<int> s;
    std::map<int, int> freq;

    TRACE_STEP(1, "Initialize set and map");
    TRACE_VAR("n", n);

    for (int q = 0; q < n; ++q) {
        int type, x;
        std::cin >> type >> x;

        TRACE_STEP(10 + q, "Process query");
        TRACE_VAR("type", type);
        TRACE_VAR("x", x);

        if (type == 1) {
            s.insert(x);
            freq[x]++;
            TRACE_STEP(100 + q, "Inserted into set and increased frequency");
            TRACE_VAR("set_size", static_cast<long long>(s.size()));
            TRACE_VAR("freq_x", freq[x]);
        } else if (type == 2) {
            auto it = s.lower_bound(x);
            int ans = (it != s.end()) ? *it : -1;
            TRACE_STEP(200 + q, "Queried lower_bound(x)");
            TRACE_VAR("lb_res", ans);
            std::cout << ans << "\n";
        }
    }

    if (s.empty()) {
        TRACE_STEP(999, "Set is empty");
        std::cout << "0 0\n";
    } else {
        int best_val = s.empty() ? 0 : *s.begin();
        int max_count = 0;
        for (const auto& kv : freq) {
            if (kv.second > max_count) {
                max_count = kv.second;
                best_val = kv.first;
            }
        }
        TRACE_STEP(999, "Finished query stream");
        TRACE_VAR("distinct_count", static_cast<long long>(s.size()));
        TRACE_VAR("max_freq_val", best_val);
        TRACE_VAR("max_count", max_count);

        std::cout << s.size() << " " << best_val << "\n";
    }

    return 0;
}
