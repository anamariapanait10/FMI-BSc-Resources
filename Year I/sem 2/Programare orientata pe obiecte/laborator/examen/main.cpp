/*
Compilator folosit: MinGW w64 9.0
Nume tutore laborator: Anca Dovrovat
*/
#include <iostream>
#include <vector>

using namespace std;

class bilet{
	float taxa;
	int valid = 1;
    static int nr_bilete;
public:
	bilet(float taxa);
	bilet(const bilet&);
	virtual ~bilet();
	void set_taxa(int);
	int get_taxa();
	void set_valid(int);
	int get_valid();
    int get_nr_bilete();
	virtual void citire(istream&);
	virtual void afisare(ostream&);
	friend istream& operator>>(istream&, bilet&);
	friend ostream& operator<<(ostream&, bilet&);
};
int bilet::nr_bilete = 0;

int bilet::get_nr_bilete() {
    return nr_bilete;
}
bilet::bilet(float taxa){
    nr_bilete++;
	this->taxa = taxa;
}
bilet::bilet(const bilet& ob){
    nr_bilete++;
	this->taxa = ob.taxa;
	this->valid = 1;
}
bilet::~bilet(){
    nr_bilete--;
    valid = 0;
};
void bilet::set_taxa(int taxa){
	this->taxa = taxa;
}
void bilet::set_valid(int valid){
	this->valid = valid;
}
int bilet::get_taxa(){
	return taxa;
}
int bilet::get_valid(){
	return valid;
}
void bilet::citire(istream& in){
	cout << "taxa = ";
	in >> this->taxa;
}
istream& operator>>(istream& in, bilet &ob){
	ob.citire(in);
	return in;
}
void bilet::afisare(ostream& out){
	out << "taxa = "<< taxa << '\n';
	out << "valid = "<< valid << '\n';
}

ostream& operator<<(ostream& out, bilet &ob) {
		ob.afisare(out);
		return out;
}


class bilet_supraf: virtual public bilet{
	static int nr_supraf;
public:
	bilet_supraf(float taxa);
	~bilet_supraf();
	static int get_nr_supraf();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, bilet_supraf&);
	friend ostream& operator<<(ostream&, bilet_supraf&);
};

int bilet_supraf::nr_supraf = 0;
bilet_supraf::bilet_supraf(float taxa): bilet(taxa){
    nr_supraf++;
    this->set_taxa(2);
}
bilet_supraf::~bilet_supraf(){
    nr_supraf--;
};
int bilet_supraf::get_nr_supraf(){
	return nr_supraf;
}
void bilet_supraf::citire(istream& in){
}
istream& operator>>(istream& in, bilet_supraf &ob){
	ob.citire(in);
	return in;
}
void bilet_supraf::afisare(ostream& out){
}

ostream& operator<<(ostream& out, bilet_supraf &ob) {
		ob.afisare(out);
		return out;
}
class bilet_metrou: virtual public bilet{
	static int nr_metrou;
public:
	bilet_metrou(float taxa);
	~bilet_metrou();
	static int get_nr_metrou();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, bilet_metrou&);
	friend ostream& operator<<(ostream&, bilet_metrou&);
};
int bilet_metrou::nr_metrou = 0;
bilet_metrou::bilet_metrou(float taxa): bilet(taxa){
    nr_metrou++;
    this->set_taxa(2.5);
}

bilet_metrou::~bilet_metrou(){
    nr_metrou--;
};
int bilet_metrou::get_nr_metrou(){
	return nr_metrou;
}
void bilet_metrou::citire(istream& in){
}
istream& operator>>(istream& in, bilet_metrou &ob){
	ob.citire(in);
	return in;
}
void bilet_metrou::afisare(ostream& out){
}

ostream& operator<<(ostream& out, bilet_metrou &ob) {
		ob.afisare(out);
		return out;
}
class bilet_tranzit: virtual public bilet{
	int durata;
	static int nr_tranzit;
public:
	bilet_tranzit(float taxa, int durata);
	~bilet_tranzit();
	void set_durata(int);
	int get_durata();
	static int get_nr_tranzit();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, bilet_tranzit&);
	friend ostream& operator<<(ostream&, bilet_tranzit&);
};
int bilet_tranzit::nr_tranzit = 0;
bilet_tranzit::bilet_tranzit(float taxa, int durata): bilet(taxa) {
    this->durata = durata;
    this->set_taxa(3);
}

bilet_tranzit::~bilet_tranzit(){

};
void bilet_tranzit::set_durata(int durata){
	this->durata = durata;
}
int bilet_tranzit::get_durata(){
	return durata;
}
int bilet_tranzit::get_nr_tranzit(){
	return nr_tranzit;
}
void bilet_tranzit::citire(istream& in){
	cout << "durata = ";
	in >> this->durata;
}
istream& operator>>(istream& in, bilet_tranzit &ob){
	ob.citire(in);
	return in;
}
void bilet_tranzit::afisare(ostream& out){
	out << "durata = "<< durata << '\n';
}

ostream& operator<<(ostream& out, bilet_tranzit &ob) {
		ob.afisare(out);
		return out;
}
class card{
	int min_start;
	int valid = 0;
	vector<bilet*> bilete_card;
public:
	card(int min_start=0, int valid=0, vector<bilet*> bilete_card={});
	card(const card&);
	virtual ~card();
    void adaugare_bilet(bilet* b){
        bilete_card.push_back(b);
    }
    void valideaza_card(){
        int nr = bilete_card.size();
        if (nr > 0){
            this->bilete_card[0]->set_valid(1);
            valid = 1;
        }

    }
	void set_min_start(int);
	int get_min_start();
	void set_valid(int);
	int get_valid();
	void set_bilete_card(vector<bilet*>);
	vector<bilet*> get_bilete_card();
	virtual void citire(istream&);
	virtual void afisare(ostream&);
	friend istream& operator>>(istream&, card&);
	friend ostream& operator<<(ostream&, card&);
};
card::card(int min_start, int valid, vector<bilet*> bilete_card){
	this->min_start = min_start;
	this->valid = valid;
	this->bilete_card = bilete_card;
}
card::card(const card& ob){
	this->min_start = ob.min_start;
	this->valid = ob.valid;
	int nr = ob.bilete_card.size();
	bilete_card = vector<bilet*>(nr);
	for(int i = 0; i < nr; i++)
		this->bilete_card[i] = ob.bilete_card[i];
}
card::~card(){

};
void card::set_min_start(int min_start){
	this->min_start = min_start;
}
void card::set_valid(int valid){
	this->valid = valid;
}
void card::set_bilete_card(vector<bilet*> bilete_card){
	this->bilete_card = bilete_card;
}
int card::get_min_start(){
	return min_start;
}
int card::get_valid(){
	return valid;
}
vector<bilet*> card::get_bilete_card(){
	return bilete_card;
}
void card::citire(istream& in){
	cout << "min_start = ";
	in >> this->min_start;
	int nr;
	cout << "Introduceti numarul de bilete_card = ";
	in >> nr;
	cout << "Introduceti elementele: ";
	for(int i = 0; i < nr; i++)
		this->bilete_card[i]->citire(in);
}
istream& operator>>(istream& in, card &ob){
	ob.citire(in);
	return in;
}
void card::afisare(ostream& out){
	out << "min_start = "<< min_start << '\n';
	out << "valid = "<< valid << '\n';
	int nr = bilete_card.size();
	out << "bilete_card:\n";
	for(int i = 0; i < nr; i++)
		out << *(this->bilete_card[i]) << '\n';
}

ostream& operator<<(ostream& out, card &ob) {
		ob.afisare(out);
		return out;
}
class card_supraf: virtual public card{
public:
	card_supraf();
    card_supraf(const card_supraf&);
	~card_supraf();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, card_supraf&);
	friend ostream& operator<<(ostream&, card_supraf&);
};
card_supraf::card_supraf(){

}
card_supraf::card_supraf(const card_supraf& ob){
}
card_supraf::~card_supraf(){

};
void card_supraf::citire(istream& in){
}
istream& operator>>(istream& in, card_supraf &ob){
	ob.citire(in);
	return in;
}
void card_supraf::afisare(ostream& out){
}

ostream& operator<<(ostream& out, card_supraf &ob) {
		ob.afisare(out);
		return out;
}
class card_subteran: virtual public card{
public:
	card_subteran();
    card_subteran(const card_subteran&);
	~card_subteran();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, card_subteran&);
	friend ostream& operator<<(ostream&, card_subteran&);
};
card_subteran::card_subteran(){

}
card_subteran::card_subteran(const card_subteran& ob){
}
card_subteran::~card_subteran(){

};
void card_subteran::citire(istream& in){
}
istream& operator>>(istream& in, card_subteran &ob){
	ob.citire(in);
	return in;
}
void card_subteran::afisare(ostream& out){
}

ostream& operator<<(ostream& out, card_subteran &ob) {
		ob.afisare(out);
		return out;
}
class card_tranzit: virtual public card{
public:
	card_tranzit();
	~card_tranzit();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, card_tranzit&);
	friend ostream& operator<<(ostream&, card_tranzit&);
};
card_tranzit::card_tranzit(){

}
card_tranzit::~card_tranzit(){

};
void card_tranzit::citire(istream& in){
}
istream& operator>>(istream& in, card_tranzit &ob){
	ob.citire(in);
	return in;
}
void card_tranzit::afisare(ostream& out){
}

ostream& operator<<(ostream& out, card_tranzit &ob) {
		ob.afisare(out);
		return out;
}
class aparat_validare{
	static int bilete_validate;
	vector<card*> carduri;
public:
	aparat_validare(vector<card*> carduri={});
	aparat_validare(const aparat_validare&);
	virtual ~aparat_validare();
    static void add_bilete_validate(){
        bilete_validate++;
    }
	static int get_bilete_validate();
	void set_carduri(vector<card*>);
	vector<card*> get_carduri();
	virtual void citire(istream&);
	virtual void afisare(ostream&);
	friend istream& operator>>(istream&, aparat_validare&);
	friend ostream& operator<<(ostream&, aparat_validare&);
};
int aparat_validare::bilete_validate = 0;
aparat_validare::aparat_validare(vector<card*> carduri){
	this->carduri = carduri;
}
aparat_validare::aparat_validare(const aparat_validare& ob){
	int nr = ob.carduri.size();
	carduri = vector<card*>(nr);
	for(int i = 0; i < nr; i++)
		this->carduri[i] = ob.carduri[i];
}
aparat_validare::~aparat_validare(){

};
void aparat_validare::set_carduri(vector<card*> carduri){
	this->carduri = carduri;
}
int aparat_validare::get_bilete_validate(){
	return bilete_validate;
}
vector<card*> aparat_validare::get_carduri(){
	return carduri;
}
void aparat_validare::citire(istream& in){
	int nr;
	cout << "Introduceti numarul de carduri = ";
	in >> nr;
	cout << "Introduceti elementele: ";
	for(int i = 0; i < nr; i++)
		this->carduri[i]->citire(in);
}
istream& operator>>(istream& in, aparat_validare &ob){
	ob.citire(in);
	return in;
}
void aparat_validare::afisare(ostream& out){
	int nr = carduri.size();
	out << "carduri: ";
	for(int i = 0; i < nr; i++)
		out << *(this->carduri[i]) << '\n';
}

ostream& operator<<(ostream& out, aparat_validare &ob) {
		ob.afisare(out);
		return out;
}
class transport: virtual public aparat_validare{
public:
	transport();
    transport(const transport&);
	~transport();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, transport&);
	friend ostream& operator<<(ostream&, transport&);
};
transport::transport(){

}
transport::transport(const transport& ob){
}
transport::~transport(){

};
void transport::citire(istream& in){
}
istream& operator>>(istream& in, transport &ob){
	ob.citire(in);
	return in;
}
void transport::afisare(ostream& out){
}

ostream& operator<<(ostream& out, transport &ob) {
		ob.afisare(out);
		return out;
}
class metrou: virtual public transport{
public:
	metrou();
    metrou(const metrou&);
	~metrou();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, metrou&);
	friend ostream& operator<<(ostream&, metrou&);
};
metrou::metrou(){

}
metrou::metrou(const metrou& ob){
}
metrou::~metrou(){

};
void metrou::citire(istream& in){
}
istream& operator>>(istream& in, metrou &ob){
	ob.citire(in);
	return in;
}
void metrou::afisare(ostream& out){
}

ostream& operator<<(ostream& out, metrou &ob) {
		ob.afisare(out);
		return out;
}
class tramvai: virtual public transport{
public:
	tramvai();
    tramvai(const tramvai&);
	~tramvai();
	void citire(istream&);
	void afisare(ostream&);
	friend istream& operator>>(istream&, tramvai&);
	friend ostream& operator<<(ostream&, tramvai&);
};
tramvai::tramvai(){

}
tramvai::tramvai(const tramvai& ob){
}
tramvai::~tramvai(){

};
void tramvai::citire(istream& in){
}
istream& operator>>(istream& in, tramvai &ob){
	ob.citire(in);
	return in;
}
void tramvai::afisare(ostream& out){
}

ostream& operator<<(ostream& out, tramvai &ob) {
		ob.afisare(out);
		return out;
}
int main(){

    vector<card*> carduri;
    vector<bilet*> bilete;
    bilete.push_back(new bilet(1.3));
    bilete.push_back(new bilet(1.5));
    card* card_nou = new card(10, 0, bilete);
    carduri.push_back(card_nou);
    cout <<"Cardul nou adaugat:\n";
    cout << (*carduri[0]);
    aparat_validare* aparat = new aparat_validare(carduri);
    cout <<"Noul aparat de validare este:\n";
    cout << *aparat;
    carduri[0]->adaugare_bilet(bilete[0]);
    cout <<"-------------------\n";
    cout << (*carduri[0]);
    cout <<"-------------------\n";
    carduri[0]->valideaza_card();
    cout << (*carduri[0]);
    cout <<"-------------------\n";
    carduri[0]->set_min_start(12);
    cout << (*carduri[0]);
    cout <<"Au fost validate:";
    cout << aparat->get_bilete_validate();
    return 0;
}
