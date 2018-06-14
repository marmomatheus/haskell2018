{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Funcs where

import Import
import Foundation
import Yesod
import Database.Persist.Postgresql
import Network.HTTP.Types.Status
import qualified Data.Maybe as M

data HttpMethod = OPTIONS | GET | POST | PUT | PATCH | DELETE deriving Show

anyOriginIn :: [HttpMethod] -> Handler ()
anyOriginIn methods = do
    addHeader (T.pack "Access-Control-Allow-Origin") (T.pack "*")
    addHeader (T.pack "Access-Control-Allow-Methods") $ T.intercalate (T.pack ", ") $ Prelude.map T.pack $ Prelude.map Prelude.show methods
    addHeader (T.pack "Access-Control-Allow-Headers") (T.pack "*")

-- getTokenHeader :: UsuarioId
getTokenHeader :: Handler Text
getTokenHeader = do
    a <- waiRequest
    listaHeader <- return $ requestHeaders a
    return $ T.pack $ unpack $ M.fromJust $ Prelude.lookup "key" listaHeader