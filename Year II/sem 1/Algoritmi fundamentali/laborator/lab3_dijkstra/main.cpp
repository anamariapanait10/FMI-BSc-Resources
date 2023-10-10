#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

const int nMax = 50005;
const int mMax = 250005;
const int INF = (1 << 30);

struct arc
{
    arc(int tind = 0, int tcost = 0)
    {
        ind = tind;
        cost = tcost;
    }
    int ind, cost;
};

int n, m;
vector<arc> vecini[nMax];
int dist[nMax];

void citire()
{
    ifstream in("dijkstra.in");
    in >> n >> m;
    int a, b, c;
    for(int i = 1; i <= m; ++i)
    {
        in >> a >> b >> c;
        vecini[a].push_back(arc(b, c));

    }
    in.close();
}

struct cmp
{
    bool operator()(int ind1, int ind2)
    {
        return dist[ind1] > dist[ind2];
    }
};

void rezolvare()
{
    const int start = 1; //nodul de la care plecam
    for(int i = 1; i <= n; ++i)
        dist[i] = INF;

    priority_queue<int, vector<int>, cmp> q;

    // daca am avea mai multe noduri de start, am putea sa le punem pe toate in coada
    dist[start] = 0;
    q.push(start);

    int p;
    while(q.empty() == false)
    {
        p = q.top();
        q.pop();

        for(auto &v: vecini[p])
        {
            if(dist[v.ind] > dist[p] + v.cost)
            {
                dist[v.ind] = dist[p] + v.cost;
                q.push(v.ind);
            }
        }
    }
}

void afisare()
{
    ofstream out("dijkstra.out");
    for(int i = 2; i <= n; ++i)
    {
        if(dist[i] == INF)
            out << 0 << " ";
        else
            out << dist[i] << " ";
    }
    out.close();
}

int main()
{
    citire();
    rezolvare();
    afisare();
    return 0;
}
