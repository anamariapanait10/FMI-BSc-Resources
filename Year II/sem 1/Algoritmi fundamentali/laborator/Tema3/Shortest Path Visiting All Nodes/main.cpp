#include <iostream>

using namespace std;

class Solution {
public:
   int shortestPathLength(vector<vector<int>>& graph) {
        int n = graph.size();
        int all_mask = (1<<n) - 1;
        queue<pair<int, pair<int,int>>> q;
        set<pair<int,int>> viz;

        for(int i = 0; i < n; i++){
            int mask = (1<<i);
            viz.insert({i, mask});
            q.push({i,{0, mask}});
        }

        while(!q.empty()){
            int node = q.front().first;
            int dist = q.front().second.first;
            int mask = q.front().second.second;
            q.pop();

            for(auto i: graph[node]){
                int newmask = (mask | (1<<i));

                if(newmask == all_mask)
                    return dist + 1;
                else if(viz.count({i, newmask}))
                    continue;
                else{
                    q.push({i, {dist+1, newmask}});
                    viz.insert({i, newmask});
                }
            }
        }
        return 0;
    }
};

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
