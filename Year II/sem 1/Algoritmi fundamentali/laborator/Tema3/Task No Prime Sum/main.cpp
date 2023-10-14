#include <iostream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;


int n, src, dest, flux_max;
vector<int> tata, viz, v, sol;
vector<vector<int>> adj(2002);
int cap[2002][2002];

bool prime(int x){
    if(x <= 1)
        return false;
    for(int d = 2; d * d <= x; d++)
        if(x % d == 0)
            return false;

    return true;
}

int bfs(){
    viz = vector<int>(n + 2, 0);
    tata = vector<int>(n + 2, 0);
    queue<int> coada;

    coada.push(src);
    viz[src] = 1;
    tata[src] = 0;

    while(!coada.empty()){
        int nod = coada.front();
        coada.pop();
        if(nod == dest)
            return 1;
        for(auto vec: adj[nod]){
            if(viz[vec] == 0 && cap[nod][vec] > 0) {
                coada.push(vec);
                tata[vec] = nod;
                viz[vec] = 1;
            }
        }
    }
    return viz[dest];
}

int main() {
    cin >> n;

    adj.resize(n + 2);
    v.resize(n + 2);
    dest = n + 1;
    for(int i = 1; i <= n; i++){
        cin >> v[i];
        if(v[i] % 2){
            cap[i][dest] = 1;
            adj[dest].push_back(i);
            adj[i].push_back(dest);
        } else {
            cap[src][i] = 1;
            adj[src].push_back(i);
            adj[i].push_back(src);
        }
    }

    for(int i = 1; i < n; i++){
        for(int j = i + 1; j <= n; j++){
            if(prime(v[i] + v[j])){
                adj[i].push_back(j);
                adj[j].push_back(i);
                if(v[i] % 2 == 0)
                    cap[i][j] = 1;
                else
                    cap[j][i] = 1;
            }
        }
    }

    while(bfs()){
        for(auto vec: adj[dest]){
            if(viz[vec] && cap[vec][dest] > 0){
                tata[dest] = vec;
                int flux = INT_MAX;
                for(int nod = dest; nod != src; nod = tata[nod])
                    flux = min(flux, cap[tata[nod]][nod]);
                if(flux == 0)
                    continue;
                for(int nod = dest; nod != src; nod = tata[nod]) {
                    cap[tata[nod]][nod] -= flux;
                    cap[nod][tata[nod]] += flux;
                }
                flux_max += flux;
            }
        }
    }

    for(int i = 1; i <= n; i++)
        if(!viz[i] && v[i] % 2 == 0 || viz[i] && v[i] % 2 == 1)
            sol.push_back(v[i]);

    cout << sol.size() <<'\n';
    for(auto x: sol){
        cout << x <<" ";
    }
    return 0;
}
