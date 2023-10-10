#include <iostream>
#include <vector>

using namespace std;

vector<vector<int>> adj;
vector<int> bMatch;
int viz[1001], cnt = 1, N;

bool dfs(int x) {
	if (viz[x] == cnt)
	    return 0;
	viz[x] = cnt;
	for(int v: adj[x])
		if (bMatch[v] == -1 || dfs(bMatch[v])) {
			bMatch[v] = x;
			return 1;
		}
	return 0;
}

int bipartiteMatching() {
	int ret = 0;
	bMatch = vector<int>(N, -1);
	for (int i = 0; i < N; i++) { // O(V)
		ret += dfs(i);
		cnt++;
	}
	return ret;
}
int main() {
    int j, D;
    cin >> N;
    adj = vector<vector<int>>(N);
    for(int i = 0; i < N; i++)
        for(int j = 0; j < N; j++){
            cin >> D;
            if(D)
                adj[i].push_back(j);
    }

    bool folosit[1001]={};
    vector<int> unde(N);
    for(int i = 0; i < N; i++)
        unde[i] = i;
    if(bipartiteMatching() == N) {
        for(int i = 0; i < N; i++)
            if(unde[i] != bMatch[i]) {
                for(j = 0; j < N; j++)
                    if(unde[j] == bMatch[i])
                        break;
                cout <<"C "<< unde[j] + 1 <<" "<<unde[i] + 1<<'\n';
                swap(unde[j], unde[i]);
            }
    } else
        cout << -1;

	return 0;
}
