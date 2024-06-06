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

// This is supposed to be used as
//
// #[print_progress("the message that you want to print upon entry of a function")]
// fn foo() -> i32 {
//   ...
// }
#[proc_macro_attribute]
pub fn print_progress(arg: TokenStream, input: TokenStream) -> TokenStream {
    // `arg` is what we provided as the message, which should be a string.
    let msg = parse_macro_input!(arg as LitStr);
    // `input` is what we applied the macro on, which should be a function.
    let mut func = parse_macro_input!(input as ItemFn);
    // Get the function name for later use.
    let func_name = func.sig.ident.to_string();

    // `quote!` is an easy way to generate a proc_macro2::TokenStream from literal rust code.
    // But the syn crate usually expects proc_macro::TokenStream, so we call `into()`.
    let entry_log = quote! {
        println!(">>> {}: {}", #func_name, #msg);
    }
    .into();
    // Modify the parsed syntax tree for the target function by inserting statements at desired
    // places.
    func.block
        .stmts
        .insert(0, parse_macro_input!(entry_log as Stmt));

    // Insert another statement before the function returns.
    let exit_log = quote! {
        println!("<<< {}", #func_name);
    }
    .into();
    func.block.stmts.insert(
        func.block.stmts.len() - 1,
        parse_macro_input!(exit_log as Stmt),
    );

    // `func` is a parsed syntax tree, now we need to convert it back into a token stream to return
    // to the compiler.
    func.to_token_stream().into()
}
