#include <iostream>
#include <vector>
#include "trace_logger.hpp"

long long compute_gcd(long long a, long long b) {
    long long step = 1;
    while (b != 0) {
        long long r = a % b;
        TRACE_STEP(10 + step, "Euclid step: a % b");
        TRACE_VAR("a", a);
        TRACE_VAR("b", b);
        TRACE_VAR("r", r);
        a = b;
        b = r;
        step++;
    }
    return a;
}

long long power_mod(long long base, long long exp, long long mod) {
    long long res = 1;
    base %= mod;
    long long step = 1;
    while (exp > 0) {
        if (exp & 1) {
            res = (1LL * res * base) % mod;
            TRACE_STEP(20 + step, "Exp odd: multiply res with base");
            TRACE_VAR("res", res);
        }
        base = (1LL * base * base) % mod;
        exp >>= 1;
        TRACE_STEP(30 + step, "Square base and shift exp");
        TRACE_VAR("base", base);
        TRACE_VAR("exp", exp);
        step++;
    }
    return res;
}

int count_primes_sieve(int k) {
    if (k < 2) return 0;
    std::vector<bool> is_prime(k + 1, true);
    is_prime[0] = is_prime[1] = false;
    for (int p = 2; p * p <= k; ++p) {
        if (is_prime[p]) {
            for (int i = p * p; i <= k; i += p) {
                is_prime[i] = false;
            }
        }
    }
    int count = 0;
    for (int p = 2; p <= k; ++p) {
        if (is_prime[p]) count++;
    }
    return count;
}

int main() {
    long long a, b, m;
    int k;
    if (!(std::cin >> a >> b >> m >> k)) return 0;

    TRACE_STEP(1, "Read inputs");
    TRACE_VAR("a", a);
    TRACE_VAR("b", b);
    TRACE_VAR("m", m);
    TRACE_VAR("k", k);

    long long g = compute_gcd(a, b);
    TRACE_STEP(2, "GCD calculated");
    TRACE_VAR("gcd", g);

    long long p_mod = power_mod(a, b, m);
    TRACE_STEP(3, "Power Mod calculated");
    TRACE_VAR("pow_mod", p_mod);

    int primes = count_primes_sieve(k);
    TRACE_STEP(4, "Primes counted");
    TRACE_VAR("primes_count", primes);

    std::cout << g << " " << p_mod << " " << primes << "\n";
    return 0;
}
