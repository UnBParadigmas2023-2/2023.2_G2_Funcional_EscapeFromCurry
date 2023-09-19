module Monster () where

import Types ( GameState, Position, CellState (..), GameMap, neighborsFor )

import qualified Data.Map as Map

validPosition :: GameMap -> Map.Map Position Position -> Position -> Bool
validPosition gameMap father currentPosition =
    case Map.lookup currentPosition gameMap of
        Just wall -> wall == Empty &&
            case Map.lookup currentPosition father of
                Just _ -> False  
                Nothing -> True  
        Nothing -> False 

bfs :: GameState ->  [Position] ->  Map.Map Position Position -> Map.Map Position Position
bfs  _ [] father = father
bfs gameState (v:xs) father = 
    let validNeighbors = filter (validPosition gameMap father v) neighborsFor v
        newFather = Map.fromList [(n, v) | n <- validPosition]
        newQueue = xs ++ validNeighbors
    in bfs gameState newQueue (Map.union father newFather) 
  
nextPosition :: Map.Map Position Position -> Position -> Position -> Position -> Position
nextPosition father currentPosition monsterPosition playerPosition =
  case Map.lookup currentPosition father of
    Just fatherPosition
      | fatherPosition == monsterPosition -> currentPosition
      | otherwise -> nextPosition father fatherPosition monsterPosition playerPosition
    Nothing -> currentPosition 

nextPositionBFS :: GameState -> Position
nextPositionBFS gameState =
  let defaultFather = Map.singleton (enemyPosition gameState) (666, 666)
      bfsResult = bfs gameState [gameState.enemyPosition] defaultFather
  in nextPosition bfsResult gameState.playerPosition gameState.enemyPosition gameState.playerPosition
