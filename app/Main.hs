module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Message  -- Importe o módulo Message
import Time

main :: IO ()
main = do

  timerState <- startTimer

  endTime <- stopTimer timerState
  let gameResult = False  -- Defina o resultado do jogo (True para vitória, False para derrota)
      messagePicture = checkResult gameResult $ show endTime  -- Chame checkResult com o resultado

  play
    (InWindow "Meu Jogo" (800, 600) (10, 10)) -- Configuração da janela
    black                                      -- Cor de fundo da janela
    60                                         -- Frames por segundo
    messagePicture                             -- Imagem a ser exibida (mensagem de vitória)
    (\_ -> messagePicture)                     -- Função de renderização (exibe a mesma mensagem)
    (\_ _ -> messagePicture)                   -- Função de tratamento de eventos (exibe a mesma mensagem)
    (\_ gameState -> gameState)                -- Função de atualização do jogo
