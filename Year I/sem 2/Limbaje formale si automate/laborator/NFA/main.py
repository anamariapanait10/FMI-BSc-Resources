f = open("input.txt", "r")
g = open("output.out", "w")

def fc(string):
    litere = [litera for litera in string]
    return litere[0]

def efc(string):
    litere = [litera for litera in string]
    litere.pop(0)
    return "".join(litere)

def DFS(word, nod, t) :
    global n, m, muchii, start_state, number_of_final_states, final_states, value, traseu
    t.append(nod)
    if nod in final_states and word == "" :
        value = True
        traseu = t[:]
    else:
        for element in muchii[nod] :
            if not value and fc(word) == element[1]:
                DFS(efc(word), element[0], t)
    t.pop()

[n, m] = f.readline().split()
n = int(n)
m = int(m)
value = False
muchii = {}
traseu = []
for i in range(m) :
    [istate, astate, letter] = f.readline().split();
    istate = int(istate)
    astate = int(astate)
    p = istate
    if istate not in muchii :
        muchii[istate] = [(astate, letter)]
    else :
        muchii[istate] += [(astate,letter)]


start_state = int(f.readline())
[number_of_final_states, *final_states] = f.readline().split()
final_states = [int(x) for x in final_states]
number_of_words = int(f.readline())
for i in range(number_of_words) :
    word = f.readline().strip()
    value = False
    t = []
    DFS(word, start_state, t)
    if not value:
        g.write("Nu\n")
    else :
        g.write("Da\nTraseu: ")
        for element in traseu:
            g.write(str(element) + " ")
        g.write("\n")
