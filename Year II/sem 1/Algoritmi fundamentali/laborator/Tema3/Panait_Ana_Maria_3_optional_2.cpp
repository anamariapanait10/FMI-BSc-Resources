/*
Problema Drumuri2, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2962320

Complexitate timp: O(n*m^2)
Complexitate memorie: O(n^2*m)
*/

#include <fstream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;

ifstream in("drumuri2.in");
ofstream out("drumuri2.out");

int n, m, src, dest, flux_total;
vector<int> tata, viz;
vector<vector<int>> adj, cap;


bool bfs(){
    queue<int> coada;

    for(int i = 0; i <= dest; i++){
        viz[i] = 0;
        tata[i] = -1;
    }
    coada.push(src);
    viz[src] = 1;

    while(!coada.empty()){
        int nod= coada.front();
        coada.pop();

        if(nod == dest)
            return true;

        for(int j = 0; j < adj[nod].size(); j++){
            int vec = adj[nod][j];

            if(cap[nod][vec] && viz[vec] == 0){
                tata[vec] = nod;
                viz[vec] = 1;
                coada.push(vec);
            }
        }
    }

    return false;
}

void drum(){
    while(bfs()){
        for(int i = n + 1; i <= 2 * n; i++){
            if(viz[i]){
                tata[dest] = i;
                int flux_min = INT_MAX;

                for(int nod = dest; nod != src; nod = tata[nod])
                    flux_min = min(flux_min, cap[tata[nod]][nod]);

                flux_total += flux_min;

                for(int nod = dest; nod != src; nod = tata[nod]){
                    cap[tata[nod]][nod] -= flux_min;
                    cap[nod][tata[nod]] += flux_min;
                }
            }
        }
    }
}

int main()
{
    int x, y;
    in >> n >> m;

    dest = 2 * n + 1;
    adj.resize(dest+1);
    viz.resize(dest+1, 0);
    tata.resize(dest+1);
    cap.resize(dest+1);
    for(int i = 0; i <= dest; i++)
        cap[i].resize(dest+1, 0);

    for(int i = 1; i <= m; i++){
        in >> x >> y;
        cap[x][n + y] = 1;
        adj[x].push_back(n + y);
        adj[n + y].push_back(x);
    }

    for(int i = 1; i <= n; i++){
        cap[src][i] = 1;
        adj[src].push_back(i);
        cap[n + i][dest] = 1;
        adj[n + i].push_back(dest);
        cap[n + i][i] = 1;
        adj[i].push_back(n + i);
        adj[n + i].push_back(i);
    }

    drum();

    out << n - flux_total;

    return 0;
}
