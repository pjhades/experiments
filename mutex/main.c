#include <stdio.h>
#include <stdint.h>
#include <stdatomic.h>
#include <inttypes.h>
#include <threads.h>
#include <err.h>
#include "mutex.h"

#define N_WORKERS 10
#define N_INCREMENT 1000
#define N_REPEAT 1000

uint64_t counter = 0;

int inc_with_custom_mutex(void *arg) {
    struct mutex *mu = arg;
    for (size_t i = 0; i < N_INCREMENT; i++) {
        mutex_lock(mu);
        ++counter;
        mutex_unlock(mu);
    }
    return 0;
}

int inc_with_pthread_mutex(void *arg) {
    mtx_t *mu = arg;
    for (size_t i = 0; i < N_INCREMENT; i++) {
        mtx_lock(mu);
        ++counter;
        mtx_unlock(mu);
    }
    return 0;
}

int inc_without_lock(void *arg) {
    for (size_t i = 0; i < N_INCREMENT; i++)
        ++counter;
    return 0;
}

void do_test(const char *title, thrd_start_t func, void *arg) {
    thrd_t workers[N_WORKERS];
    size_t wrong = 0;

    for (size_t rep = 0; rep < N_REPEAT; rep++) {
        counter = 0;
        for (size_t i = 0; i < N_WORKERS; i++) {
            if (thrd_create(&workers[i], func, arg) != thrd_success)
                errx(1, "fail to create thread");
        }
        for (size_t i = 0; i < N_WORKERS; i++)
            thrd_join(workers[i], NULL);
        if (counter != N_WORKERS * N_INCREMENT)
            wrong++;
    }
    printf("%30s wrong=%zu\n", title, wrong);
}

#define DO_TEST(func, arg) do_test(#func, func, arg)

int main(int argc, char **argv) {
    DO_TEST(inc_without_lock, NULL);

    mtx_t pthread_mu;
    if (mtx_init(&pthread_mu, mtx_plain) != thrd_success)
        errx(1, "fail to create mtx_t");
    DO_TEST(inc_with_pthread_mutex, &pthread_mu);

    struct mutex custom_mu = MUTEX_INITIALIZER;
    DO_TEST(inc_with_custom_mutex, &custom_mu);

    return 0;
}
