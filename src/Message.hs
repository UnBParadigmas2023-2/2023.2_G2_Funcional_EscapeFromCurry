module Message where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Types

checkResult:: Bool -> Picture
checkResult True =
  Pictures
    [ Translate (-200) 0 $ Scale 0.5 0.5 $ Color green $ Text "Parabéns! Você venceu o jogo!",
      Translate (-100) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-100) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu."
    ]
    
checkResult False =
  Pictures
    [ Translate (-200) 0 $ Scale 0.5 0.5 $ Color red $ Text "Poxa, o monstro te pegou! Se desafie, tente novamente!",
      Translate (-100) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-100) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu."
    ]

redirectPlayer :: Event -> GameState -> GameState
redirectPlayer (EventKey (Char 'p') Down _ _) _ = undefined
redirectPlayer (EventKey (Char 'm') Down _ _) _ = undefined
redirectPlayer _ gameState = gameState
