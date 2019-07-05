#include <stdio.h>
#define N 1000
#define M 1000

int uf[N*M];
int n, m;
char map[N][M];
int dir[2][2] = {{-1, 0}, {0, -1}};

void u(int x, int y) {
    if (x == y)
        return;
    if (uf[x] < uf[y]) {
        uf[x] += uf[y];
        uf[y] = x;
    }
    else {
        uf[y] += uf[x];
        uf[x] = y;
    }
}

int f(int x) {
    int i, j, k;
    for (i = x; uf[i] >= 0; i = uf[i]);
    for (j = x; j != i;) {
        k = j;
        j = uf[j];
        uf[k] = i;
    }
    return i;
}

int main() {
    scanf("%d%d", &n, &m);
    for (int i = 0; i < n; i++) {
        scanf("%s", &map[i]);
        for (int j = 0; j < m; j++)
            uf[i*m + j] = -1;
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (map[i][j] == '0')
                continue;
            for (int k = 0; k < 2; k++) {
                int ni = i + dir[k][0], nj = j + dir[k][1];
                if (ni < 0 || ni >= n || nj < 0 || nj >= m || map[ni][nj] == '0')
                    continue;
                u(f(i*m+j), f(ni*m+nj));
            }
        }
    }
    int ans = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        if (map[i][j] == '1' && uf[i*m + j] < 0)
            ans++;
    printf("%d\n", ans);
    return 0;
}
