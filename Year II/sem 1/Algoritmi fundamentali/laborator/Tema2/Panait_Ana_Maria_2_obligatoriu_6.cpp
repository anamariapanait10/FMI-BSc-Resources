/*
Problema Easygraph, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://infoarena.ro/job_detail/2946750?action=view-source

Complexitate timp: O(t(n+m)), unde t este numarul de teste
                                n numarul de noduri si m numarul de muchii
*/
#include <fstream>
#include <vector>
#include <climits>

using namespace std;

ifstream in("easygraph.in");
ofstream out("easygraph.out");


vector<int> mat[15001];
long long v[15001], cost_lant[15001];

bool viz[15001];

// facem o parcurgere dfs in care calculam si
// suma pe fiecare lant
void dfs(int x){
    viz[x] = 1;
    cost_lant[x] = v[x];
    for (auto vec: mat[x]){
        if (!viz[vec])
            dfs(vec);
        cost_lant[x] = max(cost_lant[x], v[x] + cost_lant[vec]);
    }
}
int main()
{
    int n, m, t, x, y;
    long long maxim;
    in >> t;

    for(int i = 0; i < t; i++){
        in >> n >> m;

        for (int i = 1; i <= n; i++)
            in >> v[i];

        for (int i = 1; i <= m; i++){
            in >> x >> y;
            mat[x].push_back(y);
        }

        for (int i = 1; i <= n; i++)
            if (!viz[i])
                dfs(i);

        maxim = LLONG_MIN;

        // actualizam lantul de cost maxim
        for (int i = 1; i <= n; i++)
            maxim = max(maxim, cost_lant[i]);

        out << maxim <<"\n";

        // resetam matricea si vectorul viz
        for (int i = 1; i <= n; i++){
            mat[i].clear();
            viz[i] = 0;
        }
    }

    return 0;
}
