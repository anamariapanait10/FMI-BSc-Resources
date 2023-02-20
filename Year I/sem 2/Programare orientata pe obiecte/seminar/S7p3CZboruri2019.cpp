#include <iostream>
#include <string>
#include <vector>
using namespace std;
class zbor{
 static int id;
        int idZ;
        string destinatie;
        string data;
public: virtual double bilet(){}
        virtual void afisare(ostream & o)const{}
        zbor(){id++; idZ=id++}
           };
int zbor::id=0;

ostream & operator<< (ostream & o, const zbor & z){z.afisare(o); return o;}

class zborL:public zbor{double costKgB;};
class zborE:public zbor{vector<string> escale;};

class charter{public: double cost;};

class zborLC:public zborL,public charter{};
class zborLE:public zborE,public charter{};

//class companieP {zbor * zboruri[100];};///necesita constructor de initializare si copiere, operator=

class companie{vector<zbor*>zboruri;
                /*string tipC; void adaugaZbor(){ if(tipC=="Low"){}
                                                if(tipC=="Linie"){}}  */
                virtual void adaugaZbor()=0;
                };  ///necesita constructor de initializare si copiere, operator=
class companieLow:public companie
 {void adaugaZbor(){}///doar zborL si zborLC
 };

class companieLinie:public companie
 {void adaugaZbor(){}///doar zbor,zborE si zborEC
 };

/*class Bilet{zbor * z;}*/

/*template <class T>
class companieT{vector<T> zboruri;}; // eventual vector<T*> */

int main()
{
}
