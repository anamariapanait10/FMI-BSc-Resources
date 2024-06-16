from pc.utils import euclid, fast_pow

if __name__ == "__main__":
    p = 19
    g = 2
    h = 6
    c1 = 7
    c2 = 8

    power = 1
    b = g
    while g != h:
        print(g)
        g = (g * b) % p
        power += 1

    x = power
    print(f"found x = {x}")

    res = fast_pow(c1, x, p)

    print(f"{c1} ^ {x} = {res}")

    _, a1, b1 = euclid(res, p)
    if a1 < 0:
        a1 = p + a1
    print(f"{res} ^ -1 = {a1}")

    res = (a1 * c2) % p

    print(f"{c2} * {a1} = {res}")
