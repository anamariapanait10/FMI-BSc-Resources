"""
Panait Ana-Maria, grupa 132
Cerinta: a) [0,5p] Fișierul "date.in" conține n>1 linii cu următoarea structură: pe linia i se găsesc n
numere naturale nenule separate prin câte un spațiu. Să se scrie o funcție citire care să
citească datele din fișier și să returneze matricea de dimensiuni 𝑛 × 𝑛 care conține numerele
în ordinea din fișier.
b) [1,5p] Să se scrie o funcție modifica_matr care primește ca parametri o matrice pătratică
𝑛 × 𝑛 și un număr variabil de parametri 𝑥1, 𝑥2, . . . 𝑥𝑘 cu valori cuprinse între 0 și n-1,
reprezentând indicii unor linii/coloane. Funcția va modifica matricea primită ca parametru
astfel:
● adaugă o linie nouă la finalul matricei (după ultima linie existentă), în care fiecare element
de pe coloana j va fi egal cu:
➢ -1, dacă indicele j nu se află printre parametrii 𝑥1, 𝑥2, . . . 𝑥𝑘 primiți de funcție sau
➢ suma elementelor de pe coloana j aflate strict deasupra diagonalei principale, dacă
indicele j se află printre parametrii 𝑥1, 𝑥2, . . . 𝑥𝑘 primiți de funcție.
● apoi adaugă (la matricea obținută după adăugarea liniei) o coloană nouă la începutul
matricei (înainte de prima coloană existentă), în care fiecare element de pe linia 𝑖 va fi
egal cu:
➢ -1, dacă indicele i nu se află printre parametrii 𝑥1, 𝑥2, . . . 𝑥𝑘 primiți de funcție sau
➢ maximul dintre elementele de pe linia i aflate pe diagonala secundară sau sub ea, dacă
indicele i se află printre parametrii 𝑥1, 𝑥2, . . . 𝑥𝑘 primiți de funcție.
c) [1p] Să se apeleze funcția de la b) pentru matricea obținută la a) și indicii corespunzători
următoarelor linii/coloane: prima, a doua, ultima, una respectiv două din mijlocul matricei (în
funcție dacă n este impar respectiv par). Matricea obținută să se afișeze pe ecran, fără
paranteze și virgule, iar elementele de pe fiecare coloană să fie aliniate la dreapta ținând cont
că numerele pot avea maxim 4 caractere (inclusiv semnul ‘-’).
"""

def citire(nume_fis):
    try:
        f = open(nume_fis)
        lin = f.readline()
        mat = []
        while lin:
            mat += [[int(x) for x in lin.split()]]
            lin = f.readline()

        return mat
        f.close()
    except FileNotFoundError:
        print("Fisierul nu exista!")

def modifica_matr(mat, *param):
    n = len(mat)
    linie = [0 for x in range(n)]
    for elem in range(n):
        if elem in param:
            linie[elem] = sum([mat[x][elem] for x in range(elem)])
        else:
            linie[elem] = -1
    mat += [linie]
    n = len(mat)
    m = [[0 for x in range(n)] for y in range(n)]
    for i in range(n):
        for j in range(n-1, 0, -1):
            m[i][j] = mat[i][j-1]

    for ind in range(n):
        if ind in param:
            m[ind][0] = max([m[ind][x] for x in range(n-ind-1, n)])
        else:
            m[ind][0] = -1
    mat[:] = m


m = citire("date.in")
n = len(m)
if n % 2 == 0:
    modifica_matr(m, 0, 1, n-1, n//2-1, n//2)
else:
    modifica_matr(m, 0, 1, n - 1, n // 2)

n = len(m)
for i in range(n):
    for j in range(n):
        print(str(m[i][j]).rjust(4), end=" ")
    print()
