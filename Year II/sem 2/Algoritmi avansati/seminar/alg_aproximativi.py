
"""
Formez sume partiale intr-o matrice dp[k][n] unde:
i = la primele cate elemente ma uit
j = suma partiala maxima pe care vreau sa o obtin (cu primele i elemente, vreau sa obtin suma maxima <= j)

La pasul dp[i][j] ma decid daca adaug obiectul s[i-1] sumei partiale curente sau nu
- daca nu-l adaug, dp[i][j] - dp[i-1][j] (suma maxima <= j fara elem i)
- daca il adaug (si nu depasesc j) dp[i][j] = dp[i-1][j-s[i-1]] + s[i-1]
(elementul s[i-1] + suma maxima care mai incape pe langa el 
(din sumele fara i, aleg suma partiala maxima <= j-s[i-1], de exemplu pt j=7 si
s[i-1]=3, daca aleg sa il iau pe 3, suma maxima va fi 3 + suma maxima pe care o pot 
obtine fara elementul 3 si cu valoarea maxima <=4)

Complexitate: O(n*k) timp, pseudopolinomiala pt ca depinde de K, spatiu se poate reduce la O(2*k) daca retin doar ultimele 2 randuri pt ca doar de alea ma folosesc.

dp[i][j] = luand in considerarea primele i obiecte putem obtine o valoare maxima de greutate maxim j
"""
n = int(input())
K = int(input())
S = []
for i in range(n):
    S.append(int(input()))

dp = [[0 for _ in range (K+1)] for _ in range(n+1)]
 
for i in range(n):
    for suma in range(1, K+1):
        if dp[i-1][suma-S[i-1]] + S[i-1] <= suma:
            dp[i][suma] = max(dp[i-1][suma], dp[i-1][suma-S[i-1]] + S[i-1])
        else:
            dp[i][suma] = dp[i-1][suma]


print(dp[n-1][K])


# Algoritmul compune o suma incercand sa se apropie cat mai mult de valoarea K parcurgand sirul de elemente L si adunand numarul L[i] daca "mai este loc" pentru el (daca spatiul ramas permite sa-l mai adun si pe L[i] fara sa depasesc K)
# In timp ce fac parcurgerea, mai calculez si valoarea maxima din L si aleg maximul dintre s si aceasta pt a obtine o solutie 1/2-aproximativa.

# Cum stiu ca s[i] <= K, am 2 situatii in functie de maxim:
# 	daca m >= k/2, OPT(i) < 2 * ALG(i)
# 	daca m < k/2, cum m e cel mai mare nr din lista => toata lista e formata din numere < k/2 si parcurgand toata lista voi obtine o suma >=k/2 deoarece garantat voi putea aduna numere pana cand depasesc k/2, deci OPT(i) < 2 * ALG(I)


# Scopul algoritmului este de a calcula o suma cât mai apropiată de valoarea k prin parcurgerea unui șir de elemente
# și adunarea numărului curent la sumă în cazul în care se poate aduna fără depășirea valorii k.
# În timpul parcurgerii, algoritmul determină elementul cu valoare maximă din șir și în cazul în care este mai mare
# decât suma calculată până la momentul respectiv, schimbă suma cu acel element, cu scopul de a obține
# o soluție 1/2-aproximativă

# Știind că elementul curent din șir este mai mic decât k, pentru fiecare element se disting două situații:
#   1. Dacă valoarea elementului maxim din șir este mai mare sau egal decât jumătatea lui k, înseamnă că soluția curentă
#   este deja mai bună decât jumătatea algoritmului optim, deci soluția este 1/2-aproximativă
#   2. Dacă valoarea elementului maxim din șir este mai mică decât jumătatea lui k, rezultă că toate elementele din
#   șir sunt mai mici decât jumătatea lui k, deci prin parcurgerea întregului șir se ba obține o sumă mai mare decât k/2
#   pentru că cu siguranță se vor putea aduna numere până se depășește k/2, astfel algoritmul fiind 1/2-aproximativ

# if __name__ == '__main__':
#     n = int(input())
#     k = int(input())
#     suma = 0
#     maxim = -1
#     while n > 0:
#         n -= 1
#         x = int(input())
#         if x + suma <= k:
#             suma += x
#         if maxim < x <= k:
#             maxim = x

#     print(max(suma, maxim))