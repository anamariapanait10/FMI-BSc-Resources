#include <fstream>
#include <deque>

using namespace std;

ifstream in("vila2.in");
ofstream out("vila2.out");

int v[100000];
deque<int> deq_min, deq_max;

int main()
{
    int n, k, dif_max = 0;
    in >> n >> k;
    for(int i = 0; i < n; i++)
        in >> v[i];

    for(int i = 0; i < n; i++){

        while(!deq_min.empty() && v[i] <= v[deq_min.front()]){
            deq_min.pop_front();
        }
        deq_min.push_front(i);

        while(!deq_max.empty() && v[i] >= v[deq_max.front()]){
            deq_max.pop_front();
        }
        deq_max.push_front(i);

        if(i >= k){
            if(i - k > deq_min.back())
                deq_min.pop_back();
            if(i - k > deq_max.back())
                deq_max.pop_back();
            if(v[deq_max.back()] - v[deq_min.back()] > dif_max)
                dif_max = v[deq_max.back()] - v[deq_min.back()];
        }
    }

    out << dif_max;
    return 0;
}


