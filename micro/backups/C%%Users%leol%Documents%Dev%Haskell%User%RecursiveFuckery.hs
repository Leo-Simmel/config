fix f = let x = f x in x


iterate' f x = x : iterate' f (f x)

iterate'' f = fix (\g x -> x : g f (f x))


until' j f x
    | j x       = x
    | otherwise = until' j f (f x)

until'' j f = fix (g x -> if j x then x else g (f x))

replicate' n = take n . repeat

compose n f = foldr (.) id $ take n . repeat $ f

compose' n f = (!!n) . iterate f
