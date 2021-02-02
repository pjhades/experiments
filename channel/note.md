# Bug 1
`chan_close` is never called but the threads all think the channel is closed
they all quit so we get stuck in the while loop.

`send = 3` should not happen:

```
(gdb) p *ch
$1 = {mu_send = {val = 0}, mu_recv = {val = 0}, send = 3, recv = 4294967295, n_send_waiters = 0, n_recv_waiters = 0, cap = 0,
  len = 0, head = 0, tail = 0, data = {0x65}}
(gdb) info thread
  Id   Target Id         Frame
* 1    Thread 0x7fd1b4285740 (LWP 18878) "test_chan" do_test_chan (cap=0, to_write=100, n_readers=2,
    reader_func=0x4008c3 <reader>, n_writers=2, writer_func=0x400802 <writer>) at test/test_chan.c:126
(gdb) p n_read
$2 = 19
(gdb) p n_write
$3 = 21
(gdb) p n_total
$4 = 200
```

A scenario of failure:

```
   writer            reader
-- run 1 --       -- run 1 --
lock
                  lock
write
recv 1->0
                  recv 0->1
                  read
send 1->2
(will sleep)
                  send 2->1
                  (will wake)
futex_wait
(EAGAIN)

unlock

-- run 2 --
lock
write
recv 1->0
send 1->2
(will sleep)
futex_wait

                  futex_wake
                  unlock

(woken up..
 but data is
 not read yet,
 send == 2)
 but it exits)

unlock
(very wrong)
```

Reason: futex wakeup actually wakes up another peer.


# Bug 2

```
(gdb) info thread
  Id   Target Id         Frame
  2    Thread 0x7f871abcf700 (LWP 28646) "test_chan" 0x00007f871acc8c89 in syscall () from /lib64/libc.so.6
* 1    Thread 0x7f871b5d7740 (LWP 28567) "test_chan" 0x00007f871b1af017 in pthread_join () from /lib64/libpthread.so.0
(gdb) p msg_count
$1 = {1, 0 <repeats 99999 times>}
(gdb) thread 2
[Switching to thread 2 (Thread 0x7f871abcf700 (LWP 28646))]
#0  0x00007f871acc8c89 in syscall () from /lib64/libc.so.6
(gdb) bt
#0  0x00007f871acc8c89 in syscall () from /lib64/libc.so.6
#1  0x0000000000400e64 in futex_wait (uaddr=0x1b78028, val=0) at src/futex.h:8
#2  0x00000000004013e5 in chan_recv_buf (ch=0x1b78010, data=0x7f871abceef8) at src/chan.c:164
#3  0x0000000000401a87 in chan_recv (ch=0x1b78010, data=0x7f871abceef8) at src/chan.c:347
#4  0x0000000000400951 in reader (arg=0x6d0640 <reader_args>) at test/test_chan.c:83
#5  0x00007f871b1adea5 in start_thread () from /lib64/libpthread.so.0
#6  0x00007f871acce96d in clone () from /lib64/libc.so.6
(gdb) f 2
#2  0x00000000004013e5 in chan_recv_buf (ch=0x1b78010, data=0x7f871abceef8) at src/chan.c:164
warning: Source file is more recent than executable.
164                     futex_wait(&ch->recv, 0);
(gdb) p *ch
$2 = {datap = 0x0, closed = false, mu_send = {val = 0}, mu_recv = {val = 0}, send = 1, recv = 0, n_send_waiters = 0, n_recv_waiters = 0, cap = 1, head = 0, tail = 0, buf = 0x1b78058}
(gdb) p ch->buf[0]
$3 = {readable = false, data = 0x0}
```

Cap 1, 1 reader, 2 writers, each writes 1 message.

Writers quit, but reader is stuck.

`msg_count` shows that 0 is received but 1 is not.

However `ch->buf[0]` shows the data is not readable.

Reason: tail/head wraps around, so that writers/readers claim the same slot at the same time.
