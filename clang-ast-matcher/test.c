void f() {}
void g() { f(); }
void h() { f(); g(); }
int main() {
    f();
    g();
    h();
    return 0;
}
