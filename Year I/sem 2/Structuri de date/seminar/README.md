# Stack implementation using two queues

### Task of the homework:

Explain how to implement a stack with two queues 
(complexity of push and pop operations) / optional implementation.


## Stack 

In a stack the elements are added in `LIFO` (Last In, First Out) order.
This means that the last element inserted in the stack will be the 
first one removed. The basic operations of a stack are:

- `push` — insert an element at the top
- `pop` — remove an element from the top

## Queue

In a queue the elements are added in FIFO (First In, First Out) order.
This meand that the first element inserted is the first one to be removed. 
The basic operations of the queue are:

- enqueue — insert an element at the rear
- dequeue — remove an element from the front

![image](link)

## Algorithm 

Let stack to be implemented be `s` and queues used to 
implement be `q1` and `q2`. Stack `s` can be implemented in two ways:

## Method #1 (By making push operation costly) 

To construct a stack using two queues q1 and q2, we need to simulate the stack operations by using queue operations:

- push (element e)
	- if q1 is empty, enqueue e to q1
	- if q1 is not empty, enqueue all elements from q1 to q2, then enqueue e to q1, and enqueue all elements from q2 back to q1
- pop
	- dequeue an element from q1 and return it

As we see, q1 acts as the main source for the stack, while q2 is just a helper queue that we use to preserve 
the order expected by the stack.

### Complexity 

The time complexity of the `pop` operation is `O(1)`. For the `push` operation, 
we have a time complexity of `O(n)` because we have to transfer n-1 elements 
from q1 to q2 and back from q2 to q1.

### Implementation

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

## Method #2 (By making pop operation costly) 

To construct a stack using two queues q1 and q2, we need to simulate the stack operations by using queue operations:

- push(element e)
	- enqueued e to q1
- pop()
	- enqueue all elements except the last from q1 to q2 and then enqueue all elements from q2 back to q1
	- dequeue an element from q1 and return it

### Complexity 

The time complexity of the `push` operation is `O(1)`. For the `pop` operation, 
we have a time complexity of `O(n)` because we have to transfer n-1 elements 
from q1 to q2 and back from q2 to q1.


### Implementation

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


