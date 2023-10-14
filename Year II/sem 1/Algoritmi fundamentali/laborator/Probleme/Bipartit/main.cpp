#include <fstream>
#include <vector>
#include <deque>

using namespace std;

ifstream in("bipartit.in");
ofstream out("bipartit.out");

int mat[101][101], viz[101], n;
deque<int> coada;
bool biparit = true;

void bfs(int k){
    coada.push_back(k);
    viz[k] = 1;
    while(!coada.empty()){
        int x = coada.front();
        for(int i = 1; i <= n; i++){
            if(mat[x][i] == 1){
                if(viz[i] == 0){
                    coada.push_back(i);
                    viz[i] = 3 - viz[x];
                } else if(viz[x] == viz[i]){
                    biparit = false;
                    return;
                }
            }
        }
        coada.pop_front();
    }

}

int main()
{
    int m;
    in >> n >> m;
    int a, b;
    for(int i = 0; i < m; i++){
        in >> a >> b;
        mat[a][b] = mat[b][a] = 1;
    }

    for(int i = 1; i <= n; i++){
        if(viz[i] == 0){
            bfs(i);
            if(!biparit){
                out <<"NU";
                return 0;
            }
        }
    }

    out << "DA\n";
    for(int i = 1; i <= n; i++){
        if(viz[i] == 1){
            out << i<<" ";
        }
    }
    out <<"\n";
    for(int i = 1; i <= n; i++){
        if(viz[i] == 2){
            out << i<<" ";
        }
    }

    return 0;
}
