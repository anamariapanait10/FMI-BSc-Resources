#include <iostream>
#include <fstream>
#include <vector>
#include <string.h>

using namespace std;

ifstream in("input.txt");

class Ingredient {
    string denumire;
    double pretUnitar;
    int cantitate;
public:
    Ingredient();
    Ingredient(string, double, int);
    Ingredient(Ingredient&);
    string get_denumire();
    double get_pretUnitar();
    int get_cantitate();
    double Total();
    void operator=(Ingredient&);
    friend istream& operator>>(istream&, Ingredient&);
    friend ostream& operator<<(ostream&, Ingredient&);
    void citire(istream& in);
    void afisare();
};
Ingredient::Ingredient() {
    denumire = "salam";
    pretUnitar = 2.3;
    cantitate = 4;
}
Ingredient::Ingredient(string s,  double pret, int cant) {
    denumire = s;
    pretUnitar = pret;
    cantitate = cant;
}
Ingredient::Ingredient(Ingredient& ing) {
    denumire = ing.denumire;
    pretUnitar = ing.get_pretUnitar();
    cantitate = ing.get_cantitate();
}
string Ingredient::get_denumire() {
    return denumire;
}
double Ingredient::get_pretUnitar() {
    return pretUnitar;
}
int Ingredient::get_cantitate() {
    return cantitate;
}
double Ingredient::Total() {
    return pretUnitar * cantitate;
}
void Ingredient::operator=(Ingredient &ing) {
    denumire = ing.get_denumire();
    pretUnitar = ing.get_pretUnitar();
    cantitate = ing.get_cantitate();
}
istream& operator>>(istream& in, Ingredient& ing){
    in >> ing.denumire >> ing.pretUnitar >> ing.cantitate;
}
ostream& operator<<(ostream& out, Ingredient& ing){
    out <<"Denumire: "<<ing.denumire<<", Pret: "<<ing.pretUnitar<<", Cantitate: "<<ing.cantitate;
}
void Ingredient::citire(istream& in){
    in >> denumire >> pretUnitar >> cantitate;
}
void Ingredient::afisare(){
    cout<<"Denumire ingredient: "<<denumire<<", Pret unitar: "<<pretUnitar;
    cout<<", Cantitate: "<<cantitate;
}


class Pizza{
    string denumire;
    Ingredient lista_de_ingrediente[100];
    int nringrediente;
public:
    Pizza();
    Pizza(string, Ingredient[], int);
    Pizza(Pizza&);
    string get_denumire();
    Ingredient* get_lista_ingrediente();
    int get_nringrediente();
    Pizza& operator=(Pizza&);
    friend istream& operator>>(istream&, Pizza&);
    friend ostream& operator<<(ostream&, Pizza&);
    void citire(istream& in);
    void afisare();
};
Pizza::Pizza() {
    denumire = "Margherita";
    nringrediente = 0;
}
Pizza::Pizza(string s, Ingredient lista[], int nr){
    denumire = s;
    nringrediente = nr;
    for(int i = 0; i < nringrediente; i++)
        lista_de_ingrediente[i] = lista[i];
}
Pizza::Pizza(Pizza& p){
    denumire = p.denumire;
    nringrediente = p.nringrediente;
    for(int i = 0; i < nringrediente; i++)
        lista_de_ingrediente[i] = p.lista_de_ingrediente[i];
}
string Pizza::get_denumire() {
    return denumire;
}
Ingredient* Pizza::get_lista_ingrediente() {
    return lista_de_ingrediente;
}
int Pizza::get_nringrediente() {
    return nringrediente;
}
Pizza& Pizza::operator=(Pizza &p) {
    if(this != &p) {
        denumire = p.denumire;
        nringrediente = p.nringrediente;
        for (int i = 0; i < nringrediente; i++)
            lista_de_ingrediente[i] = p.lista_de_ingrediente[i];
    }
    return *this;
}
istream& operator>>(istream& in, Pizza& p){
    in >> p.denumire;
    in >> p.nringrediente;
    for(int i = 0; i < p.nringrediente; i++){
        in >> p.lista_de_ingrediente[i];
    }
}
ostream& operator<<(ostream& out, Pizza& p){
    out <<"Denumire: "<<p.denumire<<", Lista_ingrediente: ";
    for(int i = 0; i < p.nringrediente; i++){
        out << p.lista_de_ingrediente[i]<<" ";
    }
    out<<", Nr_ingredinete: "<<p.nringrediente;
}
void Pizza::citire(istream& in){
    int nringr;
    in >> denumire >> nringr;
    nringrediente = nringr;
    for(int i = 0; i < nringr; i++){
        Ingredient ing;
        ing.citire(in);
        lista_de_ingrediente[i] = ing;
    }
}
void Pizza::afisare(){
    cout <<"Denumire pizza: "<<denumire<<", Nr ingrediente: "<<nringrediente;
    cout <<", Ingrediente: ";
    for(int i = 0; i < nringrediente; i++)
        cout << lista_de_ingrediente[i]<<" ";
}


class Comanda {
    static int nr_comanda;
    int nrPizza;
    float total;
    Pizza p[100];
public:
    Comanda();
    Comanda(int, float, Pizza pizza[100]);
    int getNrPizza();
    void setNrPizza(int);
    float getTotal();
    virtual void Afisare();
    virtual double Total();
    Comanda& operator=(Comanda&);
    friend istream& operator>>(istream&, Comanda&);
    friend ostream& operator<<(ostream&, Comanda&);
};
int Comanda::nr_comanda = 0;
Comanda::Comanda() {
    nr_comanda++;
    nrPizza = 0;
}
Comanda::Comanda(int nrPizza, float total, Pizza pizza[100]) {
    this->nrPizza = nrPizza;
    this->total = total;
    for (int i = 0; i < nrPizza; ++i) {
        p[i] = pizza[i];
    }
}
int Comanda::getNrPizza() {
    return nrPizza;
}
void Comanda::setNrPizza(int nrp) {
    nrPizza = nrp;
}
float Comanda::getTotal() {
    return total;
}
Comanda& Comanda::operator=(Comanda &comanda) {
    if (this != &comanda)
    {
        nrPizza = comanda.nrPizza;
        total = comanda.total;
        copy(&comanda.p[0], &comanda.p[0] + nrPizza, &p[0]);
    }
    return *this;
}
void Comanda::Afisare() {
    cout << "Comanda: nrPizza: " << nrPizza << ", total: " << total << ", ";
    for (int i = 0; i < nrPizza; ++i) {
        cout << p[i] <<" ";
    }
}
double Comanda::Total(){
    double suma;
    for(int i = 0; i < nrPizza; i++){
        for(int j = 0; j < p[i].get_nringrediente(); j++){
            suma += p[i].get_lista_ingrediente()[j].Total();
        }
    }
    return suma;
}
istream& operator>>(istream &in, Comanda &comanda){
    in >> comanda.nrPizza;
    in >> comanda.total;
    for(int i = 0; i < comanda.nrPizza;  i++)
        in >> comanda.p[i];
    return in;
}
ostream& operator<<(ostream &out, Comanda &comanda) {
    out << "Comanda: nrPizza: " << comanda.nrPizza << ", total: " << comanda.total << ", ";
    for (int i = 0; i < comanda.nrPizza; ++i) {
        out << comanda.p[i] <<" ";
    }
    return out;
}



class Comanda_Online: public Comanda {
    string nume_client, adresa;
public:
    Comanda_Online();
    Comanda_Online(string, string);
    Comanda_Online(int, float, Pizza[], string, string);
    string getNumeClient();
    void setNumeClient(string nc);
    string getAdresa();
    void setAdresa(string adr);
    void Afisare();
    double Total();
    Comanda_Online& operator=(const Comanda_Online& comandaOnline);
    friend istream& operator>>(istream&, Comanda_Online&);
    friend ostream& operator<<(ostream&, Comanda_Online&);
};
Comanda_Online::Comanda_Online() {
    nume_client = "Popescu Ion";
    adresa = "Strada X";
}
Comanda_Online::Comanda_Online(string nume, string adr): Comanda() {
    nume_client = nume;
    adresa = adr;
}
Comanda_Online::Comanda_Online(int i, float d, Pizza pizza[], string numeClient, string adr) : Comanda(i, d, pizza) {
    nume_client = numeClient;
    adresa = adr;
}
string Comanda_Online::getNumeClient() {
    return nume_client;
}
void Comanda_Online::setNumeClient(string nc) {
    nume_client = nc;
}
string Comanda_Online::getAdresa() {
    return adresa;
}
void Comanda_Online::setAdresa(string adr) {
    adresa = adr;
}
void Comanda_Online::Afisare(){
    cout <<"Comanda_online: Nume_client: " << nume_client << ", adresa: "<< adresa;
}
double Comanda_Online::Total(){
    double total = Comanda::Total();
    total = total + total * 0.1;
    return total;
}
Comanda_Online &Comanda_Online::operator=(const Comanda_Online &comandaOnline) {
    if (this != &comandaOnline){
        nume_client = comandaOnline.nume_client;
        adresa = comandaOnline.adresa;
    }
    return *this;
}
istream& operator>>(istream& in, Comanda_Online& comandaOnline){
    in >> comandaOnline.nume_client;
    in >> comandaOnline.adresa;
}
ostream& operator<<(ostream& out, Comanda_Online& comandaOnline) {
    out <<"Comanda online: Nume_client: " << comandaOnline.nume_client << ", adresa: "<< comandaOnline.adresa;
    return out;
}


int main() {
    Comanda* v[1000];
    int n;
    cout <<"Introduceti numarul de obiecte pe care doriti sa il cititi = ";
    cin >> n;
    for(int i = 0; i < n; i++){
        int nr = rand() % 2;
        if (nr == 0){
            Comanda* c = new Comanda();
            cout <<"Introduceti datele pentru comanda:\n";
            cin >> *c;
            v[i] = c;
        } else{
            Comanda_Online* c = new Comanda_Online();
            cout <<"Introduceti datele pentru comanda online:\n";
            cin >> *c;
            v[i] = c;
        }
    }
    cout <<"\nDatele introduce sunt:\n";
    for(int i = 0; i < n; i++){
        cout << *v[i]<<"\n";
    }

    // downcasting
    int com_online = 0;
    for(int i = 0; i < n; i++){
        if(dynamic_cast<Comanda_Online*>(v[i]))
            com_online++;
    }
    cout <<"Numarul de comenzi online din vector este:"<< com_online;
    return 0;
}