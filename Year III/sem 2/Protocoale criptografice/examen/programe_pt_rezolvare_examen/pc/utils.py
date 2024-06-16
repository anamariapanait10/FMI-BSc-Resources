def euclid(a, b):
    oa = a
    ob = b
    swapped = False
    if a < b:
        print("a smaller than b, swapping")
        a = a ^ b
        b = a ^ b
        a = a ^ b
        swapped = True

    print(f"starting with a = {a} b = {b}")

    print("doing repetitive division: ")

    l = [(a, b)]
    i = 0
    while b != 0:
        i += 1
        c = b
        b = a % b
        a = c
        l.append((a, b))
        print(f"step {i}: a = {a} b = {b}")

    if a != 1:
        print("gcd is different, only returning gcd")
        return (a, -1, -1)
    x = a
    y = b

    n = i
    print(f"starting with x = {x} y = {y}")
    for i in range(i - 1, -1, -1):
        c = y
        y = x - (l[i][0] // l[i][1]) * y
        x = c
        print(f"step {n - i}: x = {x} y = {y}")

    if not swapped:
        print(f"for {oa} {ob} found x = {x} and y = {y}")
        return (1, x, y)

    print(f"for {oa} {ob} found x = {y} and y = {x}")
    return (1, y, x)


def lcm(a, b):
    gcd, _, _ = euclid(a, b)
    return a * b // gcd


def fast_pow(a, p, n):
    print(f"fast pow : number {a} pow {p} mod {n}")
    i = 1
    e = a
    pow = 1
    res = 1
    last = 1
    while i <= p:
        print(f"{e} ^ {i} = {(a) % n} ({last} * {last}) mod {n}")
        if p & i:
            res = (res * a) % n
            print(f"adding {a}")
        last = a
        a = (a * a) % n
        i = i << 1
    print(f"res = {res}")
    return res
