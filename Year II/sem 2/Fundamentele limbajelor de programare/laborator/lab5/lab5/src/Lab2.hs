{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use $>" #-}
{-# HLINT ignore "Use <$>" #-}
module Lab2 where

import Control.Applicative ( Alternative(..) )
import Data.Char ( digitToInt, isDigit, isSpace )

newtype Parser a = Parser { apply :: String -> [(a, String)] }

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser go
  where
    go [] = []   -- imposibil de parsat șirul vid
    go (c:input)
      | p c = [(c, input)]   -- dacă predicatul ține, întoarce c și restul șirului de intrare
      | otherwise = []       -- în caz contrar, imposibil de parsat

--- | Acceptă orice caracter
anychar :: Parser Char
anychar = satisfy (const True)

--- | acceptă doar caracterul dat ca argument
char :: Char -> Parser Char
char c = satisfy (== c)

--- | acceptă o cifră
digit :: Parser Char
digit = satisfy isDigit

--- | acceptă un spațiu (sau tab, sau sfârșit de linie -- vedeți funcția din Data.Char )
space :: Parser Char
space = satisfy isSpace

--- | succes doar dacă am șirul de intrare este vid 
endOfInput :: Parser ()
endOfInput  = Parser go
  where
    go "" = [((), "")]
    go _ = []

instance Functor Parser where
    fmap f pa = Parser (\input -> [(f a, rest) | (a, rest) <- apply pa input])

instance Applicative Parser where
    pure a = Parser (\input -> [(a, input)])
    pf <*> pa = Parser (\input -> [(f a, resta) | (f, restf) <- apply pf input, (a, resta) <- apply pa restf])

parse :: Parser a -> String -> Either String a
parse p str
  | [(one, "")] <- candidates
  = Right one
  | otherwise
  = Left "Sirul de intrare nu a fost complet consumat sau parsare ambigua"
  where
    candidates = apply (p <* endOfInput) str

instance Monad Parser where
    pa >>= k = Parser (\input -> [(b, restb) | (a, resta) <- apply pa input, (b, restb) <- apply (k a) resta])

cifraSemn :: Parser Int
cifraSemn
  = do
    ch <- satisfy (`elem` "+-")
    d <- digitToInt <$> digit
    case ch of
      '-' -> return (-d)
      _ -> return d

cifraSemnApp :: Parser Int
cifraSemnApp = pure convert <*> satisfy (`elem` "+-") <*> (digitToInt <$> digit)
  where
    convert '+' d = d
    convert '-' d = -d

string :: String -> Parser String
string [] = return [] 
string (ch:s) = pure (:) <*> char ch <*> string s
-- și bineînțeles că merge și ca un foldr

instance Alternative Parser where
    empty = Parser (const [])
    p <|> p' = Parser (\input -> apply p input ++ apply p' input)

string2Int :: String -> Int
string2Int = foldl (\n d -> 10 * n + digitToInt d) 0

naiveNatural :: Parser Int
naiveNatural = string2Int <$> naiveNat
  where
    naiveNat = pure (:) <*> digit <*> naiveNat
            <|> pure (:[]) <*> digit

-- | Elimină zero sau mai multe apariții ale lui `space`
whiteSpace :: Parser ()
whiteSpace = many space *> return ()

-- | parses a natural number (one or more digits)
nat :: Parser Int
nat = string2Int <$> some digit

-- | aplică un parser, și elimină spațiile de după
lexeme :: Parser a -> Parser a
lexeme p = p <* whiteSpace

-- | parses a natural number and skips the space after it
natural :: Parser Int
natural = lexeme nat

-- | Parses the string and skips whiteSpace after it
symbol :: String -> Parser String
symbol = lexeme . string

-- | Parses the string, skips whiteSpace, returns unit
reserved :: String -> Parser ()
reserved s = symbol s *> return ()

-- | parsează virgulă, eliminând spațiile de după
comma :: Parser ()
comma = reserved ","

-- | parsează argumentul intre paranteze rotunde
--   elimină spațiile de după paranteze
parens :: Parser a -> Parser a
parens p = reserved "(" *> p <* reserved ")"

-- | parsează argumentul intre paranteze pătrate
--   elimină spațiile de după paranteze
brackets :: Parser a -> Parser a
brackets p = reserved "[" *> p <* reserved "]"

-- | una sau mai multe instanțe, separate de virgulă,
--   cu eliminarea spațiilor de după fiecare virgulă
--   intoarce lista obiectelor parsate
commaSep1 :: Parser a -> Parser [a]
commaSep1 p
  = do
    a <- p
    as <- many (comma *> p)
    return (a : as)

-- | zero sau mai multe instanțe, separate de virgulă,
--   cu eliminarea spațiilor de după fiecare virgulă
--   intoarce lista obiectelor parsate
commaSep :: Parser a -> Parser [a]
commaSep p = commaSep1 p <|> pure []

-- | date fiind parsere pentru prima literă si pentru felul literelor următoare
--   scrieți un parser pentru un identificator
ident :: Parser Char -> Parser Char -> Parser String
ident identStart identLetter
  = do
    s <- identStart
    ls <- many identLetter
    return (s:ls)

-- | ca mai sus, dar elimină spatiile de după
identifier :: Parser Char -> Parser Char -> Parser String
identifier start letter = lexeme (ident start letter)

