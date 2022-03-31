#include <iostream>

using namespace std;

// cand este nevoie sa rescriem constructorii? cand avem date care necesita alocare: pointeri


class Grupa2{
    int *v;
public:
    Grupa2(){
        v  = new int[3];
        v[0] = 10;
        v[1] = 20;
        v[2] = 30;
    }
    ~Grupa2(){ delete[] v;}
    void afis(){ cout <<v[0]<<" "<<v[1]<<" "<<v[2]<<'\n';}
};

void functie_oarecare(Grupa2 ob){
    ob.afis();
}

class Grupa{
    // const int id;
    string nume;
    int nr_studenti;
public:
    Grupa();
    Grupa(string);
    Grupa(string, int);
    ~Grupa(){cout <<nume<<" "<<nr_studenti<<"\n";}
};

Grupa::Grupa(){ // operatorul de rezolutie de scop
    nume = "anonim";
    nr_studenti = 0;
}

Grupa::Grupa(string s){
    nume = s;
    nr_studenti = 0;
}

Grupa::Grupa(string s, int n){
    nume = s;
    nr_studenti = n;
}
int main(){
    Grupa g1, g2("132"), g3("134", 30); // "132" const char*
    cout <<'\n';
    Grupa2 g;
    g.afis();
    functie_oarecare(g);
    g.afis();
    return 0;
}
