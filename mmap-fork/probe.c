#include <uapi/linux/ptrace.h>
#include <linux/sched.h>

#define DATA_COMMON \
    u32 tgid; \
    u32 pid; \
    char comm[TASK_COMM_LEN]

#define FILL_DATA_COMMON(dat) \
    u64 pidtgid = bpf_get_current_pid_tgid(); \
    (dat).tgid = pidtgid >> 32; \
    (dat).pid = pidtgid; \
    bpf_get_current_comm(&(dat).comm, sizeof((dat).comm))

struct data {
    DATA_COMMON;
    int is_ret;
    unsigned long ret;
    long pages;
    int cap_sys_admin;
};

BPF_PERF_OUTPUT(events);

int enter(struct pt_regs *ctx, struct mm_struct *mm, long pages, int cap_sys_admin)
{
    struct data dat = {0};
    FILL_DATA_COMMON(dat);
    dat.is_ret = 0;
    dat.pages = pages;
    dat.cap_sys_admin = cap_sys_admin;
    events.perf_submit(ctx, &dat, sizeof(dat));
    return 0;
}

int leave(struct pt_regs *ctx)
{
    struct data dat = {0};
    FILL_DATA_COMMON(dat);
    dat.is_ret = 1;
    dat.ret = regs_return_value(ctx);
    events.perf_submit(ctx, &dat, sizeof(dat));
    return 0;
}
