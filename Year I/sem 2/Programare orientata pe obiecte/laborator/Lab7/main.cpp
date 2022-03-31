#include <iostream>
#include <typeinfo>

using namespace std;

class Student{
protected:
    string nume;
    int grupa;
public:
    virtual void citire(){cin >> nume >> grupa;}
    virtual void afisare(){cout << nume<<" "<<grupa<<"\n";}
    friend istream& operator>>(istream& in, Student& s){
        in >> s.nume >> s.grupa;
        return in;
    }
    friend ostream& operator<<(ostream& out, Student& s){
        out << s.nume<<" "<<s.grupa<<" ";
        return out;
    }
};

class Student_1322: public Student{
    const string x = "The Best";
    float nota;
public:
    void citire(){
        Student::citire();
        cin >> nota;
    }
    void afisare(){
        cout << x;
        Student::afisare();
        cout << nota;
    }
    friend istream& operator>>(istream& in, Student_1322& s){
        in >> dynamic_cast<Student&>(s);
        in >> s.nota;
        return in;
    }
    friend ostream& operator<<(ostream& out, Student_1322& s){
        out << (Student&)(s);
        out << s.nota;
        return out;
    }
};

int main()
{
    Student* v[10];
    int n;
    cin >> n;
    for(int i = 0; i < n; i++){
        int op;
        cin >> op;
        if(op == 1)
            v[i] = new Student();
        else
            v[i] = new Student_1322(); //upcast
    }
    for(int i = 0; i < n; i++){
        if(typeid(*v[i]) == typeid(Student))
            cout <<*v[i];
        else
            cout << *dynamic_cast<Student_1322*>(v[i]); //downcast
    }

    return 0;
}
