#include <iostream>
#include <vector>

using namespace std;

class produs{
    double pret;
    int cantitate;
    static int id;
public:
    produs(double pret, int cantitate);
    virtual string get_titlu() {
        return "titlu1";
    };
    virtual void citire();
    virtual void afisare();
};
int produs::id = 0;

void produs::citire() {
    cout << "Pret = ";
    cin >> pret;
    cout << "Cantitate = ";
    cin >> cantitate;
}

void produs::afisare(){
    cout << "Pret = " << pret;
    cout << "\nCantitate = "<<cantitate;
}

produs::produs(double pret, int cantitate) : pret(pret), cantitate(cantitate) {
    id++;
}

class carte: public produs{
    string titlu, editura;
    vector<string> autori;
    static int id;
public:
    void citire();
    void afisare();

    carte(double pret, int cantitate, const string &titlu, const string &editura, const vector<string> &autori);

    virtual ~carte();

    string get_titlu(){
        return titlu;
    }
    carte(double pret, int cantitate);
};
int carte::id = 0;

carte::~carte() {

}


carte::carte(double pret, int cantitate, const string &titlu, const string &editura, const vector<string> &autori)
        : produs(pret, cantitate), titlu(titlu), editura(editura), autori(autori) {
    id++;
}


void carte::citire() {
    this->produs::citire();
    cout <<"Titlu = ";
    cin >> titlu;
    cout << "Introduceti numarul de autori pe care doriti sa ii introduceti = ";
    int n;
    string aut;
    cin >> n;
    for(int i = 0; i < n; i++) {
        cin >> aut;
        autori.push_back(aut);
    }
    cout <<"Editura = ";
    cin >> editura;
}

void carte::afisare(){
    this->produs::afisare();
    cout <<"Titlu = " << titlu;
    cout <<"\nAutori: ";
    for(int i = 0; i < autori.size(); i++) {
        cout << autori[i]<<" ";
    }
    cout <<"\nEditura = "<<editura;
}

carte::carte(double pret, int cantitate) : produs(pret, cantitate) {}


class dvd: public produs{
    static int id;
    int nr_min;
public:
    dvd(double pret, int cantitate, int nrMin);

    dvd(double pret, int cantitate);

    virtual ~dvd() {

    }

    void citire();

    void afisare();
};
int dvd::id = 0;

dvd::dvd(double pret, int cantitate, int nrMin) : produs(pret, cantitate), nr_min(nrMin) {id++;}


void dvd::citire() {
    this->produs::citire();
    cout <<"Nr min = ";
    cin >> nr_min;
}

void dvd::afisare(){
    this->produs::afisare();
    cout <<"\nNr min = "<<nr_min;
}

dvd::dvd(double pret, int cantitate) : produs(pret, cantitate) {}


class dvd_muzica: public dvd{
    string nume_album;
    vector<string> interpreti;
    static int id;
public:
    dvd_muzica(double pret, int cantitate, int nrMin, const string &numeAlbum, const vector<string> &interpreti);

    dvd_muzica(double pret, int cantitate, int nrMin);

    void citire();

    void afisare();
};
int dvd_muzica::id = 0;
dvd_muzica::dvd_muzica(double pret, int cantitate, int nrMin, const string &numeAlbum, const vector<string> &interpreti)
        : dvd(pret, cantitate, nrMin), nume_album(numeAlbum), interpreti(interpreti) { id++;}

void dvd_muzica::citire() {
    this->dvd::citire();
    cout <<"\nNume album = ";
    cin >> nume_album;
    cout <<"Introduceti nr de interpreti = ";
    int n;
    string inter;
    cin >> n;
    for(int i = 0; i < n; i++){
        cin >> inter;
        interpreti.push_back(inter);
    }
}

void dvd_muzica::afisare(){
    this->dvd::afisare();
    cout <<"\nNume album = "<<nume_album;
    cout <<"\nInterpreti = ";
    for(int i = 0; i < interpreti.size(); i++){
        cout << interpreti[i] <<' ';
    }
}

dvd_muzica::dvd_muzica(double pret, int cantitate, int nrMin) : dvd(pret, cantitate, nrMin) {}

class dvd_filme: public dvd{
    string nume, gen;
    static int id;
public:
    dvd_filme(double pret, int cantitate, int nrMin, const string &nume, const string &gen);

    void citire();

    void afisare();
};
int dvd_filme::id = 0;

dvd_filme::dvd_filme(double pret, int cantitate, int nrMin, const string &nume, const string &gen) : dvd(pret,
                                                                                                         cantitate,
                                                                                                         nrMin),
                                                                                                     nume(nume),
                                                                                                     gen(gen) {
    id++;
}

void dvd_filme::citire() {
    this->dvd::citire();
    cout <<"\nNume film = ";
    cin >> nume;
    cout <<"\nGenul filmului = ";
    cin >> gen;
}

void dvd_filme::afisare(){
    this->dvd::afisare();
    cout <<"\nNume filmului = "<< nume;
    cout <<"\nGenul filmuli = " << gen;
}

class obiecte_colectie: public produs{
    static int id;
    string denumire;
public:
    obiecte_colectie(double pret, int cantitate, const string &denumire);

    void afisare();

    void citire();
};
int obiecte_colectie::id = 0;

obiecte_colectie::obiecte_colectie(double pret, int cantitate, const string &denumire) : produs(pret, cantitate),
                                                                                         denumire(denumire) {id++;}
void obiecte_colectie::citire() {
    cout <<"\nDenumirea = ";
    cin >> denumire;
}

void obiecte_colectie::afisare(){
    cout <<"\nDenumirea obiectului = "<< denumire;
}

class figurina: public obiecte_colectie{
    string categorie, brand, material;
    static int id;
public:
    figurina(double pret, int cantitate, const string &denumire, const string &categorie, const string &brand,
             const string &material);

    void citire();

    void afisare();
};
int figurina::id = 0;

figurina::figurina(double pret, int cantitate, const string &denumire, const string &categorie, const string &brand,
                   const string &material) : obiecte_colectie(pret, cantitate, denumire), categorie(categorie),
                                             brand(brand), material(material) {id++;}


void figurina::citire() {
    this->obiecte_colectie::citire();
    cout <<"\nCategorie = ";
    cin >> categorie;
    cout <<"\nBrand = ";
    cin >> brand;
    cout <<"\nMaterial = ";
    cin >> material;
}

void figurina::afisare(){
    cout <<"\nCategorie = " << categorie;
    cout <<"\nBrand = " << brand;
    cout <<"\nMaterial = " << material;
}

class poster: public obiecte_colectie{
    static int id;
    string format;
public:
    poster(double pret, int cantitate, const string &denumire, const string &format);

    void citire();

    void afisare();

};
int poster::id = 0;

poster::poster(double pret, int cantitate, const string &denumire, const string &format) : obiecte_colectie(pret,
                                                                                                            cantitate,
                                                                                                            denumire),
                                                                                           format(format) {id++;}

void poster::citire(){
    this->obiecte_colectie::citire();
    cout <<"\nFormat = "<<format;
}
void poster::afisare() {
    this->obiecte_colectie::afisare();
    cout <<"\nFormat = " <<format;
}

int main() {

    produs* v[1000];
    int n;
    cout <<"Introduceti numarul de obiecte pe care doriti sa il cititi = ";
    cin >> n;
    for(int i = 0; i < n; i++){
        int nr = rand() % 5;
        if (nr == 0){
            vector<string> vec;
            vec.push_back("Nume autor 1");
            vec.push_back("Nume autor 2");
            carte* c = new carte(1.2, 2, "Titlu carte", "EdituraX", vec);
            cout <<"\nIntroduceti datele pentru noul obiect de tip carte:\n";
            c->citire();
            v[i] = c;
        } else if(nr == 1) {
            vector<string> vec;
            vec.push_back("Nume inter 1");
            vec.push_back("Nume inter 2");
            cout << "\nIntroduceti datele pentru noul obiect de tip dvd cu muzica:\n";
            dvd_muzica *d = new dvd_muzica(1.2, 3, 30, "Nume album", vec);
            d->citire();
            v[i] = d;
        } else if(nr == 2){
            cout <<"\nIntroduceti datele pentru noul obiect de tip dvd cu filme:\n";
            dvd_filme* d = new dvd_filme(1.2, 3, 30, "Nume film", "Gen film");
            d->citire();
            v[i] = d;
        } else if(nr == 3){
            vector<string> vec;
            vec.push_back("Nume inter 1");
            vec.push_back("Nume inter 2");
            cout <<"\nIntroduceti datele pentru noul obiect de tip figurine:\n";
            figurina* f = new figurina(1.2, 3, "DenumireX", "CategorieX", "BrandX", "MaterialX");
            f->citire();
            v[i] = f;
        } else if(nr == 4){
            cout <<"\nIntroduceti datele pentru noul obiect de tip poster:\n";
            poster * f = new poster(1.2, 3, "DenumirePoster", "A4");
            f->citire();
            v[i] = f;
        }
    }
    cout <<"\nDatele introduce sunt:\n";
    for(int i = 0; i < n; i++){
        (*v[i]).afisare();
        cout <<"\n";
    }


    cout<<"Cautarea unei carti dupa titlu:\n";
    string titlu_cautat;
    cout << "Introduceti cartea cautata: ";
    cin >> titlu_cautat;
    int gasit = 0;
    for(int i = 0; i < n; i++) {
        if (!(dynamic_cast<obiecte_colectie *>(v[i]) || dynamic_cast<dvd *>(v[i])))
            if ((dynamic_cast<carte*>(v[i]))->get_titlu() == titlu_cautat) {
                cout << "Cartea cautata se afla in vector pe pozitia " << i << "\n";
                gasit = 1;
            }
    }
    if(!gasit)
        cout << "Cartea cautata nu se afla in vector\n";


    return 0;
}
