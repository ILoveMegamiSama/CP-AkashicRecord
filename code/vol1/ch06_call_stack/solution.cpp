#include <iostream>
#include "trace_logger.hpp"

int gcd(int a, int b, int depth, int& max_depth) {
    if (depth > max_depth) {
        max_depth = depth;
    }
    TRACE_STEP(depth, "Enter gcd frame");
    TRACE_VAR("a", a);
    TRACE_VAR("b", b);
    TRACE_VAR("depth", depth);

    if (b == 0) {
        TRACE_STEP(depth, "Base case reached");
        return a;
    }
    return gcd(b, a % b, depth + 1, max_depth);
}

int main() {
    int a, b;
    if (!(std::cin >> a >> b)) return 0;

    int max_depth = 0;
    int res = gcd(a, b, 1, max_depth);

    TRACE_STEP(99, "Finished gcd");
    TRACE_VAR("res", res);
    TRACE_VAR("max_depth", max_depth);

    std::cout << res << " " << max_depth << "\n";
    return 0;
}
