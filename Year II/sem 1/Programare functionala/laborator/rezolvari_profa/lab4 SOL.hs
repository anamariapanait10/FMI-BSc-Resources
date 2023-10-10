{-
[ x^2 | x <- [1..10], x `rem` 3 == 2]
-> [4, 25, 64]

[(x,y)| x <- [1..5], y <- [x..(x+2)]]
-> [(1, 1), (1, 2), (1, 3), (2, 2), (2, 3), (2, 4), (3, 3), (3, 4), (3, 5), (4, 4), (4, 5), (4, 6), (5, 5), (5, 6), (5, 7)]

[(x,y)| x <- [1..3], let k = x ^ 2, y <- [1..k]]
-> [(1, 1), (2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9)]

[ x | x <- "Facultatea de Matematica si Informatica", elem x ['A'..'Z']]
-> "FMI"

[[x..y]| x <- [1..5], y <- [1..5], x < y]
-> [[1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5], [2, 3], [2, 3, 4], [2, 3, 4, 5], [3, 4], [3, 4, 5], [4, 5]]
*Main> :t rem
rem :: Integral a => a -> a -> a
*Main> rem 7 5
2
*Main> rem 7 3
1
*Main> 7 `rem` 3
1
*Main> [ X^2 |x <- [1..10], x `rem` 3 == 2]

<interactive>:5:3: error: Data constructor not in scope: X
*Main> [ x^2 |x <- [1..10], x `rem` 3 == 2]
[4,25,64]
*Main> [(x,y)| x<- [1..5], y <- [x..(x+2)]]
[(1,1),(1,2),(1,3),(2,2),(2,3),(2,4),(3,3),(3,4),(3,5),(4,4),(4,5),(4,6),(5,5),(5,6),(5,7)]
*Main> [(x,y)| x<- [1..5], y <- [1..5]]
[(1,1),(1,2),(1,3),(1,4),(1,5),(2,1),(2,2),(2,3),(2,4),(2,5),(3,1),(3,2),(3,3),(3,4),(3,5),(4,1),(4,2),(4,3),(4,4),(4,5),(5,1),(5,2),(5,3),(5,4),(5,5)]
*Main> [(x,y)| x<-[1..3], let k = x^2, y <- [1..k]}

<interactive>:9:44: error: parse error on input `}'
*Main> [(x,y)| x<-[1..3], let k = x^2, y <- [1..k]]
[(1,1),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9)]
*Main> [ x | x<- "Facultatea de Matematica si Informatica", elem x ['A'..'Z']]
"FMI"
*Main> [(x,y)| x<- [1..5], y <- [1..5]]
[(1,1),(1,2),(1,3),(1,4),(1,5),(2,1),(2,2),(2,3),(2,4),(2,5),(3,1),(3,2),(3,3),(3,4),(3,5),(4,1),(4,2),(4,3),(4,4),(4,5),(5,1),(5,2),(5,3),(5,4),(5,5)]
*Main> [(x,y)| x <- [1..5], y <- [1..5], x < y]
[(1,2),(1,3),(1,4),(1,5),(2,3),(2,4),(2,5),(3,4),(3,5),(4,5)]
*Main> [[x..y]| x <- [1..5], y <- [1..5], x < y]
[[1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5],[2,3],[2,3,4],[2,3,4,5],[3,4],[3,4,5],[4,5]]
-}

-- ex 1
--factori :: Int -> [Int]
factori n = [d | d <- [1..n], n `mod` d == 0]

-- ex 2
prim :: Int -> Bool
prim n = length (factori n) == 2

prim2 :: Int -> Bool
prim2 n = (length $ factori n) == 2

-- ex 3
numerePrime :: Int -> [Int]
numerePrime n = [nr | nr <- [2..n], prim nr]

{-
*Main> zip [1..5] [1..3]
[(1,1),(2,2),(3,3)]
*Main> zip (zip [1..5] [1..3]) [1..5]
[((1,1),1),((2,2),2),((3,3),3)]
*Main> fst ((1,2),3)
(1,2)
*Main> fst( fst ((1,2),3))
1
*Main> snd( fst ((1,2),3))
2

*Main> snd ((1,2),3)
3

-}
-- ex 4
-- myzip3 [1, 2, 3] [1, 2] [1, 2, 3, 4] == [(1, 1, 1), (2, 2, 2)]

myzip3 :: [a] -> [b] -> [c] -> [(a, b, c)]

myzip3 l1 l2 l3 = [(a, b, c) | (a, (b, c)) <- zip l1 (zip l2 l3)]

myzip3' :: [a] -> [b] -> [c] -> [(a, b, c)]

myzip3' l1 l2 l3 = [(fst (fst p), snd(fst p), snd p) | p <- zip (zip l1 l2) l3]

-- Compunere de functii:
aplica2 :: (a -> a) -> a -> a
aplica2 f x = f (f x) 

aplica2' :: (a -> a) -> a -> a
aplica2' f = f . f

aplica2'' :: (a -> a) -> a -> a
aplica2'' = \f x -> f (f x)

aplica2''' :: (a -> a) -> a -> a
aplica2''' f = \x -> f (f x)

adunare x = x+x
{-
*Main> aplica2 (*3) 5
45
*Main> (*3) 5
15
*Main> (*3) ((*3) 5)
45
*Main> aplica2 (*3) 5
45
*Main> :t (*3)
(*3) :: Num a => a -> a
*Main> :t aplica2
aplica2 :: (a -> a) -> a -> a
*Main> aplica2' (*3) 5
45
*Main> aplica2'' (*3) 5
45
*Main> aplica2''' (*3) 5
45
*Main> :r
[1 of 1] Compiling Main             ( C:\\Users\Student\Documents\232-PF\2321\Laborator 4\lab4 sol - actualizat.hs, interpreted )
Ok, one module loaded.
*Main> aplica2''' adunare 5
20
-}

{- Functia map:
map :: (a -> b) -> [a] -> [b]
map f xs =[f x | x <- xs]

map (\x -> 2 * x) [1..10]
-> [2, 4..20]

map (1 `elem`) [[2,3], [1,2]]
-> [False, True]

map (`elem` [2, 3]) [1, 3, 4, 5]
-> [False, True, False, False]
-}

{- Functia filter:
filter :: (a -> Bool) -> [a] -> [a]
filter p xs = [x | x <- xs, p x]

filter (> 2) [3, 1, 4, 2, 5]
-> [3, 4, 5]

filter odd [3, 1, 4, 2, 5]
-> [3, 1, 5]
-}

-- ex 5
-- firstEl [('a', 3), ('b', 2), ('c', 1)] == "abc"
{-
*Main> firstEl [('a',3),('b',2), ('c',1)]
"abc"
*Main> firstEl2 [('a',3),('b',2), ('c',1)]
"abc"
*Main> firstEl2' [('a',3),('b',2), ('c',1)]
"abc"
-}

firstEl2 :: [(a, b)] -> [a]
firstEl2 l = [x| (x,y) <-l]

firstEl2' :: [(a, b)] -> [a]
firstEl2' l = [fst t | t <-l]

firstEl :: [(a, b)] -> [a]
firstEl list = map fst list
-- sau map (\(a, b) -> a) list


firstEl3 :: [(a, b, c)] -> [a]
firstEl3 list = map (\(x, y, z) -> x) list
-- *Main> firstEl3 [('a',5,3),('b',4,2), ('c',1,1)]
--"abc"
-- ex 6
-- sumList [[1, 3], [2, 4, 5], [], [1, 3, 5, 6]] == [4, 11, 0, 15]

sumList :: [[Int]] -> [Int]
sumList = map sum
--sumList l = map sum l
-- sumList l=  [sum li| li <- l]


prel2' :: [Int] -> [Int]
prel2' list = [if x `mod` 2 == 0 then x `div` 2 else x * 2|x<- list]

-- ex 7
-- prel2 [2, 4, 5, 6] == [1, 2, 10, 3]

prel2 :: [Int] -> [Int]
prel2 list = map (\ x -> if x `mod` 2 == 0 then x `div` 2 else x * 2) list

-- ex 8
-- ex8 's' ["sos", "civic", "palton", "desen", "aerisire"] == ["sos", "desen", "aerisire"]

ex8 :: Char -> [String] -> [String]
ex8 c s = filter (elem c) s

-- ex 9
-- ex9 [3..8] == [9, 25, 49]

ex9 :: [Int] -> [Int]
ex9  = map (^2) . filter odd
ex92 l  = map (^2) $ filter odd l

-- ex 10
-- ex10 [3..8] == [16, 36, 64]

ex10 :: [Int] -> [Int]
ex10 list = map (\(a, b) -> a * a) (filter (\(a, b) -> odd b) (zip list [0..]))

-- ex 11
-- numaiVocale ["laboratorul", "PrgrAmare", "DEclarativa"] == ["aoaou", "Aae", "Eaaia"]

numaiVocale :: [String] -> [String]
numaiVocale list = map (filter (\c -> elem c "aeiouAEIOU")) list

-- ex 12
mymap :: (a -> b) -> [a] -> [b]
mymap _ [] = []
mymap f (x:xs) = f x : mymap f xs

myfilter :: (a -> Bool)  -> [a] -> [a]
myfilter _ [] = []
myfilter p (x:xs)
  | p x = x : myfilter p xs
  | otherwise = myfilter p xs
