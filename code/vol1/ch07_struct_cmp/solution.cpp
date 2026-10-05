#include <iostream>
#include <vector>
#include <algorithm>
#include "trace_logger.hpp"

struct Point {
    int id;
    int x;
    int y;

    int manhattan() const {
        int ax = (x < 0) ? -x : x;
        int ay = (y < 0) ? -y : y;
        return ax + ay;
    }

    bool operator<(const Point& other) const {
        int d1 = manhattan();
        int d2 = other.manhattan();
        if (d1 != d2) return d1 < d2;
        if (x != other.x) return x < other.x;
        return id < other.id;
    }
};

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    std::vector<Point> pts(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> pts[i].id >> pts[i].x >> pts[i].y;
    }

    TRACE_STEP(1, "Loaded points");
    std::sort(pts.begin(), pts.end());
    TRACE_STEP(2, "Sorted points");

    for (int i = 0; i < n; ++i) {
        TRACE_STEP(i + 3, "Output point");
        TRACE_VAR("id", pts[i].id);
        TRACE_VAR("dist", pts[i].manhattan());
        std::cout << pts[i].id << (i + 1 == n ? "" : " ");
    }
    std::cout << "\n";
    return 0;
}
