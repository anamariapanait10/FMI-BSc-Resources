#include <iostream>
#include <vector>

using namespace std;
struct pct{
    int x, y;
};
vector<pct> poligon;
pct stg, dr, sus, jos;
int n, i_stg, i_dr, i_sus, i_jos;

void x_monoton(){
    // de la stg la dr
    int copie = (i_stg + 1) % n;
    while(copie != i_dr){
        if(copie == 0) {
            if (poligon[0].x < poligon[n - 1].x) {
                cout << "NO\n";
                return;

            }
        } else {
            if (poligon[copie].x < poligon[copie - 1].x) {
                cout << "NO\n";
                return;
            }
        }
        copie = (copie + 1) % n;
    }

    // de la stg la dr dar invers
    if(i_stg == 0){
        copie = n - 1;
    } else{
        copie = i_stg - 1;
    }
    while(copie != i_dr){
        if(copie + 1 == n){
            if(poligon[copie].x < poligon[0].x) {
                cout << "NO\n";
                return;
            }
        } else {
            if(poligon[copie].x < poligon[copie + 1].x) {
                cout << "NO\n";
                return;
            }
        }
        if(copie == 0){
            copie = n - 1;
        } else{
            copie--;
        }
    }
    cout << "YES\n";
}

void y_monoton(){
    // de sus in jos
    int copie = (i_sus + 1) % n;
    while(copie != i_jos){
        if(copie == 0) {
            if (poligon[0].y > poligon[n - 1].y) {
                cout << "NO\n";
                return;

            }
        } else {
            if (poligon[copie].y > poligon[copie - 1].y) {
                cout << "NO\n";
                return;
            }
        }
        copie = (copie + 1) % n;
    }

    // de sus in jos dar pe partea cealalta
    if(i_sus == 0){
        copie = n - 1;
    } else{
        copie = i_sus - 1;
    }
    while(copie != i_jos){
        if(copie + 1 == n){
            if(poligon[copie].y > poligon[0].y) {
                cout << "NO\n";
                return;
            }
        } else {
            if(poligon[copie].y > poligon[copie + 1].y) {
                cout << "NO\n";
                return;
            }
        }
        if(copie == 0){
            copie = n - 1;
        } else{
            copie--;
        }
    }
    cout << "YES\n";
}

int main(){
    cin >> n;
    for(int i = 0; i < n; i++) {
        pct p;
        cin >> p.x >> p.y;
        if (i == 0) {
            stg = p;
            dr = p;
            sus = p;
            jos = p;
            i_stg = i_dr = i_sus = i_jos = 0;
        } else {
            if (p.x < stg.x) {
                stg = p;
                i_stg = i;
            }
            if (p.x > dr.x) {
                dr = p;
                i_dr = i;
            }
            if (p.y < jos.y) {
                jos = p;
                i_jos = i;
            }
            if (p.y > sus.y) {
                sus = p;
                i_sus = i;
            }
        }
        poligon.push_back(p);
    }

    x_monoton();
    y_monoton();
    return 0;
}