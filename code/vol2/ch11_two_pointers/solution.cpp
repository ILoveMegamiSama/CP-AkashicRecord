#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

int main() {
    int n;
    long long s;
    if (!(std::cin >> n >> s)) return 0;

    std::vector<long long> a(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
    }

    TRACE_STEP(1, "Read inputs n, s and array a");
    TRACE_VAR("n", n);
    TRACE_VAR("s", s);
    TRACE_ARRAY("a", a, n);

    int left = 0;
    long long current_sum = 0;
    int max_len = 0;
    long long total_count = 0;

    for (int right = 0; right < n; ++right) {
        current_sum += a[right];
        TRACE_STEP(10 + right, "Expand right boundary");
        TRACE_VAR("right", right);
        TRACE_VAR("a[right]", a[right]);
        TRACE_VAR("current_sum", current_sum);

        while (current_sum > s && left <= right) {
            current_sum -= a[left];
            TRACE_STEP(100 + left, "Shrink left boundary");
            TRACE_VAR("left_removed", a[left]);
            left++;
            TRACE_VAR("new_left", left);
            TRACE_VAR("current_sum", current_sum);
        }

        if (left <= right && current_sum <= s) {
            int current_len = right - left + 1;
            max_len = std::max(max_len, current_len);
            total_count += current_len;
            TRACE_VAR("valid_window_len", current_len);
            TRACE_VAR("subarrays_ending_at_right", current_len);
        }
    }

    TRACE_STEP(999, "Finished sliding window");
    TRACE_VAR("max_len", max_len);
    TRACE_VAR("total_count", total_count);

    std::cout << max_len << " " << total_count << "\n";
    return 0;
}
