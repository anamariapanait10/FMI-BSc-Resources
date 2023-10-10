/*
    complexitate timp: O(n*m^2)
*/
#include <iostream>
#include <fstream>
#include <math.h>
#include <queue>
#include <climits>


using namespace std;

ifstream in("maxflow.in");
ofstream out("maxflow.out");

int n, m;
pair<int, int> muchie[1001][1001];
vector<int> tata, muchii[1001], rezidual[1001], cap;
vector<bool> viz;

int bfs(int src, int dest){
    queue<int> q;

    for(int i = 0; i <= n; i++){
        tata[i] = -1;
        cap[i] = 0;
    }

    cap[src] = INT_MAX;
    q.push(src);

    while(!q.empty()){
        int nod = q.front();
        q.pop();

        for(auto vec: muchii[nod]){
            if(tata[vec] == -1){
                if(muchie[nod][vec].second - muchie[nod][vec].first > 0){
                    tata[vec] = nod;
                    cap[vec] = min(cap[nod], muchie[nod][vec].second - muchie[nod][vec].first);

                    if(vec == dest)
                        return cap[dest];

                    q.push(vec);
                }
            }
        }
    }
    return 0;
}

int flux(int src, int dest){
    int f_max = 0, f = bfs(src, dest);

    while(f != 0){
        f_max += f;

        for(int nod = dest; nod != src; nod = tata[nod]){
            muchie[tata[nod]][nod].first += f;
            muchie[nod][tata[nod]].first -= f;
        }
        f = bfs(src, dest);
    }

    return f_max;
}

void dfs(int nod){
    viz[nod] = 1;
    for(auto vec: rezidual[nod])
        if(viz[vec] == 0)
            dfs(vec);
}


void taietura_min(int src, int dest){
    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= n; j++){
            if(muchie[i][j].first < 0)
                rezidual[j].push_back(j);
            else
                rezidual[i].push_back(i);
        }
    }
    viz = vector<bool>(n + 1, 0);
    dfs(src);

    for(int i = 1; i <= n; i++){
        for(int j = 0; j < muchii[i].size(); j++){
            if(viz[i] && !viz[muchii[i][j]])
                out << i <<" "<< muchii[i][j]<<"\n";
        }
    }
}

int main()
{
    in >> n >> m;
    tata.resize(n+1);
    cap.resize(n+1);

    int x, y, z;
    for(int i = 1; i <= m; i++){
        in >> x >> y >> z;
        muchie[x][y].second = z;
        muchie[x][y].first = 0;
        muchii[x].push_back(y);
        muchii[y].push_back(x);
    }

    out << flux(1, n) << "\nTaietura minima:\n";
    taietura_min(1, n);

    return 0;
}
