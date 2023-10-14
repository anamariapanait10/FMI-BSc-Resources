/*
Problema Possible Bipartition, LeetCode, punctul a
Link unde se vede ca a trecut testele de pe LeetCode: https://leetcode.com/problems/possible-bipartition/submissions/830163154/

Idee:
    Consideram fiecare persoana un nod in graf si pentru fiecare pereche de persoane care se displac
    o sa avem o muchie in graf. Problema se rezuma la a verifica daca putem imparti varfurile in
    doua multimi astfel incat sa nu fie niciun nod cu muchie intre oricare alt nod din multimea sa.
    Se parcurge fiecare componenta conexa cu un bfs si marcam primul nod ca find din multimea 1
    (viz[i] = 1) si apoi toti vecinii lui ca find parte din multimea complementara. Se continua parcurgerea
    pe acelasi principiu. Pentru a afla multimea complementara putem scadea din 3 numarul
    multimii (3-2=1 si 3-1=2). Daca gasesc un vecin deja vizitat care e din aceeasi multime ca nodul
    curent inseamna ca nu exista o impartire a grafului in doua multimi si returnez false.


Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)


*/
#include <iostream>
#include <queue>

using namespace std;

class Solution {
public:

    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        int viz[2001] = {0};
        queue<int> coada;
        vector<vector<int>> adj(n+1);

        // construim lista de adiacenta
        for (auto x: dislikes){
            adj[x[0]].push_back(x[1]);
            adj[x[1]].push_back(x[0]);
        }

        for(int i = 1; i <= n; i++){
            if(viz[i] == 0){

                // bfs
                coada.push(i);
                viz[i] = 1; // primul nod face parte din multimea 1

                while(!coada.empty()){
                    int x = coada.front();
                    coada.pop();
                    for(int j = 0; j < adj[x].size(); j++){
                        if(viz[adj[x][j]] == 0){
                           viz[adj[x][j]] = 3 - viz[x];
                            coada.push(adj[x][j]);
                        } else if(viz[adj[x][j]] == viz[x]){
                            return false;
                        }

                    }
                }

            }
        }
        return true;
    }
};


int main(){

    return 0;
}

/*
Problema Possible Bipartition, punctul b

Idee:
    Asemanator ca la punctul precedent doar ca in loc sa returnez false in cazul in care
    am gasit un vecin din aceeasi multime ca nodul curent o sa returnez un vector gol.
    Daca s-a reusit impartirea in doua multimi a grafului atunci se pun in doi vectori
    (part1 si part2) nodurile care fac parte din multile respective, informatie
    retinuta in vectorul viz.

Complexitatea timp: O(n+e)
Complexitatea spatiu: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)



#include <fstream>
#include <vector>
#include <queue>

using namespace std;

ifstream in("bipartit.in");
ofstream out("bipartit.out");

vector<vector<int>> possibleBipartition(int n, vector<vector<int>>& dislikes) {
    int viz[2001] = {0};
    queue<int> coada;
    vector<vector<int>> adj(n+1);
    vector<vector<int>>res;

    // construire lista de adiaceta
    for (auto x: dislikes){
        adj[x[0]].push_back(x[1]);
        adj[x[1]].push_back(x[0]);
    }

    for(int i = 1; i <= n; i++){
        if(viz[i] == 0){

            // bfs
            coada.push(i);
            viz[i] = 1;

            while(!coada.empty()){
                int x = coada.front();
                coada.pop();

                for(int j = 0; j < adj[x].size(); j++){
                    if(viz[adj[x][j]] == 0){
                        viz[adj[x][j]] = 3 - viz[x];
                        coada.push(adj[x][j]);
                    } else if(viz[adj[x][j]] == viz[x]){
                        return res;
                    }

                }
            }

        }
    }
    // vectori pentru partitia grafului in 2 multimi
    vector<int> part1, part2;
    for(int i = 1; i <= n; i++){
        if(viz[i] == 1){
            part1.push_back(i);
        } else
            part2.push_back(i);
    }
    res.push_back(part1);
    res.push_back(part2);
    return res;
}

int main()
{

    int n, m;
    in >> n >> m;
    vector<vector<int>> dislikes;
    int a, b;
    for(int i = 0; i < m; i++){
        in >> a >> b;
        vector<int> aux{a, b};
        dislikes.push_back(aux);
    }



    vector<vector<int>> res = possibleBipartition(n, dislikes);
    if(!res.size()){
        out << "NU";
    } else {
        out << "DA\n";
        for(int i = 0; i < res[0].size(); i++){
            out << res[0][i] <<" ";

        }
        out <<"\n";
        for(int i = 0; i < res[1].size(); i++){
            out << res[1][i] <<" ";
        }
    }

    return 0;
}


*/
