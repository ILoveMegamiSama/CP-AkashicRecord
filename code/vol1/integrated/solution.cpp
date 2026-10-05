#include <iostream>
#include <utility>
#include "trace_logger.hpp"

struct Student {
    int id;
    int score;
    int age;
};

bool compare_students(const Student* a, const Student* b) {
    if (a->score != b->score) return a->score > b->score; // Higher score first
    if (a->age != b->age) return a->age < b->age;         // Younger first
    return a->id < b->id;                                 // Smaller ID first
}

int main() {
    int n;
    if (!(std::cin >> n)) return 0;

    Student arr[16];
    Student* ptrs[16];

    for (int i = 0; i < n; ++i) {
        std::cin >> arr[i].id >> arr[i].score >> arr[i].age;
        ptrs[i] = &arr[i];
    }

    TRACE_STEP(1, "Students initialized and pointers bound");

    int comparisons = 0;
    // Selection sort on pointers
    for (int i = 0; i < n; ++i) {
        int best = i;
        for (int j = i + 1; j < n; ++j) {
            comparisons++;
            if (compare_students(ptrs[j], ptrs[best])) {
                best = j;
            }
        }
        if (best != i) {
            Student* temp = ptrs[i];
            ptrs[i] = ptrs[best];
            ptrs[best] = temp;
        }
    }

    TRACE_STEP(2, "Pointers sorted");
    TRACE_VAR("comparisons", comparisons);

    for (int i = 0; i < n; ++i) {
        std::cout << ptrs[i]->id << (i + 1 == n ? "" : " ");
    }
    std::cout << "\n";

    int top_id = (n > 0) ? ptrs[0]->id : 0;
    int top_score = (n > 0) ? ptrs[0]->score : 0;
    std::cout << top_id << " " << top_score << " " << comparisons << "\n";

    return 0;
}
