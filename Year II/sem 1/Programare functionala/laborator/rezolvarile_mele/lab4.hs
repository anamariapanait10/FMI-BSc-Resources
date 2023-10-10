
factori :: Int -> [Int]
factori n = [x | x <- [1..(abs n)], n `mod` x  == 0]

prim :: Int -> Bool
prim n = length (factori n) == 2

numerePrime :: Int -> [Int]
numerePrime n = [x | x <- [2..n], prim x]


myzip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
myzip3 l1 l2 l3 = myzip (zip l1 l2) l3
                where 
                    myzip [] _ = []
                    myzip _ [] = []
                    myzip ((x, y):ss) (z:xs) = (x, y, z):(myzip ss xs)
--myzip3 l1 l2 l3 = [(x1, x2, x3) | ((x1, x2), x3) <- zip(zip(l1, l2), l3)]

firstEl :: [(a, b)] -> [a]
firstEl l = [x | (x, y) <- l]
--firstEl xs = map fst xs

sumList :: [[Int]] ->[Int]
sumList l = [sum x | x <- l]
--sumList l = map sum l

pre12 :: [Int] -> [Int]
pre12 l = [if(even x) then x `div` 2 else x * 2| x <- l]
--prel2 l = map (\x -> if even(x) then (div x 2) else x*2) l

f1 :: Char -> [[Char]] -> [[Char]]
f1 ch l = [x | x <- l, ch `elem` x]

f2 :: [Int] -> [Int]
f2 l = [x^2 | x <- l, x `mod` 2 == 1]

f3 :: [Int] -> [Int]
f3 l = [x^2 | (x, y) <- zip l [1..], y `mod` 2 == 1]

numaiVocale :: [[Char]] -> [[Char]]
numaiVocale l = [scoateCons x | x <- l]
    where
        scoateCons [] = [] 
        scoateCons (x:xs) = if((x `elem` "aeiouAEIOU") == True) 
                            then ([x] ++ scoateCons xs) 
                            else (scoateCons xs)

mymap :: (a->b) -> [a] -> [b]
mymap f [] = []
mymap f (x:xs) = [f x] ++ mymap f xs

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter f [] = []
myfilter f (x:xs) = if (f x) 
                    then [x] ++ myfilter f xs  
                    else [] ++ myfilter f xs 