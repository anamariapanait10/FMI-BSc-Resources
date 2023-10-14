/*
Problema Cuplaj, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://www.infoarena.ro/job_detail/2962302

Complexitate timp: O(n*m)
Complexitate memorie: O(n*m)
*/

#include <fstream>
#include <algorithm>
#include <vector>
#include <queue>

using namespace std;

ifstream in("cuplaj.in");
ofstream out("cuplaj.out");

vector<int> tata, viz;
vector<vector<int>> ind;
//muchie, indice
struct muchie{
    int x, y, cap, indx;
};
vector<muchie> muchii;

int n, e, src, dest;

int bfs(){
    tata.clear();
    tata.resize(n);
    viz = vector<int>(n);
    queue<int> q;
    q.push(src);
    viz[src] = 1;

    while(!q.empty()){
        int nod = q.front();
        q.pop();
        if(nod == dest)
            continue;
        for(int i: ind[nod]){
            muchie m = muchii[i];
            if(!viz[m.y] and m.cap != 0){
                viz[m.y] = 1;
                tata[m.y] = i;
                q.push(m.y);
            }
        }
    }
    return viz[dest];
}

int cuplaj(){
    int cupl_max = 0;

    while(bfs()){
        for(auto i:ind[dest]){
            if(viz[muchii[i].y] and muchii[muchii[i].indx].cap != 0){

                int cup = 1<<13;
                muchie m = muchii[i];
                tata[dest] = m.indx;
                for(int nod = dest; nod != src; nod = muchii[tata[nod]].x)
                    cup = min(cup, muchii[tata[nod]].cap);

                for(int nod = dest; nod != src; nod = muchii[tata[nod]].x){
                    muchii[tata[nod]].cap -= cup;
                    muchii[muchii[tata[nod]].indx].cap += cup;

                }

                cupl_max += cup;
            }
        }
    }

    return cupl_max;
}
int main()
{
    int gr1, gr2;
    in >> gr1 >> gr2 >> e;
    n = gr1 + gr2 + 2;
    src = 0;
    dest = n - 1;
    tata.resize(n);
    ind.resize(n);
    viz.resize(n);

    for(int i = 1; i <= e; i++){
        int x, y;
        in >> x >> y;
        muchii.push_back({x, y + gr1, 1, 2 * i - 1});
        muchii.push_back({y + gr1, x, 0, 2 * i - 2});
        ind[y + gr1].push_back(2 * i - 1);
        ind[x].push_back(2 * i - 2);
    }


    int dim = muchii.size();
    for(int i = 1; i <= gr1; i++){
        dim += 2;
        muchii.push_back({src, i, 1, dim - 1});
        ind[i].push_back(dim - 1);
        muchii.push_back({i, src, 0, dim - 2});
        ind[src].push_back(dim - 2);
    }

    for(int i = gr1 + 1; i < n - 1; i++){
        dim += 2;
        muchii.push_back({i, dest, 1, dim - 1});
        ind[dest].push_back(dim - 1);
        muchii.push_back({dest, i, 0, dim - 2});
        ind[i].push_back(dim - 2);

    }

    out << cuplaj()<<"\n";


    for(auto i: muchii){
        if(i.cap == 0 and i.x != src and i.y != dest and i.x < i.y){
            out << i.x<<" "<< i.y - gr1<<'\n';
        }
    }

    return 0;
}
