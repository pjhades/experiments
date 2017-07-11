// Use epoll to watch both signalfd and inotify events.
// Note that there's inconsistencies in the nix document.
// So read the source before using the functions.

extern crate inotify;
extern crate nix;

use inotify::{Inotify, watch_mask};
use nix::sys::epoll::{epoll_create, epoll_ctl, epoll_wait,
                      EpollOp, EpollEvent, EPOLLIN};
use nix::sys::signal::{SigSet, SIGUSR1};
use nix::sys::signalfd::SignalFd;
use nix::unistd;
use std::os::unix::io::AsRawFd;
use std::os::unix::io::RawFd;

fn main() {
    let pid = unistd::getpid();
    println!("pid={}", pid);

    // create epoll loop
    let epfd = epoll_create().unwrap();

    // create signalfd, watch SIGUSR1
    let mut mask = SigSet::empty();
    mask.add(SIGUSR1);
    // mask the watched signals
    mask.thread_block().unwrap();
    let mut sgfd = SignalFd::new(&mask).unwrap();

    // create inotify
    let mut inotify = Inotify::init().unwrap();
    inotify.add_watch("/tmp/x", watch_mask::DELETE |
                                watch_mask::MODIFY |
                                watch_mask::MOVE |
                                watch_mask::OPEN).unwrap();

    // add signalfd and inotify to epoll
    let mut signal_event = EpollEvent::new(EPOLLIN, sgfd.as_raw_fd() as u64);
    epoll_ctl(epfd, EpollOp::EpollCtlAdd, sgfd.as_raw_fd(), &mut signal_event)
        .unwrap();

    let inotify_fd: RawFd;
    unsafe {
        inotify_fd = inotify.fd().to_owned();
        let mut file_event = EpollEvent::new(EPOLLIN, inotify_fd as u64);
        epoll_ctl(epfd, EpollOp::EpollCtlAdd, inotify_fd, &mut file_event)
            .unwrap();
    }

    // wait for events
    let mut revent = [EpollEvent::new(EPOLLIN, 0); 5];
    loop {
        let n_event = epoll_wait(epfd, &mut revent, -1).unwrap();
        println!("{} events", n_event);
        for x in 0..n_event {
            if revent[x].events().contains(EPOLLIN) {
                let fd = revent[x].data() as RawFd;
                if fd == sgfd.as_raw_fd() {
                    if let Some(info) = sgfd.read_signal().unwrap() {
                        println!("sig {}, pid {}",
                                 info.ssi_signo, info.ssi_pid);
                    }
                }
                else if fd == inotify_fd {
                    let mut buf = [0; 1024];
                    for e in inotify.read_events_blocking(&mut buf).unwrap() {
                        println!("{:?}", e.name);
                    }
                }
            }
        }
    }
}
