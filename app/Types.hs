module Types where

import

data CellState
  = Wall
  | Goal
  | Empty

type GameState = 
  { gameMap :: map Position CellState
  , playerPosition :: Position
  , enemyPosition :: Position
  }

type Position = (Int, Int)