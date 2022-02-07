"""
Panait Ana-Maria, grupa 132
Cerinta: Se consideră o rețea în plan formată din puncte unite prin arce. Fiecare punct are coordonatele
întregi, iar un arc are asociată o grosime (număr natural) și o culoare (un șir de caractere fără
spații reprezentând numele culorii, de exemplu: roșu, verde, albastru). Un punct cu coordonatele
x și y va fi notat (x,y). Se consideră fișierul text arce.in care conține informații despre o astfel de
rețea, fiecare linie conținând informații despre un arc sub forma:
(x1,y1)-(x2,y2) grosime culoare
unde (x1,y1) este punctul din care începe arcul, (x2,y2) este punctul în care se termină arcul,
grosime reprezintă grosimea arcului, iar culoare colorarea sa. Acest arc se va numi arc între
punctele (x1,y1) și (x2,y2), vom numi (x1,y1) capătul inițial al arcului și (x2,y2) capătul final al
arcului. Un exemplu de fișier de acest tip este următorul:
a) [2 p.] Să se memoreze datele din fișier într-o singură structură astfel încât să se răspundă
eficient la cerințele de la punctele următoare.
b) [1 p.] Scrieți o funcție modifica_arc care primește 5 parametri:
● în primul parametru se transmite structura în care s-au memorat datele la cerința a)
● următorii 2 parametri p1 și p2 sunt două tupluri cu două elemente reprezentând capătul
inițial și final al unui arc
● ultimii 2 parametri sunt un număr natural reprezentând grosimea arcului și un șir de
caractere reprezentând culoarea arcului.
Dacă arcul există deja în rețea funcția va modifica informațiile asociate arcului (grosimea și
culoarea), altfel funcția va adăuga acest arc la rețea (modificând structura trimisă ca
parametru). Funcția va returna numărul de arce care au capătul inițial în p1. Să se apeleze
funcția pentru a adăuga la rețea arcul de la (5,6) la (7,8) de grosime 5 si culoare verde.
c) [1 p.] Scrieți o funcție sterge_punct care primește 2 parametri: în primul parametru se
transmite structura în care s-au memorat datele la cerința a), iar al doilea parametru este un
tuplu cu 2 elemente reprezentând un punct din rețea. Funcția va șterge din rețea punctul
primit ca parametru (se vor șterge toate arcele care au acel punct ca și capăt inițial sau capăt
final) și va returna mulțimea arcelor din rețea. Să se apeleze funcția pentru a șterge punctul
(1,2) și să se afișeze rezultatul returnat. După ștergere se vor afișa datele memorate în
structură în același format în care s-au dat și datele în fișier (nu contează ordinea în care se
vor afișa arcele).
"""

def citeste_fisier():
    try:
        f = open('arce.in')
        linii = f.readlines()
        structura = dict()
        for l in linii:
            tokens = l.split(' ')
            capete = tokens[0].split('-')

            x, y = capete[0].split(',')
            x = x[1:]
            y = y[:len(y)-1]
            inceput = (int(x), int(y))

            x, y = capete[1].split(',')
            x = x[1:]
            y = y[:len(y) - 1]
            sfarsit = (int(x), int(y))

            grosime = int(tokens[1])
            culoare = tokens[2].rstrip()

            if inceput not in structura:
                structura[inceput] = [[sfarsit, grosime, culoare]]
            else:
                structura[inceput].append([sfarsit, grosime, culoare])

        f.close()
        return structura
    except FileNotFoundError:
        print("Fisierul nu exista!")

    return None


def afiseaza_structura(structura):
    for inc in structura:
        for date in structura[inc]:
            print(f'({inc[0]},{inc[1]})-({date[0][0]},{date[0][1]}) {date[1]} {date[2]}')


def modifica_arc(structura, p1, p2, grosime, culoare):
    if p1 in structura:
        gasit = False
        for elem in structura[p1]:
            if p2 in elem:
                elem[1] = grosime
                elem[2] = culoare
                gasit = True
        if not gasit:
            structura[p1].append([p2, grosime, culoare])
    else:
        structura[p1] = [[p2, grosime, culoare]]

    return len(structura[p1])


def sterge_punct(structura, punct):
    if punct in structura:
        structura.pop(punct)
    for inc in structura:
        for date in structura[inc]:
            if punct in date:
                structura[inc].remove(date)

    return structura


arce = citeste_fisier()
ret = modifica_arc(arce, (5, 6), (7, 8), 5, 'verde')
arce = sterge_punct(arce, (1, 2))
afiseaza_structura(arce)