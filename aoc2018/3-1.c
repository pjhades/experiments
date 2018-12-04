// With a little basic knowledge of data structures you can do this in O(N*M).
// I do not understand why you only choose your O(N*M*M) brute force.
#include <stdio.h>
#include <stdlib.h>

#define N 2000 // limit on number of edges
#define M 1000 // limit on range of y coordinates

struct edge {
    // x >= 0: left edge, x < 0: right edge
    int id, x, y_lo, y_hi;
} edges[N * 2];
int ys[N * 2], n = 0, covered[N] = {0};

struct segment {
    // x == -1: internal node
    int y_lo, y_hi, x, count, id;
} tree[M * 5];

int comp_y(const void *y1, const void *y2) {
    int p1 = *(const int *)y1,
        p2 = *(const int *)y2;
    return p1 < p2 ? -1 : p1 > p2 ? +1 : 0;
}

int comp_edge(const void *e1, const void *e2) {
    int x1 = abs(((const struct edge *)e1)->x),
        x2 = abs(((const struct edge *)e2)->x);
    return x1 < x2 ? -1 : x1 > x2 ? 1 : 0;
}

int dedup(int *arr, int n) {
    int i = 0, j = 1;
    while (j < n) {
        if (arr[j] != arr[i]) {
            i++;
            arr[i] = arr[j];
        }
        j++;
    }
    return i + 1;
}

void build_tree(int i, int lo, int hi) {
    tree[i].y_lo = ys[lo];
    tree[i].y_hi = ys[hi];
    tree[i].x = -1;
    tree[i].count = 0;
    tree[i].id = -1;
    if (lo + 1 == hi) {
        tree[i].x = -2;
        return;
    }
    int mid = lo + (hi - lo) / 2;
    build_tree(i * 2, lo, mid);
    build_tree(i * 2 + 1, mid, hi);
}

// return 1 if covered, 0 otherwise
int update_tree(int i, int k, int lo, int hi) {
    if (ys[lo] >= edges[k].y_hi || ys[hi] <= edges[k].y_lo)
        return 0;

    if (lo + 1 == hi) {
        int change = 2 * !!(edges[k].x >= 0) - 1, area = 0;
        // part 2
        if (change == 1 && tree[i].count == 0)
            tree[i].id = edges[k].id;
        if (change == -1 && tree[i].count == 1)
            tree[i].id = -1;
        if ((change == 1 && tree[i].count > 0) || (change == -1 && tree[i].count > 1)) {
            covered[edges[k].id - 1] = 1;
            covered[tree[i].id - 1] = 1;
        }

        // part 1
        if (tree[i].count >= 2)
            area = (abs(edges[k].x) - tree[i].x) * (ys[hi] - ys[lo]);
        tree[i].count += change;
        tree[i].x = abs(edges[k].x);
        return area;
    }

    int mid = lo + (hi - lo) / 2;
    if (hi <= mid)
        return update_tree(i * 2, k, lo, hi);
    if (lo >= mid)
        return update_tree(i * 2 + 1, k, lo, hi);
    return update_tree(i * 2, k, lo, mid) +
           update_tree(i * 2 + 1, k, mid, hi);
}

int main() {
    int i, x, y, w, h;
    while (scanf("#%d @ %d,%d: %dx%d\n", &i, &x, &y, &w, &h) != EOF) {
        // left edge
        ys[n] = y;
        edges[n].id = i;
        edges[n].x = x;
        edges[n].y_lo = y;
        edges[n++].y_hi = y + h;
        // right edge
        ys[n] = y + h;
        edges[n].id = i;
        edges[n].x = -(x + w);
        edges[n].y_lo = y;
        edges[n++].y_hi = y + h;
    }
    qsort(edges, n, sizeof(edges[0]), comp_edge);
    qsort(ys, n, sizeof(ys[0]), comp_y);
    int m = dedup(ys, n);
    build_tree(1, 0, m - 1);

    int area = 0;
    for (i = 0; i < n; i++)
        area += update_tree(1, i, 0, m - 1);
    // part 1
    printf("%d\n", area);
    // part 2
    for (i = 0; i < n / 2; i++)
        if (!covered[i])
            break;
    printf("%d\n", i + 1);
    return 0;
}
