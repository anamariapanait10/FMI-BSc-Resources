# Deterministic finite automaton (DFA)

### Task:
Write an algorithm that has as input a deterministic finite automaton (DFA)
and a list of strings. Display YES / NO for each word and an automatic route 
(at least for the first one), whether accepted or not.

### Remarks:
- If there are several possible routes, only the first one found will be displayed
- Input data contains on the first line n (number of nodes) and m (number of transitions). 
  The following lines describe the transitions in each machine. On the line m + 2 is the 
  initial state index. On the line m + 3 there is a number nf (number of final states) 
  followed by the indices of the respective final states, separated by space. Line m + 4 
  contains ni, the number of input strings, and on the next ni lines, the respective strings.
- Output data, for each string: contain YES, if the word is accepted and a possible route, 
  respectively NO, otherwise.


### Input data
```
Input
6 10 # number of states and transitions
0 1 a # transition from 0 to 1 with a
0 2 b
1 1 b
1 2 c
1 3 a
2 2 a
2 4 b
3 5 c
4 4 a
4 5 c
0 # initial state
1 5 # final states
4  # number of words to check
abbbac  # word1
baaaabac
abccc
ababaaa
```

## Implementation

For the implementation of the automaton was used a custom 
data structure to save the graph in memory consisting 
in a dictionary that has as a key the possible states 
and as values a dictionary that has as a key a letter and 
as a value the state that can be reached with that letter from 
the first dictionary key (possible transitions from that state).

### Example:

    transitions = {0: {'a': 1, 'b': 2}, 1: {'b': 1, 'c': 2, 'a': 3}, 2: {'a': 2, 'b': 4}, 3: {'c': 5}, 4: {'a': 4, 'c': 5}}