#include <iostream>
#include <fstream>
#include <stack>

using namespace std;

ifstream in("paranteze.in");
ofstream out("paranteze.out");

stack<pair<char, int>> st;

int main()
{
    int n, lung_max = 0;
    in >> n;
    char sir[1000001];
    in >> sir;

    for (int i = 0; i < n; i++){

        if(sir[i] == ')' && !st.empty() && st.top().first == '(')
            st.pop();
        else if(sir[i] == ']' && !st.empty() && st.top().first == '[')
            st.pop();
        else if(sir[i] == '}' && !st.empty() && st.top().first == '{')
            st.pop();
        else
            st.push({sir[i], i});

        if(!st.empty() && i - st.top().second > lung_max)
            lung_max = i - st.top().second;
    }
    out << lung_max;
    return 0;
}
