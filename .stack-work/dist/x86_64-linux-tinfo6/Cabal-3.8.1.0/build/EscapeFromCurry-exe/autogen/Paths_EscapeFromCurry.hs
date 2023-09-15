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
bindir     = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/bin"
libdir     = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/lib/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0-FGEXIaJbq2tCTstV5OXBfg-EscapeFromCurry-exe"
dynlibdir  = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/lib/x86_64-linux-ghc-9.4.7"
datadir    = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/share/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0"
libexecdir = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/libexec/x86_64-linux-ghc-9.4.7/EscapeFromCurry-0.1.0.0"
sysconfdir = "/home/gabriel/unb/paradigmas/2023.2_G2_Funcional/.stack-work/install/x86_64-linux-tinfo6/a639b0aee50b53b5c878a466db7199c1497ee0fd52cd5a33042c262f34e19de0/9.4.7/etc"

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
