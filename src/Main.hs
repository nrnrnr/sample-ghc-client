module Main where

import GHC
import GHC.Driver.Session ( defaultFatalMessager, defaultFlushOut )

stage0 :: String
stage0 = "/home/nr/asterius/ghc/_build/stage0"

main :: IO ()
main = do
    putStrLn $ "libdir == " ++ thelibdir
    defaultErrorHandler defaultFatalMessager defaultFlushOut $ do
      runGhc (Just thelibdir) $ do
        dflags <- getSessionDynFlags
        setSessionDynFlags dflags
  where thelibdir = stage0 ++ "/lib"
