#include <iostream>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    int a[16];
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
    }

    int* ptr = a;
    TRACE_STEP(1, "Array loaded via pointer base");
    TRACE_ARRAY("a", ptr, n);

    int min_val = *ptr;
    int max_val = *ptr;
    int min_idx = 0;
    int max_idx = 0;

    for (int i = 1; i < n; ++i) {
        int val = *(ptr + i);
        if (val < min_val) {
            min_val = val;
            min_idx = i;
        }
        if (val > max_val) {
            max_val = val;
            max_idx = i;
        }
        TRACE_STEP(i + 1, "Pointer scan step");
        TRACE_VAR("val", val);
        TRACE_VAR("min_val", min_val);
        TRACE_VAR("max_val", max_val);
    }

    int offset = max_idx - min_idx;
    TRACE_STEP(n + 1, "Result computed");
    TRACE_VAR("offset", offset);

    std::cout << min_val << " " << max_val << " " << offset << "\n";
    return 0;
}
