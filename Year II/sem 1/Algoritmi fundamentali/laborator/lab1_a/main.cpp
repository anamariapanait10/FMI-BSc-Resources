#include <fstream>
#include <vector>
using namespace std;

ifstream in("graf.in");
ofstream out("graf.out");

int n, m, mat[1000][1000];
vector<vector<int>> adj(1000);
int orientat;

void citire_matrice(){
    int a, b;
    in >> orientat;
    in >> n >> m;
    for(int i = 0; i < m; i++){
        in >> a >> b;
        mat[a][b] = 1;
        if(orientat)
            mat[b][a] = 1;
    }
}

void citire_mat_adj(){
    in >> orientat;
    in >> n >> m;
    int a, b;
    for(int i = 0; i < m; i++){
        in >> a >> b;
        adj[a].push_back(b);
        if(orientat)
            adj[b].push_back(a);
    }
}

void afisare_matrice(){
    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= n; j++){
            out << mat[i][j] <<" ";
        }
        out <<"\n";
    }
}

void afisare_matrice_adj(){
    for(int i = 1; i <= n; i++){
        out << i <<": ";
        for(int j = 0; j < adj[i].size(); j++){
            out << adj[i][j] <<" ";
        }
        out <<"\n";
    }
}

void from_mat_to_lista(){
    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= n; j++){
            if(mat[i][j] == 1)
                adj[i].push_back(j);
        }
    }
}

void from_lista_to_mat(){
    for(int i = 1; i <= n; i++){
        for(int j = 0; j < adj[i].size(); j++)
            mat[i][j] = 1;
    }
}

int main()
{
    //citire_matrice();
    citire_mat_adj();
    //from_mat_to_lista();
    from_lista_to_mat();
    afisare_matrice();

    /*
    1
7 8
1 3
2 4
3 4
3 5
3 6
5 6
6 7
3 7
*/

    return 0;
}
