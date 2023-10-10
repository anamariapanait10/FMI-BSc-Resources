/*
Problema Cheapest Flights Within k Stops, LeetCode
Link la solutia mea de 100 de pct: https://leetcode.com/problems/cheapest-flights-within-k-stops/submissions/850622785/

Idee: Pentru a rezolva aceasta problema am folosit algoritmul lui
Dijkstra. In coada de prioritati (min heap) punem perechi de valori
ce reprezinta distanta de la sursa pana la nodul curent,
nodul curent si numarul de stopuri de la sursa pana la
nodul curent.
Cat timp am elemente in coada verificam daca numarul
de stopuri pentru elementul din varf este mai mic decat
eventualele drumuri gasite anterori si daca da actualizam
numarul de stopuri.
Daca am ajuns la destinatie in cel mult k stopuri ne oprim si returnam
costul altfel returnam -1.

Complexitate timp: O(N+E*K*log(EK)), unde E de numarul de zboruri si N numarul de orase
Complexitate spatiu: O(N+E*K)
*/
#include <iostream>

using namespace std;


class Solution {
public:
    int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int k) {
        vector<vector<pair<int, int>>> adj(n);
        for (auto e : flights) {
            adj[e[0]].push_back({e[1], e[2]});
        }
        vector<int> stops(n, INT_MAX);
        priority_queue<vector<int>, vector<vector<int>>, greater<vector<int>>> pq;
        pq.push({0, src, 0});

        while (!pq.empty()) {
            auto temp = pq.top();
            int dist = temp[0];
            int nod = temp[1];
            int steps = temp[2];
            pq.pop();

            // daca deja avem un drum cu mai putine opriri sau
            // numarul de opriri a depasit limita ignoram elementul si trecem la urmatorul
            if (steps > stops[nod] || steps > k + 1)
                continue;
            // altfel actualizam numarul de opriri
            stops[nod] = steps;
            // daca am ajuns la destinatie ne oprim si returnam costul
            if (nod == dst)
                return dist;
            // adaugam vecinii adaugand costul lor la dist si 1 la numarul de opriri
            // de pana acum
            for (auto& [vecin, cost] : adj[nod]) {
                pq.push({dist + cost, vecin, steps + 1});
            }
        }
        return -1;
    }
};

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
