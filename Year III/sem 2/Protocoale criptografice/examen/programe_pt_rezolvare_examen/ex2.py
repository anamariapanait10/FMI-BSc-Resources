from pc.utils import euclid


if __name__ == "__main__":
    n = 120
    g = 11
    h = 12
    c1 = 13
    c2 = 14

    _, a, b = euclid(g, n)
    if a < 0:
        a = n + a

    print("-------------------")

    print(f"x = g^-1 ^ h = {a}^-1 ^ {h} mod {n}")
    x = (a * h) % n

    print(f"x = {x}\n")

    print(f"m = c2 - x * c1 = {c2} - {x} * {c1} mod {n}")
    m = (c2 - x * c1) % n
    print(f"found m: {m}")
