#include <stdio.h>
#include <stdlib.h>

#define MAX 1000

struct segment {
    int base;
    int start, end;
} v1[MAX], v2[MAX], h1[MAX], h2[MAX];

struct step {
    char dir;
    int dis;
} s1[MAX], s2[MAX];

size_t nv1, nv2, nh1, nh2, ns1, ns2;

int cmp(const void *a, const void *b)
{
    return ((struct segment *)a)->base - ((struct segment *)b)->base;
}

void read_wire(struct segment *v, size_t *nv,
               struct segment *h, size_t *nh,
               struct step *s, size_t *ns)
{
    size_t nrv = 0, nrh = 0, nrs = 0;
    char delim;
    int x = 0, y = 0;
    struct step this;

    while (scanf("%c%d%c", &this.dir, &this.dis, &delim) != EOF) {
        s[nrs++] = this;

        switch (this.dir) {
            case 'R':
                h[nrh++] = (struct segment){y, x, x + this.dis};
                x += this.dis;
                break;
            case 'L':
                h[nrh++] = (struct segment){y, x - this.dis, x};
                x -= this.dis;
                break;
            case 'U':
                v[nrv++] = (struct segment){x, y, y + this.dis};
                y += this.dis;
                break;
            case 'D':
                v[nrv++] = (struct segment){x, y - this.dis, y};
                y -= this.dis;
                break;
        }
        if (delim == '\n')
            break;
    }

    qsort(v, nrv, sizeof(v[0]), cmp);
    qsort(h, nrh, sizeof(h[0]), cmp);

    *nv = nrv;
    *nh = nrh;
    *ns = nrs;
}

size_t walk(int tx, int ty, struct step *s, size_t ns) {
    int x = 0, y = 0;
    size_t count = 0;

    for (size_t i = 0; i < ns; i++) {
        switch (s[i].dir) {
            case 'R':
                if (y == ty && x < tx && tx < x + s[i].dis)
                    return count + tx - x;
                x += s[i].dis;
                break;
            case 'L':
                if (y == ty && x - s[i].dis < tx && tx < x)
                    return count + x - tx;
                x -= s[i].dis;
                break;
            case 'U':
                if (x == tx && y < ty && ty < y + s[i].dis)
                    return count + ty - y;
                y += s[i].dis;
                break;
            case 'D':
                if (x == tx && y - s[i].dis < ty && ty < y)
                    return count + y - ty;
                y -= s[i].dis;
                break;
        }
        count += s[i].dis;
    }

    return count;
}

size_t find_intersection(struct segment *v, size_t nv,
                         struct segment *h, size_t nh,
                         int question)
{
    size_t dist, min = 999999;

    for (size_t i = 0; i < nv; i++) {
        for (size_t j = 0; j < nh; j++) {
            if (h[j].base < v[i].start)
                continue;
            if (h[j].base > v[i].end)
                break;
            if (h[j].start < v[i].base && v[i].base < h[j].end) {
                if (question == 1) {
                    dist = abs(v[i].base) + abs(h[j].base);
                    if (dist < min)
                        min = dist;
                }
                else {
                    dist = walk(v[i].base, h[j].base, s1, ns1) + walk(v[i].base, h[j].base, s2, ns2);
                    if (dist < min)
                        min = dist;
                }
            }
        }
    }

    return min;
}

int main(void)
{
    size_t answer1, answer2;

    read_wire(v1, &nv1, h1, &nh1, s1, &ns1);
    read_wire(v2, &nv2, h2, &nh2, s2, &ns2);

    answer1 = find_intersection(v1, nv1, h2, nh2, 1);
    answer2 = find_intersection(v2, nv2, h1, nh1, 1);

    printf("%lu\n", answer1 < answer2 ? answer1 : answer2);

    answer1 = find_intersection(v1, nv1, h2, nh2, 2);
    answer2 = find_intersection(v2, nv2, h1, nh1, 2);

    printf("%lu\n", answer1 < answer2 ? answer1 : answer2);

    return 0;
}
