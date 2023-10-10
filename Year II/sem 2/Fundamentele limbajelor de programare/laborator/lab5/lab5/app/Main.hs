
module Main where

import System.IO

import Lab2
import Exp
import Parsing
import Printing
import REPLCommand
import Sugar
import Eval


{-
main :: IO ()
main
  = do
    putStr "miniHaskell> "
    hFlush stdout
    s <- getLine
    case parseFirst replCommand s of
          Nothing -> putStrLn "Cannot parse command" >> main
          Just Quit -> return ()
          Just (Load _) -> putStrLn "Not implemented" >> main
          Just (Eval es) ->
            case parseFirst exprParser es of
              Nothing -> putStrLn "Error: cannot parse expression" >> main 
              Just e -> putStrLn (showExp e) >> main
-}

main :: IO ()
main = do
  putStrLn (show $ (desugarVar (Var "x")))
  putStrLn (show $ (sugarVar (IndexedVar "x" 0)))
  putStrLn (show $ (sugarVar (IndexedVar "x" 3)))
  putStrLn (show $ (desugarExp (CApp (CLam (Var "x") (CX (Var "y"))) (CX (Var "z")))))
  putStrLn (show $ (desugarExp (Nat 3)))
  putStrLn (show $ (desugarExp (List [CX (Var "y"), CX (Var "x")])))
  putStrLn (show $ (desugarExp (Let (Var "y") (CX (Var "x")) (CX (Var "z")))))
  putStrLn (show $ desugarExp (LetRec (Var "y") (CX (Var "x")) (CX (Var "z"))))
  putStrLn (show $ sugarExp (App (X (IndexedVar "x" 0)) (X (IndexedVar "y" 1))))
  putStrLn (show $ sugarExp (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "y", ivCount = 0}))) (X (IndexedVar {ivName = "z", ivCount = 0}))))
  putStrLn (show $ vars (Lam (makeIndexedVar "x") (X (makeIndexedVar "y"))))
  putStrLn (show $ vars (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "y", ivCount = 0}))) (X (IndexedVar {ivName = "z", ivCount = 0}))))
  putStrLn (show $ vars (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0}))) (X (IndexedVar {ivName = "x", ivCount = 0}))))
  putStrLn (show $ freeVars (Lam (makeIndexedVar "x") (X (makeIndexedVar "y"))))
  putStrLn (show $ freeVars  (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "y", ivCount = 0}))) (X (IndexedVar {ivName = "z", ivCount = 0}))))
  putStrLn (show $ freeVars (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0}))) (X (IndexedVar {ivName = "x", ivCount = 0}))))
  putStrLn (show $ freeVars (Lam (IndexedVar {ivName = "x", ivCount = 0}) (App (X (IndexedVar {ivName = "x", ivCount = 0})) (X (IndexedVar {ivName = "x", ivCount = 0})))))
  putStrLn (show $ makeIndexedVar "x" `occursFree` Lam (makeIndexedVar "x") (X (makeIndexedVar "y")))
  putStrLn (show $ makeIndexedVar "y" `occursFree` Lam (makeIndexedVar "x") (X (makeIndexedVar "y")))
  putStrLn (show $ freshVar (makeIndexedVar "x") [makeIndexedVar "x"])
  putStrLn (show $ freshVar (makeIndexedVar "x") [makeIndexedVar "x", IndexedVar {ivName = "x", ivCount = 1}, IndexedVar {ivName = "y", ivCount = 2}])
  putStrLn (show $ renameVar (IndexedVar {ivName = "x", ivCount = 0}) (IndexedVar {ivName = "z", ivCount = 0}) (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0}))) (X (IndexedVar {ivName = "x", ivCount = 0}))))
  {-
  putStrLn (show $ substitute (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "z", ivCount = 0})) (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0}))) (X (IndexedVar {ivName = "x", ivCount = 0}))))
  putStrLn (show $ substitute (IndexedVar {ivName = "y", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0})) (App (Lam (IndexedVar {ivName = "x", ivCount = 0}) (X (IndexedVar {ivName = "y", ivCount = 0}))) (X (IndexedVar {ivName = "z", ivCount = 0}))))
  putStrLn (show $ normalize (App (Lam (IndexedVar {ivName = "y", ivCount = 0}) (X (IndexedVar {ivName = "x", ivCount = 0}))) (App (Lam (IndexedVar {ivName = "y", ivCount = 0}) (App (X (IndexedVar {ivName = "y", ivCount = 0})) (X (IndexedVar {ivName = "y", ivCount = 0})))) (Lam (IndexedVar {ivName = "y", ivCount = 0}) (App (X (IndexedVar {ivName = "y", ivCount = 0})) (X (IndexedVar {ivName = "y", ivCount = 0})))))))

-}