#include <iostream>
using namespace std;
class C {
    int *p;
public:
    C (int *q) : p(q) {}
    void reload () { delete p; p = new int;}
    void set (int q) const { *p = q; }
};
int main () {
    int x = 20210614;
    C ob(&x);
    ob.reload(); ob.set(x);
    return 0;
}
