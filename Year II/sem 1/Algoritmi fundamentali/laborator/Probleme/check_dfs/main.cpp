/*
Check DFS, CSAcademy

Idee:
    Se sorteaza fiecare lista de adiacenta folosind ca comparator ordinea din permutare a nodurilor.
    Pentru acest comparator m-am ajutat de vectorul invers al permutarii care indica pt rev_perm[i] pe
    ce pozitie se afla i in permutare. Apoi se parcurge graful cu dfs si verificam daca se parcurg
    nodurile in ordinea data. Pentru asta m-am folosit de permutarea citita din care tot scot cate
    un element din fata pe masura ce verific sa a fost parcurs nodul din fata.

Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de muchii
*/

#include <iostream>
#include <vector>
#include <algorithm>
#include <deque>

using namespace std;

vector<vector<int>> adj(100000);
deque<int> perm, rev_perm(100000);
int vis[100000];
bool exists_solution = true;

void dfs(int k){
  vis[k] = 1;
  perm.pop_front(); // a fost parcurs nodul din permutare
  for(int i = 0; i < adj[k].size(); i++)
    if(adj[k][i] == perm.front() && vis[adj[k][i]] == 0){
        dfs(adj[k][i]);
    } else if(adj[k][i] != perm.front() && vis[adj[k][i]] == 0){
        exists_solution = false; // nu exista solutie si ne oprim
        return;
    }
}

bool comparator(int a, int b){
    return rev_perm[a] < rev_perm[b];
}

int main() {

    int n, m, x;
    cin >> n >> m;
    for(int i = 1; i <= n; i++){
        cin >> x;
        perm.push_back(x);
        rev_perm[x] = i;
    }
    // construire lista de adiacenta
    int a, b;
    for(int i = 0; i < m; i++){
        cin >> a >> b;
        adj[a].push_back(b);
        adj[b].push_back(a);
    }

    // sortare dupa ordinea din permutare
    for(int i = 1; i <= n; i++){
        sort(adj[i].begin(), adj[i].end(), comparator);
    }

    dfs(1);

    if(!exists_solution)
        cout << 0;
    else
        cout << 1;

    return 0;
}
