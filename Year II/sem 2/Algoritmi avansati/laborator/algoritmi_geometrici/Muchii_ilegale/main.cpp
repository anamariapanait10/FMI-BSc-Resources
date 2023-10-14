#include <iostream>
#define LL long long

using namespace std;

long long determinant(LL x_a, LL y_a, LL x_b, LL y_b, LL x_c, LL y_c, LL x_d, LL y_d){
    long long xa_ya = x_a * x_a + y_a * y_a;
    long long xb_yb = x_b * x_b + y_b * y_b;
    long long xc_yc = x_c * x_c + y_c * y_c;
    long long xd_yd =  x_d * x_d + y_d * y_d;

    long long s1 = (x_b - x_a) * (y_c - y_a) * (xd_yd - xa_ya);
    long long s2 = (x_c - x_a) * (y_d - y_a) * (xb_yb - xa_ya);
    long long s3 = (x_d - x_a) * (y_b - y_a) * (xc_yc - xa_ya);
    long long s4 = (x_d - x_a) * (y_c - y_a) * (xb_yb - xa_ya);
    long long s5 = (x_b - x_a) * (y_d - y_a) * (xc_yc - xa_ya);
    long long s6 = (x_c - x_a) * (y_b - y_a) * (xd_yd - xa_ya);
    return (s4 + s5 + s6 - s1 - s2 - s3);
}

int main() {

    long long x_a, y_a, x_b, y_b, x_c, y_c, x_d, y_d;
    cin >> x_a >> y_a >> x_b >> y_b >> x_c >> y_c >> x_d >> y_d;

    long long det = determinant(x_a, y_a, x_b, y_b, x_c, y_c, x_d, y_d);
    if(det > 0) {
        cout << "AC: ILLEGAL\n";
    } else {
        cout << "AC: LEGAL\n";
    }


    det = determinant(x_b, y_b, x_c, y_c, x_d, y_d, x_a, y_a);
    if(det > 0) {
        cout << "BD: ILLEGAL\n";
    } else {
        cout << "BD: LEGAL\n";
    }
    return 0;
}


