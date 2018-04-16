/* http://www.dtic.mil/dtic/tr/fulltext/u2/a066739.pdf */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double rand01() {
    // shit
    return (double)rand() / RAND_MAX;
}

void rand_sorted(double *a, size_t n) {
    double lncurmax = 0.0;
    for (size_t i = n; i >= 1; i--) {
        lncurmax = lncurmax + log(rand01()) / i;
        a[i - 1] = exp(lncurmax);
    }
}

int main() {
    // shit too
    srand(time(NULL));
    const size_t n = 100;
    double a[n];
    rand_sorted(a, n);
    for (size_t i = 0; i < n; i++)
        printf("%lf\n", a[i]);
    return 0;
}

