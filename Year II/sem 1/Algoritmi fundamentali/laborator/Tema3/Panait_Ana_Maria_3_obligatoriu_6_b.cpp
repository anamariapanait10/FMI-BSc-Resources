/*
Problema Longest Common Subsequence, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://leetcode.com/problems/shortest-common-supersequence/submissions/874032757/

Complexitate timp: O(n*m), unde n=strlen(s1) si m=strlen(s2)
*/

#include <iostream>

using namespace std;

class Solution {
public:
    string shortestCommonSupersequence(string s1, string s2) {
        int len1 = s1.size(), len2 = s2.size();
        int t[len1+1][len2+1];
        string res;
        // construim cel mai mare subsir comun
        for(int i = 0; i <= len1; i++){
            for(int j = 0; j <= len2; j++){
                if(i == 0 || j == 0)
                    t[i][j] = 0;
                else if(s1[i-1] == s2[j-1]){
                    t[i][j] = 1 + t[i-1][j-1];
                } else {
                    t[i][j] = max(t[i-1][j], t[i][j-1]);
                }
            }
        }

        // afisam subsirul comun
        int i = len1, j = len2;
        while(i > 0 && j > 0){
            if(s1[i-1] == s2[j-1]){
                res.push_back(s1[--i]);
                j--;
            } else {
                if(t[i-1][j] > t[i][j-1]){
                    res.push_back(s1[--i]);
                } else{
                    res.push_back(s2[--j]);
                }
            }
        }
        while(i > 0){ // daca au ramas caractere in s1
            res.push_back(s1[--i]);
        }
        while(j > 0){ // daca au ramas caractere in s2
            res.push_back(s2[--j]);

        }
        reverse(res.begin(),res.end());
        return res;
    }
};


int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
