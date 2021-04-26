// representing states
//    -- 1 --> B -- 2 ---
//   /        ^  \        \
// A           \_/ 1       >-> D
//   \                    /
//    -- 2 --> C -- 1,2 --
#[derive(Debug)]
struct A;
#[derive(Debug)]
struct B;
#[derive(Debug)]
struct C;
#[derive(Debug)]
struct D;

// representing char classes
#[derive(Debug)]
struct X1;
#[derive(Debug)]
struct X2;

#[derive(Debug)]
struct Fsm<T> {
    state: T
}

trait Transition<V, T> {
    fn next(self, input: V) -> T;
}

impl Fsm<A> {
    fn new() -> Self {
        Fsm { state: A {} }
    }
}

impl Transition<X1, Fsm<B>> for Fsm<A> {
    fn next(self, _input: X1) -> Fsm<B> {
        Fsm { state: B {} }
    }
}

impl Transition<X2, Fsm<C>> for Fsm<A> {
    fn next(self, _input: X2) -> Fsm<C> {
        Fsm { state: C {} }
    }
}

fn main() {
    let f = Fsm::new();
    println!("start: {:?}", f);
    let f = f.next(X1 {});
    println!("given x1: {:?}", f);

    let f = Fsm::new();
    println!("start: {:?}", f);
    let f = f.next(X2 {});
    println!("given x2: {:?}", f);

    // compiler will complain: method not found in `Fsm<C>`
    // let f = f.next(X2 {});
    // println!("given x2: {:?}", f);
}
