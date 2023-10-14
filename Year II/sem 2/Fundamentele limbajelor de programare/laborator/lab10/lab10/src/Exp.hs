
module Exp where

import Numeric.Natural

newtype Var = Var { getVar :: String }
  deriving (Show)

data ComplexExp                         --  ComplexExp ::= "(" ComplexExp ")"
  = CX Var                              --          |   Var
  | Nat Natural                           --        |   Natural
  | CLam Var ComplexExp                 --          |   "\" Var "->" ComplexExp
  | CApp ComplexExp ComplexExp          --          |   ComplexExp ComplexExp
  | Let Var ComplexExp ComplexExp       --          |   "let" Var ":=" ComplexExp "in"
  | LetRec Var ComplexExp ComplexExp    --          |   "letrec" Var ":=" ComplexExp "in"
  | List [ComplexExp]                   --          |   "[" {ComplexExp ","}* "]"
  deriving (Show)


data IndexedVar = IndexedVar
  { ivName :: String
  , ivCount :: Int
  } deriving (Eq, Read, Show, Ord)

makeIndexedVar :: String -> IndexedVar
makeIndexedVar name = IndexedVar name 0

data Exp
  = X IndexedVar
  | Lam IndexedVar Exp
  | App Exp Exp
  deriving (Show)

