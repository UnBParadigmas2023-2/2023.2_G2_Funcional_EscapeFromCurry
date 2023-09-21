module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Message  -- Importe o módulo Message
import Time
import Types
import Map
import qualified System.Random as R
import Generator
import Player
import qualified Data.Map.Strict as M

a :: GameState
a = let
    mwidth = 40
    mheight = 40 
    maze = mkMaze mwidth mheight
    seed = R.mkStdGen 40
    fullMaze = genMaze maze (0, 0) seed
    playerPos = initialPosition fullMaze seed
    goal = (25, 35)
    withGoal = M.fromList [(goal, Goal)] `M.union` fullMaze
    gs = GameState { 
      gameMap = withGoal, width = mwidth, height = mheight, playerPosition = playerPos, enemyPosition = (10, 0),
      playingState = Playing 
    }
  in gs

update :: GameState -> GameState
update gameState = undefined

main :: IO ()
main = do
  let gs = a
  timerState <- startTimer

  play
    (InWindow "Meu Jogo" (800, 800) (0, 0)) -- Configuração da janela
    white                                      -- Cor de fundo da janela
    5                                         -- Frames por segundo
    gs                             -- Imagem a ser exibida (mensagem de vitória)
    (\state -> case playingState state of
       Lost -> checkResult False ""
       Won -> checkResult True ""
       Playing ->  displayGameMap state
    )                 -- Função de renderização (exibe a mesma mensagem
    (\evt state -> case playingState state of
      Playing -> inputPlayer evt state
      _ -> redirectPlayer evt state
    )
    updateGame                -- Função de atualização do jogo

