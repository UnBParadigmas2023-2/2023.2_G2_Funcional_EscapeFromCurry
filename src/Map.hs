module Map (initialPosition, displayGameMap, cellSize) where

import qualified Data.Map.Strict as M
import Graphics.Gloss
  ( Color,
    Picture,
    black,
    blue,
    color,
    green,
    red,
    pictures,
    rectangleSolid,
    translate,
    white,
  )
import Types (CellState (..), GameState (..), Position, GameMap, GameMode(..))
import qualified Data.Map.Strict as Map
import qualified System.Random as R

cellStateToPicture :: CellState -> Picture
cellStateToPicture Wall = color wallColor $ rectangleSolid cellSize cellSize
cellStateToPicture Empty = color emptyColor $ rectangleSolid cellSize cellSize
cellStateToPicture Goal = color goalColor $ rectangleSolid cellSize cellSize

wallColor :: Color
wallColor = black

emptyColor :: Color
emptyColor = white

goalColor :: Color
goalColor = green

cellSize :: Float
cellSize = 15

displayGameMap :: GameState -> Picture
displayGameMap gameState =
  translate (-390.0) (-390.0) . pictures $
    [ translate (fromIntegral x * cellSize) (fromIntegral y * cellSize) (cellStateToPicture cellState)
      | ((x, y), cellState) <- gameMapWithCoords, shouldDraw (x, y)
    ] ++ [ translate (fromIntegral px * cellSize) (fromIntegral py * cellSize) (color blue $ rectangleSolid cellSize cellSize)]
      ++ [ translate (fromIntegral ex * cellSize) (fromIntegral ey * cellSize) (color red $ rectangleSolid cellSize cellSize)]
  where
    playerPos = playerPosition gameState
    (px, py) = playerPos
    (ex, ey) = enemyPosition gameState

    distance (x, y) = abs (px - x) + abs (py - y)
    shouldDraw pos = case gameMode gameState of
      Easy -> True
      Hard -> distance pos <= 8

    gameMapWithCoords =
      [ ((x, y), M.findWithDefault Wall (x, y) (gameMap gameState))
        | x <- [0 .. width gameState - 1],
          y <- [0 .. height gameState - 1]
      ]

initialPosition :: GameMap -> R.StdGen -> (Position, R.StdGen)
initialPosition gameMap' = getRandomPosition (findEmptyCells gameMap')

getRandomPosition :: [Position] -> R.StdGen -> (Position, R.StdGen)
getRandomPosition positions s = (positions !! randomIndex, s')
  where (randomIndex, s') = R.randomR (0, length positions - 1) s

findEmptyCells :: GameMap -> [Position]
findEmptyCells gameMap' = [pos | (pos, cellState) <- Map.toList gameMap', cellState == Empty]
