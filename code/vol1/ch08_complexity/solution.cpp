#include <iostream>
#include <vector>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<int> a(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
    }

    int ops = 0;
    int inv = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            ops++;
            if (a[i] > a[j]) {
                inv++;
            }
        }
    }

    TRACE_STEP(1, "Counting complete");
    TRACE_VAR("ops", ops);
    TRACE_VAR("inv", inv);

    int est_seconds = 50; // Theoretical projection for N = 10^5 (5*10^9 / 10^8 = 50s)
    std::cout << ops << " " << inv << " " << est_seconds << "\n";
    return 0;
}
