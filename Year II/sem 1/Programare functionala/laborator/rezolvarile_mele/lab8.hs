data Punct = Pt [Int]


fct_rec :: [Int] -> String
fct_rec [x] = show x
fct_rec (p:px) = show p ++ ", " ++ fct_rec px

instance Show Punct where
    show (Pt []) = "()" 
    show (Pt p) = "(" ++  fct_rec p ++ ")" 


-- Pt [1,2,3]
-- (1, 2, 3)

-- Pt []
-- ()

data Arb = Vid | F Int | N Arb Arb
    deriving Show

class ToFromArb a where
    toArb :: a -> Arb 
    fromArb :: Arb -> a 

-- toArb (Pt [1,2,3])
-- N (F 1) (N (F 2) (N (F 3) Vid))
-- fromArb $ N (F 1) (N (F 2) (N (F 3) Vid)) :: Punct
--  (1,2,3)


instance ToFromArb Punct where
    toArb (Pt []) = Vid
    toArb (Pt (x:xs)) = N (F x) (toArb (Pt xs))
    fromArb (Vid) = Pt []
    fromArb (F x) = Pt [x]
    fromArb (N l r) = Pt (fromArb' ++ fromArb'')
        where Pt fromArb' = fromArb l
              Pt fromArb'' = fromArb r


data Geo a = Square a | Rectangle a a | Circle a
    deriving Show

class GeoOps g where
    perimeter :: (Floating a) => g a -> a
    area :: (Floating a) => g a -> a


instance GeoOps Geo where
    perimeter (Square x) = 4 * x
    perimeter (Rectangle x y) = 2 * (x + y)
    perimeter (Circle r) = 2 * pi * r
    area (Square x) = x * x
    area (Rectangle x y) = x * y
    area (Circle r) = pi * r * r

instance (Floating a, Eq a) => Eq (Geo a) where
    g1 == g2 = perimeter g1 == perimeter g2


