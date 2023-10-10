import copy
import time
from queue import PriorityQueue

class NodParcurgere:
    def __init__(self, info, g=0, h=0, parinte=None):
        self.info = info  # eticheta nodului, de exemplu: 0,1,2...
        self.parinte = parinte  # parintele din arborele de parcurgere
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

    def vizitat(self):  # verifică dacă nodul a fost vizitat (informatia lui e in propriul istoric)
        nodDrum = self.parinte
        while nodDrum:
            if (self.info == nodDrum.info):
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


class Graph:  # graful problemei
    def __init__(self, start, scopuri, estimari_h):
        self.start = start  # informatia nodului de start
        self.scopuri = scopuri  # lista cu informatiile nodurilor scop
        self.estimari_h = estimari_h

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def succesori(self, nodCurent):
        listaSuccesori = []
        for i, stiva in enumerate(nodCurent.info):
            if not stiva:
                continue
            copieStiva = copy.deepcopy(nodCurent.info)
            bloc = copieStiva[i].pop()
            for j, stiva2 in enumerate(copieStiva):
                if i == j:
                    continue
                stareNoua = copy.deepcopy(copieStiva)
                stareNoua[j].append(bloc)
                nodNou = NodParcurgere(stareNoua, nodCurent.g+1, self.estimeaza_h(stareNoua), nodCurent)
                if not nodNou.vizitat():
                    listaSuccesori.append(nodNou)
        return listaSuccesori

    def estimeaza_h(self, nod):
        return self.estimari_h
    def scop(self, infoNod):
        return infoNod in self.scopuri

    def valideaza(self):
        nr_stive = len(self.start)
        cond1 = all([nr_stive == len(scop) for scop in self.scopuri])
        blocuriStart = sorted(sum(self.start, start=[]))
        cond2 = all([blocuriStart == sorted(sum(scop, start=[])) for scop in self.scopuri])
        return cond1 and cond2

##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

def calculeazaStiva(sirStiva):
    return [s.strip().split() if s.strip() != "#" else [] for s in sirStiva.strip().split('\n')]


with open("input.txt") as f:
    sirStart, sirScopuri = f.read().split("=========")

start = calculeazaStiva(sirStart)
scopuri = [calculeazaStiva(scop) for scop in sirScopuri.split('---')]
estimari_h = 0
gr = Graph(start, scopuri, estimari_h)

if not gr.valideaza():
    exit(-1)


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
    open = [NodParcurgere(gr.start)]
    closed = []
    while len(open) > 0:
        print("Coada: " + str(open))
        nod_curent = open.pop(0)
        closed.append(nod_curent)
        if gr.scop(nod_curent.info):
            print("Solutie:")
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
                    else:  # s.f<nod.f
                        open.remove(nod)
                    break
            if not gasit:
                for nod in closed:
                    if s.info == nod.info:
                        if s.f >= nod.f:
                            succ.remove(s)
                        else:  # s.f<nod.f
                            closed.remove(nod)
                        break
        for s in gr.succesori(nod_curent):
            indice = cautare_binara(open, s, 0, len(open) - 1)
            if indice == len(open):
                open.append(s)
            else:
                open.insert(indice, s)


# aStarSolMultiple(gr, nrSolutiiCautate=6)
a_star(gr)


#### algoritm BF
# presupunem ca vrem mai multe solutii (un numar fix) prin urmare vom folosi o variabilă numită nrSolutiiCautate
# daca vrem doar o solutie, renuntam la variabila nrSolutiiCautate
# si doar oprim algoritmul la afisarea primei solutii

def breadth_first(gr, nrSolutiiCautate=1):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start)]

    while len(c) > 0:
        # print("Coada actuala: " + str(c))
        # input()
        nodCurent = c.pop(0)

        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("\n----------------\n")
            # input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        c += gr.succesori(nodCurent)


def depth_first(gr, nrSolutiiCautate=1):
    # vom simula o stiva prin relatia de parinte a nodului curent
    df(NodParcurgere(gr.start), nrSolutiiCautate)


def df(nodCurent, nrSolutiiCautate):
    if nrSolutiiCautate <= 0:  # testul acesta s-ar valida doar daca in apelul initial avem df(start,if nrSolutiiCautate=0)
        return nrSolutiiCautate
    # print("Stiva actuala: " + repr(nodCurent.drumRadacina()))
    # input()
    if gr.scop(nodCurent.info):
        print("Solutie: ", end="")
        drum = nodCurent.drumRadacina()
        print(("->").join([str(n.info) for n in drum]))
        print("\n----------------\n")
        # input()
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
    # consider varful stivei in dreapta
    while stiva:  # cat timp stiva nevida
        nodCurent = stiva.pop()  # sterg varful
        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("\n----------------\n")
            # input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        stiva += gr.succesori(nodCurent)[::-1]


"""
Mai jos puteti comenta si decomenta apelurile catre algoritmi. Pentru moment e apelat doar breadth-first
"""
#
# print("====================================================== \nBreadthfirst")
# breadth_first(gr, nrSolutiiCautate=4)
# print("====================================================== \nDepthFirst recursiv")
# depth_first(gr, nrSolutiiCautate=4)
# print("====================================================== \nDepthFirst nerecursiv")
# df_nerecursiv(nrSolutiiCautate=4)
