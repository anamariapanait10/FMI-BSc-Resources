/*
Problema Online, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2946775?action=view-source

Complexitate timp: O(k(m + n))
Complexitate memorie: O(n)

*/
#include <fstream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>

using namespace std;


ifstream in ("online.in");
ofstream out ("online.out");

int n, m;
struct muchie{
    int x, y, cost;
};
vector <muchie> muchii;
vector <int> tata;
vector <int> rg;
vector <muchie> solutie;
int sol;

// cauta reprezentantul nodului x
int cauta(int x){
    if(tata[x] == x)
        return x;
    return cauta(tata[x]);
}

// reuneste multimile x si y
void reuniune(int x, int y){
    int a = cauta(x);
    int b = cauta(y);
    if(rg[a] < rg[b])
        tata[a] = b;
    else
        tata[b] = a;
    if(rg[a] == rg[b])
        rg[b]++;
}

// aplicam Kruskal pentru a obtine APMul curent
void kruskal(){
    int nr_muchii = 0;
    for(int i = 0; i < muchii.size(); i++){
        int x = cauta(muchii[i].x);
        int y = cauta(muchii[i].y);
        if(x != y){
            reuniune(x, y);
            sol += muchii[i].cost;
            nr_muchii++;
            solutie.push_back(muchii[i]);
        }
        if(nr_muchii == n - 1){
            muchii = solutie;
            solutie.clear();
            return;
        }

    }
}

int comp(muchie m1, muchie m2){
    return m1.cost < m2.cost;
}

int main()
{
    int k;
    in >> n >> m;
    for (int i = 1; i <= m; i++){
        muchie m;
        in >> m.x >> m.y >> m.cost;
        muchii.push_back(m);
    }

    // initializarea vectorilor pentru kruskal
    tata.resize(n + 1);
    rg.resize(n + 1);
    for(int i = 1; i <= n; i++){
        tata[i] = i;
        rg[i] = 1;
    }

    sort(muchii.begin(), muchii.end(), comp);

    kruskal();

    out << sol << '\n';

    // ofertele noi
    in >> k;
    for(int i = 1; i <= k; i++){
        muchie m;
        in >> m.x >> m.y >> m.cost;
        muchii.push_back(m);

        sort(muchii.begin(), muchii.end(), comp);

        sol = 0;
        for(int j = 1; j <= n; j++){
            tata[j] = j;
            rg[j] = 1;
        }

        kruskal();

        out << sol << '\n';
    }
    return 0;
}
