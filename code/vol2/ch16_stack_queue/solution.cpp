#include <iostream>
#include <vector>
#include <stack>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<long long> a(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
    }

    TRACE_STEP(1, "Read inputs");
    TRACE_VAR("n", n);
    TRACE_ARRAY("a", a, n);

    std::vector<long long> nge(n, -1);
    std::stack<long long> st;

    // Traverse from right to left to find Next Greater Element
    for (int i = n - 1; i >= 0; --i) {
        TRACE_STEP(10 + (n - 1 - i), "Examine element a[i] from right");
        TRACE_VAR("i", i);
        TRACE_VAR("a[i]", a[i]);

        while (!st.empty() && st.top() <= a[i]) {
            TRACE_STEP(100 + (n - 1 - i), "Pop smaller or equal element from stack");
            TRACE_VAR("popped_top", st.top());
            st.pop();
        }

        if (!st.empty()) {
            nge[i] = st.top();
            TRACE_STEP(200 + (n - 1 - i), "Found next greater element on stack top");
            TRACE_VAR("nge[i]", nge[i]);
        } else {
            nge[i] = -1;
            TRACE_STEP(300 + (n - 1 - i), "No greater element on right");
            TRACE_VAR("nge[i]", nge[i]);
        }

        st.push(a[i]);
        TRACE_VAR("pushed_to_stack", a[i]);
    }

    TRACE_STEP(999, "Finished Monotonic Stack scan");
    TRACE_ARRAY("nge", nge, n);

    for (int i = 0; i < n; ++i) {
        if (i > 0) std::cout << " ";
        std::cout << nge[i];
    }
    std::cout << "\n";

    return 0;
}
