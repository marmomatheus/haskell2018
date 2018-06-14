{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Anuncio where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Network.HTTP.Types.Status

-- Cadastra 1 Anuncio
postAnuncioCriarR :: Handler ()
postAnuncioCriarR = do
    pers <- requireJsonBody :: Handler Anuncio
    pid <- runDB $ insert pers
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))])

-- Lista todos os Anuncioes
getAnuncioListarR :: Handler Value
getAnuncioListarR = do
    pers <- runDB $ selectList [] [Asc AnuncioTitulo]
    sendResponse (object [pack "resp" .= toJSON pers])

-- Recebe 1 Anuncio
getAnuncioGetR :: AnuncioId -> Handler Value
getAnuncioGetR pid = do
    pers <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= pers])

-- Deleta 1 Anuncio
deleteAnuncioDeleteR :: AnuncioId -> Handler Value
deleteAnuncioDeleteR pid = do
	_ <- runDB $ get404 pid
	runDB $ delete pid
	sendStatusJSON noContent204 (object [])