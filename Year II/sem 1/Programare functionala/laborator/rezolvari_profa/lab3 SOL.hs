import Data.Char

palindrom :: String -> Bool
palindrom s = s == reverse s
-- if s==reverse s then True else False

isVowel :: Char -> Bool
isVowel c = c `elem` "AEIOUaeiou"

countVowels :: String -> Int
countVowels "" = 0
countVowels (c:s) = (if isVowel c then 1 else 0 ) + countVowels s

nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale (s:ss)
  | palindrom s = countVowels s + nrVocale ss
  | otherwise = nrVocale ss
  
---lista de cuvinte palindrome
  
  
  
-- doarPalindrom :: [String] ->[String] 
-- doarPalindrom [] = []
-- doarPalindrom (s:ss) 
    -- |palindrom s = [s] ++ doarPalindrom ss
    -- |otherwise = doarPalindrom ss
-- *Main> doarPalindrom ["sos", "civic", "palton", "desen", "aerisirea"]
-- ["sos","civic","aerisirea"]
	
doarPalindrom :: [String] ->String 
doarPalindrom [] = ""
doarPalindrom (s:ss) 
    |palindrom s = s ++ doarPalindrom ss
    |otherwise = doarPalindrom ss	
	
-- *Main> doarPalindrom ["sos", "civic", "palton", "desen", "aerisirea"]
-- "soscivicaerisirea"


-- -- nrVocale ["sos", "civic", "palton", "desen", "aerisirea"] = 9
-- *Main> elem 'd' "aeiouAEIOU"
-- False
-- *Main> elem 'a' "aeiouAEIOU"
-- True
-- *Main> reverse "palindrom"
-- "mordnilap"
-- *Main> reverse "ana"
-- "ana"
-- *Main> reverse "ana" == "ana"
-- True
-- *Main> reverse "civic" == "civic"
-- True
-- *Main> nrVocale ["sos", "civic", "palton", "desen", "aerisirea"]
-- 9

f :: Int -> [Int] -> [Int]
f _ [] = []
f y (x:xs)
  | x `mod` 2 == 0 = x :y: f y xs
  | otherwise = x: f y xs
-- f 3 [1,2,3,4,5,6] = [1,2,3,3,4,3,5,6,3]

-- f :: Int -> [Int] -> [Int]
-- f _ [] = []
-- f y (x:xs)
  -- | x ` mod` 2 == 0 = [x] ++ [y] ++ f y xs
  -- | otherwise = x: f y xs

semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]
-- divizori 4 = [1,2,4]
divizori :: Int -> [Int]
divizori n = [d | d<-[1..n], n `mod` d == 0 ]


listadiv :: [Int] -> [[Int]]
listadiv l = [divizori n | n <- l]
-- listadiv [1,4,6,8] = [[1],[1,2,4],[1,2,3,6],[1,2,4,8]]

--  

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs)  = (if a <= x && x<=b 
								then x:inIntervalRec a b xs 
								else inIntervalRec a b xs)


inIntervalRec2 :: Int -> Int -> [Int] -> [Int]
inIntervalRec2 _ _ [] = []
inIntervalRec2 a b (x:xs) 
 |a <= x && x<=b = x:inIntervalRec2 a b xs
 |otherwise= inIntervalRec2 a b xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [x | x<-l, a<=x && x<=b]  

-- inInterval 5 10 [1..15] == [5,6,7,8,9,10]
-- inInterval 5 10 [1,3,5,2,8,-1] = [5,8]

-- *Main> inIntervalRec2 5 10 [1..15] == [5,6,7,8,9,10]
-- True


pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
  | x > 0 = 1 + pozitiveRec xs
  | otherwise = pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp l = length [n | n<-l, n > 0]

-- pozitive [0,1,-3,-2,8,-1,6] == 3

pozitiiImpareRec, pozitiiImpareComp :: [Int] -> [Int]

pozitiiImpareRecAux _ [] = []
pozitiiImpareRecAux i (x:xs)
    | x `mod` 2 == 1 = i : pozitiiImpareRecAux (i+1) xs
    | otherwise = pozitiiImpareRecAux (i+1) xs

pozitiiImpareRec l = pozitiiImpareRecAux 0 l

pozitiiImpareComp l = [p | (el,p)<- zip l [0..], el `mod` 2 == 1]
-- pozitiiImpare [0,1,-3,-2,8,-1,6,1] == [1,2,5,7]

multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec (c:s) = if isDigit  c then digitToInt c * multDigitsRec s
    else multDigitsRec s

multDigitsComp :: String -> Int
multDigitsComp s = product [digitToInt c | c<-s, isDigit c]

-- multDigits "The time is 4:25" == 40
-- multDigits "No digits here!" == 1
