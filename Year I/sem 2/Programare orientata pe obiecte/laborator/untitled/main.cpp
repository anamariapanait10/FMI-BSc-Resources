#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

class Ingredient {
private:
    string nume;
    float pret_unitar;
    int cantitate;
public:
    Ingredient();
    Ingredient(string nume, float pret_unitar, int cantitate);
    Ingredient(const Ingredient &i);
    ~Ingredient();
    void setNume(const string &nume);
    string getNume() const;
    void setPretUnitar(float pretUnitar);
    float getPretUnitar() const;
    void setCantitate(int cantitate);
    int getCantitate() const;
    virtual float PretTotal() const;
    virtual void citire();
    virtual void afisare();
    friend istream& operator>>(istream&, Ingredient&);
    friend ostream& operator<<(ostream&, Ingredient&);
    Ingredient& operator=(const Ingredient& ing);
};
Ingredient::Ingredient() {
    this->nume = "";
    this->pret_unitar = 0;
    this->cantitate = 0;
}
Ingredient::Ingredient(string nume, float pret_unitar, int cantitate) {
    this->nume = nume;
    this->pret_unitar = pret_unitar;
    this->cantitate = cantitate;
}
Ingredient::Ingredient(const Ingredient &i) {
    this->nume = i.nume;
    this->pret_unitar = i.pret_unitar;
    this->cantitate = i.cantitate;
}
Ingredient::~Ingredient() {
    nume = "";
    pret_unitar = 0;
    cantitate = 0;
}
void Ingredient::setNume(const string &nume) {
    Ingredient::nume = nume;
}
string Ingredient::getNume() const {
    return nume;
}
void Ingredient::setPretUnitar(float pretUnitar) {
    pret_unitar = pretUnitar;
}
float Ingredient::getPretUnitar() const {
    return pret_unitar;
}
void Ingredient::setCantitate(int cantitate) {
    Ingredient::cantitate = cantitate;
}
int Ingredient::getCantitate() const {
    return cantitate;
}
float Ingredient::PretTotal() const {
    return this->pret_unitar * this->cantitate;
}
void Ingredient::citire() {
    cout << "Numele, pretul unitar si cantitatea ingredientului: ";
    cin >> this->nume >> this->pret_unitar >> this->cantitate;
}
void Ingredient::afisare() {
    cout <<"Nume: "<<this->nume << ", Pret_unitar: " << this->pret_unitar << ", Cantitatea: " << this->cantitate;
}
istream& operator>>(istream &in, Ingredient &i) {
    i.citire();
    return in;
}
ostream& operator<<(ostream &out, Ingredient &i) {
    i.afisare();
    return out;
}
Ingredient& Ingredient::operator=(const Ingredient& ing) {
    this->cantitate = ing.cantitate;
    this->pret_unitar = ing.pret_unitar;
    this->nume = ing.nume;
    return *this;
}

class Produs {
    string nume_produs;
    vector<Ingredient> ingrediente;
public:
    virtual float CalcPret() = 0;
    Produs();
    Produs(string nume_produs, vector<Ingredient> ingrediente);
    Produs(const Produs &p);
    virtual ~Produs();
    void setNumeProdus(const string &numeProdus);
    const string &getNumeProdus() const;
    void setIngrediente(const vector<Ingredient> &ingrediente);
    const vector<Ingredient> &getIngrediente() const;
    virtual void citire();
    virtual void afisare();
    friend istream& operator>>(istream&, Produs&);
    friend ostream& operator<<(ostream&, Produs&);
    Produs& operator=(Produs& prod);
};
Produs::Produs() {
    nume_produs = "Paste";
}
Produs::Produs(string nume_produs, vector<Ingredient> ingrediente) {
    this->nume_produs = nume_produs;
    for (int i = 0; i < ingrediente.size(); i++) {
        this->ingrediente.at(i) = ingrediente.at(i);
    }
}
Produs::Produs(const Produs &p) {
    this->ingrediente.clear();
    for (int i = 0; i < p.ingrediente.size(); i++) {
        this->ingrediente.at(i) = p.ingrediente.at(i);
    }
}
Produs::~Produs() {
    nume_produs = "";
    ingrediente.clear();
}
void Produs::setNumeProdus(const string &numeProdus) {
    nume_produs = numeProdus;
}
const string &Produs::getNumeProdus() const {
    return nume_produs;
}
void Produs::setIngrediente(const vector<Ingredient> &ingrediente) {
    Produs::ingrediente = ingrediente;
}
const vector<Ingredient> &Produs::getIngrediente() const {
    return ingrediente;
}
void Produs::citire() {
    cout << "Numele produsului: ";
    cin >> this->nume_produs;
    cout << "Introduceti numarul total de ingrediente: ";
    int nr;
    cin >> nr;
    for (int i = 0; i < nr; i++) {
        Ingredient ing;
        cin >> ing;
        this->ingrediente.push_back(ing);
    }
}
void Produs::afisare() {
    cout << "Nume produs: " << this->nume_produs<<"\n";
    cout <<"Ingrediente: ";
    for (int i = 0; i < this->ingrediente.size(); i++) {
        cout << ingrediente.at(i) <<" ";
    }
}
istream& operator>>(istream &in, Produs &p) {
    p.citire();
    return in;
}
ostream& operator<<(ostream &out, Produs &p) {
    p.afisare();
    return out;
}
Produs& Produs::operator=(Produs &prod) {
    this->nume_produs = prod.nume_produs;
    std::copy(prod.ingrediente.begin(), prod.ingrediente.end(), this->ingrediente.begin());
    return *this;
}


class Pizza: public Produs {
    static const int manopera = 5;
    string blat;
public:
    Pizza();
    Pizza(string nume_produs, vector<Ingredient> ingrediente, string blat);
    Pizza(const Pizza &pi);
    ~Pizza();
    void setBlat(const string &blat);
    const string &getBlat() const;
    static int getManopera();
    virtual void citire();
    virtual void afisare();
    virtual float CalcPret();
    friend istream& operator>>(istream&, Pizza&);
    friend ostream& operator<<(ostream&, Pizza&);
    Pizza& operator=(Pizza& prod);
};
Pizza::Pizza(): Produs() {}
Pizza::Pizza(string nume_produs, vector<Ingredient> ingrediente, string blat): Produs(nume_produs, ingrediente) {
    this->blat = blat;
}
Pizza::Pizza(const Pizza &pi): Produs() {
    this->blat = pi.blat;
}
Pizza::~Pizza() {
    blat = "";
}
void Pizza::setBlat(const string &blat) {
    Pizza::blat = blat;
}
const string &Pizza::getBlat() const {
    return blat;
}
int Pizza::getManopera() {
    return manopera;
}
void Pizza::citire() {
    Produs::citire();
    cout << "Blatul: ";
    cin >> this->blat;
}
void Pizza::afisare() {
    Produs::afisare();
    cout << "\nBlat: " << this->blat;
}
float Pizza::CalcPret() {
    float sum = manopera;
    for (int i = 0; i < this->getIngrediente().size(); i++) {
        sum += this->getIngrediente().at(i).PretTotal();
    }
    return sum;
}
istream& operator>>(istream& in, Pizza& p){
    p.citire();
    return in;
}
ostream& operator<<(ostream& out, Pizza& p){
    p.afisare();
    return out;
}
Pizza& Pizza::operator=(Pizza& prod){
    this->blat = prod.blat;
    return *this;
}

template<typename T>
class Meniu{
private:
    unordered_map<T*, int> produse;
public:
    Meniu() {};
    void operator +=(Produs* prod);
};

template<typename T>
void Meniu<T>::operator+=(Produs* prod) {
    auto it = produse.find(prod);
    if(it == produse.end()) {
        produse.insert({prod, 0});
    } else {
        it->second++;
    }
}

Meniu<Produs> meniu;

//Sablon folosit: Strategy pattern
class I_Comanda {
protected:
    int nrp;
    vector<Pizza*> produse;
public:
    virtual float PretTotalComanda() = 0;
    I_Comanda();
    I_Comanda(vector<Pizza*> produse);
    I_Comanda(const I_Comanda &c);
    virtual ~I_Comanda();
    virtual void citire();
    virtual void afisare();
    friend istream &operator>>(istream &, I_Comanda &);
    friend ostream &operator<<(ostream &, I_Comanda &);
    I_Comanda& operator=(I_Comanda& com);
};
istream &operator>>(istream &in, I_Comanda &c) {
    c.citire();
    return in;
}
ostream &operator<<(ostream &out, I_Comanda &c) {
    c.afisare();
    return out;
}
I_Comanda& I_Comanda::operator=(I_Comanda& com) {
    copy(com.produse.begin(), com.produse.end(), this->produse.begin());
    this->nrp = com.nrp;
    return *this;
}
I_Comanda::~I_Comanda() {
    produse.clear();
}
I_Comanda::I_Comanda() {}
I_Comanda::I_Comanda(vector<Pizza*> produse) {
    std::copy(produse.begin(), produse.end(), this->produse.begin());
}
I_Comanda::I_Comanda(const I_Comanda &c) {
    this->produse.clear();
    std::copy(c.produse.begin(), c.produse.end(), this->produse.begin());
}
void I_Comanda::citire() {
    cout << "Introduceti numarul de comenzi: ";
    cin >> this->nrp;
    for (int i = 0; i < nrp; i++) {
        Pizza *p = new Pizza();
        cin >> *p;
        this->produse.push_back(p);
        meniu += p;
    }
}
void I_Comanda::afisare() {
    for (int i = 0; i < this->produse.size(); i++) {
        cout << produse.at(i) << " ";
    }
}

class Online : public I_Comanda {
protected:
    int distanta; //in km
public:
    virtual float PretTotalComanda() {
        float ptc = 0;
        for (int i = 0; i < this->produse.size(); i++) {
            ptc += this->produse.at(i)->CalcPret();
        }
        for (int i = 0; i < distanta / 10; i++) {
            ptc += ((5 * ptc) / 100);
        }
        return ptc;
    }

    Online() : I_Comanda() {

    }

    Online(vector<Pizza*> produse, int distanta) : I_Comanda(produse) {
        this->distanta = distanta;
    }

    Online(const Online &o) : I_Comanda() {
        this->distanta = o.distanta;
    }

    virtual void citire() {
        I_Comanda::citire();
        cout << "Introduceti distanta in km: ";
        cin >> this->distanta;
    }

    virtual void afisare() {
        cout << "Comanda a fost plasata cu succes!";
    }
    Online& operator=(Online& onl);
};

Online &Online::operator=(Online &onl) {
    this->distanta = onl.distanta;
    std::copy(onl.produse.begin(), onl.produse.end(), this->produse.begin());
    this->nrp = onl.nrp;
    return *this;
}

class Telefonica : public I_Comanda {
protected:
    int timp; //in minute
public:
    virtual float PretTotalComanda();
    Telefonica();
    Telefonica(vector<Pizza*> produse, int timp);
    Telefonica(const Telefonica &o);
    virtual void citire();
    virtual void afisare();
    friend istream &operator>>(istream &, Telefonica &);
    friend ostream &operator<<(ostream &, Telefonica &);
    Telefonica& operator=(Telefonica& telef);
};
float Telefonica::PretTotalComanda() {
    float ptc = 0;
    for (int i = 0; i < this->produse.size(); i++)
        ptc += this->produse.at(i)->CalcPret();
    for (int i = 0; i < timp / 20; i++)
        ptc += ((5 / 100) * ptc);
    cout << "Pretul pentru comanda este " << ptc;
    return ptc;
}
Telefonica::Telefonica(): I_Comanda() {};
Telefonica::Telefonica(vector<Pizza*> produse, int timp) : I_Comanda(produse) {
    this->timp = timp;
}
Telefonica::Telefonica(const Telefonica &o) : I_Comanda() {
    this->timp = o.timp;
}
void Telefonica::citire() {
    I_Comanda::citire();
    cout << "Introduceti durata comenzii in minute: ";
    cin >> this->timp;
}
void Telefonica::afisare() {
    cout << "Comanda a fost plasata cu succes!";
}
istream &operator>>(istream &in, Telefonica &t) {
    t.citire();
    return in;
}
ostream &operator<<(ostream &out, Telefonica &t) {
    t.afisare();
    return out;
}
Telefonica &Telefonica::operator=(Telefonica &telef) {
    this->timp = telef.timp;
    this->nrp = telef.nrp;
    std::copy(telef.produse.begin(), telef.produse.end(), this->produse.begin());
    return *this;
}

class Fizica : public I_Comanda {
    float bacsis;
public:
    Fizica();
    Fizica(vector<Pizza*> produse, int distanta);
    Fizica(const Fizica &o);
    void setBacsis(float bacsis);
    float getBacsis() const;
    virtual void citire();
    virtual void afisare();
    friend istream &operator>>(istream &, Fizica &);
    friend ostream &operator<<(ostream &, Fizica &);
    virtual float PretTotalComanda();
};
float Fizica::PretTotalComanda() {
    float ptc = 0;
    for (int i = 0; i < this->produse.size(); i++)
        ptc += this->produse.at(i)->CalcPret();
    ptc += this->bacsis;
    cout << "Pretul pentru comanda este " << ptc;
    return ptc;
}
Fizica::Fizica() : I_Comanda() {};
Fizica::Fizica(vector<Pizza*> produse, int distanta) : I_Comanda(produse) {
    this->bacsis = bacsis;
}
Fizica::Fizica(const Fizica &o) : I_Comanda() {
    this->bacsis = o.bacsis;
}
void Fizica::setBacsis(float bacsis) {
    Fizica::bacsis = bacsis;
}
float Fizica::getBacsis() const {
    return bacsis;
}
void Fizica::citire() {
    I_Comanda::citire();
    cout << "Introduceti bacsisul pentru ospatar:";
    cin >> this->bacsis;
}
void Fizica::afisare() {
    cout << "Comanda a fost plasata cu succes!";
}
istream &operator>>(istream &in, Fizica &f) {
    f.citire();
    return in;
}
ostream &operator<<(ostream &out, Fizica &f) {
    f.afisare();
    return out;
}



class Client {
protected:
    string nume;
    I_Comanda *comanda;
public:
    Client();
    Client(string nume, I_Comanda *comanda);
    Client(const Client &cl);
    void setComanada(I_Comanda *cmd);
    void getComanda() const;
    virtual ~Client();
    virtual void citire();
    virtual void afisare();
    friend istream &operator>>(istream &, Client &);
    friend ostream &operator<<(ostream &, Client &);
};
Client::Client() {};
Client::Client(string nume, I_Comanda *comanda) {
    this->nume = nume;
    this->comanda = comanda;
}
Client::Client(const Client &cl) {
    this->nume = cl.nume;
    delete this->comanda;
    this->comanda = cl.comanda;
}
void Client::setComanada(I_Comanda *cmd) {
    if (this->comanda != NULL) delete this->comanda;
    this->comanda = cmd;
}
void Client::getComanda() const {
    if (this->comanda == NULL) cout <<"Nu ati plasat comanda!";
    this->comanda->afisare();
}
Client::~Client() {
    delete this->comanda;
}
void Client::citire() {
    cout << "Numele client: ";
    cin >> this->nume;
    cout << "Comanda: ";
    cin >> *this->comanda;
}
void Client::afisare() {
    cout << "Nume: "<<this->nume << ", Comanda: " << *this->comanda;
}
istream &operator>>(istream &in, Client &cl) {
    cl.citire();
    return in;
}
ostream &operator<<(ostream &out, Client &cl) {
    cl.afisare();
    return out;
}


int main() {
    int n, j;
    vector<I_Comanda*> v;
    cout << "Numarul de comenzi:";
    cin >> n;
    for (int i = 0; i < n; i++) {
        cout << "Introduceti tipul de comanda (1=online, 2=prin apel telefonic, 3=fizic): ";
        cin >> j;
        if (j == 1) {
            I_Comanda *c = new Online();
            cin >> *c;
            v.push_back(c);
        } else if (j == 2) {
            I_Comanda *c = new Telefonica();
            cin >> *c;
            v.push_back(c);
        } else if (j == 3) {
            I_Comanda *c = new Fizica();
            cin >> *c;
            v.push_back(c);
        }
    }
    cout <<"\nDatele introduce sunt:\n";
    for(int i = 0; i < n; i++){
        (*v[i]).afisare();
        cout <<"\n";
    }

    cout <<"Indicii la care se afla fiecare comanda:";
    for(int i = 0; i < 3; i++) {
        switch (i) {
            case 0: {
                cout << "\nOnline: ";
                break;
            }
            case 1: {
                cout << "\nTelefonica: ";
                break;
            }
            case 2: {
                cout << "\nFizica: ";
                break;
            }
        }
        for (int j = 0; j < v.size(); j++) {
            switch (i) {
                case 0: {
                    if (dynamic_cast<Fizica *>(v[j]) || dynamic_cast<Telefonica *>(v[j]))
                        break;
                    else {
                        cout << j << " ";
                        break;
                    }
                }
                case 1: {
                    if (dynamic_cast<Fizica *>(v[j]))
                        break;
                    else if (dynamic_cast<Telefonica *>(v[j])) {
                        cout << j << " ";
                        break;
                    }
                }
                case 2: {
                    if (dynamic_cast<Fizica *>(v[j]) || dynamic_cast<Telefonica *>(v[j]))
                        break;
                    else if (dynamic_cast<Online *>(v[j])) {
                        cout << j << " ";
                        break;
                    }
                }
            }
        }
    }

    cout <<"\n";
    Client client("Marinescu", new Online());
    client.setComanada(new Telefonica());
    client.getComanda();
    cout<<'\n';
    client.setComanada(new Fizica());
    client.getComanda();

    return 0;
}
