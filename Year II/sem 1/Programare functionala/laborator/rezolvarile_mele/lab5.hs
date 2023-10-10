--1
-- suma patratelor elementelor impare
-- map, filter si fold (fara recursivitate sau selectie)

f1 :: [Int] -> Int
f1 l = sum (map (^2) (filter odd l))

-- 2
-- toate elementele dintr-o listă sunt True, folosind foldr.
f2 :: [Bool] -> Bool
f2 l = foldr (&&) True l

-- 3
allVerifies :: (Int -> Bool) -> [Int] -> Bool
allVerifies f l = f2 (map f l)

-- 4
anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies f l = foldr (||) False (map f l)

-- 5
mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr f [] = []
mapFoldr f xs = foldr (\y ys -> (f y):ys) [] xs

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr f [] = []
filterFoldr f x = foldr (\x xs -> if f x then x:xs else xs ) [] x

-- 6
listToInt :: [Integer] -> Integer
listToInt l = foldl (\x xs -> x * 10 + xs) 0 l


-- 7
-- a)
rmChar :: Char -> String -> String
rmChar ch l = foldr (\x xs -> if x == ch then xs else x:xs ) [] l 


-- b)
rmCharRec :: String -> String -> String
rmCharRec [] l = l
rmCharRec (ch:chs) l = rmCharRec chs (rmChar ch l)

-- c)
rmCharFold :: String -> String -> String
--rmCharFold chs l = foldr (\ch chs -> rmChar chs l) [] chs
rmCharFold chs l = foldr rmChar l chs


