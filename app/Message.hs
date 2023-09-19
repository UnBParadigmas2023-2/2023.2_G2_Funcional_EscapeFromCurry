module Message (mensagemParabens, mensagemIncentivo) where

import Graphics.Gloss

mensagemParabens :: Picture
mensagemParabens = Translate (-200) 0 $ Scale 0.5 0.5 $ Text "Parabéns! Você concluiu o labirinto com animações."

mensagemIncentivo :: Picture
mensagemIncentivo = Translate (-200) 0 $ Scale 0.5 0.5 $ Text "Ops! Você não conseguiu, tente novamente!"
