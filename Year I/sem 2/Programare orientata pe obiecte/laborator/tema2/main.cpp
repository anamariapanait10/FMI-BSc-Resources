#include <iostream>
#include <vector>
#include <math.h>
#include <map>
#include <unordered_map>
#include <cstring>

using namespace std;

/*
Tema 5. Se dau urmatoarele clase:
- Punct (float x, float y)
- Patrat (Punct stanga_jos, float latura)
- Dreptunghi (float latura2) : Patrat
- Romb (Punct colt opus) :Patrat
- Paralelogram : Dreptunghi, Romb
- Trapez (float baza2) : Paralelogram
Toate figurile au 2 laturi paralele cu axa Ox. Clasele derivate trebuie sa
contina constructori parametrizati (prin care sa se evidentieze transmiterea
parametrilor catre constructorul din clasa de baza) si destructori. Functiile
membre conțin și metode de calcul pentru arie.
O data membra valid are valorea 1 dacă figura este specificata corect.
Constructorii verifica paralelismul laturilor.
Definiti și implementati ierarhia de clase.
*/

class Punct{
    float x, y;
    bool valid;
    static int nr;
public:
    Punct();
    Punct(float, float);
    Punct(Punct&);
    virtual ~Punct();
    void set_x(float);
    void set_y(float);
    float get_x();
    float get_y();
    bool get_valid();
    void operator=(Punct&);
    friend istream& operator>>(istream&, Punct&);
    friend ostream& operator<<(ostream&, Punct&);
    static int get_nr();
};
Punct::Punct(){
    this->x = 0;
    this->y = 0;
    valid = 1;
    nr++;
}
Punct::Punct(float x, float y){
    this->x = x;
    this->y = y;
    valid = 1;
    nr++;
}
Punct::Punct(Punct& p){
    this->x = p.get_x();
    this->y = p.get_y();
    this->valid = 1;
    nr++;
}
Punct::~Punct(){
    nr--;
}
void Punct::set_x(float x){
    this->x = x;
}
void Punct::set_y(float y){
    this->y = y;
}
float Punct::get_x(){
    return x;
}
float Punct::get_y(){
    return y;
}
bool Punct::get_valid(){
    return valid;
}
void Punct::operator=(Punct &p){
    this->set_x(p.get_x());
    this->set_y(p.get_y());
}
istream &operator>>(istream &in, Punct &p) {
    in >> p.x >> p.y;
    return in;
}
ostream &operator<<(ostream &out, Punct &p) {
    out <<"("<< p.get_x()<<", "<<p.get_y()<<")";
    return out;
}
int Punct::nr = 0;
int Punct::get_nr(){
    return nr;
}

class Figura{
public:
    virtual double arie() = 0;
    virtual void citire() = 0;
    virtual void afisare() = 0;
    virtual ~Figura(){};
};

class Patrat: public Figura{
    Punct *stanga_jos;
    float latura;
    bool valid;
    static int nr;
public:
    Patrat();
    Patrat(Punct*, float);
    Patrat(Patrat&);
    virtual ~Patrat();
    void set_latura(float);
    float get_latura();
    void set_stanga_jos(Punct*);
    Punct* get_stanga_jos();
    bool get_valid();
    double arie();
    void operator=(Patrat&);
    friend istream& operator>>(istream&, Patrat&);
    friend ostream& operator<<(ostream&, Patrat&);
    void citire();
    void afisare();
    static int get_nr();
};
Patrat::Patrat(){
    stanga_jos = new Punct(0, 0);
    latura = 5;
    valid = 1;
    nr++;
}
Patrat::Patrat(Punct *p, float lat): stanga_jos(p){
    latura  = lat;
    valid = 1;
    nr++;
}
Patrat::Patrat(Patrat& p){
    stanga_jos = p.get_stanga_jos();
    latura = p.get_latura();
    valid = 1;
    nr++;
}
Patrat::~Patrat(){
    delete stanga_jos;
    nr--;
}
void Patrat::set_latura(float lat){
    latura = lat;
}
float Patrat::get_latura(){
    return latura;
}
void Patrat::set_stanga_jos(Punct* p){
    stanga_jos = p;
}
Punct* Patrat::get_stanga_jos(){
    return stanga_jos;
}
bool Patrat::get_valid(){
    return valid;
}
double Patrat::arie(){
    return latura * latura;
}
void Patrat::operator=(Patrat& p){
    stanga_jos = p.get_stanga_jos();
    latura = p.get_latura();
}
istream& operator>>(istream& in, Patrat& p){
    in >> *(p.stanga_jos) >> p.latura;
    return in;
}
ostream& operator<<(ostream& out, Patrat& p){
    out <<"\n";
    out <<"      "<<p.latura<<"\n";
    out <<" ----------\n";
    out <<" |        |\n";
    out <<" |        |\n";
    out <<" |        |\n";
    out <<" |        |\n";
    out <<" +---------\n";
    out <<" A"<<*p.stanga_jos<<"\n";
    return out;
}
void Patrat::citire() {
    cin >> *(this->stanga_jos) >> this->latura;
}
void Patrat::afisare(){
    cout <<"\n";
    cout <<"      "<<this->latura<<"\n";
    cout <<" ----------\n";
    cout <<" |        |\n";
    cout <<" |        |\n";
    cout <<" |        |\n";
    cout <<" |        |\n";
    cout <<" +---------\n";
    cout <<" A"<<*this->stanga_jos<<"\n";
}

int Patrat::nr = 0;
int Patrat::get_nr(){
    return nr;
}


class Dreptunghi: virtual public Patrat, public Figura{
    float latura2;
    bool valid;
    static int nr;
public:
    Dreptunghi();
    Dreptunghi(float, Punct*, float);
    Dreptunghi(float, Patrat&);
    Dreptunghi(Dreptunghi&);
    virtual ~Dreptunghi();
    void set_latura2(float);
    float get_latura2();
    bool get_valid();
    double arie();
    void operator=(Dreptunghi&);
    friend istream& operator>>(istream&, Dreptunghi&);
    friend ostream& operator<<(ostream&, Dreptunghi&);
    void citire();
    void afisare();
    static int get_nr();
};

Dreptunghi::Dreptunghi(){
    this->set_latura(10);
    this->set_latura2(5);
    valid = 1;
    nr++;
}
Dreptunghi::Dreptunghi(float lat2, Punct* a , float l): Patrat(a, l){
    latura2 = lat2;
    valid = 1;
    nr++;
}
Dreptunghi::Dreptunghi(float lat2, Patrat& p): Patrat(p){
    latura2 = lat2;
    valid = 1;
    nr++;
}
Dreptunghi::Dreptunghi(Dreptunghi& d){
    this->set_latura(d.get_latura());
    this->set_latura2(d.get_latura2());
    this->set_stanga_jos(d.get_stanga_jos());
    valid = 1;
    nr++;
}
Dreptunghi::~Dreptunghi(){
    nr--;
}
void Dreptunghi::set_latura2(float lat){
    latura2 = lat;
}
float Dreptunghi::get_latura2(){
    return latura2;
}
bool Dreptunghi::get_valid(){
    return valid;
}
double Dreptunghi::arie(){
    return get_latura() * get_latura2();
}
void Dreptunghi::operator=(Dreptunghi &d){
    this->set_latura(d.get_latura());
    this->set_latura2(d.get_latura2());
    this->set_stanga_jos(d.get_stanga_jos());
}
istream& operator>>(istream& in, Dreptunghi& d){
    float lat, lat2;
    in >> *(d.get_stanga_jos()) >> lat >> lat2;
    d.set_latura(lat);
    d.set_latura2(lat2);
    return in;
}
ostream& operator<<(ostream& out, Dreptunghi& d){
    out <<"\n";
    out <<"          "<<d.get_latura()<<"\n";
    out <<" --------------------\n";
    out <<" |                  |\n";
    out <<" |                  | "<<d.get_latura2()<<"\n";
    out <<" |                  |\n";
    out <<" |                  |\n";
    out <<" +-------------------\n";
    out <<" A"<<*d.get_stanga_jos()<<"\n";
    return out;
}
void Dreptunghi::citire(){
    float lat, lat2;
    cin >> *(this->get_stanga_jos()) >> lat >> lat2;
    this->set_latura(lat);
    this->set_latura2(lat2);
}
void Dreptunghi::afisare(){
    cout <<"\n";
    cout <<"          "<<this->get_latura()<<"\n";
    cout <<" --------------------\n";
    cout <<" |                  |\n";
    cout <<" |                  | "<<this->get_latura2()<<"\n";
    cout <<" |                  |\n";
    cout <<" |                  |\n";
    cout <<" +-------------------\n";
    cout <<" A"<<*this->get_stanga_jos()<<"\n";
}
int Dreptunghi::nr = 0;
int Dreptunghi::get_nr(){
    return nr;
}


class Romb: virtual public Patrat, public Figura{
    Punct* colt_opus;
    bool valid;
    static int nr;
public:
    Romb();
    Romb(Patrat&, Punct*);
    Romb(Romb&);
    virtual ~Romb();
    void set_colt_opus(Punct*);
    Punct* get_colt_opus();
    bool get_valid();
    double arie();
    void operator=(Romb&);
    friend istream& operator>>(istream&, Romb&);
    friend ostream& operator<<(ostream&, Romb&);
    void citire();
    void afisare();
    static int get_nr();
};

Romb::Romb(){
    this->set_latura(10);
    this->set_stanga_jos(new Punct());
    this->set_colt_opus(new Punct(16.1394, 7.8935));
    valid = true;
    nr++;
}
Romb::Romb(Patrat& p, Punct* pct){
    float x1 = p.get_stanga_jos()->get_x(), y1 = p.get_stanga_jos()->get_y(),
            x2 = pct->get_x(), y2 = pct->get_y();
    float diag_mare = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if(diag_mare > 2.f * p.get_latura()) {
        valid = 0;
        throw 'e';
    }

    this->set_stanga_jos(p.get_stanga_jos());
    this->set_latura(p.get_latura());
    this->colt_opus = pct;
    valid = true;
    nr++;
}

Romb::Romb(Romb& r){
    this->set_stanga_jos(r.get_stanga_jos());
    this->set_latura(r.get_latura());
    this->set_colt_opus(r.get_colt_opus());
    valid = true;
    nr++;
}
Romb::~Romb(){
    delete colt_opus;
    nr--;
}
void Romb::set_colt_opus(Punct* p){
    colt_opus = p;
}
Punct* Romb::get_colt_opus(){
    return colt_opus;
}
bool Romb::get_valid(){
    return valid;
}
double Romb::arie(){
    double diag_mare = sqrt((get_colt_opus()->get_x()-get_stanga_jos()->get_x()) * (get_colt_opus()->get_x()-get_stanga_jos()->get_x())
                            +(get_colt_opus()->get_y()-get_stanga_jos()->get_y()) * (get_colt_opus()->get_y()-get_stanga_jos()->get_y()));
    double diag_mica = 2.0 * sqrt(get_latura()*get_latura() - diag_mare/2.0*diag_mare/2.0);
    return diag_mare * diag_mica / 2.0;
}
void Romb::operator=(Romb& r){
    this->set_stanga_jos(r.get_stanga_jos());
    this->set_latura(r.get_latura());
    this->set_colt_opus(r.get_colt_opus());
}
istream& operator>>(istream& in, Romb& r){
    float lat;
    in >> *(r.get_stanga_jos()) >> *(r.get_colt_opus()) >> lat;
    r.set_latura(lat);
    return in;
}
ostream& operator<<(ostream& out, Romb& r){
    out <<"\n";
    out <<"         "<<r.get_latura()<<"\n";
    out <<"     -----------+ B"<<*r.get_colt_opus()<<"\n";
    out <<"    /           /\n";
    out <<"   /           / "<<r.get_latura()<<"\n";
    out <<"  /           /\n";
    out <<" /           /\n";
    out <<" +----------\n";
    out <<" A"<<*r.get_stanga_jos()<<"\n";
    return out;
}
void Romb::citire() {
    float lat;
    cin >> *(this->get_stanga_jos()) >> *(this->get_colt_opus()) >> lat;
    this->set_latura(lat);
}
void Romb::afisare() {
    cout <<"\n";
    cout <<"          "<< this->get_latura()<<"\n";
    cout <<"     -----------+ B"<<*this->get_colt_opus()<<"\n";
    cout <<"    /           /\n";
    cout <<"   /           / "<<this->get_latura()<<"\n";
    cout <<"  /           /\n";
    cout <<" /           /\n";
    cout <<" +----------\n";
    cout <<" A"<<*this->get_stanga_jos()<<"\n";
}

int Romb::nr = 0;
int Romb::get_nr(){
    return nr;
}



class Paralelogram: public Dreptunghi, public Romb, public Figura{
    bool valid;
    static int nr;
public:
    Paralelogram();
    Paralelogram(Dreptunghi&, Romb&);
    Paralelogram(Paralelogram&);
    virtual ~Paralelogram();
    bool get_valid();
    double arie();
    void operator=(Paralelogram&);
    friend istream& operator>>(istream&, Paralelogram&);
    friend ostream& operator<<(ostream&, Paralelogram&);
    void citire();
    void afisare();
    static int get_nr();
};

Paralelogram::Paralelogram(){
    this->set_latura(10);
    this->set_stanga_jos(new Punct());
    this->set_colt_opus(new Punct(10, 10));
    valid = 1;
    nr++;
}
Paralelogram::Paralelogram(Dreptunghi &d, Romb &r){
    float x1 = r.get_stanga_jos()->get_x(), y1 = r.get_stanga_jos()->get_y(),
            x2 = r.get_colt_opus()->get_x(), y2 = r.get_colt_opus()->get_y();
    float diag_mare = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if(diag_mare > d.get_latura() + d.get_latura2()) {
        valid = 0;
        throw 'e';
    }
    this->set_latura(d.get_latura());
    this->set_latura2(d.get_latura2());
    this->set_stanga_jos(r.get_stanga_jos());
    this->set_colt_opus(r.get_colt_opus());
    valid = 1;
    nr++;
}

Paralelogram::Paralelogram(Paralelogram& p){
    this->set_latura(p.get_latura());
    this->set_latura2(p.get_latura2());
    this->set_stanga_jos(p.get_stanga_jos());
    this->set_colt_opus(p.get_colt_opus());
    nr++;
    valid = 1;
}
Paralelogram::~Paralelogram(){
    nr--;
}
bool Paralelogram::get_valid(){
    return valid;
}
double Paralelogram::arie(){
    return get_latura() * (get_colt_opus()->get_y()-get_stanga_jos()->get_y());
}
void Paralelogram::operator=(Paralelogram& p){
    this->set_latura(p.get_latura());
    this->set_latura2(p.get_latura2());
    this->set_stanga_jos(p.get_stanga_jos());
    this->set_colt_opus(p.get_colt_opus());
}
istream& operator>>(istream& in, Paralelogram& p){
    float lat, lat2;
    in >> *(p.get_stanga_jos()) >> *(p.get_colt_opus()) >> lat >> lat2;
    p.set_latura(lat);
    p.set_latura2(lat2);
    return in;
}
ostream& operator<<(ostream& out, Paralelogram& p){
    out <<"\n";
    out <<"            "<<p.get_latura()<<"\n";
    out <<"      -------------+ B"<<*p.get_colt_opus()<<"\n";
    out <<"     /             /\n";
    out <<"    /             / "<<p.get_latura2()<<"\n";
    out <<"   /             /\n";
    out <<"  /             /\n";
    out <<" +--------------\n";
    out <<" A"<<*p.get_stanga_jos()<<"\n";
    return out;
}
void Paralelogram::citire() {
    float lat, lat2;
    cin >> *(this->get_stanga_jos()) >> *(this->get_colt_opus()) >> lat >> lat2;
    this->set_latura(lat);
    this->set_latura2(lat2);
}
void Paralelogram::afisare() {
    cout <<"\n";
    cout <<"           "<<this->get_latura()<<"\n";
    cout <<"      -------------+ B"<<*this->get_colt_opus()<<"\n";
    cout <<"     /             /\n";
    cout <<"    /             / "<<this->get_latura2()<<"\n";
    cout <<"   /             /\n";
    cout <<"  /             /\n";
    cout <<" +--------------\n";
    cout <<" A"<<*this->get_stanga_jos()<<"\n";
}
int Paralelogram::nr = 0;
int Paralelogram::get_nr(){
    return nr;
}


class Trapez: public Paralelogram, public Figura{
    float baza2;
    bool valid;
    static int nr;
public:
    Trapez();
    Trapez(Paralelogram&, float);
    Trapez(Trapez&);
    virtual ~Trapez();
    void set_baza2(float);
    float get_baza2();
    bool get_valid();
    double arie();
    void operator=(Trapez&);
    friend istream& operator>>(istream&, Trapez&);
    friend ostream& operator<<(ostream&, Trapez&);
    void citire();
    void afisare();
    static int get_nr();
};
Trapez::Trapez(){
    baza2 = 3;
    set_latura(7);
    set_latura2(5);
    set_stanga_jos(new Punct());
    set_colt_opus(new Punct(5, 2));
    valid = 1;
    nr++;
}
Trapez::Trapez(Paralelogram& p, float b){
    set_latura(p.get_latura());
    set_latura2(p.get_latura2());
    set_stanga_jos(p.get_stanga_jos());
    set_colt_opus(p.get_colt_opus());
    baza2 = b;
    nr++;
}
Trapez::Trapez(Trapez& t){
    set_latura(t.get_latura());
    set_latura2(t.get_latura2());
    set_stanga_jos(t.get_stanga_jos());
    set_colt_opus(t.get_colt_opus());
    baza2 = t.get_baza2();
    nr++;
}
Trapez::~Trapez(){
    nr--;
}
void Trapez::set_baza2(float b){
    baza2 = b;
}
float Trapez::get_baza2(){
    return baza2;
}
bool Trapez::get_valid(){
    return valid;
}
double Trapez::arie(){
    return (baza2 + get_latura()) / 2.0 * (get_colt_opus()->get_y()-get_stanga_jos()->get_y());
}
void Trapez::operator=(Trapez& t){
    set_latura(t.get_latura());
    set_latura2(t.get_latura2());
    set_stanga_jos(t.get_stanga_jos());
    set_colt_opus(t.get_colt_opus());
    baza2 = t.get_baza2();
}
istream& operator>>(istream& in, Trapez& t){
    float lat, lat2, baza_mica;
    in >> *(t.get_stanga_jos()) >> *(t.get_colt_opus()) >> lat >> lat2 >> baza_mica;
    t.set_baza2(baza_mica);
    return in;
}
ostream& operator<<(ostream& out, Trapez& t){
    out <<"\n";
    out <<"         "<<t.baza2<<"\n";
    out <<"       ------+ B"<<*t.get_colt_opus()<<"\n";
    out <<"      /       \\   \n";
    out <<"     /         \\   "<<t.get_latura2()<<"\n";
    out <<"    /           \\ \n";
    out <<"   /             \\\n";
    out <<"  +---------------\n";
    out <<" A"<<*t.get_stanga_jos() <<"   "<<t.get_latura()<<"\n";

}
void Trapez::citire(){
    float lat, lat2, baza_mica;
    cin >> *(this->get_stanga_jos()) >> *(this->get_colt_opus()) >> lat >> lat2 >> baza_mica;
    this->set_baza2(baza_mica);
}
void Trapez::afisare(){
    cout <<"\n";
    cout <<"         "<<this->baza2<<"\n";
    cout <<"       ------+ B"<<*this->get_colt_opus()<<"\n";
    cout <<"      /       \\   \n";
    cout <<"     /         \\    "<<this->get_latura2()<<"\n";
    cout <<"    /           \\ \n";
    cout <<"   /             \\\n";
    cout <<"  +---------------\n";
    cout <<" A"<<*this->get_stanga_jos() <<"   "<<this->get_latura()<<"\n";
}
int Trapez::nr = 0;
int Trapez::get_nr(){
    return nr;
}

float str_to_float(string str){
    int nr_punct = 0;
    for(int i = 0; i < str.length(); i++){
        if(str[i] == '.')
            nr_punct++;
        else if(!isdigit(str[i]))
            throw invalid_argument("argument is not float");
    }
    if(nr_punct > 1)
        throw invalid_argument("argument is not float");
    return stof(str);
}
int str_to_int(string str){
    for(int i = 0; i < str.length(); i++){
        if(!isdigit(str[i]))
            throw invalid_argument("argument is not int");
    }
    return stoi(str);
}

void adauga_figura(Patrat* v[], int &indice, string figura){
    if(figura == "patrat") {
        cout <<" Patrat:\n";
        string str;
        float x, y, lung, lat;
        bool citit = false;
        cout << " Introduceti abscisa punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                x = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                y = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea patratului = ";
        while (!citit) {
            try {
                cin >> str;
                lung = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }
        Punct *p = new Punct(x, y);
        v[++indice] = new Patrat(p, lung);
        cout <<" Patratul a fost adaugat cu succes\n";
    } else if(figura == "dreptunghi"){
        cout <<" Dreptunghi:\n";
        string str;
        float x, y, lung, lat;
        bool citit = false;
        cout << " Introduceti abscisa punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                x = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                y = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea dreptunghiului = ";
        while (!citit) {
            try {
                cin >> str;
                lung = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti latimea dreptunghiului = ";
        while (!citit) {
            try {
                cin >> str;
                lat = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Latimea este invalida, introduceti un numar zecimal = ";
            }
        }
        Punct *pct = new Punct(x, y);
        Patrat *pat = new Patrat(pct, lung);
        v[++indice] = new Dreptunghi(lat, *pat);
        cout <<" Dreptunghiul a fost adaugat cu succes\n";
    } else if(figura == "romb"){
        cout <<" Romb:\n";
        string str;
        float x, y, x2, y2, lung;
        bool citit = false;
        cout << " Introduceti abscisa punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                x = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                y = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti abscisa punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                x2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                y2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea rombului = ";
        while (!citit) {
            try {
                cin >> str;
                lung = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }

        Punct *stg_jos = new Punct(x, y);
        Punct *dr_sus = new Punct(x2, y2);
        Patrat *pat = new Patrat(stg_jos, lung);
        try {
            v[++indice] = new Romb(*pat, dr_sus);
            cout <<" Rombul a fost adaugat cu succes\n";
        } catch (char a){
            cout <<" Datele introduse nu constituie un romb valid\n";
        }
    } else if(figura == "paralelogram"){
        cout <<" Paralelogram:\n";
        string str;
        float x, y, x2, y2, lung, lat;
        bool citit = false;
        cout << " Introduceti abscisa punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                x = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                y = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti abscisa punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                x2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                y2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea paralelogramului = ";
        while (!citit) {
            try {
                cin >> str;
                lung = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti latimea paralelogramului = ";
        while (!citit) {
            try {
                cin >> str;
                lat = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Latimea este invalida, introduceti un numar zecimal = ";
            }
        }

        Punct *stg_jos = new Punct(x, y);
        Punct *dr_sus = new Punct(x2, y2);
        Patrat *pat = new Patrat(stg_jos, lung);
        Dreptunghi *dr = new Dreptunghi(lat, *pat);
        Romb *r = new Romb(*pat, dr_sus);
        try {
            v[++indice] = new Paralelogram(*dr, *r);
            cout << " Paralelogramul a fost adaugat cu succes\n";
        } catch (char a){
            cout << " Date intoduse nu constituie un paralelogram valid\n";
        }
    } else if(figura == "trapez"){
        cout <<" Trapez:\n";
        string str;
        float x, y, x2, y2, lung, lat, baza2;
        bool citit = false;
        cout << " Introduceti abscisa punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                x = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului stanga-jos = ";
        while (!citit) {
            try {
                cin >> str;
                y = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti abscisa punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                x2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Abscisa este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti ordonata punctului dreapta-sus = ";
        while (!citit) {
            try {
                cin >> str;
                y2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Ordonata este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea bazei mari a trapezului = ";
        while (!citit) {
            try {
                cin >> str;
                lung = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea laturii din stanga = ";
        while (!citit) {
            try {
                cin >> str;
                lat = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Latimea este invalida, introduceti un numar zecimal = ";
            }
        }
        citit = false;
        cout << " Introduceti lungimea bazei mici a trapezului = ";
        while (!citit) {
            try {
                cin >> str;
                baza2 = str_to_float(str);
                citit = true;
            } catch (invalid_argument e) {
                cout << " Lungimea este invalida, introduceti un numar zecimal = ";
            }
        }

        Punct *stg_jos = new Punct(x, y);
        Punct *dr_sus = new Punct(x2, y2);
        Patrat *pat = new Patrat(stg_jos, lung);
        Dreptunghi *dr = new Dreptunghi(lat, stg_jos, lung);
        Romb *r = new Romb(*pat, dr_sus);
        Paralelogram *par = new Paralelogram(*dr, *r);
        v[++indice] = new Trapez(*par, baza2);
        cout <<" Trapezul a fost adaugat cu succes\n";
    }
}

int main()
{
    Patrat* v[10000];
    int indice = -1, optiune;
    bool terminat = false;
    string s;
    bool citit;

    cout << " Bine ati venit! :)\n\n";
    while(!terminat) {
        cout << " Introduceti numarul optiunii dorite:\n\t1. Adauga un patrat\n\t2. Adauga un dreptunghi";
        cout << "\n\t3. Adauga un romb\n\t4. Adauga un paralelogram\n\t5. Adauga un trapez\n\t6. Afiseaza cate figuri sunt ";
        cout << "din fiecare tip\n\t7. Afiseaza figura si aria de la un index din vector\n\t8. Adauga n figuri alese random\n\t";
        cout << "9. Afiseaza indicii pe care sunt figurile\n\t10. Inchideti programul\n";
        citit = false;
        while (!citit) {
            cout << " Numar = ";
            cin >> s;
            try {
                optiune = stoi(s);
                citit = true;
            } catch (exception) {
                cout << " Numar introdus  gresit\n";
            }
        }
        if (optiune == 1) {
            adauga_figura(v, indice, "patrat");
        } else if (optiune == 2) {
            adauga_figura(v, indice, "dreptunghi");
        } else if (optiune == 3) {
            adauga_figura(v, indice, "romb");
        } else if (optiune == 4) {
            adauga_figura(v, indice, "paralelogram");
        } else if (optiune == 5) {
            adauga_figura(v, indice, "trapez");
        } else if (optiune == 6) {
            cout << "\tSunt " << Patrat::get_nr() << " patrate\n";
            cout << "\tSunt " << Dreptunghi::get_nr() << " dreptunghiuri\n";
            cout << "\tSunt " << Romb::get_nr() << " romburi\n";
            cout << "\tSunt " << Paralelogram::get_nr() << " paralelograme\n";
            cout << "\tSunt " << Trapez::get_nr() << " trapeze\n";
        } else if (optiune == 7) {
            if(indice == -1){
                cout <<" Nu sunt elemente in vector inca\n";
            } else {
                citit = false;
                int n;
                string str;
                cout << " Introduceti un indice intre 0 si "<<indice<<" = ";
                while (!citit) {
                    try {
                        cin >> str;
                        n = str_to_int(str);
                        if (n < 0 || n > indice)
                            throw invalid_argument("numarul nu este valid");
                        citit = true;
                    } catch (invalid_argument e) {
                        cout << " Numarul nu este valid, introduceti un numar intreg intre 0 si "<<indice<<" = ";
                    }
                }
                cout <<" Figura are aria " <<(v[n])->arie() <<"\n";
                (v[n])->afisare();
            }
        } else if (optiune == 8) {
            bool citit = false;
            int n;
            string str;
            cout <<" Introduceti numarul de obiecte pe care doriti sa le adaugati = ";
            while (!citit) {
                try {
                    cin >> str;
                    n = str_to_int(str);
                    citit = true;
                } catch (invalid_argument e) {
                    cout << " Numarul nu este valid, introduceti un numar intreg = ";
                }
            }
            int nr;
            for(int i = 0; i < n; i++){
                nr = rand() % 5;
                switch (nr) {
                    case 0:
                        adauga_figura(v, indice, "patrat"); break;
                    case 1:
                        adauga_figura(v, indice, "dreptunghi"); break;
                    case 2:
                        adauga_figura(v, indice, "romb"); break;
                    case 3:
                        adauga_figura(v, indice, "paralelogram"); break;
                    case 4:
                        adauga_figura(v, indice, "trapez"); break;
                }
            }

        } else if (optiune == 9) {
            for(int i = 0; i < 5; i++){
                switch (i) {
                    case 0: {cout <<" Patrat: "; break;}
                    case 1: {cout <<"\n Dreptunghi: "; break;}
                    case 2: {cout <<"\n Romb: "; break;}
                    case 3: {cout <<"\n Paralelogram: "; break;}
                    case 4: {cout <<"\n Trapez: "; break;}
                }
                for(int j = 0; j <= indice; j++) {
                    switch (i) {
                        case 0: {
                            if(dynamic_cast<Trapez*>(v[j]) || dynamic_cast<Paralelogram*>(v[j])
                               || dynamic_cast<Romb*>(v[j]) || dynamic_cast<Dreptunghi*>(v[j]))
                                break;
                            else {
                                cout << j << " "; break;
                            }
                        } case 1: {
                            if (dynamic_cast<Trapez *>(v[j]) || dynamic_cast<Paralelogram *>(v[j]) ||
                                dynamic_cast<Romb *>(v[j]))
                                break;
                            else if (dynamic_cast<Dreptunghi *>(v[j])) {
                                cout << j << " ";
                                break;
                            }
                        } case 2: {
                            if(dynamic_cast<Trapez*>(v[j]) || dynamic_cast<Paralelogram*>(v[j]))
                                break;
                            else if(dynamic_cast<Romb*>(v[j])){
                                cout <<j<<" ";
                                break;
                            }
                        } case 3: {
                            if(dynamic_cast<Trapez*>(v[j]))
                                break;
                            else if(dynamic_cast<Paralelogram*>(v[j])){
                                cout <<j<<" ";
                                break;
                            }
                        } case 4: {
                            if(dynamic_cast<Trapez*>(v[j])){
                                cout <<j<<" ";
                                break;
                            }
                        }
                    }
                }
            }
            cout <<"\n";
        } else if(optiune == 10){
            cout << "\n La revedere!";
            return 0;
        }
        char res[255];
        cin.get();
        cout << " Apasati enter daca doriti sa mai faceti o alta actiune sau altceva in caz contrar ";
        cin.getline(res, 255);
        if (strcmp(res, "") != 0) {
            terminat = true;
        }
    }
    map<int, int> m;
    unordered_map<int, int> um;
    um[2] = 2;
    return 0;
}
