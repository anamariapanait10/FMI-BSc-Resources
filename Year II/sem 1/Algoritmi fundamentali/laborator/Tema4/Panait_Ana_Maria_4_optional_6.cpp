#include<fstream>
#include<vector>
#include<climits>
#include<queue>

using namespace std;

ifstream in("dbz.in");
ofstream out("dbz.out");

int n, m, vizitat[1501], rez, dp[1501], t, pr[1501];
vector<pair<int, int>> v[1501];
priority_queue<pair<int, int>> q;

void bf() {
    int nod, val;
    while (!q.empty()) {
        val = -q.top().first;
        nod = q.top().second;
        q.pop();
        if (val != dp[nod])
            continue;
        for (pair<int, int> i: v[nod]) {
            if (dp[nod] + i.second < dp[i.first] || !vizitat[i.first]) {
                vizitat[i.first] = 1;
                dp[i.first] = dp[nod] + i.second;
                q.push({-dp[i.first], i.first});
                if (nod == t)
                    pr[i.first] = i.first;
                else
                    pr[i.first] = pr[nod];
            }
        }
    }
    for (int i = 1; i <= n; i++) {
        if (vizitat[i] == 1) {
            for (pair<int, int> j: v[i]) {
                if (j.first != t) {
                    if (vizitat[j.first] == 1 && pr[i] != pr[j.first]) {
                        if (i == t && pr[j.first] == j.first)
                            continue;
                        rez = min(rez, dp[i] + dp[j.first] + j.second);
                    }
                }
            }
        }
    }
}

int main() {
    in >> n >> m;

    while (m--) {
        int x, y, z;
        in >> x >> y >> z;
        v[x].push_back({y, z});
        v[y].push_back({x, z});
    }

    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            vizitat[j] = pr[j] = 0;
            dp[j] = INT_MAX;
        }
        dp[i] = 0;
        vizitat[i] = 1;
        q.push({0, i});
        rez = INT_MAX;
        t = i;
        bf();
        if (rez == INT_MAX)
            rez = -1;
        out << rez << ' ';
    }
}
