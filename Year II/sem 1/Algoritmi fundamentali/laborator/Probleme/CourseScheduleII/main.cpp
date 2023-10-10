/*
Problema Course Schedule II, LeetCode, punctul a
Link unde se poate vedea ca a trecut testele de pe LeetCode: https://leetcode.com/problems/course-schedule-ii/submissions/821568372/

Idee:
    Consideram fiecare curs un nod in graf si pentru fiecare curs A care trebuie parcurs inaintea altui curs B se considera o
    muchie A -> B. Aceasta problema se rezuma la problema sortarii topologice a grafului generat.
    Pentru fiecare nod nevizitat se incepe o parcurgere dfs si marcam cu 1 nodurile pe care le vizitam iar cand
    ne intoarcem din recursie marcam cu 2 si inseamna ca nu am dat de un ciclu.
    Existenta unui ciclu se poate determina cand parcurgem graful cu dfs daca gasim un vecin marcat cu 1.

Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)


*/

#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

vector<int> viz(2000);

class Solution {
    vector<int> adj[2000], sol;
    bool ciclu = false;
public:
    void dfs(int k){
        if(ciclu == true)
            return;
        viz[k] = 1; // marcam ca am inceput parcurgerea din nodul k
        for (auto i: adj[k])
            if (viz[i] == 0)
                dfs(i);
            else if(viz[i] == 1) // daca dam de un nod marcat cu 1 inseamna ca gasit un ciclu
                ciclu = true;
        viz[k] = 2; // marcam ca am terminat parcurgerea din nodul k
        sol.push_back(k); //adaugam in solutie nodul
    }

    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        // construim lista de adiacenta dolosind vectorul dat in problema
        for(int i = 0; i < prerequisites.size(); i++)
            adj[prerequisites[i][1]].push_back(prerequisites[i][0]);

        // parcurgem cu un dfs fiecare componenta conexa
        for(int i = 0; i < numCourses; i++)
            if(!viz[i])
                dfs(i);

        if(ciclu == false){
            // solutia e in ordine inversa
            reverse(sol.begin(), sol.end());
            return sol;
        } else {
            return vector<int>();
        }
    }
};

int main()
{
    int n, m, a, b;
    cin >> n >> m;
    vector<vector<int>> pre;
    vector<int> rez;

    // generam un vector de test cu structura din exemplu
    for(int i = 0; i < m; i++){
        cin >> a >> b;
        vector<int> aux{a, b};
        pre.push_back(aux);
    }
    Solution s = Solution();
    rez = s.findOrder(n, pre);
    for(auto x: rez)
        cout << x <<" ";
    return 0;
}


/*

Problema Course Schedule II, LeetCode, punctul b

Idee:
    Asemanator cu punctul precendent doar ca adaugam in solutie inainte de parcurgerea vecinilor si
    daca am dat de un vecin marcat cu 1 inseamna ca avem un ciclu si il adaugam in solutie si ne
    oprim.

Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)




#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

vector<int> adj[2000], sol;
int viz[2000];
bool ciclu = false;
class Solution {


public:
    void dfs(int k){
        if(ciclu == true)
            return;
        viz[k] = 1; // marcam ca am inceput parcurgerea din nodul k
        sol.push_back(k); //adaugam in solutie nodul
        for (auto i: adj[k])
            if (viz[i] == 0)
                dfs(i);
            else if(viz[i] == 1){ // daca dam de un nod marcat cu 1 inseamna ca gasit un ciclu
                sol.push_back(i);
                ciclu = true;
            }
        viz[k] = 2; // marcam ca am terminat parcurgerea din nodul k
    }

    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        // construim lista de adiacenta dolosind vectorul dat in problema
        for(int i = 0; i < prerequisites.size(); i++)
            adj[prerequisites[i][1]].push_back(prerequisites[i][0]);

        // parcurgem cu un dfs fiecare componenta conexa
        for(int i = 0; i < numCourses; i++)
            if(!viz[i])
                dfs(i);

        if(ciclu == true){
            return sol;
        } else {
            return vector<int>();
        }
    }
};

int main()
{
    int n, m, a, b;
    cin >> n >> m;
    vector<vector<int>> pre;
    vector<int> rez;

    // generam un vector de test cu structura din exemplu
    for(int i = 0; i < m; i++){
        cin >> a >> b;
        vector<int> aux{a, b};
        pre.push_back(aux);
    }
    Solution s = Solution();
    rez = s.findOrder(n, pre);

    for(auto x: rez)
        cout << x <<" ";
    return 0;
}
*/
