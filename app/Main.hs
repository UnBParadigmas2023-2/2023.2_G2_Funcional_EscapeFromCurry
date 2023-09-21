module Main (main) where

import Graphics.Gloss
import qualified System.Random as R
import Game
import Data.Time.Clock.POSIX

main :: IO ()
main = do
  currentTime <- getPOSIXTime

  let gs = initializeGame . R.mkStdGen $ round (currentTime * 1000)

  play
    (InWindow "Escape From Curry" (800, 800) (0, 0))
    white
    fps
    gs
    drawGame
    handleInput
    updateGame

