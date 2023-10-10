module MyPrelude where

import Prelude ()

-- | Identity function.
id :: a -> a
id a = a

-- | @'const' x y@ always evaluates to @x@, ignoring its second argument.
const :: a -> b -> a
const x _ = x

-- | @'flip' f@ takes its (first) two arguments in the reverse order of @f@.
flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x

-- | Function composition.
(.) :: (b -> c) -> (a -> b) -> a -> c
(g . f) x = g (f x)