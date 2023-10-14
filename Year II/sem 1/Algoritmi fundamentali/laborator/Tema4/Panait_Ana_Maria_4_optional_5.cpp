#include <vector>
#include <string>
#include <map>
#include <iostream>

using namespace std;

const int max_N = 100002;

int n, k;
char s[max_N];
vector<int> S[max_N];

int N, M, grad_intrare[max_N * 2];
map<string, int> idx;
string pf, sf;

struct cuvant {
    int pfId, sfId;
} cuvinte[max_N];

vector<pair<int, int>> V[max_N * 2];
bool folosit[max_N * 2];
map<pair<int, int>, char> valori;
vector<int> coada;

int st;
char ans[max_N];

bool verifica_euler() {
    int fn = 0;
    for (int i = 1; i <= N; ++i) {
        int grad_iesire = V[i].size();
        if (grad_intrare[i] < grad_iesire) {
            if (st) return false;
            st = i;
        } else if (grad_intrare[i] > grad_iesire) {
            if (fn) return false;
            fn = i;
        }
    }
    if (!st) st = 1;
    return true;
}

int gasire_ciclu() {
    int sz = 0;
    coada.push_back(st);
    int prv = -1;
    while (!coada.empty()) {
        int nod = coada.back();
        while (!V[nod].empty() && folosit[V[nod].back().second]) {
            V[nod].pop_back();
        }
        if (V[nod].empty()) {
            if (prv != -1)
                ans[sz++] = valori[pair<int, int>{nod, prv}];

            coada.pop_back();
            prv = nod;
            continue;
        }
        pair<int, int> adj = V[nod].back();
        folosit[adj.second] = true;
        V[nod].pop_back();
        coada.push_back(adj.first);
    }
    return sz;
}

int main() {
    cin >> n >> k;
    for (int i = 0; i < n; i++) {
        pf.clear();
        sf.clear();
        cin >> s;
        if (k == 1)
            cout << s[0];
        S[i].resize(k);
        for (int j = 0; j < k - 1; j++) {
            S[i][j] = s[j];
            pf += s[j];
            sf += s[j + 1];
        }
        if (idx.find(pf) == idx.end())
            idx[pf] = ++N;
        if (idx.find(sf) == idx.end())
            idx[sf] = ++N;

        cuvinte[i] = cuvant{idx[pf], idx[sf]};
        ++M;
        V[cuvinte[i].pfId].push_back(pair<int, int>{cuvinte[i].sfId, M});
        ++grad_intrare[cuvinte[i].sfId];
        valori[pair<int, int>{cuvinte[i].pfId, cuvinte[i].sfId}] = s[k - 1];
    }
    if (k == 1) return 0;
    if (!verifica_euler())
        cout << "-1\n";
    else {
        if (gasire_ciclu() < n)
            cout << "-1\n";
        else {
            int idx = 0;
            for (int i = 1; i < n; i++)
                if (cuvinte[i].pfId == st) {
                    idx = i;
                    break;
                }
            for (int i = 0; i < k - 1; i++)
                cout << (char) S[idx][i];
            for (int i = n - 1; i >= 0; i--)
                cout << (char) ans[i];
        }
    }

    return 0;
}
