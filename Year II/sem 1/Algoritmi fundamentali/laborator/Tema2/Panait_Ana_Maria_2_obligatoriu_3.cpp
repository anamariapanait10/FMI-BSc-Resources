/*
Problema Clustering, propusa

Idee: Calculam distanta Levensthein dintre siruri folosind programare dinamica.
Punem intr-un vector indicii tuturor perechilor de cuvinte cu distanta corespunzatoare.
Clusterele vor fi reprezentate ca niste arbori si apoi o sa folosim algoritmul de union-find.

Complexitate timp: O(nlogn), unde n este numarul de cuvinte
*/

#include <fstream>
#include <iostream>
#include <cstring>
#include <vector>
#include <algorithm>
#include <unordered_map>

using namespace std;

ifstream in ("cuvinte.in");
char cuvinte[105][105], linie[2000];
vector<int> tata;
int n, k;

struct dist{
    int x, y, d;
};

int distantaLevensthein(char* src, char* dest){
    int len_src = strlen(src);
    int len_dest = strlen(dest);
    vector<vector<int>> dinamica(len_src + 1, vector<int>(len_dest + 1));
    dinamica[0][0] = 0;

    for(int i = 1; i <= len_src; i++)
        dinamica[i][0] = i;

    for (int i = 1; i <= len_dest; i++)
        dinamica[0][i] = i;

    for (int i = 1; i <= len_src; i++)
        for (int j = 1; j <= len_dest; j++){
            dinamica[i][j] = min(min(dinamica[i-1][j], dinamica[i][j-1]), dinamica[i-1][j-1]);
            if (src[i-1] != dest[j-1])
                dinamica[i][j] += 1;
        }
    return dinamica[len_src][len_dest];
}

// cauta reprezentantul unui cluster
int cauta(int nod){
    if (tata[nod] == 0)
        return nod;
    else
        return cauta(tata[nod]);
}

void cluster(int k){
    vector<dist> d;
    for(int i = 0; i <  n-1; i++)
        for (int j = i+1; j < n; j++){
            dist d1;
            d1.x = i;
            d1.y = j;
            d1.d = distantaLevensthein(cuvinte[i], cuvinte[j]);
            d.push_back(d1);
        }

    sort(d.begin(), d.end(), [] (dist a, dist b) {
        return a.d < b.d;
    });

    int pas = 0, sep = 0;
    for(int i = 0; i < d.size(); i++){
        if (pas > n - k) // intr-un cluster putem avea maxim n - k cuvinte
            break;
        if (cauta(d[i].x) != cauta(d[i].y)){// clustere diferite
            if (pas == n - k)
                sep = d[i].d;
            else
                tata[cauta(d[i].x)] = cauta(d[i].y);
            pas++;
        }
    }

    unordered_map <int, char*> sol;
    for (int i = tata.size() - k; i < tata.size(); i++)
        sol[i] = strcat(cuvinte[i], " ");
    for (int i = 0; i < tata.size(); i++){
        if (i == tata.size() - k)
            break;
        strcat(sol[cauta(tata[i])], strcat(cuvinte[i], " "));
    }
    for (auto i: sol){
        if (i.second != " ")
            cout << i.second << '\n';
    }
    cout << sep;
}

int main()
{
    // citesc cuvintele
    int index = 0;
    while(in.getline(linie, 2000)){
        char* p = strtok(linie, " ");
        while(p != NULL){
            strcpy(cuvinte[index++], p);
            p = strtok(NULL, " ");
        }
    }
    n = index;
    tata = vector<int>(n, 0);
    cin >> k;
    cluster(k);

    return 0;
}

