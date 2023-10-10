/*
Problema Padure, Infoarena
Link unde se poate vedea ca solutia a luat 100 de pct: https://www.infoarena.ro/job_detail/2935781

Idee:
    Plec de la pozitia (pl, pc) si ma deplasez in padure cu ajutorul vectorilor de
    directie lin si col pana ajung la castel. Voi folosi o matrice auxiliara ce
    retine costul minim de la pozitia de start pana la celelalte pozitii.
    La final voi avea la pozitia (cl, cc) in matrice costul minim pana la castel.

Complexitate timp: O(n*m), unde n e numarul de noduri si m numarul de muchii
Complexitate spatiu: O(n^2), unde n e numarul de noduri

*/
#include <fstream>
#include <vector>
#include <algorithm>
#include <deque>
#include <climits>

using namespace std;

ifstream in("padure.in");
ofstream out("padure.out");

int n, m, pl, pc, cl, cc;
int mat[1001][1001], cost[1001][1001];
int lin[4] = {0, 0, -1, 1}, col[4] = {-1, 1, 0, 0};

int main()
{
    in >> n >> m >> pl >> pc >> cl >> cc;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++){
            in >> mat[i][j];
            cost[i][j] = INT_MAX;
        }

    // bfs
    deque <pair<int, int>> coada;
    coada.push_front(make_pair(pl, pc));
    cost[pl][pc] = 0; // poz de start are costul 0

    while (!coada.empty()){
        int x = coada.front().first, y = coada.front().second;
        coada.pop_front();
        for (int i = 0; i < 4; i++){
            int poz_x = x + lin[i], poz_y = y + col[i];
            if (1 <= poz_x && poz_x <= n && 1 <= poz_y && poz_y <= m){
                if (mat[poz_x][poz_y] != mat[x][y]){ // daca vecinii au tipul de copaci diferit
                    if (cost[poz_x][poz_y] > cost[x][y] + 1){ // actualizam costul vecinilor
                        cost[poz_x][poz_y] = cost[x][y] + 1;
                        if (poz_x != cl || poz_y != cc) // daca nu am ajuns la castel
                            coada.push_back(make_pair(poz_x, poz_y));
                    }
                } else {
                    if (cost[poz_x][poz_y] > cost[x][y]){
                        cost[poz_x][poz_y] = cost[x][y];
                        if (poz_x != cl || poz_y != cc)
                            coada.push_front(make_pair(poz_x, poz_y));
                    }
                }
            }
        }
    }
    out << cost[cl][cc];

    return 0;
}
