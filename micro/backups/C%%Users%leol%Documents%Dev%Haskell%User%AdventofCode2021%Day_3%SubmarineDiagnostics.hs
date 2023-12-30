import Control.Arrow
import Control.Monad
import Data.List

parse :: [Char] -> [Bool]
parse = map (== '1')

todecimal :: [Bool] -> Integer
todecimal [] = 0
todecimal (j:js)
    | j = 2 ^ length js + todecimal js
    | otherwise = todecimal js


count :: [[Bool]] -> [(Integer, Integer)]
count = map (foldr (\j -> if j then first (+1) else second (+1)) (0, 0)) . transpose

gamma = map (liftM2 (>) fst snd)

epsilon = map (liftM2 (<) fst snd)

main = interact $ show . uncurry (*) . join (***) todecimal . (gamma &&& epsilon) . count . map parse . lines
