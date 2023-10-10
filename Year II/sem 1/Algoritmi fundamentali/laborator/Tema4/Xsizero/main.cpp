#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

ifstream in("xsizero.in");
ofstream out("xsizero.out");


int cost[100000], puteri_trei[11];
char mat[4][4], sursa[4][4];
vector<bool> vizitat(100000);

bool final_joc() {
    if ((mat[0][0] == 'X' && mat[1][1] == 'X' && mat[2][2] == 'X') ||
        (mat[2][0] == 'X' && mat[1][1] == 'X' && mat[0][2] == 'X') ||
        (mat[0][0] == '0' && mat[1][1] == '0' && mat[2][2] == '0') ||
        (mat[2][0] == '0' && mat[1][1] == '0' && mat[0][2] == '0')) {
        return true;
    }

    for (int i = 0; i < 3; i++) {
        if ((mat[i][0] == 'X' && mat[i][1] == 'X' && mat[i][2] == 'X') ||
            (mat[0][i] == 'X' && mat[1][i] == 'X' && mat[2][i] == 'X') ||
            (mat[i][0] == '0' && mat[i][1] == '0' && mat[i][2] == '0') ||
            (mat[0][i] == '0' && mat[1][i] == '0' && mat[2][i] == '0')) {
            return true;
        }
    }
    return false;
}

void bkt(int mov, int conf) {
    vizitat[conf] = true;

    if (mov % 2) // Cazul in care X pierde
        cost[conf] = 1;
    else // Cazul in care X castiga
        cost[conf] = 3;
    if (final_joc())
        return;

    if (mov == 10) { // Egalitate
        cost[conf] = 2;
        return;
    }

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (!mat[i][j]) {
                if (mov % 2) {
                    mat[i][j] = 'X';
                    int newconf = conf + puteri_trei[3 * i + j];
                    if (!vizitat[newconf])
                        bkt(mov + 1, newconf);
                    cost[conf] = max(cost[conf], cost[newconf]);
                    mat[i][j] = 0;
                } else {
                    mat[i][j] = '0';
                    int newconf = conf + 2 * puteri_trei[3 * i + j];
                    if (!vizitat[newconf])
                        bkt(mov + 1, newconf);
                    cost[conf] = min(cost[conf], cost[newconf]);
                    mat[i][j] = 0;
                }
            }
        }
    }
}

int main() {
    puteri_trei[0] = 1;
    for (int i = 1; i <= 10; i++) {
        puteri_trei[i] = puteri_trei[i - 1] * 3;
    }
    bkt(1, 0);

    int nr_test = 0;
    while (in >> sursa[0] >> sursa[1] >> sursa[2]) {
        int conf = 0;
        nr_test++;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (sursa[i][j] == 'X')
                    conf += puteri_trei[3 * i + j];
                else if (sursa[i][j] == '0')
                    conf += 2 * puteri_trei[3 * i + j];
            }
        }

        out << "Testul #" << nr_test << ": ";
        if (cost[conf] == 3)
            out << "win";
        else if (cost[conf] == 2)
            out << "draw";
        else if (cost[conf] == 1)
            out << "lose";
        else
            out << "invalid";
        out << '\n';
    }
    return 0;
}
