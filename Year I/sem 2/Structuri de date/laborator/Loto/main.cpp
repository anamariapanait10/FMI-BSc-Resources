#include <fstream>
#include <unordered_map>

using namespace std;

ifstream in("loto.in");
ofstream out("loto.out");

const int p = 666013;

unordered_map<int, tuple<int, int, int>> dict;
int v[100];

int main()
{

    int n, s;
    in >> n >> s;
    for(int i = 0; i < n; i++)
        in >> v[i];

    for(int i = 0; i < n; i++)
        for(int j = i; j < n; j++)
            for(int k = j; k < n; k++)
                dict[v[i] + v[j] + v[k]] = {i, j, k};

    for(int i = 0; i < n; i++)
        for(int j = i; j < n; j++)
            for(int k = j; k < n; k++){
                int aux = s - v[i] - v[j] - v[k];
                if (dict.find(aux) != dict.end()){
                    out << v[i]<<' '<<v[j]<<' '<<v[k]<<' '<<v[get<0>(dict[aux])]<<' '<<v[get<1>(dict[aux])]<<' '<<v[get<2>(dict[aux])];
                    return 0;
                }
            }
    out << -1;
    return 0;
}
