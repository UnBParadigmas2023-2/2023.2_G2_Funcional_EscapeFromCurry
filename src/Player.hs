module Player ( initialPlayerPosition, inputPlayer ) where

import Graphics.Gloss (Point)
import System.Random
import qualified Data.Map.Strict as Map
import Graphics.Gloss.Interface.Pure.Game
    ( Event(EventKey),
      Key(SpecialKey),
      KeyState(Down),
      SpecialKey(KeyRight, KeyUp, KeyDown, KeyLeft) )
import Types ( Position, CellState(..), GameMap, GameState(..), Direction(..) )

-- recebe gamestate e direction do movimento, retorna um gamestate com a nova posição do player (validada)
updatePlayer :: GameState -> Direction -> GameState
updatePlayer gameState direction = undefined

inputPlayer :: Event -> GameState -> GameState
inputPlayer (EventKey (SpecialKey KeyUp) Down _ _) gameState = updatePlayer gameState DirUp
inputPlayer (EventKey (SpecialKey KeyDown) Down _ _) gameState = updatePlayer gameState DirDown
inputPlayer (EventKey (SpecialKey KeyLeft) Down _ _) gameState = updatePlayer gameState DirLeft
inputPlayer (EventKey (SpecialKey KeyRight) Down _ _) gameState = updatePlayer gameState DirRight
inputPlayer _ gameState = gameState 

initialPlayerPosition :: GameMap -> Position
initialPlayerPosition gameMap = do
    let emptyCellPositions = findEmptyCells gameMap
    playerPosition <- getRandomPosition emptyCellPositions
    return $ playerPosition

getRandomPosition :: [Position] -> Position
getRandomPosition positions = do
    randomIndex <- randomRIO (0, length positions - 1)
    return $ positions !! randomIndex

findEmptyCells :: GameMap -> [Position]
findEmptyCells gameMap = [pos | (pos, cellState) <- Map.toList gameMap, cellState == Empty]

isGoalCell :: Position -> Bool
isGoalCell (x, y) = undefined

isMonsterCell :: Position -> Bool
isMonsterCell (x, y) = undefined

isWallCell :: Position -> Bool
isWallCell (x, y) = undefined

-- criar função de desenho do player na tela

-- completar funções que validam a próxima posição