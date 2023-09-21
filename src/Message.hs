module Message where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Types

checkResult:: Bool -> String -> Picture
checkResult True time =
  Pictures
    [ Translate (-510) 0 $ Scale 0.5 1 $ Color green $ Text "Parabens! Voce venceu o jogo!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu.",
      Translate (-350) (-200) $ Scale 0.2 0.2 $ Color white $ Text $ "Tempo: " ++ time ++ "s"
    ]
    
checkResult False time =
  Pictures
    [ Translate (-200) 0 $ Scale 0.5 0.5 $ Color red $ Text "GAME OVER!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu.",
      Translate (-350) (-200) $ Scale 0.2 0.2 $ Color white $ Text $ "Tempo: " ++ time ++ "s"
    ]

redirectPlayer :: Event -> GameState -> GameState
redirectPlayer (EventKey (Char 'p') Down _ _) gs = gs { playingState = Playing }
redirectPlayer (EventKey (Char 'm') Down _ _) gs = gs { playingState = Playing }-- Incluir função de destino
redirectPlayer _ gameState = gameState
