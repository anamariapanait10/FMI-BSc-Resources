/*
Problema Retea2, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2946608?action=view-source

Complexitate timp: O(c*b + b^2), unde c e numarul de centrale si b numarul de blocuri
Complexitate memorie: O(c + b)
*/

#include <fstream>
#include <vector>
#include <cmath>
#include <iomanip>
#include <climits>

using namespace std;

ifstream in("retea2.in");
ofstream out("retea2.out");

vector<pair<int, int>> centrale, blocuri;
vector<double> dist; // dist minima pana la un punct cu curent
int vizitat[2001];



// dist euclidiana intre doua puncte
double dist_euclidiana(pair<int,int> p1, pair<int, int> p2){
    return sqrt(1.0 * (p1.first - p2.first) * (p1.first - p2.first) + 1.0 * (p1.second - p2.second) * (p1.second - p2.second));
}

int main(){
    int n, m, x, y, bloc_min;
    double cost = 0, dist_min;
    in >> n >> m;
    dist.resize(m);

    for(int i = 0; i < n; i++){
        in >> x >> y;
        centrale.push_back({x, y});
    }

    for(int i = 0; i < m; i++){
        in >> x >> y;
        blocuri.push_back({x, y});
        dist[i] = INT_MAX;
    }

    for(int i = 0; i < m; i++){
        for(int j = 0; j < n; j++)
            // dist de la bloc la cea ai apropiata centrala
            dist[i] = min(dist[i], dist_euclidiana(blocuri[i], centrale[j]));
    }

    // facem dist pana la cel mai apropiat bloc care primeste curent si retinem pozitia
    for(int i = 0; i < m; i++) {
        bloc_min = -1;
        dist_min = INT_MAX;

        for (int j = 0; j < m; j++) {
            if (dist[j] < dist_min && vizitat[j] == 0) {
                bloc_min = j;
                dist_min = dist[j];
            }
        }

        vizitat[bloc_min]++;
        cost += dist_min;

        // actualizam dist in caz ca gasim un bloc cu curent mai apropiat
        for (int j = 0; j < m; j++) {
            dist[j] = min(dist[j], dist_euclidiana(blocuri[j], blocuri[bloc_min]));
        }
    }

    out << setprecision(6) << fixed << cost;

}
