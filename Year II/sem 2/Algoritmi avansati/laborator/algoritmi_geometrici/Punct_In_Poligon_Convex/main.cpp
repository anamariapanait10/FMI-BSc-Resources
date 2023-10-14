#include <iostream>
#include <vector>

using namespace std;

struct punct {
    long long x, y;
};

vector<punct> poligon;
vector<punct> puncte;
punct p = {1000000001, 1000000001};

int verif_p_in_poligon(punct a, punct b, punct c, punct p){

    long long suprafata;
    punct p1 = {b.x - a.x, b.y - a.y };
    punct p2 = {p.x - c.x, p.y - c.y };
    long long area = p1.x * p2.y - p1.y * p2.x;

    if(area == 0) {
        return -1;
    }

    if(area > 1) {
        suprafata = 1;
    } else {
        suprafata = -1;
    }

    area *= suprafata;

    long long u = ((c.x - a.x) * p1.y - (c.y - a.y) * p1.x) * suprafata;
    long long t = ((c.x - a.x) * p2.y - (c.y - a.y) * p2.x) * suprafata;

    if ( u >= 0  && u <= area && t>= 0  && t <= area) {
        if (u == 0) {
            return 0;
        }
        return 1;
    }
    else {
        return -1;
    }
}

int main() {

    int n, m;
    cin >> n;
    poligon.resize(n + 1);
    for(int i = 0; i < n; i++) {
        cin >> poligon[i].x >> poligon[i].y;
    }
    cin >> m;
    puncte.resize(m + 1);

    for (int i = 0; i < m; i++){
        cin >> puncte[i].x >> puncte[i].y;
        int cnt = 0;
        for (int j = 0; j < n && cnt != -1; j++) {
            int rez = verif_p_in_poligon(poligon[j], poligon[(j + 1) % n], puncte[i], p);
            if (rez == 0){
                cnt = -1;
            } else if (rez == 1) {
                cnt += 1;
            }
        }

        if(cnt == -1) {
            cout << "BOUNDARY\n";
        } else if(cnt % 2 == 0) {
            cout << "OUTSIDE\n";
        } else {
            cout << "INSIDE\n";
        }
    }

    return 0;
}