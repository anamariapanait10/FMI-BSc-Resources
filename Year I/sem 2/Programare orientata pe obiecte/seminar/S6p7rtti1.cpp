#include <cstdlib>
#include <iostream>
#include <fstream>
#include <typeinfo> /*  !!! biblioteca ce ofera informatii asupra tipului de date
-operatorul typeid() apelat pentru tip de date sau expresie 
-intoarce referinta la  obiect de tip type_info
-clasa type_info are:- operatorul == si != pentru compararea tipurilor
                      -metoda name()(intoarce un format intern pt numele tipului de date)
*/
using namespace std;

class B
{
public:  virtual void fv(){} // mecanism functional doar daca sunt metode virtuale
                            //pointer suplimentar si evaluare la executie
};

class D: public B
{
public:  void fv(){}
         void fsup(){cout<<"suplimentar";}
};




int main()
{B *pb;
int i;
cin>>i;
if(i) pb=new B;
      else pb=new D;
cout<<typeid(*pb).name()<<endl;// typeid(*pb).name() este codificat intern -nu neaparat "D"
//(D*)pb; /* corect- daca stiu ca la pb am obiect de tip D/
if( typeid(*pb)==typeid(D)) ((D *)pb)->fsup();
else cout<<"obiect B"<<endl;

if( typeid(pb)==typeid(B*)) cout<<"pointer din B"<<endl; // chiar daca contine adresa unui obiect din D, pointerul este vazut ca B*
else cout<<"pointer din D";

}

