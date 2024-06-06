use macrology::print_progress;

#[print_progress("calling foo")]
fn foo() -> i32 {
    println!("this is foo speaking!");
    53
}

fn main() {
    println!("{}", foo());
}
