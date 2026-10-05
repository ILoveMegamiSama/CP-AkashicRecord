#include <iostream>
#include <vector>
#include <algorithm>
#include <utility>
#include "trace_logger.hpp"

struct Interval {
    long long s, e;
    int id;
};

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<Interval> intervals(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> intervals[i].s >> intervals[i].e;
        intervals[i].id = i + 1;
    }

    TRACE_STEP(1, "Read input intervals");
    TRACE_VAR("n", n);

    // C++14 Generic Lambda for sorting by end time, then start time
    std::sort(intervals.begin(), intervals.end(), [](const auto& a, const auto& b) {
        if (a.e != b.e) return a.e < b.e;
        return a.s < b.s;
    });

    TRACE_STEP(2, "Sorted intervals by earliest finish time");

    long long last_end = -1;
    int max_meetings = 0;
    long long total_duration = 0;

    for (int i = 0; i < n; ++i) {
        long long s = intervals[i].s;
        long long e = intervals[i].e;
        TRACE_STEP(10 + i, "Consider interval (s, e)");
        TRACE_VAR("id", intervals[i].id);
        TRACE_VAR("start", s);
        TRACE_VAR("end", e);
        TRACE_VAR("last_end", last_end);

        if (s >= last_end) {
            max_meetings++;
            total_duration += (e - s);
            last_end = e;
            TRACE_STEP(100 + i, "Compatible: Selected this meeting");
            TRACE_VAR("current_count", max_meetings);
            TRACE_VAR("new_last_end", last_end);
            TRACE_VAR("total_duration", total_duration);
        } else {
            TRACE_STEP(200 + i, "Conflict: Discarded this meeting");
        }
    }

    TRACE_STEP(999, "Greedy activity selection complete");
    TRACE_VAR("max_meetings", max_meetings);
    TRACE_VAR("total_duration", total_duration);

    std::cout << max_meetings << " " << total_duration << "\n";
    return 0;
}
