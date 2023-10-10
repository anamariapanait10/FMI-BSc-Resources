/*
Problema Taramul Nicaieri, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2962308

Idee: Se dubleaza numarul de noduri si se pun in doua multimi
care se leaga cu muchii de cost 1 daca au indici diferiti. Apoi
se aplica algoritmul Ford-Fulkerson.

Complexitate timp: O(n*m^2)
*/

#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>
#include <stack>
#include <unordered_map>

using namespace std;

ifstream in("harta.in");
ofstream out("harta.out");

vector<int> tata;
vector<int> viz;
int a[201][201];
int intr[201], ies[201];
int n, m, src, dest;

int bfs(){
    tata = vector<int>(2 * n + 2);
    viz = vector<int>(2 * n + 2);
    queue <int> q;
    q.push(src);
    viz[src] = 1;
    tata[src] = -1;
    while (!q.empty()){
        int nod = q.front();
        q.pop();
        if(nod == dest)
            return 1;

        for (int i = 1; i <= 2 * n + 1; i++){
            if (!viz[i] && a[nod][i] > 0){
                q.push(i);
                tata[i] = nod;
                viz[i] = 1;
            }
        }
    }
    return 0;
}

int cuplaj(){
    int cup_max = 0, cup = 0;
    while (bfs()){
        for(int i = 1; i <= n; i++){
            if (viz[n + i] && a[n + i][2 * n + 1] > 0){
                cup = 1<<13;
                tata[dest] = n + i;
                for(int nod = dest; nod != src; nod = tata[nod])
                    cup = min(cup, a[tata[nod]][nod]);

                if (cup == 0)
                    continue;

                for (int nod = dest; nod != src; nod = tata[nod]){
                    a[tata[nod]][nod] -= cup;
                    a[nod][tata[nod]] += cup;
                }
                cup_max += cup;
            }
        }
    }
    return cup_max;
}

int main ()
{
    int x, y;
    in >> n;
    for(int i = 1; i <= n; i++){
        in >> x >> y;
        intr[i] = y;
        ies[i] = x;
        a[0][i] = x;
        a[i + n][2 * n + 1] = y;

        for(int j = 1; j <= n; j++){
            if(i != j){
                a[i][j + n] = 1;
            }
        }
    }

    src = 0;
    dest = 2 * n + 1;
    out << cuplaj() << '\n';

    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= n; j++){
            if(a[i][j + n] == 0 && i != j){
                out << i << " " << j << '\n';
            }
        }
    }

    return 0;
}
