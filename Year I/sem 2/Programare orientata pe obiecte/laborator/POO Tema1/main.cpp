#include <iostream>
#include <fstream>
#include <string.h>
#include <math.h>

using namespace std;

class Numar_Complex {
    double re, im;
public:
    Numar_Complex() {};
    Numar_Complex(double, double);
    Numar_Complex(const Numar_Complex &ob);
    void setRe(double);
    void setIm(double);
    double getRe();
    double getIm();
    void afis();
    double modul();
    Numar_Complex operator+(Numar_Complex);
    Numar_Complex operator*(Numar_Complex);
    Numar_Complex operator/(Numar_Complex);
    friend istream& operator>>(istream &in, Numar_Complex &);
    friend ostream& operator<<(ostream &out, const Numar_Complex &);
    friend bool operator==(Numar_Complex, Numar_Complex);
    friend bool operator!=(Numar_Complex, Numar_Complex);
    operator double();
};

Numar_Complex::Numar_Complex(double r, double i) {
    re = r;
    im = i;
}

Numar_Complex::Numar_Complex(const Numar_Complex &ob) {
    re = ob.re;
    im = ob.im;
}

void Numar_Complex::setRe(double r) {
    re = r;
}

void Numar_Complex::setIm(double i) {
    im = i;
}

double Numar_Complex::getRe() {
    return re;
}

double Numar_Complex::getIm() {
    return im;
}

void Numar_Complex::afis() {
    if (re == 0 && im == 0)
        cout << 0;
    if (re != 0)
        cout << re;
    if (im != 0) {
        if (im < 0)
            cout << " - i * " << -im;
        else
            cout << " + i * " << im;
    }
    cout << '\n';
}

double Numar_Complex::modul() {
    return sqrt(re * re + im * im);
}

Numar_Complex Numar_Complex::operator+(Numar_Complex B) {
    Numar_Complex S(0, 0);
    S.re = re + B.re;
    S.im = im + B.im;
    return S;
}

Numar_Complex Numar_Complex::operator*(Numar_Complex B) {
    Numar_Complex S(0, 0);
    S.re = re * B.re - im * B.im;
    S.im = re * B.im + im * B.re;
    return S;
}

Numar_Complex Numar_Complex::operator/(Numar_Complex B) {
    Numar_Complex S(0, 0);
    S.re = (re * B.re + im * B.im) / (B.re * B.re + B.im * B.im);
    S.im = (im * B.re - re * B.im) / (B.re * B.re + B.im * B.im);
    return S;
}

istream &operator>>(istream &in, Numar_Complex &ob) {
    in >> ob.re >> ob.im;
    return in;
}

ostream &operator<<(ostream &out, const Numar_Complex &ob) {
    out << "(";
    if (ob.re == 0 && ob.im == 0)
        out << "0";

    if (ob.re != 0)
        out << ob.re << " ";

    if (ob.im != 0) {
        if (ob.im > 0)
            out << "+ " << ob.im << "*i";
        else
            out << "- " << -ob.im << "*i";
    }
    out << ")";
    return out;
}


bool operator==(Numar_Complex ob1, Numar_Complex ob2) {
    if (ob1.re == ob2.re && ob1.im == ob2.im)
        return true;
    return false;
}

bool operator!=(Numar_Complex ob1, Numar_Complex ob2) {
    return !(ob1 == ob2);
}

Numar_Complex::operator double() {
    return this->modul();
}

class Vector_Complex {
    friend class Numar_Complex;

    Numar_Complex *v;
    int n;
public:
    Vector_Complex() { n = 0; v = new Numar_Complex[100]; };
    Vector_Complex(int);
    //Vector_Complex(Numar_Complex, int);
    Vector_Complex(Numar_Complex&);
    Vector_Complex(const Vector_Complex &);
    Vector_Complex(Numar_Complex&, Numar_Complex&);
    Vector_Complex(bool);
    ~Vector_Complex();
    int get_n();
    Numar_Complex get_v_poz(int poz);
    void set_n(int);
    double *module();
    friend istream& operator>>(istream &in, Vector_Complex &);
    friend ostream& operator<<(ostream &out, const Vector_Complex &);
    void sort_cresc();
    friend Numar_Complex suma(Vector_Complex&);
    void inserare_poz(Numar_Complex &, int);
    void sterge_poz(int);
    Numar_Complex &operator[](int i);
    void adaugare_element(Numar_Complex &);
    Vector_Complex& operator+(Vector_Complex &);
    friend Vector_Complex& operator+(Vector_Complex &, Numar_Complex &);
    friend Vector_Complex& operator-(Vector_Complex &, Numar_Complex &);
    friend Vector_Complex& operator-(Vector_Complex &, int);
    friend bool operator==(Vector_Complex, Vector_Complex);
    Vector_Complex& operator=(Vector_Complex &);
    operator double();
    friend Vector_Complex& operator-(Vector_Complex& v1);
    friend Vector_Complex& operator-(Vector_Complex&, Vector_Complex&);
    friend bool operator!(Vector_Complex& v1){
        if(v1.n == 0)
            return true;
        else
            return false;
    }
    Vector_Complex& operator++();
    Vector_Complex operator++(int);
    friend void operator+=(Vector_Complex&, Vector_Complex&);

};

void operator+=(Vector_Complex& v1, Vector_Complex& v2){
    for(int i = 0; i < v2.n; i++)
        v1.adaugare_element(v2[i]);
}
Vector_Complex& operator-(Vector_Complex& v1){

    for(int i = 0; i < v1.get_n(); i++){
        v1[i].setRe(-v1[i].getRe());
        v1[i].setIm(-v1[i].getIm());
    }
    return v1;
}
Vector_Complex& operator-(Vector_Complex& v1, Vector_Complex& v2){
    for (int i = 0; i < v1.n; i++)
        for(int j = 0; j < v2.n; j++)
            if (v1[i] == v2[j]) {
                for (int g = i; g < v1.n - 1; g++) {
                    v1[g] = v1[g + 1];
                }
                v1.n--;
            }
    return v1;

}

Vector_Complex::Vector_Complex(int len) {
    n = len;
    v = new Numar_Complex[n];
}

/*Vector_Complex::Vector_Complex(Numar_Complex val, int len) {
    n = len;
    v = new Numar_Complex[n];
    for (int i = 0; i < n; i++) {
        v[i] = val;
    }
}*/
Vector_Complex::Vector_Complex(Numar_Complex &ob){
    this->n = 1;
    this->v = new Numar_Complex[1];
    v[0] = ob;
}
Vector_Complex::Vector_Complex(Numar_Complex &ob1, Numar_Complex &ob2){
    this->n = 2;
    this->v = new Numar_Complex[2];
    v[0] = ob1;
    v[1] = ob2;
}

Vector_Complex& Vector_Complex::operator++() {
    for (int i = 0; i < this->get_n(); ++i) {
        this->v[i].setRe(this->v[i].getRe() + 1);
        this->v[i].setIm(this->v[i].getIm() + 1);
    }
    return *this;
}

Vector_Complex Vector_Complex::operator++(int) {
    for (int i = 0; i < this->get_n(); ++i) {
        this->v[i].setRe(this->v[i].getRe() + 1);
        this->v[i].setIm(this->v[i].getIm() + 1);
    }
    return *this;
}

Vector_Complex::Vector_Complex(const Vector_Complex &ob) {
    n = ob.n;
    v = new Numar_Complex[n];
    for (int i = 0; i < n; i++) {
        v[i] = ob.v[i];
    }
}

Vector_Complex::Vector_Complex(bool tastatura) {
    v = new Numar_Complex[100];
    if(tastatura) {
        cin >> this->n;
        for(int i = 0; i < this->n; i++) {
            cin >> this->v[i];
        }
    } else {
        ifstream fin("date.txt");
        fin >> this->n;
        for(int i = 0; i < this->n; i++) {
            fin >> this->v[i];
        }
    }
}

Vector_Complex::~Vector_Complex() {
    if (n == 1 && v != NULL)
        delete v;
    else if (v != NULL && n != 0)
        delete[] v;
}

int Vector_Complex::get_n() {
    return n;
}

Numar_Complex Vector_Complex::get_v_poz(int poz) {
    return v[poz];
}

void Vector_Complex::set_n(int len) {
    n = len;
}

istream &operator>>(istream &in, Vector_Complex &ob) {
    in >> ob.n;
    for (int i = 0; i < ob.n; i++) {
        in >> ob.v[i];
    }
    return in;
}

ostream &operator<<(ostream &out, const Vector_Complex &ob) {
    if(ob.n == 0)
        out <<"Vectorul nu are elemente\n";
    for (int i = 0; i < ob.n - 1; i++) {
        out << ob.v[i] << ", ";
    }
    out << ob.v[ob.n - 1] << '\n';
    return out;
}

double* Vector_Complex::module() {
    double *vec = new double[n];
    for (int i = 0; i < n; i++) {
        vec[i] = v[i].modul();
    }
    return vec;
}

void Vector_Complex::sort_cresc() {
    double *vec = module();
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (vec[i] > vec[j]) {
                double aux = vec[i];
                vec[i] = vec[j];
                vec[j] = aux;
                Numar_Complex aux2(v[i]);
                v[i] = v[j];
                v[j] = aux2;
            }
        }
    }
}

Numar_Complex suma(Vector_Complex& v) {
    Numar_Complex sum(0, 0);
    for (int i = 0; i < v.get_n(); i++) {
        sum = sum + v[i];
    }
    return sum;
}

void Vector_Complex::inserare_poz(Numar_Complex &ob, int poz) {
    for (int i = this->get_n(); i > poz; i--)
        this->v[i] = this->v[i - 1];
    this->v[poz] = ob;
    this->n++;
}

void Vector_Complex::sterge_poz(int poz) {
    for (int i = poz; i < this->get_n() - 1; i++) {
        this->v[i] = this->v[i + 1];
    }
    this->set_n(this->get_n() - 1);
}

Numar_Complex &Vector_Complex::operator[](int i) {
    return v[i];
}

void Vector_Complex::adaugare_element(Numar_Complex &ob) {
    if (n == 0) {
        this->v = new Numar_Complex[100];
    }
    this->v[n] = ob;
    this->n++;
}

Vector_Complex &operator-(Vector_Complex &vec, Numar_Complex &ob) {
    for (int i = 0; i < vec.n; i++)
        if (vec[i] == ob) {
            for (int j = i; j < vec.n - 1; j++) {
                vec[j] = vec[j + 1];
            }
            vec.n--;
        }
    return vec;
}

Vector_Complex &operator-(Vector_Complex &vec, int poz) {

    for (int j = poz; j < vec.n - 1; j++) {
        vec[j] = vec[j + 1];
    }
    vec.n--;

    return vec;
}

Vector_Complex& Vector_Complex::operator+(Vector_Complex &v1) {
    Vector_Complex *v3 = new Vector_Complex(this->n + v1.n);
    for (int i = 0; i < this->n; i++)
        v3->v[i] = this->v[i];
    for (int i = this->n; i < this->n + v1.n; i++)
        v3->v[i] = v1[i - this->n];
    return *v3;
}

Vector_Complex &operator+(Vector_Complex &vec, Numar_Complex &ob) {
    vec[vec.n] = ob;
    vec.n++;
    return vec;
}

bool operator==(Vector_Complex v1, Vector_Complex v2) {
    if (v1.get_n() != v2.get_n())
        return false;
    for (int i = 0; i < v1.get_n(); i++)
        if (v1[i] != v2[i])
            return false;
    return true;
}

Vector_Complex &Vector_Complex::operator=(Vector_Complex &vec) {
    if (this != &vec) {
        this->n = vec.n;
        delete[] this->v;
        this->v = new Numar_Complex[vec.n];

        for (int i = 0; i < vec.n; i++)
            this->v[i] = vec.v[i];
    }
    return *this;
}

Vector_Complex::operator double() {
    if(this->n == 0)
        return 0;
    double *m = this->module();

    double sum = 0;
    for (int i = 0; i < this->n; i++)
        sum += m[i];
    double avg = sum / this->n;
    return avg;
}

class Nod_Complex {
    Numar_Complex val;
    Nod_Complex *urm;
public:
    Nod_Complex(Numar_Complex);
    Nod_Complex(Nod_Complex &);
    Numar_Complex get_val();
    Nod_Complex *get_urm();
    void set_val(Numar_Complex&);
    void set_urm(Nod_Complex *);
    friend istream& operator>>(istream &in, Nod_Complex &);
    friend ostream& operator<<(ostream &out, const Nod_Complex &);
    friend bool operator==(Nod_Complex &, Nod_Complex &);
    friend bool operator!=(Nod_Complex &, Nod_Complex &);
    friend Nod_Complex& operator+(Nod_Complex &, Nod_Complex &);
    friend Nod_Complex& operator*(Nod_Complex &, Nod_Complex &);
    friend Nod_Complex& operator/(Nod_Complex &, Nod_Complex &);
};

Nod_Complex::Nod_Complex(Numar_Complex val) {
    this->val = val;
    this->urm = NULL;
}

Nod_Complex::Nod_Complex(Nod_Complex &nod) {
    this->val = nod.val;
    this->urm = NULL;
}

Numar_Complex Nod_Complex::get_val() {
    return val;
}

Nod_Complex *Nod_Complex::get_urm() {
    return urm;
}

void Nod_Complex::set_val(Numar_Complex& v) {
    val = v;
}

void Nod_Complex::set_urm(Nod_Complex *nod) {
    urm = nod;
}

istream &operator>>(istream &in, Nod_Complex &ob) {
    in >> ob.val;
    return in;
}

ostream &operator<<(ostream &out, const Nod_Complex &ob) {
    out << ob.val << '\n';
    return out;
}

bool operator==(Nod_Complex &nod1, Nod_Complex &nod2) {
    if (nod1.get_val() == nod2.get_val())
        return true;
    return false;
}

bool operator!=(Nod_Complex &nod1, Nod_Complex &nod2) {
    if (nod1 == nod2)
        return false;
    return true;
}


Nod_Complex &operator+(Nod_Complex &nod1, Nod_Complex &nod2) {

    return *(new Nod_Complex(nod1.get_val() + nod2.get_val()));
}

Nod_Complex &operator*(Nod_Complex &nod1, Nod_Complex &nod2) {
    return *(new Nod_Complex(nod1.get_val() * nod2.get_val()));
}

Nod_Complex &operator/(Nod_Complex &nod1, Nod_Complex &nod2) {
    return *(new Nod_Complex(nod1.get_val() / nod2.get_val()));
}

class Lista_Complexa {
    Nod_Complex *inc;
public:
    Lista_Complexa() { inc = NULL; };
    Lista_Complexa(Nod_Complex *);
    Lista_Complexa(Lista_Complexa &);
    void adaugare_nod_final(Nod_Complex *);
    void adaugare_nod_inceput(Nod_Complex *);
    void adaugare_inainte_nod(Nod_Complex *, Nod_Complex *);
    int get_lungime();
    void sterge(Nod_Complex &);
    Numar_Complex &suma();
    friend istream& operator>>(istream &in, Lista_Complexa &);
    friend ostream& operator<<(ostream &out, const Lista_Complexa &);
    friend Lista_Complexa& operator+(Lista_Complexa&, Lista_Complexa&);
    friend double operator+(double, Lista_Complexa&);
    friend bool operator==(Vector_Complex &, Lista_Complexa &);
    Nod_Complex& operator[](int);
    operator double();
};

Lista_Complexa::Lista_Complexa(Nod_Complex *nod) {
    inc = new Nod_Complex(*nod);
}

void Lista_Complexa::adaugare_nod_final(Nod_Complex *nod) {
    if (inc == NULL) {
        Nod_Complex *copie = new Nod_Complex(*nod);
        inc = copie;
    } else {
        Nod_Complex *pnod = inc;
        while (pnod->get_urm() != NULL) {
            pnod = pnod->get_urm();
        }
        pnod->set_urm(nod);
    }
}

void Lista_Complexa::adaugare_nod_inceput(Nod_Complex *nod) {
    if (inc == NULL) {
        inc = new Nod_Complex(*nod);
    } else {
        nod->set_urm(inc);
        inc = nod;
    }
}

void Lista_Complexa::adaugare_inainte_nod(Nod_Complex *nod, Nod_Complex *inainte) {
    if (inainte == inc) {
        nod->set_urm(inc);
        inc = nod;
    } else {
        Nod_Complex *pnod = inc;
        while (pnod->get_urm() != inainte) {
            pnod = pnod->get_urm();
        }
        Nod_Complex *urm = pnod->get_urm();
        pnod->set_urm(nod);
        nod->set_urm(urm);
    }
}

int Lista_Complexa::get_lungime() {
    if (this->inc == NULL)
        return 0;
    int n = 1;
    Nod_Complex *pnod = this->inc;
    while (pnod->get_urm() != NULL) {
        n++;
        pnod = pnod->get_urm();
    }
    return n;
}

void Lista_Complexa::sterge(Nod_Complex &nod) {
    Nod_Complex *pnod = this->inc;
    if (pnod == &nod) {
        if (pnod->get_urm() == NULL) {
            delete pnod;
            this->inc = NULL;
        } else {
            this->inc = this->inc->get_urm();
            delete pnod;
        }
    } else {
        while (*(pnod->get_urm()) != nod) {
            pnod = pnod->get_urm();
        }
        pnod->set_urm(pnod->get_urm()->get_urm());
        delete &nod;
    }
}

Numar_Complex &Lista_Complexa::suma() {
    Numar_Complex s = Numar_Complex(0, 0);
    Nod_Complex *pnod = inc;
    while (pnod != NULL) {
        s = s + pnod->get_val();
        pnod = pnod->get_urm();
    }
    Numar_Complex *sum = new Numar_Complex(s);
    return *sum;
}

istream &operator>>(istream &in, Lista_Complexa &ob) {
    int n;
    Numar_Complex nr_compl;
    in >> n;

    in >> *(ob.inc);
    for (int i = 1; i < n; i++) {
        in >> nr_compl;
        ob.adaugare_nod_final(new Nod_Complex(nr_compl));
    }

    return in;
}

ostream &operator<<(ostream &out, const Lista_Complexa &ob) {
    Nod_Complex *pnod = ob.inc;
    while (pnod != NULL) {
        out << pnod->get_val() << " ";
        pnod = pnod->get_urm();
    }
    return out;
}

Lista_Complexa::Lista_Complexa(Lista_Complexa &lista) {
    this->inc = NULL;
    Nod_Complex *p = lista.inc;
    while (p != NULL) {
        this->adaugare_nod_final(new Nod_Complex(*p));
        p = p->get_urm();
    }
}

Lista_Complexa& operator+(Lista_Complexa &lista1, Lista_Complexa &lista2) {
    Lista_Complexa *lista3 = new Lista_Complexa(lista1);
    Nod_Complex *p = lista2.inc;
    while (p != NULL) {
        lista3->adaugare_nod_final(new Nod_Complex(*p));
        p = p->get_urm();
    }
    return *lista3;
}

double operator+(double x, Lista_Complexa& lista){
    return x + double(lista);
}

bool operator==(Vector_Complex &vec, Lista_Complexa &lista) {
    Nod_Complex *p = lista.inc;
    for (int i = 0; i < vec.get_n(); i++) {
        if (p == NULL)
            return false;
        if (vec[i] != p->get_val())
            return false;
        p = p->get_urm();
    }
    return true;
}

Nod_Complex &Lista_Complexa::operator[](int index) {
    int i = 0;
    Nod_Complex *p = this->inc;
    while (p != NULL && i < index) {
        p = p->get_urm();
        i++;
    }
    return *p;
}

Lista_Complexa::operator double() {
    if(this->get_lungime() == 0)
        return 0;
    double sum = 0;
    for (int i = 0; i < this->get_lungime(); i++)
        sum = sum + this[i];
    double avg = sum / this->get_lungime();
    return avg;
}

int main() {
    bool terminat = false;
    Vector_Complex vec;
    Lista_Complexa lista;

/*
    int optiune;
    cout << " Bine ati venit! :)\n\n";
    meniu:
    cout << " Introduceti numarul optiunii dorite:\n\t1. Optiuni care opereaza pe vectorul de tipul Vector_Complex\n\t";
    cout
            << "2. Optiuni care opereaza pe lista de tipul Lista_Complexa\n\t3. Optiuni care opereaza si pe vector si pe lista\n\t4. Opriti executia programului\n";
    cout << " Optiune = ";
    cin >> optiune;
    if (optiune == 4) {
        cout << " ----------------------------------------------------------------------------------------- ";
        cout << "\n Multumim ca ati folosit acest program! O zi buna in continuare :)\n\n";
        cout << " ----------------------------------------------------------------------------------------- \n\n";
        return 0;
    }
    cout << " ----------------------------------------------------------------------------------------- \n\n";

    int nr;
    while (!terminat) {
        cout << " Introduceti numarul actiunii dorite:\n\n";
        if (optiune == 1) {
            cout << " --------------- optiuni care opereaza pe vectorul de tipul Vector_Complex --------------- \n\n\t";
            cout << "1. Adauga la final un numar complex (in vector)\n\t2. Modifica un numar complex (din vector)\n\t3. Aduna doua numere complexe (din vector)\n\t";
            cout << "4. Inmulteste doua numere complexe (din vector)\n\t5. Imparte doua numere complexe (din vector)\n\t";
            cout << "6. Verifica daca doua numere complexe sunt egale (din vector)\n\t7. Afiseaza vectorul de numere complexe\n\t";
            cout << "8. Afiseaza suma elementelor (din vector)\n\t9. Afiseaza modulele numerelor complexe (din vector)\n\t";
            cout << "10. Sorteaza crescator vectorul de numere complexe (+afisare)\n\t11. Insereaza numar complex pe o pozitie (in vector)\n\t";
            cout << "12. Sterge numar complex de pe o pozitie (din vector)\n\n\t13. Inapoi la meniul principal\n";
            cout << " ----------------------------------------------------------------------------------------- \n";
        } else if (optiune == 2) {
            cout << " ---------------- optiuni care opereaza pe lista de tipul Lista_Complexa ----------------- \n\n\t";
            cout << "1. Adauga un numar complex la final (in lista)\n\t2. Adauga un numar complex la inceput (in lista)\n\t";
            cout << "3. Adauga un numar complex inainte de un nod (din lista)\n\t4. Modifica un numar complex (din lista)\n\t";
            cout << "5. Aduna doua numere complexe (din lista)\n\t6. Inmulteste doua numere complexe (din lista)\n\t";
            cout << "7. Imparte doua numere complexe (din lista)\n\t8. Verifica daca doua numere complexe sunt egale (din lista)\n\t";
            cout << "9. Afiseaza lista de numere complexe\n\t10. Afiseaza suma elementelor (din lista)\n\t";
            cout << "11. Sterge un numar complex (din lista)\n\n\t12. Inapoi la meniul principal\n";
            cout << " ----------------------------------------------------------------------------------------- \n";
        } else if (optiune == 3) {
            cout << " ---------------- optiuni care opereaza si pe vector si pe lista ------------------------- \n\n\t";
            cout << "1. Verifica daca vectorul are aceleasi elemente ca lista\n\t2. Inapoi la meniul principal\n";
            cout << " ----------------------------------------------------------------------------------------- \n";
        } else {
            cout << "Optiunea este gresita, introduceti nu numar intre 1 si 4\n";
        }

        cout << " Numar = ";

        cin >> nr;
        if (optiune == 1 && nr == 1) {
            cout << " Introduceti partea reala a numarului complex = ";
            double re;
            cin >> re;
            cout << " Introduceti partea imaginara a numarului complex = ";
            double im;
            cin >> im;
            Numar_Complex nc = Numar_Complex(re, im);
            vec.adaugare_element(nc);
            cout << " Numarul complex " << nc << " a fost adaugat cu succes :)\n";
        } else if (optiune == 1 && nr == 2) {
            int n = vec.get_n();
            if (n == 0) {
                cout << " Nu exista inca numere in vector\n";
            } else {
                cout << " Introduceti numarul numarului complex pe care doriti sa il modificati: \n";
                for (int i = 0; i < vec.get_n(); i++) {
                    cout << "\t" << i << ". " << vec[i] << '\n';
                }


                cout << " Numar = ";
                int nr_compl;
                cin >> nr_compl;

                while (nr_compl < 0 || nr_compl >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar = ";
                    cin >> nr_compl;
                }

                cout << " Introduceti noua parte reala a numarului complex = ";
                double re;
                cin >> re;
                vec[nr_compl].setRe(re);
                cout << " Introduceti noua parte imaginara a numarului complex = ";
                double im;
                cin >> im;
                vec[nr_compl].setIm(im);
                cout << " Numarul a fost modificat cu succes :)\n";

            }
        } else if (optiune == 1 && nr == 3) {
            int n = vec.get_n();
            if (n < 2) {
                cout << " Nu exista destule numere in vector\n";
            } else {
                cout << " Introduceti numarul primului numarului complex pe care doriti sa il adunati: \n";
                for (int i = 0; i < n; i++) {
                    cout << "\t" << i << ". " << vec[i] << '\n';
                }
                cout << " Numar 1 = ";
                int s1, s2;
                cin >> s1;
                while (s1 < 0 || s1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> s1;
                }
                cout << " Introduceti numarul numarului complex pe care doriti sa il adunati cu primul: \n";
                for (int i = 0; i < n; i++) {
                    cout << "\t" << i << ". " << vec[i] << '\n';
                }
                cout << " Numar 2 = ";
                cin >> s2;
                while (s2 < 1 || s2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> s2;
                }

                cout << " Suma numerelor este " << vec[s1] + vec[s2] << '\n';
            }

        } else if (optiune == 1 && nr == 4) {
            int n = vec.get_n();
            if (n < 2) {
                cout << " Nu exista destule numere in vector\n";
            } else {
                cout << " Introduceti numarul primului numarului complex pe care doriti sa il inmultiti: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << vec[i] << '\n';
                }
                cout << " Numar 1 = ";
                int p1, p2;
                cin >> p1;
                while (p1 < 0 || p1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> p1;
                }
                cout << " Introduceti numarul numarului complex pe care doriti sa il inmultiti cu primul: \n";
                for (int i = 0; i < n; i++) {
                    cout << "\t" << i << ". " << vec[i] << '\n';
                }
                cout << " Numar 2 = ";
                cin >> p2;
                while (p2 < 0 || p2 >= n) {
                    cout << "Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << "Numar 2 = ";
                    cin >> p2;
                }

                cout << " Produsul numerelor este " << vec[p1] * vec[p2] << '\n';
            }

        } else if (optiune == 1 && nr == 5) {
            int n = vec.get_n();
            if (n < 2) {
                cout << " Nu exista destule numere in vector\n";
            } else {
                cout << " Introduceti numarul deimpartitului: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << vec[i] << '\n';
                }
                cout << " Numar 1 = ";
                int c1, c2;
                cin >> c1;
                while (c1 < 0 || c1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> c1;
                }
                cout << " Introduceti numarul impartitorului: \n";
                for (int i = 0; i < n; i++) {
                    cout << "\t" << i << ". " << vec[i] << '\n';
                }
                cout << " Numar 2 = ";
                cin >> c2;
                while (c2 < 0 || c2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> c2;
                }

                cout << " Impartirea numerelor este " << vec[c1] / vec[c2] << '\n';
            }
        } else if (optiune == 1 && nr == 6) {
            int n = vec.get_n();
            if (n < 2) {
                cout << " Nu exista destule numere in vector\n";
            } else {
                int nr1, nr2;

                cout << " Introduceti numarul numerelor complexe intre care doriti sa verificati egalitatea\n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << vec[i] << '\n';
                }

                cout << " Numar 1 = ";
                cin >> nr1;
                while (nr1 < 0 || nr1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> nr1;
                }
                cout << " Numar 2 = ";
                cin >> nr2;
                while (nr2 < 0 || nr2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> nr2;
                }

                if (vec[nr1] == vec[nr2])
                    cout << " Numerele sunt egale\n";
                else
                    cout << " Numerele nu sunt egale\n";
            }

        } else if (optiune == 1 && nr == 7) {

            cout << vec << '\n';

        } else if (optiune == 1 && nr == 8) {
            cout << " Suma vectorului de numere complexe este " << vec.suma() << '\n';
        } else if (optiune == 1 && nr == 9) {
            cout << " Modulele vectorului de numere complexe sunt:\n";
            double *module = vec.module();
            cout <<" ";
            for (int i = 0; i < vec.get_n(); ++i) {
                cout << module[i] << " ";
            }
            cout << '\n';

        } else if (optiune == 1 && nr == 10) {
            cout << " Vectorul initial:\n";
            cout << vec << "\nVectorul sortat:\n";
            vec.sort_cresc();
            cout << vec << "\n";
        } else if (optiune == 1 && nr == 11) {
            int n = vec.get_n();
            if (n == 0) {
                cout << " Vectorul este gol!\n";
            } else {
                double re, im;
                cout << " Introduceti partea reala a numarului pe care doriti sa il inserati = ";
                cin >> re;
                cout << " Introduceti partea imaginara a numarului pe care doriti sa il inserati = ";
                cin >> im;
                cout << " Introduceti pozitia pe care doriti sa inserati in vector\n";
                int poz, n = vec.get_n();
                for (int i = 0; i < n; i++) {
                    cout << "\t"<<i << ". " << vec[i] << '\n';
                }
                cout << " Pozitie = ";
                cin >> poz;
                while (poz < 0 || poz >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Pozitie = ";
                    cin >> poz;
                }
                Numar_Complex nc = Numar_Complex(re, im);
                vec.inserare_poz(nc, poz);
            }
        } else if (optiune == 1 && nr == 12) {
            int n = vec.get_n();
            if (n == 0) {
                cout << " Vectorul este gol!\n";
            } else {
                cout << " Introduceti pozitia de pe care doriti sa stergeti elementul din vector\n";
                int poz;
                for (int i = 0; i < n; i++) {
                    cout << "\t"<<i << ". " << vec[i] << '\n';
                }
                cout << " Pozitie = ";
                cin >> poz;
                vec.sterge_poz(poz);
            }
        } else if (optiune == 1 && nr == 13) {
            goto meniu;

        } else if (optiune == 2 && nr == 1) {
            double re, im;
            cout << " Introduceti partea reala a numarului pe care doriti sa il adaugati la final = ";
            cin >> re;
            cout << " Introduceti partea imaginara a numarului pe care doriti sa il adaugati la final = ";
            cin >> im;
            Numar_Complex *nr_c = new Numar_Complex(re, im);
            Nod_Complex *nod_c = new Nod_Complex(*nr_c);
            lista.adaugare_nod_final(nod_c);

        } else if (optiune == 2 && nr == 2) {
            double re, im;
            cout << " Introduceti partea reala a numarului pe care doriti sa il adaugati la inceput = ";
            cin >> re;
            cout << " Introduceti partea imaginara a numarului pe care doriti sa il adaugati la inceput = ";
            cin >> im;
            Numar_Complex *nr_c = new Numar_Complex(re, im);
            Nod_Complex *nod_c = new Nod_Complex(*nr_c);
            lista.adaugare_nod_inceput(nod_c);

        } else if (optiune == 2 && nr == 3) {
            if (lista.get_lungime() == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                double re, im;
                cout << " Introduceti partea reala a numarului pe care doriti sa il inserati = ";
                cin >> re;
                cout << " Introduceti partea imaginara a numarului pe care doriti sa il inserati = ";
                cin >> im;
                Numar_Complex *nr_c = new Numar_Complex(re, im);

                cout << " Introduceti numarul nodului inainte de care doriti sa inserati nodul\n";
                int poz, n = lista.get_lungime();
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i] << '\n';
                }
                cout << " Numar = ";
                cin >> poz;
                while (poz < 0 || poz >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar = ";
                    cin >> poz;
                }

                Nod_Complex *nod_c = new Nod_Complex(*nr_c);
                lista.adaugare_inainte_nod(nod_c, &lista[poz]);
            }
        } else if (optiune == 2 && nr == 4) {
            int n = lista.get_lungime();
            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                cout << " Introduceti numarul numarului complex pe care doriti sa il modificati: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i];
                }
                cout << " Numar = ";
                int num;
                cin >> num;

                if (num < 0 || num > n)
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                else {
                    cout << " Introduceti noua parte reala a numarului complex = ";
                    double re;
                    cin >> re;
                    cout << " Introduceti noua parte imaginara a numarului complex = ";
                    double im;
                    cin >> im;
                    Numar_Complex *nc = new Numar_Complex(re, im);
                    lista[num].set_val(*nc);
                }
            }

        } else if (optiune == 2 && nr == 5) {
            int n = lista.get_lungime();
            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                cout << " Introduceti numarul numerelor pe care doriti sa le adunati: \n";

                for (int i = 0; i < n; i++) {
                    cout <<"\t"<<i << ". " << lista[i];
                }
                cout << " Numar 1 = ";
                int s1, s2;
                cin >> s1;
                while (s1 < 0 || s1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> s1;
                }

                cout << " Numar 2 = ";
                cin >> s2;
                while (s2 < 1 || s2 > n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> s2;
                }

                cout << " Suma numerelor este " << lista[s1] + lista[s2] << '\n';
            }

        } else if (optiune == 2 && nr == 6) {
            int n = lista.get_lungime();
            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                cout << " Introduceti numarul primului numarului complex pe care doriti sa il inmultiti: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i];
                }
                cout << " Numar 1 = ";
                int p1, p2;
                cin >> p1;
                while (p1 < 0 || p1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> p1;
                }
                cout << " Introduceti numarul numarului complex pe care doriti sa il inmultiti cu primul: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i] << '\n';
                }
                cout << " Numar 2 = ";
                cin >> p2;
                while (p2 < 0 || p2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> p2;
                }

                cout << " Produsul numerelor este " << lista[p1] * lista[p2] << '\n';
            }
        } else if (optiune == 2 && nr == 7) {
            int n = lista.get_lungime();
            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                cout << " Introduceti numarul deimpartitului: \n";
                int n = lista.get_lungime();
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i];
                }
                cout << " Numar 1 = ";
                int c1, c2;
                cin >> c1;
                while (c1 < 0 || c1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> c1;
                }
                cout << " Introduceti numarul impartitorului: \n";
                for (int i = 0; i < n; i++) {
                    cout << "\t"<<i << ". " << lista[i] << '\n';
                }
                cout << " Numar 2 = ";
                cin >> c2;
                while (c2 < 0 || c2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> c2;
                }

                cout << " Impartirea numerelor este " << lista[c1] / lista[c2] << '\n';
            }
        } else if (optiune == 2 && nr == 8) {
            int n = lista.get_lungime();

            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                int nr1, nr2;

                cout << " Introduceti numarul numerelor complexe intre care doriti sa verificati egalitatea\n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i];
                }

                cout << " Numar 1 = ";
                cin >> nr1;
                while (nr1 < 0 || nr1 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 1 = ";
                    cin >> nr1;
                }
                cout << " Numar 2 = ";
                cin >> nr2;
                while (nr2 < 0 || nr2 >= n) {
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                    cout << " Numar 2 = ";
                    cin >> nr2;
                }

                if (lista[nr1] == lista[nr2])
                    cout << " Numerele sunt egale\n";
                else
                    cout << " Numerele nu sunt egale\n";
            }
        } else if (optiune == 2 && nr == 9) {
            if(lista.get_lungime())
                cout << lista << '\n';
            else
                cout <<" Nu exista noduri in lista inca\n";

        } else if (optiune == 2 && nr == 10) {
            if(lista.get_lungime())
                cout << " Suma listei de numere complexe este " << lista.suma() << '\n';
            else
                cout <<" Nu exista noduri in lista inca\n";
        } else if (optiune == 2 && nr == 11) {
            int n = lista.get_lungime();
            if (n == 0) {
                cout << " Nu exista inca numere in lista\n";
            } else {
                cout << " Introduceti numarul numarului complex pe care doriti sa il stergeti: \n";
                for (int i = 0; i < n; i++) {
                    cout <<"\t"<< i << ". " << lista[i];
                }
                cout << " Numar = ";
                int num;
                cin >> num;

                if (num < 0 || num > n)
                    cout << " Numar gresit, introduceti un numar intre 0 si " << n - 1 << "\n";
                else {
                    lista.sterge(lista[num]);
                    cout << " Nodul a fost sters cu succes\n";
                }
            }
        } else if (optiune == 2 && nr == 12) {
            goto meniu;

        } else if (optiune == 3 && nr == 1) {
            if (vec == lista)
                cout << " Vectorul are aceleasi numere complexe ca lista\n";
            else
                cout << " Vectorul nu are aceleasi numere complexe ca lista\n";

        } else if (optiune == 3 && nr == 2) {
            goto meniu;

        } else {
            cout << " Numarul introdus nu este valid, introduceti un numar intre 1 si ";
            if (optiune == 1)
                cout << "13\n";
            else if (optiune == 2)
                cout << "12\n";
            else if (optiune == 3)
                cout << "2\n";
            else {
                cout <<"4\n";
            }
        }

        cout << " ----------------------------------------------------------------------------------------- \n";
        char resp[255];
        cin.get();
        cout << " Apasati enter daca doriti sa mai faceti o alta actiune sau 'n' altfel ";
        cin.getline(resp, 255);
        if (strcmp(resp, "n") == 0)
            terminat = true;
        else
            cout << "\n ----------------------------------------------------------------------------------------- \n\n";

    }
*/
    // atribuire multipla, cout <<A+B << A+B+C; pe liste




    Numar_Complex A(3, 4), B(1, 1), C(2, 3), D(10, 29), E(21, -3);
    Vector_Complex v1, v2(A), v3(A, B), v4 = v3;
    Vector_Complex v5(false);

    cin >> v1;
    cout <<v1 <<" "<<-v1;
    ++v1;
    v1++;
    double y = v1;
    cout << y <<'\n';

    Vector_Complex v[3];
    v[0] = v1;
    v[1] = v[2];//= v3 - v2;
    if(v[0] != v[2])
        v[0] += v[2];
    else if(!v[1])
        cout <<"v[1] nu e zero";

    // Transformati o functie prieten din cadrul proiectului intr-o functie membra;
    // Vector_Complex& operator+(Vector_Complex &);

    // Transformati o functie membra din cadrul proiectului intr-o functie prieten;
    // friend Numar_Complex suma(Vector_Complex&);

    /*
    Nod_Complex n1(A), n2(B), n3(C), n4(D), n5(E);
    Lista_Complexa lis1(&n1), lis2(&n2), lis3 = lis2;
    lis1.adaugare_nod_final(&n2);
    lis1.adaugare_nod_final(&n3);
    lis1.adaugare_nod_final(&n4);
    lis1.adaugare_nod_final(&n5);

    cout << lis3 <<"\t"<< lis1<<"\n";
    cout <<lis1+lis2<<"\n";
    cout <<(double)lis1<<"\n";
   // cout <<100.2 + lis1<<"\n";

    cout <<A+B<<"\n";
    cout <<A+B+C<<"\n";
    double x = E;
    cout << x <<"\n";
*/
    /*
    A.afis();
    cout << A.getRe() <<'\n';
    cout << A.modul() <<'\n';
    (A+B).afis();
    (A*B).afis();
    (A/B).afis();
    cout <<A+B <<" "<<A+B+C;
    cout <<"\n\n";
    Nod_Complex inceput(A);
    Lista_Complexa lista(&inceput);
    Nod_Complex* Nod_B = new Nod_Complex(B);
    lista.adaugare_nod_final(Nod_B);
    lista.adaugare_inainte_nod(new Nod_Complex(C), Nod_B);
    cout << lista;
    */
    return 0;
}
