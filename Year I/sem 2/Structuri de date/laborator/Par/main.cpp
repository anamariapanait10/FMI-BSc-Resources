#include <iostream>
#include <fstream>
#include <stack>

using namespace std;

ifstream in("par.in");
ofstream out("par.out");

stack<char> st;

int main()
{
    int n, sch = 0;
    char s[5001];
    in >> n;
    in.get();
    in.getline(s, 5001);

    if(n % 2 == 1){
        out << -1;
    } else {
        for(int i = 0; i < n; i++){
            if(s[i] == '('){
                st.push('(');
            } else {
                if(st.empty()){
                    sch++;
                    st.push('(');
                } else {
                    st.pop();
                }
            }
        }
        out << st.size() / 2 + sch;
    }

    return 0;
}
