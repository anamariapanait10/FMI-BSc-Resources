#include <iostream>
#include <iomanip>
#include <vector>
#include <float.h>

using namespace std;

#define max_val 99999999999999
#define min_val -99999999999999

struct dreapta{
    double a, b, c;
};

struct punct{
    double x, y;
};

vector<dreapta> dr;
vector<punct> puncte;

double verifica_p_in_dreptunghi_interesant(vector<dreapta> dr, punct p){
    double min_x = max_val, max_x = min_val, min_y = max_val, max_y = min_val;

    for(int i = 0; i < dr.size(); i++) {
        if (dr[i].a == 0) { // semiplan orizontal
            if (dr[i].b * p.y + dr[i].c >= 0) { // punctul nu se afla in semiplanul orizontal
                continue;
            } else if (dr[i].b > 0) { // semiplan in sus
                min_y = min(min_y, (-1) * dr[i].c / dr[i].b);
            } else {
                max_y = max(max_y, (-1) * dr[i].c / dr[i].b);
            }
        } else { // semiplan vertical
            if (dr[i].a * p.x + dr[i].c >= 0) { // punctul nu se afla in semiplanul vertical
                continue;
            } else if (dr[i].a > 0) { // semiplan vertical in dreapta
                min_x = min(min_x, (-1) * dr[i].c / dr[i].a);
            } else {
                max_x = max(max_x, (-1) * dr[i].c / dr[i].a);
            }
        }
    }

    if(min_x == max_val || min_y == max_val || max_x == min_val || max_y == min_val){
        return 0;
    } else {
        return (max_x - min_x) * (max_y - min_y);
    }
}

int main()
{
    double n, m, arie;
    cin >> n;
    dr.resize(n+1);
    for (int i = 0; i < n; i++){
        cin >> dr[i].a >> dr[i].b >> dr[i].c;
    }
    cin >> m;
    puncte.resize(m + 1);

    for(int i = 0; i < m; i++){
        cin >> puncte[i].x >> puncte[i].y;
    }

    for (int i = 0; i < m; i++){
        arie = verifica_p_in_dreptunghi_interesant(dr, puncte[i]);
        if (arie == 0) {
            cout << "NO\n";
        } else {
            cout << "YES\n" << setprecision(6) << fixed << arie << "\n";
        }
    }

    return 0;
}