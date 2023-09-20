module Map (displayGameMap) where

import qualified Data.Map.Strict as M
import Graphics.Gloss
  ( Color,
    Picture,
    black,
    color,
    green,
    pictures,
    rectangleSolid,
    translate,
    white,
  )
import Types (CellState (..), GameState (..))

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
  pictures
    [ translate (fromIntegral x * cellSize) (fromIntegral y * cellSize) (cellStateToPicture cellState)
      | ((x, y), cellState) <- gameMapWithCoords
    ]
  where
    gameMapWithCoords =
      [ ((x, y), M.findWithDefault Wall (x, y) (gameMap gameState))
        | x <- [0 .. width gameState - 1],
          y <- [0 .. height gameState - 1]
      ]

