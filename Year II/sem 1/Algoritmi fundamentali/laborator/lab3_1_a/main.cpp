#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

ifstream in("apm.in");
ofstream out("apm.out");

struct muchie {
    int nod_intrare, nod_iesire, cost;
};

vector<muchie> muchii;
vector<int> tata;

bool comparator(muchie m1, muchie m2){
    return m1.cost < m2.cost;
}

int findRoot(int nod){
    if(tata[nod] == nod){
        return nod;
    }
    return findRoot(tata[nod]);
}
vector<muchie> solutie;
int cost_total;

int main()
{
    int n, m;
    in >> n >> m;

    muchii.resize(m);
    for(int i = 0; i < m; i++){
        in >> muchii[i].nod_intrare >> muchii[i].nod_iesire >> muchii[i].cost;
    }

    sort(muchii.begin(), muchii.end(), comparator);

    tata.resize(n+1);
    for(int i = 1; i <= n; i++){
        tata[i] = i;
    }

    for(int i = 0; i < m; i++){

        if(findRoot(muchii[i].nod_intrare) != findRoot(muchii[i].nod_iesire)){
            cost_total += muchii[i].cost;
            solutie.push_back(muchii[i]);
            tata[findRoot(muchii[i].nod_intrare)] = findRoot(muchii[i].nod_iesire);
        }
    }

    out << cost_total <<'\n'<< solutie.size() <<'\n';
    for(int i = 0; i < solutie.size(); i++)
        out << solutie[i].nod_iesire <<" "<<solutie[i].nod_intrare<<'\n';
    return 0;
}
