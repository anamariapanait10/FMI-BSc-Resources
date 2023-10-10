#include <fstream>
#include <algorithm>
#include <vector>
#include <unordered_map>

using namespace std;

ifstream in("johnie.in");
ofstream out("johnie.out");

int n, m, cnt;
unordered_map <int, vector<int>> sol;
vector<bool> muchii_viz(1000001);
unordered_map <int, vector<pair<int, int>>> adj(50001);
unordered_map <int, int> grad;


void dfs(int nod){
    auto &vec = adj[nod];

    while(!vec.empty()) {
        auto v = vec.back();
        auto nod_vec = v.first;
        auto muchie_vec = v.second;
        vec.pop_back();

        if (!muchii_viz[muchie_vec]) {
            muchii_viz[muchie_vec] = true;
            dfs(nod_vec);
        }
    }

    if (nod == 0)
        cnt++;
    else
        sol[cnt].push_back(nod);
}

void adaugare(){
    for (int i = 1; i <= n; i++)
        if (grad[i] % 2 == 1){
            adj[i].push_back({0, i + m});
            adj[0].push_back({i, i + m});
        }
}


int main()
{
    int x, y;
    in >> n >> m;
    for (int i = 0; i < m; i++){
        in >> x >> y;
        adj[x].push_back({y, i});
        adj[y].push_back({x, i});
        grad[x] += 1;
        grad[y] += 1;
    }

    adaugare();
    dfs(0);

    out << sol.size() << '\n';
    for (auto x: sol){
        out << x.second.size() << " ";
        for (auto y: x.second)
           out << y << " ";
        out << '\n';
    }
    return 0;
}
