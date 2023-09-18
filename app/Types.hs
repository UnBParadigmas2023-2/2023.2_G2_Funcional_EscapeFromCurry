module Types (CellState, GameState, Position) where 

import qualified Data.Map as Map

data CellState 
  = Wall 
  | Goal 
  | Empty

type Position = (Int, Int)

data GameState = GameState
  { gameMap :: Map.Map Position CellState
  , playerPosition :: Position
  , enemyPosition :: Position
  }
