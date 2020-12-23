#include <stdio.h>

long long next[1000001];
#define DEC(k, max) (long long[]){k - 1, max}[!!(k - 1 < 1)]
#define IN(k, p) (k == p || k == next[p] || k == next[next[p]])

void iter(int count, long long max) {
    long long p3, mx, dst;
    for (long long cur = next[0]; count--; cur = next[cur]) {
        p3 = next[cur];
        next[cur] = next[next[next[p3]]];
        for (mx = max; IN(mx, p3); mx--);
        for (dst = DEC(cur, mx); IN(dst, p3); dst = DEC(dst, mx));
        next[next[next[p3]]] = next[dst];
        next[dst] = p3;
    }
}

void mklist(char *s, long long n) {
    long long pre = 0;
    for (char *c = s; *c != '\0'; c++)
        pre = next[pre] = *c - '0';
    for (long long i = 9; i < n; i++)
        pre = next[pre] = i + 1;
    next[pre] = next[0];
}

int main(int argc, char **argv) {
    char s[10];
    scanf("%s", s);

    mklist(s, 9);
    iter(100, 9);
    for (long long i = next[1]; i != 1; i = next[i])
        printf("%lld", i);
    printf("\n");

    mklist(s, 1000000);
    iter(10000000, 1000000);
    printf("%lld\n", next[1] * next[next[1]]);

    return 0;
}
