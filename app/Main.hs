module Main (main) where

import Generator
import Graphics.Gloss
import Map
import qualified System.Random as R
import Types

a :: GameState
a =
  let mwidth = 40
      mheight = 40
      maze = mkMaze mwidth mheight
      fullMaze = genMaze maze (0, 0) (R.mkStdGen 100)
      gs =
        GameState
          { gameMap = fullMaze,
            width = mwidth,
            height = mheight,
            playerPosition = (0, 0),
            enemyPosition = (0, 0)
          }
   in gs

main :: IO ()
main = display (InWindow "Game Map" (19980, 1020) (0, 0)) white (displayGameMap a)
