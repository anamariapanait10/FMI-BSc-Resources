/*
Problema Longest Common Subsequence, Infoarena
Link unde se poate vedea ca a luat 100 de pct: https://leetcode.com/problems/longest-common-subsequence/submissions/874017869/

Complexitate timp: O(n^2)
Complexitate memorie: O(n*m), unde n=strlen(text1) si m=strlen(text2)
*/

#include <iostream>
#include <vector>

using namespace std;


class Solution {
public:
   int longestCommonSubsequence(string text1, string text2){
        int len1 = text1.size(), len2 = text2.size();
        vector<vector<int>> dp(len1 + 1, vector<int>(len2 + 1, -1));

        for (int i = 0; i <= len1; i++)
            dp[i][0] = 0;
        for (int i = 0; i <= len2; i++)
            dp[0][i] = 0;

        for (int i = 1; i <= len1; i++){
            for (int j = 1; j <= len2; j++){
                if (text1[i - 1] == text2[j - 1]){
                    dp[i][j] = 1 + dp[i - 1][j - 1];
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }

        return dp[len1][len2];
    }
};


int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
