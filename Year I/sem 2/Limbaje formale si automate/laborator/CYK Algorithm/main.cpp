#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

int np; //nr de productii
string gram[100][100]; //gramatica de intrare
string concat(string a, string b){ //concateneaza fara a repeta terminalele
    string aux = a;
    for(int i = 0; i < b.length(); i++)
        if(aux.find(b[i]) == std::string::npos) //==NULL(deci nu se repeta)
            aux += b[i];
    return aux;
}

string cauta(string p){ //cauta litera corespunzatoare unei productii
    string aux = "";
    for(int j = 0; j < np; j++)
        for(int k = 2; k < 2 + stoi(gram[j][1]); k++)
            if(gram[j][k] == p) aux = concat(aux, gram[j][0]);
    return aux;
}

string combina(string a, string b){ //combina ex:AB*BA= AB, AA, BB, BA
    string l, aux = "";
    for(int i = 0; i < a.length(); i++)
        for(int j = 0; j < b.length(); j++){
            l = ""; l = l + a[i] + b[j];
            aux += cauta(l); //si returneaza litera corespunzatoare productiiei
        }
    return aux;
}

int main()
{
    char start; // simbol de start
    cout << "Simbol de start: "; cin >> start;
    cout << "Nr de productii totale: "; cin >> np;

    // citire gramatica
    for(int i = 0; i < np; i++){
        cout << "Litera: "; cin >> gram[i][0];
        cout << "Nr productii: "; cin >> gram[i][1];
        for(int j = 2; j < stoi(gram[i][1]) + 2; j++) cin >> gram[i][j];
    }

    string matrix[100][100], cuvant; // matrix = matrice pentru cuvant
    cout << "Introduceti cuvantul pt verificare: "; cin >> cuvant;
    string l; //retin literele din cuvant
    string aux; //folosesc pt concatenare terminale

    // initializare matrice (voi incepe de la 1 si liniile si coloanele)
    for(int i = 1; i <= cuvant.length(); i++){ //pt fiecare litera a cuvantului
        l = cuvant[i-1]; aux="";
        for(int j = 0; j < np; j++){ //caut in fiecare productie
            for(int k = 2; k < stoi(gram[j][1]) + 2; k++)
                if(l == gram[j][k]){
                    aux = concat(aux, gram[j][0]);
                    break;
                }
        }
        matrix[1][i] = aux;
    }

    // construire matrice propriu-zis
    for(int j = 2; j <= cuvant.length(); j++){ //pt fiecare linie
        for(int i = 1; i <= cuvant.length()-j+1; i++){ //pt fiecare coloana
            aux = "";
            for(int k = 1; k < j; k++){ //pt k-ul
                l = combina(matrix[k][i], matrix[j-k][i+k]);
                aux = concat(aux, l);
            }
            matrix[j][i]=aux;
        }
    }

    // afisare matrice
    cout << endl;
    for(int j = 1; j <= cuvant.length(); j++){
        for(int i = 1; i <= cuvant.length()-j+1; i++) cout << setw(5) << matrix[j][i];
        cout << endl;
    }
    if(matrix[cuvant.length()][1].find(start)!=std::string::npos)
        cout << "Cuvantul este acceptat de limbaj." << endl;
    else cout << "Cuvantul nu este acceptat de limbaj." << endl;


    return 0;
}
