#include <iostream>
#include <string>
#include <vector>
using namespace std;
class zbor{ static int id;
            int idZ;
            string detinatie;
            string data;
 public: virtual double bilet(){}
         virtual void afisare(ostream & o)const{}
    zbor(){id++; idZ=id++}
           };
  int zbor::id=0;
ostream & operator<< (ostream & o, const  zbor & z){z.afisare(o); return o;}

class zborL:virtual public zbor{double costKgB;};
class zborE:virtual public zbors{vector<string> escale;};
class zborC: virtual public zbor{public: double cost;};

class zborLC:public zborL,public zborC{};
class zborEC:public zborE,public zborC{};
class companie {vector<zbor *> zboruri;};///necesita constructor de initializare si copiere, operator=

int main()
{}
