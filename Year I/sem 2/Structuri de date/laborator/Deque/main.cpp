
#include <fstream>

using namespace std;

ifstream in("deque.in");
ofstream out("deque.out");

int v[5000001], deq[5000001];

int main()
{
    int n, k, front = 0, back = 0;
    in >> n >> k;
    for(int i = 0; i < n; i++){
        in >> v[i];
    }

    long long S = 0;
    for(int i = 0; i <= k - 2; i++){
        while(front <= back && v[deq[back]] >= v[i])
            back--;
        deq[++back] = i;
    }
    for(int i = k - 1; i < n; i++){
        if(i - k == deq[front]){
            front++;
        }
        while(front <= back && v[i] <= v[deq[back]])
            back--;
        deq[++back] = i;
        S += v[deq[front]];
    }
    out << S;
    return 0;
}

