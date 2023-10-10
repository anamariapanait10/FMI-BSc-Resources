#include <iostream>
#include <vector>
#include <climits>

using namespace std;

struct dr {
    long long a, b, c;
};
vector<dr> semiplane;

int main() {
    long long n;
    cin >> n;

    for(int i = 0; i < n; i++){
        dr d;
        cin >> d.a >> d.b >> d.c;
        semiplane.push_back(d);
    }

    long long semiplane_stg_x_maxim = LONG_LONG_MAX, semiplane_dr_x_minim = LONG_LONG_MIN;
    long long semiplane_jos_y_maxim = LONG_LONG_MAX, semiplane_sus_y_minim = LONG_LONG_MIN;
    for(int i = 0; i < n; i++) {
        if(semiplane[i].a == 0) {
            if(semiplane[i].b > 0) {
                semiplane_jos_y_maxim = min(semiplane_jos_y_maxim, (-1) * (semiplane[i].c / semiplane[i].b));
            } else {
                semiplane_sus_y_minim = max(semiplane_sus_y_minim, (-1) * (semiplane[i].c / semiplane[i].b));
            }
        } else if(semiplane[i].a > 0) {
            semiplane_stg_x_maxim = min(semiplane_stg_x_maxim, (-1) * (semiplane[i].c / semiplane[i].a));
        } else {
            semiplane_dr_x_minim = max(semiplane_dr_x_minim, (-1) * (semiplane[i].c / semiplane[i].a));
        }
    }
    if(semiplane_stg_x_maxim < semiplane_dr_x_minim || semiplane_jos_y_maxim < semiplane_sus_y_minim) {
        cout << "VOID\n";
    } else if(semiplane_stg_x_maxim == LONG_LONG_MAX || semiplane_dr_x_minim == LONG_LONG_MIN || semiplane_jos_y_maxim == LONG_LONG_MAX || semiplane_sus_y_minim == LONG_LONG_MIN) {
        cout << "UNBOUNDED\n";
    } else {
        cout << "BOUNDED\n";
    }
    return 0;
}
