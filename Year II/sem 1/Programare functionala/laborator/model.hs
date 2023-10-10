-- subiectul 1 ADT (Algebraic data type) + Clase

data Point = Pt [Int] deriving Show

data Arb = Empty | Node Int Arb Arb deriving Show

class ToFromArb a where
    toArb :: a -> Arb 
    fromArb :: Arb -> a

instance ToFromArb Point where 
    toArb (Pt []) = Empty
    toArb (Pt (x:xs)) = Node x (toArb (Pt (filter (<x) xs)))  (toArb (Pt (filter (>=x) xs)))
    fromArb Empty = Pt [1]
    fromArb (Node val left right) = Pt (fromArb' ++ [val] ++ fromArb'')
                            where   Pt fromArb' = fromArb left 
                                    Pt fromArb'' = fromArb right  
                                    

-- subiectul 2 List + Monade
getFromInterval :: Int -> Int -> [Int] -> [Int]
getFromInterval a b l = if (a <= b) then [ x | x <- l, a <= x, x <= b]
                        else [ x | x <- l, b <= x, x <= a]

getFromInterval' :: Int -> Int -> [Int] -> [Int]
getFromInterval' a b l = do 
                            x <- l
                            if a <= x && x <= b then return x else []

-- subiectul 3 Monade
newtype ReaderWriter env a = RW {getRW :: env-> (a,String)}

instance Monad (ReaderWriter env) where
  return va = RW (\_ -> (va,""))
  ma >>= k = RW f 
      where f env = let (va, str1) = getRW ma env
                        (vb, str2)  = getRW (k va) env
                    in (vb, str1 ++ str2)

instance Applicative (ReaderWriter env) where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor (ReaderWriter env) where              
  fmap f ma = pure f <*> ma 