module Monster () where

import Types ( GameState, Position, CellState (..), GameMap )

import qualified Data.Map as Map

validPosition :: GameMap -> Position -> Bool
validPosition gameMap currentPosition =
    case Map.lookup currentPosition gameMap of
        Just current -> current == Empty
        Nothing -> False

-- insertPosition :: GameState -> [Position] -> Position -> Direction -> [Position]
-- insertPosition :: GameState -> Position -> [Position] -> [Position]
addPosition :: Position -> Position -> Position
addPosition (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

bfs :: GameState ->  [Position] ->  Map.Map Position Position -> Map.Map Position Position
bfs  _ [] father = father
bfs gameState (x:ys) father = do 
  right <- currentPosition `addPosition` directionOffset DirRight
  gameState.gameMap ! right

  
nextPosition :: Map.Map Position Position -> Position -> Position -> Position -> Position
nextPosition father currentPosition monsterPosition playerPosition
    | fatherPosition == error = monsterPosition
    | fatherPosition == monsterPosition = currentPosition
    | otherwise = nextPosition father fatherPosition monsterPosition playerPosition
  where
    fatherPosition = father ! currentPosition


nextPositionBFS :: GameState -> Position 
nextPositionBFS gameState = nextPosition ( bfs(gameState [gameState.enemyPosition] Map.empty ) gameState.playerPosition gameState.enemyPosition gameState.playerPosition)

  
