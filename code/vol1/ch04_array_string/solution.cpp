#include <iostream>
#include <vector>
#include <string>
#include "trace_logger.hpp"

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<int> a(n);
    long long sum = 0;
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
        sum += a[i];
    }
    std::string s;
    std::cin >> s;

    TRACE_STEP(1, "Array loaded");
    TRACE_ARRAY("a", a.data(), a.size());
    TRACE_VAR("sum", sum);

    double avg = static_cast<double>(sum) / n;
    TRACE_VAR("avg", avg);

    int count_above = 0;
    for (int i = 0; i < n; ++i) {
        if (a[i] > avg) count_above++;
    }
    TRACE_VAR("count_above", count_above);

    bool is_pal = true;
    int len = static_cast<int>(s.size());
    for (int i = 0; i < len / 2; ++i) {
        if (s[i] != s[len - 1 - i]) {
            is_pal = false;
            break;
        }
    }
    TRACE_STEP(2, "Palindrome checked");
    TRACE_VAR("is_pal", is_pal);

    std::cout << count_above << " " << (is_pal ? "YES" : "NO") << "\n";
    return 0;
}
