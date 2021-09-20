#!/usr/bin/env python3

import sys
from bcc import BPF
from time import sleep

if len(sys.argv) != 3:
    print(f"usage: ./inject.py <path to executable> <pid>")
    sys.exit(1)

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
bpf.attach_uprobe(name=sys.argv[1], sym="main.say", fn_name="inject", pid=int(sys.argv[2]))
print(f"tracing executable {sys.argv[1]} pid {sys.argv[2]}...")
bpf.trace_print()
