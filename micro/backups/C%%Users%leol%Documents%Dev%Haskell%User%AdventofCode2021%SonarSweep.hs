import System.IO
import System.Environment

increase :: [Int] -> Int
increase x = foldr1 (+) $ map (\(x,y) -> if x < y then 1 else 0) $ zip x (tail x)

increase' x = foldr1 (+) [ 1 | (a,b) <- zip x (tail x), a < b]


main = do
    args <- getArgs
    text <- readFile.head $ args
    print.increase $ map (read::String->Int) (lines text)
