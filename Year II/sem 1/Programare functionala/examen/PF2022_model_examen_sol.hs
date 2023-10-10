-- Programare Functionala 2022
-- Model examen

-- Subiectul 1
data Point = Pt [Int]
  deriving Show

data Arb = Empty | Node Int Arb Arb
  deriving Show

class ToFromArb a where
  toArb :: a -> Arb
  fromArb :: Arb -> a 

instance ToFromArb Point where 
  toArb (Pt []) = Empty 
  toArb (Pt (x:xs)) = Node x (toArb (Pt (filter (< x) xs)))  (toArb (Pt (filter (>= x) xs)))
  fromArb Empty = Pt [] 
  fromArb (Node x st dr) = let Pt l1 = fromArb st 
                               Pt l2 = fromArb dr
                           in Pt (l1 ++ [x] ++ l2)

-- Subiectul 2
-- cu selectie 
getFromIntervalSel a b list = [x | x<-list, x>=a, x<=b]
-- monade
getFromInterval a b list = do 
    x<-list 
    if a <= x && x <= b then return x else []

-- Subiectul 3
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

 