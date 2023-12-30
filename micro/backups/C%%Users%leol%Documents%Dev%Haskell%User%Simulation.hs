import Prelude hiding (init)
import System.Environment

{-
	Planet 1
	pos: 0, 10
	vel: 1.7, 0
	acc: 0, -0.289
	k: 3.4969

	Planet 2:
	pos: 0, -1
	vel: -0.17, 0
	acc: 0, 0.0289
	k: 34.969
-}


-- init = (0, [(Vec2 0 10, Vec2 1.7 0, Vec2 0 (-0.289), 3.4969), (Vec2 0 (-1), Vec2 (-0.17) 0, Vec2 0 0.0289, 34.969)])

-- : Structures

data Vec2 = Vec2 Double Double deriving (Show, Read, Eq)

type Object = (Vec2, Vec2, Vec2, Double)

type State = (Double, [Object])

--Vector Operations

(.+) :: Vec2 -> Vec2 -> Vec2
(Vec2 x1 y1) .+ (Vec2 x2 y2) = Vec2 (x1 + x2) (y1 + y2)
infixl 6 .+

(.*) :: Double -> Vec2 -> Vec2
a .* (Vec2 x y) = Vec2 (a*x) (a*y)
infixl 7 .*

(.#) :: Vec2 -> Vec2 -> Double
(Vec2 x1 y1) .# (Vec2 x2 y2) = (x1*x2) + (y1*y2)

-- : Definitions

init :: State
init = (0, [(Vec2 0 10, Vec2 1.7 0, Vec2 0 (-1.0106041), 3.4969), (Vec2 0 (-1), Vec2 (-0.17) 0, Vec2 0 1.0106041, 34.969)])

next :: State -> State
next (t, objects) = (t, applyForce . map resetForce $ objects)
    where
    resetForce :: Object -> Object
    resetForce (p, v, _, k) = (p, v, Vec2 0 0, k)
    
    applyForce :: [Object] -> [Object]
    applyForce [] = []
    applyForce (obj:objs) = done : applyForce partial
        where
        (done, partial) = apply obj objs
    
    apply :: Object -> [Object] -> (Object, [Object])
    apply x [] = (x, [])
    apply x (y:ys) = (x', y' : ys')
        where
        (pos1, v1, f1, k1) = x
        (pos2, v2, f2, k2) = y
        
        r = pos2 .+ (-1) .* pos1
        abs = r .# r
        norm = (1 / sqrt abs) .* r
        f = (k1 * k2 / abs) .* norm
        
        f1' = f1 .+ f
        f2' = f2 .+ (-1) .* f
        
        y' = (pos2, v2, f2', k2)
        (x', ys') = apply (pos1, v1, f1', k1) ys

process :: State -> State
process (t, objects) = (t + dt, map leapfrog objects)
    where
    dt = 0.1
    leapfrog (pos, v, f, k) = (pos', v', f, k)
        where
        a = (1 / k) .* f
        v' = v .+ dt .* a
        pos' = pos .+ (0.5 * dt) .* (v .+ v')

-- : Main Structure

server = map process
client init ~(resp:resps) = init : client (next resp) resps

reqs  = client init resps
resps = server reqs

main = do
    args <- getArgs
    foldr1 (>>) $ (take.read.head) args $ map print resps
    -- foldr (>>) (return ()) $ (take $ head args) . (map print) $ resps
