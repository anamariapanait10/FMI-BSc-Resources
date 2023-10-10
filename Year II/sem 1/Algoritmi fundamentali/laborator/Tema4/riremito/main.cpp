#include <fstream>
#include <vector>
#include <utility>

using namespace std;

ifstream in("riremito.in");
ofstream out("riremito.out");


struct muc{
	int dest;
	long long dist;
};

void rec(const vector<vector<muc>>& graf, const int curr, const int prev,
	vector<long long>& dist_rad, vector<long long>& cost_cu_intoarcere,
	vector<long long>& cost_fara_intoarcere){

	cost_cu_intoarcere[curr] = cost_fara_intoarcere[curr] = 0;
	long long delta = 0, tmp;
	for(const auto next : graf[curr]){
		if(next.dest != prev){
			dist_rad[next.dest] = dist_rad[curr] + next.dist;
			rec(graf, next.dest, curr, dist_rad, cost_cu_intoarcere, cost_fara_intoarcere);
			cost_cu_intoarcere[curr] += (tmp = min(cost_cu_intoarcere[next.dest] + 2ll*next.dist,
				cost_fara_intoarcere[next.dest] + dist_rad[curr] + next.dist));
			delta = max(delta,
				tmp - cost_fara_intoarcere[next.dest] - next.dist);
        }
    }
	cost_fara_intoarcere[curr] = cost_cu_intoarcere[curr] - delta;
}


long long rezolva_test(const vector<vector<muc>>& graf, const int rad){
	const int n = graf.size();
	vector<long long> dist_rad(n, 0), cost_cu_intoarcere(n, 0), cost_fara_intoarcere(n, 0);
	rec(graf, rad, -1, dist_rad, cost_cu_intoarcere, cost_fara_intoarcere);
	return cost_fara_intoarcere[rad];
}

int main(){

	int n;
	in >> n;
	vector<vector<muc>> graf(n);
	for(int i = 0, x, y; i < n-1; i++){
		long long z;
		in >> x >> y >> z;
		x--;
		y--;
		graf[x].push_back(muc{y, z});
		graf[y].push_back(muc{x, z});
    }
	int m = 0;
	in >> m;
	for(int i = 0, a; i < m; ++i){
		in >> a;
		a--;
		out << rezolva_test(graf, a) << '\n';
    }
	return 0;
}
