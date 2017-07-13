// A simple process model: parent watches its children
// and restart them when they die.

extern crate nix;

use nix::sys::signal::{kill, SigSet, SIGTERM, SIGCHLD};
use nix::sys::signalfd::SignalFd;
use nix::sys::wait::{waitpid, WNOHANG};
use nix::sys::wait::WaitStatus::StillAlive;
use nix::unistd;
use nix::unistd::ForkResult;

fn spawn(mask: &SigSet) {
    match unistd::fork() {
        Ok(ForkResult::Parent { .. }) => (),
        Ok(ForkResult::Child) => { 
            mask.thread_unblock().unwrap();
            unistd::sleep(300);
        }
        Err(e) => panic!("error {}", e),
    }
}

fn main() {
    // Put parent and all children in the same group
    // so that we can easily kill(0, SIGXXX)
    unistd::setpgid(0, 0).unwrap();

    println!("parent {}", unistd::getpid());

    let mut mask = SigSet::empty();
    mask.add(SIGCHLD);
    mask.add(SIGTERM);
    // Note 1: block the signals watched by signalfd
    mask.thread_block().unwrap();

    spawn(&mask);
    spawn(&mask);

    let mut sgfd = SignalFd::new(&mask).unwrap();
    loop {
        if let Some(info) = sgfd.read_signal().unwrap() {
            match info.ssi_signo as i32 {
                nix::libc::SIGCHLD => {
                    println!("SIGCHLD from {}", info.ssi_pid);
                    // Note 2: since SIGCHLD has been blocked,
                    // multiple instances of it might be merged.
                    // So we need to reap all the dead children
                    // and determine how many children do we need
                    // to restart
                    let mut death_toll = 0;
                    loop {
                        let status = waitpid(-1, Some(WNOHANG));
                        if status.is_err() || status.unwrap() == StillAlive {
                            break;
                        }
                        death_toll += 1;
                    }
                    for _ in 0..death_toll {
                        spawn(&mask);
                    }
                }
                nix::libc::SIGTERM => {
                    println!("SIGTERM from {}, kill all", info.ssi_pid);
                    kill(0, SIGTERM).unwrap();
                    break;
                }
                _ => println!("fuck ya")
            }
        }
    }
}
