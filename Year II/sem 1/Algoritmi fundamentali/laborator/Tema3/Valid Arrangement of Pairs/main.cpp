#include <iostream>

using namespace std;

class Solution {
public:
    vector<vector<int>> validArrangement(vector<vector<int>>& pairs) {
        vector<vector<int>> rezultat;
        unsigned int nr_perechi = pairs.size();
        unordered_map<int, stack<int>> adiacenta;
        unordered_map<int, int> input;
        unordered_map<int, int> output;

        adiacenta.reserve(nr_perechi);
        input.reserve(nr_perechi);
        output.reserve(nr_perechi);

        for (int i = 0; i < nr_perechi; i++) {
            int u = pairs[i][0], v = pairs[i][1];
            input[v]++;
            output[u]++;
            adiacenta[u].push(v);
        }
        int inceput = -1;
        for (auto& p : adiacenta) {
            int i = p.first;
            if (output[i] - input[i] == 1) inceput = i;
        }
        if (inceput == -1) {
            inceput = adiacenta.begin()->first;
        }
        parcurgere_euler(adiacenta, rezultat, inceput);
        reverse(rezultat.begin(), rezultat.end());
        return rezultat;
    }
private:
    void parcurgere_euler(unordered_map<int, stack<int>>& adiacenta, vector<vector<int>>& raspuns, int indice_curent) {
        auto& stiva = adiacenta[indice_curent];
        while (!stiva.empty()) {
            int nei = stiva.top();
            stiva.pop();
            parcurgere_euler(adiacenta, raspuns, nei);
            raspuns.push_back({indice_curent, nei});
        }
    }
};

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
