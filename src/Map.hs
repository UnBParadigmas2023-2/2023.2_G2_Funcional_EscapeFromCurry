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
import Types (CellState (..), GameState (..), Position, GameMap)
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
  translate (-400.0) (-400.0) . pictures $
    [ translate (fromIntegral x * cellSize) (fromIntegral y * cellSize) (cellStateToPicture cellState)
      | ((x, y), cellState) <- gameMapWithCoords
    ] ++ [ translate (fromIntegral px * cellSize) (fromIntegral py * cellSize) (color blue $ rectangleSolid cellSize cellSize)]
      ++ [ translate (fromIntegral ex * cellSize) (fromIntegral ey * cellSize) (color red $ rectangleSolid cellSize cellSize)]
  where
    playerPos = playerPosition gameState
    (px, py) = playerPos
    (ex, ey) = enemyPosition gameState

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
