// The assembly code tries to factorize the numbers
// in a range and count the composite numbers in that range.

#include <stdio.h>
#include <stdint.h>
#include <math.h>

int is_prime(int x) {
    if (x == 2) return 1;
    if (x % 2 == 0) return 0;
    int root = sqrt(x);
    for (int d = 3; d <= root; d += 2)
        if (x % d == 0)
            return 0;
    return 1;
}

void part2() {
    size_t prime = 0;
    int lo = 109900, hi = 126900, step = 17;
    for (int i = lo; i < hi; i += step)
        if (is_prime(i))
            prime++;
    printf("%lu\n", (hi - lo) / 17 - prime + 1);
}

void part1() {
    // The number of mul instructions equals to the number
    // of factorization checks, from 2 to 98.
    printf("%d\n", 97 * 97);
}

int main() {
    part1();
    part2();
    return 0;
}
