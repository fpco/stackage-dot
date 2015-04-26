{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import           Control.Monad (forM_, when)
import           Data.Conduit (Conduit, ($$), ($=), awaitForever, yield)
import qualified Data.Conduit.Combinators as C
import           Data.Monoid
import qualified Data.Map as Map
import qualified Data.Text as T
import           Prelude hiding (mapM_)
import           Stackage.Build
import           Stackage.Build.Config
import           Stackage.Build.Types

-- | Convert a package name to a graph node name.
nodeName :: PName -> T.Text
nodeName (PName txt) = "\"" <> txt <> "\""

emitGraph :: Monad m => Conduit PInfo m T.Text
emitGraph = do
    yield "digraph deps {\n"
    yield "splines=polyline;\n"
    awaitForever $ \PInfo{..} -> do
      let deps = Map.keys pinfoDeps
      forM_ deps $ \dep -> do
        yield $ nodeName pinfoName <> " -> " <> nodeName dep <> ";\n"
      -- Ground leaf nodes.
      when (null deps) $
        yield $ "{rank=max; " <> nodeName pinfoName <> "}\n"
    yield "}\n"

main :: IO ()
main = do
    config <- readConfig
    -- Ignore errors - produce graph on a best effort basis.
    (pinfos, _errs) <- getPackageInfos DoNothing config
    C.yieldMany pinfos $= emitGraph $$ C.stdout
