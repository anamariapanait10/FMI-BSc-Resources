#include <iostream>
#include <fstream>
#include <string.h>
#include <stack>

using namespace std;
ifstream in("alibaba.in");
ofstream out("alibaba.out");

deque <int> st;
int n, k, x;
string s;

int main()
{
    in>>n>>k>>s;

    for(int i=0; i<n; i++)
    {
        int x=s[i]-'0';
        if(st.empty() || x<=st.back())
        {
            st.push_back(x);
        }
        else
        {
            while(st.size() > 0 && x>st.back() && k>0)
            {
                k--;
                st.pop_back();
            }
            st.push_back(x);
        }
    }

    while(k>0)
    {
        st.pop_back();
        k--;
    }


    while(!st.empty())
    {
       out<<st.front();
       st.pop_front();
    }


    return 0;
}
