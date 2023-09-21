module Map (initialPosition, displayGameMap, updateGame) where

import qualified Data.Map.Strict as M
import Graphics.Gloss
  ( Color,
    Picture,
    black,
    color,
    green,
    red,
    pictures,
    rectangleSolid,
    translate,
    white,
  )
import Types (CellState (..), GameState (..), Position, GameMap, PlayingState(..))
import Monster
import Player
import qualified Data.Map.Strict as Map
import Control.Monad.IO.Class (MonadIO)
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
cellSize = 10

displayGameMap :: GameState -> Picture
displayGameMap gameState =
  translate (-400.0) (-400.0) . pictures $
    [ translate (fromIntegral x * cellSize) (fromIntegral y * cellSize) (cellStateToPicture cellState)
      | ((x, y), cellState) <- gameMapWithCoords
    ] ++ [ translate (fromIntegral px * cellSize) (fromIntegral py * cellSize) (color green $ rectangleSolid cellSize cellSize)]
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


initialPosition :: GameMap -> R.StdGen -> Position
initialPosition gameMap s = getRandomPosition (findEmptyCells gameMap) s

getRandomPosition :: [Position] -> R.StdGen -> Position
getRandomPosition positions s = positions !! randomIndex
  where (randomIndex, _) = R.randomR (0, length positions - 1) s

findEmptyCells :: GameMap -> [Position]
findEmptyCells gameMap = [pos | (pos, cellState) <- Map.toList gameMap, cellState == Empty]

updateGame :: Float -> GameState -> GameState
updateGame dt cur = newPlayer { enemyPosition = enemy, playingState = newState }
  where
    enemy = case (round dt) `mod` 10000 == 0 of
      True -> nextPositionBFS cur
      False -> enemyPosition cur
    newPlayer = updatePlayer cur
    newState = if enemy == playerPosition cur then Lost else playingState cur
