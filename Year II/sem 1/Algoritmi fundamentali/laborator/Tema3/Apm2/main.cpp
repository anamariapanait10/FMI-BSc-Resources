/*
Problema Apm2, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://infoarena.ro/job_detail/2946777?action=view-source

Complexitate timp: O(k(m + n))
Complexitate memorie: O(n)
*/
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

ifstream in("apm2.in");
ofstream out("apm2.out");

int n, m, q;
struct muchie{
    int x, y, cost;
};
long long costMin = 0, costCurent;
vector<int> tata, rang;
vector<muchie> muchii, apm;


bool comp(muchie m1, muchie m2) {
    return m1.cost < m2.cost;
}

// cauta reprezentantul nodului si face compresia drumurilor
int cauta(int x) {
    int r = x;
    while (tata[r] != r)
        r = tata[r];

    while (tata[x] != x) {
        int aux = tata[x];
        tata[x] = r;
        x = aux;
    }
    return r;
}

// reuneste multimile celor doua noduri dupa
// rangurile lor
void reuneste(int x, int y) {
    x = cauta(x);
    y = cauta(y);

    if (x != y) {
        if (rang[x] > rang[y])
            tata[x] = y;
        else tata[y] = x;
        if (rang[x] == rang[y])
            rang[y]++;
    }
}

int main() {

    in >> n >> m >> q;

    muchii.resize(m);

    for (int i = 0; i < m; i++) {
        in >> muchii[i].x >> muchii[i].y >> muchii[i].cost;
    }

    sort(muchii.begin(), muchii.end(), comp);

    rang.resize(n + 1, 0);
    tata.resize(n + 1);
    costCurent = 0;

    for (int i = 1; i <= n; i++)
        tata[i] = i;

    int rx, ry;
    for (int i = 0; i < muchii.size(); i++) {
        rx = cauta(muchii[i].x);
        ry = cauta(muchii[i].y);

        if (rx != ry) {
            reuneste(rx, ry);
            apm.push_back(muchii[i]);
            costCurent += muchii[i].cost;
        }
    }

    costMin = costCurent;

    muchie mch;
    apm.insert(apm.begin(), mch);

    for (int i = 0; i < q; i++) {
        in >> mch.x >> mch.y;
        mch.cost = 0;
        apm[0] = mch;

        costCurent = 0;

        for (int j = 1; j <= n; j++) {
            tata[j] = j;
            rang[j] = 0;
        }

        int rx, ry;
        for (int j = 0; j < apm.size(); j++) {
            rx = cauta(apm[j].x);
            ry = cauta(apm[j].y);

            if (rx != ry) {
                reuneste(rx, ry);
                costCurent += apm[j].cost;
            }
        }

        out << costMin - costCurent - 1 << "\n";
    }
}
