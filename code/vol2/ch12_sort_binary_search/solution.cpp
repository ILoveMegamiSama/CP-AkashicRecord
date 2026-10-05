#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>
#include "trace_logger.hpp"

bool check(long long mid, const std::vector<long long>& a, int k) {
    int segments = 1;
    long long current_sum = 0;
    for (size_t i = 0; i < a.size(); ++i) {
        if (a[i] > mid) return false;
        if (current_sum + a[i] > mid) {
            segments++;
            current_sum = a[i];
        } else {
            current_sum += a[i];
        }
    }
    return segments <= k;
}

int main() {
    int n, k;
    if (!(std::cin >> n >> k)) return 0;

    std::vector<long long> a(n);
    long long max_val = 0;
    long long sum_val = 0;
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
        max_val = std::max(max_val, a[i]);
        sum_val += a[i];
    }

    TRACE_STEP(1, "Read inputs and compute search bounds");
    TRACE_VAR("n", n);
    TRACE_VAR("k", k);
    TRACE_ARRAY("a", a, n);
    TRACE_VAR("low_initial", max_val);
    TRACE_VAR("high_initial", sum_val);

    long long low = max_val;
    long long high = sum_val;
    long long ans = sum_val;
    int check_count = 0;
    int iter = 0;

    while (low <= high) {
        long long mid = low + (high - low) / 2;
        check_count++;
        iter++;
        bool ok = check(mid, a, k);

        TRACE_STEP(10 + iter, "Binary search iteration");
        TRACE_VAR("low", low);
        TRACE_VAR("high", high);
        TRACE_VAR("mid", mid);
        TRACE_VAR("check_ok", ok);

        if (ok) {
            ans = mid;
            high = mid - 1;
            TRACE_STEP(100 + iter, "mid feasible, search lower half");
            TRACE_VAR("new_high", high);
            TRACE_VAR("best_ans", ans);
        } else {
            low = mid + 1;
            TRACE_STEP(200 + iter, "mid infeasible, search upper half");
            TRACE_VAR("new_low", low);
        }
    }

    TRACE_STEP(999, "Binary search finished");
    TRACE_VAR("ans", ans);
    TRACE_VAR("check_count", check_count);

    std::cout << ans << " " << check_count << "\n";
    return 0;
}
