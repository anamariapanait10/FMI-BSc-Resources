f = open("C:\\Users\\Ana\\Desktop\\FMI\\Year I\\sem 2\\Programare orientata pe obiecte\\marire\\main.cpp", "r")
g = open("output.txt", "w")

Classes = []
Entities = []

class_index = -1
lines = f.readlines()
for line in lines:
    words = line.replace(',', '').replace(';', '').split()
    if words[0] == "class":
        Classes.append(words[1:])
        class_index += 1
        Entities.append([])
    else:
        dataType = words[0]
        Entities[class_index].append((dataType, words[1:]))


def Main(class_index):
    print("\t", Classes[class_index][0], sep="", end="", file=g)
    print("(", end="", file=g)
    # constructor parametrizat
    numberOfEntities = len(Entities[class_index])
    step = 1
    for tuple in Entities[class_index]:
        if tuple[0] != "static":
            step2 = 1
            numberOfEntities2 = len(tuple[1])
            for entity in tuple[1]:
                print(f"{tuple[0]} {entity}", end="", file=g)
                if tuple[0] == "int" or tuple[0] == "float" or tuple == "double":
                    print("=0", end="", file=g)
                elif tuple[0] == "string":
                    print("=\"\"", end="", file=g)
                if "vector" in tuple[0]:
                    print("={}", end="", file=g)
                if step2 != numberOfEntities2:
                    print(", ", end="", file=g)
                step2 += 1
            if step != numberOfEntities:
                print(", ", end="", file=g)
            else:
                print(");", file=g)
        step = step + 1


    # constructor de copiere
    print(f"\t{Classes[class_index][0]}(const {Classes[class_index][0]}&);", file=g)

    # destructor
    if len(Classes[class_index]) > 1:
        print(f"\t~{Classes[class_index][0]}();", file=g)
    else:
        print(f"\tvirtual ~{Classes[class_index][0]}();", file=g)

    # seteri + geteri
    for tuple in Entities[class_index]:
        for entity in tuple[1]:
            if "vector" not in tuple[0] and tuple[0] != "static":
                print(f"\tvoid set_{entity}({tuple[0]});", file=g)
            elif tuple[0] != "static":
                print(f"\tvoid set_{entity}({tuple[0]});", file=g)

            if tuple[0] == "static":
                print(f"\t{tuple[0]} int get_{entity}();", file=g)
            elif "vector" not in tuple[0]:
                print(f"\t{tuple[0]} get_{entity}();", file=g)
            else:
                print(f"\t{tuple[0]} get_{entity}();", file=g)
    if len(Classes[class_index]) > 1:
        print("\tvoid citire(istream&);", file=g)
        print("\tvoid afisare(ostream&);", file=g)
    else:
        print("\tvirtual void citire(istream&);", file=g)
        print("\tvirtual void afisare(ostream&);", file=g)
    print(f"\tfriend istream& operator>>(istream&, {Classes[class_index][0]}&);", file=g)
    print(f"\tfriend ostream& operator<<(ostream&, {Classes[class_index][0]}&);", file=g)


def Constructor(class_index):
    # constructor parametrizat
    print(Classes[class_index][0], "::", Classes[class_index][0], sep="", end="", file=g)
    print("(", end="", file=g)

    numberOfEntities = len(Entities[class_index])
    step = 1
    for tuple in Entities[class_index]:
        if tuple[0] != "static":
            step2 = 1
            numberOfEntities2 = len(tuple[1])
            for entity in tuple[1]:
                print(f"{tuple[0]} {entity}", end="", file=g)
                if step2 != numberOfEntities2:
                    print(", ", end="", file=g)
                step2 += 1
            if step != numberOfEntities:
                print(", ", end="", file=g)
            else:
                print("){", file=g)

        step = step + 1

    for tuple in Entities[class_index]:
        dataType = tuple[0]
        if tuple[0] != "static":
            for entity in tuple[1]:
                print(f"\tthis->{entity} = {entity};", file=g)

    print("}", file=g)

    # constructor de copiere
    print(Classes[class_index][0], "::", Classes[class_index][0], sep="", end="", file=g)
    print(f"(const {Classes[class_index][0]}& ob)", end="", file=g)
    print("{", file=g)
    for tuple in Entities[class_index]:
        dataType = tuple[0]
        for entity in tuple[1]:
            if "vector" not in dataType and dataType != "static":
                print(f"\tthis->{entity} = ob.{entity};", file=g)
            elif "vector" in dataType:
                print(f"\tint nr = ob.{entity}.size();", file=g)
                print(f"\t{entity} = {dataType}(nr);", file=g)
                print(f"\tfor(int i = 0; i < nr; i++)", file=g)
                print(f"\t\tthis->{entity}[i] = ob.{entity}[i];", file=g)
    print("}", file=g)

def Destructor(class_index):
        print(f"{Classes[class_index][0]}::~{Classes[class_index][0]}()", end="", file=g)
        print("{\n\n};", file=g)


def Citire(class_index):
    print(f"void {Classes[class_index][0]}", file=g, end="")
    print(f"::citire(istream& in)", file=g, end="")
    print("{", file=g)
    for tuple in Entities[class_index]:
        for variable in tuple[1]:
            if "vector" not in tuple[0] and tuple[0] != "static":
                print(f"\tcout << \"{variable} = \";", file=g)
                print(f"\tin >> this->{variable};", file=g)
            elif tuple[0] != "static":
                print(f"\tint nr;", file=g)
                print(f"\tcout << \"Introduceti numarul de {variable} = \";", file=g)
                print("\tin >> nr;", file=g)
                print(f"\tcout << \"Introduceti elementele: \";", file=g)
                print(f"\tfor(int i = 0; i < nr; i++)", file=g)
                print(f"\t\tin >> this->{variable}[i];", file=g)
    print("}", file=g)
    print(f"istream& operator>>(istream& in, {Classes[class_index][0]} ", file=g, end="")
    print("&ob){", file=g)
    print("\tob.citire(in);", file=g)
    print("\treturn in;", file=g)
    print("}", file=g)


def Afisare(class_index):
    print(f"void {Classes[class_index][0]}", file=g, end="")
    print(f"::afisare(ostream& out)", file=g, end="")
    print("{", file=g)

    for tuple in Entities[class_index]:
        for variable in tuple[1]:
            if "vector" not in tuple[0] and tuple[0] != "static":
                print(f"\tout << \"{variable} = \"<< {variable} << \'\\", end="", file=g)
                print("n';", file=g)
            elif tuple[0] != "static":
                print(f"\tint nr = {variable}.size();", file=g)
                print(f"\tout << \"{variable}: \";", file=g)
                print(f"\tfor(int i = 0; i < nr; i++)", file=g)
                print(f"\t\tout << this->{variable}[i] << \'\\", end="", file=g)
                print("n';", file=g)

    print("}\n", file=g)

    print(f"ostream& operator<<(ostream& out, {Classes[class_index][0]} ", file=g, end="")
    print("&ob) {", file=g)
    print("\t\tob.afisare(out);", file=g)
    print("\t\treturn out;", file=g);
    print("}", file=g)


def Setter(class_index):
    for tuple in Entities[class_index]:
        if tuple[0] != "static":
            for variable in tuple[1]:
                print(f"void {Classes[class_index][0]}::set_{variable}({tuple[0]} {variable})", file=g, end="")
                print("{", file=g)
                if "\tvector" not in tuple[0]:
                    print(f"\tthis->{variable} = {variable};", file=g)
                else:
                    print(f"\tint nr = {variable}.size();")
                    print("\tfor(int i = 0; i < nr; i++)", file=g)
                    print(f"\t\tthis->{variable}[i] = {variable}[i];", file=g)
                print("}", file=g)


def Getter(class_index):
    for tuple in Entities[class_index]:
        for variable in tuple[1]:
            if tuple[0] == "static":
                print(f"int {Classes[class_index][0]}::get_{variable}()", file=g, end="")
            elif "vector" not in tuple[0]:
                print(f"{tuple[0]} {Classes[class_index][0]}::get_{variable}()", file=g, end="")
            else:
                print(f"{tuple[0]} {Classes[class_index][0]}::get_{variable}()", file=g, end="")
            print("{", file=g)
            print(f"\treturn {variable};", file=g)
            print("}", file=g)


print("/*\nCompilator folosit: MinGW w64 9.0\nNume tutore laborator: Anca Dovrovat\n*/", file=g)
print("#include <iostream>\n#include <vector>\n\nusing namespace std;\n\n", end="", file=g)


for index in range(class_index):
    print(f"class {Classes[index][0]}", end="", file=g)
    prima = 1
    for cls in Classes[index][1:]:
        if prima == 1:
            print(": virtual public", cls, end="", file=g)
            prima = 0
        else:
            print(", virtual public", cls, end="", file=g)
    print("{", file=g)


    for entity in Entities[index]:
        dataType = entity[0]
        first_variable = entity[1][0]
        if dataType != "static":
            print("\t", dataType, " ", first_variable, sep="", end="", file=g)
        else:
            print("\tstatic int", first_variable, end="", file=g)
        for variable in entity[1][1:]:
            print(", ", variable, end="", file=g)
        print(";", file=g)

    print("public:", file=g)
    Main(index)
    print("};", file=g)

    for entity in Entities[index]:
        dataType = entity[0]
        if dataType == "static":
            print(f"int {Classes[index][0]}::{entity[1][0]} = 0;", file=g)

    Constructor(index)
    Destructor(index)
    Setter(index)
    Getter(index)
    Citire(index)
    Afisare(index)


continut_main = """
/*
    produse* v[1000];
    int n;
    cout <<"Introduceti numarul de obiecte pe care doriti sa il cititi = ";
    cin >> n;
    for(int i = 0; i < n; i++){
        int nr = rand() % 5;
        if (nr == 0){
            vector<string> vec;
            vec.push_back("Nume autor 1");
            vec.push_back("Nume autor 2");
            carti* c = new carti(1.2, 2, "Titlu carte", "EdituraX", vec);
            cout <<"Introduceti datele pentru noul obiect de tip carte:";
            c->citire();
            v[i] = c;
        } else if(nr == 1) {
            vector<string> vec;
            vec.push_back("Nume inter 1");
            vec.push_back("Nume inter 2");
            cout << "Introduceti datele pentru noul obiect de tip dvd cu muzica:";
            dvd_muzica *d = new dvd_muzica(1.2, 3, 30, "Nume album", vec);
            d->citire();
            v[i] = d;
        } else if(nr == 2){
            cout <<"Introduceti datele pentru noul obiect de tip dvd cu filme:";
            dvd_filme* d = new dvd_filme(1.2, 3, 30, "Nume film", "Gen film");
            d->citire();
            v[i] = d;
        } else if(nr == 3){
            vector<string> vec;
            vec.push_back("Nume inter 1");
            vec.push_back("Nume inter 2");
            cout <<"Introduceti datele pentru noul obiect de tip figurine:";
            figurina* f = new figurina(1.2, 3, "DenumireX", "CategorieX", "BrandX", "MaterialX");
            f->citire();
            v[i] = f;
        } else if(nr == 4){
            cout <<"Introduceti datele pentru noul obiect de tip poster:";
            poster * f = new poster(1.2, 3, "DenumirePoster", "A4");
            f->citire();
            v[i] = f;
        }
    }
    cout <<"Datele introduce sunt:";
    for(int i = 0; i < n; i++){
        (*v[i]).afisare();
    }"
    cout<<"Cautarea unei carti dupa titlu:";
    string titlu_cautat;
    cout << "Introduceti cartea cautata: ";
    int gasit = 0;
    for(int i = 0; i < n; i++) {
        if (!(dynamic_cast<obiecte_colectie *>(v[i]) || dynamic_cast<dvd *>(v[i])))
            if ((*v[i]).get_titlu() == titlu_cautat) {
                cout << "Cartea cautata se afla in vector pe pozitia " << i;
                gasit = 1;
            }
        if(dynamic_cast<Trapez*>(v[j]) || dynamic_cast<Paralelogram*>(v[j])
        || dynamic_cast<Romb*>(v[j]) || dynamic_cast<Dreptunghi*>(v[j]))
                break;
            else {
                cout << j << " "; break;
    }
*/
"""
print("int main(){", file=g)
print(continut_main, file=g)
print("\t return 0;\n}", file=g)

f.close()
g.close()
f = open("C:\\Users\\Ana\\Desktop\\FMI\\Year I\\sem 2\\Programare orientata pe obiecte\\marire\\main.cpp", "w")
g = open("output.txt", "r")
f.write(g.read())
f.close()
g.close()


"""
exemplu apel:
class produse;
float pret;
int cantitate;
class carti;
string titlu, editura;
vector<string> autori;
class dvd;
int nr_min;
class dvd_muzica;
string album;
vector<string> interpreti;
class dvd_filme;
string film, gen;
class obiecte_colectie;
string denumire;
class figurine;
string categorie, brand, material;
class poster;
string format;
"""