-- criar módulo para o player
module Player ( initialPlayerPosition, inputPlayer ) where

-- importar dependências
import Graphics.Gloss (Point)
import System.Random
import qualified Data.Map.Strict as Map
import Graphics.Gloss.Interface.Pure.Game
    ( Event(EventKey),
      Key(SpecialKey),
      KeyState(Down),
      SpecialKey(KeyRight, KeyUp, KeyDown, KeyLeft) )
import Types ( Position, CellState(..), GameMap, GameState(..), Direction(..) )

updatePlayer :: GameState -> Direction -> GameState
updatePlayer gameState direction =
    let (curX, curY) = playerPosition gameState
        newPosition =
            case direction of
                DirUp    -> (curX, curY + 1)
                DirDown  -> (curX, curY - 1)
                DirLeft  -> (curX - 1, curY)
                DirRight -> (curX + 1, curY)
    in gameState { playerPosition = newPosition }

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
    printStrLn
    return $ positions !! randomIndex

findEmptyCells :: GameMap -> [Position]
findEmptyCells gameMap = [pos | (pos, cellState) <- Map.toList gameMap, cellState == Empty]

isGoalCell :: Position -> Bool
isGoalCell (x, y) = undefined

isMonsterCell :: Position -> Bool
isMonsterCell (x, y) = undefined

isWallCell :: Position -> Bool
isWallCell (x, y) = undefined

-- criar função que desenha o player na tela, recebendo GameState
--  e chamando as funções de desenho