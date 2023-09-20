module Map (displayGameMap) where

import qualified Data.Map.Strict as M

import Types (CellState (..), GameState (..))

import Graphics.Gloss
    ( black,
      Color,
      green,
      white,
      color,
      pictures,
      rectangleSolid,
      translate,
      Picture )


-- Definir aqui o Mapa Obrigatorio
-- a :: GameState
-- a = let
--     mwidth = 40
--     mheight = 40
--     maze = mkMaze mwidth mheight
--     fullMaze = genMaze maze (0, 0) (R.mkStdGen 100)
--     gs = GameState { 
--       gameMap = fullMaze, width = mwidth, height = mheight, playerPosition = (0, 0), enemyPosition = (0, 0) 
--     }
--   in gs

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
  pictures [translate (fromIntegral x * cellSize) (fromIntegral y * cellSize) (cellStateToPicture cellState)
            | ((x, y), cellState) <- gameMapWithCoords]
  where
    gameMapWithCoords = [((x, y), M.findWithDefault Wall (x, y) (gameMap gameState))
                         | x <- [0 .. width gameState - 1],
                           y <- [0 .. height gameState - 1]]

--main :: IO ()
--main = do
--    let gameState = a  -- Assuming 'a' is your GameState initialization
--    display (InWindow "Game Map" (1980, 1020) (0, 0)) white (displayGameMap gameState)
