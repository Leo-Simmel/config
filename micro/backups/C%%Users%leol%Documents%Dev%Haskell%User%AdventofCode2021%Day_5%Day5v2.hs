import Control.Arrow
import Control.Monad
import Data.Char
import Data.Function
import Data.List
import Data.List.Split

type Point = (Integer, Integer)
type Line = (Point, Point)
type Field = [[Integer]]

parse :: [String] -> [Line]
parse = map $ pack . map (pack . map read . splitOn ",") . splitOn " -> "
    where pack = \(a:b:[]) -> (a, b)

getPoints :: Point -> Point -> [Point]
getPoints (x1, y1) (x2, y2)
    | dX == 0 && dY == 0 = return (x1, y1)
    | otherwise = map ((x1+) . (sX*) &&& (y1+) . (sY*)) [0..steps]
  where
    dX = x2 - x1
    dY = y2 - y1
    steps = gcd (abs dX) (abs dY)
    sX = dX `quot` steps
    sY = dY `quot` steps

replace :: Integer -> (a -> a) -> [a] -> [a]
replace 0 f (x:xs) = f x : xs
replace n f (x:xs) = x : replace (n-1) f xs

replaceGrid :: Integer -> Integer -> (a -> a) -> [[a]] -> [[a]]
replaceGrid m n f = replace m (replace n f)

subGrid :: Integer -> Integer -> [[a]] -> [[a]]
subGrid m n = map (genericTake n) . genericTake m

applyLine :: [Point] -> Field -> Field
applyLine = flip . foldr $ flip (uncurry replaceGrid) (+1)

applyGrid :: [Line] -> Field
applyGrid = foldr (applyLine . uncurry getPoints) $ repeat (repeat 0)

countPoints :: Field -> Int
countPoints = length . concat . (map . filter $ (>=2))

boundingPoint :: [Point] -> Point
boundingPoint = foldr (max . fst) 0 &&& foldr (max . snd) 0

allPoints = (concat .) $ map . uncurry $ (. return) . (:)

part1 = part2 . (filter . uncurry $ (\(x1, y1) (x2, y2) -> x1 == x2 || y1 == y2))

part2 = ((unlines . map show) .) $ (uncurry subGrid . boundingPoint . allPoints) <*> applyGrid

main = interact $ part1 . parse . lines
