module Game (fps, drawGame, handleInput, updateGame, initializeGame, resetGame) where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Interact (Event)
import Graphics.Gloss.Interface.IO.Game (Event(..), KeyState(..), Key(..))
import Map
import Monster
import Player
import Types
import Generator
import qualified System.Random as R
import qualified Data.Map.Strict as M

fps :: Int
fps = 5

windowWidth :: Int
windowWidth = 800

windowHeight :: Int
windowHeight = 800

initializeGame :: R.StdGen -> GameState
initializeGame s = 
  let 
    cs = round cellSize
    mazeWidth = windowWidth `div` cs
    mazeHeight = windowHeight `div` cs
    maze = mkMaze mazeWidth mazeHeight 
    (fullMaze, s'') = genMaze maze (0, 0) s
    playerDir = DirNone
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
      , playingState = Playing
      , totalTime = 0
      , seed = s'''''
      }
   
resetGame :: GameState -> GameState
resetGame gs = initializeGame (seed gs)

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
      newEnemyPosition = nextPositionBFS newGs
      newTime = totalTime newGs + dt
      newState = if newEnemyPosition == playerPosition gs then Lost else playingState gs
   in case playingState newGs of
        Playing ->
          newGs {enemyPosition = newEnemyPosition, totalTime = newTime, playingState = newState}
        _ -> newGs


checkResult:: PlayingState -> String -> Picture
checkResult Won time =
  Pictures
    [ Translate (-510) 0 $ Scale 0.5 1 $ Color green $ Text "Parabens! Voce venceu o jogo!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu.",
      Translate (-350) (-200) $ Scale 0.2 0.2 $ Color green $ Text $ "Tempo: " ++ time ++ "s"
    ]
    
checkResult Lost time =
  Pictures
    [ Translate (-200) 0 $ Scale 0.5 0.5 $ Color red $ Text "GAME OVER!",
      Translate (-350) (-100) $ Scale 0.3 0.3 $ Color blue $ Text "Pressione 'P' para jogar novamente.",
      Translate (-350) (-150) $ Scale 0.3 0.3 $ Color yellow $ Text "Pressione 'M' para voltar ao menu.",
      Translate (-350) (-200) $ Scale 0.2 0.2 $ Color green $ Text $ "Tempo: " ++ time ++ "s"
    ]

-- this should never happen.
checkResult _ _ = undefined

redirectPlayer :: Event -> GameState -> GameState
redirectPlayer (EventKey (Char 'p') Down _ _) gs = resetGame gs
redirectPlayer (EventKey (Char 'm') Down _ _) gs = resetGame gs
redirectPlayer _ gameState = gameState
