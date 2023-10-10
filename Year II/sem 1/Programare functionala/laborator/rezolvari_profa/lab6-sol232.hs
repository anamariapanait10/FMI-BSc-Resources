data Fruct
    = Mar String Bool
    | Portocala String Int
		   deriving Show


ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False, Portocala "Sanguinello" 10, Portocala "Valencia" 22, Mar "Golden Delicious" True, Portocala "Sanguinello" 15, Portocala "Moro" 12, Portocala "Tarocco" 3, Portocala "Moro" 12, Portocala "Valencia" 2, Mar "Golden Delicious" False, Mar "Golden" False, Mar "Golden" True]

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala x _ ) = x `elem` ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia _ = False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False

-- test_meu x = filter (\y -> ePortocalaDeSicilia y) x

nrFeliiSicilia :: [Fruct] -> Int
-- nrFeliiSicilia list = auxNrFelii (filter (ePortocalaDeSicilia) list)  0
-- auxNrFelii (h:t) f = auxNrFelii t f+ ((\(Portocala x y) -> y) h)
-- auxNrFelii [] f = f

-- nrFeliiSicilia list =sum [f |Portocala s f <- list, ePortocalaDeSicilia (Portocala s f)]

nrFeliiSicilia [] =0
nrFeliiSicilia ( Mar _ _ : t) = nrFeliiSicilia t
nrFeliiSicilia (Portocala s f : t) = ( if ePortocalaDeSicilia(Portocala s f) then f else 0) 
										+ nrFeliiSicilia t 

-- *Main> nrFeliiSicilia listaFructe
-- 76  fara verificare de sicilie
--52

-- *Main> nrFeliiSicilia [(Portocala "Moro" 12), (Mar "Ionatan" False)]
-- 12
-- *Main> nrFeliiSicilia [(Portocala "Moro" 12), (Mar "Ionatan" False),(Portocala  "Sanguinello" 10)]
-- 22
eMar :: Fruct -> Bool
eMar (Mar _ _)=True
eMar _ =False

nrMereViermi :: [Fruct] -> Int
nrMereViermi list = auxNrMere (filter (eMar) list) 


auxNrMere l = length[1| x<-l, (\(Mar x y) -> y ==True) x]  

-- nrMereViermi :: [Fruct] -> Int
-- nrMereViermi list = length [ b | Mar s b <- list , b ]

-- *Main> nrMereViermi [(Portocala "Moro" 12), (Mar "Ionatan" False),(Portocala  "Sanguinello" 10)]
-- 0
-- *Main> nrMereViermi [(Portocala "Moro" 12), (Mar "Ionatan" False),(Portocala  "Sanguinello" 10),goldenCuVierme]
-- 1

type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa
				deriving Show

vorbeste :: Animal -> String
vorbeste (Pisica _) ="Meow!"
vorbeste (Caine _ _) ="Woof!"

-- *Main> vorbeste (Pisica "lulu")
-- "Meow!"
-- *Main> vorbeste (Caine "Don" "maidanez")
-- "Woof!"

rasa :: Animal -> Maybe String
rasa (Caine _ x) = Just x
rasa (Pisica _) = Nothing

-- *Main> rasa (Caine "Don" "maidanez")
-- Just "maidanez"
-- *Main> rasa (Pisica "lulu")
-- Nothing

-- *Main> map sum ([[1,2,3], [4,5], [2,3,6,8], [8,5,3]])
-- [6,9,19,16]


data Linie = L [Int]
   deriving Show
data Matrice = M [Linie]
   deriving Show

verifica :: Matrice -> Int -> Bool
verifica (M list) n =  foldr (&&) True (map (\ (L l)-> sum l == n ) list)

verifica2 :: Matrice -> Int -> [Int]
verifica2 (M list) n = map (\ (L l)-> sum l) list

-- *Main> verifica2 (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3
-- [6,9,19,16]

verifica3 :: Matrice -> Int -> [Bool]
verifica3 (M list) n = map (\ (L l)-> sum l == n) list

-- *Main> verifica3 (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3
-- [False,False,False,False]

-- *Main> verifica3 (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 9
-- [False,True,False,False] 


test_verif1 = verifica (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 10 == False
test_verif2 = verifica (M[L[2,20,3], L[4,21], L[2,3,6,8,6], L[8,5,3,9]]) 25 == True
doarPozN :: Matrice -> Int -> Bool
doarPozN (M list) n = foldr (&&) True (map pozitive liniiN)
    where
      liniiN = filter (\ (L l) -> length l == n) list
      pozitive (L l) = l == filter (> 0) l

testPoz1 = doarPozN (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == True

testPoz2 = doarPozN (M [L[1,2,-3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == False
corect :: Matrice -> Bool
corect (M [])  = True
corect (M [l]) = True
corect (M (L l1: (L l2):list)) =  length l1 == length l2 && corect (M (L l2:list))

testcorect1 = corect (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) == False
testcorect2 = corect (M[L[1,2,3], L[4,5,8], L[3,6,8], L[8,5,3]]) == True



--------------------------------------Alte rezolvari ----------------------


{-
data Linie = L [Int]
deriving Show
data Matrice = M [Linie]
deriving Show



verifica :: Matrice -> Int -> Bool
verifica (M linii) n = foldr (&&) True (map (\(L l) -> n == sum l) linii)



doarPozN :: Matrice -> Int -> Bool
doarPozN (M linii) n = foldr (&&) True (map (\(L l) -> n /= length l || length (filter (<=0) l) == 0) linii)



corect :: Matrice -> Bool
corect (M linii) = foldr (&&) True (map (\lungime -> n == lungime) lungimi)
where lungimi = map (\(L l) -> length l) linii; n = lungimi !! 0
-}

{-
data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]
    deriving Show





verifica :: Matrice -> Int -> Bool
verifica (M m) n= foldr (&&) True $ map (\x -> x == n) $ map sum $ map (\(L  l) -> l) m



doarPozN :: Matrice -> Int -> Bool
doarPozN (M m) n =foldr (&&) True $ map (\l -> length l == length [x | x<-l, x>0]) $ map(\(L l)->l) $ filter (\(L l) -> length l == n) m





egale :: [Int] -> Bool
egale [] = True
egale (a:b) =  foldr (&&) True  $ map(==a) b



corect :: Matrice -> Bool
corect (M m) = egale $ map (\(L l)->length l) m
-}

{-
--3
data Linie = L [Int]
            deriving Show
data Matrice = M [Linie]
            deriving Show



--a
verifica :: Matrice -> Int -> Bool
verifica (M linii) n = foldr (&&) True (map (\(L l) -> sum l == n) linii)



--test_veri1 = verifica (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 10 == False
--test_verif2 = verifica (M[L[2,20,3], L[4,21], L[2,3,6,8,6], L[8,5,3,9]]) 25 == True



--b
doarPozN :: Matrice -> Int -> Bool
--doarPozN (M linii) n = foldr (&&) True (map (\(L l) -> length l == length (filter (>0) l) && length l == n) linii)
doarPozN (M linii) n = foldr (&&) True (map (\(L l) -> length l == length (filter (>0) l)) (filter (\(L l) -> length l == n) linii))



--testPoz1 = doarPozN (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == True
--testPoz2 = doarPozN (M [L[1,2,-3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == False



--c
corect :: Matrice -> Bool
corect (M linii) = foldr (&&) True (map (\(L l) -> length l == n) linii)
                where lista = map (\(L l) -> length l) linii
                      n = lista !! 0
--testcorect1 = corect (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) == False
--testcorect2 = corect (M[L[1,2,3], L[4,5,8], L[3,6,8], L[8,5,3]]) == True

-}
