
module Main where

import System.IO

import Lab2
import Exp
import Parsing
import Sugar
import Eval
import Printing
import REPLCommand
import Program

{-
main :: IO ()
main
  = do
    putStrLn $ show ex1
    putStrLn $ show ex2
    putStrLn $ show ex3
    putStrLn "-----------"
    putStrLn $ show ex4
    putStrLn $ show ex5
    putStrLn "-----------"
    putStrLn $ show ex6
    putStrLn "-----------"
    putStrLn $ show ex7
  where
    ex1 = parseFirst definition "id := \\x -> x"
    ex2 = parseFirst definition "id x := x"
    ex3 = parseFirst definition "const x y := x"

    ex4 = parseFirst program "id x := x; const x y := x"
    ex5 = parseFirst program "id x := x; const x y := x;"
    
    ex6 = definitionExp (Definition {defHead = Var {getVar = "const"}, defArgs = [Var {getVar = "x"},Var {getVar = "y"}], defBody = CX (Var {getVar = "x"})})
    ex7 = programEnv [Definition {defHead = Var {getVar = "const"}, defArgs = [Var {getVar = "x"},Var {getVar = "y"}], defBody = CX (Var {getVar = "x"})},
                  Definition {defHead = Var {getVar = "id"}, defArgs = [Var {getVar = "x"}], defBody = CX (Var {getVar = "x"})}]
-}

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

{-
execute :: Environment -> IO ()
execute env
  = do
    putStr "miniHaskell> "
    hFlush stdout
    s <- getLine
    case parseFirst replCommand s of
          Nothing -> putStrLn "Cannot parse command" >> execute env
          Just Quit -> return ()
          Just (Load file) -> 
            do
              content <- parseFromFile program file
              case content of
                Left error -> putStrLn error >> (execute env)
                Right definitions -> putStrLn "Loaded." >> execute (programEnv definitions)
          Just (Eval es) ->
            case parseFirst exprParser es of
              Nothing -> putStrLn "Error: cannot parse expression" >> execute env 
              Just e ->
                let simpleE = desugarExp e
                    simpleE' = (normalizeEnv env) simpleE
                    e' = sugarExp simpleE'
                 in putStrLn (showExp e') >> execute env

main :: IO ()
main = execute mempty
-}