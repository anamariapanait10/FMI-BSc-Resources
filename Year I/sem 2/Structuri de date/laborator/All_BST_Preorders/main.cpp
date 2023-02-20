#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

vector<int> v;

bool verif_preorder(int left, int right){
    if(left >= right)
        return true;

    int res = 1, index = left + 1;
    while(index <= right && v[index] <= v[left])
        index++;

    while(index <= right && v[index] >= v[left])
        index++;
    if(index <= right)
        return false;

    if (verif_preorder(left + 1, index - 1) && verif_preorder(index, right))
        return true;
    return false;
}

void allBstPreorders(int N) {
    v = vector<int>(N);

    for(int i = 1; i <= N; i++)
        v[i - 1] = i;

    do {
        if(verif_preorder(0, N - 1)){
            for(int i = 0; i < N; i++)
                cout << v[i] <<' ';
            cout << '\n';
        }
    } while(next_permutation(v.begin(), v.end()));
}


int main()
{
    int N;
    cin >> N;
    allBstPreorders(N);
    return 0;
}
