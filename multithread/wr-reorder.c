#include <stdio.h>
#include <pthread.h>

int a, b;
int ra, rb;

void *t1(void *arg) {
    a = 1;
    //asm ("mfence");
    ra = b;
    return NULL;
}

void *t2(void *arg) {
    b = 1;
    //asm ("mfence");
    rb = a;
    return NULL;
}

int main() {
    pthread_t tid1, tid2;
    size_t run, times = 100000;

    for (run = 1; run <= times; run++) {
        a = 0;
        b = 0;
        ra = 0;
        rb = 0;

        pthread_create(&tid1, NULL, t1, NULL);
        pthread_create(&tid2, NULL, t2, NULL);

        pthread_join(tid1, NULL);
        pthread_join(tid2, NULL);

        if (ra == 0 && rb == 0)
            printf("run=%zu a=%d b=%d ra=%d rb=%d\n", run, a, b, ra, rb);
    }

    return 0;
}
