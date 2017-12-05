#include <stdio.h>
#include <assert.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

int n;
pid_t child[2];

void chld(int);

void sa()
{
    struct sigaction sa;
    sa.sa_handler = chld;
    /* This flag only has effects when sigaction() is applied on SIGCHLD.
     *
     * With this flag, dead children will be considered as will be automatically
     * reaped by the kernel instead of becoming a zombie.
     *
     * Also, if the parent waits for its children but there's no zombie,
     * the parent will block until all of its children terminate. By then,
     * the wait call will fail and set errno to ECHILD.
     *
     * Experiment to confirm that:
     *
     *   1. Run this code with SA_NOCLDWAIT. [Two children will be spawned.]
     *   2. Kill one of them.                ["wait end" won't be printed.]
     *   3. Kill the other child.            [The parent continues but the wait call fails.]
     *
     * In kernel 4.6, the function for this check is
     * do_notify_parent() in kernel/signal.c.
     */
    sa.sa_flags = SA_NOCLDWAIT;
    assert(sigaction(SIGCHLD, &sa, NULL) == 0);
}

void chld(int sig)
{
    printf("caught sigchld\n");
    if (waitpid(-1, NULL, 0))
        perror("waitpid");
    n--;
    printf("wait end\n");

    /* Remaining mystery:
     *
     * It seems that the kernel resets SIGCHLD handler to SIG_DFL so that
     * without this sa() call, the parent won't receive the second SIGCHLD.
     * This can be verified by:
     *
     *   cat /proc/<PID>/status | grep Sig
     *
     * Need to figure out:
     *
     *   - If the kernel really resets the signal.
     *   - The logic behind this reset, is it true also for other signals? (not apparently)
     *   - The code that does the reset.
     */
    sa();
}

int main() {
    printf("parent %u\n", getpid());

    for (int i = 0; i < 2; i++) {
        child[i] = fork();
        if (child[i] == 0) {
            printf("child %u\n", getpid());
            while (1);
        }
        n++;
    }

    sa();
    while (n > 0);

    return 0;
}
