sumImp :: [Int] -> Int
sumImp l = foldr (+) 0 (map (^2) (filter odd l ))

alltrue :: [Bool] -> Bool
alltrue l = foldr (&&) True l

allVerifies :: (Int -> Bool) -> [Int] -> Bool
allVerifies p list = foldr (\ x acc ->acc  && p x) True list

allVerifies2 :: (Int -> Bool) -> [Int] -> Bool
allVerifies2 p list = foldr (&&) True (map p list)

anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies  p list = foldr (\ x acc ->  acc || p x) False list

anyVerifies2 :: (Int -> Bool) -> [Int] -> Bool
anyVerifies2 p list =  foldr (||) False (map p list)


mapFoldr :: (a->b) -> [a] -> [b]
mapFoldr f list = foldr (\ x acc -> f x : acc) [] list

mapFoldr2 :: (a->b) -> [a] -> [b]
mapFoldr2 f list = foldr ((:).(f$)) [] list

filterFoldr :: (a->Bool) -> [a] -> [a]
filterFoldr p list = foldr (\ x acc -> (if p x then [x] else [] ) ++ acc) [] list


filterFoldr2 :: (a->Bool) -> [a] -> [a]
filterFoldr2 p list = foldr ((++).(\x -> if p x then [x] else [] )) [] list



listToInt :: [Integer]-> Integer
listToInt list = foldl (\acc x->acc * 10 + x) 0 list


listToInt2 :: [Integer]-> Integer
listToInt2 list = foldr (\acc x->acc * 10 + x) 0 list


listToInt3 :: [Integer]-> Integer
listToInt3 list = foldr (\x acc->acc * 10 + x) 0 list


rmChar :: Char -> String -> String
rmChar c s = filter (/=c) s
{-
rmCharsRec :: String -> String -> String
rmCharsRec s1 "" = ""
rmCharsRec s1 (c:s)
   | c `elem` s1 = rmCharsRec s1 s  
   | otherwise = c:rmCharsRec s1 s
-}
rmCharsRec :: String -> String -> String
rmCharsRec "" s2 = s2
rmCharsRec (c:s) s2 = rmCharsRec s (rmChar c s2)


rmCharsFold :: String -> String -> String
--rmCharsFold s1 s2 = foldr (rmChar) s2 s1
rmCharsFold s1 s2 = foldr (\ x acc ->rmChar x acc) s2 s1


{-
*Main> sumImp [1,2,3,4,5]
35
*Main> alltrue [False]
False
*Main> alltrue [False, True]
False
*Main> alltrue [Tr, True]
Traversable  True
*Main> alltrue [True, True]
True
*Main> allVerifies odd [1,3,5,7]
True
*Main> allVerifies odd [1,3,5,7,2]
False

*Main> allVerifies2 odd [1,3,5,7]
True
*Main> allVerifies2 odd [1,3,5,7,8]
False

*Main> anyVerifies2 odd [1,3,5,7,8]
True
*Main> anyVerifies2 even [1,3,5,7,8]
True
*Main> anyVerifies2 even [1,3,5,7]
False
*Main> anyVerifies odd [1,3,5,7,8]
True
*Main> anyVerifies even [1,3,5,7,8]
True
*Main> anyVerifies even [1,3,5,7]
False



*Main> mapFoldr (+10) [1..5]
[11,12,13,14,15]
*Main> filterFoldr odd [1,2,3,4,5,6,7,8]
[1,3,5,7]

*Main> listToInt2 [1,2,3,4]
100
*Main> listToInt [1,2,3,4]
1234
*Main> listToInt3 [1,2,3,4]
4321


*Main> rmChar 'a' "abbcccdddcccbbbfff"
"bbcccdddcccbbbfff"
*Main> rmChar 'b' "abbcccdddcccbbbfff"
"acccdddcccfff"

*Main> rmCharsFold "abc" "abbcccdddcccbbbfff"
"dddfff"

-}