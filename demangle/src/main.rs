// stolen from
// https://github.com/compiler-explorer/tools/blob/main/rust/src/main.rs
use lazy_static::lazy_static;
use regex::Captures;
use regex::Regex;
use rustc_demangle::demangle;
use std::{io, env};
use std::io::BufReader;
use std::fs::File;
use std::io::prelude::*;

fn demangle_line(line: &str) -> String {
    lazy_static! {
        static ref RE: Regex = Regex::new(r"[_a-zA-Z$][_a-zA-Z$0-9.]*").unwrap();
    }

    RE.replace_all(line, |caps: &Captures<'_>| {
        format!("{:#}", demangle(caps.get(0).unwrap().as_str()))
    })
    .to_string()
}

fn demangle_all<R: BufRead>(r: R) {
    for line in r.lines() {
        if let Ok(l) = line {
            println!("{}", demangle_line(&l));
        }
    }
}

fn main() -> std::io::Result<()> {
    let args = env::args();
    if args.len() == 1 {
        demangle_all(io::stdin().lock());
    }
    else {
        let file_count = args.len();
        for arg in args.skip(1) {
            if file_count > 1 {
                println!("demangling {}", arg);
            }
            let file = File::open(arg)?;
            let reader = BufReader::new(file);
            demangle_all(reader);
        }
    }
    Ok(())
}
