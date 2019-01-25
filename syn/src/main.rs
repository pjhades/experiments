extern crate syn;

use std::fs::File;
use std::io::Read;
use std::collections::HashMap;
use syn::visit::{self, Visit};

#[derive(Debug)]
struct S {
    callgraph: HashMap<String, String>,
}

impl<'ast> Visit<'ast> for S {
    fn visit_item_fn(&mut self, f: &'ast syn::ItemFn) {
        println!("function: {}", f.ident);
        for stmt in f.block.stmts.iter() {
            match stmt {
                syn::Stmt::Expr(ref expr) => println!("{:?}", expr),
                syn::Stmt::Semi(ref expr, _) => println!("{:?}", expr),
                _ => (),
            }
        }
        visit::visit_item_fn(self, f);
    }

    fn visit_impl_item_method(&mut self, f: &'ast syn::ImplItemMethod) {
        println!("impl method: {}", f.sig.ident);
        visit::visit_impl_item_method(self, f);
    }

    //fn visit_foreign_item_fn;
    //fn visit_trait_item_method;
}

fn main() {
    let mut file = File::open("./src/main.rs").unwrap();
    let mut content = String::new();
    file.read_to_string(&mut content).unwrap();

    let ast = syn::parse_file(&content).unwrap();
    let mut s = S {
        callgraph: HashMap::new(),
    };
    s.visit_file(&ast);
}
