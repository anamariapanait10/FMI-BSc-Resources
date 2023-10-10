#include <fstream>
#include <vector>
#include <queue>

using namespace std;

ifstream in("maxflow.in");
ofstream out("maxflow.out");

vector<int> tata;
vector<vector<int>> adj, c;
int n;

bool bfs(int src){
    queue<int> coada;
    vector<bool> viz(n+1);

    coada.push(src);
    viz[src] = true;
    tata[src] = -1;

    while(!coada.empty()){
        int nod = coada.front();
        coada.pop();
        for(auto vec: adj[nod]){
            if(c[nod][vec] > 0 && !viz[vec]){
                tata[vec] = nod;
                if(vec == n)
                    return true;
                viz[vec] = true;
                coada.push(vec);
            }
        }
    }

    return false;
}

int main()
{
    int m, x, y, z;
    in >> n >> m;
    adj.resize(n+1);
    c.resize(n+1, vector<int>(n+1));
    while(m--){
        in >> x >> y >> z;
        c[x][y] = z;
        adj[x].push_back(y);
        adj[y].push_back(x);
    }
    tata.resize(n+1);
    unsigned int cap_max = 0;
    while(bfs(1)){
        int cap =  1<<13;
        for (int nod = n; nod != 1; nod = tata[nod])
            cap = min(cap, c[tata[nod]][nod]);

        for (int nod = n; nod != 1; nod = tata[nod]){
            c[tata[nod]][nod] -= cap;
            c[nod][tata[nod]] += cap;
        }

        cap_max += cap;
    }

    out << cap_max;

    return 0;
}
