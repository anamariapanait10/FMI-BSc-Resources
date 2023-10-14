/*
Problema Max Area Of Island, LeetCode
Link unde se poate vedea ca solutia a luat 100 de pct: https://leetcode.com/problems/max-area-of-island/submissions/837343200/


Idee:
    Parcurgem matricea si daca dam de o casuta ce reprezinta insula si e nevizitata atunci aplicam dfs pornind de
    la pozitia aia si incercam sa vizitam in cele 4 directii (si apoi recursiv pentru vecini). Numarul de casute
    vizitate reprezinta aria insulei. Daca casuta e apa sau e insula vizitata sau depaseste conturul se va returna
    aria 0.

Complexitate timp: O(r * c), unde r e numarul de randuri si c e numar de coloane
Complexitate spatiu: O(r * c), unde r e numarul de randuri si c e numar de coloane (utilizat de matricea visited)
*/


#include <iostream>
#include <vector>
#include <set>
using namespace std;

class Solution {
    int cols;
    int rows;
public:
    int dfs(int r, int c, vector<vector<int>>& grid, set<pair<int, int>>& visited){
        if(r < 0 || r == rows || c < 0 || c == cols || grid[r][c] == 0 || visited.find(make_pair(c, r)) != visited.end())
            return 0;
        visited.insert(make_pair(c, r));
        return 1 + dfs(r+1, c, grid, visited) + dfs(r-1, c, grid, visited) + dfs(r, c+1, grid, visited) + dfs(r, c-1, grid, visited);

    }
    int maxAreaOfIsland(vector<vector<int>>& grid) {
        cols = grid[0].size();
        rows = grid.size();
        set<pair<int, int>> visited;
        int max_area = 0;

        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                max_area = max(max_area, dfs(i, j, grid, visited));
            }
        }
        return max_area;
    }
};

int main()
{

    return 0;
}
