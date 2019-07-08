#include <stdio.h>
void dfs(int npush, int npop, char *buf, int k) {
    if (npush == 0 && npop == 0) {
        printf("%.*s\n", k, buf);
        return;
    }
    if (npop > 0 && npop - npush > 0) {
        buf[k] = ')';
        dfs(npush, npop - 1, buf, k + 1);
    }
    if (npush > 0) {
        buf[k] = '(';
        dfs(npush - 1, npop, buf, k + 1);
    }
}
int main() {
    int n;
    scanf("%d", &n);
    char buf[n*2];
    dfs(n, n, buf, 0);
    return 0;
}
