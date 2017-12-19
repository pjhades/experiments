#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

struct ins {
    void (*f)(size_t id, int64_t *, int64_t *);
    int64_t *op1, *op2;
    int64_t n1, n2;
};

struct ins code[2][100];
int64_t reg[2][26], q[2][10000], freq;
int ip[2], lock[2];
size_t h[2], r[2], count[2], codelen[2];

#define _reg     reg[id]
#define _qo      q[1-id]
#define _q       q[id]
#define _h       h[id]
#define _ro      r[1-id]
#define _r       r[id]
#define _lock    lock[id]
#define _locko   lock[1-id]
#define _count   count[id]
#define _ip      ip[id]
#define _codelen codelen[id]
#define _code    code[id]

// part1
//static inline void snd(size_t id, int64_t *op1, int64_t *op2) { freq = *op1; }
//static inline void rcv(size_t id, int64_t *op1, int64_t *op2) { if (*op1 != 0) _lock = 1; }
// part2
static inline void snd(size_t id, int64_t *op1, int64_t *op2) { _qo[_ro++] = *op1; _locko = 0; _count++; }
static inline void rcv(size_t id, int64_t *op1, int64_t *op2) { if (_h == _r) { _lock = 1; _ip--; } else *op1 = _q[_h++]; }
static inline void set(size_t id, int64_t *op1, int64_t *op2) { *op1 = *op2; }
static inline void add(size_t id, int64_t *op1, int64_t *op2) { *op1 += *op2; }
static inline void mul(size_t id, int64_t *op1, int64_t *op2) { *op1 *= *op2; }
static inline void mod(size_t id, int64_t *op1, int64_t *op2) { *op1 %= *op2; }
static inline void jgz(size_t id, int64_t *op1, int64_t *op2) { if (*op1 > 0) _ip = _ip + *op2 - 1; }

#define OP(k) do { \
    if (islower(op##k[0])) \
        i->op##k = &_reg[op##k[0] - 'a']; \
    else { \
        i->n##k = atoi(op##k); \
        i->op##k = &i->n##k; \
    } \
} while (0)

void parse(size_t id, char *s, struct ins *i) {
    char *name = s, *op1 = s+4, *op2 = NULL;
    *strchr(s, '\n') = '\0';
    s[3] = '\0';
    if ((op2 = strchr(op1, ' '))) *op2++ = '\0';
    if (strcmp(name, "snd") == 0) { i->f = snd; OP(1); return; }
    if (strcmp(name, "rcv") == 0) { i->f = rcv; OP(1); return; }
    if (strcmp(name, "set") == 0) { i->f = set; OP(1); OP(2); return; }
    if (strcmp(name, "add") == 0) { i->f = add; OP(1); OP(2); return; }
    if (strcmp(name, "mul") == 0) { i->f = mul; OP(1); OP(2); return; }
    if (strcmp(name, "mod") == 0) { i->f = mod; OP(1); OP(2); return; }
    if (strcmp(name, "jgz") == 0) { i->f = jgz; OP(1); OP(2); return; }
}

static inline int valid_ip(size_t id) { return _ip >= 0 && _ip < _codelen; }
static inline int alive(size_t id) { return valid_ip(id) && !_lock; }

void run(size_t id) {
    while (alive(id)) {
        struct ins *i = &_code[_ip];
        i->f(id, i->op1, i->op2);
        _ip++;
    }
}

void part2() {
    char s[2][32];
    while (fgets(s[0], 32, stdin)) {
        strcpy(s[1], s[0]);
        for (size_t id = 0; id < 2; id++)
            parse(id, s[id], &_code[_codelen++]);
    }
    for (size_t id = 0; id < 2; id++)
        _reg['p' - 'a'] = id;
    while (alive(0) || alive(1)) {
        run(0);
        run(1);
    }
    printf("%lu\n", count[1]);
}

void part1() {
    char s[32];
    size_t id = 0;
    while (fgets(s, 32, stdin))
        parse(0, s, &_code[_codelen++]);
    while (alive(0))
        run(0);
    printf("%lld\n", freq);
}

int main() {
    //part1();
    part2();
    return 0;
}
