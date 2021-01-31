/* https://akkadia.org/drepper/futex.pdf */

#define _DEFAULT_SOURCE
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdatomic.h>
#include <sys/time.h>
#include <sys/syscall.h>
#include <linux/futex.h>
#include "mutex.h"

static long futex(uint32_t *uaddr, int futex_op, uint32_t val,
        const struct timespec *timeout,   /* or: uint32_t val2 */
        uint32_t *uaddr2, uint32_t val3)
{
    return syscall(SYS_futex, uaddr, futex_op, val, timeout, uaddr2, val3);
}

void mutex_init(struct mutex *mu) {
    mu->val = 0;
}

void mutex_unlock(struct mutex *mu) {
    uint32_t orig = atomic_fetch_sub_explicit(&mu->val, 1, memory_order_relaxed);
    /* Slow path: there were waiters */
    if (orig != 1) {
        mu->val = 0;
        futex(&mu->val, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}

static uint32_t cmpxchg(uint32_t *ptr, uint32_t expect, uint32_t new) {
    atomic_compare_exchange_strong_explicit(ptr, &expect, new,
        memory_order_relaxed,
        memory_order_relaxed);
    return expect;
}

void mutex_lock(struct mutex *mu) {
    /* Expect mutex is unlocked, try to lock it */
    uint32_t val = cmpxchg(&mu->val, 0, 1);
    if (val != 0) {
        /* Now, mutex is locked */
        do {
            /* 1. There are other waiters, or
             * 2. There is no waiter but we can't claim it yet */
            if (val == 2 || cmpxchg(&mu->val, 1, 2) != 0)
                futex(&mu->val, FUTEX_WAIT, 2, NULL, NULL, 0);
        } while ((val = cmpxchg(&mu->val, 0, 2)) != 0);
    }
}
