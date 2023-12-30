module Intcode where

import Prelude hiding (Word)
import Parser
import Data.Array
import Data.Char
import Data.Maybe

type Opcode = Int
type Word = (Opcode, Int, Int, Int)
type Program = [Int]
type State = (Memory, Int)
type Memory = Array Int Int
-- remove halt and replace with a calculation of const, no Monoid instance
data Computation
    = Halt {run :: State -> State}
    | Comp (State -> State)

-- right associative
instance Semigroup Computation where
    (Halt x) <> _ = Halt x
    (Comp f) <> (Halt g) = Halt $ g . f
    (Comp f) <> (Comp g) = Comp $ g . f

instance Monoid Computation where
    mempty = Halt id

viewComp :: Computation -> (State -> State)
viewComp (Comp f) = f
viewComp (Halt f) = f

parseProgram :: Parser Program
parseProgram = comma `sepBy` parseInt
  where
    parseInt = read <$> notNull (spanP isDigit)
    comma = spanP isSpace *> charP ',' <* spanP isSpace

unsafeParseState :: String -> State
unsafeParseState = loadProgram . snd . fromJust . runParser parseProgram

parseAndRun instructions text = viewComp (foldr (<>) mempty instructions) . loadProgram . snd <$>  runParser parseProgram text

parseAndRunProgram = parseAndRun (repeat loadAndExecute)

loadProgram :: Program -> State
loadProgram program = (array (0, length program - 1) $ zip [0..] program, 0)

executeInstruction :: Word -> Computation
executeInstruction (1, op1, op2, _) = Comp $ \(mem, pc) -> (mem // return (pc+3, op1+op2), pc+4)
executeInstruction (2, op1, op2, _) = Comp $ \(mem, pc) -> (mem // return (pc+3, op1*op2), pc+4)
executeInstruction (99, _, _, _) = mempty

loadInstruction :: State -> Word
loadInstruction (mem, pc) = (mem!pc, mem!(pc+1), mem!(pc+2), mem!(pc+3))

loadAndExecute :: Computation
-- 
loadAndExecute = 
