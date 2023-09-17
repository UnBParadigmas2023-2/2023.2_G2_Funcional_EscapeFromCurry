{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_EscapeFromCurry (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/bin"
libdir     = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/lib/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0-5KluApCzguY5CWZuaFr1tU"
dynlibdir  = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/lib/x86_64-linux-ghc-9.4.7"
datadir    = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/share/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0"
libexecdir = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/libexec/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0"
sysconfdir = "/home/gabriel/Desktop/2023.2/PP/haskell/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/716ab45214ee2d8838050bc7e092a772cabfe35cc4887821897b36c885b65c8f/9.4.7/etc"

getBinDir     = catchIO (getEnv "EscapeFromCurry_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "EscapeFromCurry_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "EscapeFromCurry_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "EscapeFromCurry_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "EscapeFromCurry_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "EscapeFromCurry_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
