/*
Problema Componente tare conexe, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2929036?action=view-source

Idee:
    S-a folosit algoritmul lui Tarjan pentru determinarea componentelor tare conexe.
    Pe scurt, fiecare nod primeste un id si vom determina pentru fiecare pe masura ce parcurgem
    graful prin dfs care e cel mai mic id la care poate ajunge nodul curent. Initial
    marcam pentru fiecare nod ca cel mai mic id la care poate ajunge e chiar el.
    Vom construi o stiva in care adaugam pe rand elementele curente si le vom scoate pe cele care
    fac parte dintr-o componenta tare conexa cand determinam una. Pentru a asigura corectitudinea
    agoritmului vecinii isi vor actualiza cel mai mic id la care pot ajunge la intoarcerea din recursie si
    numai daca se afla si pe stiva. Daca la intoarcerea din recursivitate dintr-un nod am
    gasit ca are id-ul egal cu cel mai mic id la care poate ajunge inseamna ca s-a format o componenta
    tare conexa (din moment ce id-urile pot doar sa creasa). Scoatem de pe stiva toate nodurile care
    fac parte din componenta gasita si o adaugam la solutie.


Complexitatea timp: O(n+e), unde n este numarul de noduri si e este numarul de
                                perechi de persoane care nu se plac (muchii)


*/
#include <fstream>
#include <iostream>
#include <vector>
#include <stack>

using namespace std;

ifstream in("ctc.in");
ofstream out("ctc.out");

vector<int> adj[100001], componente[100001]; // in componente[i] sunt nodurile din a i-a componenta tare conexa
int ids[100001], low[100001];
stack<int> stiva;
bool peStiva[100001];
int id = 1;
int ctc = 0; // numarul de componente tare conexe


void dfs(int nod_curent){
    stiva.push(nod_curent);
    peStiva[nod_curent] = true;
    ids[nod_curent] = low[nod_curent] = id++;
    for(int i = 0; i < adj[nod_curent].size(); i++){
        int vecin = adj[nod_curent][i];
        if(ids[vecin] == 0)
            dfs(vecin);
        if(peStiva[vecin] == true) // daca vecinul e pe stiva atunci isi poate actualiza minimul
            low[nod_curent] = min(low[nod_curent], low[vecin]);
    }

    if(ids[nod_curent] == low[nod_curent]){ // inceputul unei componente tare conexe
        int nod;
        ctc++;
        do{
            nod = stiva.top();
            low[nod] = ids[nod_curent];
            peStiva[nod] = false;
            stiva.pop();
            componente[ctc].push_back(nod);
        } while(nod != nod_curent);
    }
}

int main()
{
    int n, m, x, y;
    in >> n >> m;
    for(int i = 0; i < m; i++){
        in >> x >> y;
        adj[x].push_back(y);
    }


    for(int i = 1; i <= n; i++){
        if(ids[i] == 0) // daca inca nu a fost vizitat parcurgem componenta
            dfs(i);
    }

    out << ctc <<"\n";
    for(int i = 1; i <= ctc; i++){
        for(int j = 0; j < componente[i].size(); j++)
            out << componente[i][j]<<" ";
        out <<"\n";
    }
    return 0;
}
