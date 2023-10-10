import copy
from queue import PriorityQueue


class NodParcurgere:
    def __init__(self, info, parinte=None, g=0, h=0):
        self.info = info
        self.parinte = parinte
        self.g = g
        self.h = h
        self.f = g + h

    def drumRadacina(self):
        l = []
        nod = self
        while nod:
            l.insert(0, nod)
            nod = nod.parinte
        return l

    def vizitat(self):
        nodDrum = self.parinte
        while nodDrum:
            if self.info == nodDrum.info:
                return True
            nodDrum = nodDrum.parinte

        return False

    def __str__(self):
        return str(self.info)

    def __repr__(self):
        sir = str(self.info) + "("
        drum = self.drumRadacina()
        sir += ("->").join([str(n.info) for n in drum])
        sir += ")"
        return sir

    def __eq__(self, other):
        return self.f == other.f and self.g == other.g

    def __lt__(self, other):
        return self.f < other.f or (self.f == other.f and self.g > other.g)


class Graph:

    def __init__(self, start, scopuri):
        self.start = start
        self.scopuri = scopuri

    def succesori(self, nod):
        succ = []
        gasit = False
        x_zero = None
        y_zero = None
        for x_zero in range(len(self.start)):
            for y_zero in range(len(self.start)):
                if nod.info[x_zero][y_zero] == 0:
                   gasit = True
                   break
            if gasit:
                break

        dir = {"stanga": [-1, 0], "sus": [0, -1], "dreapta": [1, 0], "jos": [0, 1]}
        for d in dir.values():
            x = x_zero + d[0]
            y = y_zero + d[1]
            if 0 <= x < 3 and 0 <= y < 3:
                aux = copy.deepcopy(nod.info)
                aux[x_zero][y_zero] = aux[x][y]
                aux[x][y] = 0
                nod_nou = NodParcurgere(aux, nod,  nod.g + 1, self.estimeaza_h(aux))
                if not nod_nou.vizitat():
                   succ.append(nod_nou)
        return succ

    def scop(self, nod):
        return nod in self.scopuri

    def estimeaza_h(self, nod):
        return 0

    def valideaza(self):
        # dc s-a citit o matrice corecta
        if len(self.start) != 3:
            return False
        for linie in self.start:
            if len(linie) != 3:
                return False

        # dc nr din mat sunt de la 0 la 8
        for i in range(9):
            gasit = False
            for linie in self.start:
                if i in linie:
                    gasit = True
                    break
            if not gasit:
                return False

        # dc din starea initiala se poate ajunge intr-o stare scop
        nr_inversiuni = 0
        lista = []
        for linie in self.start:
            lista.extend(linie)

        for i in range(len(lista)):
            if lista[i] != 0:
                for j in range(i+1, len(lista)):
                    if lista[j] != 0 and lista[i] > lista[j]:
                        nr_inversiuni += 1

        if nr_inversiuni % 2 == 1:
            return False
        return True

##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

with open("input.txt") as f:
    start = [[int(x) for x in l.strip().split()] for l in f.readlines()]

scopuri = [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
gr = Graph(start, scopuri)


def cautare_binara(coada, st, dr, nod):
    if len(coada) > 0:
        if st == dr:
            if nod.f < coada[st].f:
                return st
            elif nod.f > coada[st].f:
                return st + 1
            elif nod.g < coada[st].g:
                return st + 1
            else:
                return st
        else:
            m = (st + dr) // 2
            if nod.f < coada[m].f:
                return cautare_binara(coada, st, m, nod)
            elif nod.f > coada[m].f:
                return cautare_binara(coada, m + 1, dr, nod)
            elif nod.g < coada[m].g:
                return cautare_binara(coada, m + 1, dr, nod)
            else:
                return cautare_binara(coada, st, m, nod)
    return 0


def aStarSolMultiple(gr, nrSolutiiCautate=1):
    c = [NodParcurgere(gr.start)]

    while len(c) > 0:
        nodCurent = c.pop(0)

        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("Cost total: ", nodCurent.f)
            print("\n----------------\n")

            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        for s in gr.succesori(nodCurent):
            poz = cautare_binara(c, 0, len(c) - 1, s)
            if poz == len(c):
                c.append(s)
            else:
                c.insert(poz, s)


def aStarSolMultiplePQ(gr, nrSolutiiCautate=1):
    c = PriorityQueue()
    c.put(NodParcurgere(gr.start))
    while not c.empty():
        nodCurent = c.get()

        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("Cost total: ", nodCurent.f)
            print("\n----------------\n")

            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        for s in gr.succesori(nodCurent):
            c.put(s)


def a_star(gr):
    open = [NodParcurgere(info=gr.start, h=gr.estimeaza_h(gr.start))]
    closed = []
    while len(open) > 0:
        print("Coada: " + str(open))
        nod_curent = open.pop(0)
        closed.append(nod_curent)
        if gr.scop(nod_curent.info):
            print("Solutie: ")
            drum = nod_curent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("cost:", nod_curent.g)
            return

        succ = gr.succesori(nod_curent)
        for s in succ:
            gasit = False
            for nod in open:
                if s.info == nod.info:
                    gasit = True
                    if s.f >= nod.f:
                        succ.remove(s)
                    else:
                        open.remove(nod)
                    break
            if not gasit:
                for nod in closed:
                    if s.info == nod.info:
                        if s.f >= nod.f:
                            succ.remove(s)
                        else:
                            closed.remove(nod)
                        break
    for s in succ:
        ind = cautare_binara(open, 0, len(open)-1, s)
        if ind == len(open):
            open.append(s)
        else:
            open.insert(ind, s)


# a_star(gr)


#### algoritm BF
# presupunem ca vrem mai multe solutii (un numar fix) prin urmare vom folosi o variabilă numită nrSolutiiCautate
# daca vrem doar o solutie, renuntam la variabila nrSolutiiCautate
# si doar oprim algoritmul la afisarea primei solutii

def breadth_first(gr, nrSolutiiCautate=1):
   # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
   c = [NodParcurgere(gr.start)]

   while len(c) > 0:
       #print("Coada actuala: " + str(c))
       #input()
       nodCurent = c.pop(0)

       if gr.scop(nodCurent.info):
           print("Solutie:")
           drum = nodCurent.drumRadacina()
           print(("->").join([str(n.info) for n in drum]))
           print("\n----------------\n")
           #input()
           nrSolutiiCautate -= 1
           if nrSolutiiCautate == 0:
               return
       c+=gr.succesori(nodCurent)


def depth_first(gr, nrSolutiiCautate=1):
   # vom simula o stiva prin relatia de parinte a nodului curent
   df(NodParcurgere(gr.start), nrSolutiiCautate)


def df(nodCurent, nrSolutiiCautate):
   if nrSolutiiCautate <= 0:  # testul acesta s-ar valida doar daca in apelul initial avem df(start,if nrSolutiiCautate=0)
       return nrSolutiiCautate
   #print("Stiva actuala: " + repr(nodCurent.drumRadacina()))
   #input()
   if gr.scop(nodCurent.info):
       print("Solutie: ", end="")
       drum = nodCurent.drumRadacina()
       print(("->").join([str(n.info) for n in drum]))
       print("\n----------------\n")
       #input()
       nrSolutiiCautate -= 1
       if nrSolutiiCautate == 0:
           return nrSolutiiCautate
   lSuccesori = gr.succesori(nodCurent)
   for sc in lSuccesori:
       if nrSolutiiCautate != 0:
           nrSolutiiCautate = df(sc, nrSolutiiCautate)

   return nrSolutiiCautate


# df(a)->df(b)->df(c)->df(f)
#############################################


def df_nerecursiv(nrSolutiiCautate):
   stiva = [NodParcurgere(gr.start)]
   #consider varful stivei in dreapta
   while stiva: #cat timp stiva nevida
       nodCurent=stiva.pop() #sterg varful
       if gr.scop(nodCurent.info):
           print("Solutie:")
           drum = nodCurent.drumRadacina()
           print(("->").join([str(n.info) for n in drum]))
           print("\n----------------\n")
           #input()
           nrSolutiiCautate -= 1
           if nrSolutiiCautate == 0:
               return
       stiva+=gr.succesori(nodCurent)[::-1] #adaug in varf succesoii in ordine inversa deoarece vreau sa expandez primul succesor generat si trebuie sa il pun in varf

"""
Mai jos puteti comenta si decomenta apelurile catre algoritmi. Pentru moment e apelat doar breadth-first
"""

print("====================================================== \nBreadthfirst")
breadth_first(gr, nrSolutiiCautate=1)
# print("====================================================== \nDepthFirst recursiv")
# depth_first(gr, nrSolutiiCautate=1)
# print("====================================================== \nDepthFirst nerecursiv")
# df_nerecursiv(nrSolutiiCautate=4)


