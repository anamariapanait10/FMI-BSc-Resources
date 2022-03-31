#include <iostream>
#include <queue>

using namespace std;

// method 1

class Stack1 {
    queue<int> q1, q2;
    int curr_size;
public:
    Stack1(){
        curr_size = 0;
    }

    void push(int e){
        curr_size++;
        if(q1.empty())
            q1.push(e);
        else{
            while(!q1.empty()){
                q2.push(q1.front());
                q1.pop();
            }
            q1.push(e);
            while(!q2.empty()){
                q1.push(q2.front());
                q2.pop();
            }
        }
    }

    int pop(){
        if (q1.empty())
            return -1;
        int val = q1.front();
        q1.pop();
        curr_size--;
        return val;
    }
};

// method 2

class Stack2 {
    queue<int> q1, q2;
    int curr_size;

public:
    Stack2(){
        curr_size = 0;
    }

     void push(int e){
        q1.push(e);
        curr_size++;
    }

    int pop(){
        if (q1.empty())
            return -1;

        while (q1.size() != 1) {
            q2.push(q1.front());
            q1.pop();
        }

        while(!q2.empty()){
            q1.push(q2.front());
            q2.pop();
        }

        int val = q1.front();
        q1.pop();
        curr_size--;
        return val;
    }
};


int main(){
    Stack1 s;
    s.push(1);
    s.push(2);
    s.push(3);
    s.push(4);
    s.push(5);

    cout << s.pop() <<'\n'<< s.pop() <<'\n'<< s.pop() <<'\n';
    cout << s.pop() <<'\n'<< s.pop() <<'\n';

    Stack2 s2;
    s2.push(1);
    s2.push(2);
    s2.push(3);
    s2.push(4);
    s2.push(5);

    cout << s2.pop() <<'\n'<< s2.pop() <<'\n'<< s2.pop() <<'\n';
    cout << s2.pop() <<'\n'<< s2.pop() <<'\n';

    return 0;
}
