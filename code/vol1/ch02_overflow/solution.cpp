#include <iostream>
#include <cstdlib>
#include "trace_logger.hpp"

int main() {
    long long a, b, threshold;
    if (!(std::cin >> a >> b >> threshold)) return 0;

    TRACE_STEP(1, "Read inputs a, b, threshold");
    TRACE_VAR("a", a);
    TRACE_VAR("b", b);
    TRACE_VAR("threshold", threshold);

    long long prod = static_cast<long long>(a) * b;
    TRACE_STEP(2, "Compute static_cast<long long>(a) * b");
    TRACE_VAR("prod", prod);

    long long abs_prod = (prod < 0) ? -prod : prod;
    TRACE_VAR("abs_prod", abs_prod);

    if (abs_prod > threshold) {
        TRACE_STEP(3, "abs_prod exceeds threshold: OVERFLOW");
        std::cout << "OVERFLOW " << prod << "\n";
    } else {
        TRACE_STEP(3, "abs_prod within threshold: SAFE");
        std::cout << "SAFE " << prod << "\n";
    }
    return 0;
}
