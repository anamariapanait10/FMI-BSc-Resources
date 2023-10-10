/*
Problema Lesbulan, Infoarena
Link unde se poate vedea ca solutia a luat 100 de pct: https://infoarena.ro/job_detail/2935746

Complexitate timp: O(n*m), unde n e numarul de noduri si m numarul de muchii
Complexitate spatiu: O(n*m), unde n e numarul de noduri si m numarul de muchii

*/

#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

ifstream in("lesbulan.in");
ofstream out("lesbulan.out");

vector<int> adj[51];
int n;
bool visited[51], solution;


void dfs(int i, int f) {
    visited[i] = true;
    if(adj[i].size() > 2)
        solution = false;

    for(int j = 0; j < adj[i].size(); j++) {
        if (adj[i][j] == f)
            continue;
        if (!visited[adj[i][j]])
            dfs(adj[i][j], i);
        else
            solution = false;
    }
}

void eliminare_frunze() {
    vector<int> frunze;

    for (int i = 1; i <= n; i++)
        if (adj[i].size() == 1) // daca e frunza
            frunze.push_back(i);

    cout <<"frunze\n";
    for(int i = 0; i < frunze.size(); i++){
        cout << frunze[i] <<" ";
    }
    cout << '\n';
    for(auto f: frunze){
        // il eliminam pe f din listele de vecini ale nodurilor
        for (int i = 1; i <= n; i++){
            auto it = find(adj[i].begin(), adj[i].end(), f);
            if(it != adj[i].end())
                adj[i].erase(it);
        }

        adj[f].clear(); //eliminam vecinii lui f

        for(int i = 1; i <= n; i++){
            cout << i <<": ";
            for(int j = 0; j < adj[i].size(); j++){
                cout << adj[i][j] <<" ";
            }
            cout <<'\n';
        }
    }

}

void solve() {

    // eliminam de doua ori frunzele din graf
    for(int i = 1; i <= 2; i++)
        eliminare_frunze();

    solution = true;
    for(int i = 1; i <= n; i++)
        if(adj[i].size() <= 1 && !visited[i]) // daca este funza sau nod izolat si nevizitat
            dfs(i, 0);

    for (int i = 1; i <= n; i++)
        if (!visited[i])
            solution = false;
}

int main()
{
    int t, m, x, y;
    in >> t;
    for(int i = 0; i < t; i++){
        in >> n >> m;
        // construiesc lista de adiacenta
        for(int j = 0; j < m; j++){
            in >> x >> y;
            adj[x].push_back(y);
            adj[y].push_back(x);
        }
        for(int ii = 1; ii <= n; ii++){
        cout << ii <<": ";
            for(int j = 0; j < adj[ii].size(); j++){
                cout << adj[ii][j] <<" ";
            }
            cout <<'\n';
        }

        solve();

        if(!solution){
            out << 0 <<'\n';
        } else {
            out << 1 <<'\n';
        }

        // initializez pt urmatoarele teste
        for(int i = 1; i <= n; i++){
            adj[i].clear();
            visited[i] = false;
        }
    }

    return 0;
}
