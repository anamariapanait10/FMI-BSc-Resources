#include<bits/stdc++.h>
using namespace std;

ifstream in("bfs.in");
ofstream out("bfs.out");

vector<int> mat[100005];
queue<int> coada;
vector<int> sol;
int dist[100005], prevv[100005];

void BFS(int nod_plecare){
    coada.push(nod_plecare);
    dist[nod_plecare] = 0;
    int nodcurent, vecin;
    while(!coada.empty()){
        nodcurent= coada.front();
        coada.pop();
        for(int i = 0; i < mat[nodcurent].size(); i++){
            vecin = mat[nodcurent][i];
            if(dist[vecin] == -1){
                coada.push(vecin);
                dist[vecin] = dist[nodcurent] + 1;
                prevv[vecin] = nodcurent;
            }
        }
    }
}

int main()
{
    int n, m, s, a, b, x;
    cin >> n >> m >> s >> x;
    for(int i = 1; i <= n; i++){
        dist[i] = -1;
    }
    for(int i = 1; i <= m; i++){
        cin >> a >> b;
        mat[a].push_back(b);
    }
    prevv[s] = s;
    BFS(s);

    if(dist[x] == -1){
        cout <<"nu exista";
        reutrn 0;
    }

    int nod_curent = x;
    while(nod_curent != s){
        sol.push_back(nod_curent);
        nod_curent = prevv[nod_curent];

    }

    sol.push_back(s);
    reverse(sol.begin(), sol.end());
    for(auto x: sol){
        cout << x<<" ";
    }

    return 0;
}
