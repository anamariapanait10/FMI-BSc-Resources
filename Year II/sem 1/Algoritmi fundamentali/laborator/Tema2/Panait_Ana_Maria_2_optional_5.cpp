/*
Problema Ciclu, Infoarena
Link unde se poate vedea ca a luat 100 de pct:

Idee: Cautam binar pe distantele de la 0 la INT_MAX si verificam daca exista un ciclu care
sa aiba media minima.

*/

#include <fstream>
#include <vector>
#include <climits>
#include <queue>
#include <iomanip>

using namespace std;

ifstream in("ciclu.in");
ofstream out("ciclu.out");

int nr_terase, nr_drumuri;
vector<vector<pair<int, int>>> adj;
vector<int> visited;
vector<bool> in_coada;
vector<double> dist;
queue<int> coada;


int nu_exista_ciclu(double cost){
    visited = vector<int>(nr_terase + 1, 0);
    in_coada = vector<bool>(nr_terase + 1, false);
    dist = vector<double>(nr_terase + 1, INT_MAX);
    coada = queue<int>();

    for(int i = 1; i <= nr_terase; i++){
        if(!visited[i]){
            dist[i] = 0;
            coada.push(i);
            in_coada[i] = true;
            visited[i]++;

            if(visited[i] == nr_terase) // dc este ciclu
                return false;

            while(!coada.empty()){
                int nod = coada.front();
                in_coada[nod] = false;
                coada.pop();

                for(int j = 0; j < adj[nod].size(); j++){
                    int vecin = adj[nod][j].first;
                    double c = adj[nod][j].second - cost;
                    if(dist[nod] + c <= dist[vecin]){
                        dist[vecin] = dist[nod] + c;
                        in_coada[vecin] = true;

                        if(visited[vecin] == nr_terase) // dc e ciclu
                            return false;
                        else{
                            coada.push(vecin);
                            visited[vecin]++;
                        }
                    }
                }
            }
        }
    }
    return true;
}



void cautare_bin(double st, double dr, double &costMin){
    if(dr - st >= 0){
        double mij = (st + dr) / 2;
        if(!nu_exista_ciclu(mij)){
            costMin = mij;
            dr = mij - 0.01;
        } else
            st = mij + 0.01;
        cautare_bin(st, dr, costMin);
    }
}

int main()
{

    in >> nr_terase >> nr_drumuri;

    adj.resize(nr_terase + 1);
    visited.resize(nr_terase + 1, 0);
    in_coada.resize(nr_terase + 1, false);
    dist.resize(nr_terase + 1, INT_MAX);

    int x, y, cost;
    for(int i = 1; i <= nr_drumuri; i++){
        in >> x >> y >> cost;
        adj[x].push_back(make_pair(y, cost));
    }

    double costMin = INT_MAX;
    cautare_bin(0, INT_MAX, costMin);

    out << fixed << setprecision(2) << costMin;
}
