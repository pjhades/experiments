#define _DEFAULT_SOURCE

#include <err.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdatomic.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <linux/io_uring.h>

#define READ_BLOCK_SIZE 4096

struct ring_context {
    int fd;
    struct io_uring_sqe *sqes;
    struct io_uring_cqe *cqes;
    uint32_t *sq_tail;
    uint32_t *sq_mask;
    uint32_t *sq_array;
    uint32_t *cq_head;
    uint32_t *cq_tail;
    uint32_t *cq_mask;
};

void usage() {
    fprintf(stderr, "usage: cat <file>");
    exit(1);
}

int io_uring_setup(uint32_t entries, struct io_uring_params *params) {
    return syscall(__NR_io_uring_setup, entries, params);
}

int io_uring_enter(unsigned int fd, unsigned int to_submit, unsigned int min_complete,
        unsigned int flags, sigset_t *sig) {
    return syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags, sig);
}

int submit_sq(struct ring_context *ctx, int fd, uint8_t *buf) {
    uint32_t tail = *ctx->sq_tail;
    uint32_t index = tail & *ctx->sq_mask;
    struct io_uring_sqe *sqe = &ctx->sqes[index];

    sqe->opcode = IORING_OP_READ;
    sqe->fd = fd;
    // respect file offset, see io_uring_enter(2)
    sqe->off = -1;
    sqe->addr = (__u64)buf;
    sqe->len = READ_BLOCK_SIZE;
    ctx->sq_array[index] = index;
    tail++;
    atomic_store_explicit(ctx->sq_tail, tail, memory_order_release);

    if (io_uring_enter(ctx->fd, 1, 1, IORING_ENTER_GETEVENTS, NULL) < 0) {
        warn("io_uring_enter");
        return -1;
    }

    return 0;
}

int read_cq(struct ring_context *ctx) {
    uint32_t head = atomic_load_explicit(ctx->cq_head, memory_order_acquire);
    if (head == *ctx->cq_tail)
        return -1;

    struct io_uring_cqe *cqe = &ctx->cqes[head & *ctx->cq_mask];
    if (cqe->res < 0) 
        warnx("error from io_uring: %s", strerror(-cqe->res));

    head++;
    atomic_store_explicit(ctx->cq_head, head, memory_order_release);

    return cqe->res;
}

int main(int argc, char **argv) {
    int ret = EXIT_FAILURE;

    if (argc != 2)
        usage();

    struct io_uring_params params = {0};
    params.flags = IORING_SETUP_SUBMIT_ALL | IORING_SETUP_COOP_TASKRUN | IORING_SETUP_SINGLE_ISSUER;
    int ring_fd = io_uring_setup(32, &params);
    if (ring_fd < 0) {
        warn("io_uring_setup");
        goto out;
    }

    size_t sq_size = params.sq_off.array + params.sq_entries * sizeof(uint32_t);
    size_t cq_size = params.cq_off.cqes + params.cq_entries * sizeof(struct io_uring_cqe);

    if (params.features & IORING_FEAT_SINGLE_MMAP) {
        if (sq_size > cq_size)
            cq_size = sq_size;
        sq_size = cq_size;
    }

    uint8_t *sq, *cq;
    sq = mmap(0, sq_size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_SQ_RING);
    if (sq == MAP_FAILED) {
        warn("mmap SQ");
        goto out_close;
    }

    if (params.features & IORING_FEAT_SINGLE_MMAP)
        cq = sq;
    else {
        cq = mmap(0, cq_size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_CQ_RING);
        if (cq == MAP_FAILED) {
            warn("mmap CQ");
            goto out_unmap_sq;
        }
    }

    // map SQEs
    size_t sqes_size = params.sq_entries * sizeof(struct io_uring_sqe);
    struct io_uring_sqe *sqes = mmap(0, sqes_size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_SQES);
    if (sqes == MAP_FAILED) {
        warn("mmap SQEs");
        goto out_unmap_cq;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1)
        err(EXIT_FAILURE, "open");

    struct ring_context ctx = {
        .fd = ring_fd,
        .sqes = sqes,
        .cqes = (struct io_uring_cqe *)(cq + params.cq_off.cqes),
        .sq_tail = (uint32_t *)(sq + params.sq_off.tail),
        .sq_mask = (uint32_t *)(sq + params.sq_off.ring_mask),
        .sq_array = (uint32_t *)(sq + params.sq_off.array),
        .cq_head = (uint32_t *)(cq + params.cq_off.head),
        .cq_tail = (uint32_t *)(cq + params.cq_off.tail),
        .cq_mask = (uint32_t *)(cq + params.cq_off.ring_mask),
    };

    uint8_t buf[READ_BLOCK_SIZE];
    while (1) {
        if (submit_sq(&ctx, fd, buf) < 0)
            goto out_close_file;
        int bytes_read = read_cq(&ctx);
        if (bytes_read < 0)
            goto out_close_file;
        printf("%.*s", bytes_read, buf);
        if (bytes_read < READ_BLOCK_SIZE)
            break;
    }

    ret = EXIT_SUCCESS;

out_close_file:
    close(fd);
out_unmap_cq:
    munmap(cq, cq_size);
out_unmap_sq:
    munmap(sq, sq_size);
out_close:
    close(ring_fd);
out:
    return ret;
}
