#include <iostream>
#include <string.h>

using namespace std;


class Test {
    char *nume;
    int n;
    float *v;
public:
    Test(){};
    Test(const Test&);
    Test& operator=(Test&);
    //Test& operator+(float);
    friend Test& operator+(Test&, float);
    friend Test& operator+(float, Test&);
    bool operator==(Test&);
    friend istream& operator >>(istream&, Test&);
    friend ostream& operator <<(ostream& out, Test& t){
        out <<t.nume<<" ";
        for(int i = 0; i < t.n; i++)
            out << t.v[i] <<" ";
        out <<"\n";
        return out;
    }

};

//memcpy tema

Test& operator+(Test& t, float x){
    t.n++;
    float *aux = new float [t.n];
    for(int i = 0; i < t.n - 1; i++){
        aux[i] = t.v[i];
    }
    aux[t.n-1] = x;
    delete[] t.v;
    t.v = aux;
    return t;
}

Test& operator+(float x, Test& t){
    t.n++;
    float *aux = new float [t.n];
    for(int i = 0; i < t.n - 1; i++){
        aux[i] = t.v[i];
    }
    aux[t.n-1] = x;
    delete[] t.v;
    t.v = aux;
    return t;
}

bool Test::operator==(Test& p){
    if(strcmp(this->nume, p.nume) != 0)
        return false;
    else if (this->n != p.n)
        return false;
    else {
        for(int i = 0; i < this->n; i++)
            if(this->v[i] != p.v[i])
                return false;
    }
    return true;
}
/*
bool Test::operator==(Test& t, Test& p){
    if(strcmp(t.nume, p.nume) != 0)
        return false;
    else if (t.n != p.n)
        return false;
    else {
        for(int i = 0; i < t.n; i++)
            if(t.v[i] != p.v[i])
                return false;
    }
    return true;
}
Test& Test::operator+(float x){
    this->n++;
    float *aux = new float [this->n];
    for(int i = 0; i < this->n - 1; i++){
        aux[i] = this->v[i];
    }
    aux[this->n-1] = x;
    delete[] v;
    v = aux;
    return *this;
}
*/
Test::Test(const Test& ob){
    this->nume = new char[strlen(ob.nume)+1];
    strcpy(this->nume, ob.nume);
    this->n = ob.n;
    this->v= new float[this->n];
    for(int i = 0; i < this->n; i++)
        this->v[i]= ob.v[i];
}

Test& Test::operator=(Test& ob){
    if(this != &ob){
         this->nume = new char[strlen(ob.nume)+1];
        strcpy(this->nume, ob.nume);
        this->n = ob.n;
        this->v= new float[this->n];
        for(int i = 0; i < this->n; i++)
            this->v[i]= ob.v[i];
    }
    return *this;
}

istream& operator >>(istream& in, Test& t){
    char s[255];
    in.get(s, 255);
    in.get();
    t.nume = new char[strlen(s) + 1];
    strcpy(t.nume, s);
    in >> t.n;
    t.v = new float[t.n];
    for(int i = 0; i < t.n; i++)
        in >> t.v[i];
    in.get();
    return in;

}
int main()
{
    Test a;
    cin >> a;
    cout << a <<"\n";
    a = a;
    cout << a <<'\n';
    a = a + 10;
    a = 7 + a;
    cout << a <<'\n';

    Test b;
    cin >> b;
    if (a == b)
       cout <<"Da";
    else
        cout <<"Nu";

    return 0;
}
