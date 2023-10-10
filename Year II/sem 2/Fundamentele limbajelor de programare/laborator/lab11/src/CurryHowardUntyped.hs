import Prelude (undefined)
import Distribution.Compat.Lens (_1)

newtype False = False { getFalse :: forall t. t }
newtype True = True { getTrue :: forall t . t -> t }
newtype And a b = And { getAnd :: forall t. (a -> b -> t) -> t }
newtype Or a b = Or { getOr :: forall t . (a -> t) -> (b -> t) -> t}
type Not a = a -> False
type Iff a b = And (a -> b) (b -> a)


-- Natural deduction introduction and elimination rules

trueIntro :: True                                   -- true introduction
trueIntro = True (\x -> x)

falseElim :: False -> b                             -- false elimination
falseElim f = getFalse f 

implIntro :: (a -> b) -> (a -> b)                   -- implication introduction
implIntro p = \x -> p x

implElim :: (a -> b) -> a -> b                      -- implication elimination
implElim f x = f x

andIntro :: a -> b -> And a b                       -- and introduction
andIntro x y = And (\f -> f x y)

andElimL :: And a b -> a                            -- and elimination 1
andElimL (And f) = f (\x _ -> x)

andElimR :: And a b -> b                            -- and elimination 2
andElimR (And f) = f (\_ y -> y)

orIntroL :: a -> Or a b                             -- or introduction 1
orIntroL x = Or (\f _ -> f x)

orIntroR :: b -> Or a b                             -- or introduction 2
orIntroR y = Or (\_ f -> f y)

orElim :: Or a b -> (a -> c) -> (b -> c) -> c       -- or elimination
orElim (Or f) g h = f g h

notElim :: Not p -> p -> c                          -- not elimination 
notElim f x = falseElim (f x)

notIntro :: (forall p. a -> p) -> Not a             -- not introduction
notIntro f = \x -> f x x

iffIntro :: (a -> b) -> (b -> a) -> Iff a b         -- iff introduction
iffIntro f g = andIntro (\x -> f x) (\y -> g y)

iffElimL :: Iff a b -> a -> b                       -- iff elimination 1
iffElimL (And f) x = f (\y _ -> y) x

iffElimR :: Iff a b -> b -> a                       -- iff elimination 1
iffElimR (And f) y = f (\_ z -> z) y

-- Hilbert-style axiomatization for intuitionistic propositional logic

ax1 :: a -> b -> a
ax1 x y = x

ax2 :: (a -> b) -> (a -> (b -> c)) -> a -> c
ax2 f g x = g x (f x)

ax3 :: a -> b -> And a b
ax3 x y = andIntro x y

ax4 :: And a b -> a
ax4 (And f) = f (\x _ -> x)

ax5 :: And a b -> b
ax5 (And f) = f (\_ y -> y)

ax6 :: a -> Or a b
ax6 x = orIntroL x

ax7 :: b -> Or a b
ax7 y = orIntroR y

ax8 :: (a -> c) -> (b -> c) -> Or a b -> c
ax8 f g (Or h) = h f g

ax9 :: (a -> b) -> (a -> Not b) -> Not a
ax9 f g = notIntro (\x -> notElim (g x) (f x))

ax10 :: Not a -> a -> b
ax10 f x = falseElim (f x)

modusPonens :: (a -> b) -> a -> b
modusPonens f x = f x

-- Several tautologies

pNPFalse :: p -> Not p -> False
pNPFalse p np = np p
