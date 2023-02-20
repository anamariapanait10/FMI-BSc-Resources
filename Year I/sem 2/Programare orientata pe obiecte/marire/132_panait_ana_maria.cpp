/*
Compilator folosit: MinGW w64 9.0
Nume tutore laborator: Anca Dovrovat
*/
#include <iostream>
#include <vector>
#include <unordered_map>
#include <math.h>

using namespace std;

class masina{
	static int id;
	int an_productie,  viteza_maxima,  greutate;
	string nume,  model;
public:
	masina(int an_productie=0, int viteza_maxima=0, int greutate=0, string nume="", string model="");
	masina(const masina&);
	virtual ~masina();
	static int get_id();
	void set_an_productie(int);
	int get_an_productie();
	void set_viteza_maxima(int);
	int get_viteza_maxima();
	void set_greutate(int);
	int get_greutate();
	void set_nume(string);
	string get_nume();
	void set_model(string);
	string get_model();
	virtual void citire(istream&);
	virtual void afisare(ostream&);
	friend istream& operator>>(istream&, masina&);
	friend ostream& operator<<(ostream&, masina&);
};
int masina::id = 0;
masina::masina(int an_productie, int viteza_maxima, int greutate, string nume, string model){
    id++;
	this->an_productie = an_productie;
	this->viteza_maxima = viteza_maxima;
	this->greutate = greutate;
	this->nume = nume;
	this->model = model;
}
masina::masina(const masina& ob){
    id++;
	this->an_productie = ob.an_productie;
	this->viteza_maxima = ob.viteza_maxima;
	this->greutate = ob.greutate;
	this->nume = ob.nume;
	this->model = ob.model;
}
masina::~masina(){
    id--;
};
void masina::set_an_productie(int an_productie){
	this->an_productie = an_productie;
}
void masina::set_viteza_maxima(int viteza_maxima){
	this->viteza_maxima = viteza_maxima;
}
void masina::set_greutate(int greutate){
	this->greutate = greutate;
}
void masina::set_nume(string nume){
	this->nume = nume;
}
void masina::set_model(string model){
	this->model = model;
}
int masina::get_id(){
	return id;
}
int masina::get_an_productie(){
	return an_productie;
}
int masina::get_viteza_maxima(){
	return viteza_maxima;
}
int masina::get_greutate(){
	return greutate;
}
string masina::get_nume(){
	return nume;
}
string masina::get_model(){
	return model;
}
void masina::citire(istream& in){
	cout << "an_productie = ";
	in >> this->an_productie;
	cout << "viteza_maxima = ";
	in >> this->viteza_maxima;
	cout << "greutate = ";
	in >> this->greutate;
	cout << "nume = ";
	in >> this->nume;
	cout << "model = ";
	in >> this->model;
}
istream& operator>>(istream& in, masina &ob){
	ob.citire(in);
	return in;
}
void masina::afisare(ostream& out){
	out << "an_productie = "<< an_productie << '\n';
	out << "viteza_maxima = "<< viteza_maxima << '\n';
	out << "greutate = "<< greutate << '\n';
	out << "nume = "<< nume << '\n';
	out << "model = "<< model << '\n';
}

ostream& operator<<(ostream& out, masina &ob) {
		ob.afisare(out);
		return out;
}
class masina_combustibil_fosil: virtual public masina{
	static int id;
	string tip;
	int capacitate_rezervor;
public:
	masina_combustibil_fosil(string tip="", int capacitate_rezervor=0);
	masina_combustibil_fosil(const masina_combustibil_fosil&);
	~masina_combustibil_fosil();
	static int get_id();
	void set_tip(string);
	string get_tip();
	void set_capacitate_rezervor(int);
	int get_capacitate_rezervor();
	void citire_fosil(istream&);
	void afisare_fosil(ostream&);
	friend istream& operator>>(istream&, masina_combustibil_fosil&);
	friend ostream& operator<<(ostream&, masina_combustibil_fosil&);
    int get_autonomie_fosil(){
        return capacitate_rezervor / sqrt(get_greutate());
    }
};
int masina_combustibil_fosil::id = 0;
masina_combustibil_fosil::masina_combustibil_fosil(string tip, int capacitate_rezervor){
    id++;
	this->tip = tip;
	this->capacitate_rezervor = capacitate_rezervor;
}
masina_combustibil_fosil::masina_combustibil_fosil(const masina_combustibil_fosil& ob){
    id++;
	this->tip = ob.tip;
	this->capacitate_rezervor = ob.capacitate_rezervor;
}
masina_combustibil_fosil::~masina_combustibil_fosil(){
    id--;
};
void masina_combustibil_fosil::set_tip(string tip){
	this->tip = tip;
}
void masina_combustibil_fosil::set_capacitate_rezervor(int capacitate_rezervor){
	this->capacitate_rezervor = capacitate_rezervor;
}
int masina_combustibil_fosil::get_id(){
	return id;
}
string masina_combustibil_fosil::get_tip(){
	return tip;
}
int masina_combustibil_fosil::get_capacitate_rezervor(){
	return capacitate_rezervor;
}
void masina_combustibil_fosil::citire_fosil(istream& in){
	cout << "tip = ";
	in >> this->tip;
	cout << "capacitate_rezervor = ";
	in >> this->capacitate_rezervor;
}
istream& operator>>(istream& in, masina_combustibil_fosil &ob){
	ob.citire(in);
	return in;
}
void masina_combustibil_fosil::afisare_fosil(ostream& out){
	out << "tip = "<< tip << '\n';
	out << "capacitate_rezervor = "<< capacitate_rezervor << '\n';
}

ostream& operator<<(ostream& out, masina_combustibil_fosil &ob) {
		ob.afisare(out);
		return out;
}
class masina_electrica: virtual public masina{
	static int id;
	int capacitate_baterie;
public:
	masina_electrica(int capacitate_baterie=0);
	masina_electrica(const masina_electrica&);
	~masina_electrica();
	static int get_id();
	void set_capacitate_baterie(int);
	int get_capacitate_baterie();
	virtual void citire(istream&);
	virtual void afisare(ostream&);
	friend istream& operator>>(istream&, masina_electrica&);
	friend ostream& operator<<(ostream&, masina_electrica&);
    int get_autonomie(){
        return capacitate_baterie / get_greutate()* get_greutate();
    }
};
int masina_electrica::id = 0;
masina_electrica::masina_electrica(int capacitate_baterie){
    id++;
	this->capacitate_baterie = capacitate_baterie;
}
masina_electrica::masina_electrica(const masina_electrica& ob){
    id++;
	this->capacitate_baterie = ob.capacitate_baterie;
}
masina_electrica::~masina_electrica(){
    capacitate_baterie = 0;
    id--;
};
void masina_electrica::set_capacitate_baterie(int capacitate_baterie){
	this->capacitate_baterie = capacitate_baterie;
}
int masina_electrica::get_id(){
	return id;
}
int masina_electrica::get_capacitate_baterie(){
	return capacitate_baterie;
}
void masina_electrica::citire(istream& in){
	cout << "capacitate_baterie = ";
	in >> this->capacitate_baterie;
}
istream& operator>>(istream& in, masina_electrica &ob){
	ob.citire(in);
	return in;
}
void masina_electrica::afisare(ostream& out){
	out << "capacitate_baterie = "<< capacitate_baterie << '\n';
}

ostream& operator<<(ostream& out, masina_electrica &ob) {
		ob.afisare(out);
		return out;
}

class masina_hibrida: virtual public masina_combustibil_fosil, virtual public masina_electrica{
    static int id;
public:
    masina_hibrida();
    ~masina_hibrida();
    void citire(){};
    void afisare(){};
    static int get_id();
    int get_autonomie(){
        return get_autonomie_fosil() + get_autonomie();
    }
};
int masina_hibrida::id = 0;
masina_hibrida::masina_hibrida() {
    id++;
}
masina_hibrida::~masina_hibrida() {
    id--;
}
int masina_hibrida::get_id() {
    return id;
}

class tranzactie{
    static int id;
    string nume_client,  data_tranzactiei;
    vector<masina> modele;
public:
    tranzactie(string nume_client="", string data_tranzactiei="", vector<masina> modele={});
    tranzactie(const tranzactie&);
    virtual ~tranzactie();
    void set_nume_client(string);
    string get_nume_client();
    void set_data_tranzactiei(string);
    string get_data_tranzactiei();
    void set_modele(vector<masina>);
    vector<masina> get_modele();
    virtual void citire(istream&);
    virtual void afisare(ostream&);
    friend istream& operator>>(istream&, tranzactie&);
    friend ostream& operator<<(ostream&, tranzactie&);
};
int tranzactie::id = 0;
tranzactie::tranzactie(string nume_client, string data_tranzactiei, vector<masina> modele){
    id++;
    this->nume_client = nume_client;
    this->data_tranzactiei = data_tranzactiei;
    this->modele = modele;
}
tranzactie::tranzactie(const tranzactie& ob){
    id++;
    this->nume_client = ob.nume_client;
    this->data_tranzactiei = ob.data_tranzactiei;
    int nr = ob.modele.size();
    modele = vector<masina>(nr);
    for(int i = 0; i < nr; i++)
        this->modele[i] = ob.modele[i];
}
tranzactie::~tranzactie(){
    id--;
};
void tranzactie::set_nume_client(string nume_client){
    this->nume_client = nume_client;
}
void tranzactie::set_data_tranzactiei(string data_tranzactiei){
    this->data_tranzactiei = data_tranzactiei;
}
void tranzactie::set_modele(vector<masina> modele){
    this->modele = modele;
}
string tranzactie::get_nume_client(){
    return nume_client;
}
string tranzactie::get_data_tranzactiei(){
    return data_tranzactiei;
}
vector<masina> tranzactie::get_modele(){
    return modele;
}
void tranzactie::citire(istream& in){
    cout << "nume_client = ";
    in >> this->nume_client;
    cout << "data_tranzactiei = ";
    in >> this->data_tranzactiei;
    int nr;
    cout << "Introduceti numarul de modele = ";
    in >> nr;
    cout << "Introduceti elementele: ";
    for(int i = 0; i < nr; i++)
        in >> this->modele[i];
}
istream& operator>>(istream& in, tranzactie &ob){
    ob.citire(in);
    return in;
}
void tranzactie::afisare(ostream& out){
    out << "nume_client = "<< nume_client << '\n';
    out << "data_tranzactiei = "<< data_tranzactiei << '\n';
    int nr = modele.size();
    out << "modele: ";
    for(int i = 0; i < nr; i++)
        out << this->modele[i] << '\n';
}

ostream& operator<<(ostream& out, tranzactie &ob) {
    ob.afisare(out);
    return out;
}

int main(){

    vector<tranzactie> tranz;
    int nr;
    bool terminat = false;
    while(!terminat) {
        cout <<" Introduceti un numar de la 1 la 5:\n";
        cout <<" 1. Adauga un nou model masina citind de la tastatura tipul masinii si apoi campurile specifice ei\n";
        cout <<" 2. Adauga o tranzactie\n";
        cout <<" 3. Afiseaza cel mai vandut model\n";
        cout <<" 4. Afiseaza modelul cu autonomia cea mai mare\n";
        cout <<" 5. Aduce o optimizare unui anumit model crescandu-i viteza maxima cu un anumit procent\n";
        try {
            cout <<" Nr = ";
            cin >> nr;

        } catch (...) {
            cout << " Numar gresit! Introduceti un numar de la 1 la 5 = ";
        }
        if (nr == 1){
            string tip;
            cout <<"Ce fel de masina sa fie? (fosil, electric, hibrid) = ";
            cin >> tip;
            if (tip == "fosil"){
                masina_combustibil_fosil m;
                cin >> m;
            } else if(tip == "electic"){
                masina_electrica m;
                cin >> m;
            } else if(tip == "hibrid"){
                masina_hibrida m;
            }
        } else if (nr == 2){
            tranzactie t;
            cin >> t;
            tranz.push_back(t);
        }
//        else if(nr == 3) {
//            unordered_map<string, int> map;
//            for (int i = 0; i < tranz.size(); i++) {
//                for(int j = 0; j < tranz[i].get_modele().size(); j++){
//                    map[tranz[i].get_modele()[j].get_model()]++;
//                }
//            }
//            int max_nr = 0;
//            string max_model = "";
//            for(auto model, nr: map){
//                if(max_nr < nr){
//                    max_nr = nr;
//                    max_model = model;
//                }
//            }
//        } else if(nr == 4){
//            int max_autonomie = 0;
//            for(int i = 0; i < tranz.size(); i++){
//                for(int j = 0; j < tranz[i].get_modele().size(); j++){
//                    if (dynamic_cast<masina_hibrida>(tranz[i].get_modele()[j]))
//                        if(max_autonomie < tranz[i].get_modele()[j].get_autonomie())
//                            max_autonomie = tranz[i].get_modele()[j].get_autonomie();
//                }
//            }
//        } else if(nr == 5){
//            cout <<"Carui model doriti sa ii cresteti viteza?\n";
//
//        }
        cout <<"\nDoriti sa mai faceti ceva? Introduceti \"n\" pentru a iesi sau orice altceva pentru a continua = ";
        string input;
        cin >> input;
        cout <<"Inputul este: "<<input;
        if(input == "n")
            terminat = true;
    }
	 return 0;
}
