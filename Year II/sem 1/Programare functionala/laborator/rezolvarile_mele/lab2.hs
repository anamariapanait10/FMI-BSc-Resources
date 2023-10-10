
poly2 :: Double -> Double -> Double -> Double -> Double
poly2 a b c x = a * x ^ 2 + b * x + c

eeny :: Integer -> String
eeny x = if(even x)
            then "eeny"
        else "meeny"

fizzbuzz :: Integer -> String
fizzbuzz x = if(x `mod` 3 == 0 && x `mod` 5 == 0)
                then "FizzBuzz"
            else if(x `mod` 3 == 0)
                then "Fizz"
            else if(x `mod` 5 == 0)
                then "Buzz"
            else ""

fizzbuzz2 :: Integer -> String
fizzbuzz2 x 
    | x `mod` 3 == 0 && x `mod` 5 == 0 = "FizzBuzz"
    | x `mod` 3 == 0 = "Fizz"
    | x `mod` 5 == 0 = "Buzz"
    | otherwise = ""

trifibonacciCazuri :: Integer -> Integer
trifibonacciCazuri n
    | n < 3 = 1
    | n == 3 = 2
    | otherwise = trifibonacciCazuri (n-1) + trifibonacciCazuri (n-2) + trifibonacciCazuri (n-3)


trifibonacciEcuational :: Integer -> Integer
trifibonacciEcuational 1 = 1
trifibonacciEcuational 2 = 1
trifibonacciEcuational 3 = 2
trifibonacciEcuational n = trifibonacciEcuational (n-1) + trifibonacciEcuational (n-2) + trifibonacciEcuational (n-3)


binomial :: Integer -> Integer -> Integer
binomial 0 k = 0
binomial n 0 = 1
binomial n k = binomial (n-1) k + binomial (n-1) (k-1)


verifL :: [Int] -> Bool
verifL lista
    | length lista `mod` 2 == 0 = True
    | otherwise = False

takefinal :: [Int] -> Int -> [Int]
takefinal lista n
    | length lista <= n = lista
    | length lista > n = drop (length lista - n) lista

takefinal2 :: [a] -> Int -> [a]
takefinal2 lista n
    | length lista <= n = lista
    | length lista > n = drop (length lista - n) lista

remove :: [a] -> Int -> [a]
remove lista n = take (n-1) lista ++ (drop n lista)

myreplicate :: Int -> Int -> [Int]
myreplicate v 0 = []
myreplicate v n = v : myreplicate v (n-1)


sumImp :: [Int] -> Int
sumImp [] = 0
sumImp lista = if(head lista `mod` 2 == 1)
                    then head lista + sumImp (tail lista)
                else sumImp (tail lista)

totalLen :: [String] -> Int
totalLen [] = 0
totalLen lista = if(head (head lista) == 'A')
                    then length (head lista) + totalLen (tail lista)
                else totalLen (tail lista)