#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <sys/stat.h>

char *map_alloc(const size_t len)
{
    char *p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED)
        return NULL;
    memset(p, '$', len);
    return p;
}

char *map_file(const char *file, size_t *len)
{
    char *p = NULL;
    int fd;
    struct stat stat;

    fd = open(file, O_RDWR);
    if (fd == -1)
        return NULL;

    if (fstat(fd, &stat) == -1)
        return NULL;
    p = mmap(NULL, stat.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    if (p == MAP_FAILED)
        return NULL;
    *len = stat.st_size;
    memset(p, '$', *len);
    return p;
}

int main() {
    pid_t pid;
    char *p = NULL;
    size_t len = 2L << 30;

    p = map_alloc(len);
    //p = map_file("temp", &len);

    printf("parent %u\n", getpid());
    fgetc(stdin);
    pid = fork();
    if (pid == -1)
        err(1, "fork");
    if (pid == 0) {
        printf("child %u\n", getpid());
        printf("child terminated\n");
    }
    else {
        waitpid(pid, NULL, 0);
        printf("parent terminated\n");
    }

    return 0;
}
