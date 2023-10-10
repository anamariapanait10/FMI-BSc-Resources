data Expr = Const Int -- integer constant
          | Expr :+: Expr -- addition
          | Expr :*: Expr -- multiplication
           deriving Eq

data Operation = Add | Mult deriving (Eq, Show)

data Tree = Lf Int -- leaf
          | Node Operation Tree Tree -- branch
           deriving (Eq, Show)

instance Show Expr where
    show (Const x) = show x
    show (x :+: y) = "(" ++ show x ++ "+" ++ show y ++ ")"
    show (x :*: y) = "(" ++ show x ++ "*" ++ show y ++ ")"

evalExp :: Expr -> Int
evalExp (Const nr) = nr
evalExp (x :+: y) = (evalExp x) + (evalExp y)
evalExp (x :*: y) = (evalExp x) * (evalExp y)

exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
exp2 = (Const 2 :*: (Const 3 :+: Const 4))
exp3 = (Const 4 :+: (Const 3 :*: Const 3))
exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)
test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16

evalArb :: Tree -> Int
evalArb (Lf x) = x
evalArb (Node Add tree1 tree2) = (evalArb tree1) + (evalArb tree2)
evalArb (Node Mult tree1 tree2) = (evalArb tree1) * (evalArb tree2)


arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6
test22 = evalArb arb2 == 14
test23 = evalArb arb3 == 13
test24 = evalArb arb4 == 16


expToArb :: Expr -> Tree
expToArb = undefined


class Collection c where
  empty :: c key value
  singleton :: key -> value -> c key value
  insert
      :: Ord key
      => key -> value -> c key value -> c key value
  --clookup :: Ord key => key -> c key value -> Maybe value
  --delete :: Ord key => key -> c key value -> c key value
  keys :: c key value -> [key]
  values :: c key value -> [value]
  toList :: c key value -> [(key, value)]
  fromList :: Ord key => [(key,value)] -> c key value

  keys c = [fst p | p <- toList c]
  values c = [snd p | p <- toList c]
  fromList [] = empty
  fromList ((k,v):xs) = insert k v (fromList xs)


newtype PairList k v
  = PairList { getPairList :: [(k, v)] }
  --deriving Show


instance Collection PairList where
    empty = PairList []
    singleton k v = PairList[(k,v)]
    insert k v (PairList l) = PairList ((k, v):[t | t <- l, fst t /= k])
    --clookup k (PairList l) = 2
    --delete k (PairList l) = PairList l

instance (Show k, Show v) => Show (PairList k v) where
    show (PairList l) = "PairList " ++ (show l)

data SearchTree key value
  = Empty
  | BNode
      (SearchTree key value) -- elemente cu cheia mai mica
      key                    -- cheia elementului
      (Maybe value)          -- valoarea elementului
      (SearchTree key value) -- elemente cu cheia mai mare
    deriving Show

instance Collection SearchTree where
  empty = Empty 
  singleton k v = BNode Empty k (Just v) Empty
  insert k v s = inserare s
    where inserare Empty = singleton k v 
        inserare (BNode arb_st k1 v1 arb_dr)
          | k == k1 = BNode arb_st k (Just v) arb_dr 
          | k < k1 = BNode (inserare arb_st) k1 v1 arb_dr 
          | otherwise = BNode arb_st k1 v1 (inserare arb_dr)
  delete k s = sterge s
    where
        sterge Empty = Empty
        sterge (BNode arb_st k1 v1 arb_dr)
          | k == k1 = BNode arb_st k Nothing arb_dr
          | k < k1 = BNode (sterge arb_st) k1 v1 arb_dr 
          | otherwise = BNode arb_st k1 v1 (sterge arb_dr)

  clookup k s = cauta s
    where
        cauta Empty = Nothing
        cauta (BNode arb_st k1 v1 arb_dr)
          | k == k1 = BNode arb_st k Nothing arb_dr
          | k < k1 = BNode (cauta arb_st) k1 v1 arb_dr 
          | otherwise = BNode arb_st k1 v1 (cauta arb_dr)
  toList Empty = []
  toList (BNode arb_st k1 v1 arb_dr) = 
    (toList arb_st) ++ (lista_din k1 v1) ++ (toList arb_dr)
    where
      lista_din 
--insert 1 "a" (BNode Empty 2 (Just "a") Empty)