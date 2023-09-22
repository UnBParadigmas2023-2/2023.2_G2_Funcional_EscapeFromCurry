module Monster (nextPositionBFS) where

import qualified Data.Map as Map
import qualified Data.Sequence as Seq
import Types (CellState (..), GameMap, GameState (..), Position, neighborsFor)

validPosition :: GameMap -> Map.Map Position Position -> Position -> Bool
validPosition gameMap father currentPosition =
    case Map.lookup currentPosition gameMap of
        Just wall -> (wall == Empty || wall == Goal) &&
            case Map.lookup currentPosition father of
                Just _ -> False
                Nothing -> True  
        Nothing -> False 

bfs :: GameState ->  [Position] ->  Map.Map Position Position -> Map.Map Position Position
bfs  _ [] father = father
bfs gameState (v:xs) father = 
    let validNeighbors = filter (validPosition (gameMap gameState) father) $ neighborsFor v
        newFather = Map.fromList [(n, v) | n <- validNeighbors]
        newQueue = xs ++ validNeighbors
    in bfs gameState newQueue (Map.union father newFather) 
  
nextPosition :: Map.Map Position Position -> Position -> Position -> Position -> Position
nextPosition father currentPosition monsterPosition playerPosition =
  case Map.lookup currentPosition father of
    Just fatherPosition
      | fatherPosition == monsterPosition -> currentPosition
      | otherwise -> nextPosition father fatherPosition monsterPosition playerPosition
    Nothing -> monsterPosition 

nextPositionBFS :: Position -> Position -> GameState -> Position
nextPositionBFS str fin gameState =
  let defaultFather = Map.singleton (str) (666, 666)
      bfsResult = bfs gameState [str] defaultFather
   in nextPosition bfsResult (fin) (str) (fin)

data SearchNode = SearchNode
  { position :: Position
  , parent :: Maybe SearchNode
  } deriving (Eq, Show)

bfs' :: GameState -> Position -> Position -> Maybe [Position]
bfs' gs start goal = bfs'' (Seq.singleton (SearchNode start Nothing)) []
  where
    bfs'' :: Seq.Seq SearchNode -> [SearchNode] -> Maybe [Position]
    bfs'' queue visited =
      case Seq.viewl queue of
        Seq.EmptyL -> Nothing
        (x Seq.:< xs) ->
          if position x == goal
            then Just $ position <$> reverse (x : visited)
            else bfs'' (foldl (enqueueAdjacent x) xs (neighborsFor $ position x)) (x : visited)

    enqueueAdjacent :: SearchNode -> Seq.Seq SearchNode -> Position -> Seq.Seq SearchNode
    enqueueAdjacent parent' queue neighbor =
      if Just Empty == neighbor `Map.lookup` gameMap gs && notElem neighbor (position <$> queue)
        then queue Seq.|> SearchNode neighbor (Just parent')
        else queue
