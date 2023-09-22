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

verifyInitialGame :: IO GameState
verifyInitialGame = do
  currentTime <- getPOSIXTime
  let initialGame = initializeGame (R.mkStdGen $ round (currentTime * 1000)) Easy
  let playerPos = playerPosition initialGame
  let enemyPos = enemyPosition initialGame
  let goalPos = goalPosition initialGame
  if (nextPositionBFS enemyPos playerPos initialGame == enemyPos)
    || (nextPositionBFS playerPos goalPos initialGame == playerPos)
    then verifyInitialGame
    else return initialGame

resetGame :: GameState -> GameMode -> GameState
resetGame gs gm =
  let init' = initializeGame (seed gs) gm
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

checkResult:: PlayingState -> String -> Picture
checkResult Won time =
  Pictures
    [ Translate (-510) 0 $ Scale 0.5 1 $ Color black $ Text "Parabens! Voce venceu o jogo!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'H' para jogar no modo DIFICIL.",
      Translate (-350) (-200) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'Esc' para sair.",
      Translate (-350) (-250) $ Scale 0.2 0.2 $ Color black $ Text $ "Tempo: " ++ time ++ "s"
    ]
    
checkResult Lost time =
  Pictures
    [ Translate (-200) 0 $ Scale 0.5 0.5 $ Color black $ Text "GAME OVER!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'H' para jogar no modo DIFICIL.",
      Translate (-350) (-200) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'Esc' para sair.",
      Translate (-350) (-250) $ Scale 0.2 0.2 $ Color black $ Text $ "Tempo: " ++ time ++ "s"
    ]

checkResult Menu _ =
  Pictures
    [ Translate (-200) 0 $ Scale 0.3 0.3 $ Color black $ Text "ESCAPE FROM CURRY!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'P' para iniciar o jogo.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color black $ Text "Pressione 'H' para jogar no modo DIFICIL."
    ]

checkResult _ _ = undefined

redirectPlayer :: Event -> GameState -> GameState
redirectPlayer (EventKey (Char 'p') Down _ _) gs = resetGame gs Easy
redirectPlayer (EventKey (Char 'h') Down _ _) gs = resetGame gs Hard
redirectPlayer _ gameState = gameState
