#include <fstream>
#include <vector>
#include <climits>

using namespace std;

ifstream in("adn.in");
ofstream out("adn.out");


string a[20];
bool iesire[20];
int pos[20], cost[20][20], pred[20][1<<20], c[20][1<<20], pi[20][30001];
vector<int> sol;
vector<string> v;
int n;

void prefix(){
	for (int i = 0; i < n; i++){
		int k = -1;
		pi[i][0] = -1;
		for (int j = 1; j < a[i].size(); j++){
			while (k != -1 && a[i][k + 1] != a[i][j])
				k = pi[i][k];
			if (a[i][k + 1] == a[i][j])
                k++;
			pi[i][j] = k;
		}
	}
}

bool kmp(int s1, int s2){
	int k = -1;
	for (int i = 0; i < a[s1].size(); i++){
		while (k != -1 && a[s2][k + 1] != a[s1][i])
			k = pi[s2][k];

		if (a[s1][i] == a[s2][k+1])
			k++;

		if (k == a[s2].size() - 1)
			return 1;
	}
	return 0;
}

void calculeaza_cost(){
	for(int s1 = 0; s1 < n; s1++)
		for(int s2 = 0; s2 < n; s2++){
			if(s1 == s2)
                continue;
			int k = -1;
			for(int i = 0; i < v[s1].size(); i++){
				while(k != -1 && v[s2][k + 1] != v[s1][i])
					k = pi[pos[s2]][k];
				if (v[s1][i] == v[s2][k + 1]){
					k++;
					if (i == v[s1].size() - 1)
						cost[s1][s2] = k + 1;
				}
			}
		}
}

void hamilton(){
	for(int i = 0; i < n; i++)
		for(int j = 0; j < 1<<n; j++)
			c[i][j] = INT_MIN;

	for (int i = 0; i < n; i++)
		c[i][1<<i] = 0;

	for (int i = 0; i < 1 << n; i++)
		for (int j = 0; j < n; j++)
			if (i & (1 << j)){
				for (int k = 0; k < n; k++)
					if (i & (1 << k)){
						int aux = c[k][i ^ (1<<j)] + cost[k][j];
						if (aux >= c[j][i]){
							c[j][i] = aux;
							pred[j][i] = k;
						}
					}
			}
}

void drum(){
	int mask = (1 << n) - 1, maxim = 0;
	for(int i = 1; i < n; i++)
		if(c[maxim][mask] < c[i][mask])
			maxim = i;

   	for (int i = 0; i < n; i++){
		sol.push_back(maxim);
		maxim = pred[maxim][mask];
		mask ^= (1<<sol.back());
	}
}

int main()
{

	in >> n;
	for(int i = 0; i < n; i++)
		in >> a[i];

	prefix();

	for(int i = 0; i < n - 1; i++)
		for(int j = i + 1; j < n; j++)
			if (a[i].size() > a[j].size() && !iesire[j])
				iesire[j] = kmp(i, j);
			else if (a[i].size() <= a[j].size() && !iesire[i])
				iesire[i] = kmp(j, i);

    for (int i = 0; i < n; i++)
   		if (!iesire[i]){
   			pos[v.size()] = i;
   			v.push_back(a[i]);
   		}

    n = v.size();
   	if (n == 1){
    	out << v[0] << '\n';
    	return 0;
 	}

    calculeaza_cost();
    hamilton();
	drum();

	for (int i = n - 1; i >= 0; i--){
		if (i == n - 1)
			out << v[sol[i]];
		else
			out << v[sol[i]].substr(cost[sol[i+1]][sol[i]]);
    }
}
