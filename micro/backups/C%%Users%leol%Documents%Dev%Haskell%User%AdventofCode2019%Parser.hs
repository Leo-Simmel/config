module Parser (
    Parser(runParser),
    sepBy,
    notNull,
    spanP,
    charP,
    stringP,
    ) where

import Control.Applicative
import Data.List
import Data.Tuple

newtype Parser a = Parser {runParser :: String -> Maybe (String, a)}

instance Applicative Parser where
    pure x = Parser $ \input -> Just (input, x)
    (Parser p1) <*> (Parser p2) = Parser $ \input -> do
    (input', f)  <- p1 input
    (input'', a) <- p2 input'
    return (input'', f a)

instance Functor Parser where
    fmap = liftA

instance Alternative Parser where
    empty = Parser $ const Nothing
    (Parser p1) <|> (Parser p2) = Parser $ liftA2 (<|>) p1 p2

sepBy :: Parser a -> Parser b -> Parser [b]
sepBy sep element = liftA2 (:) element (many (sep *> element)) <|> pure []  -- almost looks like many definition

notNull :: Parser [a] -> Parser [a]
notNull (Parser p) = Parser $ \input -> do
    (input', xs) <- p input
    if null xs then Nothing else return (input', xs)

spanP :: (Char -> Bool) -> Parser String
spanP p = Parser $ Just . swap . span p

charP :: Char -> Parser Char
charP x = Parser f where
    f (y:ys) | y == x = Just (ys, x)
    f _ = Nothing

stringP :: String -> Parser String
stringP = sequenceA . map charP

