import Data.List

myInt = 55555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x + x


maxim x y = if (x > y)
                then x
            else y

max3 x y z = let
            u = maxim x y
            in (maxim u z)

max4 x y z t = 
    let
        a = maxim x y
        b = maxim z t
    in (maxim a b)

f1 x y = x * x + y * y

f2 x = if (x `mod` 2 == 0)
            then "par"
        else
            "impar"

f3 x = if(x > 1)
            then x * f3(x-1)
        else 1

f4 x y = if(x > 2 * y)
            then True
        else False