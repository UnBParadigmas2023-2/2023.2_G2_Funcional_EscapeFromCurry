module Game (fps, drawGame, handleInput, updateGame, verifyInitialGame, resetGame) where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Interact (Event)
import Graphics.Gloss.Interface.IO.Game (Event(..), KeyState(..), Key(..))
import Map
import Monster
import Player
import Types
import Generator
import Data.Time.Clock.POSIX
import qualified System.Random as R
import qualified Data.Map.Strict as M

fps :: Int
fps = 10

windowWidth :: Int
windowWidth = 800

windowHeight :: Int
windowHeight = 800

initializeGame :: R.StdGen -> GameMode -> GameState
initializeGame s gm =
  let
    cs = round cellSize
    mazeWidth = windowWidth `div` cs
    mazeHeight = windowHeight `div` cs
    maze = mkMaze mazeWidth mazeHeight
    playerDir = DirNone
    (fullMaze, s'') = genMaze maze (0, 0) s
    (playerPos, s''') = initialPosition fullMaze s''
    (enemyPos, s'''') = initialPosition fullMaze s'''
    (goalPos, s''''') = initialPosition fullMaze s''''
    mazeWithGoal = M.fromList [(goalPos, Goal)] `M.union` fullMaze

  in
    GameState
      { gameMap = mazeWithGoal
      , width = mazeWidth
      , height = mazeHeight
      , playerPosition = playerPos
      , playerDirection = playerDir
      , enemyPosition = enemyPos
      , goalPosition = goalPos
      , playingState = Menu
      , totalTime = 0
      , seed = s'''''
      , frameCount = 0
      , gameMode = gm
      }

verifyInitialGame :: Int -> GameMode -> GameState
verifyInitialGame s gm = do
  let initialGame = initializeGame (R.mkStdGen s) gm
  let playerPos = playerPosition initialGame
  let enemyPos = enemyPosition initialGame
  let goalPos = goalPosition initialGame
  if (nextPositionBFS enemyPos playerPos initialGame == enemyPos)
    || (nextPositionBFS playerPos goalPos initialGame == playerPos)
    then verifyInitialGame (s + 1) gm
    else initialGame

resetGame :: GameState -> GameMode -> GameState
resetGame gs gm =
  let init' = verifyInitialGame ((* frameCount gs) . round $ totalTime gs) gm
    in init' { playingState = Playing }

drawGame :: GameState -> Picture
drawGame gs = case playingState gs of
  Playing -> displayGameMap gs
  x -> checkResult x (show $ totalTime gs)

handleInput :: Event -> GameState -> GameState
handleInput evt gs = case playingState gs of
  Playing -> inputPlayer evt gs
  _ -> redirectPlayer evt gs

updateGame :: Float -> GameState -> GameState
updateGame dt gs =
  let newGs = updatePlayer gs
      newTime = totalTime newGs + dt
      newFrameCount = frameCount newGs + 1
      playerPos = playerPosition newGs
      enemyPos = enemyPosition newGs
      newEnemyPosition = if even newFrameCount then nextPositionBFS enemyPos playerPos newGs else enemyPosition newGs
      newState = if newEnemyPosition == playerPosition newGs then Lost else playingState newGs
   in case playingState newGs of
        Playing ->
          newGs 
          { enemyPosition = newEnemyPosition
          , totalTime = newTime
          , playingState = newState
          , frameCount = newFrameCount
          }
        _ -> newGs

thickText :: Float -> Color -> String -> Picture
thickText thickness textColor text =
  Pictures
    [ Translate (-thickness) 0 $ Color textColor $ Text text
    , Translate thickness 0 $ Color textColor $ Text text
    , Translate 0 (-thickness) $ Color textColor $ Text text
    , Translate 0 thickness $ Color textColor $ Text text
    , Color textColor $ Text text
    ]

checkResult:: PlayingState -> String -> Picture
checkResult Won time =
  Pictures
    [ Translate (-425) 100 $ Scale 0.43 0.43 $ thickText 2.3 black "Parabens! Voce venceu o jogo!",
      Translate (-400) 0 $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'P' para jogar novamente.",
      Translate (-400) (-60) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'H' para jogar no modo DIFICIL.",
      Translate (-400) (-120) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'Esc' para sair.",
      Translate (-400) (-180) $ Scale 0.2 0.2 $ thickText 2.3 black $ "Tempo: " ++ time ++ "s"
    ]

checkResult Lost time =
  Pictures
    [ Translate (-200) 100 $ Scale 0.43 0.43 $ thickText 2.3 black "FIM DE JOGO!",
      Translate (-400) 0 $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'P' para jogar novamente.",
      Translate (-400) (-60) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'H' para jogar no modo DIFICIL.",
      Translate (-400) (-120) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'Esc' para sair.",
      Translate (-400) (-180) $ Scale 0.2 0.2 $ thickText 2.3 black $ "Tempo: " ++ time ++ "s"
    ]

checkResult Menu _ =
  Pictures
    [ Translate (-315) 50 $ Scale 0.43 0.43 $ thickText 2.3 black "ESCAPE FROM CURRY!",
      Translate (-400) (-100) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'P' para iniciar o jogo.",
      Translate (-400) (-150) $ Scale 0.3 0.3 $ thickText 2.3 black "Pressione 'H' para jogar no modo DIFICIL."
    ]

checkResult _ _ = undefined

redirectPlayer :: Event -> GameState -> GameState
redirectPlayer (EventKey (Char 'p') Down _ _) gs = resetGame gs Easy
redirectPlayer (EventKey (Char 'P') Down _ _) gs = resetGame gs Easy
redirectPlayer (EventKey (Char 'h') Down _ _) gs = resetGame gs Hard
redirectPlayer (EventKey (Char 'H') Down _ _) gs = resetGame gs Hard
redirectPlayer _ gameState = gameState
