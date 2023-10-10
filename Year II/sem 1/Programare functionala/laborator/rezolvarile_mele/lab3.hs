{-
nrVocale :: [String] -> int
nrVocale xs
    let lista_pal = [cuv | cuv <- xs, palindrom cuv]
    in nrVoc

palindrom :: String -> Bool
palindrom cuv
    | len == 0 = False
    | len == 1 = True
    | len == 2 = head cuv == last cuv
    | head cuv /= last cuv = False
    | otherwise = palindrom (take (len - 2) (tail cuv))
    where len = length cuv

nrVoc :: String -> int
nrVoc cuv
nrVoc "" = 0
nrVoc (c:s) = (if head c elem "AEIOUaeiou" ) then 1 + nrVoc cuv else nrVoc cuv

nr_Pare :: [int] -> int
nr_Pare [] = 0
nr_Pare xs = if(even(head xs) == True) then 1 else 0 + nrPare (tail xs)


f_util :: int -> int ->[int] ->[int]
f_util n x [] = []
f_util n x xs
    | length xs < n = xs
    | otherwise take n xs ++ [x] ++ f_util n x (drop n xs)


f :: int -> [int] -> [int]
f x xs = f_util ((length xs) + nrPare) x xs
-}
import Data.List 

f :: Int -> [Int] -> [Int]
f nr [] = []
f nr lista 
    | even (head lista) = head lista : (nr : f nr (tail lista))
    | otherwise = head lista : f nr (tail lista)

semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]

divizori :: Int -> [Int]
divizori nr = [x | x <- [1..(nr)], nr `rem` x == 0]

listadiv :: [Int] -> [[Int]]
listadiv [] = []
listadiv (s:ss) = [divizori s] ++ listadiv ss

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec a b [] = []
inIntervalRec a b (s:ss) = if(s >= a && s <= b) then [s] ++ inIntervalRec a b ss else [] ++ inIntervalRec a b ss

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [x | x <- l, a <= x && x <= b]

pozitive :: [Int] -> Int
pozitive [] = 0
pozitive (s:ss) = if(s > 0) then 1 + pozitive ss else 0 + pozitive ss

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec "" = l
pozitiiImpareRec (c:s) 

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [p | (el, p) <- zip l [0..], el `mod` 2 == 1]

{-
multDigits :: String -> Int
multDigits 
multDigits 
-}










