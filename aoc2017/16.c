#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#define N 16
char movestr[1000000];
struct move {
    uint64_t (*f)(uint64_t, size_t, size_t);
    size_t i, j;
};
struct move moves[1000000];
size_t nmoves;

uint64_t spin(uint64_t x, size_t i, size_t j) {
    uint64_t mask = (1ull<<(i*4))-1;
    return ((x & ~mask) >> (i*4)) | ((x & mask) << ((N-i)*4));
}

uint64_t exchange(uint64_t x, size_t i, size_t j) {
    i = N - 1 - i;
    j = N - 1 - j;
    uint64_t mask = 0xfull<<(i*4) | 0xfull<<(j*4);
    uint64_t xi = x >> (i*4) & 0xf;
    uint64_t xj = x >> (j*4) & 0xf;
    return (x & ~mask) | (xi << (j*4)) | (xj << (i*4));
}

uint64_t partner(uint64_t x, size_t i, size_t j) {
    for (size_t k = 0; k < N; k++) {
        if (((x>>(k*4))&0xf) == (i&0xf)) {
            i = N - 1 - k;
            break;
        }
    }
    for (size_t k = 0; k < N; k++) {
        if (((x>>(k*4))&0xf) == (j&0xf)) {
            j = N - 1 - k;
            break;
        }
    }
    return exchange(x, i, j);
}

struct move parsemove(char *m) {
    char *slash;
    if (m[0] == 's')
        return (struct move){.f=spin, .i=atoi(m+1)};
    if (m[0] == 'x') {
        slash = strchr(m, '/');
        *slash = '\0';
        return (struct move){.f=exchange, .i=atoi(m+1), .j=atoi(slash+1)};
    }
    return (struct move){.f=partner, .i=m[1]-'a', .j=m[3]-'a'};
}

void print(uint64_t x) {
    for (int k = N - 1; k >= 0; k--)
        printf("%c", (char)((x>>(k*4)&0xf)+'a'));
    printf("\n");
}

uint64_t dance(uint64_t x) {
    for (size_t i = 0; i < nmoves; i++)
        x = moves[i].f(x, moves[i].i, moves[i].j);
    return x;
}

int main() {
    scanf("%s", movestr);
    char *tok = strtok(movestr, ",");
    while (tok) {
        moves[nmoves++] = parsemove(tok);
        tok = strtok(NULL, ",");
    }
    uint64_t x = 0;
    for (size_t i = 0; i < N; i++)
        x = (x<<4) | (i&0xf);
    print(dance(x));
    uint64_t t = x;
    size_t period = 0;
    do {
        t = dance(t);
        period++;
    } while (t != x);
    size_t times = 1000000000ull % period;
    while (times--)
        x = dance(x);
    print(x);
    return 0;
}
