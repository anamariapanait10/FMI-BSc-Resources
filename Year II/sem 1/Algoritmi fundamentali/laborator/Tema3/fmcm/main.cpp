/*
Problema Flux maxim de const minim, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://infoarena.ro/job_detail/2962313


Complexitate timp: O(n*m^2*log n)
Complexitate memorie: O(n^2)
*/
#include <fstream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;

ifstream in("fmcm.in");
ofstream out("fmcm.out");

int n, m, src, dest, cost_min;
int a[351][351], cost[351][351], tata[351], dist_bell[351], dist[351], dist_act[351];
vector<vector<int>> adj(351);
priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;

void bellman_ford() {
    for(int i = 1; i <= n; i++)
        dist_bell[i] = INT_MAX;

    vector<bool> in_pq(351);
    queue<int> coada;
    coada.push(src);
    in_pq[src] = true;
    dist_bell[src] = 0;

    while(!coada.empty()) {
        int nod = coada.front();
        coada.pop();
        in_pq[nod] = false;
        for(auto vec: adj[nod]) {
            if(a[nod][vec])
            if(dist_bell[vec] > dist_bell[nod] + cost[nod][vec]){
                dist_bell[vec] = dist_bell[nod] + cost[nod][vec];
                if(!in_pq[vec]){
                    coada.push(vec);
                    in_pq[vec] = true;
                }
            }
        }
    }
}

bool dijkstra() {
    for(int i = 1; i <= n; i++)
        dist[i] = INT_MAX;
    dist[src] = 0;
    dist_act[src] = 0;

    pq.push(make_pair(0, src));
    while(!pq.empty() ) {
        pair<int, int> front = pq.top();
        pq.pop();

        int nod = front.second;
        if(dist[nod] == front.first) {
            for(auto vec: adj[nod]) {
                if(a[nod][vec] > 0) {
                    if(dist[vec] > dist[nod] + cost[nod][vec] + dist_bell[nod] - dist_bell[vec] ) {
                        dist[vec] = dist[nod] + cost[nod][vec] + dist_bell[nod] - dist_bell[vec];
                        pq.push(make_pair(dist[vec], vec));
                        dist_act[vec] = dist_act[nod] + cost[nod][vec];
                        tata[vec] = nod;
                    }
                }
            }
        }
    }

    for(int i = 1; i <= n; i++)
        dist_bell[i] = dist_act[i];

    if(dist[dest] == INT_MAX)
        return false;

    int cap = INT_MAX;
    for(int nod = dest; nod != src; nod = tata[nod])
        cap = min(cap, a[tata[nod]][nod]);

    for(int nod = dest; nod != src; nod = tata[nod]) {
        a[tata[nod]][nod] -= cap;
        a[nod][tata[nod]] += cap;
    }

    cost_min += cap * dist_act[dest];
    return true;
}


int main()
{
    int x, y, c, z;
    in >> n >> m >> src >> dest;

    for(int i = 0; i < m; i++) {
        in >> x >> y >> c >> z;
        adj[x].push_back(y);
        adj[y].push_back(x);
        a[x][y] = c;
        cost[x][y] = z;
        cost[y][x] = -z;
    }

    bellman_ford();
    while(dijkstra());

    out << cost_min << '\n';

    return 0;
}
