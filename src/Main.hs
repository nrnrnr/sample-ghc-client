module Main where

import Control.Monad.IO.Class (liftIO)

import GHC
import GHC.CoreToStg
import GHC.CoreToStg.Prep
import GHC.Paths (libdir)
import GHC.Driver.Main ( hscParse, hscTypecheckRename, hscDesugar
                       , newHscEnv, hscSimplify )
import GHC.Driver.Session ( defaultFatalMessager, defaultFlushOut, initSDocContext )
import GHC.Driver.Types ( ModGuts(..) )

import GHC.IO.Handle
import GHC.Utils.Outputable ( printSDocLn, ppr, defaultUserStyle
                            , SDocContext, initSDocContext
                            )
import GHC.Utils.Ppr (Mode(PageMode))

import System.Environment ( getArgs )
import System.IO (stdout)
import GHC.Stg.Syntax (StgTopBinding, pprGenStgTopBindings, initStgPprOpts)
import GHC.CoreToStg (coreToStg)
import GHC.Builtin.Names (dATA_TYPE_EQUALITY)
import GHC.Plugins (isDataTyCon)

import StgReifyStack


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
