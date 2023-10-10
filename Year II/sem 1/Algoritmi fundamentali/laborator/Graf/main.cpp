/*
Problema Graf, Infoarena
Link unde se poate vedea ca solutia a luat 100 de pct: https://www.infoarena.ro/job_detail/2924767

Complexitate timp O(n+m), unde n e numarul de noduri si m numarul de muchii
Complexitate memorie O(n+m), unde n e numarul de noduri si m numarul de muchii
*/

#include <fstream>
#include <vector>
#include <queue>
using namespace std;

ifstream in("graf.in");
ofstream out("graf.out");

int n, m, x, y, dx[7505], dy[7505];
vector<int> graf[7505], viz(7505), sol;

void bfs(int x, vector<int> viz, int dist[]){
    queue<int> coada;
    viz[x] = 1;
    coada.push(x);
    dist[x] = 0;
    while(!coada.empty()) {
        int nod = coada.front();
        for(int i = 0; i < graf[nod].size(); i++){
            if(!viz[graf[nod][i]]) {
                viz[graf[nod][i]] = 1;
                coada.push(graf[nod][i]);
                dist[graf[nod][i]] = dist[nod] + 1;
            }
        }
        coada.pop();
    }
}

void find_solution(){
    int ap[7505] = {0};
    for(int i = 1; i <= n; i++)
        if(dx[i] + dy[i] == dx[y])
            ap[dx[i]]++;

    // ca sa fie un nod in toate drumurile optime trebuie sa fie unic pe drumul pe care se afla
    for(int i = 1; i <= n; i++)
        if(dx[i] + dy[i] == dx[y] && ap[dx[i]] == 1)
            sol.push_back(i);
}

int main()
{
    in >> n >> m >> x >> y;
    int a, b;
    // facem lista de adiacenta
    for(int i = 0; i < m; i++){
        in >> a >> b;
        graf[a].push_back(b);
        graf[b].push_back(a);
    }

    // calculam distanta de la x la celelalte noduri
    bfs(x, viz, dx);
    viz = vector<int>(7505);
    // calculam distanta de la y la celelalte noduri
    bfs(y, viz, dy);
    find_solution();

    out << sol.size() << "\n";
    for (auto nod: sol)
        out << nod << " ";

    return 0;
}
