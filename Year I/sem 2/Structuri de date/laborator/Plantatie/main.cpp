#include <fstream>

using namespace std;

ifstream in("plantatie.in");
ofstream out("plantatie.out");

int rmq[10][501][501];
int log[501];

int main()
{
    int n, m;
    in >> n >> m;

    for(int i = 2; i <= n; i++)
        log[i] = log[i / 2] + 1;

    for(int i = 1; i <= n; i++)
        for(int j = 1; j <= n; j++)
            in >> rmq[0][i][j];

    for(int k = 1; (1 << k) <= n; k++)
        for(int i = 1; i <= n - (1 << k) + 1; i++)
            for(int j = 1; j <= n - (1 << k) + 1; j++){
                int l = 1 << (k - 1);
                rmq[k][i][j] = max(rmq[k-1][i][j], max(rmq[k-1][i+l][j], max(rmq[k-1][i][j+l], rmq[k-1][i+l][j+l])));
            }

    int l;
    for(int p = 1; p <= m; p++){
        int i, j, k;
        in >> i >> j >> k;
        l = log[k];
        out << max(rmq[l][i][j], max(rmq[l][i][j+k-(1<<l)], max(rmq[l][i+k-(1<<l)][j], rmq[l][i+k-(1<<l)][j+k-(1<<l)])))<<'\n';
    }
    return 0;
}
