extern crate libc;

use libc::c_int;

#[link(name = "add")]
extern {
    fn add(a: c_int, b: c_int) -> c_int;
}

fn main() {
    unsafe {
        println!("{}", add(99, 1));
    }
}
