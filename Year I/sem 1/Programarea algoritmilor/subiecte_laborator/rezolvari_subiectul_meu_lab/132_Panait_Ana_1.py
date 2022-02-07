"""
Panait Ana-Maria, grupa 132
Cerinta:Fișierul text numere.in conține, pe mai multe linii, numere naturale despărțite prin
spații. Definim indicele binar al unui număr natural n ca fiind perechea (x, y), unde x reprezintă
numărul biților nenuli din reprezentarea binară a lui n, iar y reprezintă numărul biților nuli din
reprezentarea sa binară. De exemplu, numărul 133 are reprezentarea binară 10000101, deci
indicele său binar este (3, 5). Să se scrie în fișierul text numere.out numerele din fișierul
numere.in grupate în funcție de indicii lor binari, conform modelului din exemplul de mai jos.
Grupele de numere vor fi scrise în ordinea descrescătoare a numărului de numere pe care le
conțin, iar în caz de egalitate se vor scrie în ordinea lexicografică a indicilor lor binari. În cadrul
fiecărei grupe numerele vor fi ordonate crescător. Fiecare număr va fi scris o singură dată în
fișierul de ieșire.
"""

try:
    f = open("numere.in")
    text = f.read()
    numere = set([int(elem) for elem in text.split()])
    dict = {}
    for elem in numere:
        binar = "{0:b}".format(elem)
        tuplu = (str(binar).count("1"), str(binar).count("0"))
        if tuplu in dict:
            dict[tuplu].append(elem)
        else:
            dict[tuplu] = [elem]

    for elem in dict:
        dict[elem] = sorted(dict[elem])
    dict = sorted(dict.items(), key=lambda x: (-len(x[1]), x[0]))
    for elem in dict:
        print(elem[0], ": ", ",".join(str(x) for x in elem[1]))
    f.close()
except FileNotFoundError:
    print("Fisierul nu exista!")