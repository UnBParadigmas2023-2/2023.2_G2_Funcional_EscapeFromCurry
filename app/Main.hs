module Main (main) where

import Graphics.Gloss
import Game
import Types
import Data.Time.Clock.POSIX

main :: IO ()
main = do
  initialTime <- getPOSIXTime
  let gs = verifyInitialGame (round (initialTime * 100)) Easy

  play
    (InWindow "Escape From Curry" (1200, 840) (0, 0))
    white
    fps
    gs
    drawGame
    handleInput
    updateGame

