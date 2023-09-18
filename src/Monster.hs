module Monster () where

import Types

import qualified Data.Map as Map
import qualified Data.Queue as Queue


bfs :: GameState -> Queue []  ->  Map Position Position 
bfs gameState father queue  = do 
  

nextPosition :: Map.Map Position Position -> Position -> Position -> Position -> Position
nextPosition father currentPosition monsterPosition playerPosition
    | fatherPosition == error = monsterPosition
    | fatherPosition == monsterPosition = currentPosition
    | otherwise = nextPosition father fatherPosition monsterPosition playerPosition
  where
    fatherPosition = father ! currentPosition



nextPositionBFS :: GameState -> Position 
nextPositionBFS gameState = nextPosition ( bfs(gameState [gameState.enemyPosition] Map.empty ) gameState.playerPosition gameState.enemyPosition gameState.playerPosition)

  
