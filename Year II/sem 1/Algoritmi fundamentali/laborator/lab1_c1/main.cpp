#include <fstream>
#include <iostream>
#include <vector>
using namespace std;

ifstream in("dfs.in");
ofstream out("dfs.out");

vector<int> mat[100005];
vector<vector<int>> avansare;
int viz[100005];

void DFS(int x){
    viz[x] = 1;
    for(unsigned int i = 0; i < mat[x].size(); i++){
        int nodcurent = mat[x][i];
        if(viz[nodcurent] == 0){
            DFS(nodcurent);
            cout << x <<" "<< nodcurent<<"\n";
        }
    }
}

int main()
{
    int n, m, x, y;
    cin >> n >> m;
    for(int i = 1; i <= m; i++){
        cin >> x >> y;
        mat[x].push_back(y);
        mat[y].push_back(x);
    }

    cout <<"arce de avansare:\n";
    int cc = 0;
    for(int i = 1; i <= n; i++){
        if(viz[i] == 0){
            DFS(i);
            cc++;
        }
    }
    out << cc;
    return 0;
}
