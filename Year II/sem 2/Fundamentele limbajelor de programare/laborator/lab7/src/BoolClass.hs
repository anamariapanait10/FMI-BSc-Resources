module BoolClass where

import Prelude (Show (..), (<>), undefined) -- for show instances
import qualified Data.Bool as Bool

import MyPrelude

-- | The class of Boolean-like types (types having a notion of
-- 'true' and 'false' and 'bool'ean choice).
-- Instances should satisfy the following:
--
-- [Bool True] @'bool' f t 'true' = t@
-- [Bool False]  @'bool' f t 'false' = f@
class BoolClass b where
  false :: b
  true :: b
  bool :: a -> a -> b -> a

instance BoolClass Bool.Bool where
  true = Bool.True
  false = Bool.False
  bool = Bool.bool

-- | if-then-else
ite :: BoolClass b => b -> a -> a -> a
ite b a1 a2 = bool a2 a1 b 

-- >>> ite (true :: Bool.Bool) 1 2
-- 1

-- | Boolean "and"
(&&) :: BoolClass b => b -> b -> b
(&&) b1 b2 = ite b1 (ite b2 true false) false

-- >>> true && false :: Bool.Bool
-- False

-- | Boolean "or",
(||) :: BoolClass b => b -> b -> b
(||) b1 b2 = ite b1 true (ite b2 true false)
-- >>> true || false :: Bool.Bool
-- True

-- | Boolean "not"
not :: BoolClass b => b -> b
not b1 = ite b1 false true


-- >>>  not true :: Bool.Bool
-- False

newtype CBool = CBool { getCBool :: forall a. a -> a -> a}

instance BoolClass CBool where
  true = CBool(\x y -> y)
  false = CBool(\x y -> x)
  bool f t b = getCBool b f t

-- >>> ite (true :: CBool) 1 2
-- 1

-- | converting between different instances of 'BoolClass'
fromBoolClass :: (BoolClass a, BoolClass b) => a -> b
fromBoolClass = bool false true

-- | 'Show' instance for 'CBool' (via transformation into Haskell Bool)
instance Show CBool where
  show cb = "C" <> show (fromBoolClass cb :: Bool.Bool)

-- >>> true && false :: CBool
-- CFalse

-- >>> true || false :: CBool
-- CTrue

-- >>> not true :: CBool
-- CFalse
