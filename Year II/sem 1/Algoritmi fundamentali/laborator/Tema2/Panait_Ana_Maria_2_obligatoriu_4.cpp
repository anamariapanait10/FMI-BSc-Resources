/*
Problema Path with Maximum Probability, LeetCode
Link unde se poate vedea ca a luat 100 de pct: https://leetcode.com/problems/path-with-maximum-probability/submissions/849047101/

Idee:  Folosesc algoritmul lui Djikstra cu max heap
in care voi retine probabilitatea maxima de succes.

Complexitate timp: O(E * logN)
Complexitate spatiu: O(N)
*/

#include <iostream>

using namespace std;


class Solution {
public:
    double maxProbability(int n, vector<vector<int>>& edges, vector<double>& succProb, int start, int end) {
        vector<vector<pair<int, double>>> adj(n);
        // construiesc lista de adiacenta cu probabilitatile de succes a  traversarii
        for(int i = 0; i < edges.size(); i++) {
            adj[edges[i][0]].push_back({edges[i][1],succProb[i]});
            adj[edges[i][1]].push_back({edges[i][0],succProb[i]});
        }

        priority_queue<pair<double, int>> pq;
        pq.push({1.00, start}); // probabilitatea pentru nodul de start este 1
        vector<double> dist(n, 0.00); // pt probabilitatea maxima

        while(!pq.empty()) {
           double d = pq.top().first;
            int nod = pq.top().second;
            pq.pop();

            if (nod == end)
                return d;

            for(auto vec: adj[nod]){
                if(d * vec.second > dist[vec.first]){
                    dist[vec.first] = d * vec.second;
                    pq.push({dist[vec.first], vec.first});
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
