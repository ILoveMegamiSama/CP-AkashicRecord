#include <iostream>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    long long n;
    if (!(std::cin >> n)) return 0;

    long long current = n;
    long long max_val = current;
    int steps = 0;

    TRACE_STEP(0, "Initial state");
    TRACE_VAR("current", current);
    TRACE_VAR("max_val", max_val);

    while (current > 1) {
        steps++;
        if (current % 2 == 0) {
            current = current / 2;
        } else {
            current = 3 * current + 1;
        }
        if (current > max_val) {
            max_val = current;
        }
        TRACE_STEP(steps, "Collatz iteration");
        TRACE_VAR("current", current);
        TRACE_VAR("max_val", max_val);
    }

    std::cout << steps << " " << max_val << "\n";
    return 0;
}
