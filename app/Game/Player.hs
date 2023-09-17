-- criar módulo para o player
module Game.Player where

-- importar dependências
import Graphics.Gloss (Point)
import Graphics.Gloss.Interface.Pure.Game
    ( Event(EventKey),
      Key(SpecialKey),
      KeyState(Down),
      SpecialKey(KeyRight, KeyUp, KeyDown, KeyLeft) )
import Game.Map ( isWallCell, isMonsterCell, isGoalCell )
import Types ( Position )
import Game.Game ( updateGame, drawGame, finishGame )

-- criar função de atualizar posição do jogador
--  recebe input e retorna GameState(?)
--  verifica qual a condição do player após tentar se mover
--  separar essa função em funções menores quando possível
updatePlayer :: Position -> Position -> GameState
updatePlayer position newPosition
    | isGoalCell newPosition = finishGame Goal
    | isMonsterCell newPosition = finishGame Monster
    | isWallCell newPosition = updateGame position
    | otherwise = updateGame newPosition

inputPlayer :: Event -> Position -> Position
inputPlayer (EventKey (SpecialKey KeyUp) Down _ _) position = updatePlayer (position nextPosition (0, -1))
inputPlayer (EventKey (SpecialKey KeyDown) Down _ _) position = updatePlayer (position nextPosition (0, 1))
inputPlayer (EventKey (SpecialKey KeyLeft) Down _ _) position = updatePlayer (position nextPosition (-1, 0))
inputPlayer (EventKey (SpecialKey KeyRight) Down _ _) position = updatePlayer (position nextPosition (1, 0))
inputPlayer _ position = updatePlayer (position position)

-- criar função que verifica se a próxima Cell é parede, monstro, saída ou vazio
--  recebe nextPosition e retorna um inteiro

nextPosition :: Position -> Position
nextPosition (x, y) = ()

-- criar função que desenha o player na tela, recebendo GameState e chamando as funções de desenho