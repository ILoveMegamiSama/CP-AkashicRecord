#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include <numeric>
#include "trace_logger.hpp"

bool check_partition(long long mid, const std::vector<long long>& a, int k) {
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
    long long s;
    if (!(std::cin >> n >> s >> k)) return 0;

    std::vector<long long> a(n);
    std::set<long long> uniq_set;
    std::map<long long, int> freq_map;

    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
        uniq_set.insert(a[i]);
        freq_map[a[i]]++;
    }

    TRACE_STEP(1, "Read inputs and populated STL Set and Map");
    TRACE_VAR("n", n);
    TRACE_VAR("s", s);
    TRACE_VAR("k", k);
    TRACE_ARRAY("a", a, n);

    // Phase 1: STL Set & Map statistics
    long long unique_count = uniq_set.size();
    long long max_freq_val = 0;
    int max_freq = 0;
    for (const auto& kv : freq_map) {
        if (kv.second > max_freq) {
            max_freq = kv.second;
            max_freq_val = kv.first;
        }
    }
    TRACE_STEP(2, "Phase 1: Unique count and max frequency value");
    TRACE_VAR("unique_count", unique_count);
    TRACE_VAR("max_freq_val", max_freq_val);

    // Phase 2: Two Pointers on sorted array
    std::vector<long long> b = a;
    std::sort(b.begin(), b.end());
    TRACE_STEP(3, "Phase 2: Sorted array for Two Pointers");
    TRACE_ARRAY("b", b, n);

    long long pair_count = 0;
    int left = 0;
    int right = n - 1;
    while (left < right) {
        if (b[left] + b[right] <= s) {
            pair_count += (right - left);
            TRACE_STEP(100 + left, "Two Pointers: valid pairs found");
            TRACE_VAR("left", left);
            TRACE_VAR("right", right);
            TRACE_VAR("added_pairs", static_cast<long long>(right - left));
            left++;
        } else {
            TRACE_STEP(200 + right, "Two Pointers: sum exceeds s, shrink right");
            right--;
        }
    }
    TRACE_STEP(4, "Phase 2 completed: Total valid pairs");
    TRACE_VAR("pair_count", pair_count);

    // Phase 3: Binary Search on Answer
    long long max_elem = 0;
    long long sum_elem = 0;
    for (int i = 0; i < n; ++i) {
        max_elem = std::max(max_elem, a[i]);
        sum_elem += a[i];
    }

    long long low = max_elem;
    long long high = sum_elem;
    long long min_max_workload = sum_elem;
    int bs_step = 0;

    while (low <= high) {
        long long mid = low + (high - low) / 2;
        bs_step++;
        bool ok = check_partition(mid, a, k);
        TRACE_STEP(300 + bs_step, "Phase 3 BS: check(mid)");
        TRACE_VAR("mid", mid);
        TRACE_VAR("ok", ok);

        if (ok) {
            min_max_workload = mid;
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    TRACE_STEP(5, "Phase 3 completed: Min max workload found");
    TRACE_VAR("min_max_workload", min_max_workload);

    std::cout << unique_count << " " << max_freq_val << " " << pair_count << " " << min_max_workload << "\n";
    return 0;
}
