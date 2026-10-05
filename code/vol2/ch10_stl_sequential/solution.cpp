#include <iostream>
#include <vector>
#include <utility>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<std::pair<int, int>> pts;
    TRACE_STEP(1, "Initialize empty vector of pairs");
    TRACE_VAR("n", n);

    for (int i = 0; i < n; ++i) {
        int x, y;
        std::cin >> x >> y;
        long long sum = static_cast<long long>(x) + y;
        TRACE_STEP(10 + i, "Process input pair (x, y)");
        TRACE_VAR("x", x);
        TRACE_VAR("y", y);
        TRACE_VAR("sum", sum);

        if (sum >= 0) {
            pts.push_back(std::make_pair(x, y));
            TRACE_STEP(100 + i, "Push back pair into vector");
        } else {
            if (!pts.empty()) {
                pts.pop_back();
                TRACE_STEP(200 + i, "Pop back last pair from vector");
            } else {
                TRACE_STEP(300 + i, "Vector already empty, ignore pop");
            }
        }
        TRACE_VAR("current_size", static_cast<long long>(pts.size()));
        TRACE_VAR("current_capacity", static_cast<long long>(pts.capacity()));
    }

    if (pts.empty()) {
        TRACE_STEP(999, "Vector is empty");
        std::cout << "0 0 0\n";
    } else {
        int min_x = pts[0].first;
        int max_y = pts[0].second;
        for (size_t i = 1; i < pts.size(); ++i) {
            min_x = std::min(min_x, pts[i].first);
            max_y = std::max(max_y, pts[i].second);
        }
        TRACE_STEP(999, "Calculated min_x and max_y");
        TRACE_VAR("min_x", min_x);
        TRACE_VAR("max_y", max_y);
        std::cout << pts.size() << " " << min_x << " " << max_y << "\n";
    }

    return 0;
}
