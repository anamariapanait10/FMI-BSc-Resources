from pc.primes import is_prime
from pc.utils import euclid, lcm, fast_pow
import argparse


if __name__ == "__main__":
    n = 55
    e = 7
    m = 3

    print(f"starting with : n {n} e {e} m {m}")
    print("----------------------")
    print(f"finding a and b")

    found = 0

    for i in range(2, n // 2):
        if n % i == 0:
            found = 1
            a = i
            b = n // i
            break

    if not found:
        print("couldnt find a and b")
    print(f"a = {a} b = {b}")
    print("----------------------")
    print("finding lambda")
    l = lcm(a - 1, b - 1)
    print(f"lambda of {n} = {l}")
    print("----------------------")

    _, d, y = euclid(e, l)
    if d < 0:
        d = l + d

    print(f"d(priv key) = {d}")
    print("----------------------")

    fast_pow(m, d, n)
