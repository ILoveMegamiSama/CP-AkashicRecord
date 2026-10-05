#include <iostream>
#include <string>
#include <vector>
#include "trace_logger.hpp"

static const long long BASE = 31;
static const long long MOD = 1000000007;

int main() {
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    std::string s, p;
    if (!(std::cin >> s >> p)) return 0;

    int q_l, q_r;
    if (!(std::cin >> q_l >> q_r)) return 0;

    int n = (int)s.size();
    int m = (int)p.size();

    TRACE_STEP(1, "Read inputs S, P and interval [L, R]");
    TRACE_VAR("n", n);
    TRACE_VAR("m", m);
    TRACE_VAR("q_l", q_l);
    TRACE_VAR("q_r", q_r);

    std::vector<long long> power(n + 1, 1);
    for (int i = 1; i <= n; ++i) {
        power[i] = (power[i - 1] * BASE) % MOD;
    }

    std::vector<long long> h(n + 1, 0);
    for (int i = 1; i <= n; ++i) {
        h[i] = (h[i - 1] * BASE + (s[i - 1] - 'a' + 1)) % MOD;
    }

    auto get_hash = [&](int l, int r) -> long long {
        long long res = (h[r] - h[l - 1] * power[r - l + 1]) % MOD;
        if (res < 0) res += MOD;
        return res;
    };

    // Pattern P hash
    long long p_hash = 0;
    for (char c : p) {
        p_hash = (p_hash * BASE + (c - 'a' + 1)) % MOD;
    }

    int occ_count = 0;
    int first_pos = -1;

    for (int i = 1; i <= n - m + 1; ++i) {
        if (get_hash(i, i + m - 1) == p_hash) {
            occ_count++;
            if (first_pos == -1) {
                first_pos = i;
            }
        }
    }

    TRACE_STEP(2, "Rabin-Karp search completed");
    TRACE_VAR("occ_count", occ_count);
    TRACE_VAR("first_pos", first_pos);

    // Reverse hash for palindrome check
    std::string rev_s = s;
    for (int i = 0; i < n / 2; ++i) {
        std::swap(rev_s[i], rev_s[n - 1 - i]);
    }

    std::vector<long long> rev_h(n + 1, 0);
    for (int i = 1; i <= n; ++i) {
        rev_h[i] = (rev_h[i - 1] * BASE + (rev_s[i - 1] - 'a' + 1)) % MOD;
    }

    auto get_rev_hash = [&](int l, int r) -> long long {
        long long res = (rev_h[r] - rev_h[l - 1] * power[r - l + 1]) % MOD;
        if (res < 0) res += MOD;
        return res;
    };

    int rev_l = n - q_r + 1;
    int rev_r = n - q_l + 1;

    int is_pal = 0;
    if (q_l >= 1 && q_r <= n && q_l <= q_r) {
        long long fwd = get_hash(q_l, q_r);
        long long bwd = get_rev_hash(rev_l, rev_r);
        if (fwd == bwd) {
            is_pal = 1;
        }
    }

    TRACE_STEP(3, "Palindrome check completed");
    TRACE_VAR("is_pal", is_pal);

    std::cout << occ_count << " " << first_pos << " " << is_pal << "\n";
    return 0;
}
