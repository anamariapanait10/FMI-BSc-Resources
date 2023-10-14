{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_lab10 (
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
bindir     = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\bin"
libdir     = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\lib\\x86_64-windows-ghc-9.2.7\\lab10-0.1.0.0-XzfoEKPaDC4h3k0DDBQus"
dynlibdir  = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\lib\\x86_64-windows-ghc-9.2.7"
datadir    = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\share\\x86_64-windows-ghc-9.2.7\\lab10-0.1.0.0"
libexecdir = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\libexec\\x86_64-windows-ghc-9.2.7\\lab10-0.1.0.0"
sysconfdir = "C:\\Users\\Ana\\Desktop\\FMI\\Year II\\sem 2\\Fundamentele limbajelor de programare\\laborator\\lab10\\lab10\\.stack-work\\install\\7fe89bdf\\etc"

getBinDir     = catchIO (getEnv "lab10_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "lab10_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "lab10_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "lab10_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lab10_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "lab10_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '\\'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/' || c == '\\'
