/*
Problema Catun, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2946826?action=view-source

Idee: Aplicam Dijkstra putin modificat astfel incat sa placem
din toate fortaretele in acelasi timp. Vom retine pentru
fiecare nod distanta minima pana la o fortareata.
    Daca distanta directa de la nodul vecin pana la o fortareata
e mai mare decat distanta de la nodul curent pana la aceasta,
actualizez distanta.
    Voi folosi valori negaive ale distantelor pentru a simula
un priority queue cu min heap.
    Matricea adj imi spune ca exista muchie
de la indice la primul element din pair cu costul
egal cu al doilea element din pair.
    In pq retin care e distanta de la o fortareata pana la
primul element din pair cu costul egal cu al
doilea element din pair.
    In dist voi retine distanetele nodului de la indicele i
pana la cea mai apropiata fortareata.
    In sol voi retine fortareata cea mai apropiata de nodul
de la indicele i.

Complexitate timp: O(n^2)
*/

#include <fstream>
#include <queue>
#include <vector>
#include <climits>

using namespace std;

ifstream in("catun.in");
ofstream out("catun.out");

vector <vector<pair<int, int>>> adj;
priority_queue <pair<int ,int>> pq;
vector <int> sol, dist;

void dijkstra(){
    while (!pq.empty()){
        int nod = pq.top().first;
        pq.pop();

        for (int i = 0; i < adj[nod].size(); i++){
            int vecin = adj[nod][i].first;

            if (dist[vecin] > dist[nod] + adj[nod][i].second){
                dist[vecin] = dist[nod] + adj[nod][i].second;
                sol[vecin] = sol[nod];
                pq.push(make_pair(vecin, -dist[vecin]));
            } else if(dist[vecin] == dist[nod] + adj[nod][i].second){
                if(sol[nod] < sol[vecin]){
                    sol[vecin] = sol[nod];
                    pq.push(make_pair(vecin, -dist[vecin]));
                }
            }
        }
    }
}

int main()
{
    int n, m, k, x, y, c, f;

    in >> n >> m >> k;

    dist.resize(n+1, INT_MAX);
    adj.resize(n+1);
    sol.resize(n+1);

    for (int i = 1; i <= k; i++){
        in >> f;
        dist[f] = 0;
        sol[f] = f;
        pq.push(make_pair(f, 0));
    }

    for (int i = 1; i <= m; i++){
        in >> x >> y >> c;
        adj[x].push_back(make_pair(y, c));
        adj[y].push_back(make_pair(x, c));
    }

    dijkstra();

    for (int i = 1; i <= n; i++){
        if (sol[i] == i){ // daca e fortareata
            out << 0 <<" ";
        } else {
            out << sol[i] <<" ";
        }
    }


    return 0;
}
