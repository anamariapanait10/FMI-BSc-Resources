/*
Problema propusa

Idee:
    Parcurgem graful folosind bfs din toate punctele de control ca sa aflam
    distanta minima de la ele la celelalte noduri. Parcurgerea se face simultan din
    toate punctele de control si la vectorul de distanta de adauga 1 la fiecare muchie.
    Distanta de la un punct de control la el e 0.

Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)


*/

#include <fstream>
#include <vector>
#include <queue>

using namespace std;

ifstream in("graf.in");
ofstream out("graf.out");

vector<int> adj[1000];
queue<int> coada;
int dist[1000], viz[1000];

void bfs(){
    while(!coada.empty()){
        int x = coada.front();
        coada.pop();
        for(int j = 0; j < adj[x].size(); j++){
            if(viz[adj[x][j]] == 0){
                viz[adj[x][j]] = 1;
                dist[adj[x][j]] = dist[x] + 1;
                coada.push(adj[x][j]);
            }
        }
    }
}


int main()
{
    int n, m, x, y;
    in >> n >> m;
    // construire lista de adiacenta
    for(int i = 0; i < m; i++){
        in >> x >> y;
        adj[x].push_back(y);
        adj[y].push_back(x);
    }
    // adaugam in coada toate punctele de control
    int nr;
    while(in >> nr){
        viz[nr] = 1;
        coada.push(nr);
    }
    // facem bfs din toate punctele de control
    bfs();

    //afisam distantele
    for(int i = 1; i <= n; i++){
        out << dist[i] <<" ";
    }

    return 0;
}
