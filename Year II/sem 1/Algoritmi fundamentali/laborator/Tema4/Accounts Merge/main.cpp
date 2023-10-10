class Solution {
    void DFS(string email,unordered_map<string,vector<string>>&adjList,vector<string>&temp,unordered_map<string,bool>&visited){
        visited[email] = true;
        temp.push_back(email);
        for(string& neighbour:adjList[email]){
            if(!visited[neighbour]){
                DFS(neighbour,adjList,temp,visited);
            }
        }
    }
public:
    vector<vector<string>> accountsMerge(vector<vector<string>>& accounts) {
        unordered_map<string,string>emailToName;
        unordered_map<string,vector<string>>adjList;
        for(vector<string>& account: accounts){
            string name = account[0];
            for(int i=1; i<account.size(); i++){
                adjList[account[i]].push_back(account[1]);
                adjList[account[1]].push_back(account[i]);
                emailToName[account[i]] = name;
            }
        }
        unordered_map<string,bool>visited;
        vector<vector<string>>res;
        for(auto& emails:adjList){
            string email = emails.first;
            if(!visited[email]){
                vector<string>temp;
                temp.push_back(emailToName[email]);
                DFS(email,adjList,temp,visited);
                sort(temp.begin()+1,temp.end());
                res.push_back(temp);
            }
        }
        return res;
    }
};


