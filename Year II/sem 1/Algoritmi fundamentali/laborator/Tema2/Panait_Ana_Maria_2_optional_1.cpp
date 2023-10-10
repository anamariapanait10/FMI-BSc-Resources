/*
Problema Min Cost to Connect All Points, LeetCode
Link unde se poate vedea ca a luat 100 de pct: https://leetcode.com/problems/min-cost-to-connect-all-points/submissions/849091879/

Idee: Consideram fiecare punct un nod din graf, iar muchiile
dintre ele au costul egal cu distanta manhattan dintre ele.
Construiesc lista de adiacenta cu probabilitatile
de succes a  traversarii. Ca sa aflam costul minim trebuie
de fapt sa aflam arborele partial de cost minim.
Pentru asta putem folosi algoritmul lui Prim.
Incepem de la un nod si vizitam nodurile vecine
adaugand muchiile dintre ele intr-un min heap.
Apoi luam cea mai mica muchie care conecteaza un nod
care nu e vizitat. Repetam pana cand toate nodurile au
fost vizitate.

Complexitate timp: O(N^2), unde N e numarul de noduri
Complexitate spatiu: O(N)
*/

#include <iostream>

using namespace std;

class Solution {
public:
    int minCostConnectPoints(vector<vector<int>>& ps) {
        int n = ps.size(), res = 0, i = 0, connected = 0;
        vector<bool> visited(n);
        priority_queue<pair<int, int>> pq;
        while (++connected < n) {
            visited[i] = true;
            for (int j = 0; j < n; ++j)
                if (!visited[j])
                    pq.push({-(abs(ps[i][0] - ps[j][0]) + abs(ps[i][1] - ps[j][1])), j});
            while (visited[pq.top().second])
                pq.pop();
            res -= pq.top().first;
            i = pq.top().second;
            pq.pop();
        }
        return res;
    }
};

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
