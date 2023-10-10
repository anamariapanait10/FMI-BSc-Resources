/*
Problema Lanterna, Infoarena
Link la solutia mea de 100 de pct:

Idee: Folosesc algoritmul lui Dijkstra si calculez
intr-o matrice timpul minim de la nodul 1 la
nodul i cu j watti ramasi. Apoi incerc sa minimizez
numarul de watti cu o cautare binara intre 1 si k
la care verific daca exista un numar mai mic de watti
astfel incat sa fie se pastreze timpul minim calculat anterior.

Complexitate timp: O(n^2 + nk + logk), unde n e numarul de orase
*/

#include <fstream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;

ifstream in("lanterna.in");
ofstream out("lanterna.out");

struct baza {
    int id, t, w;
};

vector<baza> v[51];
queue<baza> coada;
int d[51][1001], viz[51][1001], baze_prietene[51], n, k, w;


int djk(int start){
    baza b;
    b.id = 1;
    b.t = 0;
    b.w = start;
    coada.push(b);

    for (int i = 1; i <= n; i++)
        for (int j = 0; j <= k; j++)
            d[i][j] = INT_MAX;

    d[1][start] = 0;
    viz[1][start] = 1;

    while (!coada.empty()){
        int id = coada.front().id;
        int t = coada.front().t;
        int w_disp = coada.front().w;
        coada.pop();
        viz[id][w_disp] = 0;

        if(baze_prietene[id]){
            d[id][start] = d[id][w_disp];
            w_disp = start;
        }

        int w_cons;
        for (int i = 0; i < v[id].size(); i++){
            b.id = v[id][i].id;
            b.t = v[id][i].t;
            b.w = v[id][i].w;
            // dc avem suficienta baterie
            if (w_disp >= b.w){
                // dc drumul curent este mai rapid atunci actualizez valoarea anterioara
                if (d[id][w_disp] + b.t < d[b.id][w_disp - b.w]){
                    d[b.id][w_disp - b.w] = d[id][w_disp] + b.t;
                    if (!viz[b.id][w_disp - b.w]){
                        b.w = w_disp - b.w;
                        coada.push(b);
                        viz[b.id][b.w] = 1;
                    }
                }
            }
        }
    }
    // iau timpul minim a drumului pana la baza inamica
    int dist_mn = INT_MAX;
    for (int i = 0; i <= k; i++)
        if (d[n][i] < dist_mn)
            dist_mn = d[n][i];
    return dist_mn;
}


void cautare_bin(int st, int dr, int &poz, int dur_k){
    while(st <= dr){
        int mij = (st + dr) / 2;
        if(djk(mij) == dur_k){
            dr = mij - 1;
            poz = mij;
        } else
            st = mij + 1;
    }
}

int main()
{
    int m, t, a, b;

    in >> n >> k;
    for (int i = 1; i <= n; i++)
        in >> baze_prietene[i];
    in >> m;
    for (int i = 0; i < m; i++){
        in >> a >> b >> t >> w;
        v[a].push_back({b, t, w});
        v[b].push_back({a, t, w});
    }

    int dur_k = djk(k), poz = k;
    cautare_bin(0, k, poz, dur_k);

    out << dur_k << ' ' << poz;
    return 0;
}
