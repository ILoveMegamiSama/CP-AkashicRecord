#include <iostream>
#include "trace_logger.hpp"

int main() {
    int a, b;
    if (!(std::cin >> a >> b)) return 0;

    TRACE_STEP(1, "Read inputs a and b");
    TRACE_VAR("a", a);
    TRACE_VAR("b", b);

    int sum = a + b;
    TRACE_STEP(2, "Calculate sum = a + b");
    TRACE_VAR("sum", sum);

    int temp = a;
    TRACE_STEP(3, "Assign temp = a");
    TRACE_VAR("temp", temp);

    a = b;
    TRACE_STEP(4, "Assign a = b");
    TRACE_VAR("a", a);

    b = temp;
    TRACE_STEP(5, "Assign b = temp");
    TRACE_VAR("b", b);

    std::cout << a << " " << b << " " << sum << "\n";
    return 0;
}
