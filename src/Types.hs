{-# LANGUAGE LambdaCase #-}

module Types (CellState (..), GameState (..), GameMap, Position, Direction (..), PlayingState (..), directions, offsets, neighborsFor) where

import qualified Data.Map.Strict as Map

data CellState
  = Wall
  | Goal
  | Empty
  deriving (Eq)

data Direction
  = DirUp
  | DirRight
  | DirDown
  | DirLeft
  | DirNone
  deriving (Eq, Ord, Show)

directions :: [Direction]
directions = [DirUp, DirRight, DirDown, DirLeft]

directionOffset :: Direction -> Position
directionOffset = \case
  DirUp -> (0, -1)
  DirRight -> (1, 0)
  DirDown -> (0, 1)
  DirLeft -> (-1, 0)

offsets :: [Position]
offsets = map directionOffset directions

neighborsFor :: Position -> [Position]
neighborsFor p = map (addTuples p . directionOffset) directions
  where
    addTuples (x, y) (x', y') = (x + x', y + y')

type Position = (Int, Int)

type GameMap = Map.Map Position CellState

data PlayingState
  = Playing
  | Lost
  | Won
  deriving (Eq)

data GameState = GameState
  { gameMap :: GameMap
  , width :: Int
  , height :: Int
  , playerPosition :: Position
  , enemyPosition :: Position
  , playingState :: PlayingState
  , playerDirection :: Direction
  }
