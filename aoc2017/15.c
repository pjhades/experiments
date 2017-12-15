#include <stdio.h>
#include <stdint.h>

int64_t fa = 16807;
int64_t fb = 48271;
int64_t mod = 2147483647;
int64_t mask = (1 << 16) - 1;
size_t pairs1 = 40000000;
size_t pairs2 = 5000000;

size_t part1(int64_t a, int64_t b) {
    size_t count = 0;
    for (size_t i = 0; i < pairs1; i++) {
        a = a * fa % mod;
        b = b * fb % mod;
        count += (a & mask) == (b & mask) ? 1 : 0;
    }
    return count;
}

size_t part2(int64_t a, int64_t b) {
    size_t count = 0;
    for (size_t i = 0; i < pairs2; i++) {
        do { a = a * fa % mod; } while (a % 4 != 0);
        do { b = b * fb % mod; } while (b % 8 != 0);
        count += (a & mask) == (b & mask) ? 1 : 0;
    }
    return count;
}

int main() {
    int64_t a, b;
    scanf("%lld%lld", &a, &b);
    printf("%lu\n", part1(a, b));
    printf("%lu\n", part2(a, b));

    return 0;
}
