module Main (main) where

import Graphics.Gloss
import Game

main :: IO ()
main = do
  gs <- verifyInitialGame

  play
    (InWindow "Escape From Curry" (800, 800) (0, 0))
    white
    fps
    gs
    drawGame
    handleInput
    updateGame

