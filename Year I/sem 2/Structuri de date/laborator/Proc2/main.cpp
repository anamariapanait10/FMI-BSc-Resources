#include <fstream>
#include <queue>

using namespace std;

ifstream in("proc2.in");
ofstream out("proc2.out");

priority_queue <int> proc_disp;
priority_queue <pair<int, int>> proc_ocup;

int main()
{
    int n, m, s, d;
    in >> n >> m;
    for(int i = 1; i <= n; i++)
        proc_disp.push(-i);

    for(int i = 0; i < m; i++){
        in >> s >> d;
        if(!proc_ocup.empty()){
            while(!proc_ocup.empty() && -proc_ocup.top().first <= s){
                proc_disp.push(proc_ocup.top().second);
                proc_ocup.pop();
            }
        }
        out << proc_disp.top()*(-1) << "\n";
        proc_ocup.push({-s-d, proc_disp.top()});
        proc_disp.pop();
    }
}
