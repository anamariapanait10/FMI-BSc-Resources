#include <fstream>

using namespace std;

ifstream in("arbint.in");
ofstream out("arbint.out");

int arb[500000], v[110000];

void creare(int nod, int st, int dr){
    if(st == dr){
        arb[nod] = v[st];
    } else {
        creare(nod * 2, st, (st + dr) / 2);
        creare(nod * 2 + 1, (st + dr) / 2 + 1, dr);
        arb[nod] = max(arb[nod * 2], arb[nod * 2 + 1]);
    }
}

void modif(int nod, int st, int dr, int poz, int val){
    if(poz < st || poz > dr)
        return;
    if(st == dr){
        arb[nod] = val;
    } else {
        modif(nod * 2, st, (st + dr) / 2, poz, val);
        modif(nod * 2 + 1, (st + dr) / 2 + 1, dr, poz, val);
        arb[nod] = max(arb[nod * 2], arb[nod * 2 + 1]);
    }
}

int maxim(int nod, int st, int dr, int i, int j){
    if(dr < i || st > j)
        return 0;

    if(i <= st && dr <= j)
        return arb[nod];

    return max(maxim(nod * 2, st, (st + dr) / 2, i, j), maxim(nod * 2 + 1, (st + dr) / 2 + 1, dr, i, j));
}

int main()
{
    int n, m;
    in >> n >> m;

    for(int i = 1; i <= n; i++)
        in >> v[i];

    creare(1, 1, n);

    int x, y, op;
    for(int i = 1; i <= m; i++){
        in >> op >> x >> y;
        if(op == 1)
            modif(1, 1, n, x, y);
        else
            out << maxim(1, 1, n, x, y) << '\n';
    }

    return 0;
}
