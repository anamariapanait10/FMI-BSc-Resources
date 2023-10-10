
module Main where

import System.IO

import Lab2
import Exp
import Parsing
import Sugar
import Eval
import Printing
import REPLCommand

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
              Just e ->
                let simpleE = desugarExp e
                    simpleE' = normalize simpleE
                    e' = sugarExp simpleE'
                 in putStrLn (showExp e') >> main


