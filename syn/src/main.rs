extern crate syn;

use std::fs::File;
use std::io::Read;
use std::collections::HashMap;
use syn::visit::{self, Visit};

#[derive(Debug)]
struct S {
    callgraph: HashMap<String, String>,
}

impl S {
    fn find_fn_calls(&mut self, expr: &syn::Expr) {
        // not work properly
        match expr {
            syn::Expr::Call(ref expr_call) => println!("call: {:?}", expr_call.func),
            // consider chained method calls:
            // ptr.func1().func2().func3()
            // look into the ExprMethodCall.receiver field, where
            // there may be a chain of calls
            syn::Expr::MethodCall(ref method_call) => println!("method call: {:?}", method_call.method),
            _ => (),
        }
    }
}

impl<'ast> Visit<'ast> for S {
    fn visit_item_fn(&mut self, f: &'ast syn::ItemFn) {
        println!("function: {}", f.ident);
        for stmt in f.block.stmts.iter() {
            // need recursively search for function calls in all possible stmt types
            match stmt {
                syn::Stmt::Local(ref local) => 
                syn::Stmt::Item(ref item) |
                syn::Stmt::Expr(ref expr) |
                syn::Stmt::Semi(ref expr, _) => {
                    //println!("expr: {:#?}", expr);
                    self.find_fn_calls(expr)
                }
                s @ _ => println!("whatever: {:#?}", s),
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
