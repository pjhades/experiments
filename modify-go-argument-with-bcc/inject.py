#!/usr/bin/env python3

import sys
from bcc import BPF
from time import sleep

# fetch stack pointer and modify the first argument
code = """
#include <uapi/linux/ptrace.h>
int inject(struct pt_regs *ctx) {
    char s[] = "what?";
    u64 addr = 0;
    u64 *sp = (u64 *)PT_REGS_SP(ctx);
    bpf_probe_read_user(&addr, sizeof(addr), sp + 1);
    bpf_probe_write_user((u64 *)addr, s, sizeof(s));
    return 0;
}
"""

bpf = BPF(text=code)
bpf.attach_uprobe(name="/home/pjhades/code/t/nonsense", sym="main.say", fn_name="inject", pid=int(sys.argv[1]))
print(f"tracing pid {sys.argv[1]}...")
bpf.trace_print()
