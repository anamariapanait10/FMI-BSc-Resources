{-
class Functor f where
fmap : : ( a -> b ) -> f a -> f b
-}
newtype Identity a = Identity a
    deriving Show

instance Functor Identity where
    fmap f (Identity x) = Identity (f x)

data Pair a = Pair a a
    deriving Show

instance Functor Pair where
    fmap f (Pair x y) = Pair (f x) (f y)  

data Constant a b = Constant b
    deriving Show

instance Functor (Constant a) where
    fmap f (Constant x) = Constant (f x)

data Two a b = Two a b
    deriving Show

instance Functor (Two a) where
    fmap f (Two x y) = Two x (f y)

data Three a b c = Three a b c
    deriving Show

instance Functor (Three a b) where
    fmap f (Three x y z) = Three x y (f z)

data Three' a b = Three' a b b
    deriving Show

instance Functor (Three' a) where
    fmap f (Three' x y z) = Three' x (f y) (f z)

data Four a b c d = Four a b c d
    deriving Show

instance Functor (Four a b c) where
    fmap f (Four x y z k) = Four x y z (f k)

data Four'' a b = Four'' a a a b
    deriving Show

instance Functor (Four'' a) where
    fmap f (Four'' x y z k) = Four'' x y z (f k)

data Quant a b = Finance | Desk a | Bloor b
    deriving Show

instance Functor (Quant a) where
    fmap f Finance = Finance
    fmap f (Desk x) = Desk x
    fmap f (Bloor y) = Bloor (f y)

data LiftItOut f a = LiftItOut (f a)
    deriving Show

instance Functor f => Functor (LiftItOut f) where
    fmap f (LiftItOut fa) = LiftItOut (fmap f fa)

data Parappa f g a = DaWrappa (f a) (g a)
    deriving Show

instance (Functor f, Functor g) => Functor (Parappa f g) where
    fmap h (DaWrappa fa ga) = DaWrappa (fmap h fa) (fmap h ga)

data IgnoreOne f g a b = IgnoringSomething (f a) (g b)
    deriving Show

instance (Functor f, Functor g) => Functor (IgnoreOne f g a) where
    fmap h (IgnoringSomething fa gb) = IgnoringSomething fa (fmap h gb)

data Notorious g o a t = Notorious (g o) (g a) (g t)
    deriving Show

instance Functor g => Functor (Notorious g o a) where
    fmap h (Notorious go ga gt) = Notorious go ga (fmap h gt)


data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
    deriving Show

instance Functor GoatLord where
    fmap f NoGoat = NoGoat
    fmap f (OneGoat a) = OneGoat (f a)
    fmap f (MoreGoats a b c) = MoreGoats (fmap f a) (fmap f b) (fmap f c)


data TalkToMe a = Halt | Print String a | Read (String -> a)

instance (Show a) => Show (TalkToMe a) where
    show (Halt) = "Halt"
    show (Print s x) = show s ++ " " ++ show x
    show (Read f) = "ceva"

instance Functor TalkToMe where
    fmap f Halt = Halt
    fmap f (Print s a) = Print s (f a)
    fmap f (Read h) = Read (f . h)
