module MaybeClass where

import Prelude (Show(..), (<>), undefined) -- for show instances
import qualified Data.Maybe as Maybe
import qualified Data.Bool as Bool -- for testing

import MyPrelude
import BoolClass

-- | The class of Maybe-like types (types having a notion of
-- 'nothing' (no value) and 'just' (some value) and way to
-- apply a function on such a value (using a default value).
-- Instances should satisfy the following:
--
-- [Maybe Nothing] @'maybe' n j 'nothing' = n@
-- [Maybe Just]  @'maybe' n j ('just' x ) = j x@
class MaybeClass m where
  nothing :: m a
  just :: a -> m a
  maybe :: b -> (a -> b) -> m a -> b

instance MaybeClass Maybe.Maybe where 
  nothing = Maybe.Nothing
  just = Maybe.Just
  maybe = Maybe.maybe

-- | The 'fromMaybe' function takes a default value and a 'MaybeClass' value.
-- If the 'MaybeClass' is 'nothing', it returns the default value;
-- otherwise, it returns the value contained in the 'MaybeClass'.
fromMaybe :: (MaybeClass m) => a -> m a -> a
fromMaybe  def m = maybe def id m

-- >>> fromMaybe true (just false :: Maybe.Maybe Bool.Bool)
-- False

-- >>> fromMaybe true (nothing :: Maybe.Maybe Bool.Bool)
-- True

-- | The isNothing function returns 'true' iff its argument is 'nothing'.
isNothing :: (MaybeClass m, BoolClass b) => m a -> b
isNothing m = maybe true (const false) m

-- >>> isNothing (nothing :: Maybe.Maybe a) :: Bool.Bool
-- True

-- | The isJust function returns 'true' iff its argument is of the form @'just' _@.
isJust :: (MaybeClass m, BoolClass b) => m a -> b
isJust m = maybe false (const true) m

-- >>> isJust (nothing :: Maybe.Maybe a) :: Bool.Bool
-- False

-- | The 'Functor' instance for 'MaybeClass'
maybeFMap :: MaybeClass m => (a -> b) -> m a -> m b
maybeFMap f x = maybe nothing (just . f) x

-- >>> maybeFMap not (just true) :: Maybe.Maybe Bool.Bool
-- Just False

-- | The 'Monad' instance for 'MaybeClass'
maybeBind :: MaybeClass m => (a -> m b) -> m a -> m b
maybeBind f x = maybe nothing f x

newtype CMaybe a = CMaybe { getCMaybe :: forall b . b -> (a -> b) -> b }

instance MaybeClass CMaybe where
  nothing = CMaybe (\x _ -> x)
  just x = CMaybe (\_ j -> j x)
  maybe n j m = getCMaybe m n j

-- >>> maybeFMap not (just true) :: Maybe.Maybe Bool.Bool
-- CFalse

-- >>> fromMaybe true (nothing :: CMaybe CBool)
-- CTrue

-- >>> isNothing (nothing :: CMaybe a) :: CBool
-- CTrue

-- >>> isJust (nothing :: CMaybe a) :: CBool
-- CFalse

-- | converting between different instances of 'MaybeClass'
fromMaybeClass :: (MaybeClass m, MaybeClass n) => m a -> n a 
fromMaybeClass = maybe nothing just

-- | 'Show' instance for 'CMaybe a' (via transformation into Haskell Maybe)
instance Show a => Show (CMaybe a) where
  show cm = "C" <> show (fromMaybeClass cm :: Maybe.Maybe a)

-- >>> maybeFMap not (just true) :: CMaybe CBool
-- CJust CFalse
