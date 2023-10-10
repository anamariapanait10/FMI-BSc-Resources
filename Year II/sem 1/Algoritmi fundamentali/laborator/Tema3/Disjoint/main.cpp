/*
Problema Paduri de multimi disjuncte, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2514616?action=view-source

Idee: Construim un vector unde vom retine pentru fiecare nod reprezentantul sau pentru a determina din
ce multime face parte. La reuniune se schimba reprezentantul nodului care apartine multimii cu
dimensiune mai mica. Pentru cautare verificam daca cele doua noduri au acelasi reprezentant.

Complexitate timp: O(1) operatia 1 si O(log*n) operatia 2
Complexitate memorie: O(n), unde n este numarul de noduri
*/
#include <fstream>

using namespace std;

ifstream in("disjoint.in");
ofstream out("disjoint.out");

int tata[100001], niv[1000001];

int cautare(int nod){
    int cpnod = nod, rad = nod;
    while(tata[rad] != 0){
        rad = tata[rad];
    }
    while(tata[cpnod] != 0){
        int aux = tata[cpnod];
        tata[cpnod] = rad;
        cpnod = aux;
    }
    return rad;
}

void reuniune(int x, int y){
    int t1 = cautare(x);
    int t2 = cautare(y);
    if(niv[t1] < niv[t2]){
        tata[t1] = t2;
    }
    else if(niv[t2] < niv[t1]){
        tata[t2] = t1;
    }
    else{
        tata[t1] = t2;
        niv[t2]++;
    }
}

bool apartinMultimii(int x, int y){
   int t1 = cautare(x);
   int t2 = cautare(y);
   return t1 == t2;
}

int main()
{
    int n, m;
    in >> n >> m;
    int operatie, x, y;
    for(int i = 1; i <= m; i++){
        in >> operatie >> x >> y;
        if(operatie == 1)
            reuniune(x, y);
        else if (apartinMultimii(x, y))
            out <<"DA\n";
        else
            out <<"NU\n";
    }
    return 0;
}
