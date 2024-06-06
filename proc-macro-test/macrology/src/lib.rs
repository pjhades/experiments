use proc_macro::TokenStream;
use quote::{quote, ToTokens};
use syn::{parse_macro_input, ItemFn, LitStr, Stmt};

#[proc_macro]
pub fn make_answer(_item: TokenStream) -> TokenStream {
    "fn answer() -> i32 { 42 }".parse().unwrap()
}

#[proc_macro_derive(AnswerFn)]
pub fn drive_answer_fn(_item: TokenStream) -> TokenStream {
    "fn answer() -> i32 { 42 }".parse().unwrap()
}

#[proc_macro_attribute]
pub fn print_progress(arg: TokenStream, input: TokenStream) -> TokenStream {
    let msg = parse_macro_input!(arg as LitStr);
    let mut func = parse_macro_input!(input as ItemFn);
    let func_name = func.sig.ident.to_string();

    let entry_log = quote! {
        println!(">>> {}: {}", #func_name, #msg);
    }
    .into();
    func.block
        .stmts
        .insert(0, parse_macro_input!(entry_log as Stmt));

    let exit_log = quote! {
        println!("<<< {}", #func_name);
    }
    .into();
    func.block.stmts.insert(
        func.block.stmts.len() - 1,
        parse_macro_input!(exit_log as Stmt),
    );

    func.to_token_stream().into()
}
