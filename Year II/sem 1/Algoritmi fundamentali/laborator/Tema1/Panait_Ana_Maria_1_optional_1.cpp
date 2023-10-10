/*
Problema Critical Connections in a Network
Link unde se poate vedea ca solutia a luat 100 de pct: https://leetcode.com/problems/critical-connections-in-a-network/submissions/837210096/

Idee:
    S-a folosit algoritmul lui Tarjan pentru determinarea conexiunilor critice.
    Pe scurt, fiecare nod primeste un id si vom determina pentru fiecare pe masura ce parcurgem
    graful prin dfs care e cel mai mic id la care poate ajunge nodul curent. Initial,
    pentru fiecare nod, cel mai mic id la care poate ajunge e chiar el.
    Nodurile isi vor actualiza cel mai mic id la care pot ajunge la intoarcerea din recursie.
    Daca la intoarcerea din recursivitate am gasit ca un nod are cel mai mic id la care poate ajunge egal cu
    cel al vecinului din care ne-am intors inseamna ca muchia dintre ele nu este critica.
    Daca cand ne intoarcem din recursie nodul curent nu isi actualizeaza minimul si are minimul diferit
    de nodul vecin inseamna ca muchia dintre ele este critica. Deci va fi adaugata la solutie.

Complexitatea timp: O(n+e), unde n este numarul de noduri si e este numarul de muchii

*/

#include <iostream>
#include <vector>
using namespace std;

class Solution {
    int nextId = 0;
public:
    void tarjan(vector<int> adj[], int parentId, int nodeId,
    int visited[], int lowestId[], vector<vector<int>>& ans){

        visited[nodeId] = 1;
        lowestId[nodeId] = nextId++;
        int currentNodeLowestId = lowestId[nodeId];
        for(int neighbourId: adj[nodeId]){
            if(neighbourId == parentId) // ca sa evitam ciclarea
                continue;

            if(visited[neighbourId] == 0){
                tarjan(adj, nodeId, neighbourId, visited, lowestId, ans);
            }

            lowestId[nodeId] = min(lowestId[nodeId], lowestId[neighbourId]);

            if(currentNodeLowestId < lowestId[neighbourId])
                ans.push_back(vector<int>{nodeId, neighbourId});
        }
    }
    vector<vector<int>> criticalConnections(int n, vector<vector<int>>& connections) {
        vector<int> adj[n];
        int visited[n];
        int lowestId[n];

        // initial niciun nod nu e vizitat
        for(int i = 0; i < n; i++)
            visited[i] = 0;

        // construiesc lista de adiacenta
        for(int i = 0; i < connections.size(); i++){
            adj[connections[i][0]].push_back(connections[i][1]);
            adj[connections[i][1]].push_back(connections[i][0]);
        }

        vector<vector<int>> ans;
        tarjan(adj, -1, 0, visited, lowestId, ans);
        return ans;
    }
};


int main()
{
    int n, m, a, b;
    cin >> n >> m;
    vector<vector<int>> v, ans;
    for(int i = 0; i < m; i++){
        cin >> a >> b;
        v.push_back(vector<int>{a, b});
    }
    Solution S = Solution();
    ans = S.criticalConnections(n, v);
    for(int i = 0; i < ans.size(); i++){
        cout << ans[i][0] <<" "<< ans[i][1]<<"\n";
    }
    return 0;
}
