use std::pin::Pin;
use std::ops::{Deref, DerefMut};
use std::ptr;

// This is actually `!Unpin`
struct ImmovableThing {
    s: String,
    p: *const String,
}

impl std::fmt::Debug for ImmovableThing{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        write!(f, "s={} p={} ({:p})", self.s, unsafe { &*self.p }, self.p)
    }
}

impl ImmovableThing {
    fn new(s: &str) -> Self {
        Self {
            s: s.to_string(),
            p: ptr::null(), 
        }
    }

    fn init(&mut self) {
        self.p = &self.s as *const String;
    }
}

struct MaliciousPointer(ImmovableThing);

impl Deref for MaliciousPointer {
    type Target = ImmovableThing;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for MaliciousPointer {
    fn deref_mut(&mut self) -> &mut Self::Target {
        let mut imm = ImmovableThing::new("???");
        imm.init();
        //  malicious: s=??? p=??? (0x7ffeeca02e58)
        println!(" malicious: {imm:?}");
        let _ = std::mem::swap(&mut self.0, &mut imm);
        &mut self.0
    }
}

fn main() {
    let mut imm = ImmovableThing::new("one");
    imm.init();

    //  original: s=one p=one (0x7ffeeca02f50)
    println!("  original: {imm:?}");

    // Although a `Pin` is constructed here, it does not guarantee
    // the `ImmovableThing` under the `MaliciousPointer` is actually pinned,
    // which breaks the pinning contract.
    let ptr = MaliciousPointer(imm);
    let mut pinned = unsafe { Pin::new_unchecked(ptr) };

    // `as_mut` calls `deref_mut` on the pinned `MaliciousPointer`,
    // which replaces the memory behind its `self`. So the underlying
    // object, the `ImmovableThing` with string "one" is moved.
    // However, users of `pinned` should expect that the object is
    // immovable. This is why `new_unchecked` is unsafe: we, the caller,
    // should make sure the underlying object is really pinned.
    let r = pinned.as_mut().get_mut();
    // original.s: "???"
    println!("original.s: {:?}", r.s);
    // original.p: 0x7ffeeca02e58
    // Note this still points to the `String` on the stack of `deref_mut`.
    println!("original.p: {:?}", r.p);
}
