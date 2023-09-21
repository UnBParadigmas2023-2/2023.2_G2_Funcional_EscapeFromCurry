module Player ( inputPlayer ) where

import Graphics.Gloss (Point)
import System.Random
import qualified Data.Map.Strict as Map
import Graphics.Gloss.Interface.Pure.Game
    ( Event(EventKey),
      Key(SpecialKey),
      KeyState(Down),
      SpecialKey(KeyRight, KeyUp, KeyDown, KeyLeft) )
import Types ( Position, CellState(..), GameMap, GameState(..), Direction(..), PlayingState(..) )
import Control.Monad.Cont

-- recebe gamestate e direction do movimento, retorna um gamestate com a nova posição do player (validada)
updatePlayer :: GameState -> Direction -> GameState
updatePlayer gameState direction =
    let currentPosition = playerPosition gameState
        newPosition = case direction of
            DirUp -> (fst currentPosition, snd currentPosition + 1)
            DirDown -> (fst currentPosition, snd currentPosition - 1)
            DirLeft -> (fst currentPosition - 1, snd currentPosition)
            DirRight -> (fst currentPosition + 1, snd currentPosition )
    in
    if isWallCell (gameMap gameState) newPosition
        then gameState  -- Não é possível se mover para uma parede
    else if isMonsterCell gameState newPosition
        then gameState { playingState = Lost }
     else if isGoalCell (gameMap gameState) newPosition
        then gameState { playingState = Won }
    else gameState { playerPosition = newPosition }

inputPlayer :: Event -> GameState -> GameState
inputPlayer (EventKey (SpecialKey KeyUp) Down _ _) gameState = updatePlayer gameState DirUp
inputPlayer (EventKey (SpecialKey KeyDown) Down _ _) gameState = updatePlayer gameState DirDown
inputPlayer (EventKey (SpecialKey KeyLeft) Down _ _) gameState = updatePlayer gameState DirLeft
inputPlayer (EventKey (SpecialKey KeyRight) Down _ _) gameState = updatePlayer gameState DirRight
inputPlayer _ gameState = gameState 

isGoalCell :: GameMap -> Position -> Bool
isGoalCell gameMap (x, y) =
    case Map.lookup (x, y) gameMap of
        Just cellState -> cellState == Goal
        Nothing -> False 

isMonsterCell :: GameState -> Position -> Bool
isMonsterCell gameState position =
    position == enemyPosition gameState

isWallCell :: GameMap -> Position -> Bool
isWallCell gameMap (x, y) =
    case Map.lookup (x, y) gameMap of
        Just cellState -> cellState == Wall
        Nothing -> False  -- Se a posição não estiver no mapa, não é uma parede
-- criar função de desenho do player na tela

-- completar funções que validam a próxima posição