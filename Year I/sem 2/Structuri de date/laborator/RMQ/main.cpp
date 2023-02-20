#include <fstream>

using namespace std;

ifstream in("rmq.in");
ofstream out("rmq.out");

int rmq[18][100001], v[100000], log2[100001];

int main()
{

	int n, m, x, y;
	in >> n >> m;

	for(int i = 1; i <= n; i++)
        in >> v[i];

	for(int i = 2; i <= n; i++)
		log2[i] = log2[i>>1] + 1;

	for(int i = 1; i <= n; i++)
		rmq[0][i] = v[i];

	for(int i = 1; (1 << i) <= n; i++)
		for (int j = 1; j + (1 << i) - 1 <= n; j++)
            rmq[i][j]= min(rmq[i-1][j], rmq[i-1][j+(1<<(i-1))]);

	int l;
	for (int i = 1; i <= m; i++){
		in >> x >> y;
		l = log2[y - x + 1];
		out << min(rmq[l][x], rmq[l][y - (1<<l) + 1]) <<"\n";
	}
	return 0;
}
