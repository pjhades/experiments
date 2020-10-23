#!/usr/bin/env python

import bcc
import ctypes
from bcc import BPF

func = '__vm_enough_memory'
bpf = BPF(src_file='probe.c')
bpf.attach_kprobe(event_re=func, fn_name='enter')
bpf.attach_kretprobe(event_re=func, fn_name='leave')

TASK_COMM_LEN = 16

class Data(ctypes.Structure):
    _fields_ = [
        ('tgid', ctypes.c_uint),
        ('pid', ctypes.c_uint),
        ('comm', ctypes.c_char * TASK_COMM_LEN),
        ('is_ret', ctypes.c_int),
        ('ret', ctypes.c_ulong),
        ('pages', ctypes.c_long),
        ('cap_sys_admin', ctypes.c_int),
    ]

def print_event(cpu, data, size):
    event = ctypes.cast(data, ctypes.POINTER(Data)).contents
    if event.is_ret:
        print('pid %d leaves %s ret=%x' % (event.pid, func, event.ret))
    else:
        print('pid %d enters %s pages=%d cap_sys_admin=%d' % (event.pid, func, event.pages, event.cap_sys_admin))

bpf['events'].open_perf_buffer(print_event)

while True:
    bpf.perf_buffer_poll()
