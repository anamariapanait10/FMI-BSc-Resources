#include <fstream>
#include <vector>

using namespace std;

ifstream in("hashuri.in");
ofstream out("hashuri.out");

#define MOD 666013

vector <int> h[MOD];

int main()
{
    int n, op, x;
    in >> n;
    for(int i = 0; i < n; i++){
        in >> op >> x;
        if(op == 1){
            bool exista = false;
            int n = h[x % MOD].size();
            for(int j = 0; j < n && !exista; j++)
                if(x == h[x % MOD][j])
                    exista = true;
            if(!exista)
                h[x % MOD].push_back(x);
        } else if(op == 2){
            bool exista = false;
            int n = h[x % MOD].size();
            for(int j = 0; j < n && !exista; j++)
                if(x == h[x % MOD][j]){
                    int aux = h[x % MOD][j];
                    h[x % MOD][j] = h[x % MOD][n-1];
                    h[x % MOD][n-1] = aux;
                    h[x % MOD].pop_back();
                    exista = true;
                }
        } else if(op == 3){
            bool exista = false;
            int n = h[x % MOD].size();
            for(int j = 0; j < n && !exista; j++)
                if(x == h[x % MOD][j])
                    exista = true;
            if(exista)
                out << 1 << '\n';
            else
                out << 0 <<'\n';
        }
    }

    return 0;
}
