module Time (startTimer, stopTimer, getElapsedSeconds) where

import Data.Time

data TimerState = Running UTCTime | Stopped Integer

startTimer :: IO TimerState
startTimer = do
    startTime <- getCurrentTime
    return $ Running startTime

stopTimer :: TimerState -> IO Integer
stopTimer (Running startTime) = do
    endTime <- getCurrentTime
    let elapsedTime = diffUTCTime endTime startTime
    return $ round $ realToFrac elapsedTime

stopTimer (Stopped elapsed) = return elapsed

getElapsedSeconds :: TimerState -> IO Integer
getElapsedSeconds (Running startTime) = do
    currentTime <- getCurrentTime
    let elapsedTime = diffUTCTime currentTime startTime
    return $ round $ realToFrac elapsedTime

getElapsedSeconds (Stopped elapsed) = return elapsed
