#include <fstream>
#include <string.h>
#include <stack>

using namespace std;

ifstream in("alibaba.in");
ofstream out("alibaba.out");

stack <int> st;

int main()
{
    int n, k, copie;
    in >> n >> k;
    copie = k;
    char sir[10001], res[100001];
    in.get();
    in.getline(sir, 10001);

    for(int i = 0; i < n; i++){
        int val = sir[i] - '0';
        while(k > 0 && !st.empty() && val > st.top()){
                k--;
                st.pop();
        }
        st.push(val);
    }


    while(st.size() > n - copie){
        st.pop();
    }

    int i = n - copie - 1;
    while(!st.empty()){
       res[i--] = st.top() + '0';
       st.pop();
    }
    out << res;

    return 0;
}
