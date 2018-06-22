trait T {
    fn foo(&self) {}
}

struct X;

impl T for X {}

// This does NOT extend the trait or add default implementation
// of certain methods but add inherent methods to the trait object.
impl T {
    fn baz(&self) {}
}

fn main() {
    let x: Box<T> = Box::new(X {});
    x.foo();
    x.baz();

    let x = X {};
    x.foo();
    // But this does not work.
    x.baz();
}
