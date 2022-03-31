#include <iostream>

using namespace std;

/// exemplu de utilizare operatori
class student
{
    string nume;
    int grupa;
    public:
    void citire();
    void afisare();
    friend istream& operator>> (istream&, student&);
    friend bool operator==(student&, student&);   /// supraincarcare de operatori
    friend bool operator==(student&, string&);
    friend bool operator==(string&, student&);
};

    istream& operator>> (istream& in, student& ob)
    {
        in>>ob.nume>>ob.grupa;
        return in;
    }

    bool operator==(student& s1, student& s2)
    {
        return s1.nume == s2.nume;
    }

    bool operator==(student& s, string& x)
    {
        return s.nume == x;
    }

    bool operator==(string& x, student& s)
    {
        return s.nume == x;
    }

int main()
{
    student s;
    cin>>s;  /// operator>>(cin,s);
    s.afisare();

    student s1, s2;
    string x = "popescu";
    cin>>s1>>s2;
    if (s1 == s2) cout<<"au acelasi nume\n"; /// ==(student,student)
    if (s1 == x) cout<<"am gasit un popescu"; /// ==(student,string)
///    if (s1 == "popescu") cout<<"am gasit un popescu"; /// ==(student,const char []); compilatorul nu gaseste functie cu param
    return 0;
}

    void student::citire() { cin>>nume>>grupa;}
    void student::afisare() {cout<<nume<<" "<<grupa<<"\n";}


/// utilitate private, protected, public; protected la mostenire; exemplu de clasa prieten care are acces la date private etc
/*
class student
{
    protected:
        string nume;
    private:
    int grupa;
    public:
    void citire();
    void afisare();
    void set_nume(string);
    string get_nume();
    friend class profesor; /// a nu se abuza; clasele prietene (si functiile membre prietene) pot avea acces la datele private
};

class student_olimpic : public student
{
public:
    void afisare(){cout<<"Olimpic :"<<nume<<"\n";}
///    void afisare(){cout<<"Olimpic :"<<nume<<" "<<grupa<<"\n";} /// grupa este inaccesibila, chiar daca vorbim de clasa derivata
};

class profesor
{
    string nume;
public:
    void citire(){cin>>nume;}
    void afisare();
    void afis_student(student s){cout<<"Profesorul "<<nume<<" a dat nota 10 studentului "<<s.nume<<"\n";}
};

int main()
{
    student s;
    s.citire();
    s.afisare();
    profesor p;
    p.citire();
    p.afis_student(s);
    student_olimpic o;
    o.citire();
    o.afisare();
    return 0;
}

    void student::citire() { cin>>nume>>grupa;}
    void student::afisare() {cout<<nume<<" "<<grupa<<"\n";}
    void student::set_nume(string n){nume = n;}
    string student::get_nume(){return nume;}

    void profesor::afisare(){cout<<"Profesor "<<nume<<"\n";}
*/
/*
/// :: operator de rezolutie de scop;

class student
{
    private:
    string nume;
    int grupa;
    public:
    void citire();
    void afisare();
    void set_nume(string);
    string get_nume();
};

    void student::citire() { cin>>nume>>grupa;}
    void student::afisare() {cout<<nume<<" "<<grupa<<"\n";}
    void student::set_nume(string n){nume = n;}
    string student::get_nume(){return nume;}

int main()
{
    student s;
    s.citire();
    s.afisare();
///    cout<<s.nume<<"\n";
    cout<<s.get_nume();
    return 0;
}
*/

/*********************** class = struct cu toate datele, by default, private **********************/
/// private, public, protected = 3 modificatori de acces
/// DATE PUBLICE = PICAT EXAMEN DE POO; Functiile pot fi publice, datele NU
/*
class student
{
    private:
    string nume;
    int grupa;
    public:
    void citire() { cin>>nume>>grupa;}
    void afisare() {cout<<nume<<" "<<grupa<<"\n";}
    /// set-eri si get-eri
    void set_nume(string n){nume = n;}
    string get_nume(){return nume;}
};

int main()
{
    student s;
    s.citire();
    s.afisare();
///    cout<<s.nume<<"\n";
    cout<<s.get_nume();
    return 0;
}
*/

/************* trecerea de la struct la class **************************************************/
/*
struct student
{
    string nume;
    int grupa;
    void citire() { cin>>nume>>grupa;}
    void afisare() {cout<<nume<<" "<<grupa<<"\n";}
};

int main()
{
    student s;
    s.citire();
    s.afisare();
    return 0;
}
*/
/************* procedural citire si afisare variabila de tip structura ***************************/
/*
struct student
{
    string nume;
    int grupa;
};

void citire(student &s) { cin>>s.nume>>s.grupa;}
void afisare(student s) {cout<<s.nume<<" "<<s.grupa<<"\n";}

int main()
{
    student s;
    citire(s);
    afisare(s);
    return 0;
}
*/
