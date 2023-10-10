"""Date de intrare:

    dim_populatie (dimensiunea populatiei)
    a b (capetele domeniului de definitie)
    a b c (coeficientii polinomului de grad 2)
    precizie (precizia cu care se discretizeaza intervalul)
    prob_recombinare (probabilitatea de recombinare)
    prob_mutatie (probabilitate de mutatie)
    nr_etape (numarul de etape al algoritmului)

"""
import copy
import math
import numpy as np
import random


def random_bit():
    x = random.random()
    if x < 0.5:
        return "1"
    return "0"


def generate_chromosome(lungime_cromozom):
    return "".join([random_bit() for _ in range(lungime_cromozom)])


def get_random_population(lungime_cromozom):
    random.seed(10)
    return [generate_chromosome(lungime_cromozom) for _ in range(dim_populatie)]


def fitness_fct(x):
    a, b, c = coef_functie
    return a*x*x + b*x + c


def get_x(cromozom):
    x_b10 = int(cromozom)
    return (b - a) / (pow(2, lungime_cromozom)) * x_b10 + a


def get_fitness_values(populatie):
    return [fitness_fct(get_x(cromozom)) for cromozom in populatie]


def print_population(populatie, file):
    for i in range(dim_populatie):
        x = get_x(populatie[i])
        file.write(str(i+1) + ": ")
        file.write(populatie[i] + ", x= ")
        file.write("{: f}, ".format(x))
        file.write(str(fitness_fct(x)))
        file.write("\n")
    file.write("\n\n")


def get_prob_selectie(populatie):
    valori_fitness_cromozomi = get_fitness_values(populatie)
    F = sum(valori_fitness_cromozomi) # performanta totala a populatiei
    prob_selectie_populatie = []
    for f_x in valori_fitness_cromozomi:
        prob_selectie_populatie.append(f_x / F)

    return prob_selectie_populatie


def get_intervale_selectie(prob_selectie):
    intervale_selectie = []
    s = 0
    for p in prob_selectie:
        intervale_selectie.append(s)
        s += p
    intervale_selectie.append(1.0)

    return intervale_selectie


def gaseste_intervalul(u, st, dr):
    while st <= dr:
        m = (st + dr) // 2
        i1 = intervale_selectie[m]
        i2 = intervale_selectie[m+1]

        if i1 <= u <= i2:
            return m
        
        if u < i1:
            dr = m - 1
        else:
            st = m + 1

def metoda_ruletei(file):
    populatie_noua = []
    for _ in range(dim_populatie-1):
        u = np.random.uniform()
        j = gaseste_intervalul(u, 0, dim_populatie)
        populatie_noua.append(copy.deepcopy(populatie[j]))
        if iteratie == 0:
            file.write("u=" + str(u) + " selectam cromozomul " + str(j) + "\n")

    return populatie_noua


def get_fittest():
    max_val = fitness_fct(get_x(populatie[0]))
    max_val_idx = 0
    for i in range(1, dim_populatie):
        f_x = fitness_fct(get_x(populatie[i]))
        if f_x > max_val:
            max_val_idx = i
            max_val = f_x
    return copy.copy(populatie[max_val_idx])


def selectie_elitista():
    return [get_fittest()]


def get_crossover_candidates(iteratie, file):
    candidati = []
    for i in range(dim_populatie):
        u = np.random.uniform()
        print_str = f"{i+1}: {populatie[i]}, u={u}"
        if u < prob_recombinare:
            candidati.append(i)
            print_str += f"<{prob_recombinare} participa\n"
        if iteratie == 0:
            file.write(print_str)
    return candidati


def crossover(candidate_idxs, iteratie, f):
    rezultat_1 = ""
    rezultat_2 = ""
    while len(candidate_idxs) >= 2:
        sample = random.sample(candidate_idxs, 2)
        candidate_idxs.remove(sample[0])
        candidate_idxs.remove(sample[1])

        pct_rupere = random.randrange(0, lungime_cromozom)
        if iteratie == 0:
            f.write(f"Recombinare dintre cromozomul {sample[0] + 1} cu cromozomul {sample[1] + 1}:\n")
            f.write(f"{populatie_noua[sample[0]]} {populatie_noua[sample[1]]} punct {pct_rupere}\n")

        rezultat_1 = populatie_noua[sample[1]][:pct_rupere] + populatie_noua[sample[0]][pct_rupere:]
        rezultat_2 = populatie_noua[sample[0]][:pct_rupere] + populatie_noua[sample[1]][pct_rupere:]

        if iteratie == 0:
            f.write(f"Rezultat: {rezultat_1} {rezultat_2}\n\n")
        populatie_noua[sample[0]] = rezultat_1
        populatie_noua[sample[1]] = rezultat_2


def mutate(iteratie, file):
    if iteratie == 0:
        file.write(f"\nProbabilitatea de mutatie {prob_mutatie}:\nAu fost modificati cromozomii:\n")
    
    for i in range(dim_populatie - 1):
        u = np.random.uniform()
        if u < prob_mutatie:
            if iteratie == 0:
                file.write(f"{i + 1} ")
            poz = random.randrange(0, lungime_cromozom - 1)
            fliped_bit = str(1 - (populatie_noua[i][poz] - "0"))
            populatie_noua[i][poz] = populatie_noua[i][:poz] + fliped_bit +  populatie_noua[i][poz+1:]
    if iteratie == 0:
        file.write("\n")


def mean_fitness(populatie_noua):
    return sum([fitness_fct(get_x(x)) for x in populatie_noua]) / dim_populatie


if __name__ == '__main__':
    with open("Input.txt") as f:
        linii = f.readlines()

    dim_populatie = int(linii[0])
    a, b = tuple([int(x) for x in linii[1].split()])
    coef_functie = [int(x) for x in linii[2].split()]
    precizie = int(linii[3])
    prob_recombinare = float(linii[4])
    prob_mutatie = float(linii[5])
    nr_etape = int(linii[6])
    
    lungime_cromozom = math.floor(math.log((b - a) * math.pow(10, precizie), 2))
    populatie = get_random_population(lungime_cromozom)

    with open("Evolutie.txt", "w") as f:
        for iteratie in range(nr_etape):
            if iteratie == 0:
                f.write("Populatia initiala:\n")
                print_population(populatie, f)

            # Etapa de selectie
            prob_selectie_populatie = get_prob_selectie(populatie)
            if iteratie == 0:
                f.write("Probabilitati selectie:\n")
                for i in range(dim_populatie):
                    f.write("Cromozom " + format(i+1, "3") + " -> probabilitate: " + str(prob_selectie_populatie[i]) + "\n")
                f.write("\n\n")

            intervale_selectie = get_intervale_selectie(prob_selectie_populatie)
            if iteratie == 0:
                f.write("Intervale probabilitati selectie:\n")
                for i in intervale_selectie:
                    f.write(str(i) + " ")
                f.write("\n\n")

            populatie_noua = metoda_ruletei(f) + selectie_elitista()

            if iteratie == 0:
                f.write("\nDupa selectie:\n")
                print_population(populatie_noua, f)

            # Etapa de incrucisare
            crossover_candid_idxs = get_crossover_candidates(iteratie, f)

            f.write("\n")
            crossover(crossover_candid_idxs, iteratie, f)

            if iteratie == 0:
                f.write("\nDupa recombinare:\n")
                print_population(populatie_noua, f)

            # Etapa de mutatie
            mutate(iteratie, f)
            if iteratie == 0:
                f.write("Dupa mutatie:\n")
                print_population(populatie_noua, f)

            # Evolutia maximului
            if iteratie == 0:
                f.write("Evolutia maximului:\n")
            val_max = get_x(populatie_noua[get_fittest(populatie_noua)])
            f.write(f"{fitness_fct(val_max)}")
            f.write(f"{mean_fitness(populatie_noua)}")

            iteratie += 1
            populatie = copy.deepcopy(populatie_noua)
