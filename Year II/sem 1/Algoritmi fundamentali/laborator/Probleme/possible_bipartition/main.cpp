#include <fstream>
#include <vector>
#include <deque>

using namespace std;

ifstream in("bipartit.in");
ofstream out("bipartit.out");

vector<vector<int>> possibleBipartition(int n, vector<vector<int>>& dislikes) {
    int vis[2001] = {0};
    deque<int> deq;
    vector<vector<int>> adj(n+1);
    vector<vector<int>>res;

    for (auto x: dislikes){
        adj[x[0]].push_back(x[1]);
        adj[x[1]].push_back(x[0]);
    }

    for(int i = 1; i <= n; i++){
        if(vis[i] == 0){

            // bfs
            deq.push_back(i);
            vis[i] = 1;

            while(!deq.empty()){
                int x = deq.front();

                for(int j = 0; j < adj[x].size(); j++){
                    if(vis[adj[x][j]] == 0){
                        vis[adj[x][j]] = 3 - vis[x];
                        deq.push_back(adj[x][j]);
                    } else if(vis[adj[x][j]] == vis[x]){
                        return res;
                    }

                }
                deq.pop_front();
            }

        }
    }
    vector<int> part1, part2;
    for(int i = 1; i <= n; i++){
        if(vis[i] == 1){
            part1.push_back(i);
        } else
            part2.push_back(i);
    }
    res.push_back(part1);
    res.push_back(part2);
    return res;
}

int main()
{

    int n, m;
    in >> n >> m;
    vector<vector<int>> dislikes;
    int a, b;
    for(int i = 0; i < m; i++){
        in >> a >> b;
        vector<int> aux{a, b};
        dislikes.push_back(aux);
    }



    vector<vector<int>> res = possibleBipartition(n, dislikes);
    if(!res.size()){
        out << "NU";
    } else {
        out << "DA\n";
        for(int i = 0; i < res[0].size(); i++){
            out << res[0][i] <<" ";

        }
        out <<"\n";
        for(int i = 0; i < res[1].size(); i++){
            out << res[1][i] <<" ";
        }
    }

    return 0;
}

