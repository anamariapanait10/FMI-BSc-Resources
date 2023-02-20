#include <fstream>
#include <set>

using namespace std;

ifstream in("zeap.in");
ofstream out("zeap.out");

#define mx 2147483647

set <int> zeap;
pair<int, pair<int, int>> dif_min;

void insereaza(int val){
    auto it = zeap.find(val);
    if (it == zeap.end()){
        zeap.insert(val);
        it = zeap.find(val);
        if(dif_min.first != mx){
            auto st = prev(it);
            if (it != zeap.begin() && val - *st < dif_min.first)
                dif_min = make_pair(val - *st, make_pair(val, *st));

            auto dr = next(it);
            if (dr != zeap.end() && *dr - val < dif_min.first)
                dif_min = make_pair(*dr - val, make_pair(*dr, val));
        }
    }
}

void sterge(int val){
    if(zeap.find(val) == zeap.end()){
        out<<"-1\n";
    } else {
        if (val == dif_min.second.first || val == dif_min.second.second)
            dif_min = make_pair(mx, make_pair(-1, -1));
        zeap.erase(val);
    }
}


void min_dif(){
    if(zeap.size() < 2)
        out << "-1\n";
    else {
        if (dif_min.first == mx){
            for (auto it = ++zeap.begin(); it != zeap.end(); it++){
                auto st = prev(it);
                if (*it - *st < dif_min.first)
                    dif_min = make_pair(*it - *st, make_pair(*it, *st));

            }
        }
        out << dif_min.first << '\n';
    }
}

void max_dif(){
    if (zeap.size() < 2)
        out << "-1\n";
    else
        out <<*(--zeap.end()) - *(zeap.begin())<<'\n';
}


int main()
{
    string operatie;
    dif_min = make_pair(mx, make_pair(-1, -1));
    while(in >> operatie){
        if(operatie == "I"){
            int val;
            in >> val;
            insereaza(val);
        } else if(operatie == "S"){
            int val;
            in >> val;
            sterge(val);
        } else if(operatie == "C"){
            int val;
            in >> val;
            if(zeap.find(val) != zeap.end())
                out << "1\n";
            else
                out << "0\n";
        } else if(operatie == "MAX"){
            max_dif();
        } else if(operatie == "MIN")
            min_dif();
    }

    return 0;
}
