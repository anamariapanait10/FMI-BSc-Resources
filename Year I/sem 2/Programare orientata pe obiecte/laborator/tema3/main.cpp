#include <iostream>

using namespace std;

clasa abs{
    virtual double pret_total() = 0;
};

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

/*

Tema 8– Pizzeria X testează un nou soft, dezvoltat în maniera OOP, pentru gestionarea activității
 sale. Codul propriu-zis contine o clasa abstracta care contine doar metoda virtuala pura de
 calcul al prețului unui produs, iar din aceasta clasa deriva clasa Pizza. În realizarea oricărui
 produs intra un anumit număr de ingrediente pentru care se cunosc denumirile, cantitatile și
 prețul unitar. Prețul unui produs finit este data de prețul ingredientelor plus manopera (o suma
 constanta fixată de producător). Daca pizza este comandata OnLine, la preț se mai adaugă și 5% din
 pret la fiecare 10 km parcursi de angajatul care livrează la domiciliu.

Structura de date: unordered_map sau unordered_set <id_pizza, list sau vector <ingredient>>



Cerința suplimentară:

- Să se adauge toate campurile relevante pentru modelarea acestei probleme.

- Să se construiască clasa template Meniu care sa gestioneze tipurie de pizza comercializate.
 Clasa trebuie sa contina indexul unui produs (incrementat automat la vanzarea unui produs
 prin supraincarcarea operatorului +=) și o structură de date, alocata dinamic.

- Să se construiască o specializare pentru tipul Comanda_Online care sa
 trateze tipurile de pizza vegetariana într-un document contabil separat din care sa
 rezulte valoarea totala incasata din vanzarea acestora.
 */


int main() {
    cout << "Hello, World!" << std::endl;
    return 0;
}
