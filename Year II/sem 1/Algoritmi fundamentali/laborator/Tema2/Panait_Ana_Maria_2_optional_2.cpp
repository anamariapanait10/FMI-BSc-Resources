/*
Problema Checking Existence od Edge Length Limited Paths, LeetCode
Link catre solutia mea de 100 de pct: https://leetcode.com/problems/checking-existence-of-edge-length-limited-paths/submissions/850537280/

Idee:
Initializam vectorul de tati pentru fiecare element sa fie chiar el.
Sortam lista de muchii dupa distanta dintre fiecare pereche de noduri.
Pastram indicele elementelor din query pentru ca isi vor schimba ordinea
dupa sortare. Apoi sortam query-urile dupa limite. Apoi iteram printre
muchii si facem reuniune pe multimile din care fac parte cele doua noduri
care indeplinesc conditia ca distanta dintre ele sa fie mai mica decat
limita curenta. Si daca dupa reuniune nodurile query-ului curent au acelasi
representant inseamna ca reztultatul query-ului este adevarat (pt ca s-a
facut reuniunea pe multimi).

Complexitate timp: O(ElogE + QlogQ), unde E e numarul de muchii si Q e numarul de query-uri
Complexitate spatiu: O(n), unde n e numarul de noduri
*/
#include <iostream>

using namespace std;


vector <int> tata(100001, -1);
class Solution {
public:
    static bool comp(vector<int> e1, vector<int> e2){
        return e1[2] < e2[2];
    }
    int cauta(int x){
        if(tata[x] == x)
            return x;
        else{
            tata[x] = cauta(tata[x]);
            return tata[x];
        }
    }
    void reuniune(int x, int y){
        x = cauta(x);
        y = cauta(y);

        if(x != y)
            tata[y] = x;
    }
    vector<bool> distanceLimitedPathsExist(int n, vector<vector<int>>& edges, vector<vector<int>>& queries) {
        for(int i = 0; i <= n; i++)
            tata[i] = i;

        sort(edges.begin(),edges.end(), [](vector<int> &a, vector<int> &b) { return a[2] < b[2]; });

        // adaugam la fiecare query indicele pe care il avea inainte de sortare
        for(int i = 0; i < queries.size(); i++)
            queries[i].push_back(i);

        sort(queries.begin(),queries.end(), [](vector<int> &a, vector<int> &b) { return a[2] < b[2]; });

        vector<bool> ans(queries.size(), false);
        int idx = 0;
        for(int i = 0; i < queries.size(); i++){
            // facem join pe muchiile care au distanta dintre noduri mai mica ca limita curenta
			while(idx < edges.size() && edges[idx][2] < queries[i][2]){
                reuniune(edges[idx][0], edges[idx][1]);
                idx++;
            }
            // daca nodurile din query au acelasi reprezentant inseamna ca rez este true
            if(cauta(tata[queries[i][0]]) == cauta(tata[queries[i][1]]))
                ans[queries[i][3]] = true;
        }
        return ans;
    }
};

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
