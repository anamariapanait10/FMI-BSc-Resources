poly :: Double -> Double -> Double -> Double -> Double
poly a b c x = a * x^2 + b * x + c

eeny :: Integer -> String
eeny x
 | x `mod` 2 == 0 = "eeny"
 | otherwise = "meeny"

fizzbuzz :: Integer -> String
fizzbuzz x
  | x `mod` 3 == 0 && x `mod` 5 == 0 = "FizzBuzz"
  | x `mod` 3 == 0 = "Fizz"
  | x `mod` 5 == 0 = "Buzz"
  | otherwise = ""

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2     = n
    | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)
fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)
	
tribonacciC :: Integer -> Integer
tribonacciC n
  | n <= 2 = 1
  | n == 3 = 2
  | n > 3 =  tribonacciC (n-1) + tribonacciC (n-2) + tribonacciC (n-3)

tribonacciEc :: Integer -> Integer
tribonacciEc 1 = 1
tribonacciEc 2 = 1
tribonacciEc 3 = 2
tribonacciEc n = tribonacciEc (n-1) + tribonacciEc (n-2) + tribonacciEc (n-3)

binomial :: Integer -> Integer -> Integer
binomial n 0 = 1
binomial 0 k = 0
binomial n k = binomial (n-1) k + binomial (n-1) (k-1)

binomial2 :: Integer -> Integer -> Integer
binomial2 _ 0 = 1
binomial2 0 _ = 0
binomial2 n k = binomial2 (n-1) k + binomial2 (n-1) (k-1)

binomialpereche :: (Integer,Integer) -> Integer
binomialpereche (n, 0) = 1
binomialpereche (0, k) = 0
binomialpereche (n, k) = binomialpereche ((n-1), k) + binomialpereche ((n-1), (k-1))

-- verifL :: [Int] -> Bool
-- verifL l = even (length l)

verifL :: [Int] -> Bool
verifL l = even $ length l

takefinal :: [Int] -> Int -> [Int]
takefinal l n
  | length l > n = drop (length l - n) l
  | otherwise = l
  
remove l n = (take (n-1) l)++ (drop n l)

-- semiPareRec [0,2,1,7,8,56,17,18] == [0,1,4,28,9]
semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (h:t)
 | even h    = h `div` 2 : t'
 | otherwise = t'
 where t' = semiPareRec t
 
semiPareRec2 :: [Int] -> [Int]
semiPareRec2 [] = []
semiPareRec2 l
 | even (head l)    = (head l) `div` 2 : t'
 | otherwise = t'
 where t' = semiPareRec2 (tail l)
 
 
-- *Main> 1:[]
-- [1]
-- *Main> 1:(2:[])
-- [1,2]
-- *Main> [1,2] ++ [3,4]
-- [1,2,3,4]
-- *Main> 1:(2:(3:(4:[])))
-- [1,2,3,4]

myreplicate :: Integer -> a -> [a]
myreplicate 0 v = []
myreplicate n v = v : myreplicate (n-1) v

sumImp :: [Integer] -> Integer
sumImp [] = 0
sumImp (x:xs)
 | x `mod` 2 == 1 = x + sumImp xs
 | otherwise = sumImp xs


totalLen :: [String] -> Int
totalLen [] = 0
totalLen (s:ss)
   | s !! 0 == 'A' = length s + totalLen ss
   | otherwise = totalLen ss

palindrom :: String -> Bool
palindrom s = s == reverse s
