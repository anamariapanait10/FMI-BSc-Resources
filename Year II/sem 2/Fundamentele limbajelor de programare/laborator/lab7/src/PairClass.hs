module PairClass where

import Prelude (Show(..), (<>), undefined, const, flip) -- for show
import qualified Data.Tuple as Tuple

import BoolClass -- for testing
import MaybeClass -- for testing

-- | The class of pair-like types (types having a notion of
-- 'pair'ing two values of different types and way to
-- apply a function of two arguments on such a pair ('uncurry'ing).
-- Instances should satisfy the following:
--
-- [Pair Uncurrying] @'uncurry' f ('pair' x y) = f x y@
class PairClass p where
  pair :: a -> b -> p a b
  uncurry :: (a -> b -> c) -> p a b -> c

instance PairClass (,) where
  pair = (,)
  uncurry = Tuple.uncurry

-- | curry converts a functio on pairs to a curried function (of two arguments).
curry :: (PairClass p) => (p a b -> c) -> a -> b -> c
curry f x y = f (pair x y)

-- | Extract the first component of a pair.
fst :: (PairClass p) => p a b -> a
fst = uncurry const

-- >>> curry (fst :: (CBool, CMaybe CBool) -> CBool) true (just false)
-- CTrue

-- | Extract the second component of a pair.
snd :: (PairClass p) => p a b -> b
snd = uncurry (flip const)

-- >>> snd (pair true (just false) :: (CBool, CMaybe CBool))
-- CJust CFalse

newtype CPair a b = CPair { getCPair :: forall c . (a -> b -> c) -> c }

instance PairClass CPair where
  uncurry f p = getCPair p f
  pair a b = CPair (\f -> f a b)

-- | converting between different instances of 'PairClass'
fromPairClass :: (PairClass p, PairClass q) => p a b -> q a b
fromPairClass = uncurry pair

-- | 'Show' instance for 'CPair a b' (via transformation into Haskell pairs)
instance (Show a, Show b) => Show (CPair a b) where
  show cp = "<" <> show (fromPairClass cp :: (a, b)) <> ">"

-- >>> curry (fst :: CPair CBool (CMaybe CBool) -> CBool) true (just false)
-- CTrue

-- >>> snd (pair true (just false) :: CPair CBool (CMaybe CBool))
-- CJust CFalse
