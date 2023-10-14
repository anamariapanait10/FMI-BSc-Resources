#include <iostream>

using namespace std;

int x_a, y_a, x_b, y_b, x_c, y_c, m, x_d, y_d;
long long xa_ya, xb_yb, xc_yc, xd_yd;

long long determinant(){
    xd_yd =  x_d * x_d + y_d * y_d;

    long long s1 = (x_b - x_a) * (y_c - y_a) * (xd_yd - xa_ya);
    long long s2 = (x_c - x_a) * (y_d - y_a) * (xb_yb - xa_ya);
    long long s3 = (x_d - x_a) * (y_b - y_a) * (xc_yc - xa_ya);
    long long s4 = (x_d - x_a) * (y_c - y_a) * (xb_yb - xa_ya);
    long long s5 = (x_b - x_a) * (y_d - y_a) * (xc_yc - xa_ya);
    long long s6 = (x_c - x_a) * (y_b - y_a) * (xd_yd - xa_ya);
    return (s4 + s5 + s6 - s1 - s2 - s3);
}

int main() {


    cin >> x_a >> y_a >> x_b >> y_b >> x_c >> y_c;
    cin >> m;

    xa_ya = x_a * x_a + y_a * y_a;
    xb_yb = x_b * x_b + y_b * y_b;
    xc_yc = x_c * x_c + y_c * y_c;
    for(int i = 0; i < m; i++){
        cin >> x_d >> y_d;

        long long det = determinant();
        if(det == 0) {
            cout << "BOUNDARY\n";
        } else if(det > 0){
            cout << "INSIDE\n";
        } else {
            cout << "OUTSIDE\n";
        }

    }
    return 0;
}


