{-# LANGUAGE TupleSections #-}

module Generator (mkMaze, genMaze, showMaze) where

import Control.Applicative (liftA2)
import Control.Monad (foldM)
import Control.Monad.Random (MonadRandom, runRand)
import Data.Functor ((<&>))
import Data.List (nub)
import qualified Data.Map.Strict as M
import System.Random (StdGen)
import System.Random.Shuffle (shuffleM)
import Types (CellState (..), GameMap, Position, neighborsFor, offsets)

mkMaze :: Int -> Int -> GameMap
mkMaze w h = M.fromList . map (,Wall) $ liftA2 (,) [0 .. w - 1] [0 .. h - 1]

genMaze :: GameMap -> Position -> StdGen -> (GameMap, StdGen)
genMaze m i s =
  let gen :: (MonadRandom m) => GameMap -> Position -> m GameMap
      gen m' cur' = do
        neighbors <- shuffleM offsets
        foldM (`backtrack` cur') m' neighbors

      backtrack :: (MonadRandom m) => GameMap -> Position -> Position -> m GameMap
      backtrack m' current@(cx, cy) (dx, dy) = do
        let newCell = (cx + dx * 2, cy + dy * 2)
        if Just Wall == newCell `M.lookup` m'
          then do
            let middleCell = (cx + dx, cy + dy)
            gen (M.insert current Empty $ M.insert middleCell Empty m') newCell
          else return m'

      candidateWalls :: GameMap -> [Position]
      candidateWalls m' =
        filter isCandidate floors
        where
          floors = M.keys $ M.filter (== Empty) m'
          isCandidate f = (== 3) . length . filter (== Just Wall) $ map (`M.lookup` m') (neighborsFor f)

      removeWalls :: (MonadRandom m) => GameMap -> m GameMap
      removeWalls m' = do
        options <- shuffleM . nub . concatMap neighborsFor $ candidateWalls m'
        let chosen = M.fromList . map (,Empty) $ take (length options `div` 2) options

        return $ M.union chosen m'

      fixBorders :: GameMap -> GameMap
      fixBorders m' =
        let (mx, my) = fst $ M.findMax m'

            leftWall = (0,) <$> [0 .. my - 1]
            topWall = (,0) <$> [0 .. mx - 1]
            rightWall = (mx,) <$> [0 .. my - 1]
            bottomWall = (,my) <$> [0 .. mx - 1]

            walls = (,Wall) <$> concat [leftWall, topWall, rightWall, bottomWall]

            m'' :: GameMap
            m'' = M.fromList walls
         in m'' `M.union` m'
   in runRand ((gen m i >>= removeWalls) <&> fixBorders) s

showMaze :: Int -> Int -> GameMap -> String
showMaze w h gm = s 0 0
  where
    showCell Wall = "[]"
    showCell Empty = "  "
    showCell Goal = "##"
    s x y =
      if x == w
        then
          if y + 1 == h
            then ""
            else "\n" ++ s 0 (y + 1)
        else
          let e = M.findWithDefault Wall (x, y) gm
           in showCell e ++ s (x + 1) y
