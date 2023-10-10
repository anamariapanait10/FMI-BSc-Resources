/*
Complexitate timp: O(mlog(n))
*/
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

ifstream in("transport2.in");
ofstream out("transport2.out");

vector<pair<int, int>> adj[100001];
queue<int> q;
int n, m, viz[100001];

bool bfs(int cost_min){
    q.push(1);
    viz[1] = cost_min;

    while(!q.empty()){
        int node = q.front();
        q.pop();

        for(auto vec: adj[node])
            if(viz[vec.first] != cost_min && vec.second >= cost_min){
                q.push(vec.first);
                viz[vec.first] = cost_min;
            }
    }

    if(viz[n] == cost_min)
        return true;

    return false;
}

int cautare_binara(int st, int dr){
    int r = dr;
    while(st <= dr){
        int mij = (st + dr) / 2;
        if(bfs(mij)){
            // am gasit drum pentru adjeutatea curenta
            st = mij + 1;
            r = mij;
        } else // caut adjeutate mai mica
            dr = mij - 1;
    }

    return r;
}


int main()
{
    int a, b, c;
    in >> n >> m;

    for(int i = 1; i <= m; i++){
        in >> a >> b >> c;
        adj[a].push_back({b, c});
        adj[b].push_back({a, c});
    }

    out << cautare_binara(1, 10000);

    return 0;
}
